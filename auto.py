import flet as ft
import threading
from typing import Dict, List, Tuple
import enum
import subprocess
import os

# Clases base
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

class SistemaAlimentacion:
    def __init__(self):
        self.mc1 = Molino("MC1", {
            "clinker": Tolva("Clinker", 500, 14),
            "puzolana_humeda": Tolva("Puzolana Húmeda", 300, 12),
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
            "puzolana_seca": Tolva("Puzolana Seca", 35, 100),
            "yeso": Tolva("Yeso", 30, 100)
        }, 0.5)

    def set_productos(self, tipos_produccion: Dict[str, str]):
        producto_map = {
            "P10": TipoProducto.P10,
            "P16": TipoProducto.P16,
            "P20": TipoProducto.P20,
            "P30": TipoProducto.P30,
            "P40": TipoProducto.P40
        }
        ratios = {
            "P30": {"clinker": 68.5, "puzolana_humeda": 30, "yeso": 1.5},
            "P40": {"clinker": 68.5, "puzolana_humeda": 30, "yeso": 1.5},
            "P10": {"clinker": 87, "puzolana_humeda": 10, "yeso": 3},
            "P16": {"clinker": 87, "puzolana_humeda": 10, "yeso": 3},
            "P20": {"clinker": 87, "puzolana_humeda": 10, "yeso": 3}
        }
        alimentacion_fresca = {"P30": 75, "P40": 75, "P10": 65, "P16": 65, "P20": 65}
        if tipos_produccion["MC1"]:
            self.mc1.set_producto(producto_map[tipos_produccion["MC1"]], alimentacion_fresca[tipos_produccion["MC1"]], ratios[tipos_produccion["MC1"]])
        if tipos_produccion["MC2"]:
            self.mc2.set_producto(producto_map[tipos_produccion["MC2"]], alimentacion_fresca[tipos_produccion["MC2"]], ratios[tipos_produccion["MC2"]])
        if tipos_produccion["MC3"]:
            self.mc3.set_producto(producto_map[tipos_produccion["MC3"]], alimentacion_fresca[tipos_produccion["MC3"]], ratios[tipos_produccion["MC3"]])

# Estado inicial de rutas
estado_rutas = {
    "MC1-desde-Pretrit": True,
    "MC2-desde-Pretrit": True,
    "MC3-desde_Silo-Blanco": True,
    "Pretrit_a_Silo_Blanco": True,
    "PH-a-426HO04-por-MC2": True,
    "PH-a-MC1-por-MC2": True,
    "PH-a-MC1-por-MC1": True,
    "PS-a-MC3-por-MC2": True,
    "PS-a-426HO02-por-426HO04": True,
    "MC3-por-MC1": True,
    "MC3-por-MC2": True,
    "MC1-por-MC1": True,
    "MC1-por-MC2": True,
    "MC2-por-MC2": True
}

# Estado inicial de los molinos
estado_molinos = {"MC1": True, "MC2": True, "MC3": True}
tipos_produccion_actual = {"MC1": "P30", "MC2": "P10", "MC3": "P30"}
opciones_produccion = {
    "MC1": ["P30", "P40"],
    "MC2": ["P10", "P16", "P20", "P30"],
    "MC3": ["P30"]
}
materiales_por_molino = {
    "MC1": ["Clinker", "Yeso", "Puzolana_Humeda"],
    "MC2": ["Clinker", "Yeso", "Puzolana_Humeda", "Puzolana_Seca"],
    "MC3": ["Clinker", "Yeso", "Puzolana_Seca"]
}
orden_barras_MC1 = ["Clinker", "Yeso", "Puzolana_Humeda"]
orden_barras_MC2 = ["Clinker", "Yeso", "Puzolana_Humeda", "Puzolana_Seca"]
orden_barras_MC3 = ["Clinker", "Yeso", "Puzolana_Seca"]
materiales = ["Clinker", "Yeso", "Puzolana_Humeda", "Puzolana_Seca"]
molinos = ["MC1", "MC2", "MC3"]

# Referencias para la interfaz
barra_refs_MC1 = {mat: ft.Ref[ft.Container]() for mat in materiales_por_molino["MC1"]}
barra_refs_MC2 = {mat: ft.Ref[ft.Container]() for mat in materiales_por_molino["MC2"]}
barra_refs_MC3 = {mat: ft.Ref[ft.Container]() for mat in materiales_por_molino["MC3"]}
refs_tiempos_MC1 = {mat: ft.Ref[ft.Text]() for mat in materiales}
refs_tiempos_MC2 = {mat: ft.Ref[ft.Text]() for mat in materiales}
refs_tiempos_MC3 = {mat: ft.Ref[ft.Text]() for mat in materiales}

