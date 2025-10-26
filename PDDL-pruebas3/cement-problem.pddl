
; (define (problem cement-production-problem)
; (:domain cement-alimentacion)

; (:objects
;     ;; Molinos y Tolvas
;     mc1 mc2 mc3 - molino
;     t1-clinker t1-puzolana-h t1-yeso
;     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
;     t3-clinker t3-puzolana-s t3-yeso - tolva
; )

; (:init
;     ;; Estado de Molinos y Tolvas
;     (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)
;     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
;     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
;     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

;     ;; Recursos de Molino/Material
;     (molino-libre-clinker mc1) (molino-libre-clinker mc2) (molino-libre-clinker mc3)
;     (molino-libre-pz-seca mc3)
;     (molino-libre-pz-humeda mc1) (molino-libre-pz-humeda mc2)
;     (molino-libre-yeso mc1) (molino-libre-yeso mc2) (molino-libre-yeso mc3)
;     (yeso-libre mc1) (yeso-libre mc2) (yeso-libre mc3)
;     (puzolana-h-libre) (puzolana-s-libre)
;     (clinker-libre)
    
;     ;; Compatibilidades y Material disponible
;     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
;     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
;     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)
;     (material-disponible clinker) (material-disponible puzolana-h)
;     (material-disponible puzolana-s) (material-disponible yeso)
    
;     ;; INICIALIZACION DE RECURSOS COMPARTIDOS
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-la-cinta-mc2-libre)
;     (ruta-clinker-libre)
;     (ruta-linea-m3-libre)
    
;     ;; Rutas disponibles
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo3)
;     ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)

;     ;; Duraciones y Tiempos de vaciado
;     (= (duracion-llenado t3-clinker MC3-desde-Silo3) 8)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 3) 
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)

;     (= (tiempo-vaciado t3-clinker) 1.01)
;     (= (tiempo-vaciado t1-puzolana-h) 2.40)
;     (= (tiempo-vaciado t2-puzolana-h) 0.07)
;     (= (tiempo-vaciado t1-yeso) 3.01)
;     (= (tiempo-vaciado t2-yeso) 1.05)
;     (= (tiempo-vaciado t3-yeso) 0.10)


;     (= (prioridad t2-puzolana-h) 14.29)  ; 
;     (= (prioridad t3-yeso) 10.00)        ; 
;     (= (prioridad t3-clinker) 0.99)      ;
;     (= (prioridad t2-yeso) 0.95)         ; 
;     (= (prioridad t1-puzolana-h) 0.42)   ; 
;     (= (prioridad t1-yeso) 0.50)         ; 
;     (= (prioridad t1-clinker) 0.99)      ;

;     (= (tiempo-acumulado) 0)
;     (= (tiempo-acumulado2) 0)
;     (= (costo-total) 0)
; )

; (:goal (and
;     ; (alimentado t3-clinker clinker)

;     (alimentado t1-yeso yeso)
;     (alimentado t1-puzolana-h puzolana-h)
;     ; (alimentado t2-puzolana-h puzolana-h)
;     ; (alimentado t3-yeso yeso)
;     ; (alimentado t2-yeso yeso)
; ))
; (:metric minimize (costo-total))
; )


; (define (problem test-problem)
;   (:domain test-simple)
  
;   (:objects 
;     t1 t2 t3 - tolva
;   )
  
;   (:init
;     (libre t1)
;     (libre t2)
;     (libre t3)
    
;     ; Cada tolva tiene su tiempo de vaciado
;     (= (tiempo-vaciado t1) 10)
;     (= (tiempo-vaciado t2) 15)
;     (= (tiempo-vaciado t3) 5)
    
;     (= (tiempo-total) 0)
;   )
  
;   (:goal (and
;     (alimentado t1)
;     (alimentado t2)
;     (alimentado t3)
;   ))
  
;   ; Minimiza el tiempo total - priorizar tolvas ms rpidas primero
;   (:metric minimize (tiempo-total))
; )



; (define (problem cement-test-lama)
;   (:domain cement-alimentacion-lama)
  
;   (:objects
;     t1-puzolana-h t1-yeso
;     t2-puzolana-h t2-yeso - tolva
;     puzolana-h yeso - materia
;     mc1 mc2 - molino
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 MC1-por-MC2 - ruta
    
;   )
  
;   (:init
;     (libre t1-puzolana-h)
;     (libre t2-puzolana-h)
;     (libre t1-yeso)
;     (ruta-la-mc1-ph-y-yeso-libre)
;     (ruta-mc2-compartida-libre)
;     (compatible puzolana-h t1-puzolana-h PH-a-MC1-por-MC1)
;     (compatible puzolana-h t2-puzolana-h PH-a-MC1-por-MC2)
;     (compatible yeso t1-yeso MC1-por-MC2)
    
;     ;; Contador de posicion
;     (posicion-0)
    
;     ;; Tiempos de vaciado
;     ;; t1-puzolana-h = 24 (2.40 * 10)
;     ;; t1-yeso = 30 (3.01 * 10)
;     (= (tiempo-vaciado t1-puzolana-h) 24)
;     (= (tiempo-vaciado t1-yeso) 10)
    
;     (= (total-cost) 0)
;   )
  
;   (:goal (and
;     (alimentado t1-puzolana-h puzolana-h)
;     (alimentado t1-yeso yeso)
;     (alimentado t2-puzolana-h puzolana-h) 
;   ))
  
;   (:metric minimize (total-cost))
; )

