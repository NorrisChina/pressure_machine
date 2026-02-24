'-----------------------------------------------------------------------------
' 
' Project:     DoPENet - Demo
' Description: Demo project for DoPE .NET
' 
' (C) DOLI Elektronik GmbH, 2010-present
' 
' Author:   Benjamin Fröhlich
'  
'Changes :
'=========
' 
' PET 29.07.2011 - V2.0
' - C# demo converted.
'
' PET 01.12.2011 - V2.1
' - IOSHalt message handler added.
' - edc.Rmc.Enable removed from demo.
'
' PET 06.02.2012 - V2.2
' - DoPE V2.72
'
' PET 30.07.2012 - V2.3
' - DoPE V2.73
'
' PET 01.10.2012 - V2.74
' - DoPE V2.74
' - Error on Windows x64. Solution platform changed to x86.
'
' PET 11.01.2013 - V2.75
' - DoPE V2.75
' - Switched to Visual Studio 2012 Express.
'
' PET 26.07.2013 - V2.76
' - DoPE V2.76
'
' PET 15.11.2013 - V2.77
' - DoPE V2.77
'
' PET 07.03.2014 - V2.78
' - DoPE V2.78
'
' PET 27.03.2014 - V2.79
' - DoPE V2.79
'
' HEG 27.10.2014 - V2.80
' - DoPE V2.80
' - Simplified demo
' - OnDataBlock handler implemented
'
' PET 14.03.2016 - V2.83
' - DoPE V2.83
' - edc.Rmc.Enable added to demo.
'
' PET 18.08.2016 - V2.84
' - DoPE V2.84
'
' HEG 06.10.2017 - V2.85
' - DoPE V2.85
' - edc.Rmc.Enable caused an exception. Bug fixed.
'
' HEG 16.10.2017 - V2.86
' - DoPE V2.86
' - New modbus temperature controller.
'
' HEG 02.11.2017 - V2.87
' - DoPE V2.87
'
' HEG 25.06.2018 - V2.88
' - DoPE V2.88
'
'-------------------------------------------------------------------------------

' True enables OnDataBlock handler, False enables OnData handler
#Const ONDATABLOCK = False

Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Data
Imports System.Drawing
Imports System.Text
Imports System.Windows.Forms
Imports System.Runtime.InteropServices
Imports Doli.DoPE

' To use DoPE .NET in your own project, the following files must be in your .exe directory:
' - DoPE.dll
' - DoDpx.dll
' - DoPENet.dll
'
' In your project, you also need to add a reference for the files
' - DoPENet.dll
'
' How to add a reference?
' - In Solution Explorer, right-click on the project node and click Add Reference.
' - In the Add Reference dialog box, select the "Browse"-tab and choose the DoPENet.dll
' - Click the OK-Button.

''' <summary>
''' Demo-application for the DoPE .NET library.
''' </summary>
Public Class MainForm
  Inherits Form

#Region "Initialization"

  ''' <summary>
  ''' Represents one EDC.
  ''' This object is needed to perform DoPE tasks.
  ''' (Similar to the DoPE-handle in C++.)
  ''' </summary>
  Private MyEdc As Edc

  ''' <summary>
  ''' TAN number assigned to a DoPE command.
  ''' (To get informed when this task has been performed.)
  ''' </summary>
  Private MyTan As Short

  ''' <summary>
  ''' Just an error constant string which is used
  ''' when the EDC could not be initialized correctly.
  ''' </summary>
  Private Const CommandFailedString As String = "Command failed. Please make sure, that the Edc is successfully initialized. " & vbLf


  '''----------------------------------------------------------------------
  ''' <summary>FormShown initialzes GUI and starts communication with EDC</summary>
  '''----------------------------------------------------------------------
  Private Sub MainForm_Shown(sender As Object, e As EventArgs) Handles MyBase.Shown
    ' show GUI
    Application.DoEvents()

    ' show DoPE.Ctrl enum members in guiControl combo-box.
    guiControl.DataSource = [Enum].GetNames(GetType(DoPE.CTRL))
    guiControl.MaxDropDownItems = guiControl.Items.Count

    ' Set the control-combobox to "position".
    guiControl.SelectedIndex = CInt(DoPE.CTRL.POS)

    ' Connect to EDC
    ConnectToEdc()
  End Sub


    ''' ----------------------------------------------------------------------
    ''' <summary>Connect to EDC</summary>
    ''' ----------------------------------------------------------------------
  Private Sub ConnectToEdc()
    ' tell DoPE which DoPENet.dll and DoPE.dll version we are using
    ' THE API CANNOT BE USED WITHOUT THIS CHECK !
    DoPE.CheckApi("2.91")

    Cursor.Current = Cursors.WaitCursor

    Try
      Dim [error] As DoPE.ERR

      ' open the first EDC found on this PC
      MyEdc = New Edc(DoPE.OpenBy.DeviceId, 0)

      ' hang in event-handler to receive DoPE-events
      AddHandler MyEdc.Eh.OnLineHdlr, New DoPE.OnLineHdlr(AddressOf OnLine)
