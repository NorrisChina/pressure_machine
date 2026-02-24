Attribute VB_Name = "Event"
Option Explicit

'-----------------------------------------------------------------------------
' Application event handler functions
'-----------------------------------------------------------------------------

'-----------------------------------------------------------------------------
' Global variables
'-----------------------------------------------------------------------------

Public DoPEHdl As Long
Public e As Long

'-----------------------------------------------------------------------------
' install event handler for DoPE messages
'-----------------------------------------------------------------------------

Public Sub InstallEventHdlr(ByVal DoPEHdl As Long)
  ' OnData handler replaced by new OnDataBlock handler
  'e = DoPEVBSetOnDataHdlr(DoPEHdl, AddressOf OnData, ByVal 0&)
  
  ' Set the OnDataBlock handler
  e = DoPEVBSetOnDataBlockHdlr(DoPEHdl, AddressOf OnDataBlock, ByVal 0&)
  ' since the refresh of the label controls occurs on each OnDataBlock event
  ' we increase the number of samples in a block to 300
  e = DoPEVBSetOnDataBlockSize(DoPEHdl, 300)
  
  e = DoPEVBSetOnPosMsgHdlr(DoPEHdl, AddressOf OnPosMsg, ByVal 0&)
  e = DoPEVBSetOnTPosMsgHdlr(DoPEHdl, AddressOf OnTPosMsg, ByVal 0&)
  e = DoPEVBSetOnLPosMsgHdlr(DoPEHdl, AddressOf OnLPosMsg, ByVal 0&)
  e = DoPEVBSetOnCheckMsgHdlr(DoPEHdl, AddressOf OnCheckMsg, ByVal 0&)
  e = DoPEVBSetOnSftMsgHdlr(DoPEHdl, AddressOf OnSftMsg, ByVal 0&)
  e = DoPEVBSetOnCommandErrorHdlr(DoPEHdl, AddressOf OnCommandError, ByVal 0&)
  e = DoPEVBSetOnRuntimeErrorHdlr(DoPEHdl, AddressOf OnRuntimeError, ByVal 0&)
  e = DoPEVBSetOnKeyMsgHdlr(DoPEHdl, AddressOf OnKeyMsg, ByVal 0&)
  e = DoPEVBSetOnSystemMsgHdlr(DoPEHdl, AddressOf OnSystemMsg, ByVal 0&)
  e = DoPEVBSetOnDebugMsgHdlr(DoPEHdl, AddressOf OnDebugMsg, ByVal 0&)
  e = DoPEVBSetOnLineHdlr(DoPEHdl, AddressOf OnLine, ByVal 0&)
  e = DoPEVBSetOnOffsCMsgHdlr(DoPEHdl, AddressOf OnOffsCMsg, ByVal 0&)
  e = DoPEVBSetOnShieldMsgHdlr(DoPEHdl, AddressOf OnShieldMsg, ByVal 0&)
  e = DoPEVBSetOnRefSignalMsgHdlr(DoPEHdl, AddressOf OnRefSignalMsg, ByVal 0&)
  e = DoPEVBSetOnSensorMsgHdlr(DoPEHdl, AddressOf OnSensorMsg, ByVal 0&)
  e = DoPEVBSetOnOverflowHdlr(DoPEHdl, AddressOf OnOverflow, ByVal 0&)
  e = DoPEVBSetOnRmcEventHdlr(DoPEHdl, AddressOf OnRmcEvent, ByVal 0&)
  e = DoPEVBSetOnIoSHaltMsgHdlr(DoPEHdl, AddressOf OnIoSHaltMsg, ByVal 0&)
End Sub

'-----------------------------------------------------------------------------
' Handler for measuring data record block
'-----------------------------------------------------------------------------

Public Function OnDataBlock(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnDataBlock, ByVal lpParameter As Long) As Long
  Dim i As Integer
  Dim Sample As DoPEOnData
  Dim pSample As Long
  Dim Size As Long
  
  If Msg.DoPError = DoPERR_NOERROR Then
    Size = Len(Sample)
    For i = 0 To Msg.nData - 1
      ' copy sample data from DoPE.DLL to VB
      pSample = Msg.Data + (i * Size)
      CopyMemory Sample, ByVal pSample, Size

      ' to do: process new message

      ' show last sample
      If i = Msg.nData - 1 Then
        frmMain.Label1.Caption = Format(Sample.Data.Time, "0.000")
        frmMain.Label2.Caption = Format(Sample.Data.Position, "0.000")
        frmMain.Label3.Caption = Format(Sample.Data.Load, "0.000")
        frmMain.Label4.Caption = Format(Sample.Data.Extension, "0.000")
      End If
    Next
  End If

  ' return value
  OnDataBlock = 0
End Function

