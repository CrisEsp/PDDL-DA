# import os
# from pathlib import Path
# import requests
# import re
# import time
# from datetime import datetime
# import json


# # ======== CONFIGURA AQUÍ TUS RUTAS ========
# # DOMAIN_PATH = "/home/cristian/PDDL-DA/PDDL-pruebas/prioridad-vaciado.pddl"
# # PROBLEM_PATH = "/home/cristian/PDDL-DA/PDDL-pruebas/test-prioridad.pddl"
# # WORKSPACE_PATH = "."   # Carpeta donde se guardará generated_plans

# DOMAIN_PATH = "/home/cristian/PDDL-DA/PDDL-pruebas2/dominio.pddl"
# PROBLEM_PATH = "/home/cristian/PDDL-DA/PDDL-pruebas2/problem.pddl"
# WORKSPACE_PATH = "."   # Carpeta donde se guardará generated_plans
# # =========================================



# class PDDLExecutor:
#     def __init__(self, domain_path, problem_path, workspace_path="."):
#         # Normaliza rutas
#         self.domain_path = Path(domain_path).expanduser().resolve()
#         self.problem_path = Path(problem_path).expanduser().resolve()
#         self.workspace_path = Path(workspace_path).expanduser().resolve()
#         self.output_dir = self.workspace_path / "generated_plans"
#         self.output_dir.mkdir(exist_ok=True)

#         self.delays = {
#             'plan_generation': 50,
#             'monitor_interval': 3,
#             'max_attempts': 10
#         }

#     def execute(self):
#         print("🚀 Iniciando proceso de planificación PDDL")
#         print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

#         if not self._verify_files():
#             return False
#         if not self._run_tfd_planner():
#             return False
#         plan_path = self._capture_and_save_plan()
#         if plan_path:
#             print(f"✅ Plan generado: {plan_path}")
#             self._display_clean_plan(plan_path)
#             return True
#         print("❌ No se pudo generar el plan")
#         return False

#     def _verify_files(self):
#         print(f"📄 Dominio : {self.domain_path}")
#         print(f"📄 Problema: {self.problem_path}")
#         if not self.domain_path.exists():
#             print("❌ Archivo de dominio no encontrado.")
#             return False
#         if not self.problem_path.exists():
#             print("❌ Archivo de problema no encontrado.")
#             return False
#         return True

#     def _run_tfd_planner(self):
#         try:
#             with open(self.domain_path, 'r', encoding='utf-8') as f:
#                 domain_content = f.read()
#             with open(self.problem_path, 'r', encoding='utf-8') as f:
#                 problem_content = f.read()

#             url = "https://solver.planning.domains:5001/package/optic/solve"
#             payload = {"domain": domain_content, "problem": problem_content}
#             print("⚙️ Enviando solicitud al solver...")
#             resp = requests.post(url, json=payload, timeout=self.delays['plan_generation'])
#             if resp.status_code != 200:
#                 print(f"❌ Error en POST: {resp.status_code}")
#                 return False

#             data = resp.json()
#             check_url = data.get("result", "")
#             if not isinstance(check_url, str) or not check_url.startswith("/check/"):
#                 print("❌ Respuesta inicial inválida.")
#                 return False
#             check_url = f"https://solver.planning.domains:5001{check_url}"

#             for attempt in range(self.delays['max_attempts']):
#                 r = requests.get(check_url, timeout=self.delays['plan_generation'])
#                 if r.status_code != 200:
#                     print(f"❌ Error al verificar: {r.status_code}")
#                     return False
#                 jr = r.json()
#                 if jr.get("status") == "ok" and 'output' in jr.get('result', {}):
#                     self._planner_response = jr
#                     return True
#                 time.sleep(self.delays['monitor_interval'])
#             print("❌ Se alcanzó el máximo de intentos sin obtener plan.")
#             return False
#         except Exception as e:
#             print(f"❌ Error en la comunicación: {e}")
#             return False

#     def _capture_and_save_plan(self):
#         try:
#             result = self._planner_response.get('result', {})
#             output = result.get('output', {})
#             if isinstance(output, list) and output:
#                 output = output[0]
#             plan_text = output.get('plan', '') if isinstance(output, dict) else ''

#             if not plan_text or 'Found new plan' not in plan_text:
#                 print("❌ No se encontró plan en la respuesta.")
#                 return None

#             plan_content = self._extract_plan(plan_text)
#             if plan_content:
#                 return self._save_clean_plan(plan_content)
#             return None
#         except Exception as e:
#             print(f"⚠️ Error al procesar plan: {e}")
#             return None

