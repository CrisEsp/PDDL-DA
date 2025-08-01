# import flet as ft
# import enum
# from typing import List, Dict, Tuple
# import os

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
#     def __init__(self, material: str, capacidad: float, altura_max: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         toneladas_reales = (self.nivel_actual * self.capacidad) / self.altura_max
#         return toneladas_reales / consumo_por_hora if consumo_por_hora > 0 else float('inf')

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14),
#             "puzolana": Tolva("Puzolana", 300, 12),
#             "yeso": Tolva("Yeso", 300, 10)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12),
#             "yeso": Tolva("Yeso", 120, 9)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100),
#             "puzolana": Tolva("Puzolana", 35, 100),
#             "yeso": Tolva("Yeso", 30, 100)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "yeso": 3})
#         self.mc3.set_producto(TipoProducto.P30, 33.5, {"clinker": 63.1, "puzolana": 34.4, "yeso": 2.5})

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

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=2) -> Tuple[List[str], Dict[str, float]]:
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
#                 tiempos_por_tolva[nombre_tolva_pddl] = tiempo
#                 if tiempo < umbral:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
    
#     return tolvas_a_llenar, tiempos_por_tolva

# estado_rutas = {
#     "MC1-desde-Pretrit": True,
#     "MC2-desde-Pretrit": True,
#     "MC3-desde_Silo-Blanco": True,
#     "Pretrit_a_Silo_Blanco": True,
#     "PH-a-426HO04-por-MC2": True,
#     "PH-a-MC1-por-MC2": True,
#     "PH-a-MC1-por-MC1": True,
#     "PS-a-MC3-por-MC2": True,
#     "PS-a-426HO02-por-426HO04": True,
#     "MC1-por-MC1": True,
#     "MC1-por-MC2": True,
#     "MC2-por-MC2": True,
#     "MC3-por-MC1": True,
#     "MC3-por-MC2": True
# }

# def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl"):
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1"],
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

#     pddl_content = """(define (problem cement-production-problem)
#   (:domain cement-alimentacion)

#   (:objects
#     mc1 mc2 mc3 - molino
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva
#     clinker puzolana-h yeso puzolana-s - materia
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
#   )

#   (:init
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidad
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     (en-marcha mc1)
#     (en-marcha mc2)
#     (en-marcha mc3)
                
#     ;; Costos de prioridad basados en tiempos de vaciado
#     (= (costo-prioridad t1-clinker) 166.67)
#     (= (costo-prioridad t1-puzolana-h) 476.19)
#     (= (costo-prioridad t1-yeso) 270.27)
#     (= (costo-prioridad t2-clinker) 47619.19)
#     (= (costo-prioridad t2-puzolana-h) 142.86)
#     (= (costo-prioridad t2-puzolana-s) 400.00)
#     (= (costo-prioridad t2-yeso) 270.27)
#     (= (costo-prioridad t3-clinker) 163.93)
#     (= (costo-prioridad t3-puzolana-s) 400.00)
#     (= (costo-prioridad t3-yeso) 270.27)

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
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)
                
#     ;; Rutas disponibles
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

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "unknown")
#         if estado_rutas.get(ruta, False):
#             if i == 0:
#                 pddl_content += "    ;; Clinker\n"
#             elif i == 4:
#                 pddl_content += "    ;; Puzolana\n"
#             elif i == 9:
#                 pddl_content += "    ;; Yeso\n"
#             pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"

#     pddl_content += "    ;; Tiempos de vaciado\n"
#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"

#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         material = tolva_a_material.get(tolva, "unknown")
#         pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"

#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return f"Archivo generado en: {os.path.abspath(path_output)}"

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def main(page: ft.Page):

#    #page.theme_mode = ft.Colors.BLUE_GREY_900    #ft.ThemeMode.LIGHT
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK  # Cambiado a modo oscuro
#     page.bgcolor = ft.Colors.BLUE_GREY_900  # Fondo cambiado a azul gris oscuro
#     # page.theme = ft.Theme(
#     # color_scheme=ft.ColorScheme(
#     #     primary=ft.Colors.BLUE_ACCENT_700,
#     #     secondary=ft.Colors.GREEN_ACCENT_700,
#     #     background=ft.Colors.BLUE_GREY_900,
#     #     surface=ft.Colors.GREY_900,
#     #     on_background=ft.Colors.WHITE,
#     #     on_surface=ft.Colors.WHITE,
#     # ),
#     # text_theme=ft.TextTheme(
#     #     body_large=ft.TextStyle(color=ft.Colors.WHITE, font_family="Roboto"),
#     #     body_medium=ft.TextStyle(color=ft.Colors.WHITE70, font_family="Roboto"),
#     #     title_large=ft.TextStyle(color=ft.Colors.WHITE, font_family="Roboto", size=24, weight=ft.FontWeight.BOLD),
#     # ),
#     # )

#     page.padding = 20
#     page.window_width = 1200
#     page.window_height = 600

#     sistema = SistemaAlimentacion()
#     sistema.set_productos()

#     # Configurar niveles iniciales
#     sistema.mc1.tolvas["clinker"].nivel_actual = 5
#     sistema.mc1.tolvas["puzolana"].nivel_actual = 4
#     sistema.mc1.tolvas["yeso"].nivel_actual = 6
#     sistema.mc2.tolvas["clinker"].nivel_actual = 1
#     sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4
#     sistema.mc2.tolvas["yeso"].nivel_actual = 6
#     sistema.mc3.tolvas["clinker"].nivel_actual = 7
#     sistema.mc3.tolvas["puzolana"].nivel_actual = 8
#     sistema.mc3.tolvas["yeso"].nivel_actual = 1

#     tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)

#     def generate_pddl(e):
#         try:
#             result = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
#             page.add(ft.Text(result, color=ft.Colors.GREEN))
#             page.update()
#         except ValueError as ve:
#             page.add(ft.Text(f"Error al generar PDDL: {str(ve)}", color=ft.Colors.RED))
#             page.update()
#         except Exception as ex:
#             page.add(ft.Text(f"Error inesperado al generar PDDL: {str(ex)}", color=ft.Colors.RED))
#             page.update()

