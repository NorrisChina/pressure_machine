/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface setup and movement command handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG 18.09.13 - V2.77
  - NEW Modes for DynCycle Command:
    - DYN_WAVEFORM_SAW_TOOTH, DYN_WAVEFORM_SAW_TOOTH_INV, DYN_WAVEFORM_PULSE

*******************************************************************************/


#ifndef DoPEmovement_INCLUDED
#define DoPEmovement_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* ------ Constants  for 'Mode' DoPEExt2Ctrl and DoPEFDPoti ----------------- */
                                    /* Constants 0 .. 3 refer to measuring    */
                                    /* values. E.g EXT_SPEED_POSITIVE         */
                                    /* moves to increasing values.            */
  #define EXT_POSITION       0      /* Position                               */
  #define EXT_SPEED_BIPOLAR  1      /* Speed bipolar                          */
  #define EXT_SPEED_POSITIVE 2      /* Speed positive direction               */
  #define EXT_SPEED_NEGATIVE 3      /* Speed negative direction               */

                                    /* Direction UP/DOWN                      */
                                    /* Constants 0 .. 3 refer to movement     */
                                    /* UP/DOWN. E.g EXT_SPEED_UP moves        */
                                    /* crosshead UP.                          */
  #define EXT_POS_UP_DOWN    4      /* Position                               */
  #define EXT_SPEED_UP_DOWN  5      /* Speed bipolar                          */
  #define EXT_SPEED_UP       6      /* Speed UP                               */
  #define EXT_SPEED_DOWN     7      /* Speed DOWN                             */

  #define EXT_POS_OPENLOOP   8      /* Position (only for open loop position  */
                                    /* ctrl-structure.) and PS_FDPOTI         */

/* ------ Constants  for 'Direction' in DoPEFMove command  ------------------ */

  #define MOVE_HALT          0      /*  Halt                                  */
  #define MOVE_UP            1      /*  move UP                               */
  #define MOVE_DOWN          2      /*  move DOWN                             */


