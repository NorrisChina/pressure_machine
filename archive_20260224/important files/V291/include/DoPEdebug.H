/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Debug handling

Changes :
=========
  HEG 16.12.11
  - wrote it.

*******************************************************************************/

#ifndef DoPEdebug_INCLUDED
#define DoPEdebug_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

// -----------------------------------------------------------------------------

  extern  unsigned  DLLAPI  DoPESendDebugCommandSync  ( DoPE_HANDLE  DoPEHdl,
                                                        char        *Text );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

  extern  unsigned  DLLAPI  DoPESendDebugCommand  ( DoPE_HANDLE  DoPEHdl,
                                                    char        *Text,
                                                    WORD        *lpusTAN );


    /*
    Send a debug command to the EDC.
    
      In :  DoPEHdl       DoPE link handle
            Text          Pointer to zero terminated text to transmit
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


// -----------------------------------------------------------------------------

  extern  unsigned  DLLAPI  DoPEDebugMsgEnableSync  ( DoPE_HANDLE  DoPEHdl,
                                                      unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

  extern  unsigned  DLLAPI  DoPEDebugMsgEnable  ( DoPE_HANDLE  DoPEHdl,
                                                  unsigned     Enable,
                                                  WORD        *lpusTAN );


    /*
    Enable/disable debug messages from the EDC.
    
      In :  DoPEHdl       DoPE link handle
            Enable        !=0  enables 
                          0    disables debug messages
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
