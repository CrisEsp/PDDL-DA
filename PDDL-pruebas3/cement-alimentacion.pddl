
; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
;   (:types molino tolva materia ruta)

;   (:constants

;     mc1 mc2 mc3 - molino
;     clinker puzolana-h puzolana-s yeso - materia
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
;     PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 MC3-desde-Silo3 - ruta

;   )

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia)
;     (alimentando ?mat - materia ?m - molino ?r - ruta)
;     ; (tarea-yeso-t1-pendiente)
;     ;; Recursos positivos para controlar conflictos
;     (clinker-libre)
;     ; (yeso-libre)
;     (puzolana-s-libre)
;     (puzolana-h-libre)
;     ; (puzolana-h-libre ?r - ruta)
;     (molino-puzolana-s-libre ?m - molino)
;     (yeso-libre ?m - molino)
;     (ruta-yeso-libre ?m - molino ?r - ruta)
;     ; (yeso-libre ?r - ruta)
;     (molino-libre-clinker ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;     (ruta-puzolana-h-libre ?m - molino ?r - ruta)
;     (ruta-ck-libre ?m - molino ?r - ruta)
;     (ruta-es-mc1-por-mc1 ?r)
;     (ruta-puzolana-s-libre ?m - molino ?r - ruta)
;     (ruta-es-mc1-por-mc2 ?r)
;   )

;   (:functions
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-vaciado ?t - tolva)
;     (tiempo-acumulado)
;     (costo-total)
;   )

;   ;; -------------------------------
;   ;; Alimentar clinker
;   ;; -------------------------------

;   (:durative-action alimentar-clinker-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible mc1 ?t clinker ?r))
;       (at start (material-disponible clinker))
;       (at start (molino-libre-clinker mc1))
;       (at start (clinker-libre))
;       ; (at start (puzolana-s-libre ?m))
;       ; (at start (puzolana-h-libre ?r))
;       ; (at start (yeso-libre mc3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker))
;       (at start (alimentando clinker mc1 MC1-desde-Pretrit))
;       (at start (not (molino-libre-clinker mc1)))
;       (at start (not (clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker)))
;       (at end (not (alimentando clinker mc1 MC1-desde-Pretrit)))
;       (at end (molino-libre-clinker mc1))
;       (at end (clinker-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))

;     )
;   )

;   (:durative-action alimentar-clinker-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc2))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker MC2-desde-Pretrit))
;       (at start (material-disponible clinker))
;       (at start (molino-libre-clinker mc2))
;       (at start (clinker-libre))
;       ; (at start (puzolana-s-libre ?m))
;       ; (at start (puzolana-h-libre ?r))
;       ; (at start (yeso-libre mc3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker))
;       (at start (alimentando clinker ?m MC2-desde-Pretrit))
;       (at start (not (molino-libre-clinker ?m)))
;       (at start (not (clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker)))
;       (at end (not (alimentando clinker ?m MC2-desde-Pretrit)))
;       (at end (molino-libre-clinker ?m))
;       (at end (clinker-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     )
;   )

;   (:durative-action alimentar-clinker-mc3-desde-S3
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc3))
;       (at start (libre ?t))
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-desde-Silo3))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (material-disponible clinker))
;       (at start (molino-libre-clinker mc3))
;       (at start (clinker-libre))
;       (at start (molino-libre-pz-seca mc3))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC1)) 
;       (at start (ruta-ck-libre mc3 MC3-desde-Silo3))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1))
;       ; (at start (puzolana-h-libre ?r))
;       (at start (yeso-libre mc3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker))
;       (at start (alimentando clinker ?m ?r))
;       (at start (not (molino-libre-clinker ?m)))
;       (at start (not(molino-libre-pz-seca mc3)))
;       (at start (not (ruta-ck-libre mc3 MC3-desde-Silo3)))
;       (at start (not (clinker-libre)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker)))
;       (at end (not (alimentando clinker ?m ?r)))
;       (at end (molino-libre-clinker ?m))
;       (at end (clinker-libre))
;       (at end (molino-libre-pz-seca mc3))
;       (at end (ruta-ck-libre mc3 MC3-desde-Silo3))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

