/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface tare and reference signal commands

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEtare_INCLUDED
#define DoPEtare_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetBasicTareSync ( DoPE_HANDLE    DoPEHdl,
                                                   unsigned short SensorNo,
                                                   unsigned short Mode,
                                                   double         BasicTare );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetBasicTare ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short SensorNo,
                                               unsigned short Mode,
                                               double         BasicTare,
                                               WORD          *lpusTANFirst,
                                               WORD          *lpusTANLast );

    /*
    Set basic tare of the measuring channel

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          BASICTARE_SET:
                            BasicTare represents the desired measuring value.
                            This is useful to set crosshead position for systems
                            with encoder.
                          BASICTARE_SUBTRACT
                            BasicTare will be subtracted.
                            This is usefull to compensate the weight of grips.
            BasicTare     Value for BasicTare

      BasicTare value will be stored in EDC's non volatile memory.
      This function clears the ordinary tare value.

      Out:
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  #define  BASICTARE_SET        0
  #define  BASICTARE_SUBTRACT   1

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEGetBasicTare ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short SensorNo,
                                               double        *BasicTare);

    /*
    Read tare value of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *BasicTare  Pointer for BasicTare

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetTare ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short SensorNo,
                                          double         Tare );

    /*
    Set tare of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            Tare        Value to be subtracted.


      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEGetTare ( DoPE_HANDLE     DoPEHdl,
                                           unsigned short SensorNo,
                                           double        *Tare);

    /*
    Read tare value of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *Tare       Pointer for tare

      Returns:          Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetRefSignalMode ( DoPE_HANDLE    DoPEHdl,
                                                   unsigned short SensorNo,
                                                   unsigned short Mode,
                                                   WORD          *lpusTAN );

    /*
    Set the reference signal mode.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          reference signal messages will be reported:
                          REFSIG_NON:  never
                          REFSIG_ON:   allways
                          REFSIG_ONCE: only once

      Out : *lpusTAN      Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  #define  REFSIG_NON           0
  #define  REFSIG_ON            1
  #define  REFSIG_ONCE          2


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetRefSignalTare ( DoPE_HANDLE    DoPEHdl,
                                                   unsigned short SensorNo,
                                                   unsigned short Mode,
                                                   double         Tare,
                                                   WORD          *lpusTAN );

    /*
    Set the measuring channel to the tare value at the next occurance of the
    reference signal.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          Action at the next reference signal:
                          REFSIG_TARE: set the measuring channel to the tare value
                          REFSIG_NON:  don't affect the measuring channel
            Tare          Value for the measuring channel

      Tare value will be stored in EDC's non volatile BasicTare memory.
      This function clears the current basic tare and ordinary tare value
      at the next occurance of the reference signal.

      Out : *lpusTAN      Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  #define  REFSIG_TARE          1


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
