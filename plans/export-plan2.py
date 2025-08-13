#!/usr/bin/env python3
"""
Script para automatizar la extracción de planes PDDL desde VS Code
"""

import os
import sys
import json
import time
import subprocess
import argparse
from pathlib import Path
from datetime import datetime
import re

class PDDLPlanExtractor:
    def __init__(self, workspace_path, output_dir="plans"):
        self.workspace_path = Path(workspace_path)
        self.output_dir = self.workspace_path / output_dir
        self.output_dir.mkdir(exist_ok=True)
        
    def extract_plan_from_output(self, output_text):
        """
        Extrae el plan del texto de salida del planificador
        """
        # Buscar patrones comunes de salida de planificadores
        plan_patterns = [
            r"Plan found:(.*?)(?:Plan length:|$)",
            r"Solution:(.*?)(?:; cost|; time|$)",
            r"SOLUTION FOUND:(.*?)(?:total-cost|$)"
        ]
        
        for pattern in plan_patterns:
            match = re.search(pattern, output_text, re.DOTALL | re.IGNORECASE)
            if match:
                plan_text = match.group(1).strip()
                return self.clean_plan_text(plan_text)
        
        return None
    
    def clean_plan_text(self, plan_text):
        """
        Limpia y formatea el texto del plan
        """
        lines = plan_text.split('\n')
        cleaned_lines = []
        
        for line in lines:
            line = line.strip()
            if line and not line.startswith(';') and not line.startswith(';;'):
                # Remover números de pasos si existen
                line = re.sub(r'^\d+:\s*', '', line)
                line = re.sub(r'^\d+\.\s*', '', line)
                cleaned_lines.append(line)
        
        return '\n'.join(cleaned_lines)
    
    def monitor_vscode_output(self):
        """
        Monitorea la salida de VS Code para detectar nuevos planes
        """
        print("Monitoreando salida de VS Code...")
        
        # Directorio de logs de VS Code (puede variar según el sistema)
        vscode_logs_dirs = [
            os.path.expanduser("~/.config/Code/logs"),
            os.path.expanduser("~/Library/Application Support/Code/logs"),
            os.path.expanduser("~/AppData/Roaming/Code/logs")
        ]
        
        vscode_logs_dir = None
        for logs_dir in vscode_logs_dirs:
            if os.path.exists(logs_dir):
                vscode_logs_dir = logs_dir
                break
        
        if not vscode_logs_dir:
            print("No se pudo encontrar el directorio de logs de VS Code")
            return
        
        # Buscar archivo de log más reciente
        log_files = []
        for root, dirs, files in os.walk(vscode_logs_dir):
            for file in files:
                if 'output' in file.lower() or 'console' in file.lower():
                    log_files.append(os.path.join(root, file))
        
        if not log_files:
            print("No se encontraron archivos de log")
            return
        
        # Monitorear el archivo más reciente
        latest_log = max(log_files, key=os.path.getmtime)
        print(f"Monitoreando: {latest_log}")
        
        last_size = 0
        while True:
            try:
                current_size = os.path.getsize(latest_log)
                if current_size > last_size:
                    with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
                        f.seek(last_size)
                        new_content = f.read()
                    
                    plan = self.extract_plan_from_output(new_content)
                    if plan:
                        self.save_plan(plan)
                    
                    last_size = current_size
                
                time.sleep(1)  # Verificar cada segundo
            except KeyboardInterrupt:
                print("\nMonitoreo detenido por el usuario")
                break
            except Exception as e:
                print(f"Error en monitoreo: {e}")
                time.sleep(5)
    
    def save_plan(self, plan_content):
        """
        Guarda el plan en un archivo con timestamp
        """
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"plan_{timestamp}.pddl"
        filepath = self.output_dir / filename
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(f"; Plan generado automáticamente - {datetime.now()}\n")
                f.write(f"; Archivo: {filename}\n\n")
                f.write(plan_content)
            
            print(f"Plan guardado: {filepath}")
            return filepath
        except Exception as e:
            print(f"Error al guardar plan: {e}")
            return None
    
    def extract_from_terminal_output(self, command_output):
        """
        Extrae plan directamente de la salida de un comando de terminal
        """
        plan = self.extract_plan_from_output(command_output)
        if plan:
            return self.save_plan(plan)
        return None

def main():
    parser = argparse.ArgumentParser(description="Automatiza la extracción de planes PDDL")
    parser.add_argument("workspace", help="Ruta del workspace de VS Code")
    parser.add_argument("--output", "-o", default="plans", 
                       help="Directorio de salida para los planes")
    parser.add_argument("--monitor", "-m", action="store_true",
                       help="Modo monitoreo continuo")
    parser.add_argument("--command", "-c", help="Comando directo para extraer plan")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.workspace):
        print(f"Error: El workspace {args.workspace} no existe")
        return 1
    
    extractor = PDDLPlanExtractor(args.workspace, args.output)
    
    if args.command:
        # Ejecutar comando y extraer plan de la salida
        try:
            result = subprocess.run(args.command, shell=True, 
                                  capture_output=True, text=True)
            output = result.stdout + result.stderr
            extractor.extract_from_terminal_output(output)
        except Exception as e:
            print(f"Error ejecutando comando: {e}")
            return 1
    elif args.monitor:
        # Modo monitoreo
        extractor.monitor_vscode_output()
    else:
        print("Especifica --monitor para modo continuo o --command para extracción directa")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())