;   ; (:durative-action alimentar-clinker-pretri-SB
;   ;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   ;   :duration (= ?duration (duracion-llenado ?t ?r))
;   ;   :condition (and
;   ;     (at start (en-marcha mc3))
;   ;     (at start (libre ?t))
;   ;     (at start (= ?m mc3))
;   ;     (at start (= ?r Silo3-desde-Pretrit))
;   ;     (at start (compatible clinker ?t))
;   ;     (at start (ruta-disponible ?m ?t clinker ?r))
;   ;     (at start (material-disponible clinker))
;   ;     (at start (molino-libre-clinker mc3))
;   ;     (at start (clinker-libre))
;   ;     (at start (molino-libre-pz-seca mc3))
;   ;     ; (at start (puzolana-h-libre ?r))
;   ;     (at start (yeso-libre mc3))
;   ;     (at start (ruta-yeso-libre mc1 MC1-por-MC1)) 
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     (at start (tolva-ocupada ?t clinker))
;   ;     (at start (alimentando clinker ?m ?r))
;   ;     (at start (not (molino-libre-clinker ?m)))
;   ;     (at start (not(molino-libre-pz-seca mc3)))
;   ;     (at start (not (clinker-libre)))
;   ;     (at end (alimentado ?t clinker))
;   ;     (at end (libre ?t))
;   ;     (at end (not (tolva-ocupada ?t clinker)))
;   ;     (at end (not (alimentando clinker ?m ?r)))
;   ;     (at end (molino-libre-clinker ?m))
;   ;     (at end (clinker-libre))
;   ;     (at end (molino-libre-pz-seca mc3))
;   ;     (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;   ;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;   ;   )
;   ; )


;     ;; -------------------------------
;   ;; Alimentar puzolana-h MC1
;   ;; -------------------------------

;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc1))
;       (at start (= ?m mc1)) 
;       (at start (= ?r PH-a-MC1-por-MC1)) 
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc1 ?t puzolana-h ?r))
;       (at start (material-disponible puzolana-h))
;       (at start (molino-libre-pz-humeda mc1))
;       (at start (puzolana-h-libre))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC1))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1))
;       (at start (ruta-ck-libre mc3 MC3-desde-Silo3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-h))
;       (at start (alimentando puzolana-h mc1 ?r))
;       (at start (not (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       (at start (not (puzolana-h-libre)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-h)))
;       (at end (not (alimentando puzolana-h mc1 ?r)))
;       (at end (molino-libre-pz-humeda mc1))
;       (at end (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1))
;       (at end (puzolana-h-libre))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))
;     )
;   )

;     (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc1))
;       (at start (libre ?t))
;       (at start (= ?m mc1)) 
;       (at start (= ?r PH-a-MC1-por-MC2)) 
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc1 ?t puzolana-h ?r))
;       (at start (material-disponible puzolana-h))
;       (at start (molino-libre-pz-humeda mc1))
;       (at start (puzolana-h-libre))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at start (ruta-yeso-libre mc3 MC3-por-MC2)) 
;       (at start (ruta-yeso-libre mc2 MC2-por-MC2))    
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;     )

;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-h))
;       (at start (alimentando puzolana-h mc1 ?r))
;       (at start (not (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       (at start (not (puzolana-h-libre)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-h)))
;       (at end (not (alimentando puzolana-h mc1 ?r)))
;       (at end (molino-libre-pz-humeda mc1))
;       (at end (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at end (puzolana-h-libre))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (- 1000 (tiempo-acumulado)))))
;       ; (at end (increase (tiempo-acumulado) 1))
;       (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10) (tiempo-vaciado ?t)))) ;; --- CAMBIO AQU
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )


;     ;; -------------------------------
;   ;; Alimentar puzolana-h 426HO04-por-MC2
;   ;; -------------------------------

;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc2))
;       (at start (= ?m mc2)) 
;       (at start (= ?r PH-a-426HO04-por-MC2)) 
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc2 ?t puzolana-h ?r))
;       (at start (material-disponible puzolana-h))
;       (at start (molino-libre-pz-humeda mc2))
;       (at start (puzolana-h-libre))
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at start (ruta-yeso-libre mc3 MC3-por-MC2)) 
;       (at start (ruta-yeso-libre mc2 MC2-por-MC2))    

