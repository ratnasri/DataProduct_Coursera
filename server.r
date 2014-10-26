storm_data <- read.csv("storm_data.csv",stringsAsFactors=FALSE)
library(ggplot2)
shinyServer(function(input,output) {
      output$dmgPlot <- renderPlot({
          damage_type <-as.numeric(input$DamageType)
          plot_data <- storm_data[storm_data$BGN_YEAR>= input$Years,c(2,damage_type)]
          colnames(plot_data)[2] <- "Damage"
          plot_data <- aggregate(Damage ~ EVTYPE,
                            data=plot_data,sum)
          plot_data <- plot_data[with(plot_data,order(-Damage)),][1:10,]
          ggplot(plot_data,aes(x=EVTYPE,y=Damage)) +
          geom_bar(stat="identity",width=0.5,fill="blue") +
            theme(plot.title = element_text(face="bold",color="blue"),
                  axis.text.x = element_text(angle=30,hjust=1)) +
            labs(title= paste("Top ten event types causing maximum ",colnames(storm_data)[damage_type]),
                  x="Event type", y = "Damage value")
      })
    }
)
