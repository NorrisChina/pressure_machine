/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface setup and sensor handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG, 12.7.12 - V2.73
  - Application / DoPE versionhandling removed
  - 16 Control Channels handled
  - Mc2Output modified

  HEG, 26.7.13 - V 2.76
  - New DoPE function:
    - DoPEWrSensorHeaderData

  HEG, 31.10.13 - V 2.77
  - New  parameters in DoPESumSenInfo:
    - Tare
    - UserScale
    - McIntegr
    - CtrlIntegr
    - HwDelayTime
    - McDelayTime
    - McDelayTimeCorr

  HEG, 24.8.15 - V 2.82
  - New DoPE function:
    - DoPESetNominalAccSpeed(Sync)

  HEG, 29.7.16 - V2.84
  - New DoPE functions:
    - DoPEReInitialize
    - DoPEReInitializeEnable
*******************************************************************************/


#ifndef DoPEsetup_INCLUDED
#define DoPEsetup_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

//----------------------------------------------------------------------------

enum                                   /* Units for sensors                 */
{                                      /* --------------------------------- */
  UNIT_NO                            , /* No unit                           */
  UNIT_DEGREE                        , /* [°]                               */
  UNIT_DEGREE_SEC                    , /* [°/s]                             */
  UNIT_DEGREE_SEC2                   , /* [°/s²]                            */
  UNIT_METER                         , /* [m]                               */
  UNIT_METER_SEC                     , /* [m/s]                             */
  UNIT_METER_SEC2                    , /* [m/s²]                            */
  UNIT_NEWTON                        , /* [N]                               */
  UNIT_PASCAL                        , /* [P]                               */
  UNIT_DEGREE_CELSIUS                , /* [°C]                              */
  UNIT_VOLT                          , /* [V]                               */
  UNIT_AMPERE                        , /* [A]                               */
  UNIT_OHM                           , /* [Ohm]                             */
  UNIT_SEC                           , /* [s]                               */
  UNIT_HERTZ                         , /* [Hz]                              */
  UNIT_WATT                          , /* [W]                               */
  UNIT_INC_REV                       , /* [Increments/Revolution]          */
  UNIT_MAX                           , /* End of unit definitions           */
};


#pragma pack (1)

//----------------------------------------------------------------------------

                                       /* Machine IO signal bits             */
                                       /* ----------------------             */
#define IO_SIGNAL_IN_MACHINE1          0x0001
#define IO_SIGNAL_IN_MACHINE2          0x0002
#define IO_SIGNAL_IN_MACHINE3          0x0004
#define IO_SIGNAL_IN_MACHINE4          0x0008
#define IO_SIGNAL_IN_MACHINE5          0x0010
#define IO_SIGNAL_IN_MACHINE6          0x0020
#define IO_SIGNAL_IN_MACHINE7          0x0040
#define IO_SIGNAL_IN_MACHINE8          0x0080
                                       
#define IO_SIGNAL_OUT_MACHINE1         0x0001
#define IO_SIGNAL_OUT_MACHINE2         0x0002
#define IO_SIGNAL_OUT_MACHINE3         0x0004
#define IO_SIGNAL_OUT_MACHINE4         0x0008
#define IO_SIGNAL_OUT_MACHINE5         0x0010
#define IO_SIGNAL_OUT_MACHINE6         0x0020
#define IO_SIGNAL_OUT_MACHINE7         0x0040
#define IO_SIGNAL_OUT_MACHINE8         0x0080
                                       
#define IO_SIGNAL_IN_MACHINE_MASK      0x00FF
#define IO_SIGNAL_OUT_MACHINE_MASK     0x00FF
                                            
                                       /* Constants for MachineNoIo          */
                                       /* -------------------------          */
#define  MACHINE_NO_IO_OFF        0    /* don't use IO  to select machine    */
#define  MACHINE_NO_IO_IN_OUT     1    /* use IO IN-OUT to select machine    */
#define  MACHINE_NO_IO_OUT        2    /* use IO OUT    to select machine    */
#define  MACHINE_NO_IO_IN         3    /* use IO IN     to select machine    */

                                       /* Constants for Language             */
                                       /* ----------------------             */
#define  LANGUAGE_ENGLISH         0
#define  LANGUAGE_GERMAN          1
#define  LANGUAGE_USER1           2
#define  LANGUAGE_USER2           3

                                       /* Sync option                        */
                                       /* ---------------------------------- */
#define  SYNC_OPTION_DISABLED     0    /* Sync option is disabled            */
#define  SYNC_OPTION_MASTER       1    /* Sync option is present (master EDC)*/
#define  SYNC_OPTION_SLAVE        2    /* Sync option is present (slave  EDC)*/


typedef struct                         /* General data                       */
{                                      /* ---------------------------------- */
  WORD   MachineNo;                    /* Number of active machines      [No]*/
  WORD   MachineNoIo;                  /* Machine select IO's config.    [No]*/
                                       /* (see MACHINE_NO_IO_... definitions)*/
  WORD   Supervisor;                   /* Supervisor mode                [No]*/ //EDC120-
  WORD   SuperPassword;                /* Supervisor Password(0=inactive)[No]*/
  WORD   UserPassword;                 /* User       Password(0=inactive)[No]*/
  WORD   Logo;                         /* DOLI Logo (0 = inactive)       [No]*/
  DWORD  nRmc;                         /* Required number of RMC's       [No]*/ //EDC220+
  DWORD  Language;                     /* Language                       [No]*/ //EDC220+
  DWORD  FunctionID;                   /* User defined function ID       [No]*/ //EDC220+
  WORD   SyncOption;                   /* Sync option (SYNC_OPTION_xxx)  [No]*/ //EDC220+
  WORD   MachineNoIoBitConnector;      /* BitIn/BitOut connector         [No]*/ //EDC220+
  WORD   MachineNoIoBitNo;             /* First bit of block          [0..15]*/ //EDC220+ 
} DoPEGeneralData;

//----------------------------------------------------------------------------

                                       /* Constants for 'LimitCtrl'          */
                                       /* -------------------------          */
#define  REACT_STATE              0    /* only status bits are set           */
#define  REACT_DRIVE_OFF          1    /* turn off drive                     */
#define  REACT_SHALT              2    /* halt crosshead in position control */

typedef struct                         /* Sensor definition data             */
{                                      /* ---------------------------------- */
  WORD   Connector;                    /* Connector number of sensor     [No]*/
  WORD   Sign;                         /* Invert sign of sensor         [1/0]*/
  WORD   CtrlChannel;                  /* Activate control channel      [1/0]*/
  WORD   LimitCtrl;                    /* Stop if limit exceeded        [1/0]*/
  WORD   ConnectedCtrl;                /* Stop if disconnected          [1/0]*/
  WORD   UseEeprom;                    /* Use sensor EEPROM data        [1/0]*/
                                       /* Only for analogue sensors:         */
  double Integr;                       /* Time of integration             [s]*/
                                       /* Only for sensors without EEPROM:   */
  WORD   Init;                         /* Sensor init                    [No]*/
  double NominalValue;                 /* Nominal value of sensor      [Unit]*/
  WORD   Unit;                         /* Unit of sensor UNIT_xxx        [No]*/
  double Offset;                       /* Offset of sensor             [Unit]*/
  double UpperLimit;                   /* Upper range limit of sensor     [%]*/
  double LowerLimit;                   /* Lower range limit of sensor     [%]*/
                                       /* Only for incremental sensors:      */
  double Scale;                        /* Scale of sensor    [inc/revolution]*/
                                       /*                       or [Unit/inc]*/
  double Correction;                   /* Correction value of sensor     [No]*/
} DoPESenDef;

//----------------------------------------------------------------------------

