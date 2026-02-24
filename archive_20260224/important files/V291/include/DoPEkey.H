/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC interface keyboard handling

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

  HEG, 24.4.15 - V2.82
  - New KEY and LED definitions:
    - DoPE_KEY_LINK
    - DoPE_LED_LINK
*******************************************************************************/


#ifndef DoPE_KEY_INCLUDED
#define DoPE_KEY_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

//----- DOLI key ------------------ Code ---------------------------------------
#define DoPE_KEY_NONE               -1      // invalid (no key pressed)
#define DoPE_KEY_HALT               0x00    // 'HALT'
#define DoPE_KEY_UP                 0x01    // 'UP'
#define DoPE_KEY_DOWN               0x02    // 'DOWN'
#define DoPE_KEY_DPOTI              0x03    // 'DigiPoti pressed'
#define DoPE_KEY_F1                 0x04    // 'F1' function key
#define DoPE_KEY_F2                 0x05    // 'F2' function key
#define DoPE_KEY_F3                 0x06    // 'F3' function key
#define DoPE_KEY_ON                 0x07    // 'ON'
#define DoPE_KEY_TEST               0x08    // 'TEST'
#define DoPE_KEY_UPR_GRIP_OPEN      0x09    // 'Upper Grip Open'
#define DoPE_KEY_UPR_GRIP_CLOSE     0x0A    // 'Upper Grip Close'
#define DoPE_KEY_LWR_GRIP_OPEN      0x0B    // 'Lower Grip Open'
#define DoPE_KEY_LWR_GRIP_CLOSE     0x0C    // 'Lower Grip Close'
#define DoPE_KEY_EXTMETER_OPEN      0x0D    // 'Extensometer Open'
#define DoPE_KEY_EXTMETER_CLOSE     0x0E    // 'Extensometer Close'
#define DoPE_KEY_FIXED_XHEAD_UP     0x0F    // 'fixed X-Head Up'
#define DoPE_KEY_FIXED_XHEAD_DOWN   0x10    // 'fixed X-Head Down'
#define DoPE_KEY_DPOTI_CONTROL      0x11    // 'DigiPoti Speed-Position Mode'
#define DoPE_KEY_BF1                0x12    // 'blind F1' function key (no LCD)
#define DoPE_KEY_BF2                0x13    // 'blind F2' function key (no LCD)
#define DoPE_KEY_BF3                0x14    // 'blind F3' function key (no LCD)
#define DoPE_KEY_HIGH_PRESSURE      0x15    // 'Activate High Pressure'
#define DoPE_KEY_LOW_PRESSURE       0x16    // 'Activate Low Pressure'
#define DoPE_KEY_OFF                0x17    // 'OFF'
#define DoPE_KEY_UP_FAST            0x18    // 'Move UP fast'
#define DoPE_KEY_DOWN_FAST          0x19    // 'Move DOWN fast'
#define DoPE_KEY_TEST_STOP          0x1A    // 'Test stop'
#define DoPE_KEY_TEST_RETURN        0x1B    // 'Test return'
#define DoPE_KEY_TEST_HALT_CONTINUE 0x1C    // 'Test halt / continue'
#define DoPE_KEY_reserved1D         0x1D
#define DoPE_KEY_reserved1E         0x1E
#define DoPE_KEY_reserved1F         0x1F
#define DoPE_KEY_reserved20         0x20
#define DoPE_KEY_CTRL_SENSOR3       0x21    // 'Sensor 3 control'
#define DoPE_KEY_CTRL_SENSOR4       0x22    // 'Sensor 4 control'
#define DoPE_KEY_CTRL_SENSOR5       0x23    // 'Sensor 5 control'
#define DoPE_KEY_CTRL_SENSOR6       0x24    // 'Sensor 6 control'
#define DoPE_KEY_CTRL_SENSOR7       0x25    // 'Sensor 7 control'
#define DoPE_KEY_CTRL_SENSOR8       0x26    // 'Sensor 8 control'
#define DoPE_KEY_CTRL_SENSOR9       0x27    // 'Sensor 9 control'
#define DoPE_KEY_CTRL_SENSOR10      0x28    // 'Sensor 10 control'
#define DoPE_KEY_CTRL_SENSOR11      0x29    // 'Sensor 11 control'
#define DoPE_KEY_CTRL_SENSOR12      0x2A    // 'Sensor 12 control'
#define DoPE_KEY_CTRL_SENSOR13      0x2B    // 'Sensor 13 control'
#define DoPE_KEY_CTRL_SENSOR14      0x2C    // 'Sensor 14 control'
#define DoPE_KEY_CTRL_SENSOR15      0x2D    // 'Sensor 15 control'
#define DoPE_KEY_DP                 0x2E    // '.' period (decimal point)
#define DoPE_KEY_SIGN               0x2F    // '±' sign
#define DoPE_KEY_0                  0x30    // '0'
#define DoPE_KEY_1                  0x31    // '1'
#define DoPE_KEY_2                  0x32    // '2'
#define DoPE_KEY_3                  0x33    // '3'
#define DoPE_KEY_4                  0x34    // '4'
#define DoPE_KEY_5                  0x35    // '5'
#define DoPE_KEY_6                  0x36    // '6'
#define DoPE_KEY_7                  0x37    // '7'
#define DoPE_KEY_8                  0x38    // '8'
#define DoPE_KEY_9                  0x39    // '9'
#define DoPE_KEY_CTRL_POS           0x3A    // 'Position control'
#define DoPE_KEY_CTRL_LOAD          0x3B    // 'Load control'
#define DoPE_KEY_CTRL_EXTENSION     0x3C    // 'Extension control'
#define DoPE_KEY_reserved3D         0x3D
#define DoPE_KEY_LINK               0x3E    // 'Link' (RMCi only)
#define DoPE_KEY_CONNECT            0x3F
//----- OEM key ------------------- Code ---------------------------------------
#define DoPE_KEY_OEM0               0x40
#define DoPE_KEY_OEM1               0x41
#define DoPE_KEY_OEM2               0x42
#define DoPE_KEY_OEM3               0x43
#define DoPE_KEY_OEM4               0x44
#define DoPE_KEY_OEM5               0x45
#define DoPE_KEY_OEM6               0x46
#define DoPE_KEY_OEM7               0x47
#define DoPE_KEY_OEM8               0x48
#define DoPE_KEY_OEM9               0x49
#define DoPE_KEY_OEMA               0x4A
#define DoPE_KEY_OEMB               0x4B
#define DoPE_KEY_OEMC               0x4C
#define DoPE_KEY_OEMD               0x4D
#define DoPE_KEY_OEME               0x4E
#define DoPE_KEY_OEMF               0x4F
                          
                          
//----- DOLI LED ------------------ Code ---------------------------------------
#define DoPE_LED_HALT               DoPE_KEY_HALT
#define DoPE_LED_UP                 DoPE_KEY_UP
#define DoPE_LED_DOWN               DoPE_KEY_DOWN
#define DoPE_LED_DPOTI              DoPE_KEY_DPOTI
#define DoPE_LED_F1                 DoPE_KEY_F1
#define DoPE_LED_F2                 DoPE_KEY_F2
#define DoPE_LED_F3                 DoPE_KEY_F3
#define DoPE_LED_ON                 DoPE_KEY_ON
#define DoPE_LED_TEST               DoPE_KEY_TEST
#define DoPE_LED_UPR_GRIP_OPEN      DoPE_KEY_UPR_GRIP_OPEN   
#define DoPE_LED_UPR_GRIP_CLOSE     DoPE_KEY_UPR_GRIP_CLOSE  
#define DoPE_LED_LWR_GRIP_OPEN      DoPE_KEY_LWR_GRIP_OPEN   
#define DoPE_LED_LWR_GRIP_CLOSE     DoPE_KEY_LWR_GRIP_CLOSE  
#define DoPE_LED_EXTMETER_OPEN      DoPE_KEY_EXTMETER_OPEN    
#define DoPE_LED_EXTMETER_CLOSE     DoPE_KEY_EXTMETER_CLOSE   
#define DoPE_LED_FIXED_XHEAD_UP     DoPE_KEY_FIXED_XHEAD_UP         
#define DoPE_LED_FIXED_XHEAD_DOWN   DoPE_KEY_FIXED_XHEAD_DOWN       
#define DoPE_LED_DPOTI_CONTROL      DoPE_KEY_DPOTI_CONTROL
#define DoPE_LED_BF1                DoPE_KEY_BF1
#define DoPE_LED_BF2                DoPE_KEY_BF2
#define DoPE_LED_BF3                DoPE_KEY_BF3
#define DoPE_LED_HIGH_PRESSURE      DoPE_KEY_HIGH_PRESSURE
#define DoPE_LED_LOW_PRESSURE       DoPE_KEY_LOW_PRESSURE
#define DoPE_LED_OFF                DoPE_KEY_OFF
#define DoPE_LED_UP_FAST            DoPE_KEY_UP_FAST
#define DoPE_LED_DOWN_FAST          DoPE_KEY_DOWN_FAST
#define DoPE_LED_TEST_STOP          DoPE_KEY_TEST_STOP
#define DoPE_LED_TEST_RETURN        DoPE_KEY_TEST_RETURN
#define DoPE_LED_TEST_HALT_CONTINUE DoPE_KEY_TEST_HALT_CONTINUE
#define DoPE_LED_reserved1D         DoPE_KEY_reserved1D
#define DoPE_LED_reserved1E         DoPE_KEY_reserved1E
#define DoPE_LED_reserved1F         DoPE_KEY_reserved1F
#define DoPE_LED_reserved20         DoPE_KEY_reserved20
#define DoPE_LED_CTRL_SENSOR3       DoPE_KEY_CTRL_SENSOR3
#define DoPE_LED_CTRL_SENSOR4       DoPE_KEY_CTRL_SENSOR4
#define DoPE_LED_CTRL_SENSOR5       DoPE_KEY_CTRL_SENSOR5
#define DoPE_LED_CTRL_SENSOR6       DoPE_KEY_CTRL_SENSOR6
#define DoPE_LED_CTRL_SENSOR7       DoPE_KEY_CTRL_SENSOR7
#define DoPE_LED_CTRL_SENSOR8       DoPE_KEY_CTRL_SENSOR8
#define DoPE_LED_CTRL_SENSOR9       DoPE_KEY_CTRL_SENSOR9
#define DoPE_LED_CTRL_SENSOR10      DoPE_KEY_CTRL_SENSOR10
#define DoPE_LED_CTRL_SENSOR11      DoPE_KEY_CTRL_SENSOR11
#define DoPE_LED_CTRL_SENSOR12      DoPE_KEY_CTRL_SENSOR12
#define DoPE_LED_CTRL_SENSOR13      DoPE_KEY_CTRL_SENSOR13
#define DoPE_LED_CTRL_SENSOR14      DoPE_KEY_CTRL_SENSOR14
#define DoPE_LED_CTRL_SENSOR15      DoPE_KEY_CTRL_SENSOR15
#define DoPE_LED_DP                 DoPE_KEY_DP
#define DoPE_LED_SIGN               DoPE_KEY_SIGN
#define DoPE_LED_0                  DoPE_KEY_0
#define DoPE_LED_1                  DoPE_KEY_1
#define DoPE_LED_2                  DoPE_KEY_2
#define DoPE_LED_3                  DoPE_KEY_3
#define DoPE_LED_4                  DoPE_KEY_4
#define DoPE_LED_5                  DoPE_KEY_5
#define DoPE_LED_6                  DoPE_KEY_6
#define DoPE_LED_7                  DoPE_KEY_7
#define DoPE_LED_8                  DoPE_KEY_8
#define DoPE_LED_9                  DoPE_KEY_9
#define DoPE_LED_CTRL_POS           DoPE_KEY_CTRL_POS
#define DoPE_LED_CTRL_LOAD          DoPE_KEY_CTRL_LOAD
#define DoPE_LED_CTRL_EXTENSION     DoPE_KEY_CTRL_EXTENSION
#define DoPE_LED_reserved3D         DoPE_KEY_reserved3D
#define DoPE_LED_LINK               DoPE_KEY_LINK
#define DoPE_LED_CONNECT            DoPE_KEY_CONNECT
//----- OEM LED ------------------- Code ---------------------------------------
#define DoPE_LED_OEM0               DoPE_KEY_OEM0
#define DoPE_LED_OEM1               DoPE_KEY_OEM1
#define DoPE_LED_OEM2               DoPE_KEY_OEM2
#define DoPE_LED_OEM3               DoPE_KEY_OEM3
#define DoPE_LED_OEM4               DoPE_KEY_OEM4
#define DoPE_LED_OEM5               DoPE_KEY_OEM5
#define DoPE_LED_OEM6               DoPE_KEY_OEM6
#define DoPE_LED_OEM7               DoPE_KEY_OEM7
#define DoPE_LED_OEM8               DoPE_KEY_OEM8
#define DoPE_LED_OEM9               DoPE_KEY_OEM9
#define DoPE_LED_OEMA               DoPE_KEY_OEMA
#define DoPE_LED_OEMB               DoPE_KEY_OEMB
#define DoPE_LED_OEMC               DoPE_KEY_OEMC
#define DoPE_LED_OEMD               DoPE_KEY_OEMD
#define DoPE_LED_OEME               DoPE_KEY_OEME
#define DoPE_LED_OEMF               DoPE_KEY_OEMF


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdNumberOfKeyboards ( DoPE_HANDLE  DoPEHdl,
                                                      unsigned    *pNumber );

    /*
    Read the number of connected keyboards.

      In :  DoPEHdl       DoPE link handle
            pNumber       Pointer to storage for the number of keyboards

      Out :
           *pNumber       Number of connected keyboards

      Returns:            Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetKeyShiftStateSync ( DoPE_HANDLE  DoPEHdl,
                                                       unsigned     Enable );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetKeyShiftState ( DoPE_HANDLE  DoPEHdl,
                                                   unsigned     Enable,
                                                   WORD        *lpusTAN );
    /*
    Set the keyboard shift state.

      In :  DoPEHdl       DoPE link handle
            Enable        0=disable shift state, else enable shift state

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPERdKeyShiftState ( DoPE_HANDLE  DoPEHdl,
                                                  unsigned    *pEnabled );

    /*
    Read the keyboard shift state.

      In :  DoPEHdl       DoPE link handle
            pEnabled      Pointer to storage for keyboard shift state

      Out :
           *pEnabled      keyboard shift state

      Returns:            Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetLedSync ( DoPE_HANDLE      DoPEHdl,
                                             unsigned __int64 LedOn,
                                             unsigned __int64 LedOff,
                                             unsigned __int64 LedFlash,
                                             WORD             OemLedOn,
                                             WORD             OemLedOff,
                                             WORD             OemLedFlash );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetLed ( DoPE_HANDLE      DoPEHdl,
                                         unsigned __int64 LedOn,
                                         unsigned __int64 LedOff,
                                         unsigned __int64 LedFlash,
                                         WORD             OemLedOn,
                                         WORD             OemLedOff,
                                         WORD             OemLedFlash,
	                                       WORD            *lpusTAN );
    /*
    Switch On/Off LED's at the EDC keyboard.

      In :  DoPEHdl       DoPE link handle
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
    */

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPELedMask ( DoPE_HANDLE        DoPEHdl,
                                          __int32            LedCode,
                                          unsigned           State,
                                          unsigned __int64  *pLedMask,
                                          WORD              *pOemLedMask );

    /*
    Set the LED matrix bit for a given LED code.
    Each LED is represented by a bit in the LED matrix. This function converts
    a LED code to the matrix bit and sets the bit in the LED or OEM LED matrix. 

      In :  DoPEHdl                DoPE link handle
            LedCode                LED code to convert
            State                  0=clear bit, else set bit
            pLedMask/pOemLedMask   Pointer to the LED matrix
                                   (NULL pointers are accepted)

      Out :
           *pLedMask/*pOemLedMask  LED matrix

      Returns:            Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPECurrentKeys ( DoPE_HANDLE       DoPEHdl,
                                              unsigned __int64 *pKeys,
                                              WORD             *pOemKeys );

    /*
    Read the current keys.

      In :  DoPEHdl         DoPE link handle
            pKeys/pOemKeys  Pointer to storage for the key matrix

      Out :
           *pKeys/pOemKeys  current key matrix

      Returns:            Error constant (DoPERR_xxxx)
    */