# Límites de tolvas (en metros)
limites_tolvas = {
    "MC1": {
        "Clinker": {"max": 14, "unidad": "m"},
        "Puzolana_Humeda": {"max": 12, "unidad": "m"},
        "Yeso": {"max": 10, "unidad": "m"}
    },
    "MC2": {
        "Clinker": {"max": 9, "unidad": "m"},
        "Puzolana_Humeda": {"max": 15, "unidad": "m"},
        "Puzolana_Seca": {"max": 12, "unidad": "m"},
        "Yeso": {"max": 9, "unidad": "m"}
    },
    "MC3": {
        "Clinker": {"max": 100, "unidad": "%"},
        "Puzolana_Seca": {"max": 100, "unidad": "%"},
        "Yeso": {"max": 100, "unidad": "%"}
    }
}

# Conversión a toneladas
def get_niveles_toneladas(niveles_MC1, niveles_MC2, niveles_MC3):
    capacidades = {
        "MC1": {"Clinker": 500, "Puzolana_Humeda": 300, "Yeso": 300},
        "MC2": {"Clinker": 300, "Puzolana_Humeda": 500, "Puzolana_Seca": 100, "Yeso": 120},
        "MC3": {"Clinker": 60, "Puzolana_Seca": 35, "Yeso": 30}
    }
    return {
        "MC1": {mat: (niveles_MC1.get(mat, 0) * capacidades["MC1"].get(mat, 0)) / limites_tolvas["MC1"].get(mat, {"max": 1})["max"] for mat in materiales_por_molino["MC1"]},
        "MC2": {mat: (niveles_MC2.get(mat, 0) * capacidades["MC2"].get(mat, 0)) / limites_tolvas["MC2"].get(mat, {"max": 1})["max"] for mat in materiales_por_molino["MC2"]},
        "MC3": {mat: (niveles_MC3.get(mat, 0) * capacidades["MC3"].get(mat, 0)) / limites_tolvas["MC3"].get(mat, {"max": 1})["max"] for mat in materiales_por_molino["MC3"]}
    }

