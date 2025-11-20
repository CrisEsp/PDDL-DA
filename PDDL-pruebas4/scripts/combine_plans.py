# #!/usr/bin/env python3
# import sys
# from pathlib import Path

# def parse_final_plan(filename):
#     """Extrae SOLO el último plan válido del archivo OPTIC."""
#     path = Path(filename)
#     if not path.exists():
#         print(f"⚠️  No encontrado: {filename}")
#         return []
    
#     with open(path, 'r') as f:
#         lines = f.readlines()
    
#     # Buscar el último bloque que contenga información de costo/estados
#     # Formato típico:
#     # ; States evaluated: X
#     # ; Cost: Y
#     # ; Time Z
#     # 0.000: (action ...) [duration]
    
#     last_plan_start = -1
    
#     # Buscar de atrás hacia adelante
#     for i in range(len(lines) - 1, -1, -1):
#         line = lines[i].strip()
#         # Buscar el indicador de inicio de plan (estadísticas)
#         if '; States evaluated:' in line or '; Cost:' in line:
#             # Encontramos estadísticas, el plan está después
#             last_plan_start = i
#             break
    
#     if last_plan_start == -1:
#         print(f"⚠️  No se encontró plan en: {filename}")
#         return []
    
#     # Extraer acciones después de las estadísticas
#     actions = []
#     for i in range(last_plan_start, len(lines)):
#         line = lines[i].strip()
        
#         # Detener en ciertas líneas
#         if any(marker in line for marker in ['Process killing', 'Planner found', 'b (', '(G)']):
#             break
        
#         # Buscar acciones: 0.000: (action ...) [duration]
#         if ':' in line and '(' in line and ')' in line and '[' in line:
#             try:
#                 parts = line.split(':', 1)
#                 time_str = parts[0].strip()
#                 rest = parts[1].strip()
                
#                 # Extraer acción (hasta el último paréntesis)
#                 action_end = rest.rindex(')')
#                 action = rest[:action_end+1].strip()
                
#                 # Extraer duración
#                 duration_part = rest[action_end+1:].strip()
#                 duration_str = duration_part.replace('[', '').replace(']', '').strip()
                
#                 start = float(time_str)
#                 duration = float(duration_str) if duration_str else 0.0
                
#                 actions.append((start, action, duration))
            
#             except (ValueError, IndexError):
#                 continue
    
#     return actions

# def main():
#     if len(sys.argv) != 4:
#         print("Uso: python3 combine_plans.py <plan1> <plan2> <output>")
#         sys.exit(1)
    
#     plan1_file = sys.argv[1]
#     plan2_file = sys.argv[2]
#     output_file = sys.argv[3]
    
#     print(f"\n📖 Extrayendo SOLO el plan final de cada archivo...")
    
#     plan1 = parse_final_plan(plan1_file)
#     print(f"   ✓ Clinkers: {len(plan1)} acciones")
    
#     plan2 = parse_final_plan(plan2_file)
#     print(f"   ✓ Puzolanas: {len(plan2)} acciones")
    
#     if not plan1 and not plan2:
#         print("\n❌ No se encontraron acciones")
#         sys.exit(1)
    
#     # Combinar
#     combined = sorted(plan1 + plan2, key=lambda x: x[0])
    
#     # Guardar
#     with open(output_file, 'w') as f:
#         f.write("; Plan Combinado - Planificación Paralela\n")
#         f.write("; Solo el mejor plan de cada planificador\n")
#         f.write(f"; Clinkers: {len(plan1)} acciones\n")
#         f.write(f"; Puzolanas: {len(plan2)} acciones\n")
#         f.write(f"; Total: {len(combined)} acciones\n\n")
        
#         for start, action, duration in combined:
#             f.write(f"{start:.3f}: {action}  [{duration:.3f}]\n")
    
#     makespan = max(s + d for s, _, d in combined) if combined else 0
    
#     print(f"\n✅ Plan combinado guardado")
#     print(f"\n📊 Resumen:")
#     print(f"   • Clinkers: {len(plan1)} acciones")
#     print(f"   • Puzolanas: {len(plan2)} acciones")
#     print(f"   • Total: {len(combined)} acciones")
#     print(f"   • Makespan: {makespan:.3f}s\n")

