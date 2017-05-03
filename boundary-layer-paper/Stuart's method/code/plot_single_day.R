

plot_single_day <- function(date) {

    # Set global options
    options(stringsAsFactors = FALSE)
    
    # Set working directory
    # This will need to be changed
    setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/data/")
    datetime = paste0(date, " 12:00")
    
    # Load some data
    # Get file list
    # The path will probably need to be changed
    wdpattern = paste0("AK", substr(date, 3, 4), substr(date, 6,7), "/")
    file.list <- list.files(path = wdpattern, ".DAT$", full.names = TRUE)
    
    # Filter to single day
    pattern = paste0("A", substr(date, 4, 4), substr(date, 6, 7), substr(date, 9, 10), substr(datetime, 12, 13))
    file.list <- file.list[grep(pattern, file.list)]
    
    # Load backscatter data
    data.backscatter <- parse_ceilometer_data(file.list)
    # Function can also be used like: parse_ceilometer_data("data/A3010512.DAT")
    
    # Look at the data
    # head(data.backscatter)
    
    # Change wd
    setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/code/Stuart's method/code/")
    
    # Remove artifact
    # Load look-up table
    data.artifact <- read.csv("ceilometer_artifact_signal.csv") %>% 
      mutate(backscatter = ifelse(is.na(backscatter), 0, backscatter)) %>% 
      rename(backscatter.artifact = backscatter)
    
    # Subtract artifact from signal
    data.backscatter <- data.backscatter %>% 
      left_join(data.artifact, by = "height") %>% 
      mutate(backscatter = backscatter - backscatter.artifact, 
             backscatter = as.integer(backscatter)) %>% 
      select(-backscatter.artifact)
    
    # Apply a rolling filter, every profile a 125 m rolling mean
    data.backscatter <- data.backscatter %>% 
      group_by(date) %>% 
      mutate(backscatter = rollmean(backscatter, 125 / 5, fill = NA),  
             backscatter = as.integer(backscatter)) %>% 
      ungroup()
    
    # Aggregate data by 10 minutes and do some conditional massaging
    data.ten.min <- data.backscatter %>% 
      mutate(date = round_date_interval(date, "10 min")) %>% 
      group_by(date, height) %>% 
      summarise(backscatter = mean(backscatter)) %>% 
      ungroup() %>% 
      mutate(backscatter.massaged = ifelse(backscatter >= 200, 200, backscatter), 
             backscatter.massaged = ifelse(
               backscatter.massaged <= 0, 0, backscatter.massaged))
    
    # Look at the aggregate data
    # head(data.ten.min)
    
    
    # Plot all loaded data as a surface
    # data.ten.min %>% 
      # matlab_like_surface_plot("backscatter.massaged")
    
    # Mixing height by gradients
    # Add gradient variable
    data.ten.min <- data.ten.min %>% 
      group_by(date) %>% 
      mutate(gradient = c(NA, diff(backscatter))) %>% 
      ungroup()
    
    # Filter midday
    data.filter <- data.ten.min %>% 
      filter(date == ymd_hm(datetime)) 
    
    # Estimate mixing heights with a gradient method
    data.filter.summary <- data.filter %>% 
      estimate_mixing_height()
    
    # Join the mixing heights with the profile data
    data.filter <- join(data.filter, data.filter.summary, by = "date")
    
    lab = paste0('Height (m) = ', data.filter.summary$mixing.height)
    
    # Plot backscatter with mixing height estimations
    data.filter %>% 
      ggplot(aes(height, backscatter, colour = as.factor(date)),xlim=c(0, 4000)) +
      geom_point() + coord_flip() + facet_wrap("date") + theme_bw (base_size = 20, base_family = "Arial") + 
      geom_vline(aes(xintercept = mixing.height), linetype = "dashed") +
      theme(legend.position = "none") + xlab('height (m)')+
      scale_y_continuous(limits = c(-1000, 10000)) +
      annotate("text", label = lab, x = 3200, y = 5000)
    
    setwd("/Users/lenaweissert/Dropbox/Boundary Layer Analysis/Anna Spyker/data/Stuart/1502/plots/daily/")
    graph.name = paste0(date, ".png")
    ggsave(filename=graph.name, width=8, height = 6)
    
    
    # dev.off()
    
    return(data.filter.summary$mixing.height)
}