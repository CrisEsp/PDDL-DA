
(define (problem cement-production-problem)
(:domain cement-alimentacion)

(:objects
  ;; Molinos
  mc1 mc2 mc3 - molino
  ;; Tolvas
  t1_clinker t1_puzolana_h t1_yeso
  t2_clinker t2_puzolana_h t2_puzolana_s t2_yeso
  t3_clinker t3_puzolana_s t3_yeso - tolva
  ;; Materias
  clinker puzolana_h puzolana_s yeso - materia
  ;; Rutas
  MC1_desde_Pretrit MC2_desde_Pretrit MC3_desde_Silo_Blanco Pretrit_a_Silo_Blanco
  PH_a_MC1_por_MC1 PH_a_MC1_por_MC2 PH_a_426HO04_por_MC2
  PS_a_MC3_por_MC2 PS_a_426HO02_por_426HO04
  MC1_por_MC1 MC1_por_MC2 MC2_por_MC2 MC3_por_MC1 MC3_por_MC2 - ruta
)

(:init
  ;; Molinos en marcha
  (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)
  ;; Tolvas libres
  (libre t1_clinker) (libre t1_puzolana_h) (libre t1_yeso)
  (libre t2_clinker) (libre t2_puzolana_h) (libre t2_puzolana_s) (libre t2_yeso)
  (libre t3_clinker) (libre t3_puzolana_s) (libre t3_yeso)
  ;; Compatibilidades
  (compatible clinker t1_clinker) (compatible puzolana_h t1_puzolana_h) (compatible yeso t1_yeso)
  (compatible clinker t2_clinker) (compatible puzolana_h t2_puzolana_h)
  (compatible puzolana_s t2_puzolana_s) (compatible yeso t2_yeso)
  (compatible clinker t3_clinker) (compatible puzolana_s t3_puzolana_s) (compatible yeso t3_yeso)
  ;; Material disponible
  (material-disponible clinker)
  (material-disponible puzolana_h)
  (material-disponible puzolana_s)
  (material-disponible yeso)
  ;; Recursos positivos iniciales
  (clinker-libre)
  (puzolana_h-libre PH_a_MC1_por_MC1)
  (puzolana_h-libre PH_a_MC1_por_MC2)
  (puzolana_h-libre PH_a_426HO04_por_MC2)
  (puzolana_s-libre mc1)
  (puzolana_s-libre mc2)
  (puzolana_s-libre mc3)
  (ruta-yeso-libre MC2_por_MC2)
  (ruta-yeso-libre MC3_por_MC2)
  (yeso-libre mc1)
  (yeso-libre mc2)
  (yeso-libre mc3)
  (molino-libre-clinker mc1)
  (molino-libre-clinker mc2)
  (molino-libre-clinker mc3)
  ;; Duraciones
  (= (duracion-llenado t1_clinker MC1_desde_Pretrit) 2)
  (= (duracion-llenado t2_clinker MC2_desde_Pretrit) 3)
  (= (duracion-llenado t3_clinker MC3_desde_Silo_Blanco) 4)
  (= (duracion-llenado t3_clinker Pretrit_a_Silo_Blanco) 5)
  (= (duracion-llenado t2_puzolana_h PH_a_426HO04_por_MC2) 6)
  (= (duracion-llenado t1_puzolana_h PH_a_MC1_por_MC2) 7)
  (= (duracion-llenado t1_puzolana_h PH_a_MC1_por_MC1) 6)
  (= (duracion-llenado t3_puzolana_s PS_a_MC3_por_MC2) 5)
  (= (duracion-llenado t2_puzolana_s PS_a_426HO02_por_426HO04) 4)
  (= (duracion-llenado t1_yeso MC1_por_MC1) 3)
  (= (duracion-llenado t1_yeso MC1_por_MC2) 3)
  (= (duracion-llenado t2_yeso MC2_por_MC2) 5)
  (= (duracion-llenado t3_yeso MC3_por_MC1) 2)
  (= (duracion-llenado t3_yeso MC3_por_MC2) 6)
  ;; Inicializar tiempo y costo
  (= (tiempo-acumulado) 0)
  (= (costo-total) 0)
    (en-marcha mc1)
    (en-marcha mc2)
    (en-marcha mc3)
    ;; Clinker
    (ruta-disponible mc1 t1_clinker clinker MC1_desde_Pretrit)
    (ruta-disponible mc2 t2_clinker clinker MC2_desde_Pretrit)
    (ruta-disponible mc3 t3_clinker clinker MC3_desde_Silo_Blanco)
    (ruta-disponible mc3 t3_clinker clinker Pretrit_a_Silo_Blanco)
    ;; Puzolana
    (ruta-disponible mc2 t2_puzolana_h puzolana_h PH_a_426HO04_por_MC2)
    (ruta-disponible mc1 t1_puzolana_h puzolana_h PH_a_MC1_por_MC2)
    (ruta-disponible mc1 t1_puzolana_h puzolana_h PH_a_MC1_por_MC1)
    (ruta-disponible mc3 t3_puzolana_s puzolana_s PS_a_MC3_por_MC2)
    (ruta-disponible mc2 t2_puzolana_s puzolana_s PS_a_426HO02_por_426HO04)
    ;; Yeso
    (ruta-disponible mc1 t1_yeso yeso MC1_por_MC1)
    (ruta-disponible mc2 t2_yeso yeso MC2_por_MC2)
    (ruta-disponible mc3 t3_yeso yeso MC3_por_MC1)
    (ruta-disponible mc3 t3_yeso yeso MC3_por_MC2)
    ;; Tiempos de vaciado
    (= (tiempo-vaciado t1_clinker) 7.63)
    (= (tiempo-vaciado t2_clinker) 2.67)
    (= (tiempo-vaciado t3_clinker) 1.44)
    (= (tiempo-vaciado t1_puzolana_h) 7.03)
    (= (tiempo-vaciado t2_puzolana_h) 20.20)
    (= (tiempo-vaciado t2_puzolana_s) 4.04)
    (= (tiempo-vaciado t3_puzolana_s) 2.21)
    (= (tiempo-vaciado t1_yeso) 125.00)
    (= (tiempo-vaciado t2_yeso) 36.36)
    (= (tiempo-vaciado t3_yeso) 25.95)
  )

  (:goal (and
    (forall (?m - molino ?t - tolva ?mat - materia)
      (imply (and (en-marcha ?m) (compatible ?mat ?t))
             (alimentado ?t ?mat)))
  ))
  (:metric minimize (costo-total))
)