# if __name__ == "__main__":

#     main()



#!/usr/bin/env python3
import sys
import re

def extract_unique_actions(filename):
    """Extrae SOLO las acciones del último plan, sin duplicados."""
    with open(filename, 'r') as f:
        lines = f.readlines()
    
    # Buscar el último bloque válido - probar múltiples marcadores
    last_plan_start = -1
    
    # Marcadores en orden de prioridad
    markers = [
        '; States evaluated:',     # Formato estándar
        '; States evaluated so far:',  # Formato alternativo
        '(G)',  # Marcador de goal encontrado
        '; Plan found with metric'  # Al menos un plan
    ]
    
    for marker in markers:
        for i in range(len(lines) - 1, -1, -1):
            if marker in lines[i]:
                last_plan_start = i
                break
        
        if last_plan_start != -1:
            print(f"   → Usando marcador: '{marker}' en línea {last_plan_start}")
            break
    
    if last_plan_start == -1:
        print(f"⚠️  No se encontró marcador de plan en: {filename}")
        # Como último recurso, buscar desde el principio
        last_plan_start = 0
    
    # Extraer TODAS las acciones desde ese punto
    actions_by_name = {}
    pattern = r'^(\d+\.\d+):\s*(\(.+?\))\s*\[(\d+\.\d+)\]'
    
    for i in range(last_plan_start, len(lines)):
        line = lines[i].strip()
        
        match = re.match(pattern, line)
        if match:
            time = float(match.group(1))
            action = match.group(2)
            duration = float(match.group(3))
            
            # Clave: SOLO la acción (sin tiempo)
            if action not in actions_by_name:
                actions_by_name[action] = (time, action, duration)
    
    # Retornar lista ordenada por tiempo
    return sorted(actions_by_name.values(), key=lambda x: x[0])

# Main
if len(sys.argv) != 4:
    print("❌ Uso: python3 combine_plans_simple.py <plan1> <plan2> <output>")
    sys.exit(1)

print("\n" + "="*60)
print("🔗 COMBINADOR DE PLANES (sin duplicados)")
print("="*60 + "\n")

# Extraer planes
print("📖 Extrayendo planes...")
print(f"\n[Plan 1: {sys.argv[1]}]")
plan1 = extract_unique_actions(sys.argv[1])
print(f"   ✓ Plan 1: {len(plan1)} acciones únicas")

print(f"\n[Plan 2: {sys.argv[2]}]")
plan2 = extract_unique_actions(sys.argv[2])
print(f"   ✓ Plan 2: {len(plan2)} acciones únicas")

if not plan1 and not plan2:
    print("\n❌ No se encontraron acciones\n")
    sys.exit(1)

# Combinar
combined = sorted(plan1 + plan2, key=lambda x: x[0])

# Eliminar duplicados ENTRE planes
final_actions = {}
for time, action, duration in combined:
    if action not in final_actions:
        final_actions[action] = (time, action, duration)

final_list = sorted(final_actions.values(), key=lambda x: x[0])

print(f"\n🔀 Combinando: {len(plan1)} + {len(plan2)} = {len(final_list)} acciones únicas")

# Guardar
with open(sys.argv[3], 'w') as f:
    f.write("; Plan Combinado - Planificación Paralela\n")
    f.write("; (Solo acciones únicas, sin repeticiones)\n")
    f.write(f"; Plan 1: {len(plan1)} acciones\n")
    f.write(f"; Plan 2: {len(plan2)} acciones\n")
    f.write(f"; Total: {len(final_list)} acciones\n\n")
    
    for t, a, d in final_list:
        f.write(f"{t:.3f}: {a}  [{d:.3f}]\n")

makespan = max(t + d for t, _, d in final_list) if final_list else 0

print(f"💾 Guardado en: {sys.argv[3]}")
print(f"\n📊 Resumen:")
print(f"   • Acciones plan 1: {len(plan1)}")
print(f"   • Acciones plan 2: {len(plan2)}")
print(f"   • Total único:     {len(final_list)}")
print(f"   • Makespan:        {makespan:.3f}s")
print("\n" + "="*60 + "\n")