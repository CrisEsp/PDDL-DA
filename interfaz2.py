import flet as ft
import enum
import subprocess
import os
import json
import threading
import time
from typing import List, Dict, Tuple, Optional
from pathlib import Path

# ---------------------------------------------
# Clases base (sin cambios)
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
        self.productos_disponibles = {}
        self.en_marcha = True

    def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
        self.tipo_producto = tipo_producto
        self.alimentacion_fresca = alimentacion_fresca
        self.ratios = ratios
        self.productos_disponibles[tipo_producto] = {
            "alimentacion_fresca": alimentacion_fresca,
            "ratios": ratios
        }

    def set_alimentacion_fresca(self, alimentacion_fresca: float):
        self.alimentacion_fresca = alimentacion_fresca
        if self.tipo_producto and self.tipo_producto in self.productos_disponibles:
            self.productos_disponibles[self.tipo_producto]["alimentacion_fresca"] = alimentacion_fresca

    def set_estado(self, en_marcha: bool):
        self.en_marcha = en_marcha

    def cambiar_producto(self, tipo_producto: TipoProducto):
        if tipo_producto in self.productos_disponibles:
            self.tipo_producto = tipo_producto
            self.alimentacion_fresca = self.productos_disponibles[tipo_producto]["alimentacion_fresca"]
            self.ratios = self.productos_disponibles[tipo_producto]["ratios"]

    def tiempo_vaciado(self, material: str) -> float:
        if material not in self.ratios or material not in self.tolvas:
            return float('inf')
        consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
        return self.tolvas[material].tiempo_vaciado(consumo)

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
        self.mc1.set_producto(TipoProducto.P30, 72.0, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
        self.mc1.set_producto(TipoProducto.P40, 64.0, {"clinker": 58.5, "puzolana": 40, "yeso": 1.5})
        self.mc2.set_producto(TipoProducto.P10, 70.0, {"clinker": 87, "puzolana_humeda": 5, "puzolana_seca": 5, "yeso": 3})
        self.mc2.set_producto(TipoProducto.P16, 80.0, {"clinker": 81.5, "puzolana_humeda": 8, "puzolana_seca": 8, "yeso": 2.5})
        self.mc2.set_producto(TipoProducto.P20, 87.0, {"clinker": 85.5, "puzolana_humeda": 6, "puzolana_seca": 6, "yeso": 2.5})
        self.mc2.set_producto(TipoProducto.P30, 110.0, {"clinker": 68, "puzolana_humeda": 15, "puzolana_seca": 15, "yeso": 2})
        self.mc3.set_producto(TipoProducto.P30, 37.0, {"clinker": 67.5, "puzolana": 30, "yeso": 2.5})

# ---------------------------------------------
# Configuración y gestión del planificador PDDL
# ---------------------------------------------

class PDDLConfig:
    def __init__(self):
        self.domain_file = "cement_domain.pddl"
        self.problem_file = "cement_problem.pddl"
        self.output_file = "solution.txt"
        self.tfd_path = self.find_tfd_path()
        self.working_dir = Path.cwd()
        
    def find_tfd_path(self) -> Optional[str]:
        """Busca la ruta del ejecutable TFD en ubicaciones comunes"""
        possible_paths = [
            "tfd",  # Si está en PATH
            "./tfd",  # En directorio actual
            "./planners/tfd",
            "C:/Program Files/TFD/tfd.exe",  # Windows
            "/usr/local/bin/tfd",  # Linux/Mac
            "/opt/tfd/tfd",  # Linux
        ]
        
        for path in possible_paths:
            try:
                result = subprocess.run([path, "--help"], 
                                      capture_output=True, 
                                      timeout=5)
                if result.returncode == 0:
                    return path
            except:
                continue
        return None
    
    def set_tfd_path(self, path: str):
        """Permite configurar manualmente la ruta de TFD"""
        self.tfd_path = path

class PDDLPlanificador:
    def __init__(self, config: PDDLConfig):
        self.config = config
        self.is_running = False
        self.last_solution = None
        self.last_error = None
        
    def crear_dominio_pddl(self):
        """Crea el archivo de dominio PDDL si no existe"""
        domain_content = """(define (domain cement-alimentacion)
  (:requirements :typing :fluents :durative-actions :timed-initial-literals)
  
  (:types
    molino tolva materia ruta - object
  )
  
  (:predicates
    (libre ?t - tolva)
    (alimentado ?t - tolva ?m - materia)
    (compatible ?m - materia ?t - tolva)
    (material-disponible ?m - materia)
    (ruta-disponible ?mo - molino ?t - tolva ?m - materia ?r - ruta)
    (en-marcha ?mo - molino)
  )
  
  (:functions
    (costo-prioridad ?t - tolva)
    (duracion-llenado ?t - tolva ?r - ruta)
    (tiempo-vaciado ?t - tolva)
    (total-cost)
  )
  
  (:durative-action llenar-tolva
    :parameters (?mo - molino ?t - tolva ?m - materia ?r - ruta)
    :duration (= ?duration (duracion-llenado ?t ?r))
    :condition (and
      (at start (libre ?t))
      (at start (compatible ?m ?t))
      (at start (material-disponible ?m))
      (at start (ruta-disponible ?mo ?t ?m ?r))
      (at start (en-marcha ?mo))
    )
    :effect (and
      (at start (not (libre ?t)))
      (at end (alimentado ?t ?m))
      (at end (increase (total-cost) (/ (costo-prioridad ?t) (tiempo-vaciado ?t))))
    )
  )
)"""
        
        with open(self.config.domain_file, 'w', encoding='utf-8') as f:
            f.write(domain_content)
    
    def ejecutar_planificador(self, timeout: int = 30) -> Dict:
        """Ejecuta TFD y retorna los resultados"""
        if not self.config.tfd_path:
            return {
                "success": False,
                "error": "TFD no encontrado. Configure la ruta manualmente.",
                "solution": None
            }
        
        if self.is_running:
            return {
                "success": False,
                "error": "El planificador ya está ejecutándose",
                "solution": None
            }
        
        try:
            self.is_running = True
            self.crear_dominio_pddl()
            
            # Comando para ejecutar TFD
            cmd = [
                self.config.tfd_path,
                self.config.domain_file,
                self.config.problem_file,
                "--search", "astar(lmcut())"  # Búsqueda A* con heurística LM-Cut
            ]
            
            print(f"Ejecutando: {' '.join(cmd)}")
            
            # Ejecutar el planificador
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=self.config.working_dir
            )
            
            if result.returncode == 0:
                # Procesar la solución
                solution = self.parsear_solucion(result.stdout)
                self.last_solution = solution
                self.last_error = None
                
                # Guardar salida completa
                with open(self.config.output_file, 'w', encoding='utf-8') as f:
                    f.write(result.stdout)
                
                return {
                    "success": True,
                    "error": None,
                    "solution": solution,
                    "raw_output": result.stdout
                }
            else:
                error_msg = result.stderr or "Error desconocido en el planificador"
                self.last_error = error_msg
                return {
                    "success": False,
                    "error": error_msg,
                    "solution": None
                }
                
        except subprocess.TimeoutExpired:
            return {
                "success": False,
                "error": f"El planificador excedió el tiempo límite de {timeout} segundos",
                "solution": None
            }
        except Exception as e:
            return {
                "success": False,
                "error": f"Error ejecutando TFD: {str(e)}",
                "solution": None
            }
        finally:
            self.is_running = False
    
    def parsear_solucion(self, output: str) -> List[Dict]:
        """Parsea la salida del planificador y extrae las acciones"""
        acciones = []
        lines = output.split('\n')
        
        for line in lines:
            line = line.strip()
            # Buscar líneas que contengan acciones
            if "llenar-tolva" in line.lower():
                try:
                    # Parsear la acción (formato puede variar según TFD)
                    if ":" in line:
                        time_part, action_part = line.split(":", 1)
                        tiempo = float(time_part.strip())
                        
                        # Extraer parámetros de la acción
                        action_clean = action_part.strip()
                        if "(" in action_clean and ")" in action_clean:
                            params_str = action_clean[action_clean.find("(")+1:action_clean.rfind(")")]
                            params = [p.strip() for p in params_str.split()]
                            
                            if len(params) >= 4:
                                acciones.append({
                                    "tiempo": tiempo,
                                    "accion": "llenar-tolva",
                                    "molino": params[0],
                                    "tolva": params[1],
                                    "material": params[2],
                                    "ruta": params[3]
                                })
                except:
                    continue
        
        return sorted(acciones, key=lambda x: x.get("tiempo", 0))

