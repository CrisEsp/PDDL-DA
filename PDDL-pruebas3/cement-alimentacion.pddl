
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





; ;; ========================================
; ;; DOMINIO   - NUEVA VERSION CASI OK
; ;; ========================================

; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
;     PS-a-MC3-por-MC2 MC3-por-MC1 PS-a-426HO02-por-426HO04 - ruta
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
;     (usando-mc1-en-clinker)
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
;     (tiempo-acumulado-pz-seca)
;     (costo-tiempo-compartido)
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
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
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
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))

;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc3)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc3)))
;     )
;   )

;     ;; Puzolana-S MC2 por MC2
;   (:durative-action alimentar-puzolana-s-MC2-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r PS-a-426HO02-por-426HO04))
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-seca ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))

;       (at start (not (molino-libre-pz-seca ?m)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m))

;       (at end (increase (tiempo-acumulado-pz-seca) (tiempo-vaciado ?t)))

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

;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
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
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-vaciado ?t)))
;       )
;   )

;   ;; Yeso MC2 por MC2 - PRIORIZABLE
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
;       ; (at start (molino-libre-yeso ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC3 por MC2 - PRIORIZABLE
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
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
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-ck)))
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
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-ck)))
;     )
;   )

;     ;; Clinker MC3 desde Silo3 
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
;       ; (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))

;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc3)))
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
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

; )




; ;; ========================================
; ;; DOMINIO CON PRIORIDAD-BASE
; ;; ========================================

; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
;     PS-a-MC3-por-MC2 MC3-por-MC1 PS-a-426HO02-por-426HO04 - ruta
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
;     (usando-mc1-en-clinker)
;     ;; Recursos de molino
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (molino-libre-clinker ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (prioridad-base ?t - tolva)
;     (tiempo-acumulado-mc1)
;     (tiempo-acumulado-mc2)
;     (tiempo-acumulado-mc3)
;     (tiempo-acumulado-ck)
;     (tiempo-acumulado-pz-seca)
;     (costo-tiempo-compartido)
;     (costo-por-prioridad)
;     (costo-tiempo-compartido-mc2)  
;     (costo-tiempo-compartido-mc3)  
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc3)))

;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3))) 
;     )
;   )

;   ;; Puzolana-S MC2 por MC2
;   (:durative-action alimentar-puzolana-s-MC2-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r PS-a-426HO02-por-426HO04))
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-seca ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-seca ?m)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m))
;       (at end (increase (tiempo-acumulado-pz-seca) (tiempo-vaciado ?t)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
;       ;; PENALIZACION POR PRIORIDAD: Mayor prioridad = menor penalizacion
;       ; (at end (increase (costo-por-prioridad) (- 100 (prioridad-base ?t))))
;     )
;   )

;   ;; Yeso MC2 por MC2 - PRIORIZABLE
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
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))

;       ;; PENALIZACION POR PRIORIDAD: Mayor prioridad = menor penalizacion
;       ; (at end (increase (costo-por-prioridad) (- 100 (prioridad-base ?t))))
;     )
;   )

;   ;; Yeso MC3 por MC2 - PRIORIZABLE
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc2)))
;       ;; PENALIZACION POR PRIORIDAD: Mayor prioridad = menor penalizacion
;       (at end (increase (costo-por-prioridad) (- 100 (prioridad-base ?t))))
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
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Clinker MC3 desde Silo3 
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido) (tiempo-acumulado-mc3)))
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
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

; )


; ;; ========================================
; ;; DOMINIO CON ACUMULADORES MC1+MC2+MC3
; ;; ========================================

; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
;     PS-a-MC3-por-MC2 MC3-por-MC1 PS-a-426HO02-por-426HO04 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (tolva-asignada ?t - tolva ?m - molino)
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
;     (usando-mc1-en-clinker)
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (molino-libre-clinker ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (prioridad-base ?t - tolva)
;     (tiempo-acumulado-mc1)
;     (tiempo-acumulado-mc2)
;     (tiempo-acumulado-mc3)
;     (tiempo-acumulado-ck)
;     (tiempo-acumulado-pz-seca)
;     (costo-tiempo-compartido-mc1)  
;     (costo-tiempo-compartido-mc2)  
;     (costo-tiempo-compartido-mc3)  
;   )

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
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3))) 
;     )
;   )

