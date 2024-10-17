/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd     Cmd( CHGOBJATR )                                    */
/*               Pgm( CBX135 )                                       */
/*               SrcMbr( CBX135X )                                   */
/*               VldCkr( CBX135V )                                   */
/*               HlpPnlGrp( CBX135H )                                */
/*               HlpId( *CMD )                                       */
/*               PmtOvrPgm( CBX135O )                                */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd      Prompt( 'Change Object Attributes' )

        Parm     OBJ         Q0001                         +
                 Min( 1 )                                  +
                 Choice( *NONE )                           +
                 Keyparm( *YES )                           +
                 Prompt( 'Object' )

        Parm     OBJTYPE     *Char      10                 +
                 SpcVal(( *ALRTBL )                        +
                        ( *BNDDIR )                        +
                        ( *CFGL   )                        +
                        ( *CHTFMT )                        +
                        ( *CLD    )                        +
                        ( *CLS    )                        +
                        ( *CMD    )                        +
                        ( *CNNL   )                        +
                        ( *COSD   )                        +
                        ( *CRG    )                        +
                        ( *CRQD   )                        +
                        ( *CSI    )                        +
                        ( *CSPMAP )                        +
                        ( *CSPTBL )                        +
                        ( *CTLD   )                        +
                        ( *DEVD   )                        +
                        ( *DTAARA )                        +
                        ( *DTADCT )                        +
                        ( *DTAQ   )                        +
                        ( *EDTD   )                        +
                        ( *FCT    )                        +
                        ( *FILE   )                        +
                        ( *FNTRSC )                        +
                        ( *FNTTBL )                        +
                        ( *FORMDF )                        +
                        ( *FTR    )                        +
                        ( *GSS    )                        +
                        ( *IMGCLG )                        +
                        ( *IPXD   )                        +
                        ( *JOBD   )                        +
                        ( *JOBQ   )                        +
                        ( *JOBSCD )                        +
                        ( *JRN    )                        +
                        ( *JRNRCV )                        +
                        ( *LIB    )                        +
                        ( *LIND   )                        +
                        ( *LOCALE )                        +
                        ( *M36    )                        +
                        ( *M36CFG )                        +
                        ( *MEDDFN )                        +
                        ( *MENU   )                        +
                        ( *MGTCOL )                        +
                        ( *MODD   )                        +
                        ( *MODULE )                        +
                        ( *MSGF   )                        +
                        ( *MSGQ   )                        +
                        ( *NODGRP )                        +
                        ( *NODL   )                        +
                        ( *NTBD   )                        +
                        ( *NWID   )                        +
                        ( *NWSD   )                        +
                        ( *OUTQ   )                        +
                        ( *OVL    )                        +
                        ( *PAGDFN )                        +
                        ( *PAGSEG )                        +
                        ( *PDG    )                        +
                        ( *PGM    )                        +
                        ( *PNLGRP )                        +
                        ( *PRDAVL )                        +
                        ( *PRDDFN )                        +
                        ( *PRDLOD )                        +
                        ( *PSFCFG )                        +
                        ( *QMFORM )                        +
                        ( *QMQRY  )                        +
                        ( *QRYDFN )                        +
                        ( *RCT    )                        +
                        ( *S36    )                        +
                        ( *SBSD   )                        +
                        ( *SCHIDX )                        +
                        ( *SPADCT )                        +
                        ( *SQLPKG )                        +
                        ( *SQLUDT )                        +
                        ( *SRVPGM )                        +
                        ( *SSND   )                        +
                        ( *SVRSTG )                        +
                        ( *TBL    )                        +
                        ( *USRIDX )                        +
                        ( *USRPRF )                        +
                        ( *USRQ   )                        +
                        ( *USRSPC )                        +
                        ( *VLDL   )                        +
                        ( *WSCST  ))                       +
                 Min( 1 )                                  +
                 Expr( *YES )                              +
                 Choice( '*ALRTBL, *BNDDIR, *CFGL...')     +
                 Keyparm( *YES )                           +
                 Prompt( 'Object type' )

        Parm     SRCF        Q0002                         +
                 Dft( *SAME )                              +
                 SngVal(( *SAME '*SAME' ) ( *BLANK ' ' ))  +
                 Prompt( 'Source file' )

        Parm     SRCMBR      *Name      10                 +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME '*SAME' ) ( *BLANK ' ' ))  +
                 Expr( *YES )                              +
                 Prompt( 'Source member' )

        Parm     SRCCHGDTS   E0001                         +
                 Dft( *SAME )                              +
                 SngVal(( *SAME 000000 ))                  +
                 Prompt( 'Source file last changed' )

        Parm     ALWCHG     *Char        1                 +
                 Rstd( *YES )                              +
                 Dft( *SAME )                              +
                 SpcVal(( *NO    '0' )                     +
                        ( *YES   '1' )                     +
                        ( *SAME  '2' ))                    +
                 Expr( *YES )                              +
                 Prompt( 'Allow change by program' )

        Parm     USRDFNATR  *Char       10                 +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME  '*SAME' )                 +
                        ( *BLANK '     ' ))                +
                 Expr( *YES )                              +
                 Prompt( 'User-defined attribute' )

        Parm     TEXT       *Char       50                 +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME  '*SAME' )                 +
                        ( *BLANK '     ' ))                +
                 Expr( *YES )                              +
                 Case( *MIXED )                            +
                 Prompt( 'Text ''description''' )

        Parm     USECOUNT   *Char        1                 +
                 Rstd( *YES )                              +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME  '0' )                     +
                        ( *RESET '1' ))                    +
                 Expr( *YES )                              +
                 Prompt( 'Days used count' )

        Parm     LASTUSED   *Char        1                 +
                 Rstd( *YES )                              +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME   '0' )                    +
                        ( *UPDATE '1' ))                   +
                 Expr( *YES )                              +
                 Prompt( 'Last used date' )

        Parm     CHGDTS     *Char        1                 +
                 Rstd( *YES )                              +
                 Dft( *SAME )                              +
                 SpcVal(( *SAME    '0' )                   +
                        ( *CURRENT '1' ))                  +
                 Expr( *YES )                              +
                 Prompt( 'Changed date and time stamp' )

        Parm     MBRCOUNT   *Name       10                 +
                 Dft( *NONE )                              +
                 SpcVal(( *NONE ))                         +
                 Expr( *YES )                              +
                 Prompt( 'Reset member''s days used count' )

Q0001:  Qual                *Name       10                 +
                 Min( 1 )                                  +
                 Expr( *YES )

        Qual                *Name       10                 +
                 Dft( *LIBL )                              +
                 SpcVal(( *LIBL    )                       +
                        ( *CURLIB  )                       +
                        ( *ALL     )                       +
                        ( *ALLUSR  )                       +
                        ( *USRLIBL ))                      +
                 Expr( *YES )                              +
                 Prompt( 'Library' )

Q0002:  Qual                *Name       10                 +
                 Expr( *YES )

        Qual                *Name       10                 +
                 Expr( *YES )                              +
                 Prompt( 'Library' )

E0001:  Elem                *Date                          +
                 SpcVal(( *CURRENT 000001 ))               +
                 Expr( *YES )                              +
                 Prompt( 'Date' )

        Elem                *Time                          +
                 Dft( *CURRENT )                           +
                 SpcVal(( *CURRENT 999999 ))               +
                 Expr( *YES )                              +
                 Prompt( 'Time' )

