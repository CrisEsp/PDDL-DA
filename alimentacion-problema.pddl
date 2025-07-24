(define (problem alimentacion-problema)
  (:domain cement-alimentacion)

  (:objects
    mc1 mc2 mc3 - molino
    l1 l2 l3 - tolva
    clinker puzolana-h yeso puzolana-s - materia
    MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
    MC1-por-MC1 MC2-por-MC2 MC1-por-MC3 MC2-por-MC3 - ruta
    
  )

  (:init
    (libre l1) (libre l2) (libre l3)

    (ruta-disponible mc1 l1 clinker MC1-desde-Pretrit)
    (ruta-disponible mc2 l2 clinker MC2-desde-Pretrit)
    (ruta-disponible mc3 l3 clinker MC3-desde_Silo-Blanco )
    (ruta-disponible mc1 l1 puzolana-h PH-a-MC1-por-MC1)
    (ruta-disponible mc1 l1 puzolana-s PH-a-MC1-por-MC2)
    (ruta-disponible mc2 l2 puzolana-h PH-a-MC1-por-MC2)
    (ruta-disponible mc2 l2 puzolana-s PS-a-MC3-por-MC2)
    (ruta-disponible mc3 l3 puzolana-s PS-a-426HO02-por-426HO04)
    (ruta-disponible mc1 l1 yeso MC1-por-MC1)
    (ruta-disponible mc1 l3 yeso MC1-por-MC3)
    (ruta-disponible mc2 l2 yeso MC2-por-MC2)
    (ruta-disponible mc3 l3 yeso MC1-por-MC3) 

  
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)

    (en-marcha mc1)
    (en-marcha mc2)
    (en-marcha mc3)

  )

  (:goal
    (and
      (alimentado l1 clinker)
      (alimentado l2 clinker)
      (alimentado l1 puzolana-h)
      (alimentado l1 yeso)
    )
  )

)

