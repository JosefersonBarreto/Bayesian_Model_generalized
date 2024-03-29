#=======================================================================
# Title:  BAYESIAN GENERALIZED LINEAR MODELS
# Method: Poisson
# Case:   Statistical Analysis of Natural Events in the United States
# Date:   2021/Jan/10
# Author: Andr� Luis M.F. dos Santos
# e-mail: andre@metodosexatos.com.br
# Source: www.metodosexatos.com
#=======================================================================
# Pacotes necess�rios:

# rstanarm
# readr
#------------------------
# Diret�rios e Arquivos:

# getwd() # Qual o diret�rio que o script est� apontando
# list.files() # Quais arquivos est�o contidos no diret�rio
# setwd("C:/Users/andre/Downloads") # muda a pasta de destino
#-------------------------------------------------------------
# Leitura de dataset:

# A. op��o para ler arquivo salvo no computador
# mydata <- read.csv(file = "ecomm.csv") 

# B. op��o para ler arquivo na web (github)
library (readr)
urlfile="https://raw.githubusercontent.com/metodosexatos/mlgbayes/main/DatasetsES15/hurricanes.csv"
mydata<-read_csv2(url(urlfile)) # para csv no formato brasileiro use read_csv2#head(mydata)
#------------
# Histograma da vari�vel dependente:

k <- round(1+3.3*log10(nrow(mydata)),0) # N�mero de classes: Regra de Sturges
hist(mydata$loss, main = "Valores observados", xlab = "Loss", nclass = k, col = 5)

#--------
# Modelo:

library(rstanarm)

model_poisson <- stan_glm(loss ~ hurr, data = mydata, family = poisson())
summary(model_poisson)

coeff <- exp(model_poisson$coefficients)
coeff

#------------
# Histograma da distribui��o posterior:

k <- round(1+3.3*log10(nrow(posterior_predict(model_poisson))),0) # N�mero de classes: Regra de Sturges
hist(posterior_predict(model_poisson), main = "Posterior", xlab = "Loss", nclass = k, col = 5)

#------------
# Intervalo de credibilidade
exp(posterior_interval(model_poisson))

#------------------
# GLM Frequentista:

glm1 <- glm(loss ~ hurr, data = mydata, family = poisson())
glm1$fitted.values

round(rbind(glm = summary(glm1)$coefficients[, "Std. Error"],
            stan_glm = se(model_poisson)), digits = 3)
