Attribute VB_Name = "DoPEEH"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 1998-2006
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) event handler interface
'
' Versions:
' ---------
'
' V 1.00  14.06.2004  PET
' - Inital version.
'
' V 2.29  10.12.2004  PET
' - remarks modified
'
' V 2.51  13.07.2006  PET
'  - DoPESetOnKeyMsgHdlr and DoPESetOnKeyMsgRtHdlr implemented
'
'  HEG, 22.10.07 - V2.59
'  - DoPEOFFLINE, DoPEONLINE and DoPERESTART defined for OnLine handler
'    line state.
'
'  HEG, 4.3.09 - V2.65
'  - DoPESetOnSystemMsgHdlr and DoPESetOnSystemMsgRtHdlr implemented
'
'  HEG, 12.10.11 - V 2.71
'  - DoPESetOnIoSHaltMsgHdlr and DoPESetOnIoSHaltMsgRtHdlr implemented
'
'  HEG, 26.7.2012 - V 2.73
'  - New system message:
'    - SYSTEM_MSG_OC_MC2OUTPUT_MODE
'
'  HEG, 14.9.2012 - V 2.74
'  - New System Messages:
'    - SYSTEM_MSG_MAX_RESULT_FILES
'    - SYSTEM_MSG_SEN_SCALE
'
'  PET, 14.11.2013 - V 2.77
'  - DoPESetOnDebugMsgHdlr and DoPESetOnDebugMsgRtHdlr implemented
'
'  HEG, 20.05.14 - V 2.80
'  - DoPESetOnDataBlockHdlr and DoPESetOnDataBlockRtHdlr implemented
'  - DoPESetOnDataBlockSize and DoPEGetOnDataBlockSize implemented
'******************************************************************************
'
'  /* -------- Eventhandler definitions -------------------------------------- */
'
Public Const DoPEOFFLINE = 0         ' link is offline
Public Const DoPEONLINE = 1          ' link is online
Public Const DoPERESTART = 2         ' asynchronus restart of the link

'  typedef  unsigned (CALLBACK *DoPEOnLineHdlr)(DoPE_HANDLE, int, LPVOID);
'  /*
'     Handler for DoPE line state changed events
'       DoPE_HANDLE  DoPE link handle
'       int          Line state (DoPEOFFLINE, DoPEONLINE, DoPERESTART )
'       LPVOID       userspecific pointer set with DoPESetOnLineHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnLineRtHdlr)(DoPE_HANDLE, int, LPVOID);
'  /*
'     Realtime handler for DoPE line state changed events
'       DoPE_HANDLE  DoPE link handle
'       int          Line state (DoPEOFFLINE, DoPEONLINE, DoPERESTART )
'       LPVOID       userspecific pointer set with DoPESetOnLineRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnData                     ' Measuring data record
  DoPError As Long                  ' DoPE error code                  [No]
  Pad1     As Long                  ' internal fill charcters
  Data     As DoPEData              ' Measuring data record
  Occupied As Double                ' Utilization    [% of the buffer size]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnDataHdlr)(DoPE_HANDLE, DoPEOnData*, LPVOID);
'  /*
'     Handler for received measuring data records
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnData   received measuring data record
'       LPVOID       userspecific pointer set with DoPESetOnDataHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnDataRtHdlr)(DoPE_HANDLE, DoPEOnData*, LPVOID);
'  /*
'     Realtime handler for received measuring data records
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnData   received measuring data record
'       LPVOID       userspecific pointer set with DoPESetOnDataRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnDataBlock                ' Measuring data records block
  DoPError As Long                  ' DoPE error code                  [No]
  nData    As Long                  ' Number of measuring data records [No]
  Data     As Long                  ' Pointer to Measuring data records DoPEOnData
  Pad1     As Long                  ' internal fill charcters
  Occupied As Double                ' Utilization   [% of data buffer size]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnDataBlockHdlr)(DoPE_HANDLE, DoPEOnDataBlock*, LPVOID);
'  /*
'     Handler for received measuring data records
'       DoPE_HANDLE       DoPE link handle
'       DoPEOnDataBlock   received measuring data record block
'       LPVOID            userspecific pointer set with DoPESetOnDataBlockHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnDataBlockRtHdlr)(DoPE_HANDLE, DoPEOnDataBlock*, LPVOID);
'  /*
'     Realtime handler for received measuring data records
'       DoPE_HANDLE       DoPE link handle
'       DoPEOnDataBlock   received measuring data record block
'       LPVOID       userspecific pointer set with DoPESetOnDataBlockRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnCommandError                ' Command error
  CommandNumber As Integer             ' Number of command             [No]
  ErrorNumber   As Integer             ' Number of error               [No]
  usTAN         As Integer             ' Transaction number            [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnCommandErrorHdlr)(DoPE_HANDLE, DoPEOnCommandError*, LPVOID);
'  /*
'     Handler for command errors
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnCommandError    received command error
'       LPVOID                userspecific pointer set with DoPESetOnCommandErrorHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnCommandErrorRtHdlr)(DoPE_HANDLE, DoPEOnCommandError*, LPVOID);
'  /*
'     Realtime handler for command errors
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnCommandError    received command error
'       LPVOID                userspecific pointer set with DoPESetOnCommandErrorHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnPosMsg                      ' 'Position'       Message
  DoPError    As Long                  ' DoPE error code                  [No]
  Reached     As Integer               ' position reached                [1/0]
  Pad1        As Integer               ' internal fill charcters
  Time        As Double                ' System time for the message       [s]
  Control     As Integer               ' Control mode of position         [No]
  Pad2        As Integer               ' internal fill charcters
  Pad3        As Long                  ' internal fill charcters
  Position    As Double                ' Position                       [Unit]
  DControl    As Integer               ' Ctrl. mode of destination pos.   [No]
  Pad4        As Integer               ' internal fill charcters
  Pad5        As Long                  ' internal fill charcters
  Destination As Double                ' Destination position           [Unit]
  usTAN       As Integer               ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnPosMsgHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Handler for position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received position message
