
(define (domain cement-alimentacion)
  (:requirements :durative-actions :typing :numeric-fluents :equality)
  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    clinker puzolana-h puzolana-s yeso - materia
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
    PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 MC3-desde-Silo3 - ruta
  )

  (:predicates
    (en-marcha ?m - molino)
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (material-disponible ?mat - materia)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-ocupada ?t - tolva ?mat - materia)
    (alimentando ?mat - materia ?m - molino ?r - ruta)
    
    ;; RECURSOS COMPARTIDOS (CUELOS DE BOTELLA)
    (ruta-la-mc1-ph-y-yeso-libre)    
    (ruta-la-cinta-mc2-libre)        
    (ruta-clinker-libre)             
    (ruta-linea-m3-libre)            
    
    ;; Recursos de Molino/Material
    (clinker-libre)
    (puzolana-s-libre)
    (puzolana-h-libre)
    (yeso-libre ?m - molino)
    (molino-libre-clinker ?m - molino)
    (molino-libre-pz-seca ?m - molino)
    (molino-libre-pz-humeda ?m - molino)
    (molino-libre-yeso ?m - molino)
  )

  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-vaciado ?t - tolva)
    (tiempo-acumulado)
    (costo-total)
  )

  ;; -------------------------------
  ;; ACCIONES CLAVE DE LA LNEA COMPARTIDA MC2
  ;; (Todas usan LA-Cinta-MC2 y tienen la mtrica T + V)
  ;; -------------------------------

  ;; Puzolana-H MC1 por MC2 (V=0.77)
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC2))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible mc1 ?t puzolana-h ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-pz-humeda mc1))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-humeda mc1)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-humeda mc1))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-H 426HO04 por MC2 (V=18.45)
  (:durative-action alimentar-puzolana-h-426HO04-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible mc2 ?t puzolana-h ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-pz-humeda mc2))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-humeda mc2)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-humeda mc2))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC1 por MC2 (V=0.40)
  (:durative-action alimentar-yeso-mc1-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible mc1 ?t yeso ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso mc1))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc1)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc1))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

    (:durative-action alimentar-yeso-mc2-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible mc2 ?t yeso ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso mc2))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc2)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc2))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC3 por MC2 (V=0.01)
  (:durative-action alimentar-yeso-mc3-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible mc3 ?t yeso ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso mc3))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc3)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc3))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )
  
  ;; Puzolana-H MC1 por MC1 (V=0.77) - Lnea NO compartida con MC2
  (:durative-action alimentar-puzolana-h-MC1-por-MC1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC1))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible mc1 ?t puzolana-h ?r))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (molino-libre-pz-humeda mc1))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (molino-libre-pz-humeda mc1)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-pz-humeda mc1))
      ;; MTRICA T + V
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )
  
  ;; Acciones de Clinker simplificadas (solo T+V)
  (:durative-action alimentar-clinker-mc1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible mc1 ?t clinker ?r))
      (at start (ruta-clinker-libre))
      (at start (molino-libre-clinker mc1))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker mc1)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-clinker-libre))
      (at end (molino-libre-clinker mc1))
      (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
    )
  )

)