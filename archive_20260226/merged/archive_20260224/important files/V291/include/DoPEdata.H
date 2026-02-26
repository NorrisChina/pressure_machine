/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface data aquisition

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG, 26.1.2012 - V 2.72
  - IN_SIG_CPU_EMERGENCY_OFF defined
  
  HEG, 12.7.12 - V2.73
  - 16 Control Channels handled:
    - new DoPEData.Sensor3          (was DoPEData.SensorD)
    - new DoPEData.ActiveCtrl       (was DoPEData.SysState1)
    - new DoPEData.UpperSft         (was DoPEData.SysState2)
    - new DoPEData.LowerSft         (was DoPEData.SysState3)
    - new DoPEData.SensorConnected  (was DoPEData.SysState4)
    - new DoPEData.SensorKeyPressed (was DoPEData.SysState5)

  HEG, 19.9.13 - V 2.77
  - New Constant for 'OutSignals':
    - O_SIG_DRIVE_OFF

  HEG, 24.10.14 - V 2.80
  - New Mode parameter for DoPESetTime(Sync) and constatnt definitions:
    - SETTIME_MODE_IMMEDIATE
    - SETTIME_MODE_MOVE_START
    - SETTIME_MODE_FIRST_CYCLE
  - New DopE function:
    - DoPESetCycleMode
*******************************************************************************/


#ifndef DoPEdataaquisition_INCLUDED
#define DoPEdataaquisition_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

