
(define (problem problema-vaciado-con-tiempos)
  (:domain vaciado-con-tiempos)

  (:objects
    c1 c2 c3 c4 - contenedor
  )

  (:init
    (lleno c1)
    (lleno c2)
    (lleno c3)
    (lleno c4)

    (libre) ; recurso inicialmente disponible

    (= (tiempo-vaciado c1) 1)
    (= (tiempo-vaciado c2) 8)
    (= (tiempo-vaciado c3) 15)
    (= (tiempo-vaciado c4) 2)
    
    (= (tiempo-acumulado) 0)
    (= (costo-total) 0)
  )

  (:goal (and
          (vacio c1)
          (vacio c2)
          (vacio c3)
          (vacio c4)
         ))

  (:metric minimize (costo-total))
)
