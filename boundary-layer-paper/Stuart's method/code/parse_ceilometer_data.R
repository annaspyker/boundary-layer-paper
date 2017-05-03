#' Function to parse data files from a Vaisala CL31 ceilometer. 
#' 
#' \code{parse_ceilometer_data} reads Vaisala CL31 ceilometer's data files
#' and formats them into a data frame. The backscatter hexadecimal string is 
#' decoded into integers with correct handling of the Two's Complement rule. The 
#' time-resolution and profile-count variables are also transformed to height. 
#' The output is a data frame with three variables: date, height, and 
#' backscatter.
#' 
#' \code{parse_ceilometer_data} supports parallel processing with the 
#' \code{core} argument which speeds up the hexadecimal string decoding. 
#' 
#' @import dplyr
#'
#' @author Stuart K. Grange
#' 
#' @param file A Vaisala CL31 ceilometer data file to be parsed. \code{file} 
#' can also be a file-name vector with many files to be processed. 
#' @param cores Number of cores to use for the hexadecimal string decoding.
#' Values other than 1 are not supported for Windows systems. 
#' 
#' @examples
#' \dontrun{
#' # Parse a data file
#' data.ceil <- parse_ceilometer_data("A2080200.DAT")
#' 
#' # Parse a data file with multiple cores, this will be faster
#' data.ceil <- parse_ceilometer_data("A2080200.DAT", cores = 4)
#' 
#' }
#' 
#' @export
#'
parse_ceilometer_data <- function (file, cores = 1, interval = "15 sec", 
                                   progress = "text") {
  
  # Check OS
  if (cores > 1 & .Platform$OS.type == "windows") {
    message("Windows systems do not support parallel processing, only one core will be used.")
    cores <- 1
  }
  
  # Vectorise the function
  df <- plyr::ldply(file, parse_data, cores, interval, .progress = progress)
  
  # Return
  df
  
}


#' The main parsing function
#' 
parse_data <- function (file, cores, interval = NA) {
  
  # Load data 
  df <- read.table(file, sep = "\t", stringsAsFactors = FALSE, header = FALSE, 
                   skip = 1, col.names = "value")
  
  # Add character lengths
  df <- df %>%
    mutate(characters = nchar(value))
  
  # Process message string
  # Get message strings
  df.message <- df %>% 
    filter(characters == 47)
  
  # Split by spaces into matrix
  message.matrix <- stringr::str_split_fixed(
    df.message$value, pattern = " ", n = 10)
  
  # Get the pieces
  time.resolution <- as.numeric(message.matrix[1, 2])
  profile.count <- as.numeric(message.matrix[1, 3])
  
  # Get and parse dates
  dates <- df %>%
    filter(characters == 20) %>% 
    mutate(date = ymd_hms(value)) %>%
    select(date)
  
  # Make date vector and round
  if (!is.na(interval)) {
    
    dates <- threadr::round_date_interval(dates$date, interval)
    
  } else {
    
    dates <- dates$date
    
  }
  
  # Date vector, replicate each date
  dates <- rep(dates, each = profile.count)
  
  # Process backscatter strings
  # Filter to strings
  df.backscatter <- df %>%
    filter(characters == (time.resolution * profile.count))
  
  # Make a vector of strings
  backscatter <- df.backscatter$value
  
  # Parse the vector of strings into integers
  if (cores == 1) {
    
    # Use lapply to keep core handling consistent
    backscatter <- lapply(backscatter, make_integer)
    
  } else {
    
    backscatter <- parallel::mclapply(backscatter, make_integer, 
                                      mc.cores = getOption("mc.cores", cores))
    
  }
  
  # Unlist
  backscatter <- unlist(backscatter)
  
  # Make height sequence
  heights <- seq(time.resolution, (time.resolution * profile.count), 
                 time.resolution)
  
  # Replicate sequence as a whole many times
  heights <- rep(heights, times = length(backscatter) / profile.count)
  
  # Build data frame
  df <- data.frame(date = dates, height = heights, backscatter = backscatter)
  
  # Return
  df
  
}

#'
#' Function to pick apart the hexadecimal string and decode to integers
make_integer <- function (x, n = 5) {
  
  # Split string into a vector of n characters
  x <- substring(x, seq(1, nchar(x), n), seq(n, nchar(x), n))
  
  # Convert hex (base 16) to integer
  x <- strtoi(x, 16)
  
  # Catch the overflows due to the Two's complement rule
  x <- threadr::twos_complement(x)
  
  # Return
  x
  
}
