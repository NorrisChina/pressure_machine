/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC rarely used expert interface

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEexpert_INCLUDED
#define DoPEexpert_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESetIoCompatibilityMode  ( DoPE_HANDLE DoPEHdl,
                                                          unsigned    Enable );
    /*
    Set the compatibility mode for bit input and output channels

      In :  *DoPEHdl    Pointer to DoPE link handle
             Enable     !=0  enables
                        0    disables compatibility mode

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

#pragma pack (1)

  typedef struct                       /* Communicatio and buffer state      */
  {                                    /* ---------------------------------- */
    DWORD     ComState;                /* Communication state                */
    DWORD     RcvBuffer;               /* Full receiver buffers              */
    DWORD     XmitBuffer;              /* Full transmitter buffers           */
  } DoPEState;

#pragma pack ()

  /* ---- Constants for ComState -------------------------------------------- */

  #define COM_STATE_OFF        0         /* Link is disabled                  */
  #define COM_STATE_OFFLINE    1         /* Link is offline                   */
  #define COM_STATE_INITCYCLE  2         /* Link is initialising              */
  #define COM_STATE_ONLINE     3         /* Link is established (OnLine)      */


  extern  unsigned  DLLAPI  DoPEGetState ( DoPE_HANDLE     DoPEHdl,
                                           DoPEState      *Status );

    /*
    Get state information structure

      In :  DoPEHdl     DoPE link handle
            Status      Pointer to storage for state information

      Out:  *Status     State information (see DoPEState definition)

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

#pragma pack (1)

  typedef  struct                      /* Error counters                     */
  {                                    /* ---------------------------------- */
    DWORD     Parity;                  /* Parity errors                      */
    DWORD     Overrun;                 /* Overrun errors                     */
    DWORD     Frame;                   /* Framing errors                     */
    DWORD     InvACK;                  /* Invalid ACKs received              */
    DWORD     NoBuffer;                /* No receiver buffer available       */
    DWORD     DLESeq;                  /* Invalid DLE sequence               */
    DWORD     BufOFlow;                /* Receiver buffer overflow           */
    DWORD     BccErr;                  /* Checksum error                     */
    DWORD     MwError;                 /* Invalid sample encoding            */
  } DoPEError;

#pragma pack ()


  extern  unsigned  DLLAPI  DoPEGetErrors  ( DoPE_HANDLE DoPEHdl,
                                             DoPEError  *Error  );

    /*
    Get current error counter values

      In :  DoPEHdl     DoPE link handle
            Error       Pointer to storage for error counters

      Out:  *Error      Current error counter values (see DoPEError)

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEClearErrors  ( DoPE_HANDLE DoPEHdl );

    /*
    Clear current error counter values

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */
/* Old Functions (don't use for new designs, use event handlers instead)      */
/* -------------------------------------------------------------------------- */

/* ----- Messages of   DoPE ------------------------------------------------- */

  #define COMMAND_ERROR        200       /* Command error codes               */
  #define RUNTIME_ERROR        201       /* Run time error codes              */
  #define MOVE_CTRL_MSG        202       /* Movement control messages         */
  #define RAW_SUB_MSG          203       /* Raw messages from subsystem       */
  #define SENSOR_MSG           204       /* Sensor message                    */

  typedef  unsigned  short  Header;


#pragma pack (1)

  typedef  struct  DoPECommandError   /* Command error                        */
  {                                   /* ------------------------------------ */
    unsigned short     CommandNumber; /* Number of command                    */
    unsigned short     ErrorNumber;   /* Number of error                      */
  } DoPECE;


#if !defined __MINGW32__
  #pragma warning( disable : 4201 )
#endif

  typedef  struct                     /* Run time error short format (SUB)    */
  {                                   /* ------------------------------------ */
    double             Time;          /* System time the error occurred       */
    unsigned short     Device;        /* Device Number responsible for the err*/
    unsigned short     Bits;          /* Responsible bits if digital input dev*/
  } SubRTErr;

  typedef  struct                     /* Run time error unscaled (SUB)        */
  {                                   /* ------------------------------------ */
    BYTE               Data[131];     /* DPXMSGLEN-Typ-usTAN-ErrorNumber Bytes*/
  } SubRTErrRaw;

  typedef  struct                     /* Run time error                       */
  {                                   /* ------------------------------------ */
    unsigned short ErrorNumber;       /* Common number of run time error      */
    union                             /* Union of all runtime errors          */
    {
      SubRTErr         Sub;           /* RTE directly from the SUB            */
      SubRTErrRaw      SubRaw;        /* RTE directly from the SUB unscaled   */
/* in future DoPE versions detailed RTErr structures will be placed here */
    };
  } DoPERTErr;