#     def _extract_plan(self, log_content):
#         # Extrae bloque después de "Found new plan:"
#         m = re.search(r"Found new plan:(.*?)(?:Solution with|Search time:|$)",
#                       log_content, re.DOTALL | re.IGNORECASE)
#         if not m:
#             print("❌ No se encontró bloque de plan.")
#             return None
#         block = m.group(1).strip()
#         actions = "\n".join(l for l in block.splitlines() if re.match(r"^\d", l))
#         metric_match = re.search(r"Makespan\s*:\s*([\d\.]+)", log_content)
#         if metric_match:
#             actions = f"; Makespan: {metric_match.group(1)}\n" + actions
#         return self._clean_plan_text(actions)

#     def _clean_plan_text(self, plan_text):
#         cleaned = []
#         seen = set()
#         for line in plan_text.splitlines():
#             line = line.strip()
#             if line.startswith(";"):
#                 cleaned.append(line)
#                 continue
#             m = re.match(r"^(\d+\.\d+):\s*(.*?)\s*(\[\d+\.\d+\])?$", line)
#             if m:
#                 t = float(m.group(1))
#                 action = m.group(2).strip()
#                 dur = m.group(3) if m.group(3) else "[0.0]"
#                 if action not in seen:
#                     cleaned.append(f"{t:.3f}: {action} {dur}")
#                     seen.add(action)
#         return "\n".join(cleaned)

#     def _save_clean_plan(self, plan_content):
#         filename = f"plan_{datetime.now().strftime('%Y%m%d_%H%M%S')}.pddl"
#         path = self.output_dir / filename
#         with open(path, "w", encoding="utf-8") as f:
#             f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
#             f.write(f"; Dominio: {self.domain_path.name}\n")
#             f.write(f"; Problema: {self.problem_path.name}\n\n")
#             f.write(plan_content)
#         return path

#     def _display_clean_plan(self, plan_path):
#         print("\n" + "="*50)
#         print("PLAN LIMPIO")
#         print("="*50)
#         with open(plan_path, "r", encoding="utf-8") as f:
#             print(f.read())
#         print("="*50 + "\n")


# if __name__ == "__main__":
#     executor = PDDLExecutor(DOMAIN_PATH, PROBLEM_PATH, WORKSPACE_PATH)
#     executor.execute()



# import os
# from pathlib import Path
# import requests
# import re
# import time
# from datetime import datetime
# import json

# domain_path= "/home/cristian/PDDL-DA/PDDL-pruebas2/dominio.pddl"
# problem_path= "/home/cristian/PDDL-DA/PDDL-pruebas2/problem.pddl"
# workspace_path= "."   # Carpeta donde se guardará generated_plans
# # =========================================


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

#     def execute_optic(self):
#         print("🚀 Iniciando proceso de planificación PDDL con OPTIC")
#         print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

#         if not self._check_files():
#             return False

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
#                 return False

#             try:
#                 initial_response = response.json()
#             except json.JSONDecodeError:
#                 print("❌ No se pudo parsear la respuesta inicial como JSON")
#                 return False

#             check_url = initial_response.get('result', '')
#             if not check_url.startswith('/check/'):
#                 print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
#                 return False

#             check_url = f"https://solver.planning.domains:5001{check_url}"
#             plan_data = self._poll_for_plan(check_url)
#             if plan_data:
#                 plan_path = self._save_plan(plan_data)
#                 if plan_path:
#                     self._display_plan(plan_path)
#                     return True
#             return False

#         except Exception as e:
#             print(f"❌ Error crítico: {e}")
#             return False

#     def _check_files(self):
#         if not self.domain_path.exists():
#             print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
#             return False
#         if not self.problem_path.exists():
#             print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
#             return False
#         return True

#     def _poll_for_plan(self, check_url):
#         for attempt in range(self.delays['max_attempts']):
#             try:
#                 response = requests.get(check_url, timeout=self.delays['plan_generation'])
#                 if response.status_code != 200:
#                     print(f"❌ Error en la verificación: {response.status_code}")
#                     return None
#                 data = response.json()
#                 if data.get('status') == 'ok' and 'output' in data.get('result', {}):
#                     plan_text = data['result']['output'].get('plan', '')
#                     if plan_text:
#                         return plan_text
#             except Exception as e:
#                 print(f"⚠️ Intento {attempt+1} fallo: {e}")
#             time.sleep(self.delays['monitor_interval'])
#         print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
#         return None

