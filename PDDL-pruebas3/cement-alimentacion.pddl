
; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    
;     ;; Recursos compartidos
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
    
;     ;; Recursos de molino
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (molino-libre-clinker ?m - molino)
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-acumulado-mc1)
;     (tiempo-acumulado-mc2)
;     (costo-total)
;   )

;   ;; ========================================
;   ;; ACCIONES LINEA MC1 (NO compartida con MC2)
;   ;; ========================================

;   ;; Puzolana-H MC1 por MC1
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC1))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
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
;       ;; Metrica T + V para linea MC1
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
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
;       ;; Metrica T + V para linea MC1
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;     )
;   )

  
;     (:durative-action alimentar-clinker-mc3-desde-silo3
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-desde-Silo3))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-clinker ?m))
;       ;; Metrica T + V para linea MC1
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;     )
;   )
;   ;; ========================================
;   ;; ACCIONES LINEA MC2 (COMPARTIDA - No simultaneas)
;   ;; ========================================

;   ;; Puzolana-H MC1 por MC2
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
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
;       ;; Metrica T + V para linea MC2
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Puzolana-H 426HO04 por MC2
;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       ; (at start (= ?m mc2))
;       (at start (= ?r PH-a-426HO04-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
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
;       ;; Metrica T + V para linea MC2
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
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
;       ;; Metrica T + V para linea MC2
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
;       ;; Metrica T + V para linea MC2
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
;       ;; Metrica T + V para linea MC2
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )
; )




;; ========================================
;; DOMINIO
;; ========================================

(define (domain cement-alimentacion-durativo)
  (:requirements :durative-actions :typing :numeric-fluents :equality)
  
  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    puzolana-h yeso clinker - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    
    ;; Recursos compartidos
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    
    ;; Recursos de molino
    (molino-libre-pz-humeda ?m - molino)
    (molino-libre-yeso ?m - molino)
    (molino-libre-clinker ?m - molino)
  )

  (:functions
    (tiempo-vaciado ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-acumulado-mc1)
    (tiempo-acumulado-mc2)
    (tiempo-acumulado-3)  ;; Added new accumulated time function
    (tiempo-acumulado-4)  ;; Added new accumulated time function
    (tiempo-acumulado-ck)  ;; Added new accumulated time function for clinker
    ; (tiempo-acumulado-ck3)
    (costo-total)
  )

  ;; ========================================
  ;; ACCIONES LINEA MC1 (NO compartida con MC2)
  ;; ========================================

  ;; Puzolana-H MC1 por MC1
  (:durative-action alimentar-puzolana-h-MC1-por-MC1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC1))
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (molino-libre-pz-humeda ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (molino-libre-pz-humeda ?m)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-pz-humeda ?m))
      ;; Metrica: T + V (OPTIC interpreta asi la suma)
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))


    )
  )


  ;; Puzolana-H MC1 por MC1
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC2))
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (molino-libre-pz-humeda ?m))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (molino-libre-pz-humeda ?m)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (molino-libre-pz-humeda ?m))
      (at end (ruta-la-cinta-mc2-libre))
      ;; Metrica: T + V (OPTIC interpreta asi la suma)
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))  ;; Updated to reflect

    )
  )

  ;; Yeso MC1 por MC1
  (:durative-action alimentar-yeso-mc1-por-mc1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r MC1-por-MC1))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (molino-libre-yeso ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))

    )
  )


  ;; Yeso MC1 por MC2 
  (:durative-action alimentar-yeso-mc1-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))  ;; Updated to reflect the correct molino
      (at start (= ?r MC1-por-MC2))  ;; Updated to reflect the correct route
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (molino-libre-yeso ?m))
      (at start (ruta-la-cinta-mc2-libre))  ;; Added to reflect the correct condition
      
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))  ;; Updated to reflect the correct condition
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))  ;; Updated to reflect the correct condition
      (at end (molino-libre-yeso ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
    )
  )

  ;; ========================================
  ;; ACCIONES LINEA MC2 (COMPARTIDA - No simultaneas)
  ;; ========================================

  ;; Puzolana-H 426HO04 por MC2
  (:durative-action alimentar-puzolana-h-426HO04-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r PH-a-426HO04-por-MC2))
      (at start (libre ?t))
      (at start (compatible puzolana-h ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-pz-humeda ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-pz-humeda ?m)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-pz-humeda ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
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
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Yeso MC3 por MC2
  (:durative-action alimentar-yeso-mc3-por-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r MC3-por-MC2))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; ========================================
  ;; ACCION MC3 CLINKER (USA ruta-la-mc1-ph-y-yeso-libre)
  ;; ========================================

    ;; Clinker MC1 
  (:durative-action alimentar-clinker-mc1
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r MC1-desde-Pretrit))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (ruta-clinker-libre))
      (at start (molino-libre-clinker ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-clinker-libre))
      (at end (molino-libre-clinker ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
    )
  )

    ;; Clinker MC2
  (:durative-action alimentar-clinker-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))  ;; Updated to reflect the correct molino
      (at start (= ?r MC2-desde-Pretrit))  ;; Updated to reflect the correct route
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (ruta-clinker-libre))
      (at start (molino-libre-clinker ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-clinker-libre))
      (at end (molino-libre-clinker ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
    )
  )


  ;; Clinker MC3 desde Silo3
  (:durative-action alimentar-clinker-Silo3-desde-pretrit
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r Silo3-desde-Pretrit))  ;; Updated route name
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      ; (at start (ruta-clinker-libre))
      (at start (molino-libre-clinker ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      ; (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      ; (at end (ruta-clinker-libre))
      (at end (molino-libre-clinker ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
    )
  )
  
  ; ;; Clinker MC3 desde Silo3
  ; (:durative-action alimentar-clinker-mc3-desde-silo3
  ;   :parameters (?m - molino ?t - tolva ?r - ruta)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (= ?m mc3))
  ;     (at start (= ?r MC3-desde-Silo3))
  ;     (at start (libre ?t))
  ;     (at start (compatible clinker ?t))
  ;     (at start (ruta-disponible ?m ?t clinker ?r))
  ;     ; (at start (molino-libre-clinker ?m))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     ; (at start (not (molino-libre-clinker ?m)))
  ;     (at end (alimentado ?t clinker))
  ;     (at end (libre ?t))
  ;     ; (at end (ruta-clinker-libre))
  ;     ; (at end (molino-libre-clinker ?m))
  ;     (at end (increase (costo-total) (+ (tiempo-acumulado-ck3) (tiempo-vaciado ?t))))
  ;     (at end (increase (tiempo-acumulado-ck3) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
  ;   )
  ; )
)
