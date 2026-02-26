Attribute VB_Name = "DoPEilc"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 2006-present
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) ILC handling
'
' Versions:
' ---------
'
' HEG, 23.9.11
' - wrote it.
'
'
'  HEG 27.2.14 - V2.78
'  - New DoPE functions:
'    - DoPEPcCmd
'    - DoPEPcCmdInfo
'
'******************************************************************************
'
'/* -------------------------------------------------------------------------- */

Type DoPEPcCmdInfo                     ' PC Command Information
  BufItemsFree   As Long               ' number of available PcCmdData items [No]
  BufItemsUsed   As Long               ' number of used PcCmdData items      [No]
  BufferUnderrun As Long               ' number of buffer underruns          [No]
  Pad1           As Long               ' internal fill charcters
  PosCtrlTime    As Double             ' Position controller cycle time       [s]
  Paused         As Long               ' PC Command execution paused        [0/1]
End Type

Declare Function DoPEVBRdPcCmdInfo Lib "dope.dll" Alias "DoPERdPcCmdInfo" (ByVal DoPEHdl As Long, ByRef Info As DoPEPcCmdInfo) As Long

'  extern  unsigned  DLLAPI  DoPERdPcCmdInfo  ( DoPE_HANDLE    DoPEHdl,
'                                               DoPEPcCmdInfo *Info);
'
'    /*
'    Read PC Command info.
'
'      In :  DoPEHdl     DoPE link handle
'            Info        Pointer to storage for the PC Cmommand Info structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'// -----------------------------------------------------------------------------
'
'  // Constants for Command Mode
Public Const DoPE_PC_CMD_MODE_POS = 0                 ' Command data are position values for each control loop cycle
Public Const DoPE_PC_CMD_MODE_POS_LINEAR = 1          ' Command data are time and position.
                                                      ' A linear function is interpolated between the position values.
Public Const DoPE_PC_CMD_MODE_POS_COSINE = 2          ' Command data are time and position.
                                                      ' A cosine function is interpolated between the position values.

'  // Constants for ExecuteMode
Public Const DoPE_PC_CMD_EXECUTE_LAST = 0             ' Execute completely stored sequence.
Public Const DoPE_PC_CMD_EXECUTE_APPEND = 1           ' Execute stored sequence, more data will come
Public Const DoPE_PC_CMD_EXECUTE_PAUSE = 2            ' Fadeout and wait for continue
Public Const DoPE_PC_CMD_EXECUTE_CONTINUE = 3         ' Fadein and continue interrupted sequence
Public Const DoPE_PC_CMD_EXECUTE_TERMINATE = 4        ' Terminate a running sequence, (fadeout and stop)


Type DoPEPcCmdData
  Time As Double
  StimulationSignal As Double
End Type

Public Const MAX_PC_CMD_DATA = 1000                  ' max PcCmd data array (only as example; can also be more)

Type VBPcCmdData
  DataEdc(MAX_PC_CMD_DATA - 1) As DoPEPcCmdData
End Type


