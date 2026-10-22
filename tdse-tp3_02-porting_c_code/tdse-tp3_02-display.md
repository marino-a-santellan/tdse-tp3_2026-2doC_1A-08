
# TP3 – Actividad 02 – LCD Display Statechart

## Paso 09: Codificación del Modelo No Bloqueante
Se modificó el código fuente del proyecto STM32 para codificar en C el Diagrama de Estado del modelo `task_display`. La nueva implementación garantiza que se envíe **solo 1 instrucción o 1 dato a la vez cada 1mS**, eliminando los largos tiempos de espera dentro del estado `ST_DSP_UPDATE` para cumplir con las especificaciones del diseño. 

Archivos modificados:
* `...\tdse_workspace\tdse-tp3_2-porting_c_code\app\src\task_display.c`
* `...\tdse_workspace\tdse-tp3_2-porting_c_code\app\inc\task_display_attribute.h`

## Paso 10: Depuración y Análisis de Tiempos

### Mediciones de Depuración: `task_dta_list[]`
Los siguientes valores fueron obtenidos a través de la vista *Expressions* en el entorno de desarrollo STM32CubeIDE tras varias ejecuciones de `app_update()`, verificando el funcionamiento del nuevo Statechart.

| Campo | Descripción | `task_test` [0] | `task_display` [1] | Unidad |
|---|---|---|---|---|
| `NOE` | Number Of Executions | 14097 | 14097 | ejecuciones |
| `LET` | Last Execution Time | 2 | 2 | µs |
| `BCET` | Best-Case Execution Time | 2 | 2 | µs |
| `WCET` | Worst-Case Execution Time | **36** | **401** | µs |

### Análisis de Restricciones Temporales del Ejecutor Cíclico

Para evaluar la viabilidad y estabilidad del sistema en tiempo real, se debe contrastar el tiempo de ejecución en el peor de los casos (Total WCET) contra la base de tiempo configurada en el planificador (SysTick).

1.  **Esquema de Ejecución:** El proyecto implementa una arquitectura basada en eventos (Event-Triggered System) y máquinas de estado no bloqueantes. La actualización de las tareas se rige por el patrón *Update by Time Code*, el cual define un período estricto de **1 milisegundo (1000 µs)**.
2.  **Peor Escenario Posible (WCET Total):** Sumando el peor tiempo histórico de la tarea de pruebas (`task_test` con $36\ \mu s$) y el de la tarea del controlador del LCD rediseñado (`task_display` con $401\ \mu s$), obtenemos un tiempo total máximo de ejecución de **$437\ \mu s$** por cada ciclo del super-loop.
3.  **Cumplimiento de Restricciones:** El tiempo total exigido por las tareas ($437\ \mu s$) representa únicamente un **$43,7\%$** del período disponible de $1000\ \mu s$ dictado por el SysTick.

### Conclusión Final
**El sistema cumple holgadamente con las restricciones temporales del ejecutor cíclico.** 
Al rediseñar la máquina de estados del display para enviar un solo caracter o comando por ciclo (`tick`), el WCET de `task_display` bajó drásticamente de $6206\ \mu s$ (visto en la Actividad 01) a solo **$401\ \mu s$**. Existe ahora un margen de inactividad seguro de $563\ \mu s$ por cada ciclo de reloj base, confirmando empíricamente que el *statechart* del display LCD es genuinamente determinista y no bloqueante, previniendo cualquier desbordamiento temporal.