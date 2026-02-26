/**********************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC stiffness correction handling
  

Changes :
=========
  HEG, 18.10.11
  - wrote it.
**********************************************************************************/


#ifndef DoPE_STIFFCORR_INCLUDED
#define DoPE_STIFFCORR_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++         */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif


/* ----------------------------------------------------------------------------- */


  #define SENSOR_CORR_MAX   32        /* Max. numbers of sensor corr. points     */
  
  typedef  struct                     /* Sensor Correction Table                 */
  {                                   /* --------------------------------------- */
    unsigned CorrNo;                  /* Number of valid entries             [No]*/
    double   S1Correction[SENSOR_CORR_MAX]; /* Correction values for S1    [Unit]*/
    double   S2Value[SENSOR_CORR_MAX];      /* S2 values (must be in ascending order) [Unit]*/
  } DoPESensorCorrection;


  extern  unsigned  DLLAPI  DoPESetSensorCorrectionSync( DoPE_HANDLE           DoPEHdl,
                                                         unsigned short        CalculatedSensor,
                                                         DoPESensorCorrection *CorrTab );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

  extern  unsigned  DLLAPI  DoPESetSensorCorrection( DoPE_HANDLE           DoPEHdl,
                                                     unsigned short        CalculatedSensor,
                                                     DoPESensorCorrection *CorrTab,
                                                     WORD                 *lpusTAN );

    /*
    Set sensor correction table.

      In :  DoPEHdl            DoPE link handle
            CalculatedSensor   Position in measuring data record for the
                               corrected sensor value.
            *CorrTab           Pointer to sensor correction table

      Out :
           *lpusTAN            Pointer to TAN used from this command

      Returns:                 Error constant (DoPERR_xxxx)
    */


/* ----------------------------------------------------------------------------- */


  #define STIFF_CORR_MAX   32         /* Max. numbers of stiff. corr. points     */
  
  typedef  struct                     /* Stiffness Correction Table              */
  {                                   /* --------------------------------------- */
    unsigned CorrNo;                  /* Number of valid entries             [No]*/
    double   Load[STIFF_CORR_MAX];    /* Load value                        [Unit]*/
    double   Deformation[STIFF_CORR_MAX];  /* Machine deformation at load value [Unit]*/
  } DoPEStiffnessCorrection;


  extern  unsigned  DLLAPI  DoPESetStiffnessCorrectionSync( DoPE_HANDLE              DoPEHdl,
                                                            DoPEStiffnessCorrection *CorrTab );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

  extern  unsigned  DLLAPI  DoPESetStiffnessCorrection( DoPE_HANDLE              DoPEHdl,
                                                        DoPEStiffnessCorrection *CorrTab,
                                                        WORD                    *lpusTAN );

    /*
    Set stiffness correction table.

      In :  DoPEHdl     DoPE link handle
            *CorrTab    Pointer to stiffness correction table

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* ----------------------------------------------------------------------------- */


  #ifdef __cplusplus
  }       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
