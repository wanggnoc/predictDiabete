library(shiny)

shinyUI(pageWithSidebar(
    headerPanel('糖尿病检测'),
    sidebarPanel(
        p('输入各项数据进行预测。'),
        sliderInput('num_preg',label = h3('怀孕次数'),
                    min = 0, max = 10, value = 1, step=1),
        sliderInput('glucose_conc', label = h3('血糖浓度'),
                    min = 50, max = 200, value = 85, step=2),
        sliderInput('diastolic_bp', label = h3('舒张压mm Hg'),
                    min = 50, max = 120, value = 66, step=2),
        sliderInput('thickness', label = h3('三头肌厚度 mm'),
                    min = 5, max = 80, value = 29, step=1),
        sliderInput('insulin', label = h3('血清胰岛素 mu U/ml'),
                    min = 50, max = 900, value = 100, step=200),
        sliderInput('bmi', label = h3('BMI'),
                    min = 10, max = 50, value = 27, step=0.5), 
        sliderInput('diab_pred', label = h3('糖尿病家系'),
                    min = 0, max = 3, value = 0.3, step=0.01),
        sliderInput('age', label = h3('年龄'),
                    min = 15, max = 90, value = 31, step=1)     
    ),
    mainPanel(
        tabsetPanel(type = "tabs",
            tabPanel('结果',
                h2('预测糖尿病可能性'),
                textOutput('prediction')
            ),
            tabPanel('特征',
                  h2('特征重要度'),
                      plotOutput('main_plot')
            )

        )

    )
))
