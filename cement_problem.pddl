(define (problem cement-production-problem)
  (:domain cement-production)

  (:objects
    mc1 mc2 mc3 - molino
    t1-clinker t1-puzolana-h t1-yeso
    t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
    t3-clinker t3-puzolana-s t3-yeso - tolva
    clinker puzolana-humeda puzolana-seca yeso - materia-prima
    MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04
    MC1-por-MC1 MC2-por-MC2 MC1-por-MC3 MC2-por-MC3 - ruta
  )

  (:init
    ;; Estado inicial de tolvas
    (tolva-vacia t1-clinker) (tolva-vacia t1-puzolana-h) (tolva-vacia t1-yeso)
    (tolva-vacia t2-clinker) (tolva-vacia t2-puzolana-h) (tolva-vacia t2-puzolana-s) (tolva-vacia t2-yeso)
    (tolva-vacia t3-clinker) (tolva-vacia t3-puzolana-s) (tolva-vacia t3-yeso)

    ;; Conexiones molino-tolva
    (conectado mc1 t1-clinker) (conectado mc1 t1-puzolana-h) (conectado mc1 t2-puzolana-h) (conectado mc1 t1-yeso)
    (conectado mc2 t2-clinker) (conectado mc2 t2-puzolana-h) (conectado mc2 t2-puzolana-s) (conectado mc2 t2-yeso)
    (conectado mc3 t3-clinker) (conectado mc3 t3-puzolana-s) (conectado mc3 t2-puzolana-s) (conectado mc3 t3-yeso)

    ;; Compatibilidad materiales con tolvas
    (compatible clinker t1-clinker) (compatible puzolana-humeda t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-humeda t2-puzolana-h)
    (compatible puzolana-seca t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-seca t3-puzolana-s) (compatible yeso t3-yeso)

    ;; Disponibilidad de materiales
    (disponible clinker)
    (disponible puzolana-humeda)
    (disponible puzolana-seca)
    (disponible yeso)

    ;; Rutas disponibles
    ;; Clinker
    ;; Clinker
    (ruta-disponible mc1 t1-clinker MC1-desde-Pretrit)
    (ruta-disponible mc2 t2-clinker MC2-desde-Pretrit)
    (ruta-disponible mc3 t3-clinker MC3-desde_Silo-Blanco)
    (ruta-disponible mc3 t3-clinker Pretrit_a_Silo_Blanco)
    ;; Puzolana
    (ruta-disponible mc2 t2-puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc3 t3-puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc2 t2-puzolana-s PS-a-426HO02-por-426HO04)
    ;; Yeso
    (ruta-disponible mc1 t1-yeso MC1-por-MC1)
    (ruta-disponible mc2 t2-yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso MC1-por-MC3)
    (ruta-disponible mc3 t3-yeso MC2-por-MC3)
    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1-clinker) 0.6951685783802573)
    (= (tiempo-vaciado t1-puzolana-h) 1.1111111111111112)
    (= (tiempo-vaciado t2-clinker) 0.5894488653109343)
    (= (tiempo-vaciado t3-clinker) 0.028384227830735385)
    (= (tiempo-vaciado t3-puzolana-s) 0.030371398819854217)
    (= (tiempo-vaciado t3-yeso) 0.3582089552238806)
    ;; Duraciones de llenado (estimadas)
    (= (duracion-llenado t1-clinker) 0.1)
    (= (duracion-llenado t1-puzolana-h) 0.1)
    (= (duracion-llenado t2-clinker) 0.1)
    (= (duracion-llenado t3-clinker) 0.1)
    (= (duracion-llenado t3-puzolana-s) 0.1)
    (= (duracion-llenado t3-yeso) 0.1)
  )

  (:goal (and
    (tolva-llena t3-clinker)
    (tolva-llena t3-puzolana-s)
    (tolva-llena t3-yeso)
    (tolva-llena t2-clinker)
    (tolva-llena t1-clinker)
    (tolva-llena t1-puzolana-h)
  ))
  (:metric minimize (total-time))
)