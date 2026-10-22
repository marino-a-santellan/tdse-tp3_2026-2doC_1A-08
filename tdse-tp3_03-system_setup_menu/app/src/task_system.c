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

/********************** inclusions *******************************************/
/* Project includes */
#include "main.h"

/* Demo includes */
#include "logger.h"
#include "dwt.h"

/* Application & Tasks includes */
#include "board.h"
#include "app.h"

#include "task_actuator_attribute.h"
#include "task_actuator_interface.h"
#include "task_display_attribute.h"
#include "task_display_interface.h"
#include "task_system_attribute.h"
#include "task_system_interface.h"

/********************** macros and definitions *******************************/
#define DEL_SYS_MIN			0ul
#define DEL_SYS_MED			250ul
#define DEL_SYS_MAX			500ul

/* Modes to excite Task System */
typedef enum task_system_mode {NORMAL, SETUP, MODE_QTY} task_system_mode_t;

#define SYSTEM_DTA_QTY	MODE_QTY

/********************** internal data declaration ****************************/
task_system_dta_t task_system_dta_list[SYSTEM_DTA_QTY];

system_setup_dta_t menu_data;

const motor_dta_t motores_cfg_list[] = {
    {ID_MOTOR_1, POWER_ON,  8, SPIN_LEFT},
    {ID_MOTOR_2, POWER_OFF, 5, SPIN_RIGHT}
};

/********************** internal functions declaration ***********************/
void task_system_normal_statechart(void);
void task_system_setup_statechart(void);

void task_system_set_mode(task_system_mode_t);

/********************** internal data definition *****************************/
const char *p_task_system 		= "Task System (System Statechart)";
const char *p_task_system_ 		= "Non-Blocking Code";
const char *p_task_system__ 	= "(Update by Time Code, period = 1mS)";

/********************** external data declaration ****************************/
task_system_mode_t g_task_system_mode;

/********************** external functions definition ************************/
void task_system_init(void *parameters)
{
	uint32_t index;
	task_system_dta_t 	*p_task_system_dta;
	task_system_st_t	state;
	task_system_ev_t	event;
	bool b_event;

	/* Print out: Task Initialized */
	LOGGER_INFO(" ");
	LOGGER_INFO("  %s is running - Tick [mS] = %lu", GET_NAME(task_system_init), HAL_GetTick());
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system_);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system__);

	init_event_task_system();

	task_system_set_mode(NORMAL);

	for (index = 0; SYSTEM_DTA_QTY > index; index++)
	{
		/* Update Task System Data Pointer */
		p_task_system_dta = &task_system_dta_list[index];

		/* Init & Print out: Task execution FSM */
		state = ST_SYS_IDLE;
		p_task_system_dta->state = state;
		if (index == SETUP) {
		            p_task_system_dta->state = ST_MAIN;
		        }
		event = EV_SYS_IDLE;
		p_task_system_dta->event = event;

		b_event = false;
		p_task_system_dta->flag = b_event;

		LOGGER_INFO(" ");
		LOGGER_INFO("   %s = %lu   %s = %lu   %s = %s",
					GET_NAME(state), (uint32_t)state,
					GET_NAME(event), (uint32_t)event,
					GET_NAME(b_event), (b_event ? "true" : "false"));
	}
	menu_data.motor_idx = 0;
	menu_data.param_idx = PARAM_POWER;
	menu_data.temp_val = 0;
	for (uint8_t i = 0; i < NUM_MOTORES; i++) {
	   menu_data.motores[i] = motores_cfg_list[i];
	}

	put_event_task_display(0, 0, "task_system_mode");
	put_event_task_display(0, 1, " NORMAL         ");

	task_system_set_mode(NORMAL);
}

void task_system_update(void *parameters)
{
	/* Run Task Statechart */
	switch (g_task_system_mode)
	{
		case NORMAL:

			task_system_normal_statechart();

			break;

		case SETUP:

			task_system_setup_statechart();

			break;

		default:

			task_system_set_mode(NORMAL);

			break;
		}
}

