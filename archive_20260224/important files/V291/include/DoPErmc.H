/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC remot control default handling
  

Changes :
=========
  HEG, 12.5.11
  - wrote it.
*******************************************************************************/


#ifndef DoPE_RMC_INCLUDED
#define DoPE_RMC_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

  typedef  struct                     /* 'RMC Event'                          */
  {                                   /* ------------------------------------ */
    unsigned __int64   Keys;          /* Current key state                [No]*/
    unsigned __int64   NewKeys;       /* New keys                         [No]*/
    unsigned __int64   GoneKeys;      /* Gone keys                        [No]*/
    unsigned __int64   Leds;          /* Current LED state                [No]*/
    unsigned __int64   NewLeds;       /* New LEDs                         [No]*/
    unsigned __int64   GoneLeds;      /* Gone LEDs                        [No]*/
  } DoPEOnRmcEvent;

  typedef  unsigned (CALLBACK *DoPEOnRmcEventHdlr)(DoPE_HANDLE, DoPEOnRmcEvent*, LPVOID);
  /*
     Handler for RMC events
       DoPE_HANDLE           DoPE link handle
       DoPEOnRmcEvent        received RMC event
       LPVOID                userspecific pointer set with DoPESetOnRmcEventHdlr
     should return 0 (reserved for future versions)
  */

  typedef  unsigned (CALLBACK *DoPEOnRmcEventRtHdlr)(DoPE_HANDLE, DoPEOnRmcEvent*, LPVOID);
  /*
     Realtime handler for RMC events
       DoPE_HANDLE           DoPE link handle
       DoPEOnRmcEvent        received RMC event
       LPVOID                userspecific pointer set with DoPESetOnRmcEventRtHdlr
     should return 0 (reserved for future versions)
  */

/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnRmcEventHdlr ( DoPE_HANDLE         DoPEHdl,
                                                    DoPEOnRmcEventHdlr  Hdlr,
                                                    LPVOID              lpParameter );

    /*
    Set the OnRmcEvent handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        RMC event

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnRmcEventRtHdlr ( DoPE_HANDLE           DoPEHdl,
                                                      DoPEOnRmcEventRtHdlr  Hdlr,
                                                      LPVOID                lpParameter );

    /*
    Set the realtime OnRmcEvent handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every RMC event

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERmcEnable ( DoPE_HANDLE      DoPEHdl,
                                            unsigned __int64 EnableKeys,
                                            unsigned __int64 EnableLeds );

    /*
    Enable / disable the remote control default handling for keys and LEDs.
    Sets the PushMode and RmcDPoti settings to the default values defined in
    the setup RMC definition.

      In :  DoPEHdl       DoPE link handle
            EnableKeys    mask of enabled RMC emulation keys
            EnableLeds    mask of enabled RMC emulation LEDs
  
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERmcReDefine ( DoPE_HANDLE      DoPEHdl,
                                              unsigned __int16 PushMode,
                                              DoPERmcDPoti     RmcDPoti[MAX_CTRL] );

    /*
    Redefine the PushMode and RmcDPoti settings for the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            PushMode      !=0  enables
                          0    disables the push mode for Up/Down keys
            RmcDPoti      RMC DPoti definition
  
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERmcKeys ( DoPE_HANDLE      DoPEHdl,
                                          unsigned __int64 SetKeys,
                                          unsigned __int64 ResKeys,
                                          unsigned __int64 ToggleKeys );

    /*
    Set / reset / toggle keys for the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            SetKeys       RMC emulation keys to set
            ResKeys       RMC emulation keys to clear
            ToggleKeys    RMC emulation keys to toggle

            The three key patterns will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing bits.          (lowest priority)
            2.) Resetting of the bits.
            3.) Setting of the bits.    (highest priority)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPERmcState ( DoPE_HANDLE     DoPEHdl,
                                           DoPEOnRmcEvent *RmcEvent );

    /*
    Get keys and LEDs state of the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            Keys          currently active keys
            NewKeys       keys pressed since last call of this function
            GoneKeys      keys released since last call of this function
            Leds          currently active LEDs
            NewLeds       LEDs activated since last call of this function
            GoneLeds      LEDs deactivated since last call of this function

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */


  #ifdef __cplusplus
  }       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
