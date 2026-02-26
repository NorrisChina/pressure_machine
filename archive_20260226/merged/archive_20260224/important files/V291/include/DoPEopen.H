/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface setup and open link handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

  HEG 26.11.10 - 2.73
  - BaudRate parameter added to DoPE_PORTINFO struct.

*******************************************************************************/


#ifndef DoPEopen_INCLUDED
#define DoPEopen_INCLUDED

  #include <DoPEinfo.h>                  // DoPEModuleInfo
  

  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/*------------ Communication port definitions --------------------------------*/

  #define DoPEPORT_COM            0      /* COM port start value              */
                                         /* COMx:Number=x-1(max.COM256)       */

  #define DoPEPORT_USB ((DWORD)0x100)    /* USB port start value              */
                                         /* USBx:Number=x-0x100 (USB0..255)   */

  #define DoPEPORT_LAN ((DWORD)0x200)    /* LAN port start value              */
                                         /* LANx:Number=x-0x200 (NIC0..254)   */
                                         /* LAN255 is used by DoPE internaly! */

  #define DoPE_PORTNAMELEN        80     /* Max. port name length in bytes    */
                                         /* (including terminating zero '\0') */

#if !defined MACdefined
  typedef struct { BYTE a[6]; } MAC;     /* MAC Address                       */
#define MACdefined
#endif

  typedef struct
  {
    DWORD     Ix;                        /* Device index                      */
    char      Name[DoPE_PORTNAMELEN];    /* Device name                       */
    DWORD     ComPort;                   /* COM port                          */
    DWORD     BaudRate;                  /* Baudrate    (DoPEPORT_COM only)   */
    MAC       NicMAC;                    /* NIC address (DoPEPORT_LAN only)   */
  } DoPE_PORTINFO;

  typedef struct
  {
    DWORD     Ix;                        /* Device index                      */
    wchar_t   Name[DoPE_PORTNAMELEN];    /* Device name                       */
    DWORD     ComPort;                   /* COM port                          */
    DWORD     BaudRate;                  /* Baudrate    (DoPEPORT_COM only)   */
    MAC       NicMAC;                    /* NIC address (DoPEPORT_LAN only)   */
  } DoPE_wPORTINFO;


  extern  unsigned  DLLAPI  DoPEPortInfo ( unsigned       Port,
                                           unsigned       First,
                                           DoPE_PORTINFO *pPortInfo );
  extern  unsigned  DLLAPI  DoPEwPortInfo ( unsigned        Port,
                                            unsigned        First,
                                            DoPE_wPORTINFO *pPortInfo );

    /*
    Get the port info.

      In :  Port        Port class (DoPEPORT_COM, DoPEPORT_USB or DoPEPORT_LAN)
            First       != 0: get the first port information
                        == 0: get the next port information
            pPortInfo   pointer to port info structure

      Returns:          Error constant (DoPERR_xxxx)
                        (DoPERR_BADPORT if no more port info is available)
    */


  extern  unsigned  DLLAPI  DoPECurrentPortInfo ( DoPE_HANDLE DoPEHdl,
                                                  DoPE_PORTINFO *pPortInfo );
  extern  unsigned  DLLAPI  DoPEwCurrentPortInfo ( DoPE_HANDLE DoPEHdl,
                                                   DoPE_wPORTINFO *pPortInfo );

    /*
    Get the current port info of a link.

      In :  DoPEHdl     DoPE link handle
            pPortInfo   pointer to port info structure

      Returns:          Error constant (DoPERR_xxxx)
    */

