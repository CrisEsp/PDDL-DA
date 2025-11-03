
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
;     (tiempo-acumulado2) 
;     (costo-total)
;     (prioridad ?t - tolva)
;   )

;   ;; -------------------------------
;   ;; ACCIONES CLAVE DE LA LNEA COMPARTIDA MC2
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

      
;        )
;   )

;   ;; Puzolana-H 426HO04 por MC2 (V=18.45)
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


;   ; (:durative-action alimentar-puzolana-h-426HO04-por-MC2
;   ;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   ;   :duration (= ?duration (duracion-llenado ?t ?r))
;   ;   :condition (and
;   ;     (at start (= ?m mc2))
;   ;     (at start (= ?r PH-a-426HO04-por-MC2))
;   ;     (at start (libre ?t))
;   ;     (at start (compatible puzolana-h ?t))
;   ;     (at start (ruta-disponible ?m ?t puzolana-h ?r))
;   ;     (at start (ruta-la-cinta-mc2-libre))
;   ;     (at start (molino-libre-pz-humeda mc2))
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     (at start (not (ruta-la-cinta-mc2-libre)))
;   ;     (at start (not (molino-libre-pz-humeda mc2)))
;   ;     (at end (alimentado ?t puzolana-h))
;   ;     (at end (libre ?t))
;   ;     (at end (ruta-la-cinta-mc2-libre))
;   ;     (at end (molino-libre-pz-humeda mc2))
;   ;     ;; Acumula solo los vaciados
;   ;     (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;   ;     ;; El costo es el tiempo acumulado DESPUS de agregar este vaciado
;   ;     (at end (increase (costo-total) (tiempo-acumulado)))
;   ;   )
;   ; )

;   ;; Yeso MC1 por MC2 (V=0.40)
;   (:durative-action alimentar-yeso-mc1-por-mc1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-por-MC1))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc1 ?t yeso ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
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
;       (at end (increase (costo-total) (+ (tiempo-acumulado2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado2) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (prioridad ?t)))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t))) 

;     )
;   )
;   ;; Yeso MC1 por MC2 (V=0.40)
;   (:durative-action alimentar-yeso-mc1-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (= ?m mc1))
;       (at start (= ?r MC1-por-MC2))
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

;     (:durative-action alimentar-yeso-mc2-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (= ?m mc2))
;       (at start (= ?r MC2-por-MC2))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible mc2 ?t yeso ?r))
;       (at start (ruta-la-cinta-mc2-libre))
;       (at start (molino-libre-yeso mc2))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-cinta-mc2-libre)))
;       (at start (not (molino-libre-yeso mc2)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-cinta-mc2-libre))
;       (at end (molino-libre-yeso mc2))
;       ;; MTRICA T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     )
;   )

;   ;; Yeso MC3 por MC2 (V=0.01)
;   (:durative-action alimentar-yeso-mc3-por-mc2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r MC3-por-MC2))
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
;         (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;         (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))

;     )
;   )
  
;   ;; Puzolana-H MC1 por MC1 (V=0.77) - Lnea NO compartida con MC2
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC1))
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
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;       ; (at end (increase (costo-total) (tiempo-vaciado ?t)))
;       (at end (increase (costo-total) (+ (tiempo-acumulado2) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado2) (tiempo-vaciado ?t)))



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
;   (:durative-action alimentar-clinker-mc3
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible mc3 ?t clinker ?r))
;       ; (at start (ruta-clinker-libre))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (molino-libre-clinker mc3))

;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       ; (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker mc3)))

;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       ; (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker mc3))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       ; (at end (increase (costo-total) (+ (tiempo-acumulado2) (tiempo-vaciado ?t))))
;       ; (at end (increase (tiempo-acumulado2) (tiempo-vaciado ?t)))
;       (at end (increase (costo-total) (prioridad ?t)))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t))) 


;     )
;   )
; )

; (define (domain test-simple)
;   (:requirements :strips :typing :numeric-fluents)
  
;   (:types tolva - object)
  
;   (:predicates
;     (libre ?t - tolva)
;     (alimentado ?t - tolva)
;   )
  
;   (:functions
;     (tiempo-vaciado ?t - tolva)  ; Tiempo espec de cada tolva
;     (tiempo-total)                ; Tiempo acumulado total
;   )
  
;   (:action vaciar-tolva
;     :parameters (?t - tolva)
;     :precondition (libre ?t)
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t)
;       ; Acumula el tiempo de vaciado de esta tolva especfica
;       (increase (tiempo-total) (tiempo-vaciado ?t))
;     )
;   )
; )


; (define (domain cement-alimentacion-lama)
;   (:requirements :strips :typing :action-costs)
  
;   (:types tolva materia ruta molino)


;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva ?r - ruta)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-mc2-compartida-libre)
;     ;; Contador de posicion
;     (posicion-0)
;     (posicion-1)
;   )

