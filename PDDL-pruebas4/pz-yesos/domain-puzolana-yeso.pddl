; ;  Dominio para Puzolanas y Yesos (MC1, MC2, MC3)

; (define (domain cement-puzolana-yeso)
;   (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 
;     PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-por-MC1
;     PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-asignada ?t - tolva ?m - molino)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-mc3-compartida-libre)
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;     (ruta-la-mc1-ph-y-yeso-libre) 
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-acumulado-cinta-mc2)
;     (tiempo-acumulado-cinta-mc1)
;     (tiempo-acumulado-mc1)
;     (tiempo-acumulado-ruta-mc3)
;     (costo-tiempo-compartido-cinta-mc2)
;     (costo-tiempo-compartido-cinta-mc1) 
;     (costo-tiempo-compartido-ruta-mc3)
;  (costo-tiempo-compartido-mc1)

;   )

;   ;; ============================================
;   ;; GRUPO CINTA MC2: MC1 y MC2
;   ;; ============================================

;   ; Puzolana-H MC1 por MC1
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC1))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (tolva-asignada ?t mc1))
;       (at start (molino-libre-pz-humeda mc1))
;       ; (at start (ruta-la-mc1-ph-y-yeso-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       ; (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc1) (tiempo-acumulado-cinta-mc1)))  ; ← RESTAURAR
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-humeda mc1))
;       ; (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (increase (tiempo-acumulado-cinta-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
;     )
;   )

;   ;; Yeso MC1 por MC1
;   ; (:durative-action alimentar-yeso-mc1-por-mc1
;   ;   :parameters (?t - tolva)
;   ;   :duration (= ?duration (duracion-llenado ?t MC1-por-MC1))
;   ;   :condition (and
;   ;     (at start (libre ?t))
;   ;     (at start (compatible yeso ?t))
;   ;     (at start (tolva-asignada ?t mc1))
;   ;     (at start (molino-libre-yeso mc1))
;   ;     (at start (ruta-la-mc1-ph-y-yeso-libre))
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;   ;     (at start (not (molino-libre-yeso mc1)))
;   ;     (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))  ; ← RESTAURAR
;   ;     (at end (alimentado ?t yeso))
;   ;     (at end (libre ?t))
;   ;     (at end (ruta-la-mc1-ph-y-yeso-libre))
;   ;     (at end (molino-libre-yeso mc1))
;   ;     (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
;   ;   )
;   ; )

  
  
;   ; Puzolana-H MC1 por MC2
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC2))
;     :condition (and
;       (at start (= ?r PH-a-MC1-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (tolva-asignada ?t mc1))
;       (at start (molino-libre-pz-humeda mc1))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-humeda mc1))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Puzolana-H 426HO04 por MC2
;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t PH-a-426HO04-por-MC2))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (tolva-asignada ?t mc2))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-pz-humeda mc2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-pz-humeda mc2)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-pz-humeda mc2))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;     )
;   )



;   ;; Yeso MC1 por MC2
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t MC1-por-MC2))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (tolva-asignada ?t mc1))
;       (at start (molino-libre-yeso mc1))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc1)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc1))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC2 por MC2
;   (:durative-action alimentar-yeso-mc2-por-mc2
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t MC2-por-MC2))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (tolva-asignada ?t mc2))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso mc2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc2)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc2))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; ============================================
;   ;; GRUPO MC3: Puzolanas y Yesos
;   ;; ============================================

