Attribute VB_Name = "DoPEkey"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 2006
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) keyboard interface
'
' Versions:
' ---------
'
' HEG, 11.7.06
' - Clamp keys and leds renamed to grip
'
' HEG, 24.7.06 - V2.52
' - 'blind' function keys for RMC's without LCD defined
'
' PET, 28.07.2006 - V2.52a
' - New: DoPEVBRdKeyShiftState()
'
'  HEG, 11.01.08 - V2.59
'  - New Key and LED definitions:
'    - DoPE_KEY_HIGH_PRESSURE, DoPE_KEY_LOW_PRESSURE
'    - DoPE_LED_HIGH_PRESSURE, DoPE_LED_LOW_PRESSURE
'
'  HEG, 16.10.09 - V2.66
'  - New KEY and LED definitions:
'   - DoPE_KEY_OFF, DoPE_KEY_FAST, DoPE_KEY_TEST_STOP, DoPE_KEY_TEST_RETURN, DoPE_KEY_TEST_HALT_CONTINUE, DoPE_KEY_CONNECT
'   - DoPE_LED_OFF, DoPE_LED_FAST, DoPE_LED_TEST_STOP, DoPE_LED_TEST_RETURN, DoPE_LED_TEST_HALT_CONTINUE, DoPE_LED_CONNECT
'
' HEG, 15.7.10 - V2.68
' - New KEY and LED definitions:
'   - DoPE_KEY_UP_FAST, DoPE_KEY_DOWN_FAST (DoPE_KEY_FAST removed)
'   - DoPE_LED_UP_FAST, DoPE_LED_DOWN_FAST (DoPE_LED_FAST removed)
'
'  HEG, 15.5.11 - V2.70
'  - New KEY and LED definitions:
'    - DoPE_KEY_CTRL_POS, DoPE_KEY_CTRL_LOAD, DoPE_KEY_CTRL_EXTENSION
'    - DoPE_LED_CTRL_POS, DoPE_LED_CTRL_LOAD, DoPE_LED_CTRL_EXTENSION
'
'  HEG, 22.3.12 - V2.73
'  - New KEY and LED definitions:
'    - DoPE_KEY_CTRL_SENSOR3 ... DoPE_KEY_CTRL_SENSOR15
'    - DoPE_LED_CTRL_SENSOR3 ... DoPE_LED_CTRL_SENSOR15
'******************************************************************************


