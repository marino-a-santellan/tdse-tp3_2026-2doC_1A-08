/*
 * Copyright (c) 2026 Juan Manuel Cruz <jcruz@fi.uba.ar> <jcruz@frba.utn.edu.ar>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * @author : Juan Manuel Cruz <jcruz@fi.uba.ar> <jcruz@frba.utn.edu.ar>
 */

#ifndef TASK_SYSTEM_ATTRIBUTE_H_
#define TASK_SYSTEM_ATTRIBUTE_H_

/********************** CPP guard ********************************************/
#ifdef __cplusplus
extern "C" {
#endif

/********************** inclusions *******************************************/

/********************** macros ***********************************************/
/*Definen la cantidad de valores que tienen cada parametro. */
#define MOTOR_POWER_COUNT   2
#define MOTOR_SPEED_COUNT   10
#define MOTOR_SPIN_COUNT    2
/********************** typedef **********************************************/
/* Tipos de datos estrictos para el Setup de Motores */
typedef enum {
    PARAM_POWER = 0,
    PARAM_SPEED,
    PARAM_SPIN,
    PARAM_COUNT
} motor_param_t;

typedef enum motor_id {
    ID_MOTOR_1 = 1,
    ID_MOTOR_2
} motor_id_t;

typedef enum motor_power {
    POWER_OFF = 0,
    POWER_ON  = 1
} motor_power_t;

typedef uint8_t motor_speed_t;

typedef enum motor_spin {
    SPIN_LEFT  = 0,
    SPIN_RIGHT = 1
} motor_spin_t;

/* Estructura individual para cada motor */
typedef struct {
    motor_id_t    id;
    motor_power_t power;
    motor_speed_t speed;
    motor_spin_t  spin;
} motor_dta_t;

/* Estructura global contenedora del Menú de Configuración */
#define NUM_MOTORES 2

typedef struct {
    uint8_t       motor_idx;
    motor_param_t param_idx;
    uint8_t       temp_val;
    motor_dta_t   motores[NUM_MOTORES];
} system_setup_dta_t;

/* Events to excite Task System */
typedef enum task_system_ev {
    EV_SYS_IDLE = 0,
    EV_SYS_BTN_A,
    EV_SYS_ENTER,
    EV_SYS_NEXT,
    EV_SYS_ESCAPE
} task_system_ev_t;

/* States of Task System (Se agregan los estados del Menú de Setup) */
typedef enum task_system_st {
    ST_SYS_IDLE = 0,
    ST_SYS_ACTIVE,
    ST_MAIN,
    ST_MENU1,
    ST_MENU2,
    ST_MENU3
} task_system_st_t;

typedef struct
{
	uint32_t			tick;
	task_system_st_t	state;
	task_system_ev_t	event;
	bool				flag;
} task_system_dta_t;

/********************** external data declaration ****************************/
extern task_system_dta_t task_system_dta_list[];
extern system_setup_dta_t menu_data;
/********************** external functions declaration ***********************/

/********************** End of CPP guard *************************************/
#ifdef __cplusplus
}
#endif

#endif /* TASK_SYSTEM_ATTRIBUTE_H_ */

/********************** end of file ******************************************/
