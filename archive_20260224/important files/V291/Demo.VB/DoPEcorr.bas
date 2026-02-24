Attribute VB_Name = "DoPEcorr"
Option Explicit

'******************************************************************************
' Project: DoPE
' (C) DOLI Elektronik GmbH, 2006-present
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) stiffness correction handling
'
' Versions:
' ---------
'
' HEG, 18.10.11
' - wrote it.
'
'******************************************************************************

'/* ----------------------------------------------------------------------------- */

Public Const SENSOR_CORR_MAX = 32            ' Max. numbers of sensor corr. points

Type DoPESensorCorrection                    ' sensor Correction Table              
  CorrNo                          As Long    ' Number of valid entries                [No]
  Pad1                            As Long    ' internal fill charcters
  S1Correction(SENSOR_CORR_MAX-1) As Double  ' Correction values for S1               [Unit]
  S2Value(SENSOR_CORR_MAX-1)      As Double  ' S2 values (must be in ascending order) [Unit]
End Type

Declare Function DoPEVBSetSensorCorrectionSync Lib "dope.dll" Alias "DoPESetSensorCorrectionSync" (ByVal DoPEHdl As Long, ByVal CalculatedSensor As Integer, ByRef CorrTab As DoPESensorCorrection) As Long
Declare Function DoPEVBSetSensorCorrection Lib "dope.dll" Alias "DoPESetSensorCorrection" (ByVal DoPEHdl As Long, ByVal CalculatedSensor As Integer, ByRef CorrTab As DoPESensorCorrection, ByRef lpusTAN As Integer) As Long

'
'
'  #define SENSOR_CORR_MAX   32        /* Max. numbers of sensor corr. points     */
'  
'  typedef  struct                     /* Sensor Correction Table                 */
'  {                                   /* --------------------------------------- */
'    unsigned CorrNo;                  /* Number of valid entries             [No]*/
'    double   S1Correction[SENSOR_CORR_MAX]; /* Correction values for S1    [Unit]*/
'    double   S2Value[SENSOR_CORR_MAX];      /* S2 values (must be in ascending order) [Unit]*/
'  } DoPESensorCorrection;
'
'
'  extern  unsigned  DLLAPI  DoPESetSensorCorrectionSync( DoPE_HANDLE           DoPEHdl,
'                                                         unsigned short        CalculatedSensor,
'                                                         DoPESensorCorrection *CorrTab );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
'
'  extern  unsigned  DLLAPI  DoPESetSensorCorrection( DoPE_HANDLE           DoPEHdl,
'                                                     unsigned short        CalculatedSensor,
'                                                     DoPESensorCorrection *CorrTab,
'                                                     WORD                 *lpusTAN );
'
'    /*
'    Set sensor correction table.
'
'      In :  DoPEHdl            DoPE link handle
'            CalculatedSensor   Position in measuring data record for the
'                               corrected sensor value.
'            *CorrTab           Pointer to sensor correction table
'
'      Out :
'           *lpusTAN            Pointer to TAN used from this command
'
'      Returns:                 Error constant (DoPERR_xxxx)
'    */
'
'
'/* ----------------------------------------------------------------------------- */

Public Const STIFF_CORR_MAX = 32           ' Max. numbers of stiff. corr. points

Type DoPEStiffnessCorrection               ' Stiffness Correction Table              
  CorrNo                        As Long    ' Number of valid entries             [No]
  Pad1                          As Long    ' internal fill charcters
  Load(STIFF_CORR_MAX-1)        As Double  ' Load value                        [Unit]
  Deformation(STIFF_CORR_MAX-1) As Double  ' Machine deformation at load value [Unit]
End Type

Declare Function DoPEVBSetStiffnessCorrectionSync Lib "dope.dll" Alias "DoPESetStiffnessCorrectionSync" (ByVal DoPEHdl As Long, ByRef CorrTab As DoPEStiffnessCorrection) As Long
Declare Function DoPEVBSetStiffnessCorrection Lib "dope.dll" Alias "DoPESetStiffnessCorrection" (ByVal DoPEHdl As Long, ByRef CorrTab As DoPEStiffnessCorrection, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPESetStiffnessCorrectionSync( DoPE_HANDLE              DoPEHdl,
'                                                            DoPEStiffnessCorrection *CorrTab );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
'
'  extern  unsigned  DLLAPI  DoPESetStiffnessCorrection( DoPE_HANDLE              DoPEHdl,
'                                                        DoPEStiffnessCorrection *CorrTab,
'                                                        WORD                    *lpusTAN );
'
'    /*
'    Set stiffness correction table.
'
'      In :  DoPEHdl       DoPE link handle
'            *CorrTab      Pointer to stiffness correction table
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* ----------------------------------------------------------------------------- */