#     # Crear tarjetas para cada molino
#     cards = []
#     for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#         rows = []
#         for material, tolva in molino.tolvas.items():
#             unit = "%" if molino.nombre == "MC3" else "m"
#             max_level = tolva.altura_max
#             current_level = tolva.nivel_actual
#             progress = min(current_level / max_level, 1.0) if max_level > 0 else 0
#             tiempo = molino.tiempo_vaciado(material)
#             rows.append(
#                 ft.DataRow(cells=[
#                     ft.DataCell(ft.Text(material.capitalize(), size=14)),
#                     ft.DataCell(ft.Text(f"{current_level:.2f} {unit}", size=14)),
#                     #ft.DataCell(ft.Text(f"{max_level} {unit}", size=10)),
#                     ft.DataCell(ft.ProgressBar(value=progress, width=60, height=8)),
#                     ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
#                 ])
#             )
#         card = ft.Card(
#             content=ft.Container(
#                 content=ft.Column([
#                     ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
#                     ft.DataTable(
#                         columns=[
#                             ft.DataColumn(ft.Text("Material", size=14)),
#                             ft.DataColumn(ft.Text("Nivel Actual", size=14)),
#                             #ft.DataColumn(ft.Text("Nivel Máximo", size=13)),
#                             ft.DataColumn(ft.Text("Estado Tolva", size=14)),
#                             ft.DataColumn(ft.Text("Tiempo Vaciado", size=14)),
#                         ],
#                         rows=rows,
#                         column_spacing=35,
#                         data_row_min_height=25
#                     )
#                 ]),
#                 padding=8,
#                 width=480,
#                 height=300
#             ),
#             elevation=5
#         )
#         cards.append(card)


#     menu_rutas = ft.Dropdown(
#         width=200,
#         icon=ft.Icons.MENU,
#         options=[
#             ft.dropdown.Option("Opción 1"),
#             ft.dropdown.Option("Opción 2"),
#         ],
#         label="Rutas",
#     )
#     page.add(
#         ft.Container(
#             content=ft.Row(
#                 [
#                     #pb,  # Comentado temporalmente, descomenta si defines pb
#                     #menu_rutas,
#                     ft.Text(
#                         "OPTIMIZACIÓN DE ALIMENTACIONES",
#                         size=40,
#                         weight=ft.FontWeight.BOLD,
#                         color="white"
#                     ),
#                     ft.Image(
#                         src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",
#                         width=90,
#                         height=90,
#                         fit=ft.ImageFit.CONTAIN
#                     ),
#                 ],
                
#                 alignment=ft.MainAxisAlignment.CENTER,
#                 vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                 spacing=1# Reduje el espaciado entre elementos
#             ),
#             padding=0,
#             margin=0,
#             expand=False  # Evita que el contenedor se expanda innecesariamente
#         ),
#         #ft.Text("OPTIMIZACIÓN DE ALIMENTACIONES", size=40, weight=ft.FontWeight.BOLD , text_align=ft.TextAlign.CENTER),
#         ft.Row(
#             controls=cards,
#             wrap=True,
#             spacing=15,
#             alignment=ft.MainAxisAlignment.CENTER
#         ),
#         ft.ElevatedButton("Generar Problema PDDL", on_click=generate_pddl, bgcolor=ft.Colors.BLUE_700, color=ft.Colors.WHITE),
#         ft.Text("Presione el botón para generar el archivo PDDL.", color=ft.Colors.GREY)
#     )

#     page.update()

# if __name__ == "__main__":
#     ft.app(target=main)

#####################################################


# import flet as ft
# import enum
# from typing import List, Dict, Tuple
# import os

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
#     def __init__(self, material: str, capacidad: float, altura_max: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         toneladas_reales = (self.nivel_actual * self.capacidad) / self.altura_max
#         return toneladas_reales / consumo_por_hora if consumo_por_hora > 0 else float('inf')

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14),
#             "puzolana": Tolva("Puzolana", 300, 12),
#             "yeso": Tolva("Yeso", 300, 10)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12),
#             "yeso": Tolva("Yeso", 120, 9)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100),
#             "puzolana": Tolva("Puzolana", 35, 100),
#             "yeso": Tolva("Yeso", 30, 100)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "yeso": 3})
#         self.mc3.set_producto(TipoProducto.P30, 33.5, {"clinker": 63.1, "puzolana": 34.4, "yeso": 2.5})

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

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=5) -> Tuple[List[str], Dict[str, float]]:
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
#                 tiempos_por_tolva[nombre_tolva_pddl] = tiempo
#                 if tiempo < umbral:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
    
#     return tolvas_a_llenar, tiempos_por_tolva

# estado_rutas = {
#     "MC1-desde-Pretrit": True,
#     "MC2-desde-Pretrit": True,
#     "MC3-desde_Silo-Blanco": True,
#     "Pretrit_a_Silo_Blanco": True,
#     "PH-a-426HO04-por-MC2": True,
#     "PH-a-MC1-por-MC2": True,
#     "PH-a-MC1-por-MC1": True,
#     "PS-a-MC3-por-MC2": True,
#     "PS-a-426HO02-por-426HO04": True,
#     "MC1-por-MC1": True,
#     "MC1-por-MC2": True,
#     "MC2-por-MC2": True,
#     "MC3-por-MC1": True,
#     "MC3-por-MC2": True
# }

# def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl"):
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1"],
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

#     pddl_content = """(define (problem cement-production-problem)
#   (:domain cement-alimentacion)

#   (:objects
#     mc1 mc2 mc3 - molino
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva
#     clinker puzolana-h yeso puzolana-s - materia
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
#   )

#   (:init
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidad
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     (en-marcha mc1)
#     (en-marcha mc2)
#     (en-marcha mc3)
                
#     ;; Costos de prioridad basados en tiempos de vaciado
#     (= (costo-prioridad t1-clinker) 166.67)
#     (= (costo-prioridad t1-puzolana-h) 476.19)
#     (= (costo-prioridad t1-yeso) 270.27)
#     (= (costo-prioridad t2-clinker) 47619.19)
#     (= (costo-prioridad t2-puzolana-h) 142.86)
#     (= (costo-prioridad t2-puzolana-s) 400.00)
#     (= (costo-prioridad t2-yeso) 270.27)
#     (= (costo-prioridad t3-clinker) 163.93)
#     (= (costo-prioridad t3-puzolana-s) 400.00)
#     (= (costo-prioridad t3-yeso) 270.27)

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
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)
                
#     ;; Rutas disponibles
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

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "unknown")
#         if estado_rutas.get(ruta, False):
#             if i == 0:
#                 pddl_content += "    ;; Clinker\n"
#             elif i == 4:
#                 pddl_content += "    ;; Puzolana\n"
#             elif i == 9:
#                 pddl_content += "    ;; Yeso\n"
#             pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"

