# #!/bin/bash

# # Configuración
# PLANNER="/home/cristian/Descargas/planners64/planners/optic-30s"
# BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# # Rutas
# CLINKER_DOMAIN="$BASE_DIR/clinkers/domain-clinker-pretrit.pddl"
# CLINKER_PROBLEM="$BASE_DIR/clinkers/problem-clinker-pretrit.pddl"
# PUZOLANA_DOMAIN="$BASE_DIR/pz-yesos/domain-puzolana-yeso.pddl"  # O domain-puzolana-yeso.pddl
# PUZOLANA_PROBLEM="$BASE_DIR/pz-yesos/problem-puzolana-yeso.pddl" # O problem-puzolana-yeso.pddl

# # Salidas
# PLAN_CLINKER="$BASE_DIR/planes/plan-clinker.txt"
# PLAN_PUZOLANA="$BASE_DIR/planes/plan-puzolana.txt"
# PLAN_FINAL="$BASE_DIR/planes/plan-final.txt"

# echo "═══════════════════════════════════════════"
# echo "  🏭 PLANIFICACIÓN PARALELA CEMENTERA"
# echo "═══════════════════════════════════════════"
# echo ""
# echo "📂 Directorio base: $BASE_DIR"
# echo ""

# # Verificar archivos
# echo "🔍 Verificando archivos..."
# if [ ! -f "$CLINKER_DOMAIN" ]; then
#     echo "❌ No encontrado: $CLINKER_DOMAIN"
#     exit 1
# fi
# if [ ! -f "$PUZOLANA_DOMAIN" ]; then
#     echo "❌ No encontrado: $PUZOLANA_DOMAIN"
#     exit 1
# fi
# echo "✅ Todos los archivos encontrados"
# echo ""

# # Ejecutar planificadores
# echo "▶️  Ejecutando planificadores en paralelo..."
# echo ""

# echo "   ⏳ [1/2] Clinkers..."
# $PLANNER "$CLINKER_DOMAIN" "$CLINKER_PROBLEM" > "$PLAN_CLINKER" 2>&1 &
# PID1=$!

# echo "   ⏳ [2/2] Puzolanas/Yesos..."
# $PLANNER "$PUZOLANA_DOMAIN" "$PUZOLANA_PROBLEM" > "$PLAN_PUZOLANA" 2>&1 &
# PID2=$!

# echo ""
# echo "   PIDs: Clinkers=$PID1, Puzolanas=$PID2"
# echo ""

# # Esperar resultados
# wait $PID1
# STATUS1=$?
# echo "   ✓ Clinkers terminado (exit: $STATUS1)"

# wait $PID2
# STATUS2=$?
# echo "   ✓ Puzolanas terminado (exit: $STATUS2)"

# echo ""

# # Verificar éxito
# if [ $STATUS1 -ne 0 ] || [ $STATUS2 -ne 0 ]; then
#     echo "❌ Error en uno o ambos planificadores"
#     [ $STATUS1 -ne 0 ] && echo "   → Revisa: $PLAN_CLINKER"
#     [ $STATUS2 -ne 0 ] && echo "   → Revisa: $PLAN_PUZOLANA"
#     exit 1
# fi

# # Verificar que se generaron planes
# if ! grep -q "Plan found" "$PLAN_CLINKER" 2>/dev/null; then
#     echo "❌ Clinkers no generó plan válido"
#     exit 1
# fi

# if ! grep -q "Plan found" "$PLAN_PUZOLANA" 2>/dev/null; then
#     echo "❌ Puzolanas no generó plan válido"
#     exit 1
# fi

# echo "✅ Ambos planes generados exitosamente"
# echo ""

# # Combinar planes
# COMBINE_SCRIPT="$BASE_DIR/scripts/combine_plans.py"

