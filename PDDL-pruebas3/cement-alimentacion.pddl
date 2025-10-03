
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
    (puzolana-s-libre)
    ; (puzolana-h-libre ?r - ruta)
    (molino-puzolana-s-libre ?m - molino)
    (yeso-libre ?m - molino)
    (ruta-yeso-libre ?m - molino ?r - ruta)
    ; (yeso-libre ?r - ruta)
    (molino-libre-clinker ?m - molino)
    (molino-libre-pz-seca ?m - molino)
    (molino-libre-yeso ?m - molino)
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

  (:durative-action alimentar-clinker-mc1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha mc1))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible mc1 ?t clinker ?r))
      (at start (material-disponible clinker))
      (at start (molino-libre-clinker mc1))
      (at start (clinker-libre))
      ; (at start (puzolana-s-libre ?m))
      ; (at start (puzolana-h-libre ?r))
      ; (at start (yeso-libre mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker mc1 MC1-desde-Pretrit))
      (at start (not (molino-libre-clinker mc1)))
      (at start (not (clinker-libre)))
      (at end (alimentado t1-clinker clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker mc1 MC1-desde-Pretrit)))
      (at end (molino-libre-clinker mc1))
      (at end (clinker-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

    )
  )

  (:durative-action alimentar-clinker-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha mc2))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker MC2-desde-Pretrit))
      (at start (material-disponible clinker))
      (at start (molino-libre-clinker mc2))
      (at start (clinker-libre))
      ; (at start (puzolana-s-libre ?m))
      ; (at start (puzolana-h-libre ?r))
      ; (at start (yeso-libre mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker ?m MC2-desde-Pretrit))
      (at start (not (molino-libre-clinker ?m)))
      (at start (not (clinker-libre)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker ?m MC2-desde-Pretrit)))
      (at end (molino-libre-clinker ?m))
      (at end (clinker-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

    )
  )

  (:durative-action alimentar-clinker-mc3
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha mc3))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (material-disponible clinker))
      (at start (molino-libre-clinker mc3))
      (at start (clinker-libre))
      (at start (molino-libre-pz-seca mc3))
      ; (at start (puzolana-h-libre ?r))
      (at start (yeso-libre mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker ?m ?r))
      (at start (not (molino-libre-clinker ?m)))
      (at start (not(molino-libre-pz-seca mc3)))
      (at start (not (clinker-libre)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker ?m ?r)))
      (at end (molino-libre-clinker ?m))
      (at end (clinker-libre))
      (at end (molino-libre-pz-seca mc3))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

    )
  )
;; -------------------------------
  ;; Alimentar puzolana-s
  ;; -------------------------------

    (:durative-action alimentar-puzolana-s-mc3
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha mc3))
      (at start (libre ?t))
      (at start (compatible puzolana-s ?t))
      (at start (ruta-disponible ?m ?t puzolana-s PS-a-MC3-por-MC2))
      (at start (material-disponible puzolana-s))
      (at start (molino-libre-pz-seca mc3))
      (at start (puzolana-s-libre))
      ; (at start (puzolana-s-libre ?m))
      ; (at start (puzolana-h-libre ?r))
      ; (at start (yeso-libre mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s))
      (at start (alimentando puzolana-s ?m PS-a-MC3-por-MC2))
      (at start (not (molino-libre-pz-seca ?m)))
      (at start (not (puzolana-s-libre)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s)))
      (at end (not (alimentando puzolana-s ?m PS-a-MC3-por-MC2)))
      (at end (molino-libre-pz-seca ?m))
      (at end (puzolana-s-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
      )
  )


;; -------------------------------
  ;; Alimentar yeso MC3
  ;; -------------------------------
    (:durative-action alimentar-yeso-mc3
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha mc3))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible ?m ?t yeso MC3-por-MC2))
      (at start (material-disponible yeso))
      (at start (ruta-yeso-libre mc3 MC3-por-MC2))
      (at start (molino-libre-yeso mc3))
      ; (at start (puzolana-s-libre ?m))
      ; (at start (puzolana-h-libre ?r))
      (at start (yeso-libre mc3))

    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m MC3-por-MC2))
      (at start (not (ruta-yeso-libre mc3 MC3-por-MC2)))
      (at start (not(molino-libre-yeso mc3)))
      (at start (not(yeso-libre mc3)))
      ; (at start (not (puzolana-s-libre)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m MC3-por-MC2)))
      ; (at end (not(molino-libre-yeso mc3)))
      ; (at end (puzolana-s-libre))
      (at start (molino-libre-yeso mc3))
      (at end (yeso-libre mc3))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
      )
  )

)