{*******************************************************************************

  Project: DoPESyn

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC  synchronized datainterface for Windows

Changes :
=========
  HEG, 11.5.06
  - wrote it.
  
  FEZ, 18.4.07
  - Changed to $ALIGN OFF
  
  HEG, 12.5.07
  - DoPESetOnKeyMsgHdlr and DoPESetOnKeyMsgRtHdlr implemented
  
  HEG, 22.10.07 - V2.59
  - DoPEOFFLINE, DoPEONLINE and DoPERESTART defined for OnLine handler
    line state.
    
  HEG, 4.3.09 - V2.65
  - DoPESetOnSystemMsgHdlr and DoPESetOnSystemMsgRtHdlr implemented

  HEG, 7.12.09 - V2.66
  - Source code layout adapted to C++ header

  HEG, 12.10.11 - V 2.71
  - DoPESetOnIoSHaltMsgHdlr and DoPESetOnIoSHaltMsgRtHdlr implemented

  HEG, 26.7.2012 - V 2.73
  - New system message:
    - SYSTEM_MSG_OC_MC2OUTPUT_MODE

  HEG, 14.9.2012 - V 2.74
  - New System Messages:
    - SYSTEM_MSG_MAX_RESULT_FILES
    - SYSTEM_MSG_SEN_SCALE
    
  HEG, 24.10.13 - V2.77
  - DoPESetOnDebugMsgHdlr and DoPESetOnDebugMsgRtHdlr implemented

  HEG, 20.05.14 - V 2.80
  - DoPESetOnDataBlockHdlr and DoPESetOnDataBlockRtHdlr implemented
  - DoPESetOnDataBlockSize and DoPEGetOnDataBlockSize implemented
*****************************************************************************}


unit DoPEEh;


{$ALIGN OFF}


interface

uses Windows, DoPE;


  { --------- Eventhandler definitions --------------------------------------- }

const
  DoPEOFFLINE  = 0;         // link is offline
  DoPEONLINE   = 1;         // link is online
  DoPERESTART  = 2;         // asynchronus restart of the link

type
  DoPEOnLineHdlr = FUNCTION  ( DoPEHdl : DoPE_HANDLE;
                               nInt    : Integer;
                               Buffer  : Pointer ): DWord; STDCALL;
    {
     Handler for DoPE line state changed events
       DoPE_HANDLE  DoPE link handle
       int          Line state (0=OFFLINE, else=ONLINE)
       Pointer      userspecific pointer set with DoPESetOnLineHdlr
     should return 0 (reserved for future versions)
    }

