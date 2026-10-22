TP3 – Actividad 04 – System Setup Menu Statechart (C coding)

## Mediciones de Tareas: `task_dta_list[]`

Tras varias ejecuciones de la función `app_update()` interactuando con el menú de configuración de motores, se extrajeron los siguientes valores del depurador:

**Unidad de medida temporal:** Microsegundos ($\mu s$). Según la arquitectura de este sistema "Bare Metal", los tiempos (LET, BCET, WCET) se miden en microsegundos calculados mediante el `cycle_counter`.

| Índice | NOE (Ejecuciones) | LET ($\mu s$) | BCET ($\mu s$) | WCET ($\mu s$) |
| :---: | :--- | :--- | :--- | :--- |
| `0` | 30175 | 43 | 43 | **45** |
| `1` | 30175 | 5 | 3 | **166** |
| `2` | 30175 | 2 | 2 | **4** |
| `3` | 30175 | 2 | 2 | **78** |

---

## Análisis de Restricciones Temporales (Ejecutor Cíclico)

Para garantizar el determinismo y la estabilidad de un sistema en tiempo real basado en un ejecutor cíclico, se debe cumplir una restricción temporal fundamental: **la suma de los tiempos de ejecución en el peor de los casos (Total WCET) de todas las tareas debe ser estrictamente menor al período base del planificador.**

1. **Período del Sistema:** El patrón de diseño *Update by Time Code* configurado en la aplicación define un período de **$1\text{ ms}$ ($1000\ \mu s$)**.
2. **Cálculo del Total WCET:** Sumamos el tiempo de ejecución en el peor de los casos de las 4 tareas registradas en el arreglo:
   $$Total\ WCET = 45\ \mu s + 166\ \mu s + 4\ \mu s + 78\ \mu s = 293\ \mu s$$
3. **Evaluación de la Restricción:** 
   $$293\ \mu s < 1000\ \mu s$$

### Conclusión
**El sistema cumple perfectamente con las restricciones temporales del ejecutor cíclico.** 

El tiempo máximo que el procesador tarda en ejecutar todas las máquinas de estado (sensores, sistema, display, etc.) en su peor escenario es de $293\ \mu s$[cite: 20], lo que representa apenas el **29.3%** del tiempo disponible en cada ciclo de $1000\ \mu s$. 

Esto deja un margen de seguridad de $707\ \mu s$ (70.7% del procesador libre), demostrando que la refactorización a máquinas de estado con acciones de entrada (Entry Actions) y formato de texto controlado mediante `snprintf` logró mantener un comportamiento genuinamente no bloqueante, incluso al manejar lógica de menús anidados.