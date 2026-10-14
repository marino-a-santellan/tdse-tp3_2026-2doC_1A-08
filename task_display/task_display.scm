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
            "text": "task_display_statechart Export"
          },
          "specification": {
            "text": "@CycleBased(5000)\ninterface:\n    var flag:      boolean = false\n    var row:       integer = 0\n    var column:    integer = 0\n    const ROWS:    integer = 2\n    const COLUMNS: integer = 16\n    operation set_cursor(r:integer,col:integer):void\n    operation write_char(r:integer,col:integer):void\n"
          }
        },
        "z": 1
      },
      {
        "position": {
          "x": -259.5,
          "y": -286
        },
        "size": {
          "height": 18,
          "width": 18
        },
        "type": "Entry",
        "entryKind": "Initial",
        "attrs": {},
        "id": "3d5dd804-0c1c-4097-9a07-57fbc7f30090",
        "z": 3,
        "embeds": [
          "58a37bfc-01d7-45ab-8b2c-9e230fb92e03"
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
          "x": -259.5,
          "y": -271
        },
        "attrs": {
          "label": {
            "refX": "50%",
            "textAnchor": "middle",
            "refY": "50%",
            "textVerticalAnchor": "middle"
          }
        },
        "id": "58a37bfc-01d7-45ab-8b2c-9e230fb92e03",
        "z": 4,
        "parent": "3d5dd804-0c1c-4097-9a07-57fbc7f30090"
      },
      {
        "position": {
          "x": -323,
          "y": -164
        },
        "size": {
          "height": 64,
          "width": 141
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_DSP_IDLE",
            "fontSize": 11
          },
          "specification": {
            "show": false
          }
        },
        "id": "1b0f9fa4-5a5a-4aca-8de2-d14c81fdb314",
        "z": 22,
        "embeds": []
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "3d5dd804-0c1c-4097-9a07-57fbc7f30090"
        },
        "target": {
          "id": "1b0f9fa4-5a5a-4aca-8de2-d14c81fdb314",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "49.645%",
              "dy": "9.375%",
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
        "id": "1fcec64f-e92e-4efd-8ca8-802e26374914",
        "z": 23,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "position": {
          "x": 161,
          "y": -175
        },
        "size": {
          "height": 60,
          "width": 178
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_DSP_SET_CURSOR",
            "fontSize": 11
          },
          "specification": {
            "show": false
          }
        },
        "id": "b652a1b4-ae84-4403-bce7-fa4faa9b590d",
        "z": 30,
        "embeds": []
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "1b0f9fa4-5a5a-4aca-8de2-d14c81fdb314"
        },
        "target": {
          "id": "b652a1b4-ae84-4403-bce7-fa4faa9b590d",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "12.023%",
              "dy": "65%",
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
                "text": "[flag]/ flag = false; row=0; column=0"
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
        "id": "b4f62097-a126-44af-9a95-fbbaf0045ca7",
        "z": 31,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "position": {
          "x": 150,
          "y": 130
        },
        "size": {
          "height": 60,
          "width": 178
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "ST_DSP_WRITE_CHAR",
            "fontSize": 11
          },
          "specification": {
            "show": false
          }
        },
        "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65",
        "z": 39,
        "embeds": [
          "acfd4545-58f7-4b64-b9a0-f20ef91a3e10"
        ]
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "b652a1b4-ae84-4403-bce7-fa4faa9b590d"
        },
        "target": {
          "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "50.562%",
              "dy": "23.333%",
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
                "text": "always/\nset_cursor(row,0)"
              }
            },
            "position": {
              "distance": 0.09574468085106383,
              "offset": 51,
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
        "id": "c58e5a60-c545-4143-9c1f-443de85195a7",
        "z": 40,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65"
        },
        "target": {
          "id": "1b0f9fa4-5a5a-4aca-8de2-d14c81fdb314",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "33.333%",
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
                "text": "[column == COLUMNS - 1 && row == ROWS - 1]\n/write_char(row, column)"
              }
            },
            "position": {
              "distance": 0.44576613783838687,
              "offset": -21,
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
        "id": "782ab936-79f1-4ab3-bfdb-66da8b04e44c",
        "z": 40,
        "router": {
          "name": "orthogonal"
        },
        "vertices": []
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65"
        },
        "target": {
          "id": "b652a1b4-ae84-4403-bce7-fa4faa9b590d",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "72.472%",
              "dy": "83.333%",
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
                "text": "[column == COLUMNS - 1 && row < ROWS - 1]\n/ write_char(row, column);\ncolumn = 0;\nrow += 1"
              }
            },
            "position": {
              "distance": 0.10627526368036017,
              "offset": 123,
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
        "id": "9fc48d9d-f1f5-408e-b291-14c5dd0f834c",
        "z": 40,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 291,
            "y": 35
          }
        ]
      },
      {
        "type": "Transition",
        "attrs": {
          "specification": {
            "show": false
          }
        },
        "source": {
          "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65"
        },
        "target": {
          "id": "3a97e5e4-825e-42a0-a743-f8a0773eda65",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "32.584%",
              "dy": "68.333%",
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
                "text": "[column < COLUMNS - 1] / write_char(row,column);column+=1"
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
        "id": "acfd4545-58f7-4b64-b9a0-f20ef91a3e10",
        "z": 40,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [
          {
            "x": 239,
            "y": 211
          }
        ],
        "parent": "3a97e5e4-825e-42a0-a743-f8a0773eda65"
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
          "moduleName": "TaskDisplayExport",
          "statemachinePrefix": "taskDisplayExport",
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