# Generar barras de niveles
def crear_barras_con_refs(molino, niveles, limites, refs, orden, refs_tiempos, sistema):
    barras = []
    for material in orden:
        if material in niveles[molino]:
            nivel = float(niveles[molino][material])
            limite = limites[molino][material]["max"]
            porcentaje = nivel / limite if limite > 0 else 0
            color = ft.Colors.RED_700 if porcentaje <= 0.3 else ft.Colors.YELLOW_700 if porcentaje <= 0.7 else ft.Colors.LIGHT_GREEN_600
            tiempo = sistema.tiempo_vaciado(molino, material.lower().replace(" ", "_"))
            texto = f"{material} (No disponible)" if tiempo == float('inf') else f"{material} ({tiempo:.2f} h)"
            barras.append(
                ft.Column([
                    ft.Text(texto, size=12, ref=refs_tiempos[material]),
                    ft.Container(
                        width=35,
                        height=100,
                        bgcolor=ft.Colors.GREY_300,
                        border_radius=5,
                        alignment=ft.alignment.bottom_center,
                        content=ft.Container(
                            ref=refs[material],
                            width=35,
                            height=100 * porcentaje,
                            bgcolor=color,
                            border_radius=5
                        )
                    )
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=5)
            )
    return barras

# Generar problema PDDL
def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl"):
    tolva_a_rutas = {
        "t1-clinker": ["MC1-desde-Pretrit"],
        "t2-clinker": ["MC2-desde-Pretrit"],
        "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
        "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
        "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
        "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
        "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
        "t1-yeso": ["MC1-por-MC1", "MC1-por-MC2"],
        "t2-yeso": ["MC2-por-MC2"],
        "t3-yeso": ["MC3-por-MC1", "MC3-por-MC2"]
    }
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
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
  )
  (:init
    (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
    (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
    (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)
""")
        for molino in ["mc1", "mc2", "mc3"]:
            if estado_molinos[molino.upper()]:
                f.write(f"    (en-marcha {molino})\n")
        f.write("""    ;; Duraciones
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
    (= (duracion-llenado t2-yeso MC2-por-MC2) 2.5)
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
            ("mc1", "t1-yeso", "MC1-por-MC2"),
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
        f.write("    ;; Costos de prioridad\n")
        for tolva in tolvas_validas:
            tiempo = tiempos_por_tolva.get(tolva, float('inf'))
            costo = 100 / (tiempo + 1) if tiempo != float('inf') else 1
            f.write(f"    (= (costo-prioridad {tolva}) {costo})\n")
        f.write("  )\n\n  (:goal (and\n")
        for tolva in tolvas_validas_ordenadas:
            material = tolva_a_material.get(tolva, "unknown")
            f.write(f"    (alimentado {tolva} {material})\n")
        f.write("  ))\n  (:metric minimize (total-cost))\n)")

# Ejecutar planificador PDDL
def ejecutar_planificador(domain_file: str, problem_file: str) -> List[str]:
    output_file = "plan_output.txt"
    try:
        # Asume que Fast Downward está instalado y en el PATH
        cmd = f"fast-downward.py {domain_file} {problem_file} --search 'astar(lmcut())'"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            raise RuntimeError(f"Error al ejecutar el planificador: {result.stderr}")
        
        # Parsear la salida (esto depende del formato del planificador)
        plan = []
        with open("sas_plan", "r") as f:
            for line in f:
                if line.startswith("("):
                    plan.append(line.strip())
        return plan
    except Exception as e:
        return [f"Error al generar el plan: {str(e)}"]

# Calcular tiempos de vaciado
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
        "mc1": {"clinker": "t1-clinker", "puzolana_humeda": "t1-puzolana-h", "yeso": "t1-yeso"},
        "mc2": {"clinker": "t2-clinker", "puzolana_humeda": "t2-puzolana-h", "puzolana_seca": "t2-puzolana-s", "yeso": "t2-yeso"},
        "mc3": {"clinker": "t3-clinker", "puzolana_seca": "t3-puzolana-s", "yeso": "t3-yeso"},
    }
    for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
        tiempos = calcular_tiempos_vaciado(molino, imprimir=True)
        nombre_molino = molino.nombre.lower()
        for mat, tiempo in tiempos.items():
            nombre_tolva_pddl = nombres_tolvas[nombre_molino].get(mat)
            if nombre_tolva_pddl:
                tiempos_por_tolva[nombre_tolva_pddl] = tiempo
                if tiempo < umbral and tiempo != float('inf'):
                    tolvas_a_llenar.append(nombre_tolva_pddl)
    return tolvas_a_llenar, tiempos_por_tolva

# Interfaz principal
def main(page: ft.Page):
    sistema = SistemaAlimentacion()
    sistema.set_productos(tipos_produccion_actual)
    
    # Configuración inicial de niveles
    niveles = {
        "MC1": {mat: ft.TextField(value="0", width=30, color="white", border=ft.InputBorder.NONE) for mat in materiales},
        "MC2": {mat: ft.TextField(value="0", width=30, color="white", border=ft.InputBorder.NONE, padding=ft.padding.only(right=26)) for mat in materiales},
        "MC3": {mat: ft.TextField(value="0", width=30, color="white", border=ft.InputBorder.NONE) for mat in materiales}
    }
    calculo_toneladas = {
        "MC1": {mat: ft.TextField(value="0", width=50, color="white", read_only=True, border=ft.InputBorder.NONE) for mat in materiales},
        "MC2": {mat: ft.TextField(value="0", width=50, color="white", read_only=True, border=ft.InputBorder.NONE) for mat in materiales},
        "MC3": {mat: ft.TextField(value="0", width=50, color="white", read_only=True, border=ft.InputBorder.NONE) for mat in materiales}
    }
    
    dropdown_mc1 = ft.Ref[ft.Dropdown]()
    dropdown_mc2 = ft.Ref[ft.Dropdown]()
    dropdown_mc3 = ft.Ref[ft.Dropdown]()
    dropdown_prod_mc1 = ft.Ref[ft.Dropdown]()
    dropdown_prod_mc2 = ft.Ref[ft.Dropdown]()
    
    def actualizar_estado_molino(molino, nuevo_estado):
        estado_molinos[molino] = nuevo_estado == "En marcha"
        ref = {"MC1": dropdown_mc1, "MC2": dropdown_mc2, "MC3": dropdown_mc3}[molino]
        ref.current.color = ft.Colors.GREEN_ACCENT_400 if estado_molinos[molino] else ft.Colors.RED_400
        ref.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
        ref.current.update()

    def actualizar_produccion_molino(molino, nuevo_producto):
        tipos_produccion_actual[molino] = nuevo_producto
        ref = {"MC1": dropdown_prod_mc1, "MC2": dropdown_prod_mc2}[molino]
        ref.current.value = nuevo_producto
        ref.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
        ref.current.update()

    def calcular_tiempos(e):
        try:
            niveles_MC1 = {mat: float(niveles["MC1"][mat].value) for mat in materiales}
            niveles_MC2 = {mat: float(niveles["MC2"][mat].value) for mat in materiales}
            niveles_MC3 = {mat: float(niveles["MC3"][mat].value) for mat in materiales}

            sistema.mc1.tolvas["clinker"].nivel_actual = niveles_MC1.get("Clinker", 0)
            sistema.mc1.tolvas["puzolana_humeda"].nivel_actual = niveles_MC1.get("Puzolana_Humeda", 0)
            sistema.mc1.tolvas["yeso"].nivel_actual = niveles_MC1.get("Yeso", 0)
            sistema.mc2.tolvas["clinker"].nivel_actual = niveles_MC2.get("Clinker", 0)
            sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = niveles_MC2.get("Puzolana_Humeda", 0)
            sistema.mc2.tolvas["puzolana_seca"].nivel_actual = niveles_MC2.get("Puzolana_Seca", 0)
            sistema.mc2.tolvas["yeso"].nivel_actual = niveles_MC2.get("Yeso", 0)
            sistema.mc3.tolvas["clinker"].nivel_actual = niveles_MC3.get("Clinker", 0)
            sistema.mc3.tolvas["puzolana_seca"].nivel_actual = niveles_MC3.get("Puzolana_Seca", 0)
            sistema.mc3.tolvas["yeso"].nivel_actual = niveles_MC3.get("Yeso", 0)

            sistema.set_productos(tipos_produccion_actual)
            niveles_toneladas = get_niveles_toneladas(niveles_MC1, niveles_MC2, niveles_MC3)
            
            for mat in materiales:
                calculo_toneladas["MC1"][mat].value = str(niveles_toneladas["MC1"].get(mat, 0))
                calculo_toneladas["MC2"][mat].value = str(niveles_toneladas["MC2"].get(mat, 0))
                calculo_toneladas["MC3"][mat].value = str(niveles_toneladas["MC3"].get(mat, 0))

            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
            plan = ejecutar_planificador("cement-alimentacion.pddl", "cement_problem.pddl")
            
            # Actualizar barras
            for molino, refs, orden, refs_tiempos in [
                ("MC1", barra_refs_MC1, orden_barras_MC1, refs_tiempos_MC1),
                ("MC2", barra_refs_MC2, orden_barras_MC2, refs_tiempos_MC2),
                ("MC3", barra_refs_MC3, orden_barras_MC3, refs_tiempos_MC3)
            ]:
                for mat in limites_tolvas[molino]:
                    if mat in niveles[molino]:
                        limite = limites_tolvas[molino][mat]["max"]
                        porcentaje = niveles[molino][mat] / limite if limite > 0 else 0
                        refs[mat].current.height = 100 * porcentaje
                        color = ft.Colors.RED_700 if porcentaje <= 0.3 else ft.Colors.YELLOW_700 if porcentaje <= 0.7 else ft.Colors.LIGHT_GREEN_600
                        refs[mat].current.bgcolor = color
                for mat in materiales:
                    tiempo = sistema.tiempo_vaciado(molino, mat.lower().replace(" ", "_"))
                    texto = f"{mat} (No disponible)" if tiempo == float('inf') else f"{mat} ({tiempo:.2f} h)"
                    if refs_tiempos.get(mat) and refs_tiempos[mat].current:
                        refs_tiempos[mat].current.value = texto
                        refs_tiempos[mat].current.update()

            info_text.value = "\n".join(plan) if plan else "No se pudo generar un plan."
            page.snack_bar = ft.SnackBar(content=ft.Text("Plan generado correctamente.", color="black"), bgcolor="#00FF00", open=True)
        except ValueError as ve:
            page.snack_bar = ft.SnackBar(content=ft.Text(str(ve), color="white"), bgcolor=ft.Colors.RED_700, open=True)
            info_text.value = "Error: No se pudieron generar recomendaciones."
        page.update()

    # Configuración de la página
    page.title = "Gestión de Alimentaciones y Recomendaciones"
    page.window_width = 1400
    page.window_height = 300
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = ft.Colors.BLUE_GREY_900
    page.theme = ft.Theme(
        color_scheme=ft.ColorScheme(
            primary=ft.Colors.BLUE_ACCENT_700,
            secondary=ft.Colors.GREEN_ACCENT_700,
            background=ft.Colors.BLUE_GREY_900,
            surface=ft.Colors.GREY_900,
            on_background=ft.Colors.WHITE,
            on_surface=ft.Colors.WHITE,
        ),
        text_theme=ft.TextTheme(
            body_large=ft.TextStyle(color=ft.Colors.WHITE, font_family="Roboto"),
            body_medium=ft.TextStyle(color=ft.Colors.WHITE70, font_family="Roboto"),
            title_large=ft.TextStyle(color=ft.Colors.WHITE, font_family="Roboto", size=24, weight=ft.FontWeight.BOLD),
        ),
    )

    # Paneles de niveles
    niveles_column_MC1 = ft.Container(
        content=ft.Column(
            [
                ft.Text("Molino de Cemento 1", size=16, weight=ft.FontWeight.BOLD, color="white"),
                ft.Row(
                    [
                        ft.Container(
                            content=ft.Dropdown(
                                ref=dropdown_mc1,
                                width=140,
                                options=[ft.dropdown.Option("En marcha"), ft.dropdown.Option("Detenido")],
                                value="En marcha" if estado_molinos["MC1"] else "Detenido",
                                on_change=lambda e: actualizar_estado_molino("MC1", e.control.value),
                                border_color=ft.Colors.TRANSPARENT,
                                color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC1"] else ft.Colors.RED_400,
                                text_style=ft.TextStyle(weight=ft.FontWeight.BOLD, height=1.2),
                                content_padding=ft.padding.only(left=6, top=12),
                            ),
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,
                            border_radius=5,
                            alignment=ft.alignment.center,
                        ),
                        ft.Container(
                            ft.Row([
                                ft.Text("Producto:", width=75, weight="bold", size=14, color="white"),
                                ft.Dropdown(
                                    ref=dropdown_prod_mc1,
                                    width=89,
                                    value=tipos_produccion_actual["MC1"],
                                    options=[ft.dropdown.Option(op) for op in opciones_produccion["MC1"]],
                                    on_change=lambda e: actualizar_produccion_molino("MC1", e.control.value),
                                    text_size=14,
                                    border_color=ft.Colors.TRANSPARENT,
                                    text_style=ft.TextStyle(weight=ft.FontWeight.BOLD, size=14, color=ft.Colors.WHITE),
                                    bgcolor=ft.Colors.BLUE_GREY_800
                                )
                            ], spacing=0, alignment=ft.MainAxisAlignment.CENTER),
                            width=164,
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,
                            border_radius=5,
                            alignment=ft.alignment.center,
                        )
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=20
                ),
                ft.Row(
                    [
                        ft.Column(
                            [
                                ft.Text(mat, color="white"),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            niveles["MC1"][mat],
                                            ft.Text(limites_tolvas["MC1"][mat]["unidad"], color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0),
                                    alignment=ft.alignment.center
                                ),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC1"][mat],
                                            ft.Text("ton", color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0)
                                ),
                            ],
                            spacing=5,
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        ) for mat in materiales_por_molino["MC1"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),
                ft.Container(
                    content=ft.Row(
                        crear_barras_con_refs("MC1", niveles, limites_tolvas, barra_refs_MC1, orden_barras_MC1, refs_tiempos_MC1, sistema),
                        alignment=ft.MainAxisAlignment.CENTER,
                        vertical_alignment=ft.CrossAxisAlignment.START
                    )
                )
            ],
            spacing=15,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        bgcolor=ft.Colors.BLUE_GREY_600,
        padding=10,
        border_radius=5,
    )

    niveles_column_MC2 = ft.Container(
        content=ft.Column(
            [
                ft.Text("Molino de Cemento 2", size=16, weight=ft.FontWeight.BOLD, color="white"),
                ft.Row(
                    [
                        ft.Container(
                            content=ft.Dropdown(
                                ref=dropdown_mc2,
                                width=140,
                                options=[ft.dropdown.Option("En marcha"), ft.dropdown.Option("Detenido")],
                                value="En marcha" if estado_molinos["MC2"] else "Detenido",
                                on_change=lambda e: actualizar_estado_molino("MC2", e.control.value),
                                border_color=ft.Colors.TRANSPARENT,
                                color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC2"] else ft.Colors.RED_400,
                                text_style=ft.TextStyle(weight=ft.FontWeight.BOLD, height=1.2),
                                content_padding=ft.padding.only(left=6, top=12),
                            ),
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,
                            border_radius=5,
                            alignment=ft.alignment.center,
                        ),
                        ft.Container(
                            ft.Row([
                                ft.Text("Producto:", width=75, weight="bold", size=14, color="white"),
                                ft.Dropdown(
                                    ref=dropdown_prod_mc2,
                                    width=89,
                                    value=tipos_produccion_actual["MC2"],
                                    options=[ft.dropdown.Option(op) for op in opciones_produccion["MC2"]],
                                    on_change=lambda e: actualizar_produccion_molino("MC2", e.control.value),
                                    text_size=14,
                                    border_color=ft.Colors.TRANSPARENT,
                                    text_style=ft.TextStyle(weight=ft.FontWeight.BOLD, size=14, color=ft.Colors.WHITE),
                                    bgcolor=ft.Colors.BLUE_GREY_800
                                )
                            ], spacing=0, alignment=ft.MainAxisAlignment.CENTER),
                            width=164,
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,
                            border_radius=5,
                            alignment=ft.alignment.center,
                        )
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=20
                ),
                ft.Row(
                    [
                        ft.Column(
                            [
                                ft.Text(mat, color="white"),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            niveles["MC2"][mat],
                                            ft.Text(limites_tolvas["MC2"][mat]["unidad"], color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0),
                                    alignment=ft.alignment.center
                                ),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC2"][mat],
                                            ft.Text("ton", color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0)
                                ),
                            ],
                            spacing=5,
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        ) for mat in materiales_por_molino["MC2"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),
                ft.Container(
                    content=ft.Row(
                        crear_barras_con_refs("MC2", niveles, limites_tolvas, barra_refs_MC2, orden_barras_MC2, refs_tiempos_MC2, sistema),
                        alignment=ft.MainAxisAlignment.CENTER,
                        vertical_alignment=ft.CrossAxisAlignment.START
                    )
                )
            ],
            spacing=15,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        bgcolor=ft.Colors.BLUE_GREY_600,
        padding=10,
        border_radius=5,
    )

    niveles_column_MC3 = ft.Container(
        content=ft.Column(
            [
                ft.Text("Molino de Cemento 3", size=16, weight=ft.FontWeight.BOLD, color="white"),
                ft.Row(
                    [
                        ft.Container(
                            content=ft.Dropdown(
                                ref=dropdown_mc3,
                                width=140,
                                options=[ft.dropdown.Option("En marcha"), ft.dropdown.Option("Detenido")],
                                value="En marcha" if estado_molinos["MC3"] else "Detenido",
                                on_change=lambda e: actualizar_estado_molino("MC3", e.control.value),
                                border_color=ft.Colors.TRANSPARENT,
                                color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC3"] else ft.Colors.RED_400,
                                text_style=ft.TextStyle(weight=ft.FontWeight.BOLD, height=1.2),
                                content_padding=ft.padding.only(left=6, top=12),
                            ),
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,
                            border_radius=5,
                            alignment=ft.alignment.center,
                        ),
                        ft.Container(
                            content=ft.Row(
                                [
                                    ft.Text("Producto:", size=14, color="white", weight="bold"),
                                    ft.Text(tipos_produccion_actual["MC3"], color="white", size=14, weight="bold")
                                ],
                                spacing=10,
                                alignment=ft.MainAxisAlignment.CENTER
                            ),
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=10,
                            border_radius=5,
                            width=150,
                            height=47,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=20
                ),
                ft.Row(
                    [
                        ft.Column(
                            [
                                ft.Text(mat, color="white"),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            niveles["MC3"][mat],
                                            ft.Text(limites_tolvas["MC3"][mat]["unidad"], color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0),
                                    alignment=ft.alignment.center
                                ),
                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC3"][mat],
                                            ft.Text("ton", color="white")
                                        ],
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0)
                                ),
                            ],
                            spacing=5,
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        ) for mat in materiales_por_molino["MC3"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),
                ft.Container(
                    content=ft.Row(
                        crear_barras_con_refs("MC3", niveles, limites_tolvas, barra_refs_MC3, orden_barras_MC3, refs_tiempos_MC3, sistema),
                        alignment=ft.MainAxisAlignment.CENTER,
                        vertical_alignment=ft.CrossAxisAlignment.START
                    )
                )
            ],
            spacing=15,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        bgcolor=ft.Colors.BLUE_GREY_600,
        padding=10,
        border_radius=5,
    )

    info_text = ft.Text(value="", size=25, color="white")
    info_container = ft.Container(
        content=info_text,
        padding=20,
        bgcolor=ft.Colors.BLUE_GREY_600,
        border=ft.border.all(1, ft.Colors.BLUE),
        border_radius=5,
        width=1000,
    )
    info_container_centered = ft.Row(controls=[info_container], alignment=ft.MainAxisAlignment.CENTER)

    def crear_fila_ruta(nombre, estado):
        def on_click(e):
            tolvas_criticas, _ = obtener_tolvas_a_llenar_por_tiempos(sistema)
            tolva_a_rutas = {
                "t1-clinker": ["MC1-desde-Pretrit"],
                "t2-clinker": ["MC2-desde-Pretrit"],
                "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
                "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
                "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
                "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
                "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
                "t1-yeso": ["MC1-por-MC1", "MC1-por-MC2"],
                "t2-yeso": ["MC2-por-MC2"],
                "t3-yeso": ["MC3-por-MC1", "MC3-por-MC2"]
            }
            for tolva in tolvas_criticas:
                if nombre in tolva_a_rutas.get(tolva, []):
                    if not any(estado_rutas.get(r, False) for r in tolva_a_rutas[tolva] if r != nombre):
                        page.snack_bar = ft.SnackBar(
                            content=ft.Text(f"No se puede desactivar {nombre}: es la única ruta disponible para {tolva}."),
                            bgcolor=ft.Colors.RED_700,
                            open=True
                        )
                        page.update()
                        return
            estado_rutas[nombre] = not estado_rutas[nombre]
            menu_column.controls = construir_column_rutas()
            page.update()

        return ft.Container(
            content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
            padding=5,
            on_click=on_click,
            width=245
        )

    def construir_column_rutas():
        controls = [
            ft.Container(content=ft.Text("CLINKER", weight="bold", size=15, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER), alignment=ft.alignment.center),
            *[crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[:4]],
            ft.Divider(),
            ft.Container(content=ft.Text("PUZOLANA", weight="bold", size=15, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER), alignment=ft.alignment.center),
            *[crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[4:9]],
            ft.Divider(),
            ft.Container(content=ft.Text("YESO", weight="bold", size=15, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER), alignment=ft.alignment.center),
            *[crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[9:]]
        ]
        return controls

    menu_column = ft.Column(controls=construir_column_rutas())
    menu_rutas = ft.PopupMenuButton(
        icon=ft.Icons.MENU,
        items=[ft.PopupMenuItem(content=menu_column)]
    )

    titulo_container = ft.Container(
        content=ft.Row(
            [
                menu_rutas,
                ft.Text("OPTIMIZACIÓN DE ALIMENTACIONES", size=50, weight=ft.FontWeight.BOLD, color="white"),
                ft.Image(src="UNACEM_Logos_Finales-01-1600x1132.png", width=130, height=130, fit=ft.ImageFit.CONTAIN),
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            vertical_alignment=ft.CrossAxisAlignment.CENTER
        ),
        alignment=ft.alignment.center,
        width=1530,
        height=70,
    )

    contenido_principal = ft.Container(
        content=ft.Column(
            [
                titulo_container,
                ft.Row([niveles_column_MC1, niveles_column_MC2, niveles_column_MC3], alignment=ft.MainAxisAlignment.CENTER, spacing=10),
                ft.Row(
                    [
                        ft.ElevatedButton("Generar recomendaciones", on_click=calcular_tiempos, bgcolor=ft.Colors.BLUE_ACCENT_700, color="white"),
                        info_container_centered
                    ],
                    alignment=ft.MainAxisAlignment.CENTER
                )
            ],
            spacing=20,
            scroll=ft.ScrollMode.AUTO,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        expand=True
    )

    page.add(ft.Row([contenido_principal], expand=True, vertical_alignment=ft.CrossAxisAlignment.START))

ft.app(target=main)