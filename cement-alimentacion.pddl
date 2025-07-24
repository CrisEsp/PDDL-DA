; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing)
  
;   (:types molino tolva materia ruta)

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia) ; Nuevo predicado para rastrear ocupacin
;   )

;   ;; Accin para alimentar clinker
;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (material-disponible clinker))
;       (over all (not (tolva-ocupada ?t puzolana-h))) ; Asegura que no est ocupada por puzolana
;       (over all (not (tolva-ocupada ?t yeso)))    ; Asegura que no estocupada por yeso
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker)) ; Marca la tolva como ocupada por clinker
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker))) ; Libera la tolva al finalizar
;     )
;   )

;   ;; Accin para alimentar puzolana
;   (:durative-action alimentar-puzolana-h
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 3)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t ))
;       (at start (material-disponible puzolana-h))
;       (over all (not (tolva-ocupada ?t yeso)))    ; Evita que yeso use la tolva al mismo tiempo
;       (over all (not (tolva-ocupada ?t clinker))) ; Evita que clinker use la tolva al mismo tiempo
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-h)) ; Marca la tolva como ocupada por puzolana
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-h))) ; Libera la tolva al finalizar
;     )
;   )

  
;   ;; Accin para alimentar puzolana
;   (:durative-action alimentar-puzolana-s
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 3)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible puzolana-s))
;       (over all (not (tolva-ocupada ?t yeso)))    ; Evita que yeso use la tolva al mismo tiempo
;       (over all (not (tolva-ocupada ?t clinker))) ; Evita que clinker use la tolva al mismo tiempo
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-s)) ; Marca la tolva como ocupada por puzolana
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-s))) ; Libera la tolva al finalizar
;     )
;   )

;   ;; Acci para alimentar yeso
;   (:durative-action alimentar-yeso
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 2)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible yeso))
;       (over all (not (tolva-ocupada ?t puzolana-h))) ; Evita que puzolana use la tolva al mismo tiempo
;       (over all (not (tolva-ocupada ?t clinker)))  ; Evita que clinker use la tolva al mismo tiempo
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso)) ; Marca la tolva como ocupada por yeso
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso))) ; Libera la tolva al finalizar
;     )
;   )

  
; )



(define (domain cement-alimentacion)
  (:requirements :durative-actions :typing :numeric-fluents)
  
  (:types molino tolva materia ruta)

  (:predicates
    (en-marcha ?m - molino)
    (libre ?t - tolva)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (material-disponible ?mat - materia)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-ocupada ?t - tolva ?mat - materia) ; Para evitar puzolana y yeso simultneamente
    (clinker-ocupado) ; Nuevo predicado para evitar alimentacin simultnea de clinker a l1 y l2
  )

  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
  )
  ;; Accin para alimentar clinker
  (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration 3)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (material-disponible clinker))
      (at start (not (clinker-ocupado))) ; Asegura que no se est alimentando clinker a otra tolva
      (over all (not (tolva-ocupada ?t puzolana-h)))
      (over all (not (tolva-ocupada ?t puzolana-s)))
      (over all (not (tolva-ocupada ?t yeso)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (clinker-ocupado)) ; Marca que el sistema de clinker est ocupado
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (clinker-ocupado))) ; Libera el sistema de clinker al finalizar
    )
  )

  ;; Accin para alimentar puzolana (hmeda o seca)
  (:durative-action alimentar-puzolana
    :parameters (?m - molino ?t - tolva ?mat - materia ?r - ruta)
    :duration (= ?duration 3)
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t ?mat ?r))
      (at start (material-disponible ?mat))
      (at start (or (= ?mat puzolana-h) (= ?mat puzolana-s)))
      (over all (not (tolva-ocupada ?t yeso)))
      (over all (not (tolva-ocupada ?t clinker)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t ?mat))
      (at end (alimentado ?t ?mat))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t ?mat)))
    )
  )

  ;; Accin para alimentar yeso
  (:durative-action alimentar-yeso
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration 3 )
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (material-disponible yeso))
      (over all (not (tolva-ocupada ?t puzolana-h)))
      (over all (not (tolva-ocupada ?t puzolana-s)))
      (over all (not (tolva-ocupada ?t clinker)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
    )
  )
)