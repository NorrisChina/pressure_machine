/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface info handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEinfo_INCLUDED
#define DoPEinfo_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*--------------------------------------------------------------------------*/

    #define PEINTERFACE_LEN    6       /* 'PE interface EDC VERSION' length  */
    #define APPLICATION_LEN    13      /* 'EDC appl. version'        length  */
    #define SUBSY_LEN          6       /* 'Subsystem version'        length  */
    #define SUBSYCUSTVER_LEN   6       /* 'Subsystem customer version' length  */
    #define SUBSYCUSTNAME_LEN  9       /* 'Subsystem customer name'  length  */
    #define BIOS_LEN           6       /* 'EDC BIOS version'         length  */
    #define HWCTRL_LEN         7       /* 'EDC controller hardware no' length  */
    #define PEINTERFACEPC_LEN  6       /* 'PE interface PC Version'  length  */
    #define DPXVER_LEN         6       /* 'DPX version'              length  */
    #define SERIALNUMBER_LEN   17      /* 'EDC serial number'        length  */
                                       /* all including terminating zero '\0'*/

#pragma pack (1)

  typedef struct                       /* Read version                       */
  {                                    /* ---------------------------------- */
    char PeInterface[6];               /* PE interface EDC VERSION    "xx.xx"*/
    char Application[13];              /* EDC appl. version    "xxxxxxxx.xxx"*/
    char Subsy[6];                     /* Subsystem version           "xx.xx"*/
    char SubsyCustVer[6];              /* Subsystem customer version  "xx.xx"*/
    char SubsyCustName[9];             /* Subsystem customer name  "xxxxxxxx"*/
    char Bios[6];                      /* EDC BIOS version            "xx.xx"*/
    char HwCtrl[7];                    /* EDC controller hardware no "xxxx.x"*/
    char PeInterfacePC[6];             /* PE interface PC Version     "xx.xx"*/
    char DpxVer[6];                    /* DPX version                 "xx.xx"*/
    char SerialNumber[17];             /* EDC serial number"xxxxxxxxxxxxxxxx"*/
                                       /* Strings are zero terminated '\0'   */
  } DoPEVersion;
  
  typedef struct                       /* Read version                       */
  {                                    /* ---------------------------------- */
    wchar_t PeInterface[6];            /* PE interface EDC VERSION    "xx.xx"*/
    wchar_t Application[13];           /* EDC appl. version    "xxxxxxxx.xxx"*/
    wchar_t Subsy[6];                  /* Subsystem version           "xx.xx"*/
    wchar_t SubsyCustVer[6];           /* Subsystem customer version  "xx.xx"*/
    wchar_t SubsyCustName[9];          /* Subsystem customer name  "xxxxxxxx"*/
    wchar_t Bios[6];                   /* EDC BIOS version            "xx.xx"*/
    wchar_t HwCtrl[7];                 /* EDC controller hardware no "xxxx.x"*/
    wchar_t PeInterfacePC[6];          /* PE interface PC Version     "xx.xx"*/
    wchar_t DpxVer[6];                 /* DPX version                 "xx.xx"*/
    wchar_t SerialNumber[17];          /* EDC serial number"xxxxxxxxxxxxxxxx"*/
                                       /* Strings are zero terminated '\0'   */
  } DoPEwVersion;

#pragma pack()


  extern  unsigned  DLLAPI  DoPERdVersion ( DoPE_HANDLE  DoPEHdl,
                                            DoPEVersion *Version);
  extern  unsigned  DLLAPI  DoPEwRdVersion ( DoPE_HANDLE   DoPEHdl,
                                             DoPEwVersion *Version);

    /*
    Read Version strings.

      In :  DoPEHdl     DoPE link handle
            Version     Version strings

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define MODINFO_NAME_LEN  80         /* maximum length of module name      */
                                       /* (including terminating zero '\0')  */
  
                                       /* Constants  for 'status'            */
                                       /* -----------------------            */
  #define  MODSTAT_OK              0   /* Module is ready to operate         */
  #define  MODSTAT_HWFAIL          3   /* Hardware error on module           */
  #define  MODSTAT_NOMODULE        6   /* Module not present                 */
  #define  MODSTAT_NODRIVER        9   /* No driver for module               */
  #define  MODSTAT_REMOTE         10   /* Remote-Module                      */
  #define  MODSTAT_SWFAIL     0xFFFF   /* Error in  Module-driver-software   */

#pragma pack (1)

  typedef struct                       /* Definition of module info          */
  {                                    /* ---------------------------------- */
    DWORD  ID;                         /* Module hardware ID             [No]*/
    DWORD  Revision;                   /* Module hardware revision       [No]*/
    DWORD  DeviceID;                   /* Device ID                      [No]*/
    DWORD  FunctionID;                 /* Function ID (from MachineDef)  [No]*/
    DWORD  SerNr;                      /* Serial number                  [No]*/
    DWORD  Status;                     /* Module status                  [No]*/
    char   Name[MODINFO_NAME_LEN];     /* Module name (e.g. "2INC 1742.000(-)") */
  } DoPEModuleInfo;
  
  typedef struct                       /* Definition of module info          */
  {                                    /* ---------------------------------- */
    DWORD   ID;                        /* Module hardware ID             [No]*/
    DWORD   Revision;                  /* Module hardware revision       [No]*/
    DWORD   DeviceID;                  /* Device ID                      [No]*/
    DWORD   FunctionID;                /* Function ID (from MachineDef)  [No]*/
    DWORD   SerNr;                     /* Serial number                  [No]*/
    DWORD   Status;                    /* Module status                  [No]*/
    wchar_t Name[MODINFO_NAME_LEN];    /* Module name (e.g. "2INC 1742.000(-)") */
  } DoPEwModuleInfo;