'       LPVOID       userspecific pointer set with DoPESetOnPosMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnPosMsgRtHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Realtime handler for position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received position message
'       LPVOID       userspecific pointer set with DoPEOnPosMsgHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
'
'  typedef  unsigned (CALLBACK *DoPEOnTPosMsgHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Handler for trigger position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received trigger position message
'       LPVOID       userspecific pointer set with DoPESetOnTPosMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnTPosMsgRtHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Realtime handler for trigger position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received trigger position message
'       LPVOID       userspecific pointer set with DoPEOnTPosMsgHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
'
'  typedef  unsigned (CALLBACK *DoPEOnLPosMsgHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Handler for limit position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received limit position message
'       LPVOID       userspecific pointer set with DoPESetOnLPosMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnLPosMsgRtHdlr)(DoPE_HANDLE, DoPEOnPosMsg*, LPVOID);
'  /*
'     Realtime handler for limit position messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnPosMsg received limit position message
'       LPVOID       userspecific pointer set with DoPEOnLPosMsgHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnSftMsg                      ' 'Softend' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Upper    As Integer                  ' 1 upper, 0 lower softend        [1/0]
  Pad1     As Integer                  ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  Control  As Integer                  ' Control mode of position         [No]
  Pad2     As Integer                  ' internal fill charcters
  Pad3     As Long                     ' internal fill charcters
  Position As Double                   ' Position                       [Unit]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnSftMsgHdlr)(DoPE_HANDLE, DoPEOnSftMsg*, LPVOID);
'  /*
'     Handler for softend messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnSftMsg received softend message
'       LPVOID       userspecific pointer set with DoPESetOnSftMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnSftMsgRtHdlr)(DoPE_HANDLE, DoPEOnSftMsg*, LPVOID);
'  /*
'     Realtime handler for softend messages
'       DoPE_HANDLE  DoPE link handle
'       DoPEOnSftMsg received softend message
'       LPVOID       userspecific pointer set with DoPEOnSftMsgHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnOffsCMsg                    ' 'Offset-Correction' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Pad1     As Long                     ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  Offset   As Double                   ' Power Amplifier Offset            [%]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnOffsCMsgHdlr)(DoPE_HANDLE, DoPEOnOffsCMsg*, LPVOID);
'  /*
'     Handler for offset correction messages
'       DoPE_HANDLE    DoPE link handle
'       DoPEOnOffsCMsg received offset correction message
'       LPVOID         userspecific pointer set with DoPESetOnOffsCMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnOffsCMsgRtHdlr)(DoPE_HANDLE, DoPEOnOffsCMsg*, LPVOID);
'  /*
'     Realtime handler for offset correction messages
'       DoPE_HANDLE    DoPE link handle
'       DoPEOnOffsCMsg received offset correction message
'       LPVOID         userspecific pointer set with DoPESetOnOffsCMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnCheckMsg                    ' 'Measuring Channel Supervision' Msg.
  DoPError As Long                     ' DoPE error code                  [No]
  Action   As Integer                  ' Action started                  [1/0]
  Pad1     As Integer                  ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  CheckId  As Integer                  ' ID of Measuring Channel Check    [No]
  Pad2     As Integer                  ' internal fill charcters
  Pad3     As Long                     ' internal fill charcters
  Position As Double                   ' Position                       [Unit]
  SensorNo As Integer                  ' Supervised sensor                [No]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnCheckMsgHdlr)(DoPE_HANDLE, DoPEOnCheckMsg*, LPVOID);
'  /*
'     Handler for channel supervision messages
'       DoPE_HANDLE    DoPE link handle
'       DoPEOnCheckMsg received channel supervision message
'       LPVOID         userspecific pointer set with DoPESetOnCheckMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnCheckMsgRtHdlr)(DoPE_HANDLE, DoPEOnCheckMsg*, LPVOID);
'  /*
'     Realtime handler for channel supervision messages
'       DoPE_HANDLE    DoPE link handle
'       DoPEOnCheckMsg received channel supervision message
'       LPVOID         userspecific pointer set with DoPESetOnCheckMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnShieldMsg                   ' 'Shield' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Action   As Integer                  ' Action started                  [1/0]
  Pad1     As Integer                  ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  SensorNo As Integer                  ' Supervised sensor                [No]
  Pad2     As Integer                  ' internal fill charcters
  Pad3     As Long                     ' internal fill charcters
  Position As Double                   ' Position                       [Unit]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnShieldMsgHdlr)(DoPE_HANDLE, DoPEOnShieldMsg*, LPVOID);
'  /*
'     Handler for shield supervision messages
'       DoPE_HANDLE     DoPE link handle
'       DoPEOnShieldMsg received shield supervision message
'       LPVOID          userspecific pointer set with DoPESetOnShieldMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnShieldMsgRtHdlr)(DoPE_HANDLE, DoPEOnShieldMsg*, LPVOID);
'  /*
'     Realtime handler for shield supervision messages
'       DoPE_HANDLE     DoPE link handle
'       DoPEOnShieldMsg received shield supervision message
'       LPVOID          userspecific pointer set with DoPESetOnShieldMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnRefSignalMsg                ' 'Reference Signal' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Pad1     As Long                     ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  SensorNo As Integer                  ' Sensor where ref. signal occured [No]
  Pad2     As Integer                  ' internal fill charcters
  Pad3     As Long                     ' internal fill charcters
  Position As Double                   ' Position at ref. signal        [Unit]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnRefSignalMsgHdlr)(DoPE_HANDLE, DoPEOnRefSignalMsg*, LPVOID);
