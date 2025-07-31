(define (problem cement-production-problem)
  (:domain cement-alimentacion)

  (:objects
    mc1 mc2 mc3 - molino
    t1-clinker t1-puzolana-h t1-yeso
    t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
    t3-clinker t3-puzolana-s t3-yeso - tolva
    clinker puzolana-h yeso puzolana-s - materia
    MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
  )

  (:init
    (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
    (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
    (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

    ;; Compatibilidad
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)

    (en-marcha mc1)
    (en-marcha mc2)
    (en-marcha mc3)
                
    ;; Costos de prioridad basados en tiempos de vaciado
    (= (costo-prioridad t1-clinker) 166.67)    ;; 100 / (0.59 + 0.01)
    (= (costo-prioridad t1-puzolana-h) 476.19) ;; 100 / (0.70 + 0.01)
    (= (costo-prioridad t1-yeso) 270.27)       ;; 100 / (0.36 + 0.01)
    (= (costo-prioridad t2-clinker) 47619.19)    ;; 100 / (0.20 + 0.01)
    (= (costo-prioridad t2-puzolana-h) 142.86) ;; 100 / (0.70 + 0.01)
    (= (costo-prioridad t2-puzolana-s) 400.00) ;; 100 / (0.24 + 0.01)
    (= (costo-prioridad t2-yeso) 270.27)       ;; 100 / (0.36 + 0.01)
    (= (costo-prioridad t3-clinker) 163.93)    ;; 100 / (0.60 + 0.01)
    (= (costo-prioridad t3-puzolana-s) 400.00) ;; 100 / (0.24 + 0.01)
    (= (costo-prioridad t3-yeso) 270.27)       ;; 100 / (0.36 + 0.01)

    ; ;; Duraciones
    ; (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 3)
    ; (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 2.5)
    ; (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
    ; (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 3)
    ; (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1.5)
    ; (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
    ; (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 4)
    ; (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 4)
    ; (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 2)
    ; (= (duracion-llenado t1-yeso MC1-por-MC1) 2)
    ; (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    ; (= (duracion-llenado t2-yeso MC2-por-MC2)2.5)
    ; (= (duracion-llenado t3-yeso MC3-por-MC1) 3)
    ; (= (duracion-llenado t3-yeso MC3-por-MC2) 6.1)

            ;; Duraciones
    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 2)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 3)
    (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
    (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 5)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

                
    ;; Rutas disponibles
    ;; Clinker
    (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
    (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
    (ruta-disponible mc3 t3-clinker clinker MC3-desde_Silo-Blanco)
    (ruta-disponible mc3 t3-clinker clinker Pretrit_a_Silo_Blanco)
    ;; Puzolana
    (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)
    ;; Yeso
    (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
    (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC1)
    (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)
    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1-clinker) 0.59)
    (= (tiempo-vaciado t1-yeso) 0.36)
    (= (tiempo-vaciado t1-puzolana-h) 0.2)

    (= (tiempo-vaciado t2-clinker) 0.20)
    (= (tiempo-vaciado t2-puzolana-h) 0.7)
    (= (tiempo-vaciado t2-puzolana-s) 0.24)
    (= (tiempo-vaciado t2-yeso) 0.36)

    (= (tiempo-vaciado t3-puzolana-s) 0.24)
    (= (tiempo-vaciado t3-yeso) 0.36)
    (= (tiempo-vaciado t3-clinker) 0.6)

    ;; Inicializacin de retraso para controlar prioridad escalonada
    (= (retraso) 0)
  )

  (:goal (and
    (alimentado t1-clinker clinker)
    (alimentado t2-clinker clinker)
    (alimentado t3-clinker clinker)
    (alimentado t3-puzolana-s puzolana-s)
    (alimentado t3-yeso yeso)
    (alimentado t2-yeso yeso)
    
    (alimentado t1-yeso yeso)
    ;(alimentado t1-puzolana-h puzolana-h)

    (alimentado t2-yeso yeso)
    (alimentado t1-yeso yeso)
    (alimentado t2-puzolana-h puzolana-h)
   ; (alimentado t2-puzolana-s puzolana-s)
    (alimentado t3-puzolana-s puzolana-s)

  ))
  (:metric minimize (total-cost))
)


; (define (problem cement-production-problem)
;   (:domain cement-alimentacion)

;   (:objects
;     mc1 mc2 mc3 - molino
;     t1-clinker t1-puzolana-h t1-yeso
;     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
;     t3-clinker t3-puzolana-s t3-yeso - tolva
;     clinker puzolana-h yeso puzolana-s - materia
;     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde-Silo-Blanco Pretrit-a-Silo-Blanco 
;     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
;   )

;   (:init

;     ; (prioridad-bloqueada t2-clinker)
;     ; (prioridad-bloqueada t3-clinker)
;     ; (prioridad-bloqueada t1-clinker)

;     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
;     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
;     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

;     ;; Compatibilidad
;     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
;     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
;     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
;     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

;     (material-disponible clinker)
;     (material-disponible puzolana-h)
;     (material-disponible puzolana-s)
;     (material-disponible yeso)

;     (en-marcha mc1)
;     (en-marcha mc2)
;     (en-marcha mc3)

;     ;; Costos de prioridad (ejemplo)
;     (= (costo-prioridad t1-clinker) 166.67)
;     (= (costo-prioridad t1-puzolana-h) 476.19)
;     (= (costo-prioridad t1-yeso) 270.27)
;     (= (costo-prioridad t2-clinker) 47619.19)
;     (= (costo-prioridad t2-puzolana-h) 142.86)
;     (= (costo-prioridad t2-puzolana-s) 400.00)
;     (= (costo-prioridad t2-yeso) 270.27)
;     (= (costo-prioridad t3-clinker) 163.93)
;     (= (costo-prioridad t3-puzolana-s) 400.00)
;     (= (costo-prioridad t3-yeso) 270.27)

;     ;; Duraciones
;     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 3)
;     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 2.5)
;     (= (duracion-llenado t3-clinker MC3-desde-Silo-Blanco) 4)
;     (= (duracion-llenado t3-clinker Pretrit-a-Silo-Blanco) 3)
;     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1.5)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
;     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 4)
;     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 4)
;     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 2)
;     (= (duracion-llenado t1-yeso MC1-por-MC1) 2)
;     (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
;     (= (duracion-llenado t2-yeso MC2-por-MC2) 2.5)
;     (= (duracion-llenado t3-yeso MC3-por-MC1) 3)
;     (= (duracion-llenado t3-yeso MC3-por-MC2) 6.1)

;     ;; Tiempos de vaciado
;     (= (tiempo-vaciado t1-clinker) 0.59)
;     (= (tiempo-vaciado t1-yeso) 0.36)
;     (= (tiempo-vaciado t1-puzolana-h) 0.2)

;     (= (tiempo-vaciado t2-clinker) 0.20)
;     (= (tiempo-vaciado t2-puzolana-h) 0.7)
;     (= (tiempo-vaciado t2-puzolana-s) 0.24)
;     (= (tiempo-vaciado t2-yeso) 0.36)

;     (= (tiempo-vaciado t3-puzolana-s) 0.24)
;     (= (tiempo-vaciado t3-yeso) 0.36)
;     (= (tiempo-vaciado t3-clinker) 0.6)


;     ;; Rutas disponibles (ejemplo simplificado)
;     (ruta-disponible mc1 t1-clinker clinker MC1-desde-Pretrit)
;     (ruta-disponible mc2 t2-clinker clinker MC2-desde-Pretrit)
;     (ruta-disponible mc3 t3-clinker clinker MC3-desde-Silo-Blanco)
;     (ruta-disponible mc3 t3-clinker clinker Pretrit-a-Silo-Blanco)
;     (ruta-disponible mc2 t2-puzolana-h puzolana-h PH-a-426HO04-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC2)
;     (ruta-disponible mc1 t1-puzolana-h puzolana-h PH-a-MC1-por-MC1)
;     (ruta-disponible mc3 t3-puzolana-s puzolana-s PS-a-MC3-por-MC2)
;     (ruta-disponible mc2 t2-puzolana-s puzolana-s PS-a-426HO02-por-426HO04)
;     (ruta-disponible mc1 t1-yeso yeso MC1-por-MC1)
;     (ruta-disponible mc2 t2-yeso yeso MC2-por-MC2)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC1)
;     (ruta-disponible mc3 t3-yeso yeso MC3-por-MC2)

;     ;; Inicializaci de retraso para controlar prioridad escalonada
;     (= (retraso) 0)
;   )

;   (:goal (and
;     (alimentado t1-clinker clinker)
;     (alimentado t2-clinker clinker)
;     (alimentado t3-clinker clinker)
;     (alimentado t1-puzolana-h puzolana-h)
;     (alimentado t2-puzolana-h puzolana-h)
;     (alimentado t2-puzolana-s puzolana-s)
;     (alimentado t3-puzolana-s puzolana-s)
;     (alimentado t1-yeso yeso)
;     (alimentado t2-yeso yeso)
;     (alimentado t3-yeso yeso)
;   ))

;   (:metric minimize (total-cost))
; )