#pragma pack()


  extern  unsigned  DLLAPI  DoPERdModuleInfo ( DoPE_HANDLE     DoPEHdl,
                                               unsigned        ModulNo,
                                               DoPEModuleInfo *Info );

  extern  unsigned  DLLAPI  DoPEwRdModuleInfo ( DoPE_HANDLE      DoPEHdl,
                                                unsigned         ModulNo,
                                                DoPEwModuleInfo *Info );

    /*
    Read module info.

      In :  DoPEHdl     DoPE link handle                            
            ModuleNo    Module number ( 0 .. MAX_MODULE-1 )
            Info        Pointer to storage for the module info

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define MAX_NOMV  4                  /* maximum number of nom. voltages    */
  #define DRIVEINFO_NAME_LEN  80       /* maximum length of drive name       */
                                       /* (including terminating zero '\0')  */
  
#pragma pack (1 )

  typedef struct                       /* Definition of drive info           */
  {                                    /* ---------------------------------- */
    DWORD  ID;                         /* Drive hardware ID              [No]*/
    DWORD  Revision;                   /* Drive hardware revision        [No]*/
    DWORD  SerNr;                      /* Serial number                  [No]*/
    double NominalCurrent;             /* Nominal current                 [A]*/
    double MinCurrent;                 /* Minimum current                 [A]*/
    double MaxCurrent;                 /* Maximum current                 [A]*/
    double MaxCurrentTime;             /* Maximum current time (I²t)      [s]*/
    int    NominalVoltageCount;        /* Number of nominal voltages     [No]*/
    double NominalVoltage[MAX_NOMV];   /* Nominal voltage                 [V]*/
    double MaxPower;                   /* Maximum power                   [W]*/
    double FeedbackPower;              /* Average feedback power          [W]*/
    double MinDither;                  /* Minimum dither frequency       [Hz]*/
    double MaxDither;                  /* Maximum dither frequency       [Hz]*/
    double CurrentControllerCycle;     /* Current controller cycle time   [s]*/
                                       /* (0 = analogue or not adjustable)   */
    char   Name[DRIVEINFO_NAME_LEN];   /* Drive name (e.g. "DC2500 1860.000(-)") */
  } DoPEDriveInfo;
  
  typedef struct                       /* Definition of drive info           */
  {                                    /* ---------------------------------- */
    DWORD   ID;                        /* Drive hardware ID              [No]*/
    DWORD   Revision;                  /* Drive hardware revision        [No]*/
    DWORD   SerNr;                     /* Serial number                  [No]*/
    double  NominalCurrent;            /* Nominal current                 [A]*/
    double  MinCurrent;                /* Minimum current                 [A]*/
    double  MaxCurrent;                /* Maximum current                 [A]*/
    double  MaxCurrentTime;            /* Maximum current time (I²t)      [s]*/
    int     NominalVoltageCount;       /* Number of nominal voltages     [No]*/
    double  NominalVoltage[MAX_NOMV];  /* Nominal voltage                 [V]*/
    double  MaxPower;                  /* Maximum power                   [W]*/
    double  FeedbackPower;             /* Average feedback power          [W]*/
    double  MinDither;                 /* Minimum dither frequency       [Hz]*/
    double  MaxDither;                 /* Maximum dither frequency       [Hz]*/
    double  CurrentControllerCycle;    /* Current controller cycle time   [s]*/
                                       /* (0 = analogue or not adjustable)   */
    wchar_t Name[DRIVEINFO_NAME_LEN];  /* Drive name (e.g. "DC2500 1860.000(-)") */
  } DoPEwDriveInfo;

#pragma pack()


  extern  unsigned  DLLAPI  DoPERdDriveInfo ( DoPE_HANDLE    DoPEHdl,
                                              WORD           Connector,
                                              DoPEDriveInfo *Info );

  extern  unsigned  DLLAPI  DoPEwRdDriveInfo ( DoPE_HANDLE     DoPEHdl,
                                               WORD            Connector,
                                               DoPEwDriveInfo *Info );

    /*
    Read drive info.

      In :  DoPEHdl     DoPE link handle                            
            Connector   Connector number of output
            Info        Pointer to storage for the drive info

      Returns:          Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define LANGINFO_NAME_LEN  30        /* maximum length of language name    */
                                       /* (including terminating zero '\0')  */
  
#pragma pack (1)

  typedef struct                       /* Definition of language info        */
  {                                    /* ---------------------------------- */
    wchar_t Name0[LANGINFO_NAME_LEN];  /* language name 0 (e.g. "English")   */
    wchar_t Name1[LANGINFO_NAME_LEN];  /* language name 1 (e.g. "German")    */
    wchar_t Name2[LANGINFO_NAME_LEN];  /* language name 2 (e.g. "Spanish")   */
    wchar_t Name3[LANGINFO_NAME_LEN];  /* language name 3 (e.g. "French")    */
  } DoPEwLanguageInfo;

#pragma pack()

  extern  unsigned  DLLAPI  DoPEwRdLanguageInfo ( DoPE_HANDLE        DoPEHdl,
                                                  DoPEwLanguageInfo *Info );

    /*
    Read language info.

      In :  DoPEHdl     DoPE link handle                            
            Info        Pointer to storage for the language info

      Returns:          Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
