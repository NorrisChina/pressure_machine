{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC keyboard interface for Windows

Changes :
=========
  HEG, 11.5.06
  - wrote it.

  HEG, 11.7.06
  - Clamp keys and leds renamed to grip

  HEG, 24.7.06 - V2.52
  - 'blind' function keys for RMC's without LCD defined

  HEG, 11.01.08 - V2.59
  - New Key and LED definitions:
    - DoPE_KEY_HIGH_PRESSURE, DoPE_KEY_LOW_PRESSURE
    - DoPE_LED_HIGH_PRESSURE, DoPE_LED_LOW_PRESSURE

  HEG, 16.10.09 - V2.66
  - Source code layout adapted to C++ header
  - New KEY and LED definitions:
   - DoPE_KEY_OFF, DoPE_KEY_FAST, DoPE_KEY_TEST_STOP, DoPE_KEY_TEST_RETURN, DoPE_KEY_TEST_HALT_CONTINUE, DoPE_KEY_CONNECT
   - DoPE_LED_OFF, DoPE_LED_FAST, DoPE_LED_TEST_STOP, DoPE_LED_TEST_RETURN, DoPE_LED_TEST_HALT_CONTINUE, DoPE_LED_CONNECT

  HEG, 15.7.10 - V2.68
  - New KEY and LED definitions:
    - DoPE_KEY_UP_FAST, DoPE_KEY_DOWN_FAST (DoPE_KEY_FAST removed)
    - DoPE_LED_UP_FAST, DoPE_LED_DOWN_FAST (DoPE_LED_FAST removed)

  HEG, 15.5.11 - V2.70
  - New KEY and LED definitions:
    - DoPE_KEY_CTRL_POS, DoPE_KEY_CTRL_LOAD, DoPE_KEY_CTRL_EXTENSION
    - DoPE_LED_CTRL_POS, DoPE_LED_CTRL_LOAD, DoPE_LED_CTRL_EXTENSION

  HEG, 22.3.12 - V2.73
  - New KEY and LED definitions:
    - DoPE_KEY_CTRL_SENSOR3 ... DoPE_KEY_CTRL_SENSOR15
    - DoPE_LED_CTRL_SENSOR3 ... DoPE_LED_CTRL_SENSOR15
*****************************************************************************}


unit DoPEKey;

{$ALIGN OFF}

interface

uses Windows, DoPE;

const

