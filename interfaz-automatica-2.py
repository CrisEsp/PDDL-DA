import os
from pathlib import Path
import requests
import re
import time
from datetime import datetime
import flet as ft
from flet import Page, SnackBar, Text, Column, Card, Container, ListView, TextAlign, FontWeight, CrossAxisAlignment
import enum
from typing import List, Dict, Tuple

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
        toneladas_reales = ((self.nivel_actual - self.nivel_ineficiente) * self.capacidad) / self.altura_max
        print(f"Nivel actual de {self.material}: {self.nivel_actual} m, Capacidad: {self.capacidad} t, Altura máxima: {self.altura_max} m")
        print(f"Toneladas reales en {self.material}: {toneladas_reales} t")
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
# Funciones de actualización
# ---------------------------------------------

def update_feed_rate(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    try:
        new_feed = float(value)
        if new_feed >= 0:
            print(f"Antes de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            try:
                molino.set_alimentacion_fresca(new_feed)
                print(f"Después de actualizar: {molino.nombre} alimentacion_fresca = {molino.alimentacion_fresca}")
            except AttributeError as e:
                print(f"❌ Error: No se encontró el método set_alimentacion_fresca en {molino.nombre}: {e}")
                page.snack_bar = ft.SnackBar(ft.Text(f"❌ Error: No se pudo actualizar la alimentación fresca de {molino.nombre}"), open=True, duration=2000)
                page.update()
                return
            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            try:
                pddl_content = generar_problema_pddl_dinamico(
                    session_state['estado_molinos'],
                    session_state['estado_rutas'],
                    tolvas_criticas,
                    tiempos_por_tolva
                )
                refresh_cards(pddl_content, sistema, page)
                page.snack_bar = ft.SnackBar(ft.Text(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h"), open=True, duration=2000)
            except ValueError as e:
                page.snack_bar = ft.SnackBar(ft.Text(f"❌ Error al generar PDDL: {e}"), open=True, duration=2000)
                session_state['pddl_display'].controls[0].value = f"Error: {e}"
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
    session_state = page.session_state
    try:
        tipo_producto = TipoProducto(value)
        molino.cambiar_producto(tipo_producto)
        print(f"Producto de {molino.nombre} cambiado a {value}")
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        try:
            pddl_content = generar_problema_pddl_dinamico(
                session_state['estado_molinos'],
                session_state['estado_rutas'],
                tolvas_criticas,
                tiempos_por_tolva
            )
            refresh_cards(pddl_content, sistema, page)
        except ValueError as e:
            page.snack_bar = ft.SnackBar(ft.Text(f"❌ Error al generar PDDL: {e}"), open=True, duration=2000)
            session_state['pddl_display'].controls[0].value = f"Error: {e}"
        page.update()
    except ValueError:
        print(f"Tipo de producto inválido: {value}")
        page.snack_bar = ft.SnackBar(ft.Text(f"Tipo de producto inválido: {value}"), open=True, duration=2000)
        page.update()

def update_running_state(molino: Molino, value: str, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
    estado = value == "Encendido"
    molino.set_estado(estado)
    session_state['estado_molinos'][molino.nombre.lower()] = estado
    print(f"Estado de {molino.nombre} cambiado a {'Encendido' if estado else 'Apagado'}")
    
    dropdown_key = f"{molino.nombre}_status"
    if dropdown_key in session_state['status_dropdowns']:
        session_state['status_dropdowns'][dropdown_key].value = value
        session_state['status_dropdowns'][dropdown_key].color = ft.Colors.GREEN if estado else ft.Colors.RED
    
    tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
    try:
        pddl_content = generar_problema_pddl_dinamico(
            session_state['estado_molinos'],
            session_state['estado_rutas'],
            tolvas_criticas,
            tiempos_por_tolva
        )
        update_pddl_display(pddl_content, page)
    except ValueError as e:
        session_state['pddl_display'].controls[0].value = f"Error: {e}"
        page.snack_bar = ft.SnackBar(ft.Text(f"❌ Error al generar PDDL: {e}"), open=True, duration=2000)
    page.update()

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
# Flet UI
# ---------------------------------------------

def update_pddl_display(pddl_content, page):
    session_state = page.session_state
    session_state['pddl_display'].controls[0].value = pddl_content
    page.update()

def crear_fila_ruta(nombre, estado, sistema, page):
    session_state = page.session_state
    def on_click(e):
        session_state['estado_rutas'][nombre] = not session_state['estado_rutas'][nombre]
        print(f"Ruta '{nombre}' actualizada a {session_state['estado_rutas'][nombre]}")
        session_state['menu_column'].controls = construir_column_rutas(sistema, page)
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        try:
            pddl_content = generar_problema_pddl_dinamico(
                session_state['estado_molinos'],
                session_state['estado_rutas'],
                tolvas_criticas,
                tiempos_por_tolva
            )
            update_pddl_display(pddl_content, page)
        except ValueError as e:
            session_state['pddl_display'].controls[0].value = f"Error: {e}"
            page.snack_bar = ft.SnackBar(ft.Text(f"❌ Error al generar PDDL: {e}"), open=True, duration=2000)
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
    try:
        print(f"Starting refresh_cards for session {page.session_id}")
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
                    horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                    spacing=0,
                    expand=True,
                    ),
                    padding=7,
                    height=card_height,
                    
                ),
                elevation=0,
            )
            cards.append(card)

        pddl_card = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text(
                        "Plan Generado",
                        size=get_font_size() * 1.2,
                        weight=ft.FontWeight.BOLD,
                        color=ft.Colors.BLACK,
                        text_align=ft.TextAlign.CENTER
                    ),
                    session_state['pddl_display']
                ],
                horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=10,
                width=min(page.window_width * 0.9, 1000),
                height=min(page.window_height * 0.4, 300),
                bgcolor=ft.Colors.WHITE,
                border_radius=10
            ),
            elevation=0
        )

        print(f"Cards created: {len(cards)}")
        print(f"Page controls before adding: {len(page.controls)}")
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
        print(f"Page controls after adding: {len(page.controls)}")
        page.update()
    except Exception as e:
        print(f"❌ Error en refresh_cards: {e}")
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error al renderizar tarjetas: {e}"),
            open=True,
            duration=0
        )
        page.update()