#     pddl_content += "    ;; Tiempos de vaciado\n"
#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"

#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         material = tolva_a_material.get(tolva, "unknown")
#         pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"

#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return f"Archivo generado en: {os.path.abspath(path_output)}"

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def main(page: ft.Page):
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK
#     page.bgcolor = ft.Colors.BLUE_GREY_900
#     page.padding = 5
#     page.window_width = 1200
#     page.window_height = 600

#     sistema = SistemaAlimentacion()
#     sistema.set_productos()

#     # Configurar niveles iniciales
#     sistema.mc1.tolvas["clinker"].nivel_actual = 5
#     sistema.mc1.tolvas["puzolana"].nivel_actual = 4
#     sistema.mc1.tolvas["yeso"].nivel_actual = 6
#     sistema.mc2.tolvas["clinker"].nivel_actual = 1
#     sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4
#     sistema.mc2.tolvas["yeso"].nivel_actual = 6
#     sistema.mc3.tolvas["clinker"].nivel_actual = 7
#     sistema.mc3.tolvas["puzolana"].nivel_actual = 8
#     sistema.mc3.tolvas["yeso"].nivel_actual = 1

#     # Diccionario para almacenar los campos de texto
#     level_fields = {}

#     def update_levels(e):
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             for material, tolva in molino.tolvas.items():
#                 field_key = f"{molino.nombre}_{material}"
#                 if field_key in level_fields and level_fields[field_key].value:
#                     try:
#                         new_level = float(level_fields[field_key].value)
#                         tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))  # Limita entre 0 y altura_max
#                     except ValueError:
#                         tolva.nivel_actual = tolva.nivel_actual  # Mantiene el valor anterior si no es válido
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         result = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
#         refresh_cards(result)

#     def refresh_cards(result_text=None):
#         page.controls.clear()
#         cards = []
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)  # Recalcular tiempos
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             rows = []
#             for material, tolva in molino.tolvas.items():
#                 unit = "%" if molino.nombre == "MC3" else "m"
#                 max_level = tolva.altura_max
#                 current_level = tolva.nivel_actual
#                 progress = min(current_level / max_level, 1.0) if max_level > 0 else 0
#                 tiempo = molino.tiempo_vaciado(material)
#                 field_key = f"{molino.nombre}_{material}"
#                 level_fields[field_key] = ft.TextField(
#                     value=str(current_level),
#                     width=80,
#                     text_align=ft.TextAlign.CENTER,
#                     border_color=None,
#                     border=None,
#                     border_width=0,
#                     bgcolor=ft.colors.TRANSPARENT,
#                     filled=True,
#                     on_change=lambda e, k=field_key: level_fields[k].value
#                 )
#                 # Asignar color a la barra según el porcentaje
#                 bar_color = ft.colors.GREEN_700 if progress >= 0.5 else ft.colors.YELLOW_700 if progress >= 0.2 else ft.colors.RED_700
#                 rows.append(
#                     ft.DataRow(cells=[
#                         ft.DataCell(ft.Text(material.capitalize(), size=14)),
#                         ft.DataCell(level_fields[field_key]),
#                         ft.DataCell(ft.ProgressBar(value=progress, width=80, height=20, color=bar_color, border_radius=5)),
#                         ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
#                     ])
#                 )
#             card = ft.Card(
#                 content=ft.Container(
#                     content=ft.Column([
#                         ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
#                         ft.DataTable(
#                             columns=[
#                                 ft.DataColumn(ft.Text("Material", size=14)),
#                                 ft.DataColumn(ft.Text("Nivel Actual", size=14)),
#                                 ft.DataColumn(ft.Text("Estado Tolva", size=14)),
#                                 ft.DataColumn(ft.Text("Tiempo Vaciado", size=14)),
#                             ],
#                             rows=rows,
#                             column_spacing=35,
#                             data_row_min_height=25
#                         )
#                     ]),
#                     padding=8,
#                     width=495,
#                     height=300
#                 ),
#                 elevation=5
#             )
#             cards.append(card)

#         page.add(
#             ft.Container(
#                 content=ft.Row(
#                     [
#                         ft.Text(
#                             "OPTIMIZACIÓN DE ALIMENTACIONES",
#                             size=50,
#                             weight=ft.FontWeight.BOLD,
#                             color="white"
#                         ),
#                         ft.Image(
#                             src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",
#                             width=100,
#                             height=100,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                     ],
#                     alignment=ft.MainAxisAlignment.CENTER,
#                     vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                     spacing=1
#                 ),
#                 padding=0,
#                 margin=0,
#                 expand=False
#             ),
#             ft.Row(
#                 controls=cards,
#                 wrap=True,
#                 spacing=5,
#                 alignment=ft.MainAxisAlignment.CENTER
#             ),
#             ft.ElevatedButton("Generar Problema PDDL", on_click=update_levels, bgcolor=ft.Colors.BLUE_700, color=ft.Colors.WHITE),
#             ft.Text(result_text if result_text else "Estado: Ingrese los niveles y presione el botón para generar el archivo PDDL y actualizar.", color=ft.Colors.GREY)
#         )
#         page.update()

#     # Inicializar la interfaz
#     refresh_cards()

# if __name__ == "__main__":
#     ft.app(target=main)



##################### bir
# import flet as ft
# import enum
# from typing import List, Dict, Tuple
# import os

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
#     def __init__(self, material: str, capacidad: float, altura_max: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         toneladas_reales = (self.nivel_actual * self.capacidad) / self.altura_max
#         return toneladas_reales / consumo_por_hora if consumo_por_hora > 0 else float('inf')

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14),
#             "puzolana": Tolva("Puzolana", 300, 12),
#             "yeso": Tolva("Yeso", 300, 10)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12),
#             "yeso": Tolva("Yeso", 120, 9)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100),
#             "puzolana": Tolva("Puzolana", 35, 100),
#             "yeso": Tolva("Yeso", 30, 100)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "yeso": 3})
#         self.mc3.set_producto(TipoProducto.P30, 33.5, {"clinker": 63.1, "puzolana": 34.4, "yeso": 2.5})

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

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=5) -> Tuple[List[str], Dict[str, float]]:
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
#                 tiempos_por_tolva[nombre_tolva_pddl] = tiempo
#                 if tiempo < umbral:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
    