#If ONDATABLOCK Then
      AddHandler MyEdc.Eh.OnDataBlockHdlr, New DoPE.OnDataBlockHdlr(AddressOf OnDataBlock)
      ' Set number of samples for OnDataBlock events
      ' (with 1 ms data refresh rate this leads to a
      '  display refresh every 300 ms)
      [error] = MyEdc.Eh.SetOnDataBlockSize(300)
      DisplayError([error], "SetOnDataBlockSize")
#Else
      AddHandler MyEdc.Eh.OnDataHdlr, New DoPE.OnDataHdlr(AddressOf OnData)
#End If
      AddHandler MyEdc.Eh.OnCommandErrorHdlr, New DoPE.OnCommandErrorHdlr(AddressOf OnCommandError)
      AddHandler MyEdc.Eh.OnPosMsgHdlr, New DoPE.OnPosMsgHdlr(AddressOf OnPosMsg)
      AddHandler MyEdc.Eh.OnTPosMsgHdlr, New DoPE.OnTPosMsgHdlr(AddressOf OnTPosMsg)
      AddHandler MyEdc.Eh.OnLPosMsgHdlr, New DoPE.OnLPosMsgHdlr(AddressOf OnLPosMsg)
      AddHandler MyEdc.Eh.OnSftMsgHdlr, New DoPE.OnSftMsgHdlr(AddressOf OnSftMsg)
      AddHandler MyEdc.Eh.OnOffsCMsgHdlr, New DoPE.OnOffsCMsgHdlr(AddressOf OnOffsCMsg)
      AddHandler MyEdc.Eh.OnCheckMsgHdlr, New DoPE.OnCheckMsgHdlr(AddressOf OnCheckMsg)
      AddHandler MyEdc.Eh.OnShieldMsgHdlr, New DoPE.OnShieldMsgHdlr(AddressOf OnShieldMsg)
      AddHandler MyEdc.Eh.OnRefSignalMsgHdlr, New DoPE.OnRefSignalMsgHdlr(AddressOf OnRefSignalMsg)
      AddHandler MyEdc.Eh.OnSensorMsgHdlr, New DoPE.OnSensorMsgHdlr(AddressOf OnSensorMsg)
      AddHandler MyEdc.Eh.OnKeyMsgHdlr, New DoPE.OnKeyMsgHdlr(AddressOf OnKeyMsg)
      AddHandler MyEdc.Eh.OnRuntimeErrorHdlr, New DoPE.OnRuntimeErrorHdlr(AddressOf OnRuntimeError)
      AddHandler MyEdc.Eh.OnOverflowHdlr, New DoPE.OnOverflowHdlr(AddressOf OnOverflow)
      AddHandler MyEdc.Eh.OnSystemMsgHdlr, New DoPE.OnSystemMsgHdlr(AddressOf OnSystemMsg)
      AddHandler MyEdc.Eh.OnRmcEventHdlr, New DoPE.OnRmcEventHdlr(AddressOf OnRmcEvent)
      AddHandler MyEdc.Eh.OnIoSHaltMsgHdlr, New DoPE.OnIoSHaltMsgHdlr(AddressOf OnIoSHaltMsg)

      ' Set UserScale
      Dim UserScale As New DoPE.UserScale()
      ' set position and extension scale to mm
      UserScale(DoPE.SENSOR.SENSOR_S) = 1000
      UserScale(DoPE.SENSOR.SENSOR_E) = 1000

      ' Select machine setup and initialize
      [error] = MyEdc.Setup.SelSetup(DoPE.SETUP_NUMBER.SETUP_1, UserScale, MyTan, MyTan)
      If [error] <> DoPE.ERR.NOERROR Then
        DisplayError([error], "SelectSetup")
      Else
        Display("SelectSetup : OK !" & vbLf)
      End If

      ' enable DoPE RMC handling
      MyEdc.Rmc.Enable(-1, -1)

    Catch ex As DoPEException
      ' During the initialization and the
      ' shut-down phase a DoPE Exception can arise.
      ' Other errors are reported by the DoPE
      ' error return codes.
      Display(String.Format("{0}" & vbLf, ex))
    End Try

    Cursor.Current = Cursors.Default
  End Sub