#if !defined __MINGW32__
  #pragma warning( default : 4201 )
#endif


  /* The DoPERTE structure is kept for compatibility to old DoPE versions     */
  /* Use DoPERTErr for detailed runtime error mechanism                       */
  typedef  struct  DoPERunTimeError   /* Run time error (old style)           */
  {                                   /* ------------------------------------ */
    unsigned short     ErrorNumber;   /* Number of run time error             */
    double             Time;          /* System time the error occurred       */
    unsigned short     Device;        /* Device Number responsible for the err*/
    unsigned short     Bits;          /* Responsible bits if digital input dev*/
  } DoPERTE;

  typedef  struct  DoPEMoveCtrlMsg    /* Messages of movement control         */
  {                                   /* ------------------------------------ */
    unsigned short     MsgId;         /* ID of message                        */
    double             Time;          /* System time for the message          */
    unsigned short     Control;       /* Control mode of position             */
    double             Position;      /* Position                             */
    unsigned short     DControl;      /* Control mode of destination position */
    double             Destination;   /* Destination position                 */
  } DoPEMCM;

                                      /* Constants for 'MsgId'                */
                                      /* ---------------------                */
  #define  CMSG_POS          1        /* Destination reached                  */
  #define  CMSG_UPPER_SFT    2        /* Upper softend reached                */
  #define  CMSG_LOWER_SFT    3        /* Lower softend reached                */
  #define  CMSG_POS_ERR      4        /* Destination window not reached       */
  /*                         5           reserved                             */
  #define  CMSG_TPOS         6        /* Trigger position reached             */
  #define  CMSG_TPOS_ERR     7        /* Destination window for Trigger not r.*/
  #define  CMSG_LPOS         8        /* Limit position reached               */
  #define  CMSG_LPOS_ERR     9        /* Destination window not reached (limit)*/

  /*                        48           reserved                             */
  #define  CMSG_OFFSET      49        /* Offset correction finished           */
  #define  CMSG_REF_END     50        /* Reference cycle successfully finished */

  #define  CMSG_CHECK       51        /* Channel supervision has triggered    */
  #define  CMSG_CHECK_ERR   52        /* Channel supervision has triggered but */
                                      /* specified action was not started     */
  #define  CMSG_SHIELD      53        /* Protective Shield  supervision has triggered */
  #define  CMSG_SHIELD_ERR  54        /* Protective Shield  supervision has triggered */
                                      /* but specified action was not started */
  #define  CMSG_REFSIGNAL   55        /* Reference Signal occured             */


  typedef  struct  DoPESftMsg         /* 'Softend' Message                    */
  {                                   /* ------------------------------------ */
    unsigned short     MsgId;         /* ID of message                        */
    double             Time;          /* System time for the message          */
    unsigned short     Control;       /* Control mode of position             */
    double             Position;      /* Position                             */
  } DoPESftM;


  typedef  struct  DoPEOffsCMsg       /* 'Offset-Correction' Message          */
  {                                   /* ------------------------------------ */
    unsigned short     MsgId;         /* ID of message                        */
    double             Time;          /* System time for the message          */
    double             Offset;        /* Power Amplifier Offset               */
  } DoPEOffsCM;


  typedef  struct  DoPECheckMsg       /* 'Measuring Channel Supervision' Msg. */
  {                                   /* ------------------------------------ */
    unsigned short     MsgId;         /* ID of message                        */
    double             Time;          /* System time for the message          */
    unsigned short     CheckId;       /* ID of Measuring Channel Check        */
    double             Position;      /* Position                             */
    unsigned short     SensorNo;      /* Supervised sensor                    */
  } DoPECheckM;


  typedef  struct  DoPERefSignalMsg   /* 'Reference Signal' Message           */
  {                                   /* ------------------------------------ */
    unsigned short     MsgId;         /* ID of message                        */
    double             Time;          /* System time for the message          */
    unsigned short     SensorNo;      /* Control mode of position             */
    double             Position;      /* Position                             */
  } DoPERefSignalM;


  #define  SENSOR_MSG_LEN  80

  typedef  struct  DoPESensorMsg      /* Sensor Message                       */
  {                                   /* ------------------------------------ */
    double         Time;              /* System time for the message          */
    unsigned short SensorNo;          /* Sensor Number 0 .. 15                */
    unsigned short Length;            /* Number of bytes in the message       */
    BYTE           Data[SENSOR_MSG_LEN]; /* Message                           */
  } DoPESensorM;


  typedef  struct  DoPERawSubMsg      /* 'Raw Sub' Message                    */
  {                                   /* ------------------------------------ */
    Header             TypSub;        /* Sub header                           */
    BYTE               Data[1];       /* Sub message in raw binary format     */
                                      /* the size of the data buffer is passed*/
                                      /* in the DoPEGetMsg BufSize parameter  */
  } DoPERawM;



  typedef  union  DoPEMsgAll          /* Union of all messages from DoPE      */
  {
    DoPECE      CmdErr;               /* Command error                        */
    DoPERTE     RunTimeErr;           /* Run time error (old style)           */
    DoPERTErr   RTErr;                /* Run time error (detailed)            */
    DoPEMCM     MoveCMsg;             /* Messages of movement control         */
    DoPESftM    SftMsg;               /* 'Softend' Message                    */
    DoPEOffsCM  OffsCMsg;             /* 'Offset-Correction' Message          */
    DoPECheckM  MCCheckMsg;           /* 'Measuring Channel Supervision' Msg. */
    DoPERefSignalM RefSignalMsg;      /* 'Reference Signal' Message           */
    DoPESensorM SensorMsg;            /* 'Sensor' Message                     */
    DoPERawM    RawSubMsg;            /* 'Raw Sub' Message                    */
  }uMsgAll;


  typedef  struct                     /* Messages SUB -> PC                   */
  {                                   /* ------------------------------------ */
    Header   Typ;                     /* Common header part                   */
    unsigned short     usTAN;         /* Transaction number                   */
    uMsgAll  Usr;                     /* Message specific parts               */
  } DoPEMsg;