'  /*
'     Handler for reference signal messages
'       DoPE_HANDLE        DoPE link handle
'       DoPEOnRefSignalMsg received reference signal message
'       LPVOID             userspecific pointer set with DoPESetOnRefSignalMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnRefSignalMsgRtHdlr)(DoPE_HANDLE, DoPEOnRefSignalMsg*, LPVOID);
'  /*
'     Realtime handler for reference signal messages
'       DoPE_HANDLE        DoPE link handle
'       DoPEOnRefSignalMsg received reference signal message
'       LPVOID             userspecific pointer set with DoPESetOnRefSignalMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnSensorMsg                   ' 'Sensor' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Pad1     As Long                     ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  SensorNo As Integer                  ' Sensornumber                     [No]
  Length   As Integer                  ' Number of bytes in the message   [No]
  Data(SENSOR_MSG_LEN) As Byte         ' Message data bytes
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnSensorMsgHdlr)(DoPE_HANDLE, DoPEOnSensorMsg*, LPVOID);
'  /*
'     Handler for sensor messages
'       DoPE_HANDLE        DoPE link handle
'       DoPEOnSensorMsg    received sensor message
'       LPVOID             userspecific pointer set with DoPESetOnSensorMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnSensorMsgRtHdlr)(DoPE_HANDLE, DoPEOnSensorMsg*, LPVOID);
'  /*
'     Realtime handler for reference signal messages
'       DoPE_HANDLE        DoPE link handle
'       DoPEOnSensorMsg    received sensor message
'       LPVOID             userspecific pointer set with DoPESetOnSensorMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnIoSHaltMsg                  ' 'IoSHalt' Message
  DoPError As Long                     ' DoPE error code                  [No]
  Upper    As Integer                  ' !=0 upper, 0 lower IO-SHalt     [1/0]
  Pad1     As Integer                  ' internal fill charcters
  Time     As Double                   ' System time for the message       [s]
  Control  As Integer                  ' Control mode of position         [No]
  Pad2     As Integer                  ' internal fill charcters
  Pad3     As Long                     ' internal fill charcters
  Position As Double                   ' Position                       [Unit]
  usTAN    As Integer                  ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnIoSHaltMsgHdlr)(DoPE_HANDLE, DoPEOnIoSHaltMsg*, LPVOID);
'  /*
'     Handler for IO-SHalt messages
'       DoPE_HANDLE      DoPE link handle
'       DoPEOnIoSHaltMsg received IO-SHalt message
'       LPVOID           userspecific pointer set with DoPESetOnIoSHaltMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnIoSHaltMsgRtHdlr)(DoPE_HANDLE, DoPEOnIoSHaltMsg*, LPVOID);
'  /*
'     Realtime handler for IO-SHalt messages
'       DoPE_HANDLE      DoPE link handle
'       DoPEOnIoSHaltMsg received IO-SHalt message
'       LPVOID           userspecific pointer set with DoPESetOnIoSHaltMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type INT64                             ' __int64 variable type
  Low  As Long
  High As Long
End Type

Type DoPEOnKeyMsg                      ' 'Keyboard' Message
  DoPError    As Long                  ' DoPE error code                  [No]
  Pad1        As Long                  ' internal fill charcters
  Time        As Double                ' System time for the message       [s]
  Keys        As INT64                 ' Current key state                [No]
  NewKeys     As INT64                 ' New keys                         [No]
  GoneKeys    As INT64                 ' Gone keys                        [No]
  OemKeys     As Integer               ' Current OEM key state            [No]
  NewOemKeys  As Integer               ' New OEM keys                     [No]
  GoneOemKeys As Integer               ' Gone OEM keys                    [No]
  usTAN       As Integer               ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnKeyMsgHdlr)(DoPE_HANDLE, DoPEOnKeyMsg*, LPVOID);
'  /*
'     Handler for keyboard messages
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnKeyMsg          received keyboard message
'       LPVOID                userspecific pointer set with DoPESetOnKeyMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnKeyMsgRtHdlr)(DoPE_HANDLE, DoPEOnKeyMsg*, LPVOID);
'  /*
'     Realtime handler for keyboard messages
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnKeyMsg          received keyboard message
'       LPVOID                userspecific pointer set with DoPESetOnKeyMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

Type DoPEOnRuntimeError                ' Runtime error
  DoPError    As Long                  ' DoPE error code                  [No]
  ErrorNumber As Integer               ' Number of run time error         [No]
  Pad1        As Integer               ' internal fill charcters
  Time        As Double                ' System time the error occurred    [s]
  Device      As Integer               ' Device Number responsible for the err
  Bits        As Integer               ' Responsible bits if digital input dev
  usTAN       As Integer               ' Transaction number               [No]
End Type

'  typedef  unsigned (CALLBACK *DoPEOnRuntimeErrorHdlr)(DoPE_HANDLE, DoPEOnRuntimeError*, LPVOID);
'  /*
'     Handler for runtime errors
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnRuntimeError    received runtime error
'       LPVOID                userspecific pointer set with DoPESetOnRuntimeErrorHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnRuntimeErrorRtHdlr)(DoPE_HANDLE, DoPEOnRuntimeError*, LPVOID);
'  /*
'     Realtime handler for runtime errors
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnRuntimeError    received runtime error
'       LPVOID                userspecific pointer set with DoPESetOnRuntimeErrorRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
'
'----------------------------------------------------------------------------
' Constants for system messages
'----------------------------------------------------------------------------

