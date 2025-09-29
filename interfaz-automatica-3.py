# import os
# from pathlib import Path
# import requests
# import re
# import time
# from datetime import datetime
# import flet as ft
# from flet import Page, SnackBar, Text, Column, Card, Container, ListView, TextAlign, FontWeight, CrossAxisAlignment, ProgressRing
# import enum
# from typing import List, Dict, Tuple
# import json

# BASE_DIR = Path(__file__).resolve().parent
# ASSETS_DIR = BASE_DIR / "assets"
# LOGO_PATH_WEB = "logo.png"

# # ---------------------------------------------
# # Clases base
# # ---------------------------------------------

# class TipoProducto(enum.Enum):
#     P10 = "P10"
#     P16 = "P16"
#     P20 = "P20"
#     P30 = "P30"
#     P40 = "P40"

# class Tolva:
#     def __init__(self, material: str, capacidad: float, altura_max: float, nivel_ineficiente: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0
#         self.nivel_ineficiente = nivel_ineficiente

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         if consumo_por_hora <= 0:
#             return float('inf')
#         toneladas_reales = ((self.nivel_actual - self.nivel_ineficiente) * self.capacidad) / self.altura_max
#         return max(0, toneladas_reales / consumo_por_hora)  # Ensure non-negative time

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}
#         self.productos_disponibles = {}
#         self.en_marcha = True

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios
#         self.productos_disponibles[tipo_producto] = {
#             "alimentacion_fresca": alimentacion_fresca,
#             "ratios": ratios
#         }

#     def set_alimentacion_fresca(self, alimentacion_fresca: float):
#         self.alimentacion_fresca = alimentacion_fresca
#         if self.tipo_producto and self.tipo_producto in self.productos_disponibles:
#             self.productos_disponibles[self.tipo_producto]["alimentacion_fresca"] = alimentacion_fresca

#     def set_estado(self, en_marcha: bool):
#         self.en_marcha = en_marcha

#     def cambiar_producto(self, tipo_producto: TipoProducto):
#         if tipo_producto in self.productos_disponibles:
#             self.tipo_producto = tipo_producto
#             self.alimentacion_fresca = self.productos_disponibles[tipo_producto]["alimentacion_fresca"]
#             self.ratios = self.productos_disponibles[tipo_producto]["ratios"]

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = ((self.alimentacion_fresca * self.ratios[material]) / 100)
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14, 2.8),
#             "puzolana": Tolva("Puzolana", 300, 12, 2.4),
#             "yeso": Tolva("Yeso", 300, 10, 2)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9, 1.8),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15, 3),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12, 2.4),
#             "yeso": Tolva("Yeso", 120, 9, 1.8)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100, 50),
#             "puzolana": Tolva("Puzolana", 35, 100, 50),
#             "yeso": Tolva("Yeso", 30, 100, 50)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 72.0, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc1.set_producto(TipoProducto.P40, 64.0, {"clinker": 58.5, "puzolana": 40, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 70.0, {"clinker": 87, "puzolana_humeda": 5, "puzolana_seca": 5, "yeso": 3})
#         self.mc2.set_producto(TipoProducto.P16, 80.0, {"clinker": 81.5, "puzolana_humeda": 8, "puzolana_seca": 8, "yeso": 2.5})
#         self.mc2.set_producto(TipoProducto.P20, 87.0, {"clinker": 85.5, "puzolana_humeda": 6, "puzolana_seca": 6, "yeso": 2.5})
#         self.mc2.set_producto(TipoProducto.P30, 110.0, {"clinker": 68, "puzolana_humeda": 15, "puzolana_seca": 15, "yeso": 2})
#         self.mc3.set_producto(TipoProducto.P30, 37.0, {"clinker": 67.5, "puzolana": 30, "yeso": 2.5})

# # ---------------------------------------------
# # Funciones para vaciado y generación PDDL
# # ---------------------------------------------

# def calcular_tiempos_vaciado(molino: Molino, imprimir: bool = True) -> Dict[str, float]:
#     tiempos = {}
#     for material in molino.tolvas:
#         tiempos[material] = molino.tiempo_vaciado(material)
#         if imprimir:
#             print(f"Tiempo de vaciado para {molino.nombre} - {material}: {tiempos[material]:.2f} horas")
#     return tiempos

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=3) -> Tuple[List[str], Dict[str, float]]:
#     tolvas_a_llenar = []
#     tiempos_por_tolva = {}
#     nombres_tolvas = {
#         "mc1": {"clinker": "t1-clinker", "puzolana": "t1-puzolana-h", "yeso": "t1-yeso"},
#         "mc2": {"clinker": "t2-clinker", "puzolana_humeda": "t2-puzolana-h", "puzolana_seca": "t2-puzolana-s", "yeso": "t2-yeso"},
#         "mc3": {"clinker": "t3-clinker", "puzolana": "t3-puzolana-s", "yeso": "t3-yeso"},
#     }
#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         tiempos = calcular_tiempos_vaciado(molino, imprimir=True)
#         nombre_molino = molino.nombre.lower()
#         for mat, tiempo in tiempos.items():
#             nombre_tolva_pddl = nombres_tolvas[nombre_molino].get(mat)
#             if nombre_tolva_pddl:
#                 tiempos_por_tolva[nombre_tolva_pddl] = max(0, tiempo)  # Ensure non-negative
#                 if tiempo < umbral and sistema.__dict__[nombre_molino].en_marcha:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
#     return tolvas_a_llenar, tiempos_por_tolva

# def generar_problema_pddl_dinamico(estado_molinos: Dict[str, bool], estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1", "MC1-por-MC2"],
#         "t2-yeso": ["MC2-por-MC2"],
#         "t3-yeso": ["MC3-por-MC1", "MC3-por-MC2"]
#     }
#     tolva_a_material = {
#         "t1-clinker": "clinker",
#         "t1-puzolana-h": "puzolana-h",
#         "t1-yeso": "yeso",
#         "t2-clinker": "clinker",
#         "t2-puzolana-h": "puzolana-h",
#         "t2-puzolana-s": "puzolana-s",
#         "t2-yeso": "yeso",
#         "t3-clinker": "clinker",
#         "t3-puzolana-s": "puzolana-s",
#         "t3-yeso": "yeso"
#     }
#     tolvas_validas = []
#     for tolva in tolvas_criticas:
#         if tolva not in tolva_a_rutas:
#             print(f"Error: La tolva {tolva} no está definida en el mapeo de rutas.")
#             continue
#         rutas_disponibles = [ruta for ruta in tolva_a_rutas[tolva] if estado_rutas.get(ruta, False)]
#         if rutas_disponibles:
#             tolvas_validas.append(tolva)
#         else:
#             print(f"Advertencia: La tolva crítica {tolva} no tiene rutas habilitadas. Se excluye del objetivo.")
#     tolvas_validas_ordenadas = sorted(tolvas_validas, key=lambda x: tiempos_por_tolva.get(x, float('inf')))
#     if not tolvas_validas:
#         raise ValueError("No hay tolvas críticas válidas con rutas habilitadas para generar el objetivo.")
#     pddl_content = """
# (define (problem cement-production-problem)
# (:domain cement-alimentacion)

# (:objects
#     ;; Molinos
#     mc1 mc2 mc3 - molino

#     ;; Tolvas
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva

#     ;; Materias
#     clinker puzolana-h puzolana-s yeso - materia

#     ;; Rutas
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
#     PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
# )

# (:init
#     ;; Molinos en marcha
#     (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)

#     ;; Tolvas libres
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidades
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     ;; Material disponible
#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     ;; Recursos positivos iniciales
#     (clinker-libre)
#     (puzolana-h-libre PH-a-MC1-por-MC1)
#     (puzolana-h-libre PH-a-MC1-por-MC2)
#     (puzolana-h-libre PH-a-426HO04-por-MC2)
#     (puzolana-s-libre mc1)
#     (puzolana-s-libre mc2) 
#     (puzolana-s-libre mc3) 
#     (ruta-yeso-libre mc2 MC2-por-MC2)
#     (ruta-yeso-libre mc3 MC3-por-MC2)
#     (yeso-libre mc1)
#     (yeso-libre mc2)
#     (yeso-libre mc3)
#     (molino-libre-clinker mc1)
#     (molino-libre-clinker mc2)
#     (molino-libre-clinker mc3)

#     ;; Duraciones
#     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 2)
#     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 3)
#     (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
#     (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 5)
#     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
#     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
#     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)
#     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
#     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
#     (= (duracion-llenado t1-yeso MC1-por-MC1) 3)       
#     (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

#     ;; Inicializar tiempo y costo
#     (= (tiempo-acumulado) 0)
#     (= (costo-total) 0)
# """
#     rutas = [
#         ("mc1", "t1-clinker", "MC1-desde-Pretrit"),
#         ("mc2", "t2-clinker", "MC2-desde-Pretrit"),
#         ("mc3", "t3-clinker", "MC3-desde_Silo-Blanco"),
#         ("mc3", "t3-clinker", "Pretrit_a_Silo_Blanco"),
#         ("mc2", "t2-puzolana-h", "PH-a-426HO04-por-MC2"),
#         ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC2"),
#         ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC1"),
#         ("mc3", "t3-puzolana-s", "PS-a-MC3-por-MC2"),
#         ("mc2", "t2-puzolana-s", "PS-a-426HO02-por-426HO04"),
#         ("mc1", "t1-yeso", "MC1-por-MC1"),
#         ("mc2", "t2-yeso", "MC2-por-MC2"),
#         ("mc3", "t3-yeso", "MC3-por-MC1"),
#         ("mc3", "t3-yeso", "MC3-por-MC2"),
#     ]

#     for molino in ["mc1", "mc2", "mc3"]:  
#         if estado_molinos.get(molino, False):
#             pddl_content += f"    (en-marcha {molino})\n"  

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "Desconocido")
#         if estado_molinos.get(molino, False):
#             if estado_rutas.get(ruta, False):
#                 if i == 0:
#                     pddl_content += "    ;; Clinker\n"
#                 elif i == 4:
#                     pddl_content += "    ;; Puzolana\n"
#                 elif i == 9:
#                     pddl_content += "    ;; Yeso\n"
#                 pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"
#     pddl_content += "    ;; Tiempos de vaciado\n"

#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {max(0, tiempo):.2f})\n"
#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         molino = tolva.split('-')[0].replace('t', 'mc')
#         if estado_molinos.get(molino, False):
#             material = tolva_a_material.get(tolva, "unknown")
#             pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (costo-total))\n)"
#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return pddl_content

# # ---------------------------------------------
# # PDDL Executor
# # ---------------------------------------------

# class PDDLExecutor:
#     def __init__(self, domain_path, problem_path, workspace_path):
#         self.domain_path = Path(domain_path)
#         self.problem_path = Path(problem_path)
#         self.workspace_path = Path(workspace_path)
#         self.output_dir = self.workspace_path / "generated_plans"
#         self.output_dir.mkdir(exist_ok=True)
#         self.delays = {
#             'plan_generation': 60,
#             'monitor_interval': 5,
#             'max_attempts': 10
#         }

#     def execute(self):
#         print("🚀 Iniciando planificación PDDL con OPTIC")
#         print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

#         if not self._check_files():
#             return False, None

#         try:
#             with open(self.domain_path, 'r', encoding='utf-8') as f:
#                 domain_content = f.read()
#             with open(self.problem_path, 'r', encoding='utf-8') as f:
#                 problem_content = f.read()

#             url = "https://solver.planning.domains:5001/package/optic/solve"
#             payload = {"domain": domain_content, "problem": problem_content}
#             response = requests.post(url, json=payload, timeout=self.delays['plan_generation'])

#             if response.status_code != 200:
#                 print(f"❌ Error en la solicitud: {response.status_code}")
#                 print(response.text)
#                 return False, None

#             try:
#                 initial_response = response.json()
#             except json.JSONDecodeError:
#                 print("❌ No se pudo parsear la respuesta inicial como JSON")
#                 return False, None

#             check_url = initial_response.get('result', '')
#             if not check_url.startswith('/check/'):
#                 print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
#                 return False, None

#             check_url = f"https://solver.planning.domains:5001{check_url}"
#             plan_text = self._poll_for_plan(check_url)

#             if plan_text:
#                 print(f"📜 Plan recibido:\n{plan_text}")
#                 best_plan = self._select_best_plan(plan_text)
#                 if best_plan:
#                     plan_path, chart_config = self._save_plan(best_plan, plan_text)
#                     if plan_path:
#                         return True, chart_config
#                 print("❌ No se encontró un plan válido")
#                 return False, None

#             print("❌ No se obtuvo plan después de intentos")
#             return False, None

#         except Exception as e:
#             print(f"❌ Error crítico: {e}")
#             return False, None

#     def _check_files(self):
#         if not self.domain_path.exists():
#             print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
#             print("Creando archivo de dominio por defecto...")
#             self._create_default_domain()
#             if not self.domain_path.exists():
#                 return False
#         if not self.problem_path.exists():
#             print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
#             return False
#         return True

#     def _create_default_domain(self):
#         domain_content = """
# (define (domain cement-alimentacion)
# (:requirements :strips :typing :durative-actions :numeric-fluents)
# (:types
#     molino tolva materia ruta - object
# )
# (:predicates
#     (en-marcha ?m - molino)
#     (libre ?t - tolva)
#     (compatible ?mat - materia ?t - tolva)
#     (material-disponible ?mat - materia)
#     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
#     (alimentado ?t - tolva ?mat - materia)
#     (clinker-libre)
#     (puzolana-h-libre ?r - ruta)
#     (puzolana-s-libre ?m - molino)
#     (ruta-yeso-libre ?m - molino ?r - ruta)
#     (yeso-libre ?m - molino)
#     (molino-libre-clinker ?m - molino)
# )
# (:functions
#     (tiempo-vaciado ?t - tolva)
#     (duracion-llenado ?t - tolva ?r - ruta)
#     (tiempo-acumulado)
#     (costo-total)
# )
# (:durative-action alimentar
#     :parameters (?t - tolva ?mat - materia ?r - ruta ?m - molino)
#     :duration (= ?duration (duracion-llenado ?t ?r))
#     :condition
#         (and
#             (at start (en-marcha ?m))
#             (at start (libre ?t))
#             (at start (compatible ?mat ?t))
#             (at start (material-disponible ?mat))
#             (at start (ruta-disponible ?m ?t ?mat ?r))
#             (at start (if (eq ?mat clinker) (molino-libre-clinker ?m)))
#             (at start (if (eq ?mat puzolana-h) (puzolana-h-libre ?r)))
#             (at start (if (eq ?mat puzolana-s) (puzolana-s-libre ?m)))
#             (at start (if (eq ?mat yeso) (yeso-libre ?m)))
#             (at start (if (eq ?mat yeso) (ruta-yeso-libre ?m ?r)))
#         )
#     :effect
#         (and
#             (at start (not (libre ?t)))
#             (at end (alimentado ?t ?mat))
#             (at end (libre ?t))
#             (at end (increase (costo-total) (tiempo-vaciado ?t)))
#             (at start (if (eq ?mat clinker) (not (molino-libre-clinker ?m))))
#             (at end (if (eq ?mat clinker) (molino-libre-clinker ?m)))
#             (at start (if (eq ?mat puzolana-h) (not (puzolana-h-libre ?r))))
#             (at end (if (eq ?mat puzolana-h) (puzolana-h-libre ?r)))
#             (at start (if (eq ?mat puzolana-s) (not (puzolana-s-libre ?m))))
#             (at end (if (eq ?mat puzolana-s) (puzolana-s-libre ?m)))
#             (at start (if (eq ?mat yeso) (not (yeso-libre ?m))))
#             (at end (if (eq ?mat yeso) (yeso-libre ?m)))
#             (at start (if (eq ?mat yeso) (not (ruta-yeso-libre ?m ?r))))
#             (at end (if (eq ?mat yeso) (ruta-yeso-libre ?m ?r)))
#         )
# ))
# """
#         try:
#             self.domain_path.parent.mkdir(exist_ok=True)
#             with open(self.domain_path, 'w', encoding='utf-8') as f:
#                 f.write(domain_content)
#             print(f"✅ Archivo de dominio creado en: {self.domain_path}")
#         except Exception as e:
#             print(f"❌ Error al crear archivo de dominio: {e}")