# ---------------------------------------------
# PDDL Executor
# ---------------------------------------------

class PDDLExecutor:
    def __init__(self, domain_path, problem_path, workspace_path):
        self.domain_path = Path(str(domain_path).replace("\\", "/"))
        self.problem_path = Path(str(problem_path).replace("\\", "/"))
        self.workspace_path = Path(str(workspace_path).replace("\\", "/"))
        self.output_dir = self.workspace_path / "generated_plans"
        self.output_dir.mkdir(exist_ok=True)
        self.delays = {
            'open_vscode': 0,
            'command_palette': 5,
            'select_planner': 5,
            'plan_generation': 10,
            'monitor_interval': 0,
            'max_attempts': 10
        }

    def execute(self):
        print("🚀 Iniciando proceso de planificación PDDL")
        print(f"🔍 Usando servicio remoto: https://solver.planning.domains:5001/package/tfd/solve")
        try:
            if not self._open_vscode():
                return False
            if not self._run_tfd_planner():
                return False
            plan_path = self._capture_and_save_plan()
            if plan_path:
                print(f"✅ Plan generado exitosamente: {plan_path}")
                self._display_clean_plan(plan_path)
                return True
            else:
                print("❌ No se pudo generar el plan")
                return False
        except Exception as e:
            print(f"❌ Error crítico: {e}")
            return False

    def _open_vscode(self):
        try:
            print("📂 Verificando archivos PDDL...")
            print(f"📄 Dominio: {self.domain_path}")
            print(f"📄 Problema: {self.problem_path}")
            if not self.domain_path.exists():
                print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
                return False
            if not self.problem_path.exists():
                print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
                return False
            time.sleep(self.delays['open_vscode'])
            return True
        except Exception as e:
            print(f"❌ Error al verificar archivos: {e}")
            return False

    def _run_tfd_planner(self):
        try:
            print("⚙️ Iniciando planificador TFD remoto...")
            with open(self.domain_path, 'r', encoding='utf-8') as f:
                domain_content = f.read()
            with open(self.problem_path, 'r', encoding='utf-8') as f:
                problem_content = f.read()
            url = "https://solver.planning.domains:5001/package/tfd/solve"
            payload = {"domain": domain_content, "problem": problem_content}
            print(f"📤 Enviando solicitud al servicio: {url}")
            response = requests.post(url, json=payload, timeout=self.delays['plan_generation'])
            print(f"📥 Respuesta cruda inicial: {response.text}")
            if response.status_code != 200:
                print(f"❌ Error en la solicitud al servicio: {response.status_code} - {response.text}")
                return False
            try:
                initial_response = response.json()
                print(f"📥 Respuesta JSON inicial: {initial_response}")
            except json.JSONDecodeError:
                print(f"⚠️ No se pudo parsear la respuesta inicial como JSON: {response.text}")
                return False
            check_url = initial_response.get('result', '')
            if not check_url.startswith('/check/'):
                print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
                return False
            check_url = f"https://solver.planning.domains:5001{check_url}"
            print(f"🔄 Consultando URL de verificación: {check_url}")
            for attempt in range(self.delays['max_attempts']):
                response = requests.get(check_url, timeout=self.delays['plan_generation'])
                print(f"📥 Respuesta cruda (intento {attempt + 1}): {response.text}")
                if response.status_code != 200:
                    print(f"❌ Error en la solicitud de verificación: {response.status_code} - {response.text}")
                    return False
                try:
                    check_response = response.json()
                    print(f"📥 Respuesta JSON (intento {attempt + 1}): {check_response}")
                    if check_response.get('status') == 'ok' and 'output' in check_response.get('result', {}):
                        self._planner_response = check_response
                        return True
                except json.JSONDecodeError:
                    print(f"⚠️ No se pudo parsear la respuesta de verificación como JSON: {response.text}")
                time.sleep(self.delays['monitor_interval'])
            print(f"❌ No se obtuvo un plan después de {self.delays['max_attempts']} intentos")
            return False
        except requests.exceptions.RequestException as e:
            print(f"❌ Error al conectar con el servicio remoto: {e}")
            return False
        except Exception as e:
            print(f"❌ Error al ejecutar planificador: {e}")
            return False

    def _capture_and_save_plan(self):
        try:
            if not hasattr(self, '_planner_response'):
                print("❌ No se encontró respuesta del planificador")
                return None
            result = self._planner_response.get('result', {})
            plan_text = result.get('output', {}).get('plan', '') if isinstance(result.get('output'), dict) else ''
            if not plan_text or 'Found new plan' not in plan_text:
                print("❌ No se encontró un plan válido en la respuesta")
                print(f"Respuesta completa: {self._planner_response}")
                return None
            plan_content = self._extract_most_recent_plan(plan_text)
            if plan_content:
                return self._save_clean_plan(plan_content)
            return None
        except Exception as e:
            print(f"⚠️ Error al capturar plan: {e}")
            return None

    def _extract_most_recent_plan(self, log_content):
        rescheduled_match = re.search(
            r"Rescheduled Plan:(.*?)(?:Solution with|Search time:|$)",
            log_content,
            re.DOTALL | re.IGNORECASE
        )

        if rescheduled_match:
            print("✅ Se encontró un Rescheduled Plan, se prioriza sobre el Found new plan")
            block = rescheduled_match.group(1).strip()
            actions = "\n".join(line for line in block.splitlines() if re.match(r"^\d", line))
            after_block = log_content[rescheduled_match.end(): rescheduled_match.end() + 200]
            metric_match = re.search(r"(Rescheduled Makespan|Makespan)\s*:\s*([\d\.]+)", after_block)
            if metric_match:
                metric_name = metric_match.group(1)
                metric_value = metric_match.group(2)
                print(f"📊 {metric_name} del plan final = {metric_value}")
                actions = f"; {metric_name}: {metric_value}\n" + actions
            return self._clean_plan_text(actions)

        plan_match = re.search(
            r"Found new plan:(.*?)(?:Solution with|Search time:|$)",
            log_content,
            re.DOTALL | re.IGNORECASE
        )
        if plan_match:
            print("⚠️ No hay Rescheduled Plan, se devuelve el Found new plan")
            block = plan_match.group(1).strip()
            actions = "\n".join(line for line in block.splitlines() if re.match(r"^\d", line))
            after_block = log_content[plan_match.end(): plan_match.end() + 200]
            metric_match = re.search(r"(Makespan)\s*:\s*([\d\.]+)", after_block)
            if metric_match:
                metric_name = metric_match.group(1)
                metric_value = metric_match.group(2)
                print(f"📊 {metric_name} del plan final = {metric_value}")
                actions = f"; {metric_name}: {metric_value}\n" + actions
            return self._clean_plan_text(actions)

        print("❌ No se encontraron planes en el log")
        return None

    def _clean_plan_text(self, plan_text):
        cleaned_lines = []
        seen_actions = set()
        for line in plan_text.split('\n'):
            line = line.strip()
            if line and not any(s in line for s in ['Metric:', 'Makespan:', 'States evaluated:', 'Planner found', 'Rescheduled Plan:', 'Solution with original makespan', 'Plan length:', 'Search time:', 'Total time:']) and not line.startswith(';'):
                time_match = re.match(r'^(\d+\.\d{1,8}):\s*(.*?)\s*(\[\d+\.\d{1,8}\])?$', line)
                if time_match:
                    time_prefix = float(time_match.group(1))
                    action = time_match.group(2).strip()
                    duration = time_match.group(3) if time_match.group(3) else '[0.00000000]'
                    duration_value = float(duration[1:-1]) if duration != '[0.00000000]' else 0.0
                    if action not in seen_actions:
                        formatted_line = f"{time_prefix:.3f}: {action} [{duration_value:.3f}]"
                        cleaned_lines.append(formatted_line)
                        seen_actions.add(action)
        return '\n'.join(cleaned_lines)

    def _save_clean_plan(self, plan_content):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"plan_{timestamp}.pddl"
        filepath = self.output_dir / filename
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(f"; Plan generado automaticamente - {datetime.now()}\n")
                f.write(f"; Dominio: {self.domain_path.name}\n")
                f.write(f"; Problema: {self.problem_path.name}\n\n")
                f.write(plan_content)
            return filepath
        except Exception as e:
            print(f"⚠️ Error al guardar plan: {e}")
            return None

    def _display_clean_plan(self, plan_path):
        try:
            with open(plan_path, 'r') as f:
                print("\n" + "="*50)
                print("CONTENIDO DEL PLAN LIMPIO:")
                print("="*50)
                print(f.read())
                print("="*50 + "\n")
        except Exception as e:
            print(f"⚠️ Error al mostrar plan: {e}")

    def get_latest_plan_path(self):
        plan_files = list(self.output_dir.glob("plan_*.pddl"))
        if plan_files:
            return max(plan_files, key=os.path.getmtime)
        return None