#pragma pack ()


/* -------------------------------------------------------------------------- */

                                       /* Manifest constants for event bits  */
                                       /* ---------------------------------  */
#define DoPEEVT_RXAVAIL        0x0001  /* New message received               */
#define DoPEEVT_DATAVAIL       0x0010  /* New Samples (MW) available         */
#define DoPEEVT_DATAOVERFLOW   0x0020  /* Sample Overflow                    */
#define DoPEEVT_ACK            0x0040  /* DoPE command acknowledged          */
#define DoPEEVT_NAK            0x0080  /* DoPE command not acknowledged      */
#define DoPEEVT_RESTART        0x1000  /* EDC link established               */
#define DoPEEVT_OVERFLOW       0x2000  /* Receiver Overflow                  */
#define DoPEEVT_OFFLINE        0x4000  /* State transition to off-line       */
#define DoPEEVT_ONLINE         0x8000  /* State transition to on-line        */
#define DoPEEVT_ALL            0xF0F1  /* All valid event bits               */


  typedef  unsigned  (CALLBACK NPROC)  ( HWND   hWnd,
                                         UINT   uMsg,
                                         WPARAM DoPEHdl,
                                         LPARAM Event );

    /*
    Notification callback prototype

      In:  hWnd            Window handle, as set by DpxSetNotification
           uMsg            Message number, as set by DpxSetNotification
           DoPEHdl         DoPE link handle
           Event           Events, that have occurred

      Returns:             Events, that should be resent later on.
    */


  extern  unsigned  DLLAPI  DoPESetNotification  ( DoPE_HANDLE DoPEHdl,
                                                   unsigned    EventMask,
                                                   NPROC      *NotifyProc,
                                                   HWND        NotifyWnd,
                                                   UINT        NotifyMsg );

    /*
    Set parameters for DoPE notification callback.

      In :  DoPEHdl     DoPE link handle
            EventMask   Events for Notification. (Or'ed DPXEVT_xx constants)
            NotifyProc  Notification callback.
            NotifyWnd   Reference data: Window handle to pass to callback
            NotifyMsg   Reference data: Message-Number to pass to callback

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEGetMsg  ( DoPE_HANDLE DoPEHdl,
                                          void       *Buffer,
                                          unsigned    BufSize,
                                          unsigned   *Length   );

    /*
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
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPESendMsgSync  ( DoPE_HANDLE DoPEHdl,
                                               void       *Buffer,
                                               unsigned    Length,
                                               WORD       *lpusTAN );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPESendMsg  ( DoPE_HANDLE DoPEHdl,
                                           void       *Buffer,
                                           unsigned    Length,
                                           WORD       *lpusTAN );

    /*
    Send a message to EDC.
    This function is only needed if you have to communicate directly to EDC's
    Subsystem. The message sent must be a command to the subsystem. Refer
    Documentation Subsystem for Test Machine Control.

      In :  DoPEHdl     DoPE link handle
            Buffer      Pointer to message to transmit
            Length      Message length in BYTEs

      Out :
           *lpusTAN     Pointer to TAN used from this command

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEClearReceiver  ( DoPE_HANDLE DoPEHdl );

    /*
    Discard all received messages

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    */


/* -------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEClearTransmitter ( DoPE_HANDLE DoPEHdl );

    /*
    Discard all unsent transmitter buffers

      In :  DoPEHdl     DoPE link handle

      Returns:          Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
