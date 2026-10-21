# TP3 – Actividad 02 – LCD Display Statechart 

## Mediciones de Depuración: `task_dta_list[]`

Los siguientes valores fueron obtenidos a través de la vista *Expressions* en el entorno de desarrollo tras varias ejecuciones de `app_update()`.

| Campo | Descripción | `task_test` [0] | `task_display` [1] | Unidad |
|---|---|---|---|---|
| `NOE` | Number Of Executions | 150405 | 150405 | ejecuciones |
| `LET` | Last Execution Time | 2 | 2 | µs |
| `BCET` | Best-Case Execution Time | 2 | 2 | µs |
| `WCET` | Worst-Case Execution Time | 37 | 255 | µs |

### Análisis de Restricciones Temporales del Ejecutor Cíclico

Para evaluar la viabilidad y estabilidad del sistema en tiempo real, se debe contrastar el tiempo de ejecución en el peor de los casos (Total WCET) contra la base de tiempo configurada en el planificador (SysTick).

1.  **Esquema de Ejecución:** El proyecto implementa una arquitectura basada en eventos (Event-Triggered System) y máquinas de estado no bloqueantes. La actualización de las tareas se rige por el patrón *Update by Time Code*, el cual define un período estricto de **1 milisegundo (1000 µs)**.
2.  **Peor Escenario Posible (WCET):** Sumando el peor tiempo histórico de la tarea de pruebas (`task_test` con 37 µs) y el de la tarea del controlador del LCD (`task_display` con 255 µs), obtenemos un tiempo total máximo de ejecución (Total WCET) de **292 µs** por cada ciclo del super-loop.
3.  **Cumplimiento de Restricciones:** El tiempo total exigido por las tareas (292 µs) representa únicamente un **29,2%** del período disponible de 1000 µs dictado por el SysTick.

**Conclusión:** 
El sistema **cumple de manera holgada con las restricciones temporales del ejecutor cíclico**. Existe un margen de inactividad de 708 µs por cada ciclo de reloj base, lo que confirma empíricamente que la codificación en C del *statechart* del display LCD es determinista, genuinamente no bloqueante y asegura que ninguna tarea monopolicé el uso de la CPU, previniendo cualquier desbordamiento de tiempo real.