# if [ -f "$COMBINE_SCRIPT" ]; then
#     echo "▶️  Combinando planes..."
#     python3 "$COMBINE_SCRIPT" "$PLAN_CLINKER" "$PLAN_PUZOLANA" "$PLAN_FINAL"
    
#     if [ $? -eq 0 ]; then
#         echo ""
#         echo "═══════════════════════════════════════════"
#         echo "  ✅ ¡COMPLETADO!"
#         echo "═══════════════════════════════════════════"
#         echo ""
#         echo "📁 Planes generados en: planes/"
#         echo "   • plan-clinker.txt"
#         echo "   • plan-puzolana.txt"
#         echo "   • plan-final.txt  ← PLAN COMBINADO ✨"
#         echo ""
#         echo "👁️  Ver plan final:"
#         echo "   cat planes/plan-final.txt"
#     fi
# else
#     echo "⚠️  Script de combinación no encontrado"
#     echo "   Planes individuales en: planes/"
# fi


#!/bin/bash

PLANNER="/home/cristian/Descargas/planners64/planners/optic-30s-union"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Rutas
CLINKER_DOMAIN="$BASE_DIR/clinkers/domain-clinker-pretrit.pddl"
CLINKER_PROBLEM="$BASE_DIR/clinkers/problem-clinker-pretrit.pddl"
PUZOLANA_DOMAIN="$BASE_DIR/pz-yesos/domain-puzolana-yeso.pddl"
PUZOLANA_PROBLEM="$BASE_DIR/pz-yesos/problem-puzolana-yeso.pddl"

PLAN_CLINKER="$BASE_DIR/planes/plan-clinker.txt"
PLAN_PUZOLANA="$BASE_DIR/planes/plan-puzolana.txt"
PLAN_FINAL="$BASE_DIR/planes/plan-final.txt"

# Función para esperar a que un archivo esté completo
wait_for_file_ready() {
    local file=$1
    local max_wait=15  # 15 segundos máximo
    local count=0
    
    echo "      → Esperando a que $(basename $file) esté listo..."
    
    # Esperar a que el archivo exista
    while [ ! -f "$file" ] && [ $count -lt $max_wait ]; do
        sleep 1
        count=$((count + 1))
    done
    
    if [ ! -f "$file" ]; then
        echo "      ⚠️  Timeout: archivo no encontrado"
        return 1
    fi
    
    # Esperar a que contenga un plan válido
    count=0
    while [ $count -lt $max_wait ]; do
        # Verificar que tenga contenido
        local size=$(wc -l < "$file" 2>/dev/null || echo 0)
        
        if [ "$size" -gt 20 ]; then
            # Verificar que contenga un plan completo
            if grep -q "; States evaluated" "$file" 2>/dev/null; then
                echo "      ✓ Archivo listo: $size líneas"
                sleep 1  # Dar un segundo extra por seguridad
                return 0
            fi
        fi
        
        sleep 1
        count=$((count + 1))
    done
    
    echo "      ⚠️  Timeout: archivo sin plan válido ($(wc -l < "$file" 2>/dev/null || echo 0) líneas)"
    return 1
}


echo "═══════════════════════════════════════════"
echo "  🏭 PLANIFICACIÓN PARALELA CEMENTERA"
echo "═══════════════════════════════════════════"
echo ""

# Verificar archivos
echo "🔍 Verificando archivos..."
if [ ! -f "$CLINKER_DOMAIN" ] || [ ! -f "$PUZOLANA_DOMAIN" ] || [ ! -f "$PLANNER" ]; then
    echo "❌ Faltan archivos necesarios"
    exit 1
fi
echo "✅ Archivos encontrados"
echo ""

# Limpiar archivos antiguos
rm -f "$PLAN_CLINKER" "$PLAN_PUZOLANA" "$PLAN_FINAL"

# Ejecutar planificadores
echo "▶️  Ejecutando planificadores en paralelo..."
echo ""

