; ;; ========================================
; ;; PROBLEMA
; ;; ========================================

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-clinker t2-clinker 
;     t1-puzolana-h t1-yeso t2-puzolana-h 
;     t3-puzolana-s
;     t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
;     (libre t2-puzolana-h)
;     (libre t3-puzolana-s)
;     (libre t2-yeso)
;     (libre t3-yeso)
;     (libre t3-clinker)
;     (libre t3-clinker-SB) ;; Tolva adicional para clinker SB
;     (libre t1-clinker)
;     (libre t2-clinker)
    
;     ;; Recursos compartidos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)  ;; Added new predicate for common feeding of MC3
    
;     ;; Recursos de molino disponibles
;     (molino-libre-pz-humeda mc1)
;     (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1)
;     (molino-libre-yeso mc2)
;     (molino-libre-yeso mc3)
;     (molino-libre-clinker mc3)
    
;     (molino-libre-clinker mc1)    
;     (molino-libre-clinker mc2)
;     (molino-libre-pz-seca mc3)  
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
;     (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t3-puzolana-s)
;     (compatible yeso t2-yeso)
;     (compatible yeso t3-yeso)
;     (compatible clinker t3-clinker)
;     (compatible clinker t1-clinker)
;     (compatible clinker t2-clinker)
;     (compatible clinker t3-clinker-SB)  ;; Added compatibility for new tolva
;     ;; Rutas disponibles - LINEA MC1
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    
;     ;; Rutas disponibles - LINEA MC2 (COMPARTIDA)
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)

;     ;; Ruta MC3 - Clinker (USA ruta-la-mc1-ph-y-yeso-libre, NO simultanea)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)  ;; Added new route for t2-clinker
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)  ;; Added new route for t2-clinker
;     (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)  ;; Fixed indentation
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     ;; Duraciones de llenado (tiempo real de llenado)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 2)  ;; Updated to reflect the correct route
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)  ;; Updated to reflect the correct route
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)  ;; Added new duration for t2-clinker
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)  ;; Fixed typo for t3-clinker-SB
;     (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)

;     (= (tiempo-vaciado t2-puzolana-h) 3.8)   ;; MAS URGENTE
;     (= (tiempo-vaciado t3-yeso) 3.7)
;     (= (tiempo-vaciado t2-yeso) 3.5)
;     (= (tiempo-vaciado t1-puzolana-h) 1.4)
;     (= (tiempo-vaciado t1-yeso) 4.2)         ;; MENOS URGENTE
;     (= (tiempo-vaciado t1-clinker) 5.7)      ;; Assumed value
;     (= (tiempo-vaciado t2-clinker) 0.7)      ;; Assumed value
;     (= (tiempo-vaciado t3-clinker) 5.0)      ;; Assumed value
;     (= (tiempo-vaciado t3-clinker-SB) 1.7)      ;; Assumed value for new tolva
;     (= (tiempo-vaciado t3-puzolana-s) 2.4)
;     ;; Inicializacion de acumuladores por linea
;     (= (tiempo-acumulado-mc1) 0)                                                                                                                                                                                                                                                    
;     (= (tiempo-acumulado-mc2) 0)
;     ; ; (= (tiempo-acumulado-3) 0)  ;; Added initialization for new accumulated time)
;     ; ; (= (tiempo-acumulado-4) 0)  ;; Added initialization for new accumulated time)
;     (= (tiempo-acumulado-ck) 0)  ;; Added initialization for clinker)
;     ; (= (tiempo-acumulado-ck3) 0)  ;; Added initialization for clinker)
;     (= (costo-auxiliar) 0)


;     (= (costo-total) 0)
;   )
  
;   (:goal (and
;     ; (alimentado t1-puzolana-h puzolana-h)
;     ; (alimentado t1-yeso yeso)
;     ; (alimentado t2-puzolana-h puzolana-h)
;     ; (alimentado t2-yeso yeso)
;     (alimentado t3-yeso yeso)
;     (alimentado t3-puzolana-s puzolana-s)
;     (alimentado t3-clinker clinker)
;     ; (alimentado t1-clinker clinker) 
;     ; (alimentado t2-clinker clinker)
;     ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva

;   ))
  