'//----- DOLI key ------------------ Code ---------------------------------------
Public Const DoPE_KEY_NONE = -1                   ' invalid (no key pressed)
Public Const DoPE_KEY_HALT = &H0                  ' 'HALT'
Public Const DoPE_KEY_UP = &H1                    ' 'UP'
Public Const DoPE_KEY_DOWN = &H2                  ' 'DOWN'
Public Const DoPE_KEY_DPOTI = &H3                 ' 'DigiPoti pressed'
Public Const DoPE_KEY_F1 = &H4                    ' 'F1' function key
Public Const DoPE_KEY_F2 = &H5                    ' 'F2' function key
Public Const DoPE_KEY_F3 = &H6                    ' 'F3' function key
Public Const DoPE_KEY_ON = &H7                    ' 'ON'
Public Const DoPE_KEY_TEST = &H8                  ' 'TEST'
Public Const DoPE_KEY_UPR_GRIP_OPEN = &H9         ' 'Upper Grip Open'
Public Const DoPE_KEY_UPR_GRIP_CLOSE = &HA        ' 'Upper Grip Close'
Public Const DoPE_KEY_LWR_GRIP_OPEN = &HB         ' 'Lower Grip Open'
Public Const DoPE_KEY_LWR_GRIP_CLOSE = &HC        ' 'Lower Grip Close'
Public Const DoPE_KEY_EXTMETER_OPEN = &HD         ' 'Extensiometer Open'
Public Const DoPE_KEY_EXTMETER_CLOSE = &HE        ' 'Extensiometer Close'
Public Const DoPE_KEY_FIXED_XHEAD_UP = &HF        ' 'fixed X-Head Up'
Public Const DoPE_KEY_FIXED_XHEAD_DOWN = &H10     ' 'fixed X-Head Down'
Public Const DoPE_KEY_DPOTI_CONTROL = &H11        ' 'DigiPoti Speed-Position Mode'
Public Const DoPE_KEY_BF1 = &H12                  ' 'blind F1' function key (no LCD)
Public Const DoPE_KEY_BF2 = &H13                  ' 'blind F2' function key (no LCD)
Public Const DoPE_KEY_BF3 = &H14                  ' 'blind F3' function key (no LCD)
Public Const DoPE_KEY_HIGH_PRESSURE = &H15        ' 'Activate High Pressure'
Public Const DoPE_KEY_LOW_PRESSURE = &H16         ' 'Activate Low Pressure'
Public Const DoPE_KEY_OFF = &H17                  ' 'OFF'                 
Public Const DoPE_KEY_UP_FAST = &H18              ' 'Move UP fast'           
Public Const DoPE_KEY_DOWN_FAST = &H19            ' 'Move DOWN fast'           
Public Const DoPE_KEY_TEST_STOP = &H1A            ' 'Test stop'           
Public Const DoPE_KEY_TEST_RETURN = &H1B          ' 'Test return'         
Public Const DoPE_KEY_TEST_HALT_CONTINUE = &H1C   ' 'Test halt / continue'
Public Const DoPE_KEY_reserved1D = &H1D
Public Const DoPE_KEY_reserved1E = &H1E
Public Const DoPE_KEY_reserved1F = &H1F
Public Const DoPE_KEY_reserved20 = &H20
Public Const DoPE_KEY_CTRL_SENSOR3 = &H21
Public Const DoPE_KEY_CTRL_SENSOR4 = &H22
Public Const DoPE_KEY_CTRL_SENSOR5 = &H23
Public Const DoPE_KEY_CTRL_SENSOR6 = &H24
Public Const DoPE_KEY_CTRL_SENSOR7 = &H25
Public Const DoPE_KEY_CTRL_SENSOR8 = &H26
Public Const DoPE_KEY_CTRL_SENSOR9 = &H27
Public Const DoPE_KEY_CTRL_SENSOR10 = &H28
Public Const DoPE_KEY_CTRL_SENSOR11 = &H29
Public Const DoPE_KEY_CTRL_SENSOR12 = &H2A
Public Const DoPE_KEY_CTRL_SENSOR13 = &H2B
Public Const DoPE_KEY_CTRL_SENSOR14 = &H2C
Public Const DoPE_KEY_CTRL_SENSOR15 = &H2D
Public Const DoPE_KEY_DP = &H2E                   ' '.' period (decimal point)
Public Const DoPE_KEY_SIGN = &H2F                 ' '±' sign
Public Const DoPE_KEY_0 = &H30                    ' '0'
Public Const DoPE_KEY_1 = &H31                    ' '1'
Public Const DoPE_KEY_2 = &H32                    ' '2'
Public Const DoPE_KEY_3 = &H33                    ' '3'
Public Const DoPE_KEY_4 = &H34                    ' '4'
Public Const DoPE_KEY_5 = &H35                    ' '5'
Public Const DoPE_KEY_6 = &H36                    ' '6'
Public Const DoPE_KEY_7 = &H37                    ' '7'
Public Const DoPE_KEY_8 = &H38                    ' '8'
Public Const DoPE_KEY_9 = &H39                    ' '9'
Public Const DoPE_KEY_CTRL_POS = &H3A             ' 'Position control' 
Public Const DoPE_KEY_CTRL_LOAD = &H3B            ' 'Load control'     
Public Const DoPE_KEY_CTRL_EXTENSION = &H3C       ' 'Extension control'
Public Const DoPE_KEY_reserved3D = &H3D
Public Const DoPE_KEY_reserved3E = &H3E
Public Const DoPE_KEY_CONNECT = &H3F
'//----- OEM key ------------------- Code ---------------------------------------
Public Const DoPE_KEY_OEM0 = &H40
Public Const DoPE_KEY_OEM1 = &H41
Public Const DoPE_KEY_OEM2 = &H42
Public Const DoPE_KEY_OEM3 = &H43
Public Const DoPE_KEY_OEM4 = &H44
Public Const DoPE_KEY_OEM5 = &H45
Public Const DoPE_KEY_OEM6 = &H46
Public Const DoPE_KEY_OEM7 = &H47
Public Const DoPE_KEY_OEM8 = &H48
Public Const DoPE_KEY_OEM9 = &H49
Public Const DoPE_KEY_OEMA = &H4A
Public Const DoPE_KEY_OEMB = &H4B
Public Const DoPE_KEY_OEMC = &H4C
Public Const DoPE_KEY_OEMD = &H4D
Public Const DoPE_KEY_OEME = &H4E
Public Const DoPE_KEY_OEMF = &H4F


