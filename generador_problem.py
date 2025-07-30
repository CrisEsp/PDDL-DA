import enum
from typing import List, Dict, Tuple

# ---------------------------------------------
# Clases base
# ---------------------------------------------

class TipoProducto(enum.Enum):
    P10 = "P10"
    P16 = "P16"
    P20 = "P20"
    P30 = "P30"
    P40 = "P40"

class Tolva:
    def __init__(self, material: str, capacidad: float, altura_max: float):
        self.material = material
        self.capacidad = capacidad
        self.altura_max = altura_max
        self.nivel_actual = 0

    def tiempo_vaciado(self, consumo_por_hora: float) -> float:
        toneladas_reales = (self.nivel_actual * self.capacidad) / self.altura_max
        return toneladas_reales / consumo_por_hora if consumo_por_hora > 0 else float('inf')

class Molino:
    def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
        self.nombre = nombre
        self.tolvas = tolvas
        self.rendimiento = rendimiento
        self.tipo_producto = None
        self.alimentacion_fresca = 0
        self.ratios = {}

    def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
        self.tipo_producto = tipo_producto
        self.alimentacion_fresca = alimentacion_fresca
        self.ratios = ratios

    def tiempo_vaciado(self, material: str) -> float:
        if material not in self.ratios or material not in self.tolvas:
            return float('inf')
        consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
        return self.tolvas[material].tiempo_vaciado(consumo)

# ---------------------------------------------
# Sistema de alimentación
# ---------------------------------------------

class SistemaAlimentacion:
    def __init__(self):
        self.mc1 = Molino("MC1", {
            "clinker": Tolva("Clinker", 500, 14),
            "puzolana": Tolva("Puzolana", 300, 12),
            "yeso": Tolva("Yeso", 300, 10)
        }, 1)

        self.mc2 = Molino("MC2", {
            "clinker": Tolva("Clinker", 300, 9),
            "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15),
            "puzolana_seca": Tolva("Puzolana Seca", 100, 12),
            "yeso": Tolva("Yeso", 120, 9)
        }, 0.8)

        self.mc3 = Molino("MC3", {
            "clinker": Tolva("Clinker", 60, 100),
            "puzolana": Tolva("Puzolana", 35, 100),
            "yeso": Tolva("Yeso", 30, 100)
        }, 0.5)

    def set_productos(self):
        self.mc1.set_producto(TipoProducto.P30, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
        self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "yeso": 3})
        self.mc3.set_producto(TipoProducto.P30, 33.5, {"clinker": 63.1, "puzolana": 34.4, "yeso": 2.5})

# ---------------------------------------------
# Funciones para vaciado y generación PDDL
# ---------------------------------------------

def calcular_tiempos_vaciado(molino: Molino, imprimir: bool = True) -> Dict[str, float]:
    tiempos = {}
    for material in molino.tolvas:
        tiempos[material] = molino.tiempo_vaciado(material)
        if imprimir:
            print(f"Tiempo de vaciado para {molino.nombre} - {material}: {tiempos[material]:.2f} horas")    
    return tiempos


def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=2) -> Tuple[List[str], Dict[str, float]]:
    tolvas_a_llenar = []
    tiempos_por_tolva = {}

    nombres_tolvas = {
        "mc1": {"clinker": "t1-clinker", "puzolana": "t1-puzolana-h", "yeso": "t1-yeso"},
        "mc2": {"clinker": "t2-clinker", "puzolana_humeda": "t2-puzolana-h", "puzolana_seca": "t2-puzolana-s", "yeso": "t2-yeso"},
        "mc3": {"clinker": "t3-clinker", "puzolana": "t3-puzolana-s", "yeso": "t3-yeso"},
    }

    for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
        tiempos = calcular_tiempos_vaciado(molino, imprimir=True)
        nombre_molino = molino.nombre.lower()
        for mat, tiempo in tiempos.items():
            nombre_tolva_pddl = nombres_tolvas[nombre_molino].get(mat)
            if nombre_tolva_pddl:
                tiempos_por_tolva[nombre_tolva_pddl] = tiempo
                if tiempo < umbral:
                    tolvas_a_llenar.append(nombre_tolva_pddl)  # Usar nombre_tolva_pddl directamente
    
    return tolvas_a_llenar, tiempos_por_tolva

