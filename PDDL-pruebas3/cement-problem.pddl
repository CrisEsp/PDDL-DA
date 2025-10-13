
(define (problem cement-production-problem)
(:domain cement-alimentacion)

(:objects
    ;; Molinos
    mc1 mc2 mc3 - molino

    ;; Tolvas
    t1-clinker t1-puzolana-h t1-yeso
    t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
    t3-clinker t3-puzolana-s t3-yeso - tolva

    ;; Materias
    clinker puzolana-h puzolana-s yeso - materia

    ;; Rutas
    ;  MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
    PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 MC3-desde-Silo3 - ruta
)

(:init
    ;; Molinos en marcha
    (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)

    ;; Tolvas libres
    (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
    (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
    (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

    ;; Compatibilidades
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

    ;; Material disponible
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)

    ;; Recursos positivos iniciales
    (clinker-libre)

    (puzolana-s-libre)
    (puzolana-h-libre)
    (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1)
    (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2)
    (molino-puzolana-s-libre mc3) 
    (ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2)
    ; (ruta-yeso-libre mc2 MC2-por-MC2)
    (ruta-ck-libre mc3 MC3-desde-Silo3)
    (ruta-yeso-libre mc1 MC1-por-MC2)

    ; (yeso-libre mc2)
    ; (tarea-yeso-t1-pendiente)
    (molino-libre-clinker mc1)
    (molino-libre-clinker mc2)
    (molino-libre-clinker mc3)
    (molino-libre-pz-seca mc3)
    (molino-libre-pz-humeda mc1)
    (molino-libre-pz-humeda mc2)
    ; Yeso MC3
    (yeso-libre mc3)
    (molino-libre-yeso mc3)
    (ruta-yeso-libre mc3 MC3-por-MC2)
    (ruta-yeso-libre mc3 MC3-por-MC1)

    ;Yeso MC1
    (molino-libre-yeso mc1)
    ; (ruta-es-mc1-por-mc1 MC1-por-MC1)
    (ruta-yeso-libre mc1 MC1-por-MC1)
    (yeso-libre mc1)
    ; (ruta-es-mc1-por-mc2 MC1-por-MC2)

    ;Yeso MC2
    (molino-libre-yeso mc2)
    ; (ruta-es-mc1-por-mc1 MC1-por-MC1)
    (ruta-yeso-libre mc2 MC2-por-MC2)
    (yeso-libre mc2)
    ; (ruta-es-mc1-por-mc2 MC1-por-MC2)
    (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2)

    ;; Duraciones
    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 2)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 3)
    (= (duracion-llenado t3-clinker MC3-desde-Silo3) 4)
    (= (duracion-llenado t3-clinker Silo3-desde-Pretrit) 5)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 3)       
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

    ;; Inicializar tiempo y costo
    (= (tiempo-acumulado) 0)
    (= (costo-total) 0)
    (en-marcha mc1)
    (en-marcha mc2)
    (en-marcha mc3)
    ;; Clinker
    (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
    (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
    (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
    (ruta-disponible mc3 t3-clinker clinker Silo3-desde-Pretrit)
    ;; Puzolana
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)
    ; ;; Yeso
    ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    ; (ruta-disponible mc3 t3-yeso yeso MC3-por-MC1)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1-clinker) 4.84)
    (= (tiempo-vaciado t2-clinker) 9.71)
    (= (tiempo-vaciado t3-clinker) 10.31)
    (= (tiempo-vaciado t1-puzolana-h) 0.77)
    (= (tiempo-vaciado t2-puzolana-h) 8.45)
    (= (tiempo-vaciado t2-puzolana-s) 61.30)
    (= (tiempo-vaciado t3-puzolana-s) 30.93)
    (= (tiempo-vaciado t1-yeso) 3.29)
    (= (tiempo-vaciado t2-yeso) 0.60)
    (= (tiempo-vaciado t3-yeso) 3.01)
  )

  (:goal (and
    (alimentado t1-yeso yeso)
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t2-yeso yeso)
    (alimentado t3-yeso yeso)

    ; (alimentado t1-clinker clinker)
    ; (alimentado t2-clinker clinker)
    ; (alimentado t3-clinker clinker)

    ; (alimentado t3-puzolana-s puzolana-s)
    ; (alimentado t2-puzolana-s puzolana-s)

  ))
  (:metric minimize (costo-total))
)
