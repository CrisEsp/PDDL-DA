; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing :numeric-fluents :negative-preconditions)
;   (:types molino tolva materia ruta)

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia)
;     (alimentando ?mat - materia ?m - molino ?r - ruta)
;     (clinker-ocupado)         ; bandera global (para evitar 2 molinos a la vez)
;     (clinker-libre)
;     (puzolana-h-libre ?r - ruta)
;     (puzolana-s-libre)
;     (yeso-libre ?m - molino)    ;; Control de recursos
;     (molino-libre-clinker ?m - molino)   ; si el molino no est ocupado con clinker
;     (yeso-permitido ?m - molino)         ; si se permite yeso simultneamente
;     (es-mc3 ?m - molino)                 ; identifica al molino mc3
;   )

;   (:functions
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-vaciado ?t - tolva)
;     (tiempo-acumulado)
;     (costo-total)
;   )

;   ;; -------------------------------
;   ;; Alimentar clinker
;   ;; -------------------------------
;   (:durative-action alimentar-clinker
;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   :duration (= ?duration (duracion-llenado ?t ?r))
;   :condition (and
;     (at start (en-marcha ?m))
;     (at start (libre ?t))
;     (at start (compatible clinker ?t))
;     (at start (ruta-disponible ?m ?t clinker ?r))
;     (at start (material-disponible clinker))
;     (at start (molino-libre-clinker ?m)) ; este molino no tiene clinker
;     ; (at start (yeso-permitido ?m))       ; regla extra si es MC3

;     (at start (clinker-libre))           ; en vez de (not (clinker-ocupado))
;     (at start (puzolana-s-libre))
;     (at start (yeso-libre ?m))
;   )
;   :effect (and
;     (at start (not (libre ?t)))
;     (at start (tolva-ocupada ?t clinker))
;     (at start (alimentando clinker ?m ?r))
;     (at start (not (molino-libre-clinker ?m)))
;     (at start (not (clinker-libre)))     ; oquea el recurso global clinker

;     ;; costo y tiempo acumulado
;     (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     (at end (alimentado ?t clinker))
;     (at end (libre ?t))
;     (at end (not (tolva-ocupada ?t clinker)))
;     (at end (not (alimentando clinker ?m ?r)))
;     (at end (molino-libre-clinker ?m))
;     (at end (clinker-libre))             ; libera el recurso global clinker
;   )
; )



;   ;; -------------------------------
;   ;; Alimentar puzolana seca
;   ;; -------------------------------
;   (:durative-action alimentar-puzolana-s
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t puzolana-s ?r))
;       (at start (material-disponible puzolana-s))
;       (at start (puzolana-s-libre))
;       (at start (yeso-libre ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-s))
;       (at start (alimentando puzolana-s ?m ?r))
;       (at start (not(puzolana-s-libre)))
;       ;; costo y tiempo acumulado
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-s)))
;       (at end (not (alimentando puzolana-s ?m ?r)))
;       (at end (puzolana-s-libre))
;     )
;   )



; ;   ;; -------------------------------
; ;   ;; Alimentar puzolana hmeda
; ;   ;; -------------------------------
; ;   (:durative-action alimentar-puzolana-h
; ;     :parameters (?m - molino ?t - tolva ?r - ruta)
; ;     :duration (= ?duration (duracion-llenado ?t ?r))
; ;     :condition (and
; ;       (at start (en-marcha ?m))
; ;       (at start (libre ?t))
; ;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
; ;       (at start (material-disponible puzolana-h))
; ;       (at start (puzolana-h-libre ?r))
; ;       ; (at start (yeso-libre))
; ;     )
; ;     :effect (and
; ;       (at start (not (libre ?t)))
; ;       (at start (tolva-ocupada ?t puzolana-h))
; ;       (at start (alimentando puzolana-h ?m ?r))
; ;       (at start (not(puzolana-h-libre ?r)))
; ;       ;; costo y tiempo acumulado
; ;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
; ;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

; ;       (at end (alimentado ?t puzolana-h))
; ;       (at end (libre ?t))
; ;       (at end (not (tolva-ocupada ?t puzolana-h)))
; ;       (at end (not (alimentando puzolana-h ?m ?r)))
; ;       (at end (puzolana-h-libre ?r))
; ;     )
; ;   )


