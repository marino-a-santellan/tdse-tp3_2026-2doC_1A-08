# Modelo task_display (TP3 – Actividad 02)

Statechart no bloqueante del display: **1 instrucción o 1 dato por ejecución** (cada 1 ms).
Diseñado con el método solución-guiada (ver `borrador-task_display.c`).

## Para itemis CREATE

### Definition section

```
@CycleBased(1)

interface:
    var flag: boolean = false
    var row: integer = 0
    var column: integer = 0
    const ROWS: integer = 2
    const COLUMNS: integer = 16
    operation set_cursor(col: integer, r: integer): void
    operation write_char(r: integer, col: integer): void
```

- `@CycleBased(1)`: el statechart ejecuta un ciclo cada 1 ms, igual que `task_display_update()`
  en el cyclic executive. Las transiciones que solo tienen guarda se evalúan en cada ciclo.
- `flag` es una **variable** y no un `in event`: en itemis un evento dura un solo ciclo, y el
  mensaje tiene que quedar **pendiente** si llega mientras la tarea escribe. En el simulador,
  `put_event_task_display` se representa poniendo `flag = true` a mano en la vista de variables.
- `set_cursor` y `write_char` representan las llamadas al driver. `write_char(r, col)` envía
  `ddram[r][col]`, o `' '` si es `'\0'` (en C: `displayDataWrite`, Paso 09).

### Estados

| Estado | Qué hace |
|---|---|
| `ST_DSP_IDLE` | espera texto nuevo (`flag`) |
| `ST_DSP_SET_CURSOR` | 1 instrucción: cursor a (columna 0, fila `row`) |
| `ST_DSP_WRITE_CHAR` | 1 dato: `ddram[row][column]` |

Entrada (●) → `ST_DSP_IDLE`.

### Transiciones (etiquetas para itemis)

| Desde | Prioridad | Etiqueta | Hacia |
|---|---|---|---|
| `ST_DSP_IDLE` | — | `[flag] / flag = false; row = 0; column = 0` | `ST_DSP_SET_CURSOR` |
| `ST_DSP_SET_CURSOR` | — | `always / set_cursor(0, row)` | `ST_DSP_WRITE_CHAR` |
| `ST_DSP_WRITE_CHAR` | 1 | `[column < COLUMNS - 1] / write_char(row, column); column += 1` | `ST_DSP_WRITE_CHAR` |
| `ST_DSP_WRITE_CHAR` | 2 | `[column == COLUMNS - 1 && row < ROWS - 1] / write_char(row, column); column = 0; row += 1` | `ST_DSP_SET_CURSOR` |
| `ST_DSP_WRITE_CHAR` | 3 | `[column == COLUMNS - 1 && row == ROWS - 1] / write_char(row, column)` | `ST_DSP_IDLE` |

`ST_DSP_IDLE` sin `flag` no tiene transición: se queda en el estado. No se dibuja flecha.

## State Transition Table (para la entrega)

| Current State | Event | [Guard] | Next State | Actions |
|---|---|---|---|---|
| *(inicial)* | — | — | `ST_DSP_IDLE` | — |
| `ST_DSP_IDLE` | `EV_DSP_UPDATE` | `[flag == true]` | `ST_DSP_SET_CURSOR` | `flag = false`; `row = 0`; `column = 0` |
| `ST_DSP_SET_CURSOR` | — | — | `ST_DSP_WRITE_CHAR` | `displayCharPositionWrite(0, row)` |
| `ST_DSP_WRITE_CHAR` | — | `[column < COLUMNS − 1]` | `ST_DSP_WRITE_CHAR` | `displayDataWrite(ddram[row][column])` (o `' '`); `column++` |
| `ST_DSP_WRITE_CHAR` | — | `[column == COLUMNS − 1 && row < ROWS − 1]` | `ST_DSP_SET_CURSOR` | `displayDataWrite(...)`; `column = 0`; `row++` |
| `ST_DSP_WRITE_CHAR` | — | `[column == COLUMNS − 1 && row == ROWS − 1]` | `ST_DSP_IDLE` | `displayDataWrite(...)` |
| *(cualquier otro valor)* | — | — | `ST_DSP_IDLE` | `event = EV_DSP_IDLE`; `flag = false` (`default:`, solo en C) |

## Costo por ejecución (valores de la Actividad 01)

| Estado | Operación sobre el LCD | Costo aprox. |
|---|---|---|
| `ST_DSP_IDLE` | ninguna | ≈ 2 µs |
| `ST_DSP_SET_CURSOR` | 1 instrucción | ≈ 185 µs |
| `ST_DSP_WRITE_CHAR` | 1 dato | ≈ 148 µs |

Escritura completa del display: 1 tick en IDLE + 34 operaciones = **35 ticks (35 ms)**.
WCET esperado ≈ 185 µs < 1000 µs (antes: 6206 µs en un solo tick).