//-----------------------------------------------------------------------------

  /* ----- Constants  for 'InSignals' -------------------------------------- */

  #define IN_SIG_DRIVE_OFF           0x0001  /* Drive off or emergency off    */
  #define IN_SIG_E_MOVE_RQ           0x0002  /* Emergency off,                */
                                             /* emergency movement required   */
  #define IN_SIG_UPPER_LIMIT_SWITCH  0x0004  /* Upper hard-limit switch active*/
  #define IN_SIG_LOWER_LIMIT_SWITCH  0x0008  /* Lower hard-limit switch active*/
  #define IN_SIG_NO_CTRL             0x0010  /* Drive not ready (stop)        */
  #define IN_SIG_DF_KEY              0x0020  /* Drive free withdrawn by key   */
  #define IN_SIG_SHALT               0x0040  /* Signal S-HALT activated       */

  #define IN_SIG_REFERENZ            0x0080  /* X-head reference switch       */
  #define IN_SIG_SH_CLOSED           0x0100  /* Shield closed                 */
  #define IN_SIG_SH_LOCKED           0x0200  /* Shield locked                 */
  #define IN_SIG_SH_INACTIVE         0x0400  /* Shield function inactive      */
  #define IN_SIG_IO_SHALT_UPPER      0x0800  /* IO-Signal SHaltUpper          */
  #define IN_SIG_IO_SHALT_LOWER      0x1000  /* IO-Signal SHaltLower          */
  #define IN_SIG_CPU_EMERGENCY_OFF   0x2000  /* Internal emergency off        */


  /* ----- Constants  for 'OutSignals' -------------------------------------- */

  #define O_SIG_DRIVE_ON      0x0001         /* Drive ON output               */
  #define O_SIG_DRIVE_FREE    0x0002         /* Drive FREE output             */
  #define O_SIG_BRAKE         0x0004         /* Brake output                  */
  #define O_SIG_E_MOVE        0x0008         /* Emergency movement output     */
  #define O_SIG_BYPASS        0x0010         /* Bypass output                 */

  #define O_SIG_LIMIT         0x0020         /* Load limit for grip reached   */
  #define O_SIG_SH_LOCK       0x0040         /* Lock Shield                   */
  #define O_SIG_ON_RELAY      0x0080         /* ON Relay output               */
  #define O_SIG_INTERNAL_DRIVE_ENABLE 0x0200
  #define O_SIG_READY_TO_MOVE 0x0400         /* Controller ready for pos.cmd. */
  #define O_SIG_EDC_READY     0x0800         /* EDC ready                     */
  #define O_SIG_DRIVE_OFF     0x1000         /* EDC Drive Off                  */


  /* ----- Constants  for 'CtrlState1' -------------------------------------- */

  /* --------- 1. Hexnibble : Bit for control mode -------------------------- */
  #define CTRL_STATE_POS    0x0001  /* X-Head control is active               */
  #define CTRL_STATE_LOAD   0x0002  /* Load control is active                 */
  #define CTRL_STATE_EXT    0x0004  /* Extension control is active            */

  /* --------- 2. Hexnibble : State  command generator and X-Head ----------- */
  #define CTRL_HALT         0x0010  /* Command generator not running          */
  #define CTRL_DOWN         0x0020  /* Movement DOWN                          */
  #define CTRL_UP           0x0040  /* Movement UP                            */
  #define CTRL_MOVE         0x0080  /* X-Head moves (not halted)              */

  /* --------- 3. and 4. Hexnibble : State  movement control ---------------- */
  #define CTRL_READY        0x0100  /* Moving command will be accepted        */
  #define CTRL_FREE         0x0200  /* Waiting for free signal (PC or user)   */
  #define CTRL_INIT_E       0x0400  /* Emergency movement has to be activated */
  #define CTRL_SFTSET       0x0800  /* Change of softends allowed             */

  #define CTRL_SYNCHWAIT    0x2000  /* Synch State: 1 = wait for Start        */
  #define CTRL_SLAVE        0x4000  /* Synch State: 0 = Master 1 = Slave      */
  #define CTRL_E_ACTIVE     0x8000  /* Emergency movement active              */


  /* ----- Constants  for 'CtrlState2' -------------------------------------- */

  /* ---- Status bits in controller status WORD 2 --------------------------- */
  #define CTRL_LOWER_SFT_S   0x0001       /*  Lower softend X-Head            */
  #define CTRL_LOWER_SFT_F   0x0002       /*  Lower softend load              */
  #define CTRL_LOWER_SFT_E   0x0004       /*  Lower softend extension         */
  #define CTRL_UPPER_SFT_S   0x0010       /*  Upper softend X-Head            */
  #define CTRL_UPPER_SFT_F   0x0020       /*  Upper softend load              */
  #define CTRL_UPPER_SFT_E   0x0040       /*  Upper softend extension         */

  #define CTRL_CYCLES_ACTIVE 0x0400       /*  Cycle command active            */
                                          /* (cosin, rectangle, triangle,     */
                                          /*  cycles, dyn_cycles)             */
  #define CTRL_HIGH_PRESSURE 0x0800       /*  High pressure                   */
  #define CTRL_UPPER_LIMIT   0x4000       /*  Upper range limit of any sensor */
  #define CTRL_LOWER_LIMIT   0x2000       /*  Lower range limit of any sensor */
  #define CTRL_CALIBRATION   0x1000       /*  Calibrate analogue channels     */
  #define CTRL_ERROR         0x8000       /* Deviation position controller    */