typedef struct                         /* Control Sensor definition data     */
{                                      /* ---------------------------------- */
  double Acceleration;                 /* Nominal acceleration      [Unit/s²]*/
  double Speed;                        /* Nominal speed              [Unit/s]*/
  double UnUsed1;                      /* Unused                             */
  double UnUsed2;                      /* Unused                             */
  double Deviation;                    /* Max. deviation of controller [Unit]*/
  WORD   DevReaction;                  /* Reaction if deviation exceeded [No]*/
  DWORD  PosP;                         /* Pos.  contr. P: gain           [No]*/
  WORD   PosI;                         /* Pos.  contr. I: time constant  [No]*/
  WORD   PosD;                         /* Pos.  contr. D: time constant  [No]*/
  DWORD  PosFFP;                       /* Pos.  feed forward P           [No]*/
  DWORD  SpeedP;                       /* Speed contr. P: gain           [No]*/
  WORD   SpeedI;                       /* Speed contr. I: time constant  [No]*/
  WORD   SpeedD;                       /* Speed contr. D: time constant  [No]*/
  DWORD  UnUsed3;                      /* Unused                             */
  DWORD  UnUsed4;                      /* Unused                             */
                                       /* Only for analogue sensors:         */
  double Integr;                       /* Time of integration for control.[s]*/
  WORD   SpeedFFP;                     /* Speed feed forward             [No]*/
  WORD   PosDelay;                     /* Delay for Command              [No]*/
  WORD   AccFFP;                       /* Acceleration contr. P: gain    [No]*/
  WORD   SpeedDelay;                   /* Delay for SpeedCommand         [No]*/
} DoPECtrlSenDef;

//----------------------------------------------------------------------------

                                       /* Constants for Signal               */
                                       /* --------------------               */
#define  OUTSIGNAL_A_B             0   /* A/B                                */
#define  OUTSIGNAL_PULSE_SIGN      1   /* pulse/sign                         */
#define  OUTSIGNAL_UP_DOWN         2   /* up/down                            */
#define  OUTSIGNAL_ANALOGUE        3   /* analogue (+/- 10V)                 */
#define  OUTSIGNAL_DC_MOTOR        4   /* PWM with dirction/amplitude signals*/
#define  OUTSIGNAL_DC_LINEAR_MOTOR 5   /* PWM with single, variable duty-cycle signal*/
#define  OUTSIGNAL_SIGN_MAGNITUDE  4   /* legacy: use OUTSIGNAL_DC_MOTOR     */
#define  OUTSIGNAL_LOCKEDANTIPHASE 5   /* legacy: use OUTSIGNAL_DC_LINEAR_MOTOR*/
#define  OUTSIGNAL_MAX             6   /* number of signals                  */

                                       /* Constants for frequency            */
                                       /* -----------------------            */
#define  OUTSIGNALFREQU4MHz        0
#define  OUTSIGNALFREQU2MHz        1
#define  OUTSIGNALFREQU1MHz        2
#define  OUTSIGNALFREQU500kHz      3
#define  OUTSIGNALFREQU250kHz      4
#define  OUTSIGNALFREQU125kHz      5
#define  OUTSIGNALFREQU60kHz       6
#define  OUTSIGNALFREQU30kHz       7
#define  OUTSIGNALFREQU15kHz       8
#define  OUTSIGNALFREQU_MAX        9

                                       /* Constants for CurrentControllerGain*/
                                       /* -----------------------------------*/
#define  OUTCURRCTRLGAINSET_0_009mH  0 /* 0.009 mH                          */
#define  OUTCURRCTRLGAINSET_0_018mH  1 /* 0.018 mH                          */
#define  OUTCURRCTRLGAINSET_0_037mH  2 /* 0.037 mH                          */
#define  OUTCURRCTRLGAINSET_0_073mH  3 /* 0.073 mH                          */
#define  OUTCURRCTRLGAINSET_0_15mH   4 /* 0.15  mH                          */
#define  OUTCURRCTRLGAINSET_0_29mH   5 /* 0.29  mH                          */
#define  OUTCURRCTRLGAINSET_0_59mH   6 /* 0.59  mH                          */
#define  OUTCURRCTRLGAINSET_1_2mH    7 /* 1.2   mH                          */
#define  OUTCURRCTRLGAINSET_2_3mH    8 /* 2.3   mH                          */
#define  OUTCURRCTRLGAINSET_4_7mH    9 /* 4.7   mH                          */
#define  OUTCURRCTRLGAINSET_9_4mH   10 /* 9.4   mH                          */
#define  OUTCURRCTRLGAINSET_19mH    11 /* 19    mH                          */
#define  OUTCURRCTRLGAINSET_38mH    12 /* 38    mH                          */
#define  OUTCURRCTRLGAINSET_75mH    13 /* 75    mH                          */
#define  OUTCURRCTRLGAINSET_150mH   14 /* 150   mH                          */
#define  OUTCURRCTRLGAINSET_300mH   15 /* 300   mH                          */
#define  OUTCURRCTRLGAINSET_MAX     16 /* number of sttings                 */


typedef struct                         /* Measured channel to analogue output*/
{                                      /* ---------------------------------- */
  WORD   Mode;                         /* MC2OUT_MODE_...  (see DoPEoutput.h)*/
  WORD   SensorNo;                     /* Sensor number               [0..15]*/
  double SensorPoint[MC2OUT_MAX];      /* Sensor Point Values          [Unit]*/
  double OutputPoint[MC2OUT_MAX];      /* Output Point Values             [%]*/
} DoPEMc2OutputDef;

typedef struct                         /* Definition of output channel       */
{                                      /* ---------------------------------- */
  WORD   Connector;                    /* Connector number of channel    [No]*/
  WORD   Sign;                         /* Invert sign of channel        [1/0]*/
  double MaxValue;                     /* Maximum output value            [%]*/
  double MinValue;                     /* Minimum output value            [%]*/
  double InitValue;                    /* Initial output value            [%]*/
                                       /* Only if adjustable (DDAxx):        */
  double PaVoltage;                    /* Max. voltage of power amplifier [V]*/
  double PaCurrent;                    /* Max. current of power amplifier [A]*/
  double MaxCurrTime;                  /* Max. time for max. current (I²t)[s]*/
  double DitherFrequency;              /* Dither frequency               [Hz]*/
  double DitherAmplitude;              /* Dither amplitude                [%]*/
  WORD   CurrentControllerGain;        /* Current controller gain set    [No]*/
  WORD   Signal;                       /* Digital command output signal  [No]*/
  WORD   SignalFrequency;              /* Digital command output signal  [No]*/
  WORD   UnUsed1;                      /* Unused                             */
  WORD   UnUsed2;                      /* Unused                             */
  double Offset;                       /* Offset of channel               [%]*/
  DWORD  CurrentP;                     /* current.contr. P: gain         [No]*/
  WORD   CurrentI;                     /* current.contr. P: time constant[No]*/
  WORD   CurrentD;                     /* current.contr. P: time constant[No]*/
  DoPEMc2OutputDef Mc2Output;          /* Measured channel to analogue output*/
} DoPEOutChaDef;

//----------------------------------------------------------------------------

typedef struct                         /* Definition of bit output           */
{                                      /* ---------------------------------- */
  WORD Connector;                      /* Connector number of device     [No]*/
  WORD InitValue;                      /* Initial value of device        [No]*/
} DoPEBitOutDef;

//----------------------------------------------------------------------------

typedef struct                         /* Definition of bit input            */
{                                      /* ---------------------------------- */
  WORD Connector;                      /* Connector number of device     [No]*/
  WORD StopMask;                       /* Set bits stop the machine      [No]*/
  WORD StopLevel;                      /* Active level mask of StopMask  [No]*/
} DoPEBitInDef;

//----------------------------------------------------------------------------

                                       /* Constants for 'CtrlStructure'      */
                                       /* -----------------------------      */
#define CTRL_STRUCTURE_SPINDLE    0    /* Digital position controller        */
                                       /* for speed controlled drives        */
#define CTRL_STRUCTURE_HYDRAULIC  1    /* Hydraulic                          */
#define CTRL_STRUCTURE_OPENLOOP   3    /* No control (only for CTRL_POS)     */
#define CTRL_STRUCTURE_SPINDLE_SP 6    /* Digital position and speed controller*/

                                       /* Constants for 'ShieldType'         */
                                       /* --------------------------         */
#define  SHIELD_SIMPLE            0    /* Protective shield without lock fnct. */
#define  SHIELD_SECURE            1    /* Protective shield with lock function */


#define LIMIT_SWITCH_TYPE_SINGLE  0    /* One limit switch present           */
#define LIMIT_SWITCH_TYPE_UPPER_LOWER 1 /* Two limit switches present        */

#define XHEAD_INITIAL_MODE_AUTOMATIC  0 /* Set XHead to last known position  */
#define XHEAD_INITIAL_MODE_MANUAL     1 /* Set XHead to manual position      */

#define X4PIN14_MODE_BYPASS           0 /* X4 Pin14 mode bypass              */
#define X4PIN14_MODE_EDC_READY        1 /* X4 Pin14 mode EDC ready           */

