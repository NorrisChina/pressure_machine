// *************************************************************************************************
// *
// * Unit Name: frmDoPEEH.cpp
// * Purpose  : C++ Demo for DoPE ( Eventhandler )
// * Author   : FEZ / HEG
// *
//**************************************************************************************************
#include <vcl.h>
#pragma hdrstop

#include "frmDoPEEH.h"
//**************************************************************************************************
#pragma package(smart_init)
#pragma resource "*.dfm"
Tfrm_DoPEEH *frm_DoPEEH;

//**************************************************************************************************
//*
//* Handler for DoPE line state changed events
//*
//**************************************************************************************************
static unsigned CALLBACK OnLine( DoPE_HANDLE DHandle, int LineState, LPVOID p)
{
  AnsiString s;
  s.sprintf("OnLine : LineState=%d", LineState );
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

#define ONDATABLOCK
#if defined ONDATABLOCK
//**************************************************************************************************
//*
//* Handler for received measuring data record blocks
//*
//**************************************************************************************************
static unsigned CALLBACK OnDataBlock( DoPE_HANDLE DHandle, DoPEOnDataBlock *pMsg, LPVOID p)
{
  AnsiString s;

  if( pMsg->DoPError == DoPERR_NOERROR )
    if( pMsg->nData >= 1 )
    {
      DoPEOnData *pSample = &pMsg->Data[pMsg->nData-1];
      frm_DoPEEH->txt_Time->Caption = s.sprintf("%.3lf", pSample->Data.Time);
      frm_DoPEEH->txt_Pos->Caption  = s.sprintf("%.3lf", pSample->Data.Position);
      frm_DoPEEH->txt_Load->Caption = s.sprintf("%.3lf", pSample->Data.Load);
      frm_DoPEEH->txt_Ext->Caption  = s.sprintf("%.3lf", pSample->Data.Extension);
    }
  return 0;
}
#else
//**************************************************************************************************
//*
//* Handler for received measuring data records
//*
//**************************************************************************************************
static unsigned CALLBACK OnData( DoPE_HANDLE DHandle, DoPEOnData *pSample, LPVOID p)
{
  static double LastTime = 0;
  AnsiString s;

  if( pSample->DoPError == DoPERR_NOERROR )
    if( LastTime < pSample->Data.Time )
    {
      LastTime = pSample->Data.Time + 0.3;
      frm_DoPEEH->txt_Time->Caption = s.sprintf("%.3lf", pSample->Data.Time);
      frm_DoPEEH->txt_Pos->Caption  = s.sprintf("%.3lf", pSample->Data.Position);
      frm_DoPEEH->txt_Load->Caption = s.sprintf("%.3lf", pSample->Data.Load);
      frm_DoPEEH->txt_Ext->Caption  = s.sprintf("%.3lf", pSample->Data.Extension);
    }
  return 0;
}
#endif

//**************************************************************************************************
//*
//* Handler for command errors
//*
//**************************************************************************************************
static unsigned CALLBACK OnCommandError( DoPE_HANDLE DHandle, DoPEOnCommandError *pMsg, LPVOID p)
{
  UnicodeString s;
  s.sprintf(L"OnCommandError : CommandNumber=%d ErrorNumber=%d TAN=%d",
              pMsg->CommandNumber, pMsg->ErrorNumber, pMsg->usTAN);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for position messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnPosMsg( DoPE_HANDLE DHandle, DoPEOnPosMsg *pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnPosMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ",
                pMsg->Time, pMsg->Control, pMsg->Position, pMsg->DControl,
                pMsg->Destination, pMsg->Reached, pMsg->usTAN);
  else
    s = L"'OnPosMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for trigger position messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnTPosMsg( DoPE_HANDLE DHandle, DoPEOnPosMsg *pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnPosTMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ",
                pMsg->Time, pMsg->Control, pMsg->Position, pMsg->DControl,
                pMsg->Destination, pMsg->Reached, pMsg->usTAN);
  else
    s = L"'OnTPosMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for limit position messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnLPosMsg( DoPE_HANDLE DHandle, DoPEOnPosMsg *pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnPosLMsg : Time=%.3f Ctrl=%d Pos=%.3f DCtrl=%d DPos=%.3f Reached=%d TAN=%d ",
                pMsg->Time, pMsg->Control, pMsg->Position, pMsg->DControl,
                pMsg->Destination, pMsg->Reached, pMsg->usTAN);
  else
    s = L"'OnLPosMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for Softend messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnSftMsg( DoPE_HANDLE DHandle, DoPEOnSftMsg* pMsg, LPVOID p)
{
  UnicodeString s, s1;
  if (pMsg->DoPError == DoPERR_NOERROR)
  {
    if (pMsg->Upper != 0)
      s1 = L" Upper";
    else
      s1 = L" Lower";
    s.sprintf(L"OnSftMsg : Time=%.3f Ctrl=%d Pos=%.3f %s TAN=%d ",
                pMsg->Time, pMsg->Control, pMsg->Position, s1, pMsg->usTAN);
  }
  else
    s = L"OnSftMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for offset correction messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnOffsCMsg( DoPE_HANDLE DHandle, DoPEOnOffsCMsg* pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnOffsCMsg : Time=%.3f Offset=%.3f TAN=%d ",
                pMsg->Time, pMsg->Offset, pMsg->usTAN);
  else
    s = L"OnOffsCMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for channel supervision messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnCheckMsg( DoPE_HANDLE DHandle, DoPEOnCheckMsg* pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnCheckMsg : Time=%.3f CheckId=%d SensorNo=%d Pos=%.3f Action=%d TAN=%d ",
                pMsg->Time, pMsg->CheckId, pMsg->SensorNo, pMsg->Position, pMsg->Action, pMsg->usTAN);
  else
    s = L"OnCheckMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for shield supervision messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnShieldMsg( DoPE_HANDLE DHandle, DoPEOnShieldMsg* pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnShieldMsg : Time=%.3f Action=%d SensorNo=%d Pos=%.3f TAN=%d ",
                pMsg->Time, pMsg->Action, pMsg->SensorNo, pMsg->Position, pMsg->usTAN);
  else
    s = L"OnShieldMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for reference signal messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnRefSignalMsg( DoPE_HANDLE DHandle, DoPEOnRefSignalMsg* pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnRefSignalMsg : Time=%.3f SensorNo=%d Pos=%.3f TAN=%d ",
                pMsg->Time, pMsg->SensorNo, pMsg->Position, pMsg->usTAN);
  else
    s = L"OnRefSignalMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for reference signal messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnSensorMsg( DoPE_HANDLE DHandle, DoPEOnSensorMsg* pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnSensorMsg : Time=%.3f SensorNo=%d Length=%d Data='%s' TAN=%d ",
                pMsg->Time, pMsg->SensorNo, pMsg->Length, pMsg->Data, pMsg->usTAN);
  else
    s = L"OnSensorMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for key messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnKeyMsg( DoPE_HANDLE DHandle, DoPEOnKeyMsg *pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnKeyMsg : Time=%.3f Keys=0x%0.16Lx TAN=%d ",
               pMsg->Time, pMsg->Keys, pMsg->usTAN);
  else
    s = L"OnKeyMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for runtime errors
//*
//**************************************************************************************************
static unsigned CALLBACK OnRuntimeError( DoPE_HANDLE DHandle, DoPEOnRuntimeError *pMsg, LPVOID p)
{
  UnicodeString s;
  if (pMsg->DoPError == DoPERR_NOERROR)
    s.sprintf(L"OnRuntimeError : Time=%.3f Error=%d Device=0x%0.4x Bits=0x%0.4x TAN=%d",
               pMsg->Time, pMsg->ErrorNumber, pMsg->Device, pMsg->Bits, pMsg->usTAN);
  else
    s = L"OnRuntimeError : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for measuring data and message overlow events
//*
//**************************************************************************************************
static unsigned CALLBACK OnOverflow( DoPE_HANDLE DHandle, int bMsgLost, LPVOID p)
{
  UnicodeString s;
  s.sprintf(L"OnOverflow : %s lost", bMsgLost ? L"message" : L"(at least one) measuring data record" );
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for system messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnSystemMsg( DoPE_HANDLE DHandle, DoPEOnSystemMsg *pMsg, LPVOID p)
{
  UnicodeString s, ws;
  if (pMsg->DoPError == DoPERR_NOERROR)
  {
    s.sprintf(L"OnSystemMsg : Time=%.3f MsgNumber=%d Text='", pMsg->Time, pMsg->MsgNumber);
    ws = pMsg->Text;
    s += ws + "'";
  }
  else
    s = L"OnSystemMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for debug messages
//*
//**************************************************************************************************
static unsigned CALLBACK OnDebugMsg( DoPE_HANDLE DHandle, DoPEOnDebugMsg *pMsg, LPVOID p)
{
  UnicodeString s, ws;
  if (pMsg->DoPError == DoPERR_NOERROR)
  {
    s.sprintf(L"OnDebugMsg : Time=%.3f MsgType=%d Text='", pMsg->Time, pMsg->MsgType);
    ws = pMsg->Text;
    s += ws + "'";
  }
  else
    s = L"OnDebugMsg : fatal DoPE error " + IntToStr((int)pMsg->DoPError);
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Handler for RMC events
//*
//**************************************************************************************************
static unsigned CALLBACK OnRmcEvent( DoPE_HANDLE DHandle, DoPEOnRmcEvent *pMsg, LPVOID p)
{
  UnicodeString s;
  s.sprintf(L"OnRmcEvent : Keys=0x%0.16Lx NewKeys=0x%0.16Lx GoneKeys=0x%0.16Lx",
    pMsg->Keys, pMsg->NewKeys, pMsg->GoneKeys );
  frm_DoPEEH->Memo1->Lines->Add(s);
  s.sprintf(L"             Leds=0x%0.16Lx NewLeds=0x%0.16Lx GoneLeds=0x%0.16Lx ",
    pMsg->Leds, pMsg->NewLeds, pMsg->GoneLeds );
  frm_DoPEEH->Memo1->Lines->Add(s);
  return 0;
}

//**************************************************************************************************
//*
//* Error handling function
//*
//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::MError(unsigned DError, UnicodeString csFunction)
{
  UnicodeString cErrorMsg;

  if (DError != DoPERR_NOERROR)
  {
    cErrorMsg.sprintf(L"Error - %s : %u ( 0x%04X )", csFunction, DError, DError);
    Memo1->Lines->Add(cErrorMsg);
  }
}

//**************************************************************************************************
__fastcall Tfrm_DoPEEH::Tfrm_DoPEEH(TComponent* Owner) : TForm(Owner)
{
  UnicodeString s;
  Caption = s.sprintf( Caption.c_str(), DoPEAPIVERSION / 0x100, DoPEAPIVERSION % 0x100 );
}

//**************************************************************************************************
//*
//* Opening and initializing the Connection to the EDC
//*
//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::FormActivate(TObject *Sender)
{
  UnicodeString s;
  Refresh();
  if( DHandle == NULL )
  {
    Screen->Cursor = crHourGlass;

    // Open the DoPE link
#if 0    // OPENALL
    unsigned InfoTableValidEntries = 0;
    DoPEwOpenLinkInfo info[32];
    Rc = DoPEwOpenAll( 100, 100, 10000, DoPEAPIVERSION, NULL, 32,&InfoTableValidEntries, info);
    DHandle = info[0].DoPEHdl;
#elif 0  // OPENFUNCTIONID
    Rc = DoPEOpenFunctionID( 0, 100, 100, 10000, DoPEAPIVERSION, NULL, &DHandle );
#elif 1  // OPENDEVICEID
    Rc = DoPEOpenDeviceID  ( 0, 100, 100, 10000, DoPEAPIVERSION, NULL, &DHandle );
#endif
    if( Rc != DoPERR_NOERROR )
      Memo1->Lines->Add(L"DoPEOpenDeviceID : failed !" );
    else
    {
      Memo1->Lines->Add(L"DoPEOpenDeviceID : OK !" );

      // Set the OnLine handler
      MError(DoPESetOnLineHdlr ( DHandle, ::OnLine, this ), L"DoPESetOnLineHdlr" );

#if defined ONDATABLOCK
      // Set the OnDataBlock handler
      MError(DoPESetOnDataBlockHdlr ( DHandle, ::OnDataBlock, this ), L"DoPESetOnDataBlockHdlr" );
      // since the refresh of the edit controls occurs on each OnDataBlock event
      // we increase the number of samples in a block to 300
      MError(DoPESetOnDataBlockSize ( DHandle, 300 ), L"DoPESetOnDataBlockSize" );
#else
      // Set the OnData handler
      MError(DoPESetOnDataHdlr ( DHandle, ::OnData, this ), L"DoPESetOnDataHdlr" );
#endif

      // Set the OnCommandError handler
      MError(DoPESetOnCommandErrorHdlr ( DHandle, ::OnCommandError, this ), L"DoPESetOnCommandErrorHdlr" );
         
      // Set the OnPosMsg handler
      MError(DoPESetOnPosMsgHdlr ( DHandle, ::OnPosMsg, this ), L"DoPESetOnPosMsgHdlr" );

      // Set the OnTPosMsg handler
      MError(DoPESetOnTPosMsgHdlr ( DHandle, ::OnTPosMsg, this ), L"DoPESetOnTPosMsgHdlr" );

      // Set the OnLPosMsg handler
      MError(DoPESetOnLPosMsgHdlr ( DHandle, ::OnLPosMsg, this ), L"DoPESetOnLPosMsgHdlr" );

      // Set the OnSftMsgHdlr handler
      MError(DoPESetOnSftMsgHdlr ( DHandle, ::OnSftMsg, this ), L"DoPESetOnSftMsgHdlr" );

      // Set the OnOffsCMsgHdlr handler
      MError(DoPESetOnOffsCMsgHdlr ( DHandle, ::OnOffsCMsg, this ), L"DoPESetOnOffsCMsgHdlr" );

      // Set the OnCheckMsgHdlr handler
      MError(DoPESetOnCheckMsgHdlr ( DHandle, ::OnCheckMsg, this ), L"DoPESetOnCheckMsgHdlr" );

      // Set the OnShieldMsgHdlr handler
      MError(DoPESetOnShieldMsgHdlr ( DHandle, ::OnShieldMsg, this ), L"DoPESetOnShieldMsgHdlr" );

      // Set the OnRefSignalMsgHdlr handler
      MError(DoPESetOnRefSignalMsgHdlr ( DHandle, ::OnRefSignalMsg, this ), L"DoPESetOnRefSignalMsgHdlr" );

      // Set the OnSensorMsgHdlr handler
      MError(DoPESetOnSensorMsgHdlr ( DHandle, ::OnSensorMsg, this ), L"DoPESetOnSensorMsgHdlr" );

      // Set the OnKeyMsgHdlr handler
      MError(DoPESetOnKeyMsgHdlr ( DHandle, ::OnKeyMsg, this ), L"DoPESetOnKeyMsgHdlr" );

      // Set the OnRuntimeError handler
      MError(DoPESetOnRuntimeErrorHdlr ( DHandle, ::OnRuntimeError, this ), L"DoPESetOnRuntimeErrorHdlr" );

      // Set the OnSystemMsg handler
      MError(DoPESetOnSystemMsgHdlr ( DHandle, ::OnSystemMsg, this ), L"DoPESetOnSystemMsgHdlr" );

      // Set the OnDebugMsg handler
      MError(DoPESetOnDebugMsgHdlr ( DHandle, ::OnDebugMsg, this ), L"DoPESetOnDebugMsgHdlr" );

      // Set the OnOverflow handler
      MError(DoPESetOnOverflowHdlr ( DHandle, ::OnOverflow, this ), L"DoPESetOnOverflowHdlr" );
         
      // Set the OnRmcEvent
      MError(DoPESetOnRmcEventHdlr ( DHandle, ::OnRmcEvent, this ), L"DoPESetOnRmcEventHdlr" );

      // Set UserScale
      for (int i = 0; i < MAX_MC; i++)
        UserS[i] = 1.0;
      // Set UserScale - Position to mm
      UserS[SENSOR_S] = 1000;
      // Set UserScale - Extension to mm
      UserS[SENSOR_E] = 1000;

      // Select machine setup and initialize
      Rc = DoPESelSetup(DHandle, 1, UserS, NULL, NULL );
      if (Rc != DoPERR_NOERROR)
        MError(Rc, L"DoPESelSetup");
      else
        Memo1->Lines->Add(L"DoPESelSetup : OK !");
    }
    Screen->Cursor = crDefault;
  }
  else
    Close();
  // Default values at program start
  cbo_Ctrl->ItemIndex = CTRL_POS;
  ChangeDimension(cbo_Ctrl->ItemIndex);
  txt_Speed->Text     = "5";
  txt_Dest->Text      = "0";
}

//**************************************************************************************************
//*
//* Closing the Connection to the EDC
//*
//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::FormClose(TObject *Sender, TCloseAction &Action)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPECloseLink(&(DHandle)), L"DoPECloseLink");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::ChangeDimension(int nIndex)
{
  switch (nIndex)
  {
    case CTRL_POS :
      lbl_SpeedDim->Caption = L"mm/s";
      lbl_DestDim->Caption  = L"mm";
      break;
    case CTRL_LOAD :
      lbl_SpeedDim->Caption = L"N/s";
      lbl_DestDim->Caption  = L"N";
      break;
    case CTRL_EXTENSION :
      lbl_SpeedDim->Caption = L"mm/s";
      lbl_DestDim->Caption  = L"mm";
      break;
  }
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::cbo_CtrlChange(TObject *Sender)
{
  ChangeDimension(cbo_Ctrl->ItemIndex);
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_OnClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPEOnSync(DHandle), L"DoPEOn");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_OffClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPEOffSync(DHandle), L"DoPEOff");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_UpClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPEFDPotiSync(DHandle, CTRL_POS, 0, SENSOR_DP, 3, EXT_SPEED_UP, 2, &TAN), L"DoPEFDPoti");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_HaltClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPESHaltSync(DHandle, &TAN), L"DoPESHalt");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_DownClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
    MError(DoPEFDPotiSync(DHandle, CTRL_POS, 0, SENSOR_DP, 3, EXT_SPEED_DOWN, 2, &TAN), L"DoPEFDPoti");
}

//**************************************************************************************************
void __fastcall Tfrm_DoPEEH::btn_PosClick(TObject *Sender)
{
  if (DHandle != NULL)  // only if DoPE handle active
  {
    Speed       = StrToFloat(txt_Speed->Text);
    Destination = StrToFloat(txt_Dest->Text);
    MError(DoPEPos(DHandle, cbo_Ctrl->ItemIndex, Speed, Destination, &TAN), L"DoPEPos");
  }
}

