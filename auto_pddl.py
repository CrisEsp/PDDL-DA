
import subprocess
import time
import pyautogui
from pathlib import Path
from datetime import datetime
import re
import os
import sys

class PDDLExecutor:
    def __init__(self, domain_path, problem_path, workspace_path):
        # Convertir todas las rutas a formato Path para compatibilidad
        self.domain_path = Path(domain_path.replace("\\", "/"))
        self.problem_path = Path(problem_path.replace("\\", "/"))
        self.workspace_path = Path(workspace_path.replace("\\", "/"))
        
        # Buscar VS Code automáticamente
        self.vscode_path = self._find_vscode()
        if not self.vscode_path:
            raise FileNotFoundError("No se pudo encontrar el ejecutable de VS Code")
            
        self.output_dir = self.workspace_path / "generated_plans"
        self.output_dir.mkdir(exist_ok=True)
        
        # Configuración de tiempos ajustables
        self.delays = {
            'open_vscode': 1,
            'command_palette': 3,
            'select_planner': 4,
            'plan_generation': 12,
            'monitor_interval': 1
        }

    def _find_vscode(self):
        """Busca VS Code en ubicaciones comunes de diferentes sistemas"""
        # Windows
        paths = [
            r"C:\Users\{}\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd".format(os.getenv("USERNAME")),
            r"C:\Program Files\Microsoft VS Code\bin\code.cmd",
            # Linux/Mac
            "/usr/bin/code",
            "/usr/local/bin/code",
            "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        ]
        
        # También verificar si está en el PATH
        try:
            subprocess.run(["code", "--version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            return "code"
        except:
            pass
            
        for path in paths:
            if os.path.exists(path):
                return path
        return None

    def execute(self):
        """Flujo principal de ejecución"""
        print("🚀 Iniciando proceso de planificación PDDL")
        print(f"🔍 Usando VS Code en: {self.vscode_path}")
        
        try:
            # Paso 1: Abrir VS Code con los archivos
            if not self._open_vscode():
                return False
                
            # Paso 2: Ejecutar planificador TFD
            if not self._run_tfd_planner():
                return False
                
            # Paso 3: Capturar y guardar el plan
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
        """Abre VS Code con los archivos PDDL"""
        try:
            print("📂 Abriendo archivos en VS Code...")
            print(f"📄 Dominio: {self.domain_path}")
            print(f"📄 Problema: {self.problem_path}")
            
            # Verificar que los archivos existen
            if not self.domain_path.exists():
                print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
                return False
            if not self.problem_path.exists():
                print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
                return False
            
            subprocess.Popen([self.vscode_path, "--reuse-window", str(self.domain_path), str(self.problem_path)])
            time.sleep(self.delays['open_vscode'])
            return True
        except Exception as e:
            print(f"❌ Error al abrir VS Code: {e}")
            return False

    def _run_tfd_planner(self):
        """Ejecuta el planificador TFD"""
        try:
            print("⚙️ Iniciando planificador TFD...")
            
            # Asegurar que VS Code esté en primer plano
            if not self._focus_vscode():
                print("⚠️ No se pudo enfocar VS Code, intentando continuar...")
            
            # Abrir paleta de comandos
            pyautogui.hotkey('ctrl', 'shift', 'p')
            time.sleep(self.delays['command_palette'])
            
            # Escribir comando de planificación
            pyautogui.write('PDDL: Run the planner and display the plan')
            time.sleep(1)
            pyautogui.press('enter')
            time.sleep(self.delays['command_palette'])
            
            # Seleccionar TFD
            pyautogui.write('temporal fast downward')
            time.sleep(1)
            pyautogui.press('enter')
            
            print(f"⏳ Procesando planificación (esperando {self.delays['plan_generation']} segundos)...")
            time.sleep(self.delays['plan_generation'])
            return True
            
        except Exception as e:
            print(f"❌ Error al ejecutar planificador: {e}")
            return False

    def _capture_and_save_plan(self):
        """Captura el plan generado usando el método de extracción mejorado"""
        try:
            log_content = self._get_vscode_log_content()
            if log_content:
                # Extraer solo el plan más reciente
                plan_content = self._extract_most_recent_plan(log_content)
                if plan_content:
                    return self._save_clean_plan(plan_content)
            
            return None
            
        except Exception as e:
            print(f"⚠️ Error al capturar plan: {e}")
            return None

    def _get_vscode_log_content(self):
        """Obtiene el contenido del log de VS Code"""
        log_dirs = [
            os.path.expanduser("~/AppData/Roaming/Code/logs"),  # Windows
            os.path.expanduser("~/.config/Code/logs"),          # Linux
            os.path.expanduser("~/Library/Application Support/Code/logs")  # Mac
        ]
        
        for log_dir in log_dirs:
            if os.path.exists(log_dir):
                log_files = []
                for root, _, files in os.walk(log_dir):
                    for file in files:
                        if 'output' in file.lower() or 'console' in file.lower():
                            log_files.append(os.path.join(root, file))
                
                if log_files:
                    latest_log = max(log_files, key=os.path.getmtime)
                    try:
                        with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
                            return f.read()
                    except Exception as e:
                        print(f"⚠️ Error al leer log: {e}")
        
        print("❌ No se encontraron logs de VS Code")
        return None

    def _extract_most_recent_plan(self, log_content):
        """Extrae solo el plan más reciente del log"""
        plan_matches = list(re.finditer(
            r"(Plan found:|Solution:|SOLUTION FOUND:)(.*?)(?=(Plan found:|Solution:|SOLUTION FOUND:|$))", 
            log_content, 
            re.DOTALL | re.IGNORECASE
        ))
        
        if not plan_matches:
            return None
            
        last_plan = plan_matches[-1].group(2).strip()
        return self._clean_plan_text(last_plan)

    def _clean_plan_text(self, plan_text):
        """Limpia el texto del plan eliminando metadatos y outputs no deseados"""
        cleaned_lines = []
        for line in plan_text.split('\n'):
            line = line.strip()
            if line and not any(s in line for s in ['Metric:', 'Makespan:', 'States evaluated:', 'Planner found']):
                line = re.sub(r'^\d+:\s*', '', line)  # Remover numeración
                line = re.sub(r'\[\d+\.\d+\]$', '', line).strip()  # Remover duraciones
                if line and not line.startswith(';'):
                    cleaned_lines.append(line)
        
        return '\n'.join(cleaned_lines)

    def _save_clean_plan(self, plan_content):
        """Guarda el plan limpio en un archivo"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"plan_{timestamp}.txt"
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
        """Muestra solo el contenido limpio del plan"""
        try:
            with open(plan_path, 'r') as f:
                print("\n" + "="*50)
                print("CONTENIDO DEL PLAN LIMPIO:")
                print("="*50)
                print(f.read())
                print("="*50 + "\n")
        except Exception as e:
            print(f"⚠️ Error al mostrar plan: {e}")

    def _focus_vscode(self):
        """Asegura que VS Code esté en primer plano"""
        try:
            for title in ["Visual Studio Code", "code.exe"]:
                windows = pyautogui.getWindowsWithTitle(title)
                if windows:
                    windows[0].activate()
                    time.sleep(1)
                    return True
            return False
        except Exception as e:
            print(f"⚠️ Advertencia: No se pudo enfocar VS Code: {e}")
            return False

def main():
    # Configuración de rutas - usar rutas crudas (raw strings)
    DOMAIN = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA\cement-alimentacion.pddl"
    PROBLEM = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA\cement_problem.pddl"
    WORKSPACE = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA"
    
    try:
        # Ejecutar el proceso
        executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
        success = executor.execute()
        
        # Resultado final
        print("\n" + "="*50)
        print("✅ PROCESO COMPLETADO CON ÉXITO" if success else "❌ PROCESO COMPLETADO CON ERRORES")
        print("="*50)

        sys.exit(0 if success else 1)
        
    except Exception as e:
        print(f"❌ Error inicial: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()