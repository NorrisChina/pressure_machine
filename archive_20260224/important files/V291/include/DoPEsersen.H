/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface serial sensor handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEsersen_INCLUDED
#define DoPEsersen_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

//----------------------------------------------------------------------------

  /* Constants for serial sensor definition Init value

  Stucture of Init word :
    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    Db Pa Pa Pc Pc Pc Pc Bd Bd Bd Bd Sb Po Po Po Si

    Db =  0 => 7 Data Bits
          1 => 8 Data Bits
    Pa =  0 => No   Parity
          1 => Odd  Parity
          2 => Even Parity
    Pc =  0 => No Protocol
          1 => DOLI Standard binary protocol
               (DLE STX D1 D2 D3 D4 CRC_H CRC_L) with DLE duplication
          2    Eurothem temperature controller
          3    Grado temperature controller
          4    AI_808 temperature controller
          5    Modbus Eurothem temperature controller
          6    Modbus Grado temperature controller
          7    Modbus Shimanden SRP30 temperature controller
          8    Modbus Azbil SDC35/36 temperature controller
          9-15 not yet used
    Bd =  0 =>    110 Baud
          1       150 BAUD
          2       300 BAUD
          3       600 BAUD
          4      1200 BAUD
          5      2400 BAUD
          6      4800 BAUD
          7      9600 BAUD
          8     19200 BAUD
          9     38400 BAUD
         10     57600 BAUD
         11    115200 BAUD
         12    230400 BAUD
         13    460800 BAUD
         14    921600 BAUD
    Sb =  0 => 1 Stop Bit
          1    2 Stop Bits
    Po =  0 => DB_COM_DEBUG
          1    DB_COM_COM1
          2    DB_COM_COM2
          3    DB_COM_COM3
          4-7  not used
    Si =  0 => positive Polarity
          1    negative Polarity
  */

#define SERSEN_SIGN_P        0x0000
#define SERSEN_SIGN_N        0x0001

#define SERSEN_PORT_DEBUG    0x0000
#define SERSEN_PORT_COM1     0x0002
#define SERSEN_PORT_COM2     0x0004
#define SERSEN_PORT_COM3     0x0006

#define SERSEN_STOPBIT_1     0x0000
#define SERSEN_STOPBIT_2     0x0010

#define SERSEN_110BAUD       0x0000
#define SERSEN_150BAUD       0x0020
#define SERSEN_300BAUD       0x0040
#define SERSEN_600BAUD       0x0060
#define SERSEN_1200BAUD      0x0080
#define SERSEN_2400BAUD      0x00A0
#define SERSEN_4800BAUD      0x00C0
#define SERSEN_9600BAUD      0x00E0
#define SERSEN_19200BAUD     0x0100
#define SERSEN_38400BAUD     0x0120
#define SERSEN_57600BAUD     0x0140
#define SERSEN_115200BAUD    0x0160
#define SERSEN_230400BAUD    0x0180
#define SERSEN_460800BAUD    0x01A0
#define SERSEN_921600BAUD    0x01C0

#define SERSEN_NOPROTOCOL        0x0000
#define SERSEN_DOLIPROTOCOL      0x0200
#define SERSEN_EUROTHERM         0x0400
#define SERSEN_GRADO             0x0600
#define SERSEN_AI_808            0x0800
#define SERSEN_MODBUS_EUROTHERM  0x0A00
#define SERSEN_MODBUS_GRADO      0x0C00
#define SERSEN_MODBUS_SHIMANDEN  0x0E00
#define SERSEN_MODBUS_AZBIL      0x1000

#define SERSEN_NOPARITY      0x0000
#define SERSEN_ODDPARITY     0x2000
#define SERSEN_EVENPARITY    0x4000

