# TP3 – Actividad 02 – LCD Display Statechart (modeling, C coding)

Proyecto: `tdse-tp3_02-porting_c_code`

| Placa | Modelo | N° de serie |
|---|---|---|
| NUCLEO-F103RB | `MB1136-XXXXYY-ZZ` | `A????????` |

## Objetivo

Modelar y codificar en C el statechart de la tarea `task_display` de forma que escriba en el
display **1 instrucción o 1 dato a la vez, cada 1 ms**, y verificar que cumple las
restricciones temporales del ejecutor cíclico.

Punto de partida: en la Actividad 01, `task_display` reescribía el display completo
(2 posicionamientos + 32 caracteres) en una sola ejecución. Su WCET medido fue **6206 µs**,
más de seis períodos del SysTick (U = 6,24 > 1).

Archivos modificados respecto de `tdse-tp3_01-porting_c_code`:

- `app/inc/display.h`, `app/src/display.c`: nueva función pública `displayDataWrite()`.
- `app/inc/task_display_attribute.h`: estados del statechart.
- `app/src/task_display.c`: `task_display_statechart()`.

## Modelo (itemis CREATE)

Archivos: `task_display/task_display.scm` y `task_display/task_display.png`.

El modelo se exportó desde **itemis CREATE Cloud Editor**, cuyo formato es `.scm`. La guía
menciona `.ysc`, que es el formato de la versión Desktop, hoy discontinuada.

### Definition section

```
@CycleBased(1)

interface:
    var flag: boolean = false
    var row: integer = 0
    var column: integer = 0
    const ROWS: integer = 2
    const COLUMNS: integer = 16
    operation set_cursor(r: integer, col: integer): void
    operation write_char(r: integer, col: integer): void
```

- **`@CycleBased(1)`**: el statechart ejecuta un ciclo cada 1 ms, como `task_display_update()`
  en el ejecutor cíclico. Las transiciones que solo tienen guarda se evalúan en cada ciclo.
- **`flag` es una variable y no un `in event`**: un evento de itemis existe durante un único
  ciclo, mientras que un mensaje que llega durante una escritura tiene que quedar pendiente.
- **`set_cursor` y `write_char`** representan las llamadas al driver. Ambas reciben
  (fila, columna), el mismo orden que `ddram[row][column]`.

### Estados

| Estado | Acción por ejecución |
|---|---|
| `ST_DSP_IDLE` | ninguna: espera contenido nuevo (`flag`) |
| `ST_DSP_SET_CURSOR` | 1 instrucción: cursor a (fila `row`, columna 0) |
| `ST_DSP_WRITE_CHAR` | 1 dato: carácter `ddram[row][column]` |

Las posiciones dentro de la fila (columna 0 a 15) **no** son estados: el estado identifica el
**tipo** de operación, y la posición la llevan las variables `row` y `column`. Con este diseño,
un display de más filas solo requiere cambiar `ROWS`.

### State Transition Table

| Current State | Event | [Guard] | Next State | Actions |
|---|---|---|---|---|
| *(inicial)* | — | — | `ST_DSP_IDLE` | — |
| `ST_DSP_IDLE` | `EV_DSP_UPDATE` | `[flag == true]` | `ST_DSP_SET_CURSOR` | `flag = false`; `row = 0`; `column = 0` |
| `ST_DSP_SET_CURSOR` | — (`always`) | — | `ST_DSP_WRITE_CHAR` | `displayCharPositionWrite(0, row)` |
| `ST_DSP_WRITE_CHAR` | — | 1: `[column < COLUMNS − 1]` | `ST_DSP_WRITE_CHAR` | `displayDataWrite(c)`; `column++` |
| `ST_DSP_WRITE_CHAR` | — | 2: `[column == COLUMNS − 1 && row < ROWS − 1]` | `ST_DSP_SET_CURSOR` | `displayDataWrite(c)`; `column = 0`; `row++` |
| `ST_DSP_WRITE_CHAR` | — | 3: `[column == COLUMNS − 1 && row == ROWS − 1]` | `ST_DSP_IDLE` | `displayDataWrite(c)` |
| *(cualquier otro valor)* | — | — | `ST_DSP_IDLE` | `tick = 0`; `event = EV_DSP_IDLE`; `flag = false` (`default:`) |

donde `c = ddram[row][column]`, o `' '` si esa posición contiene `'\0'`.

