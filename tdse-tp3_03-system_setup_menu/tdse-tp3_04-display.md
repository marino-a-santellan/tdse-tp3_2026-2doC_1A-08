# TP3 – Actividad 04 – System Setup Menu Statechart (C coding)

Proyecto: `tdse-tp3_03-system_setup_menu`

| Placa | N° de serie |
|---|---|
| NUCLEO-F103RB | `NUF103RB$KU1` |

## Objetivo

Codificar en C el statechart `system_setup_menu` modelado en la Actividad 03 (carpeta
`system_setup_menu/` del repositorio), integrarlo en la tarea `task_system` del proyecto base y
verificar que cumple las restricciones temporales del ejecutor cíclico.

El menú configura dos motores (encendido, velocidad y sentido de giro) con un teclado de
membrana de 3 teclas (Enter, Next, Escape) y muestra cada pantalla en el LCD 16×2.

## Proyecto base y conexión

El proyecto `tdse-tp3_03-system_setup_menu` se importó y compiló sin cambios. Con la depuración
se verificó el comportamiento de referencia:

- `task_system_init()` muestra `"task_system_mode"` / `" NORMAL "`.
- Con B1 (USER, azul) apretado se enciende LD2 (verde); al soltarlo, se apaga.
- Cada pulsación de B1 alterna la segunda línea entre `" NORMAL "` y `" SETUP "`.

El LCD se conecta igual que en la Actividad 01 (modo 4 bits, RW a GND, trimpot de 10 kΩ en VO).
El teclado usa los pull-up internos del microcontrolador; cada tecla cierra su línea a GND:

| Pin del teclado | Pin NUCLEO | GPIO | Tecla |
|---|---|---|---|
| 1 | D10 | PB6 | Enter |
| 2 | D11 | PA7 | Next |
| 3 | D12 | PA6 | Escape |
| 4 | — | — | sin conectar |
| 5 | GND | — | común |

Archivos modificados respecto del proyecto base:

- `app/inc/task_system_attribute.h`: eventos, estados, tipos del menú y del motor, `dta` del menú.
- `app/src/task_system.c`: `tda_motor_list[]`, `task_system_statechart()` y las pantallas.
- `app/inc/task_sensor_attribute.h`, `app/src/task_sensor.c`: teclas del menú y corrección del
  recorrido de los botones.

## Modelo

Archivos: `system_setup_menu/system_setup_menu.scm` y `system_setup_menu/system_setup_menu.png`
(itemis CREATE Cloud Editor).

### Estados y eventos

| Estado | Pantalla | Opción actual |
|---|---|---|
| `ST_SYSTEM_MENU_MAIN` | estado de los dos motores | — |
| `ST_SYSTEM_MENU_1` | elección de motor | `index` (`MOTOR_1`, `MOTOR_2`) |
| `ST_SYSTEM_MENU_2` | elección de parámetro | `mode` (`MENU2_MODE_POWER`, `_SPEED`, `_SPIN`) |
| `ST_SYSTEM_MENU_3` | edición del valor | `aux_power`, `aux_speed` o `aux_spin` |

Hay un estado por nivel de menú. La opción elegida dentro de cada nivel no es un estado: la
llevan las variables `index` y `mode`. Agregar un motor solo requiere una fila más en
`tda_motor_list[]`.

| Evento | Origen |
|---|---|
| `EV_MENU_ENTER` | tecla Enter apretada |
| `EV_MENU_NEXT` | tecla Next apretada |
| `EV_MENU_ESC` | tecla Escape apretada |
| `EV_MENU_IDLE` | cualquier tecla soltada (no excita ninguna transición) |

### State Transition Table del modelo (Actividad 03)

Corresponde al modelo de itemis (`system_setup_menu/system_setup_menu.scm`). En el modelo los
estados se llaman `ST_MENU_*`; en el código, `ST_SYSTEM_MENU_*`. Las transiciones que pasan por
un pseudoestado Choice se escriben como una fila por rama.

| State | Entry |
|---|---|
| `ST_MENU_MAIN` | `show_main_screen()` |
| `ST_MENU_1` | `show_menu1_screen()` |
| `ST_MENU_2` | `show_menu2_screen(index)` |
| `ST_MENU_3` | `show_menu3_screen()` |