# ---------------------------------------------
# Variables globales
# ---------------------------------------------

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
    "MC1-por-MC1": True,
    "MC1-por-MC2": True,
    "MC2-por-MC2": True,
    "MC3-por-MC1": True,
    "MC3-por-MC2": True
}

estado_molinos = {
    "mc1": True,
    "mc2": False,
    "mc3": True
}

# Variables para los controles de UI
status_dropdowns = {}
level_fields = {}
feed_rate_fields = {}
pddl_display = None
solution_display = None

# Configuración y planificador
pddl_config = PDDLConfig()
planificador = PDDLPlanificador(pddl_config)

# ---------------------------------------------
# Funciones de actualización (sin cambios significativos)
# ---------------------------------------------

def update_feed_rate(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    try:
        new_feed = float(value)
        if new_feed >= 0:
            print(f"Antes de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            molino.set_alimentacion_fresca(new_feed)
            print(f"Después de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            pddl_content = generar_problema_pddl_dinamico(estado_molinos,estado_rutas, tolvas_criticas, tiempos_por_tolva)
            update_pddl_display(pddl_content, page)
            page.snack_bar = ft.SnackBar(ft.Text(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h"), open=True, duration=2000)
            page.update()
        else:
            print(f"Valor inválido para alimentación fresca: {value} (debe ser no negativo)")
            page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser no negativo"), open=True, duration=2000)
            page.update()
    except ValueError:
        print(f"Valor inválido para alimentación fresca: {value}")
        page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser numérico"), open=True, duration=2000)
        page.update()

def update_product_type(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    try:
        tipo_producto = TipoProducto(value)
        molino.cambiar_producto(tipo_producto)
        print(f"Producto de {molino.nombre} cambiado a {value}")
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(estado_molinos,estado_rutas, tolvas_criticas, tiempos_por_tolva)
        update_pddl_display(pddl_content, page)
    except ValueError:
        print(f"Tipo de producto inválido: {value}")
        page.snack_bar = ft.SnackBar(ft.Text(f"Tipo de producto inválido: {value}"), open=True, duration=2000)
        page.update()

def update_running_state(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    estado = value == "Encendido"
    molino.set_estado(estado)
    estado_molinos[molino.nombre.lower()] = estado
    print(f"Estado de {molino.nombre} cambiado a {'Encendido' if estado else 'Apagado'}")
    
    dropdown_key = f"{molino.nombre}_status"
    if dropdown_key in status_dropdowns:
        status_dropdowns[dropdown_key].value = value
        status_dropdowns[dropdown_key].color = ft.Colors.GREEN if estado else ft.Colors.RED
    
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
    pddl_content = generar_problema_pddl_dinamico(estado_molinos,estado_rutas, tolvas_criticas, tiempos_por_tolva)
    update_pddl_display(pddl_content, page)
    
    page.snack_bar = ft.SnackBar(ft.Text(f"Estado de {molino.nombre} cambiado a {'Encendido' if estado else 'Apagado'}"), open=True, duration=2000)
    page.update()

# ---------------------------------------------
# Funciones para vaciado y generación PDDL (sin cambios)
# ---------------------------------------------

def calcular_tiempos_vaciado(molino: Molino, imprimir: bool = True) -> Dict[str, float]:
    tiempos = {}
    for material in molino.tolvas:
        tiempos[material] = molino.tiempo_vaciado(material)
        if imprimir:
            print(f"Tiempo de vaciado para {molino.nombre} - {material}: {tiempos[material]:.2f} horas")
    return tiempos

def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=3) -> Tuple[List[str], Dict[str, float]]:
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
                    tolvas_a_llenar.append(nombre_tolva_pddl)
    return tolvas_a_llenar, tiempos_por_tolva

def generar_problema_pddl_dinamico(estado_molinos: Dict[str, bool], estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
    # [Mantener la función original sin cambios]
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
    
    pddl_content = """(define (problem cement-production-problem)
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
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)

    (= (costo-prioridad t1-clinker) 166.67)
    (= (costo-prioridad t1-puzolana-h) 476.19)
    (= (costo-prioridad t1-yeso) 270.27)
    (= (costo-prioridad t2-clinker) 47619.19)
    (= (costo-prioridad t2-puzolana-h) 142.86)
    (= (costo-prioridad t2-puzolana-s) 400.00)
    (= (costo-prioridad t2-yeso) 270.27)
    (= (costo-prioridad t3-clinker) 163.93)
    (= (costo-prioridad t3-puzolana-s) 400.00)
    (= (costo-prioridad t3-yeso) 270.27)
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

"""
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

    for molino in ["mc1", "mc2", "mc3"]:  
        if estado_molinos.get(molino, False):
            pddl_content += f"    (en-marcha {molino})\n"  

    for i, (molino, tolva, ruta) in enumerate(rutas):
        material = tolva_a_material.get(tolva, "Desconocido")
        if estado_molinos.get(molino, False):
            if estado_rutas.get(ruta, False):
                if i == 0:
                    pddl_content += "    ;; Clinker\n"
                elif i == 4:
                    pddl_content += "    ;; Puzolana\n"
                elif i == 9:
                    pddl_content += "    ;; Yeso\n"
                pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"
    pddl_content += "    ;; Tiempos de vaciado\n"

    for tolva in tolva_a_rutas:
        tiempo = tiempos_por_tolva.get(tolva, float('inf'))
        if tiempo != float('inf'):
            pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"
    pddl_content += "  )\n\n  (:goal (and\n"
    for tolva in tolvas_validas_ordenadas:
        molino = tolva.split('-')[0].replace('t', 'mc')
        if estado_molinos.get(molino, False):
            material = tolva_a_material.get(tolva, "unknown")
            pddl_content += f"    (alimentado {tolva} {material})\n"
    pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"
    with open(path_output, "w") as f:
        f.write(pddl_content)
    return pddl_content

# ---------------------------------------------
# Funciones de automatización PDDL
# ---------------------------------------------

def ejecutar_planificacion_automatica(sistema: SistemaAlimentacion, page: ft.Page):
    """Ejecuta todo el proceso PDDL de forma automática"""
    def run_planning():
        try:
            # Mostrar estado de carga
            update_solution_display("🔄 Generando problema PDDL...", page, is_loading=True)
            
            # Generar problema PDDL
            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            pddl_content = generar_problema_pddl_dinamico(estado_molinos, estado_rutas, tolvas_criticas, tiempos_por_tolva)
            
            update_solution_display("🔄 Ejecutando planificador TFD...", page, is_loading=True)
            
            # Ejecutar planificador
            resultado = planificador.ejecutar_planificador()
            
            if resultado["success"]:
                # Procesar y mostrar solución
                solucion_formateada = formatear_solucion(resultado["solution"])
                update_solution_display(solucion_formateada, page, is_loading=False)
                
                page.snack_bar = ft.SnackBar(
                    ft.Text("✅ Planificación completada exitosamente"), 
                    open=True, 
                    duration=3000,
                    bgcolor=ft.Colors.GREEN_700
                )
            else:
                error_msg = f"❌ Error en planificación: {resultado['error']}"
                update_solution_display(error_msg, page, is_loading=False)
                
                page.snack_bar = ft.SnackBar(
                    ft.Text("❌ Error en la planificación"), 
                    open=True, 
                    duration=3000,
                    bgcolor=ft.Colors.RED_700
                )
            
            page.update()
            
        except Exception as e:
            error_msg = f"❌ Error inesperado: {str(e)}"
            update_solution_display(error_msg, page, is_loading=False)
            page.snack_bar = ft.SnackBar(
                ft.Text("❌ Error inesperado"), 
                open=True, 
                duration=3000,
                bgcolor=ft.Colors.RED_700
            )
            page.update()
    
    # Ejecutar en un hilo separado para no bloquear la UI
    threading.Thread(target=run_planning, daemon=True).start()

def formatear_solucion(acciones: List[Dict]) -> str:
    """Formatea la solución del planificador para mostrar en la UI"""
    if not acciones:
        return "No se encontraron acciones en la solución."
    
    resultado = "📋 PLAN DE ALIMENTACIÓN ÓPTIMO\n" + "="*50 + "\n\n"
    
    for i, accion in enumerate(acciones, 1):
        tiempo = accion.get("tiempo", 0)
        tolva = accion.get("tolva", "")
        material = accion.get("material", "")
        ruta = accion.get("ruta", "")
        molino = accion.get("molino", "")
        
        resultado += f"{i}. Tiempo {tiempo:.1f}h: Llenar {tolva}\n"
        resultado += f"   Material: {material}\n"
        resultado += f"   Ruta: {ruta}\n"
        resultado += f"   Molino: {molino}\n\n"
    
    resultado += f"📊 Total de acciones: {len(acciones)}\n"
    resultado += f"⏱️  Tiempo total estimado: {max([a.get('tiempo', 0) for a in acciones]):.1f} horas"
    
    return resultado

def configurar_tfd_path(page: ft.Page):
    """Abre un diálogo para configurar la ruta de TFD"""
    def close_dlg(e):
        dlg_modal.open = False
        page.update()
    
    def save_path(e):
        new_path = path_field.value.strip()
        if new_path:
            pddl_config.set_tfd_path(new_path)
            planificador.config = pddl_config
            page.snack_bar = ft.SnackBar(
                ft.Text(f"Ruta TFD configurada: {new_path}"), 
                open=True, 
                duration=3000
            )
        close_dlg(e)
    
    path_field = ft.TextField(
        label="Ruta al ejecutable TFD",
        value=pddl_config.tfd_path or "",
        width=400,
        hint_text="Ej: /usr/local/bin/tfd o C:/TFD/tfd.exe"
    )
    
    dlg_modal = ft.AlertDialog(
        modal=True,
        title=ft.Text("Configurar Ruta TFD"),
        content=ft.Column([
            ft.Text("Ingrese la ruta completa al ejecutable TFD:"),
            path_field,
            ft.Text(
                f"Estado actual: {'✅ Encontrado' if pddl_config.tfd_path else '❌ No encontrado'}",
                color=ft.Colors.GREEN if pddl_config.tfd_path else ft.Colors.RED
            )
        ], width=400, height=150),
        actions=[
            ft.TextButton("Cancelar", on_click=close_dlg),
            ft.TextButton("Guardar", on_click=save_path),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    
    page.dialog = dlg_modal
    dlg_modal.open = True
    page.update()

# ---------------------------------------------
# Funciones UI actualizadas
# ---------------------------------------------

def update_pddl_display(pddl_content, page):
    global pddl_display
    if pddl_display:
        pddl_display.controls[0].value = pddl_content
        page.update()

def update_solution_display(content, page, is_loading=False):
    global solution_display
    if solution_display:
        if is_loading:
            solution_display.controls[0] = ft.Row([
                ft.ProgressRing(width=20, height=20),
                ft.Text(content, color=ft.Colors.BLACK, size=14)
            ])
        else:
            solution_display.controls[0] = ft.Text(
                content,
                color=ft.Colors.BLACK,
                size=14,
                expand=True,
                no_wrap=False
            )
        page.update()

def crear_fila_ruta(nombre, estado, menu_column, sistema, page):
    def on_click(e):
        estado_rutas[nombre] = not estado_rutas[nombre]
        print(f"Ruta '{nombre}' actualizada a {estado_rutas[nombre]}")
        menu_column.controls = construir_column_rutas(menu_column, sistema, page)
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(estado_molinos,estado_rutas, tolvas_criticas, tiempos_por_tolva)
        update_pddl_display(pddl_content, page)
        page.update()
    return ft.Container(
        content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
        padding=5,
        on_click=on_click,
        width=245
    )

def construir_column_rutas(menu_column, sistema, page):
    controls = []
    def titulo(txt):
        return ft.Container(
            content=ft.Text(
                txt,
                weight="bold",
                size=15,
                color=ft.Colors.WHITE,
                text_align=ft.TextAlign.CENTER
            ),
            alignment=ft.alignment.center,
            padding=0
        )
    controls.append(titulo("CLINKER"))
    controls.extend(crear_fila_ruta(n, e, menu_column, sistema, page) for n, e in list(estado_rutas.items())[:4])
    controls.append(ft.Divider())
    controls.append(titulo("PUZOLANA"))
    controls.extend(crear_fila_ruta(n, e, menu_column, sistema, page) for n, e in list(estado_rutas.items())[4:9])
    controls.append(ft.Divider())
    controls.append(titulo("YESO"))
    controls.extend(crear_fila_ruta(n, e, menu_column, sistema, page) for n, e in list(estado_rutas.items())[9:])
    return controls

def refresh_cards(pddl_content=None, sistema: SistemaAlimentacion=None, page: ft.Page=None):
    global pddl_display, solution_display
    page.controls.clear()
    cards = []
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
    
    menu_column = ft.Column(controls=construir_column_rutas(None, sistema, page))
    menu_rutas = ft.PopupMenuButton(
        icon=ft.Icons.MENU,
        items=[
            ft.PopupMenuItem(
                content=menu_column
            )
        ]
    )

    for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
        rows = []
        for material, tolva in molino.tolvas.items():
            unit = "%" if molino.nombre == "MC3" else "m"
            max_level = tolva.altura_max
            current_level = tolva.nivel_actual
            progress = min(current_level / max_level, 1.0) if molino.nombre != "MC3" else min(current_level / 100, 1.0)
            tiempo = molino.tiempo_vaciado(material)
            field_key = f"{molino.nombre}_{material}"
            level_fields[field_key] = ft.TextField(
                value=str(current_level),
                width=55,
                text_align=ft.TextAlign.CENTER,
                border_color=None,
                border=None,
                border_width=0,
                bgcolor=ft.Colors.TRANSPARENT,
                filled=True,
                on_submit=lambda e: update_levels(e, sistema, page)
            )
            bar_color = ft.Colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.Colors.YELLOW_700 if progress >= 0.2 else ft.Colors.RED_700
            rows.append(
                ft.DataRow(cells=[
                    ft.DataCell(ft.Text(material.capitalize(), size=14)),
                    ft.DataCell(
                        ft.Row(
                            [
                                level_fields[field_key],
                                ft.Text(unit, size=14, color=ft.Colors.WHITE),
                            ],
                            alignment=ft.MainAxisAlignment.CENTER,
                            spacing=5
                        )
                    ),
                    ft.DataCell(ft.ProgressBar(value=progress, width=100, height=20, color=bar_color, border_radius=5)),
                    ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
                ])
            )
        
        product_options = {
            "MC1": [ft.dropdown.Option("P30"), ft.dropdown.Option("P40")],
            "MC2": [ft.dropdown.Option("P10"), ft.dropdown.Option("P16"), ft.dropdown.Option("P20"), ft.dropdown.Option("P30")],
            "MC3": [ft.dropdown.Option("P30")]
        }.get(molino.nombre, [])
        
        feed_rate_key = f"{molino.nombre}_feed_rate"
        feed_rate_fields[feed_rate_key] = ft.TextField(
            prefix_text="Rendimiento: ",
            value=f"{molino.alimentacion_fresca}",
            width=180,
            text_size=14,
            filled=True,
            text_align=ft.TextAlign.RIGHT,
            suffix_text=" t/h",
            on_submit=lambda e, m=molino, s=sistema, p=page: update_feed_rate(m, e.control.value, s, p),
            tooltip="Alimentación fresca (t/h)"
        )
        
        dropdown_key = f"{molino.nombre}_status"
        status_dropdowns[dropdown_key] = ft.Dropdown(
            options=[
                ft.dropdown.Option("Encendido"),
                ft.dropdown.Option("Apagado")
            ],
            value="Encendido" if estado_molinos[molino.nombre.lower()] else "Apagado",
            width=130,
            filled=True,
            text_size=14,
            color=ft.Colors.GREEN if estado_molinos[molino.nombre.lower()] else ft.Colors.RED,
            on_change=lambda e, m=molino: update_running_state(m, e.control.value, sistema, page),
            tooltip="Estado de marcha"
        )
        
        card = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
                    ft.Row(
                        controls=[
                            status_dropdowns[dropdown_key],
                            ft.Dropdown(
                                options=product_options,
                                value=molino.tipo_producto.value if molino.tipo_producto else product_options[0].key,
                                width=84,
                                filled=True,
                                text_size=14,
                                on_change=lambda e, m=molino: update_product_type(m, e.control.value, sistema, page),
                                tooltip="Tipo de producto"
                            ),
                            feed_rate_fields[feed_rate_key],
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                        vertical_alignment=ft.CrossAxisAlignment.CENTER
                    ),
                    ft.DataTable(
                        columns=[
                            ft.DataColumn(ft.Text("Material", size=14)),
                            ft.DataColumn(ft.Text("Nivel Actual", size=14)),
                            ft.DataColumn(ft.Text("Estado Tolva", size=14)),
                            ft.DataColumn(ft.Text("T. Vaciado", size=14)),
                        ],
                        rows=rows,
                        column_spacing=35,
                        data_row_min_height=0
                    )
                ]),
                padding=8,
                width=494,
                height=350
            ),
            elevation=5
        )
        cards.append(card)
    
    # Panel de información y controles
    info_panel = ft.Card(
        content=ft.Container(
            content=ft.Column([
                ft.Row([
                    ft.Text("🔧 Configuración TFD", size=16, weight=ft.FontWeight.BOLD),
                    ft.IconButton(
                        icon=ft.Icons.SETTINGS,
                        tooltip="Configurar ruta TFD",
                        on_click=lambda e: configurar_tfd_path(page)
                    )
                ]),
                ft.Text(
                    f"Estado: {'✅ Configurado' if pddl_config.tfd_path else '❌ No configurado'}",
                    color=ft.Colors.GREEN if pddl_config.tfd_path else ft.Colors.RED,
                    size=14
                ),
                ft.Row([
                    ft.ElevatedButton(
                        "🔄 Generar Problema PDDL",
                        on_click=lambda e: update_levels(e, sistema, page),
                        bgcolor=ft.Colors.BLUE_700,
                        color=ft.Colors.WHITE,
                        width=200
                    ),
                    ft.ElevatedButton(
                        "🚀 Ejecutar Planificación Completa",
                        on_click=lambda e: ejecutar_planificacion_automatica(sistema, page),
                        bgcolor=ft.Colors.GREEN_700,
                        color=ft.Colors.WHITE,
                        width=230,
                        disabled=not pddl_config.tfd_path
                    )
                ], spacing=10)
            ]),
            padding=15,
            width=500,
            bgcolor=ft.Colors.BLUE_GREY_800,
            border_radius=10
        ),
        elevation=3
    )
    
    # Panel PDDL
    pddl_display = ft.ListView(
        controls=[
            ft.Text(
                pddl_content if pddl_content else "Presione 'Generar Problema PDDL' para ver el contenido.",
                color=ft.Colors.BLACK,
                size=12,
                expand=True,
                no_wrap=False
            )
        ],
        expand=True,
        height=200,
        auto_scroll=ft.ScrollMode.AUTO
    )
    
    pddl_card = ft.Container(
        content=ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text(
                        "📄 Problema PDDL",
                        size=16,
                        weight=ft.FontWeight.BOLD,
                        color=ft.Colors.BLACK,
                        text_align=ft.TextAlign.CENTER
                    ),
                    pddl_display
                ]),
                padding=10,
                width=490,
                bgcolor=ft.Colors.WHITE,
                border_radius=10,
            ),
            elevation=5
        ),
        alignment=ft.alignment.center
    )
    
    # Panel de solución
    solution_display = ft.ListView(
        controls=[
            ft.Text(
                "Presione 'Ejecutar Planificación Completa' para ver la solución.",
                color=ft.Colors.BLACK,
                size=12,
                expand=True,
                no_wrap=False
            )
        ],
        expand=True,
        height=200,
        auto_scroll=ft.ScrollMode.AUTO
    )
    
    solution_card = ft.Container(
        content=ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text(
                        "🎯 Solución del Planificador",
                        size=16,
                        weight=ft.FontWeight.BOLD,
                        color=ft.Colors.BLACK,
                        text_align=ft.TextAlign.CENTER
                    ),
                    solution_display
                ]),
                padding=10,
                width=490,
                bgcolor=ft.Colors.WHITE,
                border_radius=10,
            ),
            elevation=5
        ),
        alignment=ft.alignment.center
    )
    
    page.add(
        # Header
        ft.Container(
            content=ft.Row(
                [
                    menu_rutas,
                    ft.Text(
                        "OPTIMIZACIÓN DE ALIMENTACIONES",
                        size=40,
                        weight=ft.FontWeight.BOLD,
                        color="white"
                    ),
                    ft.Image(
                        src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",
                        width=100,
                        height=100,
                        fit=ft.ImageFit.CONTAIN
                    ),
                ],
                alignment=ft.MainAxisAlignment.CENTER,
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
                spacing=1
            ),
            padding=0,
            margin=0,
            expand=False
        ),
        # Tarjetas de molinos
        ft.Row(
            controls=cards,
            wrap=True,
            spacing=5,
            alignment=ft.MainAxisAlignment.CENTER
        ),
        # Panel de controles
        ft.Container(
            content=info_panel,
            alignment=ft.alignment.center,
            margin=ft.margin.only(top=10, bottom=10)
        ),
        # Paneles PDDL y Solución
        ft.Row([
            pddl_card,
            solution_card
        ], 
        alignment=ft.MainAxisAlignment.CENTER,
        spacing=10)
    )
    page.update()