typedef struct                         /* Definition of machine data         */
{                                      /* ---------------------------------- */
  double SpeedCtrlTime;                /* Speed controller cycle time     [s]*/
                                       /*                    [0.2ms .. 2.5ms]*/
  double PosCtrlTime;                  /* Position controller cycle time  [s]*/
  WORD   CtrlStructure;                /* Closed loop control structure  [No]*/
  double DataTransmissionRate;         /* Data transmission rate          [s]*/
  WORD   Mode;                         /* Data acquisition or control   [1/0]*/
  WORD   UnUsed3;                      /* Unused                             */
  WORD   XheadDir;                     /* Machine moves up/down         [1/0]*/
                                       /* with positive output signal        */
  double UnUsed4;                      /* Unused                             */
  double EncXheadRatio;                /* Ratio encoder-Xhead     [Rev/Unit] */
  double BrakeOpen;                    /* Delay time to open brake after  [s]*/
                                       /* closed loop control is active      */
  double BrakeClose;                   /* Delay time to close brake before[s]*/
                                       /* closed loop control is deactivated */
  double PistonArea;                   /* Area of piston for hydraulic   [m²]*/
  double LoadMax;                      /* Max. load capacity of machine   [N]*/
  double Load100;                      /* Nominal load of machine         [N]*/
  double Stiffness;                    /* Over all stiffness of machine [N/m]*/
  short  UnUsed1;                      /* Unused                             */
  short  UnUsed2;                      /* Unused                             */
  WORD   GripConnector;                /* Grip: connector number         [No]*/
  WORD   GripChannel;                  /* Grip: channel                  [No]*/
  WORD   GripActive;                   /* Grip: active Low/High          [No]*/
  WORD   ShieldConnector;              /* Shield: connector number       [No]*/
  WORD   ShieldType;                   /* Shield: type simple/locked     [No]*/
  double ShieldTimeout;                /* Shield: timeout                 [s]*/
  WORD   CtrlOnMode;                   /* CTRL ON mode: 0=NoCtrl, 1=Ctrl     */
  double FixValue;                     /* Fixing  output value            [%]*/
  double InitValue;                    /* Initial output value            [%]*/
  double ReturnValue;                  /* Return  output value            [%]*/
  double ShieldUprLock;                /* Shield: max. load limit      [Unit]*/
  double ShieldLwrLock;                /* Shield: min. load limit      [Unit]*/
  double ShieldSpeedLimit;             /* Shield: max. pos. speed if open [Unit/s]*/
  WORD   LimitSwitchType;              /* LIMIT_SWITCH_TYPE_xxx          [No]*/
  WORD   XheadInitialMode;             /* XHEAD_INITIAL_MODE_xxx         [No]*/
  double XheadInitialValue;            /* Initial XHead value (manual) [Unit]*/
  WORD   X4Pin14Mode;                  /* X4PIN14_MODE_xxx               [No]*/
} DoPEMachineDef;

//----------------------------------------------------------------------------

#define LIN_DATA_MAX     10            /* Max. numbers of lin. points        */

typedef struct                         /* Definition of linearisation table  */
{                                      /* ---------------------------------- */
  WORD     LinNo;                      /* Number of points for mode lin. [No]*/
  double   FalseValue[LIN_DATA_MAX];   /* Measured value by the EDC       [N]*/
} DoPELinTblFalse;

typedef struct                         /* Definition of linearisation table  */
{                                      /* ---------------------------------- */
  WORD     LinNo;                      /* Number of points for mode lin. [No]*/
  double   TrueValue[LIN_DATA_MAX];    /* True value measured by the      [N]*/
                                       /* reference system                   */
} DoPELinTblTrue;

//----------------------------------------------------------------------------

/* Grip modes */                   
#define IO_GRIP_MODE_0_OFF                  0   /* grip disabled                                            */
#define IO_GRIP_MODE_1_TANSPARENT           1   /* digital outputs are set according to grip keys           */
                                                /* grip leds are set according to digital inputs            */
#define IO_GRIP_MODE_2_LIMIT_CTRL           2   /* only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active            */
#define IO_GRIP_MODE_3_LIMIT_CTRL_INVERTED  3   /* only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active (inverted) */

/* Grip IO signal bits */                   
#define IO_SIGNAL_IN_GRIP_CONNECTED         0x0001
#define IO_SIGNAL_IN_GRIP_UPPER_OPENED      0x0002
#define IO_SIGNAL_IN_GRIP_LOWER_OPENED      0x0004
#define IO_SIGNAL_IN_GRIP_UPPER_CLOSED      0x0008
#define IO_SIGNAL_IN_GRIP_LOWER_CLOSED      0x0010
#define IO_SIGNAL_IN_GRIP_HIGH_PRESSURE     0x0020
                                            
#define IO_SIGNAL_OUT_GRIP_OPEN_ENABLE      0x0001
#define IO_SIGNAL_OUT_GRIP_UPPER_OPEN       0x0002
#define IO_SIGNAL_OUT_GRIP_LOWER_OPEN       0x0004
#define IO_SIGNAL_OUT_GRIP_UPPER_CLOSE      0x0008
#define IO_SIGNAL_OUT_GRIP_LOWER_CLOSE      0x0010
#define IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE1   0x0020
#define IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE2   0x0040
#define IO_SIGNAL_OUT_GRIP_HYDRAULIC_ON     0x0080
                                            
#define IO_SIGNAL_IN_GRIP_MASK              0x003F
#define IO_SIGNAL_OUT_GRIP_MASK             0x00FF
                                            
typedef struct                         /* Grip IO signal definition          */
{                                      /* ---------------------------------- */
  WORD      Mode;                      /* Mode (0=disabled)              [No]*/
  WORD      BitDevice;                 /* BitIn/BitOut device         [0...9]*/
  WORD      BitNo;                     /* First bit of block          [0..15]*/ 

  WORD      LimitSensorNo;             /* Limit sensor number            [No]*/
  double    LimitMax;                  /* Limit Max                    [Unit]*/
  double    LimitMin;                  /* Limit Max                    [Unit]*/

  WORD      FConstEnabled;             /* Load constant when closing    [0/1]*/
  double    CloseSecurityTime;         /* Security time for closing       [s]*/
  double    OutGripHydraulicOnTime;    /* Time for OutGripHydraulicOn     [s]*/
  double    OutGripHighPressureTime;   /* Time for OutGripHighPressure    [s]*/
  double    InGripOpenedTime;          /* Time for InGripOpened           [s]*/
  double    InGripClosedTime;          /* Time for InGripClosed           [s]*/

  WORD      PressureOutputEnabled;     /* Pressure output enabled       [0/1]*/
  WORD      OutChaNo;                  /* Analog output for pressure  [0..15]*/
  double    UnUsed1;                   /* Unused                             */
  double    OutChaLowPressure;         /* Low  Pressure value             [%]*/
  double    OutChaHighPressure;        /* High Pressure value             [%]*/
  double    OutChaRampTime;            /* Time for low/high pressure ramp [s]*/
  WORD      OutChaFCtrlEnabled;        /* Load control enabled          [0/1]*/
  double    OutChaFCtrlHighPressure;   /* Load at high pressure           [N]*/
} DoPEIOGrip;
                                      
//----------------------------------------------------------------------------

/* Extensometer IO signal definition */     
#define IO_SIGNAL_IN_EXT_UPPER_OPENED       0x0001
#define IO_SIGNAL_IN_EXT_LOWER_OPENED       0x0002
#define IO_SIGNAL_IN_EXT_UPPER_CLOSED       0x0004
#define IO_SIGNAL_IN_EXT_LOWER_CLOSED       0x0008
                                            
#define IO_SIGNAL_OUT_EXT_UPPER_OPEN        0x0001
#define IO_SIGNAL_OUT_EXT_LOWER_OPEN        0x0002
#define IO_SIGNAL_OUT_EXT_UPPER_CLOSE       0x0004
#define IO_SIGNAL_OUT_EXT_LOWER_CLOSE       0x0008
                                            
#define IO_SIGNAL_IN_EXT_MASK               0x000F
#define IO_SIGNAL_OUT_EXT_MASK              0x000F
                                            
typedef struct                         /* Extensometer IO signal definition  */
{                                      /* ---------------------------------- */
  WORD      Mode;                      /* Mode (0=disabled)              [No]*/
  WORD      BitDevice;                 /* BitIn/BitOut device         [0...9]*/
  WORD      BitNo;                     /* First bit of block          [0..15]*/ 
  double    IOTime;                    /* Time for BitIn/BitOut control   [s]*/
} DoPEIOExt;

//----------------------------------------------------------------------------