;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-h))
;       (at start (alimentando puzolana-h mc2 ?r))
;       (at start (not (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2)))
;       (at start (not (molino-libre-pz-humeda mc2)))
;       (at start (not (puzolana-h-libre)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-h)))
;       (at end (not (alimentando puzolana-h mc2 ?r)))
;       (at end (molino-libre-pz-humeda mc2))
;       (at end (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;       (at end (puzolana-h-libre))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))

;       (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10) (tiempo-vaciado ?t)))) ;; --- CAMBIO AQU
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

; ;; -------------------------------
;   ;; Alimentar puzolana-s mc3
;   ;; -------------------------------

;     (:durative-action alimentar-puzolana-s-mc3
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc3))
;       (at start (libre ?t))
;       (at start (compatible puzolana-s ?t))
;       (at start (ruta-disponible ?m ?t puzolana-s PS-a-MC3-por-MC2))
;       (at start (material-disponible puzolana-s))
;       (at start (molino-libre-pz-seca mc3))
;       (at start (puzolana-s-libre))
;       ; (at start (puzolana-s-libre ?m))
;       ; (at start (puzolana-h-libre ?r))
;       (at start (molino-libre-yeso mc3))
;       (at start (ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t puzolana-s))
;       (at start (alimentando puzolana-s ?m PS-a-MC3-por-MC2))
;       (at start (not (molino-libre-pz-seca ?m)))
;       (at start (not (puzolana-s-libre)))
;       (at start (not(ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2)))
;       (at end (alimentado ?t puzolana-s))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t puzolana-s)))
;       (at end (not (alimentando puzolana-s ?m PS-a-MC3-por-MC2)))
;       (at end (molino-libre-pz-seca ?m))
;       (at end (puzolana-s-libre))
;       (at end (ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       )
;   )


; ;; -------------------------------
;   ;; Alimentar yeso MC1
;   ;; -------------------------------
;   (:durative-action alimentar-yeso-mc1-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       ; (at start (ruta-es-mc1-por-mc1 MC1-por-MC1))
;       (at start (en-marcha mc1))
;       (at start (= ?m mc1)) 
;       (at start (= ?r MC1-por-MC1)) 
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc1 ?t yeso MC1-por-MC1))
;       (at start (material-disponible yeso))
;       (at start (molino-libre-yeso mc1))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC1))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC1))  ;;  ESTA ES LA CLAVE
;       (at start (ruta-ck-libre mc3 MC3-desde-Silo3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (alimentando yeso mc1 MC1-por-MC1))
;       (at start (not (molino-libre-yeso mc1)))
;       (at start (not(ruta-yeso-libre mc1 MC1-por-MC1))) 
;       ; (at start (not (clinker-libre)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso mc1 MC1-por-MC1)))
;       (at end (molino-libre-yeso mc1))
;       ; (at end (clinker-libre))
;       (at end (ruta-yeso-libre mc1 MC1-por-MC1))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))
;     )
;   )


;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc1))
;       (at start (= ?m mc1)) 
;       (at start (= ?r MC1-por-MC2)) 
;       ; (at start (tarea-yeso-t1-pendiente)) 
;       (at start (libre ?t))
;       (at start (yeso-libre mc1))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc1 ?t yeso MC1-por-MC2))
;       (at start (material-disponible yeso))
;       (at start (molino-libre-yeso mc1))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC2)) 
;       (at start (ruta-yeso-libre mc3 MC3-por-MC2)) 
;       (at start (ruta-yeso-libre mc2 MC2-por-MC2))    
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))

;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (not(yeso-libre mc1)))
;       (at start (alimentando yeso mc1 MC1-por-MC2))
;       (at start (not (molino-libre-yeso mc1)))
;       (at start (not (ruta-yeso-libre mc1 MC1-por-MC2))) ;; bloquea la ruta
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso mc1 MC1-por-MC2)))
;       (at end (molino-libre-yeso mc1))
;       ; (at end (clinker-libre))
;       (at end (yeso-libre mc1))
;       (at end (ruta-yeso-libre mc1 MC1-por-MC2));; bloquea la ruta
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))
;       (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10) (tiempo-vaciado ?t)))) ;; --- CAMBIO AQU
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     )
;   )


