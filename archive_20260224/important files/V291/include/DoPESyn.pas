{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 2006-present

Description :
=============

   Header for DOLI PC-EDC  synchronized datainterface for Windows
  

Changes :
=========
  HEG, 11.5.06
  - wrote it.

  HEG, 21.7.06
  - SYNCHRONIZE_MAX defined
  
  FEZ, 18.4.07
  - Changed to $ALIGN OFF

  HEG, 16.10.09 - V2.66
  - Source code layout adapted to C++ header

  HEG, 3.2.10 - V2.67
  - Buffer utilization added to DoPEOnSynchronizeData record
  - New DoPE functions:
    - DoPESetOnSynchronizeDataOverflowHdlr
    - DoPESetOnSynchronizeDataOverflowRtHdlr
*******************************************************************************}

unit DoPESyn;

{$ALIGN OFF}

interface

uses Windows, DoPE;

  { --------- Eventhandler definitions --------------------------------------- }
  
type                                   { Synchronized measuring data record    }
   DoPELinkData = record               { ------------------------------------- }
    DP        : DoPE_HANDLE;           { DoPE link handle                      }
    Reserved1 : DWord;                 { 8-Byte Alignment                      }
    Data      : DoPEData;              { Measuring data record                 }
    Reserved2 : Word;                  { 8-Byte Alignment                      }
end;

type                                   { Synchronized measuring data matrix   }
   DoPEOnSynchronizeData = record      { ------------------------------------ }
    DoPError      : DWord;             { DoPE error code                 [No] }
    nData         : DWord;             { Number of measuring data records     }
    Sample        : ^DoPELinkData;     { Array of measuring data records      }
    Occupied      : Double;            { Utilization   [% of data buffer size]}
end;

type
  DoPEOnSynchronizeDataHdlr = FUNCTION  ( var OnSyncData : DoPEOnSynchronizeData;
                                              Buffer     : Pointer ): DWord; STDCALL;
    {
     Handler for received synchronized measuring data records
       DoPEOnSynchronizeData   received synchronized measuring data records
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataHdlr
     should return 0 (reserved for future versions)
    }