#     def _poll_for_plan(self, check_url):
#         for attempt in range(self.delays['max_attempts']):
#             try:
#                 response = requests.get(check_url, timeout=self.delays['plan_generation'])
#                 if response.status_code != 200:
#                     print(f"❌ Error en la verificación: {response.status_code}")
#                     return None
#                 data = response.json()
#                 if data.get('status') == 'ok' and 'output' in data.get('result', {}):
#                     output = data['result']['output']
#                     if isinstance(output, dict):
#                         plan_text = output.get('plan') or output.get('stdout', '')
#                     else:
#                         plan_text = str(output)
#                     if plan_text:
#                         return plan_text
#             except Exception as e:
#                 print(f"⚠️ Intento {attempt+1} falló: {e}")
#             time.sleep(self.delays['monitor_interval'])
#         print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
#         return None

#     def _select_best_plan(self, log_content):
#         plan_blocks = re.split(r";\s*Plan found with metric\s+[\d.]+", log_content, flags=re.IGNORECASE)
#         metric_matches = list(re.finditer(r";\s*Plan found with metric\s+([\d.]+)", log_content, re.IGNORECASE))
        
#         best_plan = None
#         best_metric = float('inf')
        
#         for block, metric_match in zip(plan_blocks[1:], metric_matches):
#             actions = "\n".join(line.strip() for line in block.splitlines() if re.match(r"^\d+\.\d+:", line))
#             if not actions:
#                 continue
            
#             metric_value = float(metric_match.group(1)) if metric_match else None
#             if metric_value is None or metric_value == 0:
#                 continue
            
#             if metric_value < best_metric:
#                 best_metric = metric_value
#                 best_plan = actions
        
#         if best_plan:
#             return {
#                 "actions": best_plan,
#                 "metric": best_metric,
#                 "additional_info": ""
#             }
#         return None

#     def _clean_plan(self, plan_text):
#         cleaned_lines = []
#         seen_actions = set()
#         for line in plan_text.splitlines():
#             line = line.strip()
#             if line and re.match(r"^\d+\.\d+:", line):
#                 time_match = re.match(r'^(\d+\.\d+):\s*\((.*?)\)\s*\[(\d+\.\d+)\]$', line)
#                 if time_match:
#                     time_prefix = float(time_match.group(1))
#                     action = time_match.group(2).strip()
#                     duration = float(time_match.group(3))
#                     if (time_prefix, action) not in seen_actions:
#                         formatted_line = f"{time_prefix:.5f}: {action} [{duration:.5f}]"
#                         cleaned_lines.append(formatted_line)
#                         seen_actions.add((time_prefix, action))
#         return "\n".join(cleaned_lines)

#     def _create_gantt_chart_config(self, plan_text):
#         acciones = []
#         # More robust regex to handle variations in plan format
#         for line in plan_text.splitlines():
#             m = re.match(r"^\s*(\d+\.\d+):\s*\(([^)]+)\)\s*\[(\d+\.\d+)\]\s*$", line.strip())
#             if m:
#                 start = float(m.group(1))
#                 action = m.group(2).strip()
#                 dur = float(m.group(3))
#                 acciones.append((action, start, dur))

#         if not acciones:
#             print("⚠️ No se pudieron extraer acciones para graficar. Plan text:\n", plan_text)
#             return None

#         colores = {
#             'puzolana-h': '#00FF00',  # Neon green
#             'puzolana-s': '#0000FF',  # Electric blue
#             'yeso': '#FF00FF',        # Magenta
#             'clinker': '#FF0000'      # Bright red
#         }

#         labels = [accion[0] for accion in reversed(acciones)]
#         datasets = [{
#             "label": "Feeding Actions",
#             "data": [{
#                 "x": [accion[1], accion[1] + accion[2]],
#                 "y": idx,
#                 "backgroundColor": next((colores[m] for m in colores if m in accion[0].lower()), '#808080')
#             } for idx, accion in enumerate(reversed(acciones))],
#             "barThickness": 20
#         }]

#         chart_config = {
#             "type": "bar",
#             "data": {
#                 "labels": labels,
#                 "datasets": datasets
#             },
#             "options": {
#                 "indexAxis": 'y',
#                 "scales": {
#                     "x": {
#                         "type": 'linear',
#                         "position": 'bottom',
#                         "title": {
#                             "display": True,
#                             "text": 'Time (hours)',
#                             "color": '#ffffff'
#                         },
#                         "ticks": {
#                             "color": '#ffffff'
#                         },
#                         "grid": {
#                             "color": '#555555'
#                         }
#                     },
#                     "y": {
#                         "title": {
#                             "display": True,
#                             "text": 'Actions',
#                             "color": '#ffffff'
#                         },
#                         "ticks": {
#                             "color": '#ffffff'
#                         },
#                         "grid": {
#                             "color": '#555555'
#                         }
#                     }
#                 },
#                 "plugins": {
#                     "legend": {
#                         "display": False
#                     },
#                     "title": {
#                         "display": True,
#                         "text": 'PDDL Plan - Gantt Chart',
#                         "color": '#ffffff'
#                     }
#                 },
#                 "responsive": True,
#                 "maintainAspectRatio": False
#             }
#         }
#         return chart_config

#     def _save_plan(self, plan_data, log_content):
#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         plan_file = self.output_dir / f"plan_optic_{timestamp}.md"
#         clean_plan = self._clean_plan(plan_data['actions'])
#         chart_config = self._create_gantt_chart_config(clean_plan)
#         try:
#             with open(plan_file, 'w', encoding='utf-8') as f:
#                 f.write(f"# Plan Limpio para Alimentación de Materias Primas\n\n")
#                 f.write(f"## Plan Seleccionado (Metric: {plan_data['metric']})\n\n")
#                 f.write(clean_plan)
#                 f.write(plan_data['additional_info'])
#             print(f"✅ Plan guardado en: {plan_file}")
#             return plan_file, chart_config
#         except Exception as e:
#             print(f"❌ Error al guardar plan: {e}")
#             return None, None

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def update_feed_rate(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     try:
#         new_feed = float(value)
#         if new_feed >= 0:
#             molino.set_alimentacion_fresca(new_feed)
#             tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#             pddl_content = generar_problema_pddl_dinamico(
#                 session_state['estado_molinos'],
#                 session_state['estado_rutas'],
#                 tolvas_criticas,
#                 tiempos_por_tolva
#             )
#             refresh_cards(pddl_content, sistema, page)
#             page.snack_bar = ft.SnackBar(ft.Text(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h"), open=True, duration=2000)
#         else:
#             page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser no negativo"), open=True, duration=2000)
#     except ValueError:
#         page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser numérico"), open=True, duration=2000)
#     page.update()

# def update_product_type(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     try:
#         tipo_producto = TipoProducto(value)
#         molino.cambiar_producto(tipo_producto)
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva
#         )
#         refresh_cards(pddl_content, sistema, page)
#     except ValueError:
#         page.snack_bar = ft.SnackBar(ft.Text(f"Tipo de producto inválido: {value}"), open=True, duration=2000)
#     page.update()

# def update_running_state(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     estado = value == "Encendido"
#     molino.set_estado(estado)
#     session_state['estado_molinos'][molino.nombre.lower()] = estado
#     dropdown_key = f"{molino.nombre}_status"
#     if dropdown_key in session_state['status_dropdowns']:
#         session_state['status_dropdowns'][dropdown_key].value = value
#         session_state['status_dropdowns'][dropdown_key].color = ft.Colors.GREEN if estado else ft.Colors.RED
#     tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#     pddl_content = generar_problema_pddl_dinamico(
#         session_state['estado_molinos'],
#         session_state['estado_rutas'],
#         tolvas_criticas,
#         tiempos_por_tolva
#     )
#     update_pddl_display(pddl_content, page)
#     page.update()

# def update_pddl_display(pddl_content, page):
#     session_state = page.session_state
#     session_state['pddl_display'].controls[0].value = pddl_content
#     page.update()

# def crear_fila_ruta(nombre, estado, sistema, page):
#     session_state = page.session_state
#     def on_click(e):
#         session_state['estado_rutas'][nombre] = not session_state['estado_rutas'][nombre]
#         session_state['menu_column'].controls = construir_column_rutas(sistema, page)
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva
#         )
#         update_pddl_display(pddl_content, page)
#         page.update()
#     return ft.Container(
#         content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
#         padding=5,
#         on_click=on_click,
#         width=245
#     )

# def construir_column_rutas(sistema, page):
#     session_state = page.session_state
#     controls = []
#     def titulo(txt):
#         return ft.Container(
#             content=ft.Text(
#                 txt,
#                 weight="bold",
#                 size=15,
#                 color=ft.Colors.WHITE,
#                 text_align=ft.TextAlign.CENTER
#             ),
#             alignment=ft.alignment.center,
#             padding=0
#         )
#     controls.append(titulo("CLINKER"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[:4])
#     controls.append(ft.Divider())
#     controls.append(titulo("PUZOLANA"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[4:9])
#     controls.append(ft.Divider())
#     controls.append(titulo("YESO"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[9:])
#     return controls

# def refresh_cards(pddl_content=None, sistema: SistemaAlimentacion=None, page: ft.Page=None):
#     session_state = page.session_state
#     page.controls.clear()
#     cards = []

#     if session_state['menu_column'] is None:
#         session_state['menu_column'] = ft.Column(controls=construir_column_rutas(sistema, page))
    
#     menu_rutas = ft.PopupMenuButton(
#         icon=ft.Icons.MENU,
#         items=[
#             ft.PopupMenuItem(
#                 content=session_state['menu_column']
#             )
#         ]
#     )

#     def get_font_size():
#         if page.window_width < 600:
#             return 14
#         elif page.window_width < 900:
#             return 14
#         else:
#             return 14

#     drawer = ft.NavigationDrawer(
#         controls=[
#             ft.Container(
#                 content=ft.Column(
#                     controls=construir_column_rutas(sistema, page),
#                     scroll=ft.ScrollMode.AUTO
#                 ),
#                 padding=10
#             )
#         ]
#     )
#     page.drawer = drawer

#     if page.window_width < 300:
#         header_content = ft.Column(
#             controls=[
#                 ft.Text(
#                     "OPTIMIZACIÓN DE",
#                     size=get_font_size(),
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER
#                 ),
#                 ft.Row(
#                     controls=[
#                         ft.IconButton(
#                             icon=ft.Icons.MENU,
#                             on_click=lambda e: page.show_drawer(drawer),
#                             visible=True
#                         ),
#                         ft.Image(
#                             src=LOGO_PATH_WEB,
#                             width=page.window_width * 0.06,
#                             height=page.window_width * 0.06,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                     ],
#                     alignment=ft.MainAxisAlignment.CENTER,
#                     spacing=10
#                 ),
#                 ft.Text(
#                     "ALIMENTACIONES",
#                     size=get_font_size() * 0.8,
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER
#                 )
#             ],
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=5
#         )
#     else:
#         header_content = ft.Row(
#             controls=[
#                 menu_rutas,
#                 ft.Text(
#                     "OPTIMIZACIÓN DE ALIMENTACIONES",
#                     size=get_font_size() * 2,
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER,
#                     expand=True
#                 ),
#                 ft.Image(
#                     src=LOGO_PATH_WEB,
#                     width=page.window_width * 0.06,
#                     height=page.window_width * 0.06,
#                     fit=ft.ImageFit.CONTAIN
#                 ),
#             ],
#             alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
#             vertical_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=0,
#             wrap=False,
#             height=70,
#         )

#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         rows = []
#         for material, tolva in molino.tolvas.items():
#             unit = "%" if molino.nombre == "MC3" else "m"
#             max_level = tolva.altura_max
#             current_level = tolva.nivel_actual
#             progress = min(current_level / max_level, 1.0) if molino.nombre != "MC3" else min(current_level / 100, 1.0)
#             tiempo = molino.tiempo_vaciado(material)
#             field_key = f"{molino.nombre}_{material}"
#             session_state['level_fields'][field_key] = ft.TextField(
#                 value=str(current_level),
#                 width=40,
#                 text_align=ft.TextAlign.LEFT,
#                 border_color=None,
#                 border=None,
#                 border_width=0,
#                 bgcolor=ft.Colors.TRANSPARENT,
#                 filled=True,
#                 text_size=get_font_size(),
#                 content_padding=0,
#                 on_submit=lambda e: update_levels(e, sistema, page)
#             )
#             bar_color = ft.Colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.Colors.YELLOW_700 if progress >= 0.2 else ft.Colors.RED_700
#             rows.append(
#                 ft.DataRow(cells=[
#                     ft.DataCell(ft.Text(material.capitalize(), size=get_font_size())),
#                     ft.DataCell(
#                         ft.Row(
#                             [
#                                 session_state['level_fields'][field_key],
#                                 ft.Text(unit, size=13, color=ft.Colors.WHITE),
#                             ],
#                             alignment=ft.MainAxisAlignment.START,
#                             spacing=0
#                         )
#                     ),
#                     ft.DataCell(ft.ProgressBar(value=progress, width=page.window_width * 0.07, height=15, color=bar_color, border_radius=5)),
#                     ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=get_font_size())),
#                 ])
#             )

#         product_options = {
#             "MC1": [ft.dropdown.Option("P30"), ft.dropdown.Option("P40")],
#             "MC2": [ft.dropdown.Option("P10"), ft.dropdown.Option("P16"), ft.dropdown.Option("P20"), ft.dropdown.Option("P30")],
#             "MC3": [ft.dropdown.Option("P30")]
#         }.get(molino.nombre, [])
#         feed_rate_key = f"{molino.nombre}_feed_rate"
#         session_state['feed_rate_fields'][feed_rate_key] = ft.TextField(
#             prefix_text="Rendimiento: ",
#             value=f"{molino.alimentacion_fresca}",
#             width=page.window_width * 0.155,
#             text_size=get_font_size(),
#             filled=True,
#             text_align=ft.TextAlign.RIGHT,
#             suffix_text=" t/h",
#             on_submit=lambda e, m=molino, s=sistema, p=page: update_feed_rate(m, e.control.value, s, p),
#             tooltip="Alimentación fresca (t/h)"
#         )
        
#         dropdown_key = f"{molino.nombre}_status"
#         session_state['status_dropdowns'][dropdown_key] = ft.Dropdown(
#             options=[
#                 ft.dropdown.Option("Encendido"),
#                 ft.dropdown.Option("Apagado")
#             ],
#             value="Encendido" if session_state['estado_molinos'][molino.nombre.lower()] else "Apagado",
#             width=page.window_width * 0.12,
#             filled=True,
#             text_size=get_font_size(),
#             color=ft.Colors.GREEN if session_state['estado_molinos'][molino.nombre.lower()] else ft.Colors.RED,
#             on_change=lambda e, m=molino: update_running_state(m, e.control.value, sistema, page),
#             tooltip="Estado de marcha"
#         )

#         def calculate_card_height(molinos_list):
#             max_materials = max(len(molino.tolvas) for molino in molinos_list) if molinos_list else 1
#             base_height = 150
#             material_height = 45
#             return base_height + (max_materials * material_height)
    
#         molinos_list = [sistema.mc1, sistema.mc2, sistema.mc3]
#         card_height = calculate_card_height(molinos_list)
        
#         card = ft.Card(
#             content=ft.Container(
#                 content=ft.Column([
#                     ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER),
#                     ft.Row(
#                         controls=[
#                             session_state['status_dropdowns'][dropdown_key],
#                             ft.Dropdown(
#                                 options=product_options,
#                                 value=molino.tipo_producto.value if molino.tipo_producto else product_options[0].key,
#                                 width=page.window_width * 0.075,
#                                 filled=True,
#                                 text_size=get_font_size(),
#                                 on_change=lambda e, m=molino: update_product_type(m, e.control.value, sistema, page),
#                                 tooltip="Tipo de producto"
#                             ),
#                             session_state['feed_rate_fields'][feed_rate_key],
#                         ],
#                         alignment=ft.MainAxisAlignment.SPACE_EVENLY,
#                         vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                         wrap=True,
#                     ),
#                     ft.Container(
#                         content=ft.DataTable(
#                             columns=[
#                                 ft.DataColumn(ft.Text("   Material", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("   Nivel", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("    Tolva", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("   T.V", size=get_font_size())),
#                             ],
#                             rows=rows,
#                             column_spacing=7,
#                             horizontal_margin=6,
#                         ),
#                         expand=True,
#                         width=page.window_width * 0.9,
#                         bgcolor=ft.Colors.TRANSPARENT,
#                         padding=ft.padding.only(left=0, right=0),
#                     )
#                 ],
#                 scroll="always",
#                 horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#                 spacing=0,
#                 expand=True,
#                 ),
#                 padding=7,
#                 height=350,
#             ),
#             elevation=0,
#         )
#         cards.append(card)

#     pddl_card = ft.Card(
#         content=ft.Container(
#             content=ft.Column([
#                 ft.Text(
#                     "Plan Generado",
#                     size=get_font_size() * 1.2,
#                     weight=ft.FontWeight.BOLD,
#                     color=ft.Colors.BLACK,
#                     text_align=ft.TextAlign.CENTER
#                 ),
#                 session_state['pddl_display']
#             ],
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER),
#             padding=10,
#             width=min(page.window_width * 0.9, 1000),
#             height=min(page.window_height * 0.4, 300),
#             bgcolor=ft.Colors.WHITE,
#             border_radius=10
#         ),
#         elevation=0
#     )

