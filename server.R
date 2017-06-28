library(shiny)
library(ggplot2)
library(glmnet)

D=read.csv('pima-data.csv')
DD=read.csv('pima-data.csv')
gp<-function(D)
{
	load("Model.RData")
	plot(boruta.train,xlab="", xaxt="n")
lz<-lapply(1:ncol(boruta.train$ImpHistory),function(i)
boruta.train$ImpHistory[is.finite(boruta.train$ImpHistory[,i]),i])
names(lz) <- colnames(boruta.train$ImpHistory)
Labels <- sort(sapply(lz,median))
axis(side = 1,las=2,labels = names(Labels),
at = 1:ncol(boruta.train$ImpHistory), cex.axis = 0.7)
	
}
pp <- renderPlot({ gp(DD)})
dat=(D[,1]-min(D[,1]))/(max(D[,1])-min(D[,1]))
stand=c(min(D[,1]),max(D[,1]))
for (i in 2:8)
{
  b2=(D[,i]-min(D[,i]))/(max(D[,i])-min(D[,i]))
  stand=append(stand,min(D[,i]))
  stand=append(stand,max(D[,i]))
   dat=cbind(dat,b2)
}
train_ratio=0.7
n_total=nrow(dat)
n_train=round(n_total*train_ratio)
n_test=n_total-n_train
list_train=sample(n_total,n_train)

y_train=D[list_train,'diabetes']
y_test=D[-list_train,'diabetes']

x_train=dat[list_train,]
x_train=as.matrix(x_train)
#x_test=dat[-list_train,]
#x_test=as.matrix(x_test)

family='binomial'
lambda=0.1
alpha=0
Model=glmnet(x_train,y_train,family = family,lambda = lambda,alpha = alpha)


shinyServer(function(input, output) {
	output$main_plot <- pp
	
  x_tes=reactive({cbind((input$num_preg-stand[1])/(stand[2]-stand[1]),(input$glucose_conc-stand[3])/(stand[4]-stand[3]),(input$diastolic_bp-stand[5])/(stand[6]-stand[5]),(input$thickness-stand[7])/(stand[8]-stand[7]),(input$insulin-stand[9])/(stand[10]-stand[9]),(input$bmi-stand[11])/(stand[12]-stand[11]),(input$diab_pred-stand[13])/(stand[14]-stand[13]),(input$age-stand[15])/(stand[16]-stand[15]))})
 y_test_prob=reactive(predict(Model,x_tes(),type='response'))
    output$prediction <- renderText({
    # y_test_predict=predict(Model,x_tes(),type='class')
	
	 paste('患有糖尿病的可能性为',y_test_prob())

        })

})
