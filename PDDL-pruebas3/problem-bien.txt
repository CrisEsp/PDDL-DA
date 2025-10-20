
(define (problem cement-production-problem)
(:domain cement-alimentacion)

(:objects
    ;; Molinos y Tolvas
    mc1 mc2 mc3 - molino
    t1-clinker t1-puzolana-h t1-yeso
    t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
    t3-clinker t3-puzolana-s t3-yeso - tolva
)

(:init
    ;; Estado de Molinos y Tolvas
    (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)
    (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
    (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
    (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

    ;; Recursos de Molino/Material
    (molino-libre-clinker mc1) (molino-libre-clinker mc2) (molino-libre-clinker mc3)
    (molino-libre-pz-seca mc3)
    (molino-libre-pz-humeda mc1) (molino-libre-pz-humeda mc2)
    (molino-libre-yeso mc1) (molino-libre-yeso mc2) (molino-libre-yeso mc3)
    (yeso-libre mc1) (yeso-libre mc2) (yeso-libre mc3)
    (puzolana-h-libre) (puzolana-s-libre)
    (clinker-libre)
    
    ;; Compatibilidades y Material disponible
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)
    (material-disponible clinker) (material-disponible puzolana-h)
    (material-disponible puzolana-s) (material-disponible yeso)
    
    ;; INICIALIZACION DE RECURSOS COMPARTIDOS
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    (ruta-linea-m3-libre)
    
    ;; Rutas disponibles
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)

    ;; Duraciones y Tiempos de vaciado
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 6)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)

    (= (tiempo-vaciado t1-puzolana-h) 0.05)
    (= (tiempo-vaciado t2-puzolana-h) 0.07)
    (= (tiempo-vaciado t1-yeso) 0.40)
    (= (tiempo-vaciado t2-yeso) 0.01)
    (= (tiempo-vaciado t3-yeso) 0.11)

    (= (tiempo-acumulado) 0)
    (= (costo-total) 0)
)

(:goal (and
    (alimentado t1-yeso yeso)
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t3-yeso yeso)
    (alimentado t2-yeso yeso)
))
(:metric minimize (costo-total))
)