#     page.add(
#         ft.Container(
#             content=header_content,
#             padding=ft.padding.only(bottom=6),
#             margin=0,
#             alignment=ft.alignment.center,
#         ),
#         ft.ResponsiveRow(
#             controls=[ft.Column(col={"xs": 12, "sm": 6, "md": 4}, controls=[card]) for card in cards],
#             alignment=ft.MainAxisAlignment.CENTER,
#             spacing=0,
#             run_spacing=0
#         ),
#         ft.Container(
#             content=ft.ElevatedButton(
#                 "Generar Plan",
#                 on_click=lambda e: update_levels(e, sistema, page),
#                 bgcolor=ft.Colors.BLUE_700,
#                 color=ft.Colors.WHITE,
#                 height=40,
#                 width=page.window_width * 0.2
#             ),
#             alignment=ft.alignment.center,
#             padding=0
#         ),
#         ft.Container(
#             content=pddl_card,
#             alignment=ft.alignment.center,
#             padding=0
#         )
#     )
#     page.update()

# # ---------------------------------------------
# # Update Levels
# # ---------------------------------------------

# def update_levels(e, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
    
#     session_state['pddl_display'].controls.clear()
#     session_state['pddl_display'].controls.append(
#         ft.Container(
#             content=ft.Column([
#                 ft.ProgressRing(
#                     color=ft.Colors.BLUE_700,
#                     width=50,
#                     height=50,
#                     stroke_width=5
#                 ),
#                 ft.Text(
#                     "Buscando rutas disponibles...",
#                     size=16,
#                     color=ft.Colors.BLACK,
#                     text_align=ft.TextAlign.CENTER
#                 )
#             ],
#             alignment=ft.MainAxisAlignment.CENTER,
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=10
#             ),
#             alignment=ft.alignment.center,
#             expand=True
#         )
#     )
#     page.update()

#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         for material, tolva in molino.tolvas.items():
#             field_key = f"{molino.nombre}_{material}"
#             if field_key in session_state['level_fields'] and session_state['level_fields'][field_key].value:
#                 try:
#                     new_level = float(session_state['level_fields'][field_key].value)
#                     if molino.nombre == "MC3":
#                         tolva.nivel_actual = max(0, min(new_level, 100))
#                     else:
#                         tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))
#                     print(f"Nivel actualizado para {molino.nombre} - {material}: {tolva.nivel_actual:.2f}")
#                 except ValueError:
#                     print(f"Valor inválido para nivel de {molino.nombre} - {material}: {session_state['level_fields'][field_key].value}")
#         feed_rate_key = f"{molino.nombre}_feed_rate"
#         if feed_rate_key in session_state['feed_rate_fields'] and session_state['feed_rate_fields'][feed_rate_key].value:
#             try:
#                 new_feed = float(session_state['feed_rate_fields'][feed_rate_key].value)
#                 if new_feed >= 0:
#                     molino.set_alimentacion_fresca(new_feed)
#                     print(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h")
#                 else:
#                     print(f"Valor inválido para alimentación fresca de {molino.nombre}: {new_feed}")
#             except ValueError:
#                 print(f"Valor inválido para alimentación fresca de {molino.nombre}: {session_state['feed_rate_fields'][feed_rate_key].value}")

#     refresh_cards(sistema=sistema, page=page)
#     page.update()

#     try:
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         if not tolvas_criticas:
#             raise ValueError("No hay tolvas críticas para planificar.")
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva,
#             path_output=f"PDDL/cement_problem_{page.session_id}.pddl"
#         )
#     except ValueError as e:
#         print(f"❌ Error al generar problema PDDL: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al generar problema PDDL: {e}"),
#             open=True,
#             duration=5000
#         )
#         page.update()
#         return
    
#     DOMAIN = BASE_DIR / "PDDL" / "cement-alimentacion.pddl"
#     PROBLEM = BASE_DIR / "PDDL" / f"cement_problem_{page.session_id}.pddl"
#     WORKSPACE = BASE_DIR / "PDDL"

#     try:
#         with open(PROBLEM, 'w', encoding='utf-8') as f:
#             f.write(pddl_content)
#         print(f"Problema PDDL guardado en {PROBLEM}")
#     except Exception as e:
#         print(f"Error al guardar el problema PDDL: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al guardar el problema PDDL: {e}"),
#             open=True,
#             duration=5000
#         )
#         page.update()
#         return
    
#     try:
#         executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
#         success, chart_config = executor.execute()
        
#         session_state['pddl_display'].controls.clear()
        
#         if success and chart_config:
#             plan_path = executor.output_dir / max(executor.output_dir.glob("plan_optic_*.md"), key=os.path.getmtime, default=None)
#             if plan_path and plan_path.exists():
#                 with open(plan_path, 'r', encoding='utf-8') as f:
#                     plan_content = f.read()
#                 clean_plan = '\n'.join(
#                     line for line in plan_content.split('\n')
#                     if re.match(r"^\d+\.\d+:", line)
#                 )
#                 print(f"📜 Contenido para pddl_display:\n{clean_plan}")
#                 session_state['pddl_display'].controls.append(
#                     ft.Column([
#                         ft.Text(
#                             "Plan Generado",
#                             size=22,
#                             weight=ft.FontWeight.BOLD,
#                             color=ft.Colors.BLACK,
#                             text_align=ft.TextAlign.CENTER
#                         ),
#                         ft.Text(
#                             clean_plan or "Plan generado pero no se encontraron acciones.",
#                             color=ft.Colors.BLACK,
#                             size=18,
#                             expand=True,
#                             no_wrap=False
#                         ),
#                         ft.Container(
#                             content=ft.Text("Gantt Chart", size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.BLACK),
#                             alignment=ft.alignment.center
#                         ),
#                         ft.Container(
#                             content=ft.Text("Loading Gantt Chart...", size=16, color=ft.Colors.BLACK),
#                             height=300,
#                             alignment=ft.alignment.center
#                         )
#                     ])
#                 )
#                 # Add Chart.js configuration
#                 page.add(
#                     ft.Container(
#                         content=ft.Text(f"""```chartjs
# {json.dumps(chart_config, indent=2)}
# ```"""),
#                         height=300,
#                         width=min(page.window_width * 0.9, 1000),
#                         alignment=ft.alignment.center
#                     )
#                 )
#                 page.snack_bar = ft.SnackBar(
#                     Text(f"✅ Plan y gráfico generados con éxito"),
#                     open=True,
#                     duration=5000
#                 )
#             else:
#                 print("❌ No se encontraron planes generados")
#                 session_state['pddl_display'].controls.append(
#                     ft.Text(
#                         "Error: No se encontraron planes",
#                         color=ft.Colors.BLACK,
#                         size=22,
#                         expand=True,
#                         no_wrap=False
#                     )
#                 )
#                 page.snack_bar = ft.SnackBar(
#                     Text("❌ No se encontraron planes generados"),
#                     open=True,
#                     duration=5000
#                 )
#         else:
#             print("❌ Falló la generación del plan o gráfico")
#             session_state['pddl_display'].controls.append(
#                 ft.Text(
#                     "Error: No se pudo generar el plan o el gráfico",
#                     color=ft.Colors.BLACK,
#                     size=22,
#                     expand=True,
#                     no_wrap=False
#                 )
#             )
#             page.snack_bar = ft.SnackBar(
#                 Text("❌ No se pudo generar el plan o el gráfico"),
#                 open=True,
#                 duration=5000
#             )
#     except Exception as e:
#         print(f"❌ Error inicial: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error inicial: {e}"),
#             open=True,
#             duration=5000
#         )
    
#     page.update()

# # ---------------------------------------------
# # Main
# # ---------------------------------------------

# def main(page: ft.Page):
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK
#     page.bgcolor = ft.Colors.BLUE_GREY_900
#     page.padding = 5
#     page.window_width = 1200
#     page.window_height = 600
#     page.scroll = ft.ScrollMode.AUTO

#     if not (BASE_DIR / "assets" / "logo.png").exists():
#         print("⚠️ logo.png no encontrado en assets, continuando sin logo")
#         # Continue without logo to avoid blocking execution

#     if not hasattr(page, 'session_state'):
#         page.session_state = {
#             'estado_rutas': {
#                 "MC1-desde-Pretrit": True,
#                 "MC2-desde-Pretrit": True,
#                 "MC3-desde_Silo-Blanco": True,
#                 "Pretrit_a_Silo_Blanco": True,
#                 "PH-a-426HO04-por-MC2": True,
#                 "PH-a-MC1-por-MC2": True,
#                 "PH-a-MC1-por-MC1": True,
#                 "PS-a-MC3-por-MC2": True,
#                 "PS-a-426HO02-por-426HO04": True,
#                 "MC1-por-MC1": True,
#                 "MC1-por-MC2": True,
#                 "MC2-por-MC2": True,
#                 "MC3-por-MC1": True,
#                 "MC3-por-MC2": True
#             },
#             'estado_molinos': {
#                 "mc1": True,
#                 "mc2": True,
#                 "mc3": True
#             },
#             'level_fields': {},
#             'feed_rate_fields': {},
#             'status_dropdowns': {},
#             'menu_column': None,
#             'pddl_display': ft.ListView(
#                 controls=[
#                     ft.Text(
#                         "Presione 'Generar Plan' para ver el contenido.",
#                         color=ft.Colors.BLACK,
#                         size=22,
#                         expand=True,
#                         no_wrap=False
#                     )
#                 ],
#                 expand=True,
#                 height=240,
#                 auto_scroll=ft.ScrollMode.AUTO
#             )
#         }

#     try:
#         sistema = SistemaAlimentacion()
#         sistema.set_productos()
        
#         sistema.mc1.set_estado(page.session_state['estado_molinos']["mc1"])
#         sistema.mc2.set_estado(page.session_state['estado_molinos']["mc2"])
#         sistema.mc3.set_estado(page.session_state['estado_molinos']["mc3"])
        
#         # Set realistic initial hopper levels to avoid negative times
#         sistema.mc1.tolvas["clinker"].nivel_actual = 5.0
#         sistema.mc1.tolvas["puzolana"].nivel_actual = 4.0
#         sistema.mc1.tolvas["yeso"].nivel_actual = 3.0
#         sistema.mc2.tolvas["clinker"].nivel_actual = 4.0
#         sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 5.0
#         sistema.mc2.tolvas["puzolana_seca"].nivel_actual = 6.0
#         sistema.mc2.tolvas["yeso"].nivel_actual = 5.0
#         sistema.mc3.tolvas["clinker"].nivel_actual = 60.0
#         sistema.mc3.tolvas["puzolana"].nivel_actual = 70.0
#         sistema.mc3.tolvas["yeso"].nivel_actual = 65.0
        
#         refresh_cards(sistema=sistema, page=page)
#         page.update()
    
#     except Exception as e:
#         print(f"❌ Error en main: {e}")
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al inicializar la aplicación: {e}"),
#             open=True,
#             duration=5000
#         )
#         refresh_cards(sistema=sistema, page=page)
#         page.update()

# if __name__ == "__main__":
#     ft.app(
#         target=main,
#         view=ft.WEB_BROWSER,
#         port=int(os.getenv("PORT", "8080")),
#         assets_dir="assets",
#         host="0.0.0.0"
#     )


# import os
# from pathlib import Path
# import requests
# import re
# import time
# from datetime import datetime
# import flet as ft
# from flet import Page, SnackBar, Text, Column, Card, Container, ListView, TextAlign, FontWeight, CrossAxisAlignment, ProgressRing
# import enum
# from typing import List, Dict, Tuple
# import json
# import matplotlib.pyplot as plt
# import io
# import base64  # Added for base64 encoding of matplotlib figure

# BASE_DIR = Path(__file__).resolve().parent
# ASSETS_DIR = BASE_DIR / "assets"
# LOGO_PATH_WEB = "logo.png"

# # ---------------------------------------------
# # Clases base
# # ---------------------------------------------

# class TipoProducto(enum.Enum):
#     P10 = "P10"
#     P16 = "P16"
#     P20 = "P20"
#     P30 = "P30"
#     P40 = "P40"

# class Tolva:
#     def __init__(self, material: str, capacidad: float, altura_max: float, nivel_ineficiente: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0
#         self.nivel_ineficiente = nivel_ineficiente

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         if consumo_por_hora <= 0:
#             return float('inf')
#         toneladas_reales = ((self.nivel_actual - self.nivel_ineficiente) * self.capacidad) / self.altura_max
#         return max(0, toneladas_reales / consumo_por_hora)  # Non-negative for physical time

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}
#         self.productos_disponibles = {}
#         self.en_marcha = True

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios
#         self.productos_disponibles[tipo_producto] = {
#             "alimentacion_fresca": alimentacion_fresca,
#             "ratios": ratios
#         }

#     def set_alimentacion_fresca(self, alimentacion_fresca: float):
#         self.alimentacion_fresca = alimentacion_fresca
#         if self.tipo_producto and self.tipo_producto in self.productos_disponibles:
#             self.productos_disponibles[self.tipo_producto]["alimentacion_fresca"] = alimentacion_fresca

#     def set_estado(self, en_marcha: bool):
#         self.en_marcha = en_marcha

#     def cambiar_producto(self, tipo_producto: TipoProducto):
#         if tipo_producto in self.productos_disponibles:
#             self.tipo_producto = tipo_producto
#             self.alimentacion_fresca = self.productos_disponibles[tipo_producto]["alimentacion_fresca"]
#             self.ratios = self.productos_disponibles[tipo_producto]["ratios"]

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = ((self.alimentacion_fresca * self.ratios[material]) / 100)
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14, 2.8),
#             "puzolana": Tolva("Puzolana", 300, 12, 2.4),
#             "yeso": Tolva("Yeso", 300, 10, 2)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9, 1.8),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15, 3),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12, 2.4),
#             "yeso": Tolva("Yeso", 120, 9, 1.8)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100, 50),
#             "puzolana": Tolva("Puzolana", 35, 100, 50),
#             "yeso": Tolva("Yeso", 30, 100, 50)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 72.0, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc1.set_producto(TipoProducto.P40, 64.0, {"clinker": 58.5, "puzolana": 40, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 70.0, {"clinker": 87, "puzolana_humeda": 5, "puzolana_seca": 5, "yeso": 3})
#         self.mc2.set_producto(TipoProducto.P16, 80.0, {"clinker": 81.5, "puzolana_humeda": 8, "puzolana_seca": 8, "yeso": 2.5})
#         self.mc2.set_producto(TipoProducto.P20, 87.0, {"clinker": 85.5, "puzolana_humeda": 6, "puzolana_seca": 6, "yeso": 2.5})
#         self.mc2.set_producto(TipoProducto.P30, 110.0, {"clinker": 68, "puzolana_humeda": 15, "puzolana_seca": 15, "yeso": 2})
#         self.mc3.set_producto(TipoProducto.P30, 37.0, {"clinker": 67.5, "puzolana": 30, "yeso": 2.5})

# # ---------------------------------------------
# # Funciones para vaciado y generación PDDL
# # ---------------------------------------------

