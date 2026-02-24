Attribute VB_Name = "DoPErmc"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 2006-present
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) remot control default handling
'
' Versions:
' ---------
'
' HEG, 12.5.11
' - wrote it.
'
'******************************************************************************

Type DoPEOnRmcEvent                 ' 'RMC Event'
  Keys     As INT64                 ' Current key state                [No]
  NewKeys  As INT64                 ' New keys                         [No]
  GoneKeys As INT64                 ' Gone keys                        [No]
  Leds     As INT64                 ' Current LED state                [No]
  NewLeds  As INT64                 ' New LEDs                         [No]
  GoneLeds As INT64                 ' Gone LEDs                        [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnRmcEventHdlr)(DoPE_HANDLE, DoPEOnRmcEvent*, LPVOID);
'  /*
'     Handler for RMC events
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnRmcEvent        received RMC event
'       LPVOID                userspecific pointer set with DoPESetOnRmcEventHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnRmcEventRtHdlr)(DoPE_HANDLE, DoPEOnRmcEvent*, LPVOID);
'  /*
'     Realtime handler for RMC events
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnRmcEvent        received RMC event
'       LPVOID                userspecific pointer set with DoPESetOnRmcEventRtHdlr
'     should return 0 (reserved for future versions)
'  */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnRmcEventHdlr Lib "dope.dll" Alias "DoPESetOnRmcEventHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long
'
'  extern  unsigned  DLLAPI  DoPESetOnRmcEventHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnRmcEventHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the OnRmcEvent handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        RMC event
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
'    Applications using event handlers must not use this windows message number!
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
'  extern  unsigned  DLLAPI  DoPESetOnRmcEventRtHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnRmcEventRtHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the realtime OnRmcEvent handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every RMC event
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBRmcEnable Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef EnableKeys As INT64, ByRef EnableLeds As INT64) As Long
'
'  extern  unsigned  DLLAPI  DoPERmcEnable ( DoPE_HANDLE      DoPEHdl,
'                                            unsigned __int64 EnableKeys,
'                                            unsigned __int64 EnableLeds );
'
'    /*
'    Enable / disable the remote control default handling for keys and LEDs.
'    Sets the PushMode and RmcDPoti settings to the default values defined in
'    the setup RMC definition.
'
'      In :  DoPEHdl       DoPE link handle
'            EnableKeys    mask of enabled RMC emulation keys
'            EnableLeds    mask of enabled RMC emulation LEDs
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Type VBDoPERmcDPoti
  RmcDPoti(MAX_CTRL - 1) As DoPERmcDPoti ' RMC DPoti definition
End Type

Declare Function DoPEVBRmcReDefine Lib "dope.dll" Alias "DoPERmcReDefine" (ByVal DoPEHdl As Long, ByVal PushMode As Integer, ByRef RmcDPoti As VBDoPERmcDPoti) As Long
'
'  extern  unsigned  DLLAPI  DoPERmcReDefine ( DoPE_HANDLE      DoPEHdl,
'                                              unsigned __int16 PushMode,
'                                              DoPERmcDPoti     RmcDPoti[MAX_CTRL] );
'
'    /*
'    Redefine the PushMode and RmcDPoti settings for the remote control default handling.
'
'      In :  DoPEHdl       DoPE link handle
'            PushMode      !=0  enables
'                          0    disables the push mode for Up/Down keys
'            RmcDPoti      RMC DPoti definition
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBRmcKeys Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef SetKeys As INT64, ByRef ResKeys As INT64, ByRef ToggleKeys As INT64) As Long
'
'  extern  unsigned  DLLAPI  DoPERmcKeys ( DoPE_HANDLE      DoPEHdl,
'                                          unsigned __int64 SetKeys,
'                                          unsigned __int64 ResKeys,
'                                          unsigned __int64 ToggleKeys );
'
'    /*
'    Set / reset / toggle keys for the remote control default handling.
'
'      In :  DoPEHdl       DoPE link handle
'            SetKeys       RMC emulation keys to set
'            ResKeys       RMC emulation keys to clear
'            ToggleKeys    RMC emulation keys to toggle
'
'            The three key patterns will be processed in the following
'            sequence (important with conflicting data):
'            1.) Flashing bits.          (lowest priority)
'            2.) Resetting of the bits.
'            3.) Setting of the bits.    (highest priority)
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBRmcState Lib "dope.dll" Alias "DoPERmcState" (ByVal DoPEHdl As Long, ByRef RmcEvent As DoPEOnRmcEvent) As Long
'
'  extern  unsigned  DLLAPI  DoPERmcState ( DoPE_HANDLE     DoPEHdl,
'                                           DoPEOnRmcEvent *RmcEvent );
'
'    /*
'    Get keys and LEDs state of the remote control default handling.
'
'      In :  DoPEHdl       DoPE link handle
     '       RmcEvent      RMC event state
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
