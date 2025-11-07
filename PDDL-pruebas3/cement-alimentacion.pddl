
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
;     PS-a-MC3-por-MC2 - ruta
;   )

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    
;     ;; Recursos compartidos
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)  ;; Added new predicate for common feeding of MC3
    
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
;     (tiempo-acumulado-3)  ;; Added new accumulated time function
;     (tiempo-acumulado-4)  ;; Added new accumulated time function
;     (tiempo-acumulado-ck)  ;; Added new accumulated time function for clinker
;     ; (tiempo-acumulado-ck3)
;     (costo-total)
;     (costo-auxiliar)  ;; Nueva variable auxiliar
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
;       ;; Metrica: T + V (OPTIC interpreta asi la suma)
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))

;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))


;     )
;   )


;   ;; Puzolana-H MC1 por MC1
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
;       ;; Metrica: T + V (OPTIC interpreta asi la suma)
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))  ;; Updated to reflect
;     )
;   )

;   ;; Puzolana-S MC3 por MC2
;   (:durative-action alimentar-puzolana-s-MC3-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))  ;; Updated to reflect the correct molino
;       (at start (= ?r PS-a-MC3-por-MC2))  ;; Updated to reflect the correct route
;       (at start (= ?mat puzolana-s))
;       (at start (libre ?t))
;       (at start (compatible ?mat ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (molino-libre-pz-seca ?m))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-mc3-compartida-libre))

;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       ; (at start (not (alimentando-mc3-comun)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (ruta-mc3-compartida-libre)))  ;; Updated to reflect the correct condition
;       (at start (not (molino-libre-pz-seca ?m)))  ;; Updated to reflect the correct condition
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (molino-libre-pz-seca ?m))
;       (at end (ruta-mc3-compartida-libre))  ;; Updated to reflect the correct condition
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       ; (at end (alimentando-mc3-comun))  ;; Added effect to reflect common feeding
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ;; Updated to reflect
  
;       ; Calcular costo usando variable auxiliar
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc2) (tiempo-acumulado-mc1))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (* 100(tiempo-vaciado ?t)))))
;       ; ;; Incrementar ambos acumuladores
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))     


;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))
;       ; ;; Incrementar ambos acumuladores
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;       ; Eliminar el uso de costo-auxiliar
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))

;       ; Usar solo un acumulador (mc2) para el costo, manteniendo la alta prioridad de vaciado
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (*100(tiempo-vaciado ?t)))))
;       ; ;; Sigue incrementando ambos acumuladores (para la secuencialidad)
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))



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
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))

;     )
;   )


;   ;; Yeso MC1 por MC2 
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))  ;; Updated to reflect the correct molino
;       (at start (= ?r MC1-por-MC2))  ;; Updated to reflect the correct route
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (molino-libre-yeso ?m))
;       (at start (ruta-la-cinta-mc2-libre))  ;; Added to reflect the correct condition
      
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))  ;; Updated to reflect the correct condition
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))  ;; Updated to reflect the correct condition
;       (at end (molino-libre-yeso ?m))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (*100(tiempo-vaciado ?t)))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
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
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso ?m)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))  ;; Restored the line to reflect the correct effect
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
;     )
;   )

;   ; Yeso MC3 por MC2
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
;       (at start (ruta-mc3-compartida-libre))
;       ; (at start (alimentando-mc3-comun)) ;; Added to reflect the common feeding condition
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

;       (at end (ruta-mc3-compartida-libre))  ;; Added to reflect the updated condition
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;       ;; Incrementar costo con acumulador MC1
;           ; Calcular costo total sumando ambos acumuladores
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))
;       ; ;; Incrementar ambos acumuladores
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))


;           ; USAR VARIABLE AUXILIAR
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))
;       ; ;; Incrementar ambos acumuladores
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;       ; Eliminar el uso de costo-auxiliar
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))

;       ; Usar solo un acumulador (mc2) para el costo, manteniendo la alta prioridad de vaciado
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (*100(tiempo-vaciado ?t)))))
;       ; ;; Sigue incrementando ambos acumuladores (para la secuencialidad)
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;     )
;   )


;   ; ; Yeso MC3 por MC2 - Para MC3
;   ; (:durative-action alimentar-yeso-mc3-por-mc2-comun-MC3
;   ;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   ;   :duration (= ?duration (duracion-llenado ?t ?r))
;   ;   :condition (and
;   ;     (at start (= ?m mc3))
;   ;     (at start (= ?r MC3-por-MC2))
;   ;     (at start (libre ?t))
;   ;     (at start (compatible yeso ?t))
;   ;     (at start (ruta-disponible ?m ?t yeso ?r))
;   ;     (at start (ruta-la-cinta-mc2-libre))
;   ;     (at start (molino-libre-yeso ?m))
;   ;     (at start (ruta-mc3-compartida-libre))
;   ;     (at start (alimentando-mc3-comun))  ;; Added to reflect the common feeding condition
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     (at start (not (ruta-mc3-compartida-libre)))
;   ;     (at start (not (ruta-la-cinta-mc2-libre)))
;   ;     (at start (not (molino-libre-yeso ?m)))
;   ;     (at end (alimentado ?t yeso))
;   ;     (at end (libre ?t))
;   ;     (at end (ruta-la-cinta-mc2-libre))
;   ;     (at end (molino-libre-yeso ?m))

;   ;     (at end (ruta-mc3-compartida-libre))  ;; Added to reflect the updated condition
;   ;     (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;   ;     (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct accumulated time
;   ;   )
;   ; )




;   ;; ========================================
;   ;; ACCION MC3 CLINKER (USA ruta-la-mc1-ph-y-yeso-libre)
;   ;; ========================================

;     ;; Clinker MC1 
;   (:durative-action alimentar-clinker-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-desde-Pretrit))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
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
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
;     )
;   )