;   ; (:metric minimize (costo-total))
;   ; (:metric minimize (+ (* 0.06 (costo-total)) (total-time)))
;   ; (:metric minimize (+ (* 0.06 (costo-total)) (* 2 (total-time))))
;   (:metric minimize (+ (* 0.06 (costo-total)) (* 2 (total-time))))
; )
  



; ;; ========================================
; ;; PROBLEMA
; ;; ========================================

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-clinker t2-clinker 
;     t1-puzolana-h t1-yeso t2-puzolana-h 
;     t3-puzolana-s t2-puzolana-s
;     t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
;     (libre t2-puzolana-h)
;     (libre t2-puzolana-s)
;     (libre t3-puzolana-s)
;     (libre t2-yeso)
;     (libre t3-yeso)
;     (libre t3-clinker)
;     (libre t3-clinker-SB)
;     (libre t1-clinker)
;     (libre t2-clinker)
    

;     ;; Asignaciones fijas tolva-molino
;     (tolva-asignada t1-puzolana-h mc1)
;     (tolva-asignada t1-yeso mc1)
;     (tolva-asignada t1-clinker mc1)
;     (tolva-asignada t2-puzolana-h mc2)
;     (tolva-asignada t2-yeso mc2)
;     (tolva-asignada t2-clinker mc2)
;     (tolva-asignada t2-puzolana-s mc2)
;     (tolva-asignada t3-puzolana-s mc3)
;     (tolva-asignada t3-yeso mc3)
;     (tolva-asignada t3-clinker mc3)
;     (tolva-asignada t3-clinker-SB mc3)
    
;     ;; Recursos compartidos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
;     ; (usando-mc1-en-clinker)
;     ;; Recursos de molino disponibles
;     (molino-libre-pz-humeda mc1)
;     (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1)
;     (molino-libre-yeso mc2)
;     (molino-libre-yeso mc3)
;     (molino-libre-clinker mc3)
;     (molino-libre-clinker mc1)    
;     (molino-libre-clinker mc2)
;     (molino-libre-pz-seca mc3)  
;     (molino-libre-pz-seca mc2)  
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
;     (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t3-puzolana-s)
;     (compatible puzolana-s t2-puzolana-s)
;     (compatible yeso t2-yeso)
;     (compatible yeso t3-yeso)
;     (compatible clinker t3-clinker)
;     (compatible clinker t1-clinker)
;     (compatible clinker t2-clinker)
;     (compatible clinker t3-clinker-SB)
    
;     ;; Rutas disponibles - LINEA MC2 (COMPARTIDA)
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     ; (ruta-disponible mc3 t3-yeso yeso MC3-por-MC1)
;     ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
;     ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
;     (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)


;     ;; Duraciones de llenado (tiempo real de llenado)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC1) 9)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)
;     (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)
;     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)

;     (= (tiempo-vaciado t2-puzolana-h) 3.0)
;     (= (tiempo-vaciado t2-puzolana-s) 1.8)
;     (= (tiempo-vaciado t3-yeso) 2.4)
;     (= (tiempo-vaciado t2-yeso) 1.5)
;     (= (tiempo-vaciado t1-puzolana-h) 0.6)
;     (= (tiempo-vaciado t1-yeso) 0.4)
;     (= (tiempo-vaciado t1-clinker) 5.7)
;     (= (tiempo-vaciado t2-clinker) 0.7)
;     (= (tiempo-vaciado t3-clinker) 1.0)
;     (= (tiempo-vaciado t3-clinker-SB) 1.7)
;     (= (tiempo-vaciado t3-puzolana-s) 0.6)
    