' OnData handler replaced by new OnDataBlock handler
''-----------------------------------------------------------------------------
'' Handler for measuring data record
''-----------------------------------------------------------------------------
'
'Public Function OnData(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnData, ByVal lpParameter As Long) As Long
'  Static OldTime As Double
'
'  If Msg.DoPError = DoPERR_NOERROR Then
'    ' to do: process new message
'
'    ' show new data every 0.3 second
'    If (Msg.Data.Time - OldTime >= 0.3) Or (Msg.Data.Time < OldTime) Then
'      frmMain.Label1.Caption = Format(Msg.Data.Time, "0.000")
'      frmMain.Label2.Caption = Format(Msg.Data.Position, "0.000")
'      frmMain.Label3.Caption = Format(Msg.Data.Load, "0.000")
'      frmMain.Label4.Caption = Format(Msg.Data.Extension, "0.000")
'
'      ' save time
'      OldTime = Msg.Data.Time
'    End If
'
'  End If
'
'  ' return value
'  OnData = 0
'End Function

'-----------------------------------------------------------------------------
' Handler for position messages
'-----------------------------------------------------------------------------

Public Function OnPosMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnPosMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg "OnPosMsg: Time=" & Format(Msg.Time, "0.000") & " Ctrl=" & Msg.Control & " Pos=" & Format(Msg.Position, "0.000") & " DCtrl=" & Msg.DControl & " DPos=" & Format(Msg.Destination, "0.000") & " Reached=" & Msg.Reached & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnPosMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for trigger messages
'-----------------------------------------------------------------------------

Public Function OnTPosMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnPosMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg ("OnTPosMsg: Time=" & Format(Msg.Time, "0.000") & " Ctrl=" & Msg.Control & " Pos=" & Format(Msg.Position, "0.000") & " DCtrl=" & Msg.DControl & " DPos=" & Format(Msg.Destination, "0.000") & " Reached=" & Msg.Reached & " TAN=" & Msg.usTAN)
  End If

  ' return value
  OnTPosMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for limit messages
'-----------------------------------------------------------------------------

Public Function OnLPosMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnPosMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg "OnLPosMsg: Time=" & Format(Msg.Time, "0.000") & " Ctrl=" & Msg.Control & " Pos=" & Format(Msg.Position, "0.000") & " DCtrl=" & Msg.DControl & " DPos=" & Format(Msg.Destination, "0.000") & " Reached=" & Msg.Reached & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnLPosMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for check messages
'-----------------------------------------------------------------------------

Public Function OnCheckMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnCheckMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg "OnCheckMsg: Time=" & Format(Msg.Time, "0.000") & " CheckId=" & Msg.CheckId & " SensorNo=" & Msg.SensorNo & " Pos=" & Format(Msg.Position, "0.000") & " Action=" & Msg.Action & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnCheckMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for softend messages
'-----------------------------------------------------------------------------

Public Function OnSftMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnSftMsg, ByVal lpParameter As Long) As Long
  Dim sUpperLower As String

  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    If Msg.Upper Then
      sUpperLower = " Upper"
    Else
      sUpperLower = " Lower"
    End If

    frmMain.WriteMsg "OnSftMsg: Time=" & Format(Msg.Time, "0.000") & " Ctrl=" & Msg.Control & " Pos=" & Format(Msg.Position, "0.000") & sUpperLower & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnSftMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for command errors
'-----------------------------------------------------------------------------

Public Function OnCommandError(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnCommandError, ByVal lpParameter As Long) As Long
  ' to do: process new message
  frmMain.WriteMsg "OnCommandError: CommandNumber=" & Msg.CommandNumber & " ErrorNumber=" & Msg.ErrorNumber & " TAN=" & Msg.usTAN

  ' return value
  OnCommandError = 0
End Function

'-----------------------------------------------------------------------------
' Handler for runtime errors
'-----------------------------------------------------------------------------

