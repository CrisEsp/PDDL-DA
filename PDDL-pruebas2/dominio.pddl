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
    
    ;; Predicados de control
    (alimentando-puzolana-mc2 ?t - tolva)
    (alimentando-yeso-mc2 ?t - tolva)
    (clinker-ocupado)
    (clinker-ocupado2 ?m - molino)
    (puzolana-h-ocupado ?m - molino ?r - ruta)
    (puzolana-s-ocupado)
    (yeso-ocupado ?m - molino ?r - ruta)
  )

  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-vaciado ?t - tolva)
   
    (tiempo-acumulado)               ; reloj acumulado (se actualiza secuencialmente)
    (costo-total)                    ; sum of completion times (objetivo)


  )

  ;; -------------------------------
  ;; Accrica: alimentar clinker
  ;; -------------------------------
  (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      ; (at start (not (clinker-ocupado2 ?m)))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (material-disponible clinker))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker ?m ?r))
      (at start (clinker-ocupado2 ?m))
      ; (at start (increase (total-cost) (tiempo-vaciado ?t))) ; <<< prioridad tiempo de vaciado
      

            ;; aumentar el costo por (tiempo-acumulado + duracion)
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      ;; actualizar reloj acumulado
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    
      
      (at end (not (clinker-ocupado2 ?m)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker ?m ?r)))
    )
  )

  ; -------------------------------
  ; Alimentar puzolana hmeda
  ;; -------------------------------
  (:durative-action alimentar-puzolana-h
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (material-disponible puzolana-h))
      ; (at start (not (puzolana-h-ocupado ?m ?r)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-h))
      (at start (alimentando puzolana-h ?m ?r))
      (at start (puzolana-h-ocupado ?m ?r))
      ; (at start (increase (total-cost) (tiempo-vaciado ?t))) ; <<< prioridad tiempo de vaciado
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      ;; actualizar reloj acumulado
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    
      
      (at end (not (puzolana-h-ocupado ?m ?r)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-h)))
      (at end (not (alimentando puzolana-h ?m ?r)))
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
      ; (at start (not (puzolana-s-ocupado)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s))
      (at start (alimentando puzolana-s ?m ?r))
      (at start (puzolana-s-ocupado))
      ; (at start (increase (total-cost) (tiempo-vaciado ?t))) ; <<< prioridad tiempo de vaciado
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      ;; actualizar reloj acumulado
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    
      
      (at end (not (puzolana-s-ocupado)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s)))
      (at end (not (alimentando puzolana-s ?m ?r)))
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
      ; (at start (not (yeso-ocupado ?m ?r)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m ?r))
      (at start (yeso-ocupado ?m ?r))
      ; (at start (increase (total-cost) (tiempo-vaciado ?t))) ; <<< prioridad tiempo de vaciado
                  ;; aumentar el costo por (tiempo-acumulado + duracion)
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      ;; actualizar reloj acumulado
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    
      
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m ?r)))
      (at end (not (yeso-ocupado ?m ?r)))
    )
  )
)