| Current State | Event | [Guard] | Next State | Actions |
|---|---|---|---|---|
| *(inicial)* | — | — | `ST_MENU_MAIN` | — |
| `ST_MENU_MAIN` | `EV_MENU_ENTER` | — | `ST_MENU_1` | `index = 0` |
| `ST_MENU_MAIN` | `EV_MENU_NEXT`, `EV_MENU_ESC` | — | `ST_MENU_MAIN` | — |
| `ST_MENU_1` | `EV_MENU_ENTER` | `[index == MOTOR_1]` | `ST_MENU_2` | `mode = 0`; `cur_power = motor_1_power`; `cur_speed = motor_1_speed`; `cur_spin = motor_1_spin` |
| `ST_MENU_1` | `EV_MENU_ENTER` | `[else]` | `ST_MENU_2` | `mode = 0`; `cur_power = motor_2_power`; `cur_speed = motor_2_speed`; `cur_spin = motor_2_spin` |
| `ST_MENU_1` | `EV_MENU_NEXT` | `[index < MOTOR_QTY - 1]` | `ST_MENU_1` | `index++` |
| `ST_MENU_1` | `EV_MENU_NEXT` | `[else]` | `ST_MENU_1` | `index = 0` |
| `ST_MENU_1` | `EV_MENU_ESC` | — | `ST_MENU_MAIN` | — |
| `ST_MENU_2` | `EV_MENU_ENTER` | — | `ST_MENU_3` | `aux_power = cur_power`; `aux_speed = cur_speed`; `aux_spin = cur_spin` |
| `ST_MENU_2` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_QTY - 1]` | `ST_MENU_2` | `mode = 0` |
| `ST_MENU_2` | `EV_MENU_NEXT` | `[else]` | `ST_MENU_2` | `mode++` |
| `ST_MENU_2` | `EV_MENU_ESC` | `[index == MOTOR_1]` | `ST_MENU_1` | `motor_1_power = cur_power`; `motor_1_speed = cur_speed`; `motor_1_spin = cur_spin` |
| `ST_MENU_2` | `EV_MENU_ESC` | `[else]` | `ST_MENU_1` | `motor_2_power = cur_power`; `motor_2_speed = cur_speed`; `motor_2_spin = cur_spin` |
| `ST_MENU_3` | `EV_MENU_ENTER` | `[mode == MENU2_MODE_POWER]` | `ST_MENU_2` | `cur_power = aux_power` |
| `ST_MENU_3` | `EV_MENU_ENTER` | `[mode == MENU2_MODE_SPEED]` | `ST_MENU_2` | `cur_speed = aux_speed` |
| `ST_MENU_3` | `EV_MENU_ENTER` | `[else]` | `ST_MENU_2` | `cur_spin = aux_spin` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_POWER && aux_power == ON]` | `ST_MENU_3` | `aux_power = OFF` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_POWER && else]` | `ST_MENU_3` | `aux_power = ON` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPEED && aux_speed == MAX_SPEED]` | `ST_MENU_3` | `aux_speed = 0` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPEED && else]` | `ST_MENU_3` | `aux_speed += 1` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[else && aux_spin == LEFT]` | `ST_MENU_3` | `aux_spin = RIGHT` |
| `ST_MENU_3` | `EV_MENU_NEXT` | `[else && else]` | `ST_MENU_3` | `aux_spin = LEFT` |
| `ST_MENU_3` | `EV_MENU_ESC` | — | `ST_MENU_2` | — |

Constantes: `MOTOR_QTY = 2`, `MENU2_MODE_QTY = 3`, `MAX_SPEED = 9`, `MOTOR_1 = 0`,
`OFF = 0`, `ON = 1`, `LEFT = 0`, `RIGHT = 1`. Valores iniciales: `motor_N_power = ON`,
`motor_N_speed = 8`, `motor_N_spin = LEFT`.

Toda transición que llega a un estado, incluidas las auto-transiciones, ejecuta su `entry`:
la pantalla se actualiza después de cada acción.

### State Transition Table del código (Actividad 04)

