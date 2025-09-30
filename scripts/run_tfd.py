import subprocess
import os
import sys

# Rutas de tus archivos PDDL
domain_file = "/home/cristian/PDDL-DA/PDDL/cement-alimentacion.pddl"
problem_file = "/home/cristian/PDDL-DA/PDDL/cement_problem.pddl"
output_file = "/home/cristian/PDDL-DA/plan_output.txt"

# Carpeta del planner
planner_dir = "/home/cristian/PDDL-DA/TemporalFastDownward/downward"

# Copiar archivos al directorio del planner con nombres estándar
domain_dest = os.path.join(planner_dir, "domain.pddl")
problem_dest = os.path.join(planner_dir, "problem.pddl")

subprocess.run(["cp", domain_file, domain_dest], check=True)
subprocess.run(["cp", problem_file, problem_dest], check=True)

# Ejecutar Temporal Fast Downward
cmd = [
    "python3",
    os.path.join(planner_dir, "plan.py"),
    "tfd()",
    "domain.pddl",
    "problem.pddl",
    output_file
]

try:
    subprocess.run(cmd, cwd=planner_dir, check=True)
    print(f"Plan generado correctamente en: {output_file}")
except subprocess.CalledProcessError as e:
    print("Error al ejecutar el planner:")
    print(e)
