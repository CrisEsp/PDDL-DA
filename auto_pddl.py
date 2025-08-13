# import subprocess
# import time
# import pyautogui
# from pathlib import Path

# # Configuración de rutas (ajustadas a tus archivos)
# DOMAIN = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement-alimentacion.pddl"
# PROBLEM = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement_problem.pddl"
# WORKSPACE = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA"
# VSCODE_PATH = r"C:\Users\DELL\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"

# def focus_vscode():
#     """Asegura que VS Code esté en primer plano"""
#     try:
#         pyautogui.getWindowsWithTitle("Visual Studio Code")[0].activate()
#         time.sleep(1)
#     except Exception as e:
#         print(f"⚠️ Error al enfocar VS Code: {e}")

# def run_pddl_planner():
#     """Ejecuta el planificador PDDL con TFD"""
#     try:
#         # 1. Abrir paleta de comandos
#         pyautogui.hotkey('ctrl', 'shift', 'p')
#         time.sleep(1.5)
        
#         # 2. Escribir comando exacto
#         pyautogui.write('PDDL: Run the planner and display the plan')
#         time.sleep(0.8)
#         pyautogui.press('enter')
#         time.sleep(2.5)
        
#         # 3. Seleccionar TFD
#         pyautogui.write('temporal fast downward')
#         time.sleep(1)
#         pyautogui.press('enter')
#         return True
#     except Exception as e:
#         print(f"⚠️ Error en automatización: {e}")
#         return False

# def find_plan():
#     """Busca el archivo de plan generado"""
#     patterns = ["sas_plan.*", "plan*.pddl", "*.plan"]
#     for pattern in patterns:
#         plans = list(Path(WORKSPACE).glob(pattern))
#         if plans:
#             return str(plans[0].resolve())
#     return None

# def main():
#     try:
#         # 1. Abrir archivos en VS Code
#         print("📁 Abriendo archivos PDDL...")
#         subprocess.run([VSCODE_PATH, "--reuse-window", DOMAIN, PROBLEM])
#         time.sleep(5)  # Tiempo generoso para carga
        
#         # 2. Preparar VS Code
#         focus_vscode()
#         time.sleep(1)
        
#         # 3. Ejecutar planificador
#         print("⚙️ Ejecutando planificador TFD...")
#         if not run_pddl_planner():
#             return
            
#         # 4. Esperar y buscar plan
#         print("⏳ Esperando generación del plan...")
#         time.sleep(15)  # Tiempo ajustado para TFD
        
#         plan_path = find_plan()
#         if plan_path:
#             print(f"✅ Plan generado:\n{plan_path}")
#             # Mostrar contenido del plan
#             with open(plan_path, 'r') as f:
#                 print("\nContenido del plan:")
#                 print(f.read())
#         else:
#             print("❌ No se encontró el archivo de plan")
#             print("Posibles causas:")
#             print("- El planificador falló (ver terminal de VS Code)")
#             print("- El nombre del archivo generado no coincide con los patrones buscados")
            
#     except Exception as e:
#         print(f"❌ Error crítico: {e}")

# if __name__ == "__main__":
#     print("🚀 Iniciando automatización PDDL-TFD")
#     main()
#     print("🏁 Proceso completado")


# import subprocess
# import time
# import pyautogui
# from pathlib import Path
# from datetime import datetime
# import re
# import os
# import sys

# class PDDLExecutor:
#     def __init__(self, domain_path, problem_path, workspace_path):
#         self.domain_path = domain_path
#         self.problem_path = problem_path
#         self.workspace_path = Path(workspace_path)
#         self.vscode_path = r"C:\Users\DELL\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
#         self.output_dir = self.workspace_path / "generated_plans"
#         self.output_dir.mkdir(exist_ok=True)
        
#         # Configuración de tiempos ajustables
#         self.delays = {
#             'open_vscode': 5,
#             'command_palette': 2,
#             'select_planner': 3,
#             'plan_generation': 20,
#             'monitor_interval': 1
#         }

#     def execute(self):
#         """Flujo principal de ejecución"""
#         print("🚀 Iniciando proceso de planificación PDDL")
        
#         # Paso 1: Abrir VS Code con los archivos
#         if not self._open_vscode():
#             return False
            
#         # Paso 2: Ejecutar planificador TFD
#         if not self._run_tfd_planner():
#             return False
            
#         # Paso 3: Capturar y guardar el plan usando el método probado
#         plan_path = self._capture_and_save_plan()
#         if plan_path:
#             print(f"✅ Plan generado exitosamente: {plan_path}")
#             self._display_plan(plan_path)
#             return True
#         else:
#             print("❌ No se pudo generar el plan")
#             print("Posibles soluciones:")
#             print("1. Verifica que TFD esté instalado correctamente")
#             print("2. Ejecuta el proceso manualmente para ver errores")
#             print("3. Revisa la configuración de tiempos en el script")
#             return False

