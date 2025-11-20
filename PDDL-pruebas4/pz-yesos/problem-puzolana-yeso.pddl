(define (problem cement-puzolana-yeso)
  (:domain cement-puzolana-yeso)
  
  (:objects
    t1-puzolana-h t1-yeso 
    t2-puzolana-h t2-yeso t2-puzolana-s
    t3-puzolana-s t3-yeso - tolva
  )
  
  (:init
    ;; Todas las tolvas libres
    (libre t1-puzolana-h)
    (libre t1-yeso)
    (libre t2-puzolana-h)
    (libre t2-yeso)
    (libre t2-puzolana-s)
    (libre t3-puzolana-s)
    (libre t3-yeso)
    
    ;; Asignaciones a molinos
    (tolva-asignada t1-puzolana-h mc1)
    (tolva-asignada t1-yeso mc1)
    (tolva-asignada t2-puzolana-h mc2)
    (tolva-asignada t2-yeso mc2)
    (tolva-asignada t2-puzolana-s mc2)
    (tolva-asignada t3-puzolana-s mc3)
    (tolva-asignada t3-yeso mc3)
    
    ;; Rutas compartidas libres
    (ruta-la-cinta-mc2-libre)
    (ruta-mc3-compartida-libre)
    (ruta-la-mc1-ph-y-yeso-libre)

    ;; Molinos libres
    (molino-libre-pz-humeda mc1)
    (molino-libre-pz-humeda mc2)
    (molino-libre-yeso mc1)
    (molino-libre-yeso mc2)
    (molino-libre-yeso mc3)
    (molino-libre-pz-seca mc2)
    (molino-libre-pz-seca mc3)
    
    ;; Compatibilidades
    (compatible puzolana-h t1-puzolana-h)
    (compatible yeso t1-yeso)
    (compatible puzolana-h t2-puzolana-h)
    (compatible yeso t2-yeso)
    (compatible puzolana-s t2-puzolana-s)
    (compatible puzolana-s t3-puzolana-s)
    (compatible yeso t3-yeso)
    
    ;; Rutas disponibles (LAS 5 LNEAS QUE FALTABAN)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)
    (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)

    ;; Duraciones de llenado
  
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
    ; (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
    ; (= (duracion-llenado t1-yeso MC1-por-MC1) 3)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 1)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 9)

    ; (= (tiempo-vaciado t2-puzolana-h) 1.9)
    ; (= (tiempo-vaciado t2-puzolana-s) 0.8)
    ; (= (tiempo-vaciado t3-yeso) 0.0)
    ; (= (tiempo-vaciado t2-yeso) 1.8)
    ; (= (tiempo-vaciado t1-puzolana-h) 0.9)
    ; (= (tiempo-vaciado t1-yeso) 0.8)
    ; (= (tiempo-vaciado t1-clinker) 0.3)
    ; (= (tiempo-vaciado t2-clinker) 2)
    ; (= (tiempo-vaciado t3-clinker) 4.0)
    ; (= (tiempo-vaciado t3-clinker-SB) 1.7)
    ; (= (tiempo-vaciado t3-puzolana-s) 0.1)


    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1-puzolana-h) 0.5)
    (= (tiempo-vaciado t1-yeso) 0.4)
    (= (tiempo-vaciado t2-puzolana-h) 1.7)
    (= (tiempo-vaciado t2-yeso) 1.8)
    (= (tiempo-vaciado t2-puzolana-s) 1.8)
    (= (tiempo-vaciado t3-puzolana-s) 0.1)
    (= (tiempo-vaciado t3-yeso) 0.2)

    ;; Acumuladores
    (= (tiempo-acumulado-cinta-mc2) 0)
    (= (tiempo-acumulado-ruta-mc3) 0)
    (= (tiempo-acumulado-mc1) 0)
    (= (costo-tiempo-compartido-cinta-mc2) 0)
    (= (costo-tiempo-compartido-cinta-mc1) 0)
    (= (tiempo-acumulado-cinta-mc1) 0)
    (= (costo-tiempo-compartido-ruta-mc3) 0)
    (= (costo-tiempo-compartido-mc1) 0) 
  )
      
  (:goal (and
    ;; Puedes descomentar las que quieras probar:
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t2-yeso yeso)
    
    ; ;; MC3 (las que tienes en tu goal actual)
    (alimentado t3-puzolana-s puzolana-s)
    (alimentado t3-yeso yeso)
  ))
  
  (:metric minimize (+ 
    (* 10000 (+ 
      (costo-tiempo-compartido-mc1)
      (costo-tiempo-compartido-cinta-mc2)
      (costo-tiempo-compartido-ruta-mc3)
    ))
    (* 1 (total-time))
  ))
)