estado_rutas = {
    # Rutas de clinker
    "MC1-desde-Pretrit": True,  # Hacia MC1 desde pretrit
    "MC2-desde-Pretrit": True,  # Hacia MC2 desde pretrit
    "MC3-desde_Silo-Blanco": True,  # Hacia MC3 desde Silo Blanco
    "Pretrit_a_Silo_Blanco": True,  # Hacia Silo Blanco desde pretrit
    # Rutas de puzolana
    "PH-a-426HO04-por-MC2": True,  # P.H. a 426HO04 por MC2
    "PH-a-MC1-por-MC2": True,      # Húmeda a MC1 por MC2
    "PH-a-MC1-por-MC1": True,      # Húmeda a MC1 por MC1
    "PS-a-MC3-por-MC2": True,      # P.S a MC3 por MC2
    "PS-a-426HO02-por-426HO04": True,  # P.S. a 426HO02 por 426HO04
    # Rutas de yeso
    "MC3-por-MC1": True,  # Hacia MC3 por MC1
    "MC3-por-MC2": True,
    "MC2-por-MC1": True,
    "MC1-por-MC1": True,
    "MC2-por-MC2": True
}

from typing import List, Dict

def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool],tolvas_criticas:List[str], tiempos_por_tolva: Dict[str, float],path_output: str = "cement_problem.pddl"):

    # Mapeo de tolvas a rutas necesarias
    tolva_a_rutas = {
        "t1-clinker": ["MC1-desde-Pretrit"],
        "t2-clinker": ["MC2-desde-Pretrit"],
        "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
        "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
        "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
        "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
        "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
        "t1-yeso": ["MC1-por-MC1"],
        "t2-yeso": ["MC2-por-MC2"],
        "t3-yeso": ["MC3-por-MC1", "MC3-por-MC1"]
    }

    # Mapeo de tolvas a materiales
    tolva_a_material = {
        "t1-clinker": "clinker",
        "t1-puzolana-h": "puzolana-h",
        "t1-yeso": "yeso",
        "t2-clinker": "clinker",
        "t2-puzolana-h": "puzolana-h",
        "t2-puzolana-s": "puzolana-s",
        "t2-yeso": "yeso",
        "t3-clinker": "clinker",
        "t3-puzolana-s": "puzolana-s",
        "t3-yeso": "yeso"
    }
    
    # Validar que cada tolva crítica tenga al menos una ruta habilitada
    tolvas_validas = []
    for tolva in tolvas_criticas:
        if tolva not in tolva_a_rutas:
            print(f"Error: La tolva {tolva} no está definida en el mapeo de rutas.")
            continue
        rutas_disponibles = [ruta for ruta in tolva_a_rutas[tolva] if estado_rutas.get(ruta, False)]
        if rutas_disponibles:
            tolvas_validas.append(tolva)
        else:
            print(f"Advertencia: La tolva crítica {tolva} no tiene rutas habilitadas. Se excluye del objetivo.")

