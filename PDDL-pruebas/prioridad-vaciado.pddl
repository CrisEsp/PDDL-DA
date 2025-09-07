
(define (domain vaciado-con-tiempos)
  (:requirements :strips :typing :durative-actions :fluents)

  (:types
    contenedor
  )

  (:predicates
    (lleno ?c - contenedor)
    (vacio ?c - contenedor)
    (libre)                       ; recurso que obliga a secuencialidad
  )

  (:functions
    (tiempo-vaciado ?c - contenedor) ; tiempo de vaciado por contenedor
    (tiempo-acumulado)               ; reloj acumulado (se actualiza secuencialmente)
    (costo-total)                    ; sum of completion times (objetivo)
  )

  (:durative-action vaciar
    :parameters (?c - contenedor)
    :duration (= ?duration (tiempo-vaciado ?c))
    :condition (and
                (at start (lleno ?c))
                (at start (libre))          ; requiere recurso libre al inicio
                )
    :effect (and
             (at start (not (libre)))      ; ocupa recurso al comenzar
             (at end (libre))             ; libera recurso al terminar
             (at end (not (lleno ?c)))
             (at end (vacio ?c))
             ;; aumentar el costo por (tiempo-acumulado + duracion)
             (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?c))))
             ;; actualizar reloj acumulado
             (at end (increase (tiempo-acumulado) (tiempo-vaciado ?c)))
    )
  )
)