def update_levels(e, sistema: SistemaAlimentacion, page: ft.Page):
    for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
        # Actualizar niveles de tolvas
        for material, tolva in molino.tolvas.items():
            field_key = f"{molino.nombre}_{material}"
            if field_key in level_fields and level_fields[field_key].value:
                try:
                    new_level = float(level_fields[field_key].value)
                    if molino.nombre == "MC3":
                        tolva.nivel_actual = max(0, min(new_level, 100))
                    else:
                        tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))
                except ValueError:
                    tolva.nivel_actual = tolva.nivel_actual
        # Actualizar alimentación fresca
        feed_rate_key = f"{molino.nombre}_feed_rate"
        if feed_rate_key in feed_rate_fields and feed_rate_fields[feed_rate_key].value:
            try:
                new_feed = float(feed_rate_fields[feed_rate_key].value)
                if new_feed >= 0:
                    molino.set_alimentacion_fresca(new_feed)
                    print(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h")
                else:
                    print(f"Valor inválido para alimentación fresca de {molino.nombre}: {new_feed} (debe ser no negativo)")
            except ValueError:
                print(f"Valor inválido para alimentación fresca de {molino.nombre}: {feed_rate_fields[feed_rate_key].value}")
    
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
    pddl_content = generar_problema_pddl_dinamico(estado_molinos,estado_rutas, tolvas_criticas, tiempos_por_tolva)
    update_pddl_display(pddl_content, page)
    page.snack_bar = ft.SnackBar(ft.Text("✅ Problema PDDL generado"), open=True, duration=2000)
    page.update()

def main(page: ft.Page):
    page.title = "Sistema de Alimentación de Molinos de Cemento - Automatizado"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = ft.Colors.BLUE_GREY_900
    page.padding = 5
    page.window_width = 1400
    page.window_height = 800
    
    sistema = SistemaAlimentacion()
    sistema.set_productos()
    
    # Sincronizar estado_molinos con los molinos
    sistema.mc1.set_estado(estado_molinos["mc1"])
    sistema.mc2.set_estado(estado_molinos["mc2"])
    sistema.mc3.set_estado(estado_molinos["mc3"])

    # Valores iniciales
    sistema.mc1.tolvas["clinker"].nivel_actual = 5.0
    sistema.mc1.tolvas["puzolana"].nivel_actual = 4.0
    sistema.mc1.tolvas["yeso"].nivel_actual = 6.0
    sistema.mc2.tolvas["clinker"].nivel_actual = 1.5
    sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4.0
    sistema.mc2.tolvas["puzolana_seca"].nivel_actual = 6.3
    sistema.mc2.tolvas["yeso"].nivel_actual = 6.1
    sistema.mc3.tolvas["clinker"].nivel_actual = 40.0
    sistema.mc3.tolvas["puzolana"].nivel_actual = 35.0
    sistema.mc3.tolvas["yeso"].nivel_actual = 30.5
    
    refresh_cards(sistema=sistema, page=page)

if __name__ == "__main__":
    ft.app(target=main)