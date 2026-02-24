{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface ILC handling

Changes :
=========
  HEG 23.9.11
  - wrote it.
*****************************************************************************}


unit DoPEilc;


{$ALIGN OFF}


interface

uses Windows, DoPE;


{ ---------------------------------------------------------------------------- }

type                                   { PC Command Information                   }
  DoPEPcCmdInfo = record               { -----------------------------------      }
    BufItemsFree   : DWord;            { number of available PcCmdData items [No] }
    BufItemsUsed   : DWord;            { number of used PcCmdData items      [No] }
    BufferUnderrun : DWord;            { number of buffer underruns          [No] }
    reserved       : DWord;            { number of buffer underruns          [No] }
    PosCtrlTime    : Double;           { Position controller cycle time       [s] }
    Paused         : DWord;            { PC Command execution paused        [0/1] }
  end;

function DoPERdPcCmdInfo ( DoPEHdl    : DoPE_HANDLE;
                      var  pPcCmdInfo : DoPEPcCmdInfo ) : DWord; STDCALL;

    {
    Read PC Command info.

      In :  DoPEHdl     DoPE link handle
            Flags       Pointer to storage for the PC Cmommand Info structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }
const

  // Constants for ExecuteMode
  DoPE_PC_CMD_EXECUTE_LAST      = 0;   // Execute completely stored sequence.
  DoPE_PC_CMD_EXECUTE_APPEND    = 1;   // Execute stored sequence, more data will come
  DoPE_PC_CMD_EXECUTE_PAUSE     = 2;   // Fadeout and wait for continue
  DoPE_PC_CMD_EXECUTE_CONTINUE  = 3;   // Fadein and continue interrupted sequence
  DoPE_PC_CMD_EXECUTE_TERMINATE = 4;   // Terminate a running sequence, (fadeout and stop)

  // Constants for Command Mode
  DoPE_PC_CMD_MODE_POS          = 0;   // Command data are position values for each control loop cycle
  DoPE_PC_CMD_MODE_POS_LINEAR   = 1;   // Command data are time and position. 
                                       // A linear function is interpolated between the position values.
  DoPE_PC_CMD_MODE_POS_COSINE   = 2;   // Command data are time and position.
                                       // A cosine function is interpolated between the position values.

type                                   { 'PC Command Data'                     }
                                       { ------------------------------------- }
   DoPEPcCmdData = record
    Time              : Double;
    StimulationSignal : Double;
   end;
   pDoPEPcCmdData = ^DoPEPcCmdData;


