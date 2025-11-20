;  Dominio para clinkers desde Pretrit (MC1, MC2, Silo3)

(define (domain cement-clinker-pretrit)
  (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    clinker - materia
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-asignada ?t - tolva ?m - molino)
    (ruta-clinker-libre)
    (molino-libre-clinker ?m - molino)
  )

  (:functions
    (tiempo-vaciado ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-acumulado-ck)
    (costo-tiempo-compartido-ck)
  )

  ;; Clinker MC1 desde Pretrit
  (:durative-action alimentar-clinker-mc1-desde-pretrit
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC1-desde-Pretrit))
    :condition (and
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (tolva-asignada ?t mc1))
      (at start (molino-libre-clinker mc1))
      (at start (ruta-clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker mc1)))
      (at start (increase (costo-tiempo-compartido-ck) (tiempo-acumulado-ck)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (molino-libre-clinker mc1))
      (at end (ruta-clinker-libre))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker MC2 desde Pretrit
  (:durative-action alimentar-clinker-mc2-desde-pretrit
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t MC2-desde-Pretrit))
    :condition (and
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (tolva-asignada ?t mc2))
      (at start (molino-libre-clinker mc2))
      (at start (ruta-clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker mc2)))
      (at start (increase (costo-tiempo-compartido-ck) (tiempo-acumulado-ck)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (molino-libre-clinker mc2))
      (at end (ruta-clinker-libre))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker Silo3 desde Pretrit
  (:durative-action alimentar-clinker-silo3-desde-pretrit
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t Silo3-desde-Pretrit))
    :condition (and
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (increase (costo-tiempo-compartido-ck) (tiempo-acumulado-ck)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-clinker-libre))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )
)