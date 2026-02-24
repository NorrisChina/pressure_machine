/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Closed Loop Controller handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG 25.9.10 - V2.71
  - New DopE functions:
    - DoPERdPosPID, DoPEWrPosPID(Sync)           ( requires PE-Version 2.71 ! )
    - DoPERdSpeedPID, DoPEWrSpeedPID(Sync)       ( requires PE-Version 2.71 ! )
    - DoPERdFeedForward, DoPEWrFeedForward(Sync) ( requires PE-Version 2.71 ! )
    
  HEG, 26.3.14 - V2.79
  - New DopE functions:
    - DoPEDeadbandCtrl(Sync)
  - DoPECtrlParameter extended:
    - Deadband
    - PercentP

  HEG, 26.8.15 - V2.82
  - New DopE functions:
    - DoPESetNominalAccSpeed(Sync)
*******************************************************************************/


#ifndef DoPEctrl_INCLUDED
#define DoPEctrl_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* ------ Constants  for Reaction in DoPECtrlError and DoPESft -------------- */

  #define  REACT_STATUS      0        /* only status bits are set             */
  #define  REACT_ACTION      1        /* React according to pre defined action*/


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosPIDSync ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short MoveCtrl,
                                             unsigned long  PosP,
                                             unsigned short PosI,
                                             unsigned short PosD );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosPID ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short MoveCtrl,
                                         unsigned long  PosP,
                                         unsigned short PosI,
                                         unsigned short PosD,
                                         WORD          *lpusTAN );

    /*
    Set parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdPosPID ( DoPE_HANDLE     DoPEHdl,
                                           unsigned short  MoveCtrl,
                                           unsigned        HighPressure,
                                           unsigned long  *PosP,
                                           unsigned short *PosI,
                                           unsigned short *PosD );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Get parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            PosP          Pointer for gain      (kv-Factor)
            PosI          Pointer for Integration time constant
            PosD          Pointer for Time constant

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrPosPIDSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               unsigned       HighPressure,
                                               unsigned long  PosP,
                                               unsigned short PosI,
                                               unsigned short PosD );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrPosPID ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           unsigned       HighPressure,
                                           unsigned long  PosP,
                                           unsigned short PosI,
                                           unsigned short PosD,
                                           WORD          *lpusTAN );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Set parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  set parameter for high pressure
                          0    set parameter for low pressure
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESpeedPIDSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short MoveCtrl,
                                               unsigned long  SpeedP,
                                               unsigned short SpeedI,
                                               unsigned short SpeedD );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESpeedPID ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short MoveCtrl,
                                           unsigned long  SpeedP,
                                           unsigned short SpeedI,
                                           unsigned short SpeedD,
                                           WORD          *lpusTAN );

    /*
    Set parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            SpeedP        gain      (kv-Factor)
            SpeedI        Integration time constant
            SpeedD        Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdSpeedPID ( DoPE_HANDLE     DoPEHdl,
                                             unsigned short  MoveCtrl,
                                             unsigned        HighPressure,
                                             unsigned long  *SpeedP,
                                             unsigned short *SpeedI,
                                             unsigned short *SpeedD );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Get parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedP        Pointer for gain      (kv-Factor)
            SpeedI        Pointer for Integration time constant
            SpeedD        Pointer for Time constant

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSpeedPIDSync ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short MoveCtrl,
                                                 unsigned       HighPressure,
                                                 unsigned long  SpeedP,
                                                 unsigned short SpeedI,
                                                 unsigned short SpeedD );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSpeedPID ( DoPE_HANDLE     DoPEHdl,
                                             unsigned short  MoveCtrl,
                                             unsigned        HighPressure,
                                             unsigned long   SpeedP,
                                             unsigned short  SpeedI,
                                             unsigned short  SpeedD,
                                             WORD           *lpusTAN );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Set parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  set parameter for high pressure
                          0    set parameter for low pressure
            SpeedP        gain      (kv-Factor)
            SpeedI        Integration time constant
            SpeedD        Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEFeedForwardSync ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short MoveCtrl,
                                                  unsigned short SpeedFFP,
                                                  unsigned short PosDelay,
                                                  unsigned short AccFFP,
                                                  unsigned short SpeedDelay );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEFeedForward ( DoPE_HANDLE     DoPEHdl,
                                              unsigned short  MoveCtrl,
                                              unsigned short  SpeedFFP,
                                              unsigned short  PosDelay,
                                              unsigned short  AccFFP,
                                              unsigned short  SpeedDelay,
                                              unsigned short *lpusTAN );

    /*
    Set feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            SpeedFFP      FeedForward for Speed in %
            PosDelay      Delay for Position command
            AccFFP        FeedForward for Acc in %
            SpeedDelay    Delay for Speed command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdFeedForward ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short  MoveCtrl,
                                                unsigned        HighPressure,
                                                unsigned short *SpeedFFP,
                                                unsigned short *PosDelay,
                                                unsigned short *AccFFP,
                                                unsigned short *SpeedDelay );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Get feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedFFP      Pointer for FeedForward for Speed in %
            PosDelay      Pointer for Delay for Position command
            AccFFP        Pointer for FeedForward for Acc in %
            SpeedDelay    Pointer for Delay for Speed command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrFeedForwardSync ( DoPE_HANDLE    DoPEHdl,
                                                    unsigned short MoveCtrl,
                                                    unsigned       HighPressure,
                                                    unsigned short SpeedFFP,
                                                    unsigned short PosDelay,
                                                    unsigned short AccFFP,
                                                    unsigned short SpeedDelay );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrFeedForward ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short  MoveCtrl,
                                                unsigned        HighPressure,
                                                unsigned short  SpeedFFP,
                                                unsigned short  PosDelay,
                                                unsigned short  AccFFP,
                                                unsigned short  SpeedDelay,
                                                unsigned short *lpusTAN );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!

    Set feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            HighPressure  !=0  set parameter for high pressure
                          0    set parameter for low pressure
            SpeedFFP      FeedForward for Speed in %
            PosDelay      Delay for Position command
            AccFFP        FeedForward for Acc in %
            SpeedDelay    Delay for Speed command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  typedef struct                      /* Controller parameter                 */
  {                                   /* ------------------------------------ */
    unsigned long  PosP;              /* Pos.  contr. P: gain             [No]*/
    unsigned short PosI;              /* Pos.  contr. I: time constant    [No]*/
    unsigned short PosD;              /* Pos.  contr. D: time constant    [No]*/
    unsigned long  PosFFP;            /* Pos.  Feed Forward P             [No]*/
    unsigned long  SpeedP;            /* Speed contr. P: gain             [No]*/
    unsigned short SpeedI;            /* Speed contr. I: time constant    [No]*/
    unsigned short SpeedD;            /* Speed contr. D: time constant    [No]*/
    unsigned short SpeedFFP;          /* Speed feed forward               [No]*/
    unsigned short PosDelay;          /* Delay for Command                [No]*/
    unsigned short AccFFP;            /* Acceleration contr. P: gain      [No]*/
    unsigned short SpeedDelay;        /* Delay for SpeedCommand           [No]*/

    double         Acceleration;      /* default acceleration        [Unit/s²]*/
    double         Speed;             /* speed limit                  [Unit/s]*/
    double         Deviation;         /* Max. deviation of controller   [Unit]*/
    unsigned short DevReaction;       /* Reaction if deviation exceeded   [No]*/

    double         DestinationWnd;    /* Size of 1/2 destination window [Unit]*/
    double         DestinationTime;   /* Time until controlled channel     [s]*/
                                      /* must reach destination window        */
    double         UpperSoftEnd;      /* Upper softend                  [Unit]*/
    double         LowerSoftEnd;      /* Lower softend                  [Unit]*/
    unsigned short SoftEndReaktion;   /* Reaction if softend is reached   [No]*/

                                      /* numerical limitations for            */
                                      /* acceleration and speed parameters    */
    double         MinAcceleration;   /* minimum acceleration        [Unit/s²]*/
    double         MaxAcceleration;   /* maximum acceleration        [Unit/s²]*/
    double         MinDeceleration;   /* minimum deceleration        [Unit/s²]*/
    double         MaxDeceleration;   /* maximum deceleration        [Unit/s²]*/
    double         MinSpeed;          /* minimum speed                [Unit/s]*/
    double         MaxSpeed;          /* maximum speed                [Unit/s]*/

                                      /* error deadband controller parameter  */
    double          Deadband;         /* Error deadband around setpoint [Unit]*/
    unsigned short  PercentP;         /* Smallest P inside deadband[% of PosP]*/
  } DoPECtrlParameter;

  extern  unsigned  DLLAPI  DoPERdCtrlParameter ( DoPE_HANDLE        DoPEHdl,
                                                  unsigned short     MoveCtrl,
                                                  DoPECtrlParameter *CtrlParameter );

    /*
    Read closed loop controller parameter

      In :  DoPEHdl        DoPE link handle
            MoveCtrl       Control mode
            *CtrlParameter Pointer for DoPECtrlParameter structure

      Returns:             Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define OPTIMIZE_COSINE    0
  #define OPTIMIZE_TRIANGLE  1
  #define OPTIMIZE_RECTANGLE 2

  extern  unsigned  DLLAPI  DoPEOptimizeFeedForwardSync ( DoPE_HANDLE    DoPEHdl,
                                                          unsigned short MoveCtrl,
                                                          unsigned short Mode,
                                                          double         Offset,
                                                          double         Amplitude,
                                                          double         Frequency,
                                                          WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOptimizeFeedForward ( DoPE_HANDLE    DoPEHdl,
                                                      unsigned short MoveCtrl,
                                                      unsigned short Mode,
                                                      double         Offset,
                                                      double         Amplitude,
                                                      double         Frequency,
                                                      WORD          *lpusTAN );

    /*
    Optimize feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Mode          Cosine, triangle, rectangle (see OPTIMIZE_ defines)
            Amplitude     Amplitude
            Frequency     Frequency

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEDestWndSync ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short MoveCtrl,
                                              double         WndSize,
                                              double         WndTime );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDestWnd ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short MoveCtrl,
                                          double         WndSize,
                                          double         WndTime,
                                          WORD          *lpusTAN );

    /*
    Definitions for destination window.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            WndSize       Size of destination window
            WndTime       Time for destination window

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESftSync ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short MoveCtrl,
                                          double         UpperSft,
                                          double         LowerSft,
                                          unsigned short Reaction );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESft ( DoPE_HANDLE    DoPEHdl,
                                      unsigned short MoveCtrl,
                                      double         UpperSft,
                                      double         LowerSft,
                                      unsigned short Reaction,
                                      WORD          *lpusTAN );

    /*
    Definitions of limits supervised by software (softend)

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            UpperSft      Upper soft limit
            LowerSft      Lower soft limit
            Reaction      Action to be activated after softend is reached

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECtrlErrorSync ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short MoveCtrl,
                                                double         Error,
                                                unsigned short Reaction );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECtrlError ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short MoveCtrl,
                                            double         Error,
                                            unsigned short Reaction,
                                            WORD          *lpusTAN );

    /*
    Define maximum error signal for closed loop controller

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Error         Maximum error signal
            Reaction      Action to be activated after error is reached

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECtrlSpeedTimeBaseSync ( DoPE_HANDLE DoPEHdl,
                                                        double      Time );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECtrlSpeedTimeBase ( DoPE_HANDLE DoPEHdl,
                                                    double      Time,
                                                    WORD       *lpusTAN );

    /*
    Define Time Base for Speeddetection inside Close Loop Controller

      In :  DoPEHdl       DoPE link handle
            Time          Timebase in s

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEDeadbandCtrlSync ( DoPE_HANDLE    DoPEHdl,
                                                   unsigned short MoveCtrl,
                                                   double         Deadband,
                                                   unsigned short PercentP );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDeadbandCtrl ( DoPE_HANDLE     DoPEHdl,
                                               unsigned short  MoveCtrl,
                                               double          Deadband,
                                               unsigned short  PercentP,
                                               unsigned short *lpusTAN );

    /*
    FUNCTION REQUIRES PE-Interface Version 2.79 (or higher)  !!

    Set parameter for error deadband controller.
    PosP is reduced by a ramp from PosP(100%) to PercentP.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Deadband      Width of error deadband around setpoint 
            PercentP      Smallest P inside deadband in % of PosP
                          PercentP range is 0..100% 
                          (100% disables error deadband controller)
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetNominalAccSpeedSync ( DoPE_HANDLE    DoPEHdl,
                                                         unsigned short MoveCtrl,
                                                         double         Acc, 
                                                         double         Speed );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetNominalAccSpeed ( DoPE_HANDLE    DoPEHdl,
                                                     unsigned short MoveCtrl,
                                                     double         Acc, 
                                                     double         Speed,
                                                     WORD          *lpusTAN );

    /*
    Set nominal values for position generator

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Acc           default acceleration
            Speed         speed limit

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/
/* Obsolete Closed Loop Controller Commands                                 */
/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPosFeedForwardSync ( DoPE_HANDLE    DoPEHdl,
                                                     unsigned short MoveCtrl,
                                                     unsigned long  PosFFP );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPosFeedForward ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short MoveCtrl,
                                                 unsigned long  PosFFP,
                                                 WORD          *lpusTAN );

    /*
    Set parameter for Positiongenerator derivate part.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            PosFFP        gain for derivate part

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
