; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing :numeric-fluents)
  
;   (:types molino tolva materia ruta)

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia) ; Para evitar puzolana y yeso simultneamente
;     (clinker-ocupado) ; Nuevo predicado para evitar alimentacin simultnea de clinker a l1 y l2
;     (ruta-bloqueada-MC1-desde-Pretrit) ; Predicado para bloquear MC1-desde-Pretrit
;     (ruta-ocupada ?r - ruta)
;     (usando-ruta-mc1-pretrit ?r - ruta)
;     (alimentando ?mat - materia-prima ?m - molino)

;     )

;   (:functions
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (costo-prioridad ?t - tolva) ; inverso de la prioridad
;     (total-cost)
;   )

;   ;; Accin para alimentar clinker
;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (material-disponible clinker))
;       (at start (not (clinker-ocupado))) ; Asegura que no se est alimentando clinker a otra tolva
;       (over all (not (tolva-ocupada ?t puzolana-h)))
;       (over all (not (tolva-ocupada ?t puzolana-s)))
;       (over all (not (tolva-ocupada ?t yeso)))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker))
;       (at start (clinker-ocupado)) ; Marca que el sistema de clinker est ocupado
;       (at start ruta-bloqueada-MC1-desde-Pretrit)
;       (at end (not ruta-bloqueada-MC1-desde-Pretrit))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker)))
;       (at end (not (clinker-ocupado))) ; Libera el sistema de clinker al finalizar
;       ;(at end (increase (total-cost) (costo-prioridad ?t clinker)))
      

    
;     )
;   )

;   ;; Accin para alimentar puzolana (hmeda o seca)
;   (:durative-action alimentar-puzolana
;     :parameters (?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (material-disponible ?mat))
;       (at start (or (= ?mat puzolana-h) (= ?mat puzolana-s)))
;       (over all (not ruta-bloqueada-MC1-desde-Pretrit))
;       (over all (not (tolva-ocupada ?t yeso)))
;       (over all (not (tolva-ocupada ?t clinker)))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t ?mat))
;       (at end (alimentado ?t ?mat))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t ?mat)))
;       ; (at end (increase (total-cost) (costo-prioridad ?t ?mat)))
;     )
;   )

;   ;; Accin para alimentar yeso
;   (:durative-action alimentar-yeso
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r) )
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (material-disponible yeso))
;       (over all (not (tolva-ocupada ?t puzolana-h)))
;       (over all (not (tolva-ocupada ?t puzolana-s)))
;       (over all (not (tolva-ocupada ?t clinker)))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       ;(at end (increase (total-cost) (costo-prioridad ?t yeso)))
;     )
;   )
; )


; (define (domain cement-alimentacion)
;   (:requirements :durative-actions :typing :numeric-fluents)

;   (:types molino tolva materia ruta)

;   (:predicates
;     (en-marcha ?m - molino)
;     (libre ?t - tolva)
;     (compatible ?mat - materia ?t - tolva)
;     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     (material-disponible ?mat - materia)
;     (alimentado ?t - tolva ?mat - materia)
;     (tolva-ocupada ?t - tolva ?mat - materia)
;     (alimentando ?mat - materia ?m - molino)
;   )

;   (:functions
;     (duracion-llenado ?t - tolva ?r - ruta)
;     (costo-prioridad ?t - tolva)
;     (total-cost)
;   )

;   ;; Alimentar clinker
;   (:durative-action alimentar-clinker
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (compatible clinker ?t))
;       (at start (ruta-disponible ?m ?t clinker ?r))
;       (at start (material-disponible clinker))
;       ;; Bloqueo: si alimenta clinker en mc1, no puede estar alimentando puzolana en mc1
;       ; (over all (not
;       ;   (and (= ?m mc1)
;       ;        (alimentando puzolana-h mc1))
;       ; ))

;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t clinker))
;       (at start (alimentando clinker ?m))
;       (at end (alimentado ?t clinker))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t clinker)))
;       (at end (not (alimentando clinker ?m)))
;     )
;   )

;   ;; Alimentar puzolana (hmeda o seca)
;   (:durative-action alimentar-puzolana
;     :parameters (?m - molino ?t - tolva ?mat - materia ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t ?mat ?r))
;       (at start (material-disponible ?mat))
;       (at start (or (= ?mat puzolana-h) (= ?mat puzolana-s)))
;       ;; Bloqueo: si alimenta puzolana en mc1, no puede estar alimentando yeso en mc1
;       (over all (not
;         (and (= ?m mc1)
;              (alimentando yeso mc1))
;       ))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t ?mat))
;       (at start (alimentando ?mat ?m))
;       (at end (alimentado ?t ?mat))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t ?mat)))
;       (at end (not (alimentando ?mat ?m)))
;     )
;   )