Declare Function DoPEVBPcCmd Lib "dope.dll" Alias "DoPEPcCmd" (ByVal DoPEHdl As Long, ByVal ExecutionMode As Integer, ByVal MoveCtrl As Integer, ByVal CmdMode As Integer, _
                                                               ByVal SpeedToStart As Double, ByVal Offset As Double, ByVal Scale1 As Double, ByVal OffsetCtrl As Double, _
                                                               ByVal FadeInTime As Double, ByVal FadeOutTime As Double, _
                                                               ByVal Cycles As Long, ByVal Count As Long, _
                                                               ByRef Data As VBPcCmdData, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEPcCmd  ( DoPE_HANDLE     DoPEHdl,
'                                         unsigned short  ExecutionMode,
'                                         unsigned short  MoveCtrl,
'                                         unsigned short  CmdMode,
'                                         double          SpeedToStart,
'                                         double          Offset,
'                                         double          Scale,
'                                         double          OffsetCtrl,
'                                         double          FadeInTime,
'                                         double          FadeOutTime,
'                                         unsigned        Cycles,
'                                         unsigned        Count,
'                                         DoPEPcCmdData  *Data,
'                                         unsigned short *lpusTAN );
'
'    /*
'    Transfer PC Command data to the EDC and initiate execution.
'
'      In :  DoPEHdl       DoPE link handle
'            ExecutionMode Execution mode
'                          DoPE_PC_CMD_EXECUTE_LAST       Execute completely stored sequence.
'                          DoPE_PC_CMD_EXECUTE_APPEND     Execute stored sequence, more data will come
'                          DoPE_PC_CMD_EXECUTE_PAUSE      Fadeout and wait for continue
'                          DoPE_PC_CMD_EXECUTE_CONTINUE   Fadein and continue interrupted sequence
'                          DoPE_PC_CMD_EXECUTE_TERMINATE  Terminate a running sequence, (fadeout and stop)
'            MoveCtrl      Control mode for movement
'            CmdMode       Interpolation mode between the values
'                          DoPE_PC_CMD_MODE_POS        Command data are position values for     each control loop cycle
'                          DoPE_PC_CMD_MODE_POS_LINEAR Command data are time and position.
'                                                      A linear function is interpolated between the position values
'                          DoPE_PC_CMD_MODE_POS_COSINE Command data are time and position.
'                                                      A cosine function is interpolated between the position values
'            SpeedToStart  Speed to Start Position
'            Offset        Offset for stimulation signal
'            Scale         Scaling factor for stimulation signal
'            OffsetCtrl    Offset for move control channel
'            FadeInTime    Fade in time
'            FadeOutTime   Fade out time
'            Cycles        Number of cycles
'            Count         Number of PcCmdData items
'            Data          Pointer to PcCmdData array
'                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'// -----------------------------------------------------------------------------
'
Declare Function DoPEVBPcCmdFromFile Lib "dope.dll" Alias "DoPEPcCmdFromFile" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal CmdMode As Integer, _
                                                                               ByVal SpeedToStart As Double, ByVal Offset As Double, ByVal Scale1 As Double, ByVal OffsetCtrl As Double, _
                                                                               ByVal FadeInTime As Double, ByVal FadeOutTime As Double, _
                                                                               ByVal Cycles As Long, ByVal Column As Long, _
                                                                               ByVal FileName As String, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEPcCmdFromFile  ( DoPE_HANDLE     DoPEHdl,
'                                                 unsigned short  MoveCtrl,
'                                                 unsigned short  CmdMode,
'                                                 double          SpeedToStart,
'                                                 double          Offset,
'                                                 double          Scale,
'                                                 double          OffsetCtrl,
'                                                 double          FadeInTime,
'                                                 double          FadeOutTime,
'                                                 unsigned        Cycles,
'                                                 unsigned        Column,
'                                                 char           *FileName,
'                                                 unsigned short *lpusTAN );
'
'
'    /*
'    Transfer PC Command data from a file to the EDC and initiate execution.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode for movement (Position, Load, Extension)
'            CmdMode       Interpolation mode between the values
'                          DoPE_PC_CMD_MODE_POS        Command data are position values for     each control loop cycle
'                          DoPE_PC_CMD_MODE_POS_LINEAR Command data are time and position.
'                                                      A linear function is interpolated between the position values
'                          DoPE_PC_CMD_MODE_POS_COSINE Command data are time and position.
'                                                      A cosine function is interpolated between the position values
'            SpeedToStart  Speed to Start Position
'            Offset        Offset for stimulation signal
'            Scale         Scaling factor for stimulation signal
'            OffsetCtrl    Offset for move control channel
'            FadeInTime    Fade in time
'            FadeOutTime   Fade out time
'            Cycles        Number of cycles
'            Column        Column number of Stimulation Signal
'                          In interpolation modes Time has always column number 0
'            FileName      Pointer to file name and path.
'                          Supported file types:
'                            csv  "Comma Separated Values" text file:
'                                 Value separator must be ';'
'                                 Decimal point can be '.' or ','
'                                 Lines NOT starting with a number or a separator will be skipped
'                            bmv "DOLI Binary Measured Values" file:
'                                 generated by DoPE TestCenter version 2.27.1 (or above)
'                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
