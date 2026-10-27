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
#define MOTOR_QTY				(sizeof(tda_motor_list)/sizeof(tda_motor_t))
#define MAX_SPEED				9ul

#define SYSTEM_MENU_DTA_QTY		1ul

/********************** internal data declaration ****************************/
task_system_menu_dta_t task_system_menu_dta_list[SYSTEM_MENU_DTA_QTY];

tda_motor_t tda_motor_list[] = {
	{MOTOR_1,ON,8,LEFT},
	{MOTOR_2,ON,8,LEFT}
};

/********************** internal functions declaration ***********************/
void task_system_statechart(void);

void show_main_screen(void);
void show_menu1_screen(void);
void show_menu2_screen(motor_id_t index);
void show_menu3_screen(void);
void show_line(uint32_t row, const char *text);

/********************** internal data definition *****************************/
const char *p_task_system 		= "Task System (System Statechart)";
const char *p_task_system_ 		= "Non-Blocking Code";
const char *p_task_system__ 	= "(Update by Time Code, period = 1mS)";

const char *p_motor_name[] = {"Motor 1", "Motor 2"};
const char *p_mode_name[]  = {"Power", "Speed", "Spin"};
const char *p_power_name[] = {"OFF", "ON"};
const char *p_spin_name[]  = {"LEFT", "RIGHT"};
const char p_spin_char[]   = {'L', 'R'};

/********************** external data declaration ****************************/

/********************** external functions definition ************************/
void task_system_init(void *parameters)
{
	uint32_t index;
	task_system_menu_dta_t 	*p_task_system_menu_dta;
	task_system_menu_st_t	state;
	task_system_ev_t		event;
	bool b_event;

	/* Print out: Task Initialized */
	LOGGER_INFO(" ");
	LOGGER_INFO("  %s is running - Tick [mS] = %lu", GET_NAME(task_system_init), HAL_GetTick());
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system_);
	LOGGER_INFO("   %s is a %s", GET_NAME(task_system), p_task_system__);

	init_event_task_system();

	for (index = 0; SYSTEM_MENU_DTA_QTY > index; index++)
	{
		/* Update Task System Data Pointer */
		p_task_system_menu_dta = &task_system_menu_dta_list[index];

		/* Init & Print out: Task execution FSM */
		state = ST_SYSTEM_MENU_MAIN;
		p_task_system_menu_dta->state = state;

		event = EV_MENU_IDLE;
		p_task_system_menu_dta->event = event;

		b_event = false;
		p_task_system_menu_dta->flag = b_event;

		p_task_system_menu_dta->index = MOTOR_1;
		p_task_system_menu_dta->mode = MENU2_MODE_POWER;

		LOGGER_INFO(" ");
		LOGGER_INFO("   %s = %lu   %s = %lu   %s = %s",
					GET_NAME(state), (uint32_t)state,
					GET_NAME(event), (uint32_t)event,
					GET_NAME(b_event), (b_event ? "true" : "false"));
	}

	show_main_screen();
}

void task_system_update(void *parameters)
{
	/* Run Task Statechart */
	task_system_statechart();
}