#     return tolvas_a_llenar, tiempos_por_tolva

# estado_rutas = {
#     "MC1-desde-Pretrit": True,
#     "MC2-desde-Pretrit": True,
#     "MC3-desde_Silo-Blanco": True,
#     "Pretrit_a_Silo_Blanco": True,
#     "PH-a-426HO04-por-MC2": True,
#     "PH-a-MC1-por-MC2": True,
#     "PH-a-MC1-por-MC1": True,
#     "PS-a-MC3-por-MC2": True,
#     "PS-a-426HO02-por-426HO04": True,
#     "MC1-por-MC1": True,
#     "MC1-por-MC2": True,
#     "MC2-por-MC2": True,
#     "MC3-por-MC1": True,
#     "MC3-por-MC2": True
# }

# def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1"],
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

#     pddl_content = """(define (problem cement-production-problem)
#   (:domain cement-alimentacion)

#   (:objects
#     mc1 mc2 mc3 - molino
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva
#     clinker puzolana-h yeso puzolana-s - materia
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
#   )

#   (:init
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidad
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     (en-marcha mc1)
#     (en-marcha mc2)
#     (en-marcha mc3)
                
#     ;; Costos de prioridad basados en tiempos de vaciado
#     (= (costo-prioridad t1-clinker) 166.67)
#     (= (costo-prioridad t1-puzolana-h) 476.19)
#     (= (costo-prioridad t1-yeso) 270.27)
#     (= (costo-prioridad t2-clinker) 47619.19)
#     (= (costo-prioridad t2-puzolana-h) 142.86)
#     (= (costo-prioridad t2-puzolana-s) 400.00)
#     (= (costo-prioridad t2-yeso) 270.27)
#     (= (costo-prioridad t3-clinker) 163.93)
#     (= (costo-prioridad t3-puzolana-s) 400.00)
#     (= (costo-prioridad t3-yeso) 270.27)

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
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)
                
#     ;; Rutas disponibles
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

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "unknown")
#         if estado_rutas.get(ruta, False):
#             if i == 0:
#                 pddl_content += "    ;; Clinker\n"
#             elif i == 4:
#                 pddl_content += "    ;; Puzolana\n"
#             elif i == 9:
#                 pddl_content += "    ;; Yeso\n"
#             pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"

#     pddl_content += "    ;; Tiempos de vaciado\n"
#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"

#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         material = tolva_a_material.get(tolva, "unknown")
#         pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"

#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return pddl_content  # Devuelve el contenido completo del PDDL

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def main(page: ft.Page):
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK
#     page.bgcolor = ft.Colors.BLUE_GREY_900
#     page.padding = 5
#     page.window_width = 1200
#     page.window_height = 600

#     sistema = SistemaAlimentacion()
#     sistema.set_productos()

#     # Configurar niveles iniciales
#     sistema.mc1.tolvas["clinker"].nivel_actual = 5
#     sistema.mc1.tolvas["puzolana"].nivel_actual = 4
#     sistema.mc1.tolvas["yeso"].nivel_actual = 6
#     sistema.mc2.tolvas["clinker"].nivel_actual = 1
#     sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4
#     sistema.mc2.tolvas["yeso"].nivel_actual = 6
#     sistema.mc3.tolvas["clinker"].nivel_actual = 70  # Inicial como porcentaje
#     sistema.mc3.tolvas["puzolana"].nivel_actual = 80  # Inicial como porcentaje
#     sistema.mc3.tolvas["yeso"].nivel_actual = 10     # Inicial como porcentaje

#     # Diccionario para almacenar los campos de texto
#     level_fields = {}

#     def update_levels(e):
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             for material, tolva in molino.tolvas.items():
#                 field_key = f"{molino.nombre}_{material}"
#                 if field_key in level_fields and level_fields[field_key].value:
#                     try:
#                         new_level = float(level_fields[field_key].value)
#                         if molino.nombre == "MC3":
#                             tolva.nivel_actual = max(0, min(new_level, 100))  # Límite como porcentaje (0-100)
#                         else:
#                             tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))  # Límite como nivel absoluto
#                     except ValueError:
#                         tolva.nivel_actual = tolva.nivel_actual  # Mantiene el valor anterior si no es válido
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
#         refresh_cards(pddl_content)

#     def refresh_cards(pddl_content=None):
#         page.controls.clear()
#         cards = []
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)  # Recalcular tiempos
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             rows = []
#             for material, tolva in molino.tolvas.items():
#                 unit = "%" if molino.nombre == "MC3" else "m"
#                 max_level = tolva.altura_max
#                 current_level = tolva.nivel_actual
#                 progress = min(current_level / max_level, 1.0) if molino.nombre != "MC3" else min(current_level / 100, 1.0)
#                 tiempo = molino.tiempo_vaciado(material)
#                 field_key = f"{molino.nombre}_{material}"
#                 level_fields[field_key] = ft.TextField(
#                     value=str(current_level),
#                     width=80,
#                     text_align=ft.TextAlign.CENTER,
#                     border_color=None,
#                     border=None,
#                     border_width=0,
#                     bgcolor=ft.colors.TRANSPARENT,
#                     filled=True,
#                     on_change=update_levels
#                 )
#                 bar_color = ft.colors.GREEN_700 if progress >= 0.5 else ft.colors.YELLOW_700 if progress >= 0.2 else ft.colors.RED_700
#                 rows.append(
#                     ft.DataRow(cells=[
#                         ft.DataCell(ft.Text(material.capitalize(), size=14)),
#                         ft.DataCell(level_fields[field_key]),
#                         ft.DataCell(ft.ProgressBar(value=progress, width=80, height=20, color=bar_color, border_radius=5)),
#                         ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
#                     ])
#                 )
#             card = ft.Card(
#                 content=ft.Container(
#                     content=ft.Column([
#                         ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
#                         ft.DataTable(
#                             columns=[
#                                 ft.DataColumn(ft.Text("Material", size=14)),
#                                 ft.DataColumn(ft.Text("Nivel Actual", size=14)),
#                                 ft.DataColumn(ft.Text("Estado Tolva", size=14)),
#                                 ft.DataColumn(ft.Text("Tiempo Vaciado", size=14)),
#                             ],
#                             rows=rows,
#                             column_spacing=35,
#                             data_row_min_height=25
#                         )
#                     ]),
#                     padding=8,
#                     width=495,
#                     height=300
#                 ),
#                 elevation=5
#             )
#             cards.append(card)