/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEDefineNIC ( unsigned Port,  MAC *pMAC );

    /*
    Assign a NIC to a DoPE port.

      In :  Port        Port number (DoPEPORT_LAN+x)
            pMAC        Pointer to NIC's MAC address. A NULL pointer removes
                        the assignment.

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEIgnoreTcpIpNIC ( unsigned Enable );

    /*
    For faster port scanning NIC's with TCP/IP protocol can be ignored in
    DpxPortInfo, DpxDefineNIC and DpxOpenLink calls.

      In :  Enable      true:  ignore NIC's with TCP/IP protocol
                        false: include NIC's with TCP/IP protocol to port scan (Default)

      Returns:          old Enable state
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEOpenLink  ( unsigned     Port,
                                            unsigned     PortParam,
                                            unsigned     RcvBuffers,
                                            unsigned     XmitBuffers,
                                            unsigned     DataBuffers,
                                            unsigned     APIVersion,
                                            void        *Reserved,
                                            DoPE_HANDLE *DoPEHdl );

    /*
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
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEOpenDeviceID    ( unsigned     Id,
                                                  unsigned     RcvBuffers,
                                                  unsigned     XmitBuffers,
                                                  unsigned     DataBuffers,
                                                  unsigned     APIVersion,
                                                  void        *Reserved,
                                                  DoPE_HANDLE *DoPEHdl );

  extern  unsigned  DLLAPI  DoPEOpenFunctionID  ( unsigned     Id,
                                                  unsigned     RcvBuffers,
                                                  unsigned     XmitBuffers,
                                                  unsigned     DataBuffers,
                                                  unsigned     APIVersion,
                                                  void        *Reserved,
                                                  DoPE_HANDLE *DoPEHdl );

    /*
    Open the given DoPE link with a matching device or function ID.
    All communication ports are scanned, starting with DoPEPORT_USB.
    LAN ports of the PC are included to the scan.
    The link parameters are set and the link is established.
    If the function returns DoPERR_TIMEOUT, connection to the EDC did not
    go online. You must connect the EDC, switch it on and try the open function
    again.
    This function is available for USB and LAN connections only.

      In :  Port        Port number (DoPEPORT_xx)
            Id          EDC device ID or function ID
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
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPECloseLink  ( DoPE_HANDLE *DoPEHdl );

    /*
    Close down the given DoPE link.

      In :  *DoPEHdl    Pointer to DoPE link handle

      Out:  *DoPEHdl    Invalidated DoPE link handle (set to NULL)

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  typedef struct
  {
    DoPE_HANDLE    DoPEHdl;
    unsigned       PortType;               /* DoPEPORT_USB or DoPEPORT_LAN    */
    DoPE_PORTINFO  PortInfo;
    DoPEModuleInfo ModuleInfo;
  } DoPEOpenLinkInfo;

  typedef struct
  {
    DoPE_HANDLE     DoPEHdl;
    unsigned        PortType;              /* DoPEPORT_USB or DoPEPORT_LAN    */
    DoPE_wPORTINFO  PortInfo;
    DoPEwModuleInfo ModuleInfo;
  } DoPEwOpenLinkInfo;

  extern  unsigned  DLLAPI  DoPEOpenAll  ( unsigned         RcvBuffers,
                                           unsigned         XmitBuffers,
                                           unsigned         DataBuffers,
                                           unsigned         APIVersion,
                                           void            *Reserved,
                                           unsigned         InfoTableMaxEntries,
                                           unsigned        *InfoTableValidEntries,
                                           DoPEOpenLinkInfo InfoTable[] );

  extern  unsigned  DLLAPI  DoPEwOpenAll  ( unsigned          RcvBuffers,
                                            unsigned          XmitBuffers,
                                            unsigned          DataBuffers,
                                            unsigned          APIVersion,
                                            void             *Reserved,
                                            unsigned          InfoTableMaxEntries,
                                            unsigned         *InfoTableValidEntries,
                                            DoPEwOpenLinkInfo InfoTable[] );

    /*
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
            InfoTable              Info table containing valid entries for all
                                   opened links.

      Returns:          Error constant (DoPERR_xxxx)
    */


  extern  unsigned  DLLAPI  DoPECloseAll  ( unsigned         InfoTableValidEntries,
                                            DoPEOpenLinkInfo InfoTable[] );

  extern  unsigned  DLLAPI  DoPEwCloseAll  ( unsigned          InfoTableValidEntries,
                                             DoPEwOpenLinkInfo InfoTable[] );

    /*
    Close all DoPE links previously opened by DoPEOpenAll.
    
      In :  InfoTableValidEntries  Number of valid entries in the info table.
            InfoTable              Info table containing valid DoPE handles for
                                   all links to close

      Out :
            InfoTable              Info table with all DoPE handles set to NULL

      Returns:          Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