type
  DoPEOnLineRtHdlr = FUNCTION ( DoPEHdl : DoPE_HANDLE;
                                nInt    : Integer;
                                Buffer  : Pointer ): DWord; STDCALL;

  {
     Realtime handler for DoPE line state changed events
       DoPE_HANDLE  DoPE link handle
       int          Line state (0=OFFLINE, else=ONLINE)
       Pointer      userspecific pointer set with DoPESetOnLineRtHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { Measuring data record                 }
   DoPEOnData = record                 { ------------------------------------- }
    DoPError  : DWord;                 { DoPE error code                       }
    Reserved1 : DWord;
    Data      : DoPEData;              { Measuring data record                 }
    Reserved2 : Word;
    Occupied  : Double;                { Utilization in % of the buffer size   }
   end;

type
  DoPEOnDataHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                          var OnData  : DoPEOnData;
                              Buffer  : Pointer ): DWord; STDCALL;
  {
     Handler for received measuring data records
       DoPE_HANDLE  DoPE link handle
       DoPEOnData   received measuring data record
       Pointer      userspecific pointer set with DoPESetOnDataHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnDataRtHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                            var OnData  : DoPEOnData;
                                Buffer  : Pointer): DWord; STDCALL;
  {
     Realtime handler for received measuring data records
       DoPE_HANDLE  DoPE link handle
       DoPEOnData   received measuring data record
       Pointer      userspecific pointer set with DoPESetOnDataHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { Measuring data records block          }
  DoPEOnDataBlock = record             { ------------------------------------- }
    DoPError  : DWord;                 { DoPE error code                       }
    nData     : DWord;                 { Number of measuring data records      }
    Data      : ^DoPEOnData;           { Pointer to Measuring data records     }
    Reserved   : DWord;
    Occupied  : Double;                { Utilization in % of the buffer size   }
   end;

type
  DoPEOnDataBlockHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                               var Data    : DoPEOnDataBlock;
                                   Buffer  : Pointer ): DWord; STDCALL;
  {
     Handler for received measuring data records
       DoPE_HANDLE       DoPE link handle
       DoPEOnDataBlock   received measuring data record block
       LPVOID            userspecific pointer set with DoPESetOnDataBlockHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnDataBlockRtHdlr = FUNCTION  (DoPEHdl : DoPE_HANDLE;
                                 var Data    : DoPEOnDataBlock;
                                     Buffer  : Pointer ): DWord; STDCALL;
  {
     Realtime handler for received measuring data records
       DoPE_HANDLE       DoPE link handle
       DoPEOnDataBlock   received measuring data record block
       LPVOID            userspecific pointer set with DoPESetOnDataBlockRtHdlr
     should return 0 (reserved for future versions)
   }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { Command error                         }
   DoPEOnCommandError = record         { ------------------------------------- }
    CommandNumber : Word;              { Number of command                     }
    ErrorNumber   : Word;              { Number of error                       }
    usTAN         : Word;              { Transaction number                    }
   end;

type
  DoPEOnCommandErrorHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                 var OnCommandError : DoPEOnCommandError;
                                     Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for command errors
       DoPE_HANDLE           DoPE link handle
       DoPEOnCommandError    received command error
       Pointer               userspecific pointer set with DoPESetOnCommandErrorHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnCommandErrorRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                   var OnCommandError : DoPEOnCommandError;
                                       Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for command errors
       DoPE_HANDLE           DoPE link handle
       DoPEOnCommandError    received command error
       Pointer               userspecific pointer set with DoPESetOnCommandErrorHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Position'       Message              }
   DoPEOnPosMsg = record               { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Reached     : Word;                { position reached (TRUE/FALSE)         }
    Reserved1   : Word;
    Time        : Double;              { System time for the message           }
    Control     : Word;                { Control mode of position              }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position                             }
    DControl    : Word;                { Control mode of destination position }
    Reserved4   : Word;
    Reserved5   : DWord;
    Destination : Double;              { Destination position                 }
    usTAN       : Word;                { Transaction number                   }
   end;

type
   DoPEOnPosMsgHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                            var OnPosMsg : DoPEOnPosMsg;
                                Buffer   : Pointer): DWord; STDCALL;
  {
     Handler for position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received position message
       Pointer      userspecific pointer set with DoPESetOnPosMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnPosMsgRtHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                            var OnPosMsg : DoPEOnPosMsg;
                                Buffer   : Pointer): DWord; STDCALL;
  {
     Realtime handler for position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received position message
       Pointer      userspecific pointer set with DoPESetOnPosMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type
   DoPEOnTPosMsgHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                             var OnPosMsg : DoPEOnPosMsg;
                                 Buffer   : Pointer): DWord; STDCALL;
  {
     Handler for trigger position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received trigger position message
       Pointer      userspecific pointer set with DoPESetOnTPosMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnTPosMsgRtHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                               var OnPosMsg : DoPEOnPosMsg;
                                   Buffer   : Pointer): DWord; STDCALL;
  {
     Realtime handler for trigger position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received trigger position message
       Pointer      userspecific pointer set with DoPESetOnTPosMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type
   DoPEOnLPosMsgHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                             var OnPosMsg : DoPEOnPosMsg;
                                 Buffer   : Pointer): DWord; STDCALL;
  {
     Handler for limit position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received limit position message
       Pointer      userspecific pointer set with DoPESetOnLPosMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnLPosMsgRtHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                               var OnPosMsg : DoPEOnPosMsg;
                                   Buffer   : Pointer): DWord; STDCALL;
  {
     Realtime handler for limit position messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnPosMsg received limit position message
       Pointer      userspecific pointer set with DoPESetOnLPosMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Softend' Message                     }
   DoPEOnSftMsg = record               { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Upper       : Word;                { TRUE=upper, FALSE=lower softend       }
    Reserved1   : Word;
    Time        : Double;              { System time for the message           }
    Control     : Word;                { Control mode of position              }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position                              }
    usTAN       : Word;                { Transaction number                    }
   end;

type
  DoPEOnSftMsgHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                           var OnSftMsg : DoPEOnSftMsg;
                               Buffer   : Pointer): DWord; STDCALL;
  {
     Handler for softend messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnSftMsg received softend message
       Pointer      userspecific pointer set with DoPESetOnSftMsgHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnSftMsgRtHdlr = FUNCTION (DoPEHdl  : DoPE_HANDLE;
                             var OnSftMsg : DoPEOnSftMsg;
                                 Buffer   : Pointer): DWord; STDCALL;
  {
     Realtime handler for softend messages
       DoPE_HANDLE  DoPE link handle
       DoPEOnSftMsg received softend message
       Pointer      userspecific pointer set with DoPESetOnSftMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Offset-Correction' Message           }
   DoPEOnOffsCMsg = record             { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Reserved1   : DWord;
    Time        : Double;              { System time for the message           }
    Offset      : Double;              { Power Amplifier Offset                }
    usTAN       : Word;                { Transaction number                    }
   end;

type
  DoPEOnOffsCMsgHdlr = FUNCTION (DoPEHdl    : DoPE_HANDLE;
                             var OnOffsCMsg : DoPEOnOffsCMsg;
                                 Buffer     : Pointer): DWord; STDCALL;
  {
     Handler for offset correction messages
       DoPE_HANDLE    DoPE link handle
       DoPEOnOffsCMsg received offset correction message
       Pointer        userspecific pointer set with DoPESetOnOffsCMsgHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnOffsCMsgRtHdlr = FUNCTION (DoPEHdl    : DoPE_HANDLE;
                               var OnOffsCMsg : DoPEOnOffsCMsg;
                                   Buffer     : Pointer): DWord; STDCALL;
  {
     Realtime handler for offset correction messages
       DoPE_HANDLE    DoPE link handle
       DoPEOnOffsCMsg received offset correction message
       Pointer        userspecific pointer set with DoPESetOnOffsCMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Measuring Channel Supervision' Msg.  }
   DoPEOnCheckMsg = record             { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Action      : Word;                { Action started (TRUE/FALSE)           }
    Reserved1   : Word;
    Time        : Double;              { System time for the message           }
    CheckId     : Word;                { ID of Measuring Channel Check         }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position                              }
    SensorNo    : Word;                { Supervised sensor                     }
    usTAN       : Word;                { Transaction number                    }
   end;

type
  DoPEOnCheckMsgHdlr = FUNCTION (DoPEHdl    : DoPE_HANDLE;
                             var OnCheckMsg : DoPEOnCheckMsg;
                                 Buffer     : Pointer): DWord; STDCALL;
  {
     Handler for channel supervision messages
       DoPE_HANDLE    DoPE link handle
       DoPEOnCheckMsg received channel supervision message
       Pointer        userspecific pointer set with DoPESetOnCheckMsgHdlr
     should return 0 (reserved for future versions)
  }

type
  DoPEOnCheckMsgRtHdlr = FUNCTION (DoPEHdl    : DoPE_HANDLE;
                               var OnCheckMsg : DoPEOnCheckMsg;
                                   Buffer     : Pointer): DWord; STDCALL;
  {
     Realtime handler for channel supervision messages
       DoPE_HANDLE    DoPE link handle
       DoPEOnCheckMsg received channel supervision message
       Pointer        userspecific pointer set with DoPESetOnCheckMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Shield' Message                      }
   DoPEOnShieldMsg = record            { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Action      : Word;                { Action started (TRUE/FALSE)           }
    Reserved1   : Word;
    Time        : Double;              { System time for the message           }
    SensorNo    : Word;                { Supervised sensor                     }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position                              }
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnShieldMsgHdlr = FUNCTION (DoPEHdl     : DoPE_HANDLE;
                               var OnShieldMsg : DoPEOnShieldMsg;
                                   Buffer      : Pointer): DWord; STDCALL;
  {
     Handler for shield supervision messages
       DoPE_HANDLE     DoPE link handle
       DoPEOnShieldMsg received shield supervision message
       Pointer         userspecific pointer set with DoPESetOnShieldMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnShieldMsgRtHdlr = FUNCTION (DoPEHdl     : DoPE_HANDLE;
                                 var OnShieldMsg : DoPEOnShieldMsg;
                                     Buffer      : Pointer): DWord; STDCALL;
  {
     Realtime handler for shield supervision messages
       DoPE_HANDLE     DoPE link handle
       DoPEOnShieldMsg received shield supervision message
       Pointer         userspecific pointer set with DoPESetOnShieldMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Reference Signal' Message            }
  DoPEOnRefSignalMsg = record          { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Reserved1   : DWord;
    Time        : Double;              { System time for the message           }
    SensorNo    : Word;                { Sensor where ref. signal occured      }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position at ref. signal               }
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnRefSignalMsgHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                  var OnRefSignalMsg : DoPEOnRefSignalMsg;
                                      Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for reference signal messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnRefSignalMsg received reference signal message
       LPVOID             userspecific pointer set with DoPESetOnRefSignalMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnRefSignalMsgRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                    var OnRefSignalMsg : DoPEOnRefSignalMsg;
                                        Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for reference signal messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnRefSignalMsg received reference signal message
       LPVOID             userspecific pointer set with DoPESetOnRefSignalMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Sensor' Message                      }
   DoPEOnSensorMsg = record            { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Reserved1   : DWord;
    Time        : Double;              { System time for the message           }
    SensorNo    : Word;                { Sensornumber                          }
    Length      : Word;                { Number of bytes in the message        }
    Data        : array[0..SENSOR_MSG_LEN] of Byte;
                                       { DPXMSGLEN-Typ-usTAN-ErrorNumber Bytes }
    Reserved2   : Byte;
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnSensorMsgHdlr = FUNCTION (DoPEHdl         : DoPE_HANDLE;
                               var DoPEOnSensorMsg : DoPEOnSensorMsg;
                                   Buffer          : Pointer): DWord; STDCALL;
  {
     Handler for sensor messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnSensorMsg    received sensor message
       LPVOID             userspecific pointer set with DoPESetOnSensorMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnSensorMsgRtHdlr = FUNCTION (DoPEHdl         : DoPE_HANDLE;
                                 var DoPEOnSensorMsg : DoPEOnSensorMsg;
                                     Buffer          : Pointer): DWord; STDCALL;
  {
     Realtime handler for reference signal messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnSensorMsg    received sensor message
       LPVOID             userspecific pointer set with DoPESetOnSensorMsgHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'IoSHalt' Message                     }
  DoPEOnIoSHaltMsg = record            { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Upper       : Word;                { !=0 upper, 0 lower IO-SHalt           }
    Reserved1   : Word;
    Time        : Double;              { System time for the message           }
    Control     : Word;                { Control mode of position              }
    Reserved2   : Word;
    Reserved3   : DWord;
    Position    : Double;              { Position                              }
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnIoSHaltMsgHdlr = FUNCTION (DoPEHdl      : DoPE_HANDLE;
                                var OnIoSHaltMsg : DoPEOnIoSHaltMsg;
                                    Buffer       : Pointer): DWord; STDCALL;
  {
     Handler for IO-SHalt messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnIoSHaltMsg   received IO-SHalt message
       LPVOID             userspecific pointer set with DoPESetOnKeyMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnIoSHaltMsgRtHdlr = FUNCTION (DoPEHdl      : DoPE_HANDLE;
                                  var OnIoSHaltMsg : DoPEOnIoSHaltMsg;
                                      Buffer       : Pointer): DWord; STDCALL;
  {
     Realtime handler for IO-SHalt messages
       DoPE_HANDLE        DoPE link handle
       DoPEOnIoSHaltMsg   received IO-SHalt message
       LPVOID             userspecific pointer set with DoPESetOnIoSHaltMsgRtHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { 'Keyboard' Message                    }
  DoPEOnKeyMsg = record                { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    Reserved1   : DWord;
    Time        : Double;              { System time for the message           }
    Keys        : Int64;               { Current key state                     }
    NewKeys     : Int64;               { New keys                              }
    GoneKeys    : Int64;               { Gone keys                             }
    OemKeys     : Word;                { Current OEM key state                 }
    NewOemKeys  : Word;                { New OEM keys                          }
    GoneOemKeys : Word;                { Gone OEM keys                         }
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnKeyMsgHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                            var OnKeyMsg       : DoPEOnKeyMsg;
                                Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for keyboard messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnKeyMsg          received keyboard message
       LPVOID                userspecific pointer set with DoPESetOnKeyMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnKeyMsgRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                              var OnKeyMsg       : DoPEOnKeyMsg;
                                  Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for keyboard messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnKeyMsg          received keyboard message
       LPVOID                userspecific pointer set with DoPESetOnKeyMsgRtHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type                                   { Runtime error                         }
   DoPEOnRuntimeError = record         { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    ErrorNumber : Word;                { Number of run time error              }
    Reserved1   : Word;
    Time        : Double;              { System time the error occurred        }
    Device      : Word;                { Device Number responsible for the err }
    Bits        : Word;                { Responsible bits if digital input dev }
    usTAN       : Word;                { Transaction number                    }
   end;

type
   DoPEOnRuntimeErrorHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                  var OnRuntimeError : DoPEOnRuntimeError;
                                      Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for runtime errors
       DoPE_HANDLE           DoPE link handle
       DoPEOnRuntimeError    received runtime error
       LPVOID                userspecific pointer set with DoPESetOnRuntimeErrorHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnRuntimeErrorRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                    var OnRuntimeError : DoPEOnRuntimeError;
                                        Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for runtime errors
       DoPE_HANDLE           DoPE link handle
       DoPEOnRuntimeError    received runtime error
       LPVOID                userspecific pointer set with DoPESetOnRuntimeErrorHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

type
   DoPEOnOverflowHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                  nInt           : Integer;
                                  Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for measuring data and message overlow events
       DoPE_HANDLE  DoPE link handle
       int          0=measuring data records lost, else=message lost
       LPVOID       userspecific pointer set with DoPESetOnOverflowHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnOverflowRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                    nInt           : Integer;
                                    Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for measuring data and message overlow events
       DoPE_HANDLE  DoPE link handle
       int          0=measuring data records lost, else=message lost
       LPVOID       userspecific pointer set with DoPESetOnOverflowHdlr
     should return 0 (reserved for future versions)
  }

  {. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }

const                                              { Constants for system messages        }
                                                   { ------------------------------------ }
   SYSTEM_MSG_TEXT_LEN                    =   440; { max. system message text length      }
                                                   { (including terminating zero '\0')    }

   SYSTEM_MSG_NOERROR                     =     0; { No error                             }

                                                   { General runtime errors               }
   SYSTEM_MSG_UNKNOWN                     = 10000; { Unknown runtime error                }
   SYSTEM_MSG_POWERAMP_ERROR              = 10001; { Power amplifier error                }
   SYSTEM_MSG_DRIVE_ERROR                 = 10002; { Drive error                          }
   SYSTEM_MSG_DRIVE_NOTREADY              = 10003; { Drive not ready                      }
   SYSTEM_MSG_DRIVE_RELEASE               = 10004; { Drive release withdrawn              }
   SYSTEM_MSG_UPPER_SENLIMIT              = 10005; { Upper sensor limit exceeded          }
   SYSTEM_MSG_LOWER_SENLIMIT              = 10006; { Lower sensor limit exceeded          }
   SYSTEM_MSG_LIMITSWITCH                 = 10007; { Upper or lower hard-limit switch     }
   SYSTEM_MSG_DEVIATION                   = 10008; { Controller deviation error           }
   SYSTEM_MSG_NODIGIPOTI                  = 10009; { No digipoti configurated             }
   SYSTEM_MSG_NORMC                       = 10010; { No remote control pluged             }
   SYSTEM_MSG_EMERGENCY_OFF               = 10011; { Emergency switch activated           }
   SYSTEM_MSG_NOMEMORY                    = 10012; { not enough memory                    }
   SYSTEM_MSG_NOSHIELD                    = 10013; { Shield not found                     }
   SYSTEM_MSG_X2T_OFFLINE                 = 10014; { X2T module offline                   }
   SYSTEM_MSG_MAX_RESULT_FILES            = 10015; { max. count of result files reached   }

                                                   { System EEPROM errors (flashdisk)     }
   SYSTEM_MSG_SYSEEP_CRC                  = 10100; { data CRC error                       }
   SYSTEM_MSG_SYSEEP_NOBLOCK              = 10101; { block not found                      }
   SYSTEM_MSG_SYSEEP_BLOCKLENGTH          = 10102; { wrong block length                   }
   SYSTEM_MSG_SYSEEP_NOMEMORY             = 10103; { not enough EEPROM memory             }
   SYSTEM_MSG_SYSEEP_BIOSNOFUNC           = 10104; { BIOS: function not found             }
   SYSTEM_MSG_SYSEEP_BIOSNODEVICE         = 10105; { BIOS: device error                   }
   SYSTEM_MSG_SYSEEP_BIOSPARA             = 10106; { BIOS: parameter error                }
   SYSTEM_MSG_SYSEEP_BIOSREAD             = 10107; { BIOS: read error                     }
   SYSTEM_MSG_SYSEEP_BIOSWRITE            = 10108; { BIOS: write error                    }
   SYSTEM_MSG_SYSEEP_BIOSREENT            = 10109; { BIOS: reentrance error               }

                                                   { General initialization errors        }
   SYSTEM_MSG_INIT_ENDDEV                 = 10200; { Error at initialization level 1      }
   SYSTEM_MSG_INIT_ENDINI                 = 10201; { Error at initialization level 2      }
   SYSTEM_MSG_INIT_SYSTIME                = 10202; { Wrong system time                    }
   SYSTEM_MSG_INIT_POSCTRLTIME            = 10203; { Wrong position controller time       }
   SYSTEM_MSG_INIT_DATA_TRANSMISSION_RATE = 10204; { Wrong data transmission rate         }
   SYSTEM_MSG_INIT_GRIP                   = 10205; { Grip  initialization error           }
   SYSTEM_MSG_INIT_SHIELD                 = 10206; { Shield initialization error          }
   SYSTEM_MSG_INIT_MAINBOARD              = 10207; { EDC mainboard initialization error   }
   SYSTEM_MSG_INIT_MODULE_ERROR           = 10208; { Module error                         }
   SYSTEM_MSG_INIT_CTRL                   = 10209; { Error closed loop controller         }

                                                   { Sensor initialization errors         }
   SYSTEM_MSG_SEN_EEP_NOTFOUND            = 10300; { Sensor EEPROM not found              }
   SYSTEM_MSG_SEN_EEP_BCC                 = 10301; { Sensor EEPROM data BCC error         }
   SYSTEM_MSG_SEN_EEP_CLASS               = 10302; { Unknown sensor EEPROM class          }
   SYSTEM_MSG_SEN_NOTFOUND                = 10303; { Sensor not found                     }
   SYSTEM_MSG_SEN_INITBYTE                = 10304; { Initialization word error            }
   SYSTEM_MSG_SEN_INIT                    = 10305; { Sensor initialization error          }
   SYSTEM_MSG_SEN_PARA                    = 10306; { Wrong sensor parameter               }
   SYSTEM_MSG_SEN_CORR                    = 10307; { Wrong sensor correction value        }
   SYSTEM_MSG_SEN_MCINTEGR                = 10308; { Wrong integration time for           }
                                                   { measured channel values              }
   SYSTEM_MSG_SEN_CTRLINTEGR              = 10309; { Wrong integration time for           }
                                                   { closed loop control                  }
   SYSTEM_MSG_SEN_LIMIT                   = 10310; { Wrong sensor limits                  }
   SYSTEM_MSG_SEN_NOMINALACC              = 10311; { Wrong nominal acceleration           }
   SYSTEM_MSG_SEN_NOMINALSPEED            = 10312; { Wrong nominal speed                  }
   SYSTEM_MSG_SEN_POS_CTRL                = 10313; { Wrong parameter for position closed  }
                                                   { loop control                         }
   SYSTEM_MSG_SEN_SPEED_CTRL              = 10314; { Wrong parameter for speed closed     }
                                                   { loop control                         }
   SYSTEM_MSG_SEN_BIOS                    = 10315; { Wrong BIOS Version                   }
   SYSTEM_MSG_SEN_OFFSET                  = 10316; { Wrong sensor offset                  }
   SYSTEM_MSG_SEN_SCALE                   = 10317; { Wrong sensor scale                   }

                                                   { Output channel initialization errors }
   SYSTEM_MSG_OC_EEP_NOTFOUND             = 10400; { Output channel EEPROM not found      }
   SYSTEM_MSG_OC_EEP_BCC                  = 10401; { Output channel EEPROM data BCC error }
   SYSTEM_MSG_OC_EEP_CLASS                = 10402; { Unknown Output channel EEPROM class  }
   SYSTEM_MSG_OC_INIT                     = 10403; { Output channel initialization error  }
   SYSTEM_MSG_OC_VOLTAGE                  = 10404; { Wrong voltage for DDAxx              }
   SYSTEM_MSG_OC_CURRENT                  = 10405; { Wrong current for DDAxx              }
   SYSTEM_MSG_OC_POWER                    = 10406; { Wrong power   for DDAxx              }
   SYSTEM_MSG_OC_PARA                     = 10407; { Wrong output channel parameter       }
   SYSTEM_MSG_OC_MAX_CURR_TIME            = 10408; { Wrong max current time for I²T       }
   SYSTEM_MSG_OC_DITHER_FREQ              = 10409; { Wrong dither frequency               }
   SYSTEM_MSG_OC_DITHER_AMPL              = 10410; { Wrong dither amplitude               }
   SYSTEM_MSG_OC_DITHER_INIT              = 10411; { dither initialization error          }
   SYSTEM_MSG_OC_CURRENT_CTRL             = 10412; { Wrong parameter for current closed   }
                                                   { loop control                         }
   SYSTEM_MSG_OC_MC2OUTPUT                = 10413; { Mc2Output initialization error       }
   SYSTEM_MSG_OC_MC2OUTPUT_MODE           = 10414; { Mc2Output mode not implemented       }

                                                   { Bit input initialization errors      }
   SYSTEM_MSG_BIN_INIT                    = 10500; { Bit input initialization error       }

                                                   { Bit output initialization errors     }
   SYSTEM_MSG_BOUT_INIT                   = 10600; { Bit output initialization error      }

                                                   { IO-Signals initialization errors     }
   SYSTEM_MSG_IO_MACHINE_CONNECTOR        = 10700; { IOMachine: connector error           }

   SYSTEM_MSG_IO_GRIP_MODE                = 10710; { IOGrip: Mode not implemented         }
   SYSTEM_MSG_IO_GRIP_BIN                 = 10711; { IOGrip: Bit input  error             }
   SYSTEM_MSG_IO_GRIP_BOUT                = 10712; { IOGrip: Bit output error             }
   SYSTEM_MSG_IO_GRIP_OC                  = 10713; { IOGrip: Output channel error         }
   SYSTEM_MSG_IO_GRIP_LIMIT               = 10714; { IOGrip: Limit error                  }
   SYSTEM_MSG_IO_GRIP_OLD_LIMIT           = 10715; { IOGrip: Conflict with old grip limit }

   SYSTEM_MSG_IO_EXT_MODE                 = 10730; { IOExtensometer: Mode not implemented }
   SYSTEM_MSG_IO_EXT_BIN                  = 10731; { IOExtensometer: Bit input  error     }
   SYSTEM_MSG_IO_EXT_BOUT                 = 10732; { IOExtensometer: Bit output error     }

   SYSTEM_MSG_IO_FIXED_XHEAD_MODE         = 10740; { IOFixedXHead: Mode not implemented   }
   SYSTEM_MSG_IO_FIXED_XHEAD_BIN          = 10741; { IOFixedXHead: Bit input  error       }
   SYSTEM_MSG_IO_FIXED_XHEAD_BOUT         = 10742; { IOFixedXHead: Bit output error       }

   SYSTEM_MSG_IO_HIGH_PRESSURE_MODE       = 10750; { IOHighPressure: Mode not implemented }
   SYSTEM_MSG_IO_HIGH_PRESSURE_BIN        = 10751; { IOHighPressure: Bit input  error     }
   SYSTEM_MSG_IO_HIGH_PRESSURE_BOUT       = 10752; { IOHighPressure: Bit output error     }
   SYSTEM_MSG_IO_HIGH_PRESSURE_OC         = 10753; { IOHighPressure: Output channel error }

   SYSTEM_MSG_IO_MISC_MODE                = 10780; { IOMisc: Mode not implemented         }
   SYSTEM_MSG_IO_MISC_BIN                 = 10781; { IOMisc: Bit input  error             }
   SYSTEM_MSG_IO_MISC_BOUT                = 10782; { IOMisc: Bit output error             }
   SYSTEM_MSG_IO_MISC_TEMPERATURE1        = 10790; { IOMisc: temperature1       (warning) }
   SYSTEM_MSG_IO_MISC_TEMPERATURE2        = 10791; { IOMisc: temperature2 (emergency off) }
   SYSTEM_MSG_IO_MISC_OIL_LEVEL           = 10792; { IOMisc: oil level    (emergency off) }
   SYSTEM_MSG_IO_MISC_OIL_FILTER          = 10793; { IOMisc: oil filter         (warning) }
   SYSTEM_MSG_IO_MISC_POWER_FAIL          = 10794; { IOMisc: power fail   (emergency off) }

   SYSTEM_MSG_IO_SHALT_MODE               = 10850; { IOSHalt: Mode not implemented        }
   SYSTEM_MSG_IO_SHALT_BIN                = 10851; { IOSHalt: Bit input  error            }

   SYSTEM_MSG_LANGUAGE_READ               = 10900; { Language file: read error            }
   SYSTEM_MSG_LANGUAGE_VERSION            = 10901; { Language file: wrong version         }
   SYSTEM_MSG_LANGUAGE_SYNTAX             = 10902; { Language file: syntax errors         }


type                                   { System Message                        }
   DoPEOnSystemMsg = record            { ------------------------------------- }
    DoPError    : DWord;               { DoPE error code                       }
    MsgNumber   : Word;                { Number of system message              }
    Reserved1   : Word;
    Time        : Double;              { System time the error occurred        }
    Text        : array[0..SYSTEM_MSG_TEXT_LEN] of WideChar;
   end;

type
   DoPEOnSystemMsgHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                               var OnSystemMsg    : DoPEOnSystemMsg;
                                   Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for system messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnSystemMsg       received system message
       LPVOID                userspecific pointer set with DoPESetOnSystemMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnSystemMsgRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                 var OnSystemMsg    : DoPEOnSystemMsg;
                                     Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for system messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnSystemMsg       received system message
       LPVOID                userspecific pointer set with DoPESetOnSystemMsgRtHdlr
     should return 0 (reserved for future versions)
  }

{ ---------------------------------------------------------------------------- }

const DEBUG_MSG_TEXT_LEN    = 221;    { max. debug message text length         }
                                      { (including terminating zero '\0')      }

const                                 { Debug message types                    }
                                      { -------------------------------------- }
   DEBUG_MSG                = 0;      { general debug message                  }
   DEBUG_MSG_DATA           = 1;      { measured values debug message          }

type                                  { Debug Message                          }
   DoPEOnDebugMsg = record            { -------------------------------------- }
    DoPError    : DWord;              { DoPE error code                        }
    MsgType     : Word;               { Type of debug message                  }
    Reserved1   : Word;
    Time        : Double;             { System time the message was sent       }
    Text        : array[0..DEBUG_MSG_TEXT_LEN] of Char;
   end;

type
   DoPEOnDebugMsgHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                              var OnDebugMsg     : DoPEOnDebugMsg;
                                  Buffer         : Pointer): DWord; STDCALL;
  {
     Handler for debug messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnDebugMsg        received debug message
       LPVOID                userspecific pointer set with DoPESetOnDebugMsgHdlr
     should return 0 (reserved for future versions)
  }

type
   DoPEOnDebugMsgRtHdlr = FUNCTION (DoPEHdl        : DoPE_HANDLE;
                                var OnDebugMsg     : DoPEOnDebugMsg;
                                    Buffer         : Pointer): DWord; STDCALL;
  {
     Realtime handler for debug messages
       DoPE_HANDLE           DoPE link handle
       DoPEOnDebugMsg        received Debug message
       LPVOID                userspecific pointer set with DoPESetOnDebugMsgRtHdlr
     should return 0 (reserved for future versions)
   }

{ ---------------------------------------------------------------------------- }

function DoPESetOnLineHdlr ( DoPEHdl     : DoPE_HANDLE;
                             Hdlr        : DoPEOnLineHdlr;
                             lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnLine handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        line state change

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnLineRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnLineRtHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnLine handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every line state change

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDataHdlr ( DoPEHdl     : DoPE_HANDLE;
                             Hdlr        : DoPEOnDataHdlr;
                             lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnData handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received sample

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDataRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnDataRtHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnData handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every received sample

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDataBlockHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnDataBlockHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnDataBlock handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every received
                        sample block

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDataBlockRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnDataBlockRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnDataBlock handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every received sample block

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDataBlockSize ( DoPEHdl : DoPE_HANDLE;
                                  nData   : DWord): DWord; STDCALL;

    {
    Set the number of measuring data record  to collect in an OnDataBlock.

      In :  DP          DoPE link handle
            nData       number of samples in a block

      Returns:          Error constant (DoPERR_xxxx)
    }

function DoPEGetOnDataBlockSize ( DoPEHdl : DoPE_HANDLE;
                                  nData   : PDWord): DWord; STDCALL;

    {
    Get the number of measuring data record  to collect in an OnDataBlock.

      In :  DP          DoPE link handle
            nData       Pointer to storage for number of samples in a block

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnCommandErrorHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnCommandErrorHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnCommandError handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received command error message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnCommandErrorRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnCommandErrorRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnCommandError handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every received command error message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnPosMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnPosMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received positioning message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnPosMsgRtHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnPosMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every received positioning message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnTPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr        : DoPEOnPosMsgHdlr;
                                lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnTPosMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received trigger positioning message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnTPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr          : DoPEOnPosMsgRtHdlr;
                                lpParameter   : Pointer): DWord; STDCALL;

    {
    Set the OnTPosRtMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received trigger positioning message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnLPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr        : DoPEOnPosMsgHdlr;
                                lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnLPosMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received limit positioning message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnLPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnPosMsgRtHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnLPosMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received limit positioning message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSftMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnSftMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSftMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received softend message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSftMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnSftMsgRtHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSftRtMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received softend message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnOffsCMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnOffsCMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnOffsCMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received offset correction message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnOffsCMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnOffsCMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnOffsCRtMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received offset correction message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnCheckMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnCheckMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnCheckMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received channel supervision message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnCheckMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnCheckMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnCheckRtMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received channel supervision message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnShieldMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnShieldMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnShieldMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received Shield supervision message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnShieldMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnShieldMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnShieldMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received Shield supervision message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnRefSignalMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnRefSignalMsgHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnRefSignalMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received reference signal message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnRefSignalMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnRefSignalMsgRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnRefSignalMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received reference signal message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSensorMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnSensorMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSensorMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received sensor message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSensorMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnSensorMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSensorMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received sensor message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnIoSHaltMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnIoSHaltMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set Handler for IO-SHalt messages.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received IO-SHalt message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnIoSHaltMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnIoSHaltMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set Handler for IO-SHalt messages.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received IO-SHalt message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnKeyMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnKeyMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

    {
    Set Handler for keyboard messages.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        key board change

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnKeyMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnKeyMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set Handler for keyboard messages.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        key board change

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnRuntimeErrorHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnRuntimeErrorHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnRuntimeError handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received runtime error message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnRuntimeErrorRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnRuntimeErrorRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnRuntimeError handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received runtime error message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnOverflowHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnOverflowHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnOverflow handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        sample overflow

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnOverflowRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnOverflowRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnOverflow handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        sample overflow

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSystemMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnSystemMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnSystemMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received system message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnSystemMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnSystemMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnSystemMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every system message

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDebugMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnDebugMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

    {
    Set the OnDebugMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called at application priority with every
                        received debug message

      Returns:          Error constant (DoPERR_xxxx)

    DoPE event handlers use internaly the windows message WM_APP+0x3FFF (0xBFFF).
    Applications using event handlers must not use this windows message number!
    }


{ ---------------------------------------------------------------------------- }

function DoPESetOnDebugMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnDebugMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

    {
    Set the realtime OnDebugMsg handler.

      In :  DP          DoPE link handle
            Hdlr        is called from the high priotity communication thread
                        with every debug message

      Returns:          Error constant (DoPERR_xxxx)
    }


implementation

//**************************************************************************************************
function DoPESetOnLineHdlr ( DoPEHdl     : DoPE_HANDLE;
                             Hdlr        : DoPEOnLineHdlr;
                             lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnLineRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnLineRtHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDataHdlr ( DoPEHdl     : DoPE_HANDLE;
                             Hdlr        : DoPEOnDataHdlr;
                             lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDataRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnDataRtHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDataBlockHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnDataBlockHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDataBlockRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnDataBlockRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDataBlockSize ( DoPEHdl : DoPE_HANDLE;
                                  nData   : DWord): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPEGetOnDataBlockSize ( DoPEHdl : DoPE_HANDLE;
                                  nData   : PDWord): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnCommandErrorHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnCommandErrorHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnCommandErrorRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnCommandErrorRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnPosMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnPosMsgRtHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnTPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr        : DoPEOnPosMsgHdlr;
                                lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnTPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr        : DoPEOnPosMsgRtHdlr;
                                lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnLPosMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                Hdlr        : DoPEOnPosMsgHdlr;
                                lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnLPosMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnPosMsgRtHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSftMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnSftMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSftMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnSftMsgRtHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnOffsCMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnOffsCMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnOffsCMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnOffsCMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnCheckMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnCheckMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnCheckMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnCheckMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnShieldMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnShieldMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnShieldMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnShieldMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnRefSignalMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnRefSignalMsgHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnRefSignalMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnRefSignalMsgRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSensorMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnSensorMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSensorMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnSensorMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnIoSHaltMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnIoSHaltMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnIoSHaltMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnIoSHaltMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnKeyMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                               Hdlr        : DoPEOnKeyMsgHdlr;
                               lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnKeyMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnKeyMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnRuntimeErrorHdlr ( DoPEHdl     : DoPE_HANDLE;
                                     Hdlr        : DoPEOnRuntimeErrorHdlr;
                                     lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnRuntimeErrorRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                       Hdlr        : DoPEOnRuntimeErrorRtHdlr;
                                       lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnOverflowHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnOverflowHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnOverflowRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnOverflowRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSystemMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                  Hdlr        : DoPEOnSystemMsgHdlr;
                                  lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnSystemMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                    Hdlr        : DoPEOnSystemMsgRtHdlr;
                                    lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDebugMsgHdlr ( DoPEHdl     : DoPE_HANDLE;
                                 Hdlr        : DoPEOnDebugMsgHdlr;
                                 lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPESetOnDebugMsgRtHdlr ( DoPEHdl     : DoPE_HANDLE;
                                   Hdlr        : DoPEOnDebugMsgRtHdlr;
                                   lpParameter : Pointer): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************
function DoPEThreadPollHdlr ( Hdl : DoPE_HANDLE  ): DWord; STDCALL;

   external 'DoPE.dll';
//**************************************************************************************************

end.
