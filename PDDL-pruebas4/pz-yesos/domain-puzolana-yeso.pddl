;  Dominio para Puzolanas y Yesos (MC1, MC2, MC3)

(define (domain cement-puzolana-yeso)
  (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    puzolana-h yeso puzolana-s - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 
    PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2
    PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-asignada ?t - tolva ?m - molino)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (ruta-la-cinta-mc2-libre)
    (ruta-mc3-compartida-libre)
    (molino-libre-pz-humeda ?m - molino)
    (molino-libre-yeso ?m - molino)
    (molino-libre-pz-seca ?m - molino)
    (ruta-la-mc1-ph-y-yeso-libre) 
  )

  (:functions
    (tiempo-vaciado ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-acumulado-cinta-mc2)
    (tiempo-acumulado-cinta-mc1)
    (tiempo-acumulado-mc1)
    (tiempo-acumulado-ruta-mc3)
    (costo-tiempo-compartido-cinta-mc2)
    (costo-tiempo-compartido-cinta-mc1) 
    (costo-tiempo-compartido-ruta-mc3)
 (costo-tiempo-compartido-mc1)

  )

  ;; ============================================
  ;; GRUPO CINTA MC2: MC1 y MC2
  ;; ============================================

  ; Puzolana-H MC1 por MC1
  (:durative-action alimentar-puzolana-h-MC1-por-MC1
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC1))
    :condition (and
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (tolva-asignada ?t mc1))
      (at start (molino-libre-pz-humeda mc1))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (molino-libre-pz-humeda mc1)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))  ; ← RESTAURAR
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (molino-libre-pz-humeda mc1))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
    )
  )

  ;; Yeso MC1 por MC1
  (:durative-action alimentar-yeso-mc1-por-mc1
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC1-por-MC1))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t mc1))
      (at start (molino-libre-yeso mc1))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (molino-libre-yeso mc1)))
      (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))  ; ← RESTAURAR
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-yeso mc1))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
    )
  )

  
  
  ; Puzolana-H MC1 por MC2
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC2))
    :condition (and
      (at start (= ?r PH-a-MC1-por-MC2))
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (tolva-asignada ?t mc1))
      (at start (molino-libre-pz-humeda mc1))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (molino-libre-pz-humeda mc1)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (molino-libre-pz-humeda mc1))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-H 426HO04 por MC2
  (:durative-action alimentar-puzolana-h-426HO04-por-MC2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t PH-a-426HO04-por-MC2))
    :condition (and
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (tolva-asignada ?t mc2))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-pz-humeda mc2))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-humeda mc2)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-humeda mc2))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )



  ;; Yeso MC1 por MC2
  (:durative-action alimentar-yeso-mc1-por-mc2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC1-por-MC2))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t mc1))
      (at start (molino-libre-yeso mc1))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc1)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc1))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC2 por MC2
  (:durative-action alimentar-yeso-mc2-por-mc2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC2-por-MC2))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t mc2))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso mc2))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc2)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc2))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; ============================================
  ;; GRUPO MC3: Puzolanas y Yesos
  ;; ============================================

  ;; Puzolana-S MC3 por MC2
  (:durative-action alimentar-puzolana-s-MC3-por-MC2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t PS-a-MC3-por-MC2))
    :condition (and
      (at start (libre ?t))
      (at start (compatible puzolana-s ?t))
      (at start (tolva-asignada ?t mc3))
      (at start (molino-libre-pz-seca mc3))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (molino-libre-pz-seca mc3)))
      (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (molino-libre-pz-seca mc3))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC3 por MC2 (usa AMBAS rutas)
  (:durative-action alimentar-yeso-mc3-por-mc2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC3-por-MC2))
    :condition (and
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t mc3))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso mc3))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso mc3)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso mc3))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
      (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-S 426HO02 por 426HO04
  (:durative-action alimentar-puzolana-s-426HO02-por-426HO04
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t PS-a-426HO02-por-426HO04))
    :condition (and
      (at start (libre ?t))
      (at start (compatible puzolana-s ?t))
      (at start (tolva-asignada ?t mc2))
      (at start (molino-libre-pz-seca mc2))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-seca mc2)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-seca mc2))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )
)