/* FixedXHead IO signal definition */            
#define IO_SIGNAL_IN_FIXED_XHEAD_UNLOCKED   0x0001
                                            
#define IO_SIGNAL_OUT_FIXED_XHEAD_UNLOCK    0x0001
#define IO_SIGNAL_OUT_FIXED_XHEAD_UP        0x0002
#define IO_SIGNAL_OUT_FIXED_XHEAD_DOWN      0x0004
                                            
#define IO_SIGNAL_IN_FIXED_XHEAD_MASK       0x0001
#define IO_SIGNAL_OUT_FIXED_XHEAD_MASK      0x0007
                                            
typedef struct                         /* FixedXHead IO signal definition    */
{                                      /* ---------------------------------- */
  WORD      Mode;                      /* Mode (0=disabled)              [No]*/
  WORD      BitDevice;                 /* BitIn/BitOut device         [0...9]*/
  WORD      BitNo;                     /* First bit of block          [0..15]*/ 
  double    IOTime;                    /* Time for BitIn/BitOut control   [s]*/
} DoPEIOFixedXHead;

//----------------------------------------------------------------------------

/* High pressure IO signal definition */    
#define IO_SIGNAL_IN_HIGH_PRESSURE          0x0001
#define IO_SIGNAL_IN_HIGH_PRESSURE_OK       0x0002
#define IO_SIGNAL_IN_LOW_PRESSURE           0x0004
                                            
#define IO_SIGNAL_OUT_HIGH_PRESSURE         0x0001
#define IO_SIGNAL_OUT_HIGH_PRESSURE_OK      0x0002
#define IO_SIGNAL_OUT_LOW_PRESSURE          0x0004
#define IO_SIGNAL_OUT_LOW_PRESSURE_OK       0x0008
                                            
#define IO_SIGNAL_IN_HIGH_PRESSURE_MASK     0x0007
#define IO_SIGNAL_OUT_HIGH_PRESSURE_MASK    0x000F
                                            
typedef struct                         /* High pressure IO signal definition */
{                                      /* ---------------------------------- */
  WORD      Mode;                      /* Mode (0=disabled)              [No]*/
  WORD      BitDevice;                 /* BitIn/BitOut device         [0...9]*/
  WORD      BitNo;                     /* First bit of block          [0..15]*/ 
  double    IOTime;                    /* Time for BitIn/BitOut control   [s]*/

  WORD      PressureOutputEnabled;     /* Pressure output enabled       [0/1]*/
  WORD      OutChaNo;                  /* Analog output for pressure  [0..15]*/
  double    OutChaLowPressure;         /* Low  Pressure value             [%]*/
  double    OutChaHighPressure;        /* High Pressure value             [%]*/
  double    OutChaRampTime;            /* Time for low/high pressure ramp [s]*/
} DoPEIOHighPressure;

//----------------------------------------------------------------------------

/* Miscellaneous IO signal definition */    
#define IO_SIGNAL_IN_MISC_TEMPERATURE1      0x0001  /* warning       */
#define IO_SIGNAL_IN_MISC_TEMPERATURE2      0x0002  /* emergency off */
#define IO_SIGNAL_IN_MISC_OIL_LEVEL         0x0004  /* emergency off */
#define IO_SIGNAL_IN_MISC_OIL_FILTER        0x0008  /* warning       */
#define IO_SIGNAL_IN_MISC_POWER_FAIL        0x0010  /* emergency off */
                                            
#define IO_SIGNAL_OUT_MISC_CAL              0x0001
#define IO_SIGNAL_OUT_MISC_NO_SENSOR_LIMIT  0x0002
                                            
#define IO_SIGNAL_IN_MISC_MASK              0x001F
#define IO_SIGNAL_OUT_MISC_MASK             0x0003

typedef struct                         /* Miscellaneous IO signal definition */
{                                      /* ---------------------------------- */
  WORD      BitInMode;                 /* BitIn  mode   (0=disabled)     [No]*/
  WORD      BitInDevice;               /* BitIn  device               [0...9]*/
  WORD      BitInNo;                   /* BitIn  number (first of bl.)[0..15]*/ 

  WORD      BitOutMode;                /* BitOut mode   (0=disabled)     [No]*/
  WORD      BitOutDevice;              /* BitOut device               [0...9]*/
  WORD      BitOutNo;                  /* BitOut number (first of bl.)[0..15]*/ 
} DoPEIOMisc;

//----------------------------------------------------------------------------

/* SHALT IO signal modes */              
#define IO_SHALT_MODE_0_OFF                 0   /* SHalt IO signal disabled              */
#define IO_SHALT_MODE_1_ENABLED             1   /* SHalt IO signal enabled (active high) */
#define IO_SHALT_MODE_2_ENABLED_INVERTED    2   /* SHalt IO signal enabled (active low ) */

/* SHALT IO signal definition */              
#define IO_SIGNAL_IN_SHALT_UPPER            0x0001
#define IO_SIGNAL_IN_SHALT_LOWER            0x0002

#define IO_SIGNAL_IN_SHALT_MASK             0x0003
                                            
typedef struct                         /* SHalt IO signal definition         */
{                                      /* ---------------------------------- */
  WORD Mode;                           /* Mode (0=disabled)              [No]*/
  WORD BitDevice;                      /* BitIn/BitOut device         [0...9]*/
  WORD BitNo;                          /* First bit of block          [0..15]*/ 
} DoPEIOSHalt;

//----------------------------------------------------------------------------

typedef struct                         /* IO signal definition               */
{                                      /* ---------------------------------- */
  DoPEIOGrip         Grip;             /* Grip                IO signal def. */
  DoPEIOExt          Ext;              /* Extensometer        IO signal def. */
  DoPEIOFixedXHead   FixedXHead;       /* FixedXHead          IO signal def. */
  DoPEIOHighPressure HighPressure;     /* High pressure       IO signal def. */
  BYTE               Reserved[28];     /* reserved (was DoPEIOKey/DoPEIOTest)*/
  DoPEIOMisc         Misc;             /* Miscellaneous       IO signal def. */
  DoPEIOSHalt        SHalt;            /* SHalt IO signal definition         */
} DoPEIOSignals;

//----------------------------------------------------------------------------

#define MAX_MAIN_MENU  40              /* max count of EDC main menu entries */
                                                                                                                                                            
enum                                   /* Test numbers of EDC main menu      */
{                                      /* ---------------------------------- */
  TEST_NO_PC_CONTROL = 10000,          /* 10000 no licence needed            */
  TEST_NO_TENSION_COMPRESSION,         /* 10001 no licence needed            */
  TEST_NO_TEAR,                        /* 10002 no licence needed            */
  TEST_NO_METAL_TENSION,               /* 10003 no licence needed            */
  TEST_NO_CONCRETE_PRESSURE,           /* 10004 no licence needed            */
  TEST_NO_CONCRETE_BENDING,            /* 10005 no licence needed            */
  TEST_NO_CONCRETE_BRASILIAN,          /* 10006 no licence needed            */
  TEST_NO_CONCRETE_CIRCEL_BENDING,     /* 10007 no licence needed            */
  TEST_NO_CYCLES,                      /* 10008    licence needed            */
  TEST_NO_EXTERNAL_COMMAND,            /* 10009    licence needed            */
  TEST_NO_CREEP,                       /* 10010    licence needed            */
  TEST_NO_BLOCK_COMMAND,               /* 10011    licence needed            */
  TEST_NO_ADJUSTING,                   /* 10012 no licence needed            */
  TEST_NO_CALIBRATION,                 /* 10013 no licence needed            */
  TEST_NO_CLOSED_LOOP_SETUP,           /* 10014 no licence needed            */
  TEST_NO_DRIVE_SETUP,                 /* 10015 no licence needed            */
  TEST_NO_PROTOCOL_SETUP,              /* 10016 no licence needed            */
  TEST_NO_USER_SETUP,                  /* 10017 no licence needed            */

  TEST_NO_MAX,
};


typedef struct                         /* EDC main menu definition           */
{                                      /* ---------------------------------- */
  long TestNo;                         /* Test number                    [No]*/
  WORD Visible;                        /* Main menu entry visible       [0/1]*/
} DoPEMainMenu;

//----------------------------------------------------------------------------

#define RMCIO_KEY_MAX  16

typedef struct                         /* RMCIO key definition               */
{                                      /* ---------------------------------- */
  __int32 KeyCode;                     /* Key code DoPE_KEY_xxx          [No]*/
  WORD    Device;                      /* BitIn/BitOut device         [0...9]*/
  WORD    KeyMask;                     /* Bit mask for key               [No]*/
  WORD    LedMask;                     /* Bit mask for LED               [No]*/
} DoPERmcIOKey;