'//----- DOLI LED ------------------ Code ---------------------------------------
Public Const DoPE_LED_HALT = DoPE_KEY_HALT
Public Const DoPE_LED_UP = DoPE_KEY_UP
Public Const DoPE_LED_DOWN = DoPE_KEY_DOWN
Public Const DoPE_LED_DPOTI = DoPE_KEY_DPOTI
Public Const DoPE_LED_F1 = DoPE_KEY_F1
Public Const DoPE_LED_F2 = DoPE_KEY_F2
Public Const DoPE_LED_F3 = DoPE_KEY_F3
Public Const DoPE_LED_ON = DoPE_KEY_ON
Public Const DoPE_LED_TEST = DoPE_KEY_TEST
Public Const DoPE_LED_UPR_GRIP_OPEN = DoPE_KEY_UPR_GRIP_OPEN
Public Const DoPE_LED_UPR_GRIP_CLOSE = DoPE_KEY_UPR_GRIP_CLOSE
Public Const DoPE_LED_LWR_GRIP_OPEN = DoPE_KEY_LWR_GRIP_OPEN
Public Const DoPE_LED_LWR_GRIP_CLOSE = DoPE_KEY_LWR_GRIP_CLOSE
Public Const DoPE_LED_EXTMETER_OPEN = DoPE_KEY_EXTMETER_OPEN
Public Const DoPE_LED_EXTMETER_CLOSE = DoPE_KEY_EXTMETER_CLOSE
Public Const DoPE_LED_FIXED_XHEAD_UP = DoPE_KEY_FIXED_XHEAD_UP
Public Const DoPE_LED_FIXED_XHEAD_DOWN = DoPE_KEY_FIXED_XHEAD_DOWN
Public Const DoPE_LED_DPOTI_CONTROL = DoPE_KEY_DPOTI_CONTROL
Public Const DoPE_LED_BF1 = DoPE_KEY_BF1
Public Const DoPE_LED_BF2 = DoPE_KEY_BF2
Public Const DoPE_LED_BF3 = DoPE_KEY_BF3
Public Const DoPE_LED_HIGH_PRESSURE = DoPE_KEY_HIGH_PRESSURE
Public Const DoPE_LED_LOW_PRESSURE = DoPE_KEY_LOW_PRESSURE
Public Const DoPE_LED_OFF = DoPE_KEY_OFF
Public Const DoPE_LED_UP_FAST = DoPE_KEY_UP_FAST
Public Const DoPE_LED_DOWN_FAST = DoPE_KEY_DOWN_FAST
Public Const DoPE_LED_TEST_STOP = DoPE_KEY_TEST_STOP
Public Const DoPE_LED_TEST_RETURN = DoPE_KEY_TEST_RETURN
Public Const DoPE_LED_TEST_HALT_CONTINUE = DoPE_KEY_TEST_HALT_CONTINUE
Public Const DoPE_LED_reserved1D = DoPE_KEY_reserved1D
Public Const DoPE_LED_reserved1E = DoPE_KEY_reserved1E
Public Const DoPE_LED_reserved1F = DoPE_KEY_reserved1F
Public Const DoPE_LED_reserved20 = DoPE_KEY_reserved20 
Public Const DoPE_LED_CTRL_SENSOR3 = DoPE_KEY_CTRL_SENSOR3
Public Const DoPE_LED_CTRL_SENSOR4 = DoPE_KEY_CTRL_SENSOR4
Public Const DoPE_LED_CTRL_SENSOR5 = DoPE_KEY_CTRL_SENSOR5
Public Const DoPE_LED_CTRL_SENSOR6 = DoPE_KEY_CTRL_SENSOR6
Public Const DoPE_LED_CTRL_SENSOR7 = DoPE_KEY_CTRL_SENSOR7
Public Const DoPE_LED_CTRL_SENSOR8 = DoPE_KEY_CTRL_SENSOR8
Public Const DoPE_LED_CTRL_SENSOR9 = DoPE_KEY_CTRL_SENSOR9
Public Const DoPE_LED_CTRL_SENSOR10 = DoPE_KEY_CTRL_SENSOR10
Public Const DoPE_LED_CTRL_SENSOR11 = DoPE_KEY_CTRL_SENSOR11
Public Const DoPE_LED_CTRL_SENSOR12 = DoPE_KEY_CTRL_SENSOR12
Public Const DoPE_LED_CTRL_SENSOR13 = DoPE_KEY_CTRL_SENSOR13
Public Const DoPE_LED_CTRL_SENSOR14 = DoPE_KEY_CTRL_SENSOR14
Public Const DoPE_LED_CTRL_SENSOR15 = DoPE_KEY_CTRL_SENSOR15
Public Const DoPE_LED_DP = DoPE_KEY_DP
Public Const DoPE_LED_SIGN = DoPE_KEY_SIGN
Public Const DoPE_LED_0 = DoPE_KEY_0
Public Const DoPE_LED_1 = DoPE_KEY_1
Public Const DoPE_LED_2 = DoPE_KEY_2
Public Const DoPE_LED_3 = DoPE_KEY_3
Public Const DoPE_LED_4 = DoPE_KEY_4
Public Const DoPE_LED_5 = DoPE_KEY_5
Public Const DoPE_LED_6 = DoPE_KEY_6
Public Const DoPE_LED_7 = DoPE_KEY_7
Public Const DoPE_LED_8 = DoPE_KEY_8
Public Const DoPE_LED_9 = DoPE_KEY_9
Public Const DoPE_LED_CTRL_POS = DoPE_KEY_CTRL_POS
Public Const DoPE_LED_CTRL_LOAD = DoPE_KEY_CTRL_LOAD
Public Const DoPE_LED_CTRL_EXTENSION = DoPE_KEY_CTRL_EXTENSION
Public Const DoPE_LED_reserved3D = DoPE_KEY_reserved3D
Public Const DoPE_LED_reserved3E = DoPE_KEY_reserved3E
Public Const DoPE_LED_CONNECT = DoPE_KEY_CONNECT
'//----- OEM LED -------------- Code ---------------------------------------   
Public Const DoPE_LED_OEM0 = DoPE_KEY_OEM0
Public Const DoPE_LED_OEM1 = DoPE_KEY_OEM1
Public Const DoPE_LED_OEM2 = DoPE_KEY_OEM2
Public Const DoPE_LED_OEM3 = DoPE_KEY_OEM3
Public Const DoPE_LED_OEM4 = DoPE_KEY_OEM4
Public Const DoPE_LED_OEM5 = DoPE_KEY_OEM5
Public Const DoPE_LED_OEM6 = DoPE_KEY_OEM6
Public Const DoPE_LED_OEM7 = DoPE_KEY_OEM7
Public Const DoPE_LED_OEM8 = DoPE_KEY_OEM8
Public Const DoPE_LED_OEM9 = DoPE_KEY_OEM9
Public Const DoPE_LED_OEMA = DoPE_KEY_OEMA
Public Const DoPE_LED_OEMB = DoPE_KEY_OEMB
Public Const DoPE_LED_OEMC = DoPE_KEY_OEMC
Public Const DoPE_LED_OEMD = DoPE_KEY_OEMD
Public Const DoPE_LED_OEME = DoPE_KEY_OEME
Public Const DoPE_LED_OEMF = DoPE_KEY_OEMF