;   ;; Puzolana-S MC3 por MC2
;   (:durative-action alimentar-puzolana-s-MC3-por-MC2
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t PS-a-MC3-por-MC2))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-s ?t))
;       (at start (tolva-asignada ?t mc3))
;       (at start (molino-libre-pz-seca mc3))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (molino-libre-pz-seca mc3)))
;       (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca mc3))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC3 por MC2 (usa AMBAS rutas)
;   (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t MC3-por-MC2))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (tolva-asignada ?t mc3))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso mc3))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc3)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc3))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC3 por MC1
;   (:durative-action alimentar-yeso-mc3-por-mc1  
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t MC3-por-MC1))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (tolva-asignada ?t mc3))
;       ; (at start (ruta-la-cinta-mc1-libre))  ; Updated to use mc1
;       (at start (molino-libre-yeso mc3))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       ; (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc3)))
;       ; (at start (increase (costo-tiempo-compartido-cinta-mc1) (tiempo-acumulado-cinta-mc1)))  ;
;       (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       ; (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc3))
;       (at end (ruta-mc3-compartida-libre))
;       ; (at end (increase (tiempo-acumulado-cinta-mc1) (tiempo-vaciado ?t)))  ; Updated
;       (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Puzolana-S 426HO02 por 426HO04
;   (:durative-action alimentar-puzolana-s-426HO02-por-426HO04
;     :parameters (?t - tolva)
;     :duration (= ?duration (duracion-llenado ?t PS-a-426HO02-por-426HO04))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-s ?t))
;       (at start (tolva-asignada ?t mc2))
;       (at start (molino-libre-pz-seca mc2))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-pz-seca mc2)))
;       (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-pz-seca mc2))
;       (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
;     )
;   )
; )


; ;; ========================================
; ;; DOMINIO
; ;; ========================================

; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
;     PS-a-MC3-por-MC2 MC3-por-MC1 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (tolva-asignada ?t - tolva ?m - molino)
    
;     ;; Recursos compartidos
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
    
;     ;; Recursos de molino
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (molino-libre-clinker ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-acumulado-mc1)
;     (tiempo-acumulado-mc2)
;     (tiempo-acumulado-mc3)
;     (tiempo-acumulado-ck)
;     (costo-total)
;   )

;   ;; ========================================
;   ;; ACCIONES LINEA MC1 (NO compartida con MC2)
;   ;; ========================================

;   ;; Puzolana-H MC1 por MC1
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC1))
;       (at start (= ?mat puzolana-h))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-pz-humeda ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-pz-humeda ?m)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-pz-humeda ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Puzolana-H MC1 por MC2
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC2))
;       (at start (= ?mat puzolana-h))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-humeda ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-humeda ?m)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-humeda ?m))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Puzolana-S MC3 por MC2
;   (:durative-action alimentar-puzolana-s-MC3-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r PS-a-MC3-por-MC2))
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-seca ?m))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (molino-libre-pz-seca ?m)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc3) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC1 por MC1
;   (:durative-action alimentar-yeso-mc1-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-por-MC1))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-yeso ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC1 por MC2 
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-yeso ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2)  (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; ========================================
;   ;; ACCIONES LINEA MC2 (COMPARTIDA - No simultaneas)
;   ;; ========================================

;   ;; Puzolana-H 426HO04 por MC2
;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r PH-a-426HO04-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-pz-humeda ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-pz-humeda ?m)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-pz-humeda ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC2 por MC2
;   (:durative-action alimentar-yeso-mc2-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r MC2-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC3 por MC2
;   (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso ?m))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC3 por MC1
;   (:durative-action alimentar-yeso-mc3-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-por-MC1))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-yeso ?m))
;       (at start (ruta-mc3-compartida-libre))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (molino-libre-yeso ?m))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc3) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; ========================================
;   ;; ACCIONES CLINKER
;   ;; ========================================

;   ;; Clinker MC1 
;   (:durative-action alimentar-clinker-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-desde-Pretrit))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Clinker MC2
;   (:durative-action alimentar-clinker-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r MC2-desde-Pretrit))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (* 100 (tiempo-vaciado ?t)))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Clinker MC3 desde Silo3 (via Pretrit)
;   (:durative-action alimentar-clinker-Silo3-desde-pretrit
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r Silo3-desde-Pretrit))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )
  
