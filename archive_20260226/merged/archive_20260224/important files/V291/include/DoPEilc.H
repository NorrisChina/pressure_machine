/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface ILC handling

Changes :
=========
  HEG 23.9.11
  - wrote it.
  
  HEG 27.2.14 - V2.78
  - New DoPE functions:
    - DoPEPcCmd
    - DoPEPcCmdInfo

*******************************************************************************/


#ifndef DoPEilc_INCLUDED
#define DoPEilc_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* -------------------------------------------------------------------------- */

  typedef struct                       // PC Command Information              
  {                                    // -----------------------------------
    unsigned BufItemsFree;             // number of available PcCmdData items [No]
    unsigned BufItemsUsed;             // number of used PcCmdData items      [No]
    unsigned BufferUnderrun;           // number of buffer underruns          [No]
    double   PosCtrlTime;              // Position controller cycle time       [s]
    unsigned Paused;                   // PC Command execution paused        [0/1]
  } DoPEPcCmdInfo;

  extern  unsigned  DLLAPI  DoPERdPcCmdInfo  ( DoPE_HANDLE    DoPEHdl, 
                                               DoPEPcCmdInfo *Info);

    /*
    Read PC Command info.

      In :  DoPEHdl     DoPE link handle
            Info        Pointer to storage for the PC Cmommand Info structure

      Returns:          Error constant (DoPERR_xxxx)
    */


// -----------------------------------------------------------------------------

  // Constants for Command Mode
  #define DoPE_PC_CMD_MODE_POS           0        // Command data are position values for each control loop cycle.
  #define DoPE_PC_CMD_MODE_POS_LINEAR    1        // Command data are time and position. 
                                                  // A linear function is interpolated between the position values.
  #define DoPE_PC_CMD_MODE_POS_COSINE    2        // Command data are time and position.
                                                  // A cosine function is interpolated between the position values.

  // Constants for ExecuteMode
  #define DoPE_PC_CMD_EXECUTE_LAST       0        // Execute completely stored sequence.
  #define DoPE_PC_CMD_EXECUTE_APPEND     1        // Execute stored sequence, more data will come
  #define DoPE_PC_CMD_EXECUTE_PAUSE      2        // Fadeout and wait for continue 
  #define DoPE_PC_CMD_EXECUTE_CONTINUE   3        // Fadein and continue interrupted sequence 
  #define DoPE_PC_CMD_EXECUTE_TERMINATE  4        // Terminate a running sequence, (fadeout and stop)


  typedef  struct
  {
    double  Time;
    double  StimulationSignal;
  } DoPEPcCmdData;


  extern  unsigned  DLLAPI  DoPEPcCmd  ( DoPE_HANDLE     DoPEHdl,
                                         unsigned short  ExecutionMode,
                                         unsigned short  MoveCtrl,
                                         unsigned short  CmdMode,
                                         double          SpeedToStart,
                                         double          Offset,
                                         double          Scale,
                                         double          OffsetCtrl,
                                         double          FadeInTime,
                                         double          FadeOutTime,
                                         unsigned        Cycles,
                                         unsigned        Count,
                                         DoPEPcCmdData  *Data,
                                         unsigned short *lpusTAN );

    /*
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
            Count         Number of PcCmdData items
            Data          Pointer to PcCmdData array 
                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEPcCmdFromFile  ( DoPE_HANDLE     DoPEHdl,
                                                 unsigned short  MoveCtrl,
                                                 unsigned short  CmdMode,
                                                 double          SpeedToStart,
                                                 double          OffsetFile,
                                                 double          Scale,
                                                 double          OffsetCtrl,
                                                 double          FadeInTime,
                                                 double          FadeOutTime,
                                                 unsigned        Cycles,
                                                 unsigned        Column,
                                                 char           *FileName,
                                                 unsigned short *lpusTAN );


    /*
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
                            bmv "DOLI Binary Measured Values" file
                          In DoPE_PC_CMD_MODE_POS the time values will be ignored
      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
