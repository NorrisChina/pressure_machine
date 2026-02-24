/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface general definitions

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG, 12.7.12 - V2.73
  - 16 Control Channels handled:
    - MAX_CTRL changed from 3 to 16
    - CTRL_SENSOR_3 to CTRL_SENSOR_15 defined
    - SENSOR_D renamed to SENSOR_3
    - SENSOR_DP defined

  HEG, 13.2.14 - V2.78
  - Missing DoPE error definition DoPERR_CMD_NIM implemented
*******************************************************************************/


#ifndef DoPEgeneral_INCLUDED
#define DoPEgeneral_INCLUDED


/************************* Constants and Definitions **************************/

  #define DoPEAPIVERSION     0x0291     /* DoPE version number               */

/* -------- Definitions of max. values -------------------------------------- */

  #define MAX_MC      16            /* maximum number of sensors              */
  #define MAX_OC      16            /* maximum number of output channels      */
  #define MAX_BIN     10            /* maximum number of digital inputs       */
  #define MAX_BOUT    10            /* maximum number of digital outputs      */
  #define MAX_CTRL    16            /* maximum number of control channels     */
  #define MAX_MACHINE 8             /* maximum number of machine definitions  */
  #define MAX_MODULE  32            /* maximum number of modules              */

/* ----------------- Logical channel definitions ---------------------------- */

  /* -------------- Measuring channels -------------------------------------- */

  #define  SENSOR_S     0                /*  X-head position                  */
  #define  SENSOR_F     1                /*  Load                             */
  #define  SENSOR_E     2                /*  Extension                        */
  #define  SENSOR_3     3                /*  Sensor 3                         */
  #define  SENSOR_4     4                /*  Sensor 4                         */
  #define  SENSOR_5     5                /*  Sensor 5                         */
  #define  SENSOR_6     6                /*  Sensor 6                         */
  #define  SENSOR_7     7                /*  Sensor 7                         */
  #define  SENSOR_8     8                /*  Sensor 8                         */
  #define  SENSOR_9     9                /*  Sensor 9                         */
  #define  SENSOR_10    10               /*  Sensor 10                        */
  #define  SENSOR_11    11               /*  Sensor 11                        */
  #define  SENSOR_12    12               /*  Sensor 12                        */
  #define  SENSOR_13    13               /*  Sensor 13                        */
  #define  SENSOR_14    14               /*  Sensor 14                        */
  #define  SENSOR_15    15               /*  Sensor 15                        */
  #define  SENSOR_DP    0xFFFF           /*  Digipoti                         */

  /* --------------- Analogue output channels ------------------------------- */

  #define  COMMAND_OUT  0                /*   Command output                  */
  #define  OUT_1        1                /*   Optional channel 1              */
  #define  OUT_2        2                /*   Optional channel 2              */
  #define  OUT_3        3                /*   Optional channel 3              */
  #define  OUT_4        4                /*   Optional channel 4              */
  #define  OUT_5        5                /*   Optional channel 5              */
  #define  OUT_6        6                /*   Optional channel 6              */
  #define  OUT_7        7                /*   Optional channel 7              */
  #define  OUT_8        8                /*   Optional channel 8              */
  #define  OUT_9        9                /*   Optional channel 9              */
  #define  OUT_10       10               /*   Optional channel 10             */
  #define  OUT_11       11               /*   Optional channel 11             */
  #define  OUT_12       12               /*   Optional channel 12             */
  #define  OUT_13       13               /*   Optional channel 13             */
  #define  OUT_14       14               /*   Optional channel 14             */
  #define  OUT_15       15               /*   Optional channel 15             */

  /* --------------- Digital inputs ----------------------------------------- */

  #define  BIN_0        0                /*  Digital input 0                  */
  #define  BIN_1        1                /*  Digital input 1                  */
  #define  BIN_2        2                /*  Digital input 2                  */
  #define  BIN_3        3                /*  Digital input 3                  */
  #define  BIN_4        4                /*  Digital input 4                  */
  #define  BIN_5        5                /*  Digital input 5                  */
  #define  BIN_6        6                /*  Digital input 6                  */
  #define  BIN_7        7                /*  Digital input 7                  */
  #define  BIN_8        8                /*  Digital input 8                  */
  #define  BIN_9        9                /*  Digital input 9                  */

  /* --------------- Digital outputs ---------------------------------------- */

  #define  BOUT_0       0                /*  Digital output 0                 */
  #define  BOUT_1       1                /*  Digital output 1                 */
  #define  BOUT_2       2                /*  Digital output 2                 */
  #define  BOUT_3       3                /*  Digital output 3                 */
  #define  BOUT_4       4                /*  Digital output 4                 */
  #define  BOUT_5       5                /*  Digital output 5                 */
  #define  BOUT_6       6                /*  Digital output 6                 */
  #define  BOUT_7       7                /*  Digital output 7                 */
  #define  BOUT_8       8                /*  Digital output 8                 */
  #define  BOUT_9       9                /*  Digital output 9                 */

