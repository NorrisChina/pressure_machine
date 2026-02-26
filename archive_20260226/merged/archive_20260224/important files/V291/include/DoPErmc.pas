{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC remot control default handling
  

Changes :
=========
  HEG, 12.5.11
  - wrote it.
*****************************************************************************}


unit DoPErmc;


{$ALIGN OFF}


interface

uses Windows, DoPE;


  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'RMC Event'                           }
   DoPEOnRmcEvent = record             { ------------------------------------- }
    Keys        : Int64;               { Current key state                     }
    NewKeys     : Int64;               { New keys                              }
    GoneKeys    : Int64;               { Gone keys                             }
    Leds        : Int64;               { Current LED state                [No] }
    NewLeds     : Int64;               { New LEDs                         [No] }
    GoneLeds    : Int64;               { Gone LEDs                        [No] }
   end;

type
  DoPEOnRmcEventHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                          var OnRmcEvent  : DoPEOnRmcEvent;
                                  Buffer  : Pointer ): DWord; STDCALL;
  {
     Handler for RMC events
       DoPE_HANDLE     DoPE link handle
       DoPEOnRmcEvent  received RMC event
       Pointer         userspecific pointer set with DoPESetOnRmcEventHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnRmcEventRtHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                          var OnRmcEvent    : DoPEOnRmcEvent;
                                    Buffer  : Pointer): DWord; STDCALL;
  {
     Realtime handler for RMC events
       DoPE_HANDLE     DoPE link handle
       DoPEOnRmcEvent  received RMC event
       Pointer         userspecific pointer set with DoPESetOnRmcEventRtHdlr
     should return 0 (reserved for future versions)
  }

{ ---------------------------------------------------------------------------- }

function DoPESetOnRmcEventHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnRmcEventHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnRmcEvent handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        RMC event

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnRmcEventRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnRmcEventRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnRmcEvent handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every RMC event

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPERmcEnable ( DoPEHdl     : DoPE_HANDLE;
                         EnableKeys  : Int64;
                         EnableLeds  : Int64 ): DWord; STDCALL;

    {
    Enable / disable the remote control default handling for keys and LEDs.
    Sets the PushMode and RmcDPoti settings to the default values defined in
    the setup RMC definition.

      In :  DoPEHdl       DoPE link handle
            EnableKeys    mask of enabled RMC emulation keys
            EnableLeds    mask of enabled RMC emulation LEDs

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPERmcReDefine ( DoPEHdl     : DoPE_HANDLE;
                           PushMode    : word;
                       var RmcDPoti    : array of DoPERmcDPoti ): DWord; STDCALL;

    {
    Redefine the PushMode and RmcDPoti settings for the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            PushMode      !=0  enables
                          0    disables the push mode for Up/Down keys
            RmcDPoti      RMC DPoti definition

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPERmcKeys ( DoPEHdl     : DoPE_HANDLE;
                       SetKeys     : Int64;
                       ResKeys     : Int64;
                       ToggleKeys  : Int64  ): DWord; STDCALL;

    {
    Set / reset / toggle keys for the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            SetKeys       RMC emulation keys to set
            ResKeys       RMC emulation keys to clear
            ToggleKeys    RMC emulation keys to toggle

            The three key patterns will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing bits.          (lowest priority)
            2.) Resetting of the bits.
            3.) Setting of the bits.    (highest priority)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPERmcState ( DoPEHdl     : DoPE_HANDLE;
                    var RmcEvent    : DoPEOnRmcEvent ): DWord; STDCALL;

    {
    Get keys and LEDs state of the remote control default handling.

      In :  DoPEHdl       DoPE link handle
            Keys          currently active keys
            NewKeys       keys pressed since last call of this function
            GoneKeys      keys released since last call of this function
            Leds          currently active LEDs
            NewLeds       LEDs activated since last call of this function
            GoneLeds      LEDs deactivated since last call of this function

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }



implementation

//**************************************************************************************************
function DoPESetOnRmcEventHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnRmcEventHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnRmcEventRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnRmcEventRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPERmcEnable ( DoPEHdl     : DoPE_HANDLE;
                         EnableKeys  : Int64;
                         EnableLeds  : Int64 ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
 function DoPERmcReDefine ( DoPEHdl    : DoPE_HANDLE;
                           PushMode    : word;
                       var RmcDPoti    : array of DoPERmcDPoti ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPERmcKeys ( DoPEHdl     : DoPE_HANDLE;
                       SetKeys     : Int64;
                       ResKeys     : Int64;
                       ToggleKeys  : Int64  ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPERmcState ( DoPEHdl     : DoPE_HANDLE;
                    var RmcEvent    : DoPEOnRmcEvent ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************

end.
