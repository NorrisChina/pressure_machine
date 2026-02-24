// *************************************************************************************************
// *
// * Unit Name: frmDoPEEH
// * Purpose  :
// * Author   : FEZ
// * History  : DOLI Version 1.0
// * Date     : 10-Mai-2006
// *
//**************************************************************************************************
#ifndef frmDoPEEHH
#define frmDoPEEHH
//**************************************************************************************************
#include "DoPE.h"
#include "DoPEEH.h"
#include <Classes.hpp>
#include <Controls.hpp>
#include <ExtCtrls.hpp>
#include <StdCtrls.hpp>
//**************************************************************************************************
class Tfrm_DoPEEH : public TForm
{
__published:	// Von der IDE verwaltete Komponenten
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TLabel *Label6;
        TLabel *Label7;
        TLabel *lbl_SpeedDim;
        TLabel *lbl_DestDim;
        TStaticText *txt_Ext;
        TStaticText *txt_Time;
        TStaticText *txt_Pos;
        TStaticText *txt_Load;
        TComboBox *cbo_Ctrl;
        TEdit *txt_Speed;
        TEdit *txt_Dest;
        TButton *btn_On;
        TButton *btn_Off;
        TButton *btn_Up;
        TButton *btn_Halt;
        TButton *btn_Down;
        TButton *btn_Pos;
        TMemo *Memo1;
        void __fastcall FormActivate(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall btn_OnClick(TObject *Sender);
        void __fastcall btn_OffClick(TObject *Sender);
        void __fastcall btn_UpClick(TObject *Sender);
        void __fastcall btn_HaltClick(TObject *Sender);
        void __fastcall btn_DownClick(TObject *Sender);
        void __fastcall btn_PosClick(TObject *Sender);
        void __fastcall cbo_CtrlChange(TObject *Sender);
private:	// Anwender-Deklarationen
        DoPE_HANDLE DHandle;
        UserScale  UserS;
        DoPEData   Sample;
        int        n_Baud;
        int        n_Com;
        Word       TAN;
        int        Rc;
        Double     Speed;
        Double     Destination;
        void __fastcall MError(unsigned DError, UnicodeString csFunction);
        void __fastcall ChangeDimension(int nIndex);
public:		// Anwender-Deklarationen
        __fastcall Tfrm_DoPEEH(TComponent* Owner);
};
//**************************************************************************************************
extern PACKAGE Tfrm_DoPEEH *frm_DoPEEH;
//**************************************************************************************************
#endif