echo "   ⏳ [1/2] Clinkers..."
"$PLANNER" "$CLINKER_DOMAIN" "$CLINKER_PROBLEM" "$PLAN_CLINKER" > /dev/null 2>&1 &
PID1=$!

echo "   ⏳ [2/2] Puzolanas..."
"$PLANNER" "$PUZOLANA_DOMAIN" "$PUZOLANA_PROBLEM" "$PLAN_PUZOLANA" > /dev/null 2>&1 &
PID2=$!

echo ""
echo "   PIDs: Clinkers=$PID1, Puzolanas=$PID2"
echo ""

# Esperar procesos
echo "   ⏳ Esperando finalización de procesos..."
wait $PID1
STATUS1=$?
echo "   ✓ Proceso Clinkers terminado (exit: $STATUS1)"

wait $PID2
STATUS2=$?
echo "   ✓ Proceso Puzolanas terminado (exit: $STATUS2)"

echo ""
echo "🔄 Sincronizando archivos de salida..."

# Esperar a que ambos archivos estén completamente escritos
wait_for_file_ready "$PLAN_CLINKER"
READY1=$?

wait_for_file_ready "$PLAN_PUZOLANA"
READY2=$?

echo ""

if [ $READY1 -ne 0 ] || [ $READY2 -ne 0 ]; then
    echo "❌ Error: Archivos no están listos"
    [ $READY1 -ne 0 ] && echo "   → Problema con: $PLAN_CLINKER"
    [ $READY2 -ne 0 ] && echo "   → Problema con: $PLAN_PUZOLANA"
    exit 1
fi

# Verificar contenido
echo "🔍 Verificando contenido..."

SIZE_CLINKER=$(wc -l < "$PLAN_CLINKER" 2>/dev/null || echo 0)
SIZE_PUZOLANA=$(wc -l < "$PLAN_PUZOLANA" 2>/dev/null || echo 0)
CLINKER_PLANS=$(grep -c "Plan found" "$PLAN_CLINKER" 2>/dev/null || echo 0)
PUZOLANA_PLANS=$(grep -c "Plan found" "$PLAN_PUZOLANA" 2>/dev/null || echo 0)

echo "   • plan-clinker.txt:  $SIZE_CLINKER líneas, $CLINKER_PLANS planes"
echo "   • plan-puzolana.txt: $SIZE_PUZOLANA líneas, $PUZOLANA_PLANS planes"
echo ""

if [ "$CLINKER_PLANS" -eq 0 ] || [ "$PUZOLANA_PLANS" -eq 0 ]; then
    echo "❌ Uno o ambos archivos no contienen planes válidos"
    [ "$CLINKER_PLANS" -eq 0 ] && echo "   → Ver: cat $PLAN_CLINKER"
    [ "$PUZOLANA_PLANS" -eq 0 ] && echo "   → Ver: cat $PLAN_PUZOLANA"
    exit 1
fi

echo "✅ Ambos archivos listos para combinar"
echo ""

# Combinar
COMBINE_SCRIPT="$BASE_DIR/scripts/combine_plans.py"

if [ -f "$COMBINE_SCRIPT" ]; then
    echo "▶️  Combinando planes..."
    python3 "$COMBINE_SCRIPT" "$PLAN_CLINKER" "$PLAN_PUZOLANA" "$PLAN_FINAL"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "═══════════════════════════════════════════"
        echo "  ✅ ¡COMPLETADO!"
        echo "═══════════════════════════════════════════"
        echo ""
        echo "📁 Resultados:"
        echo "   • plan-clinker.txt   → $SIZE_CLINKER líneas"
        echo "   • plan-puzolana.txt  → $SIZE_PUZOLANA líneas"
        echo "   • plan-final.txt     → COMBINADO ✨"
        echo ""
        echo "👁️  Ver plan final:"
        echo "   cat planes/plan-final.txt"
        echo ""
    else
        echo "❌ Error al combinar"
        exit 1
    fi
else
    echo "⚠️  Combinador no encontrado"
fi