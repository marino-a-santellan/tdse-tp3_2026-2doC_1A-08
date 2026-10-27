# TP3 – Actividad 01 – LCD Display Driver (porting C code)

Proyecto: `tdse-tp3_01-porting_c_code`

| Placa | N° de serie |
|---|---|
| NUCLEO-F103RB | `NUF103RB$KU1` |

## Objetivo

Portar el driver del display LCD 16x2 (controlador HD44780 compatible, modo 4 bits) desde
Mbed (C++) a STM32 HAL (C), verificar su funcionamiento en la placa y analizar el
cumplimiento de las restricciones temporales del ejecutor cíclico (período = 1 ms).

El archivo `app/src/display.c` es `display.cpp` del libro *A Beginner's Guide to Designing
Embedded System Applications on Arm Cortex-M Microcontrollers* (Example 6.2, *Use of a 4-Bit
Mode to Send Commands and Data to the Display*,
https://github.com/armBookCodeExamples/example_6-2).

Archivo modificado: `app/src/display.c` (único).

## Paso 07 – Orientación general del TP3

> **Consulta:** ¿Puedes ayudarme a realizar un Trabajo Práctico sobre LCD Display (porting C
> code) - System Setup (statechart - modeling - c coding)?

Fuente: guía *TA134 - TdSE - Guia TP3 - LCD Display - System Setup Menu* (Rev. 04/2025).

### 1. Qué se construye y por qué

El TP3 agrega al modelo de referencia (Sensor → System → Actuator, ejecutados por un
cyclic executive de 1 ms) dos piezas que tiene cualquier equipo real con interfaz de
usuario:

- un **actuador de salida de texto**: un display LCD de 16 caracteres × 2 líneas, con
  controlador HD44780 compatible;
- un **menú de configuración** (*System Setup Menu*) que se recorre con 3 botones y modifica
  parámetros del sistema.

El desafío central no es "hacer andar el display", sino integrarlo **sin romper las
restricciones temporales** del cyclic executive: el LCD es un periférico lento (decenas de
µs por operación, milisegundos para algunas) y el sistema no puede detenerse a esperarlo.

### 2. Hoja de ruta

| Actividad | Qué se hace | Proyecto | Entregable |
|---|---|---|---|
| 01 – LCD Display Driver | portar `display.c` de Mbed (C++) a STM32 HAL (C), cablear, verificar y medir | `tdse-tp3_01-porting_c_code` | `tdse-tp3_01-display.md` |
| 02 – LCD Display Statechart | modelar en itemis CREATE un statechart `task_display` que escriba **1 instrucción o 1 dato por ms**, y codificarlo | `tdse-tp3_02-porting_c_code` | `task_display/` (`.ysc` + `.png`), `tdse-tp3_02-display.md` |
| 03 – System Setup Menu (modeling) | modelar el menú de 4 niveles en itemis CREATE | — | `system_setup_menu/` (`.ysc` + `.png`) |
| 04 – System Setup Menu (C coding) | codificar el menú sobre el proyecto base de la cátedra, con teclado de membrana 1×4 | `tdse-tp3_03-system_setup_menu` | `tdse-tp3_04-display.md` |

Las actividades 01 y 02 corresponden al 1.er encuentro; la 03 y la 04, al 2.º.

### 3. El display HD44780 en modo 4 bits

- El controlador tiene dos registros de entrada: **IR** (instrucciones: borrar, posicionar
  el cursor, configurar) y **DR** (datos: los caracteres). La línea **RS** elige cuál
  recibe el byte (0 = instrucción, 1 = dato).
- **EN** es la señal de captura: el LCD lee el bus en el flanco de bajada.
- **RW** se conecta a GND: el display solo se escribe.
- En **modo 4 bits** se usan solo D4–D7. Cada byte viaja en dos mitades (*nibbles*), cada
  una con su pulso de EN. Ahorra 4 pines a cambio de duplicar las transferencias.
- Tiempos de la hoja de datos: > 40 ms tras el encendido, > 4,1 ms tras el primer
  *function set*, **37 µs** por instrucción o dato, **1,52 ms** para *clear display*.

### 4. Porting: de Mbed a STM32 HAL

El driver proviene del libro *A Beginner's Guide to Designing Embedded System Applications
on Arm Cortex-M Microcontrollers* (ARM), escrito sobre Mbed. Portarlo implica reemplazar
tres cosas que solo existen en Mbed:

| Mbed (C++) | STM32 (C + HAL) |
|---|---|
| `DigitalOut displayD4(D4);` (objeto cuyo constructor configura el pin) | configuración del pin en el `.ioc` → `MX_GPIO_Init()` |
| `displayD4 = value;` (operador `=` sobrecargado que escribe el pin) | `HAL_GPIO_WritePin(D4_GPIO_Port, D4_Pin, (GPIO_PinState)value);` |
| `delay(ms);` | `HAL_Delay(ms)` durante la inicialización; `systick_delay_us(37)` durante la operación |

Como el resto de la aplicación accede al display a través de `display.h`, el porting queda
confinado a un único archivo. Es un ejemplo directo del objetivo de **portabilidad /
reúso** de la materia.

### 5. El problema temporal y su solución con un statechart

Un driver que escribe una línea completa de una sola vez encadena decenas de esperas de
37 µs. Dentro de un período de 1 ms eso se vuelve inviable: la tarea retiene la CPU varios
milisegundos y el resto del sistema se atrasa. La Actividad 01 permite **medirlo**
(`WCET` en `task_dta_list[]`).

La Actividad 02 lo resuelve con el mismo recurso que el debouncing del TP2: **repartir el
trabajo en el tiempo**. Un statechart `task_display` guarda en su estructura de datos qué
fila, qué columna y qué carácter le toca, y en cada ejecución envía **una sola**
instrucción o dato. El costo por tick queda acotado (del orden de 150 µs) y el factor de
uso vuelve a ser menor que 1.

### 6. El System Setup Menu

Según el modelo de la guía:

| Nivel | Opciones | Contenido |
|---|---|---|
| Main | 1 | pantalla de estado: `Motor 1: ON, 8, L` / `Motor 2: ON, 8, L` |
| Menu #1 | 2 | `> Motor 1`, `> Motor 2` |
| Menu #2 | 3 | `> Power`, `> Speed`, `> Spin` |
| Menu #3 | 2 o 10 | Power: `ON` / `OFF` · Speed: `0`, `1`…`8`, `9` · Spin: `LEFT` / `RIGHT` |

| Botón | Efecto |
|---|---|
| **Enter** | baja un nivel (Main → #1 → #2 → #3); en el nivel #3, **guarda** el valor elegido |
| **Next** | avanza a la opción siguiente dentro del nivel (Motor 1 → Motor 2, Power → Speed…, ON → OFF…) |
| **Escape** | sube un nivel (#3 → #2 → #1 → Main) |

La guía sugiere modelar los datos con **una estructura** (`power`, `speed`, `spin`), **un
arreglo de estructuras** (una por motor) y un **índice**, y usar los pseudoestados
**Choice** de itemis CREATE para resolver las bifurcaciones según la opción seleccionada.
Eso evita un estado por cada combinación posible: el estado representa el **nivel** del
menú, y las variables, **qué opción** está seleccionada.

En la arquitectura del proyecto, los tres botones son **Sensor** (con debouncing, como en el
TP2), el menú es lógica de **System**, y el display es un **actuador** que recibe el texto
por su interfaz (`put_event_task_display`).

### 7. Traducción statechart → C (recordatorio)

Un `switch` con un `case` por estado; dentro de cada `case`, un `if` por transición
saliente (evento [guarda]), en el orden de prioridad que indica el diagrama. En el cuerpo
del `if`: enviar señales a otra tarea (`put_event_task_...`), actualizar el estado y
actualizar el `tick`. El `switch` cierra con un `default:` que lleva la máquina a su estado
seguro.

### 8. Observaciones sobre la guía

1. El Paso 04 de la Actividad 01 nombra el *Registro de Entrega* del **TP1**: corresponde
   al del TP3.
2. Los Pasos 10 de las Actividades 01 y 04 indican rutas bajo `tdse-tp3_02-porting_c_code`;
   cada documento corresponde a su propio proyecto.
3. La guía menciona **itemis CREATE Desktop**; la cátedra trabaja con el Cloud Editor.
4. En la figura del teclado de membrana (Actividad 04), el pin 4 del conector no tiene
   etiqueta (pines 1–3 → D10, D11, D12; pin 5 → GND). Se verificará contra el `.ioc` del
   proyecto base `tdse-tp3_03-system_setup_menu`.

**Alcance:** esta respuesta es una orientación general. El análisis del código del proyecto
base está en la sección siguiente (Paso 08).

## Paso 08 – Análisis app.c / app_it.c / systick.c / task_test / task_display / display

> **Consulta:** Analizar y explicar (en español), el funcionamiento del código fuente
> contenido en los archivos adjuntos: `app.c`, `app_it.c`, `systick.c`,
> `task_test_attribute.h`, `task_test.c`, `task_display_attribute.h`,
> `task_display_interface.c`, `task_display.c`, `display.h` y `display.c`. Indicar el
> comportamiento de las funciones `void task_test_statechart(void)` y
> `void task_display_statechart(void)`.

Archivos analizados:
- `app/src/app.c`
- `app/src/app_it.c`
- `app/src/systick.c`
- `app/inc/task_test_attribute.h`
- `app/src/task_test.c`
- `app/inc/task_display_attribute.h`
- `app/src/task_display_interface.c`
- `app/src/task_display.c`
- `app/inc/display.h`
- `app/src/display.c`

### 1. Qué hace el conjunto

El proyecto reemplaza el par Sensor/System/Actuator del TP2 por dos tareas, para aislar el
problema del display:

```
task_test  ──put_event_task_display()──►  task_display  ──displayXxx()──►  display.c  ──GPIO──►  LCD
(productor de texto)                       (statechart)                     (driver HD44780)
```

- `task_test` hace de **cliente**: decide **qué** mostrar y cada cuánto.
- `task_display` hace de **actuador**: decide **cuándo** escribir.
- `display.c` sabe **cómo** se habla con el HD44780.

Ambas tareas las ejecuta el mismo cyclic executive del TP2 (`app.c` + `app_it.c`), con
período de 1 ms.

### 2. Rol de cada archivo

| Archivo | Qué contiene | Capa |
|---|---|---|
| `app.c` | tabla de tareas (`task_cfg_list[]`), `app_init()`, `app_update()` y la medición de tiempos (`task_dta_list[]`) | ejecutor cíclico |
| `app_it.c` | `HAL_SYSTICK_Callback()`: incrementa `g_app_tick_cnt` cada 1 ms | base de tiempo |
| `systick.c` | `systick_delay_us()`: espera activa con resolución de µs, leyendo `SysTick->VAL` | utilidad de tiempo |
| `task_test_attribute.h` | `task_test_dta_t`: `tick` y `counter` | datos de la tarea Test |
| `task_test.c` | `task_test_init()`, `task_test_update()`, `task_test_statechart()` | lógica de la tarea Test |
| `task_display_attribute.h` | eventos (`EV_DSP_*`), estados (`ST_DSP_*`) y `task_display_dta_t`, que incluye el buffer `ddram[2][17]` | datos de la tarea Display |
| `task_display_interface.c` | `put_event_task_display()`: única puerta de entrada al display | interfaz |
| `task_display.c` | `task_display_init()`, `task_display_update()`, `task_display_statechart()` | lógica de la tarea Display |
| `display.h` | API pública del driver: `displayInit()`, `displayCharPositionWrite()`, `displayStringWrite()` | contrato del driver |
| `display.c` | implementación del protocolo HD44780 (modo 4 u 8 bits) sobre GPIO | driver (única capa que toca hardware) |

Es el mismo patrón del TP2: `*_attribute.h` (tipos y datos), `*.c` (comportamiento),
`*_interface.c` (comunicación). `task_test` **no llama a ninguna función de `display.c`**:
solo usa la interfaz de `task_display`.

### 3. Arranque: orden de inicialización

`app_init()` recorre `task_cfg_list[]` en orden y ejecuta los `init`:

```c
const task_cfg_t task_cfg_list[] = {
    {task_test_init,    task_test_update,    NULL},
    {task_display_init, task_display_update, NULL}
};
```

1. **`task_test_init()`**: carga `tick = 1000`, `counter = 0`, y envía los dos textos
   iniciales (`"LCD Display Test"` en la fila 0 y `" Porting C code "` en la fila 1). Como
   `put_event_task_display()` solo escribe en el buffer `ddram` y levanta `flag`, no toca
   el LCD (que todavía no está inicializado).
2. **`task_display_init()`**: pone `state = ST_DSP_IDLE`, `event = EV_DSP_IDLE` y
   `flag = false`; **el buffer `ddram` no se borra**. Después inicializa el LCD
   (`displayInit()`) y escribe directamente el contenido de `ddram` en las dos filas. Por
   eso los textos iniciales aparecen sin pasar por el statechart.
3. **`app_it_init()`**: pone `g_app_tick_cnt = 0`. `displayInit()` contiene unos 63 ms de
   `HAL_Delay()`, durante los cuales el SysTick siguió contando. Al reiniciar el contador
   **después** de los `init`, esos ticks se descartan y el cyclic executive arranca sin
   atraso acumulado.

El orden importa: si `task_display_init()` corriera primero, mostraría un buffer vacío y
los textos iniciales llegarían recién por el statechart, 1–2 ms más tarde.

### 4. La interfaz: un buzón con buffer de texto

```c
void put_event_task_display(uint32_t char_column, uint32_t char_row, const char *message)
{
    p_task_display_dta->event = EV_DSP_UPDATE;
    p_task_display_dta->flag  = true;

    while ((ROWS > char_row) && (COLUMNS > char_column))
    {
        if ('\0' == *message) break;
        else p_task_display_dta->ddram[char_row][char_column++] = *message++;
    }
}
```

- `ddram[ROWS][COLUMNS+1]` = `ddram[2][17]` es una copia en RAM de lo que debería verse en
  el LCD. Su nombre imita la *Display Data RAM* interna del HD44780.
- El mensaje se copia a partir de `(columna, fila)` y **se recorta** al llegar a la columna
  16: nunca escribe la posición `[16]`. Como `task_display_dta` es global (`.bss`, en cero),
  esa posición conserva el `'\0'` que termina cada fila.
- **No es una cola:** hay un solo `event` y un solo `flag`. Dos llamadas antes de que el
  display consuma se **combinan en el buffer**, y la pantalla muestra el resultado final.
  Es el comportamiento correcto para un display, que muestra un **estado** y no una
  secuencia de eventos (misma lógica que el buzón System → Actuator del TP2).

### 5. Comportamiento de `void task_test_statechart(void)`

```c
p_task_test_dta->counter++;

if (DEL_TEST_XX_MIN < p_task_test_dta->tick)
{
    p_task_test_dta->tick--;
}
else
{
    p_task_test_dta->tick = DEL_TEST_XX_MAX;
    put_event_task_display(0, 1, "Test Nro: ******");
    snprintf(test_str, sizeof(test_str), "%lu", (p_task_test_dta->counter/DEL_TEST_XX_MAX));
    put_event_task_display(10, 1, test_str);
}
```

- `counter` se incrementa **en cada ejecución** (1 por ms): es el tiempo transcurrido en
  ms desde el arranque.
- `tick` es una **cuenta regresiva no bloqueante** de 1000 ejecuciones (1 s). Mientras es
  mayor que 0, solo se decrementa y la tarea devuelve el control.
- Al llegar a 0, recarga `tick = 1000` y envía dos mensajes a la fila 1:
  1. `"Test Nro: ******"` desde la columna 0 (plantilla);
  2. el número `counter / 1000` (segundos transcurridos) desde la columna 10, que
     sobrescribe los primeros asteriscos.
  
  Las dos escrituras se combinan en el buffer y el LCD muestra `Test Nro: X*****`.
- Aunque se llama *statechart*, no tiene variable de estado: es un temporizador periódico
  con dos ramas (esperar / emitir).
- `test_str[8]` admite hasta 7 dígitos (≈ 115 días de funcionamiento continuo).

### 6. Comportamiento de `void task_display_statechart(void)`

Dos estados (`ST_DSP_IDLE`, `ST_DSP_UPDATE`), un evento útil (`EV_DSP_UPDATE`) y el `flag`
como condición de evento pendiente:

| Estado actual | Evento [guarda] | Estado siguiente | Acciones |
|---|---|---|---|
| `ST_DSP_IDLE` | `EV_DSP_UPDATE` [`flag == true`] | `ST_DSP_UPDATE` | — |
| `ST_DSP_UPDATE` | `EV_DSP_UPDATE` [`flag == true`] | `ST_DSP_IDLE` | `flag = false`; posicionar (0,0) y escribir `ddram[0]`; posicionar (0,1) y escribir `ddram[1]` |
| *(otro valor)* | — | `ST_DSP_IDLE` | `tick = 0`, `event = EV_DSP_IDLE`, `flag = false` (`default:`) |

- Cuando `task_test` envía un mensaje en el tick N, `task_display` (que se ejecuta después
  en el mismo tick) pasa a `ST_DSP_UPDATE`. En el tick N+1 reescribe el display completo:
  hay **1 ms de latencia**.
- La transición `ST_DSP_UPDATE → ST_DSP_IDLE` hace **todo el trabajo en una sola
  ejecución**: 2 posicionamientos + 32 caracteres. Cada byte cuesta 4 esperas de 37 µs en
  `display.c`, así que esa ejecución supera ampliamente el período de 1 ms (ver
  *Mediciones*). Aunque el log de la tarea la describe como *"Non-Blocking Code"*, en
  esta versión la tarea es bloqueante dentro de esa transición.
- `task_display_dta_t` ya declara `tick`, `row`, `column` y `character`, y `task_display.c`
  define `DEL_DSP_MED` / `DEL_DSP_MAX`, que esta versión no usa. Son los datos que necesita
  un statechart que escriba **de a un byte por ejecución**: la estructura está preparada
  para la Actividad 02.

### 7. El driver `display.c`

API pública (`display.h`): `displayInit(connection)`, `displayCharPositionWrite(x, y)`,
`displayStringWrite(str)`. Funciones privadas (`static`), en capas:

```
displayStringWrite / displayCharPositionWrite
        └─ displayCodeWrite(type, byte)        → RS = instrucción o dato, RW = escritura
              └─ displayDataBusWrite(byte)     → nibble alto + pulso EN; nibble bajo + pulso EN
                    └─ displayPinWrite(pin, v) → HAL_GPIO_WritePin(...)
```

- **`displayInit()`** sigue la secuencia de inicialización por software de la hoja de datos
  del HD44780: espera > 40 ms, envía tres veces *function set* de 8 bits (con las esperas
  exigidas, para llevar al controlador a un estado conocido sea cual sea su estado previo),
  pasa a 4 bits, marca `initial8BitCommunicationIsCompleted = true` y configura 2 líneas
  5×8, display apagado, *clear*, *entry mode* (incremento, sin desplazamiento) y display
  encendido sin cursor.
- **`initial8BitCommunicationIsCompleted`**: mientras es `false`, `displayDataBusWrite()`
  envía solo el nibble alto (el controlador todavía espera 8 bits y lee solo D7–D4). Una vez
  en modo 4 bits, envía los dos nibbles.
- **`displayCharPositionWrite(x, y)`**: instrucción *Set DDRAM Address* con la dirección de
  inicio de la fila (`0x00` fila 0, `0x40` fila 1) más la columna. Usa las constantes
  `DISPLAY_20x4_*`; las dos primeras coinciden con las de un 16×2.
- **`displayStringWrite(str)`**: envía cada carácter como dato (RS = 1) hasta el `'\0'`. El
  HD44780 avanza el cursor solo (*entry mode increment*).
- Solo `displayPinWrite()` conoce los pines físicos (`D4_GPIO_Port`, `D4_Pin`, …). Es el
  único punto que cambia al portar a otra plataforma.

### 8. `systick.c`: esperas de microsegundos

`systick_delay_us(delay_us)` convierte los µs pedidos en cuentas del SysTick
(`delay_us × SystemCoreClock / 1 000 000`; a 64 MHz, 37 µs = 2368 cuentas) y espera en
un bucle leyendo `SysTick->VAL`. Como el SysTick cuenta hacia abajo y se recarga al llegar a
0, contempla una vuelta del contador (`elapsed = LOAD + start − current`).

- Permite resolución de µs **sin otro timer**, reutilizando el mismo SysTick que genera la
  interrupción de 1 ms.
- Es **espera activa**: la CPU no hace otra cosa mientras espera. Además, solo contempla
  una vuelta del contador, por lo que es válida para esperas menores a un período del
  SysTick (1 ms).

### 9. `app.c` / `app_it.c`: ejecución y medición

Mismo mecanismo que en el TP2:

- `HAL_SYSTICK_Callback()` incrementa `g_app_tick_cnt` cada 1 ms.
- `app_update()` consume esos ticks (con interrupciones deshabilitadas alrededor del
  acceso, porque la variable es compartida con la ISR) y, por cada uno, ejecuta las dos
  tareas en el orden de `task_cfg_list[]`.
- Mide cada `update` con el contador de ciclos DWT y actualiza `NOE`, `LET`, `BCET` y
  `WCET` en `task_dta_list[]`.
- Si una ronda dura más de 1 ms, los ticks se acumulan y el `while
  (b_time_update_required)` ejecuta las rondas atrasadas una tras otra. No se pierden
  ticks, pero sí la periodicidad.

### 10. Evolución de las variables

| Variable | Qué es | Unidad | Tras los `init` | En cada ejecución | A lo largo de la ejecución |
|---|---|---|---|---|---|
| `task_test_dta.counter` | ejecuciones de `task_test` | ms (1 por ejecución) | 0 | +1 | crece sin techo |
| `task_test_dta.tick` | cuenta regresiva hasta el próximo mensaje | ejecuciones (ms) | 1000 | −1, o recarga a 1000 al llegar a 0 | ciclo 1000 → 0 cada 1 s |
| `task_display_dta.state` | estado del statechart | enumerado | `ST_DSP_IDLE` | pasa a `UPDATE` con `flag`; vuelve a `IDLE` tras escribir | `IDLE` casi siempre; `UPDATE` durante 1 ms por cada mensaje |
| `task_display_dta.event` | último evento recibido | enumerado | `EV_DSP_IDLE` | lo escribe `put_event_task_display()` (`EV_DSP_UPDATE`) | queda en `EV_DSP_UPDATE` desde el primer mensaje periódico (nadie lo vuelve a `IDLE`) |
| `task_display_dta.flag` | hay contenido nuevo sin mostrar | booleano | `false` | `true` al recibir mensaje; `false` al escribir el LCD | `true` durante 2 ejecuciones por segundo |
| `task_display_dta.ddram[r]` | texto de cada fila | caracteres (16 + `'\0'`) | textos de `task_test_init()` | fila 1 actualizada cada 1 s | fila 0 fija; fila 1 = `Test Nro: X*****` |
| `g_app_tick_cnt` | ticks pendientes de procesar | ticks de 1 ms | 0 | +1 por ISR, −1 por ronda | ≈ 0; sube a ≈ 6 cuando `task_display` escribe el LCD |
| `task_dta_list[i].WCET` | peor tiempo de ejecución de la tarea *i* | µs | 0 | sube si `LET` lo supera | queda fijado por la reescritura completa del LCD (ver *Mediciones*) |

### 11. Observaciones sobre el código

1. **Parámetros invertidos en el prototipo.** `task_display_interface.h` declara
   `put_event_task_display(uint32_t char_row, uint32_t char_column, ...)`, mientras que la
   definición en `task_display_interface.c` es `(char_column, char_row, ...)`. El compilador
   no lo detecta, porque en C los nombres de los parámetros del prototipo no importan, y los
   llamadores usan el orden correcto (columna, fila). Pero alguien que lea solo el `.h`
   escribiría los mensajes en la posición equivocada.
2. **Asignación redundante.** En `ST_DSP_UPDATE` se asigna `state = ST_DSP_UPDATE` y, en el
   mismo bloque, `state = ST_DSP_IDLE`. La primera no tiene efecto.
3. **El cuello de botella es la granularidad, no el driver.** `display.c` envía cada byte
   con esperas mínimas razonables; lo que excede el período es que `task_display` escriba
   34 bytes en una sola ejecución. La solución corresponde a la tarea, no al driver.
4. **La inicialización bloqueante es aceptable.** `displayInit()` bloquea del orden de
   60 ms, pero ocurre una sola vez, antes de que arranque el cyclic executive, y
   `app_it_init()` descarta los ticks acumulados.
5. **Dependencia de orden en el arranque.** Los textos iniciales llegan al LCD porque
   `task_test_init()` corre antes que `task_display_init()` y este último no borra
   `ddram`. Si se cambiara el orden de `task_cfg_list[]`, el comportamiento visible
   cambiaría (sin error de compilación).
6. **Los `LOGGER_INFO` están solo en los `init`**: no contaminan el `WCET` de los `update`
   (ver análisis del logger en el TP2).

**Alcance:** este análisis describe el comportamiento del código. Los tiempos medidos y la
verificación de las restricciones del cyclic executive están en la sección *Mediciones*;
la versión no bloqueante de `task_display` corresponde a la Actividad 02.

## Porting de `display.c`

### Estado inicial

El proyecto importado no compila: **Build Failed. 14 errors, 7 warnings**, todos en
`display.c`. El código usa clases y funciones de Mbed que no existen en STM32 HAL.

### Recursos identificados

| Tipo | Elementos en `display.cpp` |
|---|---|
| Recursos de HW | `D4`, `D5`, `D6`, `D7`, `D8`, `D9` (header Arduino de la Nucleo) |
| Clases | `DigitalOut` (salida digital) |
| Métodos / operadores | constructor `DigitalOut(pin)`, operador `=` sobrecargado (escritura del pin), `delay(ms)` |

Las líneas de los pines `D0`–`D3` (modo 8 bits) ya venían comentadas: no se usan en modo
4 bits.

### Cambios realizados

**1. Instanciación de objetos → configuración del `.ioc`.**
Se eliminaron las declaraciones `DigitalOut displayD4( D4 );` … `DigitalOut displayEn( D9 );`.
En Mbed el constructor configura el pin como salida; en STM32 esa configuración se define en
`tdse-tp3_01-porting_c_code.ioc` y la ejecuta `MX_GPIO_Init()` (generado por STM32CubeMX)
antes de `app_init()`. El `.ioc` del proyecto base ya incluía los seis pines como
`GPIO_Output`, con las etiquetas que generan las macros `Dx_Pin` / `Dx_GPIO_Port` en
`main.h`:

| Señal LCD | Header Arduino | Pin STM32 | Macros (`main.h`) |
|---|---|---|---|
| D4 | D4 | PB5 | `D4_GPIO_Port`, `D4_Pin` |
| D5 | D5 | PB4 | `D5_GPIO_Port`, `D5_Pin` |
| D6 | D6 | PB10 | `D6_GPIO_Port`, `D6_Pin` |
| D7 | D7 | PA8 | `D7_GPIO_Port`, `D7_Pin` |
| RS | D8 | PA9 | `D8_GPIO_Port`, `D8_Pin` |
| EN | D9 | PC7 | `D9_GPIO_Port`, `D9_Pin` |

PB4 es `NJTRST` (JTAG) después del reset. Queda disponible como GPIO porque la
configuración *SYS → Debug: Serial Wire* genera `__HAL_AFIO_REMAP_SWJ_NOJTAG()` en
`stm32f1xx_hal_msp.c`.

**2. Gestión de objetos → `HAL_GPIO_WritePin()`.**
En `displayPinWrite()`, rama `DISPLAY_CONNECTION_GPIO_4BITS`, cada asignación
`displayXX = value;` se reemplazó por:

```c
HAL_GPIO_WritePin(Dn_GPIO_Port, Dn_Pin, (GPIO_PinState)value);
```

El `case DISPLAY_PIN_RW` se conserva sin acción: la línea RW está conectada a GND (el LCD
solo se escribe), por lo que no tiene GPIO asociado.

**3. Demoras bloqueantes → `HAL_Delay()` / `systick_delay_us()`.**

| Función | Original | Reemplazo | Justificación |
|---|---|---|---|
| `displayInit()` | `delay(50)` | `HAL_Delay(50)` | > 40 ms tras el encendido (HD44780) |
| `displayInit()` | `delay(5)` | `HAL_Delay(5)` | > 4,1 ms tras el primer *function set* |
| `displayInit()` | `delay(1)` (×9) | `HAL_Delay(1)` | se ejecuta una sola vez, antes del ejecutor cíclico; incluye *clear display* (1,52 ms) |
| `displayCharPositionWrite()` | `delay(1)` (×4) | `systick_delay_us(DISPLAY_DEL_37US)` | tiempo de ejecución de una instrucción: 37 µs |
| `displayDataBusWrite()` | `delay(1)` (×4) | `systick_delay_us(DISPLAY_DEL_37US)` | ídem, por cada pulso de EN |

Resultado: **Build Finished. 0 errors, 0 warnings.**

## Conexión del LCD Display

| Pin LCD | Señal | Conexión |
|---|---|---|
| 1 | VSS | GND |
| 2 | VDD | +5V (CN6) |
| 3 | VO | cursor del trimpot 10 kΩ lineal (extremos a +5V y GND), ajuste de contraste |
| 4 | RS | D8 (PA9) |
| 5 | RW | GND (solo escritura) |
| 6 | E | D9 (PC7) |
| 7–10 | D0–D3 | sin conexión (modo 4 bits) |
| 11–14 | D4–D7 | D4 (PB5), D5 (PB4), D6 (PB10), D7 (PA8) |
| 15 | A | +5V a través de resistencia de 1 kΩ (backlight) |
| 16 | K | GND |

Las salidas GPIO de 3,3 V son reconocidas como nivel alto por el HD44780 alimentado a 5 V
(V_IH ≈ 2,2 V), por lo que no se requiere adaptación de nivel. RW a GND garantiza que el LCD
nunca maneje el bus de datos.

## Verificación (depuración)

Depuración con **ST-LINK (OpenOCD)**, *Reset Mode: Software system reset* y
`monitor arm semihosting enable`.

- `task_test_init()` envía a la interfaz del display:
  - Línea 1: `"LCD Display Test"`
  - Línea 2: `" Porting C code "`
- `task_test_update()` envía, cada 1 s:
  - Línea 2: `"Test Nro: X*****"` (X se incrementa cada segundo)
- Ambos mensajes se observan correctamente en el LCD.

## Mediciones: `task_dta_list[]`

Valores leídos tras varias ejecuciones de `app_update()` (CPU suspendida, vista
*Expressions*), en dos lecturas separadas por varios segundos de ejecución. Build **Debug**,
`SystemCoreClock` = 64 MHz.

| Campo | Descripción | `task_test` [0] | `task_display` [1] | Unidad |
|---|---|---|---|---|
| `NOE` | Number Of Executions | 18855 → 26557 | 18855 → 26557 | ejecuciones |
| `LET` | Last Execution Time | 2 | 2 | µs |
| `BCET` | Best-Case Execution Time | 2 | 2 | µs |
| `WCET` | Worst-Case Execution Time | 36 | 6206 | µs |

`g_app_cnt` coincide con `NOE` en ambas lecturas. El `WCET` no varió entre lecturas.

### Análisis

**Origen del WCET de `task_display`.** Al recibir un mensaje, `task_display_statechart()`
reescribe las dos filas completas (2 posicionamientos de cursor + 32 caracteres). Cada byte
en modo 4 bits se envía en dos nibbles, cada uno con un pulso de EN y dos esperas de 37 µs:

| Operación | Esperas de 37 µs | Tiempo |
|---|---|---|
| 1 byte (2 nibbles) | 4 | 148 µs |
| 2 posicionamientos de cursor | 2 × 5 | 370 µs |
| 32 caracteres | 32 × 4 | 4736 µs |
| **Total en esperas** | | **≈ 5106 µs** |

La diferencia con el valor medido (≈ 1100 µs) corresponde al overhead de ~13 llamadas a
`HAL_GPIO_WritePin()` por byte, la selección en `displayPinWrite()` y el propio bucle de
`systick_delay_us()`. La medición es consistente con el código.

El `WCET` de `task_test` (36 µs) corresponde a la ejecución que, cada 1000 ticks, invoca
`snprintf()` y `put_event_task_display()` dos veces.

**Factor de uso de CPU (peor caso):**

```
U = (WCET_test + WCET_display) / T_systick = (36 µs + 6206 µs) / 1000 µs = 6,24
```

**U > 1: no se cumplen las restricciones temporales del ejecutor cíclico.**

**Consecuencias.** Durante los ≈ 6,2 ms que `task_display_update()` retiene la CPU, la
interrupción del SysTick continúa incrementando `g_app_tick_cnt`. Al finalizar,
`app_update()` ejecuta los ciclos acumulados uno tras otro (`while (b_time_update_required)`).
No se pierden ticks (`g_app_cnt` = `NOE`), pero se pierde la periodicidad: durante ese
intervalo ninguna tarea se ejecuta a tiempo y luego se ejecutan en ráfaga (jitter de hasta
≈ 6 ms). En un sistema con sensores, eso se traduce en latencia adicional en la detección de
eventos.

El uso promedio es bajo (una reescritura por segundo ≈ 6,2 ms / 1000 ms ≈ 0,6 %), pero la
restricción del ejecutor cíclico se evalúa sobre el peor caso.

### Conclusión

El porting es funcionalmente correcto: el driver opera el LCD con STM32 HAL sin modificar
ninguna otra capa de la aplicación. Sin embargo, el driver **sigue siendo bloqueante**.
Reemplazar `delay(1)` por esperas de 37 µs reduce el costo por byte de ≈ 2 ms a ≈ 148 µs,
pero escribir el contenido completo del display (34 bytes) en una sola ejecución de la tarea
excede el período del SysTick. La solución requiere distribuir la escritura en el tiempo:
enviar **una instrucción o un dato por ejecución** (≈ 150 µs, U < 1), que es el objetivo del
statechart `task_display` de la Actividad 02.