; ;; -------------------------------
;   ;; Alimentar yeso MC2
;   ;; -------------------------------
;   (:durative-action alimentar-yeso-mc2-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       ; (at start (ruta-es-mc1-por-mc1 MC1-por-MC1))
;       (at start (en-marcha mc2))
;       (at start (= ?m mc2)) 
;       (at start (= ?r MC2-por-MC2)) 
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc2 ?t yeso ?r))
;       (at start (material-disponible yeso))
;       (at start (molino-libre-yeso mc2))
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;       (at start (ruta-yeso-libre mc2 MC2-por-MC2))
;       (at start (ruta-yeso-libre mc3 MC3-por-MC2))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (alimentando yeso ?m ?r))
;       (at start (not (molino-libre-yeso mc2)))
;       (at start (not(ruta-yeso-libre mc2 MC2-por-MC2))) 
;       (at start (not (yeso-libre mc2)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso ?m ?r)))
;       (at end (yeso-libre mc2))
;       (at end (ruta-yeso-libre mc2 MC2-por-MC2))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     )
;   )

; ;; -------------------------------
;   ;; Alimentar yeso MC3
;   ;; -------------------------------
;     (:durative-action alimentar-yeso-mc3-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc3))
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-por-MC1)) 
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc3 ?t yeso ?r))
;       (at start (material-disponible yeso))
;       (at start (ruta-yeso-libre mc3 ?r))
;       (at start (molino-libre-yeso mc3))
;       (at start (yeso-libre mc3))
;       (at start (molino-libre-clinker mc3))
;       (at start (ruta-yeso-libre mc3 MC3-por-MC1))
;       (at start (ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (alimentando yeso ?m ?r))
;       (at start (not (ruta-yeso-libre mc3 ?r)))
;       (at start (not(molino-libre-yeso mc3)))
;       (at start (not(ruta-yeso-libre mc3 MC3-por-MC1)))
;       (at start (not(yeso-libre mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso ?m ?r)))
;       (at end (molino-libre-yeso mc3))
;       (at end (yeso-libre mc3))
;       (at end (ruta-yeso-libre mc3 MC3-por-MC1))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))
;       (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10) (tiempo-vaciado ?t)))) ;; --- CAMBIO AQU
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       )
;   )


;     (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha mc3))
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-por-MC2)) 
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc3 ?t yeso MC3-por-MC2))
;       (at start (material-disponible yeso))

;       (at start (molino-libre-yeso mc3))
;       ; (at start (yeso-libre mc3))
;       (at start (molino-libre-clinker mc3))
;       (at start (ruta-yeso-libre mc3 MC3-por-MC2))
;       (at start (ruta-yeso-libre mc2 MC2-por-MC2))
;       (at start (ruta-yeso-libre mc1 MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc1 PH-a-MC1-por-MC2))
;       (at start (ruta-puzolana-h-libre mc2 PH-a-426HO04-por-MC2))
;       (at start (ruta-puzolana-s-libre mc3 PS-a-MC3-por-MC2))
;       ; (at start (yeso-libre mc3))  ; Adding back the condition for yeso-libre
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (alimentando yeso mc3 MC3-por-MC2))
;       ; (at start (not (ruta-yeso-libre mc3 ?r)))
;       (at start (not(molino-libre-yeso mc3)))
;       (at start (not(ruta-yeso-libre mc3 MC3-por-MC2)))
;       ; (at start (not(yeso-libre mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso mc3 MC3-por-MC2)))
;       (at end (molino-libre-yeso mc3))
;       ; (at end (yeso-libre mc3))
;       (at end (ruta-yeso-libre mc3 MC3-por-MC2))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (* (tiempo-vaciado ?t) (+ (tiempo-acumulado) 1))))
;       ; (at end (increase (tiempo-acumulado) 1))
;       ; (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10000) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       (at end (increase (costo-total) (+ (* (tiempo-acumulado) 10) (tiempo-vaciado ?t)))) ;; --- CAMBIO AQU
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       )
;   )