;     ;; Inicializacion de acumuladores por linea
;     (= (tiempo-acumulado-mc1) 0)                                                                                                                                                                                                                                                    
;     (= (tiempo-acumulado-mc2) 0)
;     (= (tiempo-acumulado-mc3) 0)
;     (= (tiempo-acumulado-ck) 0)
;     (= (tiempo-acumulado-pz-seca) 0)
;     ; (= (costo-auxiliar) 0)
;     (= (costo-total) 0)
;   )
  
;   (:goal (and
;     ; (alimentado t1-puzolana-h puzolana-h)
;     ; (alimentado t1-yeso yeso)
;     ; (alimentado t2-puzolana-h puzolana-h)
;     (alimentado t2-yeso yeso)
;     ; (alimentado t3-puzolana-s puzolana-s)
;     ; (alimentado t1-clinker clinker) 
;     ; (alimentado t3-clinker clinker)  
;     (alimentado t3-yeso yeso)
;     ; (alimentado t2-clinker clinker)
;     ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
;     ; (alimentado t2-puzolana-s puzolana-s)
;   ))
  
;   (:metric minimize (+ (* 1.5 (costo-total)) (* 10 (total-time))))

; )




; ;; ========================================
; ;; PROBLEMA ok casi
; ;; ========================================

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-clinker t2-clinker 
;     t1-puzolana-h t1-yeso t2-puzolana-h 
;     t3-puzolana-s t2-puzolana-s
;     t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
;     (libre t2-puzolana-h)
;     (libre t2-puzolana-s)
;     (libre t3-puzolana-s)
;     (libre t2-yeso)
;     (libre t3-yeso)
;     (libre t3-clinker)
;     (libre t3-clinker-SB)
;     (libre t1-clinker)
;     (libre t2-clinker)
    

;     ;; Asignaciones fijas tolva-molino
;     (tolva-asignada t1-puzolana-h mc1)
;     (tolva-asignada t1-yeso mc1)
;     (tolva-asignada t1-clinker mc1)
;     (tolva-asignada t2-puzolana-h mc2)
;     (tolva-asignada t2-yeso mc2)
;     (tolva-asignada t2-clinker mc2)
;     (tolva-asignada t2-puzolana-s mc2)
;     (tolva-asignada t3-puzolana-s mc3)
;     (tolva-asignada t3-yeso mc3)
;     (tolva-asignada t3-clinker mc3)
;     (tolva-asignada t3-clinker-SB mc3)
    
;     ;; Recursos compartidos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
;     ; (usando-mc1-en-clinker)
;     ;; Recursos de molino disponibles
;     (molino-libre-pz-humeda mc1)
;     (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1)
;     (molino-libre-yeso mc2)
;     (molino-libre-yeso mc3)
;     (molino-libre-clinker mc3)
;     (molino-libre-clinker mc1)    
;     (molino-libre-clinker mc2)
;     (molino-libre-pz-seca mc3)  
;     (molino-libre-pz-seca mc2)  
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
;     (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t3-puzolana-s)
;     (compatible puzolana-s t2-puzolana-s)
;     (compatible yeso t2-yeso)
;     (compatible yeso t3-yeso)
;     (compatible clinker t3-clinker)
;     (compatible clinker t1-clinker)
;     (compatible clinker t2-clinker)
;     (compatible clinker t3-clinker-SB)
    
;     ;; Rutas disponibles - LINEA MC2 (COMPARTIDA)
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     ; (ruta-disponible mc3 t3-yeso yeso MC3-por-MC1)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
;     (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)

;     ;; Duraciones de llenado (tiempo real de llenado)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC1) 9)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)
;     (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)
;     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)

;     (= (tiempo-vaciado t2-puzolana-h) 0.1)
;     (= (tiempo-vaciado t2-puzolana-s) 0.8)
;     (= (tiempo-vaciado t3-yeso) 6.0)
;     (= (tiempo-vaciado t2-yeso) 2.0)
;     (= (tiempo-vaciado t1-puzolana-h) 0.9)
;     (= (tiempo-vaciado t1-yeso) 0.6)
;     (= (tiempo-vaciado t1-clinker) 5.7)
;     (= (tiempo-vaciado t2-clinker) 4.7)
;     (= (tiempo-vaciado t3-clinker) 4.0)
;     (= (tiempo-vaciado t3-clinker-SB) 1.7)
;     (= (tiempo-vaciado t3-puzolana-s) 0.0)    ;; Pz y Yeso 3 poner diferencia de 0.3
    