Las tres guardas de `ST_DSP_WRITE_CHAR` son **exhaustivas y mutuamente excluyentes**: para
cada combinación de `column` (0–15) y `row` (0–1) se cumple exactamente una.

### Decisiones de diseño

- **Una operación por ejecución.** Cada ejecución de la tarea realiza como máximo una
  operación sobre el LCD. Una escritura completa ocupa 35 ejecuciones: la salida de
  `ST_DSP_IDLE`, 2 posicionamientos y 32 caracteres.
- **Reposicionamiento entre filas.** Al recibir un dato, el HD44780 incrementa solo su
  dirección interna (*entry mode increment*). Después de la columna 15 de la fila 0, esa
  dirección pasa a `0x10`, una posición que no se ve en un display de 16 columnas; la fila 1
  empieza en `0x40`. Por eso, antes de cada fila, la tarea vuelve a `ST_DSP_SET_CURSOR`.
- **Fin de fila por columna, no por `'\0'`.** `put_event_task_display()` copia el texto a
  `ddram` sin rellenar el resto de la fila, así que puede haber `'\0'` antes de texto válido
  (por ejemplo, un mensaje escrito desde la columna 10 en una fila nunca usada). Cortar en el
  primer `'\0'` perdería ese texto. Se recorren siempre las 16 columnas, y las posiciones con
  `'\0'` se envían como espacio, para que la dirección del LCD y `column` no se desfasen.
- **El reemplazo de `'\0'` lo hace la tarea, no el driver.** Para el HD44780, `0x00` es un
  carácter válido (el carácter definido por el usuario n.º 0 de la CGRAM). Que `'\0'` signifique
  "posición no escrita" es una convención del buffer `ddram` de `task_display`. Por eso
  `displayDataWrite()` envía el dato tal cual y la conversión ocurre en el statechart.
- **El `flag` se baja al salir de `ST_DSP_IDLE`.** `ddram` funciona como buzón: cada mensaje
  sobrescribe las posiciones indicadas. Si llega un mensaje durante una escritura, vuelve a
  subir el `flag`; al terminar, `ST_DSP_IDLE` lo encuentra en alto e inicia otra pasada. El LCD
  termina mostrando siempre el último contenido de `ddram`. Si el `flag` se bajara al
  terminar, ese mensaje se perdería.
- **La operación va en la transición, no como acción `entry`.** Una acción `entry` en
  `ST_DSP_SET_CURSOR` se ejecutaría en el mismo ciclo que la transición que llega desde
  `ST_DSP_WRITE_CHAR`: dos operaciones sobre el LCD en un tick, y un tick vacío después.

## `displayDataWrite()`

```c
void displayDataWrite( const char data )
```

Envía **un** carácter al LCD como dato (RS = 1) mediante `displayCodeWrite(DISPLAY_RS_DATA, data)`,
la misma función privada que usa `displayStringWrite()` para cada carácter. Costo: 2 nibbles,
cada uno con su pulso de EN y 2 esperas de 37 µs, ≈ 148 µs por llamada.

## Codificación en C

`task_display_statechart()` sigue la regla de traducción de la cátedra: un `switch` sobre
`state` con un `case` por estado y, en cada `case`, las transiciones salientes como una cadena
`if / else if / else` en el orden de prioridad del modelo. El `switch` cierra con un
`default:` que lleva la tarea a la posición segura (`ST_DSP_IDLE`, valor 0 del `enum`).

Correspondencias con el modelo:

- `set_cursor(row, 0)` se traduce como `displayCharPositionWrite(0, row)`: el driver recibe
  coordenadas de pantalla (x, y) = (columna, fila).
- En `ST_DSP_WRITE_CHAR`, la escritura del carácter se hace **una sola vez, antes de evaluar
  las guardas**, en lugar de repetirla en cada rama. Es equivalente al modelo porque las tres
  transiciones comparten esa acción y escribir no modifica `row` ni `column`, que son las
  variables de las guardas. Las actualizaciones (`column++`, `column = 0`, `row++`) van después
  de la escritura, dentro de cada rama.
- En `ST_DSP_IDLE` se verifica además `event == EV_DSP_UPDATE`, siguiendo el patrón evento +
  `flag` del resto de las tareas. Como el display recibe un único tipo de mensaje, es
  equivalente a la guarda `[flag]` del modelo.

## Verificación (depuración)

Depuración con **ST-LINK (OpenOCD)**, *Reset Mode: Software system reset* y
`monitor arm semihosting enable`.