;   ;; Puzolana-S MC2 por MC2
;   (:durative-action alimentar-puzolana-s-MC2-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r PS-a-426HO02-por-426HO04))
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-seca ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-seca ?m)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m))
;       (at end (increase (tiempo-acumulado-pz-seca) (tiempo-vaciado ?t)))
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
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;     )
;   )

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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
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
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
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
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

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
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Clinker MC3 desde Silo3 
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;       (at end (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at end (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
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
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
;     )
;   )

; )



; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker puzolana-s - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
;     PS-a-MC3-por-MC2 MC3-por-MC1 PS-a-426HO02-por-426HO04 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (tolva-asignada ?t - tolva ?m - molino)
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
;     (usando-mc1-en-clinker)
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
;     (tiempo-acumulado-pz-seca)
;     (costo-tiempo-compartido-mc1)  
;     (costo-tiempo-compartido-mc2)  
;     (costo-tiempo-compartido-mc3)  
;   )

;   ;; 1. Puzolana-H MC1 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1)) 
;       (at start (= ?r PH-a-MC1-por-MC2)) 
;       (at start (= ?mat puzolana-h))
;       (at start (libre ?t)) 
;       (at start (compatible ?mat ?t)) 
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-humeda ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (molino-libre-pz-humeda ?m))) 
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t puzolana-h)) (at end (libre ?t))
;       (at end (molino-libre-pz-humeda ?m)) (at end (ruta-la-cinta-mc2-libre))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ; 2. Puzolana-S MC3 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-puzolana-s-MC3-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r PS-a-MC3-por-MC2)) 
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t)) 
;       (at start (compatible ?mat ?t)) 
;       (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-pz-seca ?m)) 
;       ; (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t))) 
;       ; (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (molino-libre-pz-seca ?m)))
;       (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t puzolana-s)) (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m)) (at end (ruta-mc3-compartida-libre))
;       ; (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )


;   ;; 3. Puzolana-H 426HO04 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2)) (at start (= ?r PH-a-426HO04-por-MC2))
;       (at start (libre ?t)) (at start (compatible puzolana-h ?t)) (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre)) (at start (molino-libre-pz-humeda ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t))) (at start (not (ruta-la-cinta-mc2-libre))) (at start (not (molino-libre-pz-humeda ?m)))
;       ; (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       ; (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t puzolana-h)) (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre)) (at end (molino-libre-pz-humeda ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; 4. Yeso MC1 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1)) (at start (= ?r MC1-por-MC2))
;       (at start (libre ?t)) (at start (compatible yeso ?t)) (at start (tolva-asignada ?t ?m))
;       (at start (molino-libre-yeso ?m)) (at start (ruta-la-cinta-mc2-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t))) (at start (not (ruta-la-cinta-mc2-libre))) (at start (not (molino-libre-yeso ?m)))
;       (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t yeso)) (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre)) (at end (molino-libre-yeso ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; 5. Yeso MC2 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-yeso-mc2-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))
;       (at start (= ?r MC2-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; 6. Yeso MC3 por MC2 (usa cinta MC2)
;   (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3)) (at start (= ?r MC3-por-MC2))
;       (at start (libre ?t)) (at start (compatible yeso ?t)) (at start (tolva-asignada ?t ?m))
;       (at start (ruta-la-cinta-mc2-libre)) (at start (molino-libre-yeso ?m))
;       (at start (ruta-mc3-compartida-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t))) (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (ruta-la-cinta-mc2-libre))) (at start (not (molino-libre-yeso ?m)))
;       (at start (increase (costo-tiempo-compartido-mc2) (tiempo-acumulado-mc2)))
;       (at start (increase (costo-tiempo-compartido-mc3) (tiempo-acumulado-mc3)))
;       (at end (alimentado ?t yeso)) (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre)) (at end (molino-libre-yeso ?m))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;       (at end (increase (tiempo-acumulado-mc3) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Las demas acciones (las que NO usan cinta MC2) quedan igual, solo con su propio costo donde corresponda
;   ;; (puzolana-h MC1 por MC1, yeso MC1 por MC1, clinker, etc.)


; )



(define (domain cement-alimentacion-durativo)
  (:requirements :durative-actions :typing :numeric-fluents :equality :negative-preconditions)

  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    puzolana-h yeso clinker puzolana-s - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
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
    (tiempo-acumulado-cinta-mc2)      ; Grupo 2: todas las rutas "por-MC2"
    (tiempo-acumulado-ruta-mc3)       ; Grupo 4: ruta-mc3-compartida
    (tiempo-acumulado-mc1)            ; Grupo 1: rutas "por-MC1"
    (tiempo-acumulado-ck)             ; Grupo 3: rutas clinker
    
    ;; Costos separados
    (costo-tiempo-compartido-cinta-mc2)
    (costo-tiempo-compartido-ruta-mc3)
    (costo-tiempo-compartido-mc1)
    (costo-tiempo-compartido-ck)
  )

  ;; ============================================
  ;; GRUPO 1: Rutas por MC1
  ;; ============================================

  ;; Puzolana-H MC1 por MC1
  ; (:durative-action alimentar-puzolana-h-MC1-por-MC1
  ;   :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (= ?m mc1))
  ;     (at start (= ?r PH-a-MC1-por-MC1))
  ;     (at start (= ?mat puzolana-h))
  ;     (at start (libre ?t))
  ;     (at start (compatible ?mat ?t))
  ;     (at start (tolva-asignada ?t ?m))
  ;     (at start (molino-libre-pz-humeda ?m))
  ;     (at start (ruta-la-mc1-ph-y-yeso-libre))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (not (molino-libre-pz-humeda ?m)))
  ;     (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
  ;     (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))
  ;     (at end (alimentado ?t puzolana-h))
  ;     (at end (libre ?t))
  ;     (at end (molino-libre-pz-humeda ?m))
  ;     (at end (ruta-la-mc1-ph-y-yeso-libre))
  ;     (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
  ;   )
  ; )

  ; ;; Yeso MC1 por MC1
  ; (:durative-action alimentar-yeso-mc1-por-mc1
  ;   :parameters (?m - molino ?t - tolva ?r - ruta)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (= ?m mc1))
  ;     (at start (= ?r MC1-por-MC1))
  ;     (at start (libre ?t))
  ;     (at start (compatible yeso ?t))
  ;     (at start (tolva-asignada ?t ?m))
  ;     (at start (molino-libre-yeso ?m))
  ;     (at start (ruta-la-mc1-ph-y-yeso-libre))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (not (molino-libre-yeso ?m)))
  ;     (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
  ;     (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))
  ;     (at end (alimentado ?t yeso))
  ;     (at end (libre ?t))
  ;     (at end (molino-libre-yeso ?m))
  ;     (at end (ruta-la-mc1-ph-y-yeso-libre))
  ;     (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
  ;   )
  ; )

  ;; ============================================
  ;; GRUPO 2: Rutas por Cinta MC2
  ;; ============================================

  ;; Puzolana-H MC1 por MC2
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC2))
      (at start (= ?mat puzolana-h))
      (at start (libre ?t))
      (at start (compatible ?mat ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-pz-humeda ?m))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (molino-libre-pz-humeda ?m)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (molino-libre-pz-humeda ?m))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-H 426HO04 por MC2
  (:durative-action alimentar-puzolana-h-426HO04-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r PH-a-426HO04-por-MC2))
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-pz-humeda ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-humeda ?m)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-humeda ?m))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC1 por MC2
  (:durative-action alimentar-yeso-mc1-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r MC1-por-MC2))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-yeso ?m))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC2 por MC2
  (:durative-action alimentar-yeso-mc2-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r MC2-por-MC2))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; ============================================
  ;; GRUPO 4: Rutas MC3 Compartida
  ;; ============================================

  ;; Puzolana-S MC3 por MC2 (usa SOLO ruta-mc3)
  (:durative-action alimentar-puzolana-s-MC3-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r PS-a-MC3-por-MC2))
      (at start (= ?mat puzolana-s))
      (at start (libre ?t))
      (at start (compatible ?mat ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-pz-seca ?m))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (molino-libre-pz-seca ?m)))
      (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (molino-libre-pz-seca ?m))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC3 por MC2 (usa AMBAS: cinta-mc2 Y ruta-mc3)
  (:durative-action alimentar-yeso-mc3-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r MC3-por-MC2))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso ?m))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
      (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker MC3 desde Silo3
  (:durative-action alimentar-clinker-mc3-desde-silo3
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r MC3-desde-Silo3))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-clinker ?m))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (molino-libre-clinker ?m))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
    )
  )

  ;; ============================================
  ;; GRUPO 3: Rutas Clinker desde Pretrit
  ;; ============================================

  ;; Clinker MC1 desde Pretrit
  (:durative-action alimentar-clinker-mc1-desde-pretrit
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r MC1-desde-Pretrit))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-clinker ?m))
      (at start (ruta-clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at start (increase (costo-tiempo-compartido-ck) (tiempo-acumulado-ck)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (molino-libre-clinker ?m))
      (at end (ruta-clinker-libre))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker MC2 desde Pretrit
  (:durative-action alimentar-clinker-mc2-desde-pretrit
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r MC2-desde-Pretrit))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-clinker ?m))
      (at start (ruta-clinker-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at start (increase (costo-tiempo-compartido-ck) (tiempo-acumulado-ck)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (molino-libre-clinker ?m))
      (at end (ruta-clinker-libre))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker Silo3 desde Pretrit
  (:durative-action alimentar-clinker-silo3-desde-pretrit
    :parameters (?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?r Silo3-desde-Pretrit))
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

  ;; ============================================
  ;; ACCIONES ADICIONALES (si existen)
  ;; ============================================

  ;; Puzolana-S 426HO02 por 426HO04 (si aplica)
  (:durative-action alimentar-puzolana-s-426HO02-por-426HO04
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r PS-a-426HO02-por-426HO04))
      (at start (libre ?t))
      (at start (compatible puzolana-s ?t))
      (at start (tolva-asignada ?t ?m))
      (at start (molino-libre-pz-seca ?m))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-seca ?m)))
      (at start (increase (costo-tiempo-compartido-cinta-mc2) (tiempo-acumulado-cinta-mc2)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-seca ?m))
      (at end (increase (tiempo-acumulado-cinta-mc2) (tiempo-vaciado ?t)))
    )
  )

  ; ;; Yeso MC3 por MC1 (si existe)
  ; (:durative-action alimentar-yeso-mc3-por-mc1
  ;   :parameters (?m - molino ?t - tolva ?r - ruta)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (= ?m mc3))
  ;     (at start (= ?r MC3-por-MC1))
  ;     (at start (libre ?t))
  ;     (at start (compatible yeso ?t))
  ;     (at start (tolva-asignada ?t ?m))
  ;     (at start (molino-libre-yeso ?m))
  ;     (at start (ruta-la-mc1-ph-y-yeso-libre))
  ;     (at start (ruta-mc3-compartida-libre))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
  ;     (at start (not (ruta-mc3-compartida-libre)))
  ;     (at start (not (molino-libre-yeso ?m)))
  ;     (at start (increase (costo-tiempo-compartido-mc1) (tiempo-acumulado-mc1)))
  ;     (at start (increase (costo-tiempo-compartido-ruta-mc3) (tiempo-acumulado-ruta-mc3)))
  ;     (at end (alimentado ?t yeso))
  ;     (at end (libre ?t))
  ;     (at end (ruta-la-mc1-ph-y-yeso-libre))
  ;     (at end (molino-libre-yeso ?m))
  ;     (at end (ruta-mc3-compartida-libre))
  ;     (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
  ;     (at end (increase (tiempo-acumulado-ruta-mc3) (tiempo-vaciado ?t)))
  ;   )
  ; )

)