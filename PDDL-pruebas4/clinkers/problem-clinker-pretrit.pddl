(define (problem cement-clinker-pretrit)
  (:domain cement-clinker-pretrit)
  
  (:objects
    t1-clinker t2-clinker t3-clinker-SB - tolva
  )
  
  (:init
    (libre t1-clinker)
    (libre t2-clinker)
    (libre t3-clinker-SB)
    
    (tolva-asignada t1-clinker mc1)
    (tolva-asignada t2-clinker mc2)
    
    (ruta-clinker-libre)
    
    (molino-libre-clinker mc1)
    (molino-libre-clinker mc2)
    
    (compatible clinker t1-clinker)
    (compatible clinker t2-clinker)
    (compatible clinker t3-clinker-SB)

    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
    (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)

    (= (tiempo-vaciado t1-clinker) 0.2)
    (= (tiempo-vaciado t2-clinker) 0.0)
    (= (tiempo-vaciado t3-clinker-SB) 0.1)

    (= (tiempo-acumulado-ck) 0)
    (= (costo-tiempo-compartido-ck) 0)
  )
      
  (:goal (and
    (alimentado t1-clinker clinker)
    (alimentado t2-clinker clinker)
    (alimentado t3-clinker-SB clinker)
  ))
  
  (:metric minimize (+ 
    (* 25 (costo-tiempo-compartido-ck))
    (* 2 (total-time))
  ))
)