; (define (problem cement-test-durativo)
;   (:domain cement-alimentacion-durativo)
  
;   (:objects
;     t1-puzolana-h t1-yeso - tolva
;     puzolana-h yeso - materia
;     PH-a-MC1-por-MC1 MC1-por-MC1 - ruta
;   )
  
;   (:init
;     ;; Tolvas libres
;     (libre t1-puzolana-h)
;     (libre t1-yeso)
    
;     ;; Recursos disponibles
;     (ruta-la-mc1-ph-y-yeso-libre)
    
;     ;; Compatibilidades
;     (compatible puzolana-h t1-puzolana-h)
;     (compatible yeso t1-yeso)
    
;     ;; Rutas disponibles
;     (ruta-disponible t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
;     (ruta-disponible t1-yeso yeso MC1-por-MC1)
    
;     ;; Duraciones de llenado (tiempo real que tarda en llenarse)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
    
;     ;; Tiempos de vaciado (V - el criterio de priorizacion)
;     ;; t1-puzolana-h tiene MENOR tiempo = MAS URGENTE
;     (= (tiempo-vaciado t1-puzolana-h) 2.40)
;     (= (tiempo-vaciado t1-yeso) 1.01)
    
;     ;; Inicializacion
;     (= (tiempo-acumulado) 0)
;     (= (costo-total) 0)
;   )
  
;   (:goal (and
;     (alimentado t1-puzolana-h puzolana-h)
;     (alimentado t1-yeso yeso)
;   ))
  
;   (:metric minimize (costo-total))
; )




(define (problem cement-test-durativo)
  (:domain cement-alimentacion-durativo)
  
  (:objects
    t1-puzolana-h t1-yeso t2-puzolana-h t2-yeso t3-yeso - tolva
  )
  
  (:init
    ;; Tolvas libres
    (libre t1-puzolana-h)
    (libre t1-yeso)
    (libre t2-puzolana-h)
    (libre t2-yeso)
    (libre t3-yeso)
    
    ;; Recursos compartidos disponibles
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    
    ;; Recursos de molino disponibles
    (molino-libre-pz-humeda mc1)
    (molino-libre-pz-humeda mc2)
    (molino-libre-yeso mc1)
    (molino-libre-yeso mc2)
    (molino-libre-yeso mc3)
    
    ;; Compatibilidades
    (compatible puzolana-h t1-puzolana-h)
    (compatible yeso t1-yeso)
    (compatible puzolana-h t2-puzolana-h)
    (compatible yeso t2-yeso)
    (compatible yeso t3-yeso)
    
    ;; Rutas disponibles - LINEA MC1
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    
    ;; Rutas disponibles - LINEA MC2 (COMPARTIDA)
    ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    
    ;; Duraciones de llenado (tiempo real de llenado)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
    
    ;; Tiempos de vaciado (V - criterio de priorizacion)
    ;; Ordenados de mas urgente a menos urgente:
    (= (tiempo-vaciado t2-puzolana-h) 0.01)   ;; MAS URGENTE
    (= (tiempo-vaciado t3-yeso) 2.06)
    (= (tiempo-vaciado t2-yeso) 3.07)
    (= (tiempo-vaciado t1-puzolana-h) 1.04)
    (= (tiempo-vaciado t1-yeso) 4.01)         ;; MENOS URGENTE
    
    ; (= (tiempo-vaciado t2-puzolana-h) 0.1)   ;; MAS URGENTE
    ; (= (tiempo-vaciado t3-yeso) 0.07)
    ; (= (tiempo-vaciado t2-yeso) 0.05)
    ; (= (tiempo-vaciado t1-puzolana-h) 0.04)
    ; (= (tiempo-vaciado t1-yeso) 0.01)         ;; MENOS URGENTE
    
        ;; Inicializacion de acumuladores
    (= (tiempo-acumulado-mc1) 0)
    (= (tiempo-acumulado-mc2) 0)
    (= (costo-total) 0)
  )
  
  (:goal (and
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t2-yeso yeso)
    (alimentado t3-yeso yeso)
  ))
  
  (:metric minimize (costo-total))
)