void task_system_normal_statechart(void)
{
	task_system_dta_t *p_task_system_dta;

	/* Update Task System Data Pointer */
	p_task_system_dta = &task_system_dta_list[NORMAL];

	if (true == any_event_task_system())
	{
		p_task_system_dta->flag = true;
		p_task_system_dta->event = get_event_task_system();
	}

	switch (p_task_system_dta->state)
	{
		case ST_SYS_IDLE:

			if ((true == p_task_system_dta->flag) && (EV_SYS_BTN_A == p_task_system_dta->event))
			{
				p_task_system_dta->flag = false;
				put_event_task_actuator(EV_LED_ACTIVE, ID_LED_A);
				p_task_system_dta->state = ST_SYS_ACTIVE;

				put_event_task_display(0, 0, "task_system_mode");
				put_event_task_display(0, 1, " SETUP          ");

				task_system_set_mode(SETUP);
			}

			break;

		case ST_SYS_ACTIVE:

			if ((true == p_task_system_dta->flag) && (EV_SYS_IDLE == p_task_system_dta->event))
			{
				p_task_system_dta->flag = false;
				put_event_task_actuator(EV_LED_IDLE, ID_LED_A);
				p_task_system_dta->state = ST_SYS_IDLE;
			}

			break;

		default:

			p_task_system_dta->tick  = DEL_SYS_MIN;
			p_task_system_dta->state = ST_SYS_IDLE;
			p_task_system_dta->event = EV_SYS_IDLE;
			p_task_system_dta->flag = false;

			break;
	}
}

