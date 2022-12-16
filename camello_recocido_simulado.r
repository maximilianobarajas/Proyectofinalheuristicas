#Funcion objetivo
camel6 <- function(xx)
{
  x1 <- xx[1]
  x2 <- xx[2]
  term1 <- (4-2.1*x1^2+(x1^4)/3) * x1^2
  term2 <- x1*x2
  term3 <- (-4+4*x2^2) * x2^2
  y <- term1 + term2 + term3
  return(y)
}
#Funcion para soluciones vecinas
solucion_vecina<-function(Sol_actual,desv){
   Q=Sol_actual
   for (y in 1:length(Q)){
      Q[y]=rnorm(1,mean=Q[y],sd=desv)
   }
   print(Q)
   return(Q)
}
#Funcion para solucion aleatoria inicial
solucion_aleatoria<-function(){
    return(c(runif(n=1,-3,3),runif(n=1,-2,2)))
}
#Funcion de recocido
recocido<-function(temp_inicial,temp_final,enfriamiento,iteraciones){
    mejor_imagen=Inf
    solucion_actual=solucion_aleatoria()
    Temp=temp_inicial
    mejor_sol=solucion_actual
    while(Temp>temp_final){
        for(i in 1:iteraciones){
            sol=solucion_vecina(solucion_actual,0.1)
            if(camel6(sol)<mejor_imagen){
                solucion_actual=sol
                mejor_sol=sol
                mejor_imagen=camel6(sol)
            }
            else{
                #Criterio de metropolis
                delta=camel6(sol)-camel6(solucion_actual)
                r=runif(1)
                if(r<exp(-delta/Temp)){
                    solucion_actual=sol
                    mejor_sol=sol
                    mejor_imagen=camel6(sol)
                }
            }
        }
        Temp=enfriamiento*Temp
    }
    return(c(mejor_imagen,mejor_sol))
}
recocido(10000000,1,0.95,200)
