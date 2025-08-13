; Plan generado automáticamente - 2025-08-13 13:02:08.985975
; Dominio: cement-alimentacion.pddl
; Problema: cement_problem.pddl

0.00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco)
4.01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2)
Planning service: https://solver.planning.domains:5001/package/delfi/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Parsing pddl.....
==== Computing an abstract structure graph from the lifted task description... ====
Graph computation returned nonzero exitcode 1
==== Computing abstract structure graph failed, using fallback planner! ====
==== Running fallback planner... ====
Running planner, call string: ['/usr/bin/python', '/workspace/delfi/fast-downward.py', '--transform-task', 'preprocess', '--build', 'release64', '--search-memory-limit', '7600M', '--plan-file', 'plan', 'domain', 'problem', '--symmetries', 'sym=structural_symmetries(search_symmetries=dks)', '--search', 'astar(celmcut,symmetries=sym,pruning=stubborn_sets_simple(minimum_pruning_ratio=0.01),num_por_probes=1000)']
INFO     Running translator.
INFO     translator input: ['domain', 'problem']
INFO     translator arguments: []
INFO     translator time limit: None
INFO     translator memory limit: None
INFO     callstring: /usr/bin/python /workspace/delfi/builds/release64/bin/translate/translate.py domain problem
Parsing...
Command '['/usr/bin/python', '/workspace/delfi/builds/release64/bin/translate/translate.py', 'domain', 'problem']' returned non-zero exit status 1
Overall time: [0.050s CPU, 0.062s wall-clock]
==== Done running fallback planner. ====
Error: Using TensorFlow backend.
Error: Could not parse domain file: domain
Reason: Unexpected token: temporal..
Error: Could not parse domain file: domain
Reason: Unexpected token: temporal..
Planner output: {}No plan found in the planner output.
Planning service: https://solver.planning.domains:5001/package/delfi/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Parsing pddl.....
==== Computing an abstract structure graph from the lifted task description... ====
Graph computation returned nonzero exitcode 1
==== Computing abstract structure graph failed, using fallback planner! ====
==== Running fallback planner... ====
Running planner, call string: ['/usr/bin/python', '/workspace/delfi/fast-downward.py', '--transform-task', 'preprocess', '--build', 'release64', '--search-memory-limit', '7600M', '--plan-file', 'plan', 'domain', 'problem', '--symmetries', 'sym=structural_symmetries(search_symmetries=dks)', '--search', 'astar(celmcut,symmetries=sym,pruning=stubborn_sets_simple(minimum_pruning_ratio=0.01),num_por_probes=1000)']
INFO     Running translator.
INFO     translator input: ['domain', 'problem']
INFO     translator arguments: []
INFO     translator time limit: None
INFO     translator memory limit: None
INFO     callstring: /usr/bin/python /workspace/delfi/builds/release64/bin/translate/translate.py domain problem
Parsing...
Command '['/usr/bin/python', '/workspace/delfi/builds/release64/bin/translate/translate.py', 'domain', 'problem']' returned non-zero exit status 1
Overall time: [0.050s CPU, 0.060s wall-clock]
==== Done running fallback planner. ====
Error: Using TensorFlow backend.
Error: Could not parse domain file: domain
Reason: Unexpected token: temporal..
Error: Could not parse domain file: domain
Reason: Unexpected token: temporal..
Planner output: {}No plan found in the planner output.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem