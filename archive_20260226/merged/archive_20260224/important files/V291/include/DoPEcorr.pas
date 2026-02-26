{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC stiffness correction handling
  

Changes :
=========
  HEG, 18.10.11
  - wrote it.
*****************************************************************************}


unit DoPEcorr;


{$ALIGN OFF}


interface

uses Windows, DoPE;


{. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

const
  SENSOR_CORR_MAX = 32;                // Max. numbers of sensor corr. points

type                                   { 'Sensor Correction Table'             }
   DoPESensorCorrection = record       { ------------------------------------- }
    CorrNo       : DWord;              { Number of valid entries           [No]}
    Reserved1    : DWord;
    S1Correction : array[0..SENSOR_CORR_MAX-1] of Double;
                                       { Correction values for S1        [Unit]}
    S2Value      : array[0..SENSOR_CORR_MAX-1] of Double;
                                       { S2 values (must be in ascending order) [Unit]}
   end;

{ ---------------------------------------------------------------------------- }

function DoPESetSensorCorrectionSync ( DoPEHdl          : DoPE_HANDLE;
                                       CalculatedSensor : Word;
                                   var CorrTab          : DoPESensorCorrection): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESetSensorCorrection ( DoPEHdl          : DoPE_HANDLE;
                                   CalculatedSensor : Word;
                               var CorrTab          : DoPESensorCorrection;
                                   usTAN            : PWord ): DWord; STDCALL;
    {
    Set sensor correction table.

      In :  DoPEHdl            DoPE link handle
            CalculatedSensor   Position in measuring data record for the
                               corrected sensor value.
            *CorrTab           Pointer to sensor correction table

      Out :
           *lpusTAN            Pointer to TAN used from this command

      Returns:                 Error constant (DoPERR_xxxx)
    }


{. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

const
  STIFF_CORR_MAX = 32;                 // Max. numbers of stiff. corr. points

type                                   { 'Stiffness Correction Table'          }
   DoPEStiffnessCorrection = record    { ------------------------------------- }
    CorrNo      : DWord;               { Number of valid entries           [No]}
    Reserved1   : DWord;
    Load        : array[0..STIFF_CORR_MAX-1] of Double;
                                       { Load value                      [Unit]}
    Deformation : array[0..STIFF_CORR_MAX-1] of Double;
                                       { Machine deformation at load value [Unit]}
   end;

{ ---------------------------------------------------------------------------- }

function DoPESetStiffnessCorrectionSync ( DoPEHdl : DoPE_HANDLE;
                                      var CorrTab : DoPEStiffnessCorrection): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESetStiffnessCorrection ( DoPEHdl : DoPE_HANDLE;
                                  var CorrTab : DoPEStiffnessCorrection;
                                      usTAN   : PWord ): DWord; STDCALL;
    {
    Set stiffness correction table.

      In :  DoPEHdl       DoPE link handle
            *CorrTab      Pointer to stiffness correction table

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }



implementation

//**************************************************************************************************
function DoPESetSensorCorrectionSync ( DoPEHdl          : DoPE_HANDLE;
                                       CalculatedSensor : Word;
                                   var CorrTab          : DoPESensorCorrection): DWord; STDCALL;

   external 'DoPE.dll';
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESetSensorCorrection ( DoPEHdl          : DoPE_HANDLE;
                                   CalculatedSensor : Word;
                               var CorrTab          : DoPESensorCorrection;
                                   usTAN            : PWord ): DWord; STDCALL;
                                   
   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetStiffnessCorrectionSync ( DoPEHdl : DoPE_HANDLE;
                                      var CorrTab : DoPEStiffnessCorrection): DWord; STDCALL;

   external 'DoPE.dll';
{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }
function DoPESetStiffnessCorrection ( DoPEHdl : DoPE_HANDLE;
                                  var CorrTab : DoPEStiffnessCorrection;
                                      usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************

end.