# Ordenar tolvas válidas por tiempo de vaciado
    tolvas_validas_ordenadas = sorted(tolvas_validas, key=lambda x: tiempos_por_tolva.get(x, float('inf')))

    if not tolvas_validas:
        raise ValueError("No hay tolvas críticas válidas con rutas habilitadas para generar el objetivo.")

    with open(path_output, "w", encoding="utf-8") as f:
        f.write("""(define (problem cement-production-problem)
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
                
    ;; Duraciones
    (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 3)
    (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 2.5)
    (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
    (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 3)
    (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 1.5)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 4)
    (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 4)
    (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 4)
    (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 2)
    (= (duracion-llenado t1-yeso MC1-por-MC1) 2)
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2)2.5)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 3)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6.1)
                
    ;; Rutas disponibles
""")

        rutas = [
            ("mc1", "t1-clinker", "MC1-desde-Pretrit"),
            ("mc2", "t2-clinker", "MC2-desde-Pretrit"),
            ("mc3", "t3-clinker", "MC3-desde_Silo-Blanco"),
            ("mc3", "t3-clinker", "Pretrit_a_Silo_Blanco"),
            ("mc2", "t2-puzolana-h", "PH-a-426HO04-por-MC2"),
            ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC2"),
            ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC1"),
            ("mc3", "t3-puzolana-s", "PS-a-MC3-por-MC2"),
            ("mc2", "t2-puzolana-s", "PS-a-426HO02-por-426HO04"),
            ("mc1", "t1-yeso", "MC1-por-MC1"),
            ("mc2", "t2-yeso", "MC2-por-MC2"),
            ("mc3", "t3-yeso", "MC3-por-MC1"),
            ("mc3", "t3-yeso", "MC3-por-MC2"),
        ]

        for i, (molino, tolva, ruta) in enumerate(rutas):
            material = tolva_a_material.get(tolva, "unknown")
            if estado_rutas.get(ruta, False):
                if i == 0:
                    f.write("    ;; Clinker\n")
                elif i == 4:
                    f.write("    ;; Puzolana\n")
                elif i == 9:
                    f.write("    ;; Yeso\n")
                f.write(f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n")

        # f.write("  )\n\n  (:goal (and\n")
        # for i, tolva in enumerate(tolvas_validas_ordenadas):
        #     f.write(f"    (tolva-llena {tolva})\n")

        # f.write("  ))\n)")


        # f.write("    ;; Tiempos de vaciado\n")
        # for tolva in tolvas_validas:
        #     tiempo = tiempos_por_tolva.get(tolva, float('inf'))
        #     if tiempo != float('inf'):
        #         f.write(f"    (= (tiempo-vaciado {tolva}) {tiempo})\n")

        #f.write("    ;; Duraciones de llenado (estimadas)\n")
        # for tolva in tolvas_validas:
        #f.write(f"    (= (duracion-llenado {tolva}) 0.1)\n")  # Ajusta según datos reales

        f.write("  )\n\n  (:goal (and\n")
        for tolva in tolvas_validas_ordenadas:
            material = tolva_a_material.get(tolva, "unknown")
            f.write(f"    (alimentado {tolva} {material})\n")
            # f.write(f"    (alimentando {tolva})\n ")
        f.write("  ))\n  (:metric minimize (total-time))\n)")

# ---------------------------------------------
# Main
# ---------------------------------------------

def main():
    sistema = SistemaAlimentacion()
    sistema.set_productos()

    # Configurar niveles iniciales
    sistema.mc1.tolvas["clinker"].nivel_actual = 10
    sistema.mc1.tolvas["puzolana"].nivel_actual = 4
    sistema.mc1.tolvas["yeso"].nivel_actual = 6

    sistema.mc2.tolvas["clinker"].nivel_actual = 1
    sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4
    sistema.mc2.tolvas["yeso"].nivel_actual = 6

    sistema.mc3.tolvas["clinker"].nivel_actual = 7
    sistema.mc3.tolvas["puzolana"].nivel_actual = 8
    sistema.mc3.tolvas["yeso"].nivel_actual = 1

    # Definir material_por_tolva usando nombres_tolvas
    nombres_tolvas = {
        "mc1": {"clinker": "t1-clinker", "puzolana": "t1-puzolana", "yeso": "t1-yeso"},
        "mc2": {"clinker": "t2-clinker", "puzolana_humeda": "t2-puzolana-h", "puzolana_seca": "t2-puzolana-s", "yeso": "t2-yeso"},
        "mc3": {"clinker": "t3-clinker", "puzolana": "t3-puzolana-s", "yeso": "t3-yeso"},
    }
    material_por_tolva = {}
    for molino_name, tolvas in nombres_tolvas.items():
        for material, tolva_pddl in tolvas.items():
            material_por_tolva[f"(tolva-llena {tolva_pddl})"] = material

    # Obtener tolvas críticas y tiempos
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)

    # Crear lista de tuplas (tolva, tiempo) para ordenar
    tolvas_con_tiempos = [(tolva, tiempos_por_tolva.get(tolva, float('inf'))) for tolva in tolvas_criticas]
    
    # Ordenar por tiempo de vaciado (menor a mayor)
    tolvas_con_tiempos.sort(key=lambda x: x[1])

    # Imprimir tolvas críticas ordenadas
    print("Tolvas críticas por vaciado (ordenadas por tiempo más crítico):")
    for tolva, tiempo in tolvas_con_tiempos:
        if tiempo == float('inf'):
            print(f" - {tolva}: No disponible")
        else:
            print(f" - {tolva}: {tiempo:.2f} horas")

    # Generar archivo PDDL con tolvas ordenadas
    generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva,"cement_problem.pddl")
    print("\nArchivo 'cement_problem.pddl' generado con éxito.")

if __name__ == "__main__":
    main()