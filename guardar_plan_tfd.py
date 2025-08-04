import subprocess
import datetime
import os

# 🔹 Ruta a tu ejecutable de Fast Downward (ajusta si está en otra carpeta)
FAST_DOWNWARD = r"C:\Users\User\downward\builds\release\bin\downward.exe"

# 🔹 Rutas a tus archivos PDDL
DOMAIN = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA\cement-alimentacion.pddl"
PROBLEM = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA\cement_problem.pddl"

# 🔹 Carpeta donde guardar los planes
OUTPUT_DIR = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA\planes-generados"

def ejecutar_tfd():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    plan_name = f"plan_{timestamp}.plan"
    output_name = f"output_{timestamp}.txt"

    cmd = [
        FAST_DOWNWARD,
        "--alias", "seq-sat-lama-2011",
        DOMAIN,
        PROBLEM
    ]

    print("🚀 Ejecutando Temporal Fast Downward...")
    proc = subprocess.run(cmd, capture_output=True, text=True)

    # Guardar salida completa
    with open(os.path.join(OUTPUT_DIR, output_name), "w", encoding="utf-8") as f:
        f.write(proc.stdout)
        if proc.stderr:
            f.write("\n--- ERRORES ---\n")
            f.write(proc.stderr)

    # Si se generó "sas_plan", lo renombramos con timestamp
    if os.path.exists("sas_plan"):
        os.rename("sas_plan", os.path.join(OUTPUT_DIR, plan_name))
        print(f"✅ Plan guardado como {plan_name}")
    else:
        print("⚠️ No se generó ningún plan. Revisa el archivo de salida.")

if __name__ == "__main__":
    ejecutar_tfd()
