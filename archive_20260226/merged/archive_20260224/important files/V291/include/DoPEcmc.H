/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface calculated measuring channels and
   peak value handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG, 21.5.13
  - new definitions for calculated sensors:
    - MAX_CALCULATED_CHANNELS
    - F_S1PlusS2_half, F_S1MinusS2, F_S1PlusS2PlusS3_third, F_S1PlusS2PlusS3
      F_S1PlusS2, F_StiffnessCorrection, F_SensorCorrection, F_ExtendedFormula,
      F_S1PlusS2PlusS3PlusS4_quarter, F_S1PlusS2PlusS3PlusS4
*******************************************************************************/


#ifndef DoPEcmc_INCLUDED
#define DoPEcmc_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

//----------------------------------------------------------------------------

  // -------------- Definitions for calculated Sensors ---------------------- 
  // -----------This channels can be used for control !!! --------------------

  #define MAX_CALCULATED_CHANNELS        4    // Maximum number of calculated measuring channels

                                              // Constants for Calculated Sensor Init Value
  #define F_S1PlusS2_half                0    // S = (((S1 + S2) / 2)     / Corr) - Offset
  #define F_S1MinusS2                    1    // S =  ((S1 - S2)          / Corr) - Offset
  #define F_S1PlusS2PlusS3_third         2    // S = (((S1 + S2+ S3) / 3) / Corr) - Offset
  #define F_S1PlusS2PlusS3               3    // S =  ((S1 + S2+ S3)      / Corr) - Offset
  #define F_S1PlusS2                     4    // S =  ((S1 + S2)          / Corr) - Offset
  #define F_StiffnessCorrection          5    // S =  ((S  - f(F)         / Corr) - Offset
  #define F_SensorCorrection             6    // S =  ((S1 - f(S2)        / Corr) - Offset
  #define F_ExtendedFormula              7

                                              // Sensors must be in in ascending order starting at S1 !!
  #define F_S1PlusS2PlusS3PlusS4_quarter 7    // S = (((S1 + S2+ S3+ S4) / 4) / Corr) - Offset
  #define F_S1PlusS2PlusS3PlusS4         8    // S = ((S1 + S2+ S3+ S4)       / Corr) - Offset

  // The formula and used sensor are all coded in a 16Bit value:
  // 1. For formula 0 - 6 may use three sensors:
  //S3          S2          S1          Formula  Sign
  //___________ ___________ ___________ ________ __
  //15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
  //
  //
  // 2. For formula 7 - 23 Bits 1-3 must be "1" and the formula is in Bits 12 - 15
  //    These extented formulas can only use two Sensors, or the sensors must be in in ascending order
  //ExtFormula  S2          S1          Value 7  Sign
  //___________ ___________ ___________ ________ __
  //15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEConfCMcSpeedSync  ( DoPE_HANDLE DoPEHdl,
                                                    WORD        CalculatedSensorNo,
                                                    WORD        SensorNo,
                                                    double      IntegrationTime,
                                                    double      Timebase );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEConfCMcSpeed  ( DoPE_HANDLE DoPEHdl,
                                                WORD        CalculatedSensorNo,
                                                WORD        SensorNo,
                                                double      IntegrationTime,
                                                double      Timebase,
                                                WORD       *lpusTANFirst,
                                                WORD       *lpusTANLast );

    /*
    Configure calculated speed to measuring data record.
    From any measuring channel speed (the first differentiation)
    may be calculated and configured to the data record.
    After it is configured, it may be used as the supervised
    channel in the command "DoPESetCheck".
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Position in measuring data record for the
                                calculated speed value.
                                Any value between SENSOR4 to SENSOR15 is valid.
            SensorNo            SensorNo to calculate speed of
            IntegrationTime     Integration time for data acquisition
                                (only relevant for analogue channels)
                                maximum 100 * cycle time of seed controller.
            Timebase            Time base for speed calculation
                                maximum 2.56 sec.

      Out:
            *lpusTANFirst       Pointer to first TAN used from this command
            *lpusTANLast        Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEConfCMcCommandSpeedSync  ( DoPE_HANDLE DoPEHdl,
                                                           WORD        CalculatedSensorNo,
                                                           double      Timebase );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEConfCMcCommandSpeed  ( DoPE_HANDLE DoPEHdl,
                                                       WORD        CalculatedSensorNo,
                                                       double      Timebase,
                                                       WORD       *lpusTANFirst,
                                                       WORD       *lpusTANLast );

    /*
    Configure calculated speed of command output to data record.
    Speed of command output (the first differentiation)
    may be calculated and configured to the data record.
    After it is configured, it may be used as the supervised
    channel in the command "DoPESetCheck".
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Position in measuring data record for the
                                calculated command speed.
            Timebase            Time base for speed calculation.
                                maximum 2.56 sec.
      Out:
            *lpusTANFirst       Pointer to first TAN used from this command
            *lpusTANLast        Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* ------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEConfCMcGradientSync  ( DoPE_HANDLE DoPEHdl,
                                                       WORD        CalculatedSensorNo,
                                                       WORD        DividentSensorNo,
                                                       WORD        DivisorSensorNo,
                                                       double      IntegrationTime,
                                                       double      Timebase );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEConfCMcGradient  ( DoPE_HANDLE DoPEHdl,
                                                   WORD        CalculatedSensorNo,
                                                   WORD        DividentSensorNo,
                                                   WORD        DivisorSensorNo,
                                                   double      IntegrationTime,
                                                   double      Timebase,
                                                   WORD       *lpusTANFirst,
                                                   WORD       *lpusTANLast );

    /*
    Configure calculated gradient between two measured values to measuring data record.
    A gradient between two measured values
    may be calculated and configured to the data record.
    After it is configured, it may be used as the supervised
    channel in the command "DoPESetCheck".
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Position in measuring data record for the
                                calculated gradient.
            DividentSensorNo    Sensor No. for Dividend
            DivisorSensorNo     Sensor No. for Divisor
            IntegrationTime     Integration time for data acquisition
                                (only relevant for analogue channels)
                                maximum 100 * cycle time of speed controller.
            Timebase            Time base for gradient calculation
                                maximum 2.56 sec.
      Out:
            *lpusTANFirst       Pointer to first TAN used from this command
            *lpusTANLast        Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEClearCMcSync  ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short CalculatedSensorNo );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEClearCMc  ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short CalculatedSensorNo,
                                            WORD          *lpusTANFirst,
                                            WORD          *lpusTANLast );

    /*
    Clear calculated measuring channel.
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Sensor Number 0 .. 9
      Out:
            *lpusTANFirst       Pointer to first TAN used from this command
            *lpusTANLast        Pointer to last TAN used from this command

      Returns:                  Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEConfPeakValueSync  ( DoPE_HANDLE DoPEHdl,
                                                     WORD        PositionMin,
                                                     WORD        PositionMax,
                                                     WORD        LoadMin,
                                                     WORD        LoadMax,
                                                     WORD        ExtensionMin,
                                                     WORD        ExtensionMax );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEConfPeakValue  ( DoPE_HANDLE DoPEHdl,
                                                 WORD        PositionMin,
                                                 WORD        PositionMax,
                                                 WORD        LoadMin,
                                                 WORD        LoadMax,
                                                 WORD        ExtensionMin,
                                                 WORD        ExtensionMax,
                                                 WORD       *lpusTANFirst,
                                                 WORD       *lpusTANLast );
    /*
    Configure peakvalues to measuring data record.
    The peak values are detected by the EDC. They may be transmitted to PC instead of
    an unused measuring channel. With this command the peak values for X-head position, load
    and extension may be configured to measuring channels in the data record.
    SENSOR4 to SENSOR15 are allowed to be configured as peak values.
    e.g. use the constant SENSOR4 for PositionMin to configure the minimum value of
    X-head position to SENSOR4 within the measuring data record.
    Any number outside SENSOR4 to SENSOR15 will reset the measuring channels to the original
    values. Use this feature to cancel Peak Values configuration.
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.

      In :  DoPEHdl           DoPE link handle
            PositionMin       Position of Minimun value of XHead Position
            PositionMax       Position of Maximum value of XHead Position
            LoadMin           Position of Minimun value of Load
            LoadMax           Position of Maximum value of Load
            ExtensionMin      Position of Minimun value of Extension
            ExtensionMax      Position of Maximum value of Extension

      Out:
            *lpusTANFirst     Pointer to first TAN used from this command
            *lpusTANLast      Pointer to last TAN used from this command


      Returns:          Error constant (DoPERR_xxxx)

    */

    
/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEPeakValueTimeSync  ( DoPE_HANDLE DoPEHdl,
                                                     double      Time );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEPeakValueTime  ( DoPE_HANDLE DoPEHdl,
                                                 double      Time,
                                                 WORD       *lpusTAN );

    /*
    Set reset time for peak value detection.
    The maximum and minimum values within this time are considered as peak values.
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl      DoPE link handle
            Time         Reset time for peak value detection

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