type
  DoPEOnSynchronizeDataRtHdlr = FUNCTION ( var OnSyncData : DoPEOnSynchronizeData;
                                               Buffer     : Pointer ): DWord; STDCALL;
  {
     Realtime handler for received synchronized measuring data records
       DoPEOnSynchronizeData   received measuring data record
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataRtHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type
  DoPEOnSynchronizeDataOverflowHdlr = FUNCTION  ( Buffer : Pointer ): DWord; STDCALL;
    {
     Handler for received synchronized measuring data events
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowHdlr
     should return 0 (reserved for future versions)
    }

type
  DoPEOnSynchronizeDataOverflowRtHdlr = FUNCTION ( Buffer : Pointer ): DWord; STDCALL;
  {
     Realtime handler for received synchronized measuring data overflow events
       LPVOID                  userspecific pointer set with DoPESetOnSynchronizeDataOverflowRtHdlr
     should return 0 (reserved for future versions)
  }

{ ---------------------------------------------------------------------------- }

function DoPESetOnSynchronizeDataHdlr ( Hdlr        : DoPEOnSynchronizeDataHdlr;
                                        lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSynchronizeData handler.

      In :  Hdlr        is called at application priority with every
                        received synchronized sample

      Returns:          Error constant (DoPERR_xxxx)

    The DoPE 'synchronize data' event handler uses internaly the windows message
    WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message number
    if the DoPE 'synchronize data' event handler should be used!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSynchronizeDataRtHdlr ( Hdlr        : DoPEOnSynchronizeDataRtHdlr;
                                          lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnSynchronizeData handler.

      In :  Hdlr        is called from the high priotity communication thread
                        with every received synchronized sample

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSynchronizeDataOverflowHdlr ( Hdlr        : DoPEOnSynchronizeDataOverflowHdlr;
                                                lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSynchronizeDataOverflow handler.

      In :  Hdlr        is called at application priority at a synchronize data
                        overflow

      Returns:          Error constant (DoPERR_xxxx)

    The DoPE 'synchronize data overflow' event handler uses internaly the windows
    message WM_APP+0x3FFF (0xBFFF). Applications must not use this windows message
    number if the DoPE 'synchronize data overflow' event handler should be used!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSynchronizeDataOverflowRtHdlr ( Hdlr        : DoPEOnSynchronizeDataOverflowRtHdlr;
                                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnSynchronizeDataOverflow handler.

      In :  Hdlr        is called from the high priotity communication thread
                        at a synchronize data overflow

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

const
  SYNCHRONIZE_MAX  = 32;               {  max. number of links to synchronize  }

function DoPESynchronizeData ( var DP     : DoPE_HANDLE;
                               var Master : DoPE_HANDLE): DWord; STDCALL;
    {
    Activate sample synchronization for the linklist DP.
    Passing an empty linklist (first item NULL) stops sample synchronization.
    Initializing, selecting a setup or closing one or more links stops sample
    synchronization, too.

      In :  DP            DoPE link handle array (terminated by NULL)
                          adress of first array member.
            pMaster       Pointer to storage for the master DoPE link handle

      Out : *DoPEHdl      Master DoPE link handle

      Returns:            Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESynchronizeSystemModeSync ( DoPEHdl     : DoPE_HANDLE;
                                         Mode        : Word;
                                         Time        : Double): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESynchronizeSystemMode     ( DoPEHdl     : DoPE_HANDLE;
                                         Mode        : Word;
                                         Time        : Double;
                                         usTAN       : PWord ): DWord; STDCALL;
    {
    Set or discard the delay time for synchronized movement commands or the
    system time for multiple systems. The systems will be synchronized by
    the DoPESynchronizeSystemStart command.

      In :  DP            DoPE link handle
            Mode          SSM_SYNCMOVE
                          SSM_SYSTEMTIME
                          SSM_DISCARD
            Time          Delay or system time to set with the next
                          DoPESynchronizeSystemStart command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

const
  SSM_DISCARD    = 0;
  SSM_SYNCMOVE   = 1;
  SSM_SYSTEMTIME = 2;


{ ---------------------------------------------------------------------------- }

function DoPESynchronizeSystemStartSync ( DoPEHdl     : DoPE_HANDLE): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESynchronizeSystemStart     ( DoPEHdl     : DoPE_HANDLE;
                                          usTAN       : PWord ): DWord; STDCALL;

    {
    Activate the delay time for synchronized movement commands or the system time
    for multiple systems set by DoPESynchronizeSystemMode calls.

      In :  DP            DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

{ ---------------------------------------------------------------------------- }

implementation

//**************************************************************************************************
function DoPESetOnSynchronizeDataHdlr ( Hdlr        : DoPEOnSynchronizeDataHdlr;
                                        lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSynchronizeDataRtHdlr ( Hdlr        : DoPEOnSynchronizeDataRtHdlr;
                                          lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSynchronizeDataOverflowHdlr ( Hdlr        : DoPEOnSynchronizeDataOverflowHdlr;
                                                lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSynchronizeDataOverflowRtHdlr ( Hdlr        : DoPEOnSynchronizeDataOverflowRtHdlr;
                                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESynchronizeData ( var DP     : DoPE_HANDLE;
                               var Master : DoPE_HANDLE): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESynchronizeSystemModeSync ( DoPEHdl     : DoPE_HANDLE;
                                         Mode        : Word;
                                         Time        : Double): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESynchronizeSystemMode     ( DoPEHdl     : DoPE_HANDLE;
                                         Mode        : Word;
                                         Time        : Double;
                                         usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESynchronizeSystemStartSync ( DoPEHdl     : DoPE_HANDLE): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESynchronizeSystemStart     ( DoPEHdl     : DoPE_HANDLE;
                                          usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************

end.