#         # Recuadro para mostrar el problema PDDL completo
#         pddl_card = ft.Card(
#             content=ft.Container(
#                 content=ft.Column([
#                     ft.Text("Problema PDDL Generado", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.WHITE),
#                     ft.ListView(
#                         controls=[ft.Text(pddl_content if pddl_content else "Presione 'Generar Problema PDDL' para ver el contenido.", color=ft.colors.WHITE70, expand=True, no_wrap=False)],
#                         expand=True,
#                         height=200,
#                         on_scroll=ft.ScrollMode.AUTO
#                     )
#                 ]),
#                 padding=10,
#                 width=1150,
#                 bgcolor=ft.colors.GREY_800
#             ),
#             elevation=5
#         )

#         page.add(
#             ft.Container(
#                 content=ft.Row(
#                     [
#                         ft.Text(
#                             "OPTIMIZACIÓN DE ALIMENTACIONES",
#                             size=50,
#                             weight=ft.FontWeight.BOLD,
#                             color="white"
#                         ),
#                         ft.Image(
#                             src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",
#                             width=100,
#                             height=100,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                     ],
#                     alignment=ft.MainAxisAlignment.CENTER,
#                     vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                     spacing=1
#                 ),
#                 padding=0,
#                 margin=0,
#                 expand=False
#             ),
#             ft.Row(
#                 controls=cards,
#                 wrap=True,
#                 spacing=5,
#                 alignment=ft.MainAxisAlignment.CENTER
#             ),
#             ft.ElevatedButton("Generar Problema PDDL", on_click=update_levels, bgcolor=ft.Colors.BLUE_700, color=ft.Colors.WHITE),
#             pddl_card
#         )
#         page.update()

#     # Inicializar la interfaz
#     refresh_cards()

# if __name__ == "__main__":
#     ft.app(target=main)











# import flet as ft
# import enum
# from typing import List, Dict, Tuple
# import os

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
#     def __init__(self, material: str, capacidad: float, altura_max: float):
#         self.material = material
#         self.capacidad = capacidad
#         self.altura_max = altura_max
#         self.nivel_actual = 0

#     def tiempo_vaciado(self, consumo_por_hora: float) -> float:
#         toneladas_reales = (self.nivel_actual * self.capacidad) / self.altura_max
#         return toneladas_reales / consumo_por_hora if consumo_por_hora > 0 else float('inf')

# class Molino:
#     def __init__(self, nombre: str, tolvas: Dict[str, Tolva], rendimiento: float):
#         self.nombre = nombre
#         self.tolvas = tolvas
#         self.rendimiento = rendimiento
#         self.tipo_producto = None
#         self.alimentacion_fresca = 0
#         self.ratios = {}

#     def set_producto(self, tipo_producto: TipoProducto, alimentacion_fresca: float, ratios: Dict[str, float]):
#         self.tipo_producto = tipo_producto
#         self.alimentacion_fresca = alimentacion_fresca
#         self.ratios = ratios

#     def tiempo_vaciado(self, material: str) -> float:
#         if material not in self.ratios or material not in self.tolvas:
#             return float('inf')
#         consumo = (self.alimentacion_fresca * self.ratios[material]) / 100
#         return self.tolvas[material].tiempo_vaciado(consumo)

# # ---------------------------------------------
# # Sistema de alimentación
# # ---------------------------------------------

# class SistemaAlimentacion:
#     def __init__(self):
#         self.mc1 = Molino("MC1", {
#             "clinker": Tolva("Clinker", 500, 14),
#             "puzolana": Tolva("Puzolana", 300, 12),
#             "yeso": Tolva("Yeso", 300, 10)
#         }, 1)

#         self.mc2 = Molino("MC2", {
#             "clinker": Tolva("Clinker", 300, 9),
#             "puzolana_humeda": Tolva("Puzolana Húmeda", 500, 15),
#             "puzolana_seca": Tolva("Puzolana Seca", 100, 12),
#             "yeso": Tolva("Yeso", 120, 9)
#         }, 0.8)

#         self.mc3 = Molino("MC3", {
#             "clinker": Tolva("Clinker", 60, 100),
#             "puzolana": Tolva("Puzolana", 35, 100),
#             "yeso": Tolva("Yeso", 30, 100)
#         }, 0.5)

#     def set_productos(self):
#         self.mc1.set_producto(TipoProducto.P30, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
#         self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "puzolana_seca": 10, "yeso": 3})
#         self.mc3.set_producto(TipoProducto.P30, 33.5, {"clinker": 63.1, "puzolana": 34.4, "yeso": 2.5})

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

# def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=5) -> Tuple[List[str], Dict[str, float]]:
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
#                 tiempos_por_tolva[nombre_tolva_pddl] = tiempo
#                 if tiempo < umbral:
#                     tolvas_a_llenar.append(nombre_tolva_pddl)
    
#     return tolvas_a_llenar, tiempos_por_tolva

# estado_rutas = {
#     "MC1-desde-Pretrit": True,
#     "MC2-desde-Pretrit": True,
#     "MC3-desde_Silo-Blanco": True,
#     "Pretrit_a_Silo_Blanco": True,
#     "PH-a-426HO04-por-MC2": True,
#     "PH-a-MC1-por-MC2": True,
#     "PH-a-MC1-por-MC1": True,
#     "PS-a-MC3-por-MC2": True,
#     "PS-a-426HO02-por-426HO04": True,
#     "MC1-por-MC1": True,
#     "MC1-por-MC2": True,
#     "MC2-por-MC2": True,
#     "MC3-por-MC1": True,
#     "MC3-por-MC2": True
# }

# def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
#     tolva_a_rutas = {
#         "t1-clinker": ["MC1-desde-Pretrit"],
#         "t2-clinker": ["MC2-desde-Pretrit"],
#         "t3-clinker": ["MC3-desde_Silo-Blanco", "Pretrit_a_Silo_Blanco"],
#         "t1-puzolana-h": ["PH-a-MC1-por-MC1", "PH-a-MC1-por-MC2"],
#         "t2-puzolana-h": ["PH-a-426HO04-por-MC2"],
#         "t2-puzolana-s": ["PS-a-426HO02-por-426HO04"],
#         "t3-puzolana-s": ["PS-a-MC3-por-MC2"],
#         "t1-yeso": ["MC1-por-MC1"],
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

#     pddl_content = """(define (problem cement-production-problem)
#   (:domain cement-alimentacion)

