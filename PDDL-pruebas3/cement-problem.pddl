;; ========================================
;; PROBLEMA
;; ========================================

(define (problem cement-test-durativo)
  (:domain cement-alimentacion-durativo)
  
  (:objects
    ; t1-clinker t2-clinker 
    t1-puzolana-h t1-yeso t2-puzolana-h t2-yeso t3-yeso t3-clinker t3-clinker-SB - tolva
  )
  
  (:init
    ;; Tolvas libres
    (libre t1-puzolana-h)
    (libre t1-yeso)
    (libre t2-puzolana-h)
    (libre t2-yeso)
    (libre t3-yeso)
    (libre t3-clinker)
    ; (libre t3-clinker-SB) ;; Tolva adicional para clinker SB
    ; (libre t1-clinker)
    ; (libre t2-clinker)
    
    ;; Recursos compartidos disponibles
    (ruta-la-mc1-ph-y-yeso-libre)
    (ruta-la-cinta-mc2-libre)
    (ruta-clinker-libre)
    
    ;; Recursos de molino disponibles
    (molino-libre-pz-humeda mc1)
    (molino-libre-pz-humeda mc2)
    (molino-libre-yeso mc1)
    (molino-libre-yeso mc2)
    (molino-libre-yeso mc3)
    (molino-libre-clinker mc3)
    
    ; (molino-libre-clinker mc1)    
    ; (molino-libre-clinker mc2)
    
    ;; Compatibilidades
    (compatible puzolana-h t1-puzolana-h)
    (compatible yeso t1-yeso)
    (compatible puzolana-h t2-puzolana-h)
    (compatible yeso t2-yeso)
    (compatible yeso t3-yeso)
    (compatible clinker t3-clinker)
    ; (compatible clinker t1-clinker)
    ; (compatible clinker t2-clinker)
    ; (compatible clinker t3-clinker-SB)  ;; Added compatibility for new tolva
    ;; Rutas disponibles - LINEA MC1
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    
    ;; Rutas disponibles - LINEA MC2 (COMPARTIDA)
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    ; (ruta-disponible mc1 t1-yeso yeso MC1-por-MC2)
    ; (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    ;; Ruta MC3 - Clinker (USA ruta-la-mc1-ph-y-yeso-libre, NO simultanea)
    ; (ruta-disponible mc3 t3-clinker-SB clinker MC3-desde-Silo3)
    ; (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)  ;; Added new route for t2-clinker
    ; (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)  ;; Added new route for t2-clinker
    (ruta-disponible mc3 t3-clinker clinker Silo3-desde-Pretrit)  ;; Fixed indentation

    ;; Duraciones de llenado (tiempo real de llenado)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 8)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 6)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 2)  ;; Updated to reflect the correct route
    (= (duracion-llenado t2-yeso MC2-por-MC2) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 9)
    ; (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 7)  ;; Updated to reflect the correct route
    ; (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 5)  ;; Added new duration for t2-clinker
    ; (= (duracion-llenado t3-clinker-SB MC3-desde-Silo3) 7)  ;; Fixed typo for t3-clinker-SB
    (= (duracion-llenado t3-clinker Silo3-desde-Pretrit) 7)

    ;;
    ; ;; VALORES INVERTIDOS (menor valor = ms urgente):
    ; (= (tiempo-vaciado t2-puzolana-h) 3)    ;; Prioridad 1 (MS URGENTE)
    ; (= (tiempo-vaciado t3-yeso) 2)          ;; Prioridad 2
    ; (= (tiempo-vaciado t2-yeso) 1)          ;; Prioridad 3
    ; (= (tiempo-vaciado t1-puzolana-h) 4)    ;; Prioridad 4
    ; (= (tiempo-vaciado t3-clinker) 7)       ;; Prioridad 5
    ; (= (tiempo-vaciado t1-yeso) 6)          ;; Prioridad 6 (MENOS URGENTE)

    (= (tiempo-vaciado t2-puzolana-h) 8.6)   ;; MAS URGENTE
    (= (tiempo-vaciado t3-yeso) 3.4)
    (= (tiempo-vaciado t2-yeso) 5.5)
    (= (tiempo-vaciado t1-puzolana-h) 1.4)
    (= (tiempo-vaciado t1-yeso) 4.2)         ;; MENOS URGENTE
    ; (= (tiempo-vaciado t1-clinker) 5.7)      ;; Assumed value
    ; (= (tiempo-vaciado t2-clinker) 10.7)      ;; Assumed value
    (= (tiempo-vaciado t3-clinker) 2.7)      ;; Assumed value
    ; (= (tiempo-vaciado t3-clinker-SB) 3.7)      ;; Assumed value for new tolva
    
    ;; Inicializacion de acumuladores por linea
    (= (tiempo-acumulado-mc1) 0)
    (= (tiempo-acumulado-mc2) 0)

    ; ; (= (tiempo-acumulado-3) 0)  ;; Added initialization for new accumulated time)
    ; ; (= (tiempo-acumulado-4) 0)  ;; Added initialization for new accumulated time)
    ; (= (tiempo-acumulado-ck) 0)  ;; Added initialization for clinker)
    ; (= (tiempo-acumulado-ck3) 0)  ;; Added initialization for clinker)


    (= (costo-total) 0)
  )
  
  (:goal (and
    (alimentado t1-puzolana-h puzolana-h)
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
    (alimentado t2-yeso yeso)
    (alimentado t3-yeso yeso)
    (alimentado t3-clinker clinker)
    ; (alimentado t3-clinker-SB clinker)  ;; Added for new tolva
    ; (alimentado t1-clinker clinker) 
    ; (alimentado t2-clinker clinker)
  ))
  
  ; (:metric minimize (costo-total))
  (:metric minimize (+ (* 0.1 (costo-total)) (total-time)))
)
  