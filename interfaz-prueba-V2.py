import flet as ft
import heuristico18  # Nombre del archivo base
import threading
from heuristico18 import get_estado_molinos,get_tolvas,get_niveles_metros,limites_tolvas,get_niveles_toneladas,get_tipo_productos_actuales,get_estado_rutas,calcular_tiempo_vaciado

barra_refs_MC1 = {mat: ft.Ref[ft.Container]() for mat in ["Clinker", "Puzolana_Humeda", "Yeso"]}
barra_refs_MC2 = {mat: ft.Ref[ft.Container]() for mat in ["Clinker", "Puzolana_Humeda", "Puzolana_Seca", "Yeso"]}
barra_refs_MC3 = {mat: ft.Ref[ft.Container]() for mat in ["Clinker", "Clinker_Silo_Blanco", "Puzolana_Seca", "Yeso"]}


# Obtener estado de los molinos desde el código base
estado_molinos = get_estado_molinos()
# Obtener las tolvas desde el código base
tolvas = get_tolvas()
# Obtener los tipos de productos actuales
producto_actual = get_tipo_productos_actuales()
# Obtener estado de las rutas disponibles desde el código base
estado_rutas = get_estado_rutas()

# Obtener los datos de tolvas
tolvas_MC1 = tolvas["MC1"]
tolvas_MC2 = tolvas["MC2"]
tolvas_MC3 = tolvas["MC3"]

# Variables globales
tipos_produccion_actual = {
    "MC1": None,
    "MC2": None,
    "MC3": "P30",
}


# Opciones por molino
opciones_produccion = {
    "MC1": ["P30", "P40"],
    "MC2": ["P10", "P16", "P20", "P30"],
    "MC3": ["P30"]
}

molino = None
tipo_produccion = None
material = None

# Variables globales para rastrear alimentaciones y temporizadores
alimentaciones_actuales = set()
alimentaciones_en_progreso = {}
lock = threading.Lock()
lock_print = threading.Lock()

niveles_metros = get_niveles_metros()

niveles_MC1 = niveles_metros["MC1"]
niveles_MC2 = niveles_metros["MC2"]
niveles_MC3 = niveles_metros["MC3"]

print(" ")
print("niveles MC1",niveles_MC1)
print("niveles MC2",niveles_MC2)
print("niveles MC3",niveles_MC3)


niveles_toneladas = get_niveles_toneladas(niveles_MC1, niveles_MC2, niveles_MC3)

toneladas_MC1 = niveles_toneladas["MC1"]
toneladas_MC2 = niveles_toneladas["MC2"]
toneladas_MC3 = niveles_toneladas["MC3"]

# Materiales disponibles por molino
materiales_por_molino = {
    "MC1": ["Clinker", "Yeso", "Puzolana_Humeda"],
    "MC2": ["Clinker", "Yeso", "Puzolana_Humeda", "Puzolana_Seca"],
    "MC3": ["Clinker", "Yeso", "Puzolana_Seca", "Clinker_Silo_Blanco"],
}

orden_barras_MC1 = ["Clinker","Yeso", "Puzolana_Humeda"]
orden_barras_MC2 = ["Clinker","Yeso", "Puzolana_Humeda", "Puzolana_Seca"]
orden_barras_MC3 = ["Clinker","Yeso", "Puzolana_Seca", "Clinker_Silo_Blanco"]

# Variables para almacenar niveles
molinos = ["MC1", "MC2", "MC3"]
materiales = ["Clinker", "Yeso", "Puzolana_Humeda", "Puzolana_Seca", "Clinker_Silo_Blanco"]

refs_tiempos_MC1 = {mat: ft.Ref[ft.Text]() for mat in materiales}
refs_tiempos_MC2 = {mat: ft.Ref[ft.Text]() for mat in materiales}
refs_tiempos_MC3 = {mat: ft.Ref[ft.Text]() for mat in materiales}