#   (:objects
#     mc1 mc2 mc3 - molino
#     t1-clinker t1-puzolana-h t1-yeso
#     t2-clinker t2-puzolana-h t2-puzolana-s t2-yeso
#     t3-clinker t3-puzolana-s t3-yeso - tolva
#     clinker puzolana-h yeso puzolana-s - materia
#     MC1-desde-Pretrit MC2-desde-Pretrit MC3-desde_Silo-Blanco Pretrit_a_Silo_Blanco 
#     PH-a-MC1-por-MC1 PH-a-MC1-por-MC2 PH-a-426HO04-por-MC2 PS-a-MC3-por-MC2 PS-a-426HO02-por-426HO04 - ruta
#     MC1-por-MC1 MC1-por-MC2 MC2-por-MC2 MC3-por-MC1 MC3-por-MC2 - ruta
#   )

#   (:init
#     (libre t1-clinker) (libre t1-puzolana-h) (libre t1-yeso)
#     (libre t2-clinker) (libre t2-puzolana-h) (libre t2-puzolana-s) (libre t2-yeso)
#     (libre t3-clinker) (libre t3-puzolana-s) (libre t3-yeso)

#     ;; Compatibilidad
#     (compatible clinker t1-clinker) (compatible puzolana-h t1-puzolana-h) (compatible yeso t1-yeso)
#     (compatible clinker t2-clinker) (compatible puzolana-h t2-puzolana-h)
#     (compatible puzolana-s t2-puzolana-s) (compatible yeso t2-yeso)
#     (compatible clinker t3-clinker) (compatible puzolana-s t3-puzolana-s) (compatible yeso t3-yeso)

#     (material-disponible clinker)
#     (material-disponible puzolana-h)
#     (material-disponible puzolana-s)
#     (material-disponible yeso)

#     (en-marcha mc1)
#     (en-marcha mc2)
#     (en-marcha mc3)
                
#     ;; Costos de prioridad basados en tiempos de vaciado
#     (= (costo-prioridad t1-clinker) 166.67)
#     (= (costo-prioridad t1-puzolana-h) 476.19)
#     (= (costo-prioridad t1-yeso) 270.27)
#     (= (costo-prioridad t2-clinker) 47619.19)
#     (= (costo-prioridad t2-puzolana-h) 142.86)
#     (= (costo-prioridad t2-puzolana-s) 400.00)
#     (= (costo-prioridad t2-yeso) 270.27)
#     (= (costo-prioridad t3-clinker) 163.93)
#     (= (costo-prioridad t3-puzolana-s) 400.00)
#     (= (costo-prioridad t3-yeso) 270.27)

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
#     (= (duracion-llenado t2-yeso MC2-por-MC2) 5)
#     (= (duracion-llenado t3-yeso MC3-por-MC1) 2)
#     (= (duracion-llenado t3-yeso MC3-por-MC2) 6)
                
#     ;; Rutas disponibles
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

#     for i, (molino, tolva, ruta) in enumerate(rutas):
#         material = tolva_a_material.get(tolva, "unknown")
#         if estado_rutas.get(ruta, False):
#             if i == 0:
#                 pddl_content += "    ;; Clinker\n"
#             elif i == 4:
#                 pddl_content += "    ;; Puzolana\n"
#             elif i == 9:
#                 pddl_content += "    ;; Yeso\n"
#             pddl_content += f"    (ruta-disponible {molino} {tolva} {material} {ruta})\n"

#     pddl_content += "    ;; Tiempos de vaciado\n"
#     for tolva in tolva_a_rutas:
#         tiempo = tiempos_por_tolva.get(tolva, float('inf'))
#         if tiempo != float('inf'):
#             pddl_content += f"    (= (tiempo-vaciado {tolva}) {tiempo:.2f})\n"

#     pddl_content += "  )\n\n  (:goal (and\n"
#     for tolva in tolvas_validas_ordenadas:
#         material = tolva_a_material.get(tolva, "unknown")
#         pddl_content += f"    (alimentado {tolva} {material})\n"
#     pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"

#     with open(path_output, "w") as f:
#         f.write(pddl_content)
#     return pddl_content  # Devuelve el contenido completo del PDDL

# # ---------------------------------------------
# # Flet UI
# # ---------------------------------------------

# def main(page: ft.Page):
#     page.title = "Sistema de Alimentación de Molinos de Cemento"
#     page.theme_mode = ft.ThemeMode.DARK
#     page.bgcolor = ft.Colors.BLUE_GREY_900
#     page.padding = 5
#     page.window_width = 1200
#     page.window_height = 600

#     sistema = SistemaAlimentacion()
#     sistema.set_productos()

#     # Configurar niveles iniciales
#     sistema.mc1.tolvas["clinker"].nivel_actual = 5.0
#     sistema.mc1.tolvas["puzolana"].nivel_actual = 4.0
#     sistema.mc1.tolvas["yeso"].nivel_actual = 6.0
#     sistema.mc2.tolvas["clinker"].nivel_actual = 1.5
#     sistema.mc2.tolvas["puzolana_humeda"].nivel_actual = 4.0
#     sistema.mc2.tolvas["puzolana_seca"].nivel_actual = 6.3
#     sistema.mc2.tolvas["yeso"].nivel_actual = 6.1
#     sistema.mc3.tolvas["clinker"].nivel_actual = 70.0  # Inicial como porcentaje
#     sistema.mc3.tolvas["puzolana"].nivel_actual = 80.0  # Inicial como porcentaje
#     sistema.mc3.tolvas["yeso"].nivel_actual = 30.5     # Inicial como porcentaje

#     # Diccionario para almacenar los campos de texto
#     level_fields = {}

#     def update_levels(e):
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             for material, tolva in molino.tolvas.items():
#                 field_key = f"{molino.nombre}_{material}"
#                 if field_key in level_fields and level_fields[field_key].value:
#                     try:
#                         new_level = float(level_fields[field_key].value)
#                         if molino.nombre == "MC3":
#                             tolva.nivel_actual = max(0, min(new_level, 100))  # Límite como porcentaje (0-100)
#                         else:
#                             tolva.nivel_actual = max(0, min(new_level, tolva.altura_max))  # Límite como nivel absoluto
#                     except ValueError:
#                         tolva.nivel_actual = tolva.nivel_actual  # Mantiene el valor anterior si no es válido
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
#         pddl_content = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
#         refresh_cards(pddl_content)
#         page.snack_bar = ft.SnackBar(ft.Text("Problema.pddl creado correctamente"), open=True, duration=2000)
#         page.snack_bar.open = True
#         page.update()

#     def refresh_cards(pddl_content=None):
#         page.controls.clear()
#         cards = []
#         tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)  # Recalcular tiempos
#         for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
#             rows = []
#             for material, tolva in molino.tolvas.items():
#                 unit = "%" if molino.nombre == "MC3" else "m"
#                 max_level = tolva.altura_max
#                 current_level = tolva.nivel_actual
#                 progress = min(current_level / max_level, 1.0) if molino.nombre != "MC3" else min(current_level / 100, 1.0)
#                 tiempo = molino.tiempo_vaciado(material)
#                 field_key = f"{molino.nombre}_{material}"
#                 level_fields[field_key] = ft.TextField(
#                     value=str(current_level),
#                     width=50,
#                     text_size=14,
#                     text_align=ft.TextAlign.CENTER,
#                     border_color=None,
#                     border=None,
#                     border_width=0,
#                     bgcolor=ft.colors.TRANSPARENT,
#                     filled=True,
#                     on_submit=update_levels



#                 )
#                 bar_color = ft.colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.colors.YELLOW_700 if progress >= 0.2 else ft.colors.RED_700
#                 rows.append(
#                     ft.DataRow(cells=[
#                         ft.DataCell(ft.Text(material.capitalize(), size=14)),
#                         #ft.DataCell(level_fields[field_key]),
#                         ft.DataCell(
#                             ft.Row(
#                                 [
#                                     level_fields[field_key],
#                                     ft.Text(unit, size=14, color=ft.colors.WHITE),
#                                 ],
#                                 alignment=ft.MainAxisAlignment.CENTER,
#                                 spacing=5
#                             )
#                         ),
#                         ft.DataCell(ft.ProgressBar(value=progress, width=100, height=20, color=bar_color, border_radius=5)),
#                         ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
#                     ])
#                 )
#             card = ft.Card(
#                 content=ft.Container(
#                     content=ft.Column([
#                         ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
#                         ft.DataTable(
#                             columns=[
#                                 ft.DataColumn(ft.Text("Material", size=14)),
#                                 ft.DataColumn(ft.Text("Nivel Actual", size=14)),
#                                 ft.DataColumn(ft.Text("Estado Tolva", size=14)),
#                                 ft.DataColumn(ft.Text("T. Vaciado", size=14)),
#                             ],
#                             rows=rows,
#                             column_spacing=35,
#                             data_row_min_height=25
#                         )
#                     ]),
#                     padding=8,
#                     width=495,
#                     height=300
#                 ),
#                 elevation=5
#             )
#             cards.append(card)

#         # # Recuadro para mostrar el problema PDDL completo
#         # pddl_card = ft.Card(
#         #     content=ft.Container(
#         #         content=ft.Column([
#         #             ft.Text("Problema PDDL Generado", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.BLACK),
#         #             ft.ListView(
#         #                 controls=[ft.Text(pddl_content if pddl_content else "Presione 'Generar Problema PDDL' para ver el contenido.", color=ft.colors.BLACK, size=14,expand=True, no_wrap=False)],
#         #                 expand=True,
#         #                 height=240,
#         #                 on_scroll=ft.ScrollMode.AUTO
#         #             )
#         #         ]),
#         #         padding=10,
#         #         width=1000,
#         #         bgcolor=ft.colors.GREY_400,
#         #         border_radius=10
#         #     ),
#         #     elevation=5
#         # )


#         pddl_card = ft.Container(
#             content=ft.Card(
#                 content=ft.Container(
#                     content=ft.Column([
#                         ft.Text(
#                             "Problema PDDL Generado",
#                             size=16,
#                             weight=ft.FontWeight.BOLD,
#                             color=ft.colors.BLACK,
#                             text_align=ft.TextAlign.CENTER
#                         ),
#                         ft.ListView(
#                             controls=[
#                                 ft.Text(
#                                     pddl_content if pddl_content else "Presione 'Generar Problema PDDL' para ver el contenido.",
#                                     color=ft.colors.BLACK,
#                                     size=14,
#                                     #text_align=ft.TextAlign.CENTER,
#                                     expand=True,
#                                     no_wrap=False
#                                 )
#                             ],
#                             expand=True,
#                             height=240,
#                             on_scroll=ft.ScrollMode.AUTO
#                         )
#                     ],
#                     horizontal_alignment=ft.CrossAxisAlignment.CENTER),
#                     padding=10,
#                     width=1000,  # Reducido de 1500 a 1200
#                     bgcolor=ft.colors.GREY_400,
#                     border_radius=10,
#                     #alignment=ft.alignment.center
#                 ),
#                 elevation=5
#             ),
#             alignment=ft.alignment.center  # Centra el Card en la pantalla
#         )

#         page.add(
#             ft.Container(
#                 content=ft.Row(
#                     [
#                         ft.Text(
#                             "OPTIMIZACIÓN DE ALIMENTACIONES",
#                             size=40,
#                             weight=ft.FontWeight.BOLD,
#                             color="white"
#                         ),
#                         ft.Image(
#                             src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",
#                             width=100,
#                             height=100,
#                             fit=ft.ImageFit.CONTAIN
#                         ),
#                     ],
#                     alignment=ft.MainAxisAlignment.CENTER,
#                     vertical_alignment=ft.CrossAxisAlignment.CENTER,
#                     spacing=1
#                 ),
#                 padding=0,
#                 margin=0,
#                 expand=False
#             ),
#             ft.Row(
#                 controls=cards,
#                 wrap=True,
#                 spacing=5,
#                 alignment=ft.MainAxisAlignment.CENTER
#             ),
#             ft.ElevatedButton("Generar Problema PDDL", on_click=update_levels, bgcolor=ft.Colors.BLUE_700, color=ft.Colors.WHITE),
#             pddl_card
#         )
#         page.update()

#     # Inicializar la interfaz
#     refresh_cards()

# if __name__ == "__main__":
#     ft.app(target=main)





import flet as ft
import enum
from typing import List, Dict, Tuple
import os

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
        self.mc1.set_producto(TipoProducto.P40, 75, {"clinker": 68.5, "puzolana": 30, "yeso": 1.5})
        self.mc2.set_producto(TipoProducto.P10, 65, {"clinker": 87, "puzolana_humeda": 10, "puzolana_seca": 10, "yeso": 3})
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