void task_system_statechart(void)
{
	task_system_menu_dta_t *p_task_system_menu_dta;

	/* Update Task System Data Pointer */
	p_task_system_menu_dta = &task_system_menu_dta_list[0];

	if (true == any_event_task_system())
	{
		p_task_system_menu_dta->flag = true;
		p_task_system_menu_dta->event = get_event_task_system();
	}

	switch (p_task_system_menu_dta->state)
	{
		case ST_SYSTEM_MENU_MAIN:
			if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ENTER == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->index = MOTOR_1;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_1;
				show_menu1_screen();
			}
			else if ((true == p_task_system_menu_dta->flag) && ((EV_MENU_NEXT == p_task_system_menu_dta->event) || (EV_MENU_ESC == p_task_system_menu_dta->event)))
			{
				p_task_system_menu_dta->flag = false;
				show_main_screen();
			}
			break;
		case ST_SYSTEM_MENU_1:
			if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ENTER == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->mode = MENU2_MODE_POWER;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_2;
				show_menu2_screen(p_task_system_menu_dta->index);
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_NEXT == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				if(p_task_system_menu_dta->index < MOTOR_QTY - 1){
					p_task_system_menu_dta->index++;
				}
				else{
					p_task_system_menu_dta->index = MOTOR_1;
				}
				show_menu1_screen();
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ESC == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_MAIN;
				show_main_screen();
			}
			break;
		case ST_SYSTEM_MENU_2:
			if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ENTER == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->aux_power = tda_motor_list[p_task_system_menu_dta->index].power;
				p_task_system_menu_dta->aux_speed = tda_motor_list[p_task_system_menu_dta->index].speed;
				p_task_system_menu_dta->aux_spin = tda_motor_list[p_task_system_menu_dta->index].spin;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_3;
				show_menu3_screen();
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_NEXT == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				if(p_task_system_menu_dta->mode == MENU2_MODE_QTY - 1){
					p_task_system_menu_dta->mode = MENU2_MODE_POWER;
				}
				else{
					p_task_system_menu_dta->mode++;
				}
				show_menu2_screen(p_task_system_menu_dta->index);
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ESC == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_1;
				show_menu1_screen();
			}
			break;
		case ST_SYSTEM_MENU_3:
			if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ENTER == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				if(p_task_system_menu_dta->mode == MENU2_MODE_POWER){
					tda_motor_list[p_task_system_menu_dta->index].power = p_task_system_menu_dta->aux_power;
				}
				else if(p_task_system_menu_dta->mode == MENU2_MODE_SPEED){
					tda_motor_list[p_task_system_menu_dta->index].speed = p_task_system_menu_dta->aux_speed;
				}
				else{
					tda_motor_list[p_task_system_menu_dta->index].spin = p_task_system_menu_dta->aux_spin;
				}
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_2;
				show_menu2_screen(p_task_system_menu_dta->index);
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_NEXT == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				if(p_task_system_menu_dta->mode == MENU2_MODE_POWER){
					if(p_task_system_menu_dta->aux_power == ON)
						p_task_system_menu_dta->aux_power = OFF;
					else
						p_task_system_menu_dta->aux_power = ON;
				}
				else if(p_task_system_menu_dta->mode == MENU2_MODE_SPEED){
					if(p_task_system_menu_dta->aux_speed == MAX_SPEED)
						p_task_system_menu_dta->aux_speed = 0;
					else
						p_task_system_menu_dta->aux_speed++;
				}
				else{
					if(p_task_system_menu_dta->aux_spin == LEFT)
						p_task_system_menu_dta->aux_spin = RIGHT;
					else
						p_task_system_menu_dta->aux_spin = LEFT;
				}
				show_menu3_screen();
			}
			else if ((true == p_task_system_menu_dta->flag) && (EV_MENU_ESC == p_task_system_menu_dta->event))
			{
				p_task_system_menu_dta->flag = false;
				p_task_system_menu_dta->state = ST_SYSTEM_MENU_2;
				show_menu2_screen(p_task_system_menu_dta->index);
			}
			break;
		default:
			p_task_system_menu_dta->index = MOTOR_1;
			p_task_system_menu_dta->mode = MENU2_MODE_POWER;
			p_task_system_menu_dta->state = ST_SYSTEM_MENU_MAIN;
			p_task_system_menu_dta->event = EV_MENU_IDLE;
			p_task_system_menu_dta->flag = false;
			show_main_screen();
			break;
	}
}

void show_main_screen(void)
{
	uint32_t index;
	char text[COLUMNS + 1];

	for (index = 0; MOTOR_QTY > index; index++)
	{
		snprintf(text, sizeof(text), "Motor %lu: %s,%lu,%c", index + 1,
				 p_power_name[tda_motor_list[index].power],
				 tda_motor_list[index].speed,
				 p_spin_char[tda_motor_list[index].spin]);
		show_line(index, text);
	}
}

void show_menu1_screen(void)
{
	task_system_menu_dta_t *p_task_system_menu_dta;
	char text[COLUMNS + 1];

	p_task_system_menu_dta = &task_system_menu_dta_list[0];

	show_line(0, "Menu 1");
	snprintf(text, sizeof(text), "> %s", p_motor_name[p_task_system_menu_dta->index]);
	show_line(1, text);
}

void show_menu2_screen(motor_id_t index)
{
	task_system_menu_dta_t *p_task_system_menu_dta;
	char text[COLUMNS + 1];

	p_task_system_menu_dta = &task_system_menu_dta_list[0];

	show_line(0, p_motor_name[index]);
	snprintf(text, sizeof(text), "> %s", p_mode_name[p_task_system_menu_dta->mode]);
	show_line(1, text);
}

void show_menu3_screen(void)
{
	task_system_menu_dta_t *p_task_system_menu_dta;
	char text[COLUMNS + 1];

	p_task_system_menu_dta = &task_system_menu_dta_list[0];

	snprintf(text, sizeof(text), "%s %s", p_motor_name[p_task_system_menu_dta->index],
			 p_mode_name[p_task_system_menu_dta->mode]);
	show_line(0, text);

	if(p_task_system_menu_dta->mode == MENU2_MODE_POWER)
		snprintf(text, sizeof(text), "> %s", p_power_name[p_task_system_menu_dta->aux_power]);
	else if(p_task_system_menu_dta->mode == MENU2_MODE_SPEED)
		snprintf(text, sizeof(text), "> %lu", p_task_system_menu_dta->aux_speed);
	else
		snprintf(text, sizeof(text), "> %s", p_spin_name[p_task_system_menu_dta->aux_spin]);
	show_line(1, text);
}

void show_line(uint32_t row, const char *text)
{
	char line[COLUMNS + 1];

	snprintf(line, sizeof(line), "%-*s", COLUMNS, text);
	put_event_task_display(0, row, line);
}

/********************** end of file ******************************************/
