Attribute VB_Name = "DoPE"
Option Explicit

'-----------------------------------------------------------------------------
' Project: DoPE
' (C) DOLI Elektronik GmbH, 1998-2004
'
' 32 Bit Visual Basic header for DoPE (DOLI PC-EDC) interface for Windows
'
' Versions:
' ---------
' V 1.00  03.08.1998  PET
'
' V 2.00  27.04.1999  PET
' - DoPEEVT_OVERFLOW definition changed (0x8000 is used by DPX offline event)
' - DoPEEVT_OFFLINE and DoPEEVT_ONLINE defined, DoPEEVT_ALL changed
' - Windows character set used
' - DoPEVersion prepared for version 2.00
' - Multiple definitions of max. values removed
' - DoPEData explicitly aligned on 8byte bounderies
' - WINDOWS.H will not be included on DOLI subsystems. BYTE, WORD and DWORD
'   defined for DOLI subsystem.
' - New sensor unit UNIT_INC_REV [Increments/Revolution].
' - 16 measuring channels. New 'SENSOR_xx', 'MCBIT_xx' constants.
' - 16 analogue output channels. New 'OUT_xx' constants.
' - 10 channel supervisions.
' - New 'BIN_xx' 'BOUT_xx' constants.
' - Changed 'MAX_MC', 'MAX_OC' constants.
' - New constant 'SENSOR_D' for digipoti (old digipoti was 'SENSOR_O7').
' - New parameters in struct DoPESenDef: 'CtrlChannel', 'UseEeprom',
'  'Correction'.
' - New parameters in struct DoPECtrlSenDef: 'PosTd', 'PosGenTd', 'SpeedTd',
'   'SpeedGenTd' and 'AccK'.
'   'UpperSoftLimit', 'LowerSoftLimit' and 'SoftLimitReaction' removed.
' - New type double in struct DoPEOutChaDef for 'MaxValue','MinValue','InitValue'
'   PaType removed
' - Parameters removed from struct DoPEBitOutDef: 'FlashMask', 'SetMask'.
' - New parameters in struct DoPEBitInDef: 'StopMask', 'StopLevel'.
'   'SetMask' removed.
' - New parameters in struct DoPEMachineDef: 'Clampxx', 'Shieldxx'.
'   'MachineType' removed
' - New parameters in struct DoPEVersion: 'PeInterfacePC', 'DpxVer'.
' - Struct DoPEDPotiDef and function DoPERdDPotiDef() deleted. The digipoti has
'   to be handled as normal sensor. Valid parameters are: 'Connector', 'Sign',
'   'Offset', 'Scale'.
' - New struct DoPEGeneralData.
' - New struct DoPESetup.
' - New constants for 'Mode' in DoPECosineV.
' - New constants for 'CtrlState2': CTRL_UPPER_LIMIT, CTRL_LOWER_LIMIT,
'   'CTRL_CALIBRATION'
' - Constants for 'McState' removed.
' - Function DoPERSysData() and DoPEWSysData() removed.
' - Function DoPERMkData() and DoPEWMkData() removed.
' - Function DoPERAkData() and DoPEWAkData() removed.
' - New interface function DoPEWrSensorDef, DoPEWrCtrlSensorDef, DoPEWrOutChannelDef,
'   DoPEWrBitOutDef, DoPEWrBitInDef and DoPEWrMachineDef.
' - New interface function DoPESetupOpen, DoPESetupClose, DoPERdSetupNumber
' - New interface function DoPERdSetupAll, DopeWrSetupAll
' - New interface function DoPERdLinTbl, DopeWrLinTbl
' - New interface function DoPERdSysUserData, DoPEWrSysUserData
' - New interface function DoPERdGeneralData, DoPEWrGeneralData
' - New interface function DoPERdBitInput, DoPEWrBitOutput
' - New interface function DoPECosineX, DoPECosineV
' - New interface function DoPECtrlP_Xpp, DoPECtrlP_XppNorm
' - New interface function DoPEMTSpecial
' - New interface function DoPECtrlPGKId
' - New interface function DoPEDspBeamScreen, DoPEDspBeamValue
' - New interface function DoPESetCheckLimit, DoPEClrCheckLimit
' - New interface function DoPEShieldLimit, DoPEShieldDisable, DoPEShieldLock
' - New interface function DoPESpeedLimit
' - New error code DoPERR_SETUPOPEN
' - New command error codes DoPERR_CMD_...
' - New command ErrorNumber definitions CMD_ERROR_...
' - New connector constants.
' - DoPECtrl... K/Ti parameters changed from double to unsigned long/short
' - New default measuring dada record:
'   New SysStateN and aditional measuring channels and bit input devices.
'   OutChanN, BitOutN, McState, McCal, FatalError, ErrorLevel and
'   CtrlState removed.
' - New Events DoPEEVT_DATAOVERFLOW, DoPEEVT_ACK, DoPEEVT_NAK and DoPEEVT_ALL
' - Conditional compilation for VER2 removed
' - New struct DoPECommandError and DoPEEPError definitions
' - Application version string in DoPEVersion struct changed to 13 char length
' - DoPEOffsK renamed to DoPEOffsC
' - Definitions CHK_BELOW and CHK_ABOVE corrected
' - New typedefinitions for messages not fitting the DoPEMCM sctructure:
'   - DoPESftM for 'Softend' Message
'   - DoPEOffsCM for 'Offset-Correction' Message
'   - DoPECheckM for 'Measuring Channel Supervision' Message
'
' V 2.01  30.11.1999  PET
' - New message CMSG_SHIELD
' - New constants for InSignals: IN_SIG_REFERENZ,  IN_SIG_SH_CLOSED
'                                IN_SIG_SH_LOCKED, IN_SIG_SH_KEY
' - New constants for OutSignals: O_SIG_LIMIT,  O_SIG_SH_LOCK
' - New message type definition RAW_SUB_MSG and DoPERawSubMsg
' - New constants for SensorState in DoPESumSenInfo (moved from PEDef.h)
' - 'Raw Sub' message not implemented in Visual Basic DoPE interface!
' - DoPEVBSendMsg() removed from Visual Basic DoPE interface.
' - All definitions with 'BREAKE' corrected to 'BRAKE'.
' - Default values for user scale will be set to 1.0, if US parameter in
'   function DoPEVBSelSetup() is set to NULL.
'
' V 2.10  14.01.2000  PET
' - Neue Funktionen DoPEConfPeakValues und DoPEPeakValueTime eingebaut.
'   Major Versionsnummer bleibt bei 2 !!!!
' - DoPEOpenMsgWnd and DoPEAddMsgStr: LPSTR arguments changed to LPCSTR
' - DoPECal and DoPEZeroCal remark updated
'
' V 2.11  27.07.2000  PET
' - New DoPE functions (WIN32 and Thunk only!):
'   - DoPEConfPeakValue, DoPEPeakValueTime
'   - DoPEConfCMcSpeed, DoPEConfCMcCommandSpeed,
'   - DoPEConfCMcGradient, DoPEClearCMc
'   - DoPESHalt
'   - DoPECtrlSpeedTimeBase
'   - DoPESetOpenLoopCommand (ACTION_SETOL and EXT_POS_OPENLOOP defined)
'   - DoPERdSenUserData, DoPEWrSenUserData (SenUsrDataLen defined)
'   - DoPEOpenSetupSync, DoPECloseSetupSync
'   - DoPERdSetupAllSync, DoPEWrSetupAllSync
'   - DoPESendMsgSync
'   - DoPERefrSync
'   - DoPESetTimeSync
'   - DoPETransmitDataSync
'   - DoPESetBasicTareSync
'   - DoPESetBSync
'   - DoPEIntgrSync
'   - DoPECalSync, DoPEZeroCalSync
'   - DoPESetOutputSync
'   - DoPEDataInclSync, DoPEDataExclSync
'   - DoPEStartMwPSync, DoPEStopMwPSync, DoPEClrMwPSync
'   - DoPESetCheckSync, DoPEClrCheckSync
'   - DoPESetCheckLimitSync, DoPEClrCheckLimitSync
'   - DoPEShieldLimitSync, DoPEShieldDisableSync, DoPEShieldLockSync
'   - DoPEPosSync, DoPEPos_ASync
'   - DoPEExt2CtrlSync
'   - DoPEFDPotiSync
'   - DoPEFMoveSync
'   - DoPEHaltSync, DoPEHalt_ASync, DoPEStopSync
'   - DoPEDefaultAccSync
'   - DoPEEmergencyMoveSync
'   - DoPECycleSync, DoPECosineSync, DoPECosineXSync, DoPETriangleSync, DoPERectangleSync
'   - DoPECosineVSync
'   - DoPEEmergencyOffSync
'   - DoPEPosG1Sync, DoPEPosG1_ASync
'   - DoPEPosD1Sync, DoPEPosD1_ASync
'   - DoPEPosG2Sync, DoPEPosG2_ASync
'   - DoPEPosD2Sync, DoPEPosD2_ASync
'   - DoPETrigSync, DoPETrig_ASync
'   - DoPEHaltWSync, DoPEHaltW_ASync, DoPESHaltSync
'   - DoPEXpContSync, DoPEStartCMDSync, DoPEEndCMDSync
'   - DoPEOffsCSync
'   - DoPECtrlPSync, DoPECtrlP_XpSync, DoPECtrlP_XppSync, DoPECtrlPGKTdSync
'   - DoPEDestWndSync
'   - DoPESftSync
'   - DoPECtrlErrorSync
'   - DoPECtrlPNormSync, DoPECtrlP_XpNormSync, DoPECtrlP_XppNormSync
'   - DoPEOnSync
'   - DoPECalOutSync
'   - DoPEBeepSync
'   - DoPELedSync
'   - DoPEUniOutSync
'   - DoPEBypassSync
'   - DoPEDspClearSync, DoPEDspHeadLineSync, DoPEDspFKeysSync, DoPEDspMValueSync
'   - DoPEDspBeamScreenSync, DoPEDspBeamValueSync
'   - DoPEWrSensorDefSync, DoPEWrCtrlSensorDefSync, DoPEWrOutChannelDefSync
'   - DoPEWrBitOutDefSync, DoPEWrBitInDefSync, DoPEWrMachineDefSync, DoPEWrLinTblSync
'   - DoPEWrSysUserDataSync, DoPEWrGeneralDataSync
'   - DoPEWrBitOutputSync
'   - DoPEMTSpecialSync
'   - DoPESetCheckLimitSync, DoPEClrCheckLimitSync
'   - DoPEShieldLimitSync, DoPEShieldDisableSync, DoPEShieldLockSync
'   - DoPESpeedLimitSync
'   - DoPEConfPeakValueSync, DoPEPeakValueTimeSync
'   - DoPECtrlSpeedTimeBaseSync
'   - DoPESetOpenLoopCommandSync
'   - DoPEConfCMcSpeedSync, DoPEConfCMcCommandSpeedSync, DoPEConfCMcGradientSync
'   - DoPEClearCMcSync
'   - DoPEWrSenUserDataSync
'   - DoPEMc2OutputSync
' - New constants for DoPEState: COM_STATE_OFF,     COM_STATE_INITCYCLE,
'                                COM_STATE_OFFLINE, COM_STATE_ONLINE
' - New DoPE functions:
'   - DoPEGetRTErr
'   - DoPEMc2Output
' - New DoPE error constant DoPERR_RTE_UNHANDLED
' - DoPE error constant DoPERR_PE_xxx changed to DoPERR_CMD_xxx
' - New runtime error constant RTE_ERROR_UNHANDLED and typedefs SubRTErr,
'   SubRTErrRaw and DoPERTErr
'
' V 2.12  06.10.2000  PET
' - New DoPE functions:
'   - DoPESetCheckXSync, DoPESetCheckX
' - New Constant Definitions for DoPESetCheck
'   - CHK_PERCENT_MAX, CHK_PERCENT_MIN, CHK_ABS_MAX, CHK_ABS_MIN
'   - ACTION_SHALT
'
' V 2.20  24.07.2001  PET
' - New DoPE function:
'   - DoPECurrentData
'   - DoPESetupScale
' - UpperLimit/LowerLimit of DoPESumSenInfo dimension is [Unit]
' - CON_X10 defined
'
' V 2.21  11.01.2002  PET
' - DoPEAPIVERSION defined for version checks
' - New DoPE function:
'   - DoPEOpenLink, DoPECloseLink
'     !!! This functions replace the old functions DoPEOpenConnection and DoPECloseConnection !!!
'   - DoPEPosExt(Sync)
'   - DoPEPosExt_A(Sync)
'   - DoPESetDither(Sync)
'   - DoPEDebugOutputFlags
'   - DoPEDebugOutput
'   - DoPEDebugPrintf
' - Message window API replaced by DoPEDebugOutput and DoPEDebugPrintf in WIN32
' - Definitions for the DoPEPosExt... commands:
'   - LIMIT_ABSOLUTE, LIMIT_RELATIVE, DEST_APPROACH, DEST_POSITION, DEST_MAINTAIN
' - Definitions for the DoPESetCheck... commands:
'   - ACTION_UP, ACTION_DOWN
' - EDC serial number added to DoPEVersion structure
' - SensorNo added to DoPECheckM structure
' - CHK_NOCHECK definition removed
' - New setup parameters in DoPEOutChaDef:
'   - MaxCurrTime
'   - DitherFrequency
'   - DitherAmplitude
'   - CurrentControllerGain
'   - Signal
'   - SignalFrequency
'   - ChangeDirection
'   - ChangeDirectionLevel
' - Definitions for the digital command outpus CurrentControllerGain, signal and
'   frequency in DoPEOutChaDef:
'   - OUTSIGNAL_A_B, OUTSIGNAL_PULSE_SIGN, OUTSIGNAL_UP_DOWN
'   - OUTSIGNALFREQU2MHz, OUTSIGNALFREQU1MHz, OUTSIGNALFREQU500kHz,
'     OUTSIGNALFREQU250kHz, OUTSIGNALFREQU120kHz, OUTSIGNALFREQU60kHz,
'     OUTSIGNALFREQU30kHz, OUTSIGNALFREQU10kHz, OUTSIGNALFREQU_MAX
'   - OUTCURRCTRLGAINSET_0_01mH, OUTCURRCTRLGAINSET_0_03mH,
'     OUTCURRCTRLGAINSET_0_05mH, OUTCURRCTRLGAINSET_0_09mH,
'     OUTCURRCTRLGAINSET_0_18mH, OUTCURRCTRLGAINSET_0_35mH,
'     OUTCURRCTRLGAINSET_0_7mH,  OUTCURRCTRLGAINSET_1_5mH,
'     OUTCURRCTRLGAINSET_3H,     OUTCURRCTRLGAINSET_5mH,
'     OUTCURRCTRLGAINSET_9mH,    OUTCURRCTRLGAINSET_18mH,
'     OUTCURRCTRLGAINSET_35mH,   OUTCURRCTRLGAINSET_75mH,
'     OUTCURRCTRLGAINSET_150mH,  OUTCURRCTRLGAINSET_300mH,
'     OUTCURRCTRLGAINSET_MAX
' - Definitions for the debug API:
'   - DoPEDebQuiet, DoPEDebERR, DoPEDebAPI, DoPEDebAPIRc, DoPEDebAPIRcNoErr,
'     DoPEDebAPICB, DoPEDebAPIRcCB, DoPEDebAPIRcNoErrCB, DoPEDebDLL, DoPEDebALL
' - New command error definition CMD_ERROR_NIM
'
' V 2.22  23.01.2002  PET
' - New Names for OUTCURRCTRLGAINSET_x_xxxmH Constants
'
' V 2.23  08.04.2003  PET
' - New constant definitions for 'MsgId' in MOVE_CTRL_MSG: CMSG_SHIELD_ERR
' - New connector definitions CON_X62A, CON_X62B, CON_X62C, CON_X62D
' - New shield message definition CMSG_SHIELD_ERR
' - New DoPE functions:
'   - DoPEGetDebugOutputFlags
'   - DoPECtrlTestValuesSync
'   - DoPESetRefSignalModeSync
'   - DoPESetRefSignalTareSync
'   - DoPESetOutChannelOffset(Sync)
'   - DoPESynchronizeSystemMode(Sync)
'   - DoPESynchronizeSystemStart(Sync)
'   - DoPEWrSensorMsg(Sync)
'   - DoPERdSensorHeaderData
'   - DoPERdSensorAnalogueData
'   - DoPEWrSensorAnalogueData
'   - DoPERdSensorIncData
'   - DoPEWrSensorIncData
'   - DoPERdSensorAbsData
'   - DoPEWrSensorAbsData
'   - DoPERdSensorUserData
'   - DoPEWrSensorUserData
'   - DoPERdSensorConKey
'   - DoPEPosPID(Sync)
'   - DoPESpeedPID(Sync)
'   - DoPEPosFeedForward(Sync)
' - New MOVE_CTRL_MSG message definition CMSG_REFSIGNAL
' - New MOVE_CTRL_MSG message type definition DoPERefSignalM
' - New message type definition SENSOR_MSG: DoPESensorM
' - New setup Offset parameter in DoPEOutChaDef
' - New constants for baudrate DoPE_BAUD_230400 and DoPE_BAUD_460800
'
'
' HEG, 25.4.03 - V2.24
' - DoPE functions renamed:
'   - DoPECtrlTestValuesSync -> DoPECtrlTestValues
'   - DoPESetRefSignalModeSync -> DoPESetRefSignalMode
'   - DoPESetRefSignalTareSync -> DoPESetRefSignalTare
' - TAN parameter added to:
'   - DoPESetRefSignalMode
'   - DoPESetRefSignalTare
' - SIG_DMS renamed to SIG_STRAINGAUGE
' - SIG_SINUS11uA and SIG_SINUS1V renamed to SIG_SINE11uA und SIG_SINE1V
'
'  HEG, 2.7.03 - V2.26
'  - DoPEAPIVERSION changed to 2.26 due to DoPERd/WrSetupAll bugfix
'  - DOPESETONRUNTIMEERRORHDLR and DOPESETONRUNTIMEERRORRTHDLR defined
'  - New connector definitions CON_X61A
'  - New absolute sensor definition SIG_MTR_SSI_S2Bx102
'
'  PET, 11.03.2004 - V2.27
'  - UNIT_xxx constants corrected
'  - changed remark for DelayTime unit from [s] to [ms/10]
'  - MACHINE_NO_IO_OFF, MACHINE_NO_IO_IN_OUT, MACHINE_NO_IO_OUT and
'    MACHINE_NO_IO_IN defined
'  - DoPEAPIVERSION changed to 2.27 due to MACHINE_NO_IO changes
'  - New DoPE functions:
'    - DoPEOfflineActionBitOutput(Sync)
'    - DoPEOfflineActionOutput(Sync)
'  - DO_NOTHING, USE_INIT_VALUE and USE_VALUE defined
'
'
'  PET, 14.06.2004 - V2.27a
'  - NEW: event handler interface DoPEEHVB32.BAS included
'  - NEW: DoPEDATA structure filled with pad characters, because of 8 byte
'         alignment. Sync variables removed.
'         ATTENTION: old and new DoPEDATA structure are not compatible !!!
'         ----------------------------------------------------------------
'  - NEW: DoPEVBGetData() and DoPEVBCurrentData() now calling dope.dll
'         instead of dopevb.dll because of new DoPEDATA structure.
'
'
'  PET, 10.12.2004 - V2.29
'  - FIX: DoPEMc2Output remark modified
'  - FIX: TRUE and FALSE replaced by 1 and 0
'  - FIX: DoPEMachineDef structure. Unused1 and Unused2 parameters included
'         in DoPE32VB.dll. Now are the following parameters of the Setup
'         correct.
'  - NEW: some changes for better VB.NET compability:
'         - Class, Day, Month, Year changed to Class_, Day_, Month_, Year_
'         - all 'as any' changed to 'as long'
'  - The DoPEAPIVERSION and the DoPE version are set to the same value
'  - New connector definitions CON_X61B, CON_X61C, CON_X61D
'  - New CtrlState1 definitions CTRL_SYNCHWAIT and CTRL_SLAVE
'  - New DoPE functions:
'    - DoPEOff(Sync)
'    - DoPESerialSensorDef(Sync)
'    - DoPESetSerialSensor(Sync)
'  - SERSEN_TRANSFER defined
'  - SERSEN_ENDCHAR_NO, SERSEN_ENDCHAR_1, SERSEN_ENDCHAR_1_OR_2,
'    SERSEN_ENDCHAR_1_AND_2 and SERSEN_ENDCHAR_1_PLUS1 defined
'  - SERSEN_SET_COMMAND and SERSEN_SET_FEEDBACK defined
'  - CTRL_STRUCTURE_OPENLOOP defined
'  - O_SIG_ON_RELAY, O_SIG_READY_TO_MOVE and O_SIG_INTERNAL_DRIVE_ENABLE defined
'  - New setup parameters in DoPEMachineDef:
'    - CtrlOnMode
'    - FixValue
'    - InitValue
'    - ReturnValue
'
'  PET, 3.3.2005 - V2.30
'  - TLib version control removed
'  - DoPEAPIVERSION changed to 2.30
'  - Serial sensor definition init value definitions:
'    - SERSEN_SIGN_P, SERSEN_SIGN_N
'    - SERSEN_PORT_DEBUG, SERSEN_PORT_COM1 , SERSEN_PORT_COM2, SERSEN_PORT_COM3
'    - SERSEN_STOPBIT_1, SERSEN_STOPBIT_2
'    - SERSEN_110BAUD, SERSEN_150BAUD, SERSEN_300BAUD, SERSEN_600BAUD
'    - SERSEN_1200BAUD, SERSEN_2400BAUD, SERSEN_4800BAUD, SERSEN_9600BAUD
'    - SERSEN_19200BAUD, SERSEN_38400BAUD, SERSEN_57600BAUD, SERSEN_115200BAUD
'    - SERSEN_230400BAUD, SERSEN_460800BAUD, SERSEN_921600BAUD
'    - SERSEN_NOPROTOCOL, SERSEN_DOLIPROTOCOL, SERSEN_EUROTHERM, SERSEN_GRADO
'    - SERSEN_AI_808
'    - SERSEN_NOPARITY, SERSEN_ODDPARITY, SERSEN_EVENPARITY
'    - SERSEN_7DATABIT, SERSEN_8DATABIT
'
'  PET, 24.6.05 - V2.31
'  - DoPEAPIVERSION changed to 2.31
'
'  HEG, 5.7.05 - V2.32
'  - DoPEAPIVERSION changed to 2.32
'
'  HEG, 25.4.05 - V2.50
'  - DoPEAPIVERSION changed to 2.50
'  - New DoPE functions:
'    - DoPEDefineNIC
'    - DoPEPortInfo
'    - DoPEInitializeResetXHead
'    - DoPERdModuleInfo
'  - Port info definitions:
'    - DoPEPORTCOM, DoPEPORTUSB, DoPEPORTLAN, DoPEPORTNAMELEN
'    - MAC, DoPE_PORTINFO
'  - DoPEModuleInfo structure defined
'  - DoPEModuleInfo status definitions:
'    - MODSTAT_OK, MODSTAT_HWFAIL, MODSTAT_NOMODULE, MODSTAT_NODRIVER
'      MODSTAT_REMOTE, MODSTAT_SWFAIL
'  - MAX_MODULE defined
'  - DoPEGeneralData extended:
'    - nRmc, Language, FunctionID
'  - Language definitions:
'    - LANGUAGE_ENGLISH, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_FRENCH
'  - DoPERR_COMPARAMETER error code defined
'
'  HEG, 12.5.06 - V2.51
'  - Obsolete functions and definitions removed
'    - DoPEOpenMsgWnd, DoPECloseMsgWnd, DoPEAddMsgStr, DoPEMeldWndProc
'    - DoPECtrlP(Sync), DoPECtrlP_Xp(Sync), DoPECtrlP_Xpp(Sync), DoPECtrlPGKTd(Sync)
'    - DoPECtrlPNorm(Sync), DoPECtrlP_XpNorm(Sync), DoPECtrlP_XppNorm(Sync)
'    - DoPEStartMwP, DoPEStopMwP, DoPEGetMwP, DoPEClrMwP
'    - DoPEDataIncl(Sync), DoPEDataExcl(Sync)
'    - DoPEMTSpecial(Sync)
'    - DoPEGetRTErr
'    - CBR_57600, CBR_115200
'    - CTRL_STRUCTURE_PNEUMATIC
'  - New DoPESetRefSignalTare definition:
'    - REFSIG_TARE
'  - New DoPESetBasicTare definitions:
'    - BASICTARE_SET
'    - BASICTARE_SUBTRACT
'  - New DoPEOutChaDef definitions:
'    - OUTSIGNAL_ANALOGUE, OUTSIGNAL_DDD
'    - OUTSIGNALFREQU4MHz
'  - OUTSIGNALFREQUxxxHz definitions changed (+1)
'  - Renamed functions and definitions
'    - DoPERefr(Sync) -> DoPESetDataTransmissionRate(Sync)
'    - DoPECosineV(Sync) -> DoPECosinePeakCtrl(Sync)
'    - DoPEStop(Sync) -> DoPESetCtrl(Sync)
'      - unsigned short State -> unsigned Enable (level inverted!)
'    - OUTSIGNALFREQU120kHz -> OUTSIGNALFREQU125kHz
'    - OUTSIGNALFREQU10kHz  -> OUTSIGNALFREQU15kHz
'    - IN_SIG_STOP -> IN_SIG_NO_CTRL
'    - IN_SIG_SH_KEY -> IN_SIG_SH_INACTIVE
'    - DoPECtrlSenDef:
'      - WndSize    -> UnUsed1
'      - WndTime    -> UnUsed2
'      - PosK         -> PosP
'      - PosTi      -> PosI
'      - PosTd      -> PosD
'      - PosGenTd   -> PosFFP
'      - SpeedK     -> SpeedP
'      - SpeedTi          -> SpeedI
'      - SpeedTd          -> SpeedD
'      - SpeedGenTd -> UnUsed3
'      - AccK       -> UnUsed4
'    - DoPEOutChaDef:
'      - ChangeDirection      -> UnUsed1
'      - ChangeDirectionLevel -> UnUsed2
'    - DoPEMachineDef:
'      - DataAqTime     -> DataTransmissionRate
'      - Bypass         -> UnUsed3
'      - MotorEncRatio  -> UnUsed4
'      - ClampConnector -> GripConnector
'      - ClampChannel   -> GripChannel
'      - ClampActive    -> GripActive
'    - DoPEGetData, DoPECurrentData:
'      - void *Buffer -> DoPEData *Sample
'  - New DoPE functions:
'    - DoPEClearErrors
'    - DoPESetIoCompatibilityMode
'  - DoPESynchronizeSystemMode(Sync) and DoPESynchronizeSystemStart(Sync)
'    moved from Dope.h to module DoPEsyn.h
'  - New Visual Basic file names:
'    - DoPEVB32.bas   -> DoPE.bas
'    - DoPEEHVB32.bas -> DoPEEH.bas
'  - Fix in DoPEData: Pad2 added (because of alignment problems with DoPEData
'    array in OnSynchronizeData() handler)
'
'  PET, 24.07.2006 - V2.52
'  - New: DoPEKey.bas, DoPEsyn.bas
'
'  HEG, 20.11.06 - V2.54
'  - SIG_TR_LT_S redefined to SIG_ROQ_424
'
'  PET, 08.05.2007 - V2.55
'  - New: DoPEAPIVERSION changed
'
'  PET, 16.05.2007 - V2.56
'  - New: DoPEAPIVERSION changed
'
'  HEG, 22.12.06 - V2.57
'  - Debugger API removed
'  - New DoPE functions:
'    - DoPECurrentPID(Sync)
'    - DoPERdDriveInfo
'    - DoPEFMove_A
'  - DoPEDriveInfo structure defined
'  - New Setup parameters in DoPEGeneralData:
'       - SyncOption
'    - MachineName
'  - DoPEOutChaDef definition OUTSIGNAL_DDD replaced by
'    - OUTSIGNAL_SIGN_MAGNITUDE
'    - OUTSIGNAL_LOCKEDANTIPHASE
'  - New definition for the DoPEPosExt... commands:
'    - LIMIT_NOT_ACTIVE
'  - New definition for the DoPESetCheck... commands:
'    - ACTION_DRIVE_OFF
'
'  HEG, 9.7.07 - V2.58
'  - Setup parameters removed from DoPEGeneralData:
'       - SyncOption
'    - MachineName
'
'  HEG, 18.1.08 - V2.59
'  - New DoPE functions:
'    - DoPESetCheckLimitIO
'    - DoPEOpenFunctionID
'    - DoPEOpenDeviceID
'    - DoPEOpenAll
'    - DoPECloseAll
'    - DoPEFeedForward(Sync)
'    - DoPEOptimizeFeedForward(Sync)
'    - DoPERdCtrlSensorDefHigh
'    - DoPEWrCtrlSensorDefHigh
'    - DoPERdIOSignals
'    - DoPEWrIOSignals(Sync)
'    - DoPERdMainMenu
'    - DoPEWrMainMenu(Sync)
'    - DoPERdCtrlParameter
'    - DoPEIOGripEnable(Sync)
'    - DoPEIOGripSet(Sync)
'    - DoPEIOGripPressure(Sync)
'    - DoPEIOExtEnable(Sync)
'    - DoPEIOExtSet(Sync)
'    - DoPEIOFixedXHeadEnable(Sync)
'    - DoPEIOFixedXHeadSet(Sync)
'    - DoPEIOHighPressureEnable(Sync)
'    - DoPEIOHighPressureSet(Sync)
'  - New Setup parameters in DoPEGeneralData:
'       - SyncOption
'    - MachineNoIoBitConnector
'    - MachineNoIoBitNo
'  - New Setup parameters in DoPECtrlSenDef:
'       - SpeedFFP
'    - PosDelay
'    - AccFFP
'    - SpeedDelay
'  - New setup parameters:
'    - DoPECtrlSenDef for high pressure
'    - DoPEIOSignals
'      - DoPEIOGrip
'      - DoPEIOExt
'      - DoPEIOFixedXHead
'      - DoPEIOHighPressure
'      - DoPEIOKey
'      - DoPEIOTest
'      - DoPEIOMisc
'    - DoPEMainMenu
'  - New setup parameters in DoPEOutChaDef:
'    - CurrentP/I/D
'  - OUTSIGNAL_DC_MOTOR and OUTSIGNAL_DC_LINEAR_MOTOR defined
'    (should be used instead of OUTSIGNAL_SIGN_MAGNITUDE and OUTSIGNAL_LOCKEDANTIPHASE)
'  - MAX_MACHINE changed from 4 to 8
'  - New connectors CON_X36A/B...CON_X39A/B defined
'  - New IO bit definitions implemented
'  - New main menu configuration definitions implemented
'  - NIC definitions can be removed by passing a NULL pointer to DoPEDefineNIC
'  - "pragma warning" eliminated for MinGW GNU Compiler
'  - New Event DoPEEVT_RESTART defined and included to DoPEEVT_ALL
'  - 'CtrlState2' definitions extended by CTRL_HIGH_PRESSURE
'  - New cnstants  for 'LimitCtrl' in DoPESenDef defined:
'  - REACT_STATE
'  - REACT_DRIVE_OFF
'  - REACT_SHALT
'
'  HEG, 31.1.08 - V2.60
'  - DoPECtrlParameter extended:
'    - MinAcceleration, MaxAcceleration
'    - MinDeceleration, MaxDeceleration
'    - MinSpeed, MaxSpeed
'
'  HEG, 15.4.08 - V2.61
'  - New connector definitions CON_X21D,...,CON_X28D
'  - New CtrlState2 definition CTRL_CYCLES_ACTIVE
'
'  HEG, 28.7.08 - V2.62
'  - DoPE.h defined DoPEIOHighPressureSet without the lpusTan parameter. Bug fixed.
'  - DoPE debug functions removed:
'    - DoPEGetDebugOutputFlags
'    - DoPEDebugOutputFlags
'    - DoPEDebugOutput
'    - DoPEDebugPrintf
'  - OutChaNominalPressure in DoPEIOGrip struct was changed to UnUsed1.
'  - All grip pressure parameters are changed form unit [Pa] to [%].
'  - New in DoPEIOHighPressure struct:
'    - PressureOutputEnabled
'    - OutChaNo
'    - OutChaLowPressure
'    - OutChaHighPressure
'    - OutChaRampTime
'  - DoPEIOExtSet declared the TAN parameter as unsigned pointer. Must be
'    unsigned short pointer. Bug fixed.
'
'  HEG, 1.10.08 - V2.63
'  - New DoPE function:
'    - DoPEDynCycles(Sync)
'  - New absolute sensor type definition SIG_POSITAL_SL_G
'  - Absolute sensor definition SIG_UNDEF removed.
'  - Typo in SIG_MTR_SSI_S2Bx102 removed. Must read SIG_MTS_SSI_S2Bx102.
'
'  HEG, 4.3.09 - V2.65
'  - Constants for system messages defined
'  - wide character support implemented
'  - Display length definitions:
'    - DSP_HEADLINE_LEN
'    - DSP_FKEYSLINE_LEN
'    - DSP_VALUE_LEN
'    - DSP_DIM_LEN
'  - Version text length definitions:
'    - PEINTERFACE_LEN
'    - APPLICATION_LEN
'    - SUBSY_LEN
'    - SUBSYCUSTVER_LEN
'    - SUBSYCUSTNAME_LEN
'    - BIOS_LEN
'    - HWCTRL_LEN
'    - PEINTERFACEPC_LEN
'    - DPXVER_LEN
'    - SERIALNUMBER_LEN
'  - New type definitions:
'    - DoPEwVersion        (not implemented in Visual Basic 6)
'    - DoPEwModuleInfo     (not implemented in Visual Basic 6)
'    - DoPEwDriveInfo      (not implemented in Visual Basic 6)
'    - DoPEwRdLanguageInfo (not implemented in Visual Basic 6)
'    - DoPE_wPORTINFO      (not implemented in Visual Basic 6)
'    - DoPEwOpenLinkInfo   (not implemented in Visual Basic 6)
'  - New DoPE functions:
'    - DoPEwDspHeadLine(Sync)
'    - DoPEwDspFKeys(Sync)
'    - DoPEwDspMValue(Sync)
'    - DoPEwRdVersion      (not implemented in Visual Basic 6)
'    - DoPEwRdModuleInfo   (not implemented in Visual Basic 6)
'    - DoPEwRdDriveInfo    (not implemented in Visual Basic 6)
'    - DoPEwPortInfo       (not implemented in Visual Basic 6)
'    - DoPEwOpenAll        (not implemented in Visual Basic 6)
'    - DoPEwCloseAll       (not implemented in Visual Basic 6)
'    - DoPEShieldEnable(Sync)
'  - New IO Grip Mode definitions:
'    - IO_GRIP_MODE_0_OFF
'    - IO_GRIP_MODE_1_TANSPARENT
'    - IO_GRIP_MODE_2_LIMIT_CTRL
'  - Language definitions redefined:
'    - LANGUAGE_SPANISH -> LANGUAGE_USER1
'    - LANGUAGE_FRENCH  -> LANGUAGE_USER2
'  - LANGINFO_NAME_LEN and struct DoPEwLanguageInfo defined (not implemented in Visual Basic 6)
'  - SYSTEM_MSG_LANGUAGE_READ, SYSTEM_MSG_LANGUAGE_VERSION and SYSTEM_MSG_LANGUAGE_SYNTAX defined
'  - New DoPEDynCycles definitions for SweepFrequencyMode and SweepAmplitudeMode:
'    - DYN_SWEEP_LINEAR_START_END
'    - DYN_SWEEP_LOGARITHMIC_START_END
'
'  HEG, 7.12.09 - V2.66
'  New DoPEMc2Output 'Mode' definition:
'    - MC2OUT_BURST
'  New absolute value sensor type definitions:
'    - SIG_POSITAL_SL_G renamed to SIG_POSITAL_SL_G_24
'    - SIG_POSITAL_SL_G_16 4
'    - SIG_ROQ_425
'    - SIG_SSI_GENERIC, SIG_SSI_CODE, SIG_SSI_LEN, SIG_SSI_LEN_OFFS
'  - New DoPE functions:
'    - DoPESetSsiGenericSignalType
'    - DoPESsiGenericSignalTypeInfo
'    - DoPESetSerialSensorTransparent(Sync)
'    - DoPESetSensorDataTransmissionRate(Sync)
'  - WM_DoPEEvent removed
'
'  HEG, 20.7.10 - V2.68
'  - New DoPE functions:
'    - DoPERdRmcDef
'    - DoPEWrRmcDef(Sync)
'  - New setup parameters:
'    - in DoPEOutChaDef:
'      - DoPEMc2OutputDef
'    - in DoPEMachineDef:
'      - ShieldUprLock
'      - ShieldLwrLock
'      - ShieldSpeedLimit
'      - LimitSwitchType
'      - XheadInitialMode
'      - XheadInitialValue
'      - X4Pin14Mode
'    - in DoPEIOSignals
'      - DoPEIOSHalt
'      - DoPEIOKey and DoPEIOTest removed
'    - in DoPESetup:
'      - DoPERmcDef
'        - PushMode
'        - DoPERmcDPoti
'        - DoPERmcIOKey
'  - New definition for max. number of DoPERmcIOKey definitions:
'    - RMCIO_KEY_MAX 16
'  - New definitions for DoPEMachineDef LimitSwitchType:
'    - LIMIT_SWITCH_TYPE_SINGLE
'    - LIMIT_SWITCH_TYPE_UPPER_LOWER
'  - New definitions for DoPEMachineDef XHeadInitialMode:
'    - XHEAD_INITIAL_MODE_AUTOMATIC
'    - XHEAD_INITIAL_MODE_MANUAL
'  - New definitions for DoPEMachineDef X4Pin14Mode:
'    - X4PIN14_MODE_BYPASS
'    - X4PIN14_MODE_EDC_READY
'  - New IO Grip Mode definition:
'    - IO_GRIP_MODE_3_LIMIT_CTRL_INVERTED
'  - New system message definitions:
'    - SYSTEM_MSG_OC_MC2OUTPUT
'    - SYSTEM_MSG_IO_MISC_TEMPERATURE1
'    - SYSTEM_MSG_IO_MISC_TEMPERATURE2
'    - SYSTEM_MSG_IO_MISC_OIL_LEVEL
'    - SYSTEM_MSG_IO_MISC_OIL_FILTER
'    - SYSTEM_MSG_IO_MISC_POWER_FAIL
'    - SYSTEM_MSG_IO_SHALT_MODE
'    - SYSTEM_MSG_IO_SHALT_BIN
'  - Obsolete system messages removed:
'    - SYSTEM_MSG_IO_KEY_MODE
'    - SYSTEM_MSG_IO_KEY_BIN
'    - SYSTEM_MSG_IO_KEY_BOUT
'    - SYSTEM_MSG_IO_TEST_MODE
'    - SYSTEM_MSG_IO_TEST_BIN
'    - SYSTEM_MSG_IO_TEST_BOUT
'  - New InSignals and OutSignals definitions:
'    - IN_SIG_IO_SHALT_UPPER
'    - IN_SIG_IO_SHALT_LOWER
'    - O_SIG_EDC_READY
'  - All 'Global Const' to 'Public Const' converted
'
'  HEG, 20.7.11 - V2.70
'  - New DoPE functions:
'    - DoPECurrentPortInfo, DoPEwCurrentPortInfo
'  - DoPEVBWrSensorMsg and DoPEVBWrSensorMsgSync parameter Buffer corrected.
'
'  HEG 25.9.10 - V2.71
'  - New DopE functions:
'    - DoPERdPosPID, DoPEWrPosPID(Sync)           ( requires PE-Version 2.71 ! )
'    - DoPERdSpeedPID, DoPEWrSpeedPID(Sync)       ( requires PE-Version 2.71 ! )
'    - DoPERdFeedForward, DoPEWrFeedForward(Sync) ( requires PE-Version 2.71 ! )
'
'  HEG, 26.1.2012 - V 2.72
'  - IN_SIG_CPU_EMERGENCY_OFF defined
'
'  HEG, 26.7.2012 - V 2.73
'  - 16 control channels supported
'    - MAX_CTRL changed to 16
'    - CTRL_SENSOR_3 to CTRL_SENSOR_15 defined
'    - SENSOR_3 defined (SENSOR_D removed)
'  - New DigiPoti sensor definition SENSOR_DP.
'    The DigiPoti (Connector X63A) can be defined at any sensor position in the setup.
'    SENSOR_DP can be used in the DoPEFDPoti(Sync) and DoPEIntgr(Sync) commands.
'  - measuring data record modified
'    - new DoPEData.Sensor3          (was DoPEData.SensorD)
'    - new DoPEData.ActiveCtrl       (was DoPEData.SysState1)
'    - new DoPEData.UpperSft         (was DoPEData.SysState2)
'    - new DoPEData.LowerSft         (was DoPEData.SysState3)
'    - new DoPEData.SensorConnected  (was DoPEData.SysState4)
'    - new DoPEData.SensorKeyPressed (was DoPEData.SysState5)
'    - ActiveCtrl indicates the active control channel     (Bit0=Position Control ... Bit15=Sensor15 Control)
'    - UpperSft/LowerSft indicates 'Range limit exceeded'           (Bit0=Position Sensor ... Bit15=Sensor15)
'    - SensorConnected indicates the connected sensor plugs         (Bit0=Position Sensor ... Bit15=Sensor15)
'    - SensorKeyPressed indicates the active sensor plugs key state (Bit0=Position Sensor ... Bit15=Sensor15)
'  - New runtime error for controller deviation error:
'    - RTE_CTRL_DEVIATION (Device contains the control channel)
'      (RTE_ERROR_S, RTE_ERROR_F, RTE_ERROR_D removed)
'  - New DoPE function:
'    - DoPEIgnoreTcpIpNIC
'  - BaudRate parameter added to DoPE_PORTINFO struct.
'  - Mc2Output(sync) definition by up to three points
'    - New MC2OUT_MODE... and MC2OUT_PRIORITY... definitions
'    - DoPEMc2Output command parameters adjusted
'    - DoPEMc2OutputDef setup structure adjusted
'
'  HEG, 26.7.13 - V 2.76
'  - New DoPE function:
'    - DoPEWrSensorHeaderData
'  - new definitions for calculated sensors:
'    - MAX_CALCULATED_CHANNELS
'    - F_S1PlusS2_half, F_S1MinusS2, F_S1PlusS2PlusS3_third, F_S1PlusS2PlusS3
'      F_S1PlusS2, F_StiffnessCorrection, F_SensorCorrection, F_ExtendedFormula,
'      F_S1PlusS2PlusS3PlusS4_quarter, F_S1PlusS2PlusS3PlusS4
'
'  HEG, 19.9.13 - V 2.77
'  - New Constant for 'OutSignals':
'    - O_SIG_DRIVE_OFF
'  - NEW Modes for DynCycle Command:
'    - DYN_WAVEFORM_SAW_TOOTH, DYN_WAVEFORM_SAW_TOOTH_INV, DYN_WAVEFORM_PULSE
'  - New  parameters in DoPESumSenInfo:
'    - Tare
'    - UserScale
'    - McIntegr
'    - CtrlIntegr
'    - HwDelayTime
'    - McDelayTime
'    - McDelayTimeCorr
'  - NEW EDC debug handling:
'    - DoPESendDebugCommand(Sync)
'    - DoPEDebugMsgEnable(Sync)
'
'  HEG, 13.2.14 - V2.78
'  - Missing DoPE error definition DoPERR_CMD_NIM implemented
'
'  HEG, 26.3.14 - V2.79
'  - New DopE functions:
'    - DoPEDeadbandCtrl(Sync)
'  - DoPECtrlParameter extended:
'    - Deadband
'    - PercentP
'
'  HEG, 24.10.14 - V 2.80
'  - New Mode parameter for DoPESetTime(Sync) and constatnt definitions:
'    - SETTIME_MODE_IMMEDIATE
'    - SETTIME_MODE_MOVE_START
'    - SETTIME_MODE_FIRST_CYCLE
'  - New DopE function:
'    - DoPESetCycleMode
'
'  HEG, 26.8.15 - V2.82
'  - New DopE functions:
'    - DoPESetNominalAccSpeed(Sync)
'
'  HEG, 12.2.16 - V2.83
'  - DoPEOpen... functions report DoPERR_VERSION if a EDCi is detected
'
'  HEG, 29.7.16 - V2.84
'  - New DoPE functions:
'    - DoPEReInitialize
'    - DoPEReInitializeEnable
'
'Version V 2.85  13.06.17  HEG:
'------------------------------
'  - Sensor definition Scale of an absolute sensor is set to the signal period of
'    the sensor now (was 0.0 before).
'  - DoPEOpenAll, DoPEOpenDeviceID and DoPEOpenFunctionID are polling available
'    links in a loop (no multiple threads).
'    They report:
'    - DoPERR_NOERROR on success
'    - DoPERR_VERSION if no link has been established and an EDCi was detected
'    - DoPERR_TIMEOUT if no link has been established
'
'Version V 2.86   16.10.2017  HEG:
'---------------------------------
'  - New Serial Sensor modbus temperature controllers definitions
'    - SERSEN_MODBUS_EUROTHERM
'    - SERSEN_MODBUS_GRADO
'    - SERSEN_MODBUS_SHIMANDEN
'    - SERSEN_MODBUS_AZBIL
'
'Version V 2.87   2.11.2017  HEG:
'--------------------------------
'  - DoPEOpenAll failed. Bug fixed.
'
'Version V 2.88   25.6.2018  HEG:
'--------------------------------
'  - DoPEReInitialize reported DoPERR_PARAMETER due to wrong CRC calculation. Bug fixed.
'  
'Version V 2.89   23.8.18  HEG
'-----------------------------
'  - Delphi DoPEError and DoPEState record declarations were to short. Bug fixed.
'  - OnDataBlock realtime Handler stopped reporting data. Bug fixed.
'
'Version V 2.90   11.10.2019  HEG
'--------------------------------
'  - typo in DoPEREINITIALIZEDATA_LEN removed
'  - missing Controll Message IDs defined
'    - CMSG_IO_SHALT_UPPER
'    - CMSG_IO_SHALT_LOWER
'  - internal synchronize data buffer increased to 0x1000
'  
'Version V 2.91   17.02.2019  HEG
'--------------------------------
'  - DoPESft didn't set the correct values in the sensor info if an DoPERR_CMD_PARCORR error occured. Bug fixed.
'
'-----------------------------------------------------------------------------
' Constants and Definitions
'-----------------------------------------------------------------------------

Public Const DoPEAPIVERSION = &H291           ' DoPE version number

' Unit constants for sensors
' --------------------------
Public Const UNIT_NO = 0                      ' No unit
Public Const UNIT_DEGREE = 1                  ' [°]
Public Const UNIT_DEGREE_SEC = 2              ' [°/s]
Public Const UNIT_DEGREE_SEC2 = 3             ' [°/s²]
Public Const UNIT_METER = 4                   ' [m]
Public Const UNIT_METER_SEC = 5               ' [m/s]
Public Const UNIT_METER_SEC2 = 6              ' [m/s²]
Public Const UNIT_NEWTON = 7                  ' [N]
Public Const UNIT_PASCAL = 8                  ' [P]
Public Const UNIT_DEGREE_CELSIUS = 9          ' [°C]
Public Const UNIT_VOLT = 10                   ' [V]
Public Const UNIT_AMPERE = 11                 ' [A]
Public Const UNIT_OHM = 12                    ' [Ohm]
Public Const UNIT_SEC = 13                    ' [s]
Public Const UNIT_HERTZ = 14                  ' [Hz]
Public Const UNIT_WATT = 15                   ' [W]
Public Const UNIT_INC_REV = 16                ' [Increments/Revolution]
Public Const UNIT_MAX = 17                    ' End of unit definitions

'  /* -------- Definitions of user data length ------------------------------*/
'
Public Const SysUsrDataLen = 16          ' System UserData length (in bytes)
Public Const SenUsrDataLen = 128         ' Sensor UserData length (in bytes)
'
'  /* -------- Definitions of max. values ---------------------------------- */
'
Public Const MAX_MC = 16                 ' maximum number of sensors
Public Const MAX_OC = 16                 ' maximum number of output channels
Public Const MAX_BOUT = 10               ' maximum number of digital outputs
Public Const MAX_BIN = 10                ' maximum number of digital inputs
Public Const MAX_CTRL = 16               ' maximum number of control channels
Public Const MAX_MACHINE = 8             ' maximum number of machine definitions
Public Const MAX_MODULE = 32             ' maximum number of modules
'
'/* ----------------- Logical channel definitions     ------------------------ */
'
'  /* -------------- Measuring channels                 ---------------------- */
'
Public Const SENSOR_S = 0                  '  X-head position
Public Const SENSOR_F = 1                  '  Load
Public Const SENSOR_E = 2                  '  Extension
Public Const SENSOR_3 = 3                  '  Sensor 3
Public Const SENSOR_4 = 4                  '  Sensor 4
Public Const SENSOR_5 = 5                  '  Sensor 5
Public Const SENSOR_6 = 6                  '  Sensor 6
Public Const SENSOR_7 = 7                  '  Sensor 7
Public Const SENSOR_8 = 8                  '  Sensor 8
Public Const SENSOR_9 = 9                  '  Sensor 9
Public Const SENSOR_10 = 10                '  Sensor 10
Public Const SENSOR_11 = 11                '  Sensor 11
Public Const SENSOR_12 = 12                '  Sensor 12
Public Const SENSOR_13 = 13                '  Sensor 13
Public Const SENSOR_14 = 14                '  Sensor 14
Public Const SENSOR_15 = 15                '  Sensor 15
Public Const SENSOR_DP = &HFFFF            '  Digipoti

'
'  /* --------------- Analogue output channels              ----------------- */
'
Public Const COMMAND_OUT = 0              '   Command output
Public Const OUT_1 = 1                    '   Optional channel 1
Public Const OUT_2 = 2                    '   Optional channel 2
Public Const OUT_3 = 3                    '   Optional channel 3
Public Const OUT_4 = 4                    '   Optional channel 4
Public Const OUT_5 = 5                    '   Optional channel 5
Public Const OUT_6 = 6                    '   Optional channel 6
Public Const OUT_7 = 7                    '   Optional channel 7
Public Const OUT_8 = 8                    '   Optional channel 8
Public Const OUT_9 = 9                    '   Optional channel 9
Public Const OUT_10 = 10                  '   Optional channel 10
Public Const OUT_11 = 11                  '   Optional channel 11
Public Const OUT_12 = 12                  '   Optional channel 12
Public Const OUT_13 = 13                  '   Optional channel 13
Public Const OUT_14 = 14                  '   Optional channel 14
Public Const OUT_15 = 15                  '   Optional channel 15
'
'  /* --------------- Digital inputs                   ---------------------- */
'
Public Const BIN_0 = 0                    '  Digital input 0
Public Const BIN_1 = 1                    '  Digital input 1
Public Const BIN_2 = 2                    '  Digital input 2
Public Const BIN_3 = 3                    '  Digital input 3
Public Const BIN_4 = 4                    '  Digital input 4
Public Const BIN_5 = 5                    '  Digital input 5
Public Const BIN_6 = 6                    '  Digital input 6
Public Const BIN_7 = 7                    '  Digital input 7
Public Const BIN_8 = 8                    '  Digital input 8
Public Const BIN_9 = 9                    '  Digital input 9
'
'  /* --------------- Digital outputs                  ---------------------- */
'
Public Const BOUT_0 = 0                   '  Digital input 0
Public Const BOUT_1 = 1                   '  Digital input 1
Public Const BOUT_2 = 2                   '  Digital input 2
Public Const BOUT_3 = 3                   '  Digital input 3
Public Const BOUT_4 = 4                   '  Digital input 4
Public Const BOUT_5 = 5                   '  Digital input 5
Public Const BOUT_6 = 6                   '  Digital input 6
Public Const BOUT_7 = 7                   '  Digital input 7
Public Const BOUT_8 = 8                   '  Digital input 8
Public Const BOUT_9 = 9                   '  Digital input 9
'
'/*+---------------- Constants for DoPE commands  ----------------------------+*/
'
'
'/* ----- Connector constants ------------------------------------------------ */
'
Public Const CON_NON = &H0
Public Const CON_X1 = &H1
Public Const CON_X2 = &H2
Public Const CON_X3 = &H3
Public Const CON_X4 = &H4
Public Const CON_X5 = &H5
Public Const CON_X7 = &H7
Public Const CON_X10 = &HA
Public Const CON_X14 = &HE
Public Const CON_X21A = &H15
Public Const CON_X21B = &H55
Public Const CON_X21C = &H95
Public Const CON_X21D = &HD5
Public Const CON_X22A = &H16
Public Const CON_X22B = &H56
Public Const CON_X22C = &H96
Public Const CON_X22D = &HD6
Public Const CON_X23A = &H17
Public Const CON_X23B = &H57
Public Const CON_X23C = &H97
Public Const CON_X23D = &HD7
Public Const CON_X24A = &H18
Public Const CON_X24B = &H58
Public Const CON_X24C = &H98
Public Const CON_X24D = &HD8
Public Const CON_X25A = &H19
Public Const CON_X25B = &H59
Public Const CON_X25C = &H99
Public Const CON_X25D = &HD9
Public Const CON_X26A = &H1A
Public Const CON_X26B = &H5A
Public Const CON_X26C = &H9A
Public Const CON_X26D = &HDA
Public Const CON_X27A = &H1B
Public Const CON_X27B = &H5B
Public Const CON_X27C = &H9B
Public Const CON_X27D = &HDB
Public Const CON_X28A = &H1C
Public Const CON_X28B = &H5C
Public Const CON_X28C = &H9C
Public Const CON_X28D = &HDC
Public Const CON_X36A = &H24
Public Const CON_X36B = &H64
Public Const CON_X37A = &H25
Public Const CON_X37B = &H65
Public Const CON_X38A = &H26
Public Const CON_X38B = &H66
Public Const CON_X39A = &H27
Public Const CON_X39B = &H67
Public Const CON_X61A = &H3D
Public Const CON_X61B = &H7D
Public Const CON_X61C = &HBD
Public Const CON_X61D = &HFD
Public Const CON_X62A = &H3E
Public Const CON_X62B = &H7E
Public Const CON_X62C = &HBE
Public Const CON_X62D = &HFE
Public Const CON_X63A = &H3F
'
'
'/* ----- Constants for closed loop control modes ---------------------------- */
'
Public Const CTRL_POS = 0              ' X-Head position control
Public Const CTRL_LOAD = 1             ' Load control
Public Const CTRL_EXTENSION = 2        ' Extension control
Public Const CTRL_SENSOR_3 = 3         ' Sensor 3  control
Public Const CTRL_SENSOR_4 = 4         ' Sensor 4  control
Public Const CTRL_SENSOR_5 = 5         ' Sensor 5  control
Public Const CTRL_SENSOR_6 = 6         ' Sensor 6  control
Public Const CTRL_SENSOR_7 = 7         ' Sensor 7  control
Public Const CTRL_SENSOR_8 = 8         ' Sensor 8  control
Public Const CTRL_SENSOR_9 = 9         ' Sensor 9  control
Public Const CTRL_SENSOR_10 = 10       ' Sensor 10 control
Public Const CTRL_SENSOR_11 = 11       ' Sensor 11 control
Public Const CTRL_SENSOR_12 = 12       ' Sensor 12 control
Public Const CTRL_SENSOR_13 = 13       ' Sensor 13 control
Public Const CTRL_SENSOR_14 = 14       ' Sensor 14 control
Public Const CTRL_SENSOR_15 = 15       ' Sensor 15 control
'
'
'/* ----- Bit constants for measuring channels ------------------------------- */
'
Public Const MCBIT_S = &H1
Public Const MCBIT_F = &H2
Public Const MCBIT_E = &H4
Public Const MCBIT_D = &H8
Public Const MCBIT_4 = &H10
Public Const MCBIT_5 = &H20
Public Const MCBIT_6 = &H40
Public Const MCBIT_7 = &H80
Public Const MCBIT_8 = &H100
Public Const MCBIT_9 = &H200
Public Const MCBIT_10 = &H400
Public Const MCBIT_11 = &H800
Public Const MCBIT_12 = &H1000
Public Const MCBIT_13 = &H2000
Public Const MCBIT_14 = &H4000
Public Const MCBIT_15 = &H8000
'
'
'/* ------ Constants for  'CheckID' in DoPESetCheck -------------------------- */
'
Public Const CHK_ID0 = 0               ' channel supervision ID 0
Public Const CHK_ID1 = 1               ' channel supervision ID 1
Public Const CHK_ID2 = 2               ' channel supervision ID 2
Public Const CHK_ID3 = 3               ' channel supervision ID 3
Public Const CHK_ID4 = 4               ' channel supervision ID 4
Public Const CHK_ID5 = 5               ' channel supervision ID 5
Public Const CHK_ID6 = 6               ' channel supervision ID 5
Public Const CHK_ID7 = 7               ' channel supervision ID 5
Public Const CHK_ID8 = 8               ' channel supervision ID 5
Public Const CHK_ID9 = 9               ' channel supervision ID 5
Public Const CHK_NUMBER = 10           ' Number of channel supervisions
Public Const CHK_ID_ALL = &HFFFF       ' All supervision ID's (for clear)
Public Const CHK_NOCLEAR = &H8000      ' Mask to "or" with CHK_Idx for checks
                                       ' that should not be cleared after
                                       ' another check hits
'
'
'/* ------ Constants  for 'Mode' in DoPESetCheck   --------------------------- */
'
Public Const CHK_BELOW = 0             ' Condition (value < Limit)
Public Const CHK_ABOVE = 1             ' Condition (value > Limit)
Public Const CHK_PERCENT_MAX = 2       ' Condition (value < % of max value)
Public Const CHK_PERCENT_MIN = 3       ' Condition (value > % of min value)
Public Const CHK_ABS_MAX = 4           ' Condition (value < max - x)
Public Const CHK_ABS_MIN = 5           ' Condition (value > min - x)
'
'
'/* ------ Constants  for 'Action' in  DoPESetCheck(X) ----------------------- */
'/* ------ Constants  for 'Action' in  DoPEShieldLimit ----------------------- */
'/* ------ for DoPEShieldLimit only ACTION_HALT and ACTION_STOP are allowed !! */
'
Public Const ACTION_HALT = 0           ' HALT with default deceleration
Public Const ACTION_HALT_A = 1         ' HALT with specified deceleration
Public Const ACTION_POS = 2            ' Position with default deceleration
Public Const ACTION_POS_A = 3          ' Position with specified deceleration
Public Const ACTION_XPCONT = 4         ' Change control mode, go on with
                                       ' current speed
Public Const ACTION_STOP = 5           ' STOP (switch off drive)
Public Const ACTION_NOACTION = 6       ' No action, only message to host
Public Const ACTION_SETOL = 7          ' Set command output in open loop
Public Const ACTION_SHALT = 8          ' immediate S-Halt
Public Const ACTION_UP = 9             ' Move Up with specified speed
Public Const ACTION_DOWN = 10          ' Move Down with specified speed
Public Const ACTION_DRIVE_OFF = 11     ' Switch drive OFF
'
'/* ------ Constants  for 'Mode' DoPEExt2Ctrl and DoPEFDPoti ----------------- */
                                       ' Constants 0 .. 3 refer to measuring
                                       ' values. E.g EXT_SPEED_POSITIVE
                                       ' moves to increasing values.
Public Const EXT_POSITION = 0          ' Position
Public Const EXT_SPEED_BIPOLAR = 1     ' Speed bipolar
Public Const EXT_SPEED_POSITIVE = 2    ' Speed positive direction
Public Const EXT_SPEED_NEGATIVE = 3    ' Speed negative direction
                                       '
                                       ' Direction UP/DOWN
                                       ' Constants 0 .. 3 refer to movement
                                       ' UP/DOWN. E.g EXT_SPEED_UP moves
                                       ' crosshead UP.
Public Const EXT_POS_UP_DOWN = 4       ' Position
Public Const EXT_SPEED_UP_DOWN = 5     ' Speed bipolar
Public Const EXT_SPEED_UP = 6          ' Speed UP
Public Const EXT_SPEED_DOWN = 7        ' Speed DOWN

Public Const EXT_POS_OPENLOOP = 8      ' Position (only for open loop position
                                       ' ctrl-structure.) and PS_FDPOTI
'
'/* ------ Constants  for 'Direction' in DoPEFMove command  ------------------ */
'
Public Const MOVE_HALT = 0             '  Halt
Public Const MOVE_UP = 1               '  move UP
Public Const MOVE_DOWN = 2             '  move DOWN
'
'
'/* ------ Constants  for 'LimitMode' and 'DestMode' in DoPEPosExt... commands */
'
Public Const LIMIT_ABSOLUTE = 0        ' Limit is a absolute Position
Public Const LIMIT_RELATIVE = 1        ' Limit is a distance (relative)Position
Public Const LIMIT_NOT_ACTIVE = 2      ' No Limit is active

Public Const DEST_APPROACH = 0         ' Halt after reaching destination,
                                       ' do not change control mode
Public Const DEST_POSITION = 1         ' Change control mode in time and
                                       ' position to destination
Public Const DEST_MAINTAIN = 2         ' No change of control mode at destination
                                       ' but maintain destination in
                                       ' moving control mode

'/* ------ Constants  for 'ModeFlags' in  DoPEStartCMD ------------------------ */
'
Public Const CMD_DWND = 1              ' supervise destination window
Public Const CMD_MESSAGE = 2           ' report intermediate destinations
'
'
'/* ------ Constants  for 'Operation' in  DoPEEndCMD ------------------------- */
'
Public Const CMD_DISCARD = 0           ' Reject movement sequence
Public Const CMD_START = 1             ' Start movement sequence
'
'
'/* ------ Constants  for Reaction in DoPECtrlError and DoPESft -------------- */

Public Const REACT_STATUS = 0          ' only status bits are set
Public Const REACT_ACTION = 1          ' React according to pre defined action


'/* ------ Constants  for 'LimitCtrl' in DoPESenDef -------------------------- */

Public Const REACT_STATE = 0          ' only status bits are set
Public Const REACT_DRIVE_OFF = 1      ' turn off drive
Public Const REACT_SHALT = 2          ' halt crosshead in position control


'/* ------ Constants  for 'Mode' in DoPECosinePeakCtrl ----------------------- */

Public Const COS_PCT_AUTO1 = 0         ' Pilot control with Start offset
Public Const COS_PCT_AUTO2 = 1         ' Pilot control without Start offset
Public Const COS_PCT_MANUAL = 2        ' Manual pilot control
Public Const COS_PCT_KEEP = 3          ' Stop pilot control, keep values
Public Const COS_PCT_CONTINUE = 4      ' Continue pilot control, use values
Public Const COS_PCT_RESET = 5         ' Reset pilot control, zero values


'/* ------ Constants  for 'Mode' and 'Priority' in DoPEMc2Output -------------- */

Public Const MC2OUT_MAX = 3            ' Number of Mc2Output definition points
                                       
Public Const MC2OUT_MODE_OFF = 0       ' Mc2Output disabled
Public Const MC2OUT_MODE_2POINTS = 1   ' Mc2Output definition by 2 points
Public Const MC2OUT_MODE_3POINTS = 2   ' Mc2Output definition by 3 points
                                       
Public Const MC2OUT_PRIORITY_HIGH = 0  ' Output all channels every 20 ms
Public Const MC2OUT_PRIORITY_LOW = 1   ' Output one of the channel every 20 ms
Public Const MC2OUT_PRIORITY_BURST = 2 ' Output every speed controller cycle


'/* ------ Constants for MachineNoIo in DoPEGeneralData ---------------------- */

Public Const MACHINE_NO_IO_OFF = 0     ' don't use IO  to select machine
Public Const MACHINE_NO_IO_IN_OUT = 1  ' use IO IN-OUT to select machine
Public Const MACHINE_NO_IO_OUT = 2     ' use IO OUT    to select machine
Public Const MACHINE_NO_IO_IN = 3      ' use IO IN     to select machine


'/* ------ Constants  for Language in DoPEGeneralData ------------------------ */

Public Const LANGUAGE_ENGLISH = 0
Public Const LANGUAGE_GERMAN = 1
Public Const LANGUAGE_USER1 = 2
Public Const LANGUAGE_USER2 = 3


'/* ------ Constants  for 'CtrlStructure' in DoPEMachineDef ------------------ */

Public Const CTRL_STRUCTURE_SPINDLE = 0    ' Digital position controller
                                           ' for speed controlled drives
Public Const CTRL_STRUCTURE_HYDRAULIC = 1  ' Hydraulic
Public Const CTRL_STRUCTURE_OPENLOOP = 3   ' No control (only for CTRL_POS)
Public Const CTRL_STRUCTURE_SPINDLE_SP = 6 ' Digital position and speed controller


'/* ------ Constants  for shield in DoPEMachineDef --------------------------- */

Public Const SHIELD_SIMPLE = 0          ' Protective shield without lock fnct.
Public Const SHIELD_SECURE = 1          ' Protective shield with lock function


'/* ------ Constants  for Mode in DoPEOfflineAction... ----------------------- */

Public Const DO_NOTHING = 0             ' Don't modify this output
Public Const USE_INIT_VALUE = 1         ' Use Setup Initial value after offline
Public Const USE_VALUE = 2              ' Use defined value after offline


'/* ------ Constants  for Signal and frequency in DoPEOutChaDef -------------- */

Public Const OUTSIGNAL_A_B = 0             ' A/B
Public Const OUTSIGNAL_PULSE_SIGN = 1      ' pulse/sign
Public Const OUTSIGNAL_UP_DOWN = 2         ' up/down
Public Const OUTSIGNAL_ANALOGUE = 3        ' analogue (+/- 10V)
Public Const OUTSIGNAL_DC_MOTOR = 4        ' PWM with dirction/amplitude signals
Public Const OUTSIGNAL_DC_LINEAR_MOTOR = 5 ' PWM with single, variable duty-cycle signal
Public Const OUTSIGNAL_SIGN_MAGNITUDE = 4  ' legacy: use OUTSIGNAL_DC_MOTOR
Public Const OUTSIGNAL_LOCKEDANTIPHASE = 5 ' legacy: use OUTSIGNAL_DC_LINEAR_MOTOR
Public Const OUTSIGNAL_MAX = 6             ' number of signals

Public Const OUTSIGNALFREQU4MHz = 0
Public Const OUTSIGNALFREQU2MHz = 1
Public Const OUTSIGNALFREQU1MHz = 2
Public Const OUTSIGNALFREQU500kHz = 3
Public Const OUTSIGNALFREQU250kHz = 4
Public Const OUTSIGNALFREQU125kHz = 5
Public Const OUTSIGNALFREQU60kHz = 6
Public Const OUTSIGNALFREQU30kHz = 7
Public Const OUTSIGNALFREQU15kHz = 8
Public Const OUTSIGNALFREQU_MAX = 9

'/* ------ Constants  for CurrentControllerGain in DoPEOutChaDef ------------- */

Public Const OUTCURRCTRLGAINSET_0_009mH = 0  ' 0.009 mH
Public Const OUTCURRCTRLGAINSET_0_018mH = 1  ' 0.018 mH
Public Const OUTCURRCTRLGAINSET_0_037mH = 2  ' 0.037 mH
Public Const OUTCURRCTRLGAINSET_0_073mH = 3  ' 0.073 mH
Public Const OUTCURRCTRLGAINSET_0_15mH = 4   ' 0.15  mH
Public Const OUTCURRCTRLGAINSET_0_29mH = 5   ' 0.29  mH
Public Const OUTCURRCTRLGAINSET_0_59mH = 6   ' 0.59  mH
Public Const OUTCURRCTRLGAINSET_1_2mH = 7    ' 1.2   mH
Public Const OUTCURRCTRLGAINSET_2_3mH = 8    ' 2.3   mH
Public Const OUTCURRCTRLGAINSET_4_7mH = 9    ' 4.7   mH
Public Const OUTCURRCTRLGAINSET_9_4mH = 10   ' 9.4   mH
Public Const OUTCURRCTRLGAINSET_19mH = 11    ' 19    mH
Public Const OUTCURRCTRLGAINSET_38mH = 12    ' 38    mH
Public Const OUTCURRCTRLGAINSET_75mH = 13    ' 75    mH
Public Const OUTCURRCTRLGAINSET_150mH = 14   ' 150   mH
Public Const OUTCURRCTRLGAINSET_300mH = 15   ' 300   mH
Public Const OUTCURRCTRLGAINSET_MAX = 16     ' number of settings
'
'/*+--------------- Constants  for commands from subsystem  ------------------+*/
'
'
'/* ------ Constants  for 'typ' in  SP_MKINFO -------------------------------- */
'
Public Const MKTYP_ABSOLUT_MB = 0      ' Absolute measuring channel with build
                                       ' in reference (standard ADC)
Public Const MKTYP_ABSOLUT_OB = 1      ' Absolute measuring channel without
                                       ' build in reference (encoders)
Public Const MKTYP_INTGR = 2           ' Integrating measuring channel
                                       ' Doli standard AD-Converter
'
'/* ------ Constants  for 'ErrorNumber' in message  COMMAND_ERROR ------------ */
'
Public Const CMD_ERROR_NOERROR = 0     ' No Error
Public Const CMD_ERROR_PARCORR = 1001  ' Error in parameter (corrected)
Public Const CMD_ERROR_PAR = 1003      ' Error in parm. not correctable
Public Const CMD_ERROR_XMOVE = 1004    ' X-Head is not halted
Public Const CMD_ERROR_INITSEQ = 1005  ' Sequence in init. not observed
Public Const CMD_ERROR_NOTINIT = 1006  ' Controller part not initialised
Public Const CMD_ERROR_DIR = 1007      ' Movement direction  not possible
Public Const CMD_ERROR_TMP = 1008      ' Required resource not available
Public Const CMD_ERROR_RUNTIME = 1009  ' Run time error active
Public Const CMD_ERROR_INTERN = 1010   ' Internal error in subsystem
Public Const CMD_ERROR_MEM = 1011      ' Insufficient memory
Public Const CMD_ERROR_CST = 1012      ' Wrong controller Structure
Public Const CMD_ERROR_NIM = 1013      ' Command not implemented
Public Const CMD_ERROR_MSGNO = 2001    ' Unknown message number
Public Const CMD_ERROR_VERSION = 2003  ' Wrong PE interface version
Public Const CMD_ERROR_OPEN = 2004     ' Setup not opened
Public Const CMD_ERROR_MEMORY = 2005   ' Not enough memory


'/* ------ Constants  for 'ErrorNumber' in message  RUNTIME_ERROR ------------ */

Public Const RTE_EMOVE_END = 104          ' Error at end of emergency movement
                                          ' still active
Public Const RTE_CTRL_DEVIATION = 105     ' Controller deviation error
                                          ' Control channel see device
                                          '
Public Const RTE_DRIVE_OFF = 201          ' Drive off or emergency off
Public Const RTE_E_MOVE_RQ = 202          ' emergency off, emergency drive required
Public Const RTE_UPPER_LIMIT_SWITCH = 203 ' Upper hard-limit switch active
Public Const RTE_LOWER_LIMIT_SWITCH = 204 ' Lower hard-limit switch active
Public Const RTE_STOP = 205               ' Drive not ready
Public Const RTE_DF_KEY = 206             ' Drive free withdrawn by key
Public Const RTE_SHALT = 207              ' Signal S-HALT activated
                                          '
Public Const RTE_UPPER_LIMIT = 301        ' Upper range limit exceeded
Public Const RTE_LOWER_LIMIT = 302        ' Lower range limit exceeded

Public Const RTE_ERROR_UNHANDLED = 999    ' Unknown runtime error

'
'/* ------ Constants  for 'MsgId' in  MOVE_CTRL_MSG -------------------------- */
'
Public Const CMSG_POS = 1                ' Destination reached
Public Const CMSG_UPPER_SFT = 2          ' Upper softend reached
Public Const CMSG_LOWER_SFT = 3          ' Lower softend reached
Public Const CMSG_POS_ERR = 4            ' Destination window not reached
                                         ' 5 reserved
Public Const CMSG_TPOS = 6               ' Trigger position reached
Public Const CMSG_TPOS_ERR = 7           ' Destination window for Trigger not r.
Public Const CMSG_LPOS = 8               ' Limit position reached
Public Const CMSG_LPOS_ERR = 9           ' Destination window not reached (limit)

                                         ' 48 reserved
Public Const CMSG_OFFSET = 49            ' Offset correction finished
Public Const CMSG_REF_END = 50           ' Reference cycle successfully finished

Public Const CMSG_CHECK = 51             ' Channel supervision has triggered
Public Const CMSG_CHECK_ERR = 52         ' Channel supervision has triggered but
                                         ' specified action was not started
Public Const CMSG_SHIELD = 53            ' Protective Shield  supervision has triggered
Public Const CMSG_SHIELD_ERR = 54        ' Protective Shield  supervision has triggered
                                         ' but specified action was not started
Public Const CMSG_REFSIGNAL = 55         ' Reference Signal occured

Public Const CMSG_IO_SHALT_UPPER = 56    ' Upper IO_SHalt Signal occured        }
Public Const CMSG_IO_SHALT_LOWER = 57    ' Lower IO_SHalt Signal occured        }

'
'/* ----- Constants  for 'InSignals' ----------------------------------------- */
'
Public Const IN_SIG_DRIVE_OFF = &H1              ' Drive off or emergency off
Public Const IN_SIG_E_MOVE_RQ = &H2              ' Emergency off,

Public Const IN_SIG_UPPER_LIMIT_SWITCH = &H4     ' Upper hard-limit switch active
Public Const IN_SIG_LOWER_LIMIT_SWITCH = &H8     ' Lower hard-limit switch active
Public Const IN_SIG_NO_CTRL = &H10               ' Drive not ready (stop)
Public Const IN_SIG_DF_KEY = &H20                ' Drive free withdrawn by key
Public Const IN_SIG_SHALT = &H40                 ' Signal S-HALT activated

Public Const IN_SIG_REFERENZ = &H80              ' X-head reference switch
Public Const IN_SIG_SH_CLOSED = &H100            ' Shield closed
Public Const IN_SIG_SH_LOCKED = &H200            ' Shield locked
Public Const IN_SIG_SH_INACTIVE = &H400          ' Shield function inactive
Public Const IN_SIG_IO_SHALT_UPPER = &H800       ' IO-Signal SHaltUpper
Public Const IN_SIG_IO_SHALT_LOWER = &H1000      ' IO-Signal SHaltLower
Public Const IN_SIG_CPU_EMERGENCY_OFF = &H2000   ' Internal emergency off

'/* ----- Constants  for 'OutSignals' ---------------------------------------- */
'
Public Const O_SIG_DRIVE_ON = &H1                ' Drive ON output
Public Const O_SIG_DRIVE_FREE = &H2              ' Drive FREE output
Public Const O_SIG_BRAKE = &H4                   ' Brake output
Public Const O_SIG_E_MOVE = &H8                  ' Emergency movement output
Public Const O_SIG_BYPASS = &H10                 ' Bypass output

Public Const O_SIG_LIMIT = &H20                  ' Load limit for grip reached
Public Const O_SIG_SH_LOCK = &H40                ' Lock Shield
Public Const O_SIG_ON_RELAY = &H80               ' ON Relay output
Public Const O_SIG_INTERNAL_DRIVE_ENABLE = &H200
Public Const O_SIG_READY_TO_MOVE = &H400         ' Controller ready for pos.cmd
Public Const O_SIG_EDC_READY = &H800             ' EDC ready
Public Const O_SIG_DRIVE_OFF = &H1000            ' EDC Drive Off

'/* ----- Constants  for 'CtrlState1' -------------------------------------- */
'
'/* --------- 1. Hexnibble : Bit for control mode -------------------------- */
Public Const CTRL_STATE_POS = &H1      ' X-Head control is active
Public Const CTRL_STATE_LOAD = &H2     ' Load control is active
Public Const CTRL_STATE_EXT = &H4      ' Extension control is active
'
'/* --------- 2. Hexnibble : State  command generator and X-Head ----------- */
Public Const CTRL_HALT = &H10          ' Command generator not running
Public Const CTRL_DOWN = &H20          ' Movement DOWN
Public Const CTRL_UP = &H40            ' Movement UP
Public Const CTRL_MOVE = &H80          ' X-Head moves (not halted)
'
'/* --------- 3. and 4. Hexnibble : State  movement control ---------------- */
Public Const CTRL_READY = &H100        ' Moving command will be accepted
Public Const CTRL_FREE = &H200         ' Waiting for free signal (PC or user)
Public Const CTRL_INIT_E = &H400       ' Emergency movement has to be activated
Public Const CTRL_SFTSET = &H800       ' Change of softends allowed

Public Const CTRL_SYNCHWAIT = &H2000   ' Synch State: 1 = wait for Start
Public Const CTRL_SLAVE = &H4000       ' Synch State: 0 = Master 1 = Slave
Public Const CTRL_E_ACTIVE = &H8000    ' Emergency movement active
'
'
'
'/* ----- Constants  for 'CtrlState2' -------------------------------------- */
'
'  /* ---- Status bits in controller status word 2 ------------------------- */
Public Const CTRL_LOWER_SFT_S = &H1          '  Lower softend X-Head
Public Const CTRL_LOWER_SFT_F = &H2          '  Lower softend load
Public Const CTRL_LOWER_SFT_E = &H4          '  Lower softend extension
Public Const CTRL_UPPER_SFT_S = &H10         '  Upper softend X-Head
Public Const CTRL_UPPER_SFT_F = &H20         '  Upper softend load
Public Const CTRL_UPPER_SFT_E = &H40         '  Upper softend extension

Public Const CTRL_CYCLES_ACTIVE = &H400      '  Cycle command active
                                             ' (cosin, rectangle, triangle,
                                             '  cycles, dyn_cycles)
Public Const CTRL_HIGH_PRESSURE = &H800      '  High pressure
Public Const CTRL_UPPER_LIMIT = &H4000       '  Upper range limit X-Head
Public Const CTRL_LOWER_LIMIT = &H2000       '  Lower range limit X-Head
Public Const CTRL_CALIBRATION = &H1000       '  Calibrate analogue channels
Public Const CTRL_ERROR = &H8000             ' Deviation position controller
'
'
'  /* -------- Definitions of EDC Frontpanel Key's (EDC5/25, EDC100/120)------ */

Public Const PE_LED_UP = &H1           ' Bit mask for LED 'UP'
Public Const PE_LED_DOWN = &H2         ' Bit mask for LED 'DOWN'
Public Const PE_LED_TEST = &H4         ' Bit mask for LED 'TEST'


'' Definitions of EDC Frontpanel Key's
'
'/*
'  DoPE handling of EDC frontpanel keys:
'       The EDC-frontpanel keys are decoded and transmitted in DoPE data record
'       in three word's, One word represents the active state of the keys, one
'       word all new keys and one word all gone keys.
'       The "0"-"9", "F1" - "F3", "." and "±" keys are coded in the low byte
'       in ASCII, The "Up", "Down", "Halt" and "DigiPoti" keys are represented
'       as single bits in the upper byte.
'*/
'
Public Const PE_KEY_HALT = &H100       ' Bit mask for Key 'HALT'
Public Const PE_KEY_UP = &H200         ' Bit mask for Key 'UP'
Public Const PE_KEY_DOWN = &H400       ' Bit mask for Key 'DOWN'
Public Const PE_KEY_DPOTI = &H800      ' Bit mask for Key 'DigiPoti'

Public Const PE_KEY_0 = &H30           ' Code for Key '0'
Public Const PE_KEY_1 = &H31           ' Code for Key '1'
Public Const PE_KEY_2 = &H32           ' Code for Key '2'
Public Const PE_KEY_3 = &H33           ' Code for Key '3'
Public Const PE_KEY_4 = &H34           ' Code for Key '4'
Public Const PE_KEY_5 = &H35           ' Code for Key '5'
Public Const PE_KEY_6 = &H36           ' Code for Key '6'
Public Const PE_KEY_7 = &H37           ' Code for Key '7'
Public Const PE_KEY_8 = &H38           ' Code for Key '8'
Public Const PE_KEY_9 = &H39           ' Code for Key '9'
Public Const PE_KEY_DP = &H2E          ' Code for Key '.'
Public Const PE_KEY_SIGN = &HF1        ' Code for Key '±'
Public Const PE_KEY_F1 = &H41          ' Code for Key 'F1'
Public Const PE_KEY_F2 = &H42          ' Code for Key 'F2'
Public Const PE_KEY_F3 = &H43          ' Code for Key 'F3'

'  /* ---- Constants for SensorState in DoPESumSenInfo ----------------------- */

Public Const SENSOR_STATE_NOTOK = &H0  ' Sensor state not OK
Public Const SENSOR_STATE_OK = &H1     ' Sensor state OK
Public Const SENSOR_STATE_ACTIVE = &H2 ' Sensor state active
Public Const SENSOR_STATE_INIT = &H4   ' Sensor state initialization ok


'  /* ---- Constants for ComState in DoPEState ------------------------------- */

Public Const COM_STATE_OFF = 0          ' Link is disabled
Public Const COM_STATE_OFFLINE = 1      ' Link is offline
Public Const COM_STATE_INITCYCLE = 2    ' Link is initialising
Public Const COM_STATE_ONLINE = 3       ' Link is established (OnLine)


'  /* ---- Constants for serial sensor definition init. value ---------------- */
'
'/*
'  Stucture of Init word :
'     15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
'     Db Pa Pa Pc Pc Pc Pc Bd Bd Bd Bd Sb Po Po Po Si
'
'     Db =  0 => 7 Data Bits
'           1 => 8 Data Bits
'     Pa =  0 => No   Parity
'           1 => Odd  Parity
'           2 => Even Parity
'     Pc =  0 => No Protocol
'           1 => DOLI Standard binary protocol
'                (DLE STX D1 D2 D3 D4 CRC_H CRC_L) with DLE duplication
'           2    Eurothem temperature controller
'           3    Grado temperature controller
'           4    AI_808 temperature controller
'           5    Modbus Eurothem temperature controller
'           6    Modbus Grado temperature controller
'           7    Modbus Shimanden SRP30 temperature controller
'           8    Modbus Azbil SDC35/36 temperature controller
'           9-15 not yet used
'     Bd =  0 =>    110 Baud
'           1       150 BAUD
'           2       300 BAUD
'           3       600 BAUD
'           4      1200 BAUD
'           5      2400 BAUD
'           6      4800 BAUD
'           7      9600 BAUD
'           8     19200 BAUD
'           9     38400 BAUD
'          10     57600 BAUD
'          11    115200 BAUD
'          12    230400 BAUD
'          13    460800 BAUD
'          14    921600 BAUD
'     Sb =  0 => 1 Stop Bit
'           1    2 Stop Bits
'     Po = 0 >= DB_COM_DEBUG
'          1    DB_COM_COM1
'          2    DB_COM_COM2
'          3    DB_COM_COM3
'          4-7  not used
'     Si = 0 => positive Polarity
'          1    negative Polarity
'  */

Public Const SERSEN_SIGN_P = &H0
Public Const SERSEN_SIGN_N = &H1

Public Const SERSEN_PORT_DEBUG = &H0
Public Const SERSEN_PORT_COM1 = &H2
Public Const SERSEN_PORT_COM2 = &H4
Public Const SERSEN_PORT_COM3 = &H6

Public Const SERSEN_STOPBIT_1 = &H0
Public Const SERSEN_STOPBIT_2 = &H10

Public Const SERSEN_110BAUD = &H0
Public Const SERSEN_150BAUD = &H20
Public Const SERSEN_300BAUD = &H40
Public Const SERSEN_600BAUD = &H60
Public Const SERSEN_1200BAUD = &H80
Public Const SERSEN_2400BAUD = &HA0
Public Const SERSEN_4800BAUD = &HC0
Public Const SERSEN_9600BAUD = &HE0
Public Const SERSEN_19200BAUD = &H100
Public Const SERSEN_38400BAUD = &H120
Public Const SERSEN_57600BAUD = &H140
Public Const SERSEN_115200BAUD = &H160
Public Const SERSEN_230400BAUD = &H180
Public Const SERSEN_460800BAUD = &H1A0
Public Const SERSEN_921600BAUD = &H1C0

Public Const SERSEN_NOPROTOCOL = &H0
Public Const SERSEN_DOLIPROTOCOL = &H200
Public Const SERSEN_EUROTHERM = &H400
Public Const SERSEN_GRADO = &H600
Public Const SERSEN_AI_808 = &H800
Public Const SERSEN_MODBUS_EUROTHERM = &HA00
Public Const SERSEN_MODBUS_GRADO = &HC00
Public Const SERSEN_MODBUS_SHIMANDEN = &HE00
Public Const SERSEN_MODBUS_AZBIL = &H1000

Public Const SERSEN_NOPARITY = &H0
Public Const SERSEN_ODDPARITY = &H2000
Public Const SERSEN_EVENPARITY = &H4000

Public Const SERSEN_7DATABIT = &H0
Public Const SERSEN_8DATABIT = &H8000

'----------------------------------------------------------------------------

Public Const PEINTERFACE_LEN = 6        ' 'PE interface EDC VERSION' length
Public Const APPLICATION_LEN = 13       ' 'EDC appl. version'        length
Public Const SUBSY_LEN = 6              ' 'Subsystem version'        length
Public Const SUBSYCUSTVER_LEN = 6       ' 'Subsystem customer version' length
Public Const SUBSYCUSTNAME_LEN = 9      ' 'Subsystem customer name'  length
Public Const BIOS_LEN = 6               ' 'EDC BIOS version'         length
Public Const HWCTRL_LEN = 7             ' 'EDC controller hardware no' length
Public Const PEINTERFACEPC_LEN = 6      ' 'PE interface PC Version'  length
Public Const DPXVER_LEN = 6             ' 'DPX version'              length
Public Const SERIALNUMBER_LEN = 17      ' 'EDC serial number'        length
                                        ' all including terminating zero '\0'

Type DoPEVersion                        ' Read version
  PeInterface   As String * 6           ' PE interface PE_VERSION    "xx.xx"
  Application   As String * 13          ' EDC appl. version   "xxxxxxxx.xxx"
  Subsy         As String * 6           ' Subsystem version          "xx.xx"
  SubsyCustVer  As String * 6           ' Subsystem customer version "xx.xx"
  SubsyCustName As String * 9           ' Subsystem customer name "xxxxxxxx"
  BIOS          As String * 6           ' EDC BIOS version           "xx.xx"
  HwCtrl        As String * 7           ' EDC controller hardware no"xxxx.x"
  PeInterfacePC As String * 6           ' PE interface PC Version    "xx.xx"
  DpxVer        As String * 6           ' DPX version                "xx.xx"
  VBInterface   As String * 6           ' VB interface VERSION       "xx.xx"
  SerialNumber  As String * 17          ' EDC serial number"xxxxxxxxxxxxxxxx"
End Type                                ' Strings are zero terminated '\0'

'----------------------------------------------------------------------------

Public Const MODINFO_NAME_LEN = 80      ' maximum length of module name
                                        ' (including terminating zero '\0')
Type DoPEModuleInfo                     ' Definition of module info
  ID         As Long                    ' Module hardware ID             [No]
  Revision   As Long                    ' Module hardware revision       [No]
  DeviceID   As Long                    ' Device ID                      [No]
  FunctionID As Long                    ' Function ID (from MachineDef)  [No]
  SerNr      As Long                    ' Serial number                  [No]
  Status     As Long                    ' Module status                  [No]
  Name       As String * MODINFO_NAME_LEN ' Module name (e.g. "2INC 1742.000(-)")
End Type

'----------------------------------------------------------------------------

Public Const MAX_NOMV = 4               ' maximum number of nom. voltages
Public Const DRIVEINFO_NAME_LEN = 80    ' maximum length of drive name
                                        ' (including terminating zero '\0')

Type DoPEDriveInfo                      ' Definition of drive info
  ID                         As Long    ' Drive hardware ID              [No]
  Revision                   As Long    ' Drive hardware revision        [No]
  SerNr                      As Long    ' Serial number                  [No]
  NominalCurrent             As Double  ' Nominal current                 [A]
  MinCurrent                 As Double  ' Minimum current                 [A]
  MaxCurrent                 As Double  ' Maximum current                 [A]
  MaxCurrentTime             As Double  ' Maximum current time (I²t)      [s]
  NominalVoltageCount        As Long    ' Number of nominal voltages     [No]
  NominalVoltage(MAX_NOMV - 1) As Double ' Nominal voltage                 [V]
  MaxPower                   As Double  ' Maximum power                   [W]
  FeedbackPower              As Double  ' Average feedback power          [W]
  MinDither                  As Double  ' Minimum dither frequency       [Hz]
  MaxDither                  As Double  ' Maximum dither frequency       [Hz]
  CurrentControllerCycle     As Double  ' Current controller cycle time   [s]
                                        ' (0 = analogue or not adjustable)
  Name As String * DRIVEINFO_NAME_LEN   ' Drive name (e.g. "DC2500 1860.000(-)")
End Type

'----------------------------------------------------------------------------

' Machine IO signal bits
Public Const IO_SIGNAL_IN_MACHINE1 = &H1
Public Const IO_SIGNAL_IN_MACHINE2 = &H2
Public Const IO_SIGNAL_IN_MACHINE3 = &H4
Public Const IO_SIGNAL_IN_MACHINE4 = &H8
Public Const IO_SIGNAL_IN_MACHINE5 = &H10
Public Const IO_SIGNAL_IN_MACHINE6 = &H20
Public Const IO_SIGNAL_IN_MACHINE7 = &H40
Public Const IO_SIGNAL_IN_MACHINE8 = &H80

Public Const IO_SIGNAL_OUT_MACHINE1 = &H1
Public Const IO_SIGNAL_OUT_MACHINE2 = &H2
Public Const IO_SIGNAL_OUT_MACHINE3 = &H4
Public Const IO_SIGNAL_OUT_MACHINE4 = &H8
Public Const IO_SIGNAL_OUT_MACHINE5 = &H10
Public Const IO_SIGNAL_OUT_MACHINE6 = &H20
Public Const IO_SIGNAL_OUT_MACHINE7 = &H40
Public Const IO_SIGNAL_OUT_MACHINE8 = &H80

Public Const IO_SIGNAL_IN_MACHINE_MASK = &HFF
Public Const IO_SIGNAL_OUT_MACHINE_MASK = &HFF

                                        ' Sync option
                                        ' ----------------------------------
Public Const SYNC_OPTION_DISABLED = 0   ' Sync option is disabled
Public Const SYNC_OPTION_MASTER = 1     ' Sync option is present (master EDC)
Public Const SYNC_OPTION_SLAVE = 2      ' Sync option is present (slave  EDC)


Type DoPEGeneralData                    ' General data
  MachineNo     As Integer              ' Number of active machines      [No]
  MachineNoIo   As Integer              ' Machine select IO's config.    [No]
                                        ' (see MACHINE_NO_IO_... definitions)
  Supervisor    As Integer              ' Supervisor mode                [No] EDC120-
  SuperPassword As Integer              ' Supervisor Password(0=inactive)[No]
  UserPassword  As Integer              ' User       Password(0=inactive)[No]
  Logo          As Integer              ' DOLI Logo (0 = inactive)       [No]
  nRmc          As Long                 ' Required number of RMC's       [No] EDC220+
  Language      As Long                 ' Language                       [No] EDC220+
  FunctionID    As Long                 ' User defined function ID       [No] EDC220+
  SyncOption    As Integer              ' Sync option (SYNC_OPTION_xxx)  [No] EDC220+
  MachineNoIoBitConnector As Integer    ' BitIn/BitOut connector         [No] EDC220+
  MachineNoIoBitNo        As Integer    ' First bit of block          [0..15] EDC220+
End Type

'----------------------------------------------------------------------------

Type DoPESenDef                         ' Sensor definition data
  Connector     As Integer              ' Connector number of sensor     [No]
  Sign          As Integer              ' Invert sign of sensor         [1/0]
  CtrlChannel   As Integer              ' Activate control channel      [1/0]
  LimitCtrl     As Integer              ' Stop if limit exceeded        [1/0]
  ConnectedCtrl As Integer              ' Stop if disconnected          [1/0]
  UseEeprom     As Integer              ' Use sensor EEPROM data        [1/0]
                                        '
                                        ' Only for analogue sensors:
  Integr        As Double               ' Time of integration             [s]
                                        '
                                        ' Only for sensors without EEPROM:
  Init          As Integer              ' Sensor init                    [No]
  NominalValue  As Double               ' Nominal value of sensor      [Unit]
  Unit          As Integer              ' Unit of sensor UNIT_xxx        [No]
  Offset        As Double               ' Offset of sensor             [Unit]
  UpperLimit    As Double               ' Upper range limit of sensor     [%]
  LowerLimit    As Double               ' Lower range limit of sensor     [%]
                                        '
                                        ' Only for incremental sensors:
  Scale         As Double               ' Scale of sensor    [inc/revolution]
                                        '                       or [Unit/inc]
  Correction    As Double               ' Correction value of sensor     [No]
End Type

'----------------------------------------------------------------------------

Type DoPECtrlSenDef                     ' Control Sensor definition data
  Acceleration      As Double           ' Nominal acceleration      [Unit/sý]
  Speed             As Double           ' Nominal speed              [Unit/s]
  UnUsed1           As Double           ' Unused
  Unused2           As Double           ' Unused
  Deviation         As Double           ' Max. deviation of controller [Unit]
  DevReaction       As Integer          ' Reaction if deviation exceeded [No]
  PosP              As Long             ' Pos.  contr. P: gain           [No]
  PosI              As Integer          ' Pos.  contr. I: time constant  [No]
  PosD              As Integer          ' Pos.  contr. D: time constant  [No]
  PosFFP            As Long             ' Pos.  feed forward P           [No]
  SpeedP            As Long             ' Speed contr. P: gain           [No]
  SpeedI            As Integer          ' Speed contr. I: time constant  [No]
  SpeedD            As Integer          ' Speed contr. D: time constant  [No]
  UnUsed3           As Long             ' Unused
  UnUsed4           As Long             ' Unused
                                        ' Only for analogue sensors:
  Integr            As Double           ' Time of integration for control.[s]
  SpeedFFP          As Integer          ' Speed feed forward             [No]
  PosDelay          As Integer          ' Delay for Command              [No]
  AccFFP            As Integer          ' Acceleration contr. P: gain    [No]
  SpeedDelay        As Integer          ' Delay for SpeedCommand         [No]
End Type

'----------------------------------------------------------------------------

Type DoPEMc2OutputDef                    ' Measured channel to analogue output
  Mode      As Integer                   ' MC2OUT_MODE_...                [No]
  SensorNo  As Integer                   ' Sensor number               [0..15]
  SensorPoint(MC2OUT_MAX - 1) As Double  ' Sensor Point Values          [Unit]
  OutputPoint(MC2OUT_MAX - 1) As Double  ' Output Point Values             [%]
End Type

Type DoPEOutChaDef                      ' Definition of output channel
  Connector             As Integer      ' Connector number of channel    [No]
  Sign                  As Integer      ' Invert sign of channel        [1/0]
  MaxValue              As Double       ' Maximum output value            [%]
  MinValue              As Double       ' Minimum output value            [%]
  InitValue             As Double       ' Initial output value            [%]
                                        ' Only if adjustable (DDAxx):
  PaVoltage             As Double       ' Max. voltage of power amplifier [V]
  PaCurrent             As Double       ' Max. current of power amplifier [A]
  MaxCurrTime           As Double       ' Max. time for max. current (I²t)[s]
  DitherFrequency       As Double       ' Dither frequency               [Hz]
  DitherAmplitude       As Double       ' Dither amplitude                [%]
  CurrentControllerGain As Integer      ' Current controller gain set    [No]
  Signal                As Integer      ' Digital command output signal  [No]
  SignalFrequency       As Integer      ' Digital command output signal  [No]
  UnUsed1               As Integer      ' Unused
  Unused2               As Integer      ' Unused
  Offset                As Double       ' Offset of channel               [%]
  CurrentP              As Long         ' current.contr. P: gain         [No]
  CurrentI              As Integer      ' current.contr. P: time constant[No]
  CurrentD              As Integer      ' current.contr. P: time constant[No]
  Mc2Output             As DoPEMc2OutputDef ' Measured channel to analogue output
End Type

'----------------------------------------------------------------------------

Type DoPEBitOutDef                      ' Definition of bit output
  Connector As Integer                  ' Connector number of device     [No]
  InitValue As Integer                  ' Initial value of device        [No]
End Type

'----------------------------------------------------------------------------

Type DoPEBitInDef                       ' Definition of bit input
  Connector As Integer                  ' Connector number of device     [No]
  StopMask  As Integer                  ' Set bits stop the machine      [No]
  StopLevel As Integer                  ' Active level mask of StopMask  [No]
End Type

'----------------------------------------------------------------------------

Public Const LIMIT_SWITCH_TYPE_SINGLE = 0      ' One limit switch present
Public Const LIMIT_SWITCH_TYPE_UPPER_LOWER = 1 ' Two limit switches present

Public Const XHEAD_INITIAL_MODE_AUTOMATIC = 0  ' Set XHead to last known position
Public Const XHEAD_INITIAL_MODE_MANUAL = 1     ' Set XHead to manual position

Public Const X4PIN14_MODE_BYPASS = 0           ' X4 Pin14 mode bypass
Public Const X4PIN14_MODE_EDC_READY = 1        ' X4 Pin14 mode EDC ready

Type DoPEMachineDef                     ' Definition of machine data
  SpeedCtrlTime        As Double        ' Speed controller cycle time     [s]
                                        '                    [0.2ms .. 2.5ms]
  PosCtrlTime          As Double        ' Position controller cycle time  [s]
  CtrlStructure        As Integer       ' Closed loop control structure  [No]
  DataTransmissionRate As Double        ' Data transmission rate          [s]
  Mode                 As Integer       ' Data acquisition or control   [1/0]
  UnUsed3              As Integer       ' Unused
  XheadDir             As Integer       ' Machine moves up/down         [1/0]
                                        ' with positive output signal
  UnUsed4              As Double        ' Unused
  EncXheadRatio        As Double        ' Ratio encoder-Xhead      [Rev/Unit]
  BrakeOpen            As Double        ' Delay time to open brake after  [s]
                                        ' closed loop control is active
  BrakeClose           As Double        ' Delay time to close brake before[s]
                                        ' closed loop control is deactivated
  PistonArea           As Double        ' Area of piston for hydraulic   [m²]
  LoadMax              As Double        ' Max. load capacity of machine   [N]
  Load100              As Double        ' Nominal load of machine         [N]
  Stiffness            As Double        ' Over all stiffness of machine [N/m]
  UnUsed1              As Integer       ' Unused
  Unused2              As Integer       ' Unused
  GripConnector        As Integer       ' Grip: connector number         [No]
  GripChannel          As Integer       ' Grip: channel                  [No]
  GripActive           As Integer       ' Grip: active Low/High          [No]
  ShieldConnector      As Integer       ' Shield: connector number       [No]
  ShieldType           As Integer       ' Shield: type simple/locked     [No]
  ShieldTimeout        As Double        ' Shield: timeout                 [s]
  CtrlOnMode           As Integer       ' CTRL ON mode: 0=NoCtrl, 1=Ctrl
  FixValue             As Double        ' Fixing  output value            [%]
  InitValue            As Double        ' Initial output value            [%]
  ReturnValue          As Double        ' Return  output value            [%]
  ShieldUprLock        As Double        ' Shield: max. load limit      [Unit]
  ShieldLwrLock        As Double        ' Shield: min. load limit      [Unit]
  ShieldSpeedLimit     As Double        ' Shield: max. pos. speed if open [Unit/s]
  LimitSwitchType      As Integer       ' LIMIT_SWITCH_TYPE_xxx          [No]
  XheadInitialMode     As Integer       ' XHEAD_INITIAL_MODE_xxx         [No]
  XheadInitialValue    As Double        ' Initial XHead value (manual) [Unit]
  X4Pin14Mode          As Integer       ' X4PIN14_MODE_xxx               [No]
End Type

'----------------------------------------------------------------------------

Public Const LIN_DATA_MAX = 10          ' Max. numbers of lin. points

Type DoPELinTblFalse                    ' Definition of linearisation table
  LinNo As Integer                      ' Number of points for mode lin. [No]
  FalseValue(LIN_DATA_MAX - 1) As Double ' Measured value by the EDC       [N]
End Type

Type DoPELinTblTrue                     ' Definition of linearisation table
  LinNo As Integer                      ' Number of points for mode lin. [No]
  TrueValue(LIN_DATA_MAX - 1) As Double ' True value measured by the      [N]
End Type

'----------------------------------------------------------------------------

' Grip modes
Public Const IO_GRIP_MODE_0_OFF = 0                   ' grip disabled
Public Const IO_GRIP_MODE_1_TANSPARENT = 1            ' digital outputs are set according to grip keys
                                                      ' grip leds are set according to digital inputs
Public Const IO_GRIP_MODE_2_LIMIT_CTRL = 2            ' only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active
Public Const IO_GRIP_MODE_2_LIMIT_CTRL_INVERTED = 3   ' only IO_SIGNAL_OUT_GRIP_OPEN_ENABLE is active (inverted)

' Grip IO signal bits
Public Const IO_SIGNAL_IN_GRIP_CONNECTED = &H1
Public Const IO_SIGNAL_IN_GRIP_UPPER_OPENED = &H2
Public Const IO_SIGNAL_IN_GRIP_LOWER_OPENED = &H4
Public Const IO_SIGNAL_IN_GRIP_UPPER_CLOSED = &H8
Public Const IO_SIGNAL_IN_GRIP_LOWER_CLOSED = &H10
Public Const IO_SIGNAL_IN_GRIP_HIGH_PRESSURE = &H20

Public Const IO_SIGNAL_OUT_GRIP_OPEN_ENABLE = &H1
Public Const IO_SIGNAL_OUT_GRIP_UPPER_OPEN = &H2
Public Const IO_SIGNAL_OUT_GRIP_LOWER_OPEN = &H4
Public Const IO_SIGNAL_OUT_GRIP_UPPER_CLOSE = &H8
Public Const IO_SIGNAL_OUT_GRIP_LOWER_CLOSE = &H10
Public Const IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE1 = &H20
Public Const IO_SIGNAL_OUT_GRIP_HIGH_PRESSURE2 = &H40
Public Const IO_SIGNAL_OUT_GRIP_HYDRAULIC_ON = &H80

Public Const IO_SIGNAL_IN_GRIP_MASK = &H3F
Public Const IO_SIGNAL_OUT_GRIP_MASK = &HFF

Type DoPEIOGrip                         ' Grip IO signal definition
  Mode                     As Integer   ' Mode (0=disabled)              [No]
  BitDevice                As Integer   ' BitIn/BitOut device         [0...9]
  BitNo                    As Integer   ' First bit of block          [0..15]
                                        '
  LimitSensorNo            As Integer   ' Limit sensor number            [No]
  LimitMax                 As Double    ' Limit Max                    [Unit]
  LimitMin                 As Double    ' Limit Max                    [Unit]
                                        '
  FConstEnabled            As Integer   ' Load constant when closing    [0/1]
  CloseSecurityTime        As Double    ' Security time for closing       [s]
  OutGripHydraulicOnTime   As Double    ' Time for OutGripHydraulicOn     [s]
  OutGripHighPressureTime  As Double    ' Time for OutGripHighPressure    [s]
  InGripOpenedTime         As Double    ' Time for InGripOpened           [s]
  InGripClosedTime         As Double    ' Time for InGripClosed           [s]
                                        '
  PressureOutputEnabled    As Integer   ' Pressure output enabled       [0/1]
  OutChaNo                 As Integer   ' Analog output for pressure  [0..15]
  UnUsed1                  As Double    ' Unused
  OutChaLowPressure        As Double    ' Low  Pressure value             [%]
  OutChaHighPressure       As Double    ' High Pressure value             [%]
  OutChaRampTime           As Double    ' Time for low/high pressure ramp [s]
  OutChaFCtrlEnabled       As Integer   ' Load control enabled          [0/1]
  OutChaFCtrlHighPressure  As Double    ' Load at high pressure           [N]
End Type

'----------------------------------------------------------------------------

' Extensometer IO signal definition
Public Const IO_SIGNAL_IN_EXT_UPPER_OPENED = &H1
Public Const IO_SIGNAL_IN_EXT_LOWER_OPENED = &H2
Public Const IO_SIGNAL_IN_EXT_UPPER_CLOSED = &H4
Public Const IO_SIGNAL_IN_EXT_LOWER_CLOSED = &H8

Public Const IO_SIGNAL_OUT_EXT_UPPER_OPEN = &H1
Public Const IO_SIGNAL_OUT_EXT_LOWER_OPEN = &H2
Public Const IO_SIGNAL_OUT_EXT_UPPER_CLOSE = &H4
Public Const IO_SIGNAL_OUT_EXT_LOWER_CLOSE = &H8

Public Const IO_SIGNAL_IN_EXT_MASK = &HF
Public Const IO_SIGNAL_OUT_EXT_MASK = &HF

Type DoPEIOExt                         ' Extensometer IO signal definition
  Mode      As Integer                 ' Mode (0=disabled)              [No]
  BitDevice As Integer                 ' BitIn/BitOut device         [0...9]
  BitNo     As Integer                 ' First bit of block          [0..15]
  IOTime    As Double                  ' Time for BitIn/BitOut control   [s]
End Type

'----------------------------------------------------------------------------

' FixedXHead IO signal definition
Public Const IO_SIGNAL_IN_FIXED_XHEAD_UNLOCKED = &H1

Public Const IO_SIGNAL_OUT_FIXED_XHEAD_UNLOCK = &H1
Public Const IO_SIGNAL_OUT_FIXED_XHEAD_UP = &H2
Public Const IO_SIGNAL_OUT_FIXED_XHEAD_DOWN = &H4

Public Const IO_SIGNAL_IN_FIXED_XHEAD_MASK = &H1
Public Const IO_SIGNAL_OUT_FIXED_XHEAD_MASK = &H7

Type DoPEIOFixedXHead                  ' FixedXHead IO signal definition
  Mode      As Integer                 ' Mode (0=disabled)              [No]
  BitDevice As Integer                 ' BitIn/BitOut device         [0...9]
  BitNo     As Integer                 ' First bit of block          [0..15]
  IOTime    As Double                  ' Time for BitIn/BitOut control   [s]
End Type

'----------------------------------------------------------------------------

' High pressure IO signal definition
Public Const IO_SIGNAL_IN_HIGH_PRESSURE = &H1
Public Const IO_SIGNAL_IN_HIGH_PRESSURE_OK = &H2
Public Const IO_SIGNAL_IN_LOW_PRESSURE = &H4

Public Const IO_SIGNAL_OUT_HIGH_PRESSURE = &H1
Public Const IO_SIGNAL_OUT_HIGH_PRESSURE_OK = &H2
Public Const IO_SIGNAL_OUT_LOW_PRESSURE = &H4
Public Const IO_SIGNAL_OUT_LOW_PRESSURE_OK = &H8

Public Const IO_SIGNAL_IN_HIGH_PRESSURE_MASK = &H7
Public Const IO_SIGNAL_OUT_HIGH_PRESSURE_MASK = &HF

Type DoPEIOHighPressure                ' High pressure IO signal definition
  Mode                  As Integer     ' Mode (0=disabled)              [No]
  BitDevice             As Integer     ' BitIn/BitOut device         [0...9]
  BitNo                 As Integer     ' First bit of block          [0..15]
  IOTime                As Double      ' Time for BitIn/BitOut control   [s]

  PressureOutputEnabled As Integer     ' Pressure output enabled       [0/1]
  OutChaNo              As Integer     ' Analog output for pressure  [0..15]
  OutChaLowPressure     As Double      ' Low  Pressure value             [%]
  OutChaHighPressure    As Double      ' High Pressure value             [%]
  OutChaRampTime        As Double      ' Time for low/high pressure ramp [s]
End Type

'----------------------------------------------------------------------------

' Miscellaneous IO signal definition
Public Const IO_SIGNAL_IN_MISC_TEMPERATURE1 = &H1        ' warning
Public Const IO_SIGNAL_IN_MISC_TEMPERATURE2 = &H2        ' emergency off
Public Const IO_SIGNAL_IN_MISC_OIL_LEVEL = &H4           ' emergency off
Public Const IO_SIGNAL_IN_MISC_OIL_FILTER = &H8          ' warning
Public Const IO_SIGNAL_IN_MISC_POWER_FAIL = &H10         ' emergency off

Public Const IO_SIGNAL_OUT_MISC_CAL = &H1
Public Const IO_SIGNAL_OUT_MISC_NO_SENSOR_LIMIT = &H2

Public Const IO_SIGNAL_IN_MISC_MASK = &H1F
Public Const IO_SIGNAL_OUT_MISC_MASK = &H3

Type DoPEIOMisc                        ' Miscellaneous IO signal definition
  BitInMode    As Integer              ' BitIn  mode   (0=disabled)     [No]
  BitInDevice  As Integer              ' BitIn  device               [0...9]
  BitInNo      As Integer              ' BitIn  number (first of bl.)[0..15]

  BitOutMode   As Integer              ' BitOut mode   (0=disabled)     [No]
  BitOutDevice As Integer              ' BitOut device               [0...9]
  BitOutNo     As Integer              ' BitOut number (first of bl.)[0..15]
End Type

'----------------------------------------------------------------------------

' SHALT IO signal modes
Public Const IO_SHALT_MODE_0_OFF = 0                   ' SHalt IO signal disabled
Public Const IO_SHALT_MODE_1_ENABLED = 1               ' SHalt IO signal enabled (active high)
Public Const IO_SHALT_MODE_2_ENABLED_INVERTED = 2      ' SHalt IO signal enabled (active low )

' SHALT IO signal definition
Public Const IO_SIGNAL_IN_SHALT_UPPER = &H1
Public Const IO_SIGNAL_IN_SHALT_LOWER = &H2

Public Const IO_SIGNAL_IN_SHALT_MASK = &H3
                                          
Type DoPEIOSHalt                       ' SHalt IO signal definition
  Mode      As Integer                 ' Mode (0=disabled)              [No]
  BitDevice As Integer                 ' BitIn/BitOut device         [0...9]
  BitNo     As Integer                 ' First bit of block          [0..15]
End Type

'----------------------------------------------------------------------------

Type DoPEIOSignals                     ' IO signal definition
  Grip         As DoPEIOGrip           ' Grip                IO signal def.
  Ext          As DoPEIOExt            ' Extensometer        IO signal def.
  FixedXHead   As DoPEIOFixedXHead     ' FixedXHead          IO signal def.
  HighPressure As DoPEIOHighPressure   ' High pressure       IO signal def.
  Reserved(27) As Byte                 ' reserved (was DoPEIOKey/DoPEIOTest)
  Misc         As DoPEIOMisc           ' Miscellaneous       IO signal def.
  SHalt        As DoPEIOSHalt          ' SHalt IO signal definition
End Type

'----------------------------------------------------------------------------

Public Const MAX_MAIN_MENU = 40        ' max count of EDC main menu entries

                                                     ' Test numbers of EDC main menu
Public Const TEST_NO_PC_CONTROL = 10000              ' 10000 no licence needed
Public Const TEST_NO_TENSION_COMPRESSION = 10001     ' 10001 no licence needed
Public Const TEST_NO_TEAR = 10002                    ' 10002 no licence needed
Public Const TEST_NO_METAL_TENSION = 10003           ' 10003 no licence needed
Public Const TEST_NO_CONCRETE_PRESSURE = 10004       ' 10004 no licence needed
Public Const TEST_NO_CONCRETE_BENDING = 10005        ' 10005 no licence needed
Public Const TEST_NO_CONCRETE_BRASILIAN = 10006      ' 10006 no licence needed
Public Const TEST_NO_CONCRETE_CIRCEL_BENDING = 10007 ' 10007 no licence needed
Public Const TEST_NO_CYCLES = 10008                  ' 10008    licence needed
Public Const TEST_NO_EXTERNAL_COMMAND = 10009        ' 10009    licence needed
Public Const TEST_NO_CREEP = 10010                   ' 10010    licence needed
Public Const TEST_NO_BLOCK_COMMAND = 10011           ' 10011    licence needed
Public Const TEST_NO_ADJUSTING = 10012               ' 10012 no licence needed
Public Const TEST_NO_CALIBRATION = 10013             ' 10013 no licence needed
Public Const TEST_NO_CLOSED_LOOP_SETUP = 10014       ' 10014 no licence needed
Public Const TEST_NO_DRIVE_SETUP = 10015             ' 10015 no licence needed
Public Const TEST_NO_PROTOCOL_SETUP = 10016          ' 10016 no licence needed
Public Const TEST_NO_USER_SETUP = 10017              ' 10017 no licence needed

Public Const TEST_NO_MAX = 10018

Type DoPEMainMenu                      ' EDC main menu definition
  TestNo  As Long                      ' Test number                    [No]
  Visible As Integer                   ' Main menu entry visible       [0/1]
End Type

'----------------------------------------------------------------------------

Public Const RMCIO_KEY_MAX = 16

Type DoPERmcIOKey                             ' RMCIO key definition
  KeyCode As Long                             ' Key code DoPE_KEY_xxx          [No]
  Device  As Integer                          ' BitIn/BitOut device         [0...9]
  KeyMask As Integer                          ' Bit mask for key               [No]
  LedMask As Integer                          ' Bit mask for LED               [No]
End Type

Type DoPERmcDPoti                             ' RMC DigiPoti definition
  SpeedSlow      As Double                    ' Slow speed                  [Unit/s]
  SpeedFast      As Double                    ' Fast speed                  [Unit/s]
  DPotiSpeedSens As Double                    ' Sensitivity Speed/Openloop [Rev/Nom]
  DPotiPosSens   As Double                    ' Sensitivity Pos           [Unit/Rev]
End Type

Type DoPERmcDef                               ' RMC definition
  PushMode                    As Integer      ' Push mode for Up/Down keys    [0/1]
  RmcDPoti(MAX_CTRL - 1)      As DoPERmcDPoti ' RMC DPoti definition
  RmcIOKey(RMCIO_KEY_MAX - 1) As DoPERmcIOKey ' RMCIO key definition
End Type

'----------------------------------------------------------------------------

Type DoPESetup                                ' EDC Setup Data
  SDef(MAX_MC - 1)        As DoPESenDef       ' Sensor definition data
  CSDef(MAX_CTRL - 1)     As DoPECtrlSenDef   ' Control-Sensor definition data
  CSDefHigh(MAX_CTRL - 1) As DoPECtrlSenDef   ' Control-Sensor def. (high pressure) EDC220+
  ODef(MAX_OC - 1)        As DoPEOutChaDef    ' Analogue output definition data
  BODef(MAX_BOUT - 1)     As DoPEBitOutDef    ' Digital bit output definition data
  BIDef(MAX_BIN - 1)      As DoPEBitInDef     ' Digital bit input definition data
  MDef                    As DoPEMachineDef   ' Machine definition data
  LinTblFalse             As DoPELinTblFalse  ' Linearisation table FALSE values
  LinTblTrue              As DoPELinTblTrue   ' Linearisation table TRUE values
  IOSignals               As DoPEIOSignals    ' IO signal definition                EDC220+
  MainMenu(MAX_MAIN_MENU - 1) As DoPEMainMenu ' EDC main menu definition            EDC220+
  RmcDef                  As DoPERmcDef       ' RMC definition
End Type

'----------------------------------------------------------------------------

Type DoPESumSenInfo                     ' Summary Sensor Information
  Connector         As Integer          ' Connector number of sensor     [No]
  NominalValue      As Double           ' Nominal value of sensor      [Unit]
  Unit              As Integer          ' Unit of sensor UNIT_xxx        [No]
  Offset            As Double           ' Offset of sensor             [Unit]
  UpperLimit        As Double           ' Upper range limit of sensor  [Unit]
  LowerLimit        As Double           ' Lower range limit of sensor  [Unit]
  SensorState       As Integer          ' Sensor state SEN_STATE_xxx     [No]
  McType            As Integer          ' Measuring channel type         [No]
  UpperSoftLimit    As Double           ' Upper soft limit             [Unit]
  LowerSoftLimit    As Double           ' Lower soft limit             [Unit]
  SoftLimitReaction As Integer          ' reaction if soft limit         [No]
  BasicTare         As Double           ' Basic   tare                 [Unit]
  Tare              As Double           ' Tare                         [Unit]
  UserScale         As Double           ' User scale                     [No]
  McIntegr          As Double           ' Measuring channel time of integration   [s]
  CtrlIntegr        As Double           ' Closed loop control time of integration [s]
  HwDelayTime       As Double           ' Hardware delaytime              [s]
  McDelayTime       As Double           ' Measuring channel delaytime     [s]
  McDelayTimeCorr   As Double           ' Delaytime correction            [s]
End Type

'----------------------------------------------------------------------------

                                       ' Sensor classes
                                       ' ----------------------------------
Public Const SEN_UNDEF = 0             ' unknown sensor class
Public Const SEN_ANALOGUE = 1          ' analogue sensor
Public Const SEN_INC = 2               ' incremental sensor
Public Const SEN_ABS = 3               ' abolute value sensor

                                       ' Analogue sensor types
                                       ' ----------------------------------
Public Const SIG_STRAINGAUGE = 0       ' Strain Gauge
Public Const SIG_LVDT = 1              ' LVDT
Public Const SIG_DC = 2                ' DC

                                       ' Incremental sensor types
                                       ' ----------------------------------
Public Const SIG_TTL = 0               ' TTL Signal
Public Const SIG_LINE = 1              ' RS422 (line driver)
Public Const SIG_SINE11uA = 2          ' Sine 11µA
Public Const SIG_SINE1V = 3            ' Sine 1V

                                         ' Absolute value sensor types
                                         ' ----------------------------------
Public Const SIG_ROQ_424 = 1             ' Heidenhain ROQ 424 Sensor
Public Const SIG_MTS_SSI_S2Bx102 = 2     ' MTS SSI S2Bx102 Sensor
Public Const SIG_POSITAL_SL_G_24 = 3     ' POSITAL OCD-SL00G-1212 Sensor
Public Const SIG_POSITAL_SL_G_16 = 4     ' POSITAL OCD-SL00G-0016 Sensor
Public Const SIG_ROQ_425 = 5             ' Heidenhain ROQ 424 Sensor
Public Const SIG_SSI_GENERIC = &H80      ' 'Generic sensor definition' mask
Public Const SIG_SSI_CODE = &H40         ' Code bit 0=binary, 1=gray code
Public Const SIG_SSI_LEN = &H1F          ' 'number of databits' mask
Public Const SIG_SSI_LEN_OFFS = 8        ' Offset for 'number of databits'

                                       ' Transducer types
                                       ' ----------------------------------
Public Const TRANSDUCER_LINEAR = 0     ' Linear transducer
Public Const TRANSDUCER_ROTARY = 1     ' Rotary transducer

                                       ' Reference mark types
                                       ' ----------------------------------
Public Const REFMARK_NON = 0           ' Transducer has no reference mark
Public Const REFMARK_ONE = 1           ' Transducer has one reference mark
Public Const REFMARK_DISTCODE = 2      ' Transducer has distance coded

Public Const SEN_LIN_DATA_MAX = 12     ' Max. numbers of sensor lin. points
                                       ' referenced marks

Type DoPESensorHeaderData              ' Sensor EEPROM header data
  PartNo     As Integer                ' Part ident number              [No]
  Version    As Byte                   ' Part revision                  [No]
  SerNo      As Long                   ' Part serial number             [No]
                                       '
  Class_     As Integer                ' Sensor class                   [No]
  DatVersion As Byte                   ' Version of data                [No]
End Type

Type LinVal                            ' Linearization table
  MeasValue As Double                  ' Measured value               [Unit]
  RefValue  As Double                  ' Reference                    [Unit]
End Type

Type DoPESensorAnalogueData            ' Analogue sensor EEPROM data
  MaxExcitation    As Single           ' Maximum excitation voltage      [V]
  MinImpedance     As Integer          ' Impedance                     [Ohm]
  NominalValue     As Single           ' Nominal value of the sensor  [Unit]
  Unit             As Integer          ' Unit of sensor UNIT_xxx        [No]
  Offset           As Single           ' Sensor offset                [Unit]
  NegLimit         As Integer          ' Range limit - min.              [%]
  PosLimit         As Integer          ' Range limit - max.              [%]
  Reference        As Single           ' Nominal value of the reference  [*]
  CorrReference    As Double           ' Corr. value of the reference   [No]
  Sensortype       As Integer          ' Sensor type
  NominalSensitive As Double           ' Sensitivity at Nominal value    [*]
  Sign             As Integer          ' Invert sign of channel        [1/0]
  Day_             As Long             ' Date of last change            [No]
  Month_           As Long             ' Date of last change            [No]
  Year_            As Long             ' Date of last change            [No]
  LinPoint         As Integer          ' Number of linearization steps  [No]
  LinV(SEN_LIN_DATA_MAX - 1) As LinVal ' Linearization table
End Type
                                       ' [*]: [V]    for DC sensor
                                       '      [mV/V] for DMS and LVDT


Type DoPESensorIncData                 ' Incremental sensor EEPROM data
  Voltage1            As Single        ' Supply voltage 1                [V]
  Voltage2            As Single        ' Supply voltage 2                [V]
  Voltage3            As Single        ' Supply voltage 3                [V]
  Current1            As Single        ' Current for supply voltage 1    [A]
  Current2            As Single        ' Current for supply voltage 2    [A]
  Current3            As Single        ' Current for supply voltage 3    [A]
  InputSignal         As Integer       ' Signal type at input  SIG_xxx  [No]
  OutputSignal        As Integer       ' Signal type at output SIG_xxx  [No]
  InterpolationFactor As Integer       ' Factor for interpolation       [No]
  MaxInputFreq        As Single        ' Maximum input frequency        [Hz]
  MaxOutputFreq       As Single        ' Maximum output frequency       [Hz]
                                       '
  TransducerType      As Integer       ' Transducer type TRANSDUCER_xxx [No]
  Unit                As Integer       ' Unit of sensor UNIT_xxx        [No]
  SignalPeriod        As Double        ' Signal period                [Unit]
  CorrFactor          As Double        ' Correction factor              [No]
  MeasuringRange      As Double        ' Measuring range              [Unit]
  SignalType          As Integer       ' Tancducer sgnal type  SIG_xxx  [No]
  ReferenceMark       As Integer       ' Reference mark type REFMARK_xxx[No]
  FirstDistance       As Double        ' First distance of the reference[Unit]
  NominalDistance     As Double        ' Nominal distance of the reference[Unit]
  Delta               As Double        ' Dislocation of the mean reference[Unit]
  LimitFrequency      As Single        ' Limit frequency of the transducer[Hz]
  Sign                As Integer       ' Invert sign of channel        [1/0]
  NegLimit            As Byte          ' Range limit - min.              [%]
  PosLimit            As Byte          ' Range limit - max.              [%]
End Type


Type DoPESensorAbsData                 ' Absolute value EEPROM header data
  Voltage1       As Single             ' Supply voltage 1                [V]
  Voltage2       As Single             ' Supply voltage 2                [V]
  Voltage3       As Single             ' Supply voltage 3                [V]
  Current1       As Single             ' Current for supply voltage 1    [A]
  Current2       As Single             ' Current for supply voltage 2    [A]
  Current3       As Single             ' Current for supply voltage 3    [A]
  InputSignal    As Integer            ' Signal type at input  SIG_xxx  [No]
  OutputSignal   As Integer            ' Signal type at output SIG_xxx  [No]
  MaxInputFreq   As Single             ' Maximum input frequency        [Hz]
  MaxOutputFreq  As Single             ' Maximum output frequency       [Hz]

  DelayTime      As Byte               ' Sensors signal delay time   [ms/10]
  Unit           As Integer            ' Unit of sensor UNIT_xxx        [No]
  SignalPeriod   As Double             ' Signal period                [Unit]
  Offset         As Single             ' Sensor offset                [Unit]
  CorrFactor     As Double             ' Correction factor              [No]
  NominalValue   As Double             ' Nominal value of the sensor  [Unit]
  SignalType     As Integer            ' Transducer sgnal type  SIG_xxx [No]
                                       ' or SIG_SSI_GENERIC + code + number
                                       ' of data bits
  LimitFrequency As Single             ' Limit frequency of the transducer[Hz]
  Sign           As Integer            ' Invert sign of channel        [1/0]
  NegLimit       As Byte               ' Range limit - min.              [%]
  PosLimit       As Byte               ' Range limit - max.              [%]
  Day_           As Long               ' Date of last change            [No]
  Month_         As Long               ' Date of last change            [No]
  Year_          As Long               ' Date of last change            [No]
End Type

'----------------------------------------------------------------------------

' Error constants
' ---------------
Public Const DoPERR_NOERROR = 0            ' No error
Public Const DoPERR_NOFLOAT = 1            ' No float in WIN16 callback
Public Const DoPERR_SYNC = 2               ' Synchronisation to callback failed
Public Const DoPERR_TIMEOUT = 3            ' Timeout bei await answer
Public Const DoPERR_NOFNC = 4              ' Function not implemented
Public Const DoPERR_VERSION = 5            ' No compatible Version EDC-DoPE
Public Const DoPERR_INIT = 6               ' Initialisation Error Subsystem
Public Const DoPERR_PARAMETER = 7          ' Invalid parameter
Public Const DoPERR_SETUPOPEN = 8          ' Setup open error
Public Const DoPERR_RTE_UNHANDLED = 9      ' Unhandled runtime error

' Command errors
Public Const DoPERR_CMD_PARCORR = 1001     ' Error in parameter (corrected)
Public Const DoPERR_CMD_PAR = 1003         ' Error in parm. not correctable
Public Const DoPERR_CMD_XMOVE = 1004       ' X-Head is not halted
Public Const DoPERR_CMD_INITSEQ = 1005     ' Sequence in init. not observed
Public Const DoPERR_CMD_NOTINIT = 1006     ' Controller part not initialised
Public Const DoPERR_CMD_DIR = 1007         ' Movement direction  not possible
Public Const DoPERR_CMD_TMP = 1008         ' Required resource not available
Public Const DoPERR_CMD_RUNTIME = 1009     ' Run time error active
Public Const DoPERR_CMD_INTERN = 1010      ' Internal error in subsystem
Public Const DoPERR_CMD_MEM = 1011         ' Insufficient memory
Public Const DoPERR_CMD_CST = 1012         ' Wrong controller Structure
Public Const DoPERR_CMD_NIM = 1013         ' Command not implemented
Public Const DoPERR_CMD_MSGNO = 2001       ' Unknown message number
Public Const DoPERR_CMD_VERSION = 2003     ' Wrong PE interface version
Public Const DoPERR_CMD_OPEN = 2004        ' Setup not opened
Public Const DoPERR_CMD_MEMORY = 2005      ' Not enough memory

' Machine normalisation errors
Public Const DoPERR_PARMS = &H4001&        ' Parameter Error
Public Const DoPERR_ZERODIV = &H4002&      ' Division by ZERO
Public Const DoPERR_OVFLOW = &H4003&       ' Overflow
Public Const DoPERR_NIN = &H4004&          ' Not Initialised

'Low level communication errors
Public Const DoPERR_NODATA = &H8001&       ' No receiver data available
Public Const DoPERR_NOBUFFER = &H8002&     ' No transmitter buffer available
Public Const DoPERR_OFFLINE = &H8003&      ' Connection is offline
Public Const DoPERR_HANDLE = &H8004&       ' Invalid DoPE handle
Public Const DoPERR_MSGSIZE = &H8005&      ' Message to long
Public Const DoPERR_COMPARAMETER = &H8006& ' Invalid com.driver parameter
Public Const DoPERR_NOMEM = &H8007&        ' Not enough heap memory
Public Const DoPERR_BADPORT = &H8008&      ' Invalid device ID
Public Const DoPERR_BAUDRATE = &H8009&     ' Invalid baudrate
Public Const DoPERR_OPEN = &H800A&         ' Device already in use/File open error
Public Const DoPERR_HARDWARE = &H800B&     ' Device not present
Public Const DoPERR_NOTOPEN = &H800C&      ' Connection not open
Public Const DoPERR_PORTLIMIT = &H800D&    ' Unused
Public Const DoPERR_NOTIMER = &H800E&      ' No timer for timeout check
Public Const DoPERR_NODRIVER = &H800F&     ' No driver available
Public Const DoPERR_NOTHREAD = &H8010&     ' Win32: Thread creation failed
Public Const DoPERR_BADOS = &H8011&        ' Not supported operating system
Public Const DoPERR_THUNK = &H8012&        ' Win32: Thread creation failed

Public Const DoPERR_INTERNAL = -1&         ' Internal driver error

' Manifest constants for DPX event bits
' -------------------------------------
Public Const DoPEEVT_RXAVAIL = &H1&         ' New message received
Public Const DoPEEVT_DATAVAIL = &H10&       ' New Samples (MW) available
Public Const DoPEEVT_DATAOVERFLOW = &H20&   ' Sample Overflow
Public Const DoPEEVT_ACK = &H40&            ' DoPE command acknowledged
Public Const DoPEEVT_NAK = &H80&            ' DoPE command not acknowledged
Public Const DoPEEVT_RESTART = &H1000&      ' EDC link established
Public Const DoPEEVT_OVERFLOW = &H2000&     ' Receiver Overflow
Public Const DoPEEVT_OFFLINE = &H4000&      ' State transition to OffLine
Public Const DoPEEVT_ONLINE = &H8000&       ' State transition to OnLine
Public Const DoPEEVT_ALL = &HF0F1&          ' All valid event bits

' Constanst for baud rate
' -----------------------
Public Const DoPE_BAUD_9600   As Long = 9600&
Public Const DoPE_BAUD_19200  As Long = 19200&
Public Const DoPE_BAUD_38400  As Long = 38400
Public Const DoPE_BAUD_57600  As Long = 57600
Public Const DoPE_BAUD_115200 As Long = 115200
Public Const DoPE_BAUD_230400 As Long = 230400
Public Const DoPE_BAUD_460800 As Long = 460800

' Constanst for COM state
' -----------------------
Public Const DoPE_STATE_OFF = 0        ' Link is disabled
Public Const DoPE_STATE_OFFLINE = 1    ' Link is offline
Public Const DoPE_STATE_INITCYCLE = 2  ' Link is initializing
Public Const DoPE_STATE_ONLINE = 3     ' Link is established (OnLine)

'/*------------ Complete structure for all messages SUB -> PC -----------------*/

Type DoPEError                         ' Error counters
  Parity   As Long                     ' Parity errors
  Overrun  As Long                     ' Overrun errors
  Frame    As Long                     ' Framing errors
  InvAck   As Long                     ' Invalid ACKs received
  NoBuffer As Long                     ' No receiver buffer available
  DLESeq   As Long                     ' Invalid DLE sequence
  BufOFlow As Long                     ' Receiver buffer overflow
  BccErr   As Long                     ' Checksum error
  MwError  As Long                     ' Invalid sample encoding
End Type

Type DoPEState
  ComState   As Long                   ' Communication state
  RcvBuffer  As Long                   ' Full receiver buffers
  XmitBuffer As Long                   ' Full transmitter buffers
End Type

'/*+---------------------- Default measuring data record ---------------------+*/

Type DoPEData                          ' Data  SUB   =>  Host
  Cycles           As Long             ' Cycle counter
  Pad1             As Long             ' internal fill charcters
  Time             As Double           ' Time from subsystem
  Position         As Double           ' X-Head position
  Load             As Double           ' Load
  Extension        As Double           ' Extension
  Sensor3          As Double           ' Sensor 3  measuring channel
  Sensor4          As Double           ' Sensor 4  measuring channel
  Sensor5          As Double           ' Sensor 5  measuring channel
  Sensor6          As Double           ' Sensor 6  measuring channel
  Sensor7          As Double           ' Sensor 7  measuring channel
  Sensor8          As Double           ' Sensor 8  measuring channel
  Sensor9          As Double           ' Sensor 9  measuring channel
  Sensor10         As Double           ' Sensor 10 measuring channel
  Sensor11         As Double           ' Sensor 11 measuring channel
  Sensor12         As Double           ' Sensor 12 measuring channel
  Sensor13         As Double           ' Sensor 13 measuring channel
  Sensor14         As Double           ' Sensor 14 measuring channel
  Sensor15         As Double           ' Sensor 15 measuring channel
  BitIn0           As Integer          ' Digital input device 0
  BitIn1           As Integer          ' Digital input device 1
  BitIn2           As Integer          ' Digital input device 2
  BitIn3           As Integer          ' Digital input device 3
  BitIn4           As Integer          ' Digital input device 4
  BitIn5           As Integer          ' Digital input device 5
  BitIn6           As Integer          ' Digital input device 6
  BitIn7           As Integer          ' Digital input device 7
  BitIn8           As Integer          ' Digital input device 8
  BitIn9           As Integer          ' Digital input device 9
  BitOut0          As Integer          ' Digital output device 0
  BitOut1          As Integer          ' Digital output device 1
  BitOut2          As Integer          ' Digital output device 2
  BitOut3          As Integer          ' Digital output device 3
  BitOut4          As Integer          ' Digital output device 4
  BitOut5          As Integer          ' Digital output device 5
  BitOut6          As Integer          ' Digital output device 6
  BitOut7          As Integer          ' Digital output device 7
  BitOut8          As Integer          ' Digital output device 8
  BitOut9          As Integer          ' Digital output device 9
  InSignals        As Integer          ' Logical input signals
  OutSignals       As Integer          ' Logical output signals
  CtrlState1       As Integer          ' Controller status word 1
  CtrlState2       As Integer          ' Controller status word 2
  UpperLimits      As Integer          ' Upper limits exceeded
  LowerLimits      As Integer          ' Lower limits exceeded
  SysState0        As Integer          ' System status WORD 0
                   
  ActiveCtrl       As Integer          ' Active control channel
  UpperSft         As Integer          ' Upper soft limit active
  LowerSft         As Integer          ' Lower soft limit active
  SensorConnected  As Integer          ' Sensor plug connected state
  SensorKeyPressed As Integer          ' Sensor plug key state
  Test1            As Double           ' Configured test value 1
  Test2            As Double           ' Configured test value 2
  Test3            As Double           ' Configured test value 3
  Keys             As Integer          ' Actual State of EDC frontpanel keys
  NewKeys          As Integer          ' New keys
  GoneKeys         As Integer          ' Gone keys
  Pad2             As Integer          ' internal fill charcters
End Type

'/***** DoPE API functions *****************************************************/
'
'
'/*------------ Communication port definitions --------------------------------*/
'
Public Const DoPEPORT_COM = &H0          ' COM port start value
                                         ' COMx:Number=x-1(max.COM256)

Public Const DoPEPORT_USB = &H100        ' USB port start value
                                         ' USBx:Number=x-0x100 (USB0..255)

Public Const DoPEPORT_LAN = &H200        ' LAN port start value
                                         ' LANx:Number=x-0x200 (NIC0..254)
                                         ' LAN 255 is used by DoPE internaly!

Public Const DoPE_PORTNAMELEN = 80       ' Max. port name length in bytes
                                         ' (including terminating zero '\0')

Type MAC                                 ' MAC Address
  a(5) As Byte
End Type

Type DoPE_PORTINFO
  Ix       As Long                        ' Device index
  Name     As String * DoPE_PORTNAMELEN   ' Device name
  ComPort  As Long                        ' COM port
  BaudRate As Long                        ' Baudrate (DoPEPORT_COM only)
  NicMac   As MAC                         ' NIC address
End Type

'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBPortInfo Lib "dope.dll" Alias "DoPEPortInfo" (ByVal Port As Long, ByVal First As Long, ByRef pPortInfo As DoPE_PORTINFO) As Long

'  extern  unsigned  DLLAPI  DoPEPortInfo ( unsigned       Port,
'                                           unsigned       First,
'                                           DoPE_PORTINFO *pPortInfo );
'
'    /*
'    Get the port info.
'
'      In :  Port        Port class (DoPEPORT_COM, DoPEPORT_USB or DoPEPORT_LAN)
'            First       != 0: get the first port information
'                        == 0: get the next port information
'            pPortInfo   pointer to port info structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'                        (DoPERR_BADPORT if no more port info is available)
'    */
'
'
Declare Function DoPEVBCurrentPortInfo Lib "dope.dll" Alias "DoPECurrentPortInfo" (ByVal DoPEHdl As Long, ByRef pPortInfo As DoPE_PORTINFO) As Long
'  extern  unsigned  DLLAPI  DoPECurrentPortInfo ( DoPE_HANDLE DoPEHdl,
'                                                  DoPE_PORTINFO *pPortInfo );
'
'    /*
'    Get the current port info of a link.
'
'      In :  DoPEHdl     DoPE link handle
'            pPortInfo   pointer to port info structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBDefineNIC Lib "dope.dll" Alias "DoPEDefineNIC" (ByVal Port As Long, ByRef pMAC As MAC) As Long

'  extern  unsigned  DLLAPI  DoPEDefineNIC ( unsigned Port,  MAC *pMAC );
'
'    /*
'    Assign a NIC to a DoPE port.
'
'      In :  Port        Port number (DoPEPORT_LAN+x)
'            pMAC        Pointer to NIC's MAC address. A NULL pointer removes
'                        the assignment.
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBIgnoreTcpIpNIC Lib "dope.dll" Alias "DoPEIgnoreTcpIpNIC" (ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIgnoreTcpIpNIC ( unsigned Enable );
'
'    /*
'    For faster port scanning NIC's with TCP/IP protocol can be ignored in
'    DpxPortInfo, DpxDefineNIC and DpxOpenLink calls.
'
'      In :  Enable      true:  ignore NIC's with TCP/IP protocol
'                        false: include NIC's with TCP/IP protocol to port scan (Default)
'
'      Returns:          old Enable state
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBOpenLink Lib "dope.dll" Alias "DoPEOpenLink" (ByVal Port&, ByVal PortParam&, ByVal RcvBuffers&, ByVal XmitBuffers&, ByVal DataBuffers&, ByVal APIVersion&, Reserved&, DoPEHdl&) As Long

'  extern  unsigned  DLLAPI  DoPEOpenLink  ( unsigned         Port,
'                                            unsigned         PortParam,
'                                            unsigned         RcvBuffers,
'                                            unsigned         XmitBuffers,
'                                            unsigned         DataBuffers,
'                                            unsigned         APIVersion,
'                                            void        FAR *Reserved,
'                                            DoPE_HANDLE FAR *DoPEHdl );
'
'    /*
'    Open the given DoPE link.
'    The link parameters are set and the link is established.
'    If DoPEOpenLink returns DoPERR_TIMEOUT, connection to the EDC did not
'    go online. You must connect the EDC, switch it on and try DoPEOpenLink
'    again.
'
'      In :  Port        Port number (DoPEPORT_xx)
'            PortParam   Baud rate for serial lines, as supported by Windows
'                        EDC device ID for USB and LAN connections
'            RcvBuffers  Number of requested receiver buffers for messages.
'                        This number messages can be stored inside DoPE until
'                        they are read with DoPEGetMsg function.
'            XmitBuffers Number of requested transmitter buffers for messages
'                        This number of messages can be stored inside DoPE.
'                        They will be transmitted by DoPE to the EDC.
'            DataBuffers Number of requested data buffers.
'                        The measuring data record will be stored inside DoPE
'                        in a circular buffer. If data are not read with
'                        DoPEGetData the oldest record be overwritten!
'            APIVersion  DoPE API version used by the DoPE user
'            *Reserved   Reserved for future use
'            DoPEHdl     Pointer to storage for DoPE link handle
'
'      Out:  *DoPEHdl    DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBOpenDeviceID Lib "dope.dll" Alias "DoPEOpenDeviceID" (ByVal DeviceID As Long, ByVal RcvBuffers As Long, ByVal XmitBuffers As Long, ByVal DataBuffers As Long, ByVal APIVersion As Long, ByRef Reserved As Long, ByRef DoPEHdl As Long) As Long
Declare Function DoPEVBOpenFunctionID Lib "dope.dll" Alias "DoPEOpenFunctionID" (ByVal FunctionID As Long, ByVal RcvBuffers As Long, ByVal XmitBuffers As Long, ByVal DataBuffers As Long, ByVal APIVersion As Long, ByRef Reserved As Long, ByRef DoPEHdl As Long) As Long

'  extern  unsigned  DLLAPI  DoPEOpenDeviceID    ( unsigned     DeviceID,
'                                                  unsigned     RcvBuffers,
'                                                  unsigned     XmitBuffers,
'                                                  unsigned     DataBuffers,
'                                                  unsigned     APIVersion,
'                                                  void        *Reserved,
'                                                  DoPE_HANDLE *DoPEHdl );
'
'  extern  unsigned  DLLAPI  DoPEOpenFunctionID  ( unsigned     FunctionID,
'                                                  unsigned     RcvBuffers,
'                                                  unsigned     XmitBuffers,
'                                                  unsigned     DataBuffers,
'                                                  unsigned     APIVersion,
'                                                  void        *Reserved,
'                                                  DoPE_HANDLE *DoPEHdl );
'
'    /*
'    Open the given DoPE link with a matching device or function ID.
'    All communication ports are scanned, starting with DoPEPORT_USB.
'    LAN ports which have been assigned with DoPEDefineNIC are included to the scan.
'    The link parameters are set and the link is established.
'    If DoPEOpenFunctionID returns DoPERR_TIMEOUT, connection to the EDC did not
'    go online. You must connect the EDC, switch it on and try DoPEOpenFunctionID
'    again.
'    This function is available for USB and LAN connections only.
'
'      In :  Port        Port number (DoPEPORT_xx)
'            FunctionID  EDC function ID
'            RcvBuffers  Number of requested receiver buffers for messages.
'                        This number messages can be stored inside DoPE until
'                        they are read with DoPEGetMsg function.
'            XmitBuffers Number of requested transmitter buffers for messages
'                        This number of messages can be stored inside DoPE.
'                        They will be transmitted by DoPE to the EDC.
'            DataBuffers Number of requested data buffers.
'                        The measuring data record will be stored inside DoPE
'                        in a circular buffer. If data are not read with
'                        DoPEGetData the oldest record be overwritten!
'            APIVersion  DoPE API version used by the DoPE user
'            *Reserved   Reserved for future use
'            DoPEHdl     Pointer to storage for DoPE link handle
'
'      Out:  *DoPEHdl    DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBCloseLink Lib "dope.dll" Alias "DoPECloseLink" (DoPEHdl&) As Long
'  extern  unsigned  DLLAPI  DoPECloseLink  ( DoPE_HANDLE FAR *DoPEHdl );
'
'    /*
'    Close down the given DoPE link.
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'
'      Out:  *DoPEHdl    Invalidated DoPE link handle (set to NULL)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */

Type DoPEOpenLinkInfo
  DoPEHdl    As Long
  PortType   As Long                    ' DoPEPORT_USB or DoPEPORT_LAN
  PortInfo   As DoPE_PORTINFO
  ModuleInfo As DoPEModuleInfo
End Type

Private Const MAX_EDC = 32               ' max connected EDCs (only as example; can also be more)

Type VBOpenLinkInfo
  Edc(MAX_EDC - 1) As DoPEOpenLinkInfo
End Type

Declare Function DoPEVBOpenAll Lib "dope.dll" Alias "DoPEOpenAll" (ByVal RcvBuffers As Long, ByVal XmitBuffers As Long, ByVal DataBuffers As Long, ByVal APIVersion As Long, ByRef Reserved As Long, ByVal InfoTableMaxEntries As Long, ByRef InfoTableValidEntries As Long, ByRef InfoTable As VBOpenLinkInfo) As Long
Declare Function DoPEVBCloseAll Lib "dope.dll" Alias "DoPECloseAll" (ByVal InfoTableValidEntries As Long, ByRef InfoTable As VBOpenLinkInfo) As Long

'  extern  unsigned  DLLAPI  DoPEOpenAll  ( unsigned         RcvBuffers,
'                                           unsigned         XmitBuffers,
'                                           unsigned         DataBuffers,
'                                           unsigned         APIVersion,
'                                           void            *Reserved,
'                                           unsigned         InfoTableMaxEntries,
'                                           unsigned        *InfoTableValidEntries,
'                                           DoPEOpenLinkInfo InfoTable[] );
'
'    /*
'    Open all available DoPE links and fill the open link info table.
'    All communication ports are scanned, starting with DoPEPORT_USB.
'    All LAN ports without installed TCP/IP protocol are included to the scan.
'
'      In :  RcvBuffers             Number of requested receiver buffers for
'                                   messages. This number of messages can be
'                                   stored inside DoPE until they are read with
'                                   DoPEGetMsg function.
'            XmitBuffers            Number of requested transmitter buffers for
'                                   messages. This number of messages can be
'                                   stored inside DoPE. They will be transmitted
'                                   by DoPE to the EDC.
'            DataBuffers            Number of requested data buffers.
'                                   The measuring data record will be stored
'                                   inside DoPE in a circular buffer. If data
'                                   are not read with DoPEGetData the oldest
'                                   record will be overwritten!
'            APIVersion             DoPE API version used by the DoPE user
'           *Reserved               Reserved for future use
'            InfoTableMaxEntries    Number of entries that can be stored to the
'                                   info table.
'           *InfoTableValidEntries  Pointer to storage for the number of valid
'                                   entries in the info table.
'
'      Out :
'           *InfoTableValidEntries  Number of valid entries in the info table.
'            InfoTable              Info table containing valid entries for all
'                                   opened links.
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'  extern  unsigned  DLLAPI  DoPECloseAll  ( unsigned         InfoTableValidEntries,
'                                            DoPEOpenLinkInfo InfoTable[] );
'
'    /*
'    Close all DoPE links previously opened by DoPEOpenAll.
'
'      In :  InfoTableValidEntries  Number of valid entries in the info table.
'            InfoTable              Info table containing valid DoPE handles for
'                                   all links to close
'
'      Out :
'            InfoTable              Info table with all DoPE handles set to NULL
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetIoCompatibilityMode Lib "dope.dll" Alias "DoPESetIoCompatibilityMode" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetIoCompatibilityMode  ( DoPE_HANDLE DoPEHdl,
'                                                          unsigned    Enable );
'    /*
'    Set the compatibility mode for bit input and output channels
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Enable     !=0  enables
'                        0    disables compatibility mode
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBCurrentData Lib "dope.dll" Alias "DoPECurrentData" (ByVal DoPEHdl As Long, ByRef Sample As DoPEData) As Long

'  extern  unsigned  DLLAPI  DoPECurrentData ( DoPE_HANDLE   DoPEHdl,
'                                              DoPEData     *Sample  );
'
'    /*
'    Get current samples from receiver buffer.
'    DoPE receives measuring data in a adjustable time scale. The data record is
'    stored inside DoPE in a circular buffer. You can read the latest data record
'    with this function.
'
'      In :  DP          DoPE link handle
'            Sample      Pointer to storage for data record.
'
'      Out:  *Sample     DoPEData record
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetCycleMode Lib "dope.dll" Alias "DoPESetCycleMode" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPESetCycleMode  ( DoPE_HANDLE  DoPEHdl,
'                                                unsigned     Enable );
'
'    /*
'    Enable/disable unified cycle handling for cyclic movement commands.
'
'      In :  DoPEHdl     DoPE link handle
'            Enable      != 0 enables
'                        == 0 disables unified cycle handling (default)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBGetData Lib "dope.dll" Alias "DoPEGetData" (ByVal DoPEHdl As Long, ByRef Sample As DoPEData) As Long

'  extern  unsigned  DLLAPI  DoPEGetData ( DoPE_HANDLE   DoPEHdl,
'                                          DoPEData     *Sample );
'
'    /*
'    Get samples from receiver buffer.
'    DoPE receives measuring data in a adjustable time scale. The data record is
'    stored inside DoPE in a circular buffer. You can read one data record
'    with this function.
'
'      In :  DoPEHdl     DoPE link handle
'            Sample      Pointer to storage for data record.
'
'      Out:  *Sample     DoPEData record
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBCtrlTestValues Lib "dope.dll" Alias "DoPECtrlTestValues" (ByVal DoPEHdl&, ByVal State%) As Long

' extern  unsigned  DLLAPI  DoPECtrlTestValues  ( DoPE_HANDLE Hdl,
'                                                 WORD        State );
'
'   /*
'   Enable or disable the controller test variables.
'
'     In :  DP          DoPE link handle
'           State       1    enables
'                       0    disables the controller test variables in
'                       the DoPEData record.
'
'     Returns:          Error constant (DoPERR_xxxx)
'   */
'
'
'* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBClearReceiver Lib "dope.dll" Alias "DoPEClearReceiver" (ByVal DoPEHdl&) As Long

'  extern  unsigned  DLLAPI  DoPEClearReceiver  ( DoPE_HANDLE DoPEHdl );
'
'    /*
'    Discard all receiver buffers
'
'      In :  DoPEHdl     DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBClearTransmitter Lib "dope.dll" Alias "DoPEClearTransmitter" (ByVal DoPEHdl&) As Long

'  extern  unsigned  DLLAPI  DoPEClearTransmitter ( DoPE_HANDLE DoPEHdl );
'
'    /*
'    Discard all unsent transmitter buffers
'
'      In :  DoPEHdl     DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBGetState Lib "dopevb.dll" (ByVal DoPEHdl&, State As DoPEState) As Long

'  extern  unsigned  DLLAPI  DoPEGetState ( DoPE_HANDLE      DoPEHdl,
'                                           DoPEState FAR  *Status );
'
'    /*
'    Get state information structure
'
'      In :  DoPEHdl     DoPE link handle
'            Status      Pointer to storage for state information
'
'      Out:  *Status     State information (see DoPEState definition)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBOpenSetup Lib "dope.dll" Alias "DoPEOpenSetup" (ByVal DoPEHdl&, ByVal SetupNo%, lpusTAN%) As Long
Declare Function DoPEVBOpenSetupSync Lib "dope.dll" Alias "DoPEOpenSetupSync" (ByVal DoPEHdl&, ByVal SetupNo%) As Long

'  extern  unsigned  DLLAPI  DoPEOpenSetup ( DoPE_HANDLE     DoPEHdl,
'                                            unsigned short  SetupNo,
'                                            WORD       FAR *lpusTAN );
'
'    /*
'    Open setup 'SetupNo' for read/write operations.
'
'      In :  DP          DoPE link handle
'            SetupNo     Setup No.
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBCloseSetup Lib "dope.dll" Alias "DoPECloseSetup" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBCloseSetupSync Lib "dope.dll" Alias "DoPECloseSetupSync" (ByVal DoPEHdl&) As Long
'  extern  unsigned  DLLAPI  DoPECloseSetup ( DoPE_HANDLE     DoPEHdl,
'                                             WORD       FAR *lpusTAN );
'
'    /*
'    Close setup.
'
'      In :  DP          DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetupScale Lib "dope.dll" Alias "DoPESetupScale" (ByVal DoPEHdl&, ByVal SetupNo%, US#) As Long

'  extern  unsigned  DLLAPI  DoPESetupScale ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  SetupNo,
'                                             UserScale  FAR  US );
'
'    /*
'    Sets the setup user scale.
'
'      In :  DP          DoPE link handle
'            SetupNo     Setup No.
'            US          User scale for all setup sensor data (except DoPESenDef).
'                        The sensor data will be multiplied by the value in US.
'                        e.g. use this to convert the SI unit meter into mm
'                        by setting the userscale to 1000 for the position sensor
'                        Default values 1.0 will be used if US is NULL
'
'      Out :
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBRdSetupAll Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SetupNo%, Setup As DoPESetup, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBRdSetupAllSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SetupNo%, Setup As DoPESetup) As Long

'  extern  unsigned  DLLAPI  DoPERdSetupAll ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  SetupNo,
'                                             DoPESetup FAR  *Setup,
'                                             WORD      FAR *lpusTANFirst,
'                                             WORD      FAR *lpusTANLast );
'
'    /*
'    Read the setup structure
'
'      In :  DP          DoPE link handle
'            SetupNo     Setup No.
'            Setup       Pointer to Setup structure
'
'      Out:  *Setup      Setup information (see DoPESetup definition)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBWrSetupAll Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SetupNo%, Setup As DoPESetup, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBWrSetupAllSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SetupNo%, Setup As DoPESetup) As Long

'  extern  unsigned  DLLAPI  DoPEWrSetupAll ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  SetupNo,
'                                             DoPESetup  FAR *Setup,
'                                             WORD       FAR *lpusTANFirst,
'                                             WORD       FAR *lpusTANLast );
'
'    /*
'    Write the setup structure
'
'      In :  DP          DoPE link handle
'            SetupNo     Setup No.
'            Setup       Pointer to Setup structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBRdSetupNumber Lib "dope.dll" Alias "DoPERdSetupNumber" (ByVal DoPEHdl&, SetupNo%) As Long

'  extern  unsigned  DLLAPI  DoPERdSetupNumber ( DoPE_HANDLE         DoPEHdl,
'                                                unsigned short FAR* SetupNo );
'
'    /*
'    Get the currently selected setup number.
'
'      In :  DP          DoPE link handle
'            SetupNo     Pointer to the Setup No.
'
'      Out:  *SetupNo    Setup No.
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */

Declare Function DoPEVBSelSetup Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SetupNo%, US#, lpusTANFirst%, lpusTANLast%) As Long

'  extern  unsigned  DLLAPI  DoPESelSetup ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  SetupNo,
'                                           UserScale FAR   US,
'                                           WORD      FAR *lpusTANFirst,
'                                           WORD      FAR *lpusTANLast );
'
'    /*
'    Select machine setup
'
'      In :  DoPEHdl     DoPE link handle
'            SetupNo     Setup No. 0 Use actual setup data.
'                                    All setup data and basic tare values are
'                                    not permanently stored in the EDC's EEPROM.
'                        Setup No. 1..4 Read setup data from the EEPROM.
'                                       All setup data and basic tare values are
'                                       permanently stored in the EDC's EEPROM.
'            US          User scale for all measuring channels.
'                        The measured data will be multiplied by the value in US.
'                        e.g. use this to convert the SI unit meter into mm
'                        by setting the userscale to 1000 for the position channel
'                        Default values 1.0 will be used if US is NULL (V2.01)
'
'Out:        lpusTANFirst Tan 's are used to identify initialization errors sent in
'            lpusTANLast   addition to the synchronized return code.
'                         (This will be implemented in future EDC versions.
'                          In Version 2.11 we have synchronized return codes but only
'                          one error code sent on the PE_INITIALIZE command.)

'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBInitialize Lib "dope.dll" Alias "DoPEInitialize" (ByVal DoPEHdl&, lpusTANFirst%, lpusTANLast%) As Long

'  extern  unsigned  DLLAPI  DoPEInitialize ( DoPE_HANDLE DP );
'
'    /*
'    Initialize System with selected setup data.
'    This command must be given after a change of machine setup.
'
'      In :  DoPEHdl     DoPE link handle
'
'Out:        lpusTANFirst Tan 's are used to identify initialization errors sent in
'            lpusTANLast   addition to the synchronized return code.
'                         (This will be implemented in future EDC versions.
'                          In Version 2.11 we have synchronized return codes but only
'                          one error code sent on the PE_INITIALIZE command.)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBInitializeResetXHead Lib "dope.dll" Alias "DoPEInitializeResetXHead" (ByVal DoPEHdl As Long, ByRef lpusTANFirst As Integer, ByRef lpusTANLast As Integer) As Long

'  extern  unsigned  DLLAPI DoPEInitializeResetXHead ( DoPE_HANDLE DP,
'                                                      WORD       *lpusTANFirst,
'                                                      WORD       *lpusTANLast );
'
'
'    /*
'    Initialize System with selected setup data and reset the crosshead position.
'
'      In :  DP            DoPE link handle
'
'      Out:  *lpusTANFirst TAN's are used to identify initialization errors sent in
'            *lpusTANLast  addition to the synchronised return code.
'                         (This will be implemented in future EDC versions.
'                          In Version 2.11 we have synchronised return codes but only
'                          one error code sent on the PE_INITIALIZE command.)
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'/*
'    ReInitialization allows to disconnect an EDC from the PC without closing
'    down the connection (the drive remains on) and recovering the connection
'    to a known state.
'    This might be neccesery to protect a long term test from a PC crash.
'*/
'

Public Const DoPEREINITIALIZEDATA_LEN = 32768

Type DoPEReInitializeData
  Data(DoPEREINITIALIZEDATA_LEN) As Byte  ' ReInitialize data array [No]
End Type

Declare Function DoPEVBReInitializeEnable Lib "dope.dll" Alias "DoPEReInitializeEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef Data As DoPEReInitializeData) As Long

'  #define DoPEREINITIALIEDATA_LEN 0x8000
'  typedef
'    BYTE DoPEReInitializeData [DoPEREINITIALIEDATA_LEN];  /* ReInitialize data array [No]*/
'
'  extern  unsigned  DLLAPI  DoPEReInitializeEnable ( DoPE_HANDLE           DoPEHdl,
'                                                     unsigned              Enable,
'                                                     DoPEReInitializeData *Data );
'
'    /*
'    Enable / disable the ReInitialization mode.
'
'      In :  DoPEHdl       DoPE link handle
'            Enable        != 0: enables the ReInitialization mode
'                          == 0: disables the ReInitialization mode
'            Data          Pointer to the ReInitialization data.
'
'      Out:  *Data         internal state of the connection used to recover the
'                          connetion with DoPEReInitialize.
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'

Declare Function DoPEVBReInitialize Lib "dope.dll" Alias "DoPEReInitialize" (ByVal DoPEHdl As Long, ByRef Data As DoPEReInitializeData) As Long

'  extern  unsigned  DLLAPI  DoPEReInitialize ( DoPE_HANDLE           DoPEHdl,
'                                               DoPEReInitializeData    *Data );
'    /*
'    Recover a connection to a known state without a new initializion that
'    switches off the drive.
'
'      In :  DoPEHdl       DoPE link handle
'            Data          Pointer to the ReInitialization data containing
'                          information to recover a connetion to the state
'                          previously saved with DoPEReInitializeEnable.
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBGetErrors Lib "dopevb.dll" (ByVal DoPEHdl&, xError As DoPEError) As Long

'  extern  unsigned  DLLAPI  DoPEGetErrors  ( DoPE_HANDLE     DoPEHdl,
'                                             DoPEError FAR  *Error  );
'
'    /*
'    Get current error counter values
'
'      In :  DoPEHdl     DoPE link handle
'            Error       Pointer to storage for error counters
'
'      Out:  *Error      Current error counter values (see DoPEError)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBClearErrors Lib "dope.dll" Alias "DoPEClearErrors" (ByVal DoPEHdl As Long) As Long

'  extern  unsigned  DLLAPI  DoPEClearErrors  ( DoPE_HANDLE DoPEHdl );
'
'    /*
'    Clear current error counter values
'
'      In :  DP          DoPE link handle
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* ------------------------------------------------------------------------- */
'/*                     Instructions for Sampling Control                     */
'/* ------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetDataTransmissionRate Lib "dope.dll" Alias "DoPESetDataTransmissionRate" (ByVal DoPEHdl&, ByVal Refresh#, lpusTAN%) As Long
Declare Function DoPEVBSetDataTransmissionRateSync Lib "dope.dll" Alias "DoPESetDataTransmissionRateSync" (ByVal DoPEHdl&, ByVal Refresh#) As Long

'  extern  unsigned  DLLAPI  DoPESetDataTransmissionRate  ( DoPE_HANDLE DP,
'                                                           double      Refresh,
'                                                           WORD       *lpusTAN );
'
'    /*
'    Set time base for data acquisition for all measuring channels.
'    The default refresh time is defined in the setup data.
'
'      In :  DP            DoPE link handle
'            Refresh       Time in s
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetSensorDataTransmissionRate Lib "dope.dll" Alias "DoPESetSensorDataTransmissionRate" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, ByVal Refresh As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetSensorDataTransmissionRateSync Lib "dope.dll" Alias "DoPESetSensorDataTransmissionRateSync" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, ByVal Refresh As Double) As Long
'
'  extern  unsigned  DLLAPI  DoPESetSensorDataTransmissionRateSync ( DoPE_HANDLE DoPEHdl,
'                                                                    WORD        SensorNo,
'                                                                    double      Refresh );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetSensorDataTransmissionRate  ( DoPE_HANDLE DoPEHdl,
'                                                                 WORD        SensorNo,
'                                                                 double      Refresh,
'                                                                 WORD       *lpusTAN );
'
'    /*
'    Set time base for data acquisition for a measuring channel.
'    The default refresh time is defined
'    in the setup data.
'
'      In :  DoPEHdl       DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Refresh       Time in s
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
' Constants for Mode
Public Const SETTIME_MODE_IMMEDIATE = 0     ' set time immediately
Public Const SETTIME_MODE_MOVE_START = 1    ' set time at the start of a movement command
Public Const SETTIME_MODE_FIRST_CYCLE = 2   ' set time at the start of the first cycle

Declare Function DoPEVBSetTime Lib "dope.dll" Alias "DoPESetTime" (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Timer As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetTimeSync Lib "dope.dll" Alias "DoPESetTimeSync" (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Timer As Double) As Long
'  extern  unsigned  DLLAPI  DoPESetTime  ( DoPE_HANDLE DoPEHdl,
'                                           WORD        Mode,
'                                           double      Time,
'                                           WORD   FAR *lpusTAN );
'    /*
'    Set time counter to a desired value.
'
'      In :  DoPEHdl     DoPE link handle
'            Mode        Set time immediate, at start of movement or at first cycle
'            Time        New value for Time in s
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBTransmitData Lib "dope.dll" Alias "DoPETransmitData" (ByVal DoPEHdl&, ByVal Enable%, lpusTAN%) As Long
Declare Function DoPEVBTransmitDataSync Lib "dope.dll" Alias "DoPETransmitDataSync" (ByVal DoPEHdl&, ByVal Enable%) As Long
'  extern  unsigned  DLLAPI  DoPETransmitData  ( DoPE_HANDLE    DoPEHdl,
'                                                unsigned short Enable,
'                                                WORD      FAR *lpusTAN );
'
'    /*
'    Activate / Deactivate transmission of data. If deactivated no measuring data
'    will be transmitted to the PC!
'
'      In :  DoPEHdl     DoPE link handle
'            Enable      1    Activate transmission
'                        0    Deactivate transmission
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetB Lib "dope.dll" Alias "DoPESetB" (ByVal DoPEHdl&, ByVal BitOutputNo%, ByVal SetB%, ByVal ResB%, ByVal FlashB%, lpusTAN%) As Long
Declare Function DoPEVBSetBSync Lib "dope.dll" Alias "DoPESetBSync" (ByVal DoPEHdl&, ByVal BitOutputNo%, ByVal SetB%, ByVal ResB%, ByVal FlashB%) As Long
'  extern  unsigned  DLLAPI  DoPESetB ( DoPE_HANDLE     DoPEHdl,
'                                       unsigned short  BitOutputNo,
'                                       unsigned short  SetB,
'                                       unsigned short  ResB,
'                                       unsigned short  FlashB,
'                                       WORD       FAR *lpusTAN );
'
'    /*
'    Set, Reset, Flash Bits
'      In :  DoPEHdl     DoPE link handle
'            BitOutputNo Number of bit output device
'            SetB        These bits will be set
'            ResB        These bits will be reset
'            FlashB      These bits 'flash'
'
'            The three data WORD's will be processed in the following
'            sequence (important with conflicting data):
'            1.) Flashing bits.          (lowest)
'            2.) Resetting of the bits.
'            3.) Setting of the bits.    (highest)
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'      Restriction:      The current SUBSY version (5.12) supports the flash
'                        function is only for BitOutputNo 0.
'                        Later Versions will support flash on all devices.
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBIntgr Lib "dope.dll" Alias "DoPEIntgr" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Intgr#, lpusTAN%) As Long
Declare Function DoPEVBIntgrSync Lib "dope.dll" Alias "DoPEIntgrSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Intgr#) As Long
'  extern  unsigned  DLLAPI  DoPEIntgr ( DoPE_HANDLE     DoPEHdl,
'                                        unsigned short  SensorNo,
'                                        double          Intgr,
'                                        WORD       FAR *lpusTAN );
'
'    /*
'    Set time of integration for an analogue measuring channel.
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            Intgr       Integration time for analogue measuring channels in sec.
'                        The limits the integration time depend on the selected
'                        timebase for the speed control loop cycle time.
'                        (see machine setup data)
'                        The minimum time is   1 x (timebase for the speed control)
'                        The maximum time is 100 x (timebase for the speed control)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCal Lib "dope.dll" Alias "DoPECal" (ByVal DoPEHdl&, ByVal SensorBits%, lpusTAN%) As Long
Declare Function DoPEVBCalSync Lib "dope.dll" Alias "DoPECalSync" (ByVal DoPEHdl&, ByVal SensorBits%) As Long

'  extern  unsigned  DLLAPI  DoPECal ( DoPE_HANDLE     DoPEHdl,
'                                      unsigned short  SensorBits,
'                                      WORD       FAR *lpusTAN );
'
'    /*
'    Compensate drifts (zero and amplification) of the measuring channel.
'    It takes about 0.5 s to compensate drifts.
'    During compensation the sensor is not measured!!!
'
'      In :  DP          DoPE link handle
'                        SensorBits  Bit 0 .. 15 define the sensor Number to be calibrated.
'                                    Bit 0 = 1 Calibrate Sensor 0
'                                    Bit 1 = 1 Calibrate Sensor 1 ...
'
'    Returns:                Error constant(DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBZeroCal Lib "dope.dll" Alias "DoPEZeroCal" (ByVal DoPEHdl&, ByVal SensorBits%, lpusTAN%) As Long
Declare Function DoPEVBZeroCalSync Lib "dope.dll" Alias "DoPEZeroCalSync" (ByVal DoPEHdl&, ByVal SensorBits%) As Long
'  extern  unsigned  DLLAPI  DoPEZeroCal ( DoPE_HANDLE     DoPEHdl,
'                                          unsigned short  SensorBits,
'                                          WORD       FAR *lpusTAN );
'
'    /*
'    Compensate only zero offset drift.
'    It takes about 0.2 s to compensate zero offset drift.
'    During compensation the sensor is not measured!!!
'
'      In :  DP          DoPE link handle
'                        SensorBits  Bit 0 .. 15 define the sensor Number to be calibrated.
'                                    Bit 0 = 1 Calibrate zero offset of Sensor 0
'                                    Bit 1 = 1 Calibrate zero offset of Sensor 1 ...
'
'    Returns:                Error constant(DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetOutput Lib "dope.dll" Alias "DoPESetOutput" (ByVal DoPEHdl&, ByVal Out%, ByVal Value#, lpusTAN%) As Long
Declare Function DoPEVBSetOutputSync Lib "dope.dll" Alias "DoPESetOutputSync" (ByVal DoPEHdl&, ByVal Out%, ByVal Value#) As Long
'  extern  unsigned  DLLAPI  DoPESetOutput ( DoPE_HANDLE     DoPEHdl,
'                                            unsigned short  Output,
'                                            double          Value,
'                                            WORD       FAR *lpusTAN );
'    /*
'    Set an analogue output channel.
'
'    Normierung des Kanals !!! ???
'
'      In :  DoPEHdl     DoPE link handle
'                        Output      Number of analogue output channel
'                        Value                           New value of output channel
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetOutChannelOffsetSync Lib "dope.dll" Alias "DoPESetOutChannelOffsetSync" (ByVal DoPEHdl&, ByVal Output%, ByVal Offset#) As Long
Declare Function DoPEVBSetOutChannelOffset Lib "dope.dll" Alias "DoPESetOutChannelOffset" (ByVal DoPEHdl&, ByVal Output%, ByVal Offset#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESetOutChannelOffsetSync ( DoPE_HANDLE     DP,
'                                                          unsigned short  Output,
'                                                          double          Offset );
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'
'  extern  unsigned  DLLAPI  DoPESetOutChannelOffset ( DoPE_HANDLE     DP,
'                                                      unsigned short  Output,
'                                                      double          Offset,
'                                                      WORD           *lpusTAN );
'    /*
'    Set an analogue output channel offset.
'
'      In :  DP            DoPE link handle
'                          Output      Number of analogue output channel
'                          Offset      New offset value of output channel
'                                      in % of max. value
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetDitherSync Lib "dope.dll" Alias "DoPESetDitherSync" (ByVal DoPEHdl&, ByVal Output%, ByVal Frequency#, ByVal Amplitude#) As Long

'  extern  unsigned  DLLAPI  DoPESetDitherSync ( DoPE_HANDLE     DP,
'                                                unsigned short  Output,
'                                                double          Frequency,
'                                                double          Amplitude );
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'
Declare Function DoPEVBSetDither Lib "dope.dll" Alias "DoPESetDither" (ByVal DoPEHdl&, ByVal Output%, ByVal Frequency#, ByVal Amplitude#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESetDither ( DoPE_HANDLE     DP,
'                                            unsigned short  Output,
'                                            double          Frequency,
'                                            double          Amplitude,
'                                            WORD       FAR *lpusTAN );
'    /*
'    NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!
'
'    Set an analogue output channel dither.
'
'      In :  DP            DoPE link handle
'            Output        Number of analogue output channel
'            Frequency     Dither frequency
'            Amplitude     Dither aplitude
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetCheck Lib "dope.dll" Alias "DoPESetCheck" (ByVal DoPEHdl&, ByVal CkeckId%, ByVal SensorNo%, ByVal Limit#, ByVal Mode%, ByVal Action%, ByVal Ctrl%, _
                                                                       ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBSetCheckSync Lib "dope.dll" Alias "DoPESetCheckSync" (ByVal DoPEHdl&, ByVal CkeckId%, ByVal SensorNo%, ByVal Limit#, ByVal Mode%, ByVal Action%, ByVal Ctrl%, _
                                                                               ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPESetCheck ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  CheckId,
'                                           unsigned short  SensorNo,
'                                           double          Limit,
'                                           unsigned short  Mode,
'                                           unsigned short  Action,
'                                           unsigned short  Ctrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          Dec,
'                                           double          Destination );
'    /*
'    Activate measuring channel supervision.
'    A measuring channel can be supervised and an action activated if the
'    channel hits the specified limit. Up to 6 channel supervisions may be
'    active at the same time. If one check hits, all supervisions are disabled.
'
'      In :  DoPEHdl     DoPE link handle
'            CheckId     ID of this check, use the CheckId constants
'            SensorNo    Sensor to be supervised
'            Limit       Limit to be supervised
'            Mode        Sensor > Limit or Sensor < Limit
'            Action      This action will be activated if the check hits.
'            Ctrl        Control mode for selected action
'            Acc         Acceleration
'            Speed       maximum speed
'            Dec         Deceleration
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetCheckX Lib "dope.dll" Alias "DoPESetCheckX" (ByVal DoPEHdl&, ByVal CkeckId%, ByVal SensorNo%, ByVal Limit#, ByVal Tare#, ByVal Mode%, ByVal Action%, ByVal Ctrl%, _
                                                                         ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBSetCheckXSync Lib "dope.dll" Alias "DoPESetCheckXSync" (ByVal DoPEHdl&, ByVal CkeckId%, ByVal SensorNo%, ByVal Limit#, ByVal Tare#, ByVal Mode%, ByVal Action%, ByVal Ctrl%, _
                                                                                 ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPESetCheckX ( DoPE_HANDLE     DP,
'                                            unsigned short  CheckId,
'                                            unsigned short  SensorNo,
'                                            double          Limit,
'                                            double          Tare,
'                                            unsigned short  Mode,
'                                            unsigned short  Action,
'                                            unsigned short  Ctrl,
'                                            double          Acc,
'                                            double          Speed,
'                                            double          Dec,
'                                            double          Destination,
'                                            WORD       FAR *lpusTAN );
'    /*
'    Activate measuring channel supervision.
'    A measuring channel can be supervised and an action activated if the
'    channel hits the specified limit. Up to 6 channel supervisions may be
'    active at the same time. If one check hits, all supervisions are disabled.
'
'      In :  DP            DoPE link handle
'            CheckId       ID of this check, use the CheckId constants
'            SensorNo      Sensor to be supervised
'            Limit         Limit to be supervised
'            Tare          Active tare (only for MKCHK_PERCENT_MAX)
'            Mode          Sensor > Limit or Sensor < Limit
'            Action        This action will be activated if the check hits.
'            Ctrl          Control mode for selected action
'            Acc           Acceleration
'            Speed         maximum speed
'            Dec           Deceleration
'            Destination   Final destination
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBClrCheck Lib "dope.dll" Alias "DoPEClrCheck" (ByVal DoPEHdl&, ByVal CkeckId%, lpusTAN%) As Long
Declare Function DoPEVBClrCheckSync Lib "dope.dll" Alias "DoPEClrCheckSync" (ByVal DoPEHdl&, ByVal CkeckId%, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEClrCheck ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  CheckId );
'
'    /*
'    Deactivate a measuring channel supervision
'
'      In :  DoPEHdl     DoPE link handle
'            CheckId     ID of this check, use the CheckId constants
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetCheckLimit Lib "dope.dll" Alias "DoPESetCheckLimit" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal UprLimitSet#, ByVal UprLimitReset#, ByVal LwrLimitReset#, ByVal LwrLimitSet#, lpusTAN%) As Long
Declare Function DoPEVBSetCheckLimitSync Lib "dope.dll" Alias "DoPESetCheckLimitSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal UprLimitSet#, ByVal UprLimitReset#, ByVal LwrLimitReset#, ByVal LwrLimitSet#) As Long
'  extern  unsigned  DLLAPI  DoPESetCheckLimit ( DoPE_HANDLE    DP,
'                                                unsigned short SensorNo,
'                                                double         UprLimitSet,
'                                                double         UprLimitReset,
'                                                double         LwrLimitReset,
'                                                double         LwrLimitSet,
'                                                WORD      FAR *lpusTAN );
'
'    /*
'    Activate measuring channel supervision.
'
'      In :  DP             DoPE link handle
'            SensorNo       Sensor to be supervised
'            UprLimitSet    Upper limit when Grip-IO is activated
'            UprLimitReset  Upper limit when Grip-IO is deactivated
'            LwrLimitReset  Lower Limit when Grip-IO is deactivated
'            LwrLimitSet    Lower Limit when Grip-IO is activated
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBClrCheckLimit Lib "dope.dll" Alias "DoPEClrCheckLimit" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBClrCheckLimitSync Lib "dope.dll" Alias "DoPEClrCheckLimitSync" (ByVal DoPEHdl&) As Long
'  extern  unsigned  DLLAPI  DoPEClrCheckLimit ( DoPE_HANDLE    DP,
'                                                WORD      FAR *lpusTAN );
'
'    /*
'    Deactivate a measuring channel supervision
'
'      In :  DP          DoPE link handle
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'

Declare Function DoPEVBSetCheckLimitIO Lib "dope.dll" Alias "DoPESetCheckLimitIO" (ByVal DoPEHdl As Long, ByVal Value As Integer, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetCheckLimitIOSync Lib "dope.dll" Alias "DoPESetCheckLimitIOSync" (ByVal DoPEHdl As Long, ByVal Value As Integer) As Long

'  extern  unsigned  DLLAPI  DoPESetCheckLimitIOSync ( DoPE_HANDLE DP,
'                                                      WORD        Value );
'
'  extern  unsigned  DLLAPI  DoPESetCheckLimitIO ( DoPE_HANDLE DP,
'                                                  WORD        Value,
'                                                  WORD       *lpusTAN );
'
'    /*
'    Set / reset measuring channel supervision IO
'
'      In :  DP            DoPE link handle
'            Value         0 = reset, 1 = set
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBShieldLimit Lib "dope.dll" Alias "DoPEShieldLimit" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal UprLock#, ByVal UprUnLock#, ByVal LwrUnLock#, ByVal LwrLock#, _
                                                                             ByVal CtrlLimit%, ByVal SpeedLimit#, ByVal CtrlAction%, ByVal Action%, lpusTAN%) As Long
Declare Function DoPEVBShieldLimitSync Lib "dope.dll" Alias "DoPEShieldLimitSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal UprLock#, ByVal UprUnLock#, ByVal LwrUnLock#, ByVal LwrLock#, _
                                                                             ByVal CtrlLimit%, ByVal SpeedLimit#, ByVal CtrlAction%, ByVal Action%, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEShieldLimit ( DoPE_HANDLE    DP,
'                                              unsigned short SensorNo,
'                                              double         UprLock,
'                                              double         UprUnLock,
'                                              double         LwrUnLock,
'                                              double         LwrLock,
'                                              unsigned short CtrlLimit,
'                                              double         SpeedLimit,
'                                              unsigned short CtrlAction,
'                                              unsigned short Action,
'                                              WORD       FAR *lpusTAN );
'
'    /*
'    Activate the shield supervision
'
'      In :  DP          DoPE link handle
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBShieldEnable Lib "dope.dll" Alias "DoPEShieldEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBShieldEnableSync Lib "dope.dll" Alias "DoPEShieldEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEShieldEnableSync ( DoPE_HANDLE    DoPEHdl,
'                                                   unsigned       Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEShieldEnable ( DoPE_HANDLE DoPEHdl,
'                                               unsigned    Enable,
'                                               WORD       *lpusTAN );
'
'    /*
'    Activate / deactivate the shield supervision
'
'      In :  DoPEHdl       DoPE link handle
'            Enable        !=0  enables
'                          0    disables shield supervision
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBShieldDisable Lib "dope.dll" Alias "DoPEShieldDisable" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBShieldDisableSync Lib "dope.dll" Alias "DoPEShieldDisableSync" (ByVal DoPEHdl&) As Long
'  extern  unsigned  DLLAPI  DoPEShieldDisable ( DoPE_HANDLE    DP,
'                                                WORD      FAR *lpusTAN );
'
'    /*
'    Deactivate the shield supervision
'
'      In :  DP          DoPE link handle
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBShieldLock Lib "dope.dll" Alias "DoPEShieldLock" (ByVal DoPEHdl&, ByVal State%, lpusTAN%) As Long
Declare Function DoPEVBShieldLockSync Lib "dope.dll" Alias "DoPEShieldLockSync" (ByVal DoPEHdl&, ByVal State%) As Long
'  extern  unsigned  DLLAPI  DoPEShieldLock ( DoPE_HANDLE    DP,
'                                             WORD           State,
'                                             WORD      FAR *lpusTAN );
'    /*
'    Lock or unlock the shield
'
'      In :  DP          DoPE link handle
'            State       1    lock
'                        0    unlock
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* ------------------------------------------------------------------------- */
'/*                             Movement Commands                             */
'/* --------------------------------------------------------------------------*/
'
'
Declare Function DoPEVBHalt Lib "dope.dll" Alias "DoPEHalt" (ByVal DoPEHdl&, ByVal MoveCtrl%, lpusTAN%) As Long
Declare Function DoPEVBHaltSync Lib "dope.dll" Alias "DoPEHaltSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEHalt ( DoPE_HANDLE     DoPEHdl,
'                                       unsigned short  MoveCtrl );
'
'    /*
'    Halt movement of crosshead in the specified control mode.
'    Default deceleration will be used.
'    After crosshead is halted, message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for halt
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
Declare Function DoPEVBSHalt Lib "dope.dll" Alias "DoPESHalt" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBSHaltSync Lib "dope.dll" Alias "DoPESHaltSync" (ByVal DoPEHdl&, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESHalt ( DoPE_HANDLE     DP,
'                                        WORD       FAR *lpusTAN );
'
'    /*
'    Halt movement of crosshead in position control mode.
'    Instant start of deceleration (command value = measured value).
'    Default deceleration will be used.
'    After crosshead is halted, message will be transmitted.
'
'      In :  DP          DoPE link handle
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBHalt_A Lib "dope.dll" Alias "DoPEHalt_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Dec#, lpusTAN%) As Long
Declare Function DoPEVBHalt_ASync Lib "dope.dll" Alias "DoPEHalt_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Dec#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEHalt_A ( DoPE_HANDLE     DoPEHdl,
'                                         unsigned short  MoveCtrl,
'                                         double          Dec );
'
'    /*
'    Halt movement of crosshead in the specified control mode.
'    Deceleration is a parameter of the command.
'    After crosshead is halted, message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for halt
'            Dec         Deceleration
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBHaltW Lib "dope.dll" Alias "DoPEHaltW" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Delay#, lpusTAN%) As Long
Declare Function DoPEVBHaltWSync Lib "dope.dll" Alias "DoPEHaltWSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Delay#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEHaltW    ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Delay );
'
'    /*
'    Halt movement of crosshead in the specified control mode.
'    Default deceleration will be used.
'    After crosshead is halted and the specified delay time is over,
'    a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for halt
'            Delay       Delay time
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBHaltW_A Lib "dope.dll" Alias "DoPEHaltW_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Dec#, ByVal Delay#, lpusTAN%) As Long
Declare Function DoPEVBHaltW_ASync Lib "dope.dll" Alias "DoPEHaltW_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Dec#, ByVal Delay#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEHaltW_A  ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Dec,
'                                           double          Delay );
'
'    /*
'    Halt movement of crosshead in the specified control mode.
'    Deceleration is a parameter of the command.
'    After crosshead is halted and the specified delay time is over,
'    a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for halt
'            Dec         Deceleration
'            Delay       Delay time
'
'
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBFMove Lib "dope.dll" Alias "DoPEFMove" (ByVal DoPEHdl&, ByVal Direction%, ByVal MoveCtrl%, ByVal Speed#, lpusTAN%) As Long
Declare Function DoPEVBFMoveSync Lib "dope.dll" Alias "DoPEFMoveSync" (ByVal DoPEHdl&, ByVal Direction%, ByVal MoveCtrl%, ByVal Speed#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEFMove ( DoPE_HANDLE     DoPEHdl,
'                                        unsigned short  Direction,
'                                        unsigned short  MoveCtrl,
'                                        double          Speed );
'
'    /*
'    Move crosshead in the specified control mode and speed UP or DOWN.
'    Default acceleration will be used.
'    As an implicit limit of this command, softend's are used.
'
'      In :  DoPEHdl     DoPE link handle
'            Direction   Direction of movement
'            MoveCtrl    Control mode of movement
'            Speed       Speed for movement
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBFMove_A Lib "dope.dll" Alias "DoPEFMove_A" (ByVal DoPEHdl&, ByVal Direction%, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, lpusTAN%) As Long
Declare Function DoPEVBFMove_ASync Lib "dope.dll" Alias "DoPEFMove_ASync" (ByVal DoPEHdl&, ByVal Direction%, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, lpusTAN%) As Long
'
'  extern  unsigned  DLLAPI  DoPEFMove_ASync ( DoPE_HANDLE    DP,
'                                              unsigned short Direction,
'                                              unsigned short MoveCtrl,
'                                              double         Acc,
'                                              double         Speed,
'                                              WORD          *lpusTAN );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEFMove_A ( DoPE_HANDLE    DP,
'                                          unsigned short Direction,
'                                          unsigned short MoveCtrl,
'                                          double         Acc,
'                                          double         Speed,
'                                          WORD          *lpusTAN );
'
'    /*
'    Move crosshead in the specified control mode and speed UP or DOWN.
'    Acceleration is a parameter of the command.
'    As an implicit limit of this command, softend's are used.
'
'      In :  DP            DoPE link handle
'            Direction     Direction of movement
'            MoveCtrl      Control mode of movement
'            Speed         Speed for movement
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/* --------------------------------------------------------------------------*/
'
Declare Function DoPEVBPos Lib "dope.dll" Alias "DoPEPos" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosSync Lib "dope.dll" Alias "DoPEPosSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPos ( DoPE_HANDLE     DoPEHdl,
'                                      unsigned short  MoveCtrl,
'                                      double          Speed,
'                                      double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Default acceleration and deceleration will be used.
'    After destination has been reached, a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Speed       Speed for positioning
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPos_A Lib "dope.dll" Alias "DoPEPos_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPos_ASync Lib "dope.dll" Alias "DoPEPos_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPos_A ( DoPE_HANDLE     DoPEHdl,
'                                        unsigned short  MoveCtrl,
'                                        double          Acc,
'                                        double          Speed,
'                                        double          Dec,
'                                        double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Acceleration and deceleration are parameters of the command.
'    After destination has been reached, a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Acc         Acceleration
'            Speed       Speed for positioning
'            Dec         Deceleration
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosExtSync Lib "dope.dll" Alias "DoPEPosExtSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal LimitMode%, ByVal Limit#, ByVal DestinationCtrl%, ByVal Destination#, ByVal DestinationMode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosExtSync    ( DoPE_HANDLE     DP,
'                                                unsigned short  MoveCtrl,
'                                                double          Speed,
'                                                unsigned short  LimitMode,
'                                                double          Limit,
'                                                unsigned short  DestinationCtrl,
'                                                double          Destination,
'                                                unsigned short  DestinationMode,
'                                                WORD       FAR *lpusTAN );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
Declare Function DoPEVBPosExt Lib "dope.dll" Alias "DoPEPosExt" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal LimitMode%, ByVal Limit#, ByVal DestinationCtrl%, ByVal Destination#, ByVal DestinationMode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosExt    ( DoPE_HANDLE     DP,
'                                            unsigned short  MoveCtrl,
'                                            double          Speed,
'                                            unsigned short  LimitMode,
'                                            double          Limit,
'                                            unsigned short  DestinationCtrl,
'                                            double          Destination,
'                                            unsigned short  DestinationMode,
'                                            WORD       FAR *lpusTAN );
'
'    /*
'    NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!
'
'    Use instead of : DoPEPosG1, DoPEPosG2, DoPEPosD1, DoPEPosD2 !!
'
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Default acceleration and deceleration will be used.
'    After destination or the limit position has been reached,
'    a message will be transmitted.
'
'
'      In :  DP              DoPE link handle
'            MoveCtrl        Control mode for positioning
'            Speed           Speed for positioning
'            LimitMode       Limit is a relative or absolute position
'            Limit           Limit position
'            DestinationCtrl Channel definition for destination
'            Destination     Final destination
'            DestinationMode Mode at destination
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosExt_ASync Lib "dope.dll" Alias "DoPEPosExt_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal LimitMode%, ByVal Limit#, ByVal DestinationCtrl%, ByVal DecDestination#, ByVal Destination#, ByVal DestinationMode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosExt_ASync    ( DoPE_HANDLE     DP,
'                                                  unsigned short  MoveCtrl,
'                                                  double          Acc,
'                                                  double          Speed,
'                                                  double          DecLimit,
'                                                  unsigned short  LimitMode,
'                                                  double          Limit,
'                                                  unsigned short  DestinationCtrl,
'                                                  double          DecDestination,
'                                                  double          Destination,
'                                                  unsigned short  DestinationMode,
'                                                  WORD       FAR *lpusTAN );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
Declare Function DoPEVBPosExt_A Lib "dope.dll" Alias "DoPEPosExt_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal LimitMode%, ByVal Limit#, ByVal DestinationCtrl%, ByVal DecDestination#, ByVal Destination#, ByVal DestinationMode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosExt_A    ( DoPE_HANDLE     DP,
'                                              unsigned short  MoveCtrl,
'                                              double          Acc,
'                                              double          Speed,
'                                              double          DecLimit,
'                                              unsigned short  LimitMode,
'                                              double          Limit,
'                                              unsigned short  DestinationCtrl,
'                                              double          DecDestination,
'                                              double          Destination,
'                                              unsigned short  DestinationMode,
'                                              WORD       FAR *lpusTAN );
'
'    /*
'    NOT AVAILABLE for EDC 5 / 25 and EDC 100  !!
'
'    Use instead of : DoPEPosG1, DoPEPosG2, DoPEPosD1, DoPEPosD2 !!
'
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Acceleration and deceleration are parameters of the command.
'    After destination or the limit position has been reached,
'    a message will be transmitted.
'
'
'      In :  DP              DoPE link handle
'            MoveCtrl        Control mode for positioning
'            Acc             Acceleration
'            Speed           Speed for positioning
'            DecLimit        Deceleration for limit position
'            LimitMode       Limit is a relative or absolute position
'            Limit           absolute limit position
'            DestinationCtrl Channel definition for destination
'            DecDestination  Deceleration for final destination
'            Destination     Final destination
'            DestinationMode Mode at destination
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBTrig Lib "dope.dll" Alias "DoPETrig" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal TriggerCtrl%, ByVal Trigger#, lpusTAN%) As Long
Declare Function DoPEVBTrigSync Lib "dope.dll" Alias "DoPETrigSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal TriggerCtrl%, ByVal Trigger#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPETrig     ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Speed,
'                                           double          Limit,
'                                           unsigned short  TriggerCtrl,
'                                           double          Trigger );
'
'    /*
'    Move crosshead with the specified speed to the limit position.
'    Acceleration and deceleration are parameters of the command.
'    If the the trigger position is reached a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for moving
'            Speed       Speed for moving
'            Limit       Absolute limit position for movement
'            TriggerCtrl Sensor number of trigger channel
'            Trigger     Position
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBTrig_A Lib "dope.dll" Alias "DoPETrig_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Limit#, ByVal TriggerCtrl%, ByVal Trigger#, lpusTAN%) As Long
Declare Function DoPEVBTrig_ASync Lib "dope.dll" Alias "DoPETrig_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal Dec#, ByVal Limit#, ByVal TriggerCtrl%, ByVal Trigger#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPETrig_A   ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          Dec,
'                                           double          Limit,
'                                           unsigned short  TriggerCtrl,
'                                           double          Trigger );
'
'    /*
'    Move crosshead with the specified speed to the limit position.
'    Default acceleration and deceleration will be used.
'    If the the trigger position is reached a message will be transmitted.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for moving
'            Acc         Acceleration
'            Speed       Speed for moving
'            Dec         Deceleration
'            Limit       Absolute limit position for movement
'            TriggerCtrl Sensor number of trigger channel
'            Trigger     Position
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBXpCont Lib "dope.dll" Alias "DoPEXpCont" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Limit#, lpusTAN%) As Long
Declare Function DoPEVBXpContSync Lib "dope.dll" Alias "DoPEXpContSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Limit#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEXpCont   ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Limit );
'
'    /*
'    Change control mode and continue movement in the new control mode
'    with the actual speed.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            Limit       Limit position for movement
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBStartCMD Lib "dope.dll" Alias "DoPEStartCMD" (ByVal DoPEHdl&, ByVal Cycles&, ByVal ModeFlags%, lpusTAN%) As Long
Declare Function DoPEVBStartCMDSync Lib "dope.dll" Alias "DoPEStartCMDSync" (ByVal DoPEHdl&, ByVal Cycles&, ByVal ModeFlags%) As Long
'  extern  unsigned  DLLAPI  DoPEStartCMD ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned long   Cycles,
'                                           unsigned short  ModeFlags );
'
'    /*
'    Start of a combined movement command. Up to 10 simple moving commands
'    may be sent after this command to specify a complex moving sequence.
'
'      In :  DoPEHdl     DoPE link handle
'            Cycles      Repeat combined moving command this number of cycles
'            ModeFlags   Flags (see definition)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBEndCMD Lib "dope.dll" Alias "DoPEEndCMD" (ByVal DoPEHdl&, ByVal Operation%, lpusTAN%) As Long
Declare Function DoPEVBEndCMDSync Lib "dope.dll" Alias "DoPEEndCMDSync" (ByVal DoPEHdl&, ByVal Operation%) As Long
'  extern  unsigned  DLLAPI  DoPEEndCMD   ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  Operation );
'
'    /*
'    End of combined moving command. With this command the first moving
'    command inside this sequence will be started.
'
'      In :  DoPEHdl     DoPE link handle
'            Operation   Start or discard the sequence
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBExt2Ctrl Lib "dope.dll" Alias "DoPEExt2Ctrl" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal OffsetCtrl#, ByVal SensorNo%, ByVal OffsetSensor#, ByVal Mode%, ByVal Scal#, lpusTAN%) As Long
Declare Function DoPEVBExt2CtrlSync Lib "dope.dll" Alias "DoPEExt2CtrlSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal OffsetCtrl#, ByVal SensorNo%, ByVal OffsetSensor#, ByVal Mode%, ByVal Scal#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEExt2Ctrl ( DoPE_HANDLE    DoPEHdl,
'                                          unsigned short  MoveCtrl,
'                                          double          OffsetCtrl,
'                                          unsigned short  SensorNo,
'                                          double          OffsetSensor,
'                                          unsigned short  Mode,
'                                          double          Scale);
'    /*
'    Move crosshead according to an external command signal.
'    This command works not properly when DoPEConfPeekValue or one of the
'    DoPEConfCMc commands are used.
'
'      In :  DoPEHdl      DoPE link handle
'            MoveCtrl     Control mode for positioning
'            OffsetCtrl   Offset for move control channel
'            SensorNo     Sensor number for the external command signal
'            OffsetSensor Offset for external command signal
'            Mode         various position or speed control modes
'            Scale        Scaling factor for external command signal
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBFDPoti Lib "dope.dll" Alias "DoPEFDPoti" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal MaxSpeed#, ByVal SensorNo%, ByVal DxTrigger%, ByVal Mode%, ByVal Scal#, lpusTAN%) As Long
Declare Function DoPEVBFDPotiSync Lib "dope.dll" Alias "DoPEFDPotiSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal MaxSpeed#, ByVal SensorNo%, ByVal DxTrigger%, ByVal Mode%, ByVal Scal#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEFDPoti ( DoPE_HANDLE     DoPEHdl,
'                                         unsigned short  MoveCtrl,
'                                         double          MaxSpeed,
'                                         unsigned short  SensorNo,
'                                         unsigned short  DxTrigger,
'                                         unsigned short  Mode,
'                                         double          Scale );
'    /*
'    Move crosshead according to an external command signal generated by
'    a digital encoder (DigiPoti).
'    This is a special version of the DoPEExt2Ctrl command.
'    Offsets and limits are handled inside this function.
'    This command works not properly when DoPEConfPeekValue or one of the
'    DoPEConfCMc commands are used.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            MaxSpeed    Speed offset for speed controlled modes
'            SensorNo    Sensor Number for the external command input.
'                        Use SENSOR_DP for Digital Encoder (DigiPoti)
'                        on EDC frontpanel.
'            DxTrigger   Dead area of encoder. The Encoder has to change
'                        the specified number of digits before the command
'                        is active.
'                        For EDC frontpanel DigiPoti 2 or 3 is a good value.
'            Mode        various position or speed control modes
'            Scale       For EXT_POSITION Number of Units per revolution
'                        eg. Scale =  1 -> 1 mm per revolution,
'                            Scale = 10 -> 10 N per revolution
'                        For EXT_SPEED_xx Number of revolutions to nominal speed
'                        eg. Scale = 2  -> after 2 revolutions to nominal speed
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCycle Lib "dope.dll" Alias "DoPECycle" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Halt1#, ByVal Speed2#, ByVal Dest2#, ByVal Halt2#, ByVal Cycles&, ByVal Speed#, ByVal Dest#, lpusTAN%) As Long
Declare Function DoPEVBCycleSync Lib "dope.dll" Alias "DoPECycleSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Halt1#, ByVal Speed2#, ByVal Dest2#, ByVal Halt2#, ByVal Cycles&, ByVal Speed#, ByVal Dest#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPECycle ( DoPE_HANDLE     DoPEHdl,
'                                        unsigned short  MoveCtrl,
'                                        double          Speed1,
'                                        double          Dest1,
'                                        double          Halt1,
'                                        double          Speed2,
'                                        double          Dest2,
'                                        double          Halt2,
'                                        unsigned long   Cycles,
'                                        double          Speed,
'                                        double          Destination );
'
'    /*
'    General cycle movement.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            Speed1      Maximum speed to reach destination 1
'            Dest1       Destination 1
'            Halt1       Halt time at destination 1
'            Speed2      Maximum speed to reach destination 2
'            Dest2       Destination 2
'            Halt2       Halt time at destination 2
'            Cycles      Number of cycles
'            Speed       Speed to final destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCosine Lib "dope.dll" Alias "DoPECosine" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBCosineSync Lib "dope.dll" Alias "DoPECosineSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPECosine  ( DoPE_HANDLE     DoPEHdl,
'                                          unsigned short  MoveCtrl,
'                                          double          Speed1,
'                                          double          Dest1,
'                                          double          Dest2,
'                                          double          Frequency,
'                                          unsigned long   HalfCycles,
'                                          double          Speed,
'                                          double          Destination );
'    /*
'    Cosine movement.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            Speed1      Maximum speed to reach destination 1
'            Dest1       Destination 1
'            Dest2       Destination 2
'            Frequency   Frequency
'            HalfCycles  Number of half cycles
'            Speed       Speed to final destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCosineX Lib "dope.dll" Alias "DoPECosineX" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Halt1#, ByVal Dest2#, ByVal Halt2#, _
                                                                     ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBCosineXSync Lib "dope.dll" Alias "DoPECosineXSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Halt1#, ByVal Dest2#, ByVal Halt2#, _
                                                                     ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPECosineX ( DoPE_HANDLE     DP,
'                                          unsigned short  MoveCtrl,
'                                          double          Speed1,
'                                          double          Dest1,
'                                          double          Halt1,
'                                          double          Dest2,
'                                          double          Halt2,
'                                          double          Frequency,
'                                          unsigned long   HalfCycles,
'                                          double          Speed,
'                                          double          Destination,
'                                          WORD       FAR *lpusTAN );
'    /*
'    Cosine movement with halt time at Destination 1 and 2
'
'      In :  DP          DoPE link handle
'            MoveCtrl    Control mode for movement
'            Speed1      Maximum speed to reach destination 1
'            Dest1       Destination 1
'            Halt1       Halt time at destination 1
'            Dest2       Destination 2
'            Halt2       Halt time at destination 2
'            Frequency   Frequency
'            HalfCycles  Number of half cycles
'            Speed       Speed to final destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCosinePeakCtrl Lib "dope.dll" Alias "DoPECosinePeakCtrl" (ByVal DoPEHdl&, ByVal Mode%, ByVal Dest1#, ByVal Dest2#, ByVal Cycles%, lpusTAN%) As Long
Declare Function DoPEVBCosinePeakCtrlSync Lib "dope.dll" Alias "DoPECosinePeakCtrlSync" (ByVal DoPEHdl&, ByVal Mode%, ByVal Dest1#, ByVal Dest2#, ByVal Cycles%) As Long
'  extern  unsigned  DLLAPI  DoPECosinePeakCtrl ( DoPE_HANDLE    DP,
'                                                 unsigned short Mode,
'                                                 double         Dest1,
'                                                 double         Dest2,
'                                                 unsigned short Cycles,
'                                                 WORD          *lpusTAN );
'    /*
'    Activate pilot control for Cosine Command
'
'      In :  DP          DoPE link handle
'            Mode        Mode for pilot control (see definition of constants)
'            Dest1       Destination 1
'            Dest2       Destination 2
'            Cycles      pilot control is active every xx Cycles
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBTriangle Lib "dope.dll" Alias "DoPETriangle" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBTriangleSync Lib "dope.dll" Alias "DoPETriangleSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPETriangle ( DoPE_HANDLE    DoPEHdl,
'                                          unsigned short  MoveCtrl,
'                                          double          Speed1,
'                                          double          Dest1,
'                                          double          Dest2,
'                                          double          Frequency,
'                                          unsigned long   HalfCycles,
'                                          double          Speed,
'                                          double          Destination );
'
'    /*
'    Triangular movement.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            Speed1      Maximum speed to reach destination 1
'            Dest1       Destination 1
'            Dest2       Destination 2
'            Frequency   Frequency
'            HalfCycles  Number of half cycles
'            Speed       Speed to final destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRectangle Lib "dope.dll" Alias "DoPERectangle" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBRectangleSync Lib "dope.dll" Alias "DoPERectangleSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed1#, ByVal Dest1#, ByVal Dest2#, ByVal Frequency#, ByVal HalfCycles&, ByVal Speed#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPERectangle ( DoPE_HANDLE   DoPEHdl,
'                                          unsigned short  MoveCtrl,
'                                          double          Speed1,
'                                          double          Dest1,
'                                          double          Dest2,
'                                          double          Frequency,
'                                          unsigned long   HalfCycles,
'                                          double          Speed,
'                                          double          Destination );
'
'
'    /*
'    Rectangular movement.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for movement
'            Speed1      Maximum speed to reach destination 1
'            Dest1       Destination 1
'            Dest2       Destination 2
'            Frequency   Frequency
'            HalfCycles  Number of half cycles
'            Speed       Speed to final destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/

Public Const DYN_WAVEFORM_COSINE = 0
Public Const DYN_WAVEFORM_TRIANGLE = 1
Public Const DYN_WAVEFORM_RECTANGLE = 2
Public Const DYN_WAVEFORM_SAW_TOOTH = 3
Public Const DYN_WAVEFORM_SAW_TOOTH_INV = 4
Public Const DYN_WAVEFORM_PULSE = 5


' No sweep active
Public Const DYN_SWEEP_OFF = 0

' Linear sweep from e.g Frequency to SweepEndFrequency
Public Const DYN_SWEEP_LINEAR = 1

' Logarithmic sweep from e.g Frequency to SweepEndFrequency
Public Const DYN_SWEEP_LOGARITHMIC = 2

' Linear sweep at Start, and End of cycles
Public Const DYN_SWEEP_LINEAR_START_END = 3

' Logarithmic sweep at Start, and End of cycles
Public Const DYN_SWEEP_LOGARITHMIC_START_END = 4

' No superposition active
Public Const DYN_SUPERPOS_OFF = 0

' Superposition active
Public Const DYN_SUPERPOS_ON = 1


' No bimodal control active
Public Const DYN_BIMODAL_CTRL_OFF = 0

' Keep arithmetic mean value of second sensor constant by changing the offset of the controlled sensor
Public Const DYN_BIMODAL_ARITHMETIC_MEAN_VALUE = 1

' Keep the mean value of second sensor constant by changing the offset of the controlled sensor
Public Const DYN_BIMODAL_MEAN_VALUE = 2

' Keep the minimum value of second sensor constant by changing the offset of the controlled sensor
Public Const DYN_BIMODAL_MIN_VALUE = 3

' Keep the maximum value of second sensor constant by changing the offset of the controlled sensor
Public Const DYN_BIMODAL_MAX_VALUE = 4

' Keep the amplitude of second sensor constant by changing the offset and amplitude of the controlled sensor
Public Const DYN_BIMODAL_AMPLITUDE_OFFSET_VAR = 5

' Keep the amplitude of second sensor constant by changing the amplitude of the controlled sensor.
' The offset of the controlled sensor is constant
Public Const DYN_BIMODAL_AMPLITUDE_OFFSET_CONST = 6

Declare Function DoPEVBDynCycles Lib "dope.dll" Alias "DoPEDynCycles" ( _
        ByVal DoPEHdl As Long, ByVal WaveForm As Integer, ByVal Modify As Integer, ByVal PeakCtrl As Integer, ByVal MoveCtrl As Integer, _
        ByVal RelativeDestination As Integer, ByVal SpeedToStart As Double, ByVal Offset As Double, ByVal Amplitude As Double, ByVal HaltAtPlusAmplitude As Double, _
        ByVal HaltAtMinusAmplitude As Double, ByVal Frequency As Double, ByVal HalfCycles As Long, ByVal SpeedToDestination As Double, ByVal Destination As Double, _
        ByVal SweepFrequencyMode As Integer, ByVal SweepEndFrequency As Double, ByVal SweepFrequencyTime As Double, ByVal SweepFrequencyCount As Long, _
        ByVal SweepOffsetMode As Integer, ByVal SweepEndOffset As Double, ByVal SweepOffsetTime As Double, ByVal SweepOffsetCount As Long, _
        ByVal SweepAmplitudeMode As Integer, ByVal SweepEndAmplitude As Double, ByVal SweepAmplitudeTime As Double, ByVal SweepAmplitudeCount As Long, _
        ByVal SuperpositionMode As Integer, ByVal SuperpositionFrequency As Double, ByVal SuperpositionAmplitude As Double, _
        ByVal BimodalCtrlMode As Integer, ByVal BimodalCtrlSensor As Integer, ByVal BimodalValue1 As Double, ByVal BimodalValue2 As Double, ByVal BimodalScale As Double, _
        ByRef lpusTAN As Integer) As Long

Declare Function DoPEVBDynCyclesSync Lib "dope.dll" Alias "DoPEDynCyclesSync" ( _
        ByVal DoPEHdl As Long, ByVal WaveForm As Integer, ByVal Modify As Integer, ByVal PeakCtrl As Integer, ByVal MoveCtrl As Integer, _
        ByVal RelativeDestination As Integer, ByVal SpeedToStart As Double, ByVal Offset As Double, ByVal Amplitude As Double, ByVal HaltAtPlusAmplitude As Double, _
        ByVal HaltAtMinusAmplitude As Double, ByVal Frequency As Double, ByVal HalfCycles As Long, ByVal SpeedToDestination As Double, ByVal Destination As Double, _
        ByVal SweepFrequencyMode As Integer, ByVal SweepEndFrequency As Double, ByVal SweepFrequencyTime As Double, ByVal SweepFrequencyCount As Long, _
        ByVal SweepOffsetMode As Integer, ByVal SweepEndOffset As Double, ByVal SweepOffsetTime As Double, ByVal SweepOffsetCount As Long, _
        ByVal SweepAmplitudeMode As Integer, ByVal SweepEndAmplitude As Double, ByVal SweepAmplitudeTime As Double, ByVal SweepAmplitudeCount As Long, _
        ByVal SuperpositionMode As Integer, ByVal SuperpositionFrequency As Double, ByVal SuperpositionAmplitude As Double, _
        ByVal BimodalCtrlMode As Integer, ByVal BimodalCtrlSensor As Integer, ByVal BimodalValue1 As Double, ByVal BimodalValue2 As Double, ByVal BimodalScale As Double, _
        ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEDynCyclesSync ( DoPE_HANDLE    DoPEHdl,
'                                                unsigned short WaveForm,
'                                                unsigned short Modify,
'                                                unsigned short PeakCtrl,
'                                                unsigned short MoveCtrl,
'                                                unsigned short RelativeDestination,
'                                                double         SpeedToStart,
'                                                double         Offset,
'                                                double         Amplitude,
'                                                double         HaltAtPlusAmplitude,
'                                                double         HaltAtMinusAmplitude,
'                                                double         Frequency,
'                                                unsigned long  HalfCycles,
'                                                double         SpeedToDestination,
'                                                double         Destination,
'                                                unsigned short SweepFrequencyMode,
'                                                double         SweepEndFrequency,
'                                                double         SweepFrequencyTime,
'                                                unsigned long  SweepFrequencyCount,
'                                                unsigned short SweepOffsetMode,
'                                                double         SweepEndOffset,
'                                                double         SweepOffsetTime,
'                                                unsigned long  SweepOffsetCount,
'                                                unsigned short SweepAmplitudeMode,
'                                                double         SweepEndAmplitude,
'                                                double         SweepAmplitudeTime,
'                                                unsigned long  SweepAmplitudeCount,
'                                                unsigned short SuperpositionMode,
'                                                double         SuperpositionFrequency,
'                                                double         SuperpositionAmplitude,
'                                                unsigned short BimodalCtrlMode,
'                                                unsigned short BimodalCtrlSensor,
'                                                double         BimodalValue1,
'                                                double         BimodalValue2,
'                                                double         BimodalScale,
'                                                unsigned short *lpusTAN );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEDynCycles ( DoPE_HANDLE    DoPEHdl,
'                                            unsigned short WaveForm,
'                                            unsigned short Modify,
'                                            unsigned short PeakCtrl,
'                                            unsigned short MoveCtrl,
'                                            unsigned short RelativeDestination,
'                                            double         SpeedToStart,
'                                            double         Offset,
'                                            double         Amplitude,
'                                            double         HaltAtPlusAmplitude,
'                                            double         HaltAtMinusAmplitude,
'                                            double         Frequency,
'                                            unsigned long  HalfCycles,
'                                            double         SpeedToDestination,
'                                            double         Destination,
'                                            unsigned short SweepFrequencyMode,
'                                            double         SweepEndFrequency,
'                                            double         SweepFrequencyTime,
'                                            unsigned long  SweepFrequencyCount,
'                                            unsigned short SweepOffsetMode,
'                                            double         SweepEndOffset,
'                                            double         SweepOffsetTime,
'                                            unsigned long  SweepOffsetCount,
'                                            unsigned short SweepAmplitudeMode,
'                                            double         SweepEndAmplitude,
'                                            double         SweepAmplitudeTime,
'                                            unsigned long  SweepAmplitudeCount,
'                                            unsigned short SuperpositionMode,
'                                            double         SuperpositionFrequency,
'                                            double         SuperpositionAmplitude,
'                                            unsigned short BimodalCtrlMode,
'                                            unsigned short BimodalCtrlSensor,
'                                            double         BimodalValue1,
'                                            double         BimodalValue2,
'                                            double         BimodalScale,
'                                            unsigned short *lpusTAN );
'
'    /*
'    Dynamic cycles.
'
'      In :  DP                      DoPE link handle
'            WaveForm                DYN_WAVEFORM_xxx (Cosine, Triangular,…)
'            Modify                  Modify Parameter of active cycles
'            PeakCtrl                Peak control cycles 0, 1,2,4,8,16
'
'            MoveCtrl                Control mode for movement
'            RelativeDestination     false, Offset, and Destination absolute
'                                    true, Offset, and Destination relative
'            SpeedToStart            Speed to Offset + Amplitude
'            Offset                  Offset
'            Amplitude               Amplitude
'            HaltAtPlusAmplitude     Halt Time at Offset + Amplitude
'            HaltAtMinusAmplitude    Halt Time at Offset - Amplitude
'            Frequency               Frequency
'            HalfCycles              Number of half cycles
'            SpeedToDestination      Speed to final destination (0=automatic speed calculation)
'            Destination             Final destination
'
'            SweepFrequencyMode      DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
'            SweepEndFrequency       End frequency for frequency sweep
'            SweepFrequencyTime      Time for frequency sweep
'            SweepFrequencyCount     Frequency sweep counter (0=infinitive)
'
'            SweepOffsetMode         DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
'            SweepEndOffset          Second offset for offset sweep
'            SweepOffsetTime         Time for offset sweep
'            SweepOffsetCount        Offset sweep counter (0=infinitive)
'
'            SweepAmplitudeMode      DYN_SWEEP_xxx (Off, Linear, Logarithmic,…)
'            SweepEndAmplitude       Second amplitude for amplitude sweep
'            SweepAmplitudeTime      Time for amplitude sweep
'            SweepAmplitudeCount     Amplitude sweep counter (0=infinitive)
'
'            SuperpositionMode       Superposition Mode (DYN_SUPERPOS_ON, DYN_SUPERPOS_OFF)
'            SuperpositionFrequency  Superposition Frequency
'            SuperpositionAmplitude  Superposition Amplitude
'
'            BimodalCtrlMode         Mode for bimodal control
'            BimodalCtrlSensor       Sensor for bimodal control
'            BimodalValue1           Value1 to keep constant
'            BimodalValue2           Value2 only used for DYN_BIMODAL_AMPLITUDE_OFFSET_VAR
'            BimodalScale            Scale
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSpeedLimit Lib "dope.dll" Alias "DoPESpeedLimit" (ByVal DoPEHdl&, ByVal Ctrl%, ByVal Speed#, lpusTAN%) As Long
Declare Function DoPEVBSpeedLimitSync Lib "dope.dll" Alias "DoPESpeedLimitSync" (ByVal DoPEHdl&, ByVal Ctrl%, ByVal Speed#) As Long
'  extern  unsigned  DLLAPI  DoPESpeedLimit ( DoPE_HANDLE    DP,
'                                             unsigned short Ctrl,
'                                             double         Speed,
'                                             WORD      FAR *lpusTAN );
'
'    /*
'    Set speed limit.
'
'      In :  DP          DoPE link handle
'            Ctrl        Control mode
'            Speed       Maximum speed
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBOffsC Lib "dope.dll" Alias "DoPEOffsC" (ByVal DoPEHdl&, ByVal Speed#, ByVal PosDiff#, lpusTAN%) As Long
Declare Function DoPEVBOffsCSync Lib "dope.dll" Alias "DoPEOffsCSync" (ByVal DoPEHdl&, ByVal Speed#, ByVal PosDiff#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEOffsK ( DoPE_HANDLE     DoPEHdl,
'                                        double          Speed,
'                                        double          PosDiff );
'
'    /*
'    Special moving command to measure the offset of an external, analogue
'    speed controller. This offset will be used for the speed output signal
'    and compensates the offset of the external speed controller.
'
'      In :  DoPEHdl     DoPE link handle
'            Speed       Maximum speed
'            PosDiff     Distance to move crosshead
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBDefaultAcc Lib "dope.dll" Alias "DoPEDefaultAcc" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, lpusTAN%) As Long
Declare Function DoPEVBDefaultAccSync Lib "dope.dll" Alias "DoPEDefaultAccSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#) As Long
'  extern  unsigned  DLLAPI  DoPEDefaultAcc ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  MoveCtrl,
'                                             double          Acc );
'
'    /*
'    Set default acceleration (and deceleration) for all moving commands.
'    After initialization default and nominal acceleration are identical.
'
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode
'            Acc         Acceleration
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetCtrl Lib "dope.dll" Alias "DoPESetCtrl" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetCtrlSync Lib "dope.dll" Alias "DoPESetCtrlSync" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
'  extern  unsigned  DLLAPI  DoPESetCtrl ( DoPE_HANDLE DP,
'                                          unsigned    Enable,
'                                          WORD       *lpusTAN );
'
'    /*
'    Enable / disable closed loop control
'
'      In :  DP            DoPE link handle
'            Enable        !=0  enables
'                          0    disables closed loop control
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBEmergencyMove Lib "dope.dll" Alias "DoPEEmergencyMove" (ByVal DoPEHdl&, ByVal State%, lpusTAN%) As Long
Declare Function DoPEVBEmergencyMoveSync Lib "dope.dll" Alias "DoPEEmergencyMoveSync" (ByVal DoPEHdl&, ByVal State%) As Long
'  extern  unsigned  DLLAPI  DoPEEmergencyMove ( DoPE_HANDLE     DoPEHdl,
'                                                unsigned short  State );
'
'    /*
'    Activate / deactivate emergency movement.
'    Emergency movement is used to move crosshead if the hardware limit
'    switch is active. (Not supported on EDC5/25)
'
'
'      In :  DoPEHdl     DoPE link handle
'            State       1    on
'                        0    off
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBEmergencyOff Lib "dope.dll" Alias "DoPEEmergencyOff" (ByVal DoPEHdl&, ByVal State%, lpusTAN%) As Long
Declare Function DoPEVBEmergencyOffSync Lib "dope.dll" Alias "DoPEEmergencyOffSync" (ByVal DoPEHdl&, ByVal State%) As Long

'  extern  unsigned  DLLAPI  DoPEEmergencyOff  ( DoPE_HANDLE     DoPEHdl,
'                                                unsigned short  State );
'
'
'    /*
'    Activate / deactivate EmergencyOff state.
'
'      In :  DoPEHdl     DoPE link handle
'            State       1    Activate emergency off
'                        0    Deactivate emergency off
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'/*                           Controller Parameters                           */
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosPIDSync Lib "dope.dll" Alias "DoPEPosPIDSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal PosP&, ByVal PosI%, ByVal PosD%) As Long
Declare Function DoPEVBPosPID Lib "dope.dll" Alias "DoPEPosPID" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal PosP&, ByVal PosI%, ByVal PosD%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosPIDSync ( DoPE_HANDLE    DP,
'                                             unsigned short MoveCtrl,
'                                             unsigned long  PosP,
'                                             unsigned short PosI,
'                                             unsigned short PosD );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEPosPID ( DoPE_HANDLE    DP,
'                                         unsigned short MoveCtrl,
'                                         unsigned long  PosP,
'                                         unsigned short PosI,
'                                         unsigned short PosD,
'                                         WORD          *lpusTAN );
'    /*
'    Set parameter for closed loop position controller.
'
'      In :  DP            DoPE link handle
'            MoveCtrl      Control mode
'            PosP          gain      (kv-Factor)
'            PosI          Integration time constant
'            PosD          Time constant
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdPosPID Lib "dope.dll" Alias "DoPERdPosPID" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByRef PosP As Long, ByRef PosI As Integer, ByRef PosD As Integer) As Long

'  extern  unsigned  DLLAPI  DoPERdPosPID ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           unsigned        HighPressure,
'                                           unsigned long  *PosP,
'                                           unsigned short *PosI,
'                                           unsigned short *PosD );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Get parameter for closed loop position controller.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  get parameter for high pressure
'                          0    get parameter for low pressure
'            PosP          Pointer for gain      (kv-Factor)
'            PosI          Pointer for Integration time constant
'            PosD          Pointer for Time constant
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'

Declare Function DoPEVBWrPosPIDSync Lib "dope.dll" Alias "DoPEWrPosPIDSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal PosP As Long, ByVal PosI As Integer, ByVal PosD As Integer) As Long
Declare Function DoPEVBWrPosPID Lib "dope.dll" Alias "DoPEWrPosPID" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal PosP As Long, ByVal PosI As Integer, ByVal PosD As Integer, ByRef lpusTAN As Integer) As Long

'/*---------------------------------------------------------------------------*/
'
'  extern  unsigned  DLLAPI  DoPEWrPosPIDSync ( DoPE_HANDLE    DoPEHdl,
'                                               unsigned short MoveCtrl,
'                                               unsigned       HighPressure,
'                                               unsigned long  PosP,
'                                               unsigned short PosI,
'                                               unsigned short PosD );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrPosPID ( DoPE_HANDLE    DoPEHdl,
'                                           unsigned short MoveCtrl,
'                                           unsigned       HighPressure,
'                                           unsigned long  PosP,
'                                           unsigned short PosI,
'                                           unsigned short PosD,
'                                           WORD          *lpusTAN );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Set parameter for closed loop position controller.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  set parameter for high pressure
'                          0    set parameter for low pressure
'            PosP          gain      (kv-Factor)
'            PosI          Integration time constant
'            PosD          Time constant
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSpeedPIDSync Lib "dope.dll" Alias "DoPESpeedPIDSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal SpeedP&, ByVal SpeedI%, ByVal SpeedD%) As Long
Declare Function DoPEVBSpeedPID Lib "dope.dll" Alias "DoPESpeedPID" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal SpeedP&, ByVal SpeedI%, ByVal SpeedD%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESpeedPIDSync ( DoPE_HANDLE    DP,
'                                               unsigned short MoveCtrl,
'                                               unsigned long  SpeedP,
'                                               unsigned short SpeedI,
'                                               unsigned short SpeedD );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESpeedPID ( DoPE_HANDLE    DP,
'                                           unsigned short MoveCtrl,
'                                           unsigned long  SpeedP,
'                                           unsigned short SpeedI,
'                                           unsigned short SpeedD,
'                                           WORD          *lpusTAN );
'    /*
'    Set parameter for closed loop speed controller.
'
'      In :  DP            DoPE link handle
'            MoveCtrl      Control mode
'            SpeedP        gain      (kv-Factor)
'            SpeedI        Integration time constant
'            SpeedD        Time constant
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSpeedPID Lib "dope.dll" Alias "DoPERdSpeedPID" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByRef SpeedP As Long, ByRef SpeedI As Integer, ByRef SpeedD As Integer) As Long

'  extern  unsigned  DLLAPI  DoPERdSpeedPID ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  MoveCtrl,
'                                             unsigned        HighPressure,
'                                             unsigned long  *SpeedP,
'                                             unsigned short *SpeedI,
'                                             unsigned short *SpeedD );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Get parameter for closed loop speed controller.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  get parameter for high pressure
'                          0    get parameter for low pressure
'            SpeedP        Pointer for gain      (kv-Factor)
'            SpeedI        Pointer for Integration time constant
'            SpeedD        Pointer for Time constant
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSpeedPIDSync Lib "dope.dll" Alias "DoPEWrSpeedPIDSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal SpeedP As Long, ByVal SpeedI As Integer, ByVal SpeedD As Integer) As Long
Declare Function DoPEVBWrSpeedPID Lib "dope.dll" Alias "DoPEWrSpeedPID" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal SpeedP As Long, ByVal SpeedI As Integer, ByVal SpeedD As Integer, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEWrSpeedPIDSync ( DoPE_HANDLE    DoPEHdl,
'                                                 unsigned short MoveCtrl,
'                                                 unsigned       HighPressure,
'                                                 unsigned long  SpeedP,
'                                                 unsigned short SpeedI,
'                                                 unsigned short SpeedD );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrSpeedPID ( DoPE_HANDLE     DoPEHdl,
'                                             unsigned short  MoveCtrl,
'                                             unsigned        HighPressure,
'                                             unsigned long   SpeedP,
'                                             unsigned short  SpeedI,
'                                             unsigned short  SpeedD,
'                                             WORD           *lpusTAN );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Set parameter for closed loop speed controller.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  set parameter for high pressure
'                          0    set parameter for low pressure
'            SpeedP        gain      (kv-Factor)
'            SpeedI        Integration time constant
'            SpeedD        Time constant
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBCurrentPIDSync Lib "dope.dll" Alias "DoPECurrentPIDSync" (ByVal DoPEHdl&, ByVal Output%, ByVal P&, ByVal i%, ByVal D%) As Long
Declare Function DoPEVBCurrentPID Lib "dope.dll" Alias "DoPECurrentPID" (ByVal DoPEHdl&, ByVal Output%, ByVal P&, ByVal i%, ByVal D%, lpusTAN%) As Long
'
'  extern  unsigned  DLLAPI  DoPECurrentPIDSync ( DoPE_HANDLE    Hdl,
'                                                 unsigned short Output,
'                                                 unsigned long  P,
'                                                 unsigned short I,
'                                                 unsigned short D );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPECurrentPID ( DoPE_HANDLE     Hdl,
'                                             unsigned short  Output,
'                                             unsigned long   P,
'                                             unsigned short  I,
'                                             unsigned short  D,
'                                             unsigned short *lpusTAN );
'    /*
'    Set parameter for the external current closed loop controller.
'
'      In :  DP            DoPE link handle
'            Output        Number of the output channel (COMMAND_OUT, OUT_1,...)
'            PosP          gain      (kv-Factor)
'            PosI          Integration time constant
'            PosD          Time constant
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosFeedForwardSync Lib "dope.dll" Alias "DoPEPosFeedForwardSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal PosFFP&) As Long
Declare Function DoPEVBPosFeedForward Lib "dope.dll" Alias "DoPEPosFeedForward" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal PosFFP&, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEPosFeedForwardSync ( DoPE_HANDLE    DP,
'                                                     unsigned short MoveCtrl,
'                                                     unsigned long  PosFFP );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEPosFeedForward ( DoPE_HANDLE    DP,
'                                                 unsigned short MoveCtrl,
'                                                 unsigned long  PosFFP,
'                                                 WORD          *lpusTAN );
'    /*
'    Set parameter for Positiongenerator derivate part.
'
'      In :  DP            DoPE link handle
'            MoveCtrl      Control mode
'            PosFFP             gain for derivate part
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBFeedForward Lib "dope.dll" Alias "DoPEFeedForward" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal SpeedFFP As Integer, ByVal PosDelay As Integer, ByVal AccFFP As Integer, ByVal SpeedDelay As Integer, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBFeedForwardSync Lib "dope.dll" Alias "DoPEFeedForwardSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal SpeedFFP As Integer, ByVal PosDelay As Integer, ByVal AccFFP As Integer, ByVal SpeedDelay As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEFeedForwardSync ( DoPE_HANDLE Hdl,
'                                                  WORD        MoveCtrl,
'                                                  WORD        SpeedFFP,
'                                                  WORD        PosDelay,
'                                                  WORD        AccFFP,
'                                                  WORD        SpeedDelay );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEFeedForward ( DoPE_HANDLE Hdl,
'                                              WORD        MoveCtrl,
'                                              WORD        SpeedFFP,
'                                              WORD        PosDelay,
'                                              WORD        AccFFP,
'                                              WORD        SpeedDelay,
'                                              WORD       *lpusTAN );
'    /*
'    Set feed forward parameter.
'
'      In :  DP            DoPE link handle
'            MoveCtrl      Control mode
'            SpeedFFP      FeedForward for Speed in %
'            PosDelay      Delay for Position command
'            AccFFP        FeedForward for Acc in %
'            SpeedDelay    Delay for Speed command
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdFeedForward Lib "dope.dll" Alias "DoPERdFeedForward" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByRef SpeedFFP As Integer, ByRef PosDelay As Integer, ByRef AccFFP As Integer, ByRef SpeedDelay As Integer) As Long

'  extern  unsigned  DLLAPI  DoPERdFeedForward ( DoPE_HANDLE     DoPEHdl,
'                                                unsigned short  MoveCtrl,
'                                                unsigned        HighPressure,
'                                                unsigned short *SpeedFFP,
'                                                unsigned short *PosDelay,
'                                                unsigned short *AccFFP,
'                                                unsigned short *SpeedDelay );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Get feed forward parameter.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  get parameter for high pressure
'                          0    get parameter for low pressure
'            SpeedFFP      Pointer for FeedForward for Speed in %
'            PosDelay      Pointer for Delay for Position command
'            AccFFP        Pointer for FeedForward for Acc in %
'            SpeedDelay    Pointer for Delay for Speed command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrFeedForwardSync Lib "dope.dll" Alias "DoPEWrFeedForwardSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal SpeedFFP As Integer, ByVal PosDelay As Integer, ByVal AccFFP As Integer, ByVal SpeedDelay As Integer) As Long
Declare Function DoPEVBWrFeedForward Lib "dope.dll" Alias "DoPEWrFeedForward" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal HighPressure As Long, ByVal SpeedFFP As Integer, ByVal PosDelay As Integer, ByVal AccFFP As Integer, ByVal SpeedDelay As Integer, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEWrFeedForwardSync ( DoPE_HANDLE    DoPEHdl,
'                                                    unsigned short MoveCtrl,
'                                                    unsigned       HighPressure,
'                                                    unsigned short SpeedFFP,
'                                                    unsigned short PosDelay,
'                                                    unsigned short AccFFP,
'                                                    unsigned short SpeedDelay );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrFeedForward ( DoPE_HANDLE     DoPEHdl,
'                                                unsigned short  MoveCtrl,
'                                                unsigned        HighPressure,
'                                                unsigned short  SpeedFFP,
'                                                unsigned short  PosDelay,
'                                                unsigned short  AccFFP,
'                                                unsigned short  SpeedDelay,
'                                                unsigned short *lpusTAN );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.71 (or higher)  !!
'
'    Set feed forward parameter.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            HighPressure  !=0  set parameter for high pressure
'                          0    set parameter for low pressure
'            SpeedFFP      FeedForward for Speed in %
'            PosDelay      Delay for Position command
'            AccFFP        FeedForward for Acc in %
'            SpeedDelay    Delay for Speed command
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/

Public Const OPTIMIZE_COSINE = 0
Public Const OPTIMIZE_TRIANGLE = 1
Public Const OPTIMIZE_RECTANGLE = 2

Declare Function DoPEVBOptimizeFeedForward Lib "dope.dll" Alias "DoPEOptimizeFeedForward" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Mode As Integer, ByVal Offset As Double, ByVal Amplitude As Double, ByVal Frequency As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBOptimizeFeedForwardSync Lib "dope.dll" Alias "DoPEOptimizeFeedForwardSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Mode As Integer, ByVal Offset As Double, ByVal Amplitude As Double, ByVal Frequency As Double, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEOptimizeFeedForwardSync ( DoPE_HANDLE    DP,
'                                                          unsigned short MoveCtrl,
'                                                          unsigned short Mode,
'                                                          double         Offset,
'                                                          double         Amplitude,
'                                                          double         Frequency,
'                                                          WORD          *lpusTAN );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEOptimizeFeedForward ( DoPE_HANDLE    DP,
'                                                      unsigned short MoveCtrl,
'                                                      unsigned short Mode,
'                                                      double         Offset,
'                                                      double         Amplitude,
'                                                      double         Frequency,
'                                                      WORD          *lpusTAN );
'    /*
'    Optimize feed forward parameter.
'
'      In :  DP            DoPE link handle
'            MoveCtrl      Control mode
'            Mode          Cosine, triangle, rectangle (see OPTIMIZE_ defines)
'            Amplitude     Amplitude
'            Frequency     Frequency
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBDestWnd Lib "dope.dll" Alias "DoPEDestWnd" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal WndSize#, ByVal WndTime#, lpusTAN%) As Long
Declare Function DoPEVBDestWndSync Lib "dope.dll" Alias "DoPEDestWndSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal WndSize#, ByVal WndTime#) As Long
'  extern  unsigned  DLLAPI  DoPEDestWnd ( DoPE_HANDLE     DoPEHdl,
'                                          unsigned short  MoveCtrl,
'                                          double          WndSize,
'                                          double          WndTime );
'
'    /*
'    Definitions for destination window.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode
'            WndSize     Size of destination window
'            WndTime     Time for destination window
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSft Lib "dope.dll" Alias "DoPESft" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal UpperSft#, ByVal LowerSft#, ByVal Reaction%, lpusTAN%) As Long
Declare Function DoPEVBSftSync Lib "dope.dll" Alias "DoPESftSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal UpperSft#, ByVal LowerSft#, ByVal Reaction%) As Long
'  extern  unsigned  DLLAPI  DoPESft ( DoPE_HANDLE     DoPEHdl,
'                                      unsigned short  MoveCtrl,
'                                      double          UpperSft,
'                                      double          LowerSft,
'                                      unsigned short  Reaction );
'
'    /*
'    Definitions of limits supervised by software (softend)
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode
'            UpperSft    Upper soft limit
'            LowerSft    Lower soft limit
'            Reaction    Action to be activated after softend is reached
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCtrlError Lib "dope.dll" Alias "DoPECtrlError" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal MaxError#, ByVal Reaction%, lpusTAN%) As Long
Declare Function DoPEVBCtrlErrorSync Lib "dope.dll" Alias "DoPECtrlErrorSync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal MaxError#, ByVal Reaction%) As Long
'  extern  unsigned  DLLAPI  DoPECtrlError ( DoPE_HANDLE     DoPEHdl,
'                                            unsigned short  MoveCtrl,
'                                            double          Error,
'                                            unsigned short  Reaction );
'
'    /*
'    Define maximum error signal for closed loop controller
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode
'            Error       Maximum error signal
'            Reaction    Action to be activated after error is reached
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCtrlSpeedTimeBase Lib "dope.dll" Alias "DoPECtrlSpeedTimeBase" (ByVal DoPEHdl&, ByVal Time#, lpusTAN%) As Long
Declare Function DoPEVBCtrlSpeedTimeBaseSync Lib "dope.dll" Alias "DoPECtrlSpeedTimeBaseSync" (ByVal DoPEHdl&, ByVal Time#) As Long
'  extern  unsigned  DLLAPI  DoPECtrlSpeedTimeBase ( DoPE_HANDLE     DP,
'                                                    double          Time,
'                                                    WORD       FAR *lpusTAN );
'
'    /*
'    Define Time Base for Speeddetection inside Close Loop Controller
'
'      In :  DP          DoPE link handle
'            Time        Timebase in s
'
'      Returns:          Error constant(DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBDeadbandCtrl Lib "dope.dll" Alias "DoPEDeadbandCtrl" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Deadband As Double, ByVal PercentP As Integer, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBDeadbandCtrlSync Lib "dope.dll" Alias "DoPEDeadbandCtrlSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Deadband As Double, ByVal PercentP As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEDeadbandCtrlSync ( DoPE_HANDLE    DoPEHdl,
'                                                   unsigned short MoveCtrl,
'                                                   double         Deadband,
'                                                   unsigned short PercentP );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEDeadbandCtrl ( DoPE_HANDLE     DoPEHdl,
'                                               unsigned short  MoveCtrl,
'                                               double          Deadband,
'                                               unsigned short  PercentP,
'                                               unsigned short *lpusTAN );
'
'    /*
'    FUNCTION REQUIRES PE-Interface Version 2.79 (or higher)  !!
'
'    Set parameter for error deadband controller.
'    PosP is reduced by a ramp from PosP(100%) to PercentP.
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            Deadband      Width of error deadband around setpoint
'            PercentP      Smallest P inside deadband in % of PosP
'                          PercentP range is 0..100%
'                          (100% disables error deadband controller)
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetNominalAccSpeed Lib "dope.dll" Alias "DoPESetNominalAccSpeed" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Acc As Double, ByVal Speed As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSetNominalAccSpeedSync Lib "dope.dll" Alias "DoPESetNominalAccSpeedSync" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByVal Acc As Double, ByVal Speed As Double) As Long

'  extern  unsigned  DLLAPI  DoPESetNominalAccSpeedSync ( DoPE_HANDLE    DoPEHdl,
'                                                         unsigned short MoveCtrl,
'                                                         double         Acc,
'                                                         double         Speed );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetNominalAccSpeed ( DoPE_HANDLE    DoPEHdl,
'                                                     unsigned short MoveCtrl,
'                                                     double         Acc,
'                                                     double         Speed,
'                                                     WORD          *lpusTAN );
'
'    /*
'    Set nominal values for position generator
'
'      In :  DoPEHdl       DoPE link handle
'            MoveCtrl      Control mode
'            Acc           default acceleration
'            Speed         speed limit
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetOpenLoopCommand Lib "dope.dll" Alias "DoPESetOpenLoopCommand" (ByVal DoPEHdl&, ByVal Command#, lpusTAN%) As Long
Declare Function DoPEVBSetOpenLoopCommandSync Lib "dope.dll" Alias "DoPESetOpenLoopCommandSync" (ByVal DoPEHdl&, ByVal Command#) As Long
'  extern  unsigned  DLLAPI  DoPESetOpenLoopCommand ( DoPE_HANDLE     DP,
'                                                     double          Command,
'                                                     WORD       FAR *lpusTAN );
'
'    /*
'    Set output in open loop mode
'
'      In :  DP          DoPE link handle
'            Command     Command value in % of nominal output value
'
'      Returns:          Error constant(DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'/*                           Requests for Information                        */
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdVersion Lib "dopevb.dll" (ByVal DoPEHdl&, Version As DoPEVersion) As Long

'  extern  unsigned  DLLAPI  DoPERdVersion ( DoPE_HANDLE DoPEHdl,
'                                            DoPEVersion FAR *Version);
'    /*
'    Read Version strings.
'
'      In :  DoPEHdl     DoPE link handle
'            Version     Version strings
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
'/* ------ Constants  for 'status' in  DoPEModuleInfo ------------------------ */

Public Const MODSTAT_OK = 0               ' Module is ready to operate
Public Const MODSTAT_HWFAIL = 3           ' Hardware error on module
Public Const MODSTAT_NOMODULE = 6         ' Module not present
Public Const MODSTAT_NODRIVER = 9         ' No driver for module
Public Const MODSTAT_REMOTE = 10          ' Remote-Module
Public Const MODSTAT_SWFAIL = &HFFFF      ' Error in  Module-driver-software

Declare Function DoPEVBRdModuleInfo Lib "dope.dll" Alias "DoPERdModuleInfo" (ByVal DoPEHdl As Long, ByVal ModulNo As Long, ByRef Info As DoPEModuleInfo) As Long
'  extern  unsigned  DLLAPI  DoPERdModuleInfo ( DoPE_HANDLE     DP,
'                                               unsigned        ModulNo,
'                                               DoPEModuleInfo *Info);
'    /*
'    Read module info.
'
'      In :  DP          DoPE link handle
'            ModuleNo    Module number ( 0 .. MAX_MODULE-1 )
'            Info        Pointer to storage for the module info
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdDriveInfo Lib "dope.dll" Alias "DoPERdDriveInfo" (ByVal DoPEHdl As Long, ByVal Connector As Integer, ByRef Info As DoPEDriveInfo) As Long
'
'  extern  unsigned  DLLAPI  DoPERdDriveInfo ( DoPE_HANDLE    DP,
'                                              WORD           Connector,
'                                              DoPEDriveInfo *Info );
'    /*
'    Read drive info.
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of output
'            Info        Pointer to storage for the drive info
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBOn Lib "dope.dll" Alias "DoPEOn" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBOnSync Lib "dope.dll" Alias "DoPEOnSync" (ByVal DoPEHdl&) As Long

'  extern  unsigned  DLLAPI  DoPEOn ( DoPE_HANDLE DP );
'    /*
'    Activate drive.
'    On EDC100 systems the drive is activated by the "ON" push button.
'
'      In :  DP            DoPE link handle
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBOffSync Lib "dope.dll" Alias "DoPEOffSync" (ByVal DoPEHdl&) As Long
Declare Function DoPEVBOff Lib "dope.dll" Alias "DoPEOff" (ByVal DoPEHdl&, lpusTANFirst%, lpusTANLast%) As Long

'  extern  unsigned  DLLAPI  DoPEOffSync ( DoPE_HANDLE DP );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEOff ( DoPE_HANDLE DP,
'                                      WORD       *lpusTANFirst,
'                                      WORD       *lpusTANLast );
'    /*
'    Deactivate drive.
'
'      In :  DP            DoPE link handle
'
'      Out :
'            *lpusTANFirst Pointer to first TAN used from this command
'            *lpusTANLast  Pointer to last TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBCalOut Lib "dope.dll" Alias "DoPECalOut" (ByVal DoPEHdl&, ByVal Cal%, lpusTAN%) As Long
Declare Function DoPEVBCalOutSync Lib "dope.dll" Alias "DoPECalOutSync" (ByVal DoPEHdl&, ByVal Cal%) As Long
'  extern  unsigned  DLLAPI  DoPECalOut ( DoPE_HANDLE    DoPEHdl,
'                                         unsigned short Cal );
'    /*
'
'
'      In :  DoPEHdl     DoPE  link handle
'            Cal         1     activate Calibration output
'                        0     deactivate Calibration output
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBBeep Lib "dope.dll" Alias "DoPEBeep" (ByVal DoPEHdl&, ByVal xBeep%, lpusTAN%) As Long
Declare Function DoPEVBBeepSync Lib "dope.dll" Alias "DoPEBeepSync" (ByVal DoPEHdl&, ByVal xBeep%) As Long

'  extern  unsigned  DLLAPI  DoPEBeep ( DoPE_HANDLE    DoPEHdl,
'                                       unsigned short Beep );
'    /*
'
'
'      In :  DoPEHdl     DoPE  link handle
'            Beep        1     activate Beep
'                        0     deactivate Beep
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBLed Lib "dope.dll" Alias "DoPELed" (ByVal DoPEHdl&, ByVal LedOn%, ByVal LedOff%, ByVal LedFlash%, lpusTAN%) As Long
Declare Function DoPEVBLedSync Lib "dope.dll" Alias "DoPELedSync" (ByVal DoPEHdl&, ByVal LedOn%, ByVal LedOff%, ByVal LedFlash%) As Long

'  extern  unsigned  DLLAPI  DoPELed ( DoPE_HANDLE    DoPEHdl,
'                                      unsigned short LedOn,
'                                      unsigned short LedOff,
'                                      unsigned short LedFlash );
'    /*
'    Switch On/Off LED's at EDC frontpanel.
'
'      In :  DoPEHdl     DoPE link handle
'            LedOn       These LED's will be set
'            LedOff      These LED's will be reset
'            LedFlash    These LED's 'flash'
'
'            The three data words will be processed in the following
'            sequence (important with conflicting data):
'            1.) Flashing LED's.         (lowest)
'            2.) Resetting of the LED's.
'            3.) Setting of the LED's.   (highest)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBUniOut Lib "dope.dll" Alias "DoPEUniOut" (ByVal DoPEHdl&, ByVal Out%, lpusTAN%) As Long
Declare Function DoPEVBUniOutSync Lib "dope.dll" Alias "DoPEUniOutSync" (ByVal DoPEHdl&, ByVal Out%) As Long
'  extern  unsigned  DLLAPI  DoPEUniOut ( DoPE_HANDLE    DoPEHdl,
'                                         unsigned short Output);
'    /*
'    Activate/Deactivate universal digital output bits.
'
'      In :  DP            DoPE link handle
'            Output        Represents the digital outputs.
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBBypass Lib "dope.dll" Alias "DoPEBypass" (ByVal DoPEHdl&, ByVal Bypass%, lpusTAN%) As Long
Declare Function DoPEVBBypassSync Lib "dope.dll" Alias "DoPEBypassSync" (ByVal DoPEHdl&, ByVal Bypass%) As Long
'  extern  unsigned  DLLAPI  DoPEBypass ( DoPE_HANDLE    DoPEHdl,
'                                         unsigned short Bypass);
'
'    /*
'    Activate/Deactivate bypass output.
'
'      In :  DoPEHdl     DoPE  link handle
'            Bypass      1     activates bypass output
'                        0     deactivates bypass output
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* ------------------------------------------------------------------------- */
'/*                Display Instructions (Only on EDC-Systems)                 */
'/* ------------------------------------------------------------------------- */
'
Declare Function DoPEVBDspClear Lib "dope.dll" Alias "DoPEDspClear" (ByVal DoPEHdl&, lpusTAN%) As Long
Declare Function DoPEVBDspClearSync Lib "dope.dll" Alias "DoPEDspClearSync" (ByVal DoPEHdl&) As Long

'  extern  unsigned  DLLAPI  DoPEDspClear    ( DoPE_HANDLE DP );
'
'    /*
'    Clear LCD-display at EDC frontpanel
'
'      In :  DoPEHdl     DoPE link handle
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'

Public Const DSP_HEADLINE_LEN = 22     ' number of characters in headline
                                       ' (including terminating zero '\0')

Declare Function DoPEVBDspHeadLine Lib "dope.dll" Alias "DoPEDspHeadLine" (ByVal DoPEHdl&, ByVal HeadLine$, lpusTAN%) As Long
Declare Function DoPEVBDspHeadLineSync Lib "dope.dll" Alias "DoPEDspHeadLineSync" (ByVal DoPEHdl&, ByVal HeadLine$) As Long

' wide character version
Declare Function DoPEVBwDspHeadLine Lib "dope.dll" Alias "DoPEwDspHeadLine" (ByVal DoPEHdl&, ByVal HeadLine$, lpusTAN%) As Long
Declare Function DoPEVBwDspHeadLineSync Lib "dope.dll" Alias "DoPEwDspHeadLineSync" (ByVal DoPEHdl&, ByVal HeadLine$) As Long

'  extern  unsigned  DLLAPI  DoPEDspHeadLine ( DoPE_HANDLE DoPEHdl,
'                                              char FAR   *HeadLine );
'
'    /*
'    Display headline on LCD-display at EDC frontpanel
'
'      In :  DoPEHdl     DoPE link handle
'            HeadLine    Character string
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'

Public Const DSP_FKEYSLINE_LEN = 22    ' number of characters in FKeys line
                                       ' (including terminating zero '\0')

Declare Function DoPEVBDspFKeys Lib "dope.dll" Alias "DoPEDspFKeys" (ByVal DoPEHdl&, ByVal FKeys$, lpusTAN%) As Long
Declare Function DoPEVBDspFKeysSync Lib "dope.dll" Alias "DoPEDspFKeysSync" (ByVal DoPEHdl&, ByVal FKeys$) As Long

' wide character version
Declare Function DoPEVBwDspFKeys Lib "dope.dll" Alias "DoPEwDspFKeys" (ByVal DoPEHdl&, ByVal FKeys$, lpusTAN%) As Long
Declare Function DoPEVBwDspFKeysSync Lib "dope.dll" Alias "DoPEwDspFKeysSync" (ByVal DoPEHdl&, ByVal FKeys$) As Long

'  extern  unsigned  DLLAPI  DoPEDspFKeys    ( DoPE_HANDLE DoPEHdl,
'                                              char FAR    *FKeys );
'
'    /*
'    Display function keys on LCD-display at EDC frontpanel
'
'
'      In :  DoPEHdl     DoPE link handle
'            FKeys       Character string
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'

Public Const DSP_VALUE_LEN = 10        ' number of characters in Value field
                                       ' (including terminating zero '\0')
Public Const DSP_DIM_LEN = 7           ' number of characters in Dim field
                                       ' (including terminating zero '\0')

Declare Function DoPEVBDspMValue Lib "dope.dll" Alias "DoPEDspMValue" (ByVal DoPEHdl&, ByVal Value1$, ByVal Value2$, ByVal Unit1$, ByVal Unit2$, lpusTAN%) As Long
Declare Function DoPEVBDspMValueSync Lib "dope.dll" Alias "DoPEDspMValueSync" (ByVal DoPEHdl&, ByVal Value1$, ByVal Value2$, ByVal Unit1$, ByVal Unit2$) As Long

' wide character version
Declare Function DoPEVBwDspMValue Lib "dope.dll" Alias "DoPEwDspMValue" (ByVal DoPEHdl&, ByVal Value1$, ByVal Value2$, ByVal Unit1$, ByVal Unit2$, lpusTAN%) As Long
Declare Function DoPEVBwDspMValueSync Lib "dope.dll" Alias "DoPEwDspMValueSync" (ByVal DoPEHdl&, ByVal Value1$, ByVal Value2$, ByVal Unit1$, ByVal Unit2$) As Long

'  extern  unsigned  DLLAPI  DoPEDspMValue   ( DoPE_HANDLE DoPEHdl,
'                                              char FAR   *Value1,
'                                              char FAR   *Value2,
'                                              char FAR   *Dim1  ,
'                                              char FAR   *Dim2  );
'
'    /*
'    Display data and dimensions on LCD-display at EDC frontpanel
'
'
'      In :  DoPEHdl     DoPE link handle
'            Value1      Character string for first value
'            Value2      Character string for second value
'            Dim1        Character string for first dimension
'            Dim2        Character string for second dimension
'                        ( Strings are zero terminated '\0' )'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBDspBeamScreen Lib "dope.dll" Alias "DoPEDspBeamScreen" (ByVal DoPEHdl&, ByVal Value%, lpusTAN%) As Long
Declare Function DoPEVBDspBeamScreenSync Lib "dope.dll" Alias "DoPEDspBeamScreenSync" (ByVal DoPEHdl&, ByVal Value%) As Long
'  extern  unsigned  DLLAPI  DoPEDspBeamScreen ( DoPE_HANDLE  DP,
'                                                short        Value,
'                                                WORD    FAR *lpusTAN );
'
'    /*
'    Display frame & beam on LCD-display at EDC frontpanel
'
'
'      In :  DP          DoPE link handle
'            Value       value of the beam in %
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBDspBeamValue Lib "dope.dll" Alias "DoPEDspBeamValue" (ByVal DoPEHdl&, ByVal Value%, lpusTAN%) As Long
Declare Function DoPEVBDspBeamValueSync Lib "dope.dll" Alias "DoPEDspBeamValueSync" (ByVal DoPEHdl&, ByVal Value%) As Long
'  extern  unsigned  DLLAPI  DoPEDspBeamValue ( DoPE_HANDLE  DP,
'                                               short        Value,
'                                               WORD    FAR *lpusTAN );
'
'    /*
'    Display beam on LCD-display at EDC frontpanel
'
'
'      In :  DP          DoPE link handle
'            Value       value of the beam in %
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'/*--------------------------------------------------------------------------*/
'
Public Const REFSIG_NON = 0
Public Const REFSIG_ON = 1
Public Const REFSIG_ONCE = 2

Declare Function DoPEVBSetRefSignalMode Lib "dope.dll" Alias "DoPESetRefSignalMode" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESetRefSignalMode ( DoPE_HANDLE    DP,
'                                                   unsigned short SensorNo,
'                                                   unsigned short Mode,
'                                                   WORD          *lpusTAN );
'
'    /*
'    Set the reference signal mode.
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Mode          reference signal messages will be reported:
'                          REFSIG_NON:  never
'                          REFSIG_ON:   allways
'                          REFSIG_ONCE: only once
'
'      Out : *lpusTAN      Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  #define  REFSIG_NON           0
'  #define  REFSIG_ON            1
'  #define  REFSIG_ONCE          2
'
'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetRefSignalTare Lib "dope.dll" Alias "DoPESetRefSignalTare" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, ByVal Tare#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESetRefSignalTareSync ( DoPE_HANDLE    DP,
'                                                       unsigned short SensorNo,
'                                                       unsigned short Mode,
'                                                       double         Tare,
'                                                       WORD          *lpusTAN );
'
'    /*
'    Set the measuring channel to the tare value at the next occurance of the
'    reference signal.
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Mode          Action at the next reference signal:
'                          REFSIG_TARE: set the measuring channel to the tare value
'                          REFSIG_NON:  don't affect the measuring channel
'            Tare          Value for the measuring channel
'
'      Tare value will be stored in EDC's non volatile BasicTare memory.
'      This function clears the current basic tare and ordinary tare value
'      at the next occurance of the reference signal.
'
'      Out : *lpusTAN      Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */

Public Const REFSIG_TARE = 1

'/*----------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetBasicTare Lib "dope.dll" Alias "DoPESetBasicTare" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, ByVal BasicTare#, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBSetBasicTareSync Lib "dope.dll" Alias "DoPESetBasicTareSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, ByVal BasicTare#) As Long
'  extern  unsigned  DLLAPI  DoPESetBasicTare ( DoPE_HANDLE     DoPEHdl,
'                                               unsigned short  SensorNo,
'                                               unsigned short  Mode,
'                                               double          BasicTare );
'
'    /*
'    Set basic tare of the measuring channel
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Mode          BASICTARE_SET:
'                            BasicTare represents the desired measuring value.
'                            This is useful to set crosshead position for systems
'                            with encoder.
'                          BASICTARE_SUBTRACT
'                            BasicTare will be subtracted.
'                            This is usefull to compensate the weight of grips.
'            BasicTare     Value for BasicTare
'
'      BasicTare value will be stored in EDC's non volatile memory.
'      This function clears the ordinary tare value.
'
'      Out:
'            *lpusTANFirst Pointer to first TAN used from this command
'            *lpusTANLast  Pointer to last TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */

Public Const BASICTARE_SET = 0
Public Const BASICTARE_SUBTRACT = 1

'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetTare Lib "dope.dll" Alias "DoPESetTare" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Tare#) As Long

'  extern  unsigned  DLLAPI  DoPESetTare ( DoPE_HANDLE     DoPEHdl,
'                                          unsigned short  SensorNo,
'                                          double          Tare );
'
'    /*
'    Set tare of the measuring channel
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            Tare        Value to be subtracted.
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBGetBasicTare Lib "dope.dll" Alias "DoPEGetBasicTare" (ByVal DoPEHdl&, ByVal SensorNo%, BasicTare#) As Long

'  extern  unsigned  DLLAPI  DoPEGetBasicTare ( DoPE_HANDLE     DoPEHdl,
'                                               unsigned short SensorNo,
'                                               double  FAR   *BasicTare);
'
'    /*
'    Read tare value of the measuring channel
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *BasicTare  Pointer for BasicTare
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBGetTare Lib "dope.dll" Alias "DoPEGetTare" (ByVal DoPEHdl&, ByVal SensorNo%, Tare#) As Long

'  extern  unsigned  DLLAPI  DoPEGetTare ( DoPE_HANDLE      DoPEHdl,
'                                           unsigned short  SensorNo,
'                                           double  FAR    *Tare);
'
'    /*
'    Read tare value of the measuring channel
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *Tare       Pointer for tare
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* ------------------------------------------------------------------------- */
'/*                   Read Messages received from Subsystem                   */
'/* ------------------------------------------------------------------------- */
'
Declare Function DoPEVBRdSensorInfo Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SensorNo%, Info As DoPESumSenInfo) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorInfo ( DoPE_HANDLE         DoPEHdl,
'                                               unsigned short      SensorNo,
'                                               DoPESumSenInfo FAR *Info );
'
'    /*
'    Read summary sensor informations
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *Info       Pointer for SumSenInfo structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SensorNo%, SensorDef As DoPESenDef) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorDef ( DoPE_HANDLE     DoPEHdl,
'                                              unsigned short  SensorNo,
'                                              DoPESenDef FAR *SensorDef );
'
'    /*
'    Read sensor definitions
'
'      In :  DoPEHdl     DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *SensorDef  Pointer for DoPESenDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdCtrlSensorDef Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef) As Long
Declare Function DoPEVBRdCtrlSensorDefHigh Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef) As Long

'  extern  unsigned  DLLAPI  DoPERdCtrlSensorDef ( DoPE_HANDLE         DoPEHdl,
'                                                  unsigned short      SensorNo,
'                                                  DoPECtrlSenDef FAR *CtrlSensorDef );
'
'    /*
'    Read definitions of control sensor for low and high pressure
'
'      In :  DoPEHdl        DoPE link handle
'            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
'            *CtrlSensorDef Pointer for DoPECtrlSenDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdOutChannelDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal OutChNo%, OutChDef As DoPEOutChaDef) As Long

'  extern  unsigned  DLLAPI  DoPERdOutChannelDef ( DoPE_HANDLE        DoPEHdl,
'                                                  unsigned short     OutChNo,
'                                                  DoPEOutChaDef FAR *OutChDef );
'    /*
'    Read analogue output channel definitions
'
'      In :  DoPEHdl     DoPE link handle
'            OutChNo     Output channel no.
'            *OutChDef   Pointer for DoPEOutChaDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdBitOutDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitOutNo%, BitOutDef As DoPEBitOutDef) As Long

'  extern  unsigned  DLLAPI  DoPERdBitOutDef ( DoPE_HANDLE        DoPEHdl,
'                                              unsigned short     BitOutNo,
'                                              DoPEBitOutDef FAR *BitOutDef );
'
'    /*
'    Read Bit output definitions
'
'      In :  DoPEHdl     DoPE link handle
'            BitOutNo    Output channel no.
'            *BitOutDef  Pointer for DoPEBitOutDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdBitInDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitInNo%, BitInDef As DoPEBitInDef) As Long

'  extern  unsigned  DLLAPI  DoPERdBitInDef ( DoPE_HANDLE       DoPEHdl,
'                                             unsigned short    BitInNo,
'                                             DoPEBitInDef FAR *BitInDef );
'
'    /*
'    Read Bit input definitions
'
'      In :  DoPEHdl        DoPE link handle
'            BitInNo        Output channel no.
'            *BitInDef      Pointer for DoPEBitInDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdMachineDef Lib "dopevb.dll" (ByVal DoPEHdl&, MachineDef As DoPEMachineDef) As Long

'  extern  unsigned  DLLAPI  DoPERdMachineDef ( DoPE_HANDLE         DoPEHdl,
'                                               DoPEMachineDef FAR *MachineDef );
'
'    /*
'    Read definitions of active machine
'
'      In :  DoPEHdl     DoPE link handle
'            *MachineDef Pointer for DoPEMachineDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdLinTbl Lib "dopevb.dll" (ByVal DoPEHdl&, LinTblFalse As DoPELinTblFalse, LinTblTrue As DoPELinTblTrue) As Long

'  extern  unsigned  DLLAPI  DoPERdLinTbl ( DoPE_HANDLE          DP,
'                                           DoPELinTblFalse FAR *LinTblFalse,
'                                           DoPELinTblTrue  FAR *LinTblTrue  );
'
'    /*
'    Read linearisation table
'
'      In :  DP           DoPE link handle
'            *LinTblFalse Pointer to measured values structure
'            *LinTblTrue  Pointer to reference values structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdIOSignals Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef IOSignals As DoPEIOSignals) As Long

'  extern  unsigned  DLLAPI  DoPERdIOSignals ( DoPE_HANDLE  Hdl,
'                                              DoPEIOSignals *IOSignals );
'
'    /*
'    Read IO signal definitions
'
'      In :  DP           DoPE link handle
'            *IOSignals   Pointer to DoPEIOSignals structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Type VBMainMenu
  MainMenu(MAX_MAIN_MENU - 1) As DoPEMainMenu
End Type

Declare Function DoPEVBRdMainMenu Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef MainMenu As VBMainMenu) As Long

'  extern  unsigned  DLLAPI  DoPERdMainMenu ( DoPE_HANDLE  Hdl,
'                                             DoPEMainMenu MainMenu[MAX_MAIN_MENU] );
'
'    /*
'    Read the main menu definition array
'
'      In :  DP           DoPE link handle
'            MainMenu     Pointer to DoPEMainMenu array
'                         The TestNo of the MainMenu entries is read only!
'
'      Returns:           Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdRmcDef Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef RmcDef As DoPERmcDef) As Long

'  extern  unsigned  DLLAPI  DoPERdRmcDef ( DoPE_HANDLE  DoPEHdl,
'                                           DoPERmcDef  *RmcDef );
'
'    /*
'    Read RMC definitions
'
'      In :  DoPEHdl      DoPE link handle
'            *RmcDef      Pointer to DoPERmcDef structure
'
'      Returns:           Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSysUserData Lib "dope.dll" Alias "DoPERdSysUserData" (ByVal DoPEHdl&, ByVal SysUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPERdSysUserData ( DoPE_HANDLE  DP,
'                                                BYTE    FAR *SysUsrData,
'                                                unsigned     Length );
'
'    /*
'    Read system user data
'
'      In :  DP          DoPE link handle
'            *SysUsrData Pointer for SYSEEPROM user data
'            Length      User data buffer length in bytes
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorHeaderData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenHdrData As DoPESensorHeaderData) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorHeaderData ( DoPE_HANDLE           DP,
'                                                     WORD                  Connector,
'                                                     DoPESensorHeaderData *SenHdrData );
'
'    /*
'    Read sensor EEPROM data header
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenHdrData Pointer to sensor data header structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBWrSensorHeaderData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenHdrData As DoPESensorHeaderData) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorHeaderData ( DoPE_HANDLE           DoPEHdl,
'                                                     WORD                  Connector,
'                                                     DoPESensorHeaderData *SenHdrData );
'
'    /*
'    Write sensor EEPROM data header
'
'      In :  DoPEHdl     DoPE link handle
'            Connector   Connector number of sensor
'            *SenHdrData Pointer to sensor data header structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorAnalogueData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenAnalogueData As DoPESensorAnalogueData) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorAnalogueData ( DoPE_HANDLE             DP,
'                                                       WORD                    Connector,
'                                                       DoPESensorAnalogueData *SenAnalogueData );
'
'    /*
'    Read analogue sensor data
'
'      In :  DP               DoPE link handle
'            Connector        Connector number of sensor
'            *SenAnalogueData Pointer to analogue sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorIncData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenIncData As DoPESensorIncData) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorIncData ( DoPE_HANDLE        DP,
'                                                  WORD               Connector,
'                                                  DoPESensorIncData *SenIncData );
'
'    /*
'    Read incremental sensor data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenIncData Pointer to incremental sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorAbsData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenAbsData As DoPESensorAbsData) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorAbsData ( DoPE_HANDLE        DP,
'                                                  WORD               Connector,
'                                                  DoPESensorAbsData *SenAbsData );
'
'    /*
'    Read absolute sensor data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenAbsData Pointer to absolute value sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorUserData Lib "dope.dll" Alias "DoPERdSensorUserData" (ByVal DoPEHdl&, ByVal Connector%, ByVal SenUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorUserData ( DoPE_HANDLE DP,
'                                                   WORD        Connector,
'                                                   BYTE       *SenUsrData,
'                                                   unsigned    Length );
'
'    /*
'    Read sensor user data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenUsrData Pointer for sensor user data
'            Length      User data buffer length in BYTEs
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSenUserData Lib "dope.dll" Alias "DoPERdSenUserData" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal SenUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPERdSenUserData ( DoPE_HANDLE  DP,
'                                                WORD         SensorNo,
'                                                BYTE    FAR *SenUsrData,
'                                                unsigned     Length );
'
'    /*
'    Read sensor user data
'
'      In :  DP          DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *SenUsrData Pointer for sensor user data
'            Length      User data buffer length in bytes
'
'    Returns:            Error constant(DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdSensorConKey Lib "dope.dll" Alias "DoPERdSensorConKey" (ByVal DoPEHdl&, ByVal Connector%, Connected%, KeyPressed%) As Long

'  extern  unsigned  DLLAPI  DoPERdSensorConKey ( DoPE_HANDLE DP,
'                                                 WORD        Connector,
'                                                 WORD       *Connected,
'                                                 WORD       *KeyPressed );
'
'    /*
'    Read sensor plug connected and key state
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *Connected  Pointer to the sensor plug connected state
'                        (0=not connected, 1=connected)
'            *KeyPressed Pointer to the sensor plug key state
'                        (0=not pressed, 1=pressed)
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdGeneralData Lib "dopevb.dll" (ByVal DoPEHdl&, GeneralData As DoPEGeneralData) As Long

'  extern  unsigned  DLLAPI  DoPERdGeneralData ( DoPE_HANDLE          DP,
'                                                DoPEGeneralData FAR *GeneralData );
'
'    /*
'    Read general data
'
'      In :  DP           DoPE link handle
'            *GeneralData Pointer for DoPEGeneralData structure
'
'      Returns:           Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/

Type DoPECtrlParameter              ' Controller parameter
  PosP             As Long          ' Pos.  contr. P: gain             [No]
  PosI             As Integer       ' Pos.  contr. I: time constant    [No]
  PosD             As Integer       ' Pos.  contr. D: time constant    [No]
  PosFFP           As Long          ' Pos.  Feed Forward P             [No]
  SpeedP           As Long          ' Speed contr. P: gain             [No]
  SpeedI           As Integer       ' Speed contr. I: time constant    [No]
  SpeedD           As Integer       ' Speed contr. D: time constant    [No]
  SpeedFFP         As Integer       ' Speed feed forward               [No]
  PosDelay         As Integer       ' Delay for Command                [No]
  AccFFP           As Integer       ' Acceleration contr. P: gain      [No]
  SpeedDelay       As Integer       ' Delay for SpeedCommand           [No]
                                    '
  Acceleration     As Double        ' default acceleration        [Unit/s²]
  Speed            As Double        ' speed limit                  [Unit/s]
  Deviation        As Double        ' Max. deviation of controller   [Unit]
  DevReaction      As Integer       ' Reaction if deviation exceeded   [No]
                                    '
  DestinationWnd   As Double        ' Size of 1/2 destination window [Unit]
  DestinationTime  As Double        ' Time until controlled channel     [s]
                                    ' must reach destination window
  UpperSoftEnd     As Double        ' Upper softend                  [Unit]
  LowerSoftEnd     As Double        ' Lower softend                  [Unit]
  SoftEndReaktion  As Integer       ' Reaction if softend is reached   [No]

                                    ' numerical limitations for
                                    ' acceleration and speed parameters
  MinAcceleration  As Double        ' minimum acceleration        [Unit/s²]
  MaxAcceleration  As Double        ' maximum acceleration        [Unit/s²]
  MinDeceleration  As Double        ' minimum deceleration        [Unit/s²]
  MaxDeceleration  As Double        ' maximum deceleration        [Unit/s²]
  MinSpeed         As Double        ' minimum speed                [Unit/s]
  MaxSpeed         As Double        ' maximum speed                [Unit/s]

                                    ' error deadband controller parameter
  Deadband         As Double        ' Error deadband around setpoint [Unit]
  PercentP         As Integer       ' Smallest P inside deadband[% of PosP]
End Type

Declare Function DoPEVBRdCtrlParameter Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal MoveCtrl As Integer, ByRef CtrlParameter As DoPECtrlParameter) As Long

'  extern  unsigned  DLLAPI  DoPERdCtrlParameter ( DoPE_HANDLE        DP,
'                                                  unsigned short     MoveCtrl,
'                                                  DoPECtrlParameter *CtrlParameter );
'
'    /*
'    Read closed loop controller parameter
'
'      In :  DP             DoPE link handle
'            MoveCtrl       Control mode
'            *CtrlParameter Pointer for DoPECtrlParameter structure
'
'      Returns:             Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SensorNo%, SensorDef As DoPESenDef, lpusTAN%) As Long
Declare Function DoPEVBWrSensorDefSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal SensorNo%, SensorDef As DoPESenDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorDef ( DoPE_HANDLE      DP,
'                                              unsigned short   SensorNo,
'                                              DoPESenDef  FAR *SensorDef,
'                                              WORD        FAR *lpusTAN );
'    /*
'    Write sensor definitions
'
'      In :  DP          DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *SensorDef  Pointer for DoPESenDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrCtrlSensorDef Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBWrCtrlSensorDefSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef) As Long

Declare Function DoPEVBWrCtrlSensorDefHigh Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBWrCtrlSensorDefHighSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, CtrlSenDef As DoPECtrlSenDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDef ( DoPE_HANDLE         DP,
'                                                  unsigned short      SensorNo,
'                                                  DoPECtrlSenDef FAR *CtrlSensorDef,
'                                                  WORD           FAR *lpusTAN );
'
'  extern  unsigned  DLLAPI  DoPEWrCtrlSensorDefHigh ( DoPE_HANDLE     DP,
'                                                      unsigned short  SensorNo,
'                                                      DoPECtrlSenDef *CtrlSensorDef,
'                                                      WORD           *lpusTAN );
'    /*
'    Write definitions of control sensor for low and high pressure
'
'      In :  DP             DoPE link handle
'            SensorNo       Sensor Number SENSOR_S .. SENSOR_15
'            *CtrlSensorDef Pointer for DoPECtrlSenDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrOutChannelDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal OutChNo%, OutChDef As DoPEOutChaDef, lpusTAN%) As Long
Declare Function DoPEVBWrOutChannelDefSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal OutChNo%, OutChDef As DoPEOutChaDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrOutChannelDef ( DoPE_HANDLE        DP,
'                                                  unsigned short     OutChNo,
'                                                  DoPEOutChaDef FAR *OutChDef,
'                                                  WORD          FAR *lpusTAN );
'    /*
'    Write analogue output channel definitions
'
'      In :  DP          DoPE link handle
'            OutChNo     Output channel no.
'            *OutChDef   Pointer for DoPEOutChaDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrBitOutDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitOutNo%, BitOutDef As DoPEBitOutDef, lpusTAN%) As Long
Declare Function DoPEVBWrBitOutDefSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitOutNo%, BitOutDef As DoPEBitOutDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrBitOutDef ( DoPE_HANDLE        DP,
'                                              unsigned short     BitOutNo,
'                                              DoPEBitOutDef FAR *BitOutDef,
'                                              WORD          FAR *lpusTAN );
'
'    /*
'    Write Bit output definitions
'
'      In :  DP          DoPE link handle
'            BitOutNo    Output channel no.
'            *BitOutDef  Pointer for DoPEBitOutDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrBitInDef Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitInNo%, BitInDef As DoPEBitInDef, lpusTAN%) As Long
Declare Function DoPEVBWrBitInDefSync Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal BitInNo%, BitInDef As DoPEBitInDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrBitInDef ( DoPE_HANDLE       DP,
'                                             unsigned short    BitInNo,
'                                             DoPEBitInDef FAR *BitInDef,
'                                             WORD         FAR *lpusTAN );
'
'    /*
'    Write Bit input definitions
'
'      In :  DP             DoPE link handle
'            BitInNo        Output channel no.
'            *BitInDef      Pointer for DoPEBitInDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrMachineDef Lib "dopevb.dll" (ByVal DoPEHdl&, MachineDef As DoPEMachineDef, lpusTAN%) As Long
Declare Function DoPEVBWrMachineDefSync Lib "dopevb.dll" (ByVal DoPEHdl&, MachineDef As DoPEMachineDef) As Long

'  extern  unsigned  DLLAPI  DoPEWrMachineDef ( DoPE_HANDLE         DP,
'                                               DoPEMachineDef FAR *MachineDef,
'                                               WORD           FAR *lpusTAN );
'
'    /*
'    Write definitions of active machine
'
'      In :  DP          DoPE link handle
'            *MachineDef Pointer for DoPEMachineDef structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrLinTbl Lib "dopevb.dll" (ByVal DoPEHdl&, LinTblFalse As DoPELinTblFalse, LinTblTrue As DoPELinTblTrue, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBWrLinTblSync Lib "dopevb.dll" (ByVal DoPEHdl&, LinTblFalse As DoPELinTblFalse, LinTblTrue As DoPELinTblTrue) As Long

'  extern  unsigned  DLLAPI  DoPEWrLinTbl ( DoPE_HANDLE          DP,
'                                           DoPELinTblFalse FAR *LinTblFalse,
'                                           DoPELinTblTrue  FAR *LinTblTrue,
'                                           WORD            FAR *lpusTANFirst,
'                                           WORD            FAR *lpusTANLast );
'
'    /*
'    Write linearisation table
'
'      In :  DP           DoPE link handle
'            *LinTblFalse Pointer to measured values structure
'            *LinTblTrue  Pointer to reference values structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrIOSignals Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef IOSignals As DoPEIOSignals, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBWrIOSignalsSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef IOSignals As DoPEIOSignals) As Long

'  extern  unsigned  DLLAPI  DoPEWrIOSignalsSync ( DoPE_HANDLE    DP,
'                                                  DoPEIOSignals *IOSignals );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrIOSignals ( DoPE_HANDLE    DP,
'                                              DoPEIOSignals *IOSignals,
'                                              WORD          *lpusTAN );
'
'    /*
'    Write IO signal input definitions
'
'      In :  DP             DoPE link handle
'            *IOSignals     Pointer for DoPEIOSignals structure
'
'      Out :
'            *lpusTAN       Pointer to TAN used from this command
'
'      Returns:             Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrMainMenu Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef MainMenu As VBMainMenu, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBWrMainMenuSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef MainMenu As VBMainMenu) As Long

'  extern  unsigned  DLLAPI  DoPEWrMainMenuSync ( DoPE_HANDLE  Hdl,
'                                                 DoPEMainMenu MainMenu[MAX_MAIN_MENU] );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrMainMenu ( DoPE_HANDLE   Hdl,
'                                             DoPEMainMenu  MainMenu[MAX_MAIN_MENU],
'                                             WORD         *lpusTAN  );
'
'    /*
'    Write the main menu definitions array
'
'      In :  DP           DoPE link handle
'            MainMenu     Pointer to DoPEMainMenu array
'
'      Out :
'            *lpusTAN     Pointer to TAN used from this command
'
'      Returns:           Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrRmcDef Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef RmcDef As DoPERmcDef, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBWrRmcDefSync Lib "dopevb.dll" (ByVal DoPEHdl As Long, ByRef RmcDef As DoPERmcDef) As Long

'   extern  unsigned  DLLAPI  DoPEWrRmcDefSync ( DoPE_HANDLE   DoPEHdl,
'                                               DoPERmcDef   *RmcDef );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrRmcDef ( DoPE_HANDLE  DoPEHdl,
'                                           DoPERmcDef  *RmcDef,
'                                           WORD        *lpusTAN );
'
'    /*
'    Write RMC definitions
'
'      In :  DoPEHdl        DoPE link handle
'            *RmcDef        Pointer for DoPERmcDef structure
'
'      Out :
'            *lpusTAN       Pointer to TAN used from this command
'
'      Returns:             Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
'
Declare Function DoPEVBWrSysUserData Lib "dope.dll" Alias "DoPEWrSysUserData" (ByVal DoPEHdl&, ByVal SysUsrData$, ByVal Lenght&, lpusTAN%) As Long
Declare Function DoPEVBWrSysUserDataSync Lib "dope.dll" Alias "DoPEWrSysUserDataSync" (ByVal DoPEHdl&, ByVal SysUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPEWrSysUserData ( DoPE_HANDLE  DP,
'                                                BYTE    FAR *SysUsrData,
'                                                unsigned     Length,
'                                                WORD    FAR *lpusTAN );
'
'    /*
'    Write system user data
'
'      In :  DP          DoPE link handle
'            *SysUsrData Pointer for SYSEEPROM user data
'            Length      User data buffer length in bytes
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorAnalogueData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenAnalogueData As DoPESensorAnalogueData) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorAnalogueData ( DoPE_HANDLE             DP,
'                                                       WORD                    Connector,
'                                                       DoPESensorAnalogueData *SenAnalogueData );
'
'    /*
'    Write analogue sensor data
'
'      In :  DP               DoPE link handle
'            Connector        Connector number of sensor
'            *SenAnalogueData Pointer to analogue sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorIncData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenIncData As DoPESensorIncData) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorIncData ( DoPE_HANDLE        DP,
'                                                  WORD               Connector,
'                                                  DoPESensorIncData *SenIncData );
'
'    /*
'    Write incremental sensor data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenIncData Pointer to incremental sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorAbsData Lib "dopevb.dll" (ByVal DoPEHdl&, ByVal Connector%, SenAbsData As DoPESensorAbsData) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorAbsData ( DoPE_HANDLE        DP,
'                                                  WORD               Connector,
'                                                  DoPESensorAbsData *SenAbsData );
'
'    /*
'    Write absolute sensor data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenAbsData Pointer to absolute value sensor data structure
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetSsiGenericSignalType Lib "dope.dll" Alias "DoPESetSsiGenericSignalType" (ByRef SignalType As Byte, ByVal Code As Long, ByVal Bits As Long) As Long
'
'  extern  unsigned  DLLAPI  DoPESetSsiGenericSignalType( BYTE     *SignalType,
'                                                         unsigned  Code,
'                                                         unsigned  Bits );
'
'    /*
'    Build the signal type of a SSI absolute sensor by it's generic data.
'
'      In :  SignalType  Pointer to signal type variable
'            Code        Code of the sensor (0:binary, !=0:gray code)
'            Bits        Number of databits of the sensor
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBSsiGenericSignalTypeInfo Lib "dope.dll" Alias "DoPESsiGenericSignalTypeInfo" (ByVal SignalType As Byte, ByRef Code As Long, ByRef Bits As Long) As Long
'
'  extern  unsigned  DLLAPI  DoPESsiGenericSignalTypeInfo( BYTE      SignalType,
'                                                          unsigned *Code,
'                                                          unsigned *Bits );
'
'    /*
'    Get the generic data of a SSI absolute sensor by it's signal type.
'
'      In :  SignalType  Signal type of the SSI sensor
'            Code        Pointer to storage for code of the sensor
'            Bits        Pointer to storage for number of databits of the sensor
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorUserData Lib "dope.dll" Alias "DoPEWrSensorUserData" (ByVal DoPEHdl&, ByVal Connector%, ByVal SenUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorUserData ( DoPE_HANDLE DP,
'                                                   WORD        Connector,
'                                                   BYTE       *SenUsrData,
'                                                   unsigned    Length );
'
'    /*
'    Write sensor user data
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *SenUsrData Pointer for sensor user data
'            Length      User data buffer length in BYTEs
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSenUserData Lib "dope.dll" Alias "DoPEWrSenUserData" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal SenUsrData$, ByVal Lenght&, lpusTAN%) As Long
Declare Function DoPEVBWrSenUserDataSync Lib "dope.dll" Alias "DoPEWrSenUserDataSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal SenUsrData$, ByVal Lenght&) As Long

'  extern  unsigned  DLLAPI  DoPEWrSenUserData ( DoPE_HANDLE  DP,
'                                                WORD         SensorNo,
'                                                BYTE    FAR *SenUsrData,
'                                                unsigned     Length,
'                                                WORD    FAR *lpusTAN );
'
'    /*
'    Write sensor user data
'
'      In :  DP          DoPE link handle
'            SensorNo    Sensor Number SENSOR_S .. SENSOR_15
'            *SenUsrData Pointer for sensor user data
'            Length      User data buffer length in bytes
'
'Returns:                Error constant(DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrGeneralData Lib "dopevb.dll" (ByVal DoPEHdl&, GeneralData As DoPEGeneralData, lpusTAN%) As Long
Declare Function DoPEVBWrGeneralDataSync Lib "dopevb.dll" (ByVal DoPEHdl&, GeneralDataSync As DoPEGeneralData) As Long

'  extern  unsigned  DLLAPI  DoPEWrGeneralData ( DoPE_HANDLE          DP,
'                                                DoPEGeneralData FAR *GeneralData,
'                                                WORD            FAR *lpusTAN );
'
'    /*
'    Write general data
'
'      In :  DP           DoPE link handle
'            *GeneralData Pointer for DoPEGeneralData structure
'
'      Returns:           Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBRdBitInput Lib "dope.dll" Alias "DoPERdBitInput" (ByVal DoPEHdl&, ByVal Connector%, Value%) As Long

'  extern  unsigned  DLLAPI  DoPERdBitInput ( DoPE_HANDLE DP,
'                                             WORD        Connector,
'                                             WORD   FAR *Value );
'    /*
'    Read an digital input device.
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            *Value      Pointer for bits read
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrBitOutput Lib "dope.dll" Alias "DoPEWrBitOutput" (ByVal DoPEHdl&, ByVal Connector%, ByVal Value%, lpusTAN%) As Long
Declare Function DoPEVBWrBitOutputSync Lib "dope.dll" Alias "DoPEWrBitOutputSync" (ByVal DoPEHdl&, ByVal Connector%, ByVal Value%) As Long

'  extern  unsigned  DLLAPI  DoPEWrBitOutput( DoPE_HANDLE DP,
'                                             WORD        Connector,
'                                             WORD        Value,
'                                             WORD   FAR *lpusTAN );
'    /*
'    Write an digital output device.
'
'      In :  DP          DoPE link handle
'            Connector   Connector number of sensor
'            Value       Bits to write
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBConfPeakValue Lib "dope.dll" Alias "DoPEConfPeakValue" (ByVal DoPEHdl&, ByVal PositionMin%, ByVal PositionMax%, ByVal LoadMin%, ByVal LoadMax%, ByVal ExtensionMin%, ByVal ExtensionMax%, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBConfPeakValueSync Lib "dope.dll" Alias "DoPEConfPeakValueSync" (ByVal DoPEHdl&, ByVal PositionMin%, ByVal PositionMax%, ByVal LoadMin%, ByVal LoadMax%, ByVal ExtensionMin%, ByVal ExtensionMax%) As Long

'  extern  unsigned  DLLAPI  DoPEConfPeakValue ( DoPE_HANDLE DP,
'                                                 unsigned short PositionMin,
'                                                 unsigned short PositionMax,
'                                                 unsigned short LoadMin,
'                                                 unsigned short LoadMax,
'                                                 unsigned short ExtensionMin,
'                                                 unsigned short ExtensionMax,
'                                                 WORD           FAR *lpusTANFirst,
'                                                 WORD           FAR *lpusTANLast );
'    /*
'    Configure peakvalues to measuring data record.
'    The peak values are detected by the EDC. They may be transmitted to PC instead of
'    an unused measuring channel. With this command the peak values for X-head position, load
'    and extension my be configured to measuring channels in the data record.
'    SENSOR4 to SENSOR15 are allowed to be configured as peak values.
'    e.g. use the constant SENSOR4 for PositionMin to configure the minimum value of
'    X-head position to SENSOR4 within the measuring data record.
'    Any number outside SENSOR4 to SENSOR15 will reset the measuring channels to the original
'    values. Use this feature to cancel Peak Values configuration.
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP                DoPE link handle
'            PositionMin       Position of Minimun value of XHead Position
'            PositionMax       Position of Maximum value of XHead Position
'            LoadMin           Position of Minimun value of Load
'            LoadMax           Position of Maximum value of Load
'            ExtensionMin      Position of Minimun value of Extension
'            ExtensionMax      Position of Maximum value of Extension
'            FAR *lpusTANFirst Pointer to first TAN used from this command
'            FAR *lpusTANLast  Pointer to last TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPeakValueTime Lib "dope.dll" Alias "DoPEPeakValueTime" (ByVal DoPEHdl&, ByVal Time#, lpusTAN%) As Long
Declare Function DoPEVBPeakValueTimeSync Lib "dope.dll" Alias "DoPEPeakValueTimeSync" (ByVal DoPEHdl&, ByVal Time#) As Long

'  extern  unsigned  DLLAPI  DoPEPeakValueTime  ( DoPE_HANDLE DP,
'                                                 double         Time,
'                                                 WORD      FAR *lpusTAN );
'    /*
'    Set reset time for peakvalue detection.
'    The maximum and minimum values within this time are considered as peak values.
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP           DoPE link handle
'            Time         Reset time for peak value detection
'            FAR *lpusTAN Pointer to TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'//----------------------------------------------------------------------------
'
'  // -------------- Definitions for calculated Sensors ----------------------
'  // -----------This channels can be used for control !!! --------------------

Public Const MAX_CALCULATED_CHANNELS = 4           ' Maximum number of calculated measuring channels

                                                   ' Constants for Calculated Sensor Init Value
Public Const F_S1PlusS2_half = 0                   ' S = (((S1 + S2) / 2)     / Corr) - Offset
Public Const F_S1MinusS2 = 1                       ' S =  ((S1 - S2)          / Corr) - Offset
Public Const F_S1PlusS2PlusS3_third = 2            ' S = (((S1 + S2+ S3) / 3) / Corr) - Offset
Public Const F_S1PlusS2PlusS3 = 3                  ' S =  ((S1 + S2+ S3)      / Corr) - Offset
Public Const F_S1PlusS2 = 4                        ' S =  ((S1 + S2)          / Corr) - Offset
Public Const F_StiffnessCorrection = 5             ' S =  ((S  - f(F)         / Corr) - Offset
Public Const F_SensorCorrection = 6                ' S =  ((S1 - f(S2)        / Corr) - Offset
Public Const F_ExtendedFormula = 7

                                                   ' Sensors must be in in ascending order starting at S1 !!
Public Const F_S1PlusS2PlusS3PlusS4_quarter = 7    ' S = (((S1 + S2+ S3+ S4) / 4) / Corr) - Offset
Public Const F_S1PlusS2PlusS3PlusS4 = 8            ' S = ((S1 + S2+ S3+ S4)       / Corr) - Offset

'  // The formula and used sensor are all coded in a 16Bit value:
'  // 1. For formula 0 - 6 may use three sensors:
'  //S3          S2          S1          Formula  Sign
'  //___________ ___________ ___________ ________ __
'  //15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
'  //
'  //
'  // 2. For formula 7 - 23 Bits 1-3 must be "1" and the formula is in Bits 12 - 15
'  //    These extented formulas can only use two Sensors, or the sensors must be in in ascending order
'  //ExtFormula  S2          S1          Value 7  Sign
'  //___________ ___________ ___________ ________ __
'  //15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBConfCMcSpeed Lib "dope.dll" Alias "DoPEConfCMcSpeed" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal SensorNo%, ByVal IntegrationTime#, ByVal Timebase#, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBConfCMcSpeedSync Lib "dope.dll" Alias "DoPEConfCMcSpeedSync" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal SensorNo%, ByVal IntegrationTime#, ByVal Timebase#) As Long

'  extern  unsigned  DLLAPI  DoPEConfCMcSpeed  ( DoPE_HANDLE  DP,
'                                                WORD         CalculatedSensorNo,
'                                                WORD         SensorNo,
'                                                double       IntegrationTime,
'                                                double       Timebase,
'                                                WORD    FAR *lpusTANFirst,
'                                                WORD    FAR *lpusTANLast );
'    /*
'    Configure calculated speed to measuring data record.
'    From any measuring channel speed (the first differentiation)
'    may be calculated and configured to the data record.
'    After it is configured, it may be used as the supervised
'    channel in the command "DoPESetCheck".
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP                  DoPE link handle
'            CalculatedSensorNo  Position in measuring data record for the
'                                calculated speed value.
'                                Any value between SENSOR4 to SENSOR15 is valid.
'            SensorNo            SensorNo to calculate speed of
'            IntegrationTime     Integration time for data aqcuisition
'                                (only relevant for analoge channels)
'                                maximum 100 * cycle time of seed controller.
'            Timebase            Timebase for speed calculation
'                                maximum 2.56 sec.
'            FAR *lpusTANFirst   Pointer to first TAN used from this command
'            FAR *lpusTANLast    Pointer to last TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBConfCMcCommandSpeed Lib "dope.dll" Alias "DoPEConfCMcCommandSpeed" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal Timebase#, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBConfCMcCommandSpeedSync Lib "dope.dll" Alias "DoPEConfCMcCommandSpeedSync" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal Timebase#) As Long

'  extern  unsigned  DLLAPI  DoPEConfCMcCommandSpeed  ( DoPE_HANDLE  DP,
'                                                       WORD         CalculatedSensorNo,
'                                                       double       Timebase,
'                                                       WORD    FAR *lpusTANFirst,
'                                                       WORD    FAR *lpusTANLast );
'    /*
'    Configure calculated speed of command output to data record.
'    Speed of command output (the first differentiation)
'    may be calculated and configured to the data record.
'    After it is configured, it may be used as the supervised
'    channel in the command "DoPESetCheck".
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP                  DoPE link handle
'            CalculatedSensorNo  Position in measuring data record for the
'                                calculated command speed.
'            Timebase            Timebase for speed calculation.
'                                maximum 2.56 sec.
'            FAR *lpusTANFirst   Pointer to first TAN used from this command
'            FAR *lpusTANLast    Pointer to last TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'
'/* ------------------------------------------------------------------------- */
'
Declare Function DoPEVBConfCMcGradient Lib "dope.dll" Alias "DoPEConfCMcGradient" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal DividentSensorNo%, ByVal DivisorSensorNo%, ByVal IntegrationTime#, ByVal Timebase#, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBConfCMcGradientSync Lib "dope.dll" Alias "DoPEConfCMcGradientSync" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, ByVal DividentSensorNo%, ByVal DivisorSensorNo%, ByVal IntegrationTime#, ByVal Timebase#) As Long

'  extern  unsigned  DLLAPI  DoPEConfCMcGradient  ( DoPE_HANDLE  DP,
'                                                   WORD         CalculatedSensorNo,
'                                                   WORD         DividentSensorNo,
'                                                   WORD         DivisorSensorNo,
'                                                   double       IntegrationTime,
'                                                   double       Timebase,
'                                                   WORD    FAR *lpusTANFirst,
'                                                   WORD    FAR *lpusTANLast );
'    /*
'    Configure calculated gradient between two measured values to measuring data record.
'    A gradient between two measured values
'    may be calculated and configured to the data record.
'    After it is configured, it may be used as the supervised
'    channel in the command "DoPESetCheck".
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP                  DoPE link handle
'            CalculatedSensorNo  Position in measuring data record for the
'                                calculated gradient.
'            DividentSensorNo    Sensor No. for Dividend
'            DivisorSensorNo     Sensor No. for Divisor
'            IntegrationTime     Integration time for data acquisition
'                                (only relevant for analogue channels)
'                                maximum 100 * cycle time of speed controller.
'            Timebase            Timebase for gradient calculation
'                                maximum 2.56 sec.
'            FAR *lpusTANFirst   Pointer to first TAN used from this command
'            FAR *lpusTANLast    Pointer to last TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBClearCMc Lib "dope.dll" Alias "DoPEClearCMc" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%, lpusTANFirst%, lpusTANLast%) As Long
Declare Function DoPEVBClearCMcSync Lib "dope.dll" Alias "DoPEClearCMcSync" (ByVal DoPEHdl&, ByVal CalculatedSensorNo%) As Long

'  extern  unsigned  DLLAPI  DoPEClearCMc  ( DoPE_HANDLE    DP,
'                                            unsigned short CalculatedSensorNo,
'                                            WORD      FAR *lpusTANFirst,
'                                            WORD      FAR *lpusTANLast );
'    /*
'    Clear calculated measuring channel.
'    This command should not be used when DoPEExts2 or DoPEFDPoti command are running.
'
'
'      In :  DP                  DoPE link handle
'            CalculatedSensorNo  Sensor Number SENSOR_S .. SENSOR_15
'            FAR *lpusTANFirst   Pointer to first TAN used from this command
'            FAR *lpusTANLast    Pointer to last TAN used from this command
'
'Returns:                Error constant(DoPERR_xxxx)
'
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBMc2OutputSync Lib "dope.dll" Alias "DoPEMc2OutputSync" (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Priority As Integer, ByVal SensorNo As Integer, ByVal Output As Integer, ByRef SensorPoint As Double, ByRef OutputPoint As Double) As Long
Declare Function DoPEVBMc2Output Lib "dope.dll" Alias "DoPEMc2Output" (ByVal DoPEHdl As Long, ByVal Mode As Integer, ByVal Priority As Integer, ByVal SensorNo As Integer, ByVal Output As Integer, ByRef SensorPoint As Double, ByRef OutputPoint As Double, ByRef lpusTAN As Integer) As Long

'  extern  unsigned  DLLAPI  DoPEMc2OutputSync  ( DoPE_HANDLE DoPEHdl,
'                                                 WORD        Mode,
'                                                 WORD        Priority,
'                                                 WORD        SensorNo,
'                                                 WORD        Output,
'                                                 double      SensorPoint[MC2OUT_MAX],
'                                                 double      OutputPoint[MC2OUT_MAX] );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEMc2Output  ( DoPE_HANDLE DoPEHdl,
'                                             WORD        Mode,
'                                             WORD        Priority,
'                                             WORD        SensorNo,
'                                             WORD        Output,
'                                             double      SensorPoint[MC2OUT_MAX],
'                                             double      OutputPoint[MC2OUT_MAX],
'                                             WORD        *lpusTAN );
'
'
'    /*
'    Output of a measured value to a analogue output channel.
'    Any measured channel may be scaled and via a DAC converted to a analogue
'    signal. Scale is defined by two or three points.
'
'    With the Mode parameter the calculation of the output is controlled:
'       MC2OUT_MODE_OFF       Output disabled
'       MC2OUT_MODE_2POINTS   Output definition by 2 points
'       MC2OUT_MODE_3POINTS   Output definition by 3 points
'
'    With the Priority parameter the output method is controlled:
'       MC2OUT_PRIORITY_HIGH  Output of this channel every 20 ms.
'       MC2OUT_PRIORITY_LOW   Every 20 ms only one of the channels with this
'                             priority is calculated and given output.
'       MC2OUT_PRIORITY_BURST Output of this channel every speed controller cycle.
'
'
'
'      In :  DoPEHdl             DoPE link handle
'            Mode                MC2OUT_MODE_...     (see above)
'            Priority            MC2OUT_PRIORITY_... (see above)
'            SensorNo            Sensor Number SENSOR_S .. SENSOR_15
'            Output              Number of analogue output channel
'            SensorPoint         Scale point sensor values
'            OutputPoint         Scale point output values
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBWrSensorMsgSync Lib "dope.dll" Alias "DoPEWrSensorMsgSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByRef Buffer As Byte, ByVal Lenght&) As Long
Declare Function DoPEVBWrSensorMsg Lib "dope.dll" Alias "DoPEWrSensorMsg" (ByVal DoPEHdl&, ByVal SensorNo%, ByRef Buffer As Byte, ByVal Lenght&, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEWrSensorMsgSync ( DoPE_HANDLE     DP,
'                                                  unsigned short  SensorNo,
'                                                  void           *Buffer,
'                                                  unsigned        Length );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEWrSensorMsg ( DoPE_HANDLE     DP,
'                                              unsigned short  SensorNo,
'                                              void           *Buffer,
'                                              unsigned        Length,
'                                              WORD           *lpusTAN );
'
'    /*
'    Write a message to a sensor.
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Buffer        Pointer to message to transmit
'            Length        Message length in BYTEs
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'/*---------------------------------------------------------------------------*/

Declare Function DoPEVBSerialSensorDefSync Lib "dope.dll" Alias "DoPESerialSensorDefSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Timeout#, ByVal MaxLength%, ByVal EndChar1 As Byte, ByVal EndChar2 As Byte, ByVal EndCharMode%) As Long
Declare Function DoPEVBSerialSensorDef Lib "dope.dll" Alias "DoPESerialSensorDef" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Timeout#, ByVal MaxLength%, ByVal EndChar1 As Byte, ByVal EndChar2 As Byte, ByVal EndCharMode%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESerialSensorDefSync ( DoPE_HANDLE     DP,
'                                                      unsigned short  SensorNo,
'                                                      double          Timeout,
'                                                      unsigned short  MaxLength,
'                                                      char            EndChar1,
'                                                      char            EndChar2,
'                                                      WORD            EndCharMode );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESerialSensorDef ( DoPE_HANDLE     DP,
'                                                  unsigned short  SensorNo,
'                                                  double          Timeout,
'                                                  unsigned short  MaxLength,
'                                                  char            EndChar1,
'                                                  char            EndChar2,
'                                                  WORD            EndCharMode,
'                                                  WORD           *lpusTAN );
'
'    /*
'    Definition for serial sensor.
'    A message for a serial sensor will be transmitted after:
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Timeout       Timeout, 0 = no timeout
'            MaxLength     Transmit after Number of bytes received
'                          (must be <= SERSEN_TRANSFER)
'            EndChar1      First  Endcharacter
'            EndChar2      Second Endcharacter
'            EndCharMode   SERSEN_ENDCHAR_NO
'                          SERSEN_ENDCHAR_1
'                          SERSEN_ENDCHAR_1_OR_2
'                          SERSEN_ENDCHAR_1_AND_2
'                          SERSEN_ENDCHAR_1_PLUS1
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
Public Const SERSEN_TRANSFER = 80                ' MaxLength limit
Public Const SERSEN_ENDCHAR_NO = 0               ' No Endcharacter active
Public Const SERSEN_ENDCHAR_1 = 1                ' Detect only EndChar1
Public Const SERSEN_ENDCHAR_1_OR_2 = 2           ' Detect EndChar1 or EndChar1
Public Const SERSEN_ENDCHAR_1_AND_2 = 3          ' Detect Sequence EndChar1 + EndChar2
Public Const SERSEN_ENDCHAR_1_PLUS1 = 4          ' Detect EndChar1 plus one Character
'
'/*---------------------------------------------------------------------------*/

Declare Function DoPEVBSetSerialSensorSync Lib "dope.dll" Alias "DoPESetSerialSensorSync" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, ByVal Value#, ByVal Speed#) As Long
Declare Function DoPEVBSetSerialSensor Lib "dope.dll" Alias "DoPESetSerialSensor" (ByVal DoPEHdl&, ByVal SensorNo%, ByVal Mode%, ByVal Value#, ByVal Speed#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPESetSerialSensorSync ( DoPE_HANDLE     DP,
'                                                      unsigned short  SensorNo,
'                                                      unsigned short  Mode,
'                                                      double          Value,
'                                                      double          Speed );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetSerialSensor ( DoPE_HANDLE     DP,
'                                                  unsigned short  SensorNo,
'                                                  unsigned short  Mode,
'                                                  double          Value,
'                                                  double          Speed,
'                                                  WORD           *lpusTAN );
'
'    /*
'    Set value (e.g. Temperature) for serial channel.
'
'      In :  DP            DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Mode          SERSEN_SET_COMMAND
'                          SERSEN_SET_FEEDBACK
'            Value         Value to set
'            Speed         Speed for ramp
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
Public Const SERSEN_SET_COMMAND = 0              ' Set Command value
Public Const SERSEN_SET_FEEDBACK = 1             ' Set Feedback value
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBSetSerialSensorTransparentSync Lib "dope.dll" Alias "DoPESetSerialSensorTransparentSync" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, ByVal Mode As Integer) As Long
Declare Function DoPEVBSetSerialSensorTransparent Lib "dope.dll" Alias "DoPESetSerialSensorTransparent" (ByVal DoPEHdl As Long, ByVal SensorNo As Integer, ByVal Mode As Integer, ByRef lpusTAN As Integer) As Long
'
'  extern  unsigned  DLLAPI  DoPESetSerialSensorTransparentSync ( DoPE_HANDLE     DoPEHdl,
'                                                                 unsigned short  SensorNo,
'                                                                 unsigned short  Mode );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPESetSerialSensorTransparent ( DoPE_HANDLE     DoPEHdl,
'                                                             unsigned short  SensorNo,
'                                                             unsigned short  Mode,
'                                                             WORD           *lpusTAN );
'
'    /*
'    Set serial channel to transparent mode or the previously selected protocol.
'
'      In :  DoPEHdl       DoPE link handle
'            SensorNo      Sensor Number SENSOR_S .. SENSOR_15
'            Mode          SERSEN_SET_PROTOCOL
'                          SERSEN_SET_TRANSPARENT
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */

Public Const SERSEN_SET_PROTOCOL = 0     ' Set sensor to the protocol defined
                                         ' by the sensors init. value
Public Const SERSEN_SET_TRANSPARENT = 1  ' Set sensor to transparent mode


'/*---------------------------------------------------------------------------*/

Declare Function DoPEVBOfflineActionBitOutputSync Lib "dope.dll" Alias "DoPEOfflineActionBitOutputSync" (ByVal DoPEHdl&, ByVal BitOutputNo%, ByVal Mode%, ByVal Value%) As Long
Declare Function DoPEVBOfflineActionBitOutput Lib "dope.dll" Alias "DoPEOfflineActionBitOutput" (ByVal DoPEHdl&, ByVal BitOutputNo%, ByVal Mode%, ByVal Value%, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEOfflineActionBitOutputSync ( DoPE_HANDLE DP,
'                                                             WORD        BitOutputNo,
'                                                             WORD        Mode,
'                                                             WORD        Value );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEOfflineActionBitOutput ( DoPE_HANDLE DP,
'                                                         WORD        BitOutputNo,
'                                                         WORD        Mode,
'                                                         WORD        Value,
'                                                         WORD       *lpusTAN );
'
'    /*
'    Set the offline action for an initialized digital output device.
'    With the Mode parameter the offline acction can be controlled:
'     DO_NOTHING       Don't modify this digital output
'     USE_INIT_VALUE   Use Initial value after offline
'     USE_VALUE        Use defined value after offline
'
'      In :  DP            DoPE link handle
'            BitOutputNo   Number of bit output device
'            Mode          Mode flag (see above)
'            Value         Output value used in USE_VALUE mode
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/

Declare Function DoPEVBOfflineActionOutputSync Lib "dope.dll" Alias "DoPEOfflineActionOutputSync" (ByVal DoPEHdl&, ByVal OutputNo%, ByVal Mode%, ByVal Value#) As Long
Declare Function DoPEVBOfflineActionOutput Lib "dope.dll" Alias "DoPEOfflineActionOutput" (ByVal DoPEHdl&, ByVal OutputNo%, ByVal Mode%, ByVal Value#, lpusTAN%) As Long

'  extern  unsigned  DLLAPI  DoPEOfflineActionOutputSync ( DoPE_HANDLE DP,
'                                                          WORD        OutputNo,
'                                                          WORD        Mode,
'                                                          double      Value );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEOfflineActionOutput ( DoPE_HANDLE DP,
'                                                      WORD        OutputNo,
'                                                      WORD        Mode,
'                                                      double      Value,
'                                                      WORD       *lpusTAN );
'
'    /*
'    Set the offline action for an initialized analog output channel.
'    With the Mode parameter the offline acction can be controlled:
'     DO_NOTHING       Don't modify the analog output channel
'     USE_INIT_VALUE   Use Initial value after offline
'     USE_VALUE        Use defined value after offline
'
'      In :  DP            DoPE link handle
'            BitOutputNo   Number of analogue output channel
'            Mode          Mode flag (see above)
'            Value         Output value used in USE_VALUE mode in % of max. value
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOGripEnable Lib "dope.dll" Alias "DoPEIOGripEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOGripEnableSync Lib "dope.dll" Alias "DoPEIOGripEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOGripEnableSync( DoPE_HANDLE  Hdl,
'                                                  unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOGripEnable( DoPE_HANDLE  Hdl,
'                                              unsigned     Enable,
'                                              WORD        *lpusTAN );
'
'    /*
'    Enable or disable grip IO handling.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Enable     !=0  enables
'                        0    disables grip IO handling
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Public Const IO_GRIP_UPPER = &H1
Public Const IO_GRIP_LOWER = &H2
Public Const IO_GRIP_BOTH = &H3

Public Const IO_GRIP_ACTION_OPEN = &H1
Public Const IO_GRIP_ACTION_CLOSE = &H2
Public Const IO_GRIP_ACTION_HIGH_PRESSURE1 = &H4
Public Const IO_GRIP_ACTION_HIGH_PRESSURE2 = &H8

Declare Function DoPEVBIOGripSet Lib "dope.dll" Alias "DoPEIOGripSet" (ByVal DoPEHdl As Long, ByVal Grip As Long, ByVal Action As Long, ByVal Pressure As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOGripSetSync Lib "dope.dll" Alias "DoPEIOGripSetSync" (ByVal DoPEHdl As Long, ByVal Grip As Long, ByVal Action As Long, ByVal Pressure As Double) As Long

'  extern  unsigned  DLLAPI  DoPEIOGripSetSync( DoPE_HANDLE  Hdl,
'                                               unsigned     Grip,
'                                               unsigned     Action,
'                                               double       Pressure );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOGripSet( DoPE_HANDLE     Hdl,
'                                           unsigned        Grip,
'                                           unsigned        Action,
'                                           double          Pressure,
'                                           unsigned short *lpusTAN );
'
'    /*
'    Perform a grip action.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Grip       Grip to use
'                        (use IO_GRIP_ defines)
'             Action     Action to perform
'                        (use IO_GRIP_ACTION_ defines)
'             Pressure   Pressure to be applied [%]
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOGripPressure Lib "dope.dll" Alias "DoPEIOGripPressure" (ByVal DoPEHdl As Long, ByVal LowPressure As Double, ByVal HighPressure As Double, ByVal RampTime As Double, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOGripPressureSync Lib "dope.dll" Alias "DoPEIOGripPressureSync" (ByVal DoPEHdl As Long, ByVal LowPressure As Double, ByVal HighPressure As Double, ByVal RampTime As Double) As Long

'  extern  unsigned  DLLAPI  DoPEIOGripPressureSync( DoPE_HANDLE  Hdl,
'                                                    double       LowPressure,
'                                                    double       HighPressure,
'                                                    double       RampTime );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOGripPressure( DoPE_HANDLE  Hdl,
'                                                double       LowPressure,
'                                                double       HighPressure,
'                                                double       RampTime,
'                                                WORD        *lpusTAN );
'
'    /*
'    Set grip parameter.
'
'
'      In :  *DoPEHdl      Pointer to DoPE link handle
'             LowPressure  Low pressure value [%]
'             HighPressure Low pressure value [%]
'             RampTime     Time to switch between low and high pressure  [s]
'
'      Out :
'            *lpusTAN      Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOExtEnable Lib "dope.dll" Alias "DoPEIOExtEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOExtEnableSync Lib "dope.dll" Alias "DoPEIOExtEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOExtEnableSync( DoPE_HANDLE  Hdl,
'                                                 unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI DoPEIOExtEnable( DoPE_HANDLE     Hdl,
'                                            unsigned        Enable,
'                                            unsigned short *lpusTAN );
'
'    /*
'    Enable or disable extensometer IO handling.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Enable     !=0  enables
'                        0    disables extensometer IO handling
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/

Public Const IO_EXT_UPPER = &H1
Public Const IO_EXT_LOWER = &H2
Public Const IO_EXT_BOTH = &H3

Public Const IO_EXT_ACTION_OPEN = &H1
Public Const IO_EXT_ACTION_CLOSE = &H2

Declare Function DoPEVBIOExtSet Lib "dope.dll" Alias "DoPEIOExtSet" (ByVal DoPEHdl As Long, ByVal Ext As Long, ByVal Action As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOExtSetSync Lib "dope.dll" Alias "DoPEIOExtSetSync" (ByVal DoPEHdl As Long, ByVal Ext As Long, ByVal Action As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOExtSetSync( DoPE_HANDLE  Hdl,
'                                              unsigned     Ext,
'                                              unsigned     Action );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOExtSet( DoPE_HANDLE     Hdl,
'                                          unsigned        Ext,
'                                          unsigned        Action,
'                                          unsigned short *lpusTAN );
'
'    /*
'    Perform a extensometer action.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Grip       Grip to use
'                        (use IO_EXT_ defines)
'             Action     Action to perform
'                        (use IO_EXT_ACTION_ defines)
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOFixedXHeadEnable Lib "dope.dll" Alias "DoPEIOFixedXHeadEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOFixedXHeadEnableSync Lib "dope.dll" Alias "DoPEIOFixedXHeadEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOFixedXHeadEnableSync( DoPE_HANDLE  Hdl,
'                                                        unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOFixedXHeadEnable( DoPE_HANDLE     Hdl,
'                                                    unsigned        Enable,
'                                                    unsigned short *lpusTAN );
'
'    /*
'    Enable or disable fixed cross head IO handling.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Enable     !=0  enables
'                        0    disables fixed cross head IO handling
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOFixedXHeadSet Lib "dope.dll" Alias "DoPEIOFixedXHeadSet" (ByVal DoPEHdl As Long, ByVal Direction As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOFixedXHeadSetSync Lib "dope.dll" Alias "DoPEIOFixedXHeadSetSync" (ByVal DoPEHdl As Long, ByVal Direction As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOFixedXHeadSetSync( DoPE_HANDLE  Hdl,
'                                                     unsigned     Direction );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOFixedXHeadSet( DoPE_HANDLE     Hdl,
'                                                 unsigned        Direction,
'                                                 unsigned short *lpusTAN );
'
'    /*
'    Move fixed cross head.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Direction  Direction of movement
'                        (use MOVE_HALT, MOVE_UP, MOVE_DOWN defines)
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOHighPressureEnable Lib "dope.dll" Alias "DoPEIOHighPressureEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOHighPressureEnableSync Lib "dope.dll" Alias "DoPEIOHighPressureEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOHighPressureEnableSync( DoPE_HANDLE  Hdl,
'                                                          unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOHighPressureEnable( DoPE_HANDLE     Hdl,
'                                                      unsigned        Enable,
'                                                      unsigned short *lpusTAN );
'
'    /*
'    Enable or disable high pressure IO handling.
'
'
'      In :  *DoPEHdl    Pointer to DoPE link handle
'             Enable     !=0  enables
'                        0    disables high pressure IO handling
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*---------------------------------------------------------------------------*/
'
Declare Function DoPEVBIOHighPressureSet Lib "dope.dll" Alias "DoPEIOHighPressureSet" (ByVal DoPEHdl As Long, ByVal HighPressure As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBIOHighPressureSetSync Lib "dope.dll" Alias "DoPEIOHighPressureSetSync" (ByVal DoPEHdl As Long, ByVal HighPressure As Long) As Long

'  extern  unsigned  DLLAPI  DoPEIOHighPressureSetSync( DoPE_HANDLE  Hdl,
'                                                       unsigned     HighPressure );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
'
'  extern  unsigned  DLLAPI  DoPEIOHighPressureSet( DoPE_HANDLE  Hdl,
'                                                   unsigned     HighPressure );
'
'    /*
'    Set high or low pressure.
'
'
'      In :  *DoPEHdl      Pointer to DoPE link handle
'             HighPressure !=0  selects high pressure
'                          0    selects low pressure
'
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'// -----------------------------------------------------------------------------
'
Declare Function DoPEVBSendDebugCommand Lib "dope.dll" Alias "DoPESendDebugCommand" (ByVal DoPEHdl As Long, ByVal Text As String, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBSendDebugCommandSync Lib "dope.dll" Alias "DoPESendDebugCommandSync" (ByVal DoPEHdl As Long, ByVal Text As String) As Long

'  extern  unsigned  DLLAPI  DoPESendDebugCommandSync  ( DoPE_HANDLE  DoPEHdl,
'                                                        char        *Text );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
'
'  extern  unsigned  DLLAPI  DoPESendDebugCommand  ( DoPE_HANDLE  DoPEHdl,
'                                                    char        *Text,
'                                                    WORD        *lpusTAN );
'
'
'    /*
'    Send a debug command to the EDC.
'
'      In :  DoPEHdl       DoPE link handle
'            Text          Pointer to zero terminated text to transmit
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'// -----------------------------------------------------------------------------
'
Declare Function DoPEVBDebugMsgEnable Lib "dope.dll" Alias "DoPEDebugMsgEnable" (ByVal DoPEHdl As Long, ByVal Enable As Long, ByRef lpusTAN As Integer) As Long
Declare Function DoPEVBDebugMsgEnableSync Lib "dope.dll" Alias "DoPEDebugMsgEnableSync" (ByVal DoPEHdl As Long, ByVal Enable As Long) As Long

'  extern  unsigned  DLLAPI  DoPEDebugMsgEnableSync  ( DoPE_HANDLE  DoPEHdl,
'                                                      unsigned     Enable );
'
'/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
'
'  extern  unsigned  DLLAPI  DoPEDebugMsgEnable  ( DoPE_HANDLE  DoPEHdl,
'                                                  unsigned     Enable,
'                                                  WORD        *lpusTAN );
'
'
'    /*
'    Enable/disable debug messages from the EDC.
'
'      In :  DoPEHdl       DoPE link handle
'            Enable        !=0  enables
'                          0    disables debug messages
'      Out :
'           *lpusTAN       Pointer to TAN used from this command
'
'      Returns:            Error constant (DoPERR_xxxx)
'    */
'
'
'// -----------------------------------------------------------------------------































'/* -------------------------------------------------------------------------- */
'/* ----- Old definitions (don't use for new designs) ------------------------ */
'
'/* ----- Messages of   DoPE      ------------------------------------------- */
'
Public Const COMMAND_ERROR = 200            ' Command error codes
Public Const RUNTIME_ERROR = 201            ' Run time error codes
Public Const MOVE_CTRL_MSG = 202            ' Movement control messages
Public Const RAW_SUB_MSG = 203              ' Raw messages from subsystem
Public Const SENSOR_MSG = 204               ' Sensor message

Type MsgHeader                         ' Common header part
  MsgType As Integer                   ' Message type
  usTAN   As Integer                   ' Transactionnumber
End Type

Type DoPECE                            ' Command error
  Type          As MsgHeader           ' Common header part
  CommandNumber As Integer             ' Number of command
  ErrorNumber   As Integer             ' Number of error
End Type



Type SubRTErr                          ' Run time error short format (SUB)
  Time   As Double                     ' System time the error occurred
  Device As Integer                    ' Device Number responsible for the err
  Bits   As Integer                    ' Responsible bits if digital input dev
End Type

Public Const SubRTErrRawLenght = 131   ' Data lenght of SubRTErrRaw
Public Const DoPERTErrLenght = SubRTErrRawLenght + 2 ' Data lenght of DoPERTErr

Type SubRTErrRaw                       ' Run time error unscaled (SUB)
  Data(SubRTErrRawLenght - 1) As Byte  ' DPXMSGLEN-Typ-usTAN-ErrorNumber bytes
End Type

Type DoPERTErr                         ' Run time error
  ErrorNumber As Integer               ' Common number of run time error
  SubRaw      As SubRTErrRaw           ' RTE directly from the SUB unscaled
End Type

'/* in future DoPE versions detailed RTErr structures will be placed here */

'  /* The DoPERTE structure is kept for compatibility to old DoPE versions     */
'  /* Use DoPERTErr for detailed runtime error mechanism                       */
Type DoPERTE                           ' Run time error
  Type        As MsgHeader             ' Common header part
  ErrorNumber As Integer               ' Number of run time error
  Time        As Double                ' System time the error occurred
  Device      As Integer               ' Device Number responsible for the err
  Bits        As Integer               ' Responsible bits if digital input dev
End Type

Type DoPEMCM                           ' Messages of movement control
  Type        As MsgHeader             ' Common header part
  MsgId       As Integer               ' ID of message
  Time        As Double                ' System time for the message
  Control     As Integer               ' Control mode of position
  Position    As Double                ' Position
  DControl    As Integer               ' Control mode of destination position
  Destination As Double                ' Destination position
End Type

Type DoPESftM                          ' 'Softend' Message
  Type        As MsgHeader             ' Common header part
  MsgId       As Integer               ' ID of message
  Time        As Double                ' System time for the message
  Control     As Integer               ' Control mode of position
  Position    As Double                ' Position
End Type

Type DoPEOffsCM                        ' 'Offset-Correction' Message
  Type        As MsgHeader             ' Common header part
  MsgId       As Integer               ' ID of message
  Time        As Double                ' System time for the message
  Offset      As Double                ' Power Amplifier Offset
End Type

Type DoPECheckM                        ' 'Measuring Channel Supervision' Msg
  Type        As MsgHeader             ' Common header part
  MsgId       As Integer               ' ID of message
  Time        As Double                ' System time for the message
  CheckId     As Integer               ' ID of Measuring Channel Check
  Position    As Double                ' Position
  SensorNo    As Integer               ' Supervised sensor
End Type

' Not implemented in Visual Basic DoPE interface !
'  typedef  struct  DoPERawSubMsg      /* 'Raw Sub' Message                    */
'    {                                 /* ------------------------------------ */
'    Header             TypSub;        /* Sub header                           */
'    BYTE               Data[128];     /* Sub message in raw binary format     */
'    } DoPERawM;

Type DoPERefSignalM                    ' Reference Signal Message
  MsgId    As Integer                  ' ID of message
  Time     As Double                   ' System time for the message
  SensorNo As Integer                  ' Control mode of position
  Position As Double                   ' Position
End Type

Public Const SENSOR_MSG_LEN = 80

Type DoPESensorM                       ' Sensor Message
  Time     As Double                   ' System time for the message
  SensorNo As Integer                  ' Sensor Number SENSOR_S .. SENSOR_15
  Length   As Integer                  ' Number of bytes in the message
  Data(SENSOR_MSG_LEN - 1) As Byte     ' Message
End Type

Public Const DoPEMsgLen = 204          ' max. SUB message length

Type DoPEMsg                           ' Messages SUB -> PC
  Type As MsgHeader                    ' Common header part
  Usr(DoPEMsgLen - 4) As Byte          ' Message specific parts
End Type


'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBSetNotification Lib "dope.dll" Alias "DoPESetNotification" (ByVal DoPEHdl&, ByVal EventMask&, ByVal NotifyProc&, ByVal NotifyWnd&, ByVal NotifyMsg&) As Long

'  extern  unsigned  DLLAPI  DoPESetNotification  ( DoPE_HANDLE  DoPEHdl,
'                                                   unsigned    EventMask,
'                                                   NPROC      *NotifyProc,
'                                                   HWND        NotifyWnd,
'                                                   UINT        NotifyMsg );
'
'    /*
'    Set parameters for DoPE notification callback.
'
'      In :  DoPEHdl     DoPE link handle
'            EventMask   Events for Notification. (Or'ed DPXEVT_xx constants)
'            NotifyProc  Notification callback.
'            NotifyWnd   Reference data: Window handle to pass to callback
'            NotifyMsg   Reference data: Message-Nummer to pass to callback
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
'Declare Function DoPEVBSendMsg Lib "dopevb.dll" (ByVal DoPEHdl&, Buffer As DoPEMsg, ByVal Length&, lpusTAN%) As Long
'Declare Function DoPEVBSendMsgSync Lib "dopevb.dll" (ByVal DoPEHdl&, Buffer As DoPEMsg, ByVal Length&) As Long
'  This command is not implemented in Visual Basic DoPE interface !
'
'  extern  unsigned  DLLAPI  DoPESendMsg  ( DoPE_HANDLE   DoPEHdl,
'                                           void FAR   *Buffer,
'                                           unsigned    Length,
'                                           WORD   FAR *lpusTAN );
'
'    /*
'    Send a message to EDC.
'    This function is only needed if you have to communicate directly to EDC's
'    Subsystem. The message sent must be a command to the subsystem. Refer
'    Documentation Subsystem for Test Machine Control.
'
'      In :  DoPEHdl     DoPE link handle
'            Buffer      Pointer to message to transmit
'            Length      Message length in bytes
'
'      Out :
'           *lpusTAN     Pointer to TAN used from this command
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBGetMsg Lib "dopevb.dll" (ByVal DoPEHdl&, Buffer&, ByVal BufSize&, Length&) As Long

'  extern  unsigned  DLLAPI  DoPEGetMsg  ( DoPE_HANDLE   DoPEHdl,
'                                          void FAR     *Buffer,
'                                          unsigned      BufSize,
'                                          unsigned FAR *Length   );
'
'    /*
'    Get message from receiver buffer.
'    Messages received from the EDC are stored inside DoPE. You can read a stored
'    message with this command.
'
'      In :  DoPEHdl     DoPE link handle
'            Buffer      Pointer to storage for message
'            BufSize     Size of storage in bytes
'            Length      Pointer to storage for message length
'
'      Out:  *Buffer     Message
'            *Length     Message length in bytes
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/* -------------------------------------------------------------------------- */
'
Declare Function DoPEVBPosG1 Lib "dope.dll" Alias "DoPEPosG1" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosG1Sync Lib "dope.dll" Alias "DoPEPosG1Sync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosG1    ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Speed,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Default acceleration and deceleration will be used.
'    After destination or the absolute limit position has been reached,
'    a message will be transmitted.
'    This command will not change control mode after the destination is reached.
'
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Speed       Speed for positioning
'            Limit       absolute limit position
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosG1_A Lib "dope.dll" Alias "DoPEPosG1_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DecDest#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosG1_ASync Lib "dope.dll" Alias "DoPEPosG1_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DecDest#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosG1_A  ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          DecLimit,
'                                           double          Limit,
'                                           double          DecDest,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Acceleration and deceleration are parameters of the command.
'    After destination or the absolute limit position has been reached,
'    a message will be transmitted.
'    This command will not change control mode after the destination is reached.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Acc         Acceleration
'            Speed       Speed for positioning
'            DecLimit    Deceleration for limit position
'            Limit       absolute limit position
'            DecDest     Deceleration for final destination
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosD1 Lib "dope.dll" Alias "DoPEPosD1" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosD1Sync Lib "dope.dll" Alias "DoPEPosD1Sync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosD1    ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Speed,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Default acceleration and deceleration will be used.
'    After destination or the relative limit position has been reached,
'    a message will be transmitted.
'    This command will not change control mode after the destination is reached.
'
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Speed       Speed for positioning
'            Limit       relative limit position (e.g. current position + 10)
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosD1_A Lib "dope.dll" Alias "DoPEPosD1_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DecDest#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosD1_ASync Lib "dope.dll" Alias "DoPEPosD1_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DecDest#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosD1_A  ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          DecLimit,
'                                           double          Limit,
'                                           double          DecDest,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Acceleration and deceleration are parameters of the command.
'    After destination or the relative limit position has been reached,
'    a message will be transmitted.
'    This command will not change control mode after the destination is reached.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Acc         Acceleration
'            Speed       Speed for positioning
'            DecLimit    Deceleration for limit position
'            Limit       relative limit position (e.g current position + 10)
'            DecDest     Deceleration for final destination
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosG2 Lib "dope.dll" Alias "DoPEPosG2" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosG2Sync Lib "dope.dll" Alias "DoPEPosG2Sync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosG2    ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Speed,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Default acceleration and deceleration will be used.
'    After destination or the absolute limit position has been reached,
'    a message will be transmitted.
'    This command will change control mode before the destination is reached
'    and positions exactly.
'
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Speed       Speed for positioning
'            Limit       absolute limit position
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosG2_A Lib "dope.dll" Alias "DoPEPosG2_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DestCtrl%, ByVal DecDest#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosG2_ASync Lib "dope.dll" Alias "DoPEPosG2_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DestCtrl%, ByVal DecDest#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosG2_A  ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          DecLimit,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          DecDest,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Acceleration and deceleration are parameters of the command.
'    After destination or the absolute limit position has been reached,
'    a message will be transmitted.
'    This command will change control mode before the destination is reached
'    and positions exactly.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Acc         Acceleration
'            Speed       Speed for positioning
'            DecLimit    Deceleration for limit position
'            Limit       absolute limit position
'            DecDest     Deceleration for final destination
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosD2 Lib "dope.dll" Alias "DoPEPosD2" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosD2Sync Lib "dope.dll" Alias "DoPEPosD2Sync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Speed#, ByVal Limit#, ByVal DestCtrl%, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosD2    ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Speed,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Default acceleration and deceleration will be used.
'    After destination or the relative limit position has been reached,
'    a message will be transmitted.
'    This command will change control mode before the destination is reached
'    and positions exactly.
'
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Speed       Speed for positioning
'            Limit       relative limit position (e.g current position + 10)
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'      Returns:          Error constant (DoPERR_xxxx)
'    */
'
'/*--------------------------------------------------------------------------*/
'
Declare Function DoPEVBPosD2_A Lib "dope.dll" Alias "DoPEPosD2_A" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DestCtrl%, ByVal DecDest#, ByVal Destination#, lpusTAN%) As Long
Declare Function DoPEVBPosD2_ASync Lib "dope.dll" Alias "DoPEPosD2_ASync" (ByVal DoPEHdl&, ByVal MoveCtrl%, ByVal Acc#, ByVal Speed#, ByVal DecLimit#, ByVal Limit#, ByVal DestCtrl%, ByVal DecDest#, ByVal Destination#, lpusTAN%) As Long
'  extern  unsigned  DLLAPI  DoPEPosD2_A  ( DoPE_HANDLE     DoPEHdl,
'                                           unsigned short  MoveCtrl,
'                                           double          Acc,
'                                           double          Speed,
'                                           double          DecLimit,
'                                           double          Limit,
'                                           unsigned short  DestCtrl,
'                                           double          DecDest,
'                                           double          Destination );
'
'    /*
'    Move crosshead in the specified control mode and speed to the given
'    destination. Destination may be different to move control.
'    Acceleration and deceleration are parameters of the command.
'    After destination or the relative limit position has been reached,
'    a message will be transmitted.
'    This command will change control mode before the destination is reached
'    and positions exactly.
'
'      In :  DoPEHdl     DoPE link handle
'            MoveCtrl    Control mode for positioning
'            Acc         Acceleration
'            Speed       Speed for positioning
'            DecLimit    Deceleration for limit position
'            Limit       relative limit position (e.g current position + 10)
'            DecDest     Deceleration for final destination
'            DestCtrl    Channel definition for destination
'            Destination Final destination
'
'
'      Returns:          Error constant (DoPERR_xxxx)
'
'    */
'
