; Plan generado automáticamente - 2025-08-13 12:43:18.765767
; Dominio: cement-alimentacion.pddl
; Problema: cement_problem.pddl

00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 4.253secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Error: mv: cannot stat 'variables.groups': No such file or directory
mv: cannot stat 'all.groups': No such file or directory
cat: 'output_plan*': No such file or directory
Plan found:
Metric: 0
Makespan: 0
States evaluated: undefined
Planner found 1 plan(s) in 3.973secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 4.416secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 3.709secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 5.06secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 3.394secs.
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
Overall time: [0.060s CPU, 0.068s wall-clock]
==== Done running fallback planner. ====
Error: Using TensorFlow backend.
Traceback (most recent call last):
File "/workspace/delfi/builds/release64/bin/translate/abstract_structure_module.py", line 547, in <module>
task = pddl_parser.open()
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/pddl_file.py", line 37, in open
return parsing_functions.parse_task(domain_pddl, task_pddl)
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/parsing_functions.py", line 308, in parse_task
= parse_domain_pddl(domain_pddl)
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/parsing_functions.py", line 360, in parse_domain_pddl
requirements = pddl.Requirements(opt[1:])
File "/workspace/delfi/builds/release64/bin/translate/pddl/tasks.py", line 70, in __init__
":derived-predicates", ":action-costs"), req
AssertionError: :durative-actions
Traceback (most recent call last):
File "/workspace/delfi/builds/release64/bin/translate/translate.py", line 753, in <module>
main()
File "/workspace/delfi/builds/release64/bin/translate/translate.py", line 730, in main
domain_filename=options.domain, task_filename=options.task)
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/pddl_file.py", line 37, in open
return parsing_functions.parse_task(domain_pddl, task_pddl)
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/parsing_functions.py", line 308, in parse_task
= parse_domain_pddl(domain_pddl)
File "/workspace/delfi/builds/release64/bin/translate/pddl_parser/parsing_functions.py", line 360, in parse_domain_pddl
requirements = pddl.Requirements(opt[1:])
File "/workspace/delfi/builds/release64/bin/translate/pddl/tasks.py", line 70, in __init__
":derived-predicates", ":action-costs"), req
AssertionError: :durative-actions
Planner output: {}No plan found in the planner output.
Planner found 0 plan(s) in 8.195secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Error: Traceback (most recent call last):
File "/planner/downward/translate/translate.py", line 895, in <module>
sas_task = pddl_to_sas(task)
File "/planner/downward/translate/translate.py", line 766, in pddl_to_sas
reachable_action_params) = instantiate.explore(task)
File "/planner/downward/translate/instantiate.py", line 134, in explore
prog = pddl_to_prolog.translate(task)
File "/planner/downward/translate/pddl_to_prolog.py", line 164, in translate
normalize.normalize(task)
File "/planner/downward/translate/normalize.py", line 538, in normalize
remove_object_functions(task)
File "/planner/downward/translate/normalize.py", line 431, in remove_object_functions
condition.append(recurse(cond,used_variables))
File "/planner/downward/translate/normalize.py", line 418, in recurse
new_parts = [recurse(part,used_variables) for part in condition.parts]
File "/planner/downward/translate/normalize.py", line 390, in recurse
typed,parts,new_term = term.compile_objectfunctions_aux(used_variables)
File "/planner/downward/translate/pddl/conditions.py", line 524, in compile_objectfunctions_aux
typed,parts,new_term = arg.compile_objectfunctions_aux(used_variables)
File "/planner/downward/translate/pddl/conditions.py", line 533, in compile_objectfunctions_aux
typed_vars.append(pddl_types.TypedObject(new_var_name, tasks.Task.FUNCTION_SYMBOLS[self.name]))
KeyError: '='
mv: cannot stat 'output.sas': No such file or directory
mv: cannot stat 'variables.groups': No such file or directory
mv: cannot stat 'all.groups': No such file or directory
/.singularity.d/runscript: 11: cannot open output.sas: No such file
/.singularity.d/runscript: 14: cannot open output: No such file
cat: 'output_plan*': No such file or directory
Plan found:
Metric: 0
Makespan: 0
States evaluated: undefined
Planner found 1 plan(s) in 3.491secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Error: Traceback (most recent call last):
File "/planner/downward/translate/translate.py", line 895, in <module>
sas_task = pddl_to_sas(task)
File "/planner/downward/translate/translate.py", line 766, in pddl_to_sas
reachable_action_params) = instantiate.explore(task)
File "/planner/downward/translate/instantiate.py", line 134, in explore
prog = pddl_to_prolog.translate(task)
File "/planner/downward/translate/pddl_to_prolog.py", line 164, in translate
normalize.normalize(task)
File "/planner/downward/translate/normalize.py", line 538, in normalize
remove_object_functions(task)
File "/planner/downward/translate/normalize.py", line 431, in remove_object_functions
condition.append(recurse(cond,used_variables))
File "/planner/downward/translate/normalize.py", line 418, in recurse
new_parts = [recurse(part,used_variables) for part in condition.parts]
File "/planner/downward/translate/normalize.py", line 390, in recurse
typed,parts,new_term = term.compile_objectfunctions_aux(used_variables)
File "/planner/downward/translate/pddl/conditions.py", line 524, in compile_objectfunctions_aux
typed,parts,new_term = arg.compile_objectfunctions_aux(used_variables)
File "/planner/downward/translate/pddl/conditions.py", line 533, in compile_objectfunctions_aux
typed_vars.append(pddl_types.TypedObject(new_var_name, tasks.Task.FUNCTION_SYMBOLS[self.name]))
KeyError: '='
mv: cannot stat 'output.sas': No such file or directory
mv: cannot stat 'variables.groups': No such file or directory
mv: cannot stat 'all.groups': No such file or directory
/.singularity.d/runscript: 11: cannot open output.sas: No such file
/.singularity.d/runscript: 14: cannot open output: No such file
cat: 'output_plan*': No such file or directory
Plan found:
Metric: 0
Makespan: 0
States evaluated: undefined
Planner found 1 plan(s) in 3.393secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 4.882secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 3.524secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 3.477secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
01000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 9.01
Makespan: 9.01
States evaluated: undefined
Planner found 3 plan(s) in 5.042secs.
Planning service: https://solver.planning.domains:5001/package/tfd/solve
Domain: cement-alimentacion, Problem: cement-production-problem
Plan found:
00000: (alimentar-puzolana-h mc1 t1-puzolana-h ph-a-mc1-por-mc1) [6.00000]
01000: (alimentar-clinker mc3 t3-clinker mc3-desde_silo-blanco) [4.00000]
02000: (alimentar-puzolana-s mc3 t3-puzolana-s ps-a-mc3-por-mc2) [5.00000]
Metric: 15.02
Makespan: 15.02
States evaluated: undefined
Planner found 3 plan(s) in 3.494secs.