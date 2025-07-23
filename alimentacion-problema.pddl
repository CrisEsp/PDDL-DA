; (define (problem alimentacion-problema)
;   (:domain cement-alimentacion)

;   (:objects
;     mc1 mc2 - molino
;     l1 - tolva
;     clinker - materia
;     puzolana - materia
;   )

;   (:init
;     (libre l1)
;     (ruta-disponible mc1 l1)
;     (ruta-disponible mc2 l1)
;     (material-disponible clinker)
;     (material-disponible puzolana)
;     (en-marcha mc1)
;     (en-marcha mc2)
;   )

;   (:goal
;     (and
;       (alimentado l1 clinker)
;       (alimentado l1 puzolana)
;     )
;   )
; )

(define (problem alimentacion-problema)
  (:domain cement-alimentacion)

  (:objects
    mc1 mc2 mc3 - molino
    l1 l2 l3 - tolva
    
    clinker puzolana-h yeso puzolana-s - materia
  )

  (:init
    (libre l1)
    (libre l2)
    (libre l3)
    (ruta-disponible mc1 l1)
    (ruta-disponible mc2 l1)
    (ruta-disponible mc3 l2)
    (ruta-disponible mc3 l3)
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)
    (en-marcha mc1)
    (en-marcha mc2)
    (en-marcha mc3)
  )

  (:goal
    (and
      (alimentado l1 clinker)
      (alimentado l1 puzolana-h)
      (alimentado l2 yeso)
      (alimentado l3 puzolana-s)
    )
  )
)

