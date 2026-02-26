/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Input/Output handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEio_INCLUDED
#define DoPEio_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetBSync ( DoPE_HANDLE     DoPEHdl,
                                           unsigned short  BitOutputNo,
                                           unsigned short  SetB,
                                           unsigned short  ResB,
                                           unsigned short  FlashB );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetB ( DoPE_HANDLE     DoPEHdl,
                                       unsigned short  BitOutputNo,
                                       unsigned short  SetB,
                                       unsigned short  ResB,
                                       unsigned short  FlashB,
                                       WORD           *lpusTAN );

    /*
    Set, Reset, Flash Bits
      In :  DoPEHdl       DoPE link handle
            BitOutputNo   Number of bit output device
            SetB          These bits will be set
            ResB          These bits will be reset
            FlashB        These bits 'flash'

            The three data WORD's will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing bits.          (lowest)
            2.) Resetting of the bits.
            3.) Setting of the bits.    (highest)


      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEUniOutSync ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short Output );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEUniOut ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short Output,
                                         WORD          *lpusTAN );

    /*
    Activate/Deactivate universal digital output bits.

      In :  DoPEHdl       DoPE link handle
            Output        Represents the digital outputs.

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECalOutSync ( DoPE_HANDLE    DoPEHdl,
                                             unsigned short Cal );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPECalOut ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short Cal,
                                         WORD          *lpusTAN );
    /*
      In :  DoPEHdl       DoPE  link handle
            Cal           !=0  activate Calibration output
                          0    deactivate Calibration output

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEBypassSync ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short Bypass );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEBypass ( DoPE_HANDLE    DoPEHdl,
                                         unsigned short Bypass,
                                         WORD          *lpusTAN );

    /*
    Activate/Deactivate bypass output.

      In :  DoPEHdl       DoPE  link handle
            Bypass        !=0   activates bypass output
                          0     deactivates bypass output

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEBeepSync ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short Beep );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEBeep ( DoPE_HANDLE    DoPEHdl,
                                       unsigned short Beep,
                                       WORD          *lpusTAN );

    /*
      In :  DoPEHdl       DoPE  link handle
            Beep          !=0   activate Beep
                          0     deactivate Beep

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Accessing uninitialized IOs by it's connector                              */
/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERdBitInput ( DoPE_HANDLE DoPEHdl,
                                             WORD        Connector,
                                             WORD       *Value );
    /*
    Read an digital input device.

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of IO device (CON_X2,...)
            *Value      Pointer for bits read

      Returns:          Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrBitOutputSync( DoPE_HANDLE DoPEHdl,
                                                 WORD        Connector,
                                                 WORD        Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrBitOutput( DoPE_HANDLE DoPEHdl,
                                             WORD        Connector,
                                             WORD        Value,
                                             WORD       *lpusTAN );
    /*
    Write an digital output device.

      In :  DoPEHdl       DoPE link handle
            Connector     Connector number of IO device (CON_X2,...)
            Value         Bits to write

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*---------------------------------------------------------------------------*/

                                       /* Constants for Mode                   */
                                       /* ------------------                   */
  #define  DO_NOTHING        0         /* Don't modify this output             */
  #define  USE_INIT_VALUE    1         /* Use Setup Initial value after offline*/
  #define  USE_VALUE         2         /* Use defined value after offline      */


  extern  unsigned  DLLAPI  DoPEOfflineActionBitOutputSync ( DoPE_HANDLE DoPEHdl,
                                                             WORD        BitOutputNo,
                                                             WORD        Mode,
                                                             WORD        Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEOfflineActionBitOutput ( DoPE_HANDLE DoPEHdl,
                                                         WORD        BitOutputNo,
                                                         WORD        Mode,
                                                         WORD        Value,
                                                         WORD       *lpusTAN );

    /*
    Set the offline action for an initialized digital output device.
    With the Mode parameter the offline acction can be controlled:
     DO_NOTHING       Don't modify this digital output
     USE_INIT_VALUE   Use Initial value after offline
     USE_VALUE        Use defined value after offline

      In :  DoPEHdl       DoPE link handle
            BitOutputNo   Number of bit output device
            Mode          Mode flag (see above)
            Value         Output value used in USE_VALUE mode

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
