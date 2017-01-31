library(shiny)
library(rpart)
library(plotly)

shinyUI(fluidPage(
  
  titlePanel("Carify: Estimate the car price & reliability"),
  tabsetPanel(
    tabPanel("Result", 
      sidebarLayout(
        sidebarPanel(
          h2("Select parameters"),
          selectInput("Country","Country of origin",levels(car.test.frame$Country),levels(car.test.frame$Country)[1]), 
          selectInput("Type","Type of the car",levels(car.test.frame$Type),levels(car.test.frame$Type)[1]),
          numericInput("Mileage","Mileage, miles-per-gallon",value = 24),
          numericInput("Weight","Weight, kg",value = 2000)
        ),
    
        mainPanel(
                 h2("Estimate of car features"),
                 fluidRow(
                   column(3,sliderInput("HP","Horse power",min = 50,max=250,value = 100),
                          h3("estimated price="),
                          verbatimTextOutput("price"),
                          h3("estimated reliability="),
                          verbatimTextOutput("reliability")),
                   column(9,plotlyOutput("pricetrend")
                          ))
                 ))), 

    tabPanel("User Manual", 
             h2("Instructions"),
             h3("Program Goal"),
             "Assess the car price, inputting it's Mileage, Country of origin, Type, Weight and Horsepower",
             h3("Program usage: Step 1"),
             "Input [Country of origin] variable: select the Country from dropdown menu, appearing in the left SideBarpanel, 
             under 'Country of origin' label",
             h3("Program usage: Step 2"),
             "Input [Type] variable: select the Type from dropdown menu, appearing in the left SideBarpanel, 
             under 'Country of origin' label, just below the dropdown menu from Step 1.",
             h3("Program usage: Step 3"),
             "Input [Mileage] and [Weight] variables: from the two input boxes below dropdown menu from Step 2, 
              select applicable values for the parameters, using arrows buttons, increasing/decreasing 
              the value in the adjacent box",
             h3("Program usage: Step 4"),
             "Select a horsepower paramter by dragging the slider input in the center of the screen (left top of the middle panel)",
             h3("Program usage: Step 5"),
             "Behold the prediction of the car price in the grey box, appearing in the right top of the middle panel, 
             together with a reliability parameter",
             h3("Program usage: Step 6"),
             "Using the plot below, examine the dependency of the car price from the horsepower, given the other 
             parameters defined by inputs in left sidebar panel; the x axis stands for horsepower, y-Axis stands for predicted car price",
             h3("Program usage: Step 7"),
             "to evaluate the model output under other parameters combination, use steps 1-4 to enter them, 
             the results (plot+predictions) would automatically adjusted to new values entered",
             h3("Program usage: Enjoy it!")
          ),
    tabPanel("Documentation", 
             h2("General Purpose"),
             "Project 'Carify': estimating car price and prediction of its reliability",
             h3("Motivation"),
             "This is a project created to demonstrate the applicability of Shiny R package 
             for development of interactive web products utilizing statistical learning tools 
             provided by R. The output is the online predicting engine for car model\'s price and 
             reliability score.
             The system exploits the model for car price, constructed on the **car.test.frame** dataset, which is shipped in **rpart** package. We apply generalized linear models theory to build the model for assessment of car price (response), given some combination of predictors.
             The prediction of the reliability is based on supervised machine learning technique provided by **rpart** 
             function of the same named package.
             In the final product, it will take form of user input of car country of origin, weight and other factors, and the resulting trend line of dependency between horsepower and price will be drawn. In real world, similar products might help used car retailers when rare car is being priced (e.g. Pontiac cars are rare in Europe, 
             but we can estimate its value given it\'s horsepower, car type and country of origin).",
             h3("Prediction models used"),"We uses the following prediction model:",
             verbatimTextOutput("code")
             )
        
  )
))