;     ;; Clinker MC2
;   (:durative-action alimentar-clinker-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc2))  ;; Updated to reflect the correct molino
;       (at start (= ?r MC2-desde-Pretrit))  ;; Updated to reflect the correct route
;       ; (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       ; (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       ; (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (* 100(tiempo-vaciado ?t)))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
;     )
;   )


;   ; Clinker MC3 desde Silo3
;   (:durative-action alimentar-clinker-Silo3-desde-pretrit
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r Silo3-desde-Pretrit))  ;; Updated route name
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       ; (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       ; (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       ; (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
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
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-mc3-compartida-libre))
;       ; (at start (alimentando-mc3-comun))
;       ; (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       ; (at start (not (alimentando-mc3-comun)))
;       (at start (not (ruta-mc3-compartida-libre)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       ; (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       ; (at end (molino-libre-clinker ?m))
;       (at end (ruta-mc3-compartida-libre))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       ; (at end (alimentando-mc3-comun))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
      
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (* 1000(tiempo-vaciado ?t)))))
;       ; ; Sigue actualizando ambos acumuladores (tu requerimiento):
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))


;       ;     ;; USAR VARIABLE AUXILIAR
;       ; (at end (assign (costo-auxiliar) (+ (tiempo-acumulado-mc1) (tiempo-acumulado-mc2))))
;       ; (at end (increase (costo-total) (+ (costo-auxiliar) (*100(tiempo-vaciado ?t)))))
;       ; ;; Incrementar ambos acumuladores
;       ; (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (*100(tiempo-vaciado ?t)))))
;       ; (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))

;       )
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
    puzolana-h yeso clinker puzolana-s - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
    MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit 
    PS-a-MC3-por-MC2 - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (tolva-asignada ?t - tolva ?m - molino)  ;; Nueva restriccion
    
    ;; Recursos compartidos
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    (ruta-mc3-compartida-libre)
    (alimentando-mc3-comun)
    
    ;; Recursos de molino
    (molino-libre-pz-humeda ?m - molino)
    (molino-libre-yeso ?m - molino)
    (molino-libre-clinker ?m - molino)
    (molino-libre-pz-seca ?m - molino)
  )

  (:functions
    (tiempo-vaciado ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-acumulado-mc1)
    (tiempo-acumulado-mc2)
    (tiempo-acumulado-3)
    (tiempo-acumulado-4)
    (tiempo-acumulado-ck)
    (costo-total)
    (costo-auxiliar)
  )

  ;; ========================================
  ;; ACCIONES LINEA MC1 (NO compartida con MC2)
  ;; ========================================

  ;; Puzolana-H MC1 por MC1
  (:durative-action alimentar-puzolana-h-MC1-por-MC1
    :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC1))
      (at start (= ?mat puzolana-h))
      (at start (libre ?t))
      (at start (compatible ?mat ?t))
      (at start (ruta-disponible ?m ?t ?mat ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
    )
  )

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
      (at start (ruta-disponible ?m ?t ?mat ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-S MC3 por MC2
  (:durative-action alimentar-puzolana-s-MC3-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta ?mat - materia) 
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r PS-a-MC3-por-MC2))
      (at start (= ?mat puzolana-s))
      (at start (libre ?t))
      (at start (compatible ?mat ?t))
      (at start (ruta-disponible ?m ?t ?mat ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
      (at start (molino-libre-pz-seca ?m))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (molino-libre-pz-seca ?m)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (molino-libre-pz-seca ?m))
      (at end (ruta-mc3-compartida-libre))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
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
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at start (= ?m mc1))
      (at start (= ?r MC1-por-MC2))
      (at start (libre ?t))
      (at start (compatible yeso ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
      (at start (molino-libre-yeso ?m))
      (at start (ruta-la-cinta-mc2-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (*100(tiempo-vaciado ?t)))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
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
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
      (at start (ruta-la-cinta-mc2-libre))
      (at start (molino-libre-yeso ?m))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (ruta-la-cinta-mc2-libre)))
      (at start (not (molino-libre-yeso ?m)))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (ruta-la-cinta-mc2-libre))
      (at end (molino-libre-yeso ?m))
      (at end (ruta-mc3-compartida-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; ========================================
  ;; ACCIONES CLINKER
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
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker MC2
  (:durative-action alimentar-clinker-mc2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc2))
      (at start (= ?r MC2-desde-Pretrit))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
      (at start (ruta-clinker-libre))
      (at start (molino-libre-clinker ?m))
    )
    :effect (and
      (at start (not (ruta-clinker-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at end (alimentado ?t clinker))
      (at end (ruta-clinker-libre))
      (at end (molino-libre-clinker ?m))
      (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (* 100(tiempo-vaciado ?t)))))
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
    )
  )

  ;; Clinker MC3 desde Silo3
  (:durative-action alimentar-clinker-Silo3-desde-pretrit
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r Silo3-desde-Pretrit))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
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
      (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))
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
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (tolva-asignada ?t ?m))  ;; Nueva condicion
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (ruta-mc3-compartida-libre))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-mc3-compartida-libre)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-mc3-compartida-libre))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
    )
  )
)


