{
  "graph": {
    "cells": [
      {
        "position": {
          "x": 0,
          "y": 0
        },
        "size": {
          "height": 10,
          "width": 10
        },
        "type": "Statechart",
        "id": "00ffb6d1-d225-4bc0-8b73-7df9987f57b7",
        "attrs": {
          "name": {
            "text": "System_Setup_Menu Export"
          },
          "specification": {
            "text": "@CycleBased(1)\n\ninterface:\n        // Eventos: uno por boton (EV_MENU_IDLE no se declara: \"sin evento\" es implicito)\n        in event EV_MENU_ENTER\n        in event EV_MENU_NEXT\n        in event EV_MENU_ESC\n\n        // Cantidades y limites\n        const MOTOR_QTY: integer = 2\n        const MENU2_MODE_QTY: integer = 3\n        const MAX_SPEED: integer = 9\n\n        // Valores de los enums de system_data.c\n        const MOTOR_1: integer = 0\n        const MOTOR_2: integer = 1\n        const MENU2_MODE_POWER: integer = 0\n        const MENU2_MODE_SPEED: integer = 1\n        const MENU2_MODE_SPIN: integer = 2\n        const OFF: integer = 0\n        const ON: integer = 1\n        const LEFT: integer = 0\n        const RIGHT: integer = 1\n\n        // Campos de task_menu_dta_t (state, event y flag no se declaran)\n        var index: integer = 0\n        var mode: integer = 0\n        var aux_power: integer = 0\n        var aux_speed: integer = 0\n        var aux_spin: integer = 0\n        \n        // Variables axuliares para guardar estado del motor actual creadas por ausencia de manipulacion de arreglos en itemis web.\n        var cur_power: integer = 0\n        var cur_speed: integer = 0\n        var cur_spin: integer = 0\n\n        // tda_motor_list[]: itemis no tiene arreglos ni structs -> una variable por campo y motor\n        var motor_1_power: integer = 1\n        var motor_1_speed: integer = 8\n        var motor_1_spin: integer = 0\n        var motor_2_power: integer = 1\n        var motor_2_speed: integer = 8\n        var motor_2_spin: integer = 0\n\n        // Pantallas del LCD (entry de cada estado)\n        operation show_main_screen(): void\n        operation show_menu1_screen(): void\n        operation show_menu2_screen(motor: integer): void\n        operation show_menu3_screen(): void\n"
          }
        },
        "z": 1
      },
      {
        "position": {
          "x": -404,
          "y": -404
        },
        "size": {
          "height": 18,
          "width": 18
        },
        "type": "Entry",
        "entryKind": "Initial",
        "attrs": {},
        "id": "e3751372-0284-4f3e-b8a7-657fd332635d",
        "z": 14,
        "embeds": [
          "2575bffe-0d94-4fd3-966c-881fc702aff5"
        ]
      },
      {
        "type": "NodeLabel",
        "label": true,
        "size": {
          "width": 15,
          "height": 15
        },
        "position": {
          "x": -404,
          "y": -389
        },
        "attrs": {
          "label": {
            "refX": "50%",
            "textAnchor": "middle",
            "refY": "50%",
            "textVerticalAnchor": "middle"
          }
        },
        "id": "2575bffe-0d94-4fd3-966c-881fc702aff5",
        "z": 15,
        "parent": "e3751372-0284-4f3e-b8a7-657fd332635d"
      },
      {
        "position": {
          "x": -474,
          "y": -295
        },
        "size": {
          "height": 96,
          "width": 208
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_MENU_MAIN",
            "fontSize": 11
          },
          "specification": {
            "text": "entry/show_main_screen()"
          }
        },
        "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b",
        "z": 17,
        "embeds": [
          "63b7e812-b0a2-42c6-af59-e79d49134bee"
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "e3751372-0284-4f3e-b8a7-657fd332635d"
        },
        "target": {
          "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "39.423%",
              "dy": "23.958%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {},
            "position": {}
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "048066c9-2bff-4831-943f-1f934c8dcb3a",
        "z": 18,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b"
        },
        "target": {
          "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "25.962%",
              "dy": "71.875%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_NEXT, EV_MENU_ESC"
              }
            },
            "position": {
              "distance": 0.4873786177464296,
              "offset": 78,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "63b7e812-b0a2-42c6-af59-e79d49134bee",
        "z": 18,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -507,
            "y": -272
          },
          {
            "x": -534,
            "y": -272
          }
        ],
        "parent": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b"
      },
      {
        "position": {
          "x": -15,
          "y": -307
        },
        "size": {
          "height": 96,
          "width": 208
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_MENU_1",
            "fontSize": 11
          },
          "specification": {
            "text": "entry/show_menu1_screen()"
          }
        },
        "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
        "z": 25
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b"
        },
        "target": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "26.923%",
              "dy": "54.167%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ENTER/index=0"
              }
            },
            "position": {}
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "71b15acf-d71a-42f0-9e7e-177b995ad633",
        "z": 26,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1"
        },
        "target": {
          "id": "17bbc96b-e802-4bf2-8b4e-ee35cc22ed7b",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "83.654%",
              "dy": "66.667%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ESC"
              }
            },
            "position": {
              "distance": 0.5239043824701195,
              "offset": -9,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "4e05e419-7c87-4d87-a0f3-966364630bcb",
        "z": 34,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "position": {
          "x": -486,
          "y": 60
        },
        "size": {
          "height": 96,
          "width": 208
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_MENU_3",
            "fontSize": 11
          },
          "specification": {
            "text": "entry/show_menu3_screen()"
          }
        },
        "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
        "z": 39,
        "embeds": []
      },
      {
        "position": {
          "x": 123,
          "y": 243
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "5ccf5aed-8384-406a-98b4-1eb8750aa037",
        "z": 47
      },
      {
        "position": {
          "x": 238,
          "y": -380
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "58825ab8-270f-4e75-9495-15c0343a87bd",
        "z": 58,
        "embeds": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1"
        },
        "target": {
          "id": "58825ab8-270f-4e75-9495-15c0343a87bd"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_NEXT"
              }
            },
            "position": {
              "distance": 0.25934540587469884,
              "offset": 5.6186676025390625,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "d52cadd7-b5df-47e4-9af4-d03b2951226f",
        "z": 59,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 295,
            "y": -275
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "58825ab8-270f-4e75-9495-15c0343a87bd"
        },
        "target": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "46.154%",
              "dy": "1.042%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[index < MOTOR_QTY - 1]\n/index++"
              }
            },
            "position": {
              "distance": 1,
              "offset": 21.93853759765625,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "eb6180e2-dfaa-4fd3-b4a4-48056fcfe416",
        "z": 59,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 245.5,
            "y": -338
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "58825ab8-270f-4e75-9495-15c0343a87bd"
        },
        "target": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "58.654%",
              "dy": "21.875%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "\nelse\n/index=0"
              }
            },
            "position": {
              "distance": 0.1612997349829966,
              "offset": 23.490005302507594,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "2f5129eb-b3d3-4c33-9682-30c17df7dc73",
        "z": 73,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 119,
            "y": -372.47
          }
        ]
      },
      {
        "position": {
          "x": -154,
          "y": 447
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "5cfaac6d-ca3b-4518-b34a-b17a4ee4ef96",
        "z": 74
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "92.308%",
              "dy": "92.708%",
              "rotate": true
            }
          },
          "priority": true
        },
        "target": {
          "id": "5cfaac6d-ca3b-4518-b34a-b17a4ee4ef96"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ENTER"
              }
            },
            "position": {
              "distance": 0.6022111599407627,
              "offset": -28.418975830078125,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "0014c2e2-d3c5-4ef6-a416-ae89ee6b547f",
        "z": 81,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -190,
            "y": 451.53
          }
        ]
      },
      {
        "position": {
          "x": -430,
          "y": 315
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "2ecbfdf7-5172-46e1-86cd-e493b3421fb0",
        "z": 89
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "74.519%",
              "dy": "98.958%",
              "rotate": true
            }
          },
          "priority": true
        },
        "target": {
          "id": "2ecbfdf7-5172-46e1-86cd-e493b3421fb0"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_NEXT"
              }
            },
            "position": {
              "distance": 0.7095454664268123,
              "offset": -6.593049972315802,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "ef475329-a24b-437d-aa2a-092ce40a03dc",
        "z": 90,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -331,
            "y": 250.53
          }
        ]
      },
      {
        "position": {
          "x": -430,
          "y": 243
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "209e3264-47bc-4b24-bca4-722e532140ae",
        "z": 91
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "2ecbfdf7-5172-46e1-86cd-e493b3421fb0"
        },
        "target": {
          "id": "209e3264-47bc-4b24-bca4-722e532140ae"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[mode == MENU2_MODE_POWER]"
              }
            },
            "position": {}
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "4bca7f1b-75d8-4947-8396-e874e42b3486",
        "z": 92,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "209e3264-47bc-4b24-bca4-722e532140ae"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "50.481%",
              "dy": "92.708%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else\n/aux_power = ON"
              }
            },
            "position": {
              "distance": 0.7752506468549136,
              "offset": -16.177276611328125,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "8913cb15-007a-45cf-80d7-503b9f439ddf",
        "z": 93,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -381,
            "y": 250.53
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "209e3264-47bc-4b24-bca4-722e532140ae"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "10.096%",
              "dy": "95.833%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[aux_power== ON]\n/aux_power = OFF"
              }
            },
            "position": {
              "distance": 0.4999999760561483,
              "offset": 4,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "3f54d89e-f5c2-4879-89a7-456e5d0fb889",
        "z": 94,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "position": {
          "x": -597,
          "y": 243
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "aa97d81d-20d1-430d-b375-f7a83388b838",
        "z": 95
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "2ecbfdf7-5172-46e1-86cd-e493b3421fb0"
        },
        "target": {
          "id": "aa97d81d-20d1-430d-b375-f7a83388b838"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[mode == MENU2_MODE_SPEED]"
              }
            },
            "position": {
              "distance": 0.386117788761371,
              "offset": 7.921010709400668,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "d65367e2-ba5b-4f30-8fd7-27136ef368f1",
        "z": 96,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "aa97d81d-20d1-430d-b375-f7a83388b838"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "4.327%",
              "dy": "87.5%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else\n/aux_speed += 1"
              }
            },
            "position": {
              "distance": 0.4385443312652753,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "02f844e3-e5ed-422d-8b7e-56ba40ddc894",
        "z": 97,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -546,
            "y": 250.53
          },
          {
            "x": -546,
            "y": 165
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "aa97d81d-20d1-430d-b375-f7a83388b838"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "1.442%",
              "dy": "65.625%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[aux_speed == MAX_SPEED]\n/aux_speed = 0"
              }
            },
            "position": {
              "distance": 0.3975238841418003,
              "offset": 7,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "d29da673-b989-4bbb-83f1-a1decce88daa",
        "z": 98,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -637,
            "y": 248.53
          },
          {
            "x": -637,
            "y": 130
          }
        ]
      },
      {
        "position": {
          "x": -430,
          "y": 378
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "3ced3c4a-adac-456c-b221-4727fc204dc7",
        "z": 99
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "2ecbfdf7-5172-46e1-86cd-e493b3421fb0"
        },
        "target": {
          "id": "3ced3c4a-adac-456c-b221-4727fc204dc7"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else"
              }
            },
            "position": {
              "distance": 0.5540835523424826,
              "offset": -11,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "e7f8f6fa-4cb1-49a5-9681-a4f4066756a0",
        "z": 100,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "3ced3c4a-adac-456c-b221-4727fc204dc7"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "7.692%",
              "dy": "27.083%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[aux_spin == LEFT]/aux_spin = RIGHT"
              }
            },
            "position": {
              "distance": 0.21877472460962824,
              "offset": 10.933090121485613,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "39c0b488-8040-4bd9-9386-8961ccd54c7c",
        "z": 101,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -714,
            "y": 385.53
          },
          {
            "x": -714,
            "y": 135
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "3ced3c4a-adac-456c-b221-4727fc204dc7"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "9.615%",
              "dy": "17.708%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else/aux_spin = LEFT"
              }
            },
            "position": {
              "distance": 0.23148089335016583,
              "offset": 8.003173828125,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "4ff78c05-3146-4304-953d-aeb0c07a225f",
        "z": 102,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -678,
            "y": 422
          },
          {
            "x": -735,
            "y": 77
          }
        ]
      },
      {
        "position": {
          "x": 11,
          "y": 31
        },
        "size": {
          "height": 96,
          "width": 208
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_MENU_2",
            "fontSize": 11
          },
          "specification": {
            "text": "\nentry/show_menu2_screen(index)"
          }
        },
        "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
        "z": 104,
        "embeds": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "8.173%",
              "dy": "1.042%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ESC"
              }
            },
            "position": {
              "distance": 0.21056828417321502,
              "offset": 11,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "65a54720-a9ce-429e-8ac5-57db61363430",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -150,
            "y": -22
          },
          {
            "x": 6,
            "y": -22
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "5cfaac6d-ca3b-4518-b34a-b17a4ee4ef96"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "8.654%",
              "dy": "71.875%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else\n/cur_spin = aux_spin"
              }
            },
            "position": {
              "distance": 0.3837839765867521,
              "offset": 61,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "111890d4-bce4-4515-b36d-937914110a83",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -96,
            "y": 493
          },
          {
            "x": -23,
            "y": 454.53
          },
          {
            "x": -23,
            "y": 148
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "5cfaac6d-ca3b-4518-b34a-b17a4ee4ef96"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "3.365%",
              "dy": "57.292%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[mode == MENU2_MODE_SPEED]\n/cur_speed = aux_speed"
              }
            },
            "position": {
              "distance": 0.45842523409500524,
              "offset": 29,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "f7380f30-2c1d-4501-9856-e513a253ac25",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -93,
            "y": 454.53
          },
          {
            "x": -93,
            "y": 238
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "5cfaac6d-ca3b-4518-b34a-b17a4ee4ef96"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "14.423%",
              "dy": "39.583%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[mode == MENU2_MODE_POWER]\n/cur_power = aux_power"
              }
            },
            "position": {
              "distance": 0.5039086961421796,
              "offset": -32.02866683977534,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "e7207977-18c2-4b95-85e7-caef58cb6255",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -152,
            "y": 156
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "5ccf5aed-8384-406a-98b4-1eb8750aa037"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "75.962%",
              "dy": "91.667%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[mode == MENU2_MODE_QTY - 1]\n/mode = 0"
              }
            },
            "position": {
              "distance": 0.48325813859770517,
              "offset": 80,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "a3006417-5c41-4072-be53-9587442b6d21",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "5ccf5aed-8384-406a-98b4-1eb8750aa037"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "88.462%",
              "dy": "69.792%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else/mode++"
              }
            },
            "position": {
              "distance": 0.8246805618317324,
              "offset": 8.101181030273438,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "97de8c3b-ac51-4ee2-b857-6beeeb37864d",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 354,
            "y": 250.53
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6"
        },
        "target": {
          "id": "114666a3-a679-416e-92a3-e5536d64a6e5",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "96.154%",
              "dy": "26.042%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ENTER\n/aux_power = cur_power;\naux_speed = cur_speed;\naux_spin  = cur_spin"
              }
            },
            "position": {
              "distance": 0.5720044404492244,
              "offset": 26,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "d579dab9-1448-4e5c-9364-8f5801df8c89",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": -241,
            "y": 60
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6"
        },
        "target": {
          "id": "5ccf5aed-8384-406a-98b4-1eb8750aa037"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_NEXT"
              }
            },
            "position": {
              "distance": 0.8086315513792858,
              "offset": -33.26354966747492,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "2e193fa7-10c3-446b-a6da-66df9e5fcd76",
        "z": 105,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 54,
            "y": 250.53
          }
        ]
      },
      {
        "position": {
          "x": 267,
          "y": -102
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "48deb716-defa-48f7-9950-5ca15df7695c",
        "z": 106
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1"
        },
        "target": {
          "id": "48deb716-defa-48f7-9950-5ca15df7695c"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ENTER\n/mode=0"
              }
            },
            "position": {
              "distance": 0.8702290076335878,
              "offset": -43,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "13e948c5-6b26-432b-9199-a33662f1b6aa",
        "z": 107,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "48deb716-defa-48f7-9950-5ca15df7695c"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "89.904%",
              "dy": "50%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[index == MOTOR_1]\n/cur_power = motor_1_power;\ncur_speed = motor_1_speed;\ncur_spin = motor_1_spin"
              }
            },
            "position": {
              "distance": 0.43038476723573826,
              "offset": -76.05996070022549,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "1186fa03-ab0c-4a3f-b40a-41c62e8e9c93",
        "z": 107,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 395,
            "y": -92.47
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "48deb716-defa-48f7-9950-5ca15df7695c"
        },
        "target": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "79.808%",
              "dy": "5.208%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else\n/cur_power = motor_2_power;\ncur_speed = motor_2_speed;\ncur_spin = motor_2_spin"
              }
            },
            "position": {
              "distance": 1,
              "offset": 35.951608657836914,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "e59f78b4-27e0-4d90-8f11-1bbb2f1be648",
        "z": 107,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 273.5,
            "y": -26
          }
        ]
      },
      {
        "position": {
          "x": 71,
          "y": -104
        },
        "size": {
          "width": 15,
          "height": 15
        },
        "type": "Choice",
        "attrs": {},
        "id": "b2c4b602-8298-49ef-973d-94687bddba84",
        "z": 110
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "25b70314-e6dd-48fc-9762-b1cb111d22c6"
        },
        "target": {
          "id": "b2c4b602-8298-49ef-973d-94687bddba84"
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "EV_MENU_ESC"
              }
            },
            "position": {
              "distance": 0.8778625954198473,
              "offset": -38,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "ce0a9c84-afa4-4dc2-b823-e027227ee863",
        "z": 111,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "b2c4b602-8298-49ef-973d-94687bddba84"
        },
        "target": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "69.231%",
              "dy": "84.375%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "[index == MOTOR_1]\n/motor_1_power = cur_power;\nmotor_1_speed  = cur_speed;\nmotor_1_spin   = cur_spin"
              }
            },
            "position": {
              "distance": 0.6493204126839403,
              "offset": 75,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "ada82c9d-f5da-4cec-9228-273bf09d03e5",
        "z": 112,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "b2c4b602-8298-49ef-973d-94687bddba84"
        },
        "target": {
          "id": "476357b8-a93c-4f1a-9c89-b4f935ce23f1",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "23.077%",
              "dy": "89.583%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "else\n/motor_2_power = cur_power;\nmotor_2_speed  = cur_speed;\nmotor_2_spin   = cur_spin"
              }
            },
            "position": {
              "distance": 0.5268399456100559,
              "offset": -7,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "9c2d952c-2948-428c-9997-aa5004ff5d63",
        "z": 113,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      }
    ]
  },
  "genModel": {
    "generator": {
      "type": "create::c",
      "features": {
        "Outlet": {
          "targetProject": "",
          "targetFolder": "",
          "libraryTargetFolder": "",
          "skipLibraryFiles": "",
          "apiTargetFolder": ""
        },
        "LicenseHeader": {
          "licenseText": ""
        },
        "FunctionInlining": {
          "inlineReactions": false,
          "inlineEntryActions": false,
          "inlineExitActions": false,
          "inlineEnterSequences": false,
          "inlineExitSequences": false,
          "inlineChoices": false,
          "inlineEnterRegion": false,
          "inlineExitRegion": false,
          "inlineEntries": false
        },
        "OutEventAPI": {
          "observables": false,
          "getters": false
        },
        "IdentifierSettings": {
          "moduleName": "SystemSetupMenu",
          "statemachinePrefix": "systemSetupMenu",
          "separator": "_",
          "headerFilenameExtension": "h",
          "sourceFilenameExtension": "c"
        },
        "Tracing": {
          "enterState": false,
          "exitState": false,
          "generic": false
        },
        "Includes": {
          "useRelativePaths": false,
          "generateAllSpecifiedIncludes": false
        },
        "GeneratorOptions": {
          "userAllocatedQueue": false,
          "metaSource": false
        },
        "GeneralFeatures": {
          "timerService": false,
          "timerServiceTimeType": ""
        },
        "Debug": {
          "dumpSexec": false
        }
      }
    }
  }
}