def crear_barras_con_refs(molino, niveles, limites, refs, orden, refs_tiempos):
    barras = []
    for material in orden:
        if material in niveles[molino]:
            nivel = float(niveles[molino][material].value)
            limite = limites[molino][material]["max"]
            unidad = limites[molino][material]["unidad"]
            porcentaje = nivel / limite if limite > 0 else 0

            # Color de la barra según nivel
            if porcentaje <= 0.3:
                color = ft.Colors.RED_700
            elif porcentaje <= 0.7:
                color = ft.Colors.YELLOW_700
            else:
                color = ft.Colors.LIGHT_GREEN_600

            # Calcular tiempo de vaciado
            tiempo_vaciado_horas = calcular_tiempo_vaciado(
                molino,
                material,
                {mat: float(niveles["MC1"][mat].value) for mat in niveles["MC1"]},
                {mat: float(niveles["MC2"][mat].value) for mat in niveles["MC2"]},
                {mat: float(niveles["MC3"][mat].value) for mat in niveles["MC3"]}
            )

            # Texto de tiempo
            if tiempo_vaciado_horas == float('inf') or tiempo_vaciado_horas is None:
                #texto = f"{material} (O h)"
                texto = f"{material} ({tiempo_vaciado_horas:.2f} h)"
            else:
                tiempo_vaciado_horas = max(tiempo_vaciado_horas, 0)
                texto = f"{material} ({tiempo_vaciado_horas:.2f} h)"

            # Crear la barra
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
                            border_radius=5,
                            alignment=ft.alignment.bottom_center
                        )
                    )
                ],
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                spacing=5)
            )
    return barras