function DoPEPcCmd ( DoPEHdl       : DoPE_HANDLE;
                     ExecutionMode : Word;
                     MoveCtrl      : Word;
                     CmdMode       : Word;
                     SpeedToStart  : Double;
                     Offset        : Double;
                     Scale         : Double;
                     OffsetCtrl    : Double;
                     FadeInTime    : Double;
                     FadeOutTime   : Double;
                     Cycles        : DWord;
                     Count         : DWord;
                     pData         : pDoPEPcCmdData;
                     usTAN         : PWord ): DWord; STDCALL;

    {
    Transfer PC Command data to the EDC and initiate execution.
    
      In :  DoPEHdl       DoPE link handle
            ExecutionMode Execution mode
                          DoPE_PC_CMD_EXECUTE_LAST       Execute completely stored sequence.
                          DoPE_PC_CMD_EXECUTE_APPEND     Execute stored sequence, more data will come
                          DoPE_PC_CMD_EXECUTE_PAUSE      Fadeout and wait for continue 
                          DoPE_PC_CMD_EXECUTE_CONTINUE   Fadein and continue interrupted sequence 
                          DoPE_PC_CMD_EXECUTE_TERMINATE  Terminate a running sequence, (fadeout and stop)
            MoveCtrl      Control mode for movement
            CmdMode       Interpolation mode between the values
                          DoPE_PC_CMD_MODE_POS        Command data are position values for 	each control loop cycle
                          DoPE_PC_CMD_MODE_POS_LINEAR Command data are time and position. 
                                                      A linear function is interpolated between the position values
                          DoPE_PC_CMD_MODE_POS_COSINE Command data are time and position. 
                                                      A cosine function is interpolated between the position values
            SpeedToStart  Speed to Start Position
            Offset        Offset for stimulation signal 
            Scale         Scaling factor for stimulation signal
            OffsetCtrl    Offset for move control channel 
            FadeInTime    Fade in time
            FadeOutTime   Fade out time
            Cycles        Number of cycles
            Count         Number of PcCmdData items.
            pData         Pointer to PcCmdData array. 
                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPEPcCmdFromFile ( DoPEHdl       : DoPE_HANDLE;
                             MoveCtrl      : Word;
                             CmdMode       : Word;
                             SpeedToStart  : Double;
                             OffsetFile    : Double;
                             Scale         : Double;
                             OffsetCtrl    : Double;
                             FadeInTime    : Double;
                             FadeOutTime   : Double;
                             Cycles        : DWord;
                             Column        : DWord;
                             FileName      : PChar;
                             usTAN         : PWord ): DWord; STDCALL;

    {
    Transfer PC Command data from a file to the EDC and initiate execution.
    
      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode for movement
            CmdMode       Interpolation mode between the values
                          DoPE_PC_CMD_MODE_POS        Command data are position values for 	each control loop cycle
                          DoPE_PC_CMD_MODE_POS_LINEAR Command data are time and position. 
                                                      A linear function is interpolated between the position values
                          DoPE_PC_CMD_MODE_POS_COSINE Command data are time and position. 
                                                      A cosine function is interpolated between the position values
            SpeedToStart  Speed to Start Position
            OffsetFile    Offset for stimulation signal 
            Scale         Scaling factor for stimulation signal
            OffsetCtrl    Offset for move control channel 
            FadeInTime    Fade in time
            FadeOutTime   Fade out time
            Cycles        Number of cycles
            Column        Column number of Stimulation Signal
                          In interpolation modes Time has always column number 0
            FileName      Pointer to file name and path. 
                          Supported file types:
                            csv  "Comma Separated Values" text file:
                                 Value separator must be ';'
                                 Decimal point can be '.' or ','
                                 Lines NOT starting with a number or a separator will be skipped
                            bmv "DOLI Binary Measured Values" file:
                                 generated by DoPE TestCenter version 2.27.1 (or above)
                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


implementation

//**************************************************************************************************
function DoPERdPcCmdInfo ( DoPEHdl    : DoPE_HANDLE;
                      var  pPcCmdInfo : DoPEPcCmdInfo ) : DWord; STDCALL;

   external 'DoPE.dll';

//**************************************************************************************************
function DoPEPcCmd ( DoPEHdl       : DoPE_HANDLE;
                     ExecutionMode : Word;
                     MoveCtrl      : Word;
                     CmdMode       : Word;
                     SpeedToStart  : Double;
                     Offset        : Double;
                     Scale         : Double;
                     OffsetCtrl    : Double;
                     FadeInTime    : Double;
                     FadeOutTime   : Double;
                     Cycles        : DWord;
                     Count         : DWord;
                     pData         : pDoPEPcCmdData;
                     usTAN         : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

//**************************************************************************************************
function DoPEPcCmdFromFile ( DoPEHdl       : DoPE_HANDLE;
                             MoveCtrl      : Word;
                             CmdMode       : Word;
                             SpeedToStart  : Double;
                             OffsetFile    : Double;
                             Scale         : Double;
                             OffsetCtrl    : Double;
                             FadeInTime    : Double;
                             FadeOutTime   : Double;
                             Cycles        : DWord;
                             Column        : DWord;
                             FileName      : PChar;
                             usTAN         : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

//**************************************************************************************************

end.