# def calcular_tiempos_vaciado(molino: Molino, imprimir: bool = True) -> Dict[str, float]:
#     tiempos = {}
#     for material in molino.tolvas:
#         tiempos[material] = molino.tiempo_vaciado(material)
#         if imprimir:
#             print(f"Tiempo de vaciado para {molino.nombre} - {material}: {tiempos[material]:.2f} horas")
#     return tiempos

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=3) -> Tuple[List[str], Dict[str, float]]:
#     tolvas_a_llenar = []
#     tiempos_por_tolva = {}
#     nombres_tolvas = {
#         "mc1": {"clinker": "t1-clinker", "puzolana": "t1-puzolana-h", "yeso": "t1-yeso"},
#         "mc2": {"clinker": "t2-clinker", "puzolana_humeda": "t2-puzolana-h", "puzolana_seca": "t2-puzolana-s", "yeso": "t2-yeso"},
#         "mc3": {"clinker": "t3-clinker", "puzolana": "t3-puzolana-s", "yeso": "t3-yeso"},
#     }
#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         tiempos = calcular_tiempos_vaciado(molino, imprimir=True)
#         nombre_molino = molino.nombre.lower()
#         for mat, tiempo in tiempos.items():
#             nombre_tolva_pddl = nombres_tolvas[nombre_molino].get(mat)
#             if nombre_tolva_pddl:
#                 tiempos_por_tolva[nombre_tolva_pddl] = tiempo  # Keep negative times
#                 if tiempo < umbral and sistema.__dict__[nombre_molino].en_marcha:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
#     return tolvas_a_llenar, tiempos_por_tolva

# def generar_problema_pddl_dinamico(estado_molinos: Dict[str, bool], estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1", "MC1-por-MC2"],
#         "t2-yeso": ["MC2-por-MC2"],
#         "t3-yeso": ["MC3-por-MC1", "MC3-por-MC2"]
#     }
#     tolva_a_material = {
#         "t1-clinker": "clinker",
#         "t1-puzolana-h": "puzolana-h",
#         "t1-yeso": "yeso",
#         "t2-clinker": "clinker",
#         "t2-puzolana-h": "puzolana-h",
#         "t2-puzolana-s": "puzolana-s",
#         "t2-yeso": "yeso",
#         "t3-clinker": "clinker",
#         "t3-puzolana-s": "puzolana-s",
#         "t3-yeso": "yeso"
#     }
#     tolvas_validas = []
#     for tolva in tolvas_criticas:
#         if tolva not in tolva_a_rutas:
#             print(f"Error: La tolva {tolva} no está definida en el mapeo de rutas.")
#             continue
#         rutas_disponibles = [ruta for ruta in tolva_a_rutas[tolva] if estado_rutas.get(ruta, False)]
#         if rutas_disponibles:
#             tolvas_validas.append(tolva)
#         else:
#             print(f"Advertencia: La tolva crítica {tolva} no tiene rutas habilitadas. Se excluye del objetivo.")
#     tolvas_validas_ordenadas = sorted(tolvas_validas, key=lambda x: tiempos_por_tolva.get(x, float('inf')))
#     if not tolvas_validas:
#         raise ValueError("No hay tolvas críticas válidas con rutas habilitadas para generar el objetivo.")
#     pddl_content = """
# (define (problem cement-production-problem)
# (:domain cement-alimentacion)

# (:objects
#     ;; Molinos
#     mc1 mc2 mc3 - molino

#     ;; Tolvas
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva

#     ;; Materias
#     clinker puzolana-h puzolana-s yeso - materia

#     ;; Rutas
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
#     PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
# )

# (:init
#     ;; Molinos en marcha
#     (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)

#     ;; Tolvas libres
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidades
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     ;; Material disponible
#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     ;; Recursos positivos iniciales
#     (clinker-libre)
#     (puzolana-h-libre PH-a-MC1-por-MC1)
#     (puzolana-h-libre PH-a-MC1-por-MC2)
#     (puzolana-h-libre PH-a-426HO04-por-MC2)
#     (puzolana-s-libre mc1)
#     (puzolana-s-libre mc2) 
#     (puzolana-s-libre mc3) 
#     (ruta-yeso-libre mc2 MC2-por-MC2)
#     (ruta-yeso-libre mc3 MC3-por-MC2)
#     (yeso-libre mc1)
#     (yeso-libre mc2)
#     (yeso-libre mc3)
#     (molino-libre-clinker mc1)
#     (molino-libre-clinker mc2)
#     (molino-libre-clinker mc3)

#     ;; Duraciones
#     (= (duracion-llenado t1-clinker MC1-desde-Pretrit) 2)
#     (= (duracion-llenado t2-clinker MC2-desde-Pretrit) 3)
#     (= (duracion-llenado t3-clinker MC3-desde_Silo-Blanco) 4)
#     (= (duracion-llenado t3-clinker Pretrit_a_Silo_Blanco) 5)
#     (= (duracion-llenado t2-puzolana-h PH-a-426HO04-por-MC2) 6)
#     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC2) 7)
#     (= (duracion-llenado t1-puzolana-h PH-a-MC1-por-MC1) 6)
#     (= (duracion-llenado t3-puzolana-s PS-a-MC3-por-MC2) 5)
#     (= (duracion-llenado t2-puzolana-s PS-a-426HO02-por-426HO04) 4)
#     (= (duracion-llenado t1-yeso MC1-por-MC1) 3)       
#     (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

#     ;; Inicializar tiempo y costo
#     (= (tiempo-acumulado) 0)
#     (= (costo-total) 0)
# """
#     rutas = [
#         ("mc1", "t1-clinker", "MC1-desde-Pretrit"),
#         ("mc2", "t2-clinker", "MC2-desde-Pretrit"),
#         ("mc3", "t3-clinker", "MC3-desde_Silo-Blanco"),
#         ("mc3", "t3-clinker", "Pretrit_a_Silo_Blanco"),
#         ("mc2", "t2-puzolana-h", "PH-a-426HO04-por-MC2"),
#         ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC2"),
#         ("mc1", "t1-puzolana-h", "PH-a-MC1-por-MC1"),
#         ("mc3", "t3-puzolana-s", "PS-a-MC3-por-MC2"),
#         ("mc2", "t2-puzolana-s", "PS-a-426HO02-por-426HO04"),
#         ("mc1", "t1-yeso", "MC1-por-MC1"),
#         ("mc2", "t2-yeso", "MC2-por-MC2"),
#         ("mc3", "t3-yeso", "MC3-por-MC1"),
#         ("mc3", "t3-yeso", "MC3-por-MC2"),
#     ]

#     for molino in ["mc1", "mc2", "mc3"]:  
#         if estado_molinos.get(molino, False):
#             pddl_content += f"    (en-marcha {molino})\n"  

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "Desconocido")
#         if estado_molinos.get(molino, False):
#             if estado_rutas.get(ruta, False):
#                 if i == 0:
#                     pddl_content += "    ;; Clinker\n"
#                 elif i == 4:
#                     pddl_content += "    ;; Puzolana\n"
#                 elif i == 9:
#                     pddl_content += "    ;; Yeso\n"
#                 pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"
#     pddl_content += "    ;; Tiempos de vaciado\n"

#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"
#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         molino = tolva.split('-')[0].replace('t', 'mc')
#         if estado_molinos.get(molino, False):
#             material = tolva_a_material.get(tolva, "unknown")
#             pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (costo-total))\n)"
#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return pddl_content

# # ---------------------------------------------
# # PDDL Executor
# # ---------------------------------------------

# class PDDLExecutor:
#     def __init__(self, domain_path, problem_path, workspace_path):
#         self.domain_path = Path(domain_path)
#         self.problem_path = Path(problem_path)
#         self.workspace_path = Path(workspace_path)
#         self.output_dir = self.workspace_path / "generated_plans"
#         self.output_dir.mkdir(exist_ok=True)
#         self.delays = {
#             'plan_generation': 60,
#             'monitor_interval': 5,
#             'max_attempts': 10
#         }

#     def execute(self):
#         print("🚀 Iniciando planificación PDDL con OPTIC")
#         print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

#         if not self._check_files():
#             return False, None

#         try:
#             with open(self.domain_path, 'r', encoding='utf-8') as f:
#                 domain_content = f.read()
#             with open(self.problem_path, 'r', encoding='utf-8') as f:
#                 problem_content = f.read()

#             url = "https://solver.planning.domains:5001/package/optic/solve"
#             payload = {"domain": domain_content, "problem": problem_content}
#             response = requests.post(url, json=payload, timeout=self.delays['plan_generation'])

#             if response.status_code != 200:
#                 print(f"❌ Error en la solicitud: {response.status_code}")
#                 print(response.text)
#                 return False, None

#             try:
#                 initial_response = response.json()
#             except json.JSONDecodeError:
#                 print("❌ No se pudo parsear la respuesta inicial como JSON")
#                 return False, None

#             check_url = initial_response.get('result', '')
#             if not check_url.startswith('/check/'):
#                 print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
#                 return False, None

#             check_url = f"https://solver.planning.domains:5001{check_url}"
#             plan_text = self._poll_for_plan(check_url)

#             if plan_text:
#                 print(f"📜 Plan recibido:\n{plan_text}")
#                 best_plan = self._select_best_plan(plan_text)
#                 if best_plan:
#                     plan_path, chart_base64 = self._save_plan(best_plan, plan_text)
#                     if plan_path:
#                         return True, chart_base64
#                 print("❌ No se encontró un plan válido")
#                 return False, None

#             print("❌ No se obtuvo plan después de intentos")
#             return False, None

#         except Exception as e:
#             print(f"❌ Error crítico: {e}")
#             return False, None

#     def _check_files(self):
#         if not self.domain_path.exists():
#             print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
#             print("Creando archivo de dominio por defecto...")
#             self._create_default_domain()
#             if not self.domain_path.exists():
#                 return False
#         if not self.problem_path.exists():
#             print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
#             return False
#         return True

#     def _create_default_domain(self):
#         domain_content = """
# (define (domain cement-alimentacion)
# (:requirements :strips :typing :durative-actions :numeric-fluents)
# (:types
#     molino tolva materia ruta - object
# )
# (:predicates
#     (en-marcha ?m - molino)
#     (libre ?t - tolva)
#     (compatible ?mat - materia ?t - tolva)
#     (material-disponible ?mat - materia)
#     (ruta-disponible ?m - molino ?t - tolva ?mat - materia ?r - ruta)
#     (alimentado ?t - tolva ?mat - materia)
#     (clinker-libre)
#     (puzolana-h-libre ?r - ruta)
#     (puzolana-s-libre ?m - molino)
#     (ruta-yeso-libre ?m - molino ?r - ruta)
#     (yeso-libre ?m - molino)
#     (molino-libre-clinker ?m - molino)
# )
# (:functions
#     (tiempo-vaciado ?t - tolva)
#     (duracion-llenado ?t - tolva ?r - ruta)
#     (tiempo-acumulado)
#     (costo-total)
# )
# (:durative-action alimentar-clinker
#     :parameters (?m - molino ?t - tolva ?r - ruta)
#     :duration (= ?duration (duracion-llenado ?t ?r))
#     :condition
#         (and
#             (at start (en-marcha ?m))
#             (at start (libre ?t))
#             (at start (compatible clinker ?t))
#             (at start (material-disponible clinker))
#             (at start (ruta-disponible ?m ?t clinker ?r))
#             (at start (molino-libre-clinker ?m))
#         )
#     :effect
#         (and
#             (at start (not (libre ?t)))
#             (at end (alimentado ?t clinker))
#             (at end (libre ?t))
#             (at end (increase (costo-total) (tiempo-vaciado ?t)))
#             (at start (not (molino-libre-clinker ?m)))
#             (at end (molino-libre-clinker ?m))
#         )
# )
# (:durative-action alimentar-puzolana-h
#     :parameters (?m - molino ?t - tolva ?r - ruta)
#     :duration (= ?duration (duracion-llenado ?t ?r))
#     :condition
#         (and
#             (at start (en-marcha ?m))
#             (at start (libre ?t))
#             (at start (compatible puzolana-h ?t))
#             (at start (material-disponible puzolana-h))
#             (at start (ruta-disponible ?m ?t puzolana-h ?r))
#             (at start (puzolana-h-libre ?r))
#         )
#     :effect
#         (and
#             (at start (not (libre ?t)))
#             (at end (alimentado ?t puzolana-h))
#             (at end (libre ?t))
#             (at end (increase (costo-total) (tiempo-vaciado ?t)))
#             (at start (not (puzolana-h-libre ?r)))
#             (at end (puzolana-h-libre ?r))
#         )
# )
# (:durative-action alimentar-puzolana-s
#     :parameters (?m - molino ?t - tolva ?r - ruta)
#     :duration (= ?duration (duracion-llenado ?t ?r))
#     :condition
#         (and
#             (at start (en-marcha ?m))
#             (at start (libre ?t))
#             (at start (compatible puzolana-s ?t))
#             (at start (material-disponible puzolana-s))
#             (at start (ruta-disponible ?m ?t puzolana-s ?r))
#             (at start (puzolana-s-libre ?m))
#         )
#     :effect
#         (and
#             (at start (not (libre ?t)))
#             (at end (alimentado ?t puzolana-s))
#             (at end (libre ?t))
#             (at end (increase (costo-total) (tiempo-vaciado ?t)))
#             (at start (not (puzolana-s-libre ?m)))
#             (at end (puzolana-s-libre ?m))
#         )
# )
# (:durative-action alimentar-yeso
#     :parameters (?m - molino ?t - tolva ?r - ruta)
#     :duration (= ?duration (duracion-llenado ?t ?r))
#     :condition
#         (and
#             (at start (en-marcha ?m))
#             (at start (libre ?t))
#             (at start (compatible yeso ?t))
#             (at start (material-disponible yeso))
#             (at start (ruta-disponible ?m ?t yeso ?r))
#             (at start (yeso-libre ?m))
#             (at start (ruta-yeso-libre ?m ?r))
#         )
#     :effect
#         (and
#             (at start (not (libre ?t)))
#             (at end (alimentado ?t yeso))
#             (at end (libre ?t))
#             (at end (increase (costo-total) (tiempo-vaciado ?t)))
#             (at start (not (yeso-libre ?m)))
#             (at end (yeso-libre ?m))
#             (at start (not (ruta-yeso-libre ?m ?r)))
#             (at end (ruta-yeso-libre ?m ?r))
#         )
# )
# )
# """
#         try:
#             self.domain_path.parent.mkdir(exist_ok=True)
#             with open(self.domain_path, 'w', encoding='utf-8') as f:
#                 f.write(domain_content)
#             print(f"✅ Archivo de dominio creado en: {self.domain_path}")
#         except Exception as e:
#             print(f"❌ Error al crear archivo de dominio: {e}")

#     def _poll_for_plan(self, check_url):
#         for attempt in range(self.delays['max_attempts']):
#             try:
#                 response = requests.get(check_url, timeout=self.delays['plan_generation'])
#                 if response.status_code != 200:
#                     print(f"❌ Error en la verificación: {response.status_code}")
#                     return None
#                 data = response.json()
#                 if data.get('status') == 'ok' and 'output' in data.get('result', {}):
#                     output = data['result']['output']
#                     if isinstance(output, dict):
#                         plan_text = output.get('plan') or output.get('stdout', '')
#                     else:
#                         plan_text = str(output)
#                     if plan_text:
#                         return plan_text
#             except Exception as e:
#                 print(f"⚠️ Intento {attempt+1} falló: {e}")
#             time.sleep(self.delays['monitor_interval'])
#         print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
#         return None

#     def _select_best_plan(self, log_content):
#         print("🔍 Parsing plan content:\n", log_content)  # Debug: Log full content
#         # Split on either "Plan found with metric" or "Solution Found"
#         plan_blocks = re.split(r";+\s*(?:Plan found with metric|Solution Found)\s+([\d.]+)", log_content, flags=re.IGNORECASE)
#         metric_matches = list(re.finditer(r";+\s*(?:Plan found with metric|Solution Found)\s+([\d.]+)", log_content, re.IGNORECASE))
        
#         best_plan = None
#         best_metric = float('inf')
        
#         print(f"Found {len(metric_matches)} metric matches, {len(plan_blocks)-1} plan blocks")  # Debug
#         for i, (block, metric_match) in enumerate(zip(plan_blocks[1:], metric_matches)):
#             # Log all lines in the block for debugging
#             print(f"Plan block {i+1} lines:")
#             for line in block.splitlines():
#                 print(f"  - '{line}'")
#             # Extract action lines with flexible whitespace
#             actions = "\n".join(
#                 line.strip() for line in block.splitlines() 
#                 if re.match(r"^\s*\d+\.\d+:\s*\([^)]+\)\s*\[\d+\.\d+\]\s*$", line.strip())
#             )
#             print(f"Plan block {i+1}: {len(actions)} chars, actions:\n{actions}")  # Debug
#             if not actions:
#                 continue
            