/*----------------------------------------------------------------------------*/

  extern  int  DLLAPI  DoPEKeyPressed ( DoPE_HANDLE        DoPEHdl,
                                        __int32            KeyCode,
                                        unsigned __int64   Keys,
                                        WORD               OemKeys );

    /*
    Check if the key with the given key code is pressed.

      In :  DoPEHdl       DoPE link handle
            KeyCode       Key code to check
            Keys/OemKeys  Key matrix

      Returns:            0 if key is not pressed, else key is pressed
    */

/*----------------------------------------------------------------------------*/

  extern  int  DLLAPI  DoPEKeyGet ( DoPE_HANDLE        DoPEHdl,
                                    unsigned __int64  *pKeys,
                                    WORD              *pOemKeys );

    /*
    Get the key code of a pressed key.
    Each pressed key is represented by a set bit in the key matrix. This function
    converts a bit from the key matrix to it's key code and resets the bit in
    the key matrix. 

      In :  DoPEHdl         DoPE link handle
            pKeys/pOemKeys  Pointer to the key matrix

      Out :
           *pKeys/pOemKeys  Key matrix.

      Returns:              The key code of a pressed key or DoPE_KEY_NONE
    */


/*--------------------------------------------------------------------------*/
/* Obsolete Commands and Definitions                                        */
/*--------------------------------------------------------------------------*/

  /*
  DoPE handling of EDC frontpanel keys:
       The EDC-frontpanel keys are decoded and transmitted in DoPE data record
       in three WORD's, One WORD represents the active state of the keys, one
       WORD all new keys and one WORD all gone keys.
       The "0"-"9", "F1" - "F3", "." and "±" keys are coded in the low BYTE
       in ASCII, The "Up", "Down", "Halt" and "DigiPoti" keys are represented
       as single bits in the upper BYTE.
  */
  #define PE_KEY_HALT          0x0100    /* Bit mask for Key 'HALT'           */
  #define PE_KEY_UP            0x0200    /* Bit mask for Key 'UP'             */
  #define PE_KEY_DOWN          0x0400    /* Bit mask for Key 'DOWN'           */
  #define PE_KEY_DPOTI         0x0800    /* Bit mask for Key 'DigiPoti'       */

  #define PE_KEY_0             0x0030    /* Code for Key '0'                  */
  #define PE_KEY_1             0x0031    /* Code for Key '1'                  */
  #define PE_KEY_2             0x0032    /* Code for Key '2'                  */
  #define PE_KEY_3             0x0033    /* Code for Key '3'                  */
  #define PE_KEY_4             0x0034    /* Code for Key '4'                  */
  #define PE_KEY_5             0x0035    /* Code for Key '5'                  */
  #define PE_KEY_6             0x0036    /* Code for Key '6'                  */
  #define PE_KEY_7             0x0037    /* Code for Key '7'                  */
  #define PE_KEY_8             0x0038    /* Code for Key '8'                  */
  #define PE_KEY_9             0x0039    /* Code for Key '9'                  */
  #define PE_KEY_DP            0x002E    /* Code for Key '.'                  */
  #define PE_KEY_SIGN          0x00F1    /* Code for Key '±'                  */
  #define PE_KEY_F1            0x0041    /* Code for Key 'F1'                 */
  #define PE_KEY_F2            0x0042    /* Code for Key 'F2'                 */
  #define PE_KEY_F3            0x0043    /* Code for Key 'F3'                 */


  /* -------- Definitions of EDC Frontpanel LED's --------------------------- */

  #define PE_LED_UP            0x0001    /* Bit mask for LED 'UP'             */
  #define PE_LED_DOWN          0x0002    /* Bit mask for LED 'DOWN'           */
  #define PE_LED_TEST          0x0004    /* Bit mask for LED 'TEST'           */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPELedSync ( DoPE_HANDLE    DoPEHdl,
                                          unsigned short LedOn,
                                          unsigned short LedOff,
                                          unsigned short LedFlash );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPELed ( DoPE_HANDLE    DoPEHdl,
                                      unsigned short LedOn,
                                      unsigned short LedOff,
                                      unsigned short LedFlash,
                                      WORD          *lpusTAN );

    /*
    Switch On/Off LED's at EDC frontpanel.

      In :  DoPEHdl       DoPE link handle
            LedOn         These LED's will be set
            LedOff        These LED's will be reset
            LedFlash      These LED's 'flash'

            The three data WORDs will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing LED's.         (lowest)
            2.) Resetting of the LED's.
            3.) Setting of the LED's.   (highest)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */



  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