;     ;; Inicializacion de acumuladores por linea
;     (= (tiempo-acumulado-mc1) 0)                                                                                                                                                                                                                                                    
;     (= (tiempo-acumulado-mc2) 0)
;     (= (tiempo-acumulado-mc3) 0)
;     (= (tiempo-acumulado-ck) 0)
;     (= (tiempo-acumulado-pz-seca) 0)
;     (= (costo-tiempo-compartido) 0)
;   )
  
;   (:goal (and
;     ; (alimentado t1-puzolana-h puzolana-h)
;     ; (alimentado t1-yeso yeso)
;     (alimentado t2-puzolana-h puzolana-h)
;     (alimentado t2-yeso yeso)
;     ; (alimentado t3-yeso yeso)
;     ; (alimentado t3-puzolana-s puzolana-s)
;     ; (alimentado t1-clinker clinker) 
;     ; (alimentado t3-clinker clinker)  

;     ; (alimentado t2-clinker clinker)
;     ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
;     ; (alimentado t2-puzolana-s puzolana-s)
;   ))
  
;   ; (:metric minimize (+ 
;   ;   (* 1.5 (tiempo-acumulado-mc1))
;   ;   (* 1.5 (tiempo-acumulado-mc2))
;   ;   (* 1.5 (tiempo-acumulado-mc3))
;   ;   (* 1.5 (tiempo-acumulado-ck))
;   ;   (* 1.5 (tiempo-acumulado-pz-seca))
;   ;   (* 0.001 (costo-tiempo-compartido))
;   ;   (* 10 (total-time))
;   ; ))

;   (:metric minimize (+ 
;   (* 0.01 (tiempo-acumulado-mc1))
;   (* 0.01 (tiempo-acumulado-mc2))
;   (* 0.01 (tiempo-acumulado-mc3))
;   (* 0.01 (tiempo-acumulado-ck))
;   (* 0.01 (tiempo-acumulado-pz-seca))
;   (* 0.04 (costo-tiempo-compartido))
;   (* 100 (total-time))
;   ))
; )




; ;; ========================================
; ;; PROBLEMA CON PRIORIDAD-BASE
; ;; ========================================

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-clinker t2-clinker 
;     t1-puzolana-h t1-yeso t2-puzolana-h 
;     t3-puzolana-s t2-puzolana-s
;     t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
;     (libre t2-puzolana-h)
;     (libre t2-puzolana-s)
;     (libre t3-puzolana-s)
;     (libre t2-yeso)
;     (libre t3-yeso)
;     (libre t3-clinker)
;     (libre t3-clinker-SB)
;     (libre t1-clinker)
;     (libre t2-clinker)
    
;     ;; Asignaciones fijas tolva-molino
;     (tolva-asignada t1-puzolana-h mc1)
;     (tolva-asignada t1-yeso mc1)
;     (tolva-asignada t1-clinker mc1)
;     (tolva-asignada t2-puzolana-h mc2)
;     (tolva-asignada t2-yeso mc2)
;     (tolva-asignada t2-clinker mc2)
;     (tolva-asignada t2-puzolana-s mc2)
;     (tolva-asignada t3-puzolana-s mc3)
;     (tolva-asignada t3-yeso mc3)
;     (tolva-asignada t3-clinker mc3)
;     (tolva-asignada t3-clinker-SB mc3)
    
;     ;; Recursos compartidos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
    
