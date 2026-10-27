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

/********************** typedef **********************************************/
/* Events to excite Task System */
typedef enum task_system_ev {EV_MENU_IDLE,
							 EV_MENU_ENTER,
							 EV_MENU_NEXT,
							 EV_MENU_ESC} task_system_ev_t;

/* State of Task System */
typedef enum task_system_menu_st {ST_SYSTEM_MENU_MAIN,
								  ST_SYSTEM_MENU_1,
								  ST_SYSTEM_MENU_2,
								  ST_SYSTEM_MENU_3} task_system_menu_st_t;

typedef enum {
	MENU2_MODE_POWER,
	MENU2_MODE_SPEED,
	MENU2_MODE_SPIN,
	MENU2_MODE_QTY
}menu2_mode_t;

typedef enum{
	OFF,
	ON
}power_t;

typedef enum{
	LEFT,
	RIGHT
}spin_t;

typedef uint32_t speed_t;

typedef enum{
	MOTOR_1,
	MOTOR_2
}motor_id_t;

typedef struct{
	motor_id_t motor_id;
	power_t power;
	speed_t speed;
	spin_t spin;
}tda_motor_t;

typedef struct
{
	motor_id_t				index;
	menu2_mode_t			mode;
	task_system_menu_st_t	state;
	task_system_ev_t		event;
	power_t					aux_power;
	speed_t					aux_speed;
	spin_t					aux_spin;
	bool					flag;
} task_system_menu_dta_t;

/********************** external data declaration ****************************/
extern task_system_menu_dta_t task_system_menu_dta_list[];

/********************** external functions declaration ***********************/

/********************** End of CPP guard *************************************/
#ifdef __cplusplus
}
#endif

#endif /* TASK_SYSTEM_ATTRIBUTE_H_ */

/********************** end of file ******************************************/
