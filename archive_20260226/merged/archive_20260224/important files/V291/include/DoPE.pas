{*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-2010

Description :
=============

   Header for DOLI PC-EDC interface for Windows

Changes :
=========
  HEG,SAH 30.11.97
  - wrote it.

  HEG, 28.4.98
  - DoPEEVT_OVERFLOW definition changed (0x8000 is used by DPX offline event)
  - DoPEEVT_OFFLINE and DoPEEVT_ONLINE defined, DoPEEVT_ALL changed
  - Windows character set used
  - DoPEVersion prepared for version 2.00

  HEG, 18.9.98
  - Multiple definitions of max. values removed

  HEG, 7.10.98
  - DoPEData explicitly aligned on 8byte bounderies

  PET, xx.xx.98/99
  - WINDOWS.H will not be included on DOLI subsystems. BYTE, WORD and DWORD
    defined for DOLI subsystem.
  - New sensor unit UNIT_INC_REV [Increments/Revolution].
  - 16 measuring channels. New 'SENSOR_xx', 'MCBIT_xx' constants.
  - 16 analogue output channels. New 'OUT_xx' constants.
  - 10 channel supervisions.
  - New 'BIN_xx' 'BOUT_xx' constants.
  - Changed 'MAX_MC', 'MAX_OC' constants.
  - New constant 'SENSOR_D' for digipoti (old digipoti was 'SENSOR_O7').
  - New parameters in struct DoPESenDef: 'CtrlChannel', 'UseEeprom',
   'Correction'.
  - New parameters in struct DoPECtrlSenDef: 'PosTd', 'PosGenTd', 'SpeedTd',
    'SpeedGenTd' and 'AccK'.
    'UpperSoftLimit', 'LowerSoftLimit' and 'SoftLimitReaction' removed.
  - New type Double in struct DoPEOutChaDef for 'MaxValue','MinValue','InitValue'
    PaType removed
  - Parameters removed from struct DoPEBitOutDef: 'FlashMask', 'SetMask'.
  - New parameters in struct DoPEBitInDef: 'StopMask', 'StopLevel'.
    'SetMask' removed.
  - New parameters in struct DoPEMachineDef: 'Clampxx', 'Shieldxx'.
    'MachineType' removed
  - New parameters in struct DoPEVersion: 'PeInterfacePC', 'DpxVer'.
  - Struct DoPEDPotiDef and function DoPERdDPotiDef() deleted. The digipoti has
    to be handled as normal sensor. Valid parameters are: 'Connector', 'Sign',
    'Offset', 'Scale'.
  - New struct DoPEGeneralData.
  - New struct DoPESetup.
  - New constants for 'Mode' in DoPECosineV.
  - New constants for 'CtrlState2': CTRL_UPPER_LIMIT, CTRL_LOWER_LIMIT,
    'CTRL_CALIBRATION'
  - Constants for 'McState' removed.
  - Function DoPERSysData() and DoPEWSysData() removed.
  - Function DoPERMkData() and DoPEWMkData() removed.
  - Function DoPERAkData() and DoPEWAkData() removed.
  - New interface function DoPEWrSensorDef, DoPEWrCtrlSensorDef, DoPEWrOutChannelDef,
    DoPEWrBitOutDef, DoPEWrBitInDef and DoPEWrMachineDef.
  - New interface function DoPESetupOpen, DoPESetupClose, DoPERdSetupNumber
  - New interface function DoPERdSetupAll, DopeWrSetupAll
  - New interface function DoPERdLinTbl, DopeWrLinTbl
  - New interface function DoPERdSysUserData, DoPEWrSysUserData
  - New interface function DoPERdGeneralData, DoPEWrGeneralData
  - New interface function DoPERdBitInput, DoPEWrBitOutput
  - New interface function DoPECosineX, DoPECosineV
  - New interface function DoPECtrlP_Xpp, DoPECtrlP_XppNorm
  - New interface function DoPEMTSpecial
  - New interface function DoPECtrlPGKId
  - New interface function DoPEDspBeamScreen, DoPEDspBeamValue
  - New interface function DoPESetCheckLimit, DoPEClrCheckLimit
  - New interface function DoPEShieldLimit, DoPEShieldDisable, DoPEShieldLock
  - New interface function DoPESpeedLimit
  - New error code DoPERR_SETUPOPEN
  - New command error codes DoPERR_CMD_...
  - New command ErrorNumber definitions CMD_ERROR_...
  - New connector constants.
  - DoPECtrl... K/Ti parameters changed from Double to unsigned long/short
  - New default measuring dada record:
    New SysStateN and aditional measuring channels and bit input devices.
    OutChanN, BitOutN, McState, McCal, FatalError, ErrorLevel and
    CtrlState removed.
    McOption1..11 renamed to SensorD, Sensor4..15
  - New Events DoPEEVT_DATAOVERFLOW, DoPEEVT_ACK, DoPEEVT_NAK and DoPEEVT_ALL
  - Conditional compilation for VER2 removed
  - New struct DoPECommandError and DoPEEPError definitions
  - Application version string in DoPEVersion struct changed to 13 char length
  - DoPEOffsK renamed to DoPEOffsC
  - Definitions CHK_BELOW and CHK_ABOVE corrected
  - New typedefinitions for messages not fitting the DoPEMCM sctructure:
  - DoPESftM for 'Softend' Message
  - DoPEOffsCM for 'Offset-Correction' Message
  - DoPECheckM for 'Measuring Channel Supervision' Message

  SAH, 27.9.99
  - New message CMSG_SHIELD
  - New constants for InSignals: IN_SIG_REFERENZ,  IN_SIG_SH_CLOSED
                                 IN_SIG_SH_LOCKED, IN_SIG_SH_KEY

  - New constants for OutSignals: O_SIG_LIMIT,  O_SIG_SH_LOCK
  HEG, 27.9.99
  - New message type definition RAW_SUB_MSG and DoPERawSubMsg
  - New constants for SensorState in DoPESumSenInfo (moved from PEDef.h)

  HEG, 25.11.99
  - DoPEOpenMsgWnd and DoPEAddMsgStr: LPSTR arguments changed to LPCSTR
  - DoPECal and DoPEZeroCal remark updated
  SAH/HEG, 14,01,00
  - New DoPE functions:
    - DoPEConfPeakValue, DoPEPeakValueTime
    - DoPEConfCMcSpeed, DoPEConfCMcCommandSpeed,
    - DoPEConfCMcGradient, DoPEClearCMc
    - DoPESHalt
    - DoPECtrlSpeedTimeBase
    - DoPESetOpenLoopCommand (ACTION_SETOL and EXT_POS_OPENLOOP defined)
    - DoPERdSenUserData, DoPEWrSenUserData (SenUsrDataLen defined)
    - DoPEOpenSetupSync, DoPECloseSetupSync
    - DoPERdSetupAllSync, DoPEWrSetupAllSync
    - DoPESendMsgSync
    - DoPERefrSync
    - DoPESetTimeSync
    - DoPETransmitDataSync
    - DoPESetBasicTareSync
    - DoPESetBSync
    - DoPEIntgrSync
    - DoPECalSync, DoPEZeroCalSync
    - DoPESetOutputSync
    - DoPEDataInclSync, DoPEDataExclSync
    - DoPEStartMwPSync, DoPEStopMwPSync, DoPEClrMwPSync
    - DoPESetCheckSync, DoPEClrCheckSync
    - DoPESetCheckLimitSync, DoPEClrCheckLimitSync
    - DoPEShieldLimitSync, DoPEShieldDisableSync, DoPEShieldLockSync
    - DoPEPosSync, DoPEPos_ASync
    - DoPEExt2CtrlSync
    - DoPEFDPotiSync
    - DoPEFMoveSync
    - DoPEHaltSync, DoPEHalt_ASync, DoPEStopSync
    - DoPEDefaultAccSync
    - DoPEEmergencyMoveSync
    - DoPECycleSync, DoPECosineSync, DoPECosineXSync, DoPETriangleSync, DoPERectangleSync
    - DoPECosineVSync
    - DoPEEmergencyOffSync
    - DoPEPosG1Sync, DoPEPosG1_ASync
    - DoPEPosD1Sync, DoPEPosD1_ASync
    - DoPEPosG2Sync, DoPEPosG2_ASync
    - DoPEPosD2Sync, DoPEPosD2_ASync
    - DoPETrigSync, DoPETrig_ASync
    - DoPEHaltWSync, DoPEHaltW_ASync, DoPESHaltSync
    - DoPEXpContSync, DoPEStartCMDSync, DoPEEndCMDSync
    - DoPEOffsCSync
    - DoPECtrlPSync, DoPECtrlP_XpSync, DoPECtrlP_XppSync, DoPECtrlPGKTdSync
    - DoPEDestWndSync
    - DoPESftSync
    - DoPECtrlErrorSync
    - DoPECtrlPNormSync, DoPECtrlP_XpNormSync, DoPECtrlP_XppNormSync
    - DoPEOnSync
    - DoPECalOutSync
    - DoPEBeepSync
    - DoPELedSync
    - DoPEUniOutSync
    - DoPEBypassSync
    - DoPEDspClearSync, DoPEDspHeadLineSync, DoPEDspFKeysSync, DoPEDspMValueSync
    - DoPEDspBeamScreenSync, DoPEDspBeamValueSync
    - DoPEWrSensorDefSync, DoPEWrCtrlSensorDefSync, DoPEWrOutChannelDefSync
    - DoPEWrBitOutDefSync, DoPEWrBitInDefSync, DoPEWrMachineDefSync, DoPEWrLinTblSync
    - DoPEWrSysUserDataSync, DoPEWrGeneralDataSync
    - DoPEWrBitOutputSync
    - DoPEMTSpecialSync
    - DoPESetCheckLimitSync, DoPEClrCheckLimitSync
    - DoPEShieldLimitSync, DoPEShieldDisableSync, DoPEShieldLockSync
    - DoPESpeedLimitSync
    - DoPEConfPeakValueSync, DoPEPeakValueTimeSync
    - DoPECtrlSpeedTimeBaseSync
    - DoPESetOpenLoopCommandSync
    - DoPEConfCMcSpeedSync, DoPEConfCMcCommandSpeedSync, DoPEConfCMcGradientSync
    - DoPEClearCMcSync
    - DoPEWrSenUserDataSync
  - New constants for DoPEState: COM_STATE_OFF,     COM_STATE_INITCYCLE,
                                 COM_STATE_OFFLINE, COM_STATE_ONLINE
  - DoPEState.ComStatus renamed to DoPEState.ComState
  - New DoPE functions:
    - DoPEGetRTErr
    - DoPEMc2Output
  - New DoPE error constant DoPERR_RTE_UNHANDLED
  - New runtime error constant RTE_ERROR_UNHANDLED and typedefs SubRTErr,
    SubRTErrRaw and DoPERTErr
  FEZ, 19,05,00
  - Constants DoPE-PE-Errors changed to DoPE-CMD-Errors
  FEZ, 28,05,00
  - Include Sync-functions
  FEZ, 29.08.00
  - DoPESetCheckSyncX, DoPESetCheckX
  - New Constant Definitions for DoPESetCheck
    - CHK_PERCENT_MAX, CHK_PERCENT_MIN, CHK_ABS_MAX, CHK_ABS_MIN
    - ACTION_SHALT
  V. 2.20 FEZ, 19.07.01
  - New DoPE function:
    - DoPECurrentData
    - DoPESetupScale
  - UpperLimit/LowerLimit of DoPESumSenInfo dimension is [Unit]
  - CON_X10 defined
  V. 2.20 FEZ, 25.09.01
  FIXED :
  - UpperLimit/LowerLimit of DoPESumSenInfo dimension is [Unit]
  - CON_X10 defined

  FEZ, 27.11.01 - V2.21
  - DoPEAPIVERSION defined for version checks
  - New DoPE function:
    - DoPEOpenLink, DoPECloseLink
      !!! This functions replace the old functions DoPEOpenConnection and DoPECloseConnection !!!
    - DoPEPosExt(Sync)
    - DoPEPosExt_A(Sync)
    - DoPESetDither(Sync)
    - DoPEDebugOutputFlags
    - DoPEDebugOutput
    - DoPEDebugPrintf
  - Message window API replaced by DoPEDebugOutput and DoPEDebugPrintf in WIN32
  - Definitions for the DoPEPosExt... commands:
    - LIMIT_ABSOLUTE, LIMIT_RELATIVE, DEST_APPROACH, DEST_POSITION, DEST_MAINTAIN
  - Definitions for the DoPESetCheck... commands:
    - ACTION_UP, ACTION_DOWN
  - EDC serial number added to DoPEVersion structure
  - SensorNo added to DoPECheckM structure
  - CHK_NOCHECK definition removed
  - New setup parameters in DoPEOutChaDef:
    - MaxCurrTime
    - DitherFrequency
    - DitherAmplitude
    - CurrentControllerGain
    - Signal
    - SignalFrequency
    - ChangeDirection
    - ChangeDirectionLevel
  - Definitions for the digital command outpus CurrentControllerGain, signal and
    frequency in DoPEOutChaDef:
    - OUTSIGNAL_A_B, OUTSIGNAL_PULSE_SIGN, OUTSIGNAL_UP_DOWN
    - OUTSIGNALFREQU2MHz, OUTSIGNALFREQU1MHz, OUTSIGNALFREQU500kHz,
      OUTSIGNALFREQU250kHz, OUTSIGNALFREQU120kHz, OUTSIGNALFREQU60kHz,
      OUTSIGNALFREQU30kHz, OUTSIGNALFREQU10kHz, OUTSIGNALFREQU_MAX
    - OUTCURRCTRLGAINSET_0_01mH, OUTCURRCTRLGAINSET_0_03mH,
      OUTCURRCTRLGAINSET_0_05mH, OUTCURRCTRLGAINSET_0_09mH,
      OUTCURRCTRLGAINSET_0_18mH, OUTCURRCTRLGAINSET_0_35mH,
      OUTCURRCTRLGAINSET_0_7mH,  OUTCURRCTRLGAINSET_1_5mH,
      OUTCURRCTRLGAINSET_3H,     OUTCURRCTRLGAINSET_5mH,
      OUTCURRCTRLGAINSET_9mH,    OUTCURRCTRLGAINSET_18mH,
      OUTCURRCTRLGAINSET_35mH,   OUTCURRCTRLGAINSET_75mH,
      OUTCURRCTRLGAINSET_150mH,  OUTCURRCTRLGAINSET_300mH,
      OUTCURRCTRLGAINSET_MAX
  - Definitions for the debug API:
    - DoPEDebQuiet, DoPEDebERR, DoPEDebAPI, DoPEDebAPIRc, DoPEDebAPIRcNoErr,
      DoPEDebAPICB, DoPEDebAPIRcCB, DoPEDebAPIRcNoErrCB, DoPEDebDLL, DoPEDebALL
  - New command error definition CMD_ERROR_NIM

  SAH, 22.01.02 - V2.22
    - New Names for OUTCURRCTRLGAINSET_x_xxxmH Constants

  HEG, 15.5.02
  - #if/#endif nesting corrected

  HEG, 8.10.02 - V2.23
  - WIN16 support removed
  - New constant definitions for 'MsgId' in MOVE_CTRL_MSG: CMSG_SHIELD_ERR
  - New connector definitions CON_X62A, CON_X62B, CON_X62C, CON_X62D
  - New shield message definition CMSG_SHIELD_ERR
  - New DoPE functions:
    - DoPEGetDebugOutputFlags
    - DoPECtrlTestValuesSync
    - DoPESetRefSignalModeSync
    - DoPESetRefSignalTareSync
    - DoPESetOutChannelOffset(Sync)
    - DoPESynchronizeSystemMode(Sync)
    - DoPESynchronizeSystemStart(Sync)
    - DoPEWrSensorMsg(Sync)
    - DoPERdSensorHeaderData
    - DoPERdSensorAnalogueData
    - DoPEWrSensorAnalogueData
    - DoPERdSensorIncData
    - DoPEWrSensorIncData
    - DoPERdSensorAbsData
    - DoPEWrSensorAbsData
    - DoPERdSensorUserData
    - DoPEWrSensorUserData
    - DoPERdSensorConKey
    - DoPEPosPID(Sync)
    - DoPESpeedPID(Sync)
    - DoPEPosFeedForward(Sync)
  - New MOVE_CTRL_MSG message type definition DoPERefSignalM
  - New message type definition SENSOR_MSG: DoPESensorM
  - New setup Offset parameter in DoPEOutChaDef

  HEG, 25.4.03 - V2.24
  - DoPE functions renamed:
    - DoPECtrlTestValuesSync -> DoPECtrlTestValues
    - DoPESetRefSignalModeSync -> DoPESetRefSignalMode
    - DoPESetRefSignalTareSync -> DoPESetRefSignalTare
  - TAN parameter added to:
    - DoPESetRefSignalMode
    - DoPESetRefSignalTare
  - SIG_DMS renamed to SIG_STRAINGAUGE
  - SIG_SINUS11uA and SIG_SINUS1V renamed to SIG_SINE11uA und SIG_SINE1V

  HEG, 2.7.03 - V2.26
  - DoPEAPIVERSION changed to 2.26 due to DoPERd/WrSetupAll bugfix
  - DOPESETONRUNTIMEERRORHDLR and DOPESETONRUNTIMEERRORRTHDLR defined
  - New connector definitions CON_X61A
  - New absolute sensor definition SIG_MTR_SSI_S2Bx102

  HEG, 26.9.03 - V2.27
  - changed remark for DelayTime unit from [s] to [ms/10]
  - MACHINE_NO_IO_OFF, MACHINE_NO_IO_IN_OUT, MACHINE_NO_IO_OUT and
    MACHINE_NO_IO_IN defined
  - DoPEAPIVERSION changed to 2.27 due to MACHINE_NO_IO changes
  - New DoPE functions:
    - DoPEOfflineActionBitOutput(Sync)
    - DoPEOfflineActionOutput(Sync)
  - DO_NOTHING, USE_INIT_VALUE and USE_VALUE defined

  HEG, 8.6.04 - V2.28
  - DoPEMc2Output remark modified
  - TRUE and FALSE replaced by !=0 and 0

  HEG, 5.7.04 - V2.29
  - The DoPEAPIVERSION and the DoPE version are set to the same value
  - New connector definitions CON_X61B, CON_X61C, CON_X61D
  - New CtrlState1 definitions CTRL_SYNCHWAIT and CTRL_SLAVE
  - New DoPE functions:
    - DoPEOff(Sync)
    - DoPESerialSensorDef(Sync)
    - DoPESetSerialSensor(Sync)
  - SERSEN_TRANSFER defined
  - SERSEN_ENDCHAR_NO, SERSEN_ENDCHAR_1, SERSEN_ENDCHAR_1_OR_2,
    SERSEN_ENDCHAR_1_AND_2 and SERSEN_ENDCHAR_1_PLUS1 defined
  - SERSEN_SET_COMMAND and SERSEN_SET_FEEDBACK defined
  - CTRL_STRUCTURE_OPENLOOP defined
  - O_SIG_ON_RELAY, O_SIG_READY_TO_MOVE and O_SIG_INTERNAL_DRIVE_ENABLE defined
  - New setup parameters in DoPEMachineDef:
    - CtrlOnMode
    - FixValue
    - InitValue
    - ReturnValue

  HEG, 2.3.05 - V2.30
  - DoPEAPIVERSION changed to 2.30
  - Serial sensor definition init value definitions:
    - SERSEN_SIGN_P, SERSEN_SIGN_N
    - SERSEN_PORT_DEBUG, SERSEN_PORT_COM1 , SERSEN_PORT_COM2, SERSEN_PORT_COM3
    - SERSEN_STOPBIT_1, SERSEN_STOPBIT_2
    - SERSEN_110BAUD, SERSEN_150BAUD, SERSEN_300BAUD, SERSEN_600BAUD
    - SERSEN_1200BAUD, SERSEN_2400BAUD, SERSEN_4800BAUD, SERSEN_9600BAUD
    - SERSEN_19200BAUD, SERSEN_38400BAUD, SERSEN_57600BAUD, SERSEN_115200BAUD
    - SERSEN_230400BAUD, SERSEN_460800BAUD, SERSEN_921600BAUD
    - SERSEN_NOPROTOCOL, SERSEN_DOLIPROTOCOL, SERSEN_EUROTHERM, SERSEN_GRADO
    - SERSEN_AI_808
    - SERSEN_NOPARITY, SERSEN_ODDPARITY, SERSEN_EVENPARITY
    - SERSEN_7DATABIT, SERSEN_8DATABIT

  HEG, 24.6.05 - V2.31:
  - DoPEAPIVERSION changed to 2.31

  HEG, 5.7.05 - V2.32:
  - DoPEAPIVERSION changed to 2.32

  HEG, 25.4.05 - V2.50
  - DoPEAPIVERSION changed to 2.50
  - New DoPE functions:
    - DoPEDefineNIC
    - DoPEPortInfo
    - DoPEInitializeResetXHead
    - DoPERdModuleInfo
  - Port info definitions:
    - DoPEPORTCOM, DoPEPORTUSB, DoPEPORTLAN, DoPEPORTNAMELEN
    - MAC, DoPE_PORTINFO
  - DoPEGeneralData extended:
    - nRmc, Language, FunctionID
  - Language definitions:
    - LANGUAGE_ENGLISH, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_FRENCH

  HEG, 12.5.06 - V2.51
  - Obsolete functions and definitions removed
    - DoPEOpenMsgWnd, DoPECloseMsgWnd, DoPEAddMsgStr, DoPEMeldWndProc
    - DoPECtrlP(Sync), DoPECtrlP_Xp(Sync), DoPECtrlP_Xpp(Sync), DoPECtrlPGKTd(Sync)
    - DoPECtrlPNorm(Sync), DoPECtrlP_XpNorm(Sync), DoPECtrlP_XppNorm(Sync)
    - DoPEStartMwP, DoPEStopMwP, DoPEGetMwP, DoPEClrMwP
    - DoPEDataIncl(Sync), DoPEDataExcl(Sync)
    - DoPEMTSpecial(Sync)
    - DoPEGetRTErr
    - CBR_57600, CBR_115200
    - CTRL_STRUCTURE_PNEUMATIC
  - New DoPESetRefSignalTare definition:
    - REFSIG_TARE
  - New DoPESetBasicTare definitions:
    - BASICTARE_SET
    - BASICTARE_SUBTRACT
  - New DoPEOutChaDef definitions:
    - OUTSIGNAL_ANALOGUE, OUTSIGNAL_DDD
    - OUTSIGNALFREQU4MHz
  - OUTSIGNALFREQUxxxHz definitions changed (+1)
  - Renamed functions and definitions
    - DoPERefr(Sync) -> DoPESetDataTransmissionRate(Sync)
    - DoPECosineV(Sync) -> DoPECosinePeakCtrl(Sync)
    - DoPEStop(Sync) -> DoPESetCtrl(Sync)
      - unsigned short State -> unsigned Enable (level inverted!)
    - OUTSIGNALFREQU120kHz -> OUTSIGNALFREQU125kHz
    - OUTSIGNALFREQU10kHz  -> OUTSIGNALFREQU15kHz
    - IN_SIG_STOP -> IN_SIG_NO_CTRL
    - IN_SIG_SH_KEY -> IN_SIG_SH_INACTIVE
    - DoPECtrlSenDef:
      - WndSize    -> UnUsed1
      - WndTime    -> UnUsed2
      - PosK	     -> PosP
      - PosTi	     -> PosI
      - PosTd      -> PosD
      - PosGenTd   -> PosFFP
      - SpeedK	   -> SpeedP
      - SpeedTi	   -> SpeedI
      - SpeedTd	   -> SpeedD
      - SpeedGenTd -> UnUsed3
      - AccK       -> UnUsed4
    - DoPEOutChaDef:
      - ChangeDirection      -> UnUsed1
      - ChangeDirectionLevel -> UnUsed2
    - DoPEMachineDef:
      - DataAqTime     -> DataTransmissionRate
      - Bypass         -> UnUsed3
      - MotorEncRatio  -> UnUsed4
      - ClampConnector -> GripConnector
      - ClampChannel   -> GripChannel
      - ClampActive    -> GripActive
    - DoPEGetData, DoPECurrentData:
      - void *Buffer -> DoPEData *Sample
  - New DoPE functions:
    - DoPEClearErrors
    - DoPESetIoCompatibilityMode
  - DoPESynchronizeSystemMode(Sync) and DoPESynchronizeSystemStart(Sync)
    moved from Dope.h to module DoPEsyn.h

  HEG, 20.11.06 - V2.54
  - SIG_TR_LT_S redefined to SIG_ROQ_424

  HEG, 22.12.06 - V2.57
  - Debugger API removed
  - New DoPE functions:
    - DoPECurrentPID(Sync)
    - DoPERdDriveInfo
    - DoPEFMove_A
  - DoPEDriveInfo structure defined
  - New Setup parameters in DoPEGeneralData:
  	- SyncOption
    - MachineName
  - DoPEOutChaDef definition OUTSIGNAL_DDD replaced by
    - OUTSIGNAL_SIGN_MAGNITUDE
    - OUTSIGNAL_LOCKEDANTIPHASE
  - New definition for the DoPEPosExt... commands:
    - LIMIT_NOT_ACTIVE
  - New definition for the DoPESetCheck... commands:
    - ACTION_DRIVE_OFF

  HEG, 9.7.07 - V2.58
  - Setup parameters removed from DoPEGeneralData:
  	- SyncOption
    - MachineName

  HEG, xx.xx.xx - V2.59
  - New DoPE functions:
    - DoPESetCheckLimitIO
    - DoPEOpenFunctionID
    - DoPEOpenDeviceID
    - DoPEOpenAll
    - DoPECloseAll
    - DoPEFeedForward(Sync)
    - DoPEOptimizeFeedForward(Sync)
    - DoPERdCtrlSensorDefHigh
    - DoPEWrCtrlSensorDefHigh
    - DoPERdIOSignals
    - DoPEWrIOSignals(Sync)
    - DoPERdMainMenu
    - DoPEWrMainMenu(Sync)
    - DoPERdCtrlParameter
    - DoPEIOGripEnable(Sync)
    - DoPEIOGripSet(Sync)
    - DoPEIOGripPressure(Sync)
    - DoPEIOExtEnable(Sync)
    - DoPEIOExtSet(Sync)
    - DoPEIOFixedXHeadEnable(Sync)
    - DoPEIOFixedXHeadSet(Sync)
    - DoPEIOHighPressureEnable(Sync)
    - DoPEIOHighPressureSet(Sync)
  - New Setup parameters in DoPEGeneralData:
  	- SyncOption
    - MachineNoIoBitConnector
    - MachineNoIoBitNo
  - New Setup parameters in DoPECtrlSenDef:
  	- SpeedFFP
    - PosDelay
    - AccFFP
    - SpeedDelay
  - New setup parameters:
    - DoPECtrlSenDef for high pressure
    - DoPEIOSignals
      - DoPEIOGrip
      - DoPEIOExt
      - DoPEIOFixedXHead
      - DoPEIOHighPressure
      - DoPEIOKey
      - DoPEIOTest
      - DoPEIOMisc
    - DoPEMainMenu
  - New setup parameters in DoPEOutChaDef:
    - CurrentP/I/D
  - OUTSIGNAL_DC_MOTOR and OUTSIGNAL_DC_LINEAR_MOTOR defined
    (should be used instead of OUTSIGNAL_SIGN_MAGNITUDE and OUTSIGNAL_LOCKEDANTIPHASE)
  - MAX_MACHINE changed from 4 to 8
  - New connectors CON_X36A/B...CON_X39A/B defined
  - New IO bit definitions implemented
  - New main menu configuration definitions implemented
  - NIC definitions can be removed by passing a NULL pointer to DoPEDefineNIC
  - "pragma warning" eliminated for MinGW GNU Compiler
  - New Event DoPEEVT_RESTART defined and included to DoPEEVT_ALL
  - 'CtrlState2' definitions extended by CTRL_HIGH_PRESSURE

  HEG, 31.1.08 - V2.60
  - DoPECtrlParameter extended:
    - MinAcceleration, MaxAcceleration
    - MinDeceleration, MaxDeceleration
    - MinSpeed, MaxSpeed

  HEG, 15.4.08 - V2.61
  - New connector definitions CON_X21D,...,CON_X28D
  - New CtrlState2 definition CTRL_CYCLES_ACTIVE

  HEG, 28.7.08 - V2.62
  - DoPE.h defined DoPEIOHighPressureSet without the lpusTan parameter. Bug fixed.
  - DoPE debug functions removed:
    - DoPEGetDebugOutputFlags
    - DoPEDebugOutputFlags
    - DoPEDebugOutput
    - DoPEDebugPrintf
  - OutChaNominalPressure in DoPEIOGrip struct was changed to UnUsed1.
  - All grip pressure parameters are changed form unit [Pa] to [%].
  - New in DoPEIOHighPressure struct:
    - PressureOutputEnabled
    - OutChaNo
    - OutChaLowPressure
    - OutChaHighPressure
    - OutChaRampTime
  - DoPEIOExtSet declared the TAN parameter as unsigned pointer. Must be
    unsigned short pointer. Bug fixed.

  HEG, 1.10.08 - V2.63
  - New DoPE function:
    - DoPEDynCycles(Sync)
  - New absolute sensor type definition SIG_POSITAL_SL_G
  - Absolute sensor definition SIG_UNDEF removed.
  - Typo in SIG_MTR_SSI_S2Bx102 removed. Must read SIG_MTS_SSI_S2Bx102.

  HEG, 4.3.09 - V2.65
  - Constants for system messages defined
  - wide character support implemented
  - Display length definitions:
    - DSP_HEADLINE_LEN
    - DSP_FKEYSLINE_LEN
    - DSP_VALUE_LEN
    - DSP_DIM_LEN
  - Version text length definitions:
    - PEINTERFACE_LEN
    - APPLICATION_LEN
    - SUBSY_LEN
    - SUBSYCUSTVER_LEN
    - SUBSYCUSTNAME_LEN
    - BIOS_LEN
    - HWCTRL_LEN
    - PEINTERFACEPC_LEN
    - DPXVER_LEN
    - SERIALNUMBER_LEN
  - New type definitions:
    - DoPEwVersion
    - DoPEwModuleInfo
    - DoPEwDriveInfo
    - DoPE_wPORTINFO
    - DoPEwOpenLinkInfo
  - New DoPE functions:
    - DoPEwDspHeadLine(Sync)
    - DoPEwDspFKeys(Sync)
    - DoPEwDspMValue(Sync)
    - DoPEwRdVersion
    - DoPEwRdModuleInfo
    - DoPEwRdDriveInfo
    - DoPEwRdLanguageInfo
    - DoPEwPortInfo
    - DoPEwOpenAll
    - DoPEwCloseAll
    - DoPEShieldEnable(Sync)
  - New IO Grip Mode definitions:
    - IO_GRIP_MODE_0_OFF
    - IO_GRIP_MODE_1_TANSPARENT
    - IO_GRIP_MODE_2_LIMIT_CTRL
  - Language definitions redefined:
    - LANGUAGE_SPANISH -> LANGUAGE_USER1
    - LANGUAGE_FRENCH  -> LANGUAGE_USER2
  - LANGINFO_NAME_LEN and struct DoPEwLanguageInfo defined
  - SYSTEM_MSG_LANGUAGE_READ, SYSTEM_MSG_LANGUAGE_VERSION and SYSTEM_MSG_LANGUAGE_SYNTAX defined
  - New DoPEDynCycles definitions for SweepFrequencyMode and SweepAmplitudeMode:
    - DYN_SWEEP_LINEAR_START_END
    - DYN_SWEEP_LOGARITHMIC_START_END

  HEG, 7.12.09 - V2.66
  - Source code layout adapted to C++ header
  - Bug in DoPESensorAnalogueData declaration removed. LinVal was to big.
  New DoPEMc2Output 'Mode' definition:
    - MC2OUT_BURST
  New absolute value sensor type definitions:
    - SIG_POSITAL_SL_G renamed to SIG_POSITAL_SL_G_24
    - SIG_POSITAL_SL_G_16 4
    - SIG_ROQ_425
    - SIG_SSI_GENERIC, SIG_SSI_CODE, SIG_SSI_LEN, SIG_SSI_LEN_OFFS
  - New DoPE functions:
    - DoPESetSsiGenericSignalType
    - DoPESsiGenericSignalTypeInfo
    - DoPESetSerialSensorTransparent(Sync)
    - DoPESetSensorDataTransmissionRate(Sync)
    
  HEG, 20.7.10 - V2.68
  - New DoPE functions:
    - DoPERdRmcDef
    - DoPEWrRmcDef(Sync)
  - New setup parameters:
    - in DoPEOutChaDef:
      - DoPEMc2OutputDef
    - in DoPEMachineDef:
      - ShieldUprLock
      - ShieldLwrLock
      - ShieldSpeedLimit
      - LimitSwitchType
      - XheadInitialMode
      - XheadInitialValue
      - X4Pin14Mode
    - in DoPEIOSignals
      - DoPEIOSHalt
      - DoPEIOKey and DoPEIOTest removed
    - in DoPESetup:
      - DoPERmcDef
        - PushMode
        - DoPERmcDPoti
        - DoPERmcIOKey
  - New definition for max. number of DoPERmcIOKey definitions:
    - RMCIO_KEY_MAX 16
  - New definitions for DoPEMachineDef LimitSwitchType:
    - LIMIT_SWITCH_TYPE_SINGLE
    - LIMIT_SWITCH_TYPE_UPPER_LOWER
  - New definitions for DoPEMachineDef XHeadInitialMode:
    - XHEAD_INITIAL_MODE_AUTOMATIC
    - XHEAD_INITIAL_MODE_MANUAL
  - New definitions for DoPEMachineDef X4Pin14Mode:
    - X4PIN14_MODE_BYPASS
    - X4PIN14_MODE_EDC_READY
  - New IO Grip Mode definition:
    - IO_GRIP_MODE_3_LIMIT_CTRL_INVERTED
  - New system message definitions:
    - SYSTEM_MSG_OC_MC2OUTPUT
    - SYSTEM_MSG_IO_MISC_TEMPERATURE1
    - SYSTEM_MSG_IO_MISC_TEMPERATURE2
    - SYSTEM_MSG_IO_MISC_OIL_LEVEL
    - SYSTEM_MSG_IO_MISC_OIL_FILTER
    - SYSTEM_MSG_IO_MISC_POWER_FAIL
    - SYSTEM_MSG_IO_SHALT_MODE
    - SYSTEM_MSG_IO_SHALT_BIN
  - Obsolete system messages removed:
    - SYSTEM_MSG_IO_KEY_MODE,
    - SYSTEM_MSG_IO_KEY_BIN
    - SYSTEM_MSG_IO_KEY_BOUT
    - SYSTEM_MSG_IO_TEST_MODE
    - SYSTEM_MSG_IO_TEST_BIN
    - SYSTEM_MSG_IO_TEST_BOUT
  - New InSignals and OutSignals definitions:
    - IN_SIG_IO_SHALT_UPPER
    - IN_SIG_IO_SHALT_LOWER
    - O_SIG_EDC_READY    
    
  HEG, 20.7.11 - V2.70
  - New DoPE functions:
    - DoPECurrentPortInfo, DoPEwCurrentPortInfo

  HEG 25.9.10 - V2.71
  - New DopE functions:
    - DoPERdPosPID, DoPEWrPosPID(Sync)           ( requires PE-Version 2.71 ! )
    - DoPERdSpeedPID, DoPEWrSpeedPID(Sync)       ( requires PE-Version 2.71 ! )
    - DoPERdFeedForward, DoPEWrFeedForward(Sync) ( requires PE-Version 2.71 ! )

  HEG, 26.1.2012 - V 2.72
  - IN_SIG_CPU_EMERGENCY_OFF defined

  HEG, 26.7.2012 - V 2.73
  - 16 control channels supported
    - MAX_CTRL changed to 16
    - CTRL_SENSOR_3 to CTRL_SENSOR_15 defined
    - SENSOR_3 defined (SENSOR_D removed)
  - New DigiPoti sensor definition SENSOR_DP.
    The DigiPoti (Connector X63A) can be defined at any sensor position in the setup.
    SENSOR_DP can be used in the DoPEFDPoti(Sync) and DoPEIntgr(Sync) commands.
  - measuring data record modified 
    - new DoPEData.Sensor3          (was DoPEData.SensorD)
    - new DoPEData.ActiveCtrl       (was DoPEData.SysState1)
    - new DoPEData.UpperSft         (was DoPEData.SysState2)
    - new DoPEData.LowerSft         (was DoPEData.SysState3)
    - new DoPEData.SensorConnected  (was DoPEData.SysState4)
    - new DoPEData.SensorKeyPressed (was DoPEData.SysState5)
    - ActiveCtrl indicates the active control channel     (Bit0=Position Control ... Bit15=Sensor15 Control)
    - UpperSft/LowerSft indicates 'Range limit exceeded'           (Bit0=Position Sensor ... Bit15=Sensor15)
    - SensorConnected indicates the connected sensor plugs         (Bit0=Position Sensor ... Bit15=Sensor15)
    - SensorKeyPressed indicates the active sensor plugs key state (Bit0=Position Sensor ... Bit15=Sensor15)
  - New runtime error for controller deviation error:
    - RTE_CTRL_DEVIATION (Device contains the control channel)
      (RTE_ERROR_S, RTE_ERROR_F, RTE_ERROR_D removed)
  - New DoPE function:
    - DoPEIgnoreTcpIpNIC
  - BaudRate parameter added to DoPE_PORTINFO struct.
  - Mc2Output(sync) definition by up to three points
    - New MC2OUT_MODE... and MC2OUT_PRIORITY... definitions
    - DoPEMc2Output command parameters adjusted
    - DoPEMc2OutputDef setup structure adjusted

  HEG, 26.7.13 - V 2.76
  - New DoPE function:
    - DoPEWrSensorHeaderData
  - New definitions for calculated sensors:
    - MAX_CALCULATED_CHANNELS
    - F_S1PlusS2_half, F_S1MinusS2, F_S1PlusS2PlusS3_third, F_S1PlusS2PlusS3
      F_S1PlusS2, F_StiffnessCorrection, F_SensorCorrection, F_ExtendedFormula,
      F_S1PlusS2PlusS3PlusS4_quarter, F_S1PlusS2PlusS3PlusS4

  HEG 18.09.13 - V2.77
  - NEW Modes for DynCycle Command:
    - DYN_WAVEFORM_SAW_TOOTH, DYN_WAVEFORM_SAW_TOOTH_INV, DYN_WAVEFORM_PULSE
  - New Constant for 'OutSignals':
    - O_SIG_DRIVE_OFF
  - New  parameters in DoPESumSenInfo:
    - Tare
    - UserScale
    - McIntegr
    - CtrlIntegr
    - HwDelayTime
    - McDelayTime
    - McDelayTimeCorr
    
  HEG, 13.2.14 - V2.78
  - Missing DoPE error definition DoPERR_CMD_NIM implemented
    
  HEG, 26.3.14 - V2.79
  - New DopE functions:
    - DoPEDeadbandCtrl(Sync)
  - DoPECtrlParameter extended:
    - Deadband
    - PercentP
    
  HEG, 20.5.14 - V2.80
  - New Mode parameter for DoPESetTime(Sync) and constatnt definitions:
    - SETTIME_MODE_IMMEDIATE
    - SETTIME_MODE_MOVE_START
    - SETTIME_MODE_FIRST_CYCLE
  - New DopE function:
    - DoPESetCycleMode
    
  HEG, 25.8.15 - V2.82
  - New DopE function:
    - DoPESetNominalAccSpeed(Sync)

  HEG, 29.7.16 - V2.84
  - New DoPE functions:
    - DoPEReInitialize
    - DoPEReInitializeEnable
    
  HEG, 16.10.17 - V2.86
  - New Serial Sensor modbus temperature controllers definitions
    - SERSEN_MODBUS_EUROTHERM
    - SERSEN_MODBUS_GRADO
    - SERSEN_MODBUS_SHIMANDEN
    - SERSEN_MODBUS_AZBIL
    
  HEG, 18.7.18 - V2.89
  - DoPEError and DoPEState record declarations were to short. Bug fixed.
*****************************************************************************}

unit DoPE;

{$ALIGN OFF}

interface

uses Windows;

{ ------------------------ Constants and Definitions ------------------------ }

const
   DoPEAPIVERSION = $0291;             { DoPE API version number              }

type                                   { Units for sensors                    }
  Units = (                            { ------------------------------------ }
    UNIT_NO                    ,       { No unit                              }
    UNIT_DEGREE                ,       { [°]                                  }
    UNIT_DEGREE_SEC            ,       { [°/s]                                }
    UNIT_DEGREE_SEC2           ,       { [°/s²]                               }
    UNIT_METER                 ,       { [m]                                  }
    UNIT_METER_SEC             ,       { [m/s]                                }
    UNIT_METER_SEC2            ,       { [m/s²]                               }
    UNIT_NEWTON                ,       { [N]                                  }
    UNIT_PASCAL                ,       { [P]                                  }
    UNIT_DEGREE_CELSIUS        ,       { [°C]                                 }
    UNIT_VOLT                  ,       { [V]                                  }
    UNIT_AMPERE                ,       { [A]                                  }
    UNIT_OHM                   ,       { [Ohm]                                }
    UNIT_SEC                   ,       { [s]                                  }
    UNIT_HERTZ                 ,       { [Hz]                                 }
    UNIT_WATT                  ,       { [W]                                  }
    UNIT_INC_REV               ,       { [Increments/Revolution]              }
    UNIT_MAX                           { End of unit definitions              }
  );

{ -------- Definitions of user data length ---------------------------------- }

const
  SysUsrDataLen = 16;                  { System UserData length (in Bytes)    }
  SenUsrDataLen = 128;                 { Sensor UserData length (in Bytes)    }

{ -------- Definitions of max. values --------------------------------------- }

  MAX_MC      = 16;                    { maximum number of sensors            }
  MAX_OC      = 16;                    { maximum number of output channels    }
  MAX_BOUT    = 10;                    { maximum number of digital outputs    }
  MAX_BIN     = 10;                    { maximum number of digital inputs     }
  MAX_CTRL    = 16;                    { maximum number of control channels   }
  MAX_MACHINE = 8;                     { max. number of machine definitions   }
  MAX_MODULE  = 32;                    { max. number of modules               }

{ --------------- Logical channel definitions ------------------------------- }

{ -------------- Measuring channels ----------------------------------------- }

    SENSOR_S    = 0;                   { X-head position                      }
    SENSOR_F    = 1;                   { Load                                 }
    SENSOR_E    = 2;                   { Extension                            }
    SENSOR_3    = 3;                   { Sensor 3                             }
    SENSOR_4    = 4;                   { Sensor 4                             }
    SENSOR_5    = 5;                   { Sensor 5                             }
    SENSOR_6    = 6;                   { Sensor 6                             }
    SENSOR_7    = 7;                   { Sensor 7                             }
    SENSOR_8    = 8;                   { Sensor 8                             }
    SENSOR_9    = 9;                   { Sensor 9                             }
    SENSOR_10   = 10;                  { Sensor 10                            }
    SENSOR_11   = 11;                  { Sensor 11                            }
    SENSOR_12   = 12;                  { Sensor 12                            }
    SENSOR_13   = 13;                  { Sensor 13                            }
    SENSOR_14   = 14;                  { Sensor 14                            }
    SENSOR_15   = 15;                  { Sensor 15                            }
    SENSOR_DP   = $FFFF;               { Digipoti                             }

{ --------------- Analogue output channels ---------------------------------- }

    COMMAND_OUT = 0;                   { Command output                       }
    OUT_1       = 1;                   { Optional channel 1                   }
    OUT_2       = 2;                   { Optional channel 2                   }
    OUT_3       = 3;                   { Optional channel 3                   }
    OUT_4       = 4;                   { Optional channel 4                   }
    OUT_5       = 5;                   { Optional channel 5                   }
    OUT_6       = 6;                   { Optional channel 6                   }
    OUT_7       = 7;                   { Optional channel 7                   }
    OUT_8       = 8;                   { Optional channel 8                   }
    OUT_9       = 9;                   { Optional channel 9                   }
    OUT_10      = 10;                  { Optional channel 10                  }
    OUT_11      = 11;                  { Optional channel 11                  }
    OUT_12      = 12;                  { Optional channel 12                  }
    OUT_13      = 13;                  { Optional channel 13                  }
    OUT_14      = 14;                  { Optional channel 14                  }
    OUT_15      = 15;                  { Optional channel 15                  }

{ --------------- Digital inputs -------------------------------------------- }

    BIN_0       = 0;                   { Digital input 0                      }
    BIN_1       = 1;                   { Digital input 1                      }
    BIN_2       = 2;                   { Digital input 2                      }
    BIN_3       = 3;                   { Digital input 3                      }
    BIN_4       = 4;                   { Digital input 4                      }
    BIN_5       = 5;                   { Digital input 5                      }
    BIN_6       = 6;                   { Digital input 6                      }
    BIN_7       = 7;                   { Digital input 7                      }
    BIN_8       = 8;                   { Digital input 8                      }
    BIN_9       = 9;                   { Digital input 9                      } 

{ --------------- Digital outputs ------------------------------------------- }

    BOUT_0      = 0;                   { Digital output 0                     }
    BOUT_1      = 1;                   { Digital output 1                     }
    BOUT_2      = 2;                   { Digital output 2                     }
    BOUT_3      = 3;                   { Digital output 3                     }
    BOUT_4      = 4;                   { Digital output 4                     }
    BOUT_5      = 5;                   { Digital output 5                     }
    BOUT_6      = 6;                   { Digital output 6                     }
    BOUT_7      = 7;                   { Digital output 7                     }
    BOUT_8      = 8;                   { Digital output 8                     }
    BOUT_9      = 9;                   { Digital output 9                     }

{ ------------ Constants for DoPE commands ---------------------------------- }


{ ------------ Connector constants ------------------------------------------ }

    CON_NON   = $00;
    CON_X1    = $01;
    CON_X2    = $02;
    CON_X3    = $03;
    CON_X4    = $04;
    CON_X5    = $05;
    CON_X7    = $07;
    CON_X10   = $0A;
    CON_X14   = $0E;
    CON_X21A  = $15;
    CON_X21B  = $55;
    CON_X21C  = $95;
    CON_X21D  = $D5;
    CON_X22A  = $16;
    CON_X22B  = $56;
    CON_X22C  = $96;
    CON_X22D  = $D6;
    CON_X23A  = $17;
    CON_X23B  = $57;
    CON_X23C  = $97;
    CON_X23D  = $D7;
    CON_X24A  = $18;
    CON_X24B  = $58;
    CON_X24C  = $98;
    CON_X24D  = $D8;
    CON_X25A  = $19;
    CON_X25B  = $59;
    CON_X25C  = $99;
    CON_X25D  = $D9;
    CON_X26A  = $1A;
    CON_X26B  = $5A;
    CON_X26C  = $9A;
    CON_X26D  = $DA;
    CON_X27A  = $1B;
    CON_X27B  = $5B;
    CON_X27C  = $9B;
    CON_X27D  = $DB;
    CON_X28A  = $1C;
    CON_X28B  = $5C;
    CON_X28C  = $9C;
    CON_X28D  = $DC;
    CON_X36A  = $24;
    CON_X36B  = $64;
    CON_X37A  = $25;
    CON_X37B  = $65;
    CON_X38A  = $26;
    CON_X38B  = $66;
    CON_X39A  = $27;
    CON_X39B  = $67;
    CON_X61A  = $3D;
    CON_X61B  = $7D;
    CON_X61C  = $BD;
    CON_X61D  = $FD;
    CON_X62A  = $3E;
    CON_X62B  = $7E;
    CON_X62C  = $BE;
    CON_X62D  = $FE;
    CON_X63A  = $3F;


{ ----- Constants for closed loop control modes ----------------------------- }

   CTRL_POS       = 0;                 { X-Head position control              }
   CTRL_LOAD      = 1;                 { Load control                         }
   CTRL_EXTENSION = 2;                 { Extension control                    }
   CTRL_SENSOR_3  = 3;                 { Sensor 3  control                    }
   CTRL_SENSOR_4  = 4;                 { Sensor 4  control                    }
   CTRL_SENSOR_5  = 5;                 { Sensor 5  control                    }
   CTRL_SENSOR_6  = 6;                 { Sensor 6  control                    }
   CTRL_SENSOR_7  = 7;                 { Sensor 7  control                    }
   CTRL_SENSOR_8  = 8;                 { Sensor 8  control                    }
   CTRL_SENSOR_9  = 9;                 { Sensor 9  control                    }
   CTRL_SENSOR_10 = 10;                { Sensor 10 control                    }
   CTRL_SENSOR_11 = 11;                { Sensor 11 control                    }
   CTRL_SENSOR_12 = 12;                { Sensor 12 control                    }
   CTRL_SENSOR_13 = 13;                { Sensor 13 control                    }
   CTRL_SENSOR_14 = 14;                { Sensor 14 control                    }
   CTRL_SENSOR_15 = 15;                { Sensor 15 control                    }


{ ----- Bit constants for measuring channels -------------------------------- }

   MCBIT_S        = $0001;
   MCBIT_F        = $0002;
   MCBIT_E        = $0004;
   MCBIT_D        = $0008;
   MCBIT_4        = $0010;
   MCBIT_5        = $0020;
   MCBIT_6        = $0040;
   MCBIT_7        = $0080;
   MCBIT_8        = $0100;
   MCBIT_9        = $0200;
   MCBIT_10       = $0400;
   MCBIT_11       = $0800;
   MCBIT_12       = $1000;
   MCBIT_13       = $2000;
   MCBIT_14       = $4000;
   MCBIT_15       = $8000;


{ ------ Constants for  'CheckID' in DoPESetCheck --------------------------- }

    CHK_ID0           = 0;             { channel supervision ID 0             }
    CHK_ID1           = 1;             { channel supervision ID 1             }
    CHK_ID2           = 2;             { channel supervision ID 2             }
    CHK_ID3           = 3;             { channel supervision ID 3             }
    CHK_ID4           = 4;             { channel supervision ID 4             }
    CHK_ID5           = 5;             { channel supervision ID 5             }
    CHK_ID6           = 6;             { channel supervision ID 6             }
    CHK_ID7           = 7;             { channel supervision ID 7             }
    CHK_ID8           = 8;             { channel supervision ID 8             }
    CHK_ID9           = 9;             { channel supervision ID 9             }
    CHK_NUMBER        = 10;            { Number of channel supervisions       }
    CHK_ID_ALL        = $FFFF;         { All supervision ID's (for clear)     }
    CHK_NOCLEAR       = $8000;         { Mask to "or" with CHK_Idx for checks }
                                       { that should not be cleared after     }
                                       { another check hits                   }


{ ------ Constants  for 'Mode' in DoPESetCheck   ---------------------------- }

    CHK_BELOW         = 0;             { Condition (value < Limit)            }
    CHK_ABOVE         = 1;             { Condition (value > Limit)            }
    CHK_PERCENT_MAX   = 2;             { Condition (value < % of max value)   }
    CHK_PERCENT_MIN   = 3;             { Condition (value > % of min value)   }
    CHK_ABS_MAX       = 4;             { Condition (value < max - x)          }
    CHK_ABS_MIN       = 5;             { Condition (value > min - x)          }


{ ------ Constants  for 'Action' in  DoPESetCheck(X) ------------------------ }
{ ------ Constants  for 'Action' in  DoPEShieldLimit ------------------------ }
{ ------ for DoPEShieldLimit only ACTION_HALT and ACTION_STOP are allowed !!  }

    ACTION_HALT       = 0;             { HALT with default deceleration       }
    ACTION_HALT_A     = 1;             { HALT with specified deceleration     }
    ACTION_POS        = 2;             { Position with default deceleration   }
    ACTION_POS_A      = 3;             { Position with specified deceleration }
    ACTION_XPCONT     = 4;             { Change control mode, go on with      }
                                       { actual speed                         }
    ACTION_STOP       = 5;             { Stop (switch off drive)              }
    ACTION_NOACTION   = 6;             { No action, only message to host      }
    ACTION_SETOL      = 7;             { Set command output in open loop      }
    ACTION_SHALT      = 8;             { immediate S-Halt                     }
    ACTION_UP         = 9;             { Move Up with specified speed         }
    ACTION_DOWN       = 10;            { Move Down with specified speed       }
    ACTION_DRIVE_OFF  = 11;            { Switch drive OFF                     }

{ ------ Constants  for 'Mode' DoPEExt2Ctrl and DoPEFDPoti ------------------ }
                                       { Constants 0 .. 3 refer to measuring  }
                                       { values. E.g EXT_SPEED_POSITIVE       }
                                       { moves to increasing values.          }
   EXT_POSITION       = 0;             { Position                             }
   EXT_SPEED_BIPOLAR  = 1;             { Speed bipolar                        }
   EXT_SPEED_POSITIVE = 2;             { Speed positive direction             }
   EXT_SPEED_NEGATIVE = 3;             { Speed negative direction             }
   
                                       { Direction UP/DOWN                    }
                                       { Constants 0 .. 3 refer to movement   }
                                       { UP/DOWN. E.g EXT_SPEED_UP moves      }
                                       { crosshead UP.                        }
   EXT_POS_UP_DOWN    = 4;             { Position                             }
   EXT_SPEED_UP_DOWN  = 5;             { Speed bipolar                        }
   EXT_SPEED_UP       = 6;             { Speed UP                             }
   EXT_SPEED_DOWN     = 7;             { Speed DOWN                           }

   EXT_POS_OPENLOOP   = 8;             { Position (only for open loop position}
                                       { ctrl-structure.) and PS_FDPOTI       }

{ ------ Constants  for 'Direction' in DoPEFMove command  ------------------- }

   MOVE_HALT         = 0;              {  Halt                                }
   MOVE_UP           = 1;              {  move UP                             }
   MOVE_DOWN         = 2;              {  move DOWN                           }


{ ------ Constants  for 'LimitMode' and 'DestMode' in DoPEPosExt... commands  }

   LIMIT_ABSOLUTE    = 0;              { Limit is a absolute Position         }
   LIMIT_RELATIVE    = 1;              { Limit is a distance (relative)Position }
   LIMIT_NOT_ACTIVE  = 2;              { No Limit is active                   }

   DEST_APPROACH     = 0;              { Halt after reaching destination,     }
                                       { do not change control mode           }
   DEST_POSITION     = 1;              { Change control mode in time and      }
                                       { position to destination              }
   DEST_MAINTAIN     = 2;              { No change of control mode at destination }
                                       { but maintain destination in          }
                                       { moving control mode                  }


{ ------ Constants  for 'ModeFlags' in  DoPEStartCMD ------------------------ }

    CMD_DWND      = $01;               { supervise destination window         }
    CMD_MESSAGE   = $02;               { report intermediate destinations     }


{ ------ Constants  for 'Operation' in  DoPEEndCMD -------------------------- }

    CMD_DISCARD              = 0;      { Reject movement sequence             }
    CMD_START                = 1;      { Start movement sequence              }


{ ------ Constants  for Reaction in DoPECtrlError and DoPESft --------------- }

    REACT_STATUS             = 0;      { only status bits are set             }
    REACT_ACTION             = 1;      { React according to pre def. action   }


{ ------ Constants  for Limit Ctrl in DoPESenDef --------------------------- }

    REACT_STATE              = 0;      { only status bits are set             }
    REACT_DRIVE_OFF          = 1;      { turn off drive                       }
    REACT_SHALT              = 2;      { halt crosshead in position control   }


{ ------ Constants  for 'Mode' in DoPECosinePeakCtrl ------------------------ }

    COS_PCT_AUTO1            = 0;      { Pilot control with Start offset      }
    COS_PCT_AUTO2            = 1;      { Pilot control without Start offset   }
    COS_PCT_MANUAL           = 2;      { Manual pilot control                 }
    COS_PCT_KEEP             = 3;      { Stop pilot control, keep values      }
    COS_PCT_CONTINUE         = 4;      { Continue pilot control, use values   }
    COS_PCT_RESET            = 5;      { Reset pilot control, zero values     }


{ ------ Constants  for 'Mode' and 'Priority' in DoPEMc2Output -------------- }

    MC2OUT_MAX = 3;                      { Number of Mc2Output definition points}

    MC2OUT_MODE_OFF          = 0;        { Mc2Output disabled                   }
    MC2OUT_MODE_2POINTS      = 1;        { Mc2Output definition by 2 points     }
    MC2OUT_MODE_3POINTS      = 2;        { Mc2Output definition by 3 points     }

    MC2OUT_PRIORITY_HIGH     = 0;        { Output all channels every 20 ms      }
    MC2OUT_PRIORITY_LOW      = 1;        { Output one of the channel every 20 ms}
    MC2OUT_PRIORITY_BURST    = 2;        { Output every speed controller cycle  } 


{ ------ Constants for MachineNoIo in DoPEGeneralData ----------------------- }

    MACHINE_NO_IO_OFF        = 0;      { don't use IO  to select machine      }
    MACHINE_NO_IO_IN_OUT     = 1;      { use IO IN-OUT to select machine      }
    MACHINE_NO_IO_OUT        = 2;      { use IO OUT    to select machine      }
    MACHINE_NO_IO_IN         = 3;      { use IO IN     to select machine      }


{ ------ Constants  for Language in DoPEGeneralData ------------------------- }

    LANGUAGE_ENGLISH         = 0;
    LANGUAGE_GERMAN          = 1;
    LANGUAGE_USER1           = 2;
    LANGUAGE_USER2           = 3;

{ ------ Constants  for 'CtrlStructure' in DoPEMachineDef ------------------- }

   CTRL_STRUCTURE_SPINDLE    = 0;      { Digital position controller          }
                                       { for speed controlled drives          }
   CTRL_STRUCTURE_HYDRAULIC  = 1;      { Hydraulic                            }
   CTRL_STRUCTURE_OPENLOOP   = 3;      {  No control (only for CTRL_POS)      }
   CTRL_STRUCTURE_SPINDLE_SP = 6;      { Digital pos. and speed controller    }


{ ------ Constants  for shield in DoPEMachineDef ---------------------------- }

   SHIELD_SIMPLE      = 0;             { Protective shield without lock fnct. }
   SHIELD_SECURE      = 1;             { Protective shield with lock function }


{ ------ Constants  for Mode in DoPEOfflineAction... ------------------------ }

  DO_NOTHING          = 0;             { Don't modify this output             }
  USE_INIT_VALUE      = 1;             { Use Setup Initial value after offline}
  USE_VALUE           = 2;             { Use defined value after offline      }


{ ------ Constants  for Signal and frequency in DoPEOutChaDef --------------- }

   OUTSIGNAL_A_B             = 0;      { A/B                                  }
   OUTSIGNAL_PULSE_SIGN      = 1;      { pulse/sign                           }
   OUTSIGNAL_UP_DOWN         = 2;      { up/down                              }
   OUTSIGNAL_ANALOGUE        = 3;      { analogue (+/- 10V)                   }
   OUTSIGNAL_DC_MOTOR        = 4;      { PWM with dirction/amplitude signals  }
   OUTSIGNAL_DC_LINEAR_MOTOR = 5;      { PWM with single, variable duty-cycle signal }
   OUTSIGNAL_SIGN_MAGNITUDE  = 4;      { PWM with dirction/amplitude signals  }
   OUTSIGNAL_LOCKEDANTIPHASE = 5;      { PWM with single, variable duty-cycle signal}
   OUTSIGNAL_MAX             = 6;      { number of signals                    }

   OUTSIGNALFREQU4MHz    = 0;
   OUTSIGNALFREQU2MHz    = 1;
   OUTSIGNALFREQU1MHz    = 2;
   OUTSIGNALFREQU500kHz  = 3;
   OUTSIGNALFREQU250kHz  = 4;
   OUTSIGNALFREQU125kHz  = 5;
   OUTSIGNALFREQU60kHz   = 6;
   OUTSIGNALFREQU30kHz   = 7;
   OUTSIGNALFREQU15kHz   = 8;
   OUTSIGNALFREQU_MAX    = 9;

{ ------ Constants  for CurrentControllerGain in DoPEOutChaDef -------------- }

   OUTCURRCTRLGAINSET_0_009mH  = 0;    { 0.009 mH                             }
   OUTCURRCTRLGAINSET_0_018mH  = 1;    { 0.018 mH                             }
   OUTCURRCTRLGAINSET_0_037mH  = 2;    { 0.037 mH                             }
   OUTCURRCTRLGAINSET_0_073mH  = 3;    { 0.073 mH                             }
   OUTCURRCTRLGAINSET_0_15mH   = 4;    { 0.15  mH                             }
   OUTCURRCTRLGAINSET_0_29mH   = 5;    { 0.29  mH                             }
   OUTCURRCTRLGAINSET_0_59mH   = 6;    { 0.59  mH                             }
   OUTCURRCTRLGAINSET_1_2mH    = 7;    { 1.2   mH                             }
   OUTCURRCTRLGAINSET_2_3mH    = 8;    { 2.3   mH                             }
   OUTCURRCTRLGAINSET_4_7mH    = 9;    { 4.7   mH                             }
   OUTCURRCTRLGAINSET_9_4mH    = 10;   { 9.4   mH                             }
   OUTCURRCTRLGAINSET_19mH     = 11;   { 19    mH                             }
   OUTCURRCTRLGAINSET_38mH     = 12;   { 38    mH                             }
   OUTCURRCTRLGAINSET_75mH     = 13;   { 75    mH                             }
   OUTCURRCTRLGAINSET_150mH    = 14;   { 150   mH                             }
   OUTCURRCTRLGAINSET_300mH    = 15;   { 300   mH                             }
   OUTCURRCTRLGAINSET_MAX      = 16;   { number of sttings                    }

{ --------------- Constants  for commands from subsystem  ------------------- }


{ ------ Constants  for 'typ' in  SP_MKINFO --------------------------------- }

    MKTYP_ABSOLUT_MB = 0;              { Absol. measuring channel with build  }
                                       { in reference (standard ADC)          }
    MKTYP_ABSOLUT_OB = 1;              { Absolute measuring channel without   }
                                       { build in reference (encoders)        }
    MKTYP_INTGR      = 2;              { Integrating measuring channel        }
                                       { Doli standard AD-Converter           }

{ ------ Constants  for 'ErrorNumber' in message  COMMAND_ERROR ------------- }

   CMD_ERROR_NOERROR       = 0;        { No Error                             }
   CMD_ERROR_PARCORR       = 1001;     { Error in parameter (corrected)       }
   CMD_ERROR_PAR           = 1003;     { Error in parm. not correctable       }
   CMD_ERROR_XMOVE         = 1004;     { X-Head is not halted                 }
   CMD_ERROR_INITSEQ       = 1005;     { Sequence in init. not observed       }
   CMD_ERROR_NOTINIT       = 1006;     { Controller part not initialised      }
   CMD_ERROR_DIR           = 1007;     { Movement direction  not possible     }
   CMD_ERROR_TMP           = 1008;     { Required resource not available      }
   CMD_ERROR_RUNTIME       = 1009;     { Run time error active                }
   CMD_ERROR_INTERN        = 1010;     { Internal error in subsystem          }
   CMD_ERROR_MEM           = 1011;     { Insufficient memory                  }
   CMD_ERROR_CST           = 1012;     { Wrong controller Structure           }
   CMD_ERROR_NIM           = 1013;     { Command not implemented              }
   CMD_ERROR_MSGNO         = 2001;     { Unknown message number               }
   CMD_ERROR_VERSION       = 2003;     { Wrong PE interface version           }
   CMD_ERROR_OPEN          = 2004;     { Setup not opened                     }
   CMD_ERROR_MEMORY        = 2005;     { Not enough memory                    }


{ ------ Constants  for 'ErrorNumber' in message  RUNTIME_ERROR ------------- }

    RTE_EMOVE_END          = 104;      { Error at end of emergency movement   }
                                       { still active                         }
    RTE_CTRL_DEVIATION     = 105;      { Controller deviation error           }
                                       { Control channel see device           }

    RTE_DRIVE_OFF          = 201;      { Drive off or emergency off           }
    RTE_E_MOVE_RQ          = 202;      { emergency off, emergency drive requ. }
    RTE_UPPER_LIMIT_SWITCH = 203;      { Upper hard-limit switch active       }
    RTE_LOWER_LIMIT_SWITCH = 204;      { Lower hard-limit switch active       }
    RTE_STOP               = 205;      { Drive not ready                      }
    RTE_DF_KEY             = 206;      { Drive free withdrawn by key          }
    RTE_SHALT              = 207;      { Signal S-HALT activated              }

    RTE_UPPER_LIMIT        = 301;      { Upper range limit exceeded           }
    RTE_LOWER_LIMIT        = 302;      { Lower range limit exceeded           }

    RTE_ERROR_UNHANDLED    = 999;      { Unknown runtime error                }


{ ------ Constants  for 'MsgId' in  MOVE_CTRL_MSG --------------------------- }

    CMSG_POS         = 1;              { Destination reached                  }
    CMSG_UPPER_SFT   = 2;              { Upper softend reached                }
    CMSG_LOWER_SFT   = 3;              { Lower softend reached                }
    CMSG_POS_ERR     = 4;              { Destination window not reached       }
{                      5                 reserved                             }
    CMSG_TPOS        = 6;              { Trigger position reached             }
    CMSG_TPOS_ERR    = 7;              { Dest. window for Trigger not requ.   }
    CMSG_LPOS        = 8;              { Limit position reached               }
    CMSG_LPOS_ERR    = 9;              { Dest. window not reached (limit)     }
{                      48                reserved                             }
    CMSG_OFFSET      = 49;             { Offset correction finished           }
    CMSG_REF_END     = 50;             { Reference cycle successf. finished   }
    CMSG_CHECK       = 51;             { Channel supervision has triggered    }
    CMSG_CHECK_ERR   = 52;             { Channel supervision has triggered    }
                                       { but specified action was not started }
    CMSG_SHIELD      = 53;             { Protective shiels supervision has    }
                                       { triggered                            }
    CMSG_SHIELD_ERR  = 54;             { Protective Shield  supervision has   }
                                       { triggered but specified action was   }
                                       { not started                          }
    CMSG_REFSIGNAL   = 55;             { Reference Signal occured             }

    CMSG_IO_SHALT_UPPER = 56;          { Upper IO_SHalt Signal occured        }
    CMSG_IO_SHALT_LOWER = 57;          { Lower IO_SHalt Signal occured        }

{ ----- Constants  for 'InSignals' ------------------------------------------ }

   IN_SIG_DRIVE_OFF          = $0001;  { Drive off or emergency off           }
   IN_SIG_E_MOVE_RQ          = $0002;  { Emergency off,                       }
                                       { emergency movement required          }
   IN_SIG_UPPER_LIMIT_SWITCH = $0004;  { Upper hard-limit switch active       }
   IN_SIG_LOWER_LIMIT_SWITCH = $0008;  { Lower hard-limit switch active       }
   IN_SIG_NO_CTRL            = $0010;  { Drive not ready ( stop )             }
   IN_SIG_DF_KEY             = $0020;  { Drive free withdrawn by key          }
   IN_SIG_SHALT              = $0040;  { Signal S-HALT activated              }
   
   IN_SIG_REFERENCE          = $0080;  { X-Head reference switch              }
   IN_SIG_SH_CLOSED          = $0100;  { Shield closed                        }
   IN_SIG_SH_LOCKED          = $0200;  { Shield locked                        }
   IN_SIG_SH_INACTIVE        = $0400;  { Shield function inactive             }
   IN_SIG_IO_SHALT_UPPER     = $0800;  { IO-Signal SHaltUpper                 }
   IN_SIG_IO_SHALT_LOWER     = $1000;  { IO-Signal SHaltLower                 }
   IN_SIG_CPU_EMERGENCY_OFF  = $2000;  { Internal emergency off               }

{ ----- Constants  for 'OutSignals' ----------------------------------------- }

   O_SIG_DRIVE_ON      = $0001;        { Drive ON output                      }
   O_SIG_DRIVE_FREE    = $0002;        { Drive FREE output                    }
   O_SIG_BRAKE         = $0004;        { Brake output                         }
   O_SIG_E_MOVE        = $0008;        { Emergency movement output            }
   O_SIG_BYPASS        = $0010;        { Bypass output                        }
   
   O_SIG_LIMIT         = $0020;        { Load Limit for clamps reached        }
   O_SIG_SH_LOCK       = $0040;        { Lock shield                          }
   O_SIG_ON_RELAY      = $0080;        { ON Relay output                      }
   O_SIG_INTERNAL_DRIVE_ENABLE = $0200;
   O_SIG_READY_TO_MOVE = $0400;        { Controller ready for position command}
   O_SIG_EDC_READY     = $0800;        { EDC ready                            }
   O_SIG_DRIVE_OFF     = $1000;        { EDC Drive Off                        }

{ ----- Constants  for 'CtrlState1' ----------------------------------------- }

{ --------- 1. Hexnibble : Bit for control mode ----------------------------- }
   CTRL_STATE_POS    = $0001;          { X-Head control is active             }
   CTRL_STATE_LOAD   = $0002;          { Load control is active               }
   CTRL_STATE_EXT    = $0004;          { Extension control is active          }

{ --------- 2. Hexnibble : State  command generator and X-Head -------------- }
   CTRL_HALT        = $0010;           { Command generator not running        }
   CTRL_DOWN        = $0020;           { Movement DOWN                        }
   CTRL_UP          = $0040;           { Movement UP                          }
   CTRL_MOVE        = $0080;           { X-Head moves (not halted)            }

{ --------- 3. and 4. Hexnibble : State  movement control ------------------- }
   CTRL_READY       = $0100;           { Moving command will be accepted      }
   CTRL_FREE        = $0200;           { Waiting for free signal (PC or user) }
   CTRL_INIT_E      = $0400;           { Emergency movement has to be activ.  }
   CTRL_SFTSET      = $0800;           { Change of softends allowed           }

   CTRL_SYNCHWAIT   = $2000;           { Synch State: 1 = wait for Start      }
   CTRL_SLAVE       = $4000;           { Synch State: 0 = Master 1 = Slave    }
   CTRL_E_ACTIVE    = $8000;           { Emergency movement active            }



{ ----- Constants  for 'CtrlState2' ----------------------------------------- }

{ ---- Status bits in controller status word 2 ------------------------------ }
   CTRL_LOWER_SFT_S   = $0001;         {  Lower softend X-Head                }
   CTRL_LOWER_SFT_F   = $0002;         {  Lower softend load                  }
   CTRL_LOWER_SFT_E   = $0004;         {  Lower softend extension             }
   CTRL_UPPER_SFT_S   = $0010;         {  Upper softend X-Head                }
   CTRL_UPPER_SFT_F   = $0020;         {  Upper softend load                  }
   CTRL_UPPER_SFT_E   = $0040;         {  Upper softend extension             }

   CTRL_CYCLES_ACTIVE = $0400;         {  Cycle command active                }
                                       { (cosin, rectangle, triangle,         }
                                       {  cycles, dyn_cycles)                 }
   CTRL_HIGH_PRESSURE = $0800;         {  High pressure                       }
   CTRL_UPPER_LIMIT   = $4000;         {  Upper range limit X-Head            }
   CTRL_LOWER_LIMIT   = $2000;         {  Lower range limit X-Head            }
   CTRL_CALIBRATION   = $1000;         {  Calibrate analogue channels         }
   CTRL_ERROR         = $8000;         {  Deviation position controller       }


{ -------- Definitions of EDC Frontpanel LED's ------------------------------ }

   PE_LED_UP         =  $0001;         { Bit mask for LED 'UP'                }
   PE_LED_DOWN       =  $0002;         { Bit mask for LED 'DOWN'              }
   PE_LED_TEST       =  $0004;         { Bit mask for LED 'TEST'              }


{ -------- Definitions of EDC Frontpanel Key's (EDC5/25, EDC100/120)--------- }

{
  DoPE handling of EDC frontpanel keys:
       The EDC-frontpanel keys are decoded and transmitted in DoPE data record
       in three word's, One word represents the active state of the keys, one
       word all new keys and one word all gone keys.
       The "0"-"9", "F1" - "F3", "." and "±" keys are coded in the low byte
       in ASCII, The "Up", "Down", "Halt" and "DigiPoti" keys are represented
       as single bits in the upper byte.
}
   PE_KEY_NO            =  $0000;      { No key pressed                       }

   PE_KEY_HALT          =  $0100;      { Bit mask for Key 'HALT'              }
   PE_KEY_UP            =  $0200;      { Bit mask for Key 'UP'                }
   PE_KEY_DOWN          =  $0400;      { Bit mask for Key 'DOWN'              }
   PE_KEY_DPOTI         =  $0800;      { Bit mask for Key 'DigiPoti'          }

   PE_KEY_0             =  $0030;      { Code for Key '0'                     }
   PE_KEY_1             =  $0031;      { Code for Key '1'                     }
   PE_KEY_2             =  $0032;      { Code for Key '2'                     }
   PE_KEY_3             =  $0033;      { Code for Key '3'                     }
   PE_KEY_4             =  $0034;      { Code for Key '4'                     }
   PE_KEY_5             =  $0035;      { Code for Key '5'                     }
   PE_KEY_6             =  $0036;      { Code for Key '6'                     }
   PE_KEY_7             =  $0037;      { Code for Key '7'                     }
   PE_KEY_8             =  $0038;      { Code for Key '8'                     }
   PE_KEY_9             =  $0039;      { Code for Key '9'                     }
   PE_KEY_DP            =  $002E;      { Code for Key '.'                     }
   PE_KEY_SIGN          =  $00F1;      { Code for Key '±'                     }
   PE_KEY_F1            =  $0041;      { Code for Key 'F1'                    }
   PE_KEY_F2            =  $0042;      { Code for Key 'F2'                    }
   PE_KEY_F3            =  $0043;      { Code for Key 'F3'                    }


{ ---- Constants for SensorState in DoPESumSenInfo -------------------------- }

   SENSOR_STATE_NOTOK   =  $0000;      { Sensor state not OK                  }
   SENSOR_STATE_OK      =  $0001;      { Sensor state OK                      }
   SENSOR_STATE_ACTIVE  =  $0002;      { Sensor state active                  }
   SENSOR_STATE_INIT    =  $0004;      { Sensor state initialization ok       }


{ ---- Constants for ComState in DoPEState ---------------------------------- }

   COM_STATE_OFF        =  0;          { Link is disabled                     }
   COM_STATE_OFFLINE    =  1;          { Link is offline                      }
   COM_STATE_INITCYCLE  =  2;          { Link is initialising                 }
   COM_STATE_ONLINE     =  3;          { Link is established (OnLine)         }

{ ---- Constants for serial sensor definition init. value ------------------- }

{
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
}

   SERSEN_SIGN_P        = $0000;       { Serial sensor - sign positive        }
   SERSEN_SIGN_N        = $0001;       { Serial sensor - sign positive        }

   SERSEN_PORT_DEBUG    = $0000;       { Serial sensor - ComPort - Debug      }
   SERSEN_PORT_COM1     = $0002;       { Serial sensor - ComPort - 1          }
   SERSEN_PORT_COM2     = $0004;       { Serial sensor - ComPort - 2          }
   SERSEN_PORT_COM3     = $0006;       { Serial sensor - ComPort - 3          }

   SERSEN_STOPBIT_1     = $0000;       { Serial sensor - StopBit - 1          }
   SERSEN_STOPBIT_2     = $0010;       { Serial sensor - StopBit - 2          }

   SERSEN_110BAUD       = $0000;       { Serial sensor - BaudRate - 110       }
   SERSEN_150BAUD       = $0020;       { Serial sensor - BaudRate - 150       }
   SERSEN_300BAUD       = $0040;       { Serial sensor - BaudRate - 300       }
   SERSEN_600BAUD       = $0060;       { Serial sensor - BaudRate - 600       }
   SERSEN_1200BAUD      = $0080;       { Serial sensor - BaudRate - 1200      }
   SERSEN_2400BAUD      = $00A0;       { Serial sensor - BaudRate - 2400      }
   SERSEN_4800BAUD      = $00C0;       { Serial sensor - BaudRate - 4800      }
   SERSEN_9600BAUD      = $00E0;       { Serial sensor - BaudRate - 9600      }
   SERSEN_19200BAUD     = $0100;       { Serial sensor - BaudRate - 19200     }
   SERSEN_38400BAUD     = $0120;       { Serial sensor - BaudRate - 38400     }
   SERSEN_57600BAUD     = $0140;       { Serial sensor - BaudRate - 57600     }
   SERSEN_115200BAUD    = $0160;       { Serial sensor - BaudRate - 115200    }
   SERSEN_230400BAUD    = $0180;       { Serial sensor - BaudRate - 230400    }
   SERSEN_460800BAUD    = $01A0;       { Serial sensor - BaudRate - 460800    }
   SERSEN_921600BAUD    = $01C0;       { Serial sensor - BaudRate - 921600    }

   SERSEN_NOPROTOCOL       = $0000;    { Serial sensor - Protocol - No        }
   SERSEN_DOLIPROTOCOL     = $0200;    { Serial sensor - Protocol - DOLI      }
   SERSEN_EUROTHERM        = $0400;    { Serial sensor - Protocol - Eurotherm }
   SERSEN_GRADO            = $0600;    { Serial sensor - Protocol - Grado     }
   SERSEN_AI_808           = $0800;    { Serial sensor - Protocol - AI808     }
   SERSEN_MODBUS_EUROTHERM = $0A00;    { Serial sensor - Modbus - Eurotherm   }
   SERSEN_MODBUS_GRADO     = $0C00;    { Serial sensor - Modbus - Grado       }
   SERSEN_MODBUS_SHIMANDEN = $0E00;    { Serial sensor - Modbus - Shimanden   }
   SERSEN_MODBUS_AZBIL     = $1000;    { Serial sensor - Modbus - Azbil       }

   SERSEN_NOPARITY      = $0000;       { Serial sensor - Parity - No          }
   SERSEN_ODDPARITY     = $2000;       { Serial sensor - Parity - Odd         }
   SERSEN_EVENPARITY    = $4000;       { Serial sensor - Parity - Even        }

   SERSEN_7DATABIT      = $0000;       { Serial sensor - Databit - 7          }
   SERSEN_8DATABIT      = $8000;       { Serial sensor - Databit - 8          }



{ -------------------------------------------------------------------------- }

  PEINTERFACE_LEN    = 6;              { 'PE interface EDC VERSION' length    }
  APPLICATION_LEN    = 13;             { 'EDC appl. version'        length    }
  SUBSY_LEN          = 6;              { 'Subsystem version'        length    }
  SUBSYCUSTVER_LEN   = 6;              { 'Subsystem customer version' length  }
  SUBSYCUSTNAME_LEN  = 9;              { 'Subsystem customer name'  length    }
  BIOS_LEN           = 6;              { 'EDC BIOS version'         length    }
  HWCTRL_LEN         = 7;              { 'EDC controller hardware no' length  }
  PEINTERFACEPC_LEN  = 6;              { 'PE interface PC Version'  length    }
  DPXVER_LEN         = 6;              { 'DPX version'              length    }
  SERIALNUMBER_LEN   = 17;             { 'EDC serial number'        length    }
                                       { all including terminating zero '\0'  }

type                                   { Read version                         }
  DoPEVersion = record                 { ------------------------------------ }
    PeInterface   : array[0..5]  of char;
                                       { PE interface PE_VERSION    "xx.xx"   }
    Application   : array[0..12] of char;
                                       { EDC application version "xxxxxx.x"   }
    Subsy         : array[0..5]  of char;
                                       { Subsystem version          "xx.xx"   }
    SubsyCustVer  : array[0..5]  of char;
                                       { Subsystem customer version "xx.xx"   }
    SubsyCustName : array[0..8]  of char;
                                       { Subsystem customer name "xxxxxxxx"   }
    Bios          : array[0..5]  of char;
                                       { EDC BIOS version           "xx.xx"   }
    HwCtrl        : array[0..6]  of char;
                                       { EDC controller hardware no"xxxx.x"   }
                                       { Strings are zero terminated '\0'     }
    PeInterfacePC : array[0..5]  of char;
                                       { PE interface PC Version    "xx.xx"   }
    DpxVer        : array[0..5]  of char;
                                       { DPX version                "xx.xx"   }
                                       { Strings are zero terminated '\0'     }
    SerialNumber  : array[0..16] of char;
                                       { EDC serial number"xxxxxxxxxxxxxxxx"  }
                                       { Strings are zero terminated '\0'     }
  end;

type                                   { Read version                         }
  DoPEwVersion = record                { ------------------------------------ }
    PeInterface   : array[0..5]  of WideChar;
                                       { PE interface PE_VERSION    "xx.xx"   }
    Application   : array[0..12] of WideChar;
                                       { EDC application version "xxxxxx.x"   }
    Subsy         : array[0..5]  of WideChar;
                                       { Subsystem version          "xx.xx"   }
    SubsyCustVer  : array[0..5]  of WideChar;
                                       { Subsystem customer version "xx.xx"   }
    SubsyCustName : array[0..8]  of WideChar;
                                       { Subsystem customer name "xxxxxxxx"   }
    Bios          : array[0..5]  of WideChar;
                                       { EDC BIOS version           "xx.xx"   }
    HwCtrl        : array[0..6]  of WideChar;
                                       { EDC controller hardware no"xxxx.x"   }
                                       { Strings are zero terminated '\0'     }
    PeInterfacePC : array[0..5]  of WideChar;
                                       { PE interface PC Version    "xx.xx"   }
    DpxVer        : array[0..5]  of WideChar;
                                       { DPX version                "xx.xx"   }
                                       { Strings are zero terminated '\0'     }
    SerialNumber  : array[0..16] of WideChar;
                                       { EDC serial number"xxxxxxxxxxxxxxxx"  }
                                       { Strings are zero terminated '\0'     }
  end;

{ --------------------------------------------------------------------------- }

const
  MODINFO_NAME_LEN   = 80;             { maximum length of module name        }
                                       { ( including terminating zero '\0' )  }

type                                   { Definition of module info            }
  DoPEModuleInfo = record              { ------------------------------------ }
    ID         : DWord;                { Module hardware ID             [No]  }
    Revision   : DWord;                { Module hardware revision       [No]  }
    DeviceID   : DWord;                { Device ID                      [No]  }
    FunctionID : DWord;                { Function ID (from MachineDef)  [No]  }
    SerNr      : DWord;                { Serial number                  [No]  }
    Status     : DWord;                { Module status                  [No]  }
    Name : array[0..(MODINFO_NAME_LEN - 1)] of char;
                                       { Module name (e.g. "2INC 1742.000(-)")}
  end;

type                                   { Definition of module info            }
  DoPEwModuleInfo = record             { ------------------------------------ }
    ID         : DWord;                { Module hardware ID             [No]  }
    Revision   : DWord;                { Module hardware revision       [No]  }
    DeviceID   : DWord;                { Device ID                      [No]  }
    FunctionID : DWord;                { Function ID (from MachineDef)  [No]  }
    SerNr      : DWord;                { Serial number                  [No]  }
    Status     : DWord;                { Module status                  [No]  }
    Name : array[0..(MODINFO_NAME_LEN - 1)] of WideChar;
                                       { Module name (e.g. "2INC 1742.000(-)")}
  end;

{ --------------------------------------------------------------------------- }

const
    MAX_NOMV           = 4;            { maximum number of nom. voltages      }
    DRIVEINFO_NAME_LEN = 80;           { maximum length of drive name         }
                                       { (including terminating zero '\0')    }

type                                   { Definition of drive info             }
  DoPEDriveInfo = record               { ------------------------------------ }
    ID                     : DWord;    { Drive hardware ID             [No]  }
    Revision               : DWord;    { Drive hardware revision       [No]  }
    SerNr                  : DWord;    { Serial number                 [No]  }
    NominalCurrent         : Double;   { Nominal current               [A]   }
    MinCurrent             : Double;   { Minimum current               [A]   }
    MaxCurrent             : Double;   { Maximum current               [A]   }
    MaxCurrentTime         : Double;   { Maximum current time (I²t)    [s]   }
    NominalVoltageCount    : Integer;  { Number of nominal voltages    [No]  }
    NominalVoltage         : array[0..MAX_NOMV - 1] of Double;
                                       { Nominal voltage               [V]   }
    MaxPower               : Double;   { Maximum power                 [W]   }
    FeedbackPower          : Double;   { Average feedback power        [W]   }
    MinDither              : Double;   { Minimum dither frequency      [Hz]  }
    MaxDither              : Double;   { Maximum dither frequency      [Hz]  }
    CurrentControllerCycle : Double;   { Current controller cycle time [s]   }
                                       { (0 = analogue or not adjustable)    }
    Name : array[0..(DRIVEINFO_NAME_LEN - 1)] of char;
                                       { Drive name (e.g. "DC2500 1860.000(-)") }
  end;

type                                   { Definition of drive info             }
  DoPEwDriveInfo = record              { ------------------------------------ }
    ID                     : DWord;    { Drive hardware ID             [No]  }
    Revision               : DWord;    { Drive hardware revision       [No]  }
    SerNr                  : DWord;    { Serial number                 [No]  }
    NominalCurrent         : Double;   { Nominal current               [A]   }
    MinCurrent             : Double;   { Minimum current               [A]   }
    MaxCurrent             : Double;   { Maximum current               [A]   }
    MaxCurrentTime         : Double;   { Maximum current time (I²t)    [s]   }
    NominalVoltageCount    : Integer;  { Number of nominal voltages    [No]  }
    NominalVoltage         : array[0..MAX_NOMV - 1] of Double;
                                       { Nominal voltage               [V]   }
    MaxPower               : Double;   { Maximum power                 [W]   }
    FeedbackPower          : Double;   { Average feedback power        [W]   }
    MinDither              : Double;   { Minimum dither frequency      [Hz]  }
    MaxDither              : Double;   { Maximum dither frequency      [Hz]  }
    CurrentControllerCycle : Double;   { Current controller cycle time [s]   }
                                       { (0 = analogue or not adjustable)    }
    Name : array[0..(DRIVEINFO_NAME_LEN - 1)] of WideChar;
                                       { Drive name (e.g. "DC2500 1860.000(-)") }
  end;

{ --------------------------------------------------------------------------- }

const
    LANGINFO_NAME_LEN = 30;            { maximum length of language name      }
                                       { (including terminating zero '\0')    }

type                                   { Definition of language info          }
  DoPEwLanguageInfo = record           { ------------------------------------ }
    Name0 : array[0..(LANGINFO_NAME_LEN - 1)] of WideChar;
    Name1 : array[0..(LANGINFO_NAME_LEN - 1)] of WideChar;
    Name2 : array[0..(LANGINFO_NAME_LEN - 1)] of WideChar;
    Name3 : array[0..(LANGINFO_NAME_LEN - 1)] of WideChar;
  end;

{ --------------------------------------------------------------------------- }

const                                  { Machine IO signal bits               }
                                       { ------------------------------------ }
   IO_SIGNAL_IN_MACHINE1   = $0001;
   IO_SIGNAL_IN_MACHINE2   = $0002;
   IO_SIGNAL_IN_MACHINE3   = $0004;
   IO_SIGNAL_IN_MACHINE4   = $0008;
   IO_SIGNAL_IN_MACHINE5   = $0010;
   IO_SIGNAL_IN_MACHINE6   = $0020;
   IO_SIGNAL_IN_MACHINE7   = $0040;
   IO_SIGNAL_IN_MACHINE8   = $0080;

   IO_SIGNAL_OUT_MACHINE1  = $0001;
   IO_SIGNAL_OUT_MACHINE2  = $0002;
   IO_SIGNAL_OUT_MACHINE3  = $0004;
   IO_SIGNAL_OUT_MACHINE4  = $0008;
   IO_SIGNAL_OUT_MACHINE5  = $0010;
   IO_SIGNAL_OUT_MACHINE6  = $0020;
   IO_SIGNAL_OUT_MACHINE7  = $0040;
   IO_SIGNAL_OUT_MACHINE8  = $0080;

   IO_SIGNAL_IN_MACHINE_MASK  = $00FF;
   IO_SIGNAL_OUT_MACHINE_MASK = $00FF;

{ --------------------------------------------------------------------------- }

const                                  { Sync option                          }
                                       { ------------------------------------ }
    SYNC_OPTION_DISABLED = 0;          { Sync option is disabled              }
    SYNC_OPTION_MASTER   = 1;          { Sync option is present (master EDC)  }
    SYNC_OPTION_SLAVE    = 2;          { Sync option is present (slave  EDC)  }


{ --------------------------------------------------------------------------- }

type                                   { General data                         }
  DoPEGeneralData = record             { ------------------------------------ }
     MachineNo               : word;   { Number of active machines      [No]  }
     MachineNoIo             : word;   { Use IO's to select machine    [1/0]  }
                                       { number (only EDC100)                 }
     Supervisor              : word;   { Supervisor mode                [No]  }
     SuperPassword           : word;   { Supervisor Password(0=inactive)[No]  }
     UserPassword            : word;   { User       Password(0=inactive)[No]  }
     Logo                    : word;   { DOLI Logo (0 = inactive)       [No]  }
     nRmc                    : DWord;  { Required number of RMC's       [No]  }
     Language                : DWord;  { Language                       [No]  }
     FunctionID              : DWord;  { User defined function ID       [No]  }
     SyncOption              : Word;   { Sync option (SYNC_OPTION_xxx)  [No]  } //EDC220+
     MachineNoIoBitConnector : word;   { BitIn/BitOut connector         [No]  } //EDC220+
     MachineNoIoBitNo        : word;   { First bit of block          [0..15]  } //EDC220+
  end;

{ --------------------------------------------------------------------------- }

type                                   { Sensor definition data               }
  DoPESenDef = record                  { ------------------------------------ }
   Connector     : word;               { Connector number of sensor     [No]  }
   Sign          : word;               { Invert sign of sensor         [1/0]  }
   CtrlChannel   : word;               { Active control channel        [1/0]  }
   LimitCtrl     : word;               { Stop if limit exceeded        [1/0]  }
   ConnectedCtrl : word;               { Stop if disconnected          [1/0]  }
   UseEeprom     : word;               { Use Eeprom                    [1/0]  }
                                       { Only for analogue sensors:           }
   Integr        : Double;             { Time of integration             [s]  }
                                       { Only for sensors without EEPROM:     }
   Init          : word;               { Sensor init                    [No]  }
   NominalValue  : Double;             { Nominal value of sensor      [Unit]  }
   U             : word;               { Unit of sensor UNIT_xxx        [No]  }
   Offset        : Double;             { Offset of sensor             [Unit]  }
   UpperLimit    : Double;             { Upper range limit of sensor     [%]  }
   LowerLimit    : Double;             { Lower range limit of sensor     [%]  }
                                       { Only for incremental sensors:        }
   Scale         : Double;             { Scale of sensor    [inc/revolution]  }
                                       {                     or [Unit/inc]    }
   Correction    : Double;             { Correction value of sensor           }
 end;

{ --------------------------------------------------------------------------- }

type                                   { Control Sensor definition data       }
  DoPECtrlSenDef = record              { ------------------------------------ }
   Acceleration  : Double;             { Nominal acceleration      [Unit/s²]  }
   Speed         : Double;             { Nominal speed             [Unit/s]   }
   UnUsed1       : Double;             { Unused                               }
   UnUsed2       : Double;             { Unused                               }
   Deviation     : Double;             { Max. deviation of controller [Unit]  }
   DevReaction   : word;               { Reaction if deviation exceeded [No]  }
   PosP          : DWord;              { Pos.  contr. P: gain           [No]  }
   PosI          : word;               { Pos.  contr. I: time constant  [No]  }
   PosD          : word;               { Pos.  contr. D: time constant  [No]  }
   PosFFP        : DWord;              { Pos.  generator D              [No]  }
   SpeedP        : DWord;              { Speed contr. P: gain           [No]  }
   SpeedI        : word;               { Speed contr. I: time constant  [No]  }
   SpeedD        : word;               { Speed contr. D: time constant  [No]  }
   UnUsed3       : DWord;              { Unused                               }
   UnUsed4       : DWord;              { Unused                               }
                                       { Only for analogue sensors:           }
   Integr        : Double;             { Time of integration for control.[s]  }
   SpeedFFP      : word;               { Speed feed forward             [No]  }
   PosDelay      : word;               { Delay for Command              [No]  }
   AccFFP        : word;               { Acceleration contr. P: gain    [No]  }
   SpeedDelay    : word;               { Delay for SpeedCommand         [No]  }
 end;

{ --------------------------------------------------------------------------- }

type                                   { Measured channel to analogue output  }
  DoPEMc2OutputDef = record            { ----------------------------------   }
    Mode           : word;             { MC2OUT_MODE_...                [No]  }
    SensorNo       : word;             { Sensor number               [0..15]  }
    SensorPoint    : array[0..(MC2OUT_MAX-1)] of Double; { Sensor Point Values[Unit] }
    OutputPoint    : array[0..(MC2OUT_MAX-1)] of Double; { Output Point Values   [%] }
 end;

type                                   { Definition of Output channel         }
  DoPEOutChaDef = record               { ------------------------------------ }
    Connector       : word;            { Connector number of channel    [No]  }
    Sign            : word;            { Invert sign of channel        [1/0]  }
    MaxValue        : Double;          { Maximum output value           [No]  }
    MinValue        : Double;          { Minimum output value           [No]  }
    InitValue       : Double;          { Initial output value           [No]  }
                                       { Only if adjustable (DDAxx):          }
    PaVoltage       : Double;          { Max. voltage of power amplifier [V]  }
    PaCurrent       : Double;          { Max. current of power amplifier [A]  }
    MaxCurrTime     : Double;          { Max. time for max. current (I²t)[s]  }
    DitherFrequency : Double;          { Dither frequency               [Hz]  }
    DitherAmplitude : Double;          { Dither amplitude                [%]  }
    CurrentControllerGain : word;      { Current controller gain set    [No]  }
    Signal          : word;            { Digital command output signal  [No]  }
    SignalFrequency : word;            { Digital command output signal  [No]  }
    UnUsed1         : word;            { Unused                               }
    UnUsed2         : word;            { Unused                               }
    Offset          : Double;          { Offset of channel               [%]  }
    CurrentP        : DWord;           { current.contr. P: gain         [No]  }
    CurrentI        : word;            { current.contr. P: time constant[No]  }
    CurrentD        : word;            { current.contr. P: time constant[No]  }
    Mc2Output       : DoPEMc2OutputDef;{ Measured channel to analogue output  }
end;

{ --------------------------------------------------------------------------- }

type                                   { Definition of Bit output             }
  DoPEBitOutDef = record               { ------------------------------------ }
    Connector  : word;                 { Connector number of device     [No]  }
    InitValue  : word;                 { Initial value of device        [No]  }
  end;

{ --------------------------------------------------------------------------- }

type                                   { Definition of Bit input              }
  DoPEBitInDef = record                { ------------------------------------ }
    Connector  : word;                 { Connector number of device     [No]  }
    StopMask   : word;                 { Set bits stop the machine      [No]  }
    StopLevel  : word;                 { Active level mask of StopMask  [No]  }
  end;

{ --------------------------------------------------------------------------- }

const

  LIMIT_SWITCH_TYPE_SINGLE      = 0;   { One limit switch present             }
  LIMIT_SWITCH_TYPE_UPPER_LOWER = 1;   { Two limit switches present           }

  XHEAD_INITIAL_MODE_AUTOMATIC  = 0;   { Set XHead to last known position     }
  XHEAD_INITIAL_MODE_MANUAL     = 1;   { Set XHead to manual position         }

  X4PIN14_MODE_BYPASS           = 0;   { X4 Pin14 mode bypass                 }
  X4PIN14_MODE_EDC_READY        = 1;   { X4 Pin14 mode EDC ready              }

type                                   { Definition of Machine data           }
  DoPEMachineDef = record              { ------------------------------------ }
    SpeedCtrlTime    : Double;         { Speed controller cycle time     [s]  }
                                       {                    [0.2ms .. 2.5ms]  }
    PosCtrlTime      : Double;         { Position controller cycle time  [s]  }
    CtrlStructure    : word;           { Closed loop control structure  [No]  }
    DataTransmissionRate : Double;     { Data transmission rate          [s]  }
    Mode             : word;           { Data acquisition or control    [1/0] }
    UnUsed3          : word;           { Unused                               }
    XheadDir         : word;           { Machine moves up/down         [1/0]  }
                                       { with positive output signal          }
    UnUsed4          : Double;         { Unused                               }
    EncXheadRatio    : Double;         { Transmis. ration encoder-Xhead [No]  }
    BreakOpen        : Double;         { Delay time to open break after  [s]  }
                                       { closed loop control is active        }
    BreakClose       : Double;         { Delay time to close break before[s]  }
                                       { closed loop control is deactivated   }
    PistonArea       : Double;         { Area of piston for hydraulic   [mý]  }
    LoadMax          : Double;         { Max. load capacity of machine   [N]  }
    Load100          : Double;         { Nominal load of machine         [N]  }
    Stiffness        : Double;         { Over all stiffness of machine [N/m]  }
    UnUsed1          : word;           {                                      }
    UnUsed2          : word;           {                                      }
    GripConnector    : word;           { Grip : connector number        [No]  }
    GripChannel      : word;           { Grip : channel                 [No]  }
    GripActive       : word;           { Grip : active Low/High         [No]  }
    ShieldConnector  : word;           { Shield: connector number       [No]  }
    ShieldType       : word;           { Shield: type simple/locked     [No]  }
    ShieldTimeout    : Double;         { Shield: timeout                 [s]  }
    CtrlOnMode       : word;           { CTRL ON mode: 0=NoCtrl, 1=Ctrl       }
    FixValue         : Double;         { Fixing  output value            [%]  }
    InitValue        : Double;         { Initial output value            [%]  }
    ReturnValue      : Double;         { Return  output value            [%]  }
    ShieldUprLock    : Double;         { Shield: max. load limit      [Unit]  }
    ShieldLwrLock    : Double;         { Shield: min. load limit      [Unit]  }
    ShieldSpeedLimit : Double;         { Shield: max. speed if open [Unit/s]  }
    LimitSwitchType  : word;           { LIMIT_SWITCH_TYPE_xxx          [No]  }
    XheadInitialMode : word;           { XHEAD_INITIAL_MODE_xxx         [No]  }
    XheadInitialValue : Double;        { Initial XHead value (manual) [Unit]  }
    X4Pin14Mode      : word;           { X4PIN14_MODE_xxx               [No]  }
  end;

{ --------------------------------------------------------------------------- }

const
  LIN_DATA_MAX = 10;                   { Max. numbers of lin. points          }

type                                   { Definition of Linearisation table -- }
  DoPELinTblFalse = record             { ------------------------------------ }
    LinNo        : word;               { Number of points for mode lin. [No]  }
    FalseValue   : array[0..LIN_DATA_MAX-1] of Double;
                                       { Measured value by the EDC       [N]  }
  end;

type                                   { Definition of Linearisation table -- }
  DoPELinTblTrue = record              { ------------------------------------ }
    LinNo        : word;               { Number of points for mode lin. [No]  }
    TrueValue    : array[0..LIN_DATA_MAX-1] of Double;
                                       { True value measured by the the  [N]  }
                                       { reference system                     }
  end;

{ --------------------------------------------------------------------------- }

const
   { Grip modes }
   IO_GRIP_MODE_0_OFF                = 0;  { grip disabled                                            }
   IO_GRIP_MODE_1_TANSPARENT         = 1;  { digital outputs are set according to grip keys           }
                                           { grip leds are set according to digital inputs            }
   IO_GRIP_MODE_2_LIMIT_CTRL         = 2;  { only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active            }
   IO_GRIP_MODE_3_LIMIT_CTRL_INVERTED= 3;  { only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active (inverted) }

   { Grip IO signal bits }
   IO_SIGNAL_IN_GRIP_CONNECTED       =  $0001;
   IO_SIGNAL_IN_GRIP_UPPER_OPENED    =  $0002;
   IO_SIGNAL_IN_GRIP_LOWER_OPENED    =  $0004;
   IO_SIGNAL_IN_GRIP_UPPER_CLOSED    =  $0008;
   IO_SIGNAL_IN_GRIP_LOWER_CLOSED    =  $0010;
   IO_SIGNAL_IN_GRIP_HIGH_PRESSURE   =  $0020;

   IO_SIGNAL_OUT_GRIP_OPEN_ENABLE    =  $0001;
   IO_SIGNAL_OUT_GRIP_UPPER_OPEN     =  $0002;
   IO_SIGNAL_OUT_GRIP_LOWER_OPEN     =  $0004;
   IO_SIGNAL_OUT_GRIP_UPPER_CLOSE    =  $0008;
   IO_SIGNAL_OUT_GRIP_LOWER_CLOSE    =  $0010;
   IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE1 =  $0020;
   IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE2 =  $0040;
   IO_SIGNAL_OUT_GRIP_HYDRAULIC_ON   =  $0080;

   IO_SIGNAL_IN_GRIP_MASK            =  $003F;
   IO_SIGNAL_OUT_GRIP_MASK           =  $00FF;

type                                   { Grip IO signal definition            }
  DoPEIOGrip = record                  { ------------------------------------ }
    Mode                    : word;    { Mode (0=disabled)               [No] }
    BitDevice               : word;    { BitIn/BitOut device          [0...9] }
    BitNo                   : word;    { First bit of block           [0..15] }

    LimitSensorNo           : word;    { Limit sensor number             [No] }
    LimitMax                : Double;  { Limit Max                     [Unit] }
    LimitMin                : Double;  { Limit Max                     [Unit] }

    FConstEnabled           : word;    { Load constant when closing     [0/1] }
    CloseSecurityTime       : Double;  { Security time for closing        [s] }
    OutGripHydraulicOnTime  : Double;  { Time for OutGripHydraulicOn      [s] }
    OutGripHighPressureTime : Double;  {  Time for OutGripHighPressure    [s] }
    InGripOpenedTime        : Double;  { Time for InGripOpened            [s] }
    InGripClosedTime        : Double;  { Time for InGripClosed            [s] }

    PressureOutputEnabled   : word;    { Pressure output enabled        [0/1] }
    OutChaNo                : word;    { Analog output for pressure   [0..15] }
    Unused1                 : Double;  { Unused                              }
    OutChaLowPressure       : Double;  { Low  Pressure value             [Pa] }
    OutChaHighPressure      : Double;  { High Pressure value             [Pa] }
    OutChaRampTime          : Double;  { Time for low/high pressure ramp  [s] }
    OutChaFCtrlEnabled      : word;    { Load control enabled           [0/1] }
    OutChaFCtrlHighPressure : Double;  { Load at high pressure            [N] }
  end;

{ --------------------------------------------------------------------------- }

const                                
   { Extensometer IO signal definition }
   IO_SIGNAL_IN_EXT_UPPER_OPENED  = $0001;
   IO_SIGNAL_IN_EXT_LOWER_OPENED  = $0002;
   IO_SIGNAL_IN_EXT_UPPER_CLOSED  = $0004;
   IO_SIGNAL_IN_EXT_LOWER_CLOSED  = $0008;

   IO_SIGNAL_OUT_EXT_UPPER_OPEN   = $0001;
   IO_SIGNAL_OUT_EXT_LOWER_OPEN   = $0002;
   IO_SIGNAL_OUT_EXT_UPPER_CLOSE  = $0004;
   IO_SIGNAL_OUT_EXT_LOWER_CLOSE  = $0008;

   IO_SIGNAL_IN_EXT_MASK          = $000F;
   IO_SIGNAL_OUT_EXT_MASK         = $000F;

type                                   { Extensometer IO signal definition    }
  DoPEIOExt = record                   { ------------------------------------ }
    Mode       : word;                 { Mode (0=disabled)               [No] }
    BitDevice  : word;                 { BitIn/BitOut device          [0...9] }
    BitNo      : word;                 { First bit of block           [0..15] }
    IOTime     : Double;               { Time for BitIn/BitOut control    [s] }
  end;

{ --------------------------------------------------------------------------- }

const
   { FixedXHead IO signal definition }
   IO_SIGNAL_IN_FIXED_XHEAD_UNLOCKED  = $0001;

   IO_SIGNAL_OUT_FIXED_XHEAD_UNLOCK   = $0001;
   IO_SIGNAL_OUT_FIXED_XHEAD_UP       = $0002;
   IO_SIGNAL_OUT_FIXED_XHEAD_DOWN     = $0004;

   IO_SIGNAL_IN_FIXED_XHEAD_MASK      = $0001;
   IO_SIGNAL_OUT_FIXED_XHEAD_MASK     = $0007;

type                                   { FixedXHead IO signal definition      }
  DoPEIOFixedXHead = record            { ------------------------------------ }
    Mode      : word;                  { Mode (0=disabled)               [No] }
    BitDevice : word;                  { BitIn/BitOut device          [0...9] }
    BitNo     : word;                  { First bit of block           [0..15] }
    IOTime    : Double;                { Time for BitIn/BitOut control    [s] }
  end;

{ --------------------------------------------------------------------------- }

const
   { High pressure IO signal definition }
   IO_SIGNAL_IN_HIGH_PRESSURE         = $0001;
   IO_SIGNAL_IN_HIGH_PRESSURE_OK      = $0002;
   IO_SIGNAL_IN_LOW_PRESSURE          = $0004;

   IO_SIGNAL_OUT_HIGH_PRESSURE        = $0001;
   IO_SIGNAL_OUT_HIGH_PRESSURE_OK     = $0002;
   IO_SIGNAL_OUT_LOW_PRESSURE         = $0004;
   IO_SIGNAL_OUT_LOW_PRESSURE_OK      = $0008;

   IO_SIGNAL_IN_HIGH_PRESSURE_MASK    = $0007;
   IO_SIGNAL_OUT_HIGH_PRESSURE_MASK   = $000F;

type                                  { High pressure IO signal definition    }
  DoPEIOHighPressure = record         { ------------------------------------- }
    Mode                  : word;     { Mode (0=disabled)                [No] }
    BitDevice             : word;     { BitIn/BitOut device           [0...9] }
    BitNo                 : word;     { First bit of block            [0..15] }
    IOTime                : Double;   { Time for BitIn/BitOut control     [s] }
    PressureOutputEnabled : word;     { Pressure output enabled        [0/1]  }
    OutChaNo              : word;     { Analog output for pressure   [0..15]  }
    OutChaLowPressure     : Double;   { Low  Pressure value              [%]  }
    OutChaHighPressure    : Double;   { High Pressure value              [%]  }
    OutChaRampTime        : Double;   { Time for low/high pressure ramp  [s]  }
  end;

{ --------------------------------------------------------------------------- }

const
   { Miscellaneous IO signal definition }
   IO_SIGNAL_IN_MISC_TEMPERATURE1     = $0001;  { warning       }
   IO_SIGNAL_IN_MISC_TEMPERATURE2     = $0002;  { emergency off }
   IO_SIGNAL_IN_MISC_OIL_LEVEL        = $0004;  { emergency off }
   IO_SIGNAL_IN_MISC_OIL_FILTER       = $0008;  { warning       }
   IO_SIGNAL_IN_MISC_POWER_FAIL       = $0010;  { emergency off }

   IO_SIGNAL_OUT_MISC_CAL             = $0001;
   IO_SIGNAL_OUT_MISC_NO_SENSOR_LIMIT = $0002;

   IO_SIGNAL_IN_MISC_MASK             = $001F;
   IO_SIGNAL_OUT_MISC_MASK            = $0003;

type                                   { Miscellaneous IO signal definition   }
  DoPEIOMisc = record                  { ------------------------------------ }
    BitInMode    : word;               { BitIn  mode   (0=disabled)      [No] }
    BitInDevice  : word;               { BitIn  device                [0...9] }
    BitInNo      : word;               { BitIn  number (first of bl.) [0..15] }

    BitOutMode   : word;               { BitOut mode   (0=disabled)      [No] }
    BitOutDevice : word;               { BitOut device                [0...9] }
    BitOutNo     : word;               { BitOut number (first of bl.) [0..15] }
  end;

{ --------------------------------------------------------------------------- }

const
   { SHALT IO signal modes }
   IO_SHALT_MODE_0_OFF                = 0;  { SHalt IO signal disabled              }
   IO_SHALT_MODE_1_ENABLED            = 1;  { SHalt IO signal enabled (active high) }
   IO_SHALT_MODE_2_ENABLED_INVERTED   = 2;  { SHalt IO signal enabled (active low ) }

   { SHALT IO signal definition }
   IO_SIGNAL_IN_SHALT_UPPER           = $0001;
   IO_SIGNAL_IN_SHALT_LOWER           = $0002;

   IO_SIGNAL_IN_SHALT_MASK            = $0003;
                                            
type                                   { SHalt IO signal definition           }
  DoPEIOSHalt = record                 { ------------------------------------ }
    Mode         : word;               { Mode (0=disabled)              [No]  }
    BitDevice    : word;               { BitIn/BitOut device         [0...9]  }
    BitNo        : word;               { First bit of block          [0..15]  }
  end;

{ --------------------------------------------------------------------------- }

type                                   { IO signal definition                 }
  DoPEIOSignals = record               { ------------------------------------ }
    Grip         : DoPEIOGrip;         { Grip                IO signal def.   }
    Ext          : DoPEIOExt;          { Extensometer        IO signal def.   }
    FixedXHead   : DoPEIOFixedXHead;   { FixedXHead          IO signal def.   }
    HighPressure : DoPEIOHighPressure; { High pressure       IO signal def.   }
    Reserved     : array[0..27] of char; { reserved (was DoPEIOKey/DoPEIOTest)}
    Misc         : DoPEIOMisc;         { Miscellaneous       IO signal def.   }
    SHalt        : DoPEIOSHalt;        { SHalt IO signal definition           }
  end;

{ --------------------------------------------------------------------------- }

const
  MAX_MAIN_MENU  = 40;                 { max count of EDC main menu entries   }

                                             { Test numbers of EDC main menu  }
                                             { ------------------------------ }
  TEST_NO_PC_CONTROL              = 10000;   { 10000 no licence needed        }
  TEST_NO_TENSION_COMPRESSION     = 10001;   { 10001 no licence needed        }
  TEST_NO_TEAR                    = 10002;   { 10002 no licence needed        }
  TEST_NO_METAL_TENSION           = 10003;   { 10003 no licence needed        }
  TEST_NO_CONCRETE_PRESSURE       = 10004;   { 10004 no licence needed        }
  TEST_NO_CONCRETE_BENDING        = 10005;   { 10005 no licence needed        }
  TEST_NO_CONCRETE_BRASILIAN      = 10006;   { 10006 no licence needed        }
  TEST_NO_CONCRETE_CIRCEL_BENDING = 10007;   { 10007 no licence needed        }
  TEST_NO_CYCLES                  = 10008;   { 10008    licence needed        }
  TEST_NO_EXTERNAL_COMMAND        = 10009;   { 10009    licence needed        }
  TEST_NO_CREEP                   = 10010;   { 10010    licence needed        }
  TEST_NO_BLOCK_COMMAND           = 10011;   { 10011    licence needed        }
  TEST_NO_ADJUSTING               = 10012;   { 10012 no licence needed        }
  TEST_NO_CALIBRATION             = 10013;   { 10013 no licence needed        }
  TEST_NO_CLOSED_LOOP_SETUP       = 10014;   { 10014 no licence needed        }
  TEST_NO_DRIVE_SETUP             = 10015;   { 10015 no licence needed        }
  TEST_NO_PROTOCOL_SETUP          = 10016;   { 10016 no licence needed        }
  TEST_NO_USER_SETUP              = 10017;   { 10017 no licence needed        }

  TEST_NO_MAX                     = 10018;

type                                   { EDC main menu definition             }
  DoPEMainMenu = record                { ------------------------------------ }
    TestNo  : Longint;                 { Test number                    [No]  }
    Visible : word;                    { Main menu entry visible       [0/1]  }
  end;
  type
    MenuTable = array of DoPEMainMenu;

{ --------------------------------------------------------------------------- }

const
   RMCIO_KEY_MAX  = 16;

type                                   { RMCIO key definition                 }
  DoPERmcIOKey = record                { ------------------------------------ }
    KeyCode      : Integer;            { Key code DoPE_KEY_xxx          [No]  }
    Device       : word;               { BitIn/BitOut device         [0...9]  }
    KeyMask      : word;               { Bit mask for key               [No]  }
    LedMask      : word;               { Bit mask for LED               [No]  }
  end;

type                                   { RMC DigiPoti definition              }
  DoPERmcDPoti = record                { ------------------------------------ }
    SpeedSlow      : Double;           { Slow speed                  [Unit/s] }
    SpeedFast      : Double;           { Fast speed                  [Unit/s] }
    DPotiSpeedSens : Double;           { Sensitivity Speed/Openloop [Rev/Nom] }
    DPotiPosSens   : Double;           { Sensitivity Pos           [Unit/Rev] }
  end;

type                                   { RMC definition                       }
  DoPERmcDef = record                  { ------------------------------------ }
    PushMode : word;                   { Push mode for Up/Down keys    [0/1]  }
    RmcDPoti : array[0..MAX_CTRL-1]      of DoPERmcDPoti;
    RmcIOKey : array[0..RMCIO_KEY_MAX-1] of DoPERmcIOKey;
  end;

{ --------------------------------------------------------------------------- }

type                                   { EDC Setup data                       }
  DoPESetup = record                   { ------------------------------------ }
   SDef         : array[0..MAX_MC-1]   of DoPESenDef;
   CSDef        : array[0..MAX_CTRL-1] of DoPECtrlSenDef;
   CSDefHigh    : array[0..MAX_CTRL-1] of DoPECtrlSenDef;
   ODef         : array[0..MAX_OC-1]   of DoPEOutChaDef;
   BODef        : array[0..MAX_BOUT-1] of DoPEBitOutDef;
   BIDef        : array[0..MAX_BIN-1]  of DoPEBitInDef;
   MDef         : DoPEMachineDef;
   LinTblFalse  : DoPELinTblFalse;
   LinTblTrue   : DoPELinTblTrue;
   IOSignals    : DoPEIOSignals;
   MainMenu     : array[0..MAX_MAIN_MENU-1] of DoPEMainMenu;
   RmcDef       : DoPERmcDef;
  end;

{ --------------------------------------------------------------------------- }

type                                   { Summary Sensor Information           }                     
  DoPESumSenInfo = record              { ------------------------------------ }
    Connector          : word;         { Connector number of sensor     [No]  }
    NominalValue       : Double;       { Nominal value of sensor      [Unit]  }
    U                  : word;         { Unit of sensor UNIT_xxx        [No]  }
    Offset             : Double;       { Offset of sensor             [Unit]  }
    UpperLimit         : Double;       { Upper range limit of sensor  [Unit]  }
    LowerLimit         : Double;       { Lower range limit of sensor  [Unit]  }
    SensorState        : word;         { Sensor state SEN_STATE_xxx     [No]  }
    McType             : word;         { Measuring channel type         [No]  }
    UpperSoftLimit     : Double;       { Upper soft limit               [No]  }
    LowerSoftLimit     : Double;       { Lower soft limit               [No]  }
    SoftLimitReaction  : word;         { reaction if soft limit         [No]  }
    BasicTare          : Double;       { Basic   tare                   [No]  }
    Tare               : Double;       { Tare                         [Unit]  }
    UserScale          : Double;       { User scale                     [No]  }
    McIntegr           : Double;       { Measuring channel time of integration   [s]}
    CtrlIntegr         : Double;       { Closed loop control time of integration [s]}
    HwDelayTime        : Double;       { Hardware delaytime              [s]  }
    McDelayTime        : Double;       { Measuring channel delaytime     [s]  }
    McDelayTimeCorr    : Double;       { Delaytime correction            [s]  }
  end;

{ --------------------------------------------------------------------------- }

const                                  { Sensor classes                       }
                                       { ------------------------------------ }
   SEN_UNDEF     = 0;                  { unknown sensor class                 }
   SEN_ANALOGUE  = 1;                  { analogue sensor                      }
   SEN_INC       = 2;                  { incremental sensor                   }
   SEN_ABS       = 3;                  { abolute value sensor                 }

                                       { Analogue sensor types                }
                                       { ------------------------------------ }
   SIG_STRAINGAUGE = 0;                { Strain Gauge                         }
   SIG_LVDT      = 1;                  { LVDT                                 }
   SIG_DC        = 2;                  { DC                                   }

                                       { Incremental sensor types             }
                                       { ------------------------------------ }
   SIG_TTL       = 0;                  { TTL Signal                           }
   SIG_LINE      = 1;                  { RS422 (line driver)                  }
   SIG_SINE11uA  = 2;                  { Sine 11µA                            }
   SIG_SINE1V    = 3;                  { Sine 1V                              }

                                       { Absolute value sensor types          }
                                       { ------------------------------------ }
   SIG_ROQ_424         = 1;            { Heidenhain ROQ 424 Sensor            }
   SIG_MTS_SSI_S2Bx102 = 2;            { MTS SSI S2Bx102 Sensor               }
   SIG_POSITAL_SL_G_24 = 3;            { POSITAL OCD-SL00G-1212 Sensor        }
   SIG_POSITAL_SL_G_16 = 4;            { POSITAL OCD-SL00G-0016 Sensor        }
   SIG_ROQ_425         = 5;            { Heidenhain ROQ 424 Sensor            }
   SIG_SSI_GENERIC     = $80;          { 'Generic sensor definition' mask     }
     SIG_SSI_CODE      = $40;          { Code bit 0=binary, 1=gray code       }
     SIG_SSI_LEN       = $1F;          { 'number of databits' mask            }
     SIG_SSI_LEN_OFFS  = 8;            { Offset for 'number of databits'      }


                                       { Transducer types                     }
                                       { ------------------------------------ }
   TRANSDUCER_LINEAR  = 0;             { Linear transducer                    }
   TRANSDUCER_ROTARY  = 1;             { Rotary transducer                    }

                                       { Reference mark types                 }
                                       { ------------------------------------ }
   REFMARK_NON        = 0;             { Transducer has no reference mark     }
   REFMARK_ONE        = 1;             { Transducer has one reference mark    }
   REFMARK_DISTCODE   = 2;             { Transducer has distance coded        }

   SEN_LIN_DATA_MAX   = 12;            { Max. numbers of sensor lin. points   }
                                       { referenced marks                     }


type                                   { Sensor EEPROM header data            }
  DoPESensorHeaderData = record        { ------------------------------------ }
    PartNo             : word;         { Part ident number              [No]  }
    Version            : Byte;         { Part revision                  [No]  }
    SerNo              : DWord;        { Part serial number             [No]  }

    SensorClass        : word;         { Sensor class                   [No]  }
    DatVersion         : Byte;         { Version of data                [No]  }
  end;


type                                   { Analogue sensor EEPROM data          }
  LinV = record                        { ------------------------------------ }
    MeasValue: Double;
    RefValue:  Double;
  end;
type
  DoPESensorAnalogueData = record
    MaxExcitation      : Single;       { Maximum excitation voltage      [V]  }
    MinImpedance       : word;         { Impedance                     [Ohm]  }
    NominalValue       : Single;       { Nominal value of the sensor  [Unit]  }
    U                  : word;         { nit of sensor UNIT_xxx        [No]   }
    Offset             : Single;       { Sensor offset                [Unit]  }
    NegLimit           : word;         { Range limit - min.              [%]  }
    PosLimit           : word;         { Range limit - max.              [%]  }
    Reference          : Single;       { Nominal value of the reference  [*]  }
    CorrReference      : Double;       { Corr. value of the reference   [No]  }
    Sensortype         : word;         { Sensor type                          }
    NominalSensitive   : Double;       { Sensitivity at Nominal value    [*]  }
    Sign               : word;         { Invert sign of channel        [1/0]  }
    Day                : Integer;      { Date of last change - day      [No]  }
    Month              : Integer;      { Date of last change - month    [No]  }
    Year               : Integer;      { Date of last change - year     [No]  }
    LinPoint           : word;         { Number of linearization steps  [No]  }
    LinVal: array[0..SEN_LIN_DATA_MAX-1] of LinV;
  end;
                                       { [*]: [V]    for DC sensorsor         }
                                       { [mV/V] for DMS and LVDT              }


type                                   { Incremental sensor EEPROM data       }
  DoPESensorIncData = record           { ------------------------------------ }
    Voltage1            : Single;      { Supply voltage 1                [V]  }
    Voltage2            : Single;      { Supply voltage 2                [V]  }
    Voltage3            : Single;      { Supply voltage 3                [V]  }
    Current1            : Single;      { Current for supply voltage 1    [A]  }
    Current2            : Single;      { Current for supply voltage 2    [A]  }
    Current3            : Single;      { Current for supply voltage 3    [A]  }
    InputSignal         : word;        { Signal type at input  SIG_xxx  [No]  }
    OutputSignal        : word;        { Signal type at output SIG_xxx  [No]  }
    InterpolationFactor : word;        { Factor for interpolation       [No]  }
    MaxInputFreq        : Single;      { Maximum input frequency        [Hz]  }
    MaxOutputFreq       : Single;      { Maximum output frequency       [Hz]  }
    TransducerType      : word;        { Transducer type TRANSDUCER_xxx [No]  }
    U                   : word;        { Unit of sensor UNIT_xxx        [No]  }
    SignalPeriod        : Double;      { Signal period                [Unit]  }
    CorrFactor          : Double;      { Correction factor              [No]  }
    MeasuringRange      : Double;      { Measuring range              [Unit]  }
    SignalType          : word;        { Transducer sgnal type SIG_xxx  [No]  }
    ReferenceMark       : word;        { Reference mark type REFMARK_xxx[No]  }
    FirstDistance       : Double;      { First distance of the reference[Unit]}
    NominalDistance     : Double;      { Nominal distance of the reference[Unit]}
    Delta               : Double;      { Dislocation of the mean reference[Unit]}
    LimitFrequency      : Single;      { Limit frequency of the transducer[Hz]}
    Sign                : word;        { Invert sign of channel        [1/0]  }
    NegLimit            : Byte;        { Range limit - min.              [%]  }
    PosLimit            : Byte;        { Range limit - max.              [%]  }
  end;


type                                   { Absolute sensor EEPROM data          }
  DoPESensorAbsData = record           { ------------------------------------ }
    Voltage1            : Single;      { Supply voltage 1                [V]  }
    Voltage2            : Single;      { Supply voltage 2                [V]  }
    Voltage3            : Single;      { Supply voltage 3                [V]  }
    Current1            : Single;      { Current for supply voltage 1    [A]  }
    Current2            : Single;      { Current for supply voltage 2    [A]  }
    Current3            : Single;      { Current for supply voltage 3    [A]  }
    InputSignal         : word;        { Signal type at input  SIG_xxx  [No]  }
    OutputSignal        : word;        { Signal type at output SIG_xxx  [No]  }
    MaxInputFreq        : Single;      { Maximum input frequency        [Hz]  }
    MaxOutputFreq       : Single;      { Maximum output frequency       [Hz]  }

    DelayTime           : Byte;        { Sensors signal delay time       [s]  }
    U                   : word;        { Unit of sensor UNIT_xxx        [No]  }
    SignalPeriod        : Double;      { Signal period                [Unit]  }
    Offset              : Single;      { Sensor offset                [Unit]  }
    CorrFactor          : Double;      { Correction factor              [No]  }
    NominalValue        : Double;      { Nominal value of the sensor  [Unit]  }
    SignalType          : word;        { Tansducer sgnal type  SIG_xxx  [No] }
                                       { or SIG_SSI_GENERIC + code + number  }
                                       { of data bits                        }
    LimitFrequency      : Single;      { Limit frequency of the transducer[Hz] }
    Sign                : word;        { Invert sign of channel        [1/0]  }
    NegLimit            : Byte;        { Range limit - min.              [%]  }
    PosLimit            : Byte;        { Range limit - max.              [%]  }
    Day                 : Integer;     { Date of last change - day      [No]  }
    Month               : Integer;     { Date of last change - month    [No]  }
    Year                : Integer;     { Date of last change - year     [No]  }
  end;


{ --------------------------------------------------------------------------- }

const                                  { Error constants                      }
                                       { ------------------------------------ }
   DoPERR_NOERROR       = $0000;       { No error                             }
   DoPERR_NOFLOAT       = $0001;       { No float in WIN16 callback           }
   DoPERR_SYNC          = $0002;       { Synchronisation to callback failed   }
   DoPERR_TIMEOUT       = $0003;       { Timeout at await answer              }
   DoPERR_NOFNC         = $0004;       { Function not implemented             }
   DoPERR_VERSION       = $0005;       { No compatible Version EDC-DoPE       }
   DoPERR_INIT          = $0006;       { Initialisation Error Subsystem       }
   DoPERR_PARAMETER     = $0007;       { Invalid parameter                    }
   DoPERR_SETUPOPEN     = $0008;       { Setup Open Error                     }
   DoPERR_RTE_UNHANDLED = $0009;       { Unhandled runtime error              }

   { Command errors                                                           }
   DoPERR_CMD_PARCORR   = 1001;        { Error in parameter (corrected)       }
   DoPERR_CMD_PAR       = 1003;        { Error in parm. not correctable       }
   DoPERR_CMD_XMOVE     = 1004;        { X-Head is not halted                 }
   DoPERR_CMD_INITSEQ   = 1005;        { Sequence in init. not observed       }
   DoPERR_CMD_NOTINIT   = 1006;        { Controller part not initialised      }
   DoPERR_CMD_DIR       = 1007;        { Movement direction  not possible     }
   DoPERR_CMD_TMP       = 1008;        { Required resource not available      }
   DoPERR_CMD_RUNTIME   = 1009;        {  Run time error active               }
   DoPERR_CMD_INTERN    = 1010;        { Internal error in subsystem          }
   DoPERR_CMD_MEM       = 1011;        { Insufficient memory                  }
   DoPERR_CMD_CST       = 1012;        { Wrong controller Structure           }
   DoPERR_CMD_NIM       = 1013;        { Command not implemented              }
   DoPERR_CMD_MSGNO     = 2001;        { Unknown message number               }
   DoPERR_CMD_VERSION   = 2003;        { Wrong PE interface version           }
   DoPERR_CMD_OPEN      = 2004;        { Setup not opened                     }
   DoPERR_CMD_MEMORY    = 2005;        { Not enough memory                    }

   { Machine normalisation error                                              }
   DoPERR_PARMS         = $4001;       { Parameter Error                      }
   DoPERR_ZERODIV       = $4002;       { Division by ZERO                     }
   DoPERR_OVFLOW        = $4003;       { Overflow                             }
   DoPERR_NIN           = $4004;       { Not Initialised                      }

   { Low level communication errors                                           }
   DoPERR_NODATA        = $8001;       { No receiver data available           }
   DoPERR_NOBUFFER      = $8002;       { No transmitter buffer available      }
   DoPERR_OFFLINE       = $8003;       { Connection is offline                }
   DoPERR_HANDLE        = $8004;       { Invalid DoPE handle                  }
   DoPERR_MSGSIZE       = $8005;       { Message to long                      }
   DoPERR_COMPARAMETER  = $8006;       { Invalid com driver parameter         }
   DoPERR_NOMEM         = $8007;       { Not enough heap memory               }
   DoPERR_BADPORT       = $8008;       { Invalid device ID                    }
   DoPERR_BAUDRATE      = $8009;       { Invalid baudrate                     }
   DoPERR_OPEN          = $800A;       { Device already in use                }
   DoPERR_HARDWARE      = $800B;       { Device not present                   }
   DoPERR_NOTOPEN       = $800C;       { Connection not open                  }
   DoPERR_PORTLIMIT     = $800D;       { Unused                               }
   DoPERR_NOTIMER       = $800E;       { No timer for timeout check           }
   DoPERR_NODRIVER      = $800F;       { No driver available                  }
   DoPERR_NOTHREAD      = $8010;       { Win32: Thread creation failed        }
   DoPERR_BADOS         = $8011;       { Not supported operating system       }
   DoPERR_THUNK         = $8012;       { Win32: Thread creation failed        }

   DoPERR_INTERNAL      = $FFFFFFFF;   { Internal driver error                }


{ --------------------------------------------------------------------------- }

                                       { Manifest constants for event bits    }
                                       { ------------------------------------ }
   DoPEEVT_RXAVAIL      = $0001;       { New message received                 }
   DoPEEVT_DATAVAIL     = $0010;       { New Samples (MW) available           }
   DoPEEVT_DATAOVERFLOW = $0020;       { Sample Overflow                      }
   DoPEEVT_ACK          = $0040;       { DoPE command acknowledged            }
   DoPEEVT_NAK          = $0080;       { DoPE command not acknowledged        }
   DoPEEVT_RESTART      = $1000;       { EDC link established                 }
   DoPEEVT_OVERFLOW     = $2000;       { Receiver Overflow                    }
   DoPEEVT_OFFLINE      = $4000;       { State transition to Offline          }
   DoPEEVT_ONLINE       = $8000;       { State transition to Online           }
   DoPEEVT_ALL          = $F0F1;       { All valid event bits                 }


{ --------------------------------------------------------------------------- }

type
  DoPE_HANDLE = PDWord;                { Handle for DoPE link                 }


type                                   { Error counters                       }
  DoPEError = record                   { ------------------------------------ }
    Parity      : DWord;               { Parity errors                        }
    Overrun     : DWord;               { Overrun errors                       }
    Frame       : DWord;               { Framing errors                       }
    InvACK      : DWord;               { Invalid ACKs received                }
    NoBuffer    : DWord;               { No receiver buffer available         }
    DLESeq      : DWord;               { Invalid DLE sequence                 }
    BufOFlow    : DWord;               { Receiver buffer overflow             }
    BccErr      : DWord;               { Checksum error                       }
    MwError     : DWord;               { Invalid sample encoding              }
  end;


type                                   { Communicatio and buffer state        }
  DoPEState = record                   { ------------------------------------ }
    ComState    : DWord;               { Communication state                  }
    RcvBuffer   : DWord;               { Full receiver buffers                }
    XmitBuffer  : DWord;               { Full transmitter buffers             }
  end;


type                                   { user scale                           }
  UserScale = array[0..MAX_MC-1] of Double;

type                                   { Sytem user data                      }
  SysUsrData  = array[0..(SysUsrDataLen-1)] of Byte;


{ --------------------------------------------------------------------------- }

type                                   { Default measuring dada record        }
  DoPEData = record                    { ------------------------------------ }
      Cycles           : DWord;        { Cycle counter                        }
      Reserved1        : DWord;        { 8-Byte Alignment                     }
      Time             : Double;       { Time from subsystem                  }
      Position         : Double;       { X-Head position                      }
      Load             : Double;       { Load                                 }
      Extension        : Double;       { Extension                            }
      Sensor3          : Double;       { Optional measuring channel 3         }
      Sensor4          : Double;       { Optional measuring channel 4         }
      Sensor5          : Double;       { Optional measuring channel 5         }
      Sensor6          : Double;       { Optional measuring channel 6         }
      Sensor7          : Double;       { Optional measuring channel 7         }
      Sensor8          : Double;       { Optional measuring channel 8         }
      Sensor9          : Double;       { Optional measuring channel 9         }
      Sensor10         : Double;       { Optional measuring channel 10        }
      Sensor11         : Double;       { Optional measuring channel 11        }
      Sensor12         : Double;       { Optional measuring channel 12        }
      Sensor13         : Double;       { Optional measuring channel 13        }
      Sensor14         : Double;       { Optional measuring channel 14        }
      Sensor15         : Double;       { Optional measuring channel 15        }
      BitIn0           : word;         { Digital input device 0               }
      BitIn1           : word;         { Digital input device 1               }
      BitIn2           : word;         { Digital input device 2               }
      BitIn3           : word;         { Digital input device 3               }
      BitIn4           : word;         { Digital input device 4               }
      BitIn5           : word;         { Digital input device 5               }
      BitIn6           : word;         { Digital input device 6               }
      BitIn7           : word;         { Digital input device 7               }
      BitIn8           : word;         { Digital input device 8               }
      BitIn9           : word;         { Digital input device 9               }
      BitOut0          : word;         { Digital output device 0              }
      BitOut1          : word;         { Digital output device 1              }
      BitOut2          : word;         { Digital output device 2              }
      BitOut3          : word;         { Digital output device 3              }
      BitOut4          : word;         { Digital output device 4              }
      BitOut5          : word;         { Digital output device 5              }
      BitOut6          : word;         { Digital output device 6              }
      BitOut7          : word;         { Digital output device 7              }
      BitOut8          : word;         { Digital output device 8              }
      BitOut9          : word;         { Digital output device 9              }
      InSignals        : word;         { Logical input signals                }
      OutSignals       : word;         { Logical output signals               }
      CtrlState1       : word;         { Controller status word 1             }
      CtrlState2       : word;         { Controller status word 2             }
      UpperLimits      : word;         { Upper limits exceeded                }
      LowerLimits      : word;         { Lower limits exceeded                }
      SysState0        : word;         { System Status word 0                 }
      ActiveCtrl       : word;         { Active control channel               }
      UpperSft         : word;         { Upper soft limit active              }
      LowerSft         : word;         { Lower soft limit active              }
      SensorConnected  : word;         { Sensor plug connected state          }
      SensorKeyPressed : word;         { Sensor plug key state                }
      Test1            : Double;       { Configured test value 1              }
      Test2            : Double;       { Configured test value 2              }
      Test3            : Double;       { Configured test value 3              }
      Keys             : word;         { Actual State of EDC frontpanel keys  }
      NewKeys          : word;         { New keys                             }
      GoneKeys         : word;         { Gone keys                            }
    end;


{***** DoPE API functions *****************************************************}

{ ------------ Communication port definitions -------------------------------- }

const
  DoPEPORT_COM     = 0;                  { COM port start value                }
                                         { COMx:Number=x-1(max.COM256)         }

  DoPEPORT_USB     = $0100;              { USB port start value                }
                                         { USBx:Number=x-0x100 (USB0..255)     }

  DoPEPORT_LAN     = $0200;              { LAN port start value                }
                                         { LANx:Number=x-0x200 (NIC0..255)     }
                                         { LAN255 is used by DoPE internaly!   }

  DoPE_PORTNAMELEN = 80;                 { Max. port name length in bytes      }
                                         { (including terminating zero '\0')   }

type
  MAC = record
    a          : array[0..5] of Byte;    { MAC Address                          }
  end;

type
  DoPE_PORTINFO = record
    Ix         : DWord;                  { Device Index                         }
    Name       : array[0..(DoPE_PORTNAMELEN - 1)] of char;   { Device Name      }
    ComPort    : DWord;                  { Com Port                             }
    BaudRate   : DWord;                  { Baudrate    (DoPEPORT_COM only)      }
    NicMac     : MAC;                    { NIC address                          }
  end;

type
  DoPE_wPORTINFO = record
    Ix         : DWord;                  { Device Index                         }
    Name       : array[0..(DoPE_PORTNAMELEN - 1)] of WideChar;
                                         { Device Name                          }
    ComPort    : DWord;                  { Com Port                             }
    BaudRate   : DWord;                  { Baudrate    (DoPEPORT_COM only)      }
    NicMac     : MAC;                    { NIC address                          }
  end;

{ ----------------------------------------------------------------------------- }

function DoPEPortInfo ( Port       : DWord;
                        First      : DWord;
                   var  pPortInfo  : DoPE_PORTINFO) : DWord; STDCALL;
function DoPEwPortInfo ( Port       : DWord;
                         First      : DWord;
                    var  pPortInfo  : DoPE_wPORTINFO) : DWord; STDCALL;

{
    Get the port info.

      In :  Port        Port class (DoPEPORT_COM, DoPEPORT_USB or DoPEPORT_LAN)
            First       != 0: get the first port information
                        == 0: get the next port information
            pPortInfo   pointer to port info structure

      Returns:          Error constant (DoPERR_xxxx)
                        (DoPERR_BADPORT if no more port info is available)
}


function DoPECurrentPortInfo ( DoPEHdl    : DoPE_HANDLE;
                          var  pPortInfo  : DoPE_PORTINFO) : DWord; STDCALL;
function DoPEwCurrentPortInfo ( DoPEHdl    : DoPE_HANDLE;
                           var  pPortInfo  : DoPE_wPORTINFO) : DWord; STDCALL;

{
    Get the current port info of a link.

      In :  DoPEHdl     DoPE link handle
            pPortInfo   pointer to port info structure

      Returns:          Error constant (DoPERR_xxxx)
                        (DoPERR_BADPORT if no more port info is available)
}


{ ----------------------------------------------------------------------------- }

function DoPEDefineNIC ( Port   : DWord;
                     var pMAC   : MAC) : DWord; STDCALL;

 {
    Assign a NIC to a DoPE port.

      In :  Port        Port number (DoPEPORT_LAN+x)
            pMAC        Pointer to NIC's MAC address. A NULL pointer removes
                        the assignment.

      Returns:          Error constant (DoPERR_xxxx)
 }


{ ------------------------------------------------------------------------- }

function DoPEIgnoreTcpIpNIC ( Enable : DWord ) : DWord; STDCALL;

 {
    For faster port scanning NIC's with TCP/IP protocol can be ignored in
    DpxPortInfo, DpxDefineNIC and DpxOpenLink calls.

      In :  Enable      true:  ignore NIC's with TCP/IP protocol
                        false: include NIC's with TCP/IP protocol to port scan (Default)

      Returns:          old Enable state
 }


{ ------------------------------------------------------------------------- }

function DoPEOpenLink  ( Port        : DWord;
                         Portparam   : DWord;
                         RcvBuffers  : DWord;
                         XmitBuffers : DWord;
                         DataBuffers : DWord;
                         APIVersion  : DWord;
                         Reserved    : Pointer;
                    var  DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

 {
    Open the given DoPE link.
    The link parameters are set and the link is established.
    If DoPEOpenLink returns DoPERR_TIMEOUT, connection to the EDC did not
    go online. You must connect the EDC, switch it on and try DoPEOpenLink
    again.

      In :  Port        Port number (DoPEPORT_xx)
            PortParam   Baud rate for serial lines, as supported by Windows
                        EDC device ID for USB and LAN connections
            RcvBuffers  Number of requested receiver buffers for messages.
                        This number messages can be stored inside DoPE until
                        they are read with DoPEGetMsg function.
            XmitBuffers Number of requested transmitter buffers for messages
                        This number of messages can be stored inside DoPE.
                        They will be transmitted by DoPE to the EDC.
            DataBuffers Number of requested data buffers.
                        The measuring data record will be stored inside DoPE
                        in a circular buffer. If data are not read with
                        DoPEGetData the oldest record be overwritten!
            APIVersion  DoPE API version used by the DoPE user
            *Reserved   Reserved for future use
            DoPEHdl     Pointer to storage for DoPE link handle

      Out:  *DoPEHdl    DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
}


{ -------------------------------------------------------------------------- }

function  DoPEOpenDeviceID    ( DeviceID    : DWord;
                                RcvBuffers  : DWord;
                                XmitBuffers : DWord;
                                DataBuffers : DWord;
                                APIVersion  : DWord;
                                Reserved    : Pointer;
                           var  DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

function  DoPEOpenFunctionID  ( FunctionID  : DWord;
                                RcvBuffers  : DWord;
                                XmitBuffers : DWord;
                                DataBuffers : DWord;
                                APIVersion  : DWord;
                                Reserved    : Pointer;
                           var  DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

    {
    Open the given DoPE link with a matching device or function ID.
    All communication ports are scanned, starting with DoPEPORT_USB.
    LAN ports which have been assigned with DoPEDefineNIC are included to the scan.
    The link parameters are set and the link is established.
    If DoPEOpenFunctionID returns DoPERR_TIMEOUT, connection to the EDC did not
    go online. You must connect the EDC, switch it on and try DoPEOpenFunctionID
    again.
    This function is available for USB and LAN connections only.

      In :  Port        Port number (DoPEPORT_xx)
            FunctionID  EDC function ID
            RcvBuffers  Number of requested receiver buffers for messages.
                        This number messages can be stored inside DoPE until
                        they are read with DoPEGetMsg function.
            XmitBuffers Number of requested transmitter buffers for messages
                        This number of messages can be stored inside DoPE.
                        They will be transmitted by DoPE to the EDC.
            DataBuffers Number of requested data buffers.
                        The measuring data record will be stored inside DoPE
                        in a circular buffer. If data are not read with
                        DoPEGetData the oldest record be overwritten!
            APIVersion  DoPE API version used by the DoPE user
            *Reserved   Reserved for future use
            DoPEHdl     Pointer to storage for DoPE link handle

      Out:  *DoPEHdl    DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ------------------------------------------------------------------------- }

function DoPECloseLink  ( var DoPEHdl : DoPE_HANDLE ) : DWord; STDCALL;

   {
    Close down the given DoPE link.

      In :  *DoPEHdl    Pointer to DoPE link handle

      Out:  *DoPEHdl    Invalidated DoPE link handle (set to NULL)

      Returns:          Error constant (DoPERR_xxxx)
   }


{ -------------------------------------------------------------------------- }

  type
    DoPEOpenLinkInfo = record
      DoPEHdl    : DoPE_HANDLE;
      PortType   : DWord;
      PortInfo   : DoPE_PORTINFO;
      Reserved   : Byte;
      Reserved1  : Byte;
      ModuleInfo : DoPEModuleInfo;
    end;

function  DoPEOpenAll  ( RcvBuffers             : DWord;
                         XmitBuffers            : DWord;
                         DataBuffers            : DWord;
                         APIVersion             : DWord;
                         Reserved               : Pointer;
                         InfoTableMaxEntries    : DWord;
                     var InfoTableValidEntries  : DWord;
                     var Info                   : array of DoPEOpenLinkInfo ) : DWord; STDCALL;

  type
    DoPEwOpenLinkInfo = record
      DoPEHdl    : DoPE_HANDLE;
      PortType   : DWord;
      PortInfo   : DoPE_wPORTINFO;
      Reserved   : Byte;
      Reserved1  : Byte;
      ModuleInfo : DoPEwModuleInfo;
    end;

function  DoPEwOpenAll  ( RcvBuffers             : DWord;
                          XmitBuffers            : DWord;
                          DataBuffers            : DWord;
                          APIVersion             : DWord;
                          Reserved               : Pointer;
                          InfoTableMaxEntries    : DWord;
                      var InfoTableValidEntries  : DWord;
                      var Info                   : array of DoPEwOpenLinkInfo ) : DWord; STDCALL;

    {
    Open all available DoPE links and fill the open link info table.
    All communication ports are scanned, starting with DoPEPORT_USB.
    All LAN ports without installed TCP/IP protocol are included to the scan.

      In :  RcvBuffers             Number of requested receiver buffers for
                                   messages. This number of messages can be
                                   stored inside DoPE until they are read with
                                   DoPEGetMsg function.
            XmitBuffers            Number of requested transmitter buffers for
                                   messages. This number of messages can be
                                   stored inside DoPE. They will be transmitted
                                   by DoPE to the EDC.
            DataBuffers            Number of requested data buffers.
                                   The measuring data record will be stored
                                   inside DoPE in a circular buffer. If data
                                   are not read with DoPEGetData the oldest
                                   record will be overwritten!
            APIVersion             DoPE API version used by the DoPE user
           *Reserved               Reserved for future use
            InfoTableMaxEntries    Number of entries that can be stored to the
                                   info table.
           *InfoTableValidEntries  Pointer to storage for the number of valid
                                   entries in the info table.

      Out :
           *InfoTableValidEntries  Number of valid entries in the info table.
            Info                   Info table containing valid entries for all
                                   opened links.

      Returns:          Error constant (DoPERR_xxxx)
    }


function  DoPECloseAll  ( InfoTableValidEntries  : DWord;
                      var Info                   : array of DoPEOpenLinkInfo ) : DWord; STDCALL;
                      
function  DoPEwCloseAll  ( InfoTableValidEntries : DWord;
                       var Info                  : array of DoPEwOpenLinkInfo ) : DWord; STDCALL;

    {
    Close all DoPE links previously opened by DoPEOpenAll.

      In :  InfoTableValidEntries  Number of valid entries in the info table.
            InfoTable              Info table containing valid DoPE handles for
                                   all links to close

      Out :
            InfoTable              Info table with all DoPE handles set to NULL

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ------------------------------------------------------------------------- }

function DoPESetIoCompatibilityMode  ( DoPEHdl : DoPE_HANDLE;
                                       Enable  : word) : DWord; STDCALL;
    {
    Set the compatibility mode for bit input and output channels

      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables compatibility mode

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPESendMsgSync  ( DoPEHdl : DoPE_HANDLE;
                            Buffer  : Pointer;
                            Length  : DWord;
                            usTAN   : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESendMsg  ( DoPEHdl : DoPE_HANDLE;
                        Buffer  : Pointer;
                        Length  : DWord;
                        usTAN   : PWord ): DWord; STDCALL;

    {
    Send a message to EDC.
    This function is only needed if you have to communicate directly to EDC's
    Subsystem. The message sent must be a command to the subsystem. Refer
    Documentation Subsystem for Test Machine Control.

      In :  DoPEHdl     DoPE link handle
            Buffer      Pointer to message to transmit
            Length      Message length in bytes

      Out :
            usTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function  DoPECurrentData ( DoPEHdl  : DoPE_HANDLE;
                            Buffer   : Pointer):DWord; STDCALL;

    {
    Get current samples from receiver buffer.
    DoPE receives measuring data in a adjustable time scale. The data record is
    stored inside DoPE in a circular buffer. You can read the newest data record
    with this function.

      In :  DoPEHdl     DoPE link handle
            Buffer      Pointer to storage for data record.
                        Buffer must be big enough to store the DoPEData structure

      Out:  *Buffer     DoPEData record

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function  DoPESetCycleMode ( DoPEHdl  : DoPE_HANDLE;
                             Enable   : Dword ): DWord; STDCALL;

    {
    Enable/disable unified cycle handling for cyclic movement commands.

      In :  DoPEHdl     DoPE link handle
            Enable      != 0 enables
                        == 0 disables unified cycle handling (default)

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEGetData ( DoPEHdl : DoPE_HANDLE;
                       Buffer  : Pointer): DWord; STDCALL;

    {
    Get samples from receiver buffer.
    DoPE receives measuring data in a adjustable time scale. The data record is
    stored inside DoPE in a circular buffer. You can read one data record
    with this function.

      In :  DoPEHdl     DoPE link handle
            Buffer      Pointer to storage for data record.
                        Buffer must be big enough to store the DoPEData structure

      Out:  *Buffer     DoPEData record

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPECtrlTestValues  ( DoPEHdl : DoPE_HANDLE;
                               State   : Word ) : DWord; STDCALL;

    {
    Enable or disable the controller test variables.

      In :  DoPEHdl     DoPE link handle
            State       TRUE:  enables
                        FALSE: disables the controller test variables in
                        the DoPEData record.

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEClearReceiver  ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

    {
    Discard all receiver buffers

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEClearTransmitter ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

    {
    Discard all unsent transmitter buffers

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEGetState ( DoPEHdl : DoPE_HANDLE;
                    var Status  : DoPEState ): DWord; STDCALL;

    {
    Get state information structure

      In :  DoPEHdl     DoPE link handle
            Status      Pointer to storage for state information

      Out:  *Status     State information

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEOpenSetupSync ( DoPEHdl  : DoPE_HANDLE;
                             SetupNo  : Word ):DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEOpenSetup ( DoPEHdl  : DoPE_HANDLE;
                         SetupNo  : Word;
                         usTAN    : PWord ): DWord; STDCALL;

   {
    Open setup 'SetupNo' for read/write operations.

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.

      Out :
            usTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPECloseSetupSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPECloseSetup ( DoPEHdl : DoPE_HANDLE;
                          usTAN   : PWord ): DWord; STDCALL;

{
    Close setup.

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPESetupScale ( DoPEHdl : DoPE_HANDLE;
                          SetupNo : Word;
                          US      : UserScale;
                          usTAN   : PWord ): DWord; STDCALL;

{
    Sets the setup user scale.

      In :  DP          DoPE link handle
            SetupNo     Setup No.
            US          User scale for all setup sensor data (except DoPESenDef).
                        The sensor data will be devided by the value in US.
                        e.g. use this to convert the SI unit meter into mm
                        by setting the userscale to 1000 for the position sensor
                        Default values 1.0 will be used if US is NULL

      Out :

      Returns:          Error constant (DoPERR_xxxx)
}


{ -------------------------------------------------------------------------- }

function DoPERdSetupAllSync ( DoPEHdl    : DoPE_HANDLE;
                              SetupNo    : Word;
                              var Setup  : DoPESetup ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPERdSetupAll ( DoPEHdl    : DoPE_HANDLE;
                          SetupNo    : Word;
                          var Setup  : DoPESetup;
                          usTANFirst : PWord;
                          usTANLast  : PWord ): DWord; STDCALL;

{
    Read the setup structure

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.
            Setup       Pointer to Setup structure

      Out:  *Status     State information (see DoPEState definition)
            usTANFirst  Pointer to first TAN used from this command
            usTANLast   Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEWrSetupAllSync ( DoPEHdl    : DoPE_HANDLE;
                              SetupNo    : Word;
                              var Setup  : DoPESetup ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEWrSetupAll ( DoPEHdl    : DoPE_HANDLE;
                          SetupNo    : Word;
                          var Setup  : DoPESetup;
                          usTANFirst : PWord;
                          usTANLast  : PWord ): DWord; STDCALL;

    {
    Write the setup structure

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.
            Setup       Pointer to Setup structure

      Out:  *Status     State information (see DoPEState definition)
            usTANFirst  Pointer to first TAN used from this command
            usTANLast   Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }

{-----------------------------------------------------------------------------}

function DoPERdSetupNumber ( DoPEHdl  : DoPE_HANDLE;
                         var SetupNo  : Word ): DWord; STDCALL;

    {
    Get the currently selected setup number.

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No.

      Out:  *Status     State information (see DoPEState definition)

      Returns:          Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPESelSetup ( DoPEHdl    : DoPE_HANDLE;
                        SetupNo    : word;
                        US         : UserScale;
                        usTANFirst : PWord;
                        usTANLast  : PWord ): DWord; STDCALL;

    {
    Select machine setup

      In :  DoPEHdl     DoPE link handle
            SetupNo     Setup No. 0 Use actual setup data.
                                    All setup data and basic tare values are
                                    not permanently stored in the EDC's EEPROM.
                        Setup No. 1..4 Read setup data from the EEPROM.
                                       All setup data and basic tare values are
                                       permanently stored in the EDC's EEPROM.
            US          User scale for all measuring channels.
                        The measured data will be devided by the value in US.
                        e.g. use this to convert the SI unit meter into mm
                        by setting the userscale to 1000 for the position channel
                        Default values 1.0 will be used if US is NULL (V2.01)

      Out:  usTANFirst  TAN's are used to identify initialization errors sent in
            usTANLast   addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:          Error constant (DoPERR_xxxx)
    }

{ -------------------------------------------------------------------------- }

function DoPEInitialize ( DoPEHdl    : DoPE_HANDLE;
                          usTANFirst : PWord;
                          usTANLast  : PWord ): DWord; STDCALL;

   {
    Initialize System with selected setup data.
    This command must be given after a change of machine setup.

      In :  DoPEHdl     DoPE link handle

      Out:  usTANFirst  TAN's are used to identify initialization errors sent in
            usTANLast   addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEInitializeResetXHead ( DoPEHdl    : DoPE_HANDLE;
                                    usTANFirst : PWord;
                                    usTANLast  : PWord ): DWord; STDCALL;

    {
    Initialize System with selected setup data and reset the crosshead position.

      In :  DoPEHdl       DoPE link handle

      Out:  *lpusTANFirst TAN's are used to identify initialization errors sent in
            *lpusTANLast  addition to the synchronised return code.
                         (This will be implemented in future EDC versions.
                          In Version 2.11 we have synchronised return codes but only
                          one error code sent on the PE_INITIALIZE command.)

      Returns:            Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }
{
    ReInitialization allows to disconnect an EDC from the PC without closing
    down the connection (the drive remains on) and recovering the connection
    to a known state.
    This might be neccesery to protect a long term test from a PC crash.
}

const
  DoPEREINITIALIEDATA_LEN = $8000;

type                                   { ReInitialize data array [No]         }
  DoPEReInitializeData  = array[0..DoPEREINITIALIEDATA_LEN-1] of char;

function DoPEReInitializeEnable ( DoPEHdl : DoPE_HANDLE;
                                  Enable  : DWord;
                              var Data    : DoPEReInitializeData): DWord; STDCALL;

    {
    Enable / disable the ReInitialization mode.

      In :  DoPEHdl       DoPE link handle
            Enable        != 0: enables the ReInitialization mode
                          == 0: disables the ReInitialization mode
            Data          Pointer to the ReInitialization data.

      Out:  *Data         internal state of the connection used to recover the
                          connetion with DoPEReInitialize.

      Returns:            Error constant (DoPERR_xxxx)
    }


function DoPEReInitialize ( DoPEHdl : DoPE_HANDLE;
                        var Data    : DoPEReInitializeData): DWord; STDCALL;
    {
    Recover a connection to a known state without a new initializion that 
    switches off the drive.

      In :  DoPEHdl       DoPE link handle
            Data          Pointer to the ReInitialization data containing
                          information to recover a connetion to the state
                          previously saved with DoPEReInitializeEnable.

      Returns:            Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEGetErrors  ( DoPEHdl : DoPE_HANDLE;
                      var Error   : DoPEError ): DWord; STDCALL;

    {
    Get current error counter values

      In :  DoPEHdl     DoPE link handle
            Error       Pointer to storage for error counters

      Out:  *Error      Current error counter values

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function  DoPEClearErrors  ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

    {
    Clear current error counter values

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ------------------------------------------------------------------------- }
{                     Instructions for Sampling Control                     }
{ ------------------------------------------------------------------------- }

function  DoPESetDataTransmissionRateSync  ( DoPEHdl : DoPE_HANDLE;
                                             Refresh : Double ): Dword; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetDataTransmissionRate  ( DoPEHdl : DoPE_HANDLE;
                                         Refresh : Double;
                                         usTAN   : PWord ): DWord; STDCALL;

   {
    Set time base for data acquisition for all measuring channels.
    The default refresh time is defined in the setup data.

      In :  DoPEHdl     DoPE link handle
            Refresh     Time in s

      Out :
           usTAN        Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

function  DoPESetSensorDataTransmissionRateSync  ( DoPEHdl  : DoPE_HANDLE;
                                                   SensorNo : Word;
                                                   Refresh  : Double ): Dword; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetSensorDataTransmissionRate  ( DoPEHdl  : DoPE_HANDLE;
                                               SensorNo : Word;
                                               Refresh  : Double;
                                               usTAN    : PWord ): DWord; STDCALL;

   {
    Set time base for data acquisition for a measuring channel.
    The default refresh time is defined
    in the setup data.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Refresh       Time in s

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

const
  SETTIME_MODE_IMMEDIATE   = 0;   { set time immediately                        }
  SETTIME_MODE_MOVE_START  = 1;   { set time at the start of a movement command }
  SETTIME_MODE_FIRST_CYCLE = 2;   { set time at the start of the first cycle    }

function  DoPESetTimeSync  ( DoPEHdl : DoPE_HANDLE;
                             Mode    : Word;
                             Time    : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetTime  ( DoPEHdl : DoPE_HANDLE;
                         Mode    : Word;
                         Time    : Double;
                         usTAN   : PWord ): DWord; STDCALL;
   {
    Set time counter to a desired value.

      In :  DoPEHdl     DoPE link handle
            Mode        Set time immediate, at start of movement or at first cycle       
            Time        New value for Time in s

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }

{--------------------------------------------------------------------------}

function  DoPETransmitDataSync  ( DoPEHdl : DoPE_HANDLE;
                                  Enable  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPETransmitData  ( DoPEHdl : DoPE_HANDLE;
                              Enable  : Word;
                              usTAN   : PWord ): DWord; STDCALL;

  {
    Activate / Deactivate transmission of data. If deactivated no measuring data
    will be transmitted to the PC!

      In :  DoPEHdl     DoPE link handle
            Enable      TRUE  = Activate transmission
                        FALSE = Deactivate transmission

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }

{--------------------------------------------------------------------------}

function  DoPESetBSync ( DoPEHdl     : DoPE_HANDLE;
                         BitOutputNo : Word;
                         SetB        : Word;
                         ResB        : Word;
                         FlashB      : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetB ( DoPEHdl     : DoPE_HANDLE;
                     BitOutputNo : Word;
                     SetB        : Word;
                     ResB        : Word;
                     FlashB      : Word;
                     usTAN       : PWord ): DWord; STDCALL;

   {
    Set, Reset, Flash Bits
      In :  DoPEHdl     DoPE link handle
            BitOutputNo Number of bit output device
            SetB        These bits will be set
            ResB        These bits will be reset
            FlashB      These bits 'flash'

            The three data words will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing bits.
            2.) Resetting of the bits.
            3.) Setting of the bits.


      Out :
           usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }

{--------------------------------------------------------------------------}

function  DoPEIntgrSync ( DoPEHdl   : DoPE_HANDLE;
                          SensorNo  : Word;
                          Intgr     : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEIntgr ( DoPEHdl   : DoPE_HANDLE;
                      SensorNo  : Word;
                      Intgr     : Double;
                      usTAN     : PWord ): DWord; STDCALL;

   {
    Set time of integration for an analogue measuring channel.

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            Intgr       Integration time for analogue measuring channels in sec.
                        The limits the integration time depend on the selected
                        timebase for the speed control loop cycle time.
                        (see machine setup data)
                        The minimum time is   1 x (timebase for the speed control)
                        The maximum time is 100 x (timebase for the speed control)

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPECalSync ( DoPEHdl    : DoPE_HANDLE;
                        SensorBits : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPECal ( DoPEHdl    : DoPE_HANDLE;
                    SensorBits : Word;
                    usTAN      : PWord ): DWord; STDCALL;

    {
    Compensate drifts (zero and amplification) of the measuring channel.
    It takes about 0.5 s to compensate drifts.
    During compensation the sensor is not measured!!!

      In :  DoPEHdl     DoPE link handle
                        SensorBits      Bit 0 .. 9 define the sensor Number to be calibrated.
                                    Bit 0 = 1 Calibrate Sensor 0
                                    Bit 1 = 1 Calibrate Sensor 1 ...

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEZeroCalSync ( DoPEHdl    : DoPE_HANDLE;
                            SensorBits : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEZeroCal ( DoPEHdl    : DoPE_HANDLE;
                        SensorBits : Word;
                        usTAN      : PWord ): DWord; STDCALL;

    {
    Compensate only zero offset drift.
    It takes about 0.2 s to compensate zero offset drift.
    During compensation the sensor is not measured!!!

      In :  DoPEHdl     DoPE link handle
                        SensorBits      Bit 0 .. 9 define the sensor Number to be calibrated.
                                    Bit 0 = 1 Calibrate zero offset of Sensor 0
                                    Bit 1 = 1 Calibrate zero offset of Sensor 1 ...

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPESetOutputSync ( DoPEHdl  : DoPE_HANDLE;
                              Output   : Word;
                              Value    : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetOutput ( DoPEHdl  : DoPE_HANDLE;
                          Output   : Word;
                          Value    : Double;
                          usTAN    : PWord ): DWord; STDCALL;

    {
    Set an analogue output channel.

      In :  DoPEHdl     DoPE link handle
                        Output      Number of analogue output channel
                        Value                           New value of output channel

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{----------------------------------------------------------------------------}

function DoPESetOutChannelOffsetSync ( DoPEHdl : DoPE_HANDLE;
                                       Output  : Word;
                                       Offset  : Double) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESetOutChannelOffset ( DoPEHdl  : DoPE_HANDLE;
                                   Output   : Word;
                                   Offset   : Double;
                                   usTAN    : PWord ) : DWord; STDCALL;
    {
    Set an analogue output channel offset.

      In :  DoPEHdl       DoPE link handle
                          Output      Number of analogue output channel
                          Offset      New offset value of output channel
                                      in % of max. value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPESetDitherSync ( DoPEHdl   : DoPE_HANDLE;
                             Output    : Word;
                             Frequency : Double;
                             Amplitude : Double ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESetDither ( DoPEHdl     : DoPE_HANDLE;
                         Output      : Word;
                         Frequency   : Double;
                         Amplitude   : Double;
                         usTAN       : PWord ) : DWord; STDCALL;

    {
    FUNCTION  NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Set an analogue output channel dither.

      In :  DoPEHdl       DoPE link handle
            Output        Number of analogue output channel
            Frequency     Dither frequency
            Amplitude     Dither aplitude

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPESetCheckSync ( DoPEHdl     : DoPE_HANDLE;
                             CheckId     : Word;
                             SensorNo    : Word;
                             Limit       : Double;
                             Mode        : Word;
                             Action      : Word;
                             Ctrl        : Word;
                             Acc         : Double;
                             Speed       : Double;
                             Dec         : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetCheck ( DoPEHdl     : DoPE_HANDLE;
                         CheckId     : Word;
                         SensorNo    : Word;
                         Limit       : Double;
                         Mode        : Word;
                         Action      : Word;
                         Ctrl        : Word;
                         Acc         : Double;
                         Speed       : Double;
                         Dec         : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;
  {
    Activate measuring channel supervision.
    A measuring channel can be supervised and an action activated if the
    channel hits the specified limit. Up to 6 channel supervisions may be
    active at the same time. If one check hits, all supervisions are disabled.

      In :  DoPEHdl     DoPE link handle
            CheckId     ID of this check, use the CheckId constants
            SensorNo    Sensor to be supervised
            Limit       Limit to be supervised
            Mode        Sensor > Limit or Sensor < Limit
            Action      This action will be activated if the check hits.
            Ctrl        Control mode for selected action
            Acc         Acceleration
            Speed       maximum speed
            Dec         Deceleration
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPESetCheckXSync ( DoPEHdl        : DoPE_HANDLE;
                              CheckId        : Word;
                              SensorNo       : Word;
                              Limit          : Double;
                              Tare           : Double;
                              Mode           : Word;
                              Action         : Word;
                              Ctrl           : Word;
                              Acc            : Double;
                              Speed          : Double;
                              Dec            : Double;
                              Destination    : Double;
                              usTAN          : PWORD ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetCheckX (     DoPEHdl        : DoPE_HANDLE;
                              CheckId        : Word;
                              SensorNo       : Word;
                              Limit          : Double;
                              Tare           : Double;
                              Mode           : Word;
                              Action         : Word;
                              Ctrl           : Word;
                              Acc            : Double;
                              Speed          : Double;
                              Dec            : Double;
                              Destination    : Double;
                              usTAN          : PWORD ): DWord; STDCALL;

 {
    Activate measuring channel supervision.
    A measuring channel can be supervised and an action activated if the
    channel hits the specified limit. Up to 6 channel supervisions may be
    active at the same time. If one check hits, all supervisions are disabled.

      In :  DoPEHdl       DoPE link handle
            CheckId       ID of this check, use the CheckId constants
            SensorNo      Sensor to be supervised
            Limit         Limit to be supervised
            Tare          Active tare (only for MKCHK_PERCENT_MAX)
            Mode          Sensor > Limit or Sensor < Limit
            Action        This action will be activated if the check hits.
            Ctrl          Control mode for selected action
            Acc           Acceleration
            Speed         maximum speed
            Dec           Deceleration
            Destination   Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
  }


{--------------------------------------------------------------------------}

function  DoPEClrCheckSync ( DoPEHdl  : DoPE_HANDLE;
                             CheckId  : Word;
                             usTAN    : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEClrCheck ( DoPEHdl  : DoPE_HANDLE;
                         CheckId  : Word;
                         usTAN    : PWord ): DWord; STDCALL;

   {
    Deactivate a measuring channel supervision

      In :  DoPEHdl     DoPE link handle
            CheckId     ID of this check, use the CheckId constants

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }

{--------------------------------------------------------------------------}

function DoPESetCheckLimitSync ( DoPEHdl       : DoPE_HANDLE;
                                 SensorNo      : Word;
                                 UprLimitSet   : Double;
                                 UprLimitReset : Double;
                                 LwrLimitReset : Double;
                                 LwrLimitSet   : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESetCheckLimit ( DoPEHdl       : DoPE_HANDLE;
                             SensorNo      : Word;
                             UprLimitSet   : Double;
                             UprLimitReset : Double;
                             LwrLimitReset : Double;
                             LwrLimitSet   : Double;
                             usTAN         : PWord ): DWord; STDCALL;

    {
    Activate measuring channel supervision.

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor to be supervised
            UprLimitSet    Upper limit when Clamp-IO is activated
            UprLimitReset  Upper limit when Clamp-IO is deactivated
            LwrLimitReset  Lower Limit when Clamp-IO is deactivated
            LwrLimitSet    Lower Limit when Clamp-IO is activated

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEClrCheckLimitSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEClrCheckLimit ( DoPEHdl : DoPE_HANDLE;
                             usTAN   : PWord ): DWord; STDCALL;

    {
    Deactivate a measuring channel supervision

      In :  DoPEHdl    DoPE link handle

      Out :
           usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPESetCheckLimitIOSync ( DoPEHdl  : DoPE_HANDLE;
                                    Output   : WORD ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function  DoPESetCheckLimitIO ( DoPEHdl  : DoPE_HANDLE;
                                Output   : WORD;
                                usTAN    : PWord ): DWord; STDCALL;

    {
    Set / reset measuring channel supervision IO

      In :  DoPEHdl       DoPE link handle
            Output        0 = reset, 1 = set

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

{--------------------------------------------------------------------------}

function DoPEShieldLimitSync ( DoPEHdl    : DoPE_HANDLE;
                               SensorNo   : Word;
                               UprLock    : Double;
                               UprUnLock  : Double;
                               LwrUnLock  : Double;
                               LwrLock    : Double;
                               CtrlLimit  : Word;
                               SpeedLimit : Double;
                               CtrlAction : Word;
                               Action     : Word;
                               usTAN      : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEShieldLimit ( DoPEHdl    : DoPE_HANDLE;
                           SensorNo   : Word;
                           UprLock    : Double;
                           UprUnLock  : Double;
                           LwrUnLock  : Double;
                           LwrLock    : Double;
                           CtrlLimit  : Word;
                           SpeedLimit : Double;
                           CtrlAction : Word;
                           Action     : Word;
                           usTAN      : PWord ): DWord; STDCALL;

    {
    Activate the shield supervision

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEShieldEnableSync ( DoPEHdl : DoPE_HANDLE;
                                Enable  : DWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEShieldEnable ( DoPEHdl : DoPE_HANDLE;
                            Enable  : DWord;
                            usTAN   : PWord ) : DWord; STDCALL;

    {
    Activate / deactivate the shield supervision

      In :  DoPEHdl       DoPE link handle
            Enable        !=0  enables
                          0    disables shield supervision

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEShieldDisableSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEShieldDisable ( DoPEHdl : DoPE_HANDLE;
                             usTAN   : PWord ) : DWord; STDCALL;

    {
    Deactivate the shield supervision

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEShieldLockSync ( DoPEHdl : DoPE_HANDLE;
                              State   : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEShieldLock ( DoPEHdl  : DoPE_HANDLE;
                          State    : Word;
                          usTAN    : PWord ): DWord; STDCALL;
    {
    Lock or unlock the shield

      In :  DoPEHdl     DoPE link handle
            State       !=0  lock
                        0    unlock

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ------------------------------------------------------------------------- }
{                             Movement Commands                             }
{ --------------------------------------------------------------------------}

function  DoPEHaltSync ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEHalt ( DoPEHdl   : DoPE_HANDLE;
                     MoveCtrl  : Word;
                     usTAN     : PWord ): DWord; STDCALL;

    {
    Halt movement of crosshead in the specified control mode.
    Default deceleration will be used.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for halt

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ --------------------------------------------------------------------------}

function  DoPESHaltSync ( DoPEHdl : DoPE_HANDLE;
                          usTAN   : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESHalt ( DoPEHdl : DoPE_HANDLE;
                      usTAN   : PWord ): DWord; STDCALL;

{
    Halt movement of crosshead in position control mode.
    Instant start of deceleration (command value = mesured value).
    Default deceleration will be used.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}


{--------------------------------------------------------------------------}

function  DoPEHalt_ASync ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           Dec       : Double;
                           usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEHalt_A ( DoPEHdl   : DoPE_HANDLE;
                       MoveCtrl  : Word;
                       Dec       : Double;
                       usTAN     : PWord ): DWord; STDCALL;

    {
    Halt movement of crosshead in the specified control mode.
    Deceleration is a parameter of the command.
    After crosshead is halted, message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for halt
            Dec         Deceleration

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEHaltWSync    ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Delay     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEHaltW    ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Delay     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

    {
    Halt movement of crosshead in the specified control mode.
    Default deceleration will be used.
    After crosshead is halted and the specified delay time is over,
    a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for halt
            Delay       Delay time

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEHaltW_ASync  ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Dec       : Double;
                             Delay     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEHaltW_A  ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Dec       : Double;
                         Delay     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

   {
       Halt movement of crosshead in the specified control mode.
    Deceleration is a parameter of the command.
    After crosshead is halted and the specified delay time is over,
    a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for halt
            Dec         Deceleration
            Delay       Delay time

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEFMoveSync ( DoPEHdl   : DoPE_HANDLE;
                          Direction : Word;
                          MoveCtrl  : Word;
                          Speed     : Double;
                          usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEFMove ( DoPEHdl   : DoPE_HANDLE;
                      Direction : Word;
                      MoveCtrl  : Word;
                      Speed     : Double;
                      usTAN     : PWord ): DWord; STDCALL;

   {
    Move crosshead in the specified control mode and speed UP or DOWN.
    Default acceleration will be used.
    As an implicit limit of this command, softend's are used.

      In :  DoPEHdl     DoPE link handle
            Direction   Direction of movement
            MoveCtrl    Control mode of movement
            Speed       Speed for movement

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function  DoPEFMove_ASync ( DoPEHdl   : DoPE_HANDLE;
                            Direction : Word;
                            MoveCtrl  : Word;
                            Acc       : Double;
                            Speed     : Double;
                            usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEFMove_A ( DoPEHdl   : DoPE_HANDLE;
                        Direction : Word;
                        MoveCtrl  : Word;
                        Acc       : Double;
                        Speed     : Double;
                        usTAN     : PWord ): DWord; STDCALL;

    {
    Move crosshead in the specified control mode and speed UP or DOWN.
    Acceleration is a parameter of the command.
    As an implicit limit of this command, softend's are used.

      In :  DoPEHdl       DoPE link handle
            Direction     Direction of movement
            MoveCtrl      Control mode of movement
            Speed         Speed for movement

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEPosSync ( DoPEHdl     : DoPE_HANDLE;
                        MoveCtrl    : Word;
                        Speed       : Double;
                        Destination : Double;
                        usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPos ( DoPEHdl     : DoPE_HANDLE;
                    MoveCtrl    : Word;
                    Speed       : Double;
                    Destination : Double;
                    usTAN       : PWord ): DWord; STDCALL;

    {
    Move crosshead in the specified control mode and speed to the given
    destination. Default acceleration and deceleration will be used.
    After destination has been reached, a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Speed       Speed for positioning
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEPos_ASync ( DoPEHdl     : DoPE_HANDLE;
                          MoveCtrl    : Word;
                          Acc         : Double;
                          Speed       : Double;
                          Dec         : Double;
                          Destination : Double;
                          usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPos_A ( DoPEHdl     : DoPE_HANDLE;
                      MoveCtrl    : Word;
                      Acc         : Double;
                      Speed       : Double;
                      Dec         : Double;
                      Destination : Double;
                      usTAN       : PWord ): DWord; STDCALL;

   {
    Move crosshead in the specified control mode and speed to the given
    destination. Acceleration and deceleration are parameters of the command.
    After destination has been reached, a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Acc         Acceleration
            Speed       Speed for positioning
            Dec         Deceleration
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)

    }


{--------------------------------------------------------------------------}

function DoPEPosExtSync    ( DoPEHdl         : DoPE_HANDLE;
                             MoveCtrl        : Word;
                             Speed           : Double;
                             LimitMode       : Word;
                             Limit           : Double;
                             DestinationCtrl : Word;
                             Destination     : Double;
                             DestinationMode : Word;
                             usTAN           : PWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEPosExt    ( DoPEHdl         : DoPE_HANDLE;
                         MoveCtrl        : Word;
                         Speed           : Double;
                         LimitMode       : Word;
                         Limit           : Double;
                         DestinationCtrl : Word;
                         Destination     : Double;
                         DestinationMode : Word;
                         usTAN           : PWord) : DWord; STDCALL;

    {

    FUNCTION  NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Use instead of : DoPEPosG1, DoPEPosG2, DoPEPosD1, DoPEPosD2 !!

    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the limit position has been reached,
    a message will be transmitted.


      In :  DoPEHdl         DoPE link handle
            MoveCtrl        Control mode for positioning
            Speed           Speed for positioning
            LimitMode       Limit is a relative or absolute position
            Limit           Limit position
            DestinationCtrl Channel definition for destination
            Destination     Final destination
            DestinationMode Mode at destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEPosExt_ASync    ( DoPEHdl         : DoPE_HANDLE;
                               MoveCtrl        : Word;
                               Acc             : Double;
                               Speed           : Double;
                               DecLimit        : Double;
                               LimitMode       : Word;
                               Limit           : Double;
                               DestinationCtrl : Word;
                               DecDestination  : Double;
                               Destination     : Double;
                               DestinationMode : Word;
                               usTAN           : PWord ) : DWORD; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEPosExt_A    ( DoPEHdl         : DoPE_HANDLE;
                           MoveCtrl        : Word;
                           Acc             : Double;
                           Speed           : Double;
                           DecLimit        : Double;
                           LimitMode       : Word;
                           Limit           : Double;
                           DestinationCtrl : Word;
                           DecDestination  : Double;
                           Destination     : Double;
                           DestinationMode : Word;
                           usTAN           : PWord ) : DWORD; STDCALL;

    {

    FUNCTION NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!

    Use instead of : DoPEPosG1_A, DoPEPosG2_A, DoPEPosD1_A, DoPEPosD2_A !!

    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the limit position has been reached,
    a message will be transmitted.


      In :  DoPEHdl         DoPE link handle
            MoveCtrl        Control mode for positioning
            Acc             Acceleration
            Speed           Speed for positioning
            DecLimit        Deceleration for limit position
            LimitMode       Limit is a relative or absolute position
            Limit           absolute limit position
            DestinationCtrl Channel definition for destination
            DecDestination  Deceleration for final destination
            Destination     Final destination
            DestinationMode Mode at destination

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPETrigSync     ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed       : Double;
                             Limit       : Double;
                             TriggerCtrl : Word;
                             Trigger     : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPETrig     ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed       : Double;
                         Limit       : Double;
                         TriggerCtrl : Word;
                         Trigger     : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   {
    Move crosshead with the specified speed to the limit position.
    Acceleration and deceleration are parameters of the command.
    If the the trigger position is reached a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for moving
            Speed       Speed for moving
            Limit       Absolute limit position for movement
            TriggerCtrl Sensor number of trigger channel
            Trigger     Position

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPETrig_ASync   ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Acc         : Double;
                             Speed       : Double;
                             Dec         : Double;
                             Limit       : Double;
                             TriggerCtrl : Word;
                             Trigger     : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPETrig_A   ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Acc         : Double;
                         Speed       : Double;
                         Dec         : Double;
                         Limit       : Double;
                         TriggerCtrl : Word;
                         Trigger     : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   {
    Move crosshead with the specified speed to the limit position.
    Default acceleration and deceleration will be used.
    If the the trigger position is reached a message will be transmitted.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for moving
            Acc         Acceleration
            Speed       Speed for moving
            Dec         Deceleration
            Limit       Absolute limit position for movement
            TriggerCtrl Sensor number of trigger channel
            Trigger     Position

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEXpContSync   ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Limit     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEXpCont   ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Limit     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

  {
    Change control mode and continue movement in the new control mode
    with the actual speed.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement
            Limit       Limit position for movement

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

function  DoPEStartCMDSync ( DoPEHdl   : DoPE_HANDLE;
                             Cycles    : DWord;
                             ModeFlags : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEStartCMD ( DoPEHdl   : DoPE_HANDLE;
                         Cycles    : DWord;
                         ModeFlags : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   {
    Start of a combined movment command. Up to 10 simple moving commands
    may be sent after this command to specify a complex moving sequence.

      In :  DoPEHdl     DoPE link handle
            Cycles      Repeat combined moving command this number of cycles
            ModeFlags   Flags (see definition)

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEEndCMDSync   ( DoPEHdl   : DoPE_HANDLE;
                             Operation : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEEndCMD   ( DoPEHdl   : DoPE_HANDLE;
                         Operation : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   {
    End of combined moving command. With this command the first moving
    command inside this sequence will be started.

      In :  DoPEHdl     DoPE link handle
            Operation   Start or discard the sequence

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEExt2CtrlSync ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             OffsetCtrl   : Double;
                             SensorNo     : Word;
                             OffsetSensor : Double;
                             Mode         : Word;
                             Scale        : Double;
                             usTAN        : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEExt2Ctrl ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         OffsetCtrl   : Double;
                         SensorNo     : Word;
                         OffsetSensor : Double;
                         Mode         : Word;
                         Scale        : Double;
                         usTAN        : PWord ): DWord; STDCALL;

      {
      Move crosshead according to an external command signal.
      This command works not properly when DoPEConfPeekValue or one of the
      DoPEConfCMc commands are used.

      In :  DoPEHdl      DoPE link handle
            MoveCtrl     Control mode for positioning
            OffsetCtrl   Offset for move control channel
            SensorNo     Sensor number for the external command signal
            OffsetSensor Offset for external command signal
            Mode         various position or speed control modes
            Scale        Scaling factor for external command signal

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPEFDPotiSync ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           MaxSpeed  : Double;
                           SensorNo  : Word;
                           DxTrigger : Word;
                           Mode      : Word;
                           Scale     : Double;
                           usTAN     : PWord): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEFDPoti ( DoPEHdl   : DoPE_HANDLE;
                       MoveCtrl  : Word;
                       MaxSpeed  : Double;
                       SensorNo  : Word;
                       DxTrigger : Word;
                       Mode      : Word;
                       Scale     : Double;
                       usTAN     : PWord): DWord; STDCALL;

    {
    Move crosshead according to an external command signal generated by
    a digital encoder (DigiPoti).
    This is a special version of the DoPEExt2Ctrl command.
    Offsets and limits are handled inside this function.
    This command works not properly when DoPEConfPeekValue or one of the
    DoPEConfCMc commands are used.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            MaxSpeed    Speed offset for speed controlled modes
            SensorNo    Sensor Number for the external command input.
                        Use SENSOR_DP for Digital Encoder (DigiPoti)
                        on EDC frontpanel.
            DxTrigger   Dead area of encoder. The Encoder has to change
                        the specified number of digits before the command
                        is active.
                        For EDC frontpanel DigiPoti 2 or 3 is a good value.
            Mode        various position or speed control modes
            Scale       For EXT_POSITION Number of Units per revolution
                        eg. Scale =  1 -> 1 mm per revolution,
                            Scale = 10 -> 10 N per revolution
                        For EXT_SPEED_xx Number of revolutions to nominal speed
                        eg. Scale = 2  -> after 2 revolutions to nominal speed

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPECycleSync ( DoPEHdl     : DoPE_HANDLE;
                          MoveCtrl    : Word;
                          Speed1      : Double;
                          Dest1       : Double;
                          Halt1       : Double;
                          Speed2      : Double;
                          Dest2       : Double;
                          Halt2       : Double;
                          Cycles      : DWord;
                          Speed       : Double;
                          Destination : Double;
                          usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPECycle ( DoPEHdl     : DoPE_HANDLE;
                      MoveCtrl    : Word;
                      Speed1      : Double;
                      Dest1       : Double;
                      Halt1       : Double;
                      Speed2      : Double;
                      Dest2       : Double;
                      Halt2       : Double;
                      Cycles      : DWord;
                      Speed       : Double;
                      Destination : Double;
                      usTAN       : PWord ): DWord; STDCALL;

     {
      General cycle movement.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            Speed1      Maximum speed to reach destination 1
            Dest1       Destination 1
            Halt1       Halt time at destination 1
            Speed2      Maximum speed to reach destination 2
            Dest2       Destination 2
            Halt2       Halt time at destination 2
            Cycles      Number of cycles
            Speed       Speed to final destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPECosineSync  ( DoPEHdl     : DoPE_HANDLE;
                            MoveCtrl    : Word;
                            Speed1      : Double;
                            Dest1       : Double;
                            Dest2       : Double;
                            Frequency   : Double;
                            HalfCycles  : DWord;
                            Speed       : Double;
                            Destination : Double;
                            usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPECosine  ( DoPEHdl     : DoPE_HANDLE;
                        MoveCtrl    : Word;
                        Speed1      : Double;
                        Dest1       : Double;
                        Dest2       : Double;
                        Frequency   : Double;
                        HalfCycles  : DWord;
                        Speed       : Double;
                        Destination : Double;
                        usTAN       : PWord ): DWord; STDCALL;

   {
       Cosine movement.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            Speed1      Maximum speed to reach destination 1
            Dest1       Destination 1
            Dest2       Destination 2
            Frequency   Frequency
            HalfCycles  Number of half cycles
            Speed       Speed to final destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{-------------------------------------------------------------------------}

function DoPECosineXSync ( DoPEHdl     : DoPE_HANDLE;
                           MoveCtrl    : Word;
                           Speed1      : Double;
                           Dest1       : Double;
                           Halt1       : Double;
                           Dest2       : Double;
                           Halt2       : Double;
                           Frequency   : Double;
                           HalfCycles  : DWord;
                           Speed       : Double;
                           Destination : Double;
                           usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPECosineX ( DoPEHdl     : DoPE_HANDLE;
                       MoveCtrl    : Word;
                       Speed1      : Double;
                       Dest1       : Double;
                       Halt1       : Double;
                       Dest2       : Double;
                       Halt2       : Double;
                       Frequency   : Double;
                       HalfCycles  : DWord;
                       Speed       : Double;
                       Destination : Double;
                       usTAN       : PWord ): DWord; STDCALL;
    {
    Cosine movement with halt time at Destination 1 and 2

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            Speed1      Maximum speed to reach destination 1
            Dest1       Destination 1
            Halt1       Halt time at destination 1
            Dest2       Destination 2
            Halt2       Halt time at destination 2
            Frequency   Frequency
            HalfCycles  Number of half cycles
            Speed       Speed to final destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPECosinePeakCtrlSync ( DoPEHdl : DoPE_HANDLE;
                                  Mode    : Word;
                                  Dest1   : Double;
                                  Dest2   : Double;
                                  Cycles  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPECosinePeakCtrl ( DoPEHdl : DoPE_HANDLE;
                              Mode    : Word;
                              Dest1   : Double;
                              Dest2   : Double;
                              Cycles  : Word;
                              usTAN   : PWord ): DWord; STDCALL;

    {
    Activate pilot control for Cosine Command

      In :  DoPEHdl     DoPE link handle
            Mode        Mode for pilot control (see definition of constants)
            Dest1       Destination 1
            Dest2       Destination 2
            Cycles      pilot control is active every xx Cycles

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPETriangleSync ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed1      : Double;
                             Dest1       : Double;
                             Dest2       : Double;
                             Frequency   : Double;
                             HalfCycles  : DWord;
                             Speed       : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPETriangle ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed1      : Double;
                         Dest1       : Double;
                         Dest2       : Double;
                         Frequency   : Double;
                         HalfCycles  : DWord;
                         Speed       : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

    {
    Triangular movement.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            Speed1      Maximum speed to reach destination 1
            Dest1       Destination 1
            Dest2       Destination 2
            Frequency   Frequency
            HalfCycles  Number of half cycles
            Speed       Speed to final destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPERectangleSync ( DoPEHdl     : DoPE_HANDLE;
                              MoveCtrl    : Word;
                              Speed1      : Double;
                              Dest1       : Double;
                              Dest2       : Double;
                              Frequency   : Double;
                              HalfCycles  : DWord;
                              Speed       : Double;
                              Destination : Double;
                              usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPERectangle ( DoPEHdl     : DoPE_HANDLE;
                          MoveCtrl    : Word;
                          Speed1      : Double;
                          Dest1       : Double;
                          Dest2       : Double;
                          Frequency   : Double;
                          HalfCycles  : DWord;
                          Speed       : Double;
                          Destination : Double;
                          usTAN       : PWord ): DWord; STDCALL;

    {
    Rectangular movement.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for movement 
            Speed1      Maximum speed to reach destination 1
            Dest1       Destination 1
            Dest2       Destination 2
            Frequency   Frequency
            HalfCycles  Number of half cycles
            Speed       Speed to final destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

const
  DYN_WAVEFORM_COSINE        = 0;
  DYN_WAVEFORM_TRIANGLE      = 1;
  DYN_WAVEFORM_RECTANGLE     = 2;
  DYN_WAVEFORM_SAW_TOOTH     = 3;
  DYN_WAVEFORM_SAW_TOOTH_INV = 4;
  DYN_WAVEFORM_PULSE         = 5;


  { No sweep active                  }
  DYN_SWEEP_OFF                   = 0;
  
  { Linear sweep from e.g Frequency to SweepEndFrequency }
  DYN_SWEEP_LINEAR                = 1;
  
  { Logarithmic sweep from e.g Frequency to SweepEndFrequency }
  DYN_SWEEP_LOGARITHMIC           = 2;
  
  { Linear sweep at Start, and End of cycles }
  DYN_SWEEP_LINEAR_START_END      = 3;
  
  { Logarithmic sweep at Start, and End of cycles }
  DYN_SWEEP_LOGARITHMIC_START_END = 4;

   
  { No superposition active }
  DYN_SUPERPOS_OFF       = 0;
  
  { Superposition active }
  DYN_SUPERPOS_ON        = 1;


  { No bimodal control active }
  DYN_BIMODAL_CTRL_OFF               = 0;

  { Keep arithmetic mean value of second sensor constant by changing the offset of the controlled sensor       }
  DYN_BIMODAL_ARITHMETIC_MEAN_VALUE  = 1;

  { Keep the mean value of second sensor constant by changing the offset of the controlled sensor              }
  DYN_BIMODAL_MEAN_VALUE             = 2;

  { Keep the minimum value of second sensor constant by changing the offset of the controlled sensor           }
  DYN_BIMODAL_MIN_VALUE              = 3;

  { Keep the maximum value of second sensor constant by changing the offset of the controlled sensor           }
  DYN_BIMODAL_MAX_VALUE              = 4;

  { Keep the amplitude of second sensor constant by changing the offset and amplitude of the controlled sensor }
  DYN_BIMODAL_AMPLITUDE_OFFSET_VAR   = 5;

  { Keep the amplitude of second sensor constant by changing the amplitude of the controlled sensor. 
    The offset of the controlled sensor is constant                                                            }
  DYN_BIMODAL_AMPLITUDE_OFFSET_CONST = 6;


function DoPEDynCyclesSync ( DoPEHdl                 : DoPE_HANDLE;
                             WaveForm                : Word;
                             Modify                  : Word;
                             PeakCtrl                : Word;
                             MoveCtrl                : Word;
                             RelativeDestination     : Word;
                             SpeedToStart            : Double;
                             Offset                  : Double;
                             Amplitude               : Double;
                             HaltAtPlusAmplitude     : Double;
                             HaltAtMinusAmplitude    : Double;
                             Frequency               : Double;
                             HalfCycles              : DWord;
                             SpeedToDestination      : Double;
                             Destination             : Double;
                             SweepFrequencyMode      : Word;
                             SweepEndFrequency       : Double;
                             SweepFrequencyTime      : Double;
                             SweepFrequencyCount     : DWord;
                             SweepOffsetMode         : DWord;
                             SweepEndOffset          : Double;
                             SweepOffsetTime         : Double;
                             SweepOffsetCount        : DWord;
                             SweepAmplitudeMode      : Word;
                             SweepEndAmplitude       : Double;
                             SweepAmplitudeTime      : Double;
                             SweepAmplitudeCount     : DWord;
                             SuperpositionMode       : Word;
                             SuperpositionFrequency  : Double;
                             SuperpositionAmplitude  : Double;
                             BimodalCtrlMode         : Word;
                             BimodalCtrlSensor       : Word;
                             BimodalValue1           : Double;
                             BimodalValue2           : Double;
                             BimodalScale            : Double;
                             usTAN                   : PWord ): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEDynCycles ( DoPEHdl                 : DoPE_HANDLE;
                         WaveForm                : Word;
                         Modify                  : Word;
                         PeakCtrl                : Word;
                         MoveCtrl                : Word;
                         RelativeDestination     : Word;
                         SpeedToStart            : Double;
                         Offset                  : Double;
                         Amplitude               : Double;
                         HaltAtPlusAmplitude     : Double;
                         HaltAtMinusAmplitude    : Double;
                         Frequency               : Double;
                         HalfCycles              : DWord;
                         SpeedToDestination      : Double;
                         Destination             : Double;
                         SweepFrequencyMode      : Word;
                         SweepEndFrequency       : Double;
                         SweepFrequencyTime      : Double;
                         SweepFrequencyCount     : DWord;
                         SweepOffsetMode         : DWord;
                         SweepEndOffset          : Double;
                         SweepOffsetTime         : Double;
                         SweepOffsetCount        : DWord;
                         SweepAmplitudeMode      : Word;
                         SweepEndAmplitude       : Double;
                         SweepAmplitudeTime      : Double;
                         SweepAmplitudeCount     : DWord;
                         SuperpositionMode       : Word;
                         SuperpositionFrequency  : Double;
                         SuperpositionAmplitude  : Double;
                         BimodalCtrlMode         : Word;
                         BimodalCtrlSensor       : Word;
                         BimodalValue1           : Double;
                         BimodalValue2           : Double;
                         BimodalScale            : Double;
                         usTAN                   : PWord ): DWord; STDCALL;

    {
    Dynamic cycles.

      In :  DP                      DoPE link handle
            WaveForm                Cosine, Triagular, Rectangular
            Modify                  Modify Parameter of active cycles
            PeakCtrl                Peak control cycles 0, 1,2,4,8,16

            MoveCtrl                Control mode for movement 
            RelativeDestination     false, Offset, and Destination absolute
                                    true, Offset, and Destination relative
            SpeedToStart            Speed to Offset + Amplitude
            Offset                  Offset
            Amplitude               Amplitude
            HaltAtPlusAmplitude     Halt Time at Offset + Amplitude
            HaltAtMinusAmplitude    Halt Time at Offset - Amplitude
            Frequency               Frequency
            HalfCycles              Number of half cycles
            SpeedToDestination      Speed to final destination (0=automatic speed calculation)
            Destination             Final destination

            SweepFrequencyMode      Off, Linear, Logarithmic
            SweepEndFrequency       End frequency for frequency sweep
            SweepFrequencyTime      Time for frequency sweep
            SweepFrequencyCount     Frequency sweep counter (0=infinitive)

            SweepOffsetMode         Off, Linear, Logarithmic
            SweepEndOffset          Second offset for offset sweep
            SweepOffsetTime         Time for offset sweep
            SweepOffsetCount        Offset sweep counter (0=infinitive)

            SweepAmplitudeMode      Off, Linear, Logarithmic
            SweepEndAmplitude       Second amplitude for amplitude sweep
            SweepAmplitudeTime      Time for amplitude sweep
            SweepAmplitudeCount     Amplitude sweep counter (0=infinitive)

            SuperpositionMode       Superposition Mode 
            SuperpositionFrequency  Superposition Frequency
            SuperpositionAmplitude  Superposition Amplitude

            BimodalCtrlMode         Mode for bimodal control
            BimodalCtrlSensor       Sensor for bimodal control
            BimodalValue1           Value1 to keep constant
            BimodalValue2           Value2 only used for DYN_AUX_AMPLITUDE_OFFSET_VAR
            BimodalScale            Scale

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPESpeedLimitSync ( DoPEHdl : DoPE_HANDLE;
                              Ctrl    : Word;
                              Speed   : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESpeedLimit ( DoPEHdl     : DoPE_HANDLE;
                          Ctrl        : Word;
                          Speed       : Double;
                          usTAN       : PWord ) : DWord; STDCALL;

    {
    Set speed limit.

      In :  DoPEHdl     DoPE link handle
            Ctrl        Control mode 
            Speed       Maximum speed

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEOffsCSync ( DoPEHdl   : DoPE_HANDLE;
                          Speed     : Double;
                          PosDiff   : Double;
                          usTAN     : PWord): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEOffsC ( DoPEHdl   : DoPE_HANDLE;
                      Speed     : Double;
                      PosDiff   : Double;
                      usTAN     : PWord): DWord; STDCALL;

  {
    Special moving command to measure the offset of an external, analogue
    speed controller. This offset will be used for the speed output signal
    and compensates the offset of the external speed controller.

      In :  DoPEHdl     DoPE link handle
            Speed       Maximum speed
            PosDiff     Distance to move crosshead

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEDefaultAccSync ( DoPEHdl   : DoPE_HANDLE;
                               MoveCtrl  : Word;
                               Acc       : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDefaultAcc ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           Acc       : Double;
                           usTAN     : PWord ): DWord; STDCALL;

  {
      Set default acceleration (and deceleration) for all moving commands.
    After initialization default and nominal acceleration are identical.


      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode 
            Acc         Acceleration

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

function  DoPESetCtrlSync ( DoPEHdl   : DoPE_HANDLE;
                            State     : Word;
                            usTAN     : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetCtrl ( DoPEHdl   : DoPE_HANDLE;
                        State     : Word;
                        usTAN     : PWord ): DWord; STDCALL;

    {
    Activate / deactivate stop state.

      In :  DoPEHdl     DoPE link handle
            Status      TRUE:  stop state (reset drive free)
                        FALSE: free state (set   drive free)

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEEmergencyMoveSync ( DoPEHdl   : DoPE_HANDLE;
                                  State     : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEEmergencyMove ( DoPEHdl   : DoPE_HANDLE;
                              State     : Word;
                              usTAN     : PWord ): DWord; STDCALL;

    {
    Activate / deactivate emergency movement.
    Emergency movement is used to move crosshead if the hardware limit
    switch is active. (Not supported on EDC5/25)


      In :  DoPEHdl     DoPE link handle
            State       !=0  on
                        0    off

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEEmergencyOffSync ( DoPEHdl   : DoPE_HANDLE;
                                 Status    : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEEmergencyOff ( DoPEHdl   : DoPE_HANDLE;
                             Status    : Word;
                             usTAN     : PWord ): DWord; STDCALL;

    {
    Activate / deactivate EmergencyOff state.

      In :  DoPEHdl     DoPE link handle
            Status      TRUE:  Activate emergency off
                        FALSE: Deactivate emergency off

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}
{                           Controller Parameters                           }
{---------------------------------------------------------------------------}

function DoPEPosPIDSync ( DoPEHdl  : DoPE_HANDLE;
                          MoveCtrl : Word;
                          PosP     : DWord;
                          PosI     : Word;
                          PosD     : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEPosPID ( DoPEHdl  : DoPE_HANDLE;
                      MoveCtrl : Word;
                      PosP     : DWord;
                      PosI     : Word;
                      PosD     : Word;
                      usTAN    : PWord ) : DWord; STDCALL;

    {
    Set parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdPosPID ( DoPEHdl      : DoPE_HANDLE;
                        MoveCtrl     : Word;
                        HighPressure : DWord;
                    var PosP         : DWord;
                    var PosI         : Word;
                    var PosD         : Word ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Get parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            PosP          Pointer for gain      (kv-Factor)
            PosI          Pointer for Integration time constant
            PosD          Pointer for Time constant

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrPosPIDSync ( DoPEHdl      : DoPE_HANDLE;
                            MoveCtrl     : Word;
                            HighPressure : DWord;
                            PosP         : DWord;
                            PosI         : Word;
                            PosD         : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEWrPosPID ( DoPEHdl      : DoPE_HANDLE;
                        MoveCtrl     : Word;
                        HighPressure : DWord;
                        PosP         : DWord;
                        PosI         : Word;
                        PosD         : Word;
                        usTAN        : PWord ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Set parameter for closed loop position controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPESpeedPIDSync ( DoPEHdl  : DoPE_HANDLE;
                            MoveCtrl : Word;
                            SpeedP   : DWord;
                            SpeedI   : Word;
                            SpeedD   : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPESpeedPID ( DoPEHdl  : DoPE_HANDLE;
                        MoveCtrl : Word;
                        SpeedP   : DWord;
                        SpeedI   : Word;
                        SpeedD   : Word;
                        usTAN    : PWord ) : DWord; STDCALL;

    {
    Set parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            SpeedP             gain      (kv-Factor)
            SpeedI        Integration time constant
            SpeedD        Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSpeedPID ( DoPEHdl      : DoPE_HANDLE;
                          MoveCtrl     : Word;
                          HighPressure : DWord;
                      var SpeedP       : DWord;
                      var SpeedI       : Word;
                      var SpeedD       : Word ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Get parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedP          Pointer for gain      (kv-Factor)
            SpeedI          Pointer for Integration time constant
            SpeedD          Pointer for Time constant

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSpeedPIDSync ( DoPEHdl      : DoPE_HANDLE;
                              MoveCtrl     : Word;
                              HighPressure : DWord;
                              SpeedP       : DWord;
                              SpeedI       : Word;
                              SpeedD       : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEWrSpeedPID ( DoPEHdl      : DoPE_HANDLE;
                          MoveCtrl     : Word;
                          HighPressure : DWord;
                          SpeedP       : DWord;
                          SpeedI       : Word;
                          SpeedD       : Word;
                          usTAN        : PWord ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Set parameter for closed loop speed controller.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedP        gain      (kv-Factor)
            SpeedI        Integration time constant
            SpeedD        Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function  DoPECurrentPIDSync ( DoPEHdl  : DoPE_HANDLE;
                               Output   : Word;
                               P        : DWord;
                               I        : Word;
                               D        : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function  DoPECurrentPID ( DoPEHdl  : DoPE_HANDLE;
                           Output   : Word;
                           P        : DWord;
                           I        : Word;
                           D        : Word;
                           usTAN    : PWord ) : DWord; STDCALL;

    {
    Set parameter for the external current closed loop controller.

      In :  DoPEHdl       DoPE link handle
            Output        Number of the output channel (COMMAND_OUT, OUT_1,...)
            PosP          gain      (kv-Factor)
            PosI          Integration time constant
            PosD          Time constant

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEPosFeedForwardSync ( DoPEHdl  : DoPE_HANDLE;
                                  MoveCtrl : Word;
                                  PosFFP   : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEPosFeedForward ( DoPEHdl  : DoPE_HANDLE;
                              MoveCtrl : Word;
                              PosFFP   : DWord;
                              usTAN    : PWord ) : DWord; STDCALL;

    {
    Set parameter for Positiongenerator derivate part.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            PosFFP        gain for derivate part

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEFeedForwardSync ( DoPEHdl    : DoPE_HANDLE;
                               MoveCtrl   : Word;
                               SpeedFFP   : Word;
                               PosDelay   : Word;
                               AccFFP     : Word;
                               SpeedDelay : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEFeedForward ( DoPEHdl    : DoPE_HANDLE;
                           MoveCtrl   : Word;
                           SpeedFFP   : Word;
                           PosDelay   : Word;
                           AccFFP     : Word;
                           SpeedDelay : Word;
                           usTAN      : PWord ) : DWord; STDCALL;

    {
    Set feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            SpeedFFP      FeedForward for Speed in %
            PosDelay      Delay for Position command
            AccFFP        FeedForward for Acc in %
            SpeedDelay    Delay for Speed command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdFeedForward ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             HighPressure : DWord;
                         var SpeedFFP     : Word;
                         var PosDelay     : Word;
                         var AccFFP       : Word;
                         var SpeedDelay   : Word ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Get feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedFFP      Pointer for FeedForward for Speed in %
            PosDelay      Pointer for Delay for Position command
            AccFFP        Pointer for FeedForward for Acc in %
            SpeedDelay    Pointer for Delay for Speed command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrFeedForwardSync ( DoPEHdl      : DoPE_HANDLE;
                                 MoveCtrl     : Word;
                                 HighPressure : DWord;
                                 SpeedFFP     : Word;
                                 PosDelay     : Word;
                                 AccFFP       : Word;
                                 SpeedDelay   : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEWrFeedForward ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             HighPressure : DWord;
                             SpeedFFP     : Word;
                             PosDelay     : Word;
                             AccFFP       : Word;
                             SpeedDelay   : Word;
                             usTAN        : PWord ) : DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.71 (of higher)  !!

    Set feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            HighPressure  !=0  get parameter for high pressure
                          0    get parameter for low pressure
            SpeedFFP      FeedForward for Speed in %
            PosDelay      Delay for Position command
            AccFFP        FeedForward for Acc in %
            SpeedDelay    Delay for Speed command

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

const
  OPTIMIZE_COSINE    = 0;
  OPTIMIZE_TRIANGLE  = 1;
  OPTIMIZE_RECTANGLE = 2;

function DoPEOptimizeFeedForwardSync ( DoPEHdl    : DoPE_HANDLE;
                                       MoveCtrl   : Word;
                                       Mode       : Word;
                                       Offset     : Double;
                                       Amplitude  : Double;
                                       Frequency  : Double;
                                       usTAN      : PWord )   : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEOptimizeFeedForward ( DoPEHdl    : DoPE_HANDLE;
                                   MoveCtrl   : Word;
                                   Mode       : Word;
                                   Offset     : Double;
                                   Amplitude  : Double;
                                   Frequency  : Double;
                                   usTAN      : PWord )   : DWord; STDCALL;

    {
    Optimize feed forward parameter.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode 
            Mode          Cosine, triangle, rectangle (see OPTIMIZE_ defines)
            Amplitude     Amplitude
            Frequency     Frequency

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEDestWndSync ( DoPEHdl   : DoPE_HANDLE;
                            MoveCtrl  : Word;
                            WndSize   : Double;
                            WndTime   : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDestWnd ( DoPEHdl   : DoPE_HANDLE;
                        MoveCtrl  : Word;
                        WndSize   : Double;
                        WndTime   : Double;
                        usTAN     : PWord ): Dword; STDCALL;

      {
      Definitions for destination window.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode 
            WndSize     Size of destination window
            WndTime     Time for destination window

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPESftSync ( DoPEHdl   : DoPE_HANDLE;
                        MoveCtrl  : Word;
                        UpperSft  : Double;
                        LowerSft  : Double;
                        Reaction  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESft ( DoPEHdl   : DoPE_HANDLE;
                    MoveCtrl  : Word;
                    UpperSft  : Double;
                    LowerSft  : Double;
                    Reaction  : Word;
                    usTAN     : PWord ): DWord; STDCALL;

     {
      Definitions of limits supervised by software (softend)

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode 
            UpperSft    Upper soft limit
            LowerSft    Lower soft limit
            Reaction    Action to be activated after softend is reached

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPECtrlErrorSync ( DoPEHdl   : DoPE_HANDLE;
                              MoveCtrl  : Word;
                              Error     : Double;
                              Reaction  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPECtrlError ( DoPEHdl   : DoPE_HANDLE;
                          MoveCtrl  : Word;
                          Error     : Double;
                          Reaction  : Word;
                          usTAN     : PWord ): DWord; STDCALL;

      {
      Define maximum error signal for closed loop controller

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode 
            Error       Maximum error signal
            Reaction    Action to be activated after error is reached

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPECtrlSpeedTimeBaseSync ( DoPEHdl  : DoPE_HANDLE;
                                      Time     : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPECtrlSpeedTimeBase ( DoPEHdl  : DoPE_HANDLE;
                                  Time     : Double;
                                  usTan    : PWord ): DWord; STDCALL;

    {
    Define Time Base for Speeddetection inside Close Loop Controller

      In :  DoPEHdl     DoPE link handle
            Time        Timebase in s

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEDeadbandCtrlSync ( DoPEHdl  : DoPE_HANDLE;
                                 MoveCtrl : word;
                                 Deadband : Double;
                                 PercentP : word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDeadbandCtrl ( DoPEHdl  : DoPE_HANDLE;
                             MoveCtrl : word;
                             Deadband : Double;
                             PercentP : word;
                             usTan    : PWord ): DWord; STDCALL;

    {
    FUNCTION REQUIRES PE-Interface Version 2.79 (or higher)  !!

    Set parameter for error dead band controller.
    PosP is reduced by a ramp from PosP(100%) to PercentP.

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Deadband      Width of error deadband around setpoint 
            PercentP      Smallest P inside deadband in % of PosP
                          PercentP range is 0..100% 
                          (100% disables error dead band controller)

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPESetNominalAccSpeedSync ( DoPEHdl  : DoPE_HANDLE;
                                       MoveCtrl : word;
                                       Acc      : Double;
                                       Speed    : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetNominalAccSpeed ( DoPEHdl  : DoPE_HANDLE;
                                   MoveCtrl : word;
                                   Acc      : Double;
                                   Speed    : Double;
                                   usTan    : PWord ): DWord; STDCALL;

    {
    Set nominal values for position generator

      In :  DoPEHdl       DoPE link handle
            MoveCtrl      Control mode
            Acc           default acceleration
            Speed         speed limit

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }
    
    
{--------------------------------------------------------------------------}

function  DoPESetOpenLoopCommandSync ( DoPEHdl  : DoPE_HANDLE;
                                       Command  : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetOpenLoopCommand ( DoPEHdl  : DoPE_HANDLE;
                                   Command  : Double;
                                   usTan    : PWord ): DWord; STDCALL;

    {
    Set output in open loop mode

      In :  DoPEHdl       DoPE link handle
            Command       Command value in % of nominal output value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}
{                           Requests for Information                        }
{---------------------------------------------------------------------------}

function DoPERdVersion ( DoPEHdl : DoPE_HANDLE;
                     var Version : DoPEVersion): DWord; STDCALL;
function DoPEwRdVersion ( DoPEHdl : DoPE_HANDLE;
                      var Version : DoPEwVersion): DWord; STDCALL;

    {
    Read Version strings.

      In :  DoPEHdl     DoPE link handle
            Version     Version strings

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------- }

{ ------ Constants  for 'status' in  DoPEModuleInfo ------------------------ }

const
  MODSTAT_OK         = 0;       { Module is ready to operate            }
  MODSTAT_HWFAIL     = 3;       { Hardware error on module              }
  MODSTAT_NOMODULE   = 6;       { Module not present                    }
  MODSTAT_NODRIVER   = 9;       { No driver for module                  }
  MODSTAT_REMOTE     = 10;      { Remote-Module                         }
  MODSTAT_SWFAIL     = $FFFF;   { Error in  Module-driver-software      }

function DoPERdModuleInfo ( DoPEHdl  : DoPE_HANDLE;
                            ModulNo  : DWord;
                        var Info     : DoPEModuleInfo) : DWord; STDCALL;

function DoPEwRdModuleInfo ( DoPEHdl  : DoPE_HANDLE;
                             ModulNo  : DWord;
                         var Info     : DoPEwModuleInfo) : DWord; STDCALL;

 {
    Read module info.

      In :  DoPEHdl     DoPE link handle
            ModuleNo    Module number ( 0 .. MAX_MODULE-1 )
            Info        Pointer to storage for the module info

      Returns:          Error constant (DoPERR_xxxx)
 }


{---------------------------------------------------------------------------}

function  DoPERdDriveInfo ( DoPEHdl   : DoPE_HANDLE;
                            Connector : Word;
                        var Info      : DoPEDriveInfo) : DWord; STDCALL;

function  DoPEwRdDriveInfo ( DoPEHdl   : DoPE_HANDLE;
                             Connector : Word;
                         var Info      : DoPEwDriveInfo) : DWord; STDCALL;

    {
    Read drive info.

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of output
            Info        Pointer to storage for the drive info

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEwRdLanguageInfo ( DoPEHdl   : DoPE_HANDLE;
                            var Info      : DoPEwLanguageInfo) : DWord; STDCALL;

    {
    Read language info.

      In :  DoPEHdl     DoPE link handle                            
            Info        Pointer to storage for the language info

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEOnSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEOn ( DoPEHdl : DoPE_HANDLE;
                  usTAN   : PWord): DWord; STDCALL;

   {
    Activate drive (only for EDC5/25). On EDC100 systems the drive is activated
    by the "ON" push button at the EDC100.

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

function DoPEOffSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEOff ( DoPEHdl    : DoPE_HANDLE;
                   usTANFirst : PWord;
                   usTANLast  : PWord): DWord; STDCALL;

    {
    Deactivate drive.

      In :  DoPEHdl    DoPE link handle

      Out :
            usTANFirst Pointer to first TAN used from this command
            usTANLast  Pointer to last TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPECalOutSync ( DoPEHdl : DoPE_HANDLE;
                          Cal     : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPECalOut ( DoPEHdl     : DoPE_HANDLE;
                      Cal         : Word;
                      usTAN       : PWord ): DWord; STDCALL;
    {
      In :  DoPEHdl     DoPE  link handle
            Cal         TRUE  activate Calibration output
                        FALSE deactivate Calibration output

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEBeepSync ( DoPEHdl : DoPE_HANDLE;
                         Beep    : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEBeep ( DoPEHdl : DoPE_HANDLE;
                     Beep    : Word;
                     usTAN   : PWord ): DWord; STDCALL;

     {
      In :  DoPEHdl     DoPE  link handle
            Beep        TRUE  activate Beep
                        FALSE deactivate Beep

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPELedSync ( DoPEHdl  : DoPE_HANDLE;
                        LedOn    : Word;
                        LedOff   : Word;
                        LedFlash : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPELed ( DoPEHdl  : DoPE_HANDLE;
                    LedOn    : Word;
                    LedOff   : Word;
                    LedFlash : Word;
                    usTAN    : PWord ): DWord; STDCALL;

     {
     Switch On/Off LED's at EDC frontpanel.

      In :  DoPEHdl     DoPE link handle
            LedOn       These LED's will be set
            LedOff      These LED's will be reset
            LedFlash    These LED's 'flash'

            The three data words will be processed in the following
            sequence (important with conflicting data):
            1.) Flashing LED's.
            2.) Resetting of the LED's.
            3.) Setting of the LED's.

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPEUniOutSync ( DoPEHdl : DoPE_HANDLE;
                           Output  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEUniOut ( DoPEHdl : DoPE_HANDLE;
                       Output  : Word;
                       usTAN   : PWord): DWord; STDCALL;

      {
      Activate/Deactivate universal digital output bits at EDC100.

      In :  DoPEHdl     DoPE link handle
            Output                      Bit 0 .. 3 represent the four digital outputs.

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPEBypassSync ( DoPEHdl : DoPE_HANDLE;
                           Bypass  : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEBypass ( DoPEHdl : DoPE_HANDLE;
                       Bypass  : Word;
                       usTAN   : PWord): DWord; STDCALL;

      {
      Activate/Deactivate bypass output.

      In :  DoPEHdl     DoPE  link handle
            Bypass      TRUE  activates bypass output
                                                        FALSE deactivates bypass output

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{ ------------------------------------------------------------------------- }
{                Display Instructions (Only on EDC-Systems)                 }
{ ------------------------------------------------------------------------- }

function  DoPEDspClearSync  ( DoPEHdl   : DoPE_HANDLE ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDspClear      ( DoPEHdl   : DoPE_HANDLE;
                              usTAN     : PWord ): DWord; STDCALL;

    {
    Clear LCD-display at EDC frontpanel

      In :  DoPEHdl     DoPE link handle

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

const
   DSP_HEADLINE_LEN = 22;             { number of characters in headline      }
                                      { (including terminating zero '\0')     }
                                      
function  DoPEDspHeadLineSync ( DoPEHdl   : DoPE_HANDLE;
                                HeadLine  : PChar ): DWord; STDCALL;
function  DoPEwDspHeadLineSync ( DoPEHdl   : DoPE_HANDLE;
                                 HeadLine  : PWideChar ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDspHeadLine ( DoPEHdl   : DoPE_HANDLE;
                            HeadLine  : PChar;
                            usTAN     : PWord ): DWord; STDCALL;
function  DoPEwDspHeadLine ( DoPEHdl   : DoPE_HANDLE;
                             HeadLine  : PWideChar;
                             usTAN     : PWord ): DWord; STDCALL;

     {
      Display headline on LCD-display at EDC frontpanel

      In :  DoPEHdl     DoPE link handle
            HeadLine    Character string

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

const
   DSP_FKEYSLINE_LEN = 22;            { number of characters in FKeys line    }
                                      { (including terminating zero '\0')     }
                                      
function  DoPEDspFKeysSync    ( DoPEHdl   : DoPE_HANDLE;
                                FKeys     : PChar ): DWord; STDCALL;
function  DoPEwDspFKeysSync    ( DoPEHdl   : DoPE_HANDLE;
                                 FKeys     : PWideChar ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDspFKeys    ( DoPEHdl   : DoPE_HANDLE;
                            FKeys     : PChar;
                            usTAN     : PWord ): DWord; STDCALL;
function  DoPEwDspFKeys    ( DoPEHdl   : DoPE_HANDLE;
                             FKeys     : PWideChar;
                             usTAN     : PWord ): DWord; STDCALL;

     {
     Display function keys on LCD-display at EDC frontpanel


      In :  DoPEHdl     DoPE link handle
            FKeys       Character string

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

const
   DSP_VALUE_LEN = 10;                { number of characters in Value field   }
                                      { (including terminating zero '\0')     }
   DSP_DIM_LEN   = 7;                 { number of characters in Dim field     }
                                      { (including terminating zero '\0')     }

function  DoPEDspMValueSync   ( DoPEHdl   : DoPE_HANDLE;
                                Value1    : PChar;
                                Value2    : PChar;
                                Dim1      : PChar;
                                Dim2      : PChar ): DWord; STDCALL;
function  DoPEwDspMValueSync   ( DoPEHdl   : DoPE_HANDLE;
                                 Value1    : PWideChar;
                                 Value2    : PWideChar;
                                 Dim1      : PWideChar;
                                 Dim2      : PWideChar ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDspMValue   ( DoPEHdl   : DoPE_HANDLE;
                            Value1    : PChar;
                            Value2    : PChar;
                            Dim1      : PChar;
                            Dim2      : PChar;
                            usTAN     : PWord): DWord; STDCALL;
function  DoPEwDspMValue   ( DoPEHdl   : DoPE_HANDLE;
                             Value1    : PWideChar;
                             Value2    : PWideChar;
                             Dim1      : PWideChar;
                             Dim2      : PWideChar;
                             usTAN     : PWord): DWord; STDCALL;

     {
     Display data and dimensions on LCD-display at EDC frontpanel


      In :  DoPEHdl     DoPE link handle
            Value1      Character string for first value
            Value2      Character string for second value
            Dim1        Character string for first dimension
            Dim2        Character string for second dimension
                        ( Strings are zero terminated '\0' )

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }

{--------------------------------------------------------------------------}

function DoPEDspBeamScreenSync ( DoPEHdl : DoPE_HANDLE;
                                 Value   : SmallInt ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEDspBeamScreen ( DoPEHdl    : DoPE_HANDLE;
                             Value      : SmallInt;
                             usTAN      : PWord): DWord; STDCALL;

    {
    Display frame & beam on LCD-display at EDC frontpanel


      In :  DoPEHdl     DoPE link handle
            Value       Value of the beam in %

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function DoPEDspBeamValueSync ( DoPEHdl  : DoPE_HANDLE;
                                Value    : SmallInt ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEDspBeamValue ( DoPEHdl : DoPE_HANDLE;
                            Value   : SmallInt;
                            usTAN   : PWord): DWord; STDCALL;

    {
    Display beam on LCD-display at EDC frontpanel


      In :  DoPEHdl     DoPE link handle
            Value       Value of the beam in %

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{----------------------------------------------------------------------------}

function DoPESetRefSignalMode ( DoPEHdl  : DoPE_HANDLE;
                                SensorNo : Word;
                                Mode     : Word;
                                usTAN    : PWord) : DWord; STDCALL;

    {
    Set the reference signal mode.

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            Mode        reference signal messages will be reported:
                        REFSIG_NON:  never
                        REFSIG_ON:   allways
                        REFSIG_ONCE: only once

      Out : usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

const
  REFSIG_NON   = 0;
  REFSIG_ON    = 1;
  REFSIG_ONCE  = 2;


{----------------------------------------------------------------------------}

function DoPESetRefSignalTare ( DoPEHdl  : DoPE_HANDLE;
                                SensorNo : Word;
                                Mode     : Word;
                                Tare     : Double;
                                usTAN    : PWord ) : DWord; STDCALL;

    {
    Set the measuring channel to the tare value at the next occurance of the
    reference signal.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode = 1      At the next reference signal the measuring channel
                          will be set to the tare value.
                 = 0      Reference signals don't affect the measuring channel.
            Tare          Value for the measuring channel

      Tare value will be stored in EDC's non volatile BasicTare memory.
      This function clears the current basic tare and ordinary tare value
      at the next occurance of the reference signal.

      Out : usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

const
  REFSIG_TARE   = 0;


{--------------------------------------------------------------------------}

function DoPESetBasicTareSync ( DoPEHdl    : DoPE_HANDLE;
                                SensorNo   : Word;
                                Mode       : Word;
                                BasicTare  : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPESetBasicTare ( DoPEHdl    : DoPE_HANDLE;
                            SensorNo   : Word;
                            Mode       : Word;
                            BasicTare  : Double;
                            usTANFirst : PWord;
                            usTANLast  : PWord ): DWord; STDCALL;

{
    Set basic tare of the measuring channel

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          BASICTARE_SET:
                            BasicTare represents the desired measuring value.
                            This is useful to set crosshead position for systems
                            with encoder.
                          BASICTARE_SUBTRACT
                            BasicTare will be subtracted.
                            This is usefull to compensate the weight of grips.
            BasicTare     Value for BasicTare

      BasicTare value will be stored in EDC's non volatile memory.
      This function clears the ordinary tare value.

      Out:
            *lpusTANFirst Pointer to first TAN used from this command
            *lpusTANLast  Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}

{ -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

const
  BASICTARE_SET       = 0;
  BASICTARE_SUBTRACT  = 1;

{--------------------------------------------------------------------------}

function DoPESetTare ( DoPEHdl    : DoPE_HANDLE;
                       SensorNo   : Word;
                       Tare       : Double ) : DWord; STDCALL;

{
    Set tare of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            Tare        Value to be subtracted.


      Returns:          Error constant (DoPERR_xxxx)
}


{--------------------------------------------------------------------------}

function DoPEGetBasicTare ( DoPEHdl    : DoPE_HANDLE;
                            SensorNo   : Word;
                        var BasicTare  : Double ): DWord; STDCALL;

    {
    Read tare value of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *BasicTare  Pointer for BasicTare

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------}

function DoPEGetTare ( DoPEHdl  : DoPE_HANDLE;
                       SensorNo : Word;
                   var Tare     : Double ): DWord; STDCALL;

    {
    Read tare value of the measuring channel

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *Tare       Pointer for tare

      Returns:          Error constant (DoPERR_xxxx)
    }


{ ------------------------------------------------------------------------- }
{                   Read Messages received from Subsystem                   }
{ ------------------------------------------------------------------------- }

function DoPERdSensorInfo ( DoPEHdl  : DoPE_HANDLE;
                            SensorNo : Word;
                        var Info     : DoPESumSenInfo ): DWord; STDCALL;

    {
    Read summary sensor informations

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *Info       Pointer for SumSenInfo structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorDef ( DoPEHdl   : DoPE_HANDLE;
                           SensorNo  : Word;
                       var SensorDef : DoPESenDef ): DWord; STDCALL;

    {
    Read sensor definitions

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SensorDef  Pointer for DoPESenDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdCtrlSensorDef ( DoPEHdl       : DoPE_HANDLE;
                               SensorNo      : Word;
                           var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;

function DoPERdCtrlSensorDefHigh ( DoPEHdl       : DoPE_HANDLE;
                                   SensorNo      : Word;
                               var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;

    {
    Read definitions of control sensor for low and high pressure

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
            *CtrlSensorDef Pointer for DoPECtrlSenDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

  function DoPERdOutChannelDef ( DoPEHdl  : DoPE_HANDLE;
                                 OutChNo  : Word;
                             var OutChDef : DoPEOutChaDef ): DWord; STDCALL;

    {
    Read analogue output channel definitions

      In :  DoPEHdl     DoPE link handle
            OutChNo     Output channel no.
            *OutChDef   Pointer for DoPEOutChaDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

  function DoPERdBitOutDef ( DoPEHdl   : DoPE_HANDLE;
                             BitOutNo  : Word;
                         var BitOutDef : DoPEBitOutDef ): DWord; STDCALL;

    {
    Read Bit output definitions

      In :  DoPEHdl     DoPE link handle
            BitOutNo    Output channel no.
            *BitOutDef  Pointer for DoPEBitOutDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

  function DoPERdBitInDef ( DoPEHdl  : DoPE_HANDLE;
                            BitInNo  : Word;
                        var BitInDef : DoPEBitInDef ): DWord; STDCALL;

    {
    Read Bit input definitions

      In :  DoPEHdl        DoPE link handle
            BitInNo        Output channel no.
            *BitInDef      Pointer for DoPEBitInDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }

{---------------------------------------------------------------------------}

  function DoPERdMachineDef ( DoPEHdl    : DoPE_HANDLE;
                          var MachineDef : DoPEMachineDef ): DWord; STDCALL;

    {
    Read definitions of active machine

      In :  DoPEHdl     DoPE link handle
            *MachineDef Pointer for DoPEMachineDef structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

  function DoPERdLinTbl ( DoPEHdl     : DoPE_HANDLE;
                      var LinTblFalse : DoPELinTblFalse;
                      var LinTblTrue  : DoPELinTblTrue ): DWord; STDCALL;

    {
    Read linearisation table

      In :  DoPEHdl      DoPE link handle
            *LinTblFalse Pointer to measured values structure
            *LinTblTrue  Pointer to reference values structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdIOSignals ( DoPEHdl   : DoPE_HANDLE;
                       var IOSignals : DoPEIOSignals ): DWord; STDCALL;

    {
    Read IO signal definitions

      In :  DoPEHdl      DoPE link handle
            *IOSignals   Pointer to DoPEIOSignals structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdMainMenu ( DoPEHdl  : DoPE_HANDLE;
                          MainMenu : MenuTable ): DWord; STDCALL;

    {
    Read the main menu definition array

      In :  DoPEHdl      DoPE link handle
            MainMenu     Pointer to DoPEMainMenu array
                         The TestNo of the MainMenu entries is read only!

      Returns:           Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdRmcDef ( DoPEHdl  : DoPE_HANDLE;
                    var RmcDef   : DoPERmcDef ): DWord; STDCALL;

    {
    Read RMC definitions

      In :  DoPEHdl      DoPE link handle
            *RmcDef      Pointer to DoPERmcDef structure

      Returns:           Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSysUserData ( DoPEHdl     : DoPE_HANDLE;
                             SysUsrData  : Pointer;
                             Length      : DWord ) : DWord; STDCALL;

    {
    Read system user data

      In :  DoPEHdl     DoPE link handle
            *SysUsrData Pointer for SYSEEPROM user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorHeaderData ( DoPEHdl    : DoPE_HANDLE;
                                  Connector  : Word;
                              var SenHdrData : DoPESensorHeaderData ) : DWord; STDCALL;

    {
    Read sensor EEPROM data header

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenHdrData Pointer to sensor data header structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorAnalogueData ( DoPEHdl         : DoPE_HANDLE;
                                    Connector       : Word;
                                var SenAnalogueData : DoPESensorAnalogueData ) : DWord; STDCALL;

    {
    Read analogue sensor data

      In :  DoPEHdl          DoPE link handle
            Connector        Connector number of sensor
            *SenAnalogueData Pointer to analogue sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorIncData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenIncData : DoPESensorIncData ) : DWord; STDCALL;

    {
    Read incremental sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenIncData Pointer to incremental sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorAbsData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenAbsData : DoPESensorAbsData ) : DWord; STDCALL;

    {
    Read absolute sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenAbsData Pointer to absolute value sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorUserData ( DoPEHdl    : DoPE_HANDLE;
                                Connector  : Word;
                                SenUsrData : Pointer;
                                Length     : DWord ) : DWord; STDCALL;

    {
    Read sensor user data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSenUserData ( DoPEHdl    : DoPE_HANDLE;
                             SensorNo   : Word;
                             SenUsrData : Pointer;
                             Length     : DWord ): DWord; STDCALL;

    {
    Read sensor user data

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPERdSensorConKey ( DoPEHdl    : DoPE_HANDLE;
                              Connector  : Word;
                              Connected  : PWord;
                              KeyPressed : PWord ) : DWord; STDCALL;

    {
    Read sensor plug connected and key state

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *Connected  Pointer to the sensor plug connected state
                        (0=not connected, 1=connected)
            *KeyPressed Pointer to the sensor plug key state
                        (0=not pressed, 1=pressed)

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

  function DoPERdGeneralData ( DoPEHdl     : DoPE_HANDLE;
                           var GeneralData : DoPEGeneralData ): DWord; STDCALL;

    {
    Read general data

      In :  DoPEHdl      DoPE link handle
            *GeneralData Pointer for DoPEGeneralData structure

      Returns:           Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

type                                  { Controller parameter                  }
  DoPECtrlParameter = record          { ------------------------------------- }
    PosP            : DWord;          { Pos.  contr. P: gain             [No] }
    PosI            : word;           { Pos.  contr. I: time constant    [No] }
    PosD            : word;           { Pos.  contr. D: time constant    [No] }
    PosFFP          : DWord;          { Pos.  Feed Forward P             [No] }
    SpeedP          : DWord;          { Speed contr. P: gain             [No] }
    SpeedI          : word;           { Speed contr. I: time constant    [No] }
    SpeedD          : word;           { Speed contr. D: time constant    [No] }
    SpeedFFP        : word;           { Speed feed forward               [No] }
    PosDelay        : word;           { Delay for Command                [No] }
    AccFFP          : word;           { Acceleration contr. P: gain      [No] }
    SpeedDelay      : word;           { Delay for SpeedCommand           [No] }
    Unused1         : DWord;

    Acceleration    : Double;         { default acceleration        [Unit/s²] }
    Speed           : Double;         { speed limit                  [Unit/s] }
    Deviation       : Double;         { Max. deviation of controller   [Unit] }
    DevReaction     : word;           { Reaction if deviation exceeded   [No] }
    Unused2         : word;
    Unused3         : DWord;

    DestinationWnd  : Double;         { Size of 1/2 destination window [Unit] }
    DestinationTime : Double;         { Time until controlled channel     [s] }
                                      { must reach destination window         }
    UpperSoftEnd    : Double;         { Upper softend                  [Unit] }
    LowerSoftEnd    : Double;         { Lower softend                  [Unit] }
    SoftEndReaktion : word;           { Reaction if softend is reached   [No] }
    Unused4         : word;
    Unused5         : DWord;

                                      { numerical limitations for             }
                                      { acceleration and speed parameters     }
    MinAcceleration : Double;         { minimum acceleration        [Unit/s²] }
    MaxAcceleration : Double;         { maximum acceleration        [Unit/s²] }
    MinDeceleration : Double;         { minimum deceleration        [Unit/s²] }
    MaxDeceleration : Double;         { maximum deceleration        [Unit/s²] }
    MinSpeed        : Double;         { minimum speed                [Unit/s] }
    MaxSpeed        : Double;         { maximum speed                [Unit/s] }
    
                                      { error dead band controller parameter  }
    Deadband        : Double;         { Error deadband around setpoint [Unit] }
    PercentP        : word;           { Smallest P inside deadband[% of PosP] }
  end;

function DoPERdCtrlParameter ( DoPEHdl       : DoPE_HANDLE;
                               MoveCtrl      : word;
                           var CtrlParameter : DoPECtrlParameter ): DWord; STDCALL;

    {
    Read closed loop controller parameter

      In :  DoPEHdl        DoPE link handle
            MoveCtrl       Control mode
            *CtrlParameter Pointer for DoPECtrlParameter structure

      Returns:             Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorDefSync ( DoPEHdl   : DoPE_HANDLE;
                               SensorNo  : Word;
                           var SensorDef : DoPESenDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEWrSensorDef ( DoPEHdl   : DoPE_HANDLE;
                           SensorNo  : Word;
                       var SensorDef : DoPESenDef;
                           usTAN     : PWord ): DWord; STDCALL;
    {
    Write sensor definitions

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SensorDef  Pointer for DoPESenDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrCtrlSensorDefSync ( DoPEHdl       : DoPE_HANDLE;
                                    SensorNo      : Word;
                                var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;

function  DoPEWrCtrlSensorDefHighSync ( DoPEHdl       : DoPE_HANDLE;
                                        SensorNo      : Word;
                                    var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrCtrlSensorDef ( DoPEHdl       : DoPE_HANDLE;
                                SensorNo      : Word;
                            var CtrlSensorDef : DoPECtrlSenDef;
                                usTAN         : PWord ): DWord; STDCALL;

function  DoPEWrCtrlSensorDefHigh ( DoPEHdl       : DoPE_HANDLE;
                                    SensorNo      : Word;
                                var CtrlSensorDef : DoPECtrlSenDef;
                                    usTAN         : PWord ): DWord; STDCALL;

    {
    Write definitions of control sensor for low and high pressure

      In :  DoPEHdl        DoPE link handle
            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
            *CtrlSensorDef Pointer for DoPECtrlSenDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrOutChannelDefSync ( DoPEHdl   : DoPE_HANDLE;
                                    OutChNo   : Word;
                                var OutChDef  : DoPEOutChaDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrOutChannelDef ( DoPEHdl   : DoPE_HANDLE;
                                OutChNo   : Word;
                            var OutChDef  : DoPEOutChaDef;
                                usTAN     : PWord ): DWord; STDCALL;
    {
    Write analogue output channel definitions

      In :  DoPEHdl     DoPE link handle
            OutChNo     Output channel no.
            *OutChDef   Pointer for DoPEOutChaDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrBitOutDefSync ( DoPEHdl   : DoPE_HANDLE;
                                BitOutNo  : Word;
                            var BitOutDef : DoPEBitOutDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrBitOutDef ( DoPEHdl   : DoPE_HANDLE;
                            BitOutNo  : Word;
                        var BitOutDef : DoPEBitOutDef;
                            usTAN     : PWord ): DWord; STDCALL;

    {
    Write Bit output definitions

      In :  DoPEHdl     DoPE link handle
            BitOutNo    Output channel no.
            *BitOutDef  Pointer for DoPEBitOutDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrBitInDefSync ( DoPEHdl   : DoPE_HANDLE;
                               BitInNo   : Word;
                           var BitInDef  : DoPEBitInDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrBitInDef ( DoPEHdl   : DoPE_HANDLE;
                           BitInNo   : Word;
                       var BitInDef  : DoPEBitInDef;
                           usTAN     : PWord ): DWord; STDCALL;

    {
    Write Bit input definitions

      In :  DoPEHdl        DoPE link handle
            BitInNo        Output channel no.
            *BitInDef      Pointer for DoPEBitInDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrMachineDefSync ( DoPEHdl    : DoPE_HANDLE;
                             var MachineDef : DoPEMachineDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrMachineDef ( DoPEHdl    : DoPE_HANDLE;
                         var MachineDef : DoPEMachineDef;
                             usTAN      : PWord ): DWord; STDCALL;

    {
    Write definitions of active machine

      In :  DoPEHdl     DoPE link handle
            *MachineDef Pointer for DoPEMachineDef structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrLinTblSync ( DoPEHdl     : DoPE_HANDLE;
                         var LinTblFalse : DoPELinTblFalse;
                         var LinTblTrue  : DoPELinTblTrue ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrLinTbl ( DoPEHdl     : DoPE_HANDLE;
                     var LinTblFalse : DoPELinTblFalse;
                     var LinTblTrue  : DoPELinTblTrue;
                         usTANFirst  : PWord;
                         usTANLast   : PWord ): DWord; STDCALL;

    {
    Write linearisation table

      In :  DoPEHdl      DoPE link handle
            *LinTblFalse Pointer to measured values structure
            *LinTblTrue  Pointer to reference values structure

      Out:
             usTANFirst Pointer to first TAN used from this command
             usTANLast  Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrIOSignalsSync ( DoPEHdl   : DoPE_HANDLE;
                           var IOSignals : DoPEIOSignals ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEWrIOSignals ( DoPEHdl   : DoPE_HANDLE;
                       var IOSignals : DoPEIOSignals;
                           usTAN     : PWord ): DWord; STDCALL;

    {
    Write IO signal input definitions

      In :  DoPEHdl        DoPE link handle
            *IOSignals     Pointer for DoPEIOSignals structure

      Out :
            *lpusTAN       Pointer to TAN used from this command

      Returns:             Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrMainMenuSync ( DoPEHdl  : DoPE_HANDLE;
                              MainMenu : MenuTable ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEWrMainMenu ( DoPEHdl  : DoPE_HANDLE;
                          MainMenu : MenuTable;
                          usTAN    : PWord ): DWord; STDCALL;

    {
    Write the main menu definitions array

      In :  DoPEHdl      DoPE link handle
            MainMenu     Pointer to DoPEMainMenu array

      Out :
            *lpusTAN     Pointer to TAN used from this command

      Returns:           Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrRmcDefSync ( DoPEHdl  : DoPE_HANDLE;
                         var RmcDef   : DoPERmcDef ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrRmcDef ( DoPEHdl  : DoPE_HANDLE;
                     var RmcDef   : DoPERmcDef;
                         usTAN    : PWord ): DWord; STDCALL;

    {
    Write RMC definitions

      In :  DoPEHdl      DoPE link handle
            *RmcDef      Pointer to DoPERmcDef structure

      Returns:           Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrSysUserDataSync ( DoPEHdl    : DoPE_HANDLE;
                                  SysUsrData : Pointer;
                                  Length     : DWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrSysUserData ( DoPEHdl    : DoPE_HANDLE;
                              SysUsrData : Pointer;
                              Length     : DWord;
                              usTAN      : PWord ): DWord; STDCALL;

    {
    Write system user data

      In :  DoPEHdl     DoPE link handle
            *SysUsrData Pointer for SYSEEPROM user data
            Length      User data buffer length in BYTEs

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorHeaderData ( DoPEHdl    : DoPE_HANDLE;
                                  Connector  : Word;
                              var SenHdrData : DoPESensorHeaderData ) : DWord; STDCALL;

    {
    Write sensor EEPROM data header

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenHdrData Pointer to sensor data header structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorAnalogueData ( DoPEHdl         : DoPE_HANDLE;
                                    Connector       : Word;
                                var SenAnalogueData : DoPESensorAnalogueData ) : DWord; STDCALL;

    {
    Write analogue sensor data

      In :  DoPEHdl          DoPE link handle
            Connector        Connector number of sensor
            *SenAnalogueData Pointer to analogue sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorIncData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenIncData : DoPESensorIncData ) : DWord; STDCALL;

    {
    Write incremental sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenIncData Pointer to incremental sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorAbsData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenAbsData : DoPESensorAbsData ) : DWord; STDCALL;

    {
    Write absolute sensor data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenAbsData Pointer to absolute value sensor data structure

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPESetSsiGenericSignalType ( SignalType : PByte;
                                       Code       : DWord;
                                       Bits       : DWord ) : DWord; STDCALL;

    {
    Build the signal type of a SSI absolute sensor by it's generic data.

      In :  SignalType  Pointer to signal type variable
            Code        Code of the sensor (0:binary, !=0:gray code)
            Bits        Number of databits of the sensor

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPESsiGenericSignalTypeInfo ( SignalType : Byte;
                                        Code       : PDWord;
                                        Bits       : PDWord ) : DWord; STDCALL;

    {
    Get the generic data of a SSI absolute sensor by it's signal type.

      In :  SignalType  Signal type of the SSI sensor
            Code        Pointer to storage for code of the sensor
            Bits        Pointer to storage for number of databits of the sensor

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorUserData ( DoPEHdl    : DoPE_HANDLE;
                                Connector  : Word;
                                SenUsrData : Pointer;
                                Length     : DWord ) : DWord; STDCALL;

    {
    Write sensor user data

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSenUserDataSync ( DoPEHdl    : DoPE_HANDLE;
                                 SensorNo   : Word;
                                 SenUsrData : Pointer;
                                 Length     : DWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function DoPEWrSenUserData     ( DoPEHdl    : DoPE_HANDLE;
                                 SensorNo   : Word;
                                 SenUsrData : Pointer;
                                 Length     : DWord;
                                 usTAN      : PWord ): DWord; STDCALL;

    {
    Write sensor user data

      In :  DoPEHdl     DoPE link handle
            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
            *SenUsrData Pointer for sensor user data
            Length      User data buffer length in BYTEs

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPEWrGeneralDataSync ( DoPEHdl     : DoPE_HANDLE;
                              var GeneralData : DoPEGeneralData ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrGeneralData ( DoPEHdl     : DoPE_HANDLE;
                          var GeneralData : DoPEGeneralData;
                              usTAN       : PWord ): DWord; STDCALL;

    {
    Write general data

      In :  DoPEHdl      DoPE link handle
            *GeneralData Pointer for DoPEGeneralData structure

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:           Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

  function  DoPERdBitInput ( DoPEHdl   : DoPE_HANDLE;
                             Connector : Word;
                         var Value     : Word ): DWord; STDCALL;
    {
    Read an digital input device.

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            *Value      Pointer for bits read

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEWrBitOutputSync( DoPEHdl   : DoPE_HANDLE;
                               Connector : Word;
                               Value     : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEWrBitOutput( DoPEHdl   : DoPE_HANDLE;
                           Connector : Word;
                           Value     : Word;
                           usTAN     : PWord ): DWord; STDCALL;
    {
    Write an digital output device.

      In :  DoPEHdl     DoPE link handle
            Connector   Connector number of sensor
            Value       Bits to write

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function    DoPEConfPeakValueSync  ( DoPEHdl      : DoPE_HANDLE;
                                     PositionMin  : Word;
                                     PositionMax  : Word;
                                     LoadMin      : Word;
                                     LoadMax      : Word;
                                     ExtensionMin : Word;
                                     ExtensionMax : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function    DoPEConfPeakValue  ( DoPEHdl      : DoPE_HANDLE;
                                 PositionMin  : Word;
                                 PositionMax  : Word;
                                 LoadMin      : Word;
                                 LoadMax      : Word;
                                 ExtensionMin : Word;
                                 ExtensionMax : Word;
                                 usTANFirst   : PWord;
                                 usTANLast    : PWord ): DWord; STDCALL;
{
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

}


{ -------------------------------------------------------------------------- }

function  DoPEPeakValueTimeSync  ( DoPEHdl : DoPE_HANDLE;
                                   Time    : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPeakValueTime  ( DoPEHdl    : DoPE_HANDLE;
                               Time       : Double;
                               usTAN      : PWord ): DWord; STDCALL;

{
    Set reset time for peak value detection.
    The maximum and minimum values within this time are considered as peak values.
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl      DoPE link handle
            Time         Reset time for peak value detection

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}

{ -------------------------------------------------------------------------- }

  { --------------- Definitions for calculated Sensors --------------------- }
  { ------------This channels can be used for control !!! -------------------}
  
const
  MAX_CALCULATED_CHANNELS        = 4;   { Maximum number of calculated measuring channels }

                                        { Constants for Calculated Sensor Init Value }
  F_S1PlusS2_half                = 0;   { S = (((S1 + S2) / 2)     / Corr) - Offset }
  F_S1MinusS2                    = 1;   { S =  ((S1 - S2)          / Corr) - Offset }
  F_S1PlusS2PlusS3_third         = 2;   { S = (((S1 + S2+ S3) / 3) / Corr) - Offset }
  F_S1PlusS2PlusS3               = 3;   { S =  ((S1 + S2+ S3)      / Corr) - Offset }
  F_S1PlusS2                     = 4;   { S =  ((S1 + S2)          / Corr) - Offset }
  F_StiffnessCorrection          = 5;   { S =  ((S  - f(F)         / Corr) - Offset }
  F_SensorCorrection             = 6;   { S =  ((S1 - f(S2)        / Corr) - Offset }
  F_ExtendedFormula              = 7;

                                        { Sensors must be in in ascending order starting at S1 !! }
  F_S1PlusS2PlusS3PlusS4_quarter = 7;   { S = (((S1 + S2+ S3+ S4) / 4) / Corr) - Offset }
  F_S1PlusS2PlusS3PlusS4         = 8;   { S = ((S1 + S2+ S3+ S4)       / Corr) - Offset }

{
   The formula and used sensor are all coded in a 16Bit value:
   1. For formula 0 - 6 may use three sensors:
  S3          S2          S1          Formula  Sign
  ___________ ___________ ___________ ________ __
  15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
  
  
   2. For formula 7 - 23 Bits 1-3 must be "1" and the formula is in Bits 12 - 15
      These extented formulas can only use two Sensors, or the sensors must be in in ascending order
  ExtFormula  S2          S1          Value 7  Sign
  ___________ ___________ ___________ ________ __
  15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
}

function  DoPEConfCMcSpeedSync  ( DoPEHdl            : DoPE_HANDLE;
                                  CalculatedSensorNo : Word;
                                  SensorNo           : Word;
                                  IntegrationTime    : Double;
                                  Timebase           : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEConfCMcSpeed  ( DoPEHdl            : DoPE_HANDLE;
                              CalculatedSensorNo : Word;
                              SensorNo           : Word;
                              IntegrationTime    : Double;
                              Timebase           : Double;
                              usTANFirst         : PWord;
                              usTANLast          : PWord ): DWord; STDCALL;

{
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
            IntegrationTime     Integration time for data aqcuisition
                                (only relevant for analoge channels)
                                maximum 100 * cycle time of seed controller.
            Timebase            Timebase for speed calculation
                                maximum 2.56 sec.

      Out:
            usTANFirst     Pointer to first TAN used from this command
            usTANLast      Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}


{ -------------------------------------------------------------------------- }

function  DoPEConfCMcCommandSpeedSync  ( DoPEHdl            : DoPE_HANDLE;
                                         CalculatedSensorNo : Word;
                                         Timebase           : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEConfCMcCommandSpeed  ( DoPEHdl            : DoPE_HANDLE;
                                     CalculatedSensorNo : Word;
                                     Timebase           : Double;
                                     usTANFirst         : PWord;
                                     usTANLast          : PWord ): DWord; STDCALL;

{
    Configure calculated speed of command output to data record.
    Speed of command output (the first differentiation)
    may be calculated and configured to the data record.
    After it is configured, it may be used as the supervised
    channel in the command "DoPESetCheck".
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Position in measuring data record for the
                                calculated command speed.
            Timebase            Timebase for speed calculation.
                                maximum 2.56 sec.
      Out:
            usTANFirst     Pointer to first TAN used from this command
            usTANLast      Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}


{ -------------------------------------------------------------------------- }

function  DoPEConfCMcGradientSync  ( DoPEHdl            : DoPE_HANDLE;
                                     CalculatedSensorNo : Word;
                                     DividentSensorNo   : Word;
                                     DivisorSensorNo    : Word;
                                     IntegrationTime    : Double;
                                     Timebase           : Double ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEConfCMcGradient  ( DoPEHdl            : DoPE_HANDLE;
                                 CalculatedSensorNo : Word;
                                 DividentSensorNo   : Word;
                                 DivisorSensorNo    : Word;
                                 IntegrationTime    : Double;
                                 Timebase           : Double;
                                 usTANFirst         : PWord;
                                 usTANLast          : PWord ): DWord; STDCALL;

{
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
}


{ -------------------------------------------------------------------------- }

function  DoPEClearCMcSync  ( DoPEHdl            : DoPE_HANDLE;
                              CalculatedSensorNo : Word ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEClearCMc  ( DoPEHdl            : DoPE_HANDLE;
                          CalculatedSensorNo : Word;
                          usTANFirst         : PWord;
                          usTANLast          : PWord ): DWord; STDCALL;

{
    Clear calculated measuring channel.
    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.


      In :  DoPEHdl             DoPE link handle
            CalculatedSensorNo  Sensor Number 0 .. 9
      Out:
            usTANFirst     Pointer to first TAN used from this command
            usTANLast      Pointer to last TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
}


{ -------------------------------------------------------------------------- }

type
  Mc2OutputPoints = array[0..(MC2OUT_MAX-1)] of Double;

function  DoPEMc2OutputSync  ( DoPEHdl      : DoPE_HANDLE;
                               Mode         : Word;
                               Priority     : Word;
                               SensorNo     : Word;
                               Output       : Word;
                               SensorPoint  : Mc2OutputPoints;
                               OutputPoint  : Mc2OutputPoints ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEMc2Output      ( DoPEHdl      : DoPE_HANDLE;
                               Mode         : Word;
                               Priority     : Word;
                               SensorNo     : Word;
                               Output       : Word;
                               SensorPoint  : Mc2OutputPoints;
                               OutputPoint  : Mc2OutputPoints;
                               usTan        : PWord ): DWord; STDCALL;

    {
    Output of a measured value to a analogue output channel.
    Any measured channel may be scaled and via a DAC converted to a analogue
    signal. Scale is defined by two or three points.

    With the Mode parameter the calculation of the output is controlled:
       MC2OUT_MODE_OFF       Output disabled
       MC2OUT_MODE_2POINTS   Output definition by 2 points
       MC2OUT_MODE_3POINTS   Output definition by 3 points

    With the Priority parameter the output method is controlled:
       MC2OUT_PRIORITY_HIGH  Output of this channel every 20 ms.
       MC2OUT_PRIORITY_LOW   Every 20 ms only one of the channels with this
                             priority is calculated and given output.
       MC2OUT_PRIORITY_BURST Output of this channel every speed controller cycle.



      In :  DoPEHdl             DoPE link handle
            Mode                MC2OUT_MODE_...     (see above)
            Priority            MC2OUT_PRIORITY_... (see above)
            SensorNo            Sensor Number SENSOR_S .. SENSOR_15
            Output              Number of analogue output channel
            SensorPoint         Scale point sensor values
            OutputPoint         Scale point output values

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEWrSensorMsgSync ( DoPEHdl  : DoPE_HANDLE;
                               SensorNo : Word;
                               Buffer   : Pointer;
                               Length   : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEWrSensorMsg ( DoPEHdl  : DoPE_HANDLE;
                           SensorNo : Word;
                           Buffer   : Pointer;
                           Length   : DWord;
                           usTAN    : PWord ) : DWord; STDCALL;

    {
    Write a message to a sensor.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Buffer        Pointer to message to transmit
            Length        Message length in BYTEs

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function  DoPESerialSensorDefSync ( DoPEHdl     : DoPE_HANDLE;
                                    SensorNo    : Word;
                                    Timeout     : double;
                                    MaxLength   : Word;
                                    EndChar1    : char;
                                    EndChar2    : char;
                                    EndCharMode : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function  DoPESerialSensorDef ( DoPEHdl     : DoPE_HANDLE;
                                SensorNo    : Word;
                                Timeout     : double;
                                MaxLength   : Word;
                                EndChar1    : char;
                                EndChar2    : char;
                                EndCharMode : Word;
                                usTAN       : PWord ) : DWord; STDCALL;

    {
    Definition for serial sensor.
    A message for a serial sensor will be transmitted after:

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Timeout       Timeout, 0 = no timeout
            MaxLength     Transmit after Number of bytes reveived
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
    }

const
  SERSEN_TRANSFER         = 80;  { MaxLength limit                     }
  SERSEN_ENDCHAR_NO       = 0;   { No Endcharacter active              }
  SERSEN_ENDCHAR_1        = 1;   { Detect only EndChar1                }
  SERSEN_ENDCHAR_1_OR_2   = 2;   { Detect EndChar1 or EndChar1         }
  SERSEN_ENDCHAR_1_AND_2  = 3;   { Detect Sequence EndChar1 + EndChar2 }
  SERSEN_ENDCHAR_1_PLUS1  = 4;   { Detect EndChar1 plus one Character  }


{---------------------------------------------------------------------------}

function  DoPESetSerialSensorSync ( DoPEHdl     : DoPE_HANDLE;
                                    SensorNo    : Word;
                                    Mode        : Word;
                                    Value       : double;
                                    Speed       : double ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function  DoPESetSerialSensor ( DoPEHdl     : DoPE_HANDLE;
                                SensorNo    : Word;
                                Mode        : Word;
                                Value       : double;
                                Speed       : double;
                                usTAN       : PWord ) : DWord; STDCALL;

    {
    Write a message to a sensor.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          SERSEN_SET_COMMAND
                          SERSEN_SET_FEEDBACK
            Value         Value to set
            Speed         Speed for ramp

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

const
  SERSEN_SET_COMMAND        = 0;  { Set Command value               }
  SERSEN_SET_FEEDBACK       = 1;  { Set Feedback value              }


{---------------------------------------------------------------------------}

function  DoPESetSerialSensorTransparentSync ( DoPEHdl     : DoPE_HANDLE;
                                               SensorNo    : Word;
                                               Mode        : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function  DoPESetSerialSensorTransparent ( DoPEHdl     : DoPE_HANDLE;
                                           SensorNo    : Word;
                                           Mode        : Word;
                                           usTAN       : PWord ) : DWord; STDCALL;

    {
    Set serial channel to transparent mode or the previously selected protocol.

      In :  DoPEHdl       DoPE link handle
            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
            Mode          SERSEN_SET_PROTOCOL
                          SERSEN_SET_TRANSPARENT

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }

const
  SERSEN_SET_PROTOCOL        = 0;  { Set sensor to the protocol defined     }
                                   { by the sensors init. value             }
  SERSEN_SET_TRANSPARENT     = 1;  { Set sensor to transparent mode         }
    

{---------------------------------------------------------------------------}

function DoPEOfflineActionBitOutputSync ( DoPEHdl     : DoPE_HANDLE;
                                          BitOutputNo : Word;
                                          Mode        : Word;
                                          Value       : Word ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEOfflineActionBitOutput ( DoPEHdl     : DoPE_HANDLE;
                                      BitOutputNo : Word;
                                      Mode        : Word;
                                      Value       : Word;
                                      usTAN       : PWord ) : DWord; STDCALL;

    {
    Set the offline action for an initialized digital output device.
    With the Mode parameter the offline acction can be controlled:
     DO_NOTHING       Don't modify this digital output
     USE_INIT_VALUE   Use Initial value after offline
     USE_VALUE        Use defined value after offline

      In :  DoPEHdl       DoPE link handle
            BitOutputNo   Number of bit output device
            Mode          Mode flag (see above)
            Value         Output value used in USE_VALUE mode

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEOfflineActionOutputSync ( DoPEHdl  : DoPE_HANDLE;
                                       OutputNo : Word;
                                       Mode     : Word;
                                       Value    : Double ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEOfflineActionOutput ( DoPEHdl  : DoPE_HANDLE;
                                   OutputNo : Word;
                                   Mode     : Word;
                                   Value    : Double;
                                   usTAN    : PWord ) : DWord; STDCALL;

    {
    Set the offline action for an initialized analog output channel.
    With the Mode parameter the offline acction can be controlled:
     DO_NOTHING       Don't modify the analog output channel
     USE_INIT_VALUE   Use Initial value after offline
     USE_VALUE        Use defined value after offline

      In :  DoPEHdl       DoPE link handle
            BitOutputNo   Number of analogue output channel
            Mode          Mode flag (see above)
            Value         Output value used in USE_VALUE mode in % of max. value

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOGripEnableSync( DoPEHdl : DoPE_HANDLE;
                               Enable  : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOGripEnable( DoPEHdl : DoPE_HANDLE;
                           Enable  : DWord;
                           usTAN   : PWord ) : DWord; STDCALL;

    {
    Enable or disable grip IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables grip IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

const
  IO_GRIP_UPPER                  = $0001;
  IO_GRIP_LOWER                  = $0002;
  IO_GRIP_BOTH                   = $0003;

  IO_GRIP_ACTION_OPEN            = $0001;
  IO_GRIP_ACTION_CLOSE           = $0002;
  IO_GRIP_ACTION_HIGH_PRESSURE1  = $0004;
  IO_GRIP_ACTION_HIGH_PRESSURE2  = $0008;

function DoPEIOGripSetSync( DoPEHdl  : DoPE_HANDLE;
                            Grip     : DWord;
                            Action   : DWord;
                            Pressure : Double ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOGripSet( DoPEHdl  : DoPE_HANDLE;
                        Grip     : DWord;
                        Action   : DWord;
                        Pressure : Double;
                        usTAN    : PWord ) : DWord; STDCALL;

    {
    Perform a grip action.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Grip       Grip to use
                        (use IO_GRIP_ defines)
             Action     Action to perform
                        (use IO_GRIP_ACTION_ defines)
             Pressure   Pressure to be applied [%]

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOGripPressureSync( DoPEHdl      : DoPE_HANDLE;
                                 LowPressure  : Double;
                                 HighPressure : Double;
                                 RampTime     : Double ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOGripPressure( DoPEHdl      : DoPE_HANDLE;
                             LowPressure  : Double;
                             HighPressure : Double;
                             RampTime     : Double;
                             usTAN        : PWord ) : DWord; STDCALL;

    {
    Set grip parameter.


      In :  *DoPEHdl      Pointer to DoPE link handle
             LowPressure  Low pressure value [%]
             HighPressure Low pressure value [%]
             RampTime     Time to switch between low and high pressure  [s]

      Out :
            *lpusTAN      Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOExtEnableSync( DoPEHdl : DoPE_HANDLE;
                              Enable  : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOExtEnable( DoPEHdl  : DoPE_HANDLE;
                          Enable   : DWord;
                          usTAN    : PWord ) : DWord; STDCALL;

    {
    Enable or disable extensometer IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables extensometer IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

const
  IO_EXT_UPPER         = $0001;
  IO_EXT_LOWER         = $0002;
  IO_EXT_BOTH          = $0003;

  IO_EXT_ACTION_OPEN   = $0001;
  IO_EXT_ACTION_CLOSE  = $0002;

function DoPEIOExtSetSync( DoPEHdl  : DoPE_HANDLE;
                           Ext      : DWord;
                           Action   : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOExtSet( DoPEHdl  : DoPE_HANDLE;
                       Ext      : DWord;
                       Action   : DWord;
                       usTAN    : PWord ) : DWord; STDCALL;

    {
    Perform a extensometer action.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Grip       Grip to use
                        (use IO_EXT_ defines)
             Action     Action to perform
                        (use IO_EXT_ACTION_ defines)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOFixedXHeadEnableSync( DoPEHdl  : DoPE_HANDLE;
                                     Enable   : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOFixedXHeadEnable( DoPEHdl   : DoPE_HANDLE;
                                 Enable    : DWord;
                                 usTAN     : PWord ) : DWord; STDCALL;

    {
    Enable or disable fixed cross head IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables fixed cross head IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOFixedXHeadSetSync( DoPEHdl   : DoPE_HANDLE;
                                  Direction : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOFixedXHeadSet( DoPEHdl   : DoPE_HANDLE;
                              Direction : DWord;
                              usTAN     : PWord ) : DWord; STDCALL;

    {
    Move fixed cross head.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Direction  Direction of movement
                        (use MOVE_HALT, MOVE_UP, MOVE_DOWN defines)

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{---------------------------------------------------------------------------}

function DoPEIOHighPressureEnableSync( DoPEHdl  : DoPE_HANDLE;
                                       Enable   : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOHighPressureEnable( DoPEHdl   : DoPE_HANDLE;
                                   Enable    : DWord;
                                   usTAN     : PWord ) : DWord; STDCALL;

    {
    Enable or disable high pressure IO handling.


      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables high pressure IO handling

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEIOHighPressureSetSync( DoPEHdl      : DoPE_HANDLE;
                                    HighPressure : DWord ) : DWord; STDCALL;

{  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function DoPEIOHighPressureSet( DoPEHdl      : DoPE_HANDLE;
                                HighPressure : DWord;
                                usTAN        : PWord ) : DWord; STDCALL;

    {
    Set high or low pressure.


      In :  *DoPEHdl      Pointer to DoPE link handle
             HighPressure !=0  selects high pressure
                          0    selects low pressure

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    }


{ --------------------------------------------------------------------------- }
{ ----- Old definitions (don't use for new designs) ------------------------- }

{ ----- Messages of   DoPE -------------------------------------------------- }

const
  COMMAND_ERROR = 200;                 { Command error codes                  }
  RUNTIME_ERROR = 201;                 { Run time error codes                 }
  MOVE_CTRL_MSG = 202;                 { Movement control messages            }
  RAW_SUB_MSG   = 203;                 { Softend messages                     }
  SENSOR_MSG    = 204;                 { Sensor messages                      }

type
  Header = word;


type                                   { Command error                        }
  DoPECE = record                      { ------------------------------------ }
    CommandNumber  : word;             { Number of command                    }
    ErrorNumber    : word;             { Number of error                      }
  end;


type                                   { Run time error short format (SUB)    }
  SubRTErr = record                    { ------------------------------------ }
    Time           : double;           { System time the error occurred       }
    Device         : word;             { Device Number responsible for the err}
    Bits           : word;             { Responsible bits if digital input dev}
  end;

type                                   { Run time error unscaled (SUB)        }
  SubRTErrRaw = record                 { ------------------------------------ }
    Data     : array[0..130] of Byte;  { DPXMSGLEN-Typ-usTAN-ErrorNumber Bytes}
  end;

type                                   { Run time error                       }
  DoPERTErr = record                   { ------------------------------------ }
    ErrorNumber    : word;             { Common number of run time error      }
    case Integer of
      RTE_EMOVE_END, RTE_ERROR_UNHANDLED :
        (Sub     : SubRTErr);          { RTE directly from the SUB            }
      RTE_LOWER_LIMIT + 1 :
        (SubRaw  : SubRTErrRaw);       { RTE directly from the SUB unscaled   }
{ in future DoPE versions detailed RTErr structures will be placed here      }
   end;
   
  { The DoPERTE structure is kept for compatibility to old DoPE versions      }
  { Use DoPERTErr for detailed runtime error mechanism                        }
type                                   { Run time error (old style)           }
  DoPERTE = record                     { ------------------------------------ }
    ErrorNumber    : word;             { Number of run time error             }
    Time           : Double;           { System time the error occurred       }
    Device         : word;             { Device Nr responsible for the err.   }
    Bits           : word;             { Responsible bits if digit. input dev }
  end;


type                                   { Message of movement control          }
  DoPEMCM = record                     { ------------------------------------ }
    MsgId          : word;             { ID of message                        }
    Time           : Double;           { System time for the message          }
    Control        : word;             { Control mode of position             }
    Position       : Double;           { Position                             }
    DControl       : word;             { Control mode of destination position }
    Destination    : Double;           { Destination position                 }
  end;


type                                   { Softend Message                      }
  DoPESftM = record                    { ------------------------------------ }
    MsgId          : word;             { ID of message                        }
    Time           : Double;           { System time for the message          }
    Control        : word;             { Control mode of position             }
    Position       : Double;           { Position                             }
  end;


type                                   { Offset-Correction Message            }
  DoPEOffsCM = record                  { ------------------------------------ }
    MsgId          : word;             { ID of message                        }
    Time           : Double;           { System time for the message          }
    Offset         : Double            { Power Amplifier Offset               }
  end;


type                                   { Measuring Channel Supervision Msg.   }
  DoPECheckM = record                  { ------------------------------------ }
    MsgId          : word;             { ID of message                        }
    Time           : Double;           { System time for the message          }
    CheckId        : word;             { ID of Measuring Channel Check        }
    Position       : Double;           { Position                             }
    SensorNo       : word;             { Supervised sensor                    }
  end;


type                                   { 'Reference Signal' Message           }
  DoPERefSignalM = record              { ------------------------------------ }
    MsgId          : word;             { ID of message                        }
    Time           : Double;           { System time for the message          }
    SensorNo       : word;             { Control mode of position             }
    Position       : Double;           { Position                             }
  end;


const
  SENSOR_MSG_LEN  = 80;
type                                   { Sensor Message                       }
  DoPESensorM = record                 { ------------------------------------ }
    Time           : Double;           { System time for the message          }
    SensorNo       : word;             { Sensor Number 0 .. 15                }
    Length         : word;             { Number of bytes in the message       }
    Data           : array[0..SENSOR_MSG_LEN-1] of Byte; { Message            }
  end;


type                                   { 'Raw Sub' Message                    }
  DoPERawM = record                    { ------------------------------------ }
    TypSub         : Header;           { Sub header                           }
    Data : array[0..127] of Byte;      { Sub message in raw binary format     }
  end;



type                                   { Union of all messages from DoPE      }
   uMsgAll = record
     case Integer of
       COMMAND_ERROR : (CmdErr     : DoPECE);      { Command error                }
       0             : (RunTimeErr : DoPERTE);     { Run time error (old style)   }
       RUNTIME_ERROR : (RTErr      : DoPERTErr);   { Run time error (detailed)    }
       MOVE_CTRL_MSG :
       (
         case Integer of
           CMSG_POS :
              (MoveCMsg   : DoPEMCM);              { Messages of movement control }
           CMSG_UPPER_SFT,CMSG_LOWER_SFT :
              (SftMsg     : DoPESftM);             { 'Softend' Message            }
           CMSG_OFFSET    :
              (OffsCMsg   : DoPEOffsCM);           { 'Offset-Correction' Message  }
           CMSG_CHECK, CMSG_CHECK_ERR    :
              (MCCheckMsg : DoPECheckM);           { 'Measuring Channel Supervision' Msg.  }
           CMSG_REFSIGNAL :
              (RefSignalMsg : DoPERefSignalM);     { 'Reference Signal' Message   }
       );
       SENSOR_MSG    : (SensorMsg  : DoPESensorM); { 'Sensor' Message             }
       RAW_SUB_MSG   : (RawSubMsg  : DoPERawM);    { 'Raw Sub' Message            }
   end;


type                                   { Messages SUB -> PC                   }
   DoPEMsg = record                    { ------------------------------------ }
    Typ    :   Header;                 { Common header part                   }
    usTAN  :   word;                   { Transactionnumber                    }
    Usr    :   uMsgAll;                { Message specific parts               }
   end;


{ -------------------------------------------------------------------------- }

type
  NPROC = FUNCTION  ( hWnd    : HWND;
                      uMsg    : UINT;
                      DoPEHdl : WPARAM;
                      Event   : LPARAM ): DWord; STDCALL;

    {
    Notification callback prototype

      In:  hWnd            Window handle, as set by DpxSetNotification
           uMsg            Message number, as set by DpxSetNotification
           DoPEHdl         DoPE link handle
           Event           Events, that have occured

      Returns:             Events, that should be resent later on.
    }


{ -------------------------------------------------------------------------- }

function DoPESetNotification  ( DoPEHdl    : DoPE_HANDLE;
                                EventMask  : DWORD;
                                NotifyProc : NPROC;
                                NotifyWnd  : HWND;
                                NotifyMsg  : UINT ): DWORD; STDCALL;

    {
    Set parameters for DoPE notification callback.

      In :  DoPEHdl     DoPE link handle
            EventMask   Events for Notification. (Or'ed DPXEVT_xx constants)
            NotifyProc  Callback-Funktion (nil bei 16-Bit !!)
            NotifyWnd   Reference data: Window handle to pass to callback
            NotifyMsg   Reference data: Message-Nummer to pass to callback

      Returns:          Error constant (DoPERR_xxxx)
    }


{ -------------------------------------------------------------------------- }

function DoPEGetMsg  ( DoPEHdl : DoPE_HANDLE;
                       Buffer  : Pointer;
                       BufSize : DWord;
                   var Length  : PDWord  ): DWord; STDCALL;

    {
    Get message from receiver buffer.
    Messages received from the EDC are stored inside DoPE. You can read a stored
    message with this command.

      In :  DoPEHdl     DoPE link handle
            Buffer      Pointer to storage for message
            BufSize     Size of storage in Byte's
            Length      Pointer to storage for message length

      Out:  *Buffer     Message
            *Length     Message length in Byte's

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEPosG1Sync    ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed       : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosG1    ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed       : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

    {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.


      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Speed       Speed for positioning
            Limit       absolute limit position
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEPosG1_ASync  ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Acc         : Double;
                             Speed       : Double;
                             DecLimit    : Double;
                             Limit       : Double;
                             DecDest     : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosG1_A  ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Acc         : Double;
                         Speed       : Double;
                         DecLimit    : Double;
                         Limit       : Double;
                         DecDest     : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Acc         Acceleration
            Speed       Speed for positioning
            DecLimit    Deceleration for limit position
            Limit       absolute limit position
            DecDest     Deceleration for final destination
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEPosD1Sync    ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed       : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosD1    ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed       : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.


      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Speed       Speed for positioning
            Limit       relative limit position (e.g current position + 10)
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
   }


{--------------------------------------------------------------------------}

function  DoPEPosD1_ASync  ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Acc         : Double;
                             Speed       : Double;
                             DecLimit    : Double;
                             Limit       : Double;
                             DecDest     : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosD1_A  ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Acc         : Double;
                         Speed       : Double;
                         DecLimit    : Double;
                         Limit       : Double;
                         DecDest     : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

    {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will not change control mode after the destination is reached.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Acc         Acceleration
            Speed       Speed for positioning
            DecLimit    Deceleration for limit position
            Limit       relative limit position (e.g current position + 10)
            DecDest     Deceleration for final destination
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
      }


{--------------------------------------------------------------------------}

function  DoPEPosG2Sync    ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed       : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosG2    ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed       : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

    {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.


      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Speed       Speed for positioning
            Limit       absolute limit position
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    }


{--------------------------------------------------------------------------}

function  DoPEPosG2_ASync  ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Acc         : Double;
                             Speed       : Double;
                             DecLimit    : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             DecDest     : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosG2_A  ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Acc         : Double;
                         Speed       : Double;
                         DecLimit    : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         DecDest     : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;
   {

    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the absolute limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Acc         Acceleration
            Speed       Speed for positioning
            DecLimit    Deceleration for limit position
            Limit       absolute limit position
            DecDest     Deceleration for final destination
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEPosD2Sync    ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed       : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosD2    ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed       : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

  {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Default acceleration and deceleration will be used.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.


      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Speed       Speed for positioning
            Limit       relative limit position (e.g current position + 10)
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
     }


{--------------------------------------------------------------------------}

function  DoPEPosD2_ASync  ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Acc         : Double;
                             Speed       : Double;
                             DecLimit    : Double;
                             Limit       : Double;
                             DestCtrl    : Word;
                             DecDest     : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEPosD2_A  ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Acc         : Double;
                         Speed       : Double;
                         DecLimit    : Double;
                         Limit       : Double;
                         DestCtrl    : Word;
                         DecDest     : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

  {
    Move crosshead in the specified control mode and speed to the given
    destination. Destination may be different to move control.
    Acceleration and deceleration are parameters of the command.
    After destination or the relative limit position has been reached,
    a message will be transmitted.
    This command will change control mode before the destination is reached
    and positions exactly.

      In :  DoPEHdl     DoPE link handle
            MoveCtrl    Control mode for positioning
            Acc         Acceleration
            Speed       Speed for positioning
            DecLimit    Deceleration for limit position
            Limit       relative limit position (e.g current position + 10)
            DecDest     Deceleration for final destination
            DestCtrl    Channel definition for destination
            Destination Final destination

      Out :
            usTAN       Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
  }


{ ----------------------------------------------------------------------------- }

implementation

{ ----------------------------------------------------------------------------- }

function DoPEPortInfo ( Port       : DWord;
                        First      : DWord;
                   var  pPortInfo  : DoPE_PORTINFO) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEwPortInfo ( Port       : DWord;
                         First      : DWord;
                    var  pPortInfo  : DoPE_wPORTINFO) : DWord; STDCALL;

   external 'DoPE.dll';


function DoPECurrentPortInfo ( DoPEHdl    : DoPE_HANDLE;
                          var  pPortInfo  : DoPE_PORTINFO) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEwCurrentPortInfo ( DoPEHdl    : DoPE_HANDLE;
                           var  pPortInfo  : DoPE_wPORTINFO) : DWord; STDCALL;

   external 'DoPE.dll';

{ ----------------------------------------------------------------------------- }

function DoPEDefineNIC ( Port   : DWord;
                     var pMAC   : MAC) : DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

function DoPEIgnoreTcpIpNIC ( Enable : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';


{ -------------------------------------------------------------------------- }

function DoPEOpenLink  ( Port        : DWord;
                         Portparam   : DWord;
                         RcvBuffers  : DWord;
                         XmitBuffers : DWord;
                         DataBuffers : DWord;
                         APIVersion  : DWord;
                         Reserved    : Pointer;
                     var DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

function  DoPEOpenDeviceID    ( DeviceID    : DWord;
                                RcvBuffers  : DWord;
                                XmitBuffers : DWord;
                                DataBuffers : DWord;
                                APIVersion  : DWord;
                                Reserved    : Pointer;
                           var  DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

function  DoPEOpenFunctionID  ( FunctionID  : DWord;
                                RcvBuffers  : DWord;
                                XmitBuffers : DWord;
                                DataBuffers : DWord;
                                APIVersion  : DWord;
                                Reserved    : Pointer;
                           var  DoPEHdl     : DoPE_HANDLE) : DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

function DoPECloseLink  ( var DoPEHdl : DoPE_HANDLE ) : DWord; STDCALL;

   external 'DoPE.dll';


{ ------------------------------------------------------------------------- }

function  DoPEOpenAll  ( RcvBuffers             : DWord;
                         XmitBuffers            : DWord;
                         DataBuffers            : DWord;
                         APIVersion             : DWord;
                         Reserved               : Pointer;
                         InfoTableMaxEntries    : DWord;
                     var InfoTableValidEntries  : DWord;
                     var Info                   : array of DoPEOpenLinkInfo ) : DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwOpenAll  ( RcvBuffers             : DWord;
                          XmitBuffers            : DWord;
                          DataBuffers            : DWord;
                          APIVersion             : DWord;
                          Reserved               : Pointer;
                          InfoTableMaxEntries    : DWord;
                      var InfoTableValidEntries  : DWord;
                      var Info                   : array of DoPEwOpenLinkInfo ) : DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

function  DoPECloseAll  ( InfoTableValidEntries : DWord;
                      var Info                  : array of DoPEOpenLinkInfo ) : DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwCloseAll  ( InfoTableValidEntries : DWord;
                       var Info                  : array of DoPEwOpenLinkInfo ) : DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPESetIoCompatibilityMode  ( DoPEHdl : DoPE_HANDLE;
                                       Enable  : word) : DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPESendMsgSync  ( DoPEHdl : DoPE_HANDLE;
                            Buffer  : Pointer;
                            Length  : DWord;
                            usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPESendMsg  ( DoPEHdl : DoPE_HANDLE;
                        Buffer  : Pointer;
                        Length  : DWord;
                        usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPECurrentData ( DoPEHdl  : DoPE_HANDLE;
                           Buffer   : Pointer): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPESetCycleMode ( DoPEHdl  : DoPE_HANDLE;
                             Enable   : Dword ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEGetData ( DoPEHdl : DoPE_HANDLE;
                       Buffer  : Pointer ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPECtrlTestValues  ( DoPEHdl : DoPE_HANDLE;
                               State   : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEClearReceiver ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';


{ -------------------------------------------------------------------------- }

function DoPEClearTransmitter ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEGetState ( DoPEHdl : DoPE_HANDLE;
                    var Status  : DoPEState ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEOpenSetupSync ( DoPEHdl : DoPE_HANDLE;
                             SetupNo : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEOpenSetup ( DoPEHdl : DoPE_HANDLE;
                         SetupNo : Word;
                         usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPECloseSetupSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPECloseSetup ( DoPEHdl : DoPE_HANDLE;
                          usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPESetupScale ( DoPEHdl : DoPE_HANDLE;
                          SetupNo : Word;
                          US      : UserScale;
                          usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdSetupAllSync ( DoPEHdl     : DoPE_HANDLE;
                              SetupNo     : Word;
                          var Setup       : DoPESetup ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPERdSetupAll ( DoPEHdl     : DoPE_HANDLE;
                          SetupNo     : Word;
                      var Setup       : DoPESetup;
                          usTANFirst  : PWord;
                          usTANLast   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{-----------------------------------------------------------------------------}

function DoPEWrSetupAllSync ( DoPEHdl     : DoPE_HANDLE;
                              SetupNo     : Word;
                          var Setup       : DoPESetup ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEWrSetupAll ( DoPEHdl     : DoPE_HANDLE;
                          SetupNo     : Word;
                      var Setup       : DoPESetup;
                          usTANFirst  : PWord;
                          usTANLast   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPERdSetupNumber ( DoPEHdl  : DoPE_HANDLE;
                         var SetupNo  : Word ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPESelSetup ( DoPEHdl     : DoPE_HANDLE;
                        SetupNo     : word;
                        US          : UserScale;
                        usTANFirst  : PWord;
                        usTANLast   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';


{ -------------------------------------------------------------------------- }

function DoPEInitialize ( DoPEHdl    : DoPE_HANDLE;
                          usTANFirst : PWord;
                          usTANLast  : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEInitializeResetXHead ( DoPEHdl    : DoPE_HANDLE;
                                    usTANFirst : PWord;
                                    usTANLast  : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEReInitializeEnable ( DoPEHdl : DoPE_HANDLE;
                                  Enable  : DWord;
                              var Data    : DoPEReInitializeData): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEReInitialize ( DoPEHdl : DoPE_HANDLE;
                        var Data    : DoPEReInitializeData): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEGetErrors  ( DoPEHdl : DoPE_HANDLE;
                      var Error   : DoPEError ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEClearErrors  ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetDataTransmissionRateSync  ( DoPEHdl   : DoPE_HANDLE;
                                             Refresh   : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetDataTransmissionRate  ( DoPEHdl   : DoPE_HANDLE;
                                         Refresh   : Double;
                                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}
                                         
function  DoPESetSensorDataTransmissionRateSync  ( DoPEHdl  : DoPE_HANDLE;
                                                   SensorNo : Word;
                                                   Refresh  : Double ): Dword; STDCALL;

   external 'DoPE.dll';

function  DoPESetSensorDataTransmissionRate  ( DoPEHdl  : DoPE_HANDLE;
                                               SensorNo : Word;
                                               Refresh  : Double;
                                               usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
                                         
{--------------------------------------------------------------------------}

function  DoPESetTimeSync  ( DoPEHdl   : DoPE_HANDLE;
                             Mode      : Word;
                             Time      : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetTime  ( DoPEHdl   : DoPE_HANDLE;
                         Mode      : Word;
                         Time      : Double;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPETransmitDataSync  ( DoPEHdl   : DoPE_HANDLE;
                                  Enable    : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPETransmitData  ( DoPEHdl   : DoPE_HANDLE;
                              Enable    : Word;
                              usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetBSync ( DoPEHdl     : DoPE_HANDLE;
                         BitOutputNo : Word;
                         SetB        : Word;
                         ResB        : Word;
                         FlashB      : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetB ( DoPEHdl     : DoPE_HANDLE;
                     BitOutputNo : Word;
                     SetB        : Word;
                     ResB        : Word;
                     FlashB      : Word;
                     usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEIntgrSync ( DoPEHdl   : DoPE_HANDLE;
                          SensorNo  : Word;
                          Intgr     : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEIntgr ( DoPEHdl   : DoPE_HANDLE;
                      SensorNo  : Word;
                      Intgr     : Double;
                      usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPECalSync ( DoPEHdl    : DoPE_HANDLE;
                        SensorBits : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECal ( DoPEHdl    : DoPE_HANDLE;
                    SensorBits : Word;
                    usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEZeroCalSync ( DoPEHdl     : DoPE_HANDLE;
                            SensorBits  : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEZeroCal ( DoPEHdl     : DoPE_HANDLE;
                        SensorBits  : Word;
                        usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetOutputSync ( DoPEHdl   : DoPE_HANDLE;
                              Output    : Word;
                              Value     : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetOutput ( DoPEHdl   : DoPE_HANDLE;
                          Output    : Word;
                          Value     : Double;
                          usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{----------------------------------------------------------------------------}

function DoPESetOutChannelOffsetSync ( DoPEHdl : DoPE_HANDLE;
                                       Output  : Word;
                                       Offset  : Double) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetOutChannelOffset ( DoPEHdl  : DoPE_HANDLE;
                                   Output   : Word;
                                   Offset   : Double;
                                   usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESetDitherSync ( DoPEHdl   : DoPE_HANDLE;
                             Output    : Word;
                             Frequency : Double;
                             Amplitude : Double ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetDither ( DoPEHdl     : DoPE_HANDLE;
                         Output      : Word;
                         Frequency   : Double;
                         Amplitude   : Double;
                         usTAN       : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetCheckSync ( DoPEHdl     : DoPE_HANDLE;
                             CheckId     : Word;
                             SensorNo    : Word;
                             Limit       : Double;
                             Mode        : Word;
                             Action      : Word;
                             Ctrl        : Word;
                             Acc         : Double;
                             Speed       : Double;
                             Dec         : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetCheck ( DoPEHdl     : DoPE_HANDLE;
                         CheckId     : Word;
                         SensorNo    : Word;
                         Limit       : Double;
                         Mode        : Word;
                         Action      : Word;
                         Ctrl        : Word;
                         Acc         : Double;
                         Speed       : Double;
                         Dec         : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetCheckXSync ( DoPEHdl        : DoPE_HANDLE;
                              CheckId        : Word;
                              SensorNo       : Word;
                              Limit          : Double;
                              Tare           : Double;
                              Mode           : Word;
                              Action         : Word;
                              Ctrl           : Word;
                              Acc            : Double;
                              Speed          : Double;
                              Dec            : Double;
                              Destination    : Double;
                              usTAN          : PWORD ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetCheckX (     DoPEHdl        : DoPE_HANDLE;
                              CheckId        : Word;
                              SensorNo       : Word;
                              Limit          : Double;
                              Tare           : Double;
                              Mode           : Word;
                              Action         : Word;
                              Ctrl           : Word;
                              Acc            : Double;
                              Speed          : Double;
                              Dec            : Double;
                              Destination    : Double;
                              usTAN          : PWORD ): DWord; STDCALL;

   external 'DoPE.dll';

{ --------------------------------------------------------------------------}

function  DoPEClrCheckSync ( DoPEHdl   : DoPE_HANDLE;
                             CheckId   : Word;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEClrCheck ( DoPEHdl   : DoPE_HANDLE;
                         CheckId   : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESetCheckLimitSync ( DoPEHdl        : DoPE_HANDLE;
                                 SensorNo       : Word;
                                 UprLimitSet    : Double;
                                 UprLimitReset  : Double;
                                 LwrLimitReset  : Double;
                                 LwrLimitSet    : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetCheckLimit ( DoPEHdl        : DoPE_HANDLE;
                             SensorNo       : Word;
                             UprLimitSet    : Double;
                             UprLimitReset  : Double;
                             LwrLimitReset  : Double;
                             LwrLimitSet    : Double;
                             usTAN          : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEClrCheckLimitSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEClrCheckLimit ( DoPEHdl : DoPE_HANDLE;
                             usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetCheckLimitIOSync ( DoPEHdl : DoPE_HANDLE;
                                    Output  : WORD ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetCheckLimitIO ( DoPEHdl  : DoPE_HANDLE;
                                Output   : WORD;
                                usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEShieldLimitSync ( DoPEHdl    : DoPE_HANDLE;
                               SensorNo   : Word;
                               UprLock    : Double;
                               UprUnLock  : Double;
                               LwrUnLock  : Double;
                               LwrLock    : Double;
                               CtrlLimit  : Word;
                               SpeedLimit : Double;
                               CtrlAction : Word;
                               Action     : Word;
                               usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEShieldLimit ( DoPEHdl    : DoPE_HANDLE;
                           SensorNo   : Word;
                           UprLock    : Double;
                           UprUnLock  : Double;
                           LwrUnLock  : Double;
                           LwrLock    : Double;
                           CtrlLimit  : Word;
                           SpeedLimit : Double;
                           CtrlAction : Word;
                           Action     : Word;
                           usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEShieldEnableSync ( DoPEHdl : DoPE_HANDLE;
                                Enable  : DWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEShieldEnable ( DoPEHdl : DoPE_HANDLE;
                            Enable  : DWord;
                            usTAN   : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEShieldDisableSync ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEShieldDisable ( DoPEHdl  : DoPE_HANDLE;
                             usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEShieldLockSync ( DoPEHdl  : DoPE_HANDLE;
                              State    : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEShieldLock ( DoPEHdl  : DoPE_HANDLE;
                          State    : Word;
                          usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEHaltSync ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEHalt ( DoPEHdl   : DoPE_HANDLE;
                     MoveCtrl  : Word;
                     usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESHaltSync ( DoPEHdl  : DoPE_HANDLE;
                          usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESHalt ( DoPEHdl  : DoPE_HANDLE;
                      usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEHalt_ASync ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           Dec       : Double;
                           usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEHalt_A ( DoPEHdl   : DoPE_HANDLE;
                       MoveCtrl  : Word;
                       Dec       : Double;
                       usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEHaltWSync    ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Delay     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEHaltW    ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Delay     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEHaltW_ASync  ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Dec       : Double;
                             Delay     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEHaltW_A  ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Dec       : Double;
                         Delay     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEFMoveSync ( DoPEHdl   : DoPE_HANDLE;
                          Direction : Word;
                          MoveCtrl  : Word;
                          Speed     : Double;
                          usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEFMove ( DoPEHdl   : DoPE_HANDLE;
                      Direction : Word;
                      MoveCtrl  : Word;
                      Speed     : Double;
                      usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEFMove_ASync ( DoPEHdl   : DoPE_HANDLE;
                            Direction : Word;
                            MoveCtrl  : Word;
                            Acc       : Double;
                            Speed     : Double;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEFMove_A ( DoPEHdl   : DoPE_HANDLE;
                        Direction : Word;
                        MoveCtrl  : Word;
                        Acc       : Double;
                        Speed     : Double;
                        usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ --------------------------------------------------------------------------}

function  DoPEPosSync ( DoPEHdl     : DoPE_HANDLE;
                        MoveCtrl    : Word;
                        Speed       : Double;
                        Destination : Double;
                        usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPos ( DoPEHdl     : DoPE_HANDLE;
                    MoveCtrl    : Word;
                    Speed       : Double;
                    Destination : Double;
                    usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPos_ASync ( DoPEHdl      : DoPE_HANDLE;
                          MoveCtrl     : Word;
                          Acc          : Double;
                          Speed        : Double;
                          Dec          : Double;
                          Destination  : Double;
                          usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPos_A ( DoPEHdl      : DoPE_HANDLE;
                      MoveCtrl     : Word;
                      Acc          : Double;
                      Speed        : Double;
                      Dec          : Double;
                      Destination  : Double;
                      usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEPosExtSync    ( DoPEHdl         : DoPE_HANDLE;
                             MoveCtrl        : Word;
                             Speed           : Double;
                             LimitMode       : Word;
                             Limit           : Double;
                             DestinationCtrl : Word;
                             Destination     : Double;
                             DestinationMode : Word;
                             usTAN           : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEPosExt    ( DoPEHdl         : DoPE_HANDLE;
                         MoveCtrl        : Word;
                         Speed           : Double;
                         LimitMode       : Word;
                         Limit           : Double;
                         DestinationCtrl : Word;
                         Destination     : Double;
                         DestinationMode : Word;
                         usTAN           : PWord) : DWord; STDCALL;

  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEPosExt_ASync    ( DoPEHdl         : DoPE_HANDLE;
                               MoveCtrl        : Word;
                               Acc             : Double;
                               Speed           : Double;
                               DecLimit        : Double;
                               LimitMode       : Word;
                               Limit           : Double;
                               DestinationCtrl : Word;
                               DecDestination  : Double;
                               Destination     : Double;
                               DestinationMode : Word;
                               usTAN           : PWord ) : DWORD; STDCALL;

  external 'DoPE.dll';

function DoPEPosExt_A    ( DoPEHdl         : DoPE_HANDLE;
                           MoveCtrl        : Word;
                           Acc             : Double;
                           Speed           : Double;
                           DecLimit        : Double;
                           LimitMode       : Word;
                           Limit           : Double;
                           DestinationCtrl : Word;
                           DecDestination  : Double;
                           Destination     : Double;
                           DestinationMode : Word;
                           usTAN           : PWord ) : DWORD; STDCALL;

  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPETrigSync     ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Speed        : Double;
                             Limit        : Double;
                             TriggerCtrl  : Word;
                             Trigger      : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPETrig     ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Speed        : Double;
                         Limit        : Double;
                         TriggerCtrl  : Word;
                         Trigger      : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPETrig_ASync   ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Acc          : Double;
                             Speed        : Double;
                             Dec          : Double;
                             Limit        : Double;
                             TriggerCtrl  : Word;
                             Trigger      : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPETrig_A   ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Acc          : Double;
                         Speed        : Double;
                         Dec          : Double;
                         Limit        : Double;
                         TriggerCtrl  : Word;
                         Trigger      : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEXpContSync   ( DoPEHdl   : DoPE_HANDLE;
                             MoveCtrl  : Word;
                             Limit     : Double;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEXpCont   ( DoPEHdl   : DoPE_HANDLE;
                         MoveCtrl  : Word;
                         Limit     : Double;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEStartCMDSync ( DoPEHdl   : DoPE_HANDLE;
                             Cycles    : DWord;
                             ModeFlags : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEStartCMD ( DoPEHdl   : DoPE_HANDLE;
                         Cycles    : DWord;
                         ModeFlags : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEEndCMDSync   ( DoPEHdl   : DoPE_HANDLE;
                             Operation : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEEndCMD   ( DoPEHdl   : DoPE_HANDLE;
                         Operation : Word;
                         usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEExt2CtrlSync ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             OffsetCtrl   : Double;
                             SensorNo     : Word;
                             OffsetSensor : Double;
                             Mode         : Word;
                             Scale        : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEExt2Ctrl ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         OffsetCtrl   : Double;
                         SensorNo     : Word;
                         OffsetSensor : Double;
                         Mode         : Word;
                         Scale        : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEFDPotiSync ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           MaxSpeed  : Double;
                           SensorNo  : Word;
                           DxTrigger : Word;
                           Mode      : Word;
                           Scale     : Double;
                           usTAN     : PWord): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEFDPoti ( DoPEHdl   : DoPE_HANDLE;
                       MoveCtrl  : Word;
                       MaxSpeed  : Double;
                       SensorNo  : Word;
                       DxTrigger : Word;
                       Mode      : Word;
                       Scale     : Double;
                       usTAN     : PWord): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPECycleSync ( DoPEHdl     : DoPE_HANDLE;
                          MoveCtrl    : Word;
                          Speed1      : Double;
                          Dest1       : Double;
                          Halt1       : Double;
                          Speed2      : Double;
                          Dest2       : Double;
                          Halt2       : Double;
                          Cycles      : DWord;
                          Speed       : Double;
                          Destination : Double;
                          usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECycle ( DoPEHdl     : DoPE_HANDLE;
                      MoveCtrl    : Word;
                      Speed1      : Double;
                      Dest1       : Double;
                      Halt1       : Double;
                      Speed2      : Double;
                      Dest2       : Double;
                      Halt2       : Double;
                      Cycles      : DWord;
                      Speed       : Double;
                      Destination : Double;
                      usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPECosineSync ( DoPEHdl      : DoPE_HANDLE;
                           MoveCtrl    : Word;
                           Speed1      : Double;
                           Dest1       : Double;
                           Dest2       : Double;
                           Frequency   : Double;
                           HalfCycles  : DWord;
                           Speed       : Double;
                           Destination : Double;
                           usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECosine (  DoPEHdl     : DoPE_HANDLE;
                        MoveCtrl    : Word;
                        Speed1      : Double;
                        Dest1       : Double;
                        Dest2       : Double;
                        Frequency   : Double;
                        HalfCycles  : DWord;
                        Speed       : Double;
                        Destination : Double;
                        usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPECosineXSync ( DoPEHdl      : DoPE_HANDLE;
                           MoveCtrl     : Word;
                           Speed1       : Double;
                           Dest1        : Double;
                           Halt1        : Double;
                           Dest2        : Double;
                           Halt2        : Double;
                           Frequency    : Double;
                           HalfCycles   : DWord;
                           Speed        : Double;
                           Destination  : Double;
                           usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPECosineX ( DoPEHdl      : DoPE_HANDLE;
                       MoveCtrl     : Word;
                       Speed1       : Double;
                       Dest1        : Double;
                       Halt1        : Double;
                       Dest2        : Double;
                       Halt2        : Double;
                       Frequency    : Double;
                       HalfCycles   : DWord;
                       Speed        : Double;
                       Destination  : Double;
                       usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPECosinePeakCtrlSync ( DoPEHdl : DoPE_HANDLE;
                                  Mode    : Word;
                                  Dest1   : Double;
                                  Dest2   : Double;
                                  Cycles  : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPECosinePeakCtrl ( DoPEHdl : DoPE_HANDLE;
                              Mode    : Word;
                              Dest1   : Double;
                              Dest2   : Double;
                              Cycles  : Word;
                              usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{-------------------------------------------------------------------------}

function  DoPETriangleSync ( DoPEHdl     : DoPE_HANDLE;
                             MoveCtrl    : Word;
                             Speed1      : Double;
                             Dest1       : Double;
                             Dest2       : Double;
                             Frequency   : Double;
                             HalfCycles  : DWord;
                             Speed       : Double;
                             Destination : Double;
                             usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPETriangle ( DoPEHdl     : DoPE_HANDLE;
                         MoveCtrl    : Word;
                         Speed1      : Double;
                         Dest1       : Double;
                         Dest2       : Double;
                         Frequency   : Double;
                         HalfCycles  : DWord;
                         Speed       : Double;
                         Destination : Double;
                         usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPERectangleSync ( DoPEHdl     : DoPE_HANDLE;
                              MoveCtrl    : Word;
                              Speed1      : Double;
                              Dest1       : Double;
                              Dest2       : Double;
                              Frequency   : Double;
                              HalfCycles  : DWord;
                              Speed       : Double;
                              Destination : Double;
                              usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPERectangle ( DoPEHdl     : DoPE_HANDLE;
                          MoveCtrl    : Word;
                          Speed1      : Double;
                          Dest1       : Double;
                          Dest2       : Double;
                          Frequency   : Double;
                          HalfCycles  : DWord;
                          Speed       : Double;
                          Destination : Double;
                          usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEDynCyclesSync ( DoPEHdl                 : DoPE_HANDLE;
                             WaveForm                : Word;
                             Modify                  : Word;
                             PeakCtrl                : Word;
                             MoveCtrl                : Word;
                             RelativeDestination     : Word;
                             SpeedToStart            : Double;
                             Offset                  : Double;
                             Amplitude               : Double;
                             HaltAtPlusAmplitude     : Double;
                             HaltAtMinusAmplitude    : Double;
                             Frequency               : Double;
                             HalfCycles              : DWord;
                             SpeedToDestination      : Double;
                             Destination             : Double;
                             SweepFrequencyMode      : Word;
                             SweepEndFrequency       : Double;
                             SweepFrequencyTime      : Double;
                             SweepFrequencyCount     : DWord;
                             SweepOffsetMode         : DWord;
                             SweepEndOffset          : Double;
                             SweepOffsetTime         : Double;
                             SweepOffsetCount        : DWord;
                             SweepAmplitudeMode      : Word;
                             SweepEndAmplitude       : Double;
                             SweepAmplitudeTime      : Double;
                             SweepAmplitudeCount     : DWord;
                             SuperpositionMode       : Word;
                             SuperpositionFrequency  : Double;
                             SuperpositionAmplitude  : Double;
                             BimodalCtrlMode         : Word;
                             BimodalCtrlSensor       : Word;
                             BimodalValue1           : Double;
                             BimodalValue2           : Double;
                             BimodalScale            : Double;
                             usTAN                   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEDynCycles ( DoPEHdl                 : DoPE_HANDLE;
                         WaveForm                : Word;
                         Modify                  : Word;
                         PeakCtrl                : Word;
                         MoveCtrl                : Word;
                         RelativeDestination     : Word;
                         SpeedToStart            : Double;
                         Offset                  : Double;
                         Amplitude               : Double;
                         HaltAtPlusAmplitude     : Double;
                         HaltAtMinusAmplitude    : Double;
                         Frequency               : Double;
                         HalfCycles              : DWord;
                         SpeedToDestination      : Double;
                         Destination             : Double;
                         SweepFrequencyMode      : Word;
                         SweepEndFrequency       : Double;
                         SweepFrequencyTime      : Double;
                         SweepFrequencyCount     : DWord;
                         SweepOffsetMode         : DWord;
                         SweepEndOffset          : Double;
                         SweepOffsetTime         : Double;
                         SweepOffsetCount        : DWord;
                         SweepAmplitudeMode      : Word;
                         SweepEndAmplitude       : Double;
                         SweepAmplitudeTime      : Double;
                         SweepAmplitudeCount     : DWord;
                         SuperpositionMode       : Word;
                         SuperpositionFrequency  : Double;
                         SuperpositionAmplitude  : Double;
                         BimodalCtrlMode         : Word;
                         BimodalCtrlSensor       : Word;
                         BimodalValue1           : Double;
                         BimodalValue2           : Double;
                         BimodalScale            : Double;
                         usTAN                   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESpeedLimitSync ( DoPEHdl  : DoPE_HANDLE;
                              Ctrl     : Word;
                              Speed    : Double ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPESpeedLimit ( DoPEHdl : DoPE_HANDLE;
                          Ctrl    : Word;
                          Speed   : Double;
                          usTAN   : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEOffsCSync ( DoPEHdl   : DoPE_HANDLE;
                          Speed     : Double;
                          PosDiff   : Double;
                          usTAN     : PWord): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEOffsC ( DoPEHdl   : DoPE_HANDLE;
                      Speed     : Double;
                      PosDiff   : Double;
                      usTAN     : PWord): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDefaultAccSync ( DoPEHdl   : DoPE_HANDLE;
                               MoveCtrl  : Word;
                               Acc       : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEDefaultAcc ( DoPEHdl   : DoPE_HANDLE;
                           MoveCtrl  : Word;
                           Acc       : Double;
                           usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetCtrlSync ( DoPEHdl   : DoPE_HANDLE;
                            State     : Word;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetCtrl ( DoPEHdl   : DoPE_HANDLE;
                        State     : Word;
                        usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEEmergencyMoveSync ( DoPEHdl   : DoPE_HANDLE;
                                  State     : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEEmergencyMove ( DoPEHdl   : DoPE_HANDLE;
                              State     : Word;
                              usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEEmergencyOffSync ( DoPEHdl   : DoPE_HANDLE;
                                 Status    : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEEmergencyOff ( DoPEHdl   : DoPE_HANDLE;
                             Status    : Word;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEPosPIDSync ( DoPEHdl  : DoPE_HANDLE;
                          MoveCtrl : Word;
                          PosP     : DWord;
                          PosI     : Word;
                          PosD     : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEPosPID ( DoPEHdl  : DoPE_HANDLE;
                      MoveCtrl : Word;
                      PosP     : DWord;
                      PosI     : Word;
                      PosD     : Word;
                      usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdPosPID ( DoPEHdl      : DoPE_HANDLE;
                        MoveCtrl     : Word;
                        HighPressure : DWord;
                    var PosP         : DWord;
                    var PosI         : Word;
                    var PosD         : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrPosPIDSync ( DoPEHdl      : DoPE_HANDLE;
                            MoveCtrl     : Word;
                            HighPressure : DWord;
                            PosP         : DWord;
                            PosI         : Word;
                            PosD         : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEWrPosPID ( DoPEHdl      : DoPE_HANDLE;
                        MoveCtrl     : Word;
                        HighPressure : DWord;
                        PosP         : DWord;
                        PosI         : Word;
                        PosD         : Word;
                        usTAN        : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESpeedPIDSync ( DoPEHdl  : DoPE_HANDLE;
                            MoveCtrl : Word;
                            SpeedP        : DWord;
                            SpeedI   : Word;
                            SpeedD   : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPESpeedPID ( DoPEHdl  : DoPE_HANDLE;
                        MoveCtrl : Word;
                        SpeedP        : DWord;
                        SpeedI   : Word;
                        SpeedD   : Word;
                        usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSpeedPID ( DoPEHdl      : DoPE_HANDLE;
                          MoveCtrl     : Word;
                          HighPressure : DWord;
                      var SpeedP       : DWord;
                      var SpeedI       : Word;
                      var SpeedD       : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSpeedPIDSync ( DoPEHdl      : DoPE_HANDLE;
                              MoveCtrl     : Word;
                              HighPressure : DWord;
                              SpeedP       : DWord;
                              SpeedI       : Word;
                              SpeedD       : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEWrSpeedPID ( DoPEHdl      : DoPE_HANDLE;
                          MoveCtrl     : Word;
                          HighPressure : DWord;
                          SpeedP       : DWord;
                          SpeedI       : Word;
                          SpeedD       : Word;
                          usTAN        : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPECurrentPIDSync ( DoPEHdl  : DoPE_HANDLE;
                               Output   : Word;
                               P        : DWord;
                               I        : Word;
                               D        : Word ) : DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECurrentPID ( DoPEHdl  : DoPE_HANDLE;
                           Output   : Word;
                           P        : DWord;
                           I        : Word;
                           D        : Word;
                           usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEPosFeedForwardSync ( DoPEHdl  : DoPE_HANDLE;
                                  MoveCtrl : Word;
                                  PosFFP   : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEPosFeedForward ( DoPEHdl  : DoPE_HANDLE;
                              MoveCtrl : Word;
                              PosFFP   : DWord;
                              usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEFeedForwardSync ( DoPEHdl    : DoPE_HANDLE;
                               MoveCtrl   : Word;
                               SpeedFFP   : Word;
                               PosDelay   : Word;
                               AccFFP     : Word;
                               SpeedDelay : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEFeedForward ( DoPEHdl    : DoPE_HANDLE;
                           MoveCtrl   : Word;
                           SpeedFFP   : Word;
                           PosDelay   : Word;
                           AccFFP     : Word;
                           SpeedDelay : Word;
                           usTAN      : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdFeedForward ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             HighPressure : DWord;
                         var SpeedFFP     : Word;
                         var PosDelay     : Word;
                         var AccFFP       : Word;
                         var SpeedDelay   : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrFeedForwardSync ( DoPEHdl      : DoPE_HANDLE;
                                 MoveCtrl     : Word;
                                 HighPressure : DWord;
                                 SpeedFFP     : Word;
                                 PosDelay     : Word;
                                 AccFFP       : Word;
                                 SpeedDelay   : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEWrFeedForward ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             HighPressure : DWord;
                             SpeedFFP     : Word;
                             PosDelay     : Word;
                             AccFFP       : Word;
                             SpeedDelay   : Word;
                             usTAN        : PWord ) : DWord; STDCALL;
  external 'DoPE.dll';


{--------------------------------------------------------------------------}

function DoPEOptimizeFeedForwardSync ( DoPEHdl    : DoPE_HANDLE;
                                       MoveCtrl   : Word;
                                       Mode       : Word;
                                       Offset     : Double;
                                       Amplitude  : Double;
                                       Frequency  : Double;
                                       usTAN      : PWord )   : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEOptimizeFeedForward ( DoPEHdl    : DoPE_HANDLE;
                                   MoveCtrl   : Word;
                                   Mode       : Word;
                                   Offset     : Double;
                                   Amplitude  : Double;
                                   Frequency  : Double;
                                   usTAN      : PWord )   : DWord; STDCALL;

  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDestWndSync ( DoPEHdl   : DoPE_HANDLE;
                            MoveCtrl  : Word;
                            WndSize   : Double;
                            WndTime   : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEDestWnd ( DoPEHdl   : DoPE_HANDLE;
                        MoveCtrl  : Word;
                        WndSize   : Double;
                        WndTime   : Double;
                        usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESftSync ( DoPEHdl   : DoPE_HANDLE;
                        MoveCtrl  : Word;
                        UpperSft  : Double;
                        LowerSft  : Double;
                        Reaction  : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESft ( DoPEHdl   : DoPE_HANDLE;
                    MoveCtrl  : Word;
                    UpperSft  : Double;
                    LowerSft  : Double;
                    Reaction  : Word;
                    usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPECtrlErrorSync ( DoPEHdl   : DoPE_HANDLE;
                              MoveCtrl  : Word;
                              Error     : Double;
                              Reaction  : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECtrlError ( DoPEHdl   : DoPE_HANDLE;
                          MoveCtrl  : Word;
                          Error     : Double;
                          Reaction  : Word;
                          usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPECtrlSpeedTimeBaseSync ( DoPEHdl  : DoPE_HANDLE;
                                      Time     : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECtrlSpeedTimeBase ( DoPEHdl  : DoPE_HANDLE;
                                  Time     : Double;
                                  usTan    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDeadbandCtrlSync ( DoPEHdl  : DoPE_HANDLE;
                                 MoveCtrl : word;
                                 Deadband : Double;
                                 PercentP : word ): DWord; STDCALL;

   external 'DoPE.dll';

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPEDeadbandCtrl ( DoPEHdl  : DoPE_HANDLE;
                             MoveCtrl : word;
                             Deadband : Double;
                             PercentP : word;
                             usTan    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetNominalAccSpeedSync ( DoPEHdl  : DoPE_HANDLE;
                                       MoveCtrl : word;
                                       Acc      : Double;
                                       Speed    : Double ): DWord; STDCALL;

   external 'DoPE.dll';

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

function  DoPESetNominalAccSpeed ( DoPEHdl  : DoPE_HANDLE;
                                   MoveCtrl : word;
                                   Acc      : Double;
                                   Speed    : Double;
                                   usTan    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPESetOpenLoopCommandSync ( DoPEHdl  : DoPE_HANDLE;
                                       Command  : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPESetOpenLoopCommand ( DoPEHdl  : DoPE_HANDLE;
                                   Command  : Double;
                                   usTan    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdVersion ( DoPEHdl : DoPE_HANDLE;
                     var Version : DoPEVersion ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEwRdVersion ( DoPEHdl : DoPE_HANDLE;
                      var Version : DoPEwVersion ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdModuleInfo ( DoPEHdl  : DoPE_HANDLE;
                            ModulNo  : DWord;
                        var Info     : DoPEModuleInfo) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEwRdModuleInfo ( DoPEHdl  : DoPE_HANDLE;
                             ModulNo  : DWord;
                         var Info     : DoPEwModuleInfo) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPERdDriveInfo ( DoPEHdl   : DoPE_HANDLE;
                            Connector : Word;
                        var Info      : DoPEDriveInfo) : DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwRdDriveInfo ( DoPEHdl   : DoPE_HANDLE;
                             Connector : Word;
                         var Info      : DoPEwDriveInfo) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEwRdLanguageInfo ( DoPEHdl   : DoPE_HANDLE;
                            var Info      : DoPEwLanguageInfo) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEOnSync ( DoPEHdl : DoPE_HANDLE ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEOn ( DoPEHdl : DoPE_HANDLE;
                  usTAN   : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEOffSync ( DoPEHdl : DoPE_HANDLE ) : DWord; STDCALL;

   external 'DoPE.dll';

function DoPEOff ( DoPEHdl    : DoPE_HANDLE;
                   usTANFirst : PWord;
                   usTANLast  : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPECalOutSync ( DoPEHdl  : DoPE_HANDLE;
                           Cal      : Word ):DWord; STDCALL;

   external 'DoPE.dll';

function  DoPECalOut ( DoPEHdl : DoPE_HANDLE;
                       Cal     : Word;
                       usTAN   : PWord ):DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEBeepSync ( DoPEHdl : DoPE_HANDLE;
                         Beep    : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEBeep ( DoPEHdl : DoPE_HANDLE;
                     Beep    : Word;
                     usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPELedSync ( DoPEHdl  : DoPE_HANDLE;
                        LedOn    : Word;
                        LedOff   : Word;
                        LedFlash : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPELed ( DoPEHdl  : DoPE_HANDLE;
                    LedOn    : Word;
                    LedOff   : Word;
                    LedFlash : Word;
                    usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEUniOutSync ( DoPEHdl  : DoPE_HANDLE;
                           Output   : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEUniOut ( DoPEHdl  : DoPE_HANDLE;
                       Output   : Word;
                       usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEBypassSync ( DoPEHdl  : DoPE_HANDLE;
                           Bypass   : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEBypass ( DoPEHdl  : DoPE_HANDLE;
                       Bypass   : Word;
                       usTAN    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDspClearSync    ( DoPEHdl : DoPE_HANDLE ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEDspClear    ( DoPEHdl : DoPE_HANDLE;
                            usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDspHeadLineSync ( DoPEHdl   : DoPE_HANDLE;
                                HeadLine  : PChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspHeadLineSync ( DoPEHdl   : DoPE_HANDLE;
                                 HeadLine  : PWideChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEDspHeadLine ( DoPEHdl   : DoPE_HANDLE;
                            HeadLine  : PChar;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspHeadLine ( DoPEHdl   : DoPE_HANDLE;
                             HeadLine  : PWideChar;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDspFKeysSync    ( DoPEHdl   : DoPE_HANDLE;
                                FKeys     : PChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspFKeysSync    ( DoPEHdl   : DoPE_HANDLE;
                                 FKeys     : PWideChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEDspFKeys    ( DoPEHdl   : DoPE_HANDLE;
                            FKeys     : PChar;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspFKeys    ( DoPEHdl   : DoPE_HANDLE;
                             FKeys     : PWideChar;
                             usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEDspMValueSync   ( DoPEHdl   : DoPE_HANDLE;
                                Value1    : PChar;
                                Value2    : PChar;
                                Dim1      : PChar;
                                Dim2      : PChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspMValueSync   ( DoPEHdl   : DoPE_HANDLE;
                                 Value1    : PWideChar;
                                 Value2    : PWideChar;
                                 Dim1      : PWideChar;
                                 Dim2      : PWideChar ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEDspMValue   ( DoPEHdl   : DoPE_HANDLE;
                            Value1    : PChar;
                            Value2    : PChar;
                            Dim1      : PChar;
                            Dim2      : PChar;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEwDspMValue   ( DoPEHdl   : DoPE_HANDLE;
                             Value1    : PWideChar;
                             Value2    : PWideChar;
                             Dim1      : PWideChar;
                             Dim2      : PWideChar;
                             usTAN     : PWord): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEDspBeamScreenSync ( DoPEHdl  : DoPE_HANDLE;
                                 Value    : SmallInt ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEDspBeamScreen ( DoPEHdl : DoPE_HANDLE;
                             Value   : SmallInt;
                             usTAN   : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEDspBeamValueSync ( DoPEHdl   : DoPE_HANDLE;
                                Value     : SmallInt ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEDspBeamValue ( DoPEHdl   : DoPE_HANDLE;
                            Value     : SmallInt;
                            usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{----------------------------------------------------------------------------}

function DoPESetRefSignalMode ( DoPEHdl  : DoPE_HANDLE;
                                SensorNo : Word;
                                Mode     : Word;
                                usTAN    : PWord) : DWord; STDCALL;

   external 'DoPE.dll';

{----------------------------------------------------------------------------}

function DoPESetRefSignalTare ( DoPEHdl  : DoPE_HANDLE;
                                SensorNo : Word;
                                Mode     : Word;
                                Tare     : Double;
                                usTAN    : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESetBasicTareSync ( DoPEHdl    : DoPE_HANDLE;
                                SensorNo   : Word;
                                Mode       : Word;
                                BasicTare  : Double ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPESetBasicTare ( DoPEHdl    : DoPE_HANDLE;
                            SensorNo   : Word;
                            Mode       : Word;
                            BasicTare  : Double;
                            usTANFirst : PWord;
                            usTANLast  : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPESetTare ( DoPEHdl    : DoPE_HANDLE;
                       SensorNo   : Word;
                       Tare       : Double ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------}

function DoPEGetBasicTare ( DoPEHdl   : DoPE_HANDLE;
                            SensorNo  : Word;
                        var BasicTare : Double ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------}

function DoPEGetTare ( DoPEHdl  : DoPE_HANDLE;
                       SensorNo : Word;
                   var Tare     : Double ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdSensorInfo ( DoPEHdl   : DoPE_HANDLE;
                            SensorNo  : Word;
                        var Info      : DoPESumSenInfo ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorDef ( DoPEHdl    : DoPE_HANDLE;
                           SensorNo   : Word;
                       var SensorDef  : DoPESenDef ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdCtrlSensorDef ( DoPEHdl        : DoPE_HANDLE;
                                 SensorNo       : Word;
                             var CtrlSensorDef  : DoPECtrlSenDef ): DWord; STDCALL;

   external 'DoPE.dll';

  function DoPERdCtrlSensorDefHigh ( DoPEHdl       : DoPE_HANDLE;
                                     SensorNo      : Word;
                                 var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;
   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdOutChannelDef ( DoPEHdl   : DoPE_HANDLE;
                                 OutChNo   : Word;
                             var OutChDef  : DoPEOutChaDef ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdBitOutDef ( DoPEHdl    : DoPE_HANDLE;
                             BitOutNo   : Word;
                         var BitOutDef  : DoPEBitOutDef ): DWord; STDCALL;


   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdBitInDef ( DoPEHdl   : DoPE_HANDLE;
                            BitInNo   : Word;
                        var BitInDef  : DoPEBitInDef ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdMachineDef ( DoPEHdl     : DoPE_HANDLE;
                          var MachineDef  : DoPEMachineDef ): DWord; STDCALL;

   external 'DoPE.dll';

{ ------------------------------------------------------------------------- }

  function DoPERdLinTbl ( DoPEHdl      : DoPE_HANDLE;
                      var LinTblFalse  : DoPELinTblFalse;
                      var LinTblTrue   :  DoPELinTblTrue ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdIOSignals ( DoPEHdl   : DoPE_HANDLE;
                       var IOSignals : DoPEIOSignals ): DWord; STDCALL;

  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdMainMenu ( DoPEHdl  : DoPE_HANDLE;
                          MainMenu : MenuTable ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdRmcDef ( DoPEHdl  : DoPE_HANDLE;
                    var RmcDef   : DoPERmcDef ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdSysUserData ( DoPEHdl     : DoPE_HANDLE;
                               SysUsrData  : Pointer;
                               Length      : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorHeaderData ( DoPEHdl    : DoPE_HANDLE;
                                  Connector  : Word;
                              var SenHdrData : DoPESensorHeaderData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorAnalogueData ( DoPEHdl         : DoPE_HANDLE;
                                    Connector       : Word;
                                var SenAnalogueData : DoPESensorAnalogueData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorIncData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenIncData : DoPESensorIncData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorAbsData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenAbsData : DoPESensorAbsData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorUserData ( DoPEHdl    : DoPE_HANDLE;
                                Connector  : Word;
                                SenUsrData : Pointer;
                                Length     : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSenUserData ( DoPEHdl    : DoPE_HANDLE;
                             SensorNo   : Word;
                             SenUsrData : Pointer;
                             Length     : DWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPERdSensorConKey ( DoPEHdl    : DoPE_HANDLE;
                              Connector  : Word;
                              Connected  : PWord;
                              KeyPressed : PWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

  function DoPERdGeneralData ( DoPEHdl      : DoPE_HANDLE;
                           var GeneralData  : DoPEGeneralData ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPERdCtrlParameter ( DoPEHdl       : DoPE_HANDLE;
                               MoveCtrl      : word;
                           var CtrlParameter : DoPECtrlParameter ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorDefSync ( DoPEHdl    : DoPE_HANDLE;
                               SensorNo   : Word;
                           var SensorDef  : DoPESenDef ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEWrSensorDef ( DoPEHdl    : DoPE_HANDLE;
                           SensorNo   : Word;
                       var SensorDef  : DoPESenDef;
                           usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrCtrlSensorDefSync ( DoPEHdl        : DoPE_HANDLE;
                                    SensorNo       : Word;
                                var CtrlSensorDef  : DoPECtrlSenDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrCtrlSensorDefHighSync ( DoPEHdl       : DoPE_HANDLE;
                                        SensorNo      : Word;
                                    var CtrlSensorDef : DoPECtrlSenDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrCtrlSensorDef ( DoPEHdl        : DoPE_HANDLE;
                                SensorNo       : Word;
                            var CtrlSensorDef  : DoPECtrlSenDef;
                                usTAN          : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrCtrlSensorDefHigh ( DoPEHdl        : DoPE_HANDLE;
                                    SensorNo       : Word;
                                var CtrlSensorDef  : DoPECtrlSenDef;
                                    usTAN          : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrOutChannelDefSync ( DoPEHdl   : DoPE_HANDLE;
                                    OutChNo   : Word;
                                var OutChDef  : DoPEOutChaDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrOutChannelDef ( DoPEHdl   : DoPE_HANDLE;
                                OutChNo   : Word;
                            var OutChDef  : DoPEOutChaDef;
                                usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrBitOutDefSync ( DoPEHdl    : DoPE_HANDLE;
                                BitOutNo   : Word;
                            var BitOutDef  : DoPEBitOutDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrBitOutDef ( DoPEHdl    : DoPE_HANDLE;
                            BitOutNo   : Word;
                        var BitOutDef  : DoPEBitOutDef;
                            usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrBitInDefSync ( DoPEHdl   : DoPE_HANDLE;
                               BitInNo   : Word;
                           var BitInDef  : DoPEBitInDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrBitInDef ( DoPEHdl   : DoPE_HANDLE;
                           BitInNo   : Word;
                       var BitInDef  : DoPEBitInDef;
                           usTAN     : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrMachineDefSync ( DoPEHdl     : DoPE_HANDLE;
                             var MachineDef  : DoPEMachineDef ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrMachineDef ( DoPEHdl     : DoPE_HANDLE;
                         var MachineDef  : DoPEMachineDef;
                             usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrLinTblSync ( DoPEHdl     : DoPE_HANDLE;
                        var LinTblFalse  : DoPELinTblFalse;
                        var LinTblTrue   : DoPELinTblTrue ): DWord; STDCALL;

   external 'DoPE.dll';


function  DoPEWrLinTbl ( DoPEHdl      : DoPE_HANDLE;
                     var LinTblFalse  : DoPELinTblFalse;
                     var LinTblTrue   : DoPELinTblTrue;
                         usTANFirst   : PWord;
                         usTANLast    : PWord ): DWord; STDCALL;

   external 'DoPE.dll';
   
{---------------------------------------------------------------------------}

function DoPEWrIOSignalsSync ( DoPEHdl   : DoPE_HANDLE;
                           var IOSignals : DoPEIOSignals ): DWord; STDCALL;

  external 'DoPE.dll';

function DoPEWrIOSignals ( DoPEHdl   : DoPE_HANDLE;
                       var IOSignals : DoPEIOSignals;
                           usTAN     : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrMainMenuSync ( DoPEHdl  : DoPE_HANDLE;
                              MainMenu : MenuTable ): DWord; STDCALL;

  external 'DoPE.dll';

function DoPEWrMainMenu ( DoPEHdl  : DoPE_HANDLE;
                          MainMenu : MenuTable;
                          usTAN    : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrRmcDefSync ( DoPEHdl  : DoPE_HANDLE;
                         var RmcDef   : DoPERmcDef ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEWrRmcDef ( DoPEHdl  : DoPE_HANDLE;
                     var RmcDef   : DoPERmcDef;
                         usTAN    : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrSysUserDataSync ( DoPEHdl     : DoPE_HANDLE;
                                  SysUsrData  : Pointer;
                                  Length      : DWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrSysUserData ( DoPEHdl     : DoPE_HANDLE;
                              SysUsrData  : Pointer;
                              Length      : DWord;
                              usTAN       : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorHeaderData ( DoPEHdl    : DoPE_HANDLE;
                                  Connector  : Word;
                              var SenHdrData : DoPESensorHeaderData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorAnalogueData ( DoPEHdl         : DoPE_HANDLE;
                                    Connector       : Word;
                                var SenAnalogueData : DoPESensorAnalogueData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorIncData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenIncData : DoPESensorIncData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorAbsData ( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                           var SenAbsData : DoPESensorAbsData ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPESetSsiGenericSignalType ( SignalType : PByte;
                                       Code       : DWord;
                                       Bits       : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPESsiGenericSignalTypeInfo ( SignalType : Byte;
                                        Code       : PDWord;
                                        Bits       : PDWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorUserData ( DoPEHdl    : DoPE_HANDLE;
                                Connector  : Word;
                                SenUsrData : Pointer;
                                Length     : DWord ) : DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSenUserDataSync ( DoPEHdl    : DoPE_HANDLE;
                                 SensorNo   : Word;
                                 SenUsrData : Pointer;
                                 Length     : DWord ): DWord; STDCALL;

   external 'DoPE.dll';

function DoPEWrSenUserData     ( DoPEHdl    : DoPE_HANDLE;
                                 SensorNo   : Word;
                                 SenUsrData : Pointer;
                                 Length     : DWord;
                                 usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPEWrGeneralDataSync ( DoPEHdl      : DoPE_HANDLE;
                              var GeneralData  : DoPEGeneralData ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrGeneralData ( DoPEHdl      : DoPE_HANDLE;
                          var GeneralData  : DoPEGeneralData;
                              usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPERdBitInput ( DoPEHdl    : DoPE_HANDLE;
                           Connector  : Word;
                       var Value      : Word ): DWord; STDCALL;

  external 'DoPE.dll';


{--------------------------------------------------------------------------}

function  DoPEWrBitOutputSync( DoPEHdl    : DoPE_HANDLE;
                               Connector  : Word;
                               Value      : Word ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEWrBitOutput( DoPEHdl    : DoPE_HANDLE;
                           Connector  : Word;
                           Value      : Word;
                           usTAN      : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function    DoPEConfPeakValueSync  ( DoPEHdl      : DoPE_HANDLE;
                                     PositionMin  : Word;
                                     PositionMax  : Word;
                                     LoadMin      : Word;
                                     LoadMax      : Word;
                                     ExtensionMin : Word;
                                     ExtensionMax : Word ): DWord; STDCALL;

  external 'DoPE.dll';

function    DoPEConfPeakValue  ( DoPEHdl      : DoPE_HANDLE;
                                 PositionMin  : Word;
                                 PositionMax  : Word;
                                 LoadMin      : Word;
                                 LoadMax      : Word;
                                 ExtensionMin : Word;
                                 ExtensionMax : Word;
                                 usTANFirst   : PWord;
                                 usTANLast    : PWord ): DWord; STDCALL;
  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEPeakValueTimeSync  ( DoPEHdl : DoPE_HANDLE;
                                   Time    : Double ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEPeakValueTime  ( DoPEHdl : DoPE_HANDLE;
                               Time    : Double;
                               usTAN   : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEConfCMcSpeedSync  ( DoPEHdl            : DoPE_HANDLE;
                                  CalculatedSensorNo : Word;
                                  SensorNo           : Word;
                                  IntegrationTime    : Double;
                                  Timebase           : Double ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEConfCMcSpeed  ( DoPEHdl            : DoPE_HANDLE;
                              CalculatedSensorNo : Word;
                              SensorNo           : Word;
                              IntegrationTime    : Double;
                              Timebase           : Double;
                              usTANFirst         : PWord;
                              usTANLast          : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEConfCMcCommandSpeedSync  ( DoPEHdl            : DoPE_HANDLE;
                                         CalculatedSensorNo : Word;
                                         Timebase           : Double ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEConfCMcCommandSpeed  ( DoPEHdl            : DoPE_HANDLE;
                                     CalculatedSensorNo : Word;
                                     Timebase           : Double;
                                     usTANFirst         : PWord;
                                     usTANLast          : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEConfCMcGradientSync  ( DoPEHdl            : DoPE_HANDLE;
                                     CalculatedSensorNo : Word;
                                     DividentSensorNo   : Word;
                                     DivisorSensorNo    : Word;
                                     IntegrationTime    : Double;
                                     Timebase           : Double ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEConfCMcGradient  ( DoPEHdl            : DoPE_HANDLE;
                                 CalculatedSensorNo : Word;
                                 DividentSensorNo   : Word;
                                 DivisorSensorNo    : Word;
                                 IntegrationTime    : Double;
                                 Timebase           : Double;
                                 usTANFirst         : PWord;
                                 usTANLast          : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEClearCMcSync  ( DoPEHdl            : DoPE_HANDLE;
                              CalculatedSensorNo : Word ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEClearCMc  ( DoPEHdl            : DoPE_HANDLE;
                          CalculatedSensorNo : Word;
                          usTANFirst         : PWord;
                          usTANLast          : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPEMc2OutputSync  ( DoPEHdl      : DoPE_HANDLE;
                               Mode         : Word;
                               Priority     : Word;
                               SensorNo     : Word;
                               Output       : Word;
                               SensorPoint  : Mc2OutputPoints;
                               OutputPoint  : Mc2OutputPoints ): DWord; STDCALL;

  external 'DoPE.dll';

function  DoPEMc2Output      ( DoPEHdl      : DoPE_HANDLE;
                               Mode         : Word;
                               Priority     : Word;
                               SensorNo     : Word;
                               Output       : Word;
                               SensorPoint  : Mc2OutputPoints;
                               OutputPoint  : Mc2OutputPoints;
                               usTan        : PWord ): DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEWrSensorMsgSync ( DoPEHdl  : DoPE_HANDLE;
                               SensorNo : Word;
                               Buffer   : Pointer;
                               Length   : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEWrSensorMsg ( DoPEHdl  : DoPE_HANDLE;
                           SensorNo : Word;
                           Buffer   : Pointer;
                           Length   : DWord;
                           usTAN    : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPESerialSensorDefSync ( DoPEHdl     : DoPE_HANDLE;
                                    SensorNo    : Word;
                                    Timeout     : double;
                                    MaxLength   : Word;
                                    EndChar1    : char;
                                    EndChar2    : char;
                                    EndCharMode : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

function  DoPESerialSensorDef ( DoPEHdl     : DoPE_HANDLE;
                                SensorNo    : Word;
                                Timeout     : double;
                                MaxLength   : Word;
                                EndChar1    : char;
                                EndChar2    : char;
                                EndCharMode : Word;
                                usTAN       : PWord ) : DWord; STDCALL;
  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function  DoPESetSerialSensorSync ( DoPEHdl     : DoPE_HANDLE;
                                    SensorNo    : Word;
                                    Mode        : Word;
                                    Value       : double;
                                    Speed       : double ) : DWord; STDCALL;

  external 'DoPE.dll';

function  DoPESetSerialSensor ( DoPEHdl     : DoPE_HANDLE;
                                SensorNo    : Word;
                                Mode        : Word;
                                Value       : double;
                                Speed       : double;
                                usTAN       : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function  DoPESetSerialSensorTransparentSync ( DoPEHdl     : DoPE_HANDLE;
                                               SensorNo    : Word;
                                               Mode        : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

function  DoPESetSerialSensorTransparent ( DoPEHdl     : DoPE_HANDLE;
                                           SensorNo    : Word;
                                           Mode        : Word;
                                           usTAN       : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEOfflineActionBitOutputSync ( DoPEHdl     : DoPE_HANDLE;
                                          BitOutputNo : Word;
                                          Mode        : Word;
                                          Value       : Word ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEOfflineActionBitOutput ( DoPEHdl     : DoPE_HANDLE;
                                      BitOutputNo : Word;
                                      Mode        : Word;
                                      Value       : Word;
                                      usTAN       : PWord ) : DWord; STDCALL;
  external 'DoPE.dll';

{--------------------------------------------------------------------------}

function DoPEOfflineActionOutputSync ( DoPEHdl  : DoPE_HANDLE;
                                       OutputNo : Word;
                                       Mode     : Word;
                                       Value    : Double ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEOfflineActionOutput ( DoPEHdl  : DoPE_HANDLE;
                                   OutputNo : Word;
                                   Mode     : Word;
                                   Value    : Double;
                                   usTAN    : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOGripEnableSync( DoPEHdl : DoPE_HANDLE;
                               Enable  : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOGripEnable( DoPEHdl  : DoPE_HANDLE;
                           Enable   : DWord;
                           usTAN    : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOGripSetSync( DoPEHdl  : DoPE_HANDLE;
                            Grip     : DWord;
                            Action   : DWord;
                            Pressure : Double ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOGripSet( DoPEHdl  : DoPE_HANDLE;
                        Grip     : DWord;
                        Action   : DWord;
                        Pressure : Double;
                        usTAN    : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOGripPressureSync( DoPEHdl      : DoPE_HANDLE;
                                 LowPressure  : Double;
                                 HighPressure : Double;
                                 RampTime     : Double ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOGripPressure( DoPEHdl      : DoPE_HANDLE;
                             LowPressure  : Double;
                             HighPressure : Double;
                             RampTime     : Double;
                             usTAN        : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';


{---------------------------------------------------------------------------}

function DoPEIOExtEnableSync( DoPEHdl : DoPE_HANDLE;
                              Enable  : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOExtEnable( DoPEHdl : DoPE_HANDLE;
                          Enable  : DWord;
                          usTAN   : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOExtSetSync( DoPEHdl : DoPE_HANDLE;
                           Ext     : DWord;
                           Action  : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOFixedXHeadEnableSync( DoPEHdl : DoPE_HANDLE;
                                     Enable  : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOExtSet( DoPEHdl : DoPE_HANDLE;
                       Ext     : DWord;
                       Action  : DWord;
                       usTAN   : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOFixedXHeadEnable( DoPEHdl : DoPE_HANDLE;
                                 Enable  : DWord;
                                 usTAN   : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOFixedXHeadSetSync( DoPEHdl   : DoPE_HANDLE;
                                  Direction : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOFixedXHeadSet( DoPEHdl   : DoPE_HANDLE;
                              Direction : DWord;
                              usTAN     : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{---------------------------------------------------------------------------}

function DoPEIOHighPressureEnableSync( DoPEHdl : DoPE_HANDLE;
                                       Enable  : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOHighPressureEnable( DoPEHdl : DoPE_HANDLE;
                                   Enable  : DWord;
                                   usTAN   : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';

{ -------------------------------------------------------------------------- }

function DoPEIOHighPressureSetSync( DoPEHdl      : DoPE_HANDLE;
                                    HighPressure : DWord ) : DWord; STDCALL;

  external 'DoPE.dll';

function DoPEIOHighPressureSet( DoPEHdl      : DoPE_HANDLE;
                                HighPressure : DWord;
                                usTAN        : PWord ) : DWord; STDCALL;

  external 'DoPE.dll';


{ -------------------------------------------------------------------------- }

function DoPESetNotification  ( DoPEHdl    : DoPE_HANDLE;
                                EventMask  : DWord;
                                NotifyProc : NPROC;
                                NotifyWnd  : HWND;
                                NotifyMsg  : UINT ): DWORD; STDCALL;

   external 'DoPE.dll';


{ -------------------------------------------------------------------------- }

function DoPEGetMsg  ( DoPEHdl : DoPE_HANDLE;
                       Buffer  : Pointer;
                       BufSize : DWord;
                   var Length  : PDWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosG1Sync    ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Speed        : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosG1    ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Speed        : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosG1_ASync  ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Acc          : Double;
                             Speed        : Double;
                             DecLimit     : Double;
                             Limit        : Double;
                             DecDest      : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosG1_A  ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Acc          : Double;
                         Speed        : Double;
                         DecLimit     : Double;
                         Limit        : Double;
                         DecDest      : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosD1Sync    ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Speed        : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosD1    ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Speed        : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosD1_ASync  ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Acc          : Double;
                             Speed        : Double;
                             DecLimit     : Double;
                             Limit        : Double;
                             DecDest      : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosD1_A  ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Acc          : Double;
                         Speed        : Double;
                         DecLimit     : Double;
                         Limit        : Double;
                         DecDest      : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosG2Sync    ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Speed        : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosG2    ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Speed        : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosG2_ASync  ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Acc          : Double;
                             Speed        : Double;
                             DecLimit     : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             DecDest      : Double;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosG2_A  ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Acc          : Double;
                         Speed        : Double;
                         DecLimit     : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         DecDest      : Double;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosD2Sync    ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Speed        : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosD2    ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Speed        : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

{--------------------------------------------------------------------------}

function  DoPEPosD2_ASync  ( DoPEHdl      : DoPE_HANDLE;
                             MoveCtrl     : Word;
                             Acc          : Double;
                             Speed        : Double;
                             DecLimit     : Double;
                             Limit        : Double;
                             DestCtrl     : Word;
                             DecDest      : Double;
                             Destination  : Double;
                             usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';

function  DoPEPosD2_A  ( DoPEHdl      : DoPE_HANDLE;
                         MoveCtrl     : Word;
                         Acc          : Double;
                         Speed        : Double;
                         DecLimit     : Double;
                         Limit        : Double;
                         DestCtrl     : Word;
                         DecDest      : Double;
                         Destination  : Double;
                         usTAN        : PWord ): DWord; STDCALL;

   external 'DoPE.dll';



end.