{ - DOLI key ------------------ Code ----------------------------------------- }
    DoPE_KEY_NONE               = -1;       // invalid (no key pressed)        
    DoPE_KEY_HALT               = $00;      // 'HALT'                          
    DoPE_KEY_UP                 = $01;      // 'UP'                            
    DoPE_KEY_DOWN               = $02;      // 'DOWN'                          
    DoPE_KEY_DPOTI              = $03;      // 'DigiPoti pressed'              
    DoPE_KEY_F1                 = $04;      // 'F1' function key               
    DoPE_KEY_F2                 = $05;      // 'F2' function key               
    DoPE_KEY_F3                 = $06;      // 'F3' function key               
    DoPE_KEY_ON                 = $07;      // 'ON'                            
    DoPE_KEY_TEST               = $08;      // 'TEST'                          
    DoPE_KEY_UPR_GRIP_OPEN      = $09;      // 'Upper Grip Open'               
    DoPE_KEY_UPR_GRIP_CLOSE     = $0A;      // 'Upper Grip Close'              
    DoPE_KEY_LWR_GRIP_OPEN      = $0B;      // 'Lower Grip Open'               
    DoPE_KEY_LWR_GRIP_CLOSE     = $0C;      // 'Lower Grip Close'              
    DoPE_KEY_EXTMETER_OPEN      = $0D;      // 'Extensometer Open'             
    DoPE_KEY_EXTMETER_CLOSE     = $0E;      // 'Extensometer Close'            
    DoPE_KEY_FIXED_XHEAD_UP     = $0F;      // 'fixed X-Head Up'               
    DoPE_KEY_FIXED_XHEAD_DOWN   = $10;      // 'fixed X-Head Down'             
    DoPE_KEY_DPOTI_CONTROL      = $11;      // 'DigiPoti Speed-Position Mode'  
    DoPE_KEY_BF1                = $12;      // 'blind F1' function key (no LCD)
    DoPE_KEY_BF2                = $13;      // 'blind F2' function key (no LCD)
    DoPE_KEY_BF3                = $14;      // 'blind F3' function key (no LCD)
    DoPE_KEY_HIGH_PRESSURE      = $15;      // 'Activate High Pressure'        
    DoPE_KEY_LOW_PRESSURE       = $16;      // 'Activate Low Pressure'         
    DoPE_KEY_OFF                = $17;      // 'OFF'                           
    DoPE_KEY_UP_FAST            = $18;      // 'Move UP fast'                     
    DoPE_KEY_DOWN_FAST          = $19;      // 'Move DOWN fast'                     
    DoPE_KEY_TEST_STOP          = $1A;      // 'Test stop'                     
    DoPE_KEY_TEST_RETURN        = $1B;      // 'Test return'                   
    DoPE_KEY_TEST_HALT_CONTINUE = $1C;      // 'Test halt / continue'          
    DoPE_KEY_reserved1D         = $1D;
    DoPE_KEY_reserved1E         = $1E;
    DoPE_KEY_reserved1F         = $1F;
    DoPE_KEY_reserved20         = $20;
    DoPE_KEY_CTRL_SENSOR3       = $21;
    DoPE_KEY_CTRL_SENSOR4       = $22;
    DoPE_KEY_CTRL_SENSOR5       = $23;
    DoPE_KEY_CTRL_SENSOR6       = $24;
    DoPE_KEY_CTRL_SENSOR7       = $25;
    DoPE_KEY_CTRL_SENSOR8       = $26;
    DoPE_KEY_CTRL_SENSOR9       = $27;
    DoPE_KEY_CTRL_SENSOR10      = $28;
    DoPE_KEY_CTRL_SENSOR11      = $29;
    DoPE_KEY_CTRL_SENSOR12      = $2A;
    DoPE_KEY_CTRL_SENSOR13      = $2B;
    DoPE_KEY_CTRL_SENSOR14      = $2C;
    DoPE_KEY_CTRL_SENSOR15      = $2D;
    DoPE_KEY_DP                 = $2E;      // '.' period (decimal point)
    DoPE_KEY_SIGN               = $2F;      // '±' sign                  
    DoPE_KEY_0                  = $30;      // '0'                       
    DoPE_KEY_1                  = $31;      // '1'                       
    DoPE_KEY_2                  = $32;      // '2'                       
    DoPE_KEY_3                  = $33;      // '3'                       
    DoPE_KEY_4                  = $34;      // '4'                       
    DoPE_KEY_5                  = $35;      // '5'                       
    DoPE_KEY_6                  = $36;      // '6'                       
    DoPE_KEY_7                  = $37;      // '7'                       
    DoPE_KEY_8                  = $38;      // '8'                       
    DoPE_KEY_9                  = $39;      // '9'
    DoPE_KEY_CTRL_POS           = $3A;      // 'Position control'
    DoPE_KEY_CTRL_LOAD          = $3B;      // 'Load control'
    DoPE_KEY_CTRL_EXTENSION     = $3C;      // 'Extension control'
    DoPE_KEY_reserved3D         = $3D;
    DoPE_KEY_reserved3E         = $3E;
    DoPE_KEY_CONNECT            = $3F;
{ - OEM key --------------------- Code --------------------------------------- }
    DoPE_KEY_OEM0               = $40;
    DoPE_KEY_OEM1               = $41;
    DoPE_KEY_OEM2               = $42;
    DoPE_KEY_OEM3               = $43;
    DoPE_KEY_OEM4               = $44;
    DoPE_KEY_OEM5               = $45;
    DoPE_KEY_OEM6               = $46;
    DoPE_KEY_OEM7               = $47;
    DoPE_KEY_OEM8               = $48;
    DoPE_KEY_OEM9               = $49;
    DoPE_KEY_OEMA               = $4A;
    DoPE_KEY_OEMB               = $4B;
    DoPE_KEY_OEMC               = $4C;
    DoPE_KEY_OEMD               = $4D;
    DoPE_KEY_OEME               = $4E;
    DoPE_KEY_OEMF               = $4F;
    
    
{ - DOLI LED -------------------- Code --------------------------------------- }
    DoPE_LED_HALT               = DoPE_KEY_HALT;
    DoPE_LED_UP                 = DoPE_KEY_UP;
    DoPE_LED_DOWN               = DoPE_KEY_DOWN;
    DoPE_LED_DPOTI              = DoPE_KEY_DPOTI;
    DoPE_LED_F1                 = DoPE_KEY_F1;
    DoPE_LED_F2                 = DoPE_KEY_F2;
    DoPE_LED_F3                 = DoPE_KEY_F3;
    DoPE_LED_ON                 = DoPE_KEY_ON;
    DoPE_LED_TEST               = DoPE_KEY_TEST;
    DoPE_LED_UPR_GRIP_OPEN      = DoPE_KEY_UPR_GRIP_OPEN;
    DoPE_LED_UPR_GRIP_CLOSE     = DoPE_KEY_UPR_GRIP_CLOSE;
    DoPE_LED_LWR_GRIP_OPEN      = DoPE_KEY_LWR_GRIP_OPEN;
    DoPE_LED_LWR_GRIP_CLOSE     = DoPE_KEY_LWR_GRIP_CLOSE;
    DoPE_LED_EXTMETER_OPEN      = DoPE_KEY_EXTMETER_OPEN;
    DoPE_LED_EXTMETER_CLOSE     = DoPE_KEY_EXTMETER_CLOSE;
    DoPE_LED_FIXED_XHEAD_UP     = DoPE_KEY_FIXED_XHEAD_UP;
    DoPE_LED_FIXED_XHEAD_DOWN   = DoPE_KEY_FIXED_XHEAD_DOWN;
    DoPE_LED_DPOTI_CONTROL      = DoPE_KEY_DPOTI_CONTROL;
    DoPE_LED_BF1                = DoPE_KEY_BF1;
    DoPE_LED_BF2                = DoPE_KEY_BF2;
    DoPE_LED_BF3                = DoPE_KEY_BF3;
    DoPE_LED_HIGH_PRESSURE      = DoPE_KEY_HIGH_PRESSURE;
    DoPE_LED_LOW_PRESSURE       = DoPE_KEY_LOW_PRESSURE;
    DoPE_LED_OFF                = DoPE_KEY_OFF;
    DoPE_LED_UP_FAST            = DoPE_KEY_UP_FAST;                  
    DoPE_LED_DOWN_FAST          = DoPE_KEY_DOWN_FAST;                    
    DoPE_LED_TEST_STOP          = DoPE_KEY_TEST_STOP;
    DoPE_LED_TEST_RETURN        = DoPE_KEY_TEST_RETURN;
    DoPE_LED_TEST_HALT_CONTINUE = DoPE_KEY_TEST_HALT_CONTINUE;
    DoPE_LED_reserved1D         = DoPE_KEY_reserved1D;
    DoPE_LED_reserved1E         = DoPE_KEY_reserved1E;
    DoPE_LED_reserved1F         = DoPE_KEY_reserved1F;
    DoPE_LED_reserved20         = DoPE_KEY_reserved20;
    DoPE_LED_CTRL_SENSOR3       = DoPE_KEY_CTRL_SENSOR3;
    DoPE_LED_CTRL_SENSOR4       = DoPE_KEY_CTRL_SENSOR4;
    DoPE_LED_CTRL_SENSOR5       = DoPE_KEY_CTRL_SENSOR5;
    DoPE_LED_CTRL_SENSOR6       = DoPE_KEY_CTRL_SENSOR6;
    DoPE_LED_CTRL_SENSOR7       = DoPE_KEY_CTRL_SENSOR7;
    DoPE_LED_CTRL_SENSOR8       = DoPE_KEY_CTRL_SENSOR8;
    DoPE_LED_CTRL_SENSOR9       = DoPE_KEY_CTRL_SENSOR9;
    DoPE_LED_CTRL_SENSOR10      = DoPE_KEY_CTRL_SENSOR10;
    DoPE_LED_CTRL_SENSOR11      = DoPE_KEY_CTRL_SENSOR11;
    DoPE_LED_CTRL_SENSOR12      = DoPE_KEY_CTRL_SENSOR12;
    DoPE_LED_CTRL_SENSOR13      = DoPE_KEY_CTRL_SENSOR13;
    DoPE_LED_CTRL_SENSOR14      = DoPE_KEY_CTRL_SENSOR14;
    DoPE_LED_CTRL_SENSOR15      = DoPE_KEY_CTRL_SENSOR15;
    DoPE_LED_DP                 = DoPE_KEY_DP;
    DoPE_LED_SIGN               = DoPE_KEY_SIGN;
    DoPE_LED_0                  = DoPE_KEY_0;
    DoPE_LED_1                  = DoPE_KEY_1;
    DoPE_LED_2                  = DoPE_KEY_2;
    DoPE_LED_3                  = DoPE_KEY_3;
    DoPE_LED_4                  = DoPE_KEY_4;
    DoPE_LED_5                  = DoPE_KEY_5;
    DoPE_LED_6                  = DoPE_KEY_6;
    DoPE_LED_7                  = DoPE_KEY_7;
    DoPE_LED_8                  = DoPE_KEY_8;
    DoPE_LED_9                  = DoPE_KEY_9;
    DoPE_LED_CTRL_POS           = DoPE_KEY_CTRL_POS;
    DoPE_LED_CTRL_LOAD          = DoPE_KEY_CTRL_LOAD;
    DoPE_LED_CTRL_EXTENSION     = DoPE_KEY_CTRL_EXTENSION;
    DoPE_LED_reserved3D         = DoPE_KEY_reserved3D;
    DoPE_LED_reserved3E         = DoPE_KEY_reserved3E;
    DoPE_LED_CONNECT            = DoPE_KEY_CONNECT;
{ - OEM LED --------------------- Code --------------------------------------- }
    DoPE_LED_OEM0               = DoPE_KEY_OEM0;
    DoPE_LED_OEM1               = DoPE_KEY_OEM1;
    DoPE_LED_OEM2               = DoPE_KEY_OEM2;
    DoPE_LED_OEM3               = DoPE_KEY_OEM3;
    DoPE_LED_OEM4               = DoPE_KEY_OEM4;
    DoPE_LED_OEM5               = DoPE_KEY_OEM5;
    DoPE_LED_OEM6               = DoPE_KEY_OEM6;
    DoPE_LED_OEM7               = DoPE_KEY_OEM7;
    DoPE_LED_OEM8               = DoPE_KEY_OEM8;
    DoPE_LED_OEM9               = DoPE_KEY_OEM9;
    DoPE_LED_OEMA               = DoPE_KEY_OEMA;
    DoPE_LED_OEMB               = DoPE_KEY_OEMB;
    DoPE_LED_OEMC               = DoPE_KEY_OEMC;
    DoPE_LED_OEMD               = DoPE_KEY_OEMD;
    DoPE_LED_OEME               = DoPE_KEY_OEME;
    DoPE_LED_OEMF               = DoPE_KEY_OEMF;


