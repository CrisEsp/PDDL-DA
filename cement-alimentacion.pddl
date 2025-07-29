(define (domain cement-alimentacion)
  (:requirements :durative-actions :typing :numeric-fluents)

  (:types molino tolva materia ruta)

  (:predicates
    (en-marcha ?m - molino)
    (libre ?t - tolva)
    (compatible ?mat - materia ?t - tolva)
    (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
    (material-disponible ?mat - materia)
    (alimentado ?t - tolva ?mat - materia)
    (tolva-ocupada ?t - tolva ?mat - materia)
    (alimentando ?mat - materia ?m - molino ?r - ruta)
    
    ;; Predicados nuevos para bloqueo MC2 especico
    (alimentando-puzolana-mc2 ?t - tolva)
    (alimentando-yeso-mc2 ?t - tolva)
    (clinker-ocupado)         ; bandera global (para evitar 2 molinos a la vez)
    (clinker-ocupado2 ?m - molino) ; bandera individual por molino
    (puzolana-h-ocupado ?m - molino ?r - ruta) ; bandera individual por molino
    (puzolana-s-ocupado) ; bandera individual por molino
    (yeso-ocupado ?m - molino ?r - ruta)
  )
  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
    (costo-prioridad ?t - tolva)
    (total-cost)
  )

    (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m)) ; molino encendido
      (at start (libre ?t)) ; tolva libre
      (at start (not (clinker-ocupado))) ; solo un molino puede alimentar clinker
      (at start (not (clinker-ocupado2 ?m))) ; ahora chequea por molino
      (at start (compatible clinker ?t)) ; la tolva acepta clinker
      (at start (ruta-disponible ?m ?t clinker ?r)) ; existe ruta disponible
      (at start (material-disponible clinker)) ; hay clinker disponible

      ;; Si es MC3, no puede haber yeso o puzolana seca alimentandose simultaneamente
      (over all (not (and (= ?m mc3) (alimentando yeso mc3 ?r))))
      (over all (not (and (= ?m mc3) (alimentando puzolana-s mc3 ?r))))
      (over all (not (and (= ?m mc1) (alimentando yeso mc1 ?r))))
      ;(over all (not (puzolana-s-ocupado mc3))) ; bloquea si mc3 tiene clinker activo
    )
    :effect (and
      (at start (not (libre ?t))) ; tolva deja de estar libre
      (at start (tolva-ocupada ?t clinker)) ; tolva queda ocupada
      (at start (alimentando clinker ?m ?r)) ; se marca que el molino alimenta clinker
      (at start (clinker-ocupado)) ; se marca bandera global de clinker ocupado
      (at start (clinker-ocupado2 ?m)) ; se marca bandera individual de clinker ocupado por molino
      (at end (not (clinker-ocupado2 ?m)))    ; <<< libera solo ese molino
      (at end (not (clinker-ocupado))) ; se libera la bandera
      (at end (alimentado ?t clinker)) ; se marca que fue alimentado
      (at end (libre ?t)) ; se libera la tolva
      (at end (not (tolva-ocupada ?t clinker))) ; se borra ocupacion
      (at end (not (alimentando clinker ?m ?r))) ; se borra marca de alimentacion
    )
  )


  ; ;; Alimentar puzolana (hmeda o seca)
  ; (:durative-action alimentar-puzolana
  ;   :parameters (?m - molino ?t - tolva ?mat - materia ?r - ruta)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (en-marcha ?m))
  ;     (at start (libre ?t))
  ;     (at start (ruta-disponible ?m ?t ?mat ?r))
  ;     (at start (material-disponible ?mat))
  ;     (at start (not (puzolana-h-ocupado ?m ?r))) ; ahora chequea por molino
  ;     (at start (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2))) ; ahora chequea por molino
  ;     (at start (not (puzolana-s-ocupado ?m))) ; ahora chequea por molino
  ;     (at start (or (= ?mat puzolana-h) (= ?mat puzolana-s)))
  ;     ;; Bloqueo simultaneidad con yeso en MC1 (mantener)
  ;     (over all (not(and (= ?m mc1)(alimentando yeso mc1))))
  ;     (over all (not (clinker-ocupado2 mc3))) ; bloquea si mc3 tiene clinker activo
  ;     ;; Bloqueo para MC2 tolvas: no puede alimentar puzolana si yeso se est alimentando en tolva mc2
  ;     (at start (not (alimentando-yeso-mc2 ?t))))

  ;   :effect (and

  ;     (at start (not (libre ?t)))
  ;     (at start (tolva-ocupada ?t ?mat))
  ;     (at start (alimentando ?mat ?m))
  ;     (at start (puzolana-h-ocupado ?m ?r)) ; se marca bandera individual de puzolana-h ocupado por molino
  ;     (at start (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2)) 
  ;     (at end (not(puzolana-h-ocupado mc1 PH-a-MC1-por-MC2))) 
  ;     (at end (not (puzolana-h-ocupado ?m ?r)))    ; <<< libera solo ese molino
  ;     (at start (puzolana-s-ocupado ?m)) ; se marca bandera individual de puzolana-h ocupado por molino
  ;     (at end (not (puzolana-s-ocupado ?m)))    ; <<< libera solo ese molino
  ;     (at end (alimentado ?t ?mat))
  ;     (at end (libre ?t))
  ;     (at end (not (tolva-ocupada ?t ?mat)))
  ;     (at end (not (alimentando ?mat ?m)))
  ;   )
  ; )
    

    
  ; (:durative-action alimentar-puzolana-h-general
  ;   :parameters (?m - molino ?t - tolva ?r - ruta)
  ;   :duration (= ?duration (duracion-llenado ?t ?r))
  ;   :condition (and
  ;     (at start (en-marcha ?m))
  ;     (at start (libre ?t))
  ;     (at start (ruta-disponible ?m ?t puzolana-h ?r))
  ;     (at start (material-disponible puzolana-h))
  ;     (at start (not (puzolana-h-ocupado ?m ?r)))
  ;     (over all (not (and (= ?m mc1) (alimentando yeso mc1))))
  ;     (over all (not (clinker-ocupado2 mc3)))
  ;     (at start (not (alimentando-yeso-mc2 ?t)))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (tolva-ocupada ?t puzolana-h))
  ;     (at start (alimentando puzolana-h ?m))
  ;     (at start (puzolana-h-ocupado ?m ?r))
  ;     (at end (not (puzolana-h-ocupado ?m ?r)))
  ;     (at end (alimentado ?t puzolana-h))
  ;     (at end (libre ?t))
  ;     (at end (not (tolva-ocupada ?t puzolana-h)))
  ;     (at end (not (alimentando puzolana-h ?m)))
  ;   )
  ; )

    
  ; (:durative-action alimentar-puzolana-h-mc2ruta
  ;   :parameters (?m - molino ?t - tolva)
  ;   :duration (= ?duration (duracion-llenado ?t PH-a-MC1-por-MC2))
  ;   :condition (and
  ;     (at start (en-marcha ?m))
  ;     (at start (libre ?t))
  ;     (at start (ruta-disponible ?m ?t puzolana-h PH-a-MC1-por-MC2))
  ;     (at start (material-disponible puzolana-h))
  ;     (at start (not (puzolana-h-ocupado ?m PH-a-MC1-por-MC2)))
  ;     (at start (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2)))
  ;     (over all (not (and (= ?m mc1) (alimentando yeso mc1))))
  ;     (over all (not (clinker-ocupado2 mc3)))
  ;     (at start (not (alimentando-yeso-mc2 ?t)))
  ;   )
  ;   :effect (and
  ;     (at start (not (libre ?t)))
  ;     (at start (tolva-ocupada ?t puzolana-h))
  ;     (at start (alimentando puzolana-h ?m))
  ;     (at start (puzolana-h-ocupado ?m PH-a-MC1-por-MC2))
  ;     (at start (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2)) ;;  solo aqu
  ;     (at end (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2)))
  ;     (at end (not (puzolana-h-ocupado ?m PH-a-MC1-por-MC2)))
  ;     (at end (alimentado ?t puzolana-h))
  ;     (at end (libre ?t))
  ;     (at end (not (tolva-ocupada ?t puzolana-h)))
  ;     (at end (not (alimentando puzolana-h ?m)))
  ;   )
  ; )


  (:durative-action alimentar-puzolana-h
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-h ?r))
      (at start (material-disponible puzolana-h))
      (at start (not (puzolana-h-ocupado ?m ?r)))
      (at start (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2))) ; bloquea si MC1 usa ruta conflictiva
      ;(over all (not (and (= ?m mc1) (alimentando yeso mc1 MC1-por-MC2))))
      (over all (not (clinker-ocupado2 mc3)))
      (over all (not (yeso-ocupado mc1 MC1-por-MC1)))
      (at start (not (alimentando-yeso-mc2 ?t)))

    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-h))
      (at start (alimentando puzolana-h ?m ?r))
      (at start (puzolana-h-ocupado ?m ?r))
      (at start (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2))
      (at end (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2)))
      (at end (not (puzolana-h-ocupado ?m ?r)))
      (at end (alimentado ?t puzolana-h))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-h)))
      (at end (not (alimentando puzolana-h ?m ?r)))
    )
  )
    
  (:durative-action alimentar-puzolana-s
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t puzolana-s ?r))
      (at start (material-disponible puzolana-s))
      (at start (not (puzolana-s-ocupado)))
      ;; Restriccin de tolvas y rutas especficas
      (at start (or 
          (and (= ?m mc2) (= ?t t2-puzolana-s) (= ?r PS-a-426HO02-por-426HO04))
          (and (= ?m mc3) (= ?t t3-puzolana-s) (= ?r PS-a-MC3-por-MC2))
      ))
      ;; Exclusin mutua para evitar alimentacin simultnea de puzolana seca
      (over all (not (and 
          (= ?m mc2) 
          (alimentando puzolana-s mc3 t3-puzolana-s PS-a-MC3-por-MC2)
      )))
      (over all (not (and 
          (= ?m mc3) 
          (alimentando puzolana-s mc2 t2-puzolana-s PS-a-426HO02-por-426HO04)
      )))
      (over all (not (and (= ?m mc1) (alimentando yeso mc1 ?r))))
      ;(over all (not (and (= ?m mc2) (alimentando puzolana-s mc2 ?r))))
      (over all (not (clinker-ocupado2 mc3)))
      
      ;(at start (not (alimentando-yeso-mc2 ?t)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t puzolana-s))
      (at start (alimentando puzolana-s ?m ?r))
      (at start (puzolana-s-ocupado))
      (at end (not (puzolana-s-ocupado)))
      (at end (alimentado ?t puzolana-s))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t puzolana-s)))
      (at end (not (alimentando puzolana-s ?m ?r)))
    )
  )

    

  ;; Alimentar yeso
  (:durative-action alimentar-yeso
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t yeso ?r))
      (at start (material-disponible yeso))
      (at start (not (puzolana-s-ocupado)))
      ;; Only block if feeding gypsum to MC1 via MC2 route and MC2 is feeding wet pozzolan to 426HO04
      (over all (not (and (= ?m mc1) (= ?r MC1-por-MC2) (puzolana-h-ocupado mc2 PH-a-426HO04-por-MC2))))
      (over all (not (puzolana-h-ocupado mc1 PH-a-MC1-por-MC2))) ; bloquea si mc3 tiene clinker activo
      (over all (not (puzolana-h-ocupado mc2 ?r))) ; bloquea si mc3 tiene clinker activo
      
      ;; Bloqueo simultaneidad con puzolana en MC1 (mantener)
      ; (over all (not
      ;   (and (= ?m mc1)
      ;        (alimentando puzolana-h ?m))
      ; ))
      (over all (not
        (and (= ?m mc3)
             (alimentando puzolana-s ?m))
      ))
      (over all (not (clinker-ocupado2 mc3))) ; bloquea si mc3 tiene clinker activo
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m ?r))
      (at start (yeso-ocupado ?m ?r))
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m)))
    )
  )
)