#pragma pack(8)

  typedef  struct                      /* Default measuring data record      */
    {                                  /* ---------------------------------- */
      unsigned long  Cycles;           /* Cycle counter                      */
      double         Time;             /* Time from subsystem                */
      double         Position;         /* X-Head position                    */
      double         Load;             /* Load                               */
      double         Extension;        /* Extension                          */
      double         Sensor3;          /* Sensor 3  measuring channel        */
      double         Sensor4;          /* Sensor 4  measuring channel        */
      double         Sensor5;          /* Sensor 5  measuring channel        */
      double         Sensor6;          /* Sensor 6  measuring channel        */
      double         Sensor7;          /* Sensor 7  measuring channel        */
      double         Sensor8;          /* Sensor 8  measuring channel        */
      double         Sensor9;          /* Sensor 9  measuring channel        */
      double         Sensor10;         /* Sensor 10 measuring channel        */
      double         Sensor11;         /* Sensor 11 measuring channel        */
      double         Sensor12;         /* Sensor 12 measuring channel        */
      double         Sensor13;         /* Sensor 13 measuring channel        */
      double         Sensor14;         /* Sensor 14 measuring channel        */
      double         Sensor15;         /* Sensor 15 measuring channel        */
      unsigned short BitIn0;           /* Digital input device 0             */
      unsigned short BitIn1;           /* Digital input device 1             */
      unsigned short BitIn2;           /* Digital input device 2             */
      unsigned short BitIn3;           /* Digital input device 3             */
      unsigned short BitIn4;           /* Digital input device 4             */
      unsigned short BitIn5;           /* Digital input device 5             */
      unsigned short BitIn6;           /* Digital input device 6             */
      unsigned short BitIn7;           /* Digital input device 7             */
      unsigned short BitIn8;           /* Digital input device 8             */
      unsigned short BitIn9;           /* Digital input device 9             */
      unsigned short BitOut0;          /* Digital output device 0            */
      unsigned short BitOut1;          /* Digital output device 1            */
      unsigned short BitOut2;          /* Digital output device 2            */
      unsigned short BitOut3;          /* Digital output device 3            */
      unsigned short BitOut4;          /* Digital output device 4            */
      unsigned short BitOut5;          /* Digital output device 5            */
      unsigned short BitOut6;          /* Digital output device 6            */
      unsigned short BitOut7;          /* Digital output device 7            */
      unsigned short BitOut8;          /* Digital output device 8            */
      unsigned short BitOut9;          /* Digital output device 9            */
      unsigned short InSignals;        /* Logical input signals              */
      unsigned short OutSignals;       /* Logical output signals             */
      unsigned short CtrlState1;       /* Controller status WORD 1           */
      unsigned short CtrlState2;       /* Controller status WORD 2           */
      unsigned short UpperLimits;      /* Upper limits exceeded              */
      unsigned short LowerLimits;      /* Lower limits exceeded              */
      unsigned short SysState0;        /* System status WORD 0               */
      unsigned short ActiveCtrl;       /* Active control channel             */
      unsigned short UpperSft;         /* Upper soft limit active            */
      unsigned short LowerSft;         /* Lower soft limit active            */
      unsigned short SensorConnected;  /* Sensor plug connected state        */
      unsigned short SensorKeyPressed; /* Sensor plug key state              */
      double Test1;                    /* Configured test value 1            */
      double Test2;                    /* Configured test value 2            */
      double Test3;                    /* Configured test value 3            */
      unsigned short Keys;             /* Actual State of EDC frontpanel keys*/
      unsigned short NewKeys;          /* New keys                           */
      unsigned short GoneKeys;         /* Gone keys                          */
    } DoPEData;

