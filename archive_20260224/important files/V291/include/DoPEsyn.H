/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC  synchronized datainterface for Windows
  

Changes :
=========
  HEG, 11.5.06
  - wrote it.

  HEG, 21.7.06
  - SYNCHRONIZE_MAX defined

  HEG, 3.2.10 - V2.67
  - Buffer utilization added to DoPEOnSynchronizeData structure
  - New DoPE functions:
    - DoPESetOnSynchronizeDataOverflowHdlr
    - DoPESetOnSynchronizeDataOverflowRtHdlr
*******************************************************************************/


#ifndef DoPE_SYN_INCLUDED
#define DoPE_SYN_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

  /* -------- Eventhandler definitions -------------------------------------- */

  typedef  struct                     /* Synchronized measuring data record   */
  {                                   /* ------------------------------------ */
    DoPE_HANDLE        DP;            /* DoPE link handle                     */
    DoPEData           Data;          /* Measuring data record                */
  } DoPELinkData;

  typedef  struct                     /* Synchronized measuring data matrix   */
  {                                   /* ------------------------------------ */
    unsigned           DoPError;      /* DoPE error code                  [No]*/
    unsigned           nData;         /* Number of measuring data records     */
    DoPELinkData      *Sample;        /* Array of measuring data records      */
    double             Occupied;      /* Utilization   [% of data buffer size]*/
  } DoPEOnSynchronizeData;

  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataHdlr)(DoPEOnSynchronizeData*, LPVOID);
  /*
     Handler for received synchronized measuring data records
       DoPEOnSynchronizeData   received synchronized measuring data records
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataHdlr
     should return 0 (reserved for future versions)
  */

  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataRtHdlr)(DoPEOnSynchronizeData*, LPVOID);
  /*
     Realtime handler for received synchronized measuring data records
       DoPEOnSynchronizeData   received measuring data record
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataRtHdlr
     should return 0 (reserved for future versions)
   */

  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataOverflowHdlr)(LPVOID);
  /*
     Handler for synchronized measuring data overflow events
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowHdlr
     should return 0 (reserved for future versions)
  */

  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataOverflowRtHdlr)(LPVOID);
  /*
     Realtime handler for synchronized measuring data overflow events
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowRtHdlr
     should return 0 (reserved for future versions)
   */

/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataHdlr ( DoPEOnSynchronizeDataHdlr  Hdlr,
                                                           LPVOID                     lpParameter );

    /*
    Set the OnSynchronizeData handler.

      In :  Hdlr        is called at application priority with every
                        received synchronized sample

      Returns:          Error constant (DoPERR_xxxx)

    The DoPE 'synchronize data' event handler uses internaly the windows message
    WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message number
    if the DoPE 'synchronize data' event handler should be used!
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataRtHdlr ( DoPEOnSynchronizeDataRtHdlr  Hdlr,
                                                             LPVOID                       lpParameter );

    /*
    Set the realtime OnSynchronizeData handler.

      In :  Hdlr        is called from the high priotity communication thread
                        with every received synchronized sample

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataOverflowHdlr ( DoPEOnSynchronizeDataOverflowHdlr  Hdlr,
                                                                   LPVOID                             lpParameter );

    /*
    Set the OnSynchronizeDataOverflow handler.

      In :  Hdlr        is called at application priority at a synchronize data
                        overflow

      Returns:          Error constant (DoPERR_xxxx)

    The DoPE 'synchronize data overflow' event handler uses internaly the windows
    message WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message
    number if the DoPE 'synchronize data overflow' event handler should be used!
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataOverflowRtHdlr ( DoPEOnSynchronizeDataOverflowRtHdlr  Hdlr,
                                                                     LPVOID                               lpParameter );

    /*
    Set the realtime OnSynchronizeDataOverflow handler.

      In :  Hdlr        is called from the high priotity communication thread
                        at a synchronize data overflow

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define SYNCHRONIZE_MAX  32          // max. number of links to synchronize

  extern  unsigned  DLLAPI  DoPESynchronizeData ( DoPE_HANDLE  DoPEHdl[],
                                                  DoPE_HANDLE *pMaster );

    /*
    Activate sample synchronization for the linklist DP.
    Passing an empty linklist (first item NULL) stops sample synchronization.
    Initializing, selecting a setup or closing one or more links stops sample
    synchronization, too.

      In :  DoPEHdl       DoPE link handle array (terminated by NULL)
            pMaster       Pointer to storage for the master DoPE link handle

      Out : *DoPEHdl      Master DoPE link handle

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESynchronizeSystemModeSync ( DoPE_HANDLE    DoPEHdl,
                                                            unsigned short Mode,
                                                            double         Time );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESynchronizeSystemMode ( DoPE_HANDLE    DoPEHdl,
                                                        unsigned short Mode,
                                                        double         Time,
                                                        WORD          *lpusTAN );

    /*
    Set or discard the delay time for synchronized movement commands or the
    system time for multiple systems. The systems will be synchronized by
    the DoPESynchronizeSystemStart command.

      In :  DoPEHdl       DoPE link handle of Master EDC 
            Mode          SSM_SYNCMOVE
                          SSM_SYSTEMTIME
                          SSM_DISCARD
            Time          Delay or system time to set with the next
                          DoPESynchronizeSystemStart command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

  #define  SSM_DISCARD    0
  #define  SSM_SYNCMOVE   1
  #define  SSM_SYSTEMTIME 2


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESynchronizeSystemStartSync ( DoPE_HANDLE  DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESynchronizeSystemStart ( DoPE_HANDLE  DoPEHdl,
                                                         WORD        *lpusTAN );
    /*
    Activate the delay time for synchronized movement commands or the system time
    for multiple systems set by DoPESynchronizeSystemMode calls.

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