typedef struct                         /* RMC DigiPoti definition             */
{                                      /* ----------------------------------- */
  double SpeedSlow;                    /* Slow speed                  [Unit/s]*/
  double SpeedFast;                    /* Fast speed                  [Unit/s]*/
  double DPotiSpeedSens;               /* Sensitivity Speed/Openloop [Rev/Nom]*/
  double DPotiPosSens;                 /* Sensitivity Pos           [Unit/Rev]*/
} DoPERmcDPoti;

typedef struct                         /* RMC definition                     */
{                                      /* ---------------------------------- */
  WORD         PushMode;               /* Push mode for Up/Down keys    [0/1]*/
  DoPERmcDPoti RmcDPoti[MAX_CTRL];     /* RMC DPoti definition               */
  DoPERmcIOKey RmcIOKey[RMCIO_KEY_MAX];/* RMCIO key definition        [0..15]*/
} DoPERmcDef;

//----------------------------------------------------------------------------

typedef struct                         /* EDC Setup Data                     */
{                                      /* ---------------------------------- */
  DoPESenDef      SDef[MAX_MC];        /* Sensor definition data             */
  DoPECtrlSenDef  CSDef[MAX_CTRL];     /* Control-Sensor definition          */
  DoPECtrlSenDef  CSDefHigh[MAX_CTRL]; /* Control-Sensor def. (high pressure)*/ //EDC220+
  DoPEOutChaDef   ODef[MAX_OC];        /* Analogue output definition data    */
  DoPEBitOutDef   BODef[MAX_BOUT];     /* Digital bit output definition data */
  DoPEBitInDef    BIDef[MAX_BIN];      /* Digital bit input definition data  */
  DoPEMachineDef  MDef;                /* Machine definition data            */
  DoPELinTblFalse LinTblFalse;         /* Linearisation table FALSE values   */
  DoPELinTblTrue  LinTblTrue;          /* Linearisation table TRUE values    */
  DoPEIOSignals   IOSignals;           /* IO signal definition               */ //EDC220+
  DoPEMainMenu    MainMenu[MAX_MAIN_MENU]; /* EDC main menu definition       */ //EDC220+
  DoPERmcDef      RmcDef;              /* RMC definition                     */ //EDC220+
} DoPESetup;

//----------------------------------------------------------------------------

                                       /* SensorStates                      */
                                       /* ------------                      */
#define SENSOR_STATE_NOTOK   0x0000    /* Sensor state not OK               */
#define SENSOR_STATE_OK      0x0001    /* Sensor state OK                   */
#define SENSOR_STATE_ACTIVE  0x0002    /* Sensor state active               */
#define SENSOR_STATE_INIT    0x0004    /* Sensor state initialization ok    */

                                       /* McTypes                           */
                                       /* -------                           */
#define MKTYP_ABSOLUT_MB     0         /* Absolute measuring channel with build*/
                                       /* in reference (standard ADC)       */
#define MKTYP_ABSOLUT_OB     1         /* Absolute measuring channel without*/
                                       /* build in reference (encoders)     */
#define MKTYP_INTGR          2         /* Integrating measuring channel     */
                                       /* Doli standard AD-Converter        */


typedef struct                         /* Summary Sensor Information         */
{                                      /* ---------------------------------- */
  WORD   Connector;                    /* Connector number of sensor     [No]*/
  double NominalValue;                 /* Nominal value of sensor      [Unit]*/
  WORD   Unit;                         /* Unit of sensor UNIT_xxx        [No]*/
  double Offset;                       /* Offset of sensor             [Unit]*/
  double UpperLimit;                   /* Upper range limit of sensor  [Unit]*/
  double LowerLimit;                   /* Lower range limit of sensor  [Unit]*/
  WORD   SensorState;                  /* Sensor state SEN_STATE_xxx     [No]*/
  WORD   McType;                       /* Measuring channel type         [No]*/
  double UpperSoftLimit;               /* Upper soft limit             [Unit]*/
  double LowerSoftLimit;               /* Lower soft limit             [Unit]*/
  WORD   SoftLimitReaction;            /* reaction if soft limit         [No]*/
  double BasicTare;                    /* Basic   tare                 [Unit]*/
  double Tare;                         /* Tare                         [Unit]*/
  double UserScale;                    /* User scale                     [No]*/
  double McIntegr;                     /* Measuring channel time of integration   [s]*/
  double CtrlIntegr;                   /* Closed loop control time of integration [s]*/
  double HwDelayTime;                  /* Hardware delaytime              [s]*/
  double McDelayTime;                  /* Measuring channel delaytime     [s]*/
  double McDelayTimeCorr;              /* Delaytime correction            [s]*/
} DoPESumSenInfo;

//----------------------------------------------------------------------------

                                       /* Sensor classes                     */
                                       /* ---------------------------------- */
#define SEN_UNDEF           0          /* unknown sensor class               */
#define SEN_ANALOGUE        1          /* analogue sensor                    */
#define SEN_INC             2          /* incremental sensor                 */
#define SEN_ABS             3          /* abolute value sensor               */

                                       /* Analogue sensor types              */
                                       /* ---------------------------------- */
#define SIG_STRAINGAUGE     0          /* Strain Gauge                       */
#define SIG_LVDT            1          /* LVDT                               */
#define SIG_DC              2          /* DC                                 */

                                       /* Incremental sensor types           */
                                       /* ---------------------------------- */
#define SIG_TTL             0          /* TTL Signal                         */
#define SIG_LINE            1          /* RS422 (line driver)                */
#define SIG_SINE11uA        2          /* Sine 11µA                          */
#define SIG_SINE1V          3          /* Sine 1V                            */

                                       /* Absolute value sensor types        */
                                       /* ---------------------------------- */
#define SIG_ROQ_424         1          /* Heidenhain ROQ 424 Sensor          */
#define SIG_MTS_SSI_S2Bx102 2          /* MTS SSI S2Bx102 Sensor             */
#define SIG_POSITAL_SL_G_24 3          /* POSITAL OCD-SL00G-1212 Sensor      */
#define SIG_POSITAL_SL_G_16 4          /* POSITAL OCD-SL00G-0016 Sensor      */
#define SIG_ROQ_425         5          /* Heidenhain ROQ 424 Sensor          */
#define SIG_SSI_GENERIC     0x80       /* 'Generic sensor definition' mask   */
#define   SIG_SSI_CODE      0x40       /* Code bit 0=binary, 1=gray code     */
#define   SIG_SSI_LEN       0x1F       /* 'number of databits' mask          */
#define   SIG_SSI_LEN_OFFS  8          /* Offset for 'number of databits'    */
    

                                       /* Transducer types                   */
                                       /* ---------------------------------- */
#define TRANSDUCER_LINEAR  0           /* Linear transducer                  */
#define TRANSDUCER_ROTARY  1           /* Rotary transducer                  */

                                       /* Reference mark types               */
                                       /* ---------------------------------- */
#define REFMARK_NON        0           /* Transducer has no reference mark   */
#define REFMARK_ONE        1           /* Transducer has one reference mark  */
#define REFMARK_DISTCODE   2           /* Transducer has distance coded      */

#define SEN_LIN_DATA_MAX 12            /* Max. numbers of sensor lin. points */
                                       /* referenced marks                   */

typedef struct                         /* Sensor EEPROM header data          */
{                                      /* ---------------------------------- */
  WORD   PartNo;                       /* Part ident number              [No]*/
  BYTE   Version;                      /* Part revision                  [No]*/
  DWORD  SerNo;                        /* Part serial number             [No]*/

  WORD   Class;                        /* Sensor class                   [No]*/
  BYTE   DatVersion;                   /* Version of data                [No]*/
} DoPESensorHeaderData;


