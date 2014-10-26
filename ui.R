library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Storm data analysis"),
    sidebarPanel(
		h5('Data shown from 2000 to 2011'),
		sliderInput("Years",
		            h5("Adjust"),
		            min = 1950,
		            max = 2011,
		            value = 2000),
		selectInput("DamageType",label  =h5('Damage type'),
		            choices = list("Fatalities"  = 6 ,"Injuries" = 7, 
		                           "Property damage" = 8, "Crop damage" = 9))
   ),
   mainPanel(
     div(class="well",style="background-color: AliceBlue","Storms data collected from NOAA Storm database, from link on 
          coursera/Reproducible Research course. This  is analyzed to identify 
         top ten event types that had  caused maximum damage. Select the damage type to view corresponding plot.
         Adjust the time frame also if you like"),
      plotOutput("dmgPlot")
    )
))
