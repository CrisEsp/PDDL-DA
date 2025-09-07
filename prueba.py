import subprocess
import json

domain_file = "/pddl/PDDL/cement-alimentacion.pddl"
problem_file = "/pddl/PDDL/cement_problem.pddl"

result = subprocess.run([
    "sudo", "docker", "run", "--rm",
    "-v", "/home/cristian/PDDL-DA:/pddl",
    "felixfi/pddl-planners",
    "tfd", domain_file, problem_file,
    "--format=json"
], capture_output=True, text=True ,timeout=60)

# Imprimir stdout y stderr para depuración
print("STDOUT:\n", result.stdout)
print("STDERR:\n", result.stderr)

# Intentar parsear JSON
try:
    plan = json.loads(result.stdout)
    print(json.dumps(plan, indent=2))
except json.JSONDecodeError:
    print("No se pudo decodificar JSON. Contenido de stdout:")
    print(result.stdout)
