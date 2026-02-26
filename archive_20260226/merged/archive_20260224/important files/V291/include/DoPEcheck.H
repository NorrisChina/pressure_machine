/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface Measuring Channel Check handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEcheck_INCLUDED
#define DoPEcheck_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

  /* ------ Constants for  'CheckID' in DoPESetCheck ------------------------ */

  #define  CHK_ID0         0        /* channel supervision ID 0               */
  #define  CHK_ID1         1        /* channel supervision ID 1               */
  #define  CHK_ID2         2        /* channel supervision ID 2               */
  #define  CHK_ID3         3        /* channel supervision ID 3               */
  #define  CHK_ID4         4        /* channel supervision ID 4               */
  #define  CHK_ID5         5        /* channel supervision ID 5               */
  #define  CHK_ID6         6        /* channel supervision ID 6               */
  #define  CHK_ID7         7        /* channel supervision ID 7               */
  #define  CHK_ID8         8        /* channel supervision ID 8               */
  #define  CHK_ID9         9        /* channel supervision ID 9               */
  #define  CHK_NUMBER      10       /* Number of channel supervisions         */
  #define  CHK_ID_ALL      0xFFFF   /* All supervision ID's (for clear)       */
  #define  CHK_NOCLEAR     0x8000   /* Mask to "or" with CHK_Idx for checks   */
                                    /* that should not be cleared after       */
                                    /* another check hits                     */


/* ------ Constants  for 'Mode' in DoPESetCheck   --------------------------- */

  #define  CHK_BELOW       0        /* Condition (value < Limit)              */
  #define  CHK_ABOVE       1        /* Condition (value > Limit)              */
  #define  CHK_PERCENT_MAX 2        /* Condition (value < % of max value)     */
  #define  CHK_PERCENT_MIN 3        /* Condition (value > % of min value)     */
  #define  CHK_ABS_MAX     4        /* Condition (value < max - x)            */
  #define  CHK_ABS_MIN     5        /* Condition (value > min - x)            */
  
  
/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetCheckSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short CheckId,
                                               unsigned short SensorNo,
                                               double         Limit,
                                               unsigned short Mode,
                                               unsigned short Action,
                                               unsigned short Ctrl,
                                               double         Acc,
                                               double         Speed,
                                               double         Dec,
                                               double         Destination,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetCheck ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short CheckId,
                                           unsigned short SensorNo,
                                           double         Limit,
                                           unsigned short Mode,
                                           unsigned short Action,
                                           unsigned short Ctrl,
                                           double         Acc,
                                           double         Speed,
                                           double         Dec,
                                           double         Destination,
                                           WORD          *lpusTAN );
    /*
    Activate measuring channel supervision.
    A measuring channel can be supervised and an action activated if the
    channel hits the specified limit. Up to 10 channel supervisions may be
    active at the same time. If one check hits, all supervisions are disabled.

      In :  DoPEHdl       DoPE link handle
            CheckId       ID of this check, use the CheckId constants
            SensorNo      Sensor to be supervised
            Limit         Limit to be supervised
            Mode          Sensor > Limit or Sensor < Limit
            Action        This action will be activated if the check hits.
            Ctrl          Control mode for selected action
            Acc           Acceleration
            Speed         maximum speed
            Dec           Deceleration
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetCheckXSync ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short CheckId,
                                                unsigned short SensorNo,
                                                double         Limit,
                                                double         Tare,
                                                unsigned short Mode,
                                                unsigned short Action,
                                                unsigned short Ctrl,
                                                double         Acc,
                                                double         Speed,
                                                double         Dec,
                                                double         Destination,
                                                WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetCheckX ( DoPE_HANDLE    DoPEHdl,
                                            unsigned short CheckId,
                                            unsigned short SensorNo,
                                            double         Limit,
                                            double         Tare,
                                            unsigned short Mode,
                                            unsigned short Action,
                                            unsigned short Ctrl,
                                            double         Acc,
                                            double         Speed,
                                            double         Dec,
                                            double         Destination,
                                            WORD          *lpusTAN );

    /*
    Activate measuring channel supervision.
    A measuring channel can be supervised and an action activated if the
    channel hits the specified limit. Up to 10 channel supervisions may be
    active at the same time. If one check hits, all supervisions are disabled.

      In :  DoPEHdl       DoPE link handle
            CheckId       ID of this check, use the CheckId constants
            SensorNo      Sensor to be supervised
            Limit         Limit to be supervised
            Tare          Active tare (only for CHK_PERCENT_MAX/MIN)
            Mode          Sensor > Limit or Sensor < Limit
            Action        This action will be activated if the check hits.
            Ctrl          Control mode for selected action
            Acc           Acceleration
            Speed         maximum speed
            Dec           Deceleration
            Destination   Final destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*----------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEClrCheckSync ( DoPE_HANDLE    DoPEHdl,
                                               unsigned short CheckId,
                                               WORD          *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEClrCheck ( DoPE_HANDLE    DoPEHdl,
                                           unsigned short CheckId,
                                           WORD          *lpusTAN );

    /*
    Deactivate a measuring channel supervision

      In :  DoPEHdl       DoPE link handle
            CheckId       ID of this check, use the CheckId constants

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetCheckLimitSync ( DoPE_HANDLE    DoPEHdl,
                                                    unsigned short SensorNo,
                                                    double         UprLimitSet,
                                                    double         UprLimitReset,
                                                    double         LwrLimitReset,
                                                    double         LwrLimitSet );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetCheckLimit ( DoPE_HANDLE    DoPEHdl,
                                                unsigned short SensorNo,
                                                double         UprLimitSet,
                                                double         UprLimitReset,
                                                double         LwrLimitReset,
                                                double         LwrLimitSet,
                                                WORD          *lpusTAN );

    /*
    Activate measuring channel supervision.

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor to be supervised
            UprLimitSet    Upper limit when Grip-IO is activated
            UprLimitReset  Upper limit when Grip-IO is deactivated
            LwrLimitReset  Lower Limit when Grip-IO is deactivated
            LwrLimitSet    Lower Limit when Grip-IO is activated

      Out :
           *lpusTAN        Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEClrCheckLimitSync ( DoPE_HANDLE DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEClrCheckLimit ( DoPE_HANDLE DoPEHdl,
                                                WORD       *lpusTAN );

    /*
    Deactivate a measuring channel supervision

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPESetCheckLimitIOSync ( DoPE_HANDLE DoPEHdl,
                                                      WORD        Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESetCheckLimitIO ( DoPE_HANDLE DoPEHdl,
                                                  WORD        Value,
                                                  WORD       *lpusTAN );

    /*
    Set / reset measuring channel supervision IO

      In :  DoPEHdl       DoPE link handle
            Value         0 = reset, 1 = set

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
