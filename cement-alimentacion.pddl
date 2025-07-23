; (define (domain cement-alimentacion)
;   (:requirements :typing :durative-actions :negative-preconditions)

;   (:types
;     molino tolva materia
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva)
;     (material-disponible ?mat - materia)
;     (contenido ?t - tolva ?mat - materia)
;     (en-marcha ?m - molino)
;     (alimentado ?t - tolva ?mat - materia)
;   )

;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible clinker))
;       (over all (libre ?t))
;     )
;     :effect (and
;       (at start (not (material-disponible clinker)))
;       (at start (not (libre ?t)))
;       (at end (contenido ?t clinker))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;     )
;   )

;   (:durative-action alimentar-puzolana
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible puzolana))
;       (at start (alimentado ?t clinker))
;       (over all (libre ?t))
;     )
;     :effect (and
;       (at start (not (material-disponible puzolana)))
;       (at start (not (libre ?t)))
;       (at end (contenido ?t puzolana))
;       (at end (alimentado ?t puzolana))
;       (at end (libre ?t))
;     )
;   )
; )



; (define (domain cement-alimentacion)
;   (:requirements :typing :durative-actions :negative-preconditions)

;   (:types
;     molino tolva materia
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva)
;     (material-disponible ?mat - materia)
;     (contenido ?t - tolva ?mat - materia)
;     (en-marcha ?m - molino)
;     (alimentado ?t - tolva ?mat - materia)
;     (bloqueo-clinker)
;   )

;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible clinker))
;       (over all (libre ?t))
;     )
;     :effect (and
;       (at start (not (material-disponible clinker)))
;       (at start (not (libre ?t)))
;       (at start (bloqueo-clinker))
;       (at end (contenido ?t clinker))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (bloqueo-clinker)))
;     )
;   )

;   (:durative-action alimentar-puzolana
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible puzolana))
;       (at start (alimentado ?t clinker))
;       (over all (libre ?t))
;     )
;     :effect (and
;       (at start (not (material-disponible puzolana)))
;       (at start (not (libre ?t)))
;       (at end (contenido ?t puzolana))
;       (at end (alimentado ?t puzolana))
;       (at end (libre ?t))
;     )
;   )

;   (:durative-action alimentar-yeso
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible yeso))
;       (over all (libre ?t))
;       (over all (not (bloqueo-clinker)))
;     )
;     :effect (and
;       (at start (not (material-disponible yeso)))
;       (at start (not (libre ?t)))
;       (at end (contenido ?t yeso))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;     )
;   )
; )

; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing)
  
;   (:types molino tolva materia)

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;   )

;   ;; Accin para alimentar clinker
;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 5)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible clinker))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;     )
;   )

;   ;; Accin para alimentar puzolana
;   (:durative-action alimentar-puzolana
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 3)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible puzolana))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at end (alimentado ?t puzolana))
;       (at end (libre ?t))
;     )
;   )

;   ;; Accin para alimentar yeso
;   (:durative-action alimentar-yeso
;     :parameters (?m - molino ?t - tolva)
;     :duration (= ?duration 2)
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t))
;       (at start (material-disponible yeso))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;     )
;   )
; )


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
      (over all (not (tolva-ocupada ?t puzolana))) ; Asegura que no est ocupada por puzolana
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