;   ;; Alimentar yeso
;   (:durative-action alimentar-yeso
;     :parameters (?m - molino ?t - tolva ?r - ruta)
;     :duration (= ?duration (duracion-llenado ?t ?r))
;     :condition (and
;       (at start (en-marcha ?m))
;       (at start (libre ?t))
;       (at start (ruta-disponible ?m ?t yeso ?r))
;       (at start (material-disponible yeso))
;       ;; Bloqueo: si alimenta clinker en mc1, no puede estar alimentando puzolana en mc1
;       (over all (not
;         (and (= ?m mc1)
;              (alimentando puzolana-h mc1))
;       ))
;     )
;     :effect (and
;       (at start (not (libre ?t)))
;       (at start (tolva-ocupada ?t yeso))
;       (at start (alimentando yeso ?m))
;       (at end (alimentado ?t yeso))
;       (at end (libre ?t))
;       (at end (not (tolva-ocupada ?t yeso)))
;       (at end (not (alimentando yeso ?m)))
;     )
;   )
; )


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
    (alimentando ?mat - materia ?m - molino)
    
    ;; Predicados nuevos para bloqueo MC2 especico
    (alimentando-puzolana-mc2 ?t - tolva)
    (alimentando-yeso-mc2 ?t - tolva)
    (clinker-ocupado)

  )

  (:functions
    (duracion-llenado ?t - tolva ?r - ruta)
    (costo-prioridad ?t - tolva)
    (total-cost)
  )

  ;; Alimentar clinker
  (:durative-action alimentar-clinker
    :parameters (?m - molino ?t - tolva ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (not (clinker-ocupado)))
      (at start (compatible clinker ?t))
      (at start (ruta-disponible ?m ?t clinker ?r))
      (at start (material-disponible clinker))

            ;; Bloqueo simultaneidad con yeso en MC1 (mantener)
      (over all (not
        (and (= ?m mc3)
             (alimentando yeso mc3))
      ))
                  ;; Bloqueo simultaneidad con yeso en MC1 (mantener)
      (over all (not
        (and (= ?m mc3)
             (alimentando puzolana-s mc3))
      ))
      

    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t clinker))
      (at start (alimentando clinker ?m))
      (at start (clinker-ocupado))
      (at end (not (clinker-ocupado)))
      (at end (alimentado ?t clinker))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t clinker)))
      (at end (not (alimentando clinker ?m)))
    )
  )

  ;; Alimentar puzolana (hmeda o seca)
  (:durative-action alimentar-puzolana
    :parameters (?m - molino ?t - tolva ?mat - materia ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (en-marcha ?m))
      (at start (libre ?t))
      (at start (ruta-disponible ?m ?t ?mat ?r))
      (at start (material-disponible ?mat))
      (at start (or (= ?mat puzolana-h) (= ?mat puzolana-s)))
      ;; Bloqueo simultaneidad con yeso en MC1 (mantener)
      (over all (not
        (and (= ?m mc1)
             (alimentando yeso mc1))
      ))
      ;; Bloqueo para MC2 tolvas: no puede alimentar puzolana si yeso se est alimentando en tolva mc2
      (at start (not (alimentando-yeso-mc2 ?t)))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t ?mat))
      (at start (alimentando ?mat ?m))
      ;; Si el molino es MC2, marcamos tolva con alimentando-puzolana-mc2
      ; (when (= ?m mc2)
      ;   (at start (alimentando-puzolana-mc2 ?t))
      ;   (at end (not (alimentando-puzolana-mc2 ?t)))
      ; )
      (at end (alimentado ?t ?mat))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t ?mat)))
      (at end (not (alimentando ?mat ?m)))
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
      
      ;; Bloqueo simultaneidad con puzolana en MC1 (mantener)
      (over all (not
        (and (= ?m mc1)
             (alimentando puzolana ?m))
      ))
      (over all (not
        (and (= ?m mc3)
             (alimentando puzolana-s ?m))
      ))

      ;; Bloqueo para MC2 tolvas: no puede alimentar yeso si puzolana se est alimentando en tolva mc2
      (at start (not (alimentando-puzolana-mc2 ?t)))
      
    )
    :effect (and
      (at start (not (libre ?t)))
      (at start (tolva-ocupada ?t yeso))
      (at start (alimentando yeso ?m))
      
      ;; Si el molino es MC2, marcamos tolva con alimentando-yeso-mc2
      ; (when (= ?m mc2)
      ;   (at start (alimentando-yeso-mc2 ?t))
      ;   (at end (not (alimentando-yeso-mc2 ?t)))
      ; )
      
      (at end (alimentado ?t yeso))
      (at end (libre ?t))
      (at end (not (tolva-ocupada ?t yeso)))
      (at end (not (alimentando yeso ?m)))
    )
  )
)