#     def _save_plan(self, plan_text):
#         plan_clean = self._clean_plan(plan_text)
#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         plan_file = self.output_dir / f"plan_optic_{timestamp}.pddl"
#         try:
#             with open(plan_file, 'w', encoding='utf-8') as f:
#                 f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
#                 f.write(f"; Dominio: {self.domain_path.name}\n")
#                 f.write(f"; Problema: {self.problem_path.name}\n\n")
#                 f.write(plan_clean)
#             print(f"✅ Plan guardado en: {plan_file}")
#             return plan_file
#         except Exception as e:
#             print(f"❌ Error al guardar plan: {e}")
#             return None

#     def _clean_plan(self, plan_text):
#         cleaned_lines = []
#         for line in plan_text.splitlines():
#             line = line.strip()
#             if line and re.match(r"^\d+\.\d+", line):
#                 cleaned_lines.append(line)
#         return "\n".join(cleaned_lines)

#     def _display_plan(self, plan_path):
#         print("\n" + "="*50)
#         print("PLAN LIMPIO:")
#         print("="*50)
#         with open(plan_path, 'r', encoding='utf-8') as f:
#             print(f.read())
#         print("="*50 + "\n")

# if __name__ == "__main__":
#     workspace = "/home/cristian/PDDL-DA"
#     executor = PDDLExecutor(domain_path, problem_path, workspace)
#     executor.execute_optic()



# import os
# from pathlib import Path
# import requests
# import re
# import time
# from datetime import datetime
# import json

# # ============================
# domain_path = "/home/cristian/PDDL-DA/PDDL-pruebas2/dominio.pddl"
# problem_path = "/home/cristian/PDDL-DA/PDDL-pruebas2/problem.pddl"
# workspace_path = "."   # Carpeta donde se guardará generated_plans
# # ============================

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

#     def execute_optic(self):
#         print("🚀 Iniciando planificación PDDL con OPTIC")
#         print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

#         if not self._check_files():
#             return False

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
#                 return False

#             try:
#                 initial_response = response.json()
#             except json.JSONDecodeError:
#                 print("❌ No se pudo parsear la respuesta inicial como JSON")
#                 return False

#             check_url = initial_response.get('result', '')
#             if not check_url.startswith('/check/'):
#                 print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
#                 return False

#             check_url = f"https://solver.planning.domains:5001{check_url}"
#             plan_text = self._poll_for_plan(check_url)

#             if plan_text:
#                 best_plan = self._select_best_plan(plan_text)
#                 if best_plan:
#                     plan_path = self._save_plan(best_plan)
#                     if plan_path:
#                         self._display_plan(plan_path)
#                         return True

#             print("❌ No se encontró un plan válido")
#             return False

#         except Exception as e:
#             print(f"❌ Error crítico: {e}")
#             return False

#     def _check_files(self):
#         if not self.domain_path.exists():
#             print(f"❌ Archivo de dominio no encontrado: {self.domain_path}")
#             return False
#         if not self.problem_path.exists():
#             print(f"❌ Archivo de problema no encontrado: {self.problem_path}")
#             return False
#         return True

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
#                     # Puede estar en 'plan' o 'stdout'
#                     if isinstance(output, dict):
#                         plan_text = output.get('plan') or output.get('stdout', '')
#                     else:
#                         plan_text = str(output)
#                     if plan_text:
#                         return plan_text
#             except Exception as e:
#                 print(f"⚠️ Intento {attempt+1} fallo: {e}")
#             time.sleep(self.delays['monitor_interval'])
#         print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
#         return None

#     # def _select_best_plan(self, log_content):
#     #     """
#     #     Extrae todos los planes y selecciona el de menor Metric positivo (excluyendo Metric = 0).
#     #     Si no hay métricas válidas, retorna None.
#     #     """
#     #     print("=== Contenido completo del log recibido ===")
#     #     print(log_content)
#     #     print("======================================")
        
#     #     # Dividir los bloques de planes
#     #     plan_blocks = re.split(r"(?:Found new plan|Plan found|Rescheduled Plan|New Plan)\s*:", log_content, flags=re.IGNORECASE)
#     #     print(f"Total de bloques de planes encontrados: {len(plan_blocks)}")
        
#     #     best_plan = None
#     #     best_metric = float('inf')
        
#     #     for i, block in enumerate(plan_blocks):
#     #         print(f"--- Bloque {i} ---")
#     #         print(block)
#     #         print("-----------------")
            
#     #         # Extraer solo las líneas de acciones
#     #         actions = "\n".join(line.strip() for line in block.splitlines() if re.match(r"^\d+\.\d+", line))
#     #         if not actions:
#     #             print(f"Bloque {i}: No se encontraron acciones válidas")
#     #             continue
            