#             metric_value = float(metric_match.group(1)) if metric_match else None
#             if metric_value is None:
#                 print(f"⚠️ No metric value for block {i+1}")  # Debug
#                 continue
            
#             print(f"Metric for block {i+1}: {metric_value}")  # Debug
#             if metric_value <= best_metric:
#                 best_metric = metric_value
#                 best_plan = actions
        
#         # Fallback: Try extracting actions from the entire log_content if no plan found
#         if not best_plan:
#             print("⚠️ No plan found in blocks, attempting fallback extraction")
#             actions = "\n".join(
#                 line.strip() for line in log_content.splitlines()
#                 if re.match(r"^\s*\d+\.\d+:\s*\([^)]+\)\s*\[\d+\.\d+\]\s*$", line.strip())
#             )
#             if actions:
#                 print(f"✅ Fallback plan extracted:\n{actions}")
#                 best_metric = 0.0  # Assume metric from last match or default to 0.0
#                 best_plan = actions
        
#         if best_plan:
#             print(f"✅ Best plan selected with metric {best_metric}:\n{best_plan}")  # Debug
#             return {
#                 "actions": best_plan,
#                 "metric": best_metric,
#                 "additional_info": ""
#             }
#         print("❌ No valid plan found after parsing and fallback")  # Debug
#         return None
    
#     def _clean_plan(self, plan_text):
#         cleaned_lines = []
#         seen_actions = set()
#         for line in plan_text.splitlines():
#             line = line.strip()
#             if line and re.match(r"^\d+\.\d+:", line):
#                 time_match = re.match(r'^(\d+\.\d+):\s*\((.*?)\)\s*\[(\d+\.\d+)\]$', line)
#                 if time_match:
#                     time_prefix = float(time_match.group(1))
#                     action = time_match.group(2).strip()
#                     duration = float(time_match.group(3))
#                     if (time_prefix, action) not in seen_actions:
#                         formatted_line = f"{time_prefix:.5f}: ({action}) [{duration:.5f}]"
#                         cleaned_lines.append(formatted_line)
#                         seen_actions.add((time_prefix, action))
#         return "\n".join(cleaned_lines)



#     def _plot_gantt(self, plan_txt):
#         print("🔍 Generating Gantt chart for plan:\n", plan_txt)  # Debug: Log input plan
#         acciones = []
#         for line in plan_txt.splitlines():
#             m = re.match(r"^\s*(\d+\.\d+):\s*\((alimentar-[^\s]+)\s+([^\)]+)\)\s*\[(\d+\.\d+)\]\s*$", line.strip())
#             if m:
#                 start = float(m.group(1))
#                 action = f"{m.group(2)} {m.group(3)}"
#                 dur = float(m.group(4))
#                 acciones.append((action, start, dur))
#             else:
#                 print(f"⚠️ Skipping invalid action line: '{line}'")  # Debug: Log skipped lines
        
#         if not acciones:
#             print("❌ No valid actions extracted for Gantt chart")
#             return None

#         colores = {
#             'puzolana-h': '#00FF00',  # Neon green
#             'puzolana-s': '#0000FF',  # Electric blue
#             'yeso': '#FF00FF',        # Magenta
#             'clinker': '#FF0000'      # Bright red
#         }

#         fig, ax = plt.subplots(figsize=(10, 5))
#         # ax.set_facecolor("#1e1e1e")  # Dark background for plot area
#         ax.set_facecolor("#ffffff")  # Dark background for plot area

#         n = len(acciones)
#         for idx, (accion, inicio, dur) in enumerate(acciones):
#             y = n - 1 - idx  # First action at the top
#             color = '#808080'
#             for m in colores:
#                 if m in accion.lower():
#                     color = colores[m]
#                     break
#             ax.barh(y, dur, left=inicio, color=color, edgecolor=None, linewidth=0)
#             ax.text(inicio + dur/2, y, f"{dur:.1f}", ha="center", va="center", color="white", fontsize=9, weight="bold")

#         ax.set_yticks(range(n))
#         ax.set_yticklabels([a[0] for a in reversed(acciones)], color="black")
#         ax.set_xlabel("Tiempo", color="black")
#         ax.set_title("Planificación PDDL – Diagrama de Gantt", color="black")
#         ax.tick_params(colors="black")

#         plt.tight_layout()
        
#         # Save figure to BytesIO and encode as base64
#         buf = io.BytesIO()
#         plt.savefig(buf, format='png', bbox_inches='tight', dpi=100)
#         plt.close(fig)
#         buf.seek(0)
#         chart_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')
#         print(f"🔍 Generated base64 length: {len(chart_base64)} chars")  # Debug: Log base64 length
#         return chart_base64  # Return only the base64 data, no prefix

#     def _save_plan(self, plan_data, log_content):
#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         plan_file = self.output_dir / f"plan_optic_{timestamp}.md"
#         clean_plan = self._clean_plan(plan_data['actions'])
#         chart_base64 = self._plot_gantt(clean_plan)
#         try:
#             with open(plan_file, 'w', encoding='utf-8') as f:
#                 f.write(f"# Plan Limpio para Alimentación de Materias Primas\n\n")
#                 f.write(f"## Plan Seleccionado (Metric: {plan_data['metric']})\n\n")
#                 f.write(clean_plan)
#                 f.write(plan_data['additional_info'])
#             print(f"✅ Plan guardado en: {plan_file}")
#             return plan_file, chart_base64
#         except Exception as e:
#             print(f"❌ Error al guardar plan: {e}")
#             return None, None

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def update_feed_rate(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     try:
#         new_feed = float(value)
#         if new_feed >= 0:
#             molino.set_alimentacion_fresca(new_feed)
#             tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#             pddl_content = generar_problema_pddl_dinamico(
#                 session_state['estado_molinos'],
#                 session_state['estado_rutas'],
#                 tolvas_criticas,
#                 tiempos_por_tolva
#             )
#             refresh_cards(pddl_content, sistema, page)
#             page.snack_bar = ft.SnackBar(ft.Text(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h"), open=True, duration=2000)
#         else:
#             page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser no negativo"), open=True, duration=2000)
#     except ValueError:
#         page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser numérico"), open=True, duration=2000)
#     page.update()

# def update_product_type(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     try:
#         tipo_producto = TipoProducto(value)
#         molino.cambiar_producto(tipo_producto)
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva
#         )
#         refresh_cards(pddl_content, sistema, page)
#     except ValueError:
#         page.snack_bar = ft.SnackBar(ft.Text(f"Tipo de producto inválido: {value}"), open=True, duration=2000)
#     page.update()

# def update_running_state(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
#     estado = value == "Encendido"
#     molino.set_estado(estado)
#     session_state['estado_molinos'][molino.nombre.lower()] = estado
#     dropdown_key = f"{molino.nombre}_status"
#     if dropdown_key in session_state['status_dropdowns']:
#         session_state['status_dropdowns'][dropdown_key].value = value
#         session_state['status_dropdowns'][dropdown_key].color = ft.Colors.GREEN if estado else ft.Colors.RED
#     tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#     pddl_content = generar_problema_pddl_dinamico(
#         session_state['estado_molinos'],
#         session_state['estado_rutas'],
#         tolvas_criticas,
#         tiempos_por_tolva
#     )
#     update_pddl_display(pddl_content, page)
#     page.update()

# def update_pddl_display(pddl_content, page):
#     session_state = page.session_state
#     session_state['pddl_display'].controls[0].value = pddl_content
#     page.update()

# def crear_fila_ruta(nombre, estado, sistema, page):
#     session_state = page.session_state
#     def on_click(e):
#         session_state['estado_rutas'][nombre] = not session_state['estado_rutas'][nombre]
#         session_state['menu_column'].controls = construir_column_rutas(sistema, page)
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva
#         )
#         update_pddl_display(pddl_content, page)
#         page.update()
#     return ft.Container(
#         content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
#         padding=5,
#         on_click=on_click,
#         width=245
#     )

# def construir_column_rutas(sistema, page):
#     session_state = page.session_state
#     controls = []
#     def titulo(txt):
#         return ft.Container(
#             content=ft.Text(
#                 txt,
#                 weight="bold",
#                 size=15,
#                 color=ft.Colors.WHITE,
#                 text_align=ft.TextAlign.CENTER
#             ),
#             alignment=ft.alignment.center,
#             padding=0
#         )
#     controls.append(titulo("CLINKER"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[:4])
#     controls.append(ft.Divider())
#     controls.append(titulo("PUZOLANA"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[4:9])
#     controls.append(ft.Divider())
#     controls.append(titulo("YESO"))
#     controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[9:])
#     return controls

# def refresh_cards(pddl_content=None, sistema: SistemaAlimentacion=None, page: ft.Page=None):
#     session_state = page.session_state
#     page.controls.clear()
#     cards = []

#     if session_state['menu_column'] is None:
#         session_state['menu_column'] = ft.Column(controls=construir_column_rutas(sistema, page))
    
#     menu_rutas = ft.PopupMenuButton(
#         icon=ft.Icons.MENU,
#         items=[
#             ft.PopupMenuItem(
#                 content=session_state['menu_column']
#             )
#         ]
#     )

#     def get_font_size():
#         if page.window_width < 600:
#             return 14
#         elif page.window_width < 900:
#             return 14
#         else:
#             return 14

#     drawer = ft.NavigationDrawer(
#         controls=[
#             ft.Container(
#                 content=ft.Column(
#                     controls=construir_column_rutas(sistema, page),
#                     scroll=ft.ScrollMode.AUTO
#                 ),
#                 padding=10
#             )
#         ]
#     )
#     page.drawer = drawer

#     if page.window_width < 300:
#         header_content = ft.Column(
#             controls=[
#                 ft.Text(
#                     "OPTIMIZACIÓN DE",
#                     size=get_font_size(),
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER
#                 ),
#                 ft.Row(
#                     controls=[
#                         ft.IconButton(
#                             icon=ft.Icons.MENU,
#                             on_click=lambda e: page.show_drawer(drawer),
#                             visible=True
#                         ),
#                         ft.Image(
#                             src=LOGO_PATH_WEB,
#                             width=page.window_width * 0.06,
#                             height=page.window_width * 0.06,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                     ],
#                     alignment=ft.MainAxisAlignment.CENTER,
#                     spacing=10
#                 ),
#                 ft.Text(
#                     "ALIMENTACIONES",
#                     size=get_font_size() * 0.8,
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER
#                 )
#             ],
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=5
#         )
#     else:
#         header_content = ft.Row(
#             controls=[
#                 menu_rutas,
#                 ft.Text(
#                     "OPTIMIZACIÓN DE ALIMENTACIONES",
#                     size=get_font_size() * 2,
#                     weight=ft.FontWeight.BOLD,
#                     color="white",
#                     text_align=ft.TextAlign.CENTER,
#                     expand=True
#                 ),
#                 ft.Image(
#                     src=LOGO_PATH_WEB,
#                     width=page.window_width * 0.06,
#                     height=page.window_width * 0.06,
#                     fit=ft.ImageFit.CONTAIN
#                 ),
#             ],
#             alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
#             vertical_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=0,
#             wrap=False,
#             height=70,
#         )

#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         rows = []
#         for material, tolva in molino.tolvas.items():
#             unit = "%" if molino.nombre == "MC3" else "m"
#             max_level = tolva.altura_max
#             current_level = tolva.nivel_actual
#             progress = min(current_level / max_level, 1.0) if molino.nombre != "MC3" else min(current_level / 100, 1.0)
#             tiempo = molino.tiempo_vaciado(material)
#             field_key = f"{molino.nombre}_{material}"
#             session_state['level_fields'][field_key] = ft.TextField(
#                 value=str(current_level),
#                 width=40,
#                 text_align=ft.TextAlign.LEFT,
#                 border_color=None,
#                 border=None,
#                 border_width=0,
#                 bgcolor=ft.Colors.TRANSPARENT,
#                 filled=True,
#                 text_size=get_font_size(),
#                 content_padding=0,
#                 on_submit=lambda e: update_levels(e, sistema, page)
#             )
#             bar_color = ft.Colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.Colors.YELLOW_700 if progress >= 0.2 else ft.Colors.RED_700
#             rows.append(
#                 ft.DataRow(cells=[
#                     ft.DataCell(ft.Text(material.capitalize(), size=get_font_size())),
#                     ft.DataCell(
#                         ft.Row(
#                             [
#                                 session_state['level_fields'][field_key],
#                                 ft.Text(unit, size=13, color=ft.Colors.WHITE),
#                             ],
#                             alignment=ft.MainAxisAlignment.START,
#                             spacing=0
#                         )
#                     ),
#                     ft.DataCell(ft.ProgressBar(value=progress, width=page.window_width * 0.07, height=15, color=bar_color, border_radius=5)),
#                     ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=get_font_size())),
#                 ])
#             )

#         product_options = {
#             "MC1": [ft.dropdown.Option("P30"), ft.dropdown.Option("P40")],
#             "MC2": [ft.dropdown.Option("P10"), ft.dropdown.Option("P16"), ft.dropdown.Option("P20"), ft.dropdown.Option("P30")],
#             "MC3": [ft.dropdown.Option("P30")]
#         }.get(molino.nombre, [])
#         feed_rate_key = f"{molino.nombre}_feed_rate"
#         session_state['feed_rate_fields'][feed_rate_key] = ft.TextField(
#             prefix_text="Rendimiento: ",
#             value=f"{molino.alimentacion_fresca}",
#             width=page.window_width * 0.155,
#             text_size=get_font_size(),
#             filled=True,
#             text_align=ft.TextAlign.RIGHT,
#             suffix_text=" t/h",
#             on_submit=lambda e, m=molino, s=sistema, p=page: update_feed_rate(m, e.control.value, s, p),
#             tooltip="Alimentación fresca (t/h)"
#         )
        
#         dropdown_key = f"{molino.nombre}_status"
#         session_state['status_dropdowns'][dropdown_key] = ft.Dropdown(
#             options=[
#                 ft.dropdown.Option("Encendido"),
#                 ft.dropdown.Option("Apagado")
#             ],
#             value="Encendido" if session_state['estado_molinos'][molino.nombre.lower()] else "Apagado",
#             width=page.window_width * 0.12,
#             filled=True,
#             text_size=get_font_size(),
#             color=ft.Colors.GREEN if session_state['estado_molinos'][molino.nombre.lower()] else ft.Colors.RED,
#             on_change=lambda e, m=molino: update_running_state(m, e.control.value, sistema, page),
#             tooltip="Estado de marcha"
#         )

#         def calculate_card_height(molinos_list):
#             max_materials = max(len(molino.tolvas) for molino in molinos_list) if molinos_list else 1
#             base_height = 150
#             material_height = 45
#             return base_height + (max_materials * material_height)
    
#         molinos_list = [sistema.mc1, sistema.mc2, sistema.mc3]
#         card_height = calculate_card_height(molinos_list)
        
#         card = ft.Card(
#             content=ft.Container(
#                 content=ft.Column([
#                     ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER),
#                     ft.Row(
#                         controls=[
#                             session_state['status_dropdowns'][dropdown_key],
#                             ft.Dropdown(
#                                 options=product_options,
#                                 value=molino.tipo_producto.value if molino.tipo_producto else product_options[0].key,
#                                 width=page.window_width * 0.075,
#                                 filled=True,
#                                 text_size=get_font_size(),
#                                 on_change=lambda e, m=molino: update_product_type(m, e.control.value, sistema, page),
#                                 tooltip="Tipo de producto"
#                             ),
#                             session_state['feed_rate_fields'][feed_rate_key],
#                         ],
#                         alignment=ft.MainAxisAlignment.SPACE_EVENLY,
#                         vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                         wrap=True,
#                     ),
#                     ft.Container(
#                         content=ft.DataTable(
#                             columns=[
#                                 ft.DataColumn(ft.Text("   Material", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("   Nivel", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("    Tolva", size=get_font_size())),
#                                 ft.DataColumn(ft.Text("   T.V", size=get_font_size())),
#                             ],
#                             rows=rows,
#                             column_spacing=7,
#                             horizontal_margin=6,
#                         ),
#                         expand=True,
#                         width=page.window_width * 0.9,
#                         bgcolor=ft.Colors.TRANSPARENT,
#                         padding=ft.padding.only(left=0, right=0),
#                     )
#                 ],
#                 scroll="always",
#                 horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#                 spacing=0,
#                 expand=True,
#                 ),
#                 padding=7,
#                 height=350,
#             ),
#             elevation=0,
#         )
#         cards.append(card)

#     pddl_card = ft.Card(
#         content=ft.Container(
#             content=ft.Column([
#                 session_state['pddl_display']
#             ],
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER),
#             padding=10,
#             width=min(page.window_width * 0.9, 1000),
#             height=300,  # Adjusted for Gantt chart
#             bgcolor=ft.Colors.WHITE,
#             border_radius=10
#         ),
#         elevation=0
#     )

