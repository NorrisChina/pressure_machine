/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface setup and combined movement command handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEcombined_INCLUDED
#define DoPEcombined_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* ------ Constants  for 'ModeFlags' in  DoPEStartCMD ----------------------- */

  #define  CMD_DWND    0x01         /* supervise destination window           */
  #define  CMD_MESSAGE 0x02         /* report intermediate destinations       */


/* ------ Constants  for 'Operation' in  DoPEEndCMD ------------------------- */

  #define  CMD_DISCARD       0        /* Reject movement sequence             */
  #define  CMD_START         1        /* Start movement sequence              */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEStartCMDSync ( DoPE_HANDLE     DoPEHdl,
                                               unsigned long   Cycles,
                                               unsigned short  ModeFlags );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEStartCMD ( DoPE_HANDLE    DoPEHdl,
                                           unsigned long  Cycles,
                                           unsigned short ModeFlags,
                                           WORD          *lpusTAN );

    /*
    Start of a combined movement command. Up to 10 simple moving commands
    may be sent after this command to specify a complex moving sequence.

      In :  DoPEHdl       DoPE link handle
            Cycles        Repeat combined moving command this number of cycles
            ModeFlags     Flags (see definition)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEEndCMDSync   ( DoPE_HANDLE     DoPEHdl,
                                               unsigned short  Operation );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEEndCMD   ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short Operation,
                                           WORD          *lpusTAN );

    /*
    End of combined moving command. With this command the first moving
    command inside this sequence will be started.

      In :  DoPEHdl       DoPE link handle
            Operation     Start or discard the sequence

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