#pragma pack()


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPECtrlTestValues  ( DoPE_HANDLE DoPEHdl,
                                                  WORD        State );

    /*
    Enable or disable the controller test variables.

      In :  DoPEHdl     DoPE link handle
            State       !=0  enables
                        0    disables the controller test variables in
                        the DoPEData record.

      Returns:          Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEIntgrSync ( DoPE_HANDLE  DoPEHdl,
                                            WORD         SensorNo,
                                            double       Intgr );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIntgr ( DoPE_HANDLE  DoPEHdl,
                                        WORD         SensorNo,
                                        double       Intgr,
                                        WORD        *lpusTAN );

    /*
    Set time of integration for an analogue measuring channel.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Intgr         Integration time for analogue measuring channels in sec.
                          The limits the integration time depend on the selected
                          time base for the speed control loop cycle time.
                          (see machine setup data)
                          The minimum time is   1 x (time base for the speed control)
                          The maximum time is 100 x (time base for the speed control)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetDataTransmissionRateSync  ( DoPE_HANDLE DoPEHdl,
                                                               double      Refresh );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetDataTransmissionRate  ( DoPE_HANDLE DoPEHdl,
                                                           double      Refresh,
                                                           WORD       *lpusTAN );

    /*
    Set time base for data acquisition for all measuring channels.
    The default refresh time is defined in the setup data.

      In :  DoPEHdl       DoPE link handle
            Refresh       Time in s

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetSensorDataTransmissionRateSync ( DoPE_HANDLE DoPEHdl,
                                                                    WORD        SensorNo,
                                                                    double      Refresh );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetSensorDataTransmissionRate  ( DoPE_HANDLE DoPEHdl,
                                                                 WORD        SensorNo,
                                                                 double      Refresh,
                                                                 WORD       *lpusTAN );

    /*
    Set time base for data acquisition for a measuring channel.
    The default refresh time is defined
    in the setup data.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Refresh       Time in s

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPETransmitDataSync  ( DoPE_HANDLE    DoPEHdl,
                                                    unsigned short Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPETransmitData  ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short Enable,
                                                WORD          *lpusTAN );

    /*
    Activate / Deactivate transmission of data. If deactivated no measuring data
    will be transmitted to the PC!

      In :  DoPEHdl       DoPE link handle
            Enable        !=0  Activate transmission
                          0    Deactivate transmission

       Out :
           *lpusTAN       Pointer to TAN used from this command

     Returns:             Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  // Constants for Mode
  #define SETTIME_MODE_IMMEDIATE    0   // set time immediately
  #define SETTIME_MODE_MOVE_START   1   // set time at the start of a movement command
  #define SETTIME_MODE_FIRST_CYCLE  2   // set time at the start of the first cycle


  extern  unsigned  DLLAPI  DoPESetTimeSync  ( DoPE_HANDLE DoPEHdl,
                                               WORD        Mode,
                                               double      Time );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetTime  ( DoPE_HANDLE DoPEHdl,
                                           WORD        Mode,
                                           double      Time,
                                           WORD       *lpusTAN );
    /*
    Set time counter to a desired value.

      In :  DoPEHdl       DoPE link handle
            Mode          Set time immediate, at start of movement or at first cycle       
            Time          New value for Time in s

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECalSync ( DoPE_HANDLE     DoPEHdl,
                                          unsigned short  SensorBits );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECal ( DoPE_HANDLE     DoPEHdl,
                                      unsigned short  SensorBits,
                                      WORD           *lpusTAN );

    /*
    Compensate drifts (zero and amplification) of the measuring channel.
    It takes about 0.5 s to compensate drifts.
    During compensation the sensor is not measured!!!

      In :  DoPEHdl       DoPE link handle
                          SensorBits Bit 0 .. 15 define the sensor Number to be calibrated.
                                     Bit 0 = 1 Calibrate Sensor 0
                                     Bit 1 = 1 Calibrate Sensor 1 ...

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEZeroCalSync ( DoPE_HANDLE     DoPEHdl,
                                              unsigned short  SensorBits );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEZeroCal ( DoPE_HANDLE     DoPEHdl,
                                          unsigned short  SensorBits,
                                          WORD           *lpusTAN );

    /*
    Compensate only zero offset drift.
    It takes about 0.2 s to compensate zero offset drift.
    During compensation the sensor is not measured!!!

      In :  DoPEHdl       DoPE link handle
                          SensorBits Bit 0 .. 15 define the sensor Number to be calibrated.
                                     Bit 0 = 1 Calibrate zero offset of Sensor 0
                                     Bit 1 = 1 Calibrate zero offset of Sensor 1 ...

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPECurrentData ( DoPE_HANDLE   DoPEHdl,
                                              DoPEData     *Sample  );

    /*
    Get current samples from receiver buffer.
    DoPE receives measuring data in a adjustable time scale. The data record is
    stored inside DoPE in a circular buffer. You can read the latest data record
    with this function.

      In :  DoPEHdl     DoPE link handle
            Sample      Pointer to storage for data record.

      Out:  *Sample     DoPEData record

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetCycleMode  ( DoPE_HANDLE  DoPEHdl,
                                                unsigned     Enable );

    /*
    Enable/disable unified cycle handling for cyclic movement commands.

      In :  DoPEHdl     DoPE link handle
            Enable      != 0 enables
                        == 0 disables unified cycle handling (default)

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Old Functions (don't use for new designs, use event handlers instead)      */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEGetData ( DoPE_HANDLE   DoPEHdl,
                                          DoPEData     *Sample  );

    /*
    Get samples from receiver buffer.
    DoPE receives measuring data in a adjustable time scale. The data record is
    stored inside DoPE in a circular buffer. You can read one data record
    with this function.

      In :  DoPEHdl     DoPE link handle
            Sample      Pointer to storage for data record.

      Out:  *Sample     DoPEData record

      Returns:          Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