typedef struct                         /* Analogue sensor EEPROM data        */
{                                      /* ---------------------------------- */
  float  MaxExcitation;                /* Maximum excitation voltage      [V]*/
  WORD   MinImpedance;                 /* Impedance                     [Ohm]*/
  float  NominalValue;                 /* Nominal value of the sensor  [Unit]*/
  WORD   Unit;                         /* Unit of sensor UNIT_xxx        [No]*/
  float  Offset;                       /* Sensor offset                [Unit]*/
  WORD   NegLimit;                     /* Range limit - min.              [%]*/
  WORD   PosLimit;                     /* Range limit - max.              [%]*/
  float  Reference;                    /* Nominal value of the reference  [*]*/
  double CorrReference;                /* Corr. value of the reference   [No]*/
  WORD   Sensortype;                   /* Sensor type                        */
  double NominalSensitive;             /* Sensitivity at Nominal value    [*]*/
  WORD   Sign;                         /* Invert sign of channel        [1/0]*/
  int    Day;                          /* Date of last change            [No]*/
  int    Month;                        /* Date of last change            [No]*/
  int    Year;                         /* Date of last change            [No]*/
  WORD   LinPoint;                     /* Number of linearization steps  [No]*/
  struct LinVal
  {
    double MeasValue;                  /* Measured value               [Unit]*/
    double RefValue;                   /* Reference                    [Unit]*/
  } LinV[SEN_LIN_DATA_MAX];            /* Linearization table                */
} DoPESensorAnalogueData;
                                       /* [*]: [V]    for DC sensor          */
                                       /*      [mV/V] for DMS and LVDT       */


typedef struct                         /* Incremental sensor EEPROM data     */
{                                      /* ---------------------------------- */
  float  Voltage1;                     /* Supply voltage 1                [V]*/
  float  Voltage2;                     /* Supply voltage 2                [V]*/
  float  Voltage3;                     /* Supply voltage 3                [V]*/
  float  Current1;                     /* Current for supply voltage 1    [A]*/
  float  Current2;                     /* Current for supply voltage 2    [A]*/
  float  Current3;                     /* Current for supply voltage 3    [A]*/
  WORD   InputSignal;                  /* Signal type at input  SIG_xxx  [No]*/
  WORD   OutputSignal;                 /* Signal type at output SIG_xxx  [No]*/
  WORD   InterpolationFactor;          /* Factor for interpolation       [No]*/
  float  MaxInputFreq;                 /* Maximum input frequency        [Hz]*/
  float  MaxOutputFreq;                /* Maximum output frequency       [Hz]*/

  WORD   TransducerType;               /* Transducer type TRANSDUCER_xxx [No]*/
  WORD   Unit;                         /* Unit of sensor UNIT_xxx        [No]*/
  double SignalPeriod;                 /* Signal period                [Unit]*/
  double CorrFactor;                   /* Correction factor              [No]*/
  double MeasuringRange;               /* Measuring range              [Unit]*/
  WORD   SignalType;                   /* Tancducer sgnal type  SIG_xxx  [No]*/
  WORD   ReferenceMark;                /* Reference mark type REFMARK_xxx[No]*/
  double FirstDistance;                /* First distance of the reference[Unit]*/
  double NominalDistance;              /* Nominal distance of the reference[Unit]*/
  double Delta;                        /* Dislocation of the mean reference[Unit]*/
  float  LimitFrequency;               /* Limit frequency of the transducer[Hz]*/
  WORD   Sign;                         /* Invert sign of channel        [1/0]*/
  BYTE   NegLimit;                     /* Range limit - min.              [%]*/
  BYTE   PosLimit;                     /* Range limit - max.              [%]*/
} DoPESensorIncData;


typedef struct                         /* Absolute value EEPROM header data  */
{                                      /* ---------------------------------- */
  float  Voltage1;                     /* Supply voltage 1                [V]*/
  float  Voltage2;                     /* Supply voltage 2                [V]*/
  float  Voltage3;                     /* Supply voltage 3                [V]*/
  float  Current1;                     /* Current for supply voltage 1    [A]*/
  float  Current2;                     /* Current for supply voltage 2    [A]*/
  float  Current3;                     /* Current for supply voltage 3    [A]*/
  WORD   InputSignal;                  /* Signal type at input  SIG_xxx  [No]*/
  WORD   OutputSignal;                 /* Signal type at output SIG_xxx  [No]*/
  float  MaxInputFreq;                 /* Maximum input frequency        [Hz]*/
  float  MaxOutputFreq;                /* Maximum output frequency       [Hz]*/

  BYTE   DelayTime;                    /* Sensors signal delay time   [ms/10]*/
  WORD   Unit;                         /* Unit of sensor UNIT_xxx        [No]*/
  double SignalPeriod;                 /* Signal period                [Unit]*/
  float  Offset;                       /* Sensor offset                [Unit]*/
  double CorrFactor;                   /* Correction factor              [No]*/
  double NominalValue;                 /* Nominal value of the sensor  [Unit]*/
  WORD   SignalType;                   /* Tansducer sgnal type  SIG_xxx  [No]*/
                                       /* or SIG_SSI_GENERIC + code + number */
                                       /* of data bits                       */
  float  LimitFrequency;               /* Limit frequency of the transducer[Hz]*/
  WORD   Sign;                         /* Invert sign of channel        [1/0]*/
  BYTE   NegLimit;                     /* Range limit - min.              [%]*/
  BYTE   PosLimit;                     /* Range limit - max.              [%]*/
  int    Day;                          /* Date of last change            [No]*/
  int    Month;                        /* Date of last change            [No]*/
  int    Year;                         /* Date of last change            [No]*/
} DoPESensorAbsData;

#pragma pack ()


/* -------------------------------------------------------------------------- */
/* Setup configuration                                                        */
/* -------------------------------------------------------------------------- */

#pragma pack (1)

  typedef  double UserScale[MAX_MC];

#pragma pack ()


  extern  unsigned  DLLAPI  DoPESetupScale ( DoPE_HANDLE     DoPEHdl,
                                             unsigned short  SetupNo,
                                             UserScale       US );

    /*
    Sets the setup user scale.

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.
            US          User scale for all setup sensor data (except DoPESenDef).
                        The sensor data will be multiplied by the value in US.
                        e.g. use this to convert the SI unit meter into mm
                        by setting the userscale to 1000 for the position sensor
                        Default values 1.0 will be used if US is NULL

      Out :

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdGeneralData ( DoPE_HANDLE      DoPEHdl,
                                                DoPEGeneralData *GeneralData );

    /*
    Read general data

      In :  DoPEHdl      DoPE link handle
            *GeneralData Pointer for DoPEGeneralData structure

      Returns:           Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrGeneralDataSync ( DoPE_HANDLE      DoPEHdl,
                                                    DoPEGeneralData *GeneralData );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrGeneralData ( DoPE_HANDLE      DoPEHdl,
                                                DoPEGeneralData *GeneralData,
                                                WORD            *lpusTAN );

    /*
    Write general data

      In :  DoPEHdl       DoPE link handle
            *GeneralData  Pointer for DoPEGeneralData structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERdSetupAllSync ( DoPE_HANDLE     DoPEHdl,
                                                 unsigned short  SetupNo,
                                                 DoPESetup      *Setup );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPERdSetupAll ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short SetupNo,
                                             DoPESetup      *Setup,
                                             WORD           *lpusTANFirst,
                                             WORD           *lpusTANLast );

    /*
    Read the setup structure

      In :  DoPEHdl       DoPE link handle
            SetupNo       Setup No.
            Setup         Pointer to Setup structure

      Out:  *Setup        Setup information (see DoPESetup definition)
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEWrSetupAllSync ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short SetupNo,
                                                 DoPESetup     *Setup );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSetupAll ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short SetupNo,
                                             DoPESetup     *Setup,
                                             WORD          *lpusTANFirst,
                                             WORD          *lpusTANLast );

    /*
    Write the setup structure

      In :  DoPEHdl       DoPE link handle
            SetupNo       Setup No.
            Setup         Pointer to Setup structure

      Out:
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESelSetup ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short SetupNo,
                                           UserScale      US,
                                           WORD          *lpusTANFirst,
                                           WORD          *lpusTANLast );

    /*
    Select machine setup

      In :  DoPEHdl       DoPE link handle
            SetupNo       Setup No. 0 Use actual setup data.
                                      All setup data and basic tare values are
                                      not permanently stored in the EDC's EEPROM.
                          Setup No. 1..4 Read setup data from the EEPROM.
                                         All setup data and basic tare values are
                                         permanently stored in the EDC's EEPROM.
            US            User scale for all measuring channels.
                          The measured data will be multiplied by the value in US.
                          e.g. use this to convert the SI unit meter into mm
                          by setting the userscale to 1000 for the position channel
                          Default values 1.0 will be used if US is NULL (V2.01)

      Out:  *lpusTANFirst TAN's are used to identify initialization errors sent in
            *lpusTANLast  addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEInitialize ( DoPE_HANDLE DoPEHdl,
                                             WORD       *lpusTANFirst,
                                             WORD       *lpusTANLast );

    /*
    Initialize System with selected setup data.
    This command must be given after a change of machine setup.

      In :  DoPEHdl       DoPE link handle

      Out:  *lpusTANFirst TAN's are used to identify initialization errors sent in
            *lpusTANLast  addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI DoPEInitializeResetXHead ( DoPE_HANDLE DoPEHdl,
                                                      WORD       *lpusTANFirst,
                                                      WORD       *lpusTANLast );

    /*
    Initialize System with selected setup data and reset the crosshead position.

      In :  DoPEHdl       DoPE link handle

      Out:  *lpusTANFirst TAN's are used to identify initialization errors sent in
            *lpusTANLast  addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/*
    ReInitialization allows to disconnect an EDC from the PC without closing
    down the connection (the drive remains on) and recovering the connection
    to a known state.
    This might be neccesery to protect a long term test from a PC crash.
*/

  #define DoPEREINITIALIZEDATA_LEN 0x8000
  typedef 
    BYTE DoPEReInitializeData [DoPEREINITIALIZEDATA_LEN];  /* ReInitialize data array [No]*/

  extern  unsigned  DLLAPI  DoPEReInitializeEnable ( DoPE_HANDLE           DoPEHdl,
                                                     unsigned              Enable,
                                                     DoPEReInitializeData *Data );

    /*
    Enable / disable the ReInitialization mode.

      In :  DoPEHdl       DoPE link handle
            Enable        != 0: enables the ReInitialization mode
                          == 0: disables the ReInitialization mode
            Data          Pointer to the ReInitialization data.

      Out:  *Data         internal state of the connection used to recover the
                          connetion with DoPEReInitialize.

      Returns:            Error constant (DoPERR_xxxx)
    */


  extern  unsigned  DLLAPI  DoPEReInitialize ( DoPE_HANDLE           DoPEHdl,
                                               DoPEReInitializeData	*Data );
    /*
    Recover a connection to a known state without a new initializion that 
    switches off the drive.

      In :  DoPEHdl       DoPE link handle
            Data          Pointer to the ReInitialization data containing
                          information to recover a connetion to the state
                          previously saved with DoPEReInitializeEnable.

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERdSetupNumber ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short *SetupNo );

    /*
    Get the currently selected setup number.

      In :  DoPEHdl     DoPE link handle
            SetupNo     Pointer to the Setup No.

      Out:  *SetupNo    Setup No.

      Returns:          Error constant (DoPERR_xxxx)
    */