#     #         # Intentar obtener Metric
#     #         metric_match = re.search(r"Metric[:=]\s*([-\d.]+)", block, re.IGNORECASE)
#     #         metric_value = float(metric_match.group(1)) if metric_match else None
#     #         print(f"Bloque {i}: Metric encontrada = {metric_value}")
            
#     #         # Filtrar métricas inválidas o cero
#     #         if metric_value is None or metric_value == 0:
#     #             print(f"Bloque {i}: Metric inválida o cero, descartado")
#     #             continue
            
#     #         # Seleccionar el plan con la menor métrica positiva
#     #         if metric_value < best_metric:
#     #             print(f"Bloque {i}: Nueva mejor métrica = {metric_value}")
#     #             best_metric = metric_value
#     #             best_plan = actions
        
#     #     if best_plan:
#     #         print(f"✅ Plan seleccionado con Metric: {best_metric}")
#     #         return self._clean_plan(best_plan)
        
#     #     print("⚠️ No se encontró plan válido con métrica positiva")
#     #     return None

#     def _select_best_plan(self, log_content):
#         """
#         Extrae todos los planes y selecciona el de menor Metric positivo (excluyendo Metric = 0).
#         Si no hay métricas válidas, retorna None.
#         """
#         print("=== Contenido completo del log recibido ===")
#         print(log_content)
#         print("======================================")
        
#         # Dividir el log usando las líneas que indican un nuevo plan
#         plan_blocks = re.split(r";\s*Plan found with metric\s+[\d.]+", log_content, flags=re.IGNORECASE)
        
#         # Extraer las métricas de las líneas divisoras
#         metric_matches = list(re.finditer(r";\s*Plan found with metric\s+([\d.]+)", log_content, re.IGNORECASE))
        
#         print(f"Total de bloques de planes encontrados: {len(plan_blocks)}")
#         print(f"Total de métricas encontradas: {len(metric_matches)}")
        
#         best_plan = None
#         best_metric = float('inf')
        
#         # Asegurarse de que los bloques y métricas estén alineados
#         for i, (block, metric_match) in enumerate(zip(plan_blocks[1:], metric_matches)):
#             print(f"--- Bloque {i} ---")
#             print(block)
#             print("-----------------")
            
#             # Extraer solo las líneas de acciones
#             actions = "\n".join(line.strip() for line in block.splitlines() if re.match(r"^\d+\.\d+:", line))
#             if not actions:
#                 print(f"Bloque {i}: No se encontraron acciones válidas")
#                 continue
            
#             # Obtener la métrica del bloque
#             metric_value = float(metric_match.group(1)) if metric_match else None
#             print(f"Bloque {i}: Metric encontrada = {metric_value}")
            
#             # Filtrar métricas inválidas o cero
#             if metric_value is None or metric_value == 0:
#                 print(f"Bloque {i}: Metric inválida o cero, descartado")
#                 continue
            
#             # Seleccionar el plan con la menor métrica positiva
#             if metric_value < best_metric:
#                 print(f"Bloque {i}: Nueva mejor métrica = {metric_value}")
#                 best_metric = metric_value
#                 best_plan = actions
        
#         if best_plan:
#             print(f"✅ Plan seleccionado con Metric: {best_metric}")
#             return self._clean_plan(best_plan)
        
#         print("⚠️ No se encontró plan válido con métrica positiva")
#         return None

#     def _clean_plan(self, plan_text):
#         cleaned_lines = []
#         seen_actions = set()
#         for line in plan_text.splitlines():
#             line = line.strip()
#             if line and re.match(r"^\d+\.\d+", line):
#                 time_match = re.match(r'^(\d+\.\d+):\s*(.*?)\s*(\[\d+\.\d+\])?$', line)
#                 if time_match:
#                     time_prefix = float(time_match.group(1))
#                     action = time_match.group(2).strip()
#                     duration = time_match.group(3) if time_match.group(3) else '[0.0]'
#                     duration_value = float(duration[1:-1]) if duration else 0.0
#                     # Evitar duplicados
#                     if (time_prefix, action) not in seen_actions:
#                         formatted_line = f"{time_prefix:.5f}: {action} [{duration_value:.5f}]"
#                         cleaned_lines.append(formatted_line)
#                         seen_actions.add((time_prefix, action))
#         return "\n".join(cleaned_lines)

