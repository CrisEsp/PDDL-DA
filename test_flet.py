import flet as ft

def main(page: ft.Page):
    page.title = "Servidor de prueba"
    page.add(ft.Text("Hola desde Flet en AWS!"))

if __name__ == "__main__":
    ft.app(
        target=main,
        view=None,                  # modo headless
        port=8080,
        host="0.0.0.0"
    )
