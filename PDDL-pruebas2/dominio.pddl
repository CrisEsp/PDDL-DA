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
    (clinker-ocupado)         ; bandera global (para evitar 2 molinos a la vez)
    (clinker-libre)
    (puzolana-h-libre ?r - ruta)
    (puzolana-s-libre)
    (yeso-libre)    ;; Control de recursos
    (molino-libre-clinker ?m - molino)   ; si el molino no est ocupado con clinker
    (yeso-permitido ?m - molino)         ; si se permite yeso simultneamente
    (es-mc3 ?m - molino)                 ; identifica al molino mc3
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
    (at start (molino-libre-clinker ?m)) ; este molino no tiene clinker
    ; (at start (yeso-permitido ?m))       ; regla extra si es MC3
    (at start (clinker-libre))           ; en vez de (not (clinker-ocupado))
    (at start (puzolana-s-libre))
    (at start (yeso-libre))
  )
  :effect (and
    (at start (not (libre ?t)))
    (at start (tolva-ocupada ?t clinker))
    (at start (alimentando clinker ?m ?r))
    (at start (not (molino-libre-clinker ?m)))
    (at start (not (clinker-libre)))     ; oquea el recurso global clinker

    ;; costo y tiempo acumulado
    (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
    (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

    (at end (alimentado ?t clinker))
    (at end (libre ?t))
    (at end (not (tolva-ocupada ?t clinker)))
    (at end (not (alimentando clinker ?m ?r)))
    (at end (molino-libre-clinker ?m))
    (at end (clinker-libre))             ; libera el recurso global clinker
  )
)


  ;; -------------------------------
  ;; Alimentar puzolana hmeda
  ;; -------------------------------
  (:durative-action alimentar-puzolana-h
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (material-disponible puzolana-h))
      (at start (puzolana-h-libre ?r))
      ; (at start (yeso-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-h))
      (at start (alimentando puzolana-h ?m ?r))
      (at start (not(puzolana-h-libre ?r)))
      ;; costo y tiempo acumulado
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-h)))
      (at end (not (alimentando puzolana-h ?m ?r)))
      (at end (puzolana-h-libre ?r))
    )
  )

  ;; -------------------------------
  ;; Alimentar puzolana seca
  ;; -------------------------------
  (:durative-action alimentar-puzolana-s
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-s ?r))
      (at start (material-disponible puzolana-s))
      (at start (puzolana-s-libre))
      (at start (yeso-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s))
      (at start (alimentando puzolana-s ?m ?r))
      (at start (not(puzolana-s-libre)))
      ;; costo y tiempo acumulado
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s)))
      (at end (not (alimentando puzolana-s ?m ?r)))
      (at end (puzolana-s-libre))
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
      (at start (puzolana-h-libre PH-a-MC1-por-MC1))
      (at start (puzolana-s-libre))
      (at start (clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m ?r))
      ;; si es MC3, bloquear clinker
      ; (at start (when (es-mc3 ?m) (not (yeso-permitido ?m))))
      (at start (not(yeso-libre)))
      ;; costo y tiempo acumulado
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m ?r)))
      ;; liberar yeso en MC3
      ; (at end (when (es-mc3 ?m) (yeso-permitido ?m)))
      (at end (yeso-libre))
    )
  )
)