def main(page: ft.Page):
    global  tipos_produccion_actual, molino, tipo_produccion, material #niveles_MC1, niveles_MC2, niveles_MC3,

    # Define una referencia para el Dropdown
    dropdown_mc1 = ft.Ref[ft.Dropdown]()
    dropdown_mc2 = ft.Ref[ft.Dropdown]()
    dropdown_mc3 = ft.Ref[ft.Dropdown]()

    def actualizar_estado_molino(molino, nuevo_estado):
        estado_molinos[molino] = nuevo_estado == "En marcha"
        # Actualizar solo el Dropdown del molino que cambió
        if molino == "MC1":
            dropdown_mc1.current.color = (
                ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC1"] else ft.Colors.RED_400
            )
            dropdown_mc1.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
            dropdown_mc1.current.update()

        elif molino == "MC2":
            dropdown_mc2.current.color = (
                ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC2"] else ft.Colors.RED_400
            )
            dropdown_mc2.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
            dropdown_mc2.current.update()

        elif molino == "MC3":
            dropdown_mc3.current.color = (
                ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC3"] else ft.Colors.RED_400
            )
            dropdown_mc3.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
            dropdown_mc3.current.update()

    # Referencias a los Dropdowns
    dropdown_prod_mc1 = ft.Ref[ft.Dropdown]()
    dropdown_prod_mc2 = ft.Ref[ft.Dropdown]()
    # dropdown_prod_mc3 = ft.Ref[ft.Dropdown]()

    # Función para actualizar tipo de producción
    def actualizar_produccion_molino(molino, nuevo_producto):
        print(f"Actualizando {molino} a {nuevo_producto}")
        print(f"Valor actual: {tipos_produccion_actual[molino]}")

        tipos_produccion_actual[molino] = nuevo_producto

        if molino == "MC1":
            dropdown_prod_mc1.current.value = nuevo_producto  # Actualiza el valor
            dropdown_prod_mc1.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
            dropdown_prod_mc1.current.update()

        elif molino == "MC2":
            dropdown_prod_mc1.current.value = nuevo_producto  # Actualiza el valor
            dropdown_prod_mc2.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
            dropdown_prod_mc2.current.update()

        # elif molino == "MC3":
        #     dropdown_prod_mc3.current.text_style = ft.TextStyle(weight=ft.FontWeight.BOLD)
        #     dropdown_prod_mc3.current.update()

    # Asegúrate de inicializar tipos_produccion_actual["MC1"] con un valor por defecto si está vacío
    if not tipos_produccion_actual["MC1"] and opciones_produccion["MC1"]:
        tipos_produccion_actual["MC1"] = opciones_produccion["MC1"][0]  # Selecciona el primer valor de las opciones
        
    # Asegúrate de inicializar tipos_produccion_actual["MC1"] con un valor por defecto si está vacío
    if not tipos_produccion_actual["MC2"] and opciones_produccion["MC2"]:
        tipos_produccion_actual["MC2"] = opciones_produccion["MC2"][0]  # Selecciona el primer valor de las opciones
        

    # Configuración de la página principal
    page.title = "Gestión de Alimentaciones y Recomendaciones"
    page.window_width = 1400
    page.window_height = 300
    page.theme_mode = ft.ThemeMode.DARK  # Establecer el tema oscuro

    # Personalización de colores oscuros
    page.bgcolor = ft.Colors.BLUE_GREY_900  # Fondo oscuro
    page.fonts = {
        "Roboto": "https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap"
    }
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

    tipos_produccion = ["P10", "P16", "P20", "P30", "P40"]
    # Configuración recuadros de niveles
    niveles = {
        "MC1": {mat: ft.TextField(value=str(niveles_MC1.get(mat, 0)), width=30, color="white") for mat in materiales},
        "MC2": {mat: ft.TextField(value=str(niveles_MC2.get(mat, 0)), width=30, color="white") for mat in materiales},
        "MC3": {mat: ft.TextField(value=str(niveles_MC3.get(mat, 0)), width=30, color="white") for mat in materiales},
    }

    # Asegúrate de que los TextField de MC2 no tengan borde
    for mat in materiales:
        niveles["MC1"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
        niveles["MC2"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
        niveles["MC3"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
        niveles["MC2"][mat].padding = ft.padding.only(right=26)  # ← para que el texto dentro tenga margen interno 
    
    calculo_toneladas = {
        "MC1": {mat: ft.TextField(value=str(toneladas_MC1.get(mat, 0)), width=50, color="white", read_only=True) for mat in materiales},
        "MC2": {mat: ft.TextField(value=str(toneladas_MC2.get(mat, 0)), width=50, color="white", read_only=True) for mat in materiales},
        "MC3": {mat: ft.TextField(value=str(toneladas_MC3.get(mat, 0)), width=50, color="white", read_only=True) for mat in materiales},
    }

    # Asegúrate de que los TextField de MC2 no tengan borde
    for mat in materiales:
        calculo_toneladas["MC1"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
        calculo_toneladas["MC2"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
        calculo_toneladas["MC3"][mat].border = ft.InputBorder.NONE  # Refuerza la eliminación del borde
       # Tipos de producción iniciales
    produccion = {
        molino: ft.Dropdown(
            options=[ft.dropdown.Option(p) for p in tipos_produccion],
            value=tipos_produccion[0],
            width=120,
            color="white",
            bgcolor=ft.Colors.BLUE_GREY_400,
        )
        for molino in molinos
    }

    # Definir los tipos de productos que cada molino puede producir
    tipos_validos_por_molino = {
        "MC1": ["P30", "P40"],
        "MC2": ["P10", "P16", "P20", "P30"],
        "MC3": ["P30"]
    }

    # Función para actualizar el tipo de producción seleccionado
    def actualizar_tipo_produccion(evento, molino):
        tipos_produccion_actual[molino] = evento.control.value
        print(f"Tipo de producción seleccionado para {molino}: {tipos_produccion_actual[molino]}")

    def calcular_tiempos(e):
        #global estado_molinos,molino, tipo_produccion, material, niveles_MC1, niveles_MC2, niveles_MC3, recomendaciones_generales
        #global calculo_toneladas
        # Construir niveles para cada molino
        niveles_MC1 = {mat: float(niveles["MC1"][mat].value) for mat in materiales}
        niveles_MC2 = {mat: float(niveles["MC2"][mat].value) for mat in materiales}
        niveles_MC3 = {mat: float(niveles["MC3"][mat].value) for mat in materiales}
 

        niveles_toneladas = get_niveles_toneladas(niveles_MC1, niveles_MC2, niveles_MC3)
        print("")
        print("Valores ingresados por usuario:")
        print("Niveles nuevos ingresados")
        print(f"Niveles MC1 = {niveles_MC1}")
        print(f"Niveles MC2 = {niveles_MC2}")
        print(f"Niveles MC3 = {niveles_MC3}")
        print("")

        # Genera un cuadro verde al final de la pantalla indicando que los valores se han ingresado correctamente
        page.snack_bar = ft.SnackBar(
            content=ft.Text(
                "Niveles actualizados correctamente.",
                color="black"
            ),
            bgcolor="#00FF00",
            open=True
        )

        recomendaciones = heuristico18.main(estado_molinos,niveles_MC1,niveles_MC2,niveles_MC3, material,tipos_produccion_actual) #,interactivo=False)

        # Concatenar las recomendaciones en un solo texto
        recomendaciones_texto = "\n".join(recomendaciones)

        # Actualizar el texto en el contenedor fijo
        info_text.value = recomendaciones_texto

        # MC1
        for mat in limites_tolvas["MC1"]:
            if mat in niveles_MC1:
                limite = limites_tolvas["MC1"][mat]["max"]
                porcentaje = niveles_MC1[mat] / limite if limite > 0 else 0
                barra_refs_MC1[mat].current.height = 100 * porcentaje
                # 🔄 También actualiza el color

                # Determinar el color según el porcentaje
                if porcentaje <= 0.3:
                    color = ft.Colors.RED_700
                elif porcentaje <= 0.7:
                    color = ft.Colors.YELLOW_700
                else:
                    color = ft.Colors.LIGHT_GREEN_600
                barra_refs_MC1[mat].current.bgcolor = color

        # MC2
        for mat in limites_tolvas["MC2"]:
            if mat in niveles_MC2:
                limite = limites_tolvas["MC2"][mat]["max"]
                porcentaje = niveles_MC2[mat] / limite if limite > 0 else 0
                barra_refs_MC2[mat].current.height = 100 * porcentaje
                
                # Determinar el color según el porcentaje
                if porcentaje <= 0.3:
                    color = ft.Colors.RED_700
                elif porcentaje <= 0.7:
                    color = ft.Colors.YELLOW_700
                else:
                    color = ft.Colors.LIGHT_GREEN_600
                barra_refs_MC2[mat].current.bgcolor = color
        # MC3
        for mat in limites_tolvas["MC3"]:
            if mat in niveles_MC3:
                limite = limites_tolvas["MC3"][mat]["max"]
                porcentaje = niveles_MC3[mat] / limite if limite > 0 else 0
                barra_refs_MC3[mat].current.height = 100 * porcentaje
                
                # Determinar el color según el porcentaje
                if porcentaje <= 0.3:
                    color = ft.Colors.RED_700
                elif porcentaje <= 0.7:
                    color = ft.Colors.YELLOW_700
                else:
                    color = ft.Colors.LIGHT_GREEN_600
                barra_refs_MC3[mat].current.bgcolor = color

        for mat in materiales:
            for molino, refs_tiempos, niveles_actuales in [
                ("MC1", refs_tiempos_MC1, niveles_MC1),
                ("MC2", refs_tiempos_MC2, niveles_MC2),
                ("MC3", refs_tiempos_MC3, niveles_MC3),
            ]:
                tiempo = calcular_tiempo_vaciado(molino, mat, niveles_MC1, niveles_MC2, niveles_MC3)
                if tiempo == float('inf') or tiempo is None:
                    texto = f"{mat} (0 h)"
                else:
                    #tiempo = max(tiempo, 0)
                    texto = f"{mat} ({tiempo:.2f} h)"

                if refs_tiempos.get(mat) and refs_tiempos[mat].current:
                    refs_tiempos[mat].current.value = texto
                    refs_tiempos[mat].current.update()


        for mat in materiales:
            calculo_toneladas["MC1"][mat].value = str(niveles_toneladas["MC1"].get(mat, 0))
            calculo_toneladas["MC2"][mat].value = str(niveles_toneladas["MC2"].get(mat, 0))
            calculo_toneladas["MC3"][mat].value = str(niveles_toneladas["MC3"].get(mat, 0))


            # print("Materiales:", materiales)
        page.update()

    # # Panel de niveles solo para Molino de Cemento 1
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
                            options=[
                                ft.dropdown.Option("En marcha"),
                                ft.dropdown.Option("Detenido"),
                            ],
                            value="En marcha" if estado_molinos["MC1"] else "Detenido",
                            on_change=lambda e: actualizar_estado_molino("MC1", e.control.value),
                            border_color=ft.Colors.TRANSPARENT,
                            color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC1"] else ft.Colors.RED_400,
                            text_style=ft.TextStyle(
                                weight=ft.FontWeight.BOLD,
                                # Altura de línea ajustada para centrado vertical:
                                height=1.2,  # Ajusta este valor (1.0, 1.2, 1.5, etc.)
                            ),
                            content_padding=ft.padding.only(left=6, top=12),  # ¡Clave para el centrado!
                            #alignment=ft.alignment.center_left,
                            autofocus=False,  # Evita efectos no deseados al interactuar
                        ),
                        bgcolor=ft.Colors.BLUE_GREY_800,
                        padding=0,  # Elimina padding interno del Container
                        border_radius=5,
                        #height=45,
                        alignment=ft.alignment.center,
                        ),

                        ft.Container(
                            ft.Row([
                                ft.Text(" Producto:" ,width=75,weight="bold",size=14, color="white"),
                                ft.Dropdown(
                                    ref=dropdown_prod_mc1,
                                    width=89,
                                    value=tipos_produccion_actual["MC1"],
                                    options=[ft.dropdown.Option(op) for op in opciones_produccion["MC1"]],
                                    on_change=lambda e: actualizar_produccion_molino("MC1", e.control.value),
                                    text_size=14,  # Fuerza el tamaño del texto directamente en el Dropdown            
                                    border_color=ft.Colors.TRANSPARENT , # Quita el borde negro del Dropdown
                                    text_style=ft.TextStyle(
                                        weight=ft.FontWeight.BOLD,  # Letra más gruesa para el valor seleccionado
                                        size=14,  # Tamaño de la fuente, ajusta si necesitas
                                        color=ft.Colors.WHITE  # Color del texto
                                    ),
                                    border_radius=0,  # Intenta eliminar el radio del borde del Dropdown
                                    bgcolor=ft.Colors.BLUE_GREY_800  # Asegura que el fondo coincida con el contenedor
                                )
                            ],
                            spacing=0,  # Reduce el espacio entre el texto y el Dropdown
                            alignment=ft.MainAxisAlignment.CENTER,  # Centra los elementos horizontalmente
                            ),
                            width=164,
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,  # Elimina padding interno del Container
                            border_radius=5,
                            border=ft.border.all(1, ft.Colors.TRANSPARENT),  # Borde transparente del Container
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
                                            niveles["MC1"][mat],  # usa el TextField existente
                                            ft.Text(
                                                limites_tolvas["MC1"][mat]["unidad"],
                                                color="white",
                                                text_align=ft.TextAlign.CENTER  # Centrar el texto de la unidad, si se desea
                                            )
                                        ],
                                        
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0),
                                    alignment=ft.alignment.center  # Centrar el Row dentro del Container
                                ),


                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC1"][mat],  # campo de toneladas
                                            ft.Text(
                                                "ton",
                                                color="white"
                                            )
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
                        )
                        for mat in materiales_por_molino["MC1"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),

                # Visualización de barras
                ft.Container(
                    content=ft.Row(
                        [
                            *crear_barras_con_refs("MC1",niveles, limites_tolvas, barra_refs_MC1,orden_barras_MC1,refs_tiempos_MC1),
                            #*crear_barras_con_refs("MC1", niveles_MC1, limites_tolvas["MC1"], barra_refs_MC1, orden=materiales_por_molino["MC1"]
                        ],
                        #alignment=ft.MainAxisAlignment.SPACE_EVENLY,
                        alignment=ft.MainAxisAlignment.CENTER,
                        vertical_alignment=ft.CrossAxisAlignment.START,
                        wrap=False
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

    # Panel de niveles solo para Molino de Cemento 1
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
                            options=[
                                ft.dropdown.Option("En marcha"),
                                ft.dropdown.Option("Detenido"),
                            ],
                            value="En marcha" if estado_molinos["MC2"] else "Detenido",
                            on_change=lambda e: actualizar_estado_molino("MC2", e.control.value),
                            border_color=ft.Colors.TRANSPARENT,
                            color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC2"] else ft.Colors.RED_400,
                            text_style=ft.TextStyle(
                                weight=ft.FontWeight.BOLD,
                                # Altura de línea ajustada para centrado vertical:
                                height=1.2,  # Ajusta este valor (1.0, 1.2, 1.5, etc.)
                            ),
                            content_padding=ft.padding.only(left=6, top=12),  # ¡Clave para el centrado!
                            #alignment=ft.alignment.center_left,
                            autofocus=False,  # Evita efectos no deseados al interactuar
                        ),
                        bgcolor=ft.Colors.BLUE_GREY_800,
                        padding=0,  # Elimina padding interno del Container
                        border_radius=5,
                        #height=45,
                        alignment=ft.alignment.center,
                        ),


                        ft.Container(
                            ft.Row([
                                ft.Text(" Producto:" ,width=75,weight="bold",size=14, color="white"),
                                ft.Dropdown(
                                    ref=dropdown_prod_mc2,
                                    width=89,
                                    value=tipos_produccion_actual["MC2"],
                                    options=[ft.dropdown.Option(op) for op in opciones_produccion["MC2"]],
                                    on_change=lambda e: actualizar_produccion_molino("MC2", e.control.value),
                                    text_size=14,  # Fuerza el tamaño del texto directamente en el Dropdown            
                                    border_color=ft.Colors.TRANSPARENT , # Quita el borde negro del Dropdown
                                    text_style=ft.TextStyle(
                                        weight=ft.FontWeight.BOLD,  # Letra más gruesa para el valor seleccionado
                                        size=14,  # Tamaño de la fuente, ajusta si necesitas
                                        color=ft.Colors.WHITE  # Color del texto
                                    ),
                                    border_radius=0,  # Intenta eliminar el radio del borde del Dropdown
                                    #padding=ft.padding.only(left=5, right=5),  # Reduce el padding interno
                                    content_padding=ft.padding.only(left=5, right=0),  # Ajusta el padding del contenido
                                    #icon_size=14,  # Reduce el tamaño de la flecha/icono si es soportado
                                    # Opcional: Si el círculo es parte del fondo del icono, intenta este ajuste
                                    bgcolor=ft.Colors.BLUE_GREY_800  # Asegura que el fondo coincida con el contenedor
                                )
                            ],
                            spacing=0,  # Reduce el espacio entre el texto y el Dropdown
                            alignment=ft.MainAxisAlignment.CENTER,  # Centra los elementos horizontalmente
                            ),
                            width=164,
                            bgcolor=ft.Colors.BLUE_GREY_800,
                            padding=0,  # Elimina padding interno del Container
                            border_radius=5,
                            border=ft.border.all(1, ft.Colors.TRANSPARENT),  # Borde transparente del Container
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
                                            niveles["MC2"][mat],  # usa el TextField existente

                                            ft.Container(
                                                content=ft.Text(
                                                    limites_tolvas["MC2"][mat]["unidad"],
                                                    color="white",
                                                    text_align=ft.TextAlign.CENTER
                                                ),
                                                #margin=ft.margin.only(left=-20)  # ← Esto sí es válido aquí
                                            )
                                        ],
                                        
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    border_radius=4,
                                    height=49,
                                    width=110,
                                    # vertical_alignment=ft.CrossAxisAlignment.CENTER,  # ← Esta línea debe estar aquí
                                    padding=ft.padding.symmetric(horizontal=0, vertical=0),
                                
                                    alignment=ft.alignment.center  # Centrar el Row dentro del Container
                                ),

                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC2"][mat],  # campo de toneladas
                                            ft.Text(
                                                "ton",
                                                color="white"
                                            )
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
                        )
                        for mat in materiales_por_molino["MC2"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),


                # Visualización de barras
                ft.Container(
                    content=ft.Row(
                        [
                            *crear_barras_con_refs("MC2",niveles, limites_tolvas, barra_refs_MC2,orden_barras_MC2,refs_tiempos_MC2),
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_EVENLY,
                        vertical_alignment=ft.CrossAxisAlignment.START,
                        wrap=False
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

    # Panel de niveles solo para Molino de Cemento 1
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
                            options=[
                                ft.dropdown.Option("En marcha"),
                                ft.dropdown.Option("Detenido"),
                            ],
                            value="En marcha" if estado_molinos["MC3"] else "Detenido",
                            on_change=lambda e: actualizar_estado_molino("MC3", e.control.value),
                            border_color=ft.Colors.TRANSPARENT,
                            color=ft.Colors.GREEN_ACCENT_400 if estado_molinos["MC1"] else ft.Colors.RED_400,
                            text_style=ft.TextStyle(
                                weight=ft.FontWeight.BOLD,
                                # Altura de línea ajustada para centrado vertical:
                                height=1.2,  # Ajusta este valor (1.0, 1.2, 1.5, etc.)
                            ),
                            content_padding=ft.padding.only(left=6, top=12),  # ¡Clave para el centrado!
                            #alignment=ft.alignment.center_left,
                            autofocus=False,  # Evita efectos no deseados al interactuar
                        ),
                        bgcolor=ft.Colors.BLUE_GREY_800,
                        padding=0,  # Elimina padding interno del Container
                        border_radius=5,
                        #height=45,
                        alignment=ft.alignment.center,
                        ),

                        ft.Container(
                            content=ft.Row(
                                [
                                    ft.Text("Producto:", size=14, color="white", weight="bold"),
                                    ft.Text(
                                        producto_actual["MC3"],
                                        color="white",
                                        size=14,
                                        weight="bold"
                                    )
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
                                            niveles["MC3"][mat],  # usa el TextField existente
                                            ft.Text(
                                                limites_tolvas["MC3"][mat]["unidad"],
                                                color="white",
                                                text_align=ft.TextAlign.CENTER  # Centrar el texto de la unidad, si se desea
                                            )
                                        ],
                                        
                                        alignment=ft.MainAxisAlignment.CENTER,
                                        spacing=5
                                    ),
                                    border=ft.border.all(1, "black"),
                                    height=49,
                                    width=110,
                                    border_radius=4,
                                    padding=ft.padding.symmetric(horizontal=6, vertical=0),
                                    alignment=ft.alignment.center  # Centrar el Row dentro del Container
                                ),


                                ft.Container(
                                    content=ft.Row(
                                        [
                                            calculo_toneladas["MC3"][mat],  # campo de toneladas
                                            ft.Text(
                                                "ton",
                                                color="white"
                                            )
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
                        )
                        for mat in materiales_por_molino["MC3"]
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                ),

                # Visualización de barras
                ft.Container(
                    content=ft.Row(
                        [
                            *crear_barras_con_refs("MC3",niveles, limites_tolvas, barra_refs_MC3,orden_barras_MC3,refs_tiempos_MC3),
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_EVENLY,
                        vertical_alignment=ft.CrossAxisAlignment.START,
                        wrap=False
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

    # # Crear un contenedor fijo para las recomendaciones
    info_text = ft.Text(value="", size=25, color="white")
    info_container = ft.Container(
        content=info_text,
        padding=20,
        bgcolor=ft.Colors.BLUE_GREY_600,
        border=ft.border.all(1, ft.Colors.BLUE),
        border_radius=5,
        width=1000,
    )

    # Centrado horizontal
    info_container_centered = ft.Row(
        controls=[info_container],
        alignment=ft.MainAxisAlignment.CENTER
    )
  

    def crear_fila_ruta(nombre, estado):
        def on_click(e):
            estado_rutas[nombre] = not estado_rutas[nombre]
            print(f"Ruta '{nombre}' actualizada a {estado_rutas[nombre]}")
            menu_column.controls = construir_column_rutas()
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
                alignment=ft.alignment.center,  # Centra horizontalmente
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

    titulo_container = ft.Container(
        content=ft.Row(
            [
                #pb,
                menu_rutas,
                ft.Text(
                    "OPTIMIZACIÓN DE ALIMENTACIONES",
                    size=50,
                    weight=ft.FontWeight.BOLD,
                    color="white"
                ),
                ft.Image(
                    src="G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/Interfaz-alimentaciones/UNACEM_Logos_Finales-01-1600x1132.png",  # Reemplaza con la ruta o URL de tu imagen
                    width=130,
                    height=130,
                    fit=ft.ImageFit.CONTAIN
                ), 
            ],
            alignment=ft.MainAxisAlignment.CENTER,  # Centra los elementos en la fila
            vertical_alignment=ft.CrossAxisAlignment.CENTER
        ),
        alignment=ft.alignment.center,
        width=1530,
        height=70,
    )

    # Crear los ítems del menú de rutas con emojis
    items = []
    for nombre_ruta, estado in estado_rutas.items():
        emoji = "✅" if estado else "❌"
        items.append(ft.PopupMenuItem(text=f"{emoji} {nombre_ruta}"))
    items.insert(4, ft.PopupMenuItem())  # Divider Clinker
    items.insert(9, ft.PopupMenuItem())  # Divider Puzolana
    menu_estado_rutas = ft.Container(
        content=ft.Column(
            controls=[
                ft.Text("ESTADO DE RUTAS", size=20, weight=ft.FontWeight.BOLD, color="white"),
                *[
                    ft.Text(f"{'✅' if estado else '❌'} {ruta}", size=13, color="white")
                    for ruta, estado in estado_rutas.items()
                ]
            ],
            spacing=20,
            scroll=ft.ScrollMode.AUTO
        ),
        bgcolor="#000000",  # Negro sólido, sin transparencia
        padding=5,
        alignment=ft.alignment.top_right,
        expand=True,  # Hace que ocupe toda la altura disponible
    )

    contenido_principal = ft.Container(
        content = ft.Column(
            [
                titulo_container,
                
                # Sección de niveles en fila
                ft.Row(
                    [
                        niveles_column_MC1,
                        niveles_column_MC2,
                        niveles_column_MC3,
                        # Puedes agregar otras columnas aquí si es necesario
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=10,
                ),
 

                ft.Row(
                    [
                    ft.ElevatedButton(
                        "Generar recomendaciones",
                        
                        on_click=calcular_tiempos,
                        bgcolor=ft.Colors.BLUE_ACCENT_700,
                        color="white",
                    ),
                    # Contenedor de recomendaciones
                    #info_container,
                    info_container_centered,
                ],
                alignment=ft.MainAxisAlignment.CENTER,
                )
            ],
            spacing=20,  # Espacion entre elemento de recomendaciones
            scroll=ft.ScrollMode.AUTO,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        ),
        expand=True,  # Hace que ocupe toda la altura disponible
    )
    
    page.add(
        ft.Row(
            [
                ft.Container(content=contenido_principal, expand=3),
                #ft.Container(content=menu_estado_rutas, expand=0.4),  # Ocupa una parte proporcional
            ],
            spacing=5,
            expand=True,
            vertical_alignment=ft.CrossAxisAlignment.START  # ← Alineación vertical al tope
        )
    )

# Ejecutar la aplicación
ft.app(target=main)