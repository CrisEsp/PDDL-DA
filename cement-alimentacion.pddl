(define (domain cement-alimentacion)
  (:requirements :durative-actions :typing)
  
  (:types molino tolva materia)

  (:predicates
    (en-marcha ?m - molino)
    (libre ?t - tolva)
    (ruta-disponible ?m - molino ?t - tolva)
    (material-disponible ?mat - materia)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-ocupada ?t - tolva ?mat - materia) ; Nuevo predicado para rastrear ocupacin
  )

  ;; Accin para alimentar clinker
  (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva)
    :duration (= ?duration 5)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t))
      (at start (material-disponible clinker))
      (over all (not (tolva-ocupada ?t puzolana-h))) ; Asegura que no est ocupada por puzolana
      (over all (not (tolva-ocupada ?t yeso)))    ; Asegura que no estocupada por yeso
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker)) ; Marca la tolva como ocupada por clinker
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker))) ; Libera la tolva al finalizar
    )
  )

  ;; Accin para alimentar puzolana
  (:durative-action alimentar-puzolana-h
    :parameters (?m - molino ?t - tolva)
    :duration (= ?duration 3)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t))
      (at start (material-disponible puzolana-h))
      (over all (not (tolva-ocupada ?t yeso)))    ; Evita que yeso use la tolva al mismo tiempo
      (over all (not (tolva-ocupada ?t clinker))) ; Evita que clinker use la tolva al mismo tiempo
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-h)) ; Marca la tolva como ocupada por puzolana
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-h))) ; Libera la tolva al finalizar
    )
  )

  
  ;; Accin para alimentar puzolana
  (:durative-action alimentar-puzolana-s
    :parameters (?m - molino ?t - tolva)
    :duration (= ?duration 3)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t))
      (at start (material-disponible puzolana-s))
      (over all (not (tolva-ocupada ?t yeso)))    ; Evita que yeso use la tolva al mismo tiempo
      (over all (not (tolva-ocupada ?t clinker))) ; Evita que clinker use la tolva al mismo tiempo
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s)) ; Marca la tolva como ocupada por puzolana
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s))) ; Libera la tolva al finalizar
    )
  )

  ;; Acci para alimentar yeso
  (:durative-action alimentar-yeso
    :parameters (?m - molino ?t - tolva)
    :duration (= ?duration 2)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t))
      (at start (material-disponible yeso))
      (over all (not (tolva-ocupada ?t puzolana-h))) ; Evita que puzolana use la tolva al mismo tiempo
      (over all (not (tolva-ocupada ?t clinker)))  ; Evita que clinker use la tolva al mismo tiempo
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso)) ; Marca la tolva como ocupada por yeso
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso))) ; Libera la tolva al finalizar
    )
  )

  
)