#define SERSEN_7DATABIT      0x0000
#define SERSEN_8DATABIT      0x8000


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESerialSensorDefSync ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  SensorNo,
                                                      double          Timeout,
                                                      unsigned short  MaxLength,
                                                      char            EndChar1,
                                                      char            EndChar2,
                                                      WORD            EndCharMode );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESerialSensorDef ( DoPE_HANDLE     DoPEHdl,
                                                  unsigned short  SensorNo,
                                                  double          Timeout,
                                                  unsigned short  MaxLength,
                                                  char            EndChar1,
                                                  char            EndChar2,
                                                  WORD            EndCharMode,
                                                  WORD           *lpusTAN );

    /*
    Definition for serial sensor.
    A message for a serial sensor will be transmitted after:

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Timeout       Timeout, 0 = no timeout
            MaxLength     Transmit after Number of bytes received
                          (must be <= SERSEN_TRANSFER)
            EndChar1      First  Endcharacter
            EndChar2      Second Endcharacter
            EndCharMode   SERSEN_ENDCHAR_NO
                          SERSEN_ENDCHAR_1
                          SERSEN_ENDCHAR_1_OR_2
                          SERSEN_ENDCHAR_1_AND_2
                          SERSEN_ENDCHAR_1_PLUS1

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

    #define SERSEN_TRANSFER        80  /* MaxLength limit                    */
    #define SERSEN_ENDCHAR_NO       0  /* No Endcharacter active             */
    #define SERSEN_ENDCHAR_1        1  /* Detect only EndChar1               */
    #define SERSEN_ENDCHAR_1_OR_2   2  /* Detect EndChar1 or EndChar1        */
    #define SERSEN_ENDCHAR_1_AND_2  3  /* Detect Sequence EndChar1 + EndChar2*/
    #define SERSEN_ENDCHAR_1_PLUS1  4  /* Detect EndChar1 plus one Character */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetSerialSensorSync ( DoPE_HANDLE     DoPEHdl,
                                                      unsigned short  SensorNo,
                                                      unsigned short  Mode,
                                                      double          Value,
                                                      double          Speed );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetSerialSensor ( DoPE_HANDLE     DoPEHdl,
                                                  unsigned short  SensorNo,
                                                  unsigned short  Mode,
                                                  double          Value,
                                                  double          Speed,
                                                  WORD           *lpusTAN );

    /*
    Set value (e.g. Temperature) for serial channel.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          SERSEN_SET_COMMAND
                          SERSEN_SET_FEEDBACK
            Value         Value to set
            Speed         Speed for ramp

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

    #define SERSEN_SET_COMMAND    0    /* Set Command value                  */
    #define SERSEN_SET_FEEDBACK   1    /* Set Feedback value                 */


/*---------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetSerialSensorTransparentSync ( DoPE_HANDLE     DoPEHdl,
                                                                 unsigned short  SensorNo,
                                                                 unsigned short  Mode );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetSerialSensorTransparent ( DoPE_HANDLE     DoPEHdl,
                                                             unsigned short  SensorNo,
                                                             unsigned short  Mode,
                                                             WORD           *lpusTAN );

    /*
    Set serial channel to transparent mode or the previously selected protocol.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          SERSEN_SET_PROTOCOL
                          SERSEN_SET_TRANSPARENT

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

    #define SERSEN_SET_PROTOCOL     0  /* Set sensor to the protocol defined */
                                       /* by the sensors init. value         */
    #define SERSEN_SET_TRANSPARENT  1  /* Set sensor to transparent mode     */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEWrSensorMsgSync ( DoPE_HANDLE     DoPEHdl,
                                                  unsigned short  SensorNo,
                                                  void           *Buffer,
                                                  unsigned        Length );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEWrSensorMsg ( DoPE_HANDLE     DoPEHdl,
                                              unsigned short  SensorNo,
                                              void           *Buffer,
                                              unsigned        Length,
                                              WORD           *lpusTAN );

    /*
    Write a message to a sensor.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Buffer        Pointer to message to transmit
            Length        Message length in BYTEs

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
