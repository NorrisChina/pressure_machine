VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Visual Basic DoPE Demo"
   ClientHeight    =   7785
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   12150
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7785
   ScaleWidth      =   12150
   StartUpPosition =   1  'CenterOwner
   Begin VB.ComboBox cmbControl 
      Height          =   315
      ItemData        =   "frmMain.frx":0000
      Left            =   3720
      List            =   "frmMain.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   21
      Top             =   960
      Width           =   1575
   End
   Begin VB.TextBox txtDestination 
      Height          =   285
      Left            =   3720
      TabIndex        =   18
      Text            =   "0"
      Top             =   1680
      Width           =   1575
   End
   Begin VB.TextBox txtSpeed 
      Height          =   285
      Left            =   3720
      TabIndex        =   17
      Text            =   "5"
      Top             =   1320
      Width           =   1575
   End
   Begin VB.CommandButton btnPos 
      Caption         =   "Pos"
      Height          =   495
      Left            =   1920
      TabIndex        =   14
      Top             =   960
      Width           =   615
   End
   Begin VB.CommandButton btnDown 
      Caption         =   "Down"
      Height          =   495
      Left            =   840
      TabIndex        =   5
      Top             =   1920
      Width           =   615
   End
   Begin VB.CommandButton btnStop 
      Caption         =   "Stop"
      Height          =   495
      Left            =   840
      TabIndex        =   4
      Top             =   1440
      Width           =   615
   End
   Begin VB.CommandButton btnUp 
      Caption         =   "Up"
      Height          =   495
      Left            =   840
      TabIndex        =   3
      Top             =   960
      Width           =   615
   End
   Begin VB.CommandButton btnEdcOff 
      Caption         =   "Off"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   615
   End
   Begin VB.CommandButton btnEdcOn 
      Caption         =   "On"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   960
      Width           =   615
   End
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   5175
      Left            =   120
      TabIndex        =   0
      Top             =   2520
      Width           =   11895
      _ExtentX        =   20981
      _ExtentY        =   9128
      _Version        =   393217
      Enabled         =   -1  'True
      ReadOnly        =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"frmMain.frx":0004
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label Label11 
      Caption         =   "Control"
      Height          =   255
      Left            =   2640
      TabIndex        =   22
      Top             =   960
      Width           =   1095
   End
   Begin VB.Label txtDestinationUnit 
      Caption         =   "mm"
      Height          =   255
      Left            =   5400
      TabIndex        =   20
      Top             =   1680
      Width           =   495
   End
   Begin VB.Label txtSpeedUnit 
      Caption         =   "mm/s"
      Height          =   255
      Left            =   5400
      TabIndex        =   19
      Top             =   1320
      Width           =   495
   End
   Begin VB.Label Label10 
      Caption         =   "Destination"
      Height          =   255
      Left            =   2640
      TabIndex        =   16
      Top             =   1680
      Width           =   1095
   End
   Begin VB.Label Label9 
      Caption         =   "Speed"
      Height          =   255
      Left            =   2640
      TabIndex        =   15
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label8 
      Alignment       =   2  'Center
      Caption         =   "Extension [mm]"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5520
      TabIndex        =   13
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label7 
      Alignment       =   2  'Center
      Caption         =   "Load [N]"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3720
      TabIndex        =   12
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      Caption         =   "Position [mm]"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1920
      TabIndex        =   11
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      Caption         =   "Time [s]"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   10
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "-0000.000"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   345
      Left            =   5520
      TabIndex        =   9
      Top             =   480
      Width           =   1695
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "-0000.000"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   345
      Left            =   3720
      TabIndex        =   8
      Top             =   480
      Width           =   1695
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "-0000.000"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   345
      Left            =   1920
      TabIndex        =   7
      Top             =   480
      Width           =   1695
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "-0000.000"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   345
      Left            =   120
      TabIndex        =   6
      Top             =   480
      Width           =   1695
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH
'
' 32 Bit Visual Basic demo programm for DoPE (DOLI PC-EDC) event handler interface
'
' Versions:
' ---------
' V 1.0.0  14.06.2004  PET
' - Inital version.
'
' V 1.1.0  10.12.2004  PET
'  - NEW: DoPE header V2.29 included
'  - NEW: 'Halt' changed to 'Stop'.
'  - NEW: 'Off' uses the new DoPE command DoPEOff.
'  - NEW: some changes for better VB.NET compability.
'
' V 1.2.0  03.03.2005  PET
'  - NEW: DoPE header V2.30 included
'
' V 1.3.0  08.07.2005  PET
'  - NEW: DoPE header V2.32 included
'
' V 1.4.0  18.07.2006  PET
'  - NEW: DoPE header V2.51 included
'  - NEW: DoPE key interface included
'  - NEW: DoPE synchronize interface included
'  - NEW: EDC220/EDC580
'
' V 1.5.0  24.07.2006  PET
'  - NEW: DoPE header V2.52 included
'  - NEW: DoPE key interface included
'  - NEW: DoPE synchronize interface included
'  - FIX: Error fixed, if no WinPcap is installed.
'
' V 1.6.0  31.07.2006  PET
'  - NEW: DoPEVBRdKeyShiftState() in DoPEkey.bas
'  - FIX: Val() replaced by CStr() (international decimal point handling).
'
' V 1.7.0  07.09.2006  PET
'  - NEW: DoPE header V2.53 included
'
' V 1.8.0  21.11.2006  PET
'  - NEW: DoPE header V2.54 included
'  - NEW: DoDPX V7.01 included
'
' V 1.9.0  08.05.2007  PET
'  - NEW: DoPE header V2.55 included
'
' V 1.10.0  16.05.2007  PET
'  - NEW: DoPE header V2.56 included
'  - NEW: DoDPX V7.02 included
'
' V 1.11.0  09.07.2007  PET
'  - NEW: DoPE header V2.58 included
'  - NEW: DoDPX V7.04 included
'
' V 1.12.0  21.01.2008  PET
'  - NEW: DoPE header V2.59 included
'
' V 1.13.0  31.01.2008  PET
'  - NEW: DoPE header V2.60 included
'
' V 1.14.0  04.08.2008  PET
'  - NEW: DoPE header V2.62 included
'
' V 1.15.0  27.10.2008  PET
'  - NEW: DoPE header V2.63 included
'  - NEW: DoDPX V7.06 included
'
' V 1.16.0  05.02.2009  PET
'  - NEW: DoPE header V2.64 included
'
' V 2.65  30.06.2009  PET
' - NEW: DoPE V2.65
' - NEW: Now DoPE version is shown on window caption
' - NEW: Message handler added:
'        OnLine, OnTPosMsg, OnOffsCMsg, OnShieldMsg, OnRefSignalMsg,
'        OnSensorMsg, OnOverflow, OnSystemMsg
' - NEW: NullTrim()
' - NEW: StrToWide()
' - NEW: Now DoPEVBOpenDeviceID() is used. frmComSettings removed.
' - NEW: Measured value display moved to OnData(). Timer removed.
'
' V 2.66  14.12.2009  PET
' - NEW: DoPE V2.66
' - NEW: Dpx V8.00
'
' V 2.68  05.08.2010  PET
' - NEW: DoPE V2.68
' - NEW: Dpx V8.03 supports Windows 7 (32/64 bit)
' - FIX: Fatal error in OnSystemMsg() fixed.
'
' V 2.69 03.12.2010  PET
' - NEW: DoPE V2.69
'
' V 2.70 29.07.2011  PET
' - NEW: DoPE V2.70
' - NEW: OnRmcEvent handler added.
'
' V 2.71 02.12.2011  PET
' - NEW: DoPE V2.71
' - NEW: OnIoSHaltMsg handler added.
' - NEW: DoPEilc.bas and DoPEstiffcorr.bas added
' - NEW: DoPEVBRmcEnable removed from demo
'
' V 2.72 06.02.2012  PET
' - NEW: DoPE V2.72
'
' V 2.73 30.07.2012  PET
' - NEW: DoPE V2.73
'
' V 2.74 28.09.2012  PET
' - NEW: DoPE V2.74
'
' V 2.75 11.01.2013  PET
' - NEW: DoPE V2.75
'
' V 2.76 27.07.2013  PET
' - NEW: DoPE V2.76
'
' V 2.77 14.11.2013  PET
' - NEW: DoPE V2.77
'
' V 2.78 07.03.2014  PET
' - NEW: DoPE V2.78
'
' V 2.79 27.03.2014  PET
' - NEW: DoPE V2.79
'
' V 2.81 19.11.2014  PET
' - NEW: DoPE V2.81
' - NEW: OnData handler replaced by new OnDataBlock handler
'
' V 2.82 01.10.2015  PET
' - NEW: DoPE V2.82
'
' V 2.83 14.03.2016  PET
' - NEW: DoPE V2.83
'
' V 2.84 18.08.2016  PET
' - NEW: DoPE V2.84
'
' V 2.85  27.06.2017  PET
' - NEW: DoPE V2.85
' - NEW: Dpx V8.08
'
' V 2.86  16.10.2017  PET
' - NEW: DoPE V2.86
'
' V 2.87  02.11.2017  PET
' - NEW: DoPE V2.87
'
' V 2.88  26.06.2018  PET
' - NEW: DoPE V2.88
'
' V 2.89  23.08.2018  PET
' - NEW: DoPE V2.89
'
' V 2.90  11.10.2019  PET
' - NEW: DoPE V2.90
'
' V 2.91  27.02.2020  PET
' - NEW: DoPE V2.91
'
'******************************************************************************