def obtener_tolvas_a_llenar_por_tiempos(sistema: SistemaAlimentacion, umbral=3) -> Tuple[List[str], Dict[str, float]]:   # Umbral de 3 horas
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

def generar_problema_pddl_dinamico(estado_rutas: Dict[str, bool], tolvas_criticas: List[str], tiempos_por_tolva: Dict[str, float], path_output: str = "cement_problem.pddl") -> str:
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

    for i, (molino, tolva, ruta) in enumerate(rutas):
        material = tolva_a_material.get(tolva, "unknown")
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
        material = tolva_a_material.get(tolva, "unknown")
        pddl_content += f"    (alimentado {tolva} {material})\n"
    pddl_content += "  ))\n  (:metric minimize (total-cost))\n)"

    with open(path_output, "w") as f:
        f.write(pddl_content)
    return pddl_content

# ---------------------------------------------
# Flet UI
# ---------------------------------------------

def main(page: ft.Page):
    page.title = "Sistema de Alimentación de Molinos de Cemento"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = ft.Colors.BLUE_GREY_900
    page.padding = 5
    page.window_width = 1200
    page.window_height = 600

    sistema = SistemaAlimentacion()
    sistema.set_productos()

    # Configurar niveles iniciales
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

    # Diccionario para almacenar los campos de texto
    level_fields = {}

    def crear_fila_ruta(nombre, estado):
        def on_click(e):
            estado_rutas[nombre] = not estado_rutas[nombre]
            print(f"Ruta '{nombre}' actualizada a {estado_rutas[nombre]}")
            menu_column.controls = construir_column_rutas()
            tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
            pddl_content = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
            refresh_cards(pddl_content)
            page.update()

        return ft.Container(
            content=ft.Text(f"{'✅' if estado else '❌'} {nombre}"),
            padding=5,
            on_click=on_click,
            width=245
        )

    def construir_column_rutas():
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
        controls.extend(crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[:4])
        controls.append(ft.Divider())
        controls.append(titulo("PUZOLANA"))
        controls.extend(crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[4:9])
        controls.append(ft.Divider())
        controls.append(titulo("YESO"))
        controls.extend(crear_fila_ruta(n, e) for n, e in list(estado_rutas.items())[9:])
        return controls

    menu_column = ft.Column(controls=construir_column_rutas())

    menu_rutas = ft.PopupMenuButton(
        icon=ft.Icons.MENU,
        items=[
            ft.PopupMenuItem(
                content=menu_column
            )
        ]
    )

    def update_levels(e):
        for molino in [sistema.mc1, sistema.mc2, sistema.mc3]:
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
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
        pddl_content = generar_problema_pddl_dinamico(estado_rutas, tolvas_criticas, tiempos_por_tolva)
        refresh_cards(pddl_content)
        page.snack_bar = ft.SnackBar(ft.Text("Problema.pddl creado correctamente"), open=True, duration=2000)
        page.snack_bar.open = True
        page.update()

    def refresh_cards(pddl_content=None):
        page.controls.clear()
        cards = []
        tolvas_criticas, tiempos_por_tolva = obtener_tolvas_a_llenar_por_tiempos(sistema)
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
                    bgcolor=ft.colors.TRANSPARENT,
                    filled=True,
                    on_submit=update_levels
                )
                bar_color = ft.colors.GREEN_ACCENT_700 if progress >= 0.5 else ft.colors.YELLOW_700 if progress >= 0.2 else ft.colors.RED_700
                rows.append(
                    ft.DataRow(cells=[
                        ft.DataCell(ft.Text(material.capitalize(), size=14)),
                        #ft.DataCell(level_fields[field_key]),
                        ft.DataCell(
                            ft.Row(
                                [
                                    level_fields[field_key],
                                    ft.Text(unit, size=14, color=ft.colors.WHITE),
                                ],
                                alignment=ft.MainAxisAlignment.CENTER,
                                spacing=5
                            )
                        ),
                        ft.DataCell(ft.ProgressBar(value=progress, width=100, height=20, color=bar_color, border_radius=5)),
                        ft.DataCell(ft.Text(f"{tiempo:.2f} h", size=14)),
                    ])
                )
            card = ft.Card(
                content=ft.Container(
                    content=ft.Column([
                        ft.Text(f"Molino {molino.nombre}", size=18, weight=ft.FontWeight.BOLD),
                        ft.DataTable(
                            columns=[
                                ft.DataColumn(ft.Text("Material", size=14)),
                                ft.DataColumn(ft.Text("Nivel Actual", size=14)),
                                ft.DataColumn(ft.Text("Estado Tolva", size=14)),
                                ft.DataColumn(ft.Text("T. Vaciado", size=14)),
                            ],
                            rows=rows,
                            column_spacing=35,
                            data_row_min_height=25
                        )
                    ]),
                    padding=8,
                    width=495,
                    height=300
                ),
                elevation=5
            )
            cards.append(card)

        pddl_card = ft.Container(
            content=ft.Card(
                content=ft.Container(
                    content=ft.Column([
                        ft.Text(
                            "Problema PDDL Generado",
                            size=16,
                            weight=ft.FontWeight.BOLD,
                            color=ft.colors.BLACK,
                            text_align=ft.TextAlign.CENTER
                        ),
                        ft.ListView(
                            controls=[
                                ft.Text(
                                    pddl_content if pddl_content else "Presione 'Generar Problema PDDL' para ver el contenido.",
                                    color=ft.colors.BLACK,
                                    size=14,
                                    expand=True,
                                    no_wrap=False
                                )
                            ],
                            expand=True,
                            height=240,
                            on_scroll=ft.ScrollMode.AUTO
                        )
                    ],
                    horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                    padding=10,
                    width=1000,
                    bgcolor=ft.colors.WHITE,
                    border_radius=10,
                ),
                elevation=5
            ),
            alignment=ft.alignment.center
        )

        page.add(
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
            ft.Row(
                controls=cards,
                wrap=True,
                spacing=5,
                alignment=ft.MainAxisAlignment.CENTER
            ),
            ft.ElevatedButton("Generar Problema PDDL", on_click=update_levels, bgcolor=ft.Colors.BLUE_700, color=ft.Colors.WHITE),
            pddl_card
        )
        page.update()

    # Inicializar la interfaz
    refresh_cards()

if __name__ == "__main__":
    ft.app(target=main)