;     ;; Recursos de molino disponibles
;     (molino-libre-pz-humeda mc1)
;     (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1)
;     (molino-libre-yeso mc2)
;     (molino-libre-yeso mc3)
;     (molino-libre-clinker mc3)
;     (molino-libre-clinker mc1)    
;     (molino-libre-clinker mc2)
;     (molino-libre-pz-seca mc3)  
;     (molino-libre-pz-seca mc2)  
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
;     (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t3-puzolana-s)
;     (compatible puzolana-s t2-puzolana-s)
;     (compatible yeso t2-yeso)
;     (compatible yeso t3-yeso)
;     (compatible clinker t3-clinker)
;     (compatible clinker t1-clinker)
;     (compatible clinker t2-clinker)
;     (compatible clinker t3-clinker-SB)
    
;     ;; Rutas disponibles
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
;     (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)

;     ;; Duraciones de llenado (tiempo real de llenado)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC1) 9)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)
;     (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)
;     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)

;     ;; Tiempos de vaciado
;     (= (tiempo-vaciado t2-puzolana-h) 0.1)
;     (= (tiempo-vaciado t2-puzolana-s) 0.8)
;     (= (tiempo-vaciado t3-yeso) 6.0)
;     (= (tiempo-vaciado t2-yeso) 2.0)
;     (= (tiempo-vaciado t1-puzolana-h) 0.9)
;     (= (tiempo-vaciado t1-yeso) 0.6)
;     (= (tiempo-vaciado t1-clinker) 5.7)
;     (= (tiempo-vaciado t2-clinker) 4.7)
;     (= (tiempo-vaciado t3-clinker) 4.0)
;     (= (tiempo-vaciado t3-clinker-SB) 1.7)
;     (= (tiempo-vaciado t3-puzolana-s) 0.0)

;     ;; ========================================
;     ;; PRIORIDADES BASADAS EN TIEMPO-VACIADO
;     ;; Regla: Menor tiempo-vaciado = Mayor prioridad (valor 100)
;     ;; ========================================
;     ;; MC2 - Linea compartida
;     (= (prioridad-base t2-puzolana-h) 100)   ;; tiempo-vaciado 0.1 - ALTA PRIORIDAD
;     (= (prioridad-base t2-yeso) 50)          ;; tiempo-vaciado 2.0 - BAJA PRIORIDAD
;     (= (prioridad-base t3-puzolana-s) 100)   ;; tiempo-vaciado 0.0 - MUY ALTA PRIORIDAD
;     (= (prioridad-base t3-yeso) 60)          ;; tiempo-vaciado 6.0 - BAJA PRIORIDAD
    
;     ;; Otras tolvas - mismo nivel
;     (= (prioridad-base t1-puzolana-h) 80)
;     (= (prioridad-base t1-yeso) 70)
;     (= (prioridad-base t1-clinker) 75)
;     (= (prioridad-base t2-clinker) 75)
;     (= (prioridad-base t3-clinker) 75)
;     (= (prioridad-base t2-puzolana-s) 65)
;     (= (prioridad-base t3-clinker-SB) 75)
    
;     ;; Inicializacion de acumuladores
;     (= (tiempo-acumulado-mc1) 0)
;     (= (tiempo-acumulado-mc2) 0)
;     (= (tiempo-acumulado-mc3) 0)
;     (= (tiempo-acumulado-ck) 0)
;     (= (tiempo-acumulado-pz-seca) 0)
;     (= (costo-tiempo-compartido) 0)
;     (= (costo-por-prioridad) 0)
;   )
  
;   (:goal (and

;     (alimentado t1-puzolana-h puzolana-h)
;     (alimentado t1-yeso yeso)
;     (alimentado t2-puzolana-h puzolana-h)
;     (alimentado t2-yeso yeso)
;     ; (alimentado t3-yeso yeso)
;     ; (alimentado t3-puzolana-s puzolana-s)
;     ; (alimentado t1-clinker clinker) 
;     ; (alimentado t3-clinker clinker)  

;     ; (alimentado t2-clinker clinker)
;     ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
;     ; (alimentado t2-puzolana-s puzolana-s)

;   ))
  