#End Region

#Region "GUI"

  '''----------------------------------------------------------------------
  ''' <summary>
  ''' Formates and displays DoPE-errors.
  ''' </summary>
  ''' <param name="error">the dope error to display</param>
  ''' <param name="Text">additional text to display</param>
  '''----------------------------------------------------------------------
  Private Sub DisplayError(ByVal [error] As DoPE.ERR, ByVal Text As String)
    If [error] <> DoPE.ERR.NOERROR Then
      Display(Text & " Error: " & Convert.ToString([error]) & vbLf)
    End If
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Display debug text</summary>
  '''----------------------------------------------------------------------
  Private Sub Display(ByVal Text As String)
    guiDebug.AppendText(Text)
    Refresh()
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Activates the EDC's drive.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiOn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiOn.Click
    Try
      Dim [error] As DoPE.ERR = MyEdc.Move.[On]()
      DisplayError([error], "On")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Deactivates the EDC's drive.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiOff_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiOff.Click
    Try
      Dim [error] As DoPE.ERR = MyEdc.Move.Off()
      DisplayError([error], "Off")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Sends a move-command with direction "up" to the EDC.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiUp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiUp.Click
    Try
      Dim [error] As DoPE.ERR = MyEdc.Move.FDPoti(DoPE.CTRL.POS, 0, DoPE.SENSOR.SENSOR_DP, 3, DoPE.EXT.SPEED_UP, 2, MyTan)
      DisplayError([error], "FDPoti")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Sends a halt-command to the EDC.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiHalt_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiHalt.Click
    Try
      Dim [error] As DoPE.ERR = MyEdc.Move.Halt(DoPE.CTRL.POS, MyTan)
      DisplayError([error], "Halt")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Sends a move-command with direction "down" to the EDC.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiDown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiDown.Click
    Try
      Dim [error] As DoPE.ERR = MyEdc.Move.FDPoti(DoPE.CTRL.POS, 0, DoPE.SENSOR.SENSOR_DP, 3, DoPE.EXT.SPEED_DOWN, 2, MyTan)
      DisplayError([error], "FDPoti")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>
  ''' Sends a move command to the EDC. The command-parameters
  ''' are copied from the user-interface.
  ''' </summary>
  '''----------------------------------------------------------------------
  Private Sub guiPos_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles guiPos.Click
    Dim control As DoPE.CTRL
    Dim speed As Double
    Dim destination As Double

    Try
      control = CType(guiControl.SelectedIndex, DoPE.CTRL)
      speed = Convert.ToDouble(guiSpeed.Text)
      destination = Convert.ToDouble(guiDestination.Text)

      Dim [error] As DoPE.ERR = MyEdc.Move.Pos(control, speed, destination, MyTan)
      DisplayError([error], "Pos")
    Catch generatedExceptionName As NullReferenceException
      Display(CommandFailedString)
    End Try
  End Sub

  '''----------------------------------------------------------------------
  ''' <summary>Sets the correct units depending on the selected control-mode.</summary>
  '''----------------------------------------------------------------------
  Private Sub guiControl_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles guiControl.SelectedIndexChanged
    Dim control As DoPE.CTRL = CType(guiControl.SelectedIndex, DoPE.CTRL)

    Select Case control
      Case DoPE.CTRL.POS
        lblSpeedUnit.Text = "mm/s"
        lblDestinationUnit.Text = "mm"
        Exit Select
      Case DoPE.CTRL.LOAD
        lblSpeedUnit.Text = "N/s"
        lblDestinationUnit.Text = "N"
        Exit Select
      Case DoPE.CTRL.EXTENSION
        lblSpeedUnit.Text = "mm/s"
        lblDestinationUnit.Text = "mm"
        Exit Select
      Case Else
        lblSpeedUnit.Text = "Unit/s"
        lblDestinationUnit.Text = "Unit"
        Exit Select
    End Select
  End Sub

#End Region

#Region "DoPE Events"

#If ONDATABLOCK Then
  Private Function OnDataBlock(ByRef Block As DoPE.OnDataBlock, ByVal Parameter As Object) As Integer
    If Block.DoPError = DoPE.ERR.NOERROR Then
      If Block.nData >= 1 Then
        Dim Sample As DoPE.Data = Block.Data(Block.nData - 1).Data

        guiTime.Text = [String].Format("{0}", Sample.Time.ToString("0.000"))
        guiPosition.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_S)).ToString("0.000"))
        guiLoad.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_F)).ToString("0.000"))
        guiExtension.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_E)).ToString("0.000"))
      End If
    End If

    Return 0
  End Function
#Else
  Private LastTime As Int32 = Environment.TickCount

  Private Function OnData(ByRef Data As DoPE.OnData, ByVal Parameter As Object) As Integer
    Dim Time As Int32 = Environment.TickCount
    If (Time - LastTime) >= 300 Then
      LastTime = Time
      Dim Sample As DoPE.Data = Data.Data

      guiTime.Text = [String].Format("{0}", Sample.Time.ToString("0.000"))
      guiPosition.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_S)).ToString("0.000"))
      guiLoad.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_F)).ToString("0.000"))
      guiExtension.Text = [String].Format("{0}", Sample.Sensor(CInt(DoPE.SENSOR.SENSOR_E)).ToString("0.000"))
    End If
    Return 0
  End Function
#End If

  Private Function OnLine(ByVal LineState As DoPE.LineState, ByVal Parameter As Object) As Integer
    Display(String.Format("OnLine: {0}" & vbLf, LineState))
    Return 0
  End Function

  Private Function OnCommandError(ByRef CommandError As DoPE.OnCommandError, ByVal Parameter As Object) As Integer
    Display(String.Format("OnCommandError: CommandNumber={0} ErrorNumber={1} usTAN={2} " & vbLf, _
                          CommandError.CommandNumber, CommandError.ErrorNumber, CommandError.usTAN))
    Return 0
  End Function

  Private Function OnPosMsg(ByRef PosMsg As DoPE.OnPosMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} " & vbLf, _
                          PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN))
    Return 0
  End Function

  Private Function OnTPosMsg(ByRef PosMsg As DoPE.OnPosMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnTPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} " & vbLf, _
                          PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN))
    Return 0
  End Function

  Private Function OnLPosMsg(ByRef PosMsg As DoPE.OnPosMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnLPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} " & vbLf, _
                          PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN))
    Return 0
  End Function

  Private Function OnSftMsg(ByRef SftMsg As DoPE.OnSftMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnSftMsg: DoPError={0} Upper={1} Time={2} Control={3} Position={4} usTAN={5} " & vbLf, _
                          SftMsg.DoPError, SftMsg.Upper, SftMsg.Time, SftMsg.Control, SftMsg.Position, SftMsg.usTAN))
    Return 0
  End Function

  Private Function OnOffsCMsg(ByRef OffsCMsg As DoPE.OnOffsCMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnOffsCMsg: DoPError={0} Time={1} Offset={2} usTAN={3} " & vbLf, _
                          OffsCMsg.DoPError, OffsCMsg.Time, OffsCMsg.Offset, OffsCMsg.usTAN))
    Return 0
  End Function

  Private Function OnCheckMsg(ByRef CheckMsg As DoPE.OnCheckMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnCheckMsg: DoPError={0} Action={1} Time={2} CheckId={3} Position={4} SensorNo={5} usTAN={6} " & vbLf, _
                          CheckMsg.DoPError, CheckMsg.Action, CheckMsg.Time, CheckMsg.CheckId, CheckMsg.Position, CheckMsg.SensorNo, CheckMsg.usTAN))
    Return 0
  End Function

  Private Function OnShieldMsg(ByRef ShieldMsg As DoPE.OnShieldMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnShieldMsg: DoPError={0} Action={1} Time={2} SensorNo={3} Position={4} usTAN={5} " & vbLf, _
                          ShieldMsg.DoPError, ShieldMsg.Action, ShieldMsg.Time, ShieldMsg.SensorNo, ShieldMsg.Position, ShieldMsg.usTAN))
    Return 0
  End Function

  Private Function OnRefSignalMsg(ByRef RefSignalMsg As DoPE.OnRefSignalMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnRefSignalMsg: DoPError={0} Time={1} SensorNo={2} Position={3} usTAN={4} " & vbLf, _
                          RefSignalMsg.DoPError, RefSignalMsg.Time, RefSignalMsg.SensorNo, RefSignalMsg.Position, RefSignalMsg.usTAN))
    Return 0
  End Function

  Private Function OnSensorMsg(ByRef SensorMsg As DoPE.OnSensorMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnSensorMsg: DoPError={0} Time={1} SensorNo={2} usTAN={3} " & vbLf, _
                          SensorMsg.DoPError, SensorMsg.Time, SensorMsg.SensorNo, SensorMsg.usTAN))
    Return 0
  End Function

  Private Function OnKeyMsg(ByRef KeyMsg As DoPE.OnKeyMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnKeyMsg: DoPError={0} Time={1} Keys={2} NewKeys={3} GoneKeys={4} OemKeys={5} NewOemKeys={6} GoneOemKeys={7} usTAN={8} " & vbLf, _
                          KeyMsg.DoPError, KeyMsg.Time, KeyMsg.Keys, KeyMsg.NewKeys, KeyMsg.GoneKeys, KeyMsg.OemKeys, KeyMsg.NewOemKeys, KeyMsg.GoneOemKeys, KeyMsg.usTAN))
    Return 0
  End Function

  Private Function OnRuntimeError(ByRef RuntimeError As DoPE.OnRuntimeError, ByVal Parameter As Object) As Integer
    Display(String.Format("OnRuntimeError: DoPError={0} ErrorNumber={1} Time={2} Device={3} Bits={4} usTAN={5} " & vbLf, _
                          RuntimeError.DoPError, RuntimeError.ErrorNumber, RuntimeError.Time, RuntimeError.Device, RuntimeError.Bits, RuntimeError.usTAN))
    Return 0
  End Function

  Private Function OnOverflow(ByVal Overflow As Integer, ByVal Parameter As Object) As Integer
    Display(String.Format("OnOverflow: Overflow={0} " & vbLf, Overflow))
    Return 0
  End Function

  Private Function OnSystemMsg(ByRef SystemMsg As DoPE.OnSystemMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnSystemMsg: DoPError={0} MsgNumber={1} Time={2} Text={3} " & vbLf, _
                          SystemMsg.DoPError, SystemMsg.MsgNumber, SystemMsg.Time, SystemMsg.Text))
    Return 0
  End Function

  Private Function OnRmcEvent(ByRef RmcEvent As DoPE.OnRmcEvent, ByVal Parameter As Object) As Integer
    Display(String.Format("OnRmcEvent: Keys={0} NewKeys={1} GoneKeys={2} Leds={3} NewLeds={4} GoneLeds={5} " & vbLf, _
                          RmcEvent.Keys, RmcEvent.NewKeys, RmcEvent.GoneKeys, RmcEvent.Leds, RmcEvent.NewLeds, RmcEvent.GoneLeds))
    Return 0
  End Function

  Private Function OnIoSHaltMsg(ByRef IoSHaltMsg As DoPE.OnIoSHaltMsg, ByVal Parameter As Object) As Integer
    Display(String.Format("OnIoSHaltMsg: DoPError={0} Upper={1} Time={2} Control={3} Position={4} usTAN={5} " & vbLf, _
                          IoSHaltMsg.DoPError, IoSHaltMsg.Upper, IoSHaltMsg.Time, IoSHaltMsg.Control, IoSHaltMsg.Position, IoSHaltMsg.usTAN))
    Return 0
  End Function

#End Region

End Class
