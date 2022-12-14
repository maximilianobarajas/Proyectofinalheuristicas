schwef <- function(xx)
{
  d <- length(xx)
  sum <- sum(xx*sin(sqrt(abs(xx))))
  y <- 418.9829*d - sum
  return(y)
}

#Funcion para soluciones vecinas
solucion_vecina<-function(Sol_actual,desv){
   Q=Sol_actual
   for (y in 1:length(Q)){
      Q[y]=rnorm(1,mean=Q[y],sd=desv)
   }
   return(Q)
}
#Funcion para solucion aleatoria inicial
solucion_aleatoria<-function(d){
   return(runif(n=d, min=400, max=500))
}

#Funcion de recocido
recocido<-function(temp_inicial,temp_final,enfriamiento,iteraciones,dimension){
    mejor_imagen=Inf
    solucion_actual=solucion_aleatoria(dimension)
    Temp=temp_inicial
    mejor_sol=solucion_actual
    while(Temp>temp_final){
        for(i in 1:iteraciones){
            sol=solucion_vecina(solucion_actual,0.1)
            if(schwef(sol)<mejor_imagen){
                solucion_actual=sol
                mejor_sol=sol
                mejor_imagen=schwef(sol)

            }
            else{
                #Criterio de metropolis
                delta=schwef(sol)-schwef(solucion_actual)
                r=runif(1)
                if(r<exp(-delta/Temp)){
                    solucion_actual=sol
            
                }
            }
        }
        Temp=enfriamiento*Temp
    }
    return(c(mejor_imagen,mejor_sol))
}

inicio<-Sys.time()
columns = c("y","x1","x2","x3","x4","x5","x6","x7","x8","x9","x10","tiempo en segundos") 
df = data.frame(matrix(nrow = 0, ncol = length(columns))) 
colnames(df) = columns
for(i in 1:30){
start.time <- Sys.time()
h<-recocido(100000,0.1,.95,1000,10)
end.time <- Sys.time()
tiempo<-end.time-start.time
df[nrow(df) + 1,] <- c(h,tiempo)
  }
fin<-Sys.time()
print(df)
boxplot(df$y)
print("El mejor mínimo encontrado es:")
print(min(df$y))
print("El peor mínimo encontrado es:")
print(max(df$y))
print("El minimo promedio es:")
print(mean(df$y))
print("La desviación estándar de los mínimos es:")
print(sd(df$y))
print("La diferencia entre el promedio y el óptimo real:")
print(mean(df$y))
print(fin-inicio)