;   (:metric minimize (+ 
;     (* 0.01 (tiempo-acumulado-mc1))
;     (* 0.01 (tiempo-acumulado-mc2))
;     (* 0.01 (tiempo-acumulado-mc3))
;     (* 0.01 (tiempo-acumulado-ck))
;     (* 0.01 (tiempo-acumulado-pz-seca))
;     (* 0.04 (costo-tiempo-compartido))
;     (* 0.5 (costo-por-prioridad))
;     (* 10 (total-time))
;   ))
; )


; ;; ========================================
; ;; PROBLEMA CON PRIORIDAD-BASE AUTOMATICA
; ;; ========================================

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-clinker t2-clinker 
;     t1-puzolana-h t1-yeso t2-puzolana-h 
;     t3-puzolana-s t2-puzolana-s
;     t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
;     (libre t2-puzolana-h)
;     (libre t2-puzolana-s)
;     (libre t3-puzolana-s)
;     (libre t2-yeso)
;     (libre t3-yeso)
;     (libre t3-clinker)
;     (libre t3-clinker-SB)
;     (libre t1-clinker)
;     (libre t2-clinker)
    
;     ;; Asignaciones fijas tolva-molino
;     (tolva-asignada t1-puzolana-h mc1)
;     (tolva-asignada t1-yeso mc1)
;     (tolva-asignada t1-clinker mc1)
;     (tolva-asignada t2-puzolana-h mc2)
;     (tolva-asignada t2-yeso mc2)
;     (tolva-asignada t2-clinker mc2)
;     (tolva-asignada t2-puzolana-s mc2)
;     (tolva-asignada t3-puzolana-s mc3)
;     (tolva-asignada t3-yeso mc3)
;     (tolva-asignada t3-clinker mc3)
;     (tolva-asignada t3-clinker-SB mc3)
    
;     ;; Recursos compartidos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-mc3-compartida-libre)
;     (alimentando-mc3-comun)
    
;     ;; Recursos de molino disponibles
;     (molino-libre-pz-humeda mc1)
;     (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1)
;     (molino-libre-yeso mc2)
;     (molino-libre-yeso mc3)
;     (molino-libre-clinker mc3)
;     (molino-libre-clinker mc1)    
;     (molino-libre-clinker mc2)
;     (molino-libre-pz-seca mc3)  
;     (molino-libre-pz-seca mc2)  
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
;     (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t3-puzolana-s)
;     (compatible puzolana-s t2-puzolana-s)
;     (compatible yeso t2-yeso)
;     (compatible yeso t3-yeso)
;     (compatible clinker t3-clinker)
;     (compatible clinker t1-clinker)
;     (compatible clinker t2-clinker)
;     (compatible clinker t3-clinker-SB)
    
;     ;; Rutas disponibles
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
;     (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)

;     ;; Duraciones de llenado
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC1) 9)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)
;     (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)
;     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)

;     ;; Tiempos de vaciado
;     (= (tiempo-vaciado t2-puzolana-h) 0.1)
;     (= (tiempo-vaciado t2-puzolana-s) 0.8)
;     (= (tiempo-vaciado t3-yeso) 6.0)
;     (= (tiempo-vaciado t2-yeso) 2.0)
;     (= (tiempo-vaciado t1-puzolana-h) 0.9)
;     (= (tiempo-vaciado t1-yeso) 0.6)
;     (= (tiempo-vaciado t1-clinker) 5.7)
;     (= (tiempo-vaciado t2-clinker) 4.7)
;     (= (tiempo-vaciado t3-clinker) 4.0)
;     (= (tiempo-vaciado t3-clinker-SB) 1.7)
;     (= (tiempo-vaciado t3-puzolana-s) 0.0)