/* ------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERdSensorInfo ( DoPE_HANDLE     DoPEHdl,
                                               unsigned short  SensorNo,
                                               DoPESumSenInfo *Info );

    /*
    Read summary sensor informations

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *Info       Pointer for SumSenInfo structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSysUserDataSync ( DoPE_HANDLE DoPEHdl,
                                                    BYTE       *SysUsrData,
                                                    unsigned    Length );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSysUserData ( DoPE_HANDLE DoPEHdl,
                                                BYTE       *SysUsrData,
                                                unsigned    Length,
                                                WORD       *lpusTAN );

    /*
    Write system user data

      In :  DoPEHdl       DoPE link handle
            *SysUsrData   Pointer for SYSEEPROM user data
            Length        User data buffer length in BYTEs

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Sensor configuration                                                       */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERdSensorHeaderData ( DoPE_HANDLE           DoPEHdl,
                                                     WORD                  Connector,
                                                     DoPESensorHeaderData *SenHdrData );

    /*
    Read sensor EEPROM data header

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenHdrData Pointer to sensor data header structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEWrSensorHeaderData ( DoPE_HANDLE           DoPEHdl,
                                                     WORD                  Connector,
                                                     DoPESensorHeaderData *SenHdrData );

    /*
    Write sensor EEPROM data header

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenHdrData Pointer to sensor data header structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSensorAnalogueData ( DoPE_HANDLE             DoPEHdl,
                                                       WORD                    Connector,
                                                       DoPESensorAnalogueData *SenAnalogueData );

    /*
    Read analogue sensor data

      In :  DoPEHdl          DoPE link handle
            Connector        Connector number of sensor
            *SenAnalogueData Pointer to analogue sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorAnalogueData ( DoPE_HANDLE             DoPEHdl,
                                                       WORD                    Connector,
                                                       DoPESensorAnalogueData *SenAnalogueData );

    /*
    Write analogue sensor data

      In :  DoPEHdl          DoPE link handle
            Connector        Connector number of sensor
            *SenAnalogueData Pointer to analogue sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSensorIncData ( DoPE_HANDLE        DoPEHdl,
                                                  WORD               Connector,
                                                  DoPESensorIncData *SenIncData );

    /*
    Read incremental sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenIncData Pointer to incremental sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorIncData ( DoPE_HANDLE        DoPEHdl,
                                                  WORD               Connector,
                                                  DoPESensorIncData *SenIncData );

    /*
    Write incremental sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenIncData Pointer to incremental sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSensorAbsData ( DoPE_HANDLE        DoPEHdl,
                                                  WORD               Connector,
                                                  DoPESensorAbsData *SenAbsData );

    /*
    Read absolute sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenAbsData Pointer to absolute value sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorAbsData ( DoPE_HANDLE        DoPEHdl,
                                                  WORD               Connector,
                                                  DoPESensorAbsData *SenAbsData );

    /*
    Write absolute sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenAbsData Pointer to absolute value sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetSsiGenericSignalType( BYTE     *SignalType,
                                                         unsigned  Code,
                                                         unsigned  Bits );

    /*
    Build the signal type of a SSI absolute sensor by it's generic data.

      In :  SignalType  Pointer to signal type variable
            Code        Code of the sensor (0:binary, !=0:gray code)
            Bits        Number of databits of the sensor

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESsiGenericSignalTypeInfo( BYTE      SignalType,
                                                          unsigned *Code,
                                                          unsigned *Bits );

    /*
    Get the generic data of a SSI absolute sensor by it's signal type.

      In :  SignalType  Signal type of the SSI sensor
            Code        Pointer to storage for code of the sensor
                        (*code = 0:binary, !=0:gray code)
            Bits        Pointer to storage for number of databits of the sensor

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  #define SenUsrDataLen  128        /* Sensor UserData length (in Bytes)     */
  
  extern  unsigned  DLLAPI  DoPERdSensorUserData ( DoPE_HANDLE DoPEHdl,
                                                   WORD        Connector,
                                                   BYTE       *SenUsrData,
                                                   unsigned    Length );

    /*
    Read sensor user data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorUserData ( DoPE_HANDLE DoPEHdl,
                                                   WORD        Connector,
                                                   BYTE       *SenUsrData,
                                                   unsigned    Length );

    /*
    Write sensor user data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSenUserData ( DoPE_HANDLE DoPEHdl,
                                                WORD        SensorNo,
                                                BYTE       *SenUsrData,
                                                unsigned    Length );

    /*
    Read sensor user data

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSenUserDataSync ( DoPE_HANDLE DoPEHdl,
                                                    WORD        SensorNo,
                                                    BYTE       *SenUsrData,
                                                    unsigned    Length );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSenUserData ( DoPE_HANDLE DoPEHdl,
                                                WORD        SensorNo,
                                                BYTE       *SenUsrData,
                                                unsigned    Length,
                                                WORD       *lpusTAN );

    /*
    Write sensor user data

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            *SenUsrData   Pointer for sensor user data
            Length        User data buffer length in BYTEs

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSensorConKey ( DoPE_HANDLE DoPEHdl,
                                                 WORD        Connector,
                                                 WORD       *Connected,
                                                 WORD       *KeyPressed );

    /*
    Read sensor plug connected and key state

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *Connected  Pointer to the sensor plug connected state
                        (0=not connected, 1=connected)
            *KeyPressed Pointer to the sensor plug key state
                        (0=not pressed, 1=pressed)

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* System User Data configuration                                             */
/* -------------------------------------------------------------------------- */

  #define SysUsrDataLen  16         /* System UserData length (in Bytes)      */

  extern  unsigned  DLLAPI  DoPERdSysUserData ( DoPE_HANDLE DoPEHdl,
                                                BYTE       *SysUsrData,
                                                unsigned    Length );

    /*
    Read system user data

      In :  DoPEHdl     DoPE link handle
            *SysUsrData Pointer for SYSEEPROM user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* Obsolete or rarely used functions                                          */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEOpenSetupSync ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short  SetupNo );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOpenSetup ( DoPE_HANDLE     DoPEHdl,
                                            unsigned short  SetupNo,
                                            WORD           *lpusTAN );

    /*
    Open setup 'SetupNo' for read/write operations.

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPECloseSetupSync ( DoPE_HANDLE     DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECloseSetup ( DoPE_HANDLE     DoPEHdl,
                                             WORD           *lpusTAN );

    /*
    Close setup.

      In :  DoPEHdl     DoPE link handle

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSensorDef ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short SensorNo,
                                              DoPESenDef    *SensorDef );

    /*
    Read sensor definitions

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SensorDef  Pointer for DoPESenDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorDefSync ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short SensorNo,
                                                  DoPESenDef    *SensorDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSensorDef ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short SensorNo,
                                              DoPESenDef    *SensorDef,
                                              WORD          *lpusTAN );
    /*
    Write sensor definitions

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            *SensorDef    Pointer for DoPESenDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdCtrlSensorDef ( DoPE_HANDLE     DoPEHdl,
                                                  unsigned short  SensorNo,
                                                  DoPECtrlSenDef *CtrlSensorDef );

  extern  unsigned  DLLAPI  DoPERdCtrlSensorDefHigh ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  SensorNo,
                                                      DoPECtrlSenDef *CtrlSensorDef );

    /*
    Read definitions of control sensor for low and high pressure

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
            *CtrlSensorDef Pointer for DoPECtrlSenDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDefSync ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  SensorNo,
                                                      DoPECtrlSenDef *CtrlSensorDef );

  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDefHighSync ( DoPE_HANDLE     DoPEHdl,
                                                          unsigned short  SensorNo,
                                                          DoPECtrlSenDef *CtrlSensorDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDef ( DoPE_HANDLE     DoPEHdl,
                                                  unsigned short  SensorNo,
                                                  DoPECtrlSenDef *CtrlSensorDef,
                                                  WORD           *lpusTAN );

  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDefHigh ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  SensorNo,
                                                      DoPECtrlSenDef *CtrlSensorDef,
                                                      WORD           *lpusTAN );

    /*
    Write definitions of control sensor for low and high pressure

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
            *CtrlSensorDef Pointer for DoPECtrlSenDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdOutChannelDef ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short OutChNo,
                                                  DoPEOutChaDef *OutChDef );

    /*
    Read analogue output channel definitions

      In :  DoPEHdl     DoPE link handle
            OutChNo     Output channel no.
            *OutChDef   Pointer for DoPEOutChaDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrOutChannelDefSync ( DoPE_HANDLE    DoPEHdl,
                                                      unsigned short OutChNo,
                                                      DoPEOutChaDef *OutChDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrOutChannelDef ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short OutChNo,
                                                  DoPEOutChaDef *OutChDef,
                                                  WORD          *lpusTAN );
    /*
    Write analogue output channel definitions

      In :  DoPEHdl       DoPE link handle
            OutChNo       Output channel no.
            *OutChDef     Pointer for DoPEOutChaDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdBitOutDef ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short BitOutNo,
                                              DoPEBitOutDef *BitOutDef );

    /*
    Read Bit output definitions

      In :  DoPEHdl     DoPE link handle
            BitOutNo    Output channel no.
            *BitOutDef  Pointer for DoPEBitOutDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrBitOutDefSync ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short BitOutNo,
                                                  DoPEBitOutDef *BitOutDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrBitOutDef ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short BitOutNo,
                                              DoPEBitOutDef *BitOutDef,
                                              WORD          *lpusTAN );

    /*
    Write Bit output definitions

      In :  DoPEHdl       DoPE link handle
            BitOutNo      Output channel no.
            *BitOutDef    Pointer for DoPEBitOutDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdBitInDef ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short BitInNo,
                                             DoPEBitInDef  *BitInDef );

    /*
    Read Bit input definitions

      In :  DoPEHdl        DoPE link handle
            BitInNo        Output channel no.
            *BitInDef      Pointer for DoPEBitInDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */

/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrBitInDefSync ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short BitInNo,
                                                 DoPEBitInDef  *BitInDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrBitInDef ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short BitInNo,
                                             DoPEBitInDef  *BitInDef,
                                             WORD          *lpusTAN );

    /*
    Write Bit input definitions

      In :  DoPEHdl        DoPE link handle
            BitInNo        Output channel no.
            *BitInDef      Pointer for DoPEBitInDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdMachineDef ( DoPE_HANDLE     DoPEHdl,
                                               DoPEMachineDef *MachineDef );

    /*
    Read definitions of active machine

      In :  DoPEHdl     DoPE link handle
            *MachineDef Pointer for DoPEMachineDef structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrMachineDefSync ( DoPE_HANDLE     DoPEHdl,
                                                   DoPEMachineDef *MachineDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrMachineDef ( DoPE_HANDLE     DoPEHdl,
                                               DoPEMachineDef *MachineDef,
                                               WORD           *lpusTAN );

    /*
    Write definitions of active machine

      In :  DoPEHdl       DoPE link handle
            *MachineDef   Pointer for DoPEMachineDef structure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdLinTbl ( DoPE_HANDLE      DoPEHdl,
                                           DoPELinTblFalse *LinTblFalse,
                                           DoPELinTblTrue  *LinTblTrue  );

    /*
    Read linearisation table

      In :  DoPEHdl,      DoPE link handle
            *LinTblFalse Pointer to measured values structure
            *LinTblTrue  Pointer to reference values structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrLinTblSync ( DoPE_HANDLE      DoPEHdl,
                                               DoPELinTblFalse *LinTblFalse,
                                               DoPELinTblTrue  *LinTblTrue );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrLinTbl ( DoPE_HANDLE      DoPEHdl,
                                           DoPELinTblFalse *LinTblFalse,
                                           DoPELinTblTrue  *LinTblTrue,
                                           WORD            *lpusTANFirst,
                                           WORD            *lpusTANLast );

    /*
    Write linearisation table

      In :  DoPEHdl      DoPE link handle
            *LinTblFalse Pointer to measured values structure
            *LinTblTrue  Pointer to reference values structure

      Out:
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:           Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdIOSignals ( DoPE_HANDLE  DoPEHdl,
                                              DoPEIOSignals *IOSignals );

    /*
    Read IO signal definitions

      In :  DoPEHdl      DoPE link handle
            *IOSignals   Pointer to DoPEIOSignals structure

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrIOSignalsSync ( DoPE_HANDLE    DoPEHdl,
                                                  DoPEIOSignals *IOSignals );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrIOSignals ( DoPE_HANDLE    DoPEHdl,
                                              DoPEIOSignals *IOSignals,
                                              WORD          *lpusTAN );

    /*
    Write IO signal input definitions

      In :  DoPEHdl        DoPE link handle
            *IOSignals     Pointer for DoPEIOSignals structure

      Out :
            *lpusTAN       Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdMainMenu ( DoPE_HANDLE  DoPEHdl,
                                             DoPEMainMenu MainMenu[MAX_MAIN_MENU] );

    /*
    Read the main menu definition array

      In :  DoPEHdl      DoPE link handle
            MainMenu     Pointer to DoPEMainMenu array
                         The TestNo of the MainMenu entries is read only!

      Returns:           Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrMainMenuSync ( DoPE_HANDLE  DoPEHdl,
                                                 DoPEMainMenu MainMenu[MAX_MAIN_MENU] );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrMainMenu ( DoPE_HANDLE   DoPEHdl,
                                             DoPEMainMenu  MainMenu[MAX_MAIN_MENU],
                                             WORD         *lpusTAN  );

    /*
    Write the main menu definitions array

      In :  DoPEHdl      DoPE link handle
            MainMenu     Pointer to DoPEMainMenu array

      Out :
            *lpusTAN     Pointer to TAN used from this command

      Returns:           Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdRmcDef ( DoPE_HANDLE  DoPEHdl,
                                           DoPERmcDef  *RmcDef );

    /*
    Read RMC definitions

      In :  DoPEHdl      DoPE link handle
            *RmcDef      Pointer to DoPERmcDef structure

      Returns:           Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrRmcDefSync ( DoPE_HANDLE   DoPEHdl,
                                               DoPERmcDef   *RmcDef );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrRmcDef ( DoPE_HANDLE  DoPEHdl,
                                           DoPERmcDef  *RmcDef,
                                           WORD        *lpusTAN );

    /*
    Write RMC definitions

      In :  DoPEHdl        DoPE link handle
            *RmcDef        Pointer for DoPERmcDef structure

      Out :
            *lpusTAN       Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