void task_system_setup_statechart(void)
{
    task_system_dta_t *p_task_system_dta = &task_system_dta_list[SETUP];


    static task_system_st_t last_state = ST_SYS_ACTIVE;
    static uint8_t last_motor_idx = 255;
    static uint8_t last_param_idx = 255;
    static uint8_t last_temp_val = 255;

    const char* str_power[] = {"OFF", "ON "};
    const char* str_spin_short[] = {"L ", "R "};
    const char* str_spin_long[] = {"LEFT", "RIGHT"};
    const char* str_param[] = {"Power", "Speed", "Spin"};
    char display_buffer[24];


    if (p_task_system_dta->state != last_state ||
        menu_data.motor_idx != last_motor_idx ||
        menu_data.param_idx != last_param_idx ||
        menu_data.temp_val != last_temp_val)
    {
        last_state = p_task_system_dta->state;
        last_motor_idx = menu_data.motor_idx;
        last_param_idx = menu_data.param_idx;
        last_temp_val = menu_data.temp_val;

        switch (p_task_system_dta->state)
        {
            case ST_MAIN:
                snprintf(display_buffer, sizeof(display_buffer), "M1:%-3s Spd:%-2d %-2s",
                         str_power[menu_data.motores[0].power],
                         menu_data.motores[0].speed,
                         str_spin_short[menu_data.motores[0].spin]);
                put_event_task_display(0, 0, display_buffer);

                snprintf(display_buffer, sizeof(display_buffer), "M2:%-3s Spd:%-2d %-2s",
                         str_power[menu_data.motores[1].power],
                         menu_data.motores[1].speed,
                         str_spin_short[menu_data.motores[1].spin]);
                put_event_task_display(0, 1, display_buffer);
                break;

            case ST_MENU1:
                put_event_task_display(0, 0, "Menu #1         ");
                snprintf(display_buffer, sizeof(display_buffer), "> Motor %-8d", menu_data.motor_idx + 1); // 8 + 8 = 16
                put_event_task_display(0, 1, display_buffer);
                break;

            case ST_MENU2:
                put_event_task_display(0, 0, "Menu #2         ");
                snprintf(display_buffer, sizeof(display_buffer), "> %-14s", str_param[menu_data.param_idx]); // 2 + 14 = 16
                put_event_task_display(0, 1, display_buffer);
                break;

            case ST_MENU3:
                put_event_task_display(0, 0, "Menu #3         ");
                if (menu_data.param_idx == PARAM_POWER) {
                    snprintf(display_buffer, sizeof(display_buffer), "> %-14s", str_power[menu_data.temp_val]);
                } else if (menu_data.param_idx == PARAM_SPEED) {
                    snprintf(display_buffer, sizeof(display_buffer), "> %-14d", menu_data.temp_val);
                } else if (menu_data.param_idx == PARAM_SPIN) {
                    snprintf(display_buffer, sizeof(display_buffer), "> %-14s", str_spin_long[menu_data.temp_val]);
                }
                put_event_task_display(0, 1, display_buffer);
                break;

            default:
                break;
        }
    }

    // Procesamiento de Eventos
    if (true == any_event_task_system())
    {
        p_task_system_dta->flag = true;
        p_task_system_dta->event = get_event_task_system();
    }

    if (p_task_system_dta->flag == true)
    {
        p_task_system_dta->flag = false;

        if (p_task_system_dta->event == EV_SYS_BTN_A)
        {
            p_task_system_dta->state = ST_MAIN;
            last_state = ST_SYS_ACTIVE;

            put_event_task_display(0, 0, "task_system_mode");
            put_event_task_display(0, 1, " NORMAL         ");
            task_system_set_mode(NORMAL);
            return;
        }

        switch (p_task_system_dta->state)
        {
            case ST_MAIN:
                if (p_task_system_dta->event == EV_SYS_ENTER) {
                    menu_data.motor_idx = 0;
                    p_task_system_dta->state = ST_MENU1;
                }
                break;

            case ST_MENU1:
                switch (p_task_system_dta->event) {
                    case EV_SYS_NEXT:
                        menu_data.motor_idx = (menu_data.motor_idx + 1) % NUM_MOTORES;
                        break;
                    case EV_SYS_ESCAPE:
                        p_task_system_dta->state = ST_MAIN;
                        break;
                    case EV_SYS_ENTER:
                        menu_data.param_idx = PARAM_POWER;
                        p_task_system_dta->state = ST_MENU2;
                        break;
                    default: break;
                }
                break;

            case ST_MENU2:
                switch (p_task_system_dta->event) {
                    case EV_SYS_NEXT:
                        menu_data.param_idx = (menu_data.param_idx + 1) % PARAM_COUNT;
                        break;
                    case EV_SYS_ESCAPE:
                        p_task_system_dta->state = ST_MENU1;
                        break;
                    case EV_SYS_ENTER:
                        switch (menu_data.param_idx) {
                            case PARAM_POWER:
                                menu_data.temp_val = (uint8_t)menu_data.motores[menu_data.motor_idx].power;
                                break;
                            case PARAM_SPEED:
                                menu_data.temp_val = (uint8_t)menu_data.motores[menu_data.motor_idx].speed;
                                break;
                            case PARAM_SPIN:
                                menu_data.temp_val = (uint8_t)menu_data.motores[menu_data.motor_idx].spin;
                                break;
                            default: break;
                        }
                        p_task_system_dta->state = ST_MENU3;
                        break;
                    default: break;
                }
                break;

            case ST_MENU3:
                switch (p_task_system_dta->event) {
                    case EV_SYS_NEXT:
                        switch (menu_data.param_idx) {
                            case PARAM_POWER:
                                menu_data.temp_val = (menu_data.temp_val + 1) % MOTOR_POWER_COUNT;
                                break;
                            case PARAM_SPEED:
                                menu_data.temp_val = (menu_data.temp_val + 1) % MOTOR_SPEED_COUNT;
                                break;
                            case PARAM_SPIN:
                                menu_data.temp_val = (menu_data.temp_val + 1) % MOTOR_SPIN_COUNT;
                                break;
                            default: break;
                        }
                        break;

                    case EV_SYS_ESCAPE:
                        p_task_system_dta->state = ST_MENU2;
                        break;

                    case EV_SYS_ENTER:
                        switch (menu_data.param_idx) {
                            case PARAM_POWER:
                                menu_data.motores[menu_data.motor_idx].power = (motor_power_t)menu_data.temp_val;
                                break;
                            case PARAM_SPEED:
                                menu_data.motores[menu_data.motor_idx].speed = (motor_speed_t)menu_data.temp_val;
                                break;
                            case PARAM_SPIN:
                                menu_data.motores[menu_data.motor_idx].spin = (motor_spin_t)menu_data.temp_val;
                                break;
                            default: break;
                        }
                        p_task_system_dta->state = ST_MENU2;
                        break;
                    default: break;
                }
                break;

            default:
                p_task_system_dta->state = ST_MAIN;
                break;
        }
    }
}

void task_system_set_mode(task_system_mode_t task_system_mode)
{
	g_task_system_mode = task_system_mode;
}

/********************** end of file ******************************************/