;     ;; PRIORIDADES AUTOMATICAS
;     ;; Formula: prioridad = 100 - (tiempo-vaciado * 100)
;     ;; PRIORIDADES - Precalculadas (100 - tiempo-vaciado*100)
;     ;; Menor tiempo-vaciado = Mayor prioridad
;     (= (prioridad-base t2-puzolana-h) 90)      ;; 100 - (0.1*100)
;     (= (prioridad-base t2-yeso) -100)          ;; 100 - (2.0*100)
;     (= (prioridad-base t3-puzolana-s) 100)     ;; 100 - (0.0*100)
;     (= (prioridad-base t3-yeso) -500)          ;; 100 - (6.0*100)
;     (= (prioridad-base t1-puzolana-h) 10)      ;; 100 - (0.9*100)
;     (= (prioridad-base t1-yeso) 40)            ;; 100 - (0.6*100)
;     (= (prioridad-base t1-clinker) -470)       ;; 100 - (5.7*100)
;     (= (prioridad-base t2-clinker) -370)       ;; 100 - (4.7*100)
;     (= (prioridad-base t3-clinker) -300)       ;; 100 - (4.0*100)
;     (= (prioridad-base t2-puzolana-s) 20)      ;; 100 - (0.8*100)
;     (= (prioridad-base t3-clinker-SB) -70)     ;; 100 - (1.7*100)
;     ;; Inicializacion acumuladores
;     (= (tiempo-acumulado-mc1) 0)
;     (= (tiempo-acumulado-mc2) 0)
;     (= (tiempo-acumulado-mc3) 0)
;     (= (tiempo-acumulado-ck) 0)
;     (= (tiempo-acumulado-pz-seca) 0)
;     (= (costo-tiempo-compartido) 0)
;     (= (costo-por-prioridad) 0)
;     (= (costo-tiempo-compartido-mc2) 0)
;     (= (costo-tiempo-compartido-mc3) 0)
;   )
  
;   (:goal (and
;     (alimentado t1-puzolana-h puzolana-h)
;     (alimentado t1-yeso yeso)
;     (alimentado t2-puzolana-h puzolana-h)
;     (alimentado t2-yeso yeso)
;     (alimentado t3-yeso yeso)
;     (alimentado t3-puzolana-s puzolana-s)
;     ; (alimentado t1-clinker clinker) 
;     ; (alimentado t3-clinker clinker)  

;     ; (alimentado t2-clinker clinker)
;     ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
;     ; (alimentado t2-puzolana-s puzolana-s)

;   ))
  
;   (:metric minimize (+ 
;     (* 0.01 (tiempo-acumulado-mc1))
;     (* 0.01 (tiempo-acumulado-mc2))
;     (* 0.01 (tiempo-acumulado-mc3))
;     (* 0.01 (tiempo-acumulado-ck))
;     (* 0.01 (tiempo-acumulado-pz-seca))
;     (* 0.04 (costo-tiempo-compartido))
;     (* 0.04 (costo-tiempo-compartido-mc2))   
;     (* 0.04 (costo-tiempo-compartido-mc3))   
;     (* 10 (total-time))
;   ))
; )



;; ========================================
;; PROBLEMA CON ACUMULADORES MC1+MC2+MC3
;; ========================================