{ -------------------------------------------------------------------------- }

function DoPERdNumberOfKeyboards ( DoPEHdl     : DoPE_HANDLE;
                             var   Number      : DWord): DWord; STDCALL;

    {
    Read the number of connected keyboards.

      In :  DP            DoPE link handle
            pNumber       Pointer to storage for the number of keyboards

      Out :
           *pNumber       Number of connected keyboards

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPESetKeyShiftStateSync ( DoPEHdl     : DoPE_HANDLE;
                                    Enable      : DWord): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESetKeyShiftState     ( DoPEHdl     : DoPE_HANDLE;
                                    Enable      : DWord;
                                    usTAN       : PWord ): DWord; STDCALL;
    {
    Set the keyboard shift state.

      In :  DP            DoPE link handle
            Enable        0=disable shift state, else enable shift state

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPERdKeyShiftState ( DoPEHdl     : DoPE_HANDLE;
                         var   Enabled     : DWord): DWord; STDCALL;

    {
    Read the keyboard shift state.

      In :  DP            DoPE link handle
            pEnabled      Pointer to storage for keyboard shift state

      Out :
           *pEnabled      keyboard shift state

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPESetLedSync ( DoPEHdl     : DoPE_HANDLE;
                          LedOn       : Int64;
                          LedOff      : Int64;
                          LedFlash    : Int64;
                          OemLedOn    : Word;
                          OemLedOff   : Word;
                          OemLedFlash : Word): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESetLed     ( DoPEHdl     : DoPE_HANDLE;
                          LedOn       : Int64;
                          LedOff      : Int64;
                          LedFlash    : Int64;
                          OemLedOn    : Word;
                          OemLedOff   : Word;
                          OemLedFlash : Word;
                          usTAN       : PWord ): DWord; STDCALL;
    {
    Switch On/Off LED's at the EDC keyboard.

      In :  DP            DoPE link handle
            (OEM)LedOn    These LED's will be set
            (OEM)LedOff   These LED's will be reset
            (OEM)LedFlash These LED's 'flash'

            The parameters will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing LED's.         (lowest)
            2.) Resetting of the LED's.
            3.) Setting of the LED's.   (highest)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPELedMask    ( DoPEHdl     : DoPE_HANDLE;
                          LedCode     : Integer;
                          State       : DWord;
                      var LedMask     : Int64;
                          OemLedMask  : PWord ): DWord; STDCALL;

    {
    Set the LED matrix bit for a given LED code.
    Each LED is represented by a bit in the LED matrix. This function converts
    a LED code to the matrix bit and sets the bit in the LED or OEM LED matrix.

      In :  DP                     DoPE link handle
            LedCode                LED code to convert
            State                  0=clear bit, else set bit
            pLedMask/pOemLedMask   Pointer to the LED matrix
                                   (NULL pointers are accepted)

      Out :
           *pLedMask/*pOemLedMask  LED matrix

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPECurrentKeys ( DoPEHdl     : DoPE_HANDLE;
                       var Keys        : Int64;
                           OemKeys     : PWord ): DWord; STDCALL;

    {
    Read the current keys.

      In :  DP              DoPE link handle
            pKeys/pOemKeys  Pointer to storage for the key matrix

      Out :
           *pKeys/pOemKeys  current key matrix

      Returns:            Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPEKeyPressed ( DoPEHdl     : DoPE_HANDLE;
                          KeyCode     : Integer;
                          Keys        : Int64;
                          OemKeys     : Word ): DWord; STDCALL;

    {
    Check if the key with the given key code is pressed.

      In :  DP            DoPE link handle
            KeyCode       Key code to check
            Keys/OemKeys  Key matrix

      Returns:            0 if key is not pressed, else key is pressed
    }

{ -------------------------------------------------------------------------- }

function DoPEKeyGet ( DoPEHdl     : DoPE_HANDLE;
                  var Keys        : Int64;
                      OemKeys     : PWord ): DWord; STDCALL;

    {
    Get the key code of a pressed key.
    Each pressed key is represented by a set bit in the key matrix. This function
    converts a bit from the key matrix to it's key code and resets the bit in
    the key matrix.

      In :  DP              DoPE link handle
            pKeys/pOemKeys  Pointer to the key matrix

      Out :
           *pKeys/pOemKeys  Key matrix.

      Returns:              The key code of a pressed key or DoPE_KEY_NONE
    }


implementation

{ -------------------------------------------------------------------------- }
function DoPERdNumberOfKeyboards ( DoPEHdl     : DoPE_HANDLE;
                             var   Number      : DWord): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPESetKeyShiftStateSync ( DoPEHdl     : DoPE_HANDLE;
                                    Enable      : DWord): DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetKeyShiftState     ( DoPEHdl     : DoPE_HANDLE;
                                    Enable      : DWord;
                                    usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPERdKeyShiftState ( DoPEHdl     : DoPE_HANDLE;
                         var   Enabled     : DWord): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPESetLedSync ( DoPEHdl     : DoPE_HANDLE;
                          LedOn       : Int64;
                          LedOff      : Int64;
                          LedFlash    : Int64;
                          OemLedOn    : Word;
                          OemLedOff   : Word;
                          OemLedFlash : Word): DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetLed     ( DoPEHdl     : DoPE_HANDLE;
                          LedOn       : Int64;
                          LedOff      : Int64;
                          LedFlash    : Int64;
                          OemLedOn    : Word;
                          OemLedOff   : Word;
                          OemLedFlash : Word;
                          usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPELedMask    ( DoPEHdl     : DoPE_HANDLE;
                          LedCode     : Integer;
                          State       : DWord;
                      var LedMask     : Int64;
                          OemLedMask  : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPECurrentKeys ( DoPEHdl     : DoPE_HANDLE;
                       var Keys        : Int64;
                           OemKeys     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPEKeyPressed ( DoPEHdl     : DoPE_HANDLE;
                          KeyCode     : Integer;
                          Keys        : Int64;
                          OemKeys     : Word ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }
function DoPEKeyGet ( DoPEHdl     : DoPE_HANDLE;
                  var Keys        : Int64;
                      OemKeys     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
{ -------------------------------------------------------------------------- }

end.
