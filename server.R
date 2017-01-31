library(shiny)
require(plotly)


#Build the prediction model

require(rpart);require(glm2);require(ggplot2);require(plotly)

model_price<-glm(Price~
                   factor(Country)+factor(Type)+HP+Weight,
                 data=car.test.frame,
                 family=poisson(link="log"))
model_reli<-rpart(Reliability~
                    HP+Mileage+Type+Weight+Country,
                  data=subset(car.test.frame,!is.na(Reliability)))

shinyServer(function(input, output) {
  
  predictors<-reactive({
    data.frame(Country=input$Country,
               Type=input$Type,
               HP=input$HP,
               Weight=input$Weight,
               Mileage=input$Mileage)
  })
  
  prediction<-reactive({
    list(
      price_value=exp(
        predict(model_price,predictors())),
      reliability_value=
        predict(
          model_reli,
          predictors())
      )
  }) 
  
  
  output$price <- renderText({
    paste(format(prediction()$price_value,digits = 0,big.mark = ",",width = 6,scientific = F)," USD")
  })
  
  output$reliability<-renderText({
    paste(format(prediction()$reliability_value,digits = 2,big.mark = ",",width = 6,scientific = F)," out of 5")
  })
  
  output$code<-renderText({
    "model_price<-glm(Price~
    factor(Country)+factor(Type)+HP+Weight,
    data=car.test.frame,
    family=poisson(link=\"log\"))
    model_reli<-rpart(Reliability~
    HP+Mileage+Type+Weight+Country,
    data=subset(car.test.frame,!is.na(Reliability)))"
  })
  output$pricetrend<-renderPlotly({
    hps<-(50+ 5*(1:60))
    predictors<-data.frame(Country=input$Country,
                           Type=input$Type,
                           HP=hps,
                           Weight=input$Weight,
                           Mileage=input$Mileage)
    
    responses<-exp(predict(model_price,predictors))
    
    car.test.frame%>%plot_ly(x = ~HP,y = ~Price,color = ~Country,text=rownames(car.test.frame),
                 type = "scatter", mode = "markers", name = "Data",
                 marker = list(size = 10, opacity = 0.9), showlegend = T) %>%
      add_trace(x = hps,y = ~responses,
                type = "scatter", mode = "lines+markers", name = "Smooth",text="",
                marker=list(size=0.01),line=list(width=3, color="#232323",opacity=0.3),showlegend = F)  %>%
      layout(title = "Predicted Price vs Horse Power", plot_bgcolor = "#e6e6e6",
             xaxis = list(title="Horse Power"),yaxis = list(title="Predicted car price"))%>%
      add_markers(x=input$HP,y=prediction()$price_value,marker=list(size=20,color="#232323",opacity=0.5),showlegend=F,text=" w",inherit=F)
  })
  
})