/* ---------------- Constants for DoPE commands  ---------------------------- */


  /* ----- Connector constants ---------------------------------------------- */

  #define  CON_NON   0x00
  #define  CON_X1    0x01
  #define  CON_X2    0x02
  #define  CON_X3    0x03
  #define  CON_X4    0x04
  #define  CON_X5    0x05
  #define  CON_X7    0x07
  #define  CON_X10   0x0A
  #define  CON_X14   0x0E
  #define  CON_X21A  0x15
  #define  CON_X21B  0x55
  #define  CON_X21C  0x95
  #define  CON_X21D  0xD5
  #define  CON_X22A  0x16
  #define  CON_X22B  0x56
  #define  CON_X22C  0x96
  #define  CON_X22D  0xD6
  #define  CON_X23A  0x17
  #define  CON_X23B  0x57
  #define  CON_X23C  0x97
  #define  CON_X23D  0xD7
  #define  CON_X24A  0x18
  #define  CON_X24B  0x58
  #define  CON_X24C  0x98
  #define  CON_X24D  0xD8
  #define  CON_X25A  0x19
  #define  CON_X25B  0x59
  #define  CON_X25C  0x99
  #define  CON_X25D  0xD9
  #define  CON_X26A  0x1A
  #define  CON_X26B  0x5A
  #define  CON_X26C  0x9A
  #define  CON_X26D  0xDA
  #define  CON_X27A  0x1B
  #define  CON_X27B  0x5B
  #define  CON_X27C  0x9B
  #define  CON_X27D  0xDB
  #define  CON_X28A  0x1C
  #define  CON_X28B  0x5C
  #define  CON_X28C  0x9C
  #define  CON_X28D  0xDC
  #define  CON_X36A  0x24
  #define  CON_X36B  0x64
  #define  CON_X37A  0x25
  #define  CON_X37B  0x65
  #define  CON_X38A  0x26
  #define  CON_X38B  0x66
  #define  CON_X39A  0x27
  #define  CON_X39B  0x67
  #define  CON_X61A  0x3D
  #define  CON_X61B  0x7D
  #define  CON_X61C  0xBD
  #define  CON_X61D  0xFD
  #define  CON_X62A  0x3E
  #define  CON_X62B  0x7E
  #define  CON_X62C  0xBE
  #define  CON_X62D  0xFE
  #define  CON_X63A  0x3F


  /* ----- Constants for closed loop control modes -------------------------- */

  #define CTRL_POS       0                  /*  X-Head position control       */
  #define CTRL_LOAD      1                  /*  Load control                  */
  #define CTRL_EXTENSION 2                  /*  Extension control             */
  #define CTRL_SENSOR_3  3                  /*  Sensor 3  control             */
  #define CTRL_SENSOR_4  4                  /*  Sensor 4  control             */
  #define CTRL_SENSOR_5  5                  /*  Sensor 5  control             */
  #define CTRL_SENSOR_6  6                  /*  Sensor 6  control             */
  #define CTRL_SENSOR_7  7                  /*  Sensor 7  control             */
  #define CTRL_SENSOR_8  8                  /*  Sensor 8  control             */
  #define CTRL_SENSOR_9  9                  /*  Sensor 9  control             */
  #define CTRL_SENSOR_10 10                 /*  Sensor 10 control             */
  #define CTRL_SENSOR_11 11                 /*  Sensor 11 control             */
  #define CTRL_SENSOR_12 12                 /*  Sensor 12 control             */
  #define CTRL_SENSOR_13 13                 /*  Sensor 13 control             */
  #define CTRL_SENSOR_14 14                 /*  Sensor 14 control             */
  #define CTRL_SENSOR_15 15                 /*  Sensor 15 control             */


  /* ----- Bit constants for measuring channels ----------------------------- */

  #define MCBIT_S        0x0001
  #define MCBIT_F        0x0002
  #define MCBIT_E        0x0004
  #define MCBIT_D        0x0008
  #define MCBIT_4        0x0010
  #define MCBIT_5        0x0020
  #define MCBIT_6        0x0040
  #define MCBIT_7        0x0080
  #define MCBIT_8        0x0100
  #define MCBIT_9        0x0200
  #define MCBIT_10       0x0400
  #define MCBIT_11       0x0800
  #define MCBIT_12       0x1000
  #define MCBIT_13       0x2000
  #define MCBIT_14       0x4000
  #define MCBIT_15       0x8000


  /* ------ Constants  for 'Action' in  DoPESetCheck(X) --------------------- */
  /* ------ Constants  for 'Action' in  DoPEShieldLimit --------------------- */
  /* ------ for DoPEShieldLimit only ACTION_HALT and ACTION_STOP are allowed !*/

  #define  ACTION_HALT       0      /* HALT with default deceleration         */
  #define  ACTION_HALT_A     1      /* HALT with specified deceleration       */
  #define  ACTION_POS        2      /* Position with default deceleration     */
  #define  ACTION_POS_A      3      /* Position with specified deceleration   */
  #define  ACTION_XPCONT     4      /* Change control mode, go on with        */
                                    /* current speed                          */
  #define  ACTION_STOP       5      /* STOP (switch off drive)                */
  #define  ACTION_NOACTION   6      /* No action, only message to host        */
  #define  ACTION_SETOL      7      /* Set command output in open loop        */
  #define  ACTION_SHALT      8      /* immediate S-Halt                       */
  #define  ACTION_UP         9      /* Move Up with specified speed           */
  #define  ACTION_DOWN       10     /* Move Down with specified speed         */
  #define  ACTION_DRIVE_OFF  11     /* Switch drive OFF                       */