; )


;=================================================================

; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     clinker puzolana-h puzolana-s yeso - materia
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
;     PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 MC3-desde-Silo3 - ruta
;   )

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia)
;     (alimentando ?mat - materia ?m - molino ?r - ruta)
    
;     ;; RECURSOS COMPARTIDOS (CUELOS DE BOTELLA)
;     (ruta-la-mc1-ph-y-yeso-libre)    
;     (ruta-la-cinta-mc2-libre)        
;     (ruta-clinker-libre)             
;     (ruta-linea-m3-libre)            
    
;     ;; Recursos de Molino/Material
;     (clinker-libre)
;     (puzolana-s-libre)
;     (puzolana-h-libre)
;     (yeso-libre ?m - molino)
;     (molino-libre-clinker ?m - molino)
;     (molino-libre-pz-seca ?m - molino)
;     (molino-libre-pz-humeda ?m - molino)
;     (molino-libre-yeso ?m - molino)
;   )

;   (:functions
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-vaciado ?t - tolva)
;     (tiempo-acumulado)
;     (costo-total)
;   )

;   ;; -------------------------------
;   ;; ACCIONES CLAVE DE LA LEA COMPARTIDA MC2
;   ;; (Todas usan LA-Cinta-MC2 y tienen la mtrica T + V)
;   ;; -------------------------------

  
  
;   ;; Puzolana-H MC1 por MC2 (V=0.77)
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC2))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc1 ?t puzolana-h ?r))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-pz-humeda mc1))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-pz-humeda mc1))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )


  

;   ;; Puzolana-H 426HO04 por MC2 (V=18.45)
;   (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc2 ?t puzolana-h ?r))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-pz-humeda mc2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-pz-humeda mc2)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-pz-humeda mc2))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

  
;   ;; Yeso MC1 por MC2 (V=0.40)
;   (:durative-action alimentar-yeso-mc1-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-por-MC1))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc1 ?t yeso ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-pz-humeda mc1))
;       (at start (molino-libre-yeso mc1))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-yeso mc1)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-yeso mc1))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Yeso MC1 por MC2 (V=0.40)
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       ; (at start (= ?m mc1))
;       ; (at start (= ?r MC1-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc1 ?t yeso ?r))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso mc1))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc1)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc1))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )



;   ;; Yeso MC1 por MC2 (V=0.40)
;   ; (:durative-action alimentar-yeso-mc2-por-mc2
;   ;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   ;   :duration (= ?duration (duracion-llenado ?t ?r))
;   ;   :condition (and
;   ;     (at start (= ?m mc2))  
;   ;     (at start (= ?r MC2-por-MC2))
;   ;     (at start (libre ?t))
;   ;     (at start (compatible yeso ?t))
;   ;     (at start (ruta-disponible mc2 ?t yeso ?r))
;   ;     (at start (ruta-la-cinta-mc2-libre))
;   ;     (at start (molino-libre-yeso mc2))
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     (at start (not (ruta-la-cinta-mc2-libre)))
;   ;     (at start (not (molino-libre-yeso mc2)))  
;   ;     (at end (alimentado ?t yeso))
;   ;     (at end (libre ?t))
;   ;     (at end (ruta-la-cinta-mc2-libre))
;   ;     (at end (molino-libre-yeso mc2))  
;   ;     ;; MTRICA T + V
;   ;     (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;   ;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;   ;   )
;   ; )

;   ;; Yeso MC3 por MC2 (V=0.01)
;   (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc3 ?t yeso ?r))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso mc3))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc3)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc3))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )


  
;   ;; Puzolana-H MC1 por MC1 (V=0.77) - Lnea NO compartida con MC2
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       ; (at start (= ?m mc1))
;       ; (at start (= ?r PH-a-MC1-por-MC1))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible mc1 ?t puzolana-h ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-pz-humeda mc1))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (molino-libre-pz-humeda mc1)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (molino-libre-pz-humeda mc1))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )
  
;   ;; Acciones de Clinker simplificadas (solo T+V)
;   (:durative-action alimentar-clinker-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible mc1 ?t clinker ?r))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker mc1))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker mc1)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker mc1))
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

; )


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