;   (:functions
;     (total-cost)
;     (tiempo-vaciado ?t - tolva)
;   )

;   ;; Primera accion (posicion 0): costo = V * 1
;   (:action alimentar-puzolana-h-pos0
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (libre ?t)
;       (compatible puzolana-h ?t ?r)
;       (ruta-la-mc1-ph-y-yeso-libre)
;       (posicion-0)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t puzolana-h)
;       (not (posicion-0))
;       (posicion-1)
;       ;; Costo = V * 1
;       (increase (total-cost) (tiempo-vaciado ?t))
;     )
;   )

;   (:action alimentar-yeso-pos0
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (libre ?t)
;       (compatible yeso ?t ?r)
;       (ruta-la-mc1-ph-y-yeso-libre)
;       (posicion-0)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t yeso)
;       (not (posicion-0))
;       (posicion-1)
;       ;; Costo = V * 1
;       (increase (total-cost) (tiempo-vaciado ?t))
;     )
;   )

;   ;; Segunda accion (posicion 1): costo = V * 2
;   (:action alimentar-puzolana-h-pos1
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (libre ?t)
;       (compatible puzolana-h ?t ?r)
;       (ruta-la-mc1-ph-y-yeso-libre)
;       (posicion-1)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t puzolana-h)
;       ;; Costo = V * 2 (simula acumulacion)
;       (increase (total-cost) (* 2 (tiempo-vaciado ?t)))
;     )
;   )

;   (:action alimentar-yeso-pos1
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (libre ?t)
;       (compatible yeso ?t ?r)
;       (ruta-la-mc1-ph-y-yeso-libre)
;       (posicion-1)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t yeso)
;       ;; Costo = V * 2 (simula acumulacion)
;       (increase (total-cost) (* 2 (tiempo-vaciado ?t)))
;     )
;   )


;   ; Primera accion (posicion 0): costo = V * 1
;   (:action alimentar-pz-h-mc1-por-mc2-pos0
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (= ?r PH-a-MC1-por-MC2)
;       (libre ?t)
;       (compatible puzolana-h ?t ?r)
;       (ruta-mc2-compartida-libre)
;       (posicion-0)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t puzolana-h)
;       (not (posicion-0))
;       (posicion-1)
;       ;; Costo = V * 1
;       (increase (total-cost) (tiempo-vaciado ?t))
;     )
;   )

;   (:action alimentar-pz-h-mc1-por-mc2-pos1
;     :parameters (?t - tolva ?r - ruta)
;     :precondition (and
;       (= ?r PH-a-MC1-por-MC2)
;       (libre ?t)
;       (compatible puzolana-h ?t ?r)
;       (ruta-mc2-compartida-libre)
;       (posicion-1)
;     )
;     :effect (and
;       (not (libre ?t))
;       (alimentado ?t puzolana-h)
;       ;; Costo = V * 1
;       (increase (total-cost) (* 2 (tiempo-vaciado ?t)))
;     )
;   )
; )



; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
  
;   (:types tolva materia ruta)

;   (:predicates
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (alimentado ?t - tolva ?mat - materia)
;     (ruta-disponible ?t - tolva ?mat - materia ?r - ruta)
;     (ruta-la-mc1-ph-y-yeso-libre)
;   )

;   (:functions
;     (tiempo-vaciado ?t - tolva)
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (tiempo-acumulado)
;     (costo-total)
;   )

;   ;; Accion durativa: Puzolana-H MC1 por MC1
;   (:durative-action alimentar-puzolana-h-MC1-por-MC1
;     :parameters (?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?t puzolana-h ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at end (alimentado ?t puzolana-h))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       ;; Metrica T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )

;   ;; Accion durativa: Yeso MC1 por MC1
;   (:durative-action alimentar-yeso-mc1-por-mc1
;     :parameters (?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (libre ?t))
;       (at start (compatible yeso ?t))
;       (at start (ruta-disponible ?t yeso ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       ;; Metrica T + V
;       (at end (increase (costo-total) (+ (tiempo-acumulado) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado) (tiempo-vaciado ?t)))
;     )
;   )
; )




; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 - ruta
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