Public Const SYSTEM_MSG_TEXT_LEN = (440 * 2)                 ' max. system message text length in bytes
                                                             ' (including terminating zero '\0')

Public Const SYSTEM_MSG_NOERROR = 0                          ' No error

                                                             ' General runtime errors
Public Const SYSTEM_MSG_UNKNOWN = 10000                      ' Unknown runtime error
Public Const SYSTEM_MSG_POWERAMP_ERROR = 10001               ' Power amplifier error
Public Const SYSTEM_MSG_DRIVE_ERROR = 10002                  ' Drive error
Public Const SYSTEM_MSG_DRIVE_NOTREADY = 10003               ' Drive not ready
Public Const SYSTEM_MSG_DRIVE_RELEASE = 10004                ' Drive release withdrawn
Public Const SYSTEM_MSG_UPPER_SENLIMIT = 10005               ' Upper sensor limit exceeded
Public Const SYSTEM_MSG_LOWER_SENLIMIT = 10006               ' Lower sensor limit exceeded
Public Const SYSTEM_MSG_LIMITSWITCH = 10007                  ' Upper or lower hard-limit switch
Public Const SYSTEM_MSG_DEVIATION = 10008                    ' Controller deviation error
Public Const SYSTEM_MSG_NODIGIPOTI = 10009                   ' No digipoti configurated
Public Const SYSTEM_MSG_NORMC = 10010                        ' No remote control pluged
Public Const SYSTEM_MSG_EMERGENCY_OFF = 10011                ' Emergency switch activated
Public Const SYSTEM_MSG_NOMEMORY = 10012                     ' not enough memory
Public Const SYSTEM_MSG_NOSHIELD = 10013                     ' Shield not found
Public Const SYSTEM_MSG_X2T_OFFLINE = 10014                  ' X2T module offline
Public Const SYSTEM_MSG_MAX_RESULT_FILES = 10015             ' max. count of result files reached

                                                             ' System EEPROM errors (flashdisk)
Public Const SYSTEM_MSG_SYSEEP_CRC = 10100                   ' data CRC error
Public Const SYSTEM_MSG_SYSEEP_NOBLOCK = 10101               ' block not found
Public Const SYSTEM_MSG_SYSEEP_BLOCKLENGTH = 10102           ' wrong block length
Public Const SYSTEM_MSG_SYSEEP_NOMEMORY = 10103              ' not enough EEPROM memory
Public Const SYSTEM_MSG_SYSEEP_BIOSNOFUNC = 10104            ' BIOS: function not found
Public Const SYSTEM_MSG_SYSEEP_BIOSNODEVICE = 10105          ' BIOS: device error
Public Const SYSTEM_MSG_SYSEEP_BIOSPARA = 10106              ' BIOS: parameter error
Public Const SYSTEM_MSG_SYSEEP_BIOSREAD = 10107              ' BIOS: read error
Public Const SYSTEM_MSG_SYSEEP_BIOSWRITE = 10108             ' BIOS: write error
Public Const SYSTEM_MSG_SYSEEP_BIOSREENT = 10109             ' BIOS: reentrance error

                                                             ' General initialization errors
Public Const SYSTEM_MSG_INIT_ENDDEV = 10200                  ' Error at initialization level 1
Public Const SYSTEM_MSG_INIT_ENDINI = 10201                  ' Error at initialization level 2
Public Const SYSTEM_MSG_INIT_SYSTIME = 10202                 ' Wrong system time
Public Const SYSTEM_MSG_INIT_POSCTRLTIME = 10203             ' Wrong position controller time
Public Const SYSTEM_MSG_INIT_DATA_TRANSMISSION_RATE = 10204  ' Wrong data transmission rate
Public Const SYSTEM_MSG_INIT_GRIP = 10205                    ' Grip  initialization error
Public Const SYSTEM_MSG_INIT_SHIELD = 10206                  ' Shield initialization error
Public Const SYSTEM_MSG_INIT_MAINBOARD = 10207               ' EDC mainboard initialization error
Public Const SYSTEM_MSG_INIT_MODULE_ERROR = 10208            ' Module error
Public Const SYSTEM_MSG_INIT_CTRL = 10209                    ' Error closed loop controller

                                                             ' Sensor initialization errors
Public Const SYSTEM_MSG_SEN_EEP_NOTFOUND = 10300             ' Sensor EEPROM not found
Public Const SYSTEM_MSG_SEN_EEP_BCC = 10301                  ' Sensor EEPROM data BCC error
Public Const SYSTEM_MSG_SEN_EEP_CLASS = 10302                ' Unknown sensor EEPROM class
Public Const SYSTEM_MSG_SEN_NOTFOUND = 10303                 ' Sensor not found
Public Const SYSTEM_MSG_SEN_INITBYTE = 10304                 ' Initialization word error
Public Const SYSTEM_MSG_SEN_INIT = 10305                     ' Sensor initialization error
Public Const SYSTEM_MSG_SEN_PARA = 10306                     ' Wrong sensor parameter
Public Const SYSTEM_MSG_SEN_CORR = 10307                     ' Wrong sensor correction value
Public Const SYSTEM_MSG_SEN_MCINTEGR = 10308                 ' Wrong integration time for
                                                             ' measured channel values
Public Const SYSTEM_MSG_SEN_CTRLINTEGR = 10309               ' Wrong integration time for
                                                             ' closed loop control
Public Const SYSTEM_MSG_SEN_LIMIT = 10310                    ' Wrong sensor limits
Public Const SYSTEM_MSG_SEN_NOMINALACC = 10311               ' Wrong nominal acceleration
Public Const SYSTEM_MSG_SEN_NOMINALSPEED = 10312             ' Wrong nominal speed
Public Const SYSTEM_MSG_SEN_POS_CTRL = 10313                 ' Wrong parameter for position closed
                                                             ' loop control
