{***************************************************************************************************
 *
 * Unit Name: frmDoPEEHTest.pas
 * Purpose  : Pascal Demo for DoPE
 * Author   : FEZ / HEG
 *
 **************************************************************************************************}
unit frmDoPEDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DoPE, DoPEEh, DoPESyn, DoPEKey,
  DoPERmc, DoPEilc, DoPEcorr, DoPEdebug;

type

  { TfrmDoPEDemo }

  TfrmDoPEDemo = class(TForm)
    btn_Down: TButton;
    btn_Halt: TButton;
    btn_Off: TButton;
    btn_On: TButton;
    btn_Pos: TButton;
    btn_Up: TButton;
    cbo_Ctrl: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbl_DestDim: TLabel;
    lbl_SpeedDim: TLabel;
    Memo1: TMemo;
    txt_Dest: TEdit;
    txt_Ext: TStaticText;
    txt_Load: TStaticText;
    txt_Pos: TStaticText;
    txt_Speed: TEdit;
    txt_Time: TStaticText;
    procedure btn_DownClick(Sender: TObject);
    procedure btn_HaltClick(Sender: TObject);
    procedure btn_OffClick(Sender: TObject);
    procedure btn_OnClick(Sender: TObject);
    procedure btn_PosClick(Sender: TObject);
    procedure btn_UpClick(Sender: TObject);
    procedure cbo_CtrlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Speed        : Double;
    Destination  : Double;
    procedure ChangeDimension(nIndex : Integer);
  public
    DHandle      : DoPE_HANDLE;
    UserS        : UserScale;
    Sample       : DoPEData;
    Tan          : Word;
    Rc           : Integer;

  end;

var
  frm_DoPEDemo: TfrmDoPEDemo;

implementation

{$R *.lfm}

{ TfrmDoPEDemo }


{$DEFINE ONDATABLOCK}


{***************************************************************************************************
 *
 * Proc Name: OnLine
 * Purpose  : Handler for DoPE line state changed events
 *
 **************************************************************************************************}
function OnLine (DoPEHdl : DoPE_HANDLE; LineState : Integer; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  s := Format('OnLine : LineState=%d', [LineState]);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;


{$IFDEF ONDATABLOCK}
{***************************************************************************************************
 *
 * Proc Name: OnDataBlock
 * Purpose  : Handler for received measuring data blocks
 *
 **************************************************************************************************}
var
  Sample : ^DoPEOnData;
function OnDataBlock (DoPEHdl : DoPE_HANDLE; var Samples : DoPEOnDataBlock; Buffer : Pointer) : DWord; STDCALL;
begin
  if (Samples.DoPError = DoPERR_NOERROR) then
    if (Samples.nData >= 1) then
      begin
        // Process last EDC measured values of the block
        Sample := @Samples.Data^;
        Inc(Sample, Samples.nData-1);
        frm_DoPEDemo.txt_Time.Caption := Format('%.3f', [Sample^.Data.Time]);
        frm_DoPEDemo.txt_Pos.Caption  := Format('%.3f', [Sample^.Data.Position]);
        frm_DoPEDemo.txt_Load.Caption := Format('%.3f', [Sample^.Data.Load]);
        frm_DoPEDemo.txt_Ext.Caption  := Format('%.3f', [Sample^.Data.Extension]);
      end;
  Result := 0;
end;
{$ELSE}
{***************************************************************************************************
 *
 * Proc Name: OnData
 * Purpose  : Handler for received measuring data records
 *
 **************************************************************************************************}
var
  LastTime : Double;
function OnData (DoPEHdl : DoPE_HANDLE; var Sample  : DoPEOnData; Buffer : Pointer) : DWord; STDCALL;
begin
  if (Sample.DoPError = DoPERR_NOERROR) then
  begin
    // Process EDC measured values
    if (LastTime < Sample.Data.Time) then
    begin
      LastTime := Sample.Data.Time + 0.3;
      frm_DoPEDemo.txt_Time.Caption := Format('%.3f', [Sample.Data.Time]);
      frm_DoPEDemo.txt_Pos.Caption  := Format('%.3f', [Sample.Data.Position]);
      frm_DoPEDemo.txt_Load.Caption := Format('%.3f', [Sample.Data.Load]);
      frm_DoPEDemo.txt_Ext.Caption  := Format('%.3f', [Sample.Data.Extension]);
    end;
  end;
  Result := 0;
end;
{$ENDIF}

{***************************************************************************************************
 *
 * Proc Name: OnCommandError
 * Purpose  : Handler for command errors
 *
 **************************************************************************************************}
function OnCommandError (DoPEHdl : DoPE_HANDLE; var CommandError : DoPEOnCommandError; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
   s := Format('OnCommandError : CommandNumber=%d ErrorNumber=%d TAN=%d',
               [CommandError.CommandNumber, CommandError.ErrorNumber, CommandError.usTAN]);
   frm_DoPEDemo.Memo1.Lines.Add(s);
   Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnPosMsg
 * Purpose  : Handler for position messages
 *
 **************************************************************************************************}
function OnPosMsg (DoPEHdl : DoPE_HANDLE; var PosMsg : DoPEOnPosMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (PosMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnPosMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ',
                [PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl,
                PosMsg.Destination, PosMsg.Reached, PosMsg.usTAN])
  else
    s := 'OnPosMsg : fatal DoPE error ' + IntToStr(PosMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnTPosMsg
 * Purpose  : Handler for trigger position messages
 *
 **************************************************************************************************}
function OnTPosMsg (DoPEHdl : DoPE_HANDLE; var TPosMsg : DoPEOnPosMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (TPosMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnTPosMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ',
                [TPosMsg.Time, TPosMsg.Control, TPosMsg.Position, TPosMsg.DControl,
                TPosMsg.Destination, TPosMsg.Reached, TPosMsg.usTAN])
  else
    s := 'OnTPosMsg : fatal DoPE error ' + IntToStr(TPosMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnLPosMsg
 * Purpose  : Handler for limit position messages
 *
 **************************************************************************************************}
function OnLPosMsg (DoPEHdl : DoPE_HANDLE; var LPosMsg : DoPEOnPosMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (LPosMsg.DoPError = DoPERR_NOERROR) then
    s := Format('LPosMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ',
                [LPosMsg.Time, LPosMsg.Control, LPosMsg.Position, LPosMsg.DControl,
                LPosMsg.Destination, LPosMsg.Reached, LPosMsg.usTAN])
  else
    s := 'OnLPosMsg : fatal DoPE error ' + IntToStr(LPosMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnSftMsg
 * Purpose  : Handler for Softend messages
 *
 **************************************************************************************************}
function OnSftMsg (DoPEHdl : DoPE_HANDLE; var SftMsg : DoPEOnSftMsg; Buffer : Pointer): DWord; STDCALL;
var
  s  : AnsiString;
  s1 : AnsiString;
begin
  if (SftMsg.DoPError = DoPERR_NOERROR) then
  begin
    if (SftMsg.Upper <> 0) then
      s1 := ' Upper'
    else
      s1 := ' Lower';
    s := Format('OnSftMsg : Time=%.3f Ctrl=%d Pos=%.3f %s TAN=%d ',
                [SftMsg.Time, SftMsg.Control, SftMsg.Position, s1,
                 SftMsg.usTAN]);
  end
  else
    s := 'OnSftMsg : fatal DoPE error ' + IntToStr(SftMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnOffsCMsg
 * Purpose  : Handler for offset correction messages
 *
 **************************************************************************************************}
function OnOffsCMsg (DoPEHdl : DoPE_HANDLE; var OffsCMsg : DoPEOnOffsCMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (OffsCMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnOffsCMsg : Time=%.3f Offset=%.3f TAN=%d',
                [OffsCMsg.Time, OffsCMsg.Offset, OffsCMsg.usTAN])
  else
    s := 'OnOffsCMsg : fatal DoPE error ' + IntToStr(OffsCMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnCheckMsg
 * Purpose  : Handler for channel supervision messages
 *
 **************************************************************************************************}
function OnCheckMsg (DoPEHdl : DoPE_HANDLE; var CheckMsg : DoPEOnCheckMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (CheckMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnCheckMsg : Time=%.3f CheckId=%d SensorNo=%d Pos=%.3f Action=%d TAN=%d',
                [CheckMsg.Time, CheckMsg.CheckId, CheckMsg.SensorNo, CheckMsg.Position, CheckMsg.Action, CheckMsg.usTAN])
  else
    s := 'OnCheckMsg : fatal DoPE error ' + IntToStr(CheckMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnShieldMsg
 * Purpose  : Handler for shield supervision messages
 *
 **************************************************************************************************}
function OnShieldMsg (DoPEHdl : DoPE_HANDLE; var ShieldMsg : DoPEOnShieldMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (ShieldMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnShieldMsg : Time=%.3f Action=%d SensorNo=%d Pos=%.3f TAN=%d',
                [ShieldMsg.Time, ShieldMsg.Action, ShieldMsg.SensorNo, ShieldMsg.Position, ShieldMsg.usTAN])
  else
    s := 'OnShieldMsg : fatal DoPE error ' + IntToStr(ShieldMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnRefSignalMsg
 * Purpose  : Handler for reference signal messages
 *
 **************************************************************************************************}
function OnRefSignalMsg (DoPEHdl : DoPE_HANDLE; var RefSignalMsg : DoPEOnRefSignalMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (RefSignalMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnRefSignalMsg : Time=%.3f SensorNo=%d Pos=%.3f TAN=%d',
                [RefSignalMsg.Time, RefSignalMsg.SensorNo, RefSignalMsg.Position, RefSignalMsg.usTAN])
  else
    s := 'OnRefSignalMsg : fatal DoPE error ' + IntToStr(RefSignalMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnSensorMsg
 * Purpose  : Handler for sensor messages
 *
 **************************************************************************************************}
function OnSensorMsg (DoPEHdl : DoPE_HANDLE; var SensorMsg : DoPEOnSensorMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (SensorMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnSensorMsg : Time=%.3f SensorNo=%d Length=%d  Data="%s" TAN=%d',
                [SensorMsg.Time, SensorMsg.SensorNo, SensorMsg.Length, PChar(@SensorMsg.Data), SensorMsg.usTAN])
  else
    s := 'OnSensorMsg : fatal DoPE error ' + IntToStr(SensorMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnIoSHaltMsg
 * Purpose  : Handler for IO-SHalt messages
 *
 **************************************************************************************************}
function OnIoSHaltMsg (DoPEHdl : DoPE_HANDLE; var IoSHaltMsg : DoPEOnIoSHaltMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (IoSHaltMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnIoSHaltMsg : Upper=%d Time=%.3f Control=%d Position=%.3f TAN=%d',
                [IoSHaltMsg.Upper, IoSHaltMsg.Time, IoSHaltMsg.Control, IoSHaltMsg.Position, IoSHaltMsg.usTAN])
  else
    s := 'OnIoSHaltMsg : fatal DoPE error ' + IntToStr(IoSHaltMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnKeyMsg
 * Purpose  : Handler for key messages
 *
 **************************************************************************************************}
function OnKeyMsg (DoPEHdl : DoPE_HANDLE; var KeyMsg : DoPEOnKeyMsg; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (KeyMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnKeyMsg : Time=%.3f Keys=$%.16x TAN=%d',
                [KeyMsg.Time, KeyMsg.Keys, KeyMsg.usTAN])
  else
    s := 'OnKeyMsg : fatal DoPE error ' + IntToStr(KeyMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnRuntimeError
 * Purpose  : Handler for runtime errors
 *
 **************************************************************************************************}
function OnRuntimeError (DoPEHdl : DoPE_HANDLE; var RuntimeError : DoPEOnRuntimeError; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  if (RuntimeError.DoPError = DoPERR_NOERROR) then
    s := Format('OnRuntimeError : Time=%.3f Error=%d Device=$%.4x Bits=$%.4x TAN=%d',
                [RuntimeError.Time, RuntimeError.ErrorNumber,
                 RuntimeError.Device, RuntimeError.Bits, RuntimeError.usTAN])
  else
    s := 'OnRuntimeError : fatal DoPE error ' + IntToStr(RuntimeError.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnOverflow
 * Purpose  : Handler for measuring data and message overlow events
 *
 **************************************************************************************************}
function OnOverflow (DoPEHdl : DoPE_HANDLE; nInt : Integer; Buffer : Pointer): DWord; STDCALL;
begin
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnSystemMsg
 * Purpose  : Handler for system messages
 *
 **************************************************************************************************}
function OnSystemMsg (DoPEHdl : DoPE_HANDLE; var SystemMsg : DoPEOnSystemMsg; Buffer : Pointer): DWord; STDCALL;
var
  s: AnsiString;
begin
  if (SystemMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnSystemMsg : Time=%.3f MsgNumber=%d Text="%s"',
                [SystemMsg.Time, SystemMsg.MsgNumber, SystemMsg.Text])
  else
    s := 'OnSystemMsg : fatal DoPE error ' + IntToStr(SystemMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnDebugMsg
 * Purpose  : Handler for system messages
 *
 **************************************************************************************************}
function OnDebugMsg (DoPEHdl : DoPE_HANDLE; var DebugMsg : DoPEOnDebugMsg; Buffer : Pointer): DWord; STDCALL;
var
  s: AnsiString;
begin
  if (DebugMsg.DoPError = DoPERR_NOERROR) then
    s := Format('OnDebugMsg : Time=%.3f MsgType=%d Text="%s"',
                [DebugMsg.Time, DebugMsg.MsgType, DebugMsg.Text])
  else
    s := 'OnDebugMsg : fatal DoPE error ' + IntToStr(DebugMsg.DoPError);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnRmcEvent
 * Purpose  : Handler for RMC events
 *
 **************************************************************************************************}
function OnRmcEvent (DoPEHdl : DoPE_HANDLE; var RmcEvent : DoPEOnRmcEvent; Buffer : Pointer): DWord; STDCALL;
var
  s : AnsiString;
begin
  s := Format('OnRmcEvent : Keys=$%.16x NewKeys=$%.16x GoneKeys=$%.16x',
              [RmcEvent.Keys, RmcEvent.NewKeys, RmcEvent.GoneKeys ]);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  s := Format('OnRmcEvent : Leds=$%.16x NewLeds=$%.16x GoneLeds=$%.16x',
              [RmcEvent.Leds, RmcEvent.NewLeds, RmcEvent.GoneLeds ]);
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnSynchronizeDataHdlr
 * Purpose  : Handler for synchronized data events
 *
 **************************************************************************************************}
function OnSynchronizeData (var OnSyncData : DoPEOnSynchronizeData; Buffer : Pointer ): DWord; STDCALL;
var
  s: AnsiString;
begin
  s := 'OnSynchronizeData';
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: OnOnSynchronizeDataOverflowHdlr
 * Purpose  : Handler for synchronized data overflow events
 *
 **************************************************************************************************}
function OnSynchronizeDataOverflow (Buffer : Pointer ): DWord; STDCALL;
var
  s: AnsiString;
begin
  s := 'OnSynchronizeDataOverflow';
  frm_DoPEDemo.Memo1.Lines.Add(s);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: MError
 * Purpose  : Error handling function
 *
 **************************************************************************************************}
function MError(DError : DWord; EText : AnsiString) : Integer;
var
  cErrorMsg : String;
begin
  cErrorMsg := Format('%s %u ( $%.4x )', [EText, DError, DError]);
  frm_DoPEDemo.Memo1.Lines.Add(cErrorMsg);
  Result := 0;
end;

{***************************************************************************************************
 *
 * Proc Name: Tfrm_DoPEEHTest.FormCreate / FormShow
 * Opening the connection to the EDC
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.FormCreate(Sender: TObject);
begin
  Caption := Format(Caption, [DoPEAPIVERSION div $100, DoPEAPIVERSION mod $100]);
  DHandle  := Nil;
end;

procedure TfrmDoPEDemo.FormShow(Sender: TObject);
var
  i : Integer;
begin
  frm_DoPEDemo.Refresh;
  if (DHandle = Nil) then
  begin
    Screen.Cursor := crHourglass;

    // Open the DoPE link
    Rc := DoPEOpenDeviceId( 0, 100, 100, 1000, DoPEAPIVERSION, Nil, DHandle );
    if ( Rc <> DoPERR_NOERROR) then
      Memo1.Lines.Add('DoPEOpenLink : failed !')
    else
    begin
      Memo1.Lines.Add('DoPEOpenLink : OK !');

      // Set the OnLine handler
      Rc := DoPESetOnLineHdlr ( DHandle, @OnLine, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnLineHdlr');

{$IFDEF ONDATABLOCK}
      // Set the OnDataBlock handler
      Rc := DoPESetOnDataBlockHdlr ( DHandle, @OnDataBlock, frm_DoPEDemo );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnDataBlockHdlr');
      // since the refresh of the edit controls occurs on each OnDataBlock event
      // we increase the number of samples in a block to 300
      Rc := DoPESetOnDataBlockSize(DHandle, 300);
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnDataBlockSize');
{$ELSE}
      // Set the OnData handler
      Rc := DoPESetOnDataHdlr ( DHandle, @OnData, frm_DoPEDemo );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnDataHdlr');
{$ENDIF}

      // Set the OnCommandError handler
      Rc := DoPESetOnCommandErrorHdlr ( DHandle, @OnCommandError, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnCommandErrorHdlr');

      // Set the OnPosMsg handler
      Rc := DoPESetOnPosMsgHdlr ( DHandle, @OnPosMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnPosMsgHdlr');

      // Set the OnTPosMsg handler
      Rc := DoPESetOnTPosMsgHdlr ( DHandle, @OnTPosMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnTPosMsgHdlr');

      // Set the OnLPosMsg handler
      Rc := DoPESetOnLPosMsgHdlr ( DHandle, @OnLPosMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnLPosMsgHdlr');

      // Set the OnSftMsgHdlr handler
      Rc := DoPESetOnSftMsgHdlr ( DHandle, @OnSftMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnSftMsgHdlr');

      // Set the OnOffsCMsgHdlr handler
      Rc := DoPESetOnOffsCMsgHdlr ( DHandle, @OnOffsCMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnOffsCMsgHdlr');

      // Set the OnCheckMsgHdlr handler
      Rc := DoPESetOnCheckMsgHdlr ( DHandle, @OnCheckMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnCheckMsgHdlr');

      // Set the OnShieldMsgHdlr handler
      Rc := DoPESetOnShieldMsgHdlr ( DHandle, @OnShieldMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnShieldMsgHdlr');

      // Set the OnRefSignalMsgHdlr handler
      Rc := DoPESetOnRefSignalMsgHdlr ( DHandle, @OnRefSignalMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnRefSignalMsgHdlr');

      // Set the OnSensorMsgHdlr handler
      Rc := DoPESetOnSensorMsgHdlr ( DHandle, @OnSensorMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnSensorMsgHdlr');

      // Set the OnIoSHaltMsgHdlr handler
      Rc := DoPESetOnIoSHaltMsgHdlr ( DHandle, @OnIoSHaltMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnIoSHaltMsgHdlr');

      // Set the OnKeyMsgHdlr handler
      Rc := DoPESetOnKeyMsgHdlr ( DHandle, @OnKeyMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnKeyMsgHdlr');

      // Set the OnRuntimeError handler
      Rc := DoPESetOnRuntimeErrorHdlr ( DHandle, @OnRuntimeError, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnRuntimeErrorHdlr');

      // Set the OnOverflow handler
      Rc := DoPESetOnOverflowHdlr ( DHandle, @OnOverflow, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnOverflowHdlr');

      // Set the OnSystemMsgHdlr handler
      Rc := DoPESetOnSystemMsgHdlr ( DHandle, @OnSystemMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnSystemMsgHdlr');

      // Set the OnDebugMsgHdlr handler
      Rc := DoPESetOnDebugMsgHdlr ( DHandle, @OnDebugMsg, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnDebugMsgHdlr');

      // Set the OnRmcEventHdlr handler
      Rc := DoPESetOnRmcEventHdlr ( DHandle, @OnRmcEvent, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESetOnRmcEventHdlr');

      // Set the OnSynchronizeDataHdlr handler
      Rc := DoPESetOnSynchronizeDataHdlr ( @OnSynchronizeData, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'OnSynchronizeDataHdlr');

      // Set the OnSynchronizeDataOverflowHdlr handler
      Rc := DoPESetOnSynchronizeDataOverflowHdlr ( @OnSynchronizeDataOverflow, Nil );
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'OnSynchronizeDataOverflowHdlr');

      // Set UserScale
      for i := 0 to (MAX_MC -1) do
        UserS[i] := 1.0;
      // Set UserScale - Position to mm
      UserS[SENSOR_S] := 1000;
      // Set UserScale - Extension to mm
      UserS[SENSOR_E] := 1000;

      // Select machine setup and initialize
      Rc := DoPESelSetup(DHandle, 1, UserS, NIL, NIL);
      if (Rc <> DoPERR_NOERROR) then
        MError(Rc, 'DoPESelSetup')
      else
        Memo1.Lines.Add('DoPESelSetup : OK !');
    end;
    Screen.Cursor := crDefault;

    // Default values at program start
    cbo_Ctrl.ItemIndex := CTRL_POS;
    ChangeDimension(cbo_Ctrl.ItemIndex);
    txt_Speed.Text     := '5';
    txt_Dest.Text      := '0';
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: Tfrm_DoPEEHTest.FormClose
 * Purpose  : Closing the Connection to the EDC
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPECloseLink(DHandle);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPECloseLink');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: ChangeDimension
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.ChangeDimension(nIndex : Integer);
begin
  case nIndex of
    CTRL_POS :
    begin
      lbl_SpeedDim.Caption := 'mm/s';
      lbl_DestDim.Caption  := 'mm';
    end;
    CTRL_LOAD :
    begin
      lbl_SpeedDim.Caption := 'N/s';
      lbl_DestDim.Caption  := 'N';
    end;
    CTRL_EXTENSION :
    begin
      lbl_SpeedDim.Caption := 'mm/s';
      lbl_DestDim.Caption  := 'mm';
    end;
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: cbo_CtrlChange
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.cbo_CtrlChange(Sender: TObject);
begin
  ChangeDimension(cbo_Ctrl.ItemIndex);
end;

{***************************************************************************************************
 *
 * Proc Name: btn_OnClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_OnClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPEOnSync(DHandle);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPEOn');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: btn_OffClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_OffClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPEOffSync(DHandle);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPEOff');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: btn_UpClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_UpClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPEFDPotiSync(DHandle, CTRL_POS, 0, SENSOR_DP, 3, EXT_SPEED_UP, 2, @Tan);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPEFDPoti');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: btn_HaltClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_HaltClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPESHaltSync(DHandle, @Tan);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPESHalt');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: btn_DownClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_DownClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Rc := DoPEFDPotiSync(DHandle, CTRL_POS, 0, SENSOR_DP, 3, EXT_SPEED_DOWN, 2, @Tan);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPEFDPoti');
  end;
end;

{***************************************************************************************************
 *
 * Proc Name: btn_PosClick
 *
 **************************************************************************************************}
procedure TfrmDoPEDemo.btn_PosClick(Sender: TObject);
begin
  if (DHandle <> Nil) then  // only if DoPE handle active
  begin
    Speed       := StrToFloat(txt_Speed.Text);
    Destination := StrToFloat(txt_Dest.Text);
    Rc          := DoPEPos(DHandle, cbo_Ctrl.ItemIndex, Speed, Destination, @Tan);
    if (Rc <> DoPERR_NOERROR) then
      MError(Rc, 'DoPEPos');
  end;
end;

end.