def update_levels(e, sistema: SistemaAlimentacion, page: ft.Page):
    session_state = page.session_state
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
                except ValueError:
                    tolva.nivel_actual = tolva.nivel_actual
        feed_rate_key = f"{molino.nombre}_feed_rate"
        if feed_rate_key in session_state['feed_rate_fields'] and session_state['feed_rate_fields'][feed_rate_key].value:
            try:
                new_feed = float(session_state['feed_rate_fields'][feed_rate_key].value)
                if new_feed >= 0:
                    try:
                        molino.set_alimentacion_fresca(new_feed)
                        print(f"Alimentación fresca de {molino.nombre} actualizada a {new_feed} t/h")
                    except AttributeError as e:
                        print(f"❌ Error: No se encontró el método set_alimentacion_fresca en {molino.nombre}: {e}")
                        page.snack_bar = ft.SnackBar(
                            Text(f"❌ Error: No se pudo actualizar la alimentación fresca de {molino.nombre}"),
                            open=True,
                            duration=5000
                        )
                        page.update()
                        return
                else:
                    print(f"Valor inválido para alimentación fresca de {molino.nombre}: {new_feed}")
            except ValueError:
                print(f"Valor inválido para alimentación fresca de {molino.nombre}: {session_state['feed_rate_fields'][feed_rate_key].value}")
    
    try:
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(
            session_state['estado_molinos'],
            session_state['estado_rutas'],
            tolvas_criticas,
            tiempos_por_tolva,
            path_output=f"PDDL/cement_problem_{page.session_id}.pddl"
        )
        refresh_cards(pddl_content, sistema, page)
    except ValueError as e:
        print(f"❌ Error al generar problema PDDL: {e}")
        session_state['pddl_display'].controls[0].value = f"Error: {e}"
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error al generar problema PDDL: {e}"),
            open=True,
            duration=0
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
        session_state['pddl_display'].controls[0].value = f"Error: {e}"
        page.snack_bar = ft.SnackBar(Text(f"❌ Error al guardar el problema PDDL: {e}"), open=True, duration=5000)
        page.update()
        return
    
    try:
        executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
        success = executor.execute()
        
        if success:
            plan_path = executor.get_latest_plan_path()
            if plan_path:
                with open(plan_path, 'r', encoding='utf-8') as f:
                    plan_content = f.read()
                clean_plan = '\n'.join(
                    line for line in plan_content.split('\n')
                    if line.strip() and not line.startswith(';') and not any(s in line for s in ['Plan length:', 'Makespan:', 'Search time:', 'Total time:'])
                )
                print(f"📜 Contenido para pddl_display:\n{clean_plan}")
                session_state['pddl_display'].controls[0].value = clean_plan
                page.snack_bar = ft.SnackBar(
                    Text(f"✅ Plan generado con éxito:\n{clean_plan}"),
                    open=True,
                    duration=0
                )
            else:
                print("❌ No se encontraron planes generados")
                session_state['pddl_display'].controls[0].value = "Error: No se encontraron planes"
                page.snack_bar = ft.SnackBar(
                    Text("❌ No se encontraron planes generados"),
                    open=True,
                    duration=0
                )
    except Exception as e:
        print(f"❌ Error inicial: {e}")
        session_state['pddl_display'].controls[0].value = f"Error: {e}"
        page.snack_bar = ft.SnackBar(
            Text(f"❌ Error inicial: {e}"),
            open=True,
            duration=0
        )
    
    refresh_cards(sistema=sistema, page=page)
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
        print("❌ Error: logo.png no encontrado en assets")
        page.snack_bar = ft.SnackBar(
            Text("❌ Error: logo.png no encontrado en assets"),
            open=True,
            duration=0
        )

    # Inicializar estado por sesión
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
            duration=0
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