(define (problem cement-test-durativo)
  (:domain cement-alimentacion-durativo)
  
  (:objects
    t1-clinker t2-clinker 
    t1-puzolana-h t1-yeso t2-puzolana-h 
    t3-puzolana-s t2-puzolana-s
    t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
  )
  
  (:init
    (libre t1-puzolana-h)
    (libre t1-yeso)
    (libre t2-puzolana-h)
    (libre t2-puzolana-s)
    (libre t3-puzolana-s)
    (libre t2-yeso)
    (libre t3-yeso)
    (libre t3-clinker)
    (libre t3-clinker-SB)
    (libre t1-clinker)
    (libre t2-clinker)
    
    (tolva-asignada t1-puzolana-h mc1)
    (tolva-asignada t1-yeso mc1)
    (tolva-asignada t1-clinker mc1)
    (tolva-asignada t2-puzolana-h mc2)
    (tolva-asignada t2-yeso mc2)
    (tolva-asignada t2-clinker mc2)
    (tolva-asignada t2-puzolana-s mc2)
    (tolva-asignada t3-puzolana-s mc3)
    (tolva-asignada t3-yeso mc3)
    (tolva-asignada t3-clinker mc3)
    (tolva-asignada t3-clinker-SB mc3)
    
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    (ruta-mc3-compartida-libre)
    (alimentando-mc3-comun)
    
    (molino-libre-pz-humeda mc1)
    (molino-libre-pz-humeda mc2)
    (molino-libre-yeso mc1)
    (molino-libre-yeso mc2)
    (molino-libre-yeso mc3)
    (molino-libre-clinker mc3)
    (molino-libre-clinker mc1)    
    (molino-libre-clinker mc2)
    (molino-libre-pz-seca mc3)  
    (molino-libre-pz-seca mc2)  
    
    (compatible puzolana-h t1-puzolana-h)
    (compatible yeso t1-yeso)
    (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t3-puzolana-s)
    (compatible puzolana-s t2-puzolana-s)
    (compatible yeso t2-yeso)
    (compatible yeso t3-yeso)
    (compatible clinker t3-clinker)
    (compatible clinker t1-clinker)
    (compatible clinker t2-clinker)
    (compatible clinker t3-clinker-SB)
    
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
    (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
    (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
    (ruta-disponible mc3 t3-clinker-SB clinker Silo3-desde-Pretrit)
    (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)

    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 2)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 9)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)
    (= (duracion-llenado t3-clinker MC3-desde-Silo3) 7)
    (= (duracion-llenado t3-clinker-SB Silo3-desde-Pretrit) 7)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)

    (= (tiempo-vaciado t2-puzolana-h) 1.9)
    (= (tiempo-vaciado t2-puzolana-s) 0.8)
    (= (tiempo-vaciado t3-yeso) 1.3)
    (= (tiempo-vaciado t2-yeso) 1.0)
    (= (tiempo-vaciado t1-puzolana-h) 0.9)
    (= (tiempo-vaciado t1-yeso) 0.0)
    (= (tiempo-vaciado t1-clinker) 5.5)
    (= (tiempo-vaciado t2-clinker) 5.4)
    (= (tiempo-vaciado t3-clinker) 4.0)
    (= (tiempo-vaciado t3-clinker-SB) 1.7)
    (= (tiempo-vaciado t3-puzolana-s) 0.1)

    (= (tiempo-acumulado-mc1) 0)
    (= (tiempo-acumulado-mc2) 0)
    (= (tiempo-acumulado-mc3) 0)
    (= (tiempo-acumulado-ck) 0)
    (= (tiempo-acumulado-pz-seca) 0)
    (= (costo-tiempo-compartido-mc1) 0)
    (= (costo-tiempo-compartido-mc2) 0)
    (= (costo-tiempo-compartido-mc3) 0)
    ; (= (costo-tiempo-compartido-ck) 0) 
    ; (= (costo-tiempo-compartido-pz-seca) 0)
  )
      
  
  (:goal (and
    ; (alimentado t1-puzolana-h puzolana-h)
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t2-yeso yeso)
    (alimentado t3-yeso yeso)
    (alimentado t3-puzolana-s puzolana-s)

    ; (alimentado t1-clinker clinker) 
    ; (alimentado t3-clinker clinker)  
    ; (alimentado t2-clinker clinker)
    ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
;     ; (alimentado t2-puzolana-s puzolana-s)

  ))
  
  (:metric minimize (+ 
  (* 0.01 (tiempo-acumulado-mc1))
  (* 0.01 (tiempo-acumulado-mc2))
  (* 0.01 (tiempo-acumulado-mc3))
  (* 0.01 (tiempo-acumulado-ck))
  (* 0.01 (tiempo-acumulado-pz-seca))
  (* 0.01 (costo-tiempo-compartido-mc1))   
  (* 0.04 (costo-tiempo-compartido-mc2))  
  (* 0.15 (costo-tiempo-compartido-mc3))   
  ; (* 0.15 (costo-tiempo-compartido-ck)) 
  ; (* 0.04 (costo-tiempo-compartido-pz-seca))
  (* 20 (total-time))  
  ))
)


