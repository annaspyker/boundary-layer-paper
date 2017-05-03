#' Function to plot ceilometer data as a surface in a MATLAB-like way.
#' 
#' \code{matlab_like_surface_plot} uses ggplot2 to plot the surface. 
#' 
#' @param df Data frame containing ceilometer data with date and height 
#' variables. 
#' @param var Quoted variable name to be plotted as a surface.
#' 
#' @author Stuart K. Grange
#' 
#' @examples 
#' \dontrun{
#' # Plot a day's worth of data
#' matlab_like_surface_plot(data.ten.min, "backscatter.massaged")
#' }
#' 
#' @import ggplot2
#' 
#' @export
#' 
matlab_like_surface_plot <- function (df, var = "backscatter.massaged") {
  
  # Plot
  ggplot(df, aes_string("date", "height", fill = var)) + geom_raster() + 
    scale_fill_gradientn(colours = jet_colors(7), 
                         guide = guide_legend(title = "Backscatter\n(units)")) + 
    ylab("Height (m)") + xlab("Date")
  
}

# Define MATLAB jet colours
jet_colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", 
                                 "#7FFF7F", "yellow", "#FF7F00", "red", 
                                 "#7F0000"))