Public Const SYSTEM_MSG_SEN_SPEED_CTRL = 10314               ' Wrong parameter for speed closed
                                                             ' loop control
Public Const SYSTEM_MSG_SEN_BIOS = 10315                     ' Wrong BIOS Version
Public Const SYSTEM_MSG_SEN_OFFSET = 10316                   ' Wrong sensor offset
Public Const SYSTEM_MSG_SEN_SCALE = 10317                    ' Wrong sensor scale

                                                             ' Output channel initialization errors
Public Const SYSTEM_MSG_OC_EEP_NOTFOUND = 10400              ' Output channel EEPROM not found
Public Const SYSTEM_MSG_OC_EEP_BCC = 10401                   ' Output channel EEPROM data BCC error
Public Const SYSTEM_MSG_OC_EEP_CLASS = 10402                 ' Unknown Output channel EEPROM class
Public Const SYSTEM_MSG_OC_INIT = 10403                      ' Output channel initialization error
Public Const SYSTEM_MSG_OC_VOLTAGE = 10404                   ' Wrong voltage for DDAxx
Public Const SYSTEM_MSG_OC_CURRENT = 10405                   ' Wrong current for DDAxx
Public Const SYSTEM_MSG_OC_POWER = 10406                     ' Wrong power   for DDAxx
Public Const SYSTEM_MSG_OC_PARA = 10407                      ' Wrong output channel parameter
Public Const SYSTEM_MSG_OC_MAX_CURR_TIME = 10408             ' Wrong max current time for I²T
Public Const SYSTEM_MSG_OC_DITHER_FREQ = 10409               ' Wrong dither frequency
Public Const SYSTEM_MSG_OC_DITHER_AMPL = 10410               ' Wrong dither amplitude
Public Const SYSTEM_MSG_OC_DITHER_INIT = 10411               ' dither initialization error
Public Const SYSTEM_MSG_OC_CURRENT_CTRL = 10412              ' Wrong parameter for current closed
                                                             ' loop control
Public Const SYSTEM_MSG_OC_MC2OUTPUT = 10413                 ' Mc2Output initialization error
Public Const SYSTEM_MSG_OC_MC2OUTPUT_MODE = 10414            ' Mc2Output mode not implemented

                                                             ' Bit input initialization errors
Public Const SYSTEM_MSG_BIN_INIT = 10500                     ' Bit input initialization error

                                                             ' Bit output initialization errors
Public Const SYSTEM_MSG_BOUT_INIT = 10600                    ' Bit output initialization error

                                                             ' IO-Signals initialization errors
Public Const SYSTEM_MSG_IO_MACHINE_CONNECTOR = 10700         ' IOMachine: connector error

Public Const SYSTEM_MSG_IO_GRIP_MODE = 10710                 ' IOGrip: Mode not implemented
Public Const SYSTEM_MSG_IO_GRIP_BIN = 10711                  ' IOGrip: Bit input  error
Public Const SYSTEM_MSG_IO_GRIP_BOUT = 10712                 ' IOGrip: Bit output error
Public Const SYSTEM_MSG_IO_GRIP_OC = 10713                   ' IOGrip: Output channel error
Public Const SYSTEM_MSG_IO_GRIP_LIMIT = 10714                ' IOGrip: Limit error
Public Const SYSTEM_MSG_IO_GRIP_OLD_LIMIT = 10715            ' IOGrip: Conflict with old grip limit

Public Const SYSTEM_MSG_IO_EXT_MODE = 10730                  ' IOExtensometer: Mode not implemented
Public Const SYSTEM_MSG_IO_EXT_BIN = 10731                   ' IOExtensometer: Bit input  error
Public Const SYSTEM_MSG_IO_EXT_BOUT = 10732                  ' IOExtensometer: Bit output error

Public Const SYSTEM_MSG_IO_FIXED_XHEAD_MODE = 10740          ' IOFixedXHead: Mode not implemented
Public Const SYSTEM_MSG_IO_FIXED_XHEAD_BIN = 10741           ' IOFixedXHead: Bit input  error
Public Const SYSTEM_MSG_IO_FIXED_XHEAD_BOUT = 10742          ' IOFixedXHead: Bit output error

Public Const SYSTEM_MSG_IO_HIGH_PRESSURE_MODE = 10750        ' IOHighPressure: Mode not implemented
Public Const SYSTEM_MSG_IO_HIGH_PRESSURE_BIN = 10751         ' IOHighPressure: Bit input  error
Public Const SYSTEM_MSG_IO_HIGH_PRESSURE_BOUT = 10752        ' IOHighPressure: Bit output error
Public Const SYSTEM_MSG_IO_HIGH_PRESSURE_OC = 10753          ' IOHighPressure: Output channel error

Public Const SYSTEM_MSG_IO_MISC_MODE = 10780                 ' IOMisc: Mode not implemented
Public Const SYSTEM_MSG_IO_MISC_BIN = 10781                  ' IOMisc: Bit input  error
Public Const SYSTEM_MSG_IO_MISC_BOUT = 10782                 ' IOMisc: Bit output error
Public Const SYSTEM_MSG_IO_MISC_TEMPERATURE1 = 10790         ' IOMisc: temperature1       (warning)
Public Const SYSTEM_MSG_IO_MISC_TEMPERATURE2 = 10791         ' IOMisc: temperature2 (emergency off)
Public Const SYSTEM_MSG_IO_MISC_OIL_LEVEL = 10792            ' IOMisc: oil level    (emergency off)
Public Const SYSTEM_MSG_IO_MISC_OIL_FILTER = 10793           ' IOMisc: oil filter         (warning)
Public Const SYSTEM_MSG_IO_MISC_POWER_FAIL = 10794           ' IOMisc: power fail   (emergency off)
                                                       