'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdNumberOfKeyboards Lib "dope.dll" Alias "DoPERdNumberOfKeyboards" (ByVal DoPEHdl As Long, ByRef pNumber As Long) As Long

'  extern  unsigned  DLLAPI  DoPERdNumberOfKeyboards ( DoPE_HANDLE  DP,
'                                                      unsigned    *pNumber );
'
'    /*
'    Read the number of connected keyboards.
'
'      In :  DP            DoPE link handle
'            pNumber       Pointer to storage for the number of keyboards
'
'      Out :
'           *pNumber       Number of connected keyboards
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetKeyShiftState Lib "dope.dll" Alias "DoPESetKeyShiftState" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetKeyShiftStateSync Lib "dope.dll" Alias "DoPESetKeyShiftStateSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetKeyShiftStateSync ( DoPE_HANDLE  DP,
'                                                       unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetKeyShiftState ( DoPE_HANDLE  DP,
'                                                   unsigned     Enable,
'                                                   WORD        *lpusTAN );
'    /*
'    Set the keyboard shift state.
'
'      In :  DP            DoPE link handle
'            Enable        0=disable shift state, else enable shift state
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdKeyShiftState Lib "dope.dll" Alias "DoPERdKeyShiftState" (ByVal DoPEHdl As Long, ByRef pEnable As Long) As Long

'  extern  unsigned  DLLAPI  DoPERdKeyShiftState ( DoPE_HANDLE  DP,
'                                                  unsigned    *pEnabled );
'
'    /*
'    Read the keyboard shift state.
'
'      In :  DP            DoPE link handle
'            pEnabled      Pointer to storage for keyboard shift state
'
'      Out :
'           *pEnabled      keyboard shift state
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetLed Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef LedOn As INT64, ByRef LedOff As INT64, ByRef LedFlash As INT64, ByVal OemLedOn As Integer, ByVal OemLedOff As Integer, ByVal OemLedFlash As Integer, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetLedSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef LedOn As INT64, ByRef LedOff As INT64, ByRef LedFlash As INT64, ByVal OemLedOn As Integer, ByVal OemLedOff As Integer, ByVal OemLedFlash As Integer) As Long