#     page.add(
#         ft.Container(
#             content=header_content,
#             padding=ft.padding.only(bottom=6),
#             margin=0,
#             alignment=ft.alignment.center,
#         ),
#         ft.ResponsiveRow(
#             controls=[ft.Column(col={"xs": 12, "sm": 6, "md": 4}, controls=[card]) for card in cards],
#             alignment=ft.MainAxisAlignment.CENTER,
#             spacing=0,
#             run_spacing=0
#         ),
#         ft.Container(
#             content=ft.ElevatedButton(
#                 "Generar Plan",
#                 on_click=lambda e: update_levels(e, sistema, page),
#                 bgcolor=ft.Colors.BLUE_700,
#                 color=ft.Colors.WHITE,
#                 height=40,
#                 width=page.window_width * 0.2
#             ),
#             alignment=ft.alignment.center,
#             padding=0
#         ),
#         ft.Container(
#             content=pddl_card,
#             alignment=ft.alignment.center,
#             padding=0
#         )
#     )
#     page.update()

# # ---------------------------------------------
# # Update Levels
# # ---------------------------------------------

# def update_levels(e, sistema: SistemaAlimentacion, page: ft.Page):
#     session_state = page.session_state
    
#     session_state['pddl_display'].controls.clear()
#     session_state['pddl_display'].controls.append(
#         ft.Container(
#             content=ft.Column([
#                 ft.ProgressRing(
#                     color=ft.Colors.BLUE_700,
#                     width=50,
#                     height=50,
#                     stroke_width=5
#                 ),
#                 ft.Text(
#                     "Buscando rutas disponibles...",
#                     size=16,
#                     color=ft.Colors.BLACK,
#                     text_align=ft.TextAlign.CENTER
#                 )
#             ],
#             alignment=ft.MainAxisAlignment.CENTER,
#             horizontal_alignment=ft.CrossAxisAlignment.CENTER,
#             spacing=10
#             ),
#             alignment=ft.alignment.center,
#             expand=True
#         )
#     )
#     page.update()

#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         for material, tolva in molino.tolvas.items():
#             field_key = f"{molino.nombre}_{material}"
#             if field_key in session_state['level_fields'] and session_state['level_fields'][field_key].value:
#                 try:
#                     new_level = float(session_state['level_fields'][field_key].value)
#                     if molino.nombre == "MC3":
#                         tolva.nivel_actual = max(0, min(new_level, 100))
#                     else:
#                         tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))
#                     print(f"Nivel actualizado para {molino.nombre} - {material}: {tolva.nivel_actual:.2f}")
#                 except ValueError:
#                     print(f"Valor inválido para nivel de {molino.nombre} - {material}: {session_state['level_fields'][field_key].value}")
#         feed_rate_key = f"{molino.nombre}_feed_rate"
#         if feed_rate_key in session_state['feed_rate_fields'] and session_state['feed_rate_fields'][feed_rate_key].value:
#             try:
#                 new_feed = float(session_state['feed_rate_fields'][feed_rate_key].value)
#                 if new_feed >= 0:
#                     molino.set_alimentacion_fresca(new_feed)
#                     print(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h")
#                 else:
#                     print(f"Valor inválido para alimentación fresca de {molino.nombre}: {new_feed}")
#             except ValueError:
#                 print(f"Valor inválido para alimentación fresca de {molino.nombre}: {session_state['feed_rate_fields'][feed_rate_key].value}")

#     refresh_cards(sistema=sistema, page=page)
#     page.update()

#     try:

#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         if not tolvas_criticas:
#             raise ValueError("No hay tolvas críticas para planificar.")
#         pddl_content = generar_problema_pddl_dinamico(
#             session_state['estado_molinos'],
#             session_state['estado_rutas'],
#             tolvas_criticas,
#             tiempos_por_tolva,
#             path_output=f"PDDL/cement_problem_{page.session_id}.pddl"
#         )

#     except ValueError as e:
#         print(f"❌ Error al generar problema PDDL: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al generar problema PDDL: {e}"),
#             open=True,
#             duration=5000
#         )
#         page.update()
#         return
    
#     DOMAIN = BASE_DIR / "PDDL" / "cement-alimentacion.pddl"
#     PROBLEM = BASE_DIR / "PDDL" / f"cement_problem_{page.session_id}.pddl"
#     WORKSPACE = BASE_DIR / "PDDL"

#     try:
#         with open(PROBLEM, 'w', encoding='utf-8') as f:
#             f.write(pddl_content)
#         print(f"Problema PDDL guardado en {PROBLEM}")
#     except Exception as e:
#         print(f"Error al guardar el problema PDDL: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al guardar el problema PDDL: {e}"),
#             open=True,
#             duration=5000
#         )
#         page.update()
#         return
    
#     try:
#         executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
#         success, chart_base64 = executor.execute()
        
#         session_state['pddl_display'].controls.clear()
        
#         if success and chart_base64:
#             plan_path = executor.output_dir / max(executor.output_dir.glob("plan_optic_*.md"), key=os.path.getmtime, default=None)
#             if plan_path and plan_path.exists():
#                 session_state['pddl_display'].controls.append(
#                     ft.Container(
#                         content=ft.Image(
#                             src_base64=chart_base64,
#                             width=min(page.window_width * 0.9, 1000),
#                             height=300,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                         alignment=ft.alignment.center
#                     )
#                 )
#                 page.snack_bar = ft.SnackBar(
#                     Text(f"✅ Gráfico Gantt generado con éxito"),
#                     open=True,
#                     duration=5000
#                 )
#             else:
#                 print("❌ No se encontraron planes generados")
#                 session_state['pddl_display'].controls.append(
#                     ft.Text(
#                         "Error: No se encontraron planes",
#                         color=ft.Colors.BLACK,
#                         size=22,
#                         expand=True,
#                         no_wrap=False
#                     )
#                 )
#                 page.snack_bar = ft.SnackBar(
#                     Text("❌ No se encontraron planes generados"),
#                     open=True,
#                     duration=5000
#                 )
#         else:
#             print("❌ Falló la generación del plan o gráfico")
#             session_state['pddl_display'].controls.append(
#                 ft.Text(
#                     "Error: No se pudo generar el plan o el gráfico",
#                     color=ft.Colors.BLACK,
#                     size=22,
#                     expand=True,
#                     no_wrap=False
#                 )
#             )
#             page.snack_bar = ft.SnackBar(
#                 Text("❌ No se pudo generar el plan o el gráfico"),
#                 open=True,
#                 duration=5000
#             )
#     except Exception as e:
#         print(f"❌ Error inicial: {e}")
#         session_state['pddl_display'].controls.clear()
#         session_state['pddl_display'].controls.append(
#             ft.Text(
#                 f"Error: {e}",
#                 color=ft.Colors.BLACK,
#                 size=22,
#                 expand=True,
#                 no_wrap=False
#             )
#         )
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error inicial: {e}"),
#             open=True,
#             duration=5000
#         )
    
#     page.update()

# # ---------------------------------------------
# # Main
# # ---------------------------------------------

# def main(page: ft.Page):
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK
#     page.bgcolor = ft.Colors.BLUE_GREY_900
#     page.padding = 5
#     page.window_width = 1200
#     page.window_height = 600
#     page.scroll = ft.ScrollMode.AUTO

#     if not (BASE_DIR / "assets" / "logo.png").exists():
#         print("⚠️ logo.png no encontrado en assets, continuando sin logo")
#         # Continue without logo to avoid blocking execution

#     if not hasattr(page, 'session_state'):
#         page.session_state = {
#             'estado_rutas': {
#                 "MC1-desde-Pretrit": True,
#                 "MC2-desde-Pretrit": True,
#                 "MC3-desde_Silo-Blanco": True,
#                 "Pretrit_a_Silo_Blanco": True,
#                 "PH-a-426HO04-por-MC2": True,
#                 "PH-a-MC1-por-MC2": True,
#                 "PH-a-MC1-por-MC1": True,
#                 "PS-a-MC3-por-MC2": True,
#                 "PS-a-426HO02-por-426HO04": True,
#                 "MC1-por-MC1": True,
#                 "MC1-por-MC2": True,
#                 "MC2-por-MC2": True,
#                 "MC3-por-MC1": True,
#                 "MC3-por-MC2": True
#             },
#             'estado_molinos': {
#                 "mc1": True,
#                 "mc2": True,
#                 "mc3": True
#             },
#             'level_fields': {},
#             'feed_rate_fields': {},
#             'status_dropdowns': {},
#             'menu_column': None,
#             'pddl_display': ft.ListView(
#                 controls=[
#                     ft.Text(
#                         "Presione 'Generar Plan' para ver el contenido.",
#                         color=ft.Colors.BLACK,
#                         size=22,
#                         expand=True,
#                         no_wrap=False
#                     )
#                 ],
#                 expand=True,
#                 height=240,
#                 auto_scroll=ft.ScrollMode.AUTO
#             )
#         }

#     try:
#         sistema = SistemaAlimentacion()
#         sistema.set_productos()
        
#         sistema.mc1.set_estado(page.session_state['estado_molinos']["mc1"])
#         sistema.mc2.set_estado(page.session_state['estado_molinos']["mc2"])
#         sistema.mc3.set_estado(page.session_state['estado_molinos']["mc3"])
        
#         # Set initial hopper levels to test negative emptying times
#         sistema.mc1.tolvas["clinker"].nivel_actual = 1.0  # Below nivel_ineficiente (2.8)
#         sistema.mc1.tolvas["puzolana"].nivel_actual = 1.0  # Below nivel_ineficiente (2.4)
#         sistema.mc1.tolvas["yeso"].nivel_actual = 1.0  # Below nivel_ineficiente (2.0)
#         sistema.mc2.tolvas["clinker"].nivel_actual = 1.0  # Below nivel_ineficiente (1.8)
#         sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 2.0  # Below nivel_ineficiente (3.0)
#         sistema.mc2.tolvas["puzolana_seca"].nivel_actual = 1.0  # Below nivel_ineficiente (2.4)
#         sistema.mc2.tolvas["yeso"].nivel_actual = 1.0  # Below nivel_ineficiente (1.8)
#         sistema.mc3.tolvas["clinker"].nivel_actual = 40.0  # Below nivel_ineficiente (50)
#         sistema.mc3.tolvas["puzolana"].nivel_actual = 45.0  # Below nivel_ineficiente (50)
#         sistema.mc3.tolvas["yeso"].nivel_actual = 40.0  # Below nivel_ineficiente (50)
        
#         refresh_cards(sistema=sistema, page=page)
#         page.update()
    
#     except Exception as e:
#         print(f"❌ Error en main: {e}")
#         page.snack_bar = ft.SnackBar(
#             Text(f"❌ Error al inicializar la aplicación: {e}"),
#             open=True,
#             duration=5000
#         )
#         refresh_cards(sistema=sistema, page=page)
#         page.update()

# if __name__ == "__main__":
#     ft.app(
#         target=main,
#         view=ft.WEB_BROWSER,
#         port=int(os.getenv("PORT", "8080")),
#         assets_dir="assets",
#         host="0.0.0.0"
#     )


import os
from pathlib import Path
import requests
import re
import time
from datetime import datetime
import flet as ft
from flet import Page, SnackBar, Text, Column, Card, Container, ListView, TextAlign, FontWeight, CrossAxisAlignment, ProgressRing, Image
import enum
from typing import List, Dict, Tuple
import matplotlib
matplotlib.use('Agg')  # Usar backend no interactivo
import matplotlib.pyplot as plt
import io
import base64

BASE_DIR = Path(__file__).resolve().parent
ASSETS_DIR = BASE_DIR / "assets"
LOGO_PATH_WEB = "logo.png"

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
    def __init__(self, material: str, capacidad: float, altura_max: float, nivel_ineficiente: float):
        self.material = material
        self.capacidad = capacidad
        self.altura_max = altura_max
        self.nivel_actual = 0
        self.nivel_ineficiente = nivel_ineficiente

    def tiempo_vaciado(self, consumo_por_hora: float) -> float:
        if consumo_por_hora <= 0:
            return float('inf')
        toneladas_reales = ((self.nivel_actual - self.nivel_ineficiente) * self.capacidad) / self.altura_max
        print(f"Calculando tiempo de vaciado para {self.material}: nivel_actual={self.nivel_actual}, nivel_ineficiente={self.nivel_ineficiente}, capacidad={self.capacidad}, altura_max={self.altura_max}, consumo={consumo_por_hora}")
        print(f"Toneladas reales: {toneladas_reales}")
        return toneladas_reales / consumo_por_hora

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
        consumo = ((self.alimentacion_fresca * self.ratios[material]) / 100)
        print(f"Consumo para {material} en {self.nombre}: {consumo} t/h")
        return self.tolvas[material].tiempo_vaciado(consumo)

# ---------------------------------------------
# Sistema de alimentación
# ---------------------------------------------

