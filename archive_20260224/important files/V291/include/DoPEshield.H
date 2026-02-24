/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Shield handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEshield_INCLUDED
#define DoPEshieldk_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEShieldLimitSync ( DoPE_HANDLE    DoPEHdl,
                                                  unsigned short SensorNo,
                                                  double         UprLock,
                                                  double         UprUnLock,
                                                  double         LwrUnLock,
                                                  double         LwrLock,
                                                  unsigned short CtrlLimit,
                                                  double         SpeedLimit,
                                                  unsigned short CtrlAction,
                                                  unsigned short Action,
                                                  WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEShieldLimit ( DoPE_HANDLE    DoPEHdl,
                                              unsigned short SensorNo,
                                              double         UprLock,
                                              double         UprUnLock,
                                              double         LwrUnLock,
                                              double         LwrLock,
                                              unsigned short CtrlLimit,
                                              double         SpeedLimit,
                                              unsigned short CtrlAction,
                                              unsigned short Action,
                                              WORD          *lpusTAN );

    /*
    Activate the shield supervision

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEShieldEnableSync ( DoPE_HANDLE    DoPEHdl,
                                                   unsigned       Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEShieldEnable ( DoPE_HANDLE DoPEHdl,
                                               unsigned    Enable,
                                               WORD       *lpusTAN );

    /*
    Activate / deactivate the shield supervision

      In :  DoPEHdl       DoPE link handle
            Enable        !=0  enables
                          0    disables shield supervision

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEShieldLockSync ( DoPE_HANDLE DoPEHdl,
                                                 WORD        State );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEShieldLock ( DoPE_HANDLE DoPEHdl,
                                             WORD        State,
                                             WORD       *lpusTAN );
    /*
    Lock or unlock the shield

      In :  DoPEHdl       DoPE link handle
            State         !=0  lock
                          0    unlock

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/
/* Obsolete. Use DoPEShieldEnable(Sync) instead.
/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEShieldDisableSync ( DoPE_HANDLE    DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEShieldDisable ( DoPE_HANDLE DoPEHdl,
                                                WORD       *lpusTAN );

    /*
    Deactivate the shield supervision

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