(define (domain cement-alimentacion-durativo)
  (:requirements :durative-actions :typing :numeric-fluents :equality)
  
  (:types molino tolva materia ruta)

  (:constants
    mc1 mc2 mc3 - molino
    puzolana-h yeso clinker - materia
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3 - ruta
  )

  (:predicates
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (alimentado ?t - tolva ?mat - materia)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    
    ;; Recursos compartidos
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    
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
      ;; Metrica T + V para linea MC1
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
      ;; Metrica T + V para linea MC1
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
    )
  )

  
    (:durative-action alimentar-clinker-mc3-desde-silo3
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc3))
      (at start (= ?r MC3-desde-Silo3))
      (at start (libre ?t))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (ruta-la-mc1-ph-y-yeso-libre))
      (at start (molino-libre-clinker ?m))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
      (at start (not (molino-libre-clinker ?m)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (ruta-la-mc1-ph-y-yeso-libre))
      (at end (molino-libre-clinker ?m))
      ;; Metrica T + V para linea MC1
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
    )
  )
  ;; ========================================
  ;; ACCIONES LINEA MC2 (COMPARTIDA - No simultaneas)
  ;; ========================================

  ;; Puzolana-H MC1 por MC2
  (:durative-action alimentar-puzolana-h-MC1-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (= ?m mc1))
      (at start (= ?r PH-a-MC1-por-MC2))
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
      ;; Metrica T + V para linea MC2
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )

  ;; Puzolana-H 426HO04 por MC2
  (:durative-action alimentar-puzolana-h-426HO04-por-MC2
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      ; (at start (= ?m mc2))
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
      ;; Metrica T + V para linea MC2
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
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
      ;; Metrica T + V para linea MC2
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
      ;; Metrica T + V para linea MC2
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
      ;; Metrica T + V para linea MC2
      (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
      (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))
    )
  )
)




; ;; ========================================
; ;; DOMINIO
; ;; ========================================

; (define (domain cement-alimentacion-durativo)
;   (:requirements :durative-actions :typing :numeric-fluents :equality)
  
;   (:types molino tolva materia ruta)

;   (:constants
;     mc1 mc2 mc3 - molino
;     puzolana-h yeso clinker - materia
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2
;     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC2 MC3-desde-Silo3
;     MC1-desde-Pretrit MC2-desde-Pretrit Silo3-desde-Pretrit - ruta
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
;     (tiempo-acumulado-3)  ;; Added new accumulated time function
;     (tiempo-acumulado-4)  ;; Added new accumulated time function
;     (tiempo-acumulado-ck)  ;; Added new accumulated time function for clinker
;     ; (tiempo-acumulado-ck3)
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
;       ;; Metrica: T + V (OPTIC interpreta asi la suma)
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc1) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-mc1) (tiempo-vaciado ?t)))
;     )
;   )


;   ;; Puzolana-H MC1 por MC1
;   (:durative-action alimentar-puzolana-h-MC1-por-MC2
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc1))
;       (at start (= ?r PH-a-MC1-por-MC2))
;       (at start (libre ?t))
;       (at start (compatible puzolana-h ?t))
;       (at start (ruta-disponible ?m ?t puzolana-h ?r))
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
;       (at end (increase (tiempo-acumulado-mc2) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
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
;       (at end (increase (costo-total) (+ (tiempo-acumulado-mc2) (tiempo-vaciado ?t))))
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


;   ;; Clinker MC3 desde Silo3
;   (:durative-action alimentar-clinker-Silo3-desde-pretrit
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (= ?m mc3))
;       (at start (= ?r Silo3-desde-Pretrit))  ;; Updated route name
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (ruta-la-mc1-ph-y-yeso-libre))
;       (at start (ruta-clinker-libre))
;       (at start (molino-libre-clinker ?m))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (not (ruta-la-mc1-ph-y-yeso-libre)))
;       (at start (not (ruta-clinker-libre)))
;       (at start (not (molino-libre-clinker ?m)))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (ruta-la-mc1-ph-y-yeso-libre))
;       (at end (ruta-clinker-libre))
;       (at end (molino-libre-clinker ?m))
;       (at end (increase (costo-total) (+ (tiempo-acumulado-ck) (tiempo-vaciado ?t))))
;       (at end (increase (tiempo-acumulado-ck) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
;     )
;   )
  
;   ; ;; Clinker MC3 desde Silo3
;   ; (:durative-action alimentar-clinker-mc3-desde-silo3
;   ;   :parameters (?m - molino ?t - tolva ?r - ruta)
;   ;   :duration (= ?duration (duracion-llenado ?t ?r))
;   ;   :condition (and
;   ;     (at start (= ?m mc3))
;   ;     (at start (= ?r MC3-desde-Silo3))
;   ;     (at start (libre ?t))
;   ;     (at start (compatible clinker ?t))
;   ;     (at start (ruta-disponible ?m ?t clinker ?r))
;   ;     ; (at start (molino-libre-clinker ?m))
;   ;   )
;   ;   :effect (and
;   ;     (at start (not (libre ?t)))
;   ;     ; (at start (not (molino-libre-clinker ?m)))
;   ;     (at end (alimentado ?t clinker))
;   ;     (at end (libre ?t))
;   ;     ; (at end (ruta-clinker-libre))
;   ;     ; (at end (molino-libre-clinker ?m))
;   ;     (at end (increase (costo-total) (+ (tiempo-acumulado-ck3) (tiempo-vaciado ?t))))
;   ;     (at end (increase (tiempo-acumulado-ck3) (tiempo-vaciado ?t)))  ;; Updated to reflect the correct metric
;   ;   )
;   ; )
; )