//------------------------------------------------------------------------------

                                      /* Error constants                      */
                                      /* ------------------------------------ */
  #define DoPERR_NOERROR            0 /* No error                             */
  #define DoPERR_NOFLOAT            1 /* No float in WIN16 callback           */
  #define DoPERR_SYNC               2 /* Synchronisation to callback failed   */
  #define DoPERR_TIMEOUT            3 /* Timeout at await answer              */
  #define DoPERR_NOFNC              4 /* Function not implemented             */
  #define DoPERR_VERSION            5 /* No compatible Version EDC-DoPE       */
  #define DoPERR_INIT               6 /* Initialisation Error Subsystem       */
  #define DoPERR_PARAMETER          7 /* Invalid parameter                    */
  #define DoPERR_SETUPOPEN          8 /* Setup open error                     */
  #define DoPERR_RTE_UNHANDLED      9 /* Unhandled runtime error              */

  /* Command errors                                                           */
  #define DoPERR_CMD_PARCORR     1001 /* Error in parameter (corrected)       */
  #define DoPERR_CMD_PAR         1003 /* Error in parm. not correctable       */
  #define DoPERR_CMD_XMOVE       1004 /* X-Head is not halted                 */
  #define DoPERR_CMD_INITSEQ     1005 /* Sequence in init. not observed       */
  #define DoPERR_CMD_NOTINIT     1006 /* Controller part not initialised      */
  #define DoPERR_CMD_DIR         1007 /* Movement direction  not possible     */
  #define DoPERR_CMD_TMP         1008 /* Required resource not available      */
  #define DoPERR_CMD_RUNTIME     1009 /* Run time error active                */
  #define DoPERR_CMD_INTERN      1010 /* Internal error in subsystem          */
  #define DoPERR_CMD_MEM         1011 /* Insufficient memory                  */
  #define DoPERR_CMD_CST         1012 /* Wrong controller Structure           */
  #define DoPERR_CMD_NIM         1013 /* Command not implemented              */
  #define DoPERR_CMD_MSGNO       2001 /* Unknown message number               */
  #define DoPERR_CMD_VERSION     2003 /* Wrong PE interface version           */
  #define DoPERR_CMD_OPEN        2004 /* Setup not opened                     */
  #define DoPERR_CMD_MEMORY      2005 /* Not enough memory                    */

  /* Machine normalisation errors                                             */
  #define DoPERR_PARMS         0x4001 /* Parameter Error                      */
  #define DoPERR_ZERODIV       0x4002 /* Division by ZERO                     */
  #define DoPERR_OVFLOW        0x4003 /* Overflow                             */
  #define DoPERR_NIN           0x4004 /* Not Initialised                      */

  /* Low level communication errors                                           */
  #define DoPERR_NODATA        0x8001 /* No receiver data available           */
  #define DoPERR_NOBUFFER      0x8002 /* No transmitter buffer available      */
  #define DoPERR_OFFLINE       0x8003 /* Connection is offline                */
  #define DoPERR_HANDLE        0x8004 /* Invalid DoPE handle                  */
  #define DoPERR_MSGSIZE       0x8005 /* Message to long                      */
  #define DoPERR_COMPARAMETER  0x8006 /* Invalid com.driver parameter         */
  #define DoPERR_NOMEM         0x8007 /* Not enough heap memory               */
  #define DoPERR_BADPORT       0x8008 /* Invalid device ID                    */
  #define DoPERR_BAUDRATE      0x8009 /* Invalid baudrate                     */
  #define DoPERR_OPEN          0x800A /* Device already in use/File open error*/
  #define DoPERR_HARDWARE      0x800B /* Device not present                   */
  #define DoPERR_NOTOPEN       0x800C /* Connection not open                  */
  #define DoPERR_PORTLIMIT     0x800D /* Unused                               */
  #define DoPERR_NOTIMER       0x800E /* No timer for timeout check           */
  #define DoPERR_NODRIVER      0x800F /* No driver available                  */
  #define DoPERR_NOTHREAD      0x8010 /* Win32: Thread creation failed        */
  #define DoPERR_BADOS         0x8011 /* Not supported operating system       */
  #define DoPERR_THUNK         0x8012 /* Win32: Thread creation failed        */

  #define DoPERR_INTERNAL ((unsigned)-1)  /* Internal driver error            */


  //----------------------------------------------------------------------------

  typedef  void  *DoPE_HANDLE;       /* Handle for DoPE link                  */


#endif
