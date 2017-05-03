#' Function to estimate mixing-height from ceilometer data with a gradient 
#' method. 
#' 
#' \code{estimate_mixing_height} calculates the difference between backscatter
#' values for a profile. The magnitude of the differences are then tested to 
#' determine if they are +- three standard deviations from the profile's mean. 
#' The first backscatter value which is greater than three standard deviations 
#' away from the mean is considered the mixing height. 
#' 
#' \code{estimate_mixing_height} is not a very good function. I need to
#' understand and then apply the so-called ideal-profile method to each profile. 
#' Any help will be very much appreciated! 
#' 
#' @author Stuart K. Grange
#'  
#' @export
#' 
estimate_mixing_height <- function (df) {
  
  # dfPos <- df[df$gradient >= 0, ] 

  # Test if gradient is outside three sd from the mean
  df <- df %>% 
    mutate(gradient.large = ifelse(
      gradient >= mean(gradient, na.rm = TRUE) + sd(gradient, na.rm = TRUE) * 2.5 |
        gradient <= mean(gradient, na.rm = TRUE) - sd(gradient, na.rm = TRUE) * 2.5, 
      TRUE, FALSE), 
      gradient.large = ifelse(height <= 50 | height >= 2900, FALSE, gradient.large))
  
  # Summarise, get the first value which passes the test
  df.summary <- df %>% 
    group_by(date) %>% 
    arrange(desc(gradient.large)) %>% 
    slice(1) %>% 
    ungroup() %>% 
    mutate(height = ifelse(gradient.large, height, NA)) %>% 
    select(date, height) %>% 
    rename(mixing.height = height)
  
  # Standard data frame catch
  df.summary <- data.frame(df.summary)
  
  # Return
  df.summary
  
}