Public Sub WriteMsg(Msg As String)
  ' display text
  RichTextBox1.Text = RichTextBox1.Text & Msg & vbCrLf
  ' position cursor at the end
  RichTextBox1.SelStart = Len(RichTextBox1.Text)
  RichTextBox1.Refresh
End Sub

Private Sub OpenLink()
  ' open link to EDC
  Dim i As Integer
  Dim sDeviceID As String
  Dim UserScale(MAX_MC - 1) As Double

  Refresh
  ' search for EDC and open link to EDC
  e = DoPEVBOpenDeviceID(0, 100&, 100&, 10000&, DoPEAPIVERSION, ByVal 0&, DoPEHdl)

  If Not e = DoPERR_NOERROR Then
    ' error opening link to EDC
    WriteMsg "ERROR " & e & ": DoPEVBOpenDeviceID"
    Exit Sub
  End If
  WriteMsg "DoPEVBOpenDeviceID OK"

  ' install event handler for DoPE messages
  InstallEventHdlr (DoPEHdl)
  
  Refresh
  ' set UserScale for all channels to 1.0
  For i = 0 To MAX_MC - 1
    UserScale(i) = 1#
  Next
  ' set UserScale for position and extension to 1000.0 [mm]
  UserScale(0) = 1000#
  UserScale(2) = 1000#

  ' select Setup No. 1 and initialize EDC
  WriteMsg "DoPEVBSelSetup 1. Please wait..."
  e = DoPEVBSelSetup(DoPEHdl, 1, UserScale(0), ByVal 0&, ByVal 0&)
  
  If Not e = DoPERR_NOERROR Then
    ' error select setup
    WriteMsg "ERROR " & e & ": Select setup 1"
  Else
    WriteMsg "DoPEVBSelSetup 1 OK"
  End If
End Sub

Private Sub CloseLink()
  ' close link to EDC, if open
  If DoPEHdl <> 0 Then
    e = DoPEVBCloseLink(DoPEHdl)
  End If
End Sub

Private Sub btnEdcOn_Click()
  ' switch on EDC
  e = DoPEVBOn(DoPEHdl, ByVal 0&)
End Sub

Private Sub btnEdcOff_Click()
  ' switch off EDC
  e = DoPEVBOff(DoPEHdl, ByVal 0&, ByVal 0&)
End Sub

Private Sub btnStop_Click()
  ' stop machine
  e = DoPEVBHalt(DoPEHdl, 0, ByVal 0&)
End Sub

Private Sub btnUp_Click()
  ' move machine UP with digipoti
  e = DoPEVBFDPoti(DoPEHdl, CTRL_POS, 0#, SENSOR_DP, 3, EXT_SPEED_UP, 2#, ByVal 0&)
End Sub

Private Sub btnDown_Click()
  ' move machine DOWN with digipoti
  e = DoPEVBFDPoti(DoPEHdl, CTRL_POS, 0#, SENSOR_DP, 3, EXT_SPEED_DOWN, 2#, ByVal 0&)
End Sub

Private Sub btnPos_Click()
  ' move machine to desired Destination
  e = DoPEVBPos(DoPEHdl, cmbControl.ListIndex, CStr(txtSpeed.Text), CStr(txtDestination.Text), ByVal 0&)
End Sub

Private Sub cmbControl_Click()
  ' change POS command units
  Select Case cmbControl.ListIndex
    Case CTRL_LOAD
      txtSpeedUnit.Caption = "N/s"
      txtDestinationUnit.Caption = "N"
    Case Else
      txtSpeedUnit.Caption = "mm/s"
      txtDestinationUnit.Caption = "mm"
  End Select
End Sub

Private Sub Form_Load()
  ' set visual basic error handler.
  On Error GoTo ErrorHandler

  ' show title
  Dim MajorVersion As Integer
  Dim MinorVersion As Integer
  MajorVersion = Hex((DoPEAPIVERSION And &HFF00) / &H100)
  MinorVersion = Hex(DoPEAPIVERSION Mod &H100)
  Caption = "Visual Basic DoPE Demo  V" & MajorVersion & "." & MinorVersion

  ' set combo box
  cmbControl.AddItem "Position"
  cmbControl.AddItem "Load"
  cmbControl.AddItem "Extension"
  cmbControl.ListIndex = 0
  Show

  DoPEHdl = 0
  ' open link to EDC
  OpenLink

  ' exit before entering error handler
  Exit Sub

ErrorHandler:
  ' error handler line label.
  Dim Msg As String
  If Err.Number <> 0 Then
    Msg = "Error number " & Str(Err.Number) & " was generated by " _
          & Err.Source & Chr(13) & Err.Description
    MsgBox Msg, , "Visual Basic Error", Err.HelpFile, Err.HelpContext
  End If
  Resume Next
  ' resume procedure.
End Sub

Private Sub Form_Unload(Cancel As Integer)
  ' close link to EDC
  CloseLink
End Sub