'  extern  unsigned  DLLAPI  DoPESetLedSync ( DoPE_HANDLE      DP,
'                                             unsigned __int64 LedOn,
'                                             unsigned __int64 LedOff,
'                                             unsigned __int64 LedFlash,
'                                             WORD             OemLedOn,
'                                             WORD             OemLedOff,
'                                             WORD             OemLedFlash );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetLed ( DoPE_HANDLE      DP,
'                                         unsigned __int64 LedOn,
'                                         unsigned __int64 LedOff,
'                                         unsigned __int64 LedFlash,
'                                         WORD             OemLedOn,
'                                         WORD             OemLedOff,
'                                         WORD             OemLedFlash,
'                                               WORD            *lpusTAN );
'    /*
'    Switch On/Off LED's at the EDC keyboard.
'
'      In :  DP            DoPE link handle
'            (OEM)LedOn    These LED's will be set
'            (OEM)LedOff   These LED's will be reset
'            (OEM)LedFlash These LED's 'flash'
'
'            The parameters will be processed in the following
'            sequence (important with conflicting data):
'            1.) Flashing LED's.         (lowest)
'            2.) Resetting of the LED's.
'            3.) Setting of the LED's.   (highest)
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBLedMask Lib "dope.dll" Alias "DoPELedMask" (ByVal DoPEHdl As Long, ByVal LedCode As Long, ByVal State As Long, ByRef pLedMask As INT64, ByRef pOemLedMask As Integer) As Long

'  extern  unsigned  DLLAPI  DoPELedMask ( DoPE_HANDLE        DP,
'                                          __int32            LedCode,
'                                          unsigned           State,
'                                          unsigned __int64  *pLedMask,
'                                          WORD              *pOemLedMask );
'
'    /*
'    Set the LED matrix bit for a given LED code.
'    Each LED is represented by a bit in the LED matrix. This function converts
'    a LED code to the matrix bit and sets the bit in the LED or OEM LED matrix.
'
'      In :  DP                     DoPE link handle
'            LedCode                LED code to convert
'            State                  0=clear bit, else set bit
'            pLedMask/pOemLedMask   Pointer to the LED matrix
'                                   (NULL pointers are accepted)
'
'      Out :
'           *pLedMask/*pOemLedMask  LED matrix
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCurrentKeys Lib "dope.dll" Alias "DoPECurrentKeys" (ByVal DoPEHdl As Long, ByRef pKeys As INT64, ByRef pOemKeys As Integer) As Long

'  extern  unsigned  DLLAPI  DoPECurrentKeys ( DoPE_HANDLE  DP,
'                                              unsigned __int64 *pKeys,
'                                              WORD             *pOemKeys );
'
'    /*
'    Read the current keys.
'
'      In :  DP              DoPE link handle
'            pKeys/pOemKeys  Pointer to storage for the key matrix
'
'      Out :
'           *pKeys/pOemKeys  current key matrix
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBKeyPressed Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal KeyCode As Long, ByRef Keys As INT64, ByVal OemKeys As Integer) As Long

'  extern  int  DLLAPI  DoPEKeyPressed ( DoPE_HANDLE        DP,
'                                        __int32            KeyCode,
'                                        unsigned __int64   Keys,
'                                        WORD               OemKeys );
'
'    /*
'    Check if the key with the given key code is pressed.
'
'      In :  DP            DoPE link handle
'            KeyCode       Key code to check
'            Keys/OemKeys  Key matrix
'
'      Returns:            0 if key is not pressed, else key is pressed
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBKeyGet Lib "dope.dll" Alias "DoPEKeyGet" (ByVal DoPEHdl As Long, ByRef pKeys As INT64, ByRef pOemKeys As Integer) As Long

'  extern  int  DLLAPI  DoPEKeyGet ( DoPE_HANDLE        DP,
'                                    unsigned __int64  *pKeys,
'                                    WORD              *pOemKeys );
'
'    /*
'    Get the key code of a pressed key.
'    Each pressed key is represented by a set bit in the key matrix. This function
'    converts a bit from the key matrix to it's key code and resets the bit in
'    the key matrix.
'
'      In :  DP              DoPE link handle
'            pKeys/pOemKeys  Pointer to the key matrix
'
'      Out :
'           *pKeys/pOemKeys  Key matrix.
'
'      Returns:              The key code of a pressed key or DoPE_KEY_NONE
'    */
