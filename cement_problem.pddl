
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
    MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
    PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
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
    (puzolana-h-libre PH-a-MC1-por-MC1)
    (puzolana-h-libre PH-a-MC1-por-MC2)
    (puzolana-h-libre PH-a-426HO04-por-MC2)
    (puzolana-s-libre mc1)
    (puzolana-s-libre mc2) 
    (puzolana-s-libre mc3) 
    ; (ruta-yeso-libre MC1-por-MC1)
    ; (ruta-yeso-libre MC1-por-MC2)
    (ruta-yeso-libre mc2 MC2-por-MC2)
    ; (ruta-yeso-libre MC3-por-MC1)
    (ruta-yeso-libre mc3 MC3-por-MC2)
    (yeso-libre mc1)
    (yeso-libre mc2)
    (yeso-libre mc3)
    (molino-libre-clinker mc1)
    (molino-libre-clinker mc2)
    (molino-libre-clinker mc3)

    ;; Duraciones
    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 2)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 3)
    (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
    (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 5)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 3)       
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

    ;; Inicializar tiempo y costo
    (= (tiempo-acumulado) 0)
    (= (costo-total) 0)


    (en-marcha mc1)
    (en-marcha mc2)
    ;; Clinker
    (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
    (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
    ;; Puzolana
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)
    ;; Yeso
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1-clinker) -1.72)
    (= (tiempo-vaciado t2-clinker) -0.13)
    (= (tiempo-vaciado t3-clinker) -0.96)
    (= (tiempo-vaciado t1-puzolana-h) -1.37)
    (= (tiempo-vaciado t2-puzolana-h) -4.04)
    (= (tiempo-vaciado t2-puzolana-s) 1.97)
    (= (tiempo-vaciado t3-puzolana-s) -1.10)
    (= (tiempo-vaciado t1-yeso) -31.25)
    (= (tiempo-vaciado t2-yeso) 26.06)
    (= (tiempo-vaciado t3-yeso) -12.81)
  )

  (:goal (and
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t1-clinker clinker)
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t2-clinker clinker)
    (alimentado t2-puzolana-s puzolana-s)
  ))
  (:metric minimize (costo-total))
)