/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Output Channel handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEoutput_INCLUDED
#define DoPEoutput_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetOutputSync ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short  Output,
                                                double          Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetOutput ( DoPE_HANDLE     DoPEHdl,
                                            unsigned short  Output,
                                            double          Value,
                                            WORD           *lpusTAN );

    /*
    Set an analogue output channel.

      In :  DoPEHdl       DoPE link handle
                          Output      Number of analogue output channel
                          Value       New value of output channel in % of max. value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetDitherSync ( DoPE_HANDLE     DoPEHdl,
                                                unsigned short  Output,
                                                double          Frequency,
                                                double          Amplitude );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetDither ( DoPE_HANDLE     DoPEHdl,
                                            unsigned short  Output,
                                            double          Frequency,
                                            double          Amplitude,
                                            WORD           *lpusTAN );

    /*
    FUNCTION  NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Set an analogue output channel dither.

      In :  DoPEHdl       DoPE link handle
            Output        Number of analogue output channel
            Frequency     Dither frequency
            Amplitude     Dither aplitude

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetOutChannelOffsetSync ( DoPE_HANDLE     DoPEHdl,
                                                          unsigned short  Output,
                                                          double          Offset );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetOutChannelOffset ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  Output,
                                                      double          Offset,
                                                      WORD           *lpusTAN );
    /*
    Set an analogue output channel offset.

      In :  DoPEHdl       DoPE link handle
                          Output      Number of analogue output channel
                          Offset      New offset value of output channel
                                      in % of max. value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEOfflineActionOutputSync ( DoPE_HANDLE DoPEHdl,
                                                          WORD        OutputNo,
                                                          WORD        Mode,
                                                          double      Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOfflineActionOutput ( DoPE_HANDLE DoPEHdl,
                                                      WORD        OutputNo,
                                                      WORD        Mode,
                                                      double      Value,
                                                      WORD       *lpusTAN );

    /*
    Set the offline action for an initialized analog output channel.
    With the Mode parameter the offline acction can be controlled:
     DO_NOTHING       Don't modify the analog output channel
     USE_INIT_VALUE   Use Initial value after offline
     USE_VALUE        Use defined value after offline

      In :  DoPEHdl       DoPE link handle
            BitOutputNo   Number of analogue output channel
            Mode          Mode flag (see above)
            Value         Output value used in USE_VALUE mode in % of max. value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetOpenLoopCommandSync ( DoPE_HANDLE DoPEHdl,
                                                         double      Command );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetOpenLoopCommand ( DoPE_HANDLE DoPEHdl,
                                                     double      Command,
                                                     WORD       *lpusTAN );

    /*
    Set output in open loop mode

      In :  DoPEHdl       DoPE link handle
            Command       Command value in % of nominal output value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define MC2OUT_MAX 3                 /* Number of Mc2Output definition points */

  #define MC2OUT_MODE_OFF       0      /* Mc2Output disabled                   */
  #define MC2OUT_MODE_2POINTS   1      /* Mc2Output definition by 2 points     */
  #define MC2OUT_MODE_3POINTS   2      /* Mc2Output definition by 3 points     */

  #define MC2OUT_PRIORITY_HIGH  0      /* Output all channels every 20 ms      */
  #define MC2OUT_PRIORITY_LOW   1      /* Output one of the channel every 20 ms*/
  #define MC2OUT_PRIORITY_BURST 2      /* Output every speed controller cycle  */


  extern  unsigned  DLLAPI  DoPEMc2OutputSync  ( DoPE_HANDLE DoPEHdl,
                                                 WORD        Mode,
                                                 WORD        Priority,
                                                 WORD        SensorNo,
                                                 WORD        Output,
                                                 double      SensorPoint[MC2OUT_MAX],
                                                 double      OutputPoint[MC2OUT_MAX] );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEMc2Output  ( DoPE_HANDLE DoPEHdl,
                                             WORD        Mode,
                                             WORD        Priority,
                                             WORD        SensorNo,
                                             WORD        Output,
                                             double      SensorPoint[MC2OUT_MAX],
                                             double      OutputPoint[MC2OUT_MAX],
                                             WORD        *lpusTAN );


    /*
    Output of a measured value to a analogue output channel.
    Any measured channel may be scaled and via a DAC converted to a analogue
    signal. Scale is defined by two or three points.

    With the Mode parameter the calculation of the output is controlled:
       MC2OUT_MODE_OFF       Output disabled
       MC2OUT_MODE_2POINTS   Output definition by 2 points
       MC2OUT_MODE_3POINTS   Output definition by 3 points

    With the Priority parameter the output method is controlled:
       MC2OUT_PRIORITY_HIGH  Output of this channel every 20 ms.
       MC2OUT_PRIORITY_LOW   Every 20 ms only one of the channels with this
                             priority is calculated and given output.
       MC2OUT_PRIORITY_BURST Output of this channel every speed controller cycle.



      In :  DoPEHdl             DoPE link handle
            Mode                MC2OUT_MODE_...     (see above)
            Priority            MC2OUT_PRIORITY_... (see above)
            SensorNo            Sensor Number SENSOR_S .. SENSOR_15
            Output              Number of analogue output channel
            SensorPoint         Scale point sensor values
            OutputPoint         Scale point output values

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPECurrentPIDSync ( DoPE_HANDLE    DoPEHdl,
                                                 unsigned short Output,
                                                 unsigned long  P,
                                                 unsigned short I,
                                                 unsigned short D );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECurrentPID ( DoPE_HANDLE     DoPEHdl,
                                             unsigned short  Output,
                                             unsigned long   P,
                                             unsigned short  I,
                                             unsigned short  D,
                                             unsigned short *lpusTAN );

    /*
    Set parameter for the external current closed loop controller.

      In :  DoPEHdl       DoPE link handle
            Output        Number of the output channel (COMMAND_OUT, OUT_1,...)
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
