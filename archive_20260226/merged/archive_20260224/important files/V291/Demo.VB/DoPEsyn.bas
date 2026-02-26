Attribute VB_Name = "DoPEsyn"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 2006
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) synchronized datainterface
'
' Versions:
' ---------
' V 2.51  17.07.2006  PET
'  - Initial version
'
' V 2.52  21.07.2006  PET
'  - SYNCHRONIZE_MAX defined
'
'  HEG, 3.2.10 - V2.67
'  - Buffer utilization added to DoPEOnSynchronizeData structure
'  - New DoPE functions:
'    - DoPESetOnSynchronizeDataOverflowHdlr
'    - DoPESetOnSynchronizeDataOverflowRtHdlr
'******************************************************************************


'  /* -------- Eventhandler definitions -------------------------------------- */
'
Type DoPELinkData                   ' Synchronized measuring data record
  DP   As Long                      ' DoPE link handle
  Pad1 As Long                      ' internal fill charcters
  Data As DoPEData                  ' Measuring data record
End Type

Type DoPEOnSynchronizeData          ' Synchronized measuring data matrix
  DoPError As Long                  ' DoPE error code                  [No]
  nData    As Long                  ' Number of measuring data records
  Sample   As Long                  ' Array of measuring data records
  Pad1     As Long                  ' internal fill charcters
  Occupied As Double                ' Utilization   [% of data buffer size]
End Type

'/* -------------------------------------------------------------------------- */
'  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataHdlr)(DoPEOnSynchronizeData*, LPVOID);
'  /*
'     Handler for received synchronized measuring data records
'       DoPEOnSynchronizeData   received synchronized measuring data records
'       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataRtHdlr)(DoPEOnSynchronizeData*, LPVOID);
'  /*
'     Realtime handler for received synchronized measuring data records
'       DoPEOnSynchronizeData   received measuring data record
'       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
'
'  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataOverflowHdlr)(LPVOID);
'  /*
'     Handler for synchronized measuring data overflow events
'       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnSynchronizeDataOverflowRtHdlr)(LPVOID);
'  /*
'     Realtime handler for synchronized measuring data overflow events
'       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnSynchronizeDataHdlr Lib "dope.dll" Alias "DoPESetOnSynchronizeDataHdlr" (ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataHdlr ( DoPEOnSynchronizeDataHdlr  Hdlr,
'                                                           LPVOID                     lpParameter );
'
'    /*
'    Set the OnSynchronizeData handler.
'
'      In :  Hdlr        is called at application priority with every
'                        received synchronized sample
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    The DoPE 'synchronize data' event handler uses internaly the windows message
'    WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message number
'    if the DoPE 'synchronize data' event handler should be used!
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
'  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataRtHdlr ( DoPEOnSynchronizeDataRtHdlr  Hdlr,
'                                                             LPVOID                       lpParameter );
'
'    /*
'    Set the realtime OnSynchronizeData handler.
'
'      In :  Hdlr        is called from the high priotity communication thread
'                        with every received synchronized sample
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnSynchronizeDataOverflowHdlr Lib "dope.dll" Alias "DoPESetOnSynchronizeDataOverflowHdlr" (ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataOverflowHdlr ( DoPEOnSynchronizeDataOverflowHdlr  Hdlr,
'                                                                   LPVOID                             lpParameter );
'
'    /*
'    Set the OnSynchronizeDataOverflow handler.
'
'      In :  Hdlr        is called at application priority at a synchronize data
'                        overflow
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    The DoPE 'synchronize data overflow' event handler uses internaly the windows
'    message WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message
'    number if the DoPE 'synchronize data overflow' event handler should be used!
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
'  extern  unsigned  DLLAPI  DoPESetOnSynchronizeDataOverflowRtHdlr ( DoPEOnSynchronizeDataOverflowRtHdlr  Hdlr,
'                                                                     LPVOID                               lpParameter );
'
'    /*
'    Set the realtime OnSynchronizeDataOverflow handler.
'
'      In :  Hdlr        is called from the high priotity communication thread
'                        at a synchronize data overflow
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Public Const SYNCHRONIZE_MAX = 32          ' max. number of links to synchronize

Declare Function DoPEVBSynchronizeData Lib "dope.dll" Alias "DoPESynchronizeData" (ByRef DP As Long, ByRef pMaster As Long) As Long

'  extern  unsigned  DLLAPI  DoPESynchronizeData ( DoPE_HANDLE  DP[],
'                                                  DoPE_HANDLE *pMaster );
'    /*
'    Activate sample synchronization for the linklist DP.
'    Passing an empty linklist (first item NULL) stops sample synchronization.
'    Initializing, selecting a setup or closing one or more links stops sample
'    synchronization, too.
'
'      In :  DP            DoPE link handle array (terminated by NULL)
'            pMaster       Pointer to storage for the master DoPE link handle
'
'      Out : *DoPEHdl      Master DoPE link handle
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSynchronizeSystemMode     Lib "dope.dll" Alias "DoPESynchronizeSystemMode"     (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Time As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSynchronizeSystemModeSync Lib "dope.dll" Alias "DoPESynchronizeSystemModeSync" (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Time As Double) As Long

'  extern  unsigned  DLLAPI  DoPESynchronizeSystemModeSync ( DoPE_HANDLE     DP,
'                                                            unsigned short Mode,
'                                                            double         Time );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESynchronizeSystemMode ( DoPE_HANDLE    DP,
'                                                        unsigned short Mode,
'                                                        double         Time,
'                                                        WORD          *lpusTAN );
'
'    /*
'    Set or discard the delay time for synchronized movement commands or the
'    system time for multiple systems. The systems will be synchronized by
'    the DoPESynchronizeSystemStart command.
'
'      In :  DP            DoPE link handle
'            Mode          SSM_SYNCMOVE
'                          SSM_SYSTEMTIME
'                          SSM_DISCARD
'            Time          Delay or system time to set with the next
'                          DoPESynchronizeSystemStart command
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
Public Const SSM_DISCARD    = 0
Public Const SSM_SYNCMOVE   = 1
Public Const SSM_SYSTEMTIME = 2
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSynchronizeSystemStart     Lib "dope.dll" Alias "DoPESynchronizeSystemStart"     (ByVal DoPEHdl As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSynchronizeSystemStartSync Lib "dope.dll" Alias "DoPESynchronizeSystemStartSync" (ByVal DoPEHdl As Long) As Long

'  extern  unsigned  DLLAPI  DoPESynchronizeSystemStartSync ( DoPE_HANDLE  DP );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESynchronizeSystemStart ( DoPE_HANDLE  DP,
'                                                         WORD        *lpusTAN );
'    /*
'    Activate the delay time for synchronized movement commands or the system time
'    for multiple systems set by DoPESynchronizeSystemMode calls.
'
'      In :  DP            DoPE link handle
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