Public Function OnRuntimeError(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnRuntimeError, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg "OnRuntimeError: Time=" & Format(Msg.Time, "0.000") & " ErrorNumber=" & Msg.ErrorNumber & " Device=" & Msg.Device & " Bits=" & Msg.Bits & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnRuntimeError = 0
End Function

'-----------------------------------------------------------------------------
' Handler for system messages
'-----------------------------------------------------------------------------

Public Function OnSystemMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnSystemMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    Dim Text As String
    
    Text = Msg.Text
    ' convert null terminated C string to a visual basic string
    Text = NullTrim(Text)
    
    frmMain.WriteMsg "OnSystemMsg: Time=" & Format(Msg.Time, "0.000") & " MsgNumber=" & Msg.MsgNumber & " Text='" & Text & "'"
  End If

  ' return value
  OnSystemMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for system messages
'-----------------------------------------------------------------------------

Public Function OnDebugMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnDebugMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    Dim Text As String
    
    ' convert C char to VB unicode
    Text = StrConv(Msg.Text, vbUnicode)
    
    ' convert null terminated C string to a visual basic string
    Text = NullTrim(Text)
    
    frmMain.WriteMsg "OnDebugMsg: Time=" & Format(Msg.Time, "0.000") & " MsgType=" & Msg.MsgType & " Text='" & Text & "'"
  End If

  ' return value
  OnDebugMsg = 0
End Function

'-----------------------------------------------------------------------------
' Format EDC keys to HEX string
'-----------------------------------------------------------------------------
Public Function KeysToHex(ByRef Keys As INT64) As String
  KeysToHex = Format(Hex(Keys.High), "00000000") & Format(Hex(Keys.Low), "00000000")
End Function

'-----------------------------------------------------------------------------
' Handler for key messages
'-----------------------------------------------------------------------------

Public Function OnKeyMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnKeyMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    ' OEM keys are not displayed here
    frmMain.WriteMsg "OnKeyMsg: Time=" & Format(Msg.Time, "0.000") & " Keys=" & KeysToHex(Msg.Keys) & " TAN=" & Msg.usTAN
  End If

  ' return value
  OnKeyMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for DoPE line state changed events
'-----------------------------------------------------------------------------

Public Function OnLine(ByVal DoPEHdl As Long, ByVal LineState As Long, ByVal lpParameter As Long) As Long
  ' to do: process new message
  frmMain.WriteMsg ("OnLine: LineState=" & LineState)

  ' return value
  OnLine = 0
End Function

'-----------------------------------------------------------------------------
' Handler for offset correction messages
'-----------------------------------------------------------------------------

Public Function OnOffsCMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnOffsCMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg ("OnOffsCMsg: Time=" & Format(Msg.Time, "0.000") & " Offset=" & Format(Msg.Offset, "0.000") & " TAN=" & Msg.usTAN)
  End If

  ' return value
  OnOffsCMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for shield supervision messages
'-----------------------------------------------------------------------------

Public Function OnShieldMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnShieldMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg ("OnShieldMsg: Time=" & Format(Msg.Time, "0.000") & " Action=" & Msg.Action & " SensorNo=" & Msg.SensorNo & " Pos=" & Format(Msg.Position, "0.000") & " TAN=" & Msg.usTAN)
  End If

  ' return value
  OnShieldMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for reference signal messages
'-----------------------------------------------------------------------------

Public Function OnRefSignalMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnRefSignalMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg ("OnRefSignalMsg: Time=" & Format(Msg.Time, "0.000") & " SensorNo=" & Msg.SensorNo & " Pos=" & Format(Msg.Position, "0.000") & " TAN=" & Msg.usTAN)
  End If

  ' return value
  OnRefSignalMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for OnSensorMsg messages
'-----------------------------------------------------------------------------

Public Function OnSensorMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnSensorMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg ("OnSensorMsg: Time=" & Format(Msg.Time, "0.000") & " SensorNo=" & Msg.SensorNo & " Length=" & Msg.Length & " TAN=" & Msg.usTAN)
  End If

  ' return value
  OnSensorMsg = 0
End Function

'-----------------------------------------------------------------------------
' Handler for measuring data and message overlow events
'-----------------------------------------------------------------------------

Public Function OnOverflow(ByVal DoPEHdl As Long, ByVal Msg As Long, ByVal lpParameter As Long) As Long
  ' to do: process new message

  ' return value
  OnOverflow = 0
End Function

'-----------------------------------------------------------------------------
' Handler for OnRmcEvent messages
'-----------------------------------------------------------------------------

Public Function OnRmcEvent(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnRmcEvent, ByVal lpParameter As Long) As Long
  ' to do: process new message
  frmMain.WriteMsg ("OnRmcEvent: Keys=" & KeysToHex(Msg.Keys) & " Leds=" & KeysToHex(Msg.Leds))

  ' return value
  OnRmcEvent = 0
End Function

'-----------------------------------------------------------------------------
' Handler for OnIoSHaltMsg messages
'-----------------------------------------------------------------------------

Public Function OnIoSHaltMsg(ByVal DoPEHdl As Long, ByRef Msg As DoPEOnIoSHaltMsg, ByVal lpParameter As Long) As Long
  If Msg.DoPError = DoPERR_NOERROR Then
    ' to do: process new message
    frmMain.WriteMsg "OnIoSHaltMsg: Time=" & Format(Msg.Time, "0.000") & " Ctrl=" & Msg.Control & " Pos=" & Format(Msg.Position, "0.000") & " Upper=" & Msg.Upper & " TAN=" & Msg.usTAN
  End If
 
  ' return value
  OnIoSHaltMsg = 0
End Function

'-----------------------------------------------------------------------------
' convert null terminated C string to a visual basic string
'-----------------------------------------------------------------------------

Public Function NullTrim(ByVal Text As String) As String
  Dim Pos As Integer

  Pos = InStr(Text, vbNullChar)
  If Pos <> 0 Then
    NullTrim = Left$(Text, Pos - 1)
  Else
    NullTrim = Text
  End If
End Function

'-----------------------------------------------------------------------------
' convert a visual basic string to wide string for DoPEVBwDsp... functions
'-----------------------------------------------------------------------------

Public Function StrToWide(ByVal Text As String) As String
  StrToWide = StrConv(Text, vbUnicode)
End Function