/* ------ Constants  for 'LimitMode' and 'DestMode' in DoPEPosExt... commands */

  #define LIMIT_ABSOLUTE     0        /* Limit is a absolute Position         */
  #define LIMIT_RELATIVE     1        /* Limit is a distance (relative)Position */
  #define LIMIT_NOT_ACTIVE   2        /* No Limit is active                   */

  #define DEST_APPROACH      0        /* Halt after reaching destination,     */
                                      /* do not change control mode           */
  #define DEST_POSITION      1        /* Change control mode in time and      */
                                      /* position to destination              */
  #define DEST_MAINTAIN      2        /* No change of control mode at destination */
                                      /* but maintain destination MoveCtrl mode */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEOnSync ( DoPE_HANDLE DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOn ( DoPE_HANDLE DoPEHdl,
                                     WORD       *lpusTAN );

    /*
    Activate drive.
    On EDC100 systems the drive is activated by the "ON" push button.

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEOffSync ( DoPE_HANDLE DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOff ( DoPE_HANDLE DoPEHdl,
                                      WORD       *lpusTANFirst,
                                      WORD       *lpusTANLast );

    /*
    Deactivate drive.

      In :  DoPEHdl       DoPE link handle

      Out :
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* --------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEHaltSync ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEHalt ( DoPE_HANDLE    DoPEHdl,
                                       unsigned short MoveCtrl,
                                       WORD          *lpusTAN );

    /*
    Halt movement of crosshead in the specified control mode.
    Default deceleration will be used.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for halt

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESHaltSync ( DoPE_HANDLE DoPEHdl,
                                            WORD       *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESHalt ( DoPE_HANDLE DoPEHdl,
                                        WORD       *lpusTAN );

    /*
    Halt movement of crosshead in position control mode.
    Instant start of deceleration (command value = measured value).
    Default deceleration will be used.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEHalt_ASync ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short MoveCtrl,
                                             double         Dec,
                                             WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEHalt_A ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short MoveCtrl,
                                         double         Dec,
                                         WORD          *lpusTAN );

    /*
    Halt movement of crosshead in the specified control mode.
    Deceleration is a parameter of the command.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for halt
            Dec           Deceleration

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEHaltWSync    ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Delay,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEHaltW    ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Delay,
                                           WORD          *lpusTAN );

    /*
    Halt movement of crosshead in the specified control mode.
    Default deceleration will be used.
    After crosshead is halted and the specified delay time is over,
    a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for halt
            Delay         Delay time

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEHaltW_ASync  ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Dec,
                                               double         Delay,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEHaltW_A  ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Dec,
                                           double         Delay,
                                           WORD          *lpusTAN );

    /*
    Halt movement of crosshead in the specified control mode.
    Deceleration is a parameter of the command.
    After crosshead is halted and the specified delay time is over,
    a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for halt
            Dec           Deceleration
            Delay         Delay time

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetCtrlSync ( DoPE_HANDLE DoPEHdl,
                                              unsigned    Enable,
                                              WORD       *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetCtrl ( DoPE_HANDLE DoPEHdl,
                                          unsigned    Enable,
                                          WORD       *lpusTAN );

    /*
    Enable / disable closed loop control

      In :  DoPEHdl       DoPE link handle
            Enable        !=0  enables
                          0    disables closed loop control

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEFMoveSync ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short Direction,
                                            unsigned short MoveCtrl,
                                            double         Speed,
                                            WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEFMove ( DoPE_HANDLE    DoPEHdl,
                                        unsigned short Direction,
                                        unsigned short MoveCtrl,
                                        double         Speed,
                                        WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed UP or DOWN.
    Default acceleration will be used.
    As an implicit limit of this command, softend's are used.

      In :  DoPEHdl       DoPE link handle
            Direction     Direction of movement
            MoveCtrl      Control mode of movement
            Speed         Speed for movement

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEFMove_ASync ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short Direction,
                                              unsigned short MoveCtrl,
                                              double         Acc,
                                              double         Speed,
                                              WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEFMove_A ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short Direction,
                                          unsigned short MoveCtrl,
                                          double         Acc,
                                          double         Speed,
                                          WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed UP or DOWN.
    Acceleration is a parameter of the command.
    As an implicit limit of this command, softend's are used.

      In :  DoPEHdl       DoPE link handle
            Direction     Direction of movement
            MoveCtrl      Control mode of movement
            Speed         Speed for movement

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* --------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosSync ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short MoveCtrl,
                                          double         Speed,
                                          double         Destination,
                                          WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPos ( DoPE_HANDLE    DoPEHdl,
                                      unsigned short MoveCtrl,
                                      double         Speed,
                                      double         Destination,
                                      WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Default acceleration and deceleration will be used.
    After destination has been reached, a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Speed         Speed for positioning
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPos_ASync ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short MoveCtrl,
                                            double         Acc,
                                            double         Speed,
                                            double         Dec,
                                            double         Destination,
                                            WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPos_A ( DoPE_HANDLE    DoPEHdl,
                                        unsigned short MoveCtrl,
                                        double         Acc,
                                        double         Speed,
                                        double         Dec,
                                        double         Destination,
                                        WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Acceleration and deceleration are parameters of the command.
    After destination has been reached, a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Acc           Acceleration
            Speed         Speed for positioning
            Dec           Deceleration
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)

    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosExtSync    ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short MoveCtrl,
                                                double         Speed,
                                                unsigned short LimitMode,
                                                double         Limit,
                                                unsigned short DestinationCtrl,
                                                double         Destination,
                                                unsigned short DestinationMode,
                                                WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosExt    ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short MoveCtrl,
                                            double         Speed,
                                            unsigned short LimitMode,
                                            double         Limit,
                                            unsigned short DestinationCtrl,
                                            double         Destination,
                                            unsigned short DestinationMode,
                                            WORD          *lpusTAN );

    /*

    FUNCTION NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Use instead of : DoPEPosG1, DoPEPosG2, DoPEPosD1, DoPEPosD2 !!

    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the limit position has been reached,
    a message will be transmitted.


      In :  DoPEHdl         DoPE link handle
            MoveCtrl        Control mode for positioning
            Speed           Speed for positioning
            LimitMode       Limit is a relative or absolute position
            Limit           Limit position
            DestinationCtrl Channel definition for destination
            Destination     Final destination
            DestinationMode Mode at destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosExt_ASync    ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short MoveCtrl,
                                                  double         Acc,
                                                  double         Speed,
                                                  double         DecLimit,
                                                  unsigned short LimitMode,
                                                  double         Limit,
                                                  unsigned short DestinationCtrl,
                                                  double         DecDestination,
                                                  double         Destination,
                                                  unsigned short DestinationMode,
                                                  WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosExt_A    ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short MoveCtrl,
                                              double         Acc,
                                              double         Speed,
                                              double         DecLimit,
                                              unsigned short LimitMode,
                                              double         Limit,
                                              unsigned short DestinationCtrl,
                                              double         DecDestination,
                                              double         Destination,
                                              unsigned short DestinationMode,
                                              WORD          *lpusTAN );

    /*

    FUNCTION NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Use instead of : DoPEPosG1, DoPEPosG2, DoPEPosD1, DoPEPosD2 !!

    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the limit position has been reached,
    a message will be transmitted.


      In :  DoPEHdl         DoPE link handle
            MoveCtrl        Control mode for positioning
            Acc             Acceleration
            Speed           Speed for positioning
            DecLimit        Deceleration for limit position
            LimitMode       Limit is a relative or absolute position
            Limit           absolute limit position
            DestinationCtrl Channel definition for destination
            DecDestination  Deceleration for final destination
            Destination     Final destination
            DestinationMode Mode at destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPETrigSync     ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed,
                                               double         Limit,
                                               unsigned short TriggerCtrl,
                                               double         Trigger,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPETrig     ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed,
                                           double         Limit,
                                           unsigned short TriggerCtrl,
                                           double         Trigger,
                                           WORD          *lpusTAN );

    /*
    Move crosshead with the specified speed to the limit position.
    Acceleration and deceleration are parameters of the command.
    If the the trigger position is reached a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for moving
            Speed         Speed for moving
            Limit         Absolute limit position for movement
            TriggerCtrl   Sensor number of trigger channel
            Trigger       Position

       Out :
           *lpusTAN       Pointer to TAN used from this command

     Returns:             Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPETrig_ASync   ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Acc,
                                               double         Speed,
                                               double         Dec,
                                               double         Limit,
                                               unsigned short TriggerCtrl,
                                               double         Trigger,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPETrig_A   ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Acc,
                                           double         Speed,
                                           double         Dec,
                                           double         Limit,
                                           unsigned short TriggerCtrl,
                                           double         Trigger,
                                           WORD          *lpusTAN );

    /*
    Move crosshead with the specified speed to the limit position.
    Default acceleration and deceleration will be used.
    If the the trigger position is reached a message will be transmitted.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for moving
            Acc           Acceleration
            Speed         Speed for moving
            Dec           Deceleration
            Limit         Absolute limit position for movement
            TriggerCtrl   Sensor number of trigger channel
            Trigger       Position

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEXpContSync   ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Limit,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEXpCont   ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Limit,
                                           WORD          *lpusTAN );

    /*
    Change control mode and continue movement in the new control mode
    with the actual speed.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Limit         Limit position for movement

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEExt2CtrlSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         OffsetCtrl,
                                               unsigned short SensorNo,
                                               double         OffsetSensor,
                                               unsigned short Mode,
                                               double         Scale,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEExt2Ctrl ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         OffsetCtrl,
                                           unsigned short SensorNo,
                                           double         OffsetSensor,
                                           unsigned short Mode,
                                           double         Scale,
                                           WORD          *lpusTAN );

    /*
    Move crosshead according to an external command signal.
    This command works not properly when DoPEConfPeekValue or one of the
    DoPEConfCMc commands are used.

      In :  DoPEHdl        DoPE link handle
            MoveCtrl       Control mode for positioning
            OffsetCtrl     Offset for move control channel
            SensorNo       Sensor number for the external command signal
            OffsetSensor   Offset for external command signal
            Mode           various position or speed control modes
            Scale          Scaling factor for external command signal

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEFDPotiSync ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short MoveCtrl,
                                             double         MaxSpeed,
                                             unsigned short SensorNo,
                                             unsigned short DxTrigger,
                                             unsigned short Mode,
                                             double         Scale,
                                             WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEFDPoti ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short MoveCtrl,
                                         double         MaxSpeed,
                                         unsigned short SensorNo,
                                         unsigned short DxTrigger,
                                         unsigned short Mode,
                                         double         Scale,
                                         WORD          *lpusTAN );

    /*
    Move crosshead according to an external command signal generated by
    a digital encoder (DigiPoti).
    This is a special version of the DoPEExt2Ctrl command.
    Offsets and limits are handled inside this function.
    This command works not properly when DoPEConfPeekValue or one of the
    DoPEConfCMc commands are used.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            MaxSpeed      Start speed for speed controlled modes
            SensorNo      Sensor Number for the external command input.
                          Use Sensor SENSOR_DP for Digital Encoder
                          (DigiPoti) on EDC frontpanel.
            DxTrigger     Dead area of encoder. The Encoder has to change
                          the specified number of digits before the command
                          is active.
                          For EDC frontpanel DigiPoti 2 or 3 is a good value.
            Mode          one of the following position or speed control modes
                             EXT_POS_UP_DOWN
                             EXT_SPEED_UP
                             EXT_SPEED_DOWN
                             EXT_POS_OPENLOOP
            Scale         For EXT_POSITION Number of Units per revolution
                          eg. Scale =  1 -> 1 mm per revolution,
                              Scale = 10 -> 10 N per revolution
                          For EXT_SPEED_xx Number of revolutions to nominal speed
                          eg. Scale = 2  -> after 2 revolutions to nominal speed

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECycleSync ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short MoveCtrl,
                                            double         Speed1,
                                            double         Dest1,
                                            double         Halt1,
                                            double         Speed2,
                                            double         Dest2,
                                            double         Halt2,
                                            unsigned long  Cycles,
                                            double         Speed,
                                            double         Destination,
                                            WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECycle ( DoPE_HANDLE    DoPEHdl,
                                        unsigned short MoveCtrl,
                                        double         Speed1,
                                        double         Dest1,
                                        double         Halt1,
                                        double         Speed2,
                                        double         Dest2,
                                        double         Halt2,
                                        unsigned long  Cycles,
                                        double         Speed,
                                        double         Destination,
                                        WORD          *lpusTAN );

    /*
    General cycle movement.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Speed1        Speed to reach destination 1
            Dest1         Destination 1
            Halt1         Halt time at destination 1
            Speed2        Speed to reach destination 2
            Dest2         Destination 2
            Halt2         Halt time at destination 2
            Cycles        Number of cycles
            Speed         Speed to final destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPETriangleSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed1,
                                               double         Dest1,
                                               double         Dest2,
                                               double         Frequency,
                                               unsigned long  HalfCycles,
                                               double         Speed,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPETriangle ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed1,
                                           double         Dest1,
                                           double         Dest2,
                                           double         Frequency,
                                           unsigned long  HalfCycles,
                                           double         Speed,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Triangular movement.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Speed1        Speed to reach destination 1
            Dest1         Destination 1
            Dest2         Destination 2
            Frequency     Frequency
            HalfCycles    Number of half cycles
            Speed         Speed to final destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERectangleSync ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short MoveCtrl,
                                                double         Speed1,
                                                double         Dest1,
                                                double         Dest2,
                                                double         Frequency,
                                                unsigned long  HalfCycles,
                                                double         Speed,
                                                double         Destination,
                                                WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPERectangle ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short MoveCtrl,
                                            double         Speed1,
                                            double         Dest1,
                                            double         Dest2,
                                            double         Frequency,
                                            unsigned long  HalfCycles,
                                            double         Speed,
                                            double         Destination,
                                            WORD          *lpusTAN );

    /*
    Rectangular movement.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Speed1        Speed to reach destination 1
            Dest1         Destination 1
            Dest2         Destination 2
            Frequency     Frequency
            HalfCycles    Number of half cycles
            Speed         Speed to final destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/


  #define DYN_WAVEFORM_COSINE        0
  #define DYN_WAVEFORM_TRIANGLE      1
  #define DYN_WAVEFORM_RECTANGLE     2
  #define DYN_WAVEFORM_SAW_TOOTH     3
  #define DYN_WAVEFORM_SAW_TOOTH_INV 4
  #define DYN_WAVEFORM_PULSE         5


  /* No sweep active                  */
  #define DYN_SWEEP_OFF                       0

  /* Linear sweep from e.g Frequency to SweepEndFrequency */
  #define DYN_SWEEP_LINEAR                    1

  /* Logarithmic sweep from e.g Frequency to SweepEndFrequency */
  #define DYN_SWEEP_LOGARITHMIC               2

  /* Linear sweep at Start, and End of cycles */
  #define DYN_SWEEP_LINEAR_START_END          3

  /* Logarithmic sweep at Start, and End of cycles */
  #define DYN_SWEEP_LOGARITHMIC_START_END     4


  /* No superposition active */
  #define DYN_SUPERPOS_OFF                    0 
  
  /* Superposition active */
  #define DYN_SUPERPOS_ON                     1


  /* No bimodal control active */
  #define DYN_BIMODAL_CTRL_OFF                0

  /* Keep arithmetic mean value of second sensor constant by changing the offset of the controlled sensor       */
  #define DYN_BIMODAL_ARITHMETIC_MEAN_VALUE   1  

  /* Keep the mean value of second sensor constant by changing the offset of the controlled sensor              */
  #define DYN_BIMODAL_MEAN_VALUE              2  

  /* Keep the minimum value of second sensor constant by changing the offset of the controlled sensor           */
  #define DYN_BIMODAL_MIN_VALUE               3  

  /* Keep the maximum value of second sensor constant by changing the offset of the controlled sensor           */
  #define DYN_BIMODAL_MAX_VALUE               4  

  /* Keep the amplitude of second sensor constant by changing the offset and amplitude of the controlled sensor */
  #define DYN_BIMODAL_AMPLITUDE_OFFSET_VAR    5  

  /* Keep the amplitude of second sensor constant by changing the amplitude of the controlled sensor. 
     The offset of the controlled sensor is constant                                                            */
  #define DYN_BIMODAL_AMPLITUDE_OFFSET_CONST  6  


  extern  unsigned  DLLAPI  DoPEDynCyclesSync ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short WaveForm,
                                                unsigned short Modify,
                                                unsigned short PeakCtrl,
                                                unsigned short MoveCtrl,
                                                unsigned short RelativeDestination,
                                                double         SpeedToStart,
                                                double         Offset,
                                                double         Amplitude,
                                                double         HaltAtPlusAmplitude,
                                                double         HaltAtMinusAmplitude,
                                                double         Frequency,
                                                unsigned long  HalfCycles,
                                                double         SpeedToDestination,
                                                double         Destination,
                                                unsigned short SweepFrequencyMode,
                                                double         SweepEndFrequency,
                                                double         SweepFrequencyTime,
                                                unsigned long  SweepFrequencyCount,
                                                unsigned short SweepOffsetMode,
                                                double         SweepEndOffset,
                                                double         SweepOffsetTime,
                                                unsigned long  SweepOffsetCount,
                                                unsigned short SweepAmplitudeMode,
                                                double         SweepEndAmplitude,
                                                double         SweepAmplitudeTime,
                                                unsigned long  SweepAmplitudeCount,
                                                unsigned short SuperpositionMode,
                                                double         SuperpositionFrequency,
                                                double         SuperpositionAmplitude,
                                                unsigned short BimodalCtrlMode,
                                                unsigned short BimodalCtrlSensor,
                                                double         BimodalValue1,
                                                double         BimodalValue2,
                                                double         BimodalScale,
                                                unsigned short *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDynCycles ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short WaveForm,
                                            unsigned short Modify,
                                            unsigned short PeakCtrl,
                                            unsigned short MoveCtrl,
                                            unsigned short RelativeDestination,
                                            double         SpeedToStart,
                                            double         Offset,
                                            double         Amplitude,
                                            double         HaltAtPlusAmplitude,
                                            double         HaltAtMinusAmplitude,
                                            double         Frequency,
                                            unsigned long  HalfCycles,
                                            double         SpeedToDestination,
                                            double         Destination,
                                            unsigned short SweepFrequencyMode,
                                            double         SweepEndFrequency,
                                            double         SweepFrequencyTime,
                                            unsigned long  SweepFrequencyCount,
                                            unsigned short SweepOffsetMode,
                                            double         SweepEndOffset,
                                            double         SweepOffsetTime,
                                            unsigned long  SweepOffsetCount,
                                            unsigned short SweepAmplitudeMode,
                                            double         SweepEndAmplitude,
                                            double         SweepAmplitudeTime,
                                            unsigned long  SweepAmplitudeCount,
                                            unsigned short SuperpositionMode,
                                            double         SuperpositionFrequency,
                                            double         SuperpositionAmplitude,
                                            unsigned short BimodalCtrlMode,
                                            unsigned short BimodalCtrlSensor,
                                            double         BimodalValue1,
                                            double         BimodalValue2,
                                            double         BimodalScale,
                                            unsigned short *lpusTAN );

    /*
    Dynamic cycles.

      In :  DP                      DoPE link handle
            WaveForm                DYN_WAVEFORM_xxx (Cosine, Triangular,…)
            Modify                  Modify Parameter of active cycles
            PeakCtrl                Peak control cycles 0, 1,2,4,8,16

            MoveCtrl                Control mode for movement
            RelativeDestination     false, Offset, and Destination absolute
                                    true, Offset, and Destination relative
            SpeedToStart            Speed to Offset + Amplitude
            Offset                  Offset
            Amplitude               Amplitude
            HaltAtPlusAmplitude     Halt Time at Offset + Amplitude
            HaltAtMinusAmplitude    Halt Time at Offset - Amplitude
            Frequency               Frequency
            HalfCycles              Number of half cycles
            SpeedToDestination      Speed to final destination (0=automatic speed calculation)
            Destination             Final destination

            SweepFrequencyMode      DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
            SweepEndFrequency       End frequency for frequency sweep
            SweepFrequencyTime      Time for frequency sweep
            SweepFrequencyCount     Frequency sweep counter (0=infinitive)

            SweepOffsetMode         DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
            SweepEndOffset          Second offset for offset sweep
            SweepOffsetTime         Time for offset sweep
            SweepOffsetCount        Offset sweep counter (0=infinitive)

            SweepAmplitudeMode      DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
            SweepEndAmplitude       Second amplitude for amplitude sweep
            SweepAmplitudeTime      Time for amplitude sweep
            SweepAmplitudeCount     Amplitude sweep counter (0=infinitive)

            SuperpositionMode       Superposition Mode (DYN_SUPERPOS_ON, DYN_SUPERPOS_OFF) 
            SuperpositionFrequency  Superposition Frequency
            SuperpositionAmplitude  Superposition Amplitude

            BimodalCtrlMode         Mode for bimodal control
            BimodalCtrlSensor       Sensor for bimodal control
            BimodalValue1           Value1 to keep constant
            BimodalValue2           Value2 only used for DYN_BIMODAL_AMPLITUDE_OFFSET_VAR
            BimodalScale            Scale

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEOffsCSync ( DoPE_HANDLE DoPEHdl,
                                            double      Speed,
                                            double      PosDiff,
                                            WORD       *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOffsC ( DoPE_HANDLE DoPEHdl,
                                        double      Speed,
                                        double      PosDiff,
                                        WORD       *lpusTAN );

    /*
    Special moving command to measure the offset of an external, analogue
    speed controller. This offset will be used for the speed output signal
    and compensates the offset of the external speed controller.

      In :  DoPEHdl       DoPE link handle
            Speed         Speed
            PosDiff       Distance to move crosshead

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESpeedLimitSync ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short Ctrl,
                                                 double         Speed );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESpeedLimit ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short Ctrl,
                                             double         Speed,
                                             WORD          *lpusTAN );

    /*
    Set speed limit.

      In :  DoPEHdl       DoPE link handle
            Ctrl          Control mode
            Speed         Maximum speed

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEDefaultAccSync ( DoPE_HANDLE     DoPEHdl,
                                                 unsigned short  MoveCtrl,
                                                 double          Acc );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDefaultAcc ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short MoveCtrl,
                                             double         Acc,
                                             WORD          *lpusTAN );

    /*
    Set default acceleration (and deceleration) for all moving commands.
    After initialization default and nominal acceleration are identical.


      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Acc           Acceleration

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEEmergencyMoveSync ( DoPE_HANDLE     DoPEHdl,
                                                    unsigned short  State );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEEmergencyMove ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short State,
                                                WORD          *lpusTAN );

    /*
    Activate / deactivate emergency movement.
    Emergency movement is used to move crosshead if the hardware limit
    switch is active. (Not supported on EDC5/25)


      In :  DoPEHdl       DoPE link handle
            State         !=0  on
                          0    off

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEEmergencyOffSync  ( DoPE_HANDLE     DoPEHdl,
                                                    unsigned short  Status );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEEmergencyOff  ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short Status,
                                                WORD          *lpusTAN );

    /*
    Activate / deactivate EmergencyOff state.

      In :  DoPEHdl       DoPE link handle
            Status        !=0  Activate emergency off
                          0    Deactivate emergency off

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/
/* Obsolete Movement Commands                                               */
/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosG1Sync    ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosG1    ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.


      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Speed         Speed for positioning
            Limit         absolute limit position
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosG1_ASync  ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Acc,
                                               double         Speed,
                                               double         DecLimit,
                                               double         Limit,
                                               double         DecDest,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosG1_A  ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Acc,
                                           double         Speed,
                                           double         DecLimit,
                                           double         Limit,
                                           double         DecDest,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Acc           Acceleration
            Speed         Speed for positioning
            DecLimit      Deceleration for limit position
            Limit         absolute limit position
            DecDest       Deceleration for final destination
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosD1Sync    ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosD1    ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.


      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Speed         Speed for positioning
            Limit         relative limit position (e.g current position + 10)
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosD1_ASync  ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Acc,
                                               double         Speed,
                                               double         DecLimit,
                                               double         Limit,
                                               double         DecDest,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosD1_A  ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Acc,
                                           double         Speed,
                                           double         DecLimit,
                                           double         Limit,
                                           double         DecDest,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Acc           Acceleration
            Speed         Speed for positioning
            DecLimit      Deceleration for limit position
            Limit         relative limit position (e.g. current position + 10)
            DecDest       Deceleration for final destination
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:           Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosG2Sync    ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosG2    ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.


      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Speed         Speed for positioning
            Limit         absolute limit position
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosG2_ASync  ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Acc,
                                               double         Speed,
                                               double         DecLimit,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         DecDest,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosG2_A  ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Acc,
                                           double         Speed,
                                           double         DecLimit,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         DecDest,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Acc           Acceleration
            Speed         Speed for positioning
            DecLimit      Deceleration for limit position
            Limit         absolute limit position
            DecDest       Deceleration for final destination
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosD2Sync    ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Speed,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosD2    ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Speed,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.


      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Speed         Speed for positioning
            Limit         relative limit position (e.g current position + 10)
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosD2_ASync  ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               double         Acc,
                                               double         Speed,
                                               double         DecLimit,
                                               double         Limit,
                                               unsigned short DestCtrl,
                                               double         DecDest,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosD2_A  ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           double         Acc,
                                           double         Speed,
                                           double         DecLimit,
                                           double         Limit,
                                           unsigned short DestCtrl,
                                           double         DecDest,
                                           double         Destination,
                                           WORD          *lpusTAN );

    /*
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for positioning
            Acc           Acceleration
            Speed         Speed for positioning
            DecLimit      Deceleration for limit position
            Limit         relative limit position (e.g current position + 10)
            DecDest       Deceleration for final destination
            DestCtrl      Channel definition for destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)

    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECosineSync  ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short MoveCtrl,
                                              double         Speed1,
                                              double         Dest1,
                                              double         Dest2,
                                              double         Frequency,
                                              unsigned long  HalfCycles,
                                              double         Speed,
                                              double         Destination,
                                              WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECosine  ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short MoveCtrl,
                                          double         Speed1,
                                          double         Dest1,
                                          double         Dest2,
                                          double         Frequency,
                                          unsigned long  HalfCycles,
                                          double         Speed,
                                          double         Destination,
                                          WORD          *lpusTAN );

    /*
    Cosine movement.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Speed1        Speed to reach destination 1
            Dest1         Destination 1
            Dest2         Destination 2
            Frequency     Frequency
            HalfCycles    Number of half cycles
            Speed         Speed to final destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECosineXSync ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short MoveCtrl,
                                              double         Speed1,
                                              double         Dest1,
                                              double         Halt1,
                                              double         Dest2,
                                              double         Halt2,
                                              double         Frequency,
                                              unsigned long  HalfCycles,
                                              double         Speed,
                                              double         Destination,
                                              WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECosineX ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short MoveCtrl,
                                          double         Speed1,
                                          double         Dest1,
                                          double         Halt1,
                                          double         Dest2,
                                          double         Halt2,
                                          double         Frequency,
                                          unsigned long  HalfCycles,
                                          double         Speed,
                                          double         Destination,
                                          WORD          *lpusTAN );
    /*
    Cosine movement with halt time at Destination 1 and 2

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            Speed1        Speed to reach destination 1
            Dest1         Destination 1
            Halt1         Halt time at destination 1
            Dest2         Destination 2
            Halt2         Halt time at destination 2
            Frequency     Frequency
            HalfCycles    Number of half cycles
            Speed         Speed to final destination
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  /* ------ Constants  for 'Mode' ------------------------------------------- */

  #define  COS_PCT_AUTO1     0        /* Pilot control with Start offset      */
  #define  COS_PCT_AUTO2     1        /* Pilot control without Start offset   */
  #define  COS_PCT_MANUAL    2        /* Manual pilot control                 */
  #define  COS_PCT_KEEP      3        /* Stop pilot control, keep values      */
  #define  COS_PCT_CONTINUE  4        /* Continue pilot control, use values   */
  #define  COS_PCT_RESET     5        /* Reset pilot control, zero values     */


  extern  unsigned  DLLAPI  DoPECosinePeakCtrlSync ( DoPE_HANDLE     DoPEHdl,
                                                     unsigned short  Mode,
                                                     double          Dest1,
                                                     double          Dest2,
                                                     unsigned short  Cycles );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECosinePeakCtrl ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short Mode,
                                                 double         Dest1,
                                                 double         Dest2,
                                                 unsigned short Cycles,
                                                 WORD          *lpusTAN );

    /*
    Activate pilot control for Cosine Command

      In :  DoPEHdl       DoPE link handle
            Mode          Mode for pilot control (see definition of constants)
            Dest1         Destination 1
            Dest2         Destination 2
            Cycles        pilot control is active every xx Cycles (0,1,2,4,8,16)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