;   ;; Clinker MC3 desde Silo3 (via MC1)
;   (:durative-action alimentar-clinker-mc3-desde-silo3
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-desde-Silo3))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-mc3-compartida-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc3) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )
; )





;  Version mas rapida y limpia

(define (domain cement-puzolana-yeso)
  (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    puzolana-h yeso puzolana-s - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
    PS-a-MC3-por-MC2 MC3-por-MC1 PS-a-426HO02-por-426HO04 - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (tolva-asignada ?t - tolva ?m - molino)
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    (ruta-mc3-compartida-libre)
    (alimentando-mc3-comun)
    (usando-mc1-en-clinker)
    (molino-libre-pz-humeda ?m - molino)
    (molino-libre-yeso ?m - molino)
    (molino-libre-clinker ?m - molino)
    (molino-libre-pz-seca ?m - molino)
  )

  (:functions
    (tiempo-vaciado ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    
    ;; Acumuladores separados por grupo de rutas
    (tiempo-acumulado-cinta-mc1)  ; ← Added this line
    (tiempo-acumulado-cinta-mc2)

    (tiempo-acumulado-ruta-mc3)
    (tiempo-acumulado-mc1)
    (tiempo-acumulado-ck)
    
    ;; Costos separados
    (costo-tiempo-compartido-cinta-mc1)  ; ← Added this line
    (costo-tiempo-compartido-cinta-mc2)
    (costo-tiempo-compartido-ruta-mc3)
    (costo-tiempo-compartido-mc1)
    (costo-tiempo-compartido-ck)
  )

  ;; ============================================
  ;; GRUPO 2: Rutas por Cinta MC2
  ;; ============================================

  ;; Puzolana-H MC1 por MC2
  ;; ANTES: 4 parámetros → AHORA: 1 parámetro
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?t - tolva)
    :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC2))
    :condition (and
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
            
      (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))  ; ← RESTAURAR       (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))  ; ← RESTAURAR
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (molino-libre-pz-humeda mc1))
      (at end (ruta-la-mc1-ph-y-yeso-libre))

      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
    )
  )

  
;   ;; Yeso MC1 por MC1
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
      ; (at start (increase (costo-tiempo-compartido-cinta-mc1) (tiempo-acumulado-cinta-mc1)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-yeso mc1))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ; ← RESTAURAR
      ; (at end (increase (tiempo-acumulado-cinta-mc1) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-H 426HO04 por MC2
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
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
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
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
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
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
  ;; GRUPO 4: Rutas MC3 Compartida
  ;; ============================================

  ;; Puzolana-S MC3 por MC2
  ;; ANTES: 4 parámetros → AHORA: 1 parámetro
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

  ;; Yeso MC3 por MC2
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
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

  ;; Clinker MC3 desde Silo3
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
  ; (:durative-action alimentar-clinker-mc3-desde-silo3
  ;   :parameters (?t - tolva)
  ;   :duration (= ?duration (duracion-llenado ?t MC3-desde-Silo3))
  ;   :condition (and
  ;     (at start (libre ?t))
  ;     (at start (compatible clinker ?t))
  ;     (at start (tolva-asignada ?t mc3))
  ;     (at start (molino-libre-clinker mc3))
  ;     (at start (ruta-mc3-compartida-libre))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (not (ruta-mc3-compartida-libre)))
  ;     (at start (not (molino-libre-clinker mc3)))
  ;     (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
  ;     (at end (alimentado ?t clinker))
  ;     (at end (libre ?t))
  ;     (at end (molino-libre-clinker mc3))
  ;     (at end (ruta-mc3-compartida-libre))
  ;     (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
  ;   )
  ; )


  ;; ============================================
  ;; ACCIONES ADICIONALES
  ;; ============================================

  ;; Puzolana-S 426HO02 por 426HO04
  ;; ANTES: 3 parámetros → AHORA: 1 parámetro
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




