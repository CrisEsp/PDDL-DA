import os
import sys

# Ruta del workspace
workspace = r"G:\Mi unidad\TRABAJO UNACEM 2025\PROYECTO HEURISTICO 2025\PDDL-DA"

print(f"Buscando archivos en: {workspace}")
print("="*50)

# Buscar todos los archivos
for root, dirs, files in os.walk(workspace):
    for file in files:
        if file.endswith(('.txt', '.out', '.plan', '.solution', '.log', '.pddl', '.html')):
            file_path = os.path.join(root, file)
            file_size = os.path.getsize(file_path)
            
            print(f"\nArchivo: {file}")
            print(f"Ruta: {file_path}")
            print(f"Tamaño: {file_size} bytes")
            
            # Leer y mostrar contenido
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Mostrar primeras líneas
                lines = content.split('\n')[:10]
                print("Contenido (primeras 10 líneas):")
                for i, line in enumerate(lines, 1):
                    print(f"  {i}: {line}")
                
                # Buscar líneas que parezcan acciones PDDL
                actions = []
                for line in content.split('\n'):
                    line = line.strip()
                    if line.startswith('(') and ')' in line and len(line) > 5:
                        actions.append(line)
                
                if actions:
                    print(f"Posibles acciones PDDL encontradas ({len(actions)}):")
                    for action in actions[:5]:
                        print(f"  -> {action}")
                    if len(actions) > 5:
                        print(f"  ... y {len(actions) - 5} más")
                else:
                    print("No se encontraron acciones PDDL evidentes")
                    
            except Exception as e:
                print(f"Error leyendo archivo: {e}")

print("\n" + "="*50)
print("Búsqueda completada")