#     def _open_vscode(self):
#         """Abre VS Code con los archivos PDDL"""
#         try:
#             print("📂 Abriendo archivos en VS Code...")
#             subprocess.Popen([self.vscode_path, "--reuse-window", self.domain_path, self.problem_path])
#             time.sleep(self.delays['open_vscode'])
#             return True
#         except Exception as e:
#             print(f"❌ Error al abrir VS Code: {e}")
#             return False

#     def _run_tfd_planner(self):
#         """Ejecuta el planificador TFD"""
#         try:
#             print("⚙️ Iniciando planificador TFD...")
            
#             # Asegurar que VS Code esté en primer plano
#             self._focus_vscode()
            
#             # Abrir paleta de comandos
#             pyautogui.hotkey('ctrl', 'shift', 'p')
#             time.sleep(self.delays['command_palette'])
            
#             # Escribir comando de planificación
#             pyautogui.write('PDDL: Run the planner and display the plan')
#             time.sleep(1)
#             pyautogui.press('enter')
#             time.sleep(self.delays['command_palette'])
            
#             # Seleccionar TFD
#             pyautogui.write('temporal fast downward')
#             time.sleep(1)
#             pyautogui.press('enter')
            
#             print("⏳ Procesando planificación...")
#             time.sleep(self.delays['plan_generation'])
#             return True
            
#         except Exception as e:
#             print(f"❌ Error al ejecutar planificador: {e}")
#             return False

#     def _capture_and_save_plan(self):
#         """Captura el plan generado usando el método de extracción probado"""
#         try:
#             # Usar el método de monitoreo de logs que ya funciona
#             log_content = self._get_vscode_log_content()
#             if log_content:
#                 plan_content = self._extract_plan_from_log(log_content)
#                 if plan_content:
#                     return self._save_plan(plan_content)
            
#             return None
            
#         except Exception as e:
#             print(f"⚠️ Error al capturar plan: {e}")
#             return None

#     def _get_vscode_log_content(self):
#         """Obtiene el contenido del log de VS Code (método probado)"""
#         log_dirs = [
#             os.path.expanduser("~/AppData/Roaming/Code/logs"),
#             os.path.expanduser("~/.config/Code/logs"),
#             os.path.expanduser("~/Library/Application Support/Code/logs")
#         ]
        
#         for log_dir in log_dirs:
#             if os.path.exists(log_dir):
#                 # Buscar el archivo de log más reciente
#                 log_files = []
#                 for root, _, files in os.walk(log_dir):
#                     for file in files:
#                         if 'output' in file.lower() or 'console' in file.lower():
#                             log_files.append(os.path.join(root, file))
                
#                 if log_files:
#                     latest_log = max(log_files, key=os.path.getmtime)
#                     try:
#                         with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
#                             return f.read()
#                     except Exception as e:
#                         print(f"⚠️ Error al leer log: {e}")
        
#         print("❌ No se encontraron logs de VS Code")
#         return None

#     def _extract_plan_from_log(self, log_content):
#         """Extrae el plan del log usando el método probado"""
#         plan_patterns = [
#             r"Plan found:(.*?)(?:Plan length:|$)",
#             r"Solution:(.*?)(?:; cost|; time|$)",
#             r"SOLUTION FOUND:(.*?)(?:total-cost|$)"
#         ]
        
#         for pattern in plan_patterns:
#             match = re.search(pattern, log_content, re.DOTALL | re.IGNORECASE)
#             if match:
#                 plan_text = match.group(1).strip()
#                 return self._clean_plan_text(plan_text)
#         return None

#     def _clean_plan_text(self, plan_text):
#         """Limpia el texto del plan (método probado)"""
#         lines = plan_text.split('\n')
#         cleaned_lines = []
        
#         for line in lines:
#             line = line.strip()
#             if line and not line.startswith(';') and not line.startswith(';;'):
#                 line = re.sub(r'^\d+:\s*', '', line)
#                 line = re.sub(r'^\d+\.\s*', '', line)
#                 cleaned_lines.append(line)
        
#         return '\n'.join(cleaned_lines)

#     def _save_plan(self, plan_content):
#         """Guarda el plan en un archivo con timestamp"""
#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         filename = f"plan_{timestamp}.pddl"
#         filepath = self.output_dir / filename
        
#         try:
#             with open(filepath, 'w', encoding='utf-8') as f:
#                 f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
#                 f.write(f"; Dominio: {Path(self.domain_path).name}\n")
#                 f.write(f"; Problema: {Path(self.problem_path).name}\n\n")
#                 f.write(plan_content)
#             return filepath
#         except Exception as e:
#             print(f"⚠️ Error al guardar plan: {e}")
#             return None