- El LCD muestra `"LCD Display Test"` / `" Porting C code "` al iniciar, y después
  `"Test Nro: X*****"` con X incrementándose cada segundo, igual que en la Actividad 01.
- Secuencia esperada de `task_display_dta.state` en cada mensaje (una vez por segundo):
  `ST_DSP_IDLE → ST_DSP_SET_CURSOR → ST_DSP_WRITE_CHAR (×16) → ST_DSP_SET_CURSOR →
  ST_DSP_WRITE_CHAR (×16) → ST_DSP_IDLE`.

**Observación de robustez.** Si durante la ejecución se mueve un cable (sobre todo EN o RS),
el LCD pierde la sincronización de nibbles del modo 4 bits y desde ese momento muestra
caracteres incorrectos. El micro no puede detectarlo, porque RW está a GND y nunca lee al LCD.
Se recupera solo con un reset, que vuelve a ejecutar la secuencia de `displayInit()`. Un
sistema real podría re-inicializar el display periódicamente o leer el *busy flag*.

## Mediciones: `task_dta_list[]`

Valores leídos tras varias ejecuciones de `app_update()` (CPU suspendida, vista
*Expressions*), en dos lecturas. Build **Debug**, `SystemCoreClock` = 64 MHz.

| Campo | Descripción | `task_test` [0] | `task_display` [1] | Unidad |
|---|---|---|---|---|
| `NOE` | Number Of Executions | 22102 → 150405 | 22107 → 150405 | ejecuciones |
| `LET` | Last Execution Time | 2 | 2 | µs |
| `BCET` | Best-Case Execution Time | 2 | 2 | µs |
| `WCET` | Worst-Case Execution Time | 36 → 37 | 220 | µs |

En la segunda lectura (≈ 150 s de ejecución) `NOE` coincide en ambas tareas. La primera
lectura de `NOE[1]` se descarta: la vista no había refrescado todas las expresiones en la misma
pausa. El cambio de 36 a 37 µs en `task_test` está dentro de la resolución de la medición
(µs enteros, con interrupciones del SysTick y esperas de la flash incluidas).

### Análisis

**Origen del WCET de `task_display` (220 µs).** Corresponde a la ejecución en
`ST_DSP_SET_CURSOR`: `displayCharPositionWrite()` envía un byte de instrucción (4 esperas de
37 µs) y agrega una espera de 37 µs, en total 185 µs de espera, más ≈ 35 µs de llamadas a
`HAL_GPIO_WritePin()`, selección en `displayPinWrite()` y bucle de espera. Ese overhead coincide
con el de la Actividad 01 (≈ 1100 µs en 34 operaciones, unos 32 µs por operación). Una ejecución
en `ST_DSP_WRITE_CHAR` cuesta ≈ 148 + 32 ≈ 180 µs, y una en `ST_DSP_IDLE`, ≈ 2 µs (BCET).

**Factor de uso de CPU (peor caso):**

```
U = (WCET_test + WCET_display) / T_systick = (37 µs + 220 µs) / 1000 µs = 0,257
```

**U < 1: se cumplen las restricciones temporales del ejecutor cíclico.**

La suma de WCET es una cota pesimista: en la ejecución en que `task_test` envía un mensaje
(su WCET), `task_display` está todavía en `ST_DSP_IDLE` (≈ 2 µs). El peor tick real ronda los
222 µs.

**Comparación con la Actividad 01:**

| | Actividad 01 (bloqueante) | Actividad 02 (statechart) |
|---|---|---|
| WCET `task_display` | 6206 µs | 220 µs |
| U | 6,24 | 0,257 |
| Ejecuciones para reescribir el display | 1 | 35 |
| Tiempo total de una reescritura | ≈ 6,2 ms | 35 ms |
| Periodicidad del ejecutor cíclico | se pierde (≈ 6 ticks atrasados en ráfaga) | se mantiene |

### Conclusión

Repartir la escritura del display en el tiempo (una instrucción o un dato por ejecución)
reduce el WCET de `task_display` unas 28 veces y deja el ejecutor cíclico dentro de su
período (U = 0,257). El costo es la latencia: el contenido nuevo tarda 35 ms en verse completo
en lugar de ≈ 6 ms, imperceptible para una persona. El driver sigue usando esperas activas de
37 µs, pero cada ejecución las acota a una sola operación: el comportamiento es no bloqueante
a nivel de la tarea, que es la condición que exige el ejecutor cíclico.