; ;   ;; -------------------------------
; ;   ;; Alimentar yeso
; ;   ;; -------------------------------
; ;   (:durative-action alimentar-yeso
; ;     :parameters (?m - molino ?t - tolva ?r - ruta)
; ;     :duration (= ?duration (duracion-llenado ?t ?r))
; ;     :condition (and
; ;       (at start (en-marcha ?m))
; ;       (at start (libre ?t))
; ;       (at start (ruta-disponible ?m ?t yeso ?r))
; ;       (at start (material-disponible yeso))
; ;       ; (at start (puzolana-h-libre PH-a-MC1-por-MC1))
; ;       (at start (yeso-libre))       ;; controla recurso yeso
; ;       (at start (puzolana-s-libre))
; ;       (at start (clinker-libre))
; ;       ;; --- restriccin especfica:
; ;       ;; si la ruta conflictiva PH-a-MC1-por-MC2 est ocupada, no puedo arrancar
; ;       (at start (puzolana-h-libre PH-a-MC1-por-MC1))
; ;     )
; ;     :effect (and
; ;       (at start (not (libre ?t)))
; ;       (at start (tolva-ocupada ?t yeso))
; ;       (at start (alimentando yeso ?m ?r))
; ;       (at start (not(yeso-libre)))
; ;       ;; costo y tiempo acumulado
; ;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
; ;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

; ;       (at end (alimentado ?t yeso))
; ;       (at end (libre ?t))
; ;       (at end (not (tolva-ocupada ?t yeso)))
; ;       (at end (not (alimentando yeso ?m ?r)))
; ;       (at end (yeso-libre))
; ;     )
; ;   )
; ; )




