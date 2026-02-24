/*******************************************************************************

  Project: DoPE

  (C) DOLI Elektronik GmbH, 1997-present

Description :
=============

   Header for DOLI PC-EDC interface display handling

Changes :
=========
  HEG 26.11.10
  - wrote it.

*******************************************************************************/


#ifndef DoPEdisplay_INCLUDED
#define DoPEdisplay_INCLUDED


  #ifdef __cplusplus
  extern "C" {                         /* Assume C declarations for C++      */
  #endif  /* __cplusplus */


  #ifndef DLLAPI
    #define  DLLAPI  __declspec ( dllimport ) WINAPI
  #endif

/* ------------------------------------------------------------------------- */

  extern  unsigned  DLLAPI  DoPEDspClearSync    ( DoPE_HANDLE DoPEHdl );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspClear    ( DoPE_HANDLE DoPEHdl,
                                              WORD       *lpusTAN );

    /*
    Clear LCD-display at EDC frontpanel

      In :  DoPEHdl       DoPE link handle

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define DSP_HEADLINE_LEN   22        /* number of characters in headline  */
                                       /* (including terminating zero '\0') */

  extern  unsigned  DLLAPI  DoPEDspHeadLineSync ( DoPE_HANDLE DoPEHdl,
                                                  char       *HeadLine );
  extern  unsigned  DLLAPI  DoPEwDspHeadLineSync ( DoPE_HANDLE DoPEHdl,
                                                   wchar_t    *HeadLine );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspHeadLine ( DoPE_HANDLE DoPEHdl,
                                              char       *HeadLine,
                                              WORD       *lpusTAN );
  extern  unsigned  DLLAPI  DoPEwDspHeadLine ( DoPE_HANDLE DoPEHdl,
                                               wchar_t    *HeadLine,
                                               WORD       *lpusTAN );

    /*
    Display headline on LCD-display at EDC frontpanel

      In :  DoPEHdl       DoPE link handle
            HeadLine      Character string

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define DSP_FKEYSLINE_LEN  22        /* number of characters in FKeys line*/
                                       /* (including terminating zero '\0') */
                                       
  extern  unsigned  DLLAPI  DoPEDspFKeysSync    ( DoPE_HANDLE DoPEHdl,
                                                  char       *FKeys );
  extern  unsigned  DLLAPI  DoPEwDspFKeysSync    ( DoPE_HANDLE DoPEHdl,
                                                   wchar_t    *FKeys );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspFKeys    ( DoPE_HANDLE DoPEHdl,
                                              char       *FKeys,
                                              WORD       *lpusTAN );
  extern  unsigned  DLLAPI  DoPEwDspFKeys    ( DoPE_HANDLE DoPEHdl,
                                               wchar_t    *FKeys,
                                               WORD       *lpusTAN );

    /*
    Display function keys on LCD-display at EDC frontpanel


      In :  DoPEHdl       DoPE link handle
            FKeys         Character string

       Out :
           *lpusTAN       Pointer to TAN used from this command

     Returns:             Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  #define DSP_VALUE_LEN      10        /* number of characters in Value field*/
                                       /* (including terminating zero '\0') */
  #define DSP_DIM_LEN        7         /* number of characters in Dim field */
                                       /* (including terminating zero '\0') */

  extern  unsigned  DLLAPI  DoPEDspMValueSync   ( DoPE_HANDLE DoPEHdl,
                                                  char       *Value1,
                                                  char       *Value2,
                                                  char       *Dim1  ,
                                                  char       *Dim2 );
  extern  unsigned  DLLAPI  DoPEwDspMValueSync   ( DoPE_HANDLE DoPEHdl,
                                                  wchar_t     *Value1,
                                                  wchar_t     *Value2,
                                                  wchar_t     *Dim1  ,
                                                  wchar_t     *Dim2 );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspMValue   ( DoPE_HANDLE DoPEHdl,
                                              char       *Value1,
                                              char       *Value2,
                                              char       *Dim1  ,
                                              char       *Dim2,
                                              WORD       *lpusTAN  );
  extern  unsigned  DLLAPI  DoPEwDspMValue   ( DoPE_HANDLE DoPEHdl,
                                               wchar_t    *Value1,
                                               wchar_t    *Value2,
                                               wchar_t    *Dim1  ,
                                               wchar_t    *Dim2,
                                               WORD       *lpusTAN );

    /*
    Display data and dimensions on LCD-display at EDC frontpanel


      In :  DoPEHdl       DoPE link handle
            Value1        Character string for first value
            Value2        Character string for second value
            Dim1          Character string for first dimension
            Dim2          Character string for second dimension
                          ( Strings are zero terminated '\0' )

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */

/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEDspBeamScreenSync ( DoPE_HANDLE DoPEHdl,
                                                    short       Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspBeamScreen ( DoPE_HANDLE DoPEHdl,
                                                short       Value,
                                                WORD       *lpusTAN );

    /*
    Display frame & beam on LCD-display at EDC frontpanel


      In :  DoPEHdl       DoPE link handle
            Value         Value of the beam in %

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


/*--------------------------------------------------------------------------*/

  extern  unsigned  DLLAPI  DoPEDspBeamValueSync ( DoPE_HANDLE DoPEHdl,
                                                   short       Value );

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  extern  unsigned  DLLAPI  DoPEDspBeamValue ( DoPE_HANDLE DoPEHdl,
                                               short       Value,
                                               WORD       *lpusTAN );

    /*
    Display beam on LCD-display at EDC frontpanel


      In :  DoPEHdl       DoPE link handle
            Value         Value of the beam in %

      Out :
           *lpusTAN       Pointer to TAN used from this command

      Returns:            Error constant (DoPERR_xxxx)
    */


  #ifdef __cplusplus
  }                       /* End of extern "C" { */
  #endif  /* __cplusplus */

#endif