Public Const SYSTEM_MSG_IO_SHALT_MODE = 10850                ' IOSHalt: Mode not implemented
Public Const SYSTEM_MSG_IO_SHALT_BIN = 10851                 ' IOSHalt: Bit input  error

Public Const SYSTEM_MSG_LANGUAGE_READ = 10900                ' Language file: read error
Public Const SYSTEM_MSG_LANGUAGE_VERSION = 10901             ' Language file: wrong version
Public Const SYSTEM_MSG_LANGUAGE_SYNTAX = 10902              ' Language file: syntax errors


Type DoPEOnSystemMsg                   ' System Message
  DoPError  As Long                    ' DoPE error code                  [No]
  MsgNumber As Integer                 ' Number of system message         [No]
  Pad1      As Integer                 ' internal fill charcters
  Time      As Double                  ' System time the message was sent  [s]
  Text      As String * SYSTEM_MSG_TEXT_LEN ' message text (wide character string)
End Type

'typedef  unsigned (CALLBACK *DoPEOnSystemMsgHdlr)(DoPE_HANDLE, DoPEOnSystemMsg*, LPVOID);
'/*
'   Handler for system messages
'     DoPE_HANDLE           DoPE link handle
'     DoPEOnSystemMsg       received system message
'     LPVOID                userspecific pointer set with DoPESetOnSystemMsgHdlr
'   should return 0 (reserved for future versions)
'*/
'
'typedef  unsigned (CALLBACK *DoPEOnSystemMsgRtHdlr)(DoPE_HANDLE, DoPEOnSystemMsg*, LPVOID);
'/*
'   Realtime handler for system messages
'     DoPE_HANDLE           DoPE link handle
'     DoPEOnSystemMsg       received system message
'     LPVOID                userspecific pointer set with DoPESetOnSystemMsgRtHdlr
'   should return 0 (reserved for future versions)
' */
'
'  /* . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
'
'  typedef  unsigned (CALLBACK *DoPEOnOverflowHdlr)(DoPE_HANDLE, int, LPVOID);
'  /*
'     Handler for measuring data and message overlow events
'       DoPE_HANDLE  DoPE link handle
'       int          0=measuring data records lost, else=message lost
'       LPVOID       userspecific pointer set with DoPESetOnOverflowHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnOverflowRtHdlr)(DoPE_HANDLE, int, LPVOID);
'  /*
'     Realtime handler for measuring data and message overlow events
'       DoPE_HANDLE  DoPE link handle
'       int          0=measuring data records lost, else=message lost
'       LPVOID       userspecific pointer set with DoPESetOnOverflowRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'/* -------------------------------------------------------------------------- */
'
Public Const DEBUG_MSG_TEXT_LEN = 221  ' max. debug message text length

                                       ' Debug message types
Public Const DEBUG_MSG = 0             ' general debug message
Public Const DEBUG_MSG_DATA = 1        ' measured values debug message

Type DoPEOnDebugMsg                    ' Debug Message
  DoPError  As Long                    ' DoPE error code                  [No]
  MsgType   As Integer                 ' Type of debug message            [No]
  Pad1      As Integer                 ' internal fill charcters
  Time      As Double                  ' System time the message was sent  [s]
  Text      As String * DEBUG_MSG_TEXT_LEN ' message text
End Type

'  typedef  unsigned (CALLBACK *DoPEOnDebugMsgHdlr)(DoPE_HANDLE, DoPEOnDebugMsg*, LPVOID);
'  /*
'     Handler for debug messages
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnDebugMsg        received debug message
'       LPVOID                userspecific pointer set with DoPESetOnDebugMsgHdlr
'     should return 0 (reserved for future versions)
'  */
'
'  typedef  unsigned (CALLBACK *DoPEOnDebugMsgRtHdlr)(DoPE_HANDLE, DoPEOnDebugMsg*, LPVOID);
'  /*
'     Realtime handler for debug messages
'       DoPE_HANDLE           DoPE link handle
'       DoPEOnDebugMsg        received Debug message
'       LPVOID                userspecific pointer set with DoPESetOnDebugMsgRtHdlr
'     should return 0 (reserved for future versions)
'   */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnLineHdlr Lib "dope.dll" Alias "DoPESetOnLineHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnLineHdlr ( DoPE_HANDLE     DoPEHdl,
'                                                DoPEOnLineHdlr  Hdlr,
'                                                LPVOID          lpParameter );
'
'    /*
'    Set the OnLine handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        line state change
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
'  extern  unsigned  DLLAPI  DoPESetOnLineRtHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                  DoPEOnLineRtHdlr  Hdlr,
'                                                  LPVOID            lpParameter );
'
'    /*
'    Set the realtime OnLine handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every line state change
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnDataHdlr Lib "dope.dll" Alias "DoPESetOnDataHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnDataHdlr ( DoPE_HANDLE     DoPEHdl,
'                                                DoPEOnDataHdlr  Hdlr,
'                                                LPVOID          lpParameter );
'
'    /*
'    Set the OnData handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received sample
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
'  extern  unsigned  DLLAPI  DoPESetOnDataRtHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                  DoPEOnDataRtHdlr  Hdlr,
'                                                  LPVOID            lpParameter );
'
'    /*
'    Set the realtime OnData handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received sample
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */


Declare Function DoPEVBSetOnDataBlockHdlr Lib "dope.dll" Alias "DoPESetOnDataBlockHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnDataBlockHdlr ( DoPE_HANDLE          DoPEHdl,
'                                                     DoPEOnDataBlockHdlr  Hdlr,
'                                                     LPVOID               lpParameter );
'
'    /*
'    Set the OnDataBlock handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every received sample block
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
'  extern  unsigned  DLLAPI  DoPESetOnDataBlockRtHdlr ( DoPE_HANDLE            DoPEHdl,
'                                                       DoPEOnDataBlockRtHdlr  Hdlr,
'                                                       LPVOID                 lpParameter );
'
'    /*
'    Set the realtime OnDataBlock handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received sample block
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnDataBlockSize Lib "dope.dll" Alias "DoPESetOnDataBlockSize" (ByVal DoPEHdl As Long, ByVal nData As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnDataBlockSize ( DoPE_HANDLE  DoPEHdl,
'                                                     unsigned     nData );
'
'    /*
'    Set the number of measuring data record  to collect in an OnDataBlock.
'
'      In :  DP          DoPE link handle
'            nData       number of samples in a block
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'  extern  unsigned  DLLAPI  DoPEGetOnDataBlockSize ( DoPE_HANDLE  DoPEHdl,
'                                                     unsigned    *nData );
'
'    /*
'    Get the number of measuring data record  to collect in an OnDataBlock.
'
'      In :  DP          DoPE link handle
'            nData       Pointer to storage for number of samples in a block
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnCommandErrorHdlr Lib "dope.dll" Alias "DoPESetOnCommandErrorHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnCommandErrorHdlr ( DoPE_HANDLE             DoPEHdl,
'                                                        DoPEOnCommandErrorHdlr  Hdlr,
'                                                        LPVOID                  lpParameter );
'
'    /*
'    Set the OnCommandError handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received command error message
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
'  extern  unsigned  DLLAPI  DoPESetOnCommandErrorRtHdlr ( DoPE_HANDLE               DoPEHdl,
'                                                          DoPEOnCommandErrorRtHdlr  Hdlr,
'                                                          LPVOID                    lpParameter );
'
'    /*
'    Set the realtime OnCommandError handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received command error message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnPosMsgHdlr Lib "dope.dll" Alias "DoPESetOnPosMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnPosMsgHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                  DoPEOnPosMsgHdlr  Hdlr,
'                                                  LPVOID            lpParameter );
'
'    /*
'    Set the OnPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received positioning message
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
'  extern  unsigned  DLLAPI  DoPESetOnPosMsgRtHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnPosMsgRtHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the realtime OnPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received positioning message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnTPosMsgHdlr Lib "dope.dll" Alias "DoPESetOnTPosMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnTPosMsgHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                   DoPEOnPosMsgHdlr  Hdlr,
'                                                   LPVOID            lpParameter );
'
'    /*
'    Set the OnTPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received trigger positioning message
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
'  extern  unsigned  DLLAPI  DoPESetOnTPosMsgRtHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                     DoPEOnPosMsgRtHdlr  Hdlr,
'                                                     LPVOID              lpParameter );
'
'    /*
'    Set the realtime OnTPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received trigger positioning message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnLPosMsgHdlr Lib "dope.dll" Alias "DoPESetOnLPosMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnLPosMsgHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                   DoPEOnPosMsgHdlr  Hdlr,
'                                                   LPVOID            lpParameter );
'
'    /*
'    Set the OnLPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received limit positioning message
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
'  extern  unsigned  DLLAPI  DoPESetOnLPosMsgRtHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                     DoPEOnPosMsgRtHdlr  Hdlr,
'                                                     LPVOID              lpParameter );
'
'    /*
'    Set the realtime OnLPosMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received limit positioning message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnSftMsgHdlr Lib "dope.dll" Alias "DoPESetOnSftMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnSftMsgHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                  DoPEOnSftMsgHdlr  Hdlr,
'                                                  LPVOID            lpParameter );
'
'    /*
'    Set the OnSftMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received softend message
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
'  extern  unsigned  DLLAPI  DoPESetOnSftMsgRtHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnSftMsgRtHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the realtime OnSftMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received softend message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnOffsCMsgHdlr Lib "dope.dll" Alias "DoPESetOnOffsCMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnOffsCMsgHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnOffsCMsgHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the OnOffsCMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received offset correction message
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
'  extern  unsigned  DLLAPI  DoPESetOnOffsCMsgRtHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnOffsCMsgRtHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the realtime OnOffsCMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received offset correction message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnCheckMsgHdlr Lib "dope.dll" Alias "DoPESetOnCheckMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnCheckMsgHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnCheckMsgHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the OnCheckMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received channel supervision message
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
'  extern  unsigned  DLLAPI  DoPESetOnCheckMsgRtHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnCheckMsgRtHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the realtime OnCheckMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every channel supervision message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnShieldMsgHdlr Lib "dope.dll" Alias "DoPESetOnShieldMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnShieldMsgHdlr ( DoPE_HANDLE          DoPEHdl,
'                                                     DoPEOnShieldMsgHdlr  Hdlr,
'                                                     LPVOID               lpParameter );
'
'    /*
'    Set the OnShieldMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received Shield supervision message
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
'  extern  unsigned  DLLAPI  DoPESetOnShieldMsgRtHdlr ( DoPE_HANDLE            DoPEHdl,
'                                                       DoPEOnShieldMsgRtHdlr  Hdlr,
'                                                       LPVOID                 lpParameter );
'
'    /*
'    Set the realtime OnShieldMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every Shield supervision message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnRefSignalMsgHdlr Lib "dope.dll" Alias "DoPESetOnRefSignalMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnRefSignalMsgHdlr ( DoPE_HANDLE             DoPEHdl,
'                                                        DoPEOnRefSignalMsgHdlr  Hdlr,
'                                                        LPVOID                  lpParameter );
'
'    /*
'    Set the OnRefSignalMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received reference signal message
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
'  extern  unsigned  DLLAPI  DoPESetOnRefSignalMsgRtHdlr ( DoPE_HANDLE               DoPEHdl,
'                                                          DoPEOnRefSignalMsgRtHdlr  Hdlr,
'                                                          LPVOID                    lpParameter );
'
'    /*
'    Set the realtime OnRefSignalMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every reference signal message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnSensorMsgHdlr Lib "dope.dll" Alias "DoPESetOnSensorMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnSensorMsgHdlr ( DoPE_HANDLE          DoPEHdl,
'                                                     DoPEOnSensorMsgHdlr  Hdlr,
'                                                     LPVOID               lpParameter );
'
'    /*
'    Set the OnSensorMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received sensor message
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
'  extern  unsigned  DLLAPI  DoPESetOnSensorMsgRtHdlr ( DoPE_HANDLE            DoPEHdl,
'                                                       DoPEOnSensorMsgRtHdlr  Hdlr,
'                                                       LPVOID                 lpParameter );
'
'    /*
'    Set the realtime OnSensorMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every sensor message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnIoSHaltMsgHdlr Lib "dope.dll" Alias "DoPESetOnIoSHaltMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnIoSHaltMsgHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnIoSHaltMsgHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the OnIoSHaltMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received IO-SHalt message
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
'  extern  unsigned  DLLAPI  DoPESetOnIoSHaltMsgRtHdlr ( DoPE_HANDLE             DoPEHdl,
'                                                        DoPEOnIoSHaltMsgRtHdlr  Hdlr,
'                                                        LPVOID                  lpParameter );
'
'    /*
'    Set the realtime OnIoSHaltMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every IO-SHalt message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnKeyMsgHdlr Lib "dope.dll" Alias "DoPESetOnKeyMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnKeyMsgHdlr ( DoPE_HANDLE       DoPEHdl,
'                                                  DoPEOnKeyMsgHdlr  Hdlr,
'                                                  LPVOID            lpParameter );
'
'    /*
'    Set the OnKeyMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received keyboard message
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
'  extern  unsigned  DLLAPI  DoPESetOnKeyMsgRtHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnKeyMsgRtHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the realtime OnKeyMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every keyboard message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnRuntimeErrorHdlr Lib "dope.dll" Alias "DoPESetOnRuntimeErrorHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnRuntimeErrorHdlr ( DoPE_HANDLE             DoPEHdl,
'                                                        DoPEOnRuntimeErrorHdlr  Hdlr,
'                                                        LPVOID                  lpParameter );
'
'    /*
'    Set the OnRuntimeError handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received runtime error message
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
'  extern  unsigned  DLLAPI  DoPESetOnRuntimeErrorRtHdlr ( DoPE_HANDLE               DoPEHdl,
'                                                          DoPEOnRuntimeErrorRtHdlr  Hdlr,
'                                                          LPVOID                    lpParameter );
'
'    /*
'    Set the realtime OnRuntimeError handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every received runtime error message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnOverflowHdlr Lib "dope.dll" Alias "DoPESetOnOverflowHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnOverflowHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnOverflowHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the OnOverflow handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        sample overflow
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
'  extern  unsigned  DLLAPI  DoPESetOnOverflowRtHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnOverflowRtHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the OnOverflow handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every sample overflow
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSetOnSystemMsgHdlr Lib "dope.dll" Alias "DoPESetOnSystemMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnSystemMsgHdlr ( DoPE_HANDLE          DoPEHdl,
'                                                     DoPEOnSystemMsgHdlr  Hdlr,
'                                                     LPVOID               lpParameter );
'
'    /*
'    Set the OnSystemMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received system message
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
'  extern  unsigned  DLLAPI  DoPESetOnSystemMsgRtHdlr ( DoPE_HANDLE            DoPEHdl,
'                                                       DoPEOnSystemMsgRtHdlr  Hdlr,
'                                                       LPVOID                 lpParameter );
'
'    /*
'    Set the realtime OnSystemMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every system message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetOnDebugMsgHdlr Lib "dope.dll" Alias "DoPESetOnDebugMsgHdlr" (ByVal DoPEHdl As Long, ByVal Hdlr As Long, ByVal lpParameter As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetOnDebugMsgHdlr ( DoPE_HANDLE         DoPEHdl,
'                                                    DoPEOnDebugMsgHdlr  Hdlr,
'                                                    LPVOID              lpParameter );
'
'    /*
'    Set the OnDebugMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called at application priority with every
'                        received Debug message
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
'  extern  unsigned  DLLAPI  DoPESetOnDebugMsgRtHdlr ( DoPE_HANDLE           DoPEHdl,
'                                                      DoPEOnDebugMsgRtHdlr  Hdlr,
'                                                      LPVOID                lpParameter );
'
'    /*
'    Set the realtime OnDebugMsg handler.
'
'      In :  DP          DoPE link handle
'            Hdlr        is called from the high priotity communication thread
'                        with every Debug message
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBThreadPollHdlr Lib "dope.dll" Alias "DoPEThreadPollHdlr" (ByVal DoPEHdl As Long) As Long

'  extern  unsigned DLLAPI DoPEThreadPollHdlr ( DoPE_HANDLE Hdl );
'
'    /*
'    Poll the event handlers.
'
'      In :  DP          DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'

'/* -------------------------------------------------------------------------- */
'
' Windows API function to copy memory.
' Use in DoPEOnDataBlock() and DoPEOnSynchronizeData() handler for DoPEData arrays.

Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDest As Any, pSource As Any, ByVal ByteLen As Long)