; ; -------------------------------
; ; Alimentar puzolana hmeda
; ; -------------------------------
; (:durative-action alimentar-puzolana-h
;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   :duration (= ?duration (duracion-llenado ?t ?r))
;   :condition (and
;     (at start (en-marcha ?m))
;     (at start (libre ?t))
;     (at start (ruta-disponible ?m ?t puzolana-h ?r))
;     (at start (material-disponible puzolana-h))
;     ;; recurso por RUTA: solo puede empezar si esa ruta est libre
;     (at start (puzolana-h-libre ?r))
;   )
;   :effect (and
;     ;; Ocupa la tolva y la ruta al inicio
;     (at start (not (libre ?t)))
;     (at start (tolva-ocupada ?t puzolana-h))
;     (at start (alimentando puzolana-h ?m ?r))
;     (at start (not (puzolana-h-libre ?r)))

;     ;; Al final libera tolva y ruta, y acumula costo/tiempo
;     (at end (alimentado ?t puzolana-h))
;     (at end (libre ?t))
;     (at end (not (tolva-ocupada ?t puzolana-h)))
;     (at end (not (alimentando puzolana-h ?m ?r)))
;     (at end (puzolana-h-libre ?r))

;     (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;   )
; )


; ;; -------------------------------
; ;; Alimentar yeso
; ;; -------------------------------
; (:durative-action alimentar-yeso
;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   :duration (= ?duration (duracion-llenado ?t ?r))
;   :condition (and
;     (at start (en-marcha ?m))
;     (at start (libre ?t))
;     (at start (ruta-disponible ?m ?t yeso ?r))
;     (at start (material-disponible yeso))

;     ;; Recurso de yeso ahora parametrizado por molino
;     (at start (yeso-libre ?m))

;     ;; Mantener restricciones de puzolana-h conflictiva
;     ;; Solo bloquea yeso si la ruta PH-a-MC1-por-MC1 est ocupada
;     (at start (puzolana-h-libre PH-a-MC1-por-MC1))
;   )
;   :effect (and
;     ;; Ocupa la tolva y recurso al inicio
;     (at start (not (libre ?t)))
;     (at start (tolva-ocupada ?t yeso))
;     (at start (alimentando yeso ?m ?r))
;     (at start (not (yeso-libre ?m)))

;     ;; Al final libera recurso y tolva, acumula costo/tiempo
;     (at end (alimentado ?t yeso))
;     (at end (libre ?t))
;     (at end (not (tolva-ocupada ?t yeso)))
;     (at end (not (alimentando yeso ?m ?r)))
;     (at end (yeso-libre ?m))

;     (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;   )
; )
; )



(define (domain cement-alimentacion)
  (:requirements :durative-actions :typing :numeric-fluents)
  (:types molino tolva materia ruta)

  (:predicates
    (en-marcha ?m - molino)
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (material-disponible ?mat - materia)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-ocupada ?t - tolva ?mat - materia)
    (alimentando ?mat - materia ?m - molino ?r - ruta)

    ;; Recursos positivos para controlar conflictos
    (clinker-libre)
    (puzolana-h-libre ?r - ruta)
    (puzolana-s-libre ?m - molino)
    (yeso-libre ?m - molino)
    (ruta-yeso-libre ?m - molino ?r - ruta)
    ; (yeso-libre ?r - ruta)
    (molino-libre-clinker ?m - molino)
  )

  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-vaciado ?t - tolva)
    (tiempo-acumulado)
    (costo-total)
  )

  ;; -------------------------------
  ;; Alimentar clinker
  ;; -------------------------------
  (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (material-disponible clinker))
      (at start (molino-libre-clinker ?m))
      (at start (clinker-libre))
      (at start (puzolana-s-libre ?m))
      ; (at start (puzolana-h-libre ?r))
      (at start (yeso-libre mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker ?m ?r))
      (at start (not (molino-libre-clinker ?m)))
      (at start (not (clinker-libre)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker ?m ?r)))
      (at end (molino-libre-clinker ?m))
      (at end (clinker-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))



    )
  )

  ;; -------------------------------
  ;; Alimentar puzolana-h
  ;; -------------------------------
  (:durative-action alimentar-puzolana-h
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (material-disponible puzolana-h))
      (at start (yeso-libre mc1))
      (at start (puzolana-h-libre ?r))   ;;  recurso positivo
      (at start (puzolana-h-libre PH-a-MC1-por-MC2)) ;; mantiene conflicto
      
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-h))
      (at start (alimentando puzolana-h ?m ?r))
      (at start (not (puzolana-h-libre ?r))) ;; ocupa la ruta
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-h)))
      (at end (not (alimentando puzolana-h ?m ?r)))
      (at end (puzolana-h-libre ?r))          ;; libera la ruta
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))


    )
  )

  ;; -------------------------------
  ;; Alimentar puzolana-s
  ;; -------------------------------
  (:durative-action alimentar-puzolana-s
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-s ?r))
      (at start (material-disponible puzolana-s))
      (at start (puzolana-s-libre mc3))
      (at start (yeso-libre ?m))
      (at start (molino-libre-clinker mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s))
      (at start (alimentando puzolana-s ?m ?r))
      (at start (not (puzolana-s-libre ?m)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s)))
      (at end (not (alimentando puzolana-s ?m ?r)))
      (at end (puzolana-s-libre ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

  ;; -------------------------------
  ;; Alimentar yeso
  ;; -------------------------------
  (:durative-action alimentar-yeso
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (material-disponible yeso))
      (at start (yeso-libre ?m))          ;; recurso positivo
      (at start (puzolana-h-libre PH-a-MC1-por-MC1)) ;; mantiene conflicto
      (at start (molino-libre-clinker mc3))
      (at start (puzolana-s-libre ?m))
      (at start (ruta-yeso-libre mc2 MC2-por-MC2))
      (at start (ruta-yeso-libre mc3 MC3-por-MC2))       ;; recurso positivo
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m ?r))
      (at start (not (yeso-libre ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m ?r)))
      (at end (yeso-libre ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )
)