| Current State | Event | [Guard] | Next State | Actions |
|---|---|---|---|---|
| *(inicial)* | — | — | `ST_SYSTEM_MENU_MAIN` | `show_main_screen()` |
| `ST_SYSTEM_MENU_MAIN` | `EV_MENU_ENTER` | — | `ST_SYSTEM_MENU_1` | `index = MOTOR_1`; `show_menu1_screen()` |
| `ST_SYSTEM_MENU_MAIN` | `EV_MENU_NEXT`, `EV_MENU_ESC` | — | `ST_SYSTEM_MENU_MAIN` | `show_main_screen()` |
| `ST_SYSTEM_MENU_1` | `EV_MENU_ENTER` | — | `ST_SYSTEM_MENU_2` | `mode = MENU2_MODE_POWER`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_1` | `EV_MENU_NEXT` | `[index < MOTOR_QTY − 1]` | `ST_SYSTEM_MENU_1` | `index++`; `show_menu1_screen()` |
| `ST_SYSTEM_MENU_1` | `EV_MENU_NEXT` | `[else]` | `ST_SYSTEM_MENU_1` | `index = MOTOR_1`; `show_menu1_screen()` |
| `ST_SYSTEM_MENU_1` | `EV_MENU_ESC` | — | `ST_SYSTEM_MENU_MAIN` | `show_main_screen()` |
| `ST_SYSTEM_MENU_2` | `EV_MENU_ENTER` | — | `ST_SYSTEM_MENU_3` | `aux_power`, `aux_speed`, `aux_spin` = valores de `tda_motor_list[index]`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_2` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_QTY − 1]` | `ST_SYSTEM_MENU_2` | `mode = MENU2_MODE_POWER`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_2` | `EV_MENU_NEXT` | `[else]` | `ST_SYSTEM_MENU_2` | `mode++`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_2` | `EV_MENU_ESC` | — | `ST_SYSTEM_MENU_1` | `show_menu1_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_ENTER` | `[mode == MENU2_MODE_POWER]` | `ST_SYSTEM_MENU_2` | `tda_motor_list[index].power = aux_power`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_ENTER` | `[mode == MENU2_MODE_SPEED]` | `ST_SYSTEM_MENU_2` | `tda_motor_list[index].speed = aux_speed`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_ENTER` | `[else]` (Spin) | `ST_SYSTEM_MENU_2` | `tda_motor_list[index].spin = aux_spin`; `show_menu2_screen(index)` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_POWER && aux_power == ON]` | `ST_SYSTEM_MENU_3` | `aux_power = OFF`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_POWER && else]` | `ST_SYSTEM_MENU_3` | `aux_power = ON`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPEED && aux_speed == MAX_SPEED]` | `ST_SYSTEM_MENU_3` | `aux_speed = 0`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPEED && else]` | `ST_SYSTEM_MENU_3` | `aux_speed++`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPIN && aux_spin == LEFT]` | `ST_SYSTEM_MENU_3` | `aux_spin = RIGHT`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_NEXT` | `[mode == MENU2_MODE_SPIN && else]` | `ST_SYSTEM_MENU_3` | `aux_spin = LEFT`; `show_menu3_screen()` |
| `ST_SYSTEM_MENU_3` | `EV_MENU_ESC` | — | `ST_SYSTEM_MENU_2` | `show_menu2_screen(index)` |
| *(cualquier otro valor)* | — | — | `ST_SYSTEM_MENU_MAIN` | `index = MOTOR_1`; `mode = MENU2_MODE_POWER`; `event = EV_MENU_IDLE`; `flag = false`; `show_main_screen()` (`default:`) |

Todas las transiciones con evento requieren además `flag == true` (evento sin consumir) y bajan
el `flag`. `MOTOR_QTY = 2`, `MENU2_MODE_QTY = 3`, `MAX_SPEED = 9`.

### Diferencias entre el modelo y el código

El lenguaje de itemis CREATE Cloud Editor no tiene arreglos, estructuras ni enumerados. El modelo
los representa así, y el código vuelve a la forma natural en C:

| Modelo (itemis) | Código C |
|---|---|
| Una `const integer` por cada valor de enumerado | `enum` en `task_system_attribute.h` |
| Una variable por campo y motor (`motor_1_power`, …) | `tda_motor_list[index]` (arreglo de `tda_motor_t`) |
| Copia del motor elegido (`cur_*`) cargada al entrar a Menu #2 y escrita de vuelta al salir, con un pseudoestado Choice por `index` | Lectura y escritura directa de `tda_motor_list[index]`; desaparecen `cur_*` y los dos Choices |
| Pseudoestados Choice con rama `else` | `if` / `else if` / `else` anidados |
| Acción `entry / show_…()` de cada estado | Llamada a `show_…()` en cada rama que llega al estado, incluidas las auto-transiciones |
| Eventos de itemis (consumidos en un ciclo) | Patrón `event` + `flag` de la cátedra |

El comportamiento observable es el mismo: lo guardado en Menu #3 queda en el motor elegido y
se ve en la pantalla Main.

### Decisiones de diseño

- **Edición sobre una copia.** Menu #3 modifica `aux_power`, `aux_speed` o `aux_spin`, que se
  cargan con los valores del motor al bajar desde Menu #2. Enter guarda el valor editado en
  `tda_motor_list[index]`; Escape vuelve sin guardar.
- **Enter en Menu #3 guarda y vuelve a Menu #2.** Si se quedara en Menu #3, la pantalla no
  cambiaría y el usuario no tendría indicación de que el valor se guardó.
- **Opción inicial de cada nivel.** `index` se reinicia al entrar a Menu #1 desde Main y `mode`
  al entrar a Menu #2 desde Menu #1. Al volver de Menu #3 a Menu #2, `mode` se conserva y el
  cursor queda en el parámetro recién editado.
- **Next en la última opción vuelve a la primera** (motor, parámetro y valor).
- **B1 sin uso.** El menú reemplaza el comportamiento NORMAL/SETUP del proyecto base, que no
  forma parte del modelo `system_setup_menu`. Se quitaron B1 del `cfg_list` del sensor y los
  eventos al actuador (LD2).

## Codificación en C

### `task_system`

`task_system_statechart()` sigue la regla de traducción de la cátedra: un `switch` sobre
`state` con un `case` por estado y, en cada `case`, un `if / else if` por evento. Las guardas
de los Choices quedan como `if / else` dentro de la rama del evento. El `switch` cierra con un
`default:` que lleva el menú a `ST_SYSTEM_MENU_MAIN`, valor 0 del `enum`.

Desaparecen el modo global (`g_task_system_mode`, `task_system_set_mode()`) y los dos statecharts
NORMAL/SETUP: `task_system_update()` ejecuta directamente `task_system_statechart()`.

**Pantallas.** Cada `show_…()` arma las dos líneas con `snprintf()` y las envía con
`put_event_task_display(columna, fila, texto)`:

| Pantalla | Línea 1 | Línea 2 |
|---|---|---|
| Main | `Motor 1: ON,8,L` | `Motor 2: ON,8,L` |
| Menu #1 | `Menu 1` | `> Motor 1` / `> Motor 2` |
| Menu #2 | `Motor 1` | `> Power` / `> Speed` / `> Spin` |
| Menu #3 | `Motor 1 Power` | `> ON` / `> OFF`, `> 0` … `> 9`, `> LEFT` / `> RIGHT` |

La pantalla Main de la figura de la guía (`Motor 1: ON, 8, L`) tiene 17 caracteres y no entra en
una línea de 16; se quitaron los espacios después de las comas.

`put_event_task_display()` copia el texto a `ddram` sin borrar el resto de la fila. Por eso
`show_line()` completa cada línea con espacios hasta 16 caracteres: sin ese relleno, un texto
más corto que el anterior dejaría a la vista el final del texto viejo.

**Evento de tecla soltada.** El sensor envía `EV_MENU_IDLE` al soltar cualquier tecla. Ningún
estado tiene una transición con ese evento, así que no produce cambios; el `flag` queda alto
con `EV_MENU_IDLE` hasta que la siguiente pulsación lo sobrescribe.

### `task_sensor`

- El `cfg_list` tiene una fila por tecla del teclado (`ID_BTN_ENT`, `ID_BTN_NEX`, `ID_BTN_ESC`),
  que emiten `EV_MENU_ENTER`, `EV_MENU_NEXT` y `EV_MENU_ESC` al confirmarse la pulsación.
- **Corrección del recorrido de los botones.** En el proyecto base, `task_sensor_update()`
  recorre los botones y llama a `task_sensor_statechart(index)`, que ignoraba su parámetro y
  volvía a recorrerlos todos. Cada botón se procesaba tantas veces por ejecución como botones
  hubiera: con 3 teclas, el antirrebote de 50 ejecuciones duraba ≈ 17 ms en lugar de 50 ms, y el
  WCET de la tarea se multiplicaba. Se quitó el recorrido interno: `task_sensor_statechart(index)`
  procesa solo el botón `index`, como en los proyectos del TP2.

## Verificación (depuración)

Depuración con **ST-LINK (OpenOCD)**, *Reset Mode: Software system reset* y
`monitor arm semihosting enable`.

- Al iniciar, el LCD muestra la pantalla Main con los valores iniciales de los dos motores.
- Se recorrieron todos los niveles y opciones: Next avanza y vuelve a la primera opción en
  cada nivel, Escape sube un nivel sin guardar y Enter en Menu #3 guarda y vuelve a Menu #2.
- Recorrido de control: Motor 2 → Speed → Next → Enter → Escape → Escape; la pantalla Main
  muestra `Motor 2: ON,9,L` y el motor 1 conserva sus valores.

## Mediciones: `task_dta_list[]`

Valores leídos con la CPU suspendida (`print task_dta_list` en la consola de GDB), después de
recorrer el menú varias veces. Build **Debug**, `SystemCoreClock` = 64 MHz.

| Campo | Descripción | `task_sensor` [0] | `task_system` [1] | `task_actuator` [2] | `task_display` [3] | Unidad |
|---|---|---|---|---|---|---|
| `NOE` | Number Of Executions | 114028 | 114028 | 114028 | 114028 | ejecuciones |
| `LET` | Last Execution Time | 10 | 3 | 2 | 2 | µs |
| `BCET` | Best-Case Execution Time | 10 | 3 | 2 | 2 | µs |
| `WCET` | Worst-Case Execution Time | 11 | 239 | 2 | 78 | µs |

`NOE` coincide en las cuatro tareas (≈ 114 s de ejecución): la lectura corresponde a una misma
pausa.

### Análisis

- **`task_system` (WCET 239 µs).** Corresponde a una ejecución en la que se consume un evento de
  tecla y se arma una pantalla: dos llamadas a `snprintf()` por línea (formato y relleno) y dos
  copias a `ddram`. Sin eventos, la tarea solo revisa la cola (3 µs). El peor caso ocurre como
  mucho una vez por pulsación.
- **`task_display` (WCET 78 µs).** Corresponde a una ejecución que posiciona el cursor o escribe
  un carácter. El driver `display.c` de este proyecto hace una sola espera de 37 µs por byte y
  pulsos de EN de 1 µs, por eso el valor es menor que los 220 µs medidos en la Actividad 02 con
  el driver portado en la Actividad 01.
- **`task_sensor` (10–11 µs).** Tres botones procesados una vez cada uno por ejecución. Su BCET y
  su WCET casi coinciden porque la tarea lee los tres pines en todas las ejecuciones.
- **`task_actuator` (2 µs).** Sin eventos: el menú no usa LEDs.

**Factor de uso de CPU (peor caso):**

```
U = (WCET_sensor + WCET_system + WCET_actuator + WCET_display) / T_systick
  = (11 µs + 239 µs + 2 µs + 78 µs) / 1000 µs = 0,33
```

**U < 1: se cumplen las restricciones temporales del ejecutor cíclico.**

La suma de WCET es una cota pesimista. En la ejecución en que `task_system` arma una pantalla,
`task_display` todavía no empezó a escribirla: lo hace a partir de la ejecución siguiente, de a
una operación por milisegundo (unas 35 ejecuciones por pantalla).

### Conclusión

El menú de configuración se integra en `task_system` sin bloquear: cada pulsación se resuelve
en una única ejecución de la tarea (≤ 239 µs) y la escritura de la pantalla queda repartida en
el tiempo por `task_display`. El ejecutor cíclico usa como máximo un tercio de cada período
(U = 0,33), con margen para agregar motores, opciones o tareas.
