//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("DoPEEH.res");
USEFORM("frmDoPEEH.cpp", frm_DoPEEH);
USELIB("DoPECB.lib");
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(Tfrm_DoPEEH), &frm_DoPEEH);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