#     def _save_plan(self, plan_text):
#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         plan_file = self.output_dir / f"plan_optic_{timestamp}.pddl"
#         try:
#             with open(plan_file, 'w', encoding='utf-8') as f:
#                 f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
#                 f.write(f"; Dominio: {self.domain_path.name}\n")
#                 f.write(f"; Problema: {self.problem_path.name}\n\n")
#                 f.write(plan_text)
#             print(f"✅ Plan guardado en: {plan_file}")
#             return plan_file
#         except Exception as e:
#             print(f"❌ Error al guardar plan: {e}")
#             return None

#     def _display_plan(self, plan_path):
#         print("\n" + "="*50)
#         print("PLAN LIMPIO:")
#         print("="*50)
#         with open(plan_path, 'r', encoding='utf-8') as f:
#             print(f.read())
#         print("="*50 + "\n")


# if __name__ == "__main__":
#     executor = PDDLExecutor(domain_path, problem_path, workspace_path)
#     executor.execute_optic()





import os
from pathlib import Path
import requests
import re
import time
from datetime import datetime
import json

# ============================
domain_path = "/home/cristian/PDDL-DA/PDDL-pruebas2/dominio.pddl"
problem_path = "/home/cristian/PDDL-DA/PDDL-pruebas2/problem.pddl"
workspace_path = "."   # Carpeta donde se guardará generated_plans
# ============================

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

    def execute(self):
        print("🚀 Iniciando planificación PDDL con OPTIC")
        print("🔍 Usando servicio: https://solver.planning.domains:5001/package/optic/solve")

        if not self._check_files():
            return False

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
                return False

            try:
                initial_response = response.json()
            except json.JSONDecodeError:
                print("❌ No se pudo parsear la respuesta inicial como JSON")
                return False

            check_url = initial_response.get('result', '')
            if not check_url.startswith('/check/'):
                print(f"❌ Respuesta inicial no contiene URL de verificación: {initial_response}")
                return False

            check_url = f"https://solver.planning.domains:5001{check_url}"
            plan_text = self._poll_for_plan(check_url)

            if plan_text:
                best_plan = self._select_best_plan(plan_text)
                if best_plan:
                    plan_path = self._save_plan(best_plan, plan_text)
                    if plan_path:
                        self._display_plan(plan_path)
                        return True

            print("❌ No se encontró un plan válido")
            return False

        except Exception as e:
            print(f"❌ Error crítico: {e}")
            return False

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
                    # Puede estar en 'plan' o 'stdout'
                    if isinstance(output, dict):
                        plan_text = output.get('plan') or output.get('stdout', '')
                    else:
                        plan_text = str(output)
                    if plan_text:
                        return plan_text
            except Exception as e:
                print(f"⚠️ Intento {attempt+1} fallo: {e}")
            time.sleep(self.delays['monitor_interval'])
        print(f"❌ No se obtuvo plan después de {self.delays['max_attempts']} intentos")
        return None

    def _select_best_plan(self, log_content):
        """
        Extrae todos los planes y selecciona el de menor Metric positivo (excluyendo Metric = 0).
        Retorna las acciones del plan limpio y la información adicional solicitada.
        """
        # Dividir el log usando las líneas que indican un nuevo plan
        plan_blocks = re.split(r";\s*Plan found with metric\s+[\d.]+", log_content, flags=re.IGNORECASE)
        metric_matches = list(re.finditer(r";\s*Plan found with metric\s+([\d.]+)", log_content, re.IGNORECASE))
        
        best_plan = None
        best_metric = float('inf')
        
        # Asegurarse de que los bloques y métricas estén alineados
        for block, metric_match in zip(plan_blocks[1:], metric_matches):
            # Extraer solo las líneas de acciones
            actions = "\n".join(line.strip() for line in block.splitlines() if re.match(r"^\d+\.\d+:", line))
            if not actions:
                continue
            
            # Obtener la métrica del bloque
            metric_value = float(metric_match.group(1)) if metric_match else None
            
            # Filtrar métricas inválidas o cero
            if metric_value is None or metric_value == 0:
                continue
            
            # Seleccionar el plan con la menor métrica positiva
            if metric_value < best_metric:
                best_metric = metric_value
                best_plan = actions
        
        if best_plan:
            # Ya no extraemos información adicional del log
            return {
                "actions": best_plan,
                "metric": best_metric,
                "additional_info": ""   # clav
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
                # f.write(f"```\n{self._clean_plan(plan_data['actions'])}\n```\n\n")
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


if __name__ == "__main__":
    executor = PDDLExecutor(domain_path, problem_path, workspace_path)
    executor.execute()