#     def _display_plan(self, plan_path):
#         """Muestra el contenido del plan"""
#         try:
#             with open(plan_path, 'r') as f:
#                 print("\n" + "="*50)
#                 print("CONTENIDO DEL PLAN:")
#                 print("="*50)
#                 print(f.read())
#                 print("="*50 + "\n")
#         except Exception as e:
#             print(f"⚠️ Error al mostrar plan: {e}")

#     def _focus_vscode(self):
#         """Asegura que VS Code esté en primer plano"""
#         try:
#             for title in ["Visual Studio Code", "code.exe"]:
#                 windows = pyautogui.getWindowsWithTitle(title)
#                 if windows:
#                     windows[0].activate()
#                     time.sleep(1)
#                     return True
#             return False
#         except Exception as e:
#             print(f"⚠️ Advertencia: No se pudo enfocar VS Code: {e}")
#             return False

# def main():
#     # Configuración de rutas
#     DOMAIN = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement-alimentacion.pddl"
#     PROBLEM = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement_problem.pddl"
#     WORKSPACE = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA"
    
#     # Ejecutar el proceso
#     executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
#     success = executor.execute()
    
#     # Resultado final
#     print("\n" + "="*50)
#     print("✅ PROCESO COMPLETADO CON ÉXITO" if success else "❌ PROCESO COMPLETADO CON ERRORES")
#     print("="*50)

#     sys.exit(0 if success else 1)

# if __name__ == "__main__":
#     main()



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
        self.domain_path = domain_path
        self.problem_path = problem_path
        self.workspace_path = Path(workspace_path)
        self.vscode_path = r"C:\Users\DELL\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
        self.output_dir = self.workspace_path / "generated_plans"
        self.output_dir.mkdir(exist_ok=True)
        
        # Configuración de tiempos ajustables
        self.delays = {
            'open_vscode': 1,
            'command_palette': 2,
            'select_planner': 3,
            'plan_generation': 5,
            'monitor_interval': 1
        }

    def execute(self):
        """Flujo principal de ejecución"""
        print("🚀 Iniciando proceso de planificación PDDL")
        
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

    def _open_vscode(self):
        """Abre VS Code con los archivos PDDL"""
        try:
            print("📂 Abriendo archivos en VS Code...")
            subprocess.Popen([self.vscode_path, "--reuse-window", self.domain_path, self.problem_path])
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
            self._focus_vscode()
            
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
            
            print("⏳ Procesando planificación...")
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
            os.path.expanduser("~/AppData/Roaming/Code/logs"),
            os.path.expanduser("~/.config/Code/logs"),
            os.path.expanduser("~/Library/Application Support/Code/logs")
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
        # Buscar todos los planes en el log
        plan_matches = list(re.finditer(
            r"(Plan found:|Solution:|SOLUTION FOUND:)(.*?)(?=(Plan found:|Solution:|SOLUTION FOUND:|$))", 
            log_content, 
            re.DOTALL | re.IGNORECASE
        ))
        
        if not plan_matches:
            return None
            
        # Tomar el último plan encontrado (el más reciente)
        last_plan = plan_matches[-1].group(2).strip()
        return self._clean_plan_text(last_plan)

    def _clean_plan_text(self, plan_text):
        """Limpia el texto del plan eliminando metadatos y outputs no deseados"""
        # Eliminar líneas que no son acciones del plan
        cleaned_lines = []
        for line in plan_text.split('\n'):
            line = line.strip()
            if line and not any(s in line for s in ['Metric:', 'Makespan:', 'States evaluated:', 'Planner found']):
                # Limpiar formato de acciones
                line = re.sub(r'^\d+:\s*', '', line)  # Remover numeración
                line = re.sub(r'\[\d+\.\d+\]$', '', line).strip()  # Remover duraciones
                if line and not line.startswith(';'):
                    cleaned_lines.append(line)
        
        return '\n'.join(cleaned_lines)

    def _save_clean_plan(self, plan_content):
        """Guarda el plan limpio en un archivo"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"plan_{timestamp}.pddl"
        filepath = self.output_dir / filename
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
                f.write(f"; Dominio: {Path(self.domain_path).name}\n")
                f.write(f"; Problema: {Path(self.problem_path).name}\n\n")
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
    # Configuración de rutas
    DOMAIN = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement-alimentacion.pddl"
    PROBLEM = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA/cement_problem.pddl"
    WORKSPACE = "G:/Mi unidad/TRABAJO UNACEM 2025/PROYECTO HEURISTICO 2025/PDDL-DA"
    
    # Ejecutar el proceso
    executor = PDDLExecutor(DOMAIN, PROBLEM, WORKSPACE)
    success = executor.execute()
    
    # Resultado final
    print("\n" + "="*50)
    print("✅ PROCESO COMPLETADO CON ÉXITO" if success else "❌ PROCESO COMPLETADO CON ERRORES")
    print("="*50)

    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