class SistemaAlimentacion:
    def __init__(self):
        self.mc1 = Molino("MC1", {
            "clinker": Tolva("Clinker", 500, 14, 2.8),
            "puzolana": Tolva("Puzolana", 300, 12, 2.4),
            "yeso": Tolva("Yeso", 300, 10, 2)
        }, 1)

        self.mc2 = Molino("MC2", {
            "clinker": Tolva("Clinker", 300, 9, 1.8),
            "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15, 3),
            "puzolana_seca": Tolva("Puzolana Seca", 100, 12, 2.4),
            "yeso": Tolva("Yeso", 120, 9, 1.8)
        }, 0.8)

        self.mc3 = Molino("MC3", {
            "clinker": Tolva("Clinker", 60, 100, 50),
            "puzolana": Tolva("Puzolana", 35, 100, 50),
            "yeso": Tolva("Yeso", 30, 100, 50)
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
# Funciones para vaciado y generación PDDL
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
                if tiempo < umbral and sistema.__dict__[nombre_molino].en_marcha:
                    tolvas_a_llenar.append(nombre_tolva_pddl)
    return tolvas_a_llenar, tiempos_por_tolva

def generar_problema_pddl_dinamico(estado_molinos: Dict[str, bool], estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
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
    pddl_content = """
(define (problem cement-production-problem)
(:domain cement-alimentacion)

(:objects
    ;; Molinos
    mc1 mc2 mc3 - molino

    ;; Tolvas
    t1-clinker t1-puzolana-h t1-yeso
    t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
    t3-clinker t3-puzolana-s t3-yeso - tolva

    ;; Materias
    clinker puzolana-h puzolana-s yeso - materia

    ;; Rutas
    MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
    PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 
    PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 
    MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
)

(:init
    ;; Molinos en marcha
    (en-marcha mc1) (en-marcha mc2) (en-marcha mc3)

    ;; Tolvas libres
    (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
    (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
    (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

    ;; Compatibilidades
    (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
    (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
    (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
    (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

    ;; Material disponible
    (material-disponible clinker)
    (material-disponible puzolana-h)
    (material-disponible puzolana-s)
    (material-disponible yeso)

    ;; Recursos positivos iniciales
    (clinker-libre)
    (puzolana-h-libre PH-a-MC1-por-MC1)
    (puzolana-h-libre PH-a-MC1-por-MC2)
    (puzolana-h-libre PH-a-426HO04-por-MC2)
    (puzolana-s-libre mc1)
    (puzolana-s-libre mc2) 
    (puzolana-s-libre mc3) 
    (ruta-yeso-libre mc2 MC2-por-MC2)
    (ruta-yeso-libre mc3 MC3-por-MC2)
    (yeso-libre mc1)
    (yeso-libre mc2)
    (yeso-libre mc3)
    (molino-libre-clinker mc1)
    (molino-libre-clinker mc2)
    (molino-libre-clinker mc3)

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
    (= (duracion-llenado t1-yeso MC1-por-MC2) 3)
    (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
    (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
    (= (duracion-llenado t3-yeso MC3-por-MC2) 6)

    ;; Inicializar tiempo y costo
    (= (tiempo-acumulado) 0)
    (= (costo-total) 0)
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
        ("mc1", "t1-yeso", "MC1-por-MC2"),
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
    pddl_content += "  ))\n  (:metric minimize (costo-total))\n)"
    with open(path_output, "w") as f:
        f.write(pddl_content)
    return pddl_content

# ---------------------------------------------
# PDDL Executor
# ---------------------------------------------

class PDDLExecutor:
    def __init__(self, domain_path, problem_path, workspace_path):
        self.domain_path = Path(domain_path)
        self.problem_path = Path(problem_path)
        self.workspace_path = Path(workspace_path)
        self.output_dir = self.workspace_path / "generated_plans"
        self.output_dir.mkdir(exist_ok=True)
        self.delays = {
            'plan_generation': 60,
            'monitor_interval': 5,
            'max_attempts': 10
        }

    def _plot_gantt(self, plan_text):
        try:
            tasks = []
            for line in plan_text.splitlines():
                # Expresión regular más robusta para manejar posibles espacios o variaciones
                match = re.match(r'^(\d+\.\d+):\s*\(alimentar-(\w+(?:-\w+)?)\s+(\w+)\s+(\S+)\s+(\S+)\)\s*\[(\d+\.\d+)\]$', line.strip())
                if match:
                    start_time = float(match.group(1))
                    material = match.group(2).lower()  # Normalizar a minúsculas
                    molino = match.group(3)
                    tolva = match.group(4)
                    ruta = match.group(5)
                    duration = float(match.group(6))
                    # Etiqueta más concisa, como en el código de referencia
                    task_label = f"alimentar-{material} {tolva} {ruta} "
                    tasks.append({
                        'Task': task_label,
                        'Start': start_time,
                        'Finish': start_time + duration,
                        'Material': material  # Para asignar colores
                    })



                # # Expresión regular ajustada para capturar toda la ruta hasta el corchete
                # match = re.match(r'^(\d+\.\d+):\s*\(alimentar-(\w+(?:-\w+)?)\s+(\w+)\s+(\S+)\s+(.*?)(?=\s*\[)\s*\[(\d+\.\d+)\]$', line.strip())
                # # match = re.match(r'^(\d+\.\d+):\s*\(alimentar-(\w+(?:-\w+)?)\s+(\w+)\s+(\S+)\s+(.*)(?=\[)\s*\[(\d+\.\d+)\]$', line.strip())
                # if match:
                #     start_time = float(match.group(1))
                #     material = match.group(2).lower()
                #     molino = match.group(3)
                #     tolva = match.group(4)
                #     ruta = match.group(5) # Captura toda la ruta hasta el corchete
                #     duration = float(match.group(6))
                #     task_label = f"alimentar-{material} {tolva} {ruta}"
                #     tasks.append({
                #         'Task': task_label,
                #         'Start': start_time,
                #         'Finish': start_time + duration,
                #         'Material': material,
                #         'Route': ruta  # Añadir ruta para depuración o uso futuro
                #     })

            if not tasks:
                print("⚠️ No se encontraron tareas válidas para el diagrama de Gantt")
                return None

            print(f"📋 Tareas parseadas: {tasks}")

            # Colores brillantes como en el código de referencia
            colores = {
                'puzolanah': '#00FF00',  # Verde neón para puzolana-h
                'puzolanas': '#0000FF',  # Azul eléctrico para puzolana-s
                'yeso': '#FF00FF',       # Magenta para yeso
                'clinker': '#FF0000'     # Rojo vivo para clinker
            }

            # Crear figura con tamaño ajustado
            n = len(tasks)
            print(f"📊 Número de tareas a graficar: {n}")
            fig, ax = plt.subplots(figsize=(16, max(n * 0.5, 5)))     # Modifica el ancho de las barras 
            # Fondo oscuro solo en el área de los ejes
            # ax.set_facecolor("#1e1e1e")
            ax.set_facecolor("#ffffff")

            # Graficar barras en orden de arriba hacia abajo
            for idx, task in enumerate(tasks):
                y = n - 1 - idx  # Primera acción arriba
                # Asignar color según el material, con depuración
                material_key = task['Material'].replace('-', '')  # Normalizar puzolana-h a puzolanah
                color = colores.get(material_key, '#808080')  # Gris por defecto
                print(f"🎨 Tarea: {task['Task']}, Material: {material_key}, Color asignado: {color}")
                # Barras sin borde
                ax.barh(y, task['Finish'] - task['Start'], left=task['Start'], 
                        color=color, edgecolor=None, linewidth=0)
                # Añadir texto de duración en el centro de la barra
                ax.text(task['Start'] + (task['Finish'] - task['Start']) / 2, y, 
                        f"{task['Finish'] - task['Start']:.1f}",
                        ha="center", va="center", color="white",
                        fontsize=14  , weight="bold")

            # Etiquetas y estilo
            ax.set_yticks(range(n))
            ax.set_yticklabels([task['Task'] for task in reversed(tasks)], color="black" ,fontsize=23)
            # ax.set_yticklabels(
            #     [task['Task'] for task in reversed(tasks)],
            #     color="black",
            #     fontsize=20,
            #     fontfamily="Courier New",   # Fuente monoespaciada (puedes usar 'Courier New' u otra)
            #     ha="left"                        # Alineación a la izquierda
            # )
            # ax.set_xlabel("Tiempo (horas)", color="black")
            # ax.set_title("Planificación PDDL – Diagrama de Gantt", color="black")
            # Desplazar las etiquetas hacia la izquierda
            # ax.tick_params(axis="y", which="major", pad=450)  # aumenta el pad para separarlas del área de barras
            ax.tick_params(colors="black")

            plt.tight_layout()

            # Guardar la imagen en un buffer
            buf = io.BytesIO()
            plt.savefig(buf, format='png', bbox_inches='tight', dpi=100)
            buf.seek(0)
            img_data = buf.getvalue()
            
            # Guardar imagen para depuración
            debug_path = BASE_DIR / "debug_gantt.png"
            with open(debug_path, "wb") as f:
                f.write(img_data)
            print(f"✅ Imagen de depuración guardada en {debug_path}")

            # Codificar en base64
            img_base64 = base64.b64encode(img_data).decode('utf-8')
            # print(f"Primeros 50 caracteres del base64: {img_base64[:50]}")
            # print(f"Longitud del string base64: {len(img_base64)}")
            
            # Verificar que el base64 sea válido
            try:
                base64.b64decode(img_base64)
                print("✅ String base64 válido")
            except Exception as e:
                print(f"❌ Error al validar base64: {e}")
                return None

            buf.close()
            plt.close(fig)
            return img_base64  # Retornar solo el string base64 puro

        except Exception as e:
            print(f"❌ Error al generar el diagrama de Gantt: {e}")
            return None


    def execute(self):
        print("🚀 Iniciando planificación PDDL con OPTIC")
        print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

        if not self._check_files():
            return False, None

        try:
            with open(self.domain_path, 'r', encoding='utf-8') as f:
                domain_content = f.read()
            with open(self.problem_path, 'r', encoding='utf-8') as f:
                problem_content = f.read()

            url = "https://solver.planning.domains:5001/package/optic/solve"
            payload = {"domain": domain_content, "problem": problem_content}
            response = requests.post(url, json=payload, timeout=self.delays['plan_generation'])

            if response.status_code != 200:
                print(f"❌ Error en la solicitud: {response.status_code}")
                print(response.text)
                return False, None

            try:
                initial_response = response.json()
            except json.JSONDecodeError:
                print("❌ No se pudo parsear la respuesta inicial como JSON")
                return False, None

            check_url = initial_response.get('result', '')
            if not check_url.startswith('/check/'):
                print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
                return False, None

            check_url = f"https://solver.planning.domains:5001{check_url}"
            plan_text = self._poll_for_plan(check_url)

            if plan_text:
                best_plan = self._select_best_plan(plan_text)
                if best_plan:
                    plan_path = self._save_plan(best_plan, plan_text)
                    if plan_path:
                        gantt_img = self._plot_gantt(best_plan['actions'])
                        self._display_plan(plan_path)
                        return True, gantt_img
                print("❌ No se encontró un plan válido")
                return False, None

            print("❌ No se obtuvo plan después de intentos")
            return False, None

        except Exception as e:
            print(f"❌ Error crítico: {e}")
            return False, None

    def _check_files(self):
        if not self.domain_path.exists():
            print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
            return False
        if not self.problem_path.exists():
            print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
            return False
        return True

    def _poll_for_plan(self, check_url):
        for attempt in range(self.delays['max_attempts']):
            try:
                response = requests.get(check_url, timeout=self.delays['plan_generation'])
                if response.status_code != 200:
                    print(f"❌ Error en la verificación: {response.status_code}")
                    return None
                data = response.json()
                if data.get('status') == 'ok' and 'output' in data.get('result', {}):
                    output = data['result']['output']
                    if isinstance(output, dict):
                        plan_text = output.get('plan') or output.get('stdout', '')
                    else:
                        plan_text = str(output)
                    if plan_text:
                        return plan_text
            except Exception as e:
                print(f"⚠️ Intento {attempt+1} falló: {e}")
            time.sleep(self.delays['monitor_interval'])
        print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
        return None

    def _select_best_plan(self, log_content):
        plan_blocks = re.split(r";\s*Plan found with metric\s+[\d.]+", log_content, flags=re.IGNORECASE)
        metric_matches = list(re.finditer(r";\s*Plan found with metric\s+([\d.]+)", log_content, re.IGNORECASE))
        
        best_plan = None
        best_metric = float('inf')
        
        for block, metric_match in zip(plan_blocks[1:], metric_matches):
            actions = "\n".join(line.strip() for line in block.splitlines() if re.match(r"^\d+\.\d+:", line))
            if not actions:
                continue
            
            metric_value = float(metric_match.group(1)) if metric_match else None
            if metric_value is None or metric_value == 0:
                continue
            
            if metric_value < best_metric:
                best_metric = metric_value
                best_plan = actions
        
        if best_plan:
            return {
                "actions": best_plan,
                "metric": best_metric,
                "additional_info": ""
            }
        return None

    def _clean_plan(self, plan_text):
        cleaned_lines = []
        seen_actions = set()
        for line in plan_text.splitlines():
            line = line.strip()
            if line and re.match(r"^\d+\.\d+:", line):
                time_match = re.match(r'^(\d+\.\d+):\s*(.*?)\s*\[(\d+\.\d+)\]$', line)
                if time_match:
                    time_prefix = float(time_match.group(1))
                    action = time_match.group(2).strip()
                    duration = float(time_match.group(3))
                    if (time_prefix, action) not in seen_actions:
                        formatted_line = f"{time_prefix:.5f}: {action} [{duration:.5f}]"
                        cleaned_lines.append(formatted_line)
                        seen_actions.add((time_prefix, action))
        return "\n".join(cleaned_lines)

    def _save_plan(self, plan_data, log_content):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        plan_file = self.output_dir / f"plan_optic_{timestamp}.md"
        try:
            with open(plan_file, 'w', encoding='utf-8') as f:
                f.write(f"# Plan Limpio para Alimentación de Materias Primas\n\n")
                f.write(f"## Plan Seleccionado (Metric: {plan_data['metric']})\n\n")
                f.write(f"{self._clean_plan(plan_data['actions'])}")
                f.write(plan_data['additional_info'])
            print(f"✅ Plan guardado en: {plan_file}")
            return plan_file
        except Exception as e:
            print(f"❌ Error al guardar plan: {e}")
            return None

    def _display_plan(self, plan_path):
        print("\n" + "="*50)
        print("PLAN LIMPIO:")
        print("="*50)
        with open(plan_path, 'r', encoding='utf-8') as f:
            print(f.read())
        print("="*50 + "\n")

# ---------------------------------------------
# Flet UI
# ---------------------------------------------

def update_feed_rate(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    try:
        new_feed = float(value)
        if new_feed >= 0:
            print(f"Antes de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            molino.set_alimentacion_fresca(new_feed)
            print(f"Después de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            pddl_content = generar_problema_pddl_dinamico(
                session_state['estado_molinos'],
                session_state['estado_rutas'],
                tolvas_criticas,
                tiempos_por_tolva
            )
            refresh_cards(pddl_content, sistema, page)
            page.snack_bar = ft.SnackBar(ft.Text(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h"), open=True, duration=2000)
        else:
            page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser no negativo"), open=True, duration=2000)
    except ValueError:
        page.snack_bar = ft.SnackBar(ft.Text(f"Valor inválido: debe ser numérico"), open=True, duration=2000)
    page.update()

def update_product_type(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    try:
        tipo_producto = TipoProducto(value)
        molino.cambiar_producto(tipo_producto)
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(
            session_state['estado_molinos'],
            session_state['estado_rutas'],
            tolvas_criticas,
            tiempos_por_tolva
        )
        refresh_cards(pddl_content, sistema, page)
    except ValueError:
        page.snack_bar = ft.SnackBar(ft.Text(f"Tipo de producto inválido: {value}"), open=True, duration=2000)
    page.update()

def update_running_state(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    estado = value == "Encendido"
    molino.set_estado(estado)
    session_state['estado_molinos'][molino.nombre.lower()] = estado
    dropdown_key = f"{molino.nombre}_status"
    if dropdown_key in session_state['status_dropdowns']:
        session_state['status_dropdowns'][dropdown_key].value = value
        session_state['status_dropdowns'][dropdown_key].color = ft.Colors.GREEN if estado else ft.Colors.RED
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
    pddl_content = generar_problema_pddl_dinamico(
        session_state['estado_molinos'],
        session_state['estado_rutas'],
        tolvas_criticas,
        tiempos_por_tolva
    )
    update_pddl_display(pddl_content, page)
    page.update()

def update_pddl_display(pddl_content, page):
    session_state = page.session_state
    session_state['pddl_display'].controls[0].value = pddl_content
    page.update()

def crear_fila_ruta(nombre, estado, sistema, page):
    session_state = page.session_state
    def on_click(e):
        session_state['estado_rutas'][nombre] = not session_state['estado_rutas'][nombre]
        session_state['menu_column'].controls = construir_column_rutas(sistema, page)
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(
            session_state['estado_molinos'],
            session_state['estado_rutas'],
            tolvas_criticas,
            tiempos_por_tolva
        )
        update_pddl_display(pddl_content, page)
        page.update()
    return ft.Container(
        content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
        padding=5,
        on_click=on_click,
        width=245
    )

def construir_column_rutas(sistema, page):
    session_state = page.session_state
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
    controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[:4])
    controls.append(ft.Divider())
    controls.append(titulo("PUZOLANA"))
    controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[4:9])
    controls.append(ft.Divider())
    controls.append(titulo("YESO"))
    controls.extend(crear_fila_ruta(n, e, sistema, page) for n, e in list(session_state['estado_rutas'].items())[9:])
    return controls

def refresh_cards(pddl_content=None, sistema: SistemaAlimentacion=None, page: ft.Page=None):
    session_state = page.session_state
    page.controls.clear()
    cards = []

    if session_state['menu_column'] is None:
        session_state['menu_column'] = ft.Column(controls=construir_column_rutas(sistema, page))
    
    menu_rutas = ft.PopupMenuButton(
        icon=ft.Icons.MENU,
        items=[
            ft.PopupMenuItem(
                content=session_state['menu_column']
            )
        ]
    )

    def get_font_size():
        if page.window_width < 600:
            return 14
        elif page.window_width < 900:
            return 14
        else:
            return 14

    drawer = ft.NavigationDrawer(
        controls=[
            ft.Container(
                content=ft.Column(
                    controls=construir_column_rutas(sistema, page),
                    scroll=ft.ScrollMode.AUTO
                ),
                padding=10
            )
        ]
    )
    page.drawer = drawer

    if page.window_width < 300:
        header_content = ft.Column(
            controls=[
                ft.Text(
                    "OPTIMIZACIÓN DE",
                    size=get_font_size(),
                    weight=ft.FontWeight.BOLD,
                    color="white",
                    text_align=ft.TextAlign.CENTER
                ),
                ft.Row(
                    controls=[
                        ft.IconButton(
                            icon=ft.Icons.MENU,
                            on_click=lambda e: page.show_drawer(drawer),
                            visible=True
                        ),
                        ft.Image(
                            src=LOGO_PATH_WEB,
                            width=page.window_width * 0.06,
                            height=page.window_width * 0.06,
                            fit=ft.ImageFit.CONTAIN
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=10
                ),
                ft.Text(
                    "ALIMENTACIONES",
                    size=get_font_size() * 0.8,
                    weight=ft.FontWeight.BOLD,
                    color="white",
                    text_align=ft.TextAlign.CENTER
                )
            ],
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=5
        )
    else:
        header_content = ft.Row(
            controls=[
                menu_rutas,
                ft.Text(
                    "OPTIMIZACIÓN DE ALIMENTACIONES",
                    size=get_font_size() * 2,
                    weight=ft.FontWeight.BOLD,
                    color="white",
                    text_align=ft.TextAlign.CENTER,
                    expand=True
                ),
                ft.Image(
                    src=LOGO_PATH_WEB,
                    width=page.window_width * 0.06,
                    height=page.window_width * 0.06,
                    fit=ft.ImageFit.CONTAIN
                ),
            ],
            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
            vertical_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=0,
            wrap=False,
            height=70,
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
            session_state['level_fields'][field_key] = ft.TextField(
                value=str(current_level),
                width=40,
                text_align=ft.TextAlign.LEFT,
                border_color=None,
                border=None,
                border_width=0,
                bgcolor=ft.Colors.TRANSPARENT,
                filled=True,
                text_size=get_font_size(),
                content_padding=0,
                on_submit=lambda e: update_levels(e, sistema, page)
            )
            bar_color = ft.Colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.Colors.YELLOW_700 if progress >= 0.2 else ft.Colors.RED_700
            rows.append(
                ft.DataRow(cells=[
                    ft.DataCell(ft.Text(material.capitalize(), size=get_font_size())),
                    ft.DataCell(
                        ft.Row(
                            [
                                session_state['level_fields'][field_key],
                                ft.Text(unit, size=13, color=ft.Colors.WHITE),
                            ],
                            alignment=ft.MainAxisAlignment.START,
                            spacing=0
                        )
                    ),
                    ft.DataCell(ft.ProgressBar(value=progress, width=page.window_width * 0.07, height=15, color=bar_color, border_radius=5)),
                    ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=get_font_size())),
                ])
            )

        product_options = {
            "MC1": [ft.dropdown.Option("P30"), ft.dropdown.Option("P40")],
            "MC2": [ft.dropdown.Option("P10"), ft.dropdown.Option("P16"), ft.dropdown.Option("P20"), ft.dropdown.Option("P30")],
            "MC3": [ft.dropdown.Option("P30")]
        }.get(molino.nombre, [])
        feed_rate_key = f"{molino.nombre}_feed_rate"
        session_state['feed_rate_fields'][feed_rate_key] = ft.TextField(
            prefix_text="Rendimiento: ",
            value=f"{molino.alimentacion_fresca}",
            width=page.window_width * 0.155,
            text_size=get_font_size(),
            filled=True,
            text_align=ft.TextAlign.RIGHT,
            suffix_text=" t/h",
            on_submit=lambda e, m=molino, s=sistema, p=page: update_feed_rate(m, e.control.value, s, p),
            tooltip="Alimentación fresca (t/h)"
        )
        
        dropdown_key = f"{molino.nombre}_status"
        session_state['status_dropdowns'][dropdown_key] = ft.Dropdown(
            options=[
                ft.dropdown.Option("Encendido"),
                ft.dropdown.Option("Apagado")
            ],
            value="Encendido" if session_state['estado_molinos'][molino.nombre.lower()] else "Apagado",
            width=page.window_width * 0.12,
            filled=True,
            text_size=get_font_size(),
            color=ft.Colors.GREEN if session_state['estado_molinos'][molino.nombre.lower()] else ft.Colors.RED,
            on_change=lambda e, m=molino: update_running_state(m, e.control.value, sistema, page),
            tooltip="Estado de marcha"
        )

        def calculate_card_height(molinos_list):
            max_materials = max(len(molino.tolvas) for molino in molinos_list) if molinos_list else 1
            base_height = 150
            material_height = 45
            return base_height + (max_materials * material_height)
    
        molinos_list = [sistema.mc1, sistema.mc2, sistema.mc3]
        card_height = calculate_card_height(molinos_list)
        
        card = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER),
                    ft.Row(
                        controls=[
                            session_state['status_dropdowns'][dropdown_key],
                            ft.Dropdown(
                                options=product_options,
                                value=molino.tipo_producto.value if molino.tipo_producto else product_options[0].key,
                                width=page.window_width * 0.075,
                                filled=True,
                                text_size=get_font_size(),
                                on_change=lambda e, m=molino: update_product_type(m, e.control.value, sistema, page),
                                tooltip="Tipo de producto"
                            ),
                            session_state['feed_rate_fields'][feed_rate_key],
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_EVENLY,
                        vertical_alignment=ft.CrossAxisAlignment.CENTER,
                        wrap=True,
                    ),
                    ft.Container(
                        content=ft.DataTable(
                            columns=[
                                ft.DataColumn(ft.Text("   Material", size=get_font_size())),
                                ft.DataColumn(ft.Text("   Nivel", size=get_font_size())),
                                ft.DataColumn(ft.Text("    Tolva", size=get_font_size())),
                                ft.DataColumn(ft.Text("   T.V", size=get_font_size())),
                            ],
                            rows=rows,
                            column_spacing=7,
                            horizontal_margin=6,
                        ),
                        expand=True,
                        width=page.window_width * 0.9,
                        bgcolor=ft.Colors.TRANSPARENT,
                        padding=ft.padding.only(left=0, right=0),
                    )
                ],
                scroll="always",
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                spacing=0,
                expand=True,
                ),
                padding=7,
                height=350,
            ),
            elevation=0,
        )
        cards.append(card)

    pddl_card = ft.Card(
        content=ft.Container(
            content=ft.Column([
                # ft.Text(
                #     "Plan Generado",
                #     size=get_font_size() * 1.2,
                #     weight=ft.FontWeight.BOLD,
                #     color=ft.Colors.BLACK,
                #     text_align=ft.TextAlign.CENTER
                # ),
                session_state['pddl_display']
            ],
            horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            padding=10,
            width=min(page.window_width * 0.9, 1900),
            height=min(page.window_height * 0.6, 320),  # Aumentado para mejor visualización del Gantt
            bgcolor=ft.Colors.WHITE,
            border_radius=10
        ),
        elevation=0
    )

    page.add(
        ft.Container(
            content=header_content,
            padding=ft.padding.only(bottom=6),
            margin=0,
            alignment=ft.alignment.center,
        ),
        ft.ResponsiveRow(
            controls=[ft.Column(col={"xs": 12, "sm": 6, "md": 4}, controls=[card]) for card in cards],
            alignment=ft.MainAxisAlignment.CENTER,
            spacing=0,
            run_spacing=0
        ),
        ft.Container(
            content=ft.ElevatedButton(
                "Generar Plan",
                on_click=lambda e: update_levels(e, sistema, page),
                bgcolor=ft.Colors.BLUE_700,
                color=ft.Colors.WHITE,
                height=40,
                width=page.window_width * 0.2
            ),
            alignment=ft.alignment.center,
            padding=0
        ),
        ft.Container(
            content=pddl_card,
            alignment=ft.alignment.center,
            padding=0
        )
    )
    page.update()

# ---------------------------------------------
# Update Levels
# ---------------------------------------------

def update_levels(e, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    
    session_state['pddl_display'].controls.clear()
    session_state['pddl_display'].controls.append(
        ft.Container(
            content=ft.Column([
                ft.ProgressRing(
                    color=ft.Colors.BLUE_700,
                    width=50,
                    height=50,
                    stroke_width=5
                ),
                ft.Text(
                    "Buscando rutas disponibles...",
                    size=16,
                    color=ft.Colors.BLACK,
                    text_align=ft.TextAlign.CENTER
                )
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=10
            ),
            alignment=ft.alignment.center,
            expand=True
        )
    )
    page.update()

    for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
        for material, tolva in molino.tolvas.items():
            field_key = f"{molino.nombre}_{material}"
            if field_key in session_state['level_fields'] and session_state['level_fields'][field_key].value:
                try:
                    new_level = float(session_state['level_fields'][field_key].value)
                    if molino.nombre == "MC3":
                        tolva.nivel_actual = max(0, min(new_level, 100))
                    else:
                        tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))
                    print(f"Nivel actualizado para {molino.nombre} - {material}: {tolva.nivel_actual:.2f}")
                except ValueError:
                    print(f"Valor inválido para nivel de {molino.nombre} - {material}: {session_state['level_fields'][field_key].value}")
        feed_rate_key = f"{molino.nombre}_feed_rate"
        if feed_rate_key in session_state['feed_rate_fields'] and session_state['feed_rate_fields'][feed_rate_key].value:
            try:
                new_feed = float(session_state['feed_rate_fields'][feed_rate_key].value)
                if new_feed >= 0:
                    molino.set_alimentacion_fresca(new_feed)
                    print(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h")
                else:
                    print(f"Valor inválido para alimentación fresca de {molino.nombre}: {new_feed}")
            except ValueError:
                print(f"Valor inválido para alimentación fresca de {molino.nombre}: {session_state['feed_rate_fields'][feed_rate_key].value}")

    refresh_cards(sistema=sistema, page=page)
    page.update()

    try:
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        if not tolvas_criticas:
            raise ValueError("No hay tolvas críticas para planificar.")
        min_tiempo = min(tiempos_por_tolva.values(), default=0)
        if min_tiempo < 0:
            C = abs(min_tiempo) + 0.01
            print(f"⚠️ Tiempo mínimo detectado: {min_tiempo:.2f} h, aplicando desplazamiento C={C:.2f}")
            for tolva in tiempos_por_tolva:
                tiempos_por_tolva[tolva] = tiempos_por_tolva[tolva] + C
                print(f"Tiempo ajustado para {tolva}: {tiempos_por_tolva[tolva]:.2f} h")
        pddl_content = generar_problema_pddl_dinamico(
            session_state['estado_molinos'],
            session_state['estado_rutas'],
            tolvas_criticas,
            tiempos_por_tolva,
            path_output=f"PDDL/cement_problem_{page.session_id}.pddl"
        )

    except ValueError as e:
        print(f"❌ Error al generar problema PDDL: {e}")
        session_state['pddl_display'].controls.clear()
        session_state['pddl_display'].controls.append(
            ft.Text(
                f"Error: {e}",
                color=ft.Colors.BLACK,
                size=22,
                expand=True,
                no_wrap=False
            )
        )
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error al generar problema PDDL: {e}"),
            open=True,
            duration=5000
        )
        page.update()
        return
    
    DOMAIN = BASE_DIR / "PDDL" / "cement-alimentacion.pddl"
    PROBLEM = BASE_DIR / "PDDL" / f"cement_problem_{page.session_id}.pddl"
    WORKSPACE = BASE_DIR / "PDDL"

    try:
        with open(PROBLEM, 'w', encoding='utf-8') as f:
            f.write(pddl_content)
        print(f"Problema PDDL guardado en {PROBLEM}")
    except Exception as e:
        print(f"Error al guardar el problema PDDL: {e}")
        session_state['pddl_display'].controls.clear()
        session_state['pddl_display'].controls.append(
            ft.Text(
                f"Error: {e}",
                color=ft.Colors.BLACK,
                size=22,
                expand=True,
                no_wrap=False
            )
        )
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error al guardar el problema PDDL: {e}"),
            open=True,
            duration=5000
        )
        page.update()
        return
    
    try:
        executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
        success, gantt_img = executor.execute()
        
        session_state['pddl_display'].controls.clear()
        
        if success and gantt_img:
            # Usar el string base64 puro, sin prefijo
            print(f"Primeros 50 caracteres del base64 (puro): {gantt_img[:50]}")
            print(f"Longitud del string base64 (puro): {len(gantt_img)}")
            
            # Verificar que el base64 sea válido
            try:
                base64.b64decode(gantt_img)
                print("✅ Base64 válido antes de pasar a ft.Image")
                session_state['pddl_display'].controls.append(
                    ft.Image(
                        src_base64=gantt_img,  # Pasar base64 puro
                        width=min(page.window_width * 0.9, 700),
                        height=min(page.window_height * 0.5, 400),
                        fit=ft.ImageFit.CONTAIN,
                        error_content=ft.Text("Error: No se pudo cargar el diagrama de Gantt", color=ft.Colors.RED)
                    )
                )
                page.snack_bar = ft.SnackBar(
                    Text(f"✅ Plan generado con éxito"),
                    open=True,
                    duration=5000
                )
            except base64.binascii.Error as e:
                print(f"❌ Error al decodificar base64: {e}")
                session_state['pddl_display'].controls.append(
                    ft.Text(
                        f"Error: No se pudo cargar el diagrama de Gantt - Formato base64 inválido: {e}",
                        color=ft.Colors.BLACK,
                        size=22,
                        expand=True,
                        no_wrap=False
                    )
                )
                page.snack_bar = ft.SnackBar(
                    Text(f"❌ Error al cargar el diagrama de Gantt: Formato base64 inválido"),
                    open=True,
                    duration=5000
                )
        else:
            print("❌ Falló la generación del plan o del diagrama de Gantt")
            session_state['pddl_display'].controls.clear()
            session_state['pddl_display'].controls.append(
                ft.Text(
                    "Error: No se pudo generar el plan o el diagrama de Gantt",
                    color=ft.Colors.BLACK,
                    size=22,
                    expand=True,
                    no_wrap=False
                )
            )
            page.snack_bar = ft.SnackBar(
                Text("❌ No se pudo generar el plan o el diagrama de Gantt"),
                open=True,
                duration=5000
            )
    except Exception as e:
        print(f"❌ Error inicial: {e}")
        session_state['pddl_display'].controls.clear()
        session_state['pddl_display'].controls.append(
            ft.Text(
                f"Error: {e}",
                color=ft.Colors.BLACK,
                size=22,
                expand=True,
                no_wrap=False
            )
        )
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error inicial: {e}"),
            open=True,
            duration=5000
        )
    
    page.update()


# ---------------------------------------------
# Main
# ---------------------------------------------

def main(page: ft.Page):
    page.title = "Sistema de Alimentación de Molinos de Cemento"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = ft.Colors.BLUE_GREY_900
    page.padding = 5
    page.window_width = 1200
    page.window_height = 600
    page.scroll = ft.ScrollMode.AUTO

    if not (BASE_DIR / "assets" / "logo.png").exists():
        print("⚠️ logo.png no encontrado en assets, continuando sin logo")

    if not hasattr(page, 'session_state'):
        page.session_state = {
            'estado_rutas': {
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
            },
            'estado_molinos': {
                "mc1": True,
                "mc2": True,
                "mc3": True
            },
            'level_fields': {},
            'feed_rate_fields': {},
            'status_dropdowns': {},
            'menu_column': None,
            'pddl_display': ft.ListView(
                controls=[
                    ft.Text(
                        "Presione 'Generar Plan' para ver el contenido.",
                        color=ft.Colors.BLACK,
                        size=22,
                        expand=True,
                        no_wrap=False
                    )
                ],
                expand=True,
                height=240,
                auto_scroll=ft.ScrollMode.AUTO
            )
        }

    try:
        sistema = SistemaAlimentacion()
        sistema.set_productos()
        
        sistema.mc1.set_estado(page.session_state['estado_molinos']["mc1"])
        sistema.mc2.set_estado(page.session_state['estado_molinos']["mc2"])
        sistema.mc3.set_estado(page.session_state['estado_molinos']["mc3"])
        
        sistema.mc1.tolvas["clinker"].nivel_actual = 1.0
        sistema.mc1.tolvas["puzolana"].nivel_actual = 1.0
        sistema.mc1.tolvas["yeso"].nivel_actual = 1.0
        sistema.mc2.tolvas["clinker"].nivel_actual = 1.5
        sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 1.0
        sistema.mc2.tolvas["puzolana_seca"].nivel_actual = 6.3
        sistema.mc2.tolvas["yeso"].nivel_actual = 6.1
        sistema.mc3.tolvas["clinker"].nivel_actual = 10.0
        sistema.mc3.tolvas["puzolana"].nivel_actual = 15.0
        sistema.mc3.tolvas["yeso"].nivel_actual = 10.5
        
        refresh_cards(sistema=sistema, page=page)
        page.update()
    
    except Exception as e:
        print(f"❌ Error en main: {e}")
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error al inicializar la aplicación: {e}"),
            open=True,
            duration=5000
        )
        refresh_cards(sistema=sistema, page=page)
        page.update()

if __name__ == "__main__":
    ft.app(
        target=main,
        view=ft.WEB_BROWSER,
        port=int(os.getenv("PORT", "8080")),
        assets_dir="assets",
        host="0.0.0.0"
    )