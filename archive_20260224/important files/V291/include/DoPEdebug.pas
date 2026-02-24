{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC interface Debug handling
  
Changes :
=========
  HEG, 18.10.11
  - wrote it.
*****************************************************************************}


unit DoPEdebug;


{$ALIGN OFF}


interface

uses Windows, DoPE;


{ ---------------------------------------------------------------------------- }

function DoPESendDebugCommandSync ( DoPEHdl  : DoPE_HANDLE;
                                    Text     : PChar ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESendDebugCommand ( DoPEHdl  : DoPE_HANDLE;
                                Text     : PChar;
                                usTAN    : PWord ): DWord; STDCALL;
    {
    Send a debug command to the EDC.
    
      In :  DoPEHdl       DoPE link handle
            Text          Pointer to zero terminated text to transmit
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

{ ---------------------------------------------------------------------------- }

function DoPEDebugMsgEnableSync ( DoPEHdl : DoPE_HANDLE;
                                  Enable  : DWord): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEDebugMsgEnable ( DoPEHdl : DoPE_HANDLE;
                              Enable  : DWord;
                              usTAN   : PWord ): DWord; STDCALL;
    {
    Enable/disable debug messages from the EDC.
    
      In :  DoPEHdl       DoPE link handle
            Enable        !=0  enables 
                          0    disables debug messages
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }



implementation

//**************************************************************************************************
function DoPESendDebugCommandSync ( DoPEHdl  : DoPE_HANDLE;
                                    Text     : PChar ): DWord; STDCALL;

   external 'DoPE.dll';
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESendDebugCommand ( DoPEHdl  : DoPE_HANDLE;
                                Text     : PChar;
                                usTAN    : PWord ): DWord; STDCALL;
                                   
   external 'DoPE.dll';
//**************************************************************************************************
function DoPEDebugMsgEnableSync ( DoPEHdl : DoPE_HANDLE;
                                  Enable  : DWord): DWord; STDCALL;

   external 'DoPE.dll';
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }
function DoPEDebugMsgEnable ( DoPEHdl : DoPE_HANDLE;
                              Enable  : DWord;
                              usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************

end.
