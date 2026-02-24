/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface IO signals handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEiosignal_INCLUDED
#define DoPEiosignal_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif


/* -------------------------------------------------------------------------- */
/* Grip IO handling                                                           */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEIOGripEnableSync( DoPE_HANDLE  DoPEHdl,
                                                  unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOGripEnable( DoPE_HANDLE     DoPEHdl,
                                              unsigned        Enable,
                                              unsigned short *lpusTAN );

    /*
    Enable or disable grip IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables grip IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  #define IO_GRIP_UPPER                 0x0001
  #define IO_GRIP_LOWER                 0x0002
  #define IO_GRIP_BOTH                  0x0003

  #define IO_GRIP_ACTION_OPEN           0x0001
  #define IO_GRIP_ACTION_CLOSE          0x0002
  #define IO_GRIP_ACTION_HIGH_PRESSURE1 0x0004
  #define IO_GRIP_ACTION_HIGH_PRESSURE2 0x0008

  extern  unsigned  DLLAPI  DoPEIOGripSetSync( DoPE_HANDLE  DoPEHdl,
                                               unsigned     Grip,
                                               unsigned     Action,
                                               double       Pressure );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOGripSet( DoPE_HANDLE     DoPEHdl,
                                           unsigned        Grip,
                                           unsigned        Action,
                                           double          Pressure,
                                           unsigned short *lpusTAN );

    /*
    Perform a grip action.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Grip       Grip to use
                        (use IO_GRIP_ defines)
             Action     Action to perform
                        (use IO_GRIP_ACTION_ defines)
             Pressure   Pressure to be applied [%]

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEIOGripPressureSync( DoPE_HANDLE  DoPEHdl,
                                                    double       LowPressure,
                                                    double       HighPressure,
                                                    double       RampTime );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOGripPressure( DoPE_HANDLE     DoPEHdl,
                                                double          LowPressure,
                                                double          HighPressure,
                                                double          RampTime,
                                                unsigned short *lpusTAN );

    /*
    Set grip parameter.


      In :  *DoPEHdl      Pointer to DoPE link handle
             LowPressure  Low pressure value [%]
             HighPressure Low pressure value [%]
             RampTime     Time to switch between low and high pressure  [s]

      Out :
            *lpusTAN      Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Extensometer IO handling                                                   */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEIOExtEnableSync( DoPE_HANDLE  DoPEHdl,
                                                 unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI DoPEIOExtEnable( DoPE_HANDLE     DoPEHdl,
                                            unsigned        Enable,
                                            unsigned short *lpusTAN );

    /*
    Enable or disable extensometer IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables extensometer IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  #define IO_EXT_UPPER          0x0001
  #define IO_EXT_LOWER          0x0002
  #define IO_EXT_BOTH           0x0003

  #define IO_EXT_ACTION_OPEN    0x0001
  #define IO_EXT_ACTION_CLOSE   0x0002

  extern  unsigned  DLLAPI  DoPEIOExtSetSync( DoPE_HANDLE  DoPEHdl,
                                              unsigned     Ext,
                                              unsigned     Action );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOExtSet( DoPE_HANDLE     DoPEHdl,
                                          unsigned        Ext,
                                          unsigned        Action,
                                          unsigned short *lpusTAN );

    /*
    Perform a extensometer action.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Grip       Grip to use
                        (use IO_EXT_ defines)
             Action     Action to perform
                        (use IO_EXT_ACTION_ defines)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Fixed Corsshead IO handling                                                */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEIOFixedXHeadEnableSync( DoPE_HANDLE  DoPEHdl,
                                                        unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOFixedXHeadEnable( DoPE_HANDLE     DoPEHdl,
                                                    unsigned        Enable,
                                                    unsigned short *lpusTAN );

    /*
    Enable or disable fixed cross head IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables fixed cross head IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEIOFixedXHeadSetSync( DoPE_HANDLE  DoPEHdl,
                                                     unsigned     Direction );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOFixedXHeadSet( DoPE_HANDLE     DoPEHdl,
                                                 unsigned        Direction,
                                                 unsigned short *lpusTAN );

    /*
    Move fixed cross head.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Direction  Direction of movement
                        (use MOVE_HALT, MOVE_UP, MOVE_DOWN defines)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* High Pressure IO handling                                                  */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEIOHighPressureEnableSync( DoPE_HANDLE  DoPEHdl,
                                                          unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOHighPressureEnable( DoPE_HANDLE     DoPEHdl,
                                                      unsigned        Enable,
                                                      unsigned short *lpusTAN );

    /*
    Enable or disable high pressure IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables high pressure IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEIOHighPressureSetSync( DoPE_HANDLE  DoPEHdl,
                                                       unsigned     HighPressure );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEIOHighPressureSet( DoPE_HANDLE     DoPEHdl,
                                                   unsigned        HighPressure,
                                                   unsigned short *lpusTAN );

    /*
    Set high or low pressure.


      In :  *DoPEHdl      Pointer to DoPE link handle
             HighPressure !=0  selects high pressure
                          0    selects low pressure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
