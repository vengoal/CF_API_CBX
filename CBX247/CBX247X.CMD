/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( ADDWCHDFN )                                        */
/*           Pgm( CBX247 )                                           */
/*           SrcMbr( CBX247X )                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd        Prompt( 'Add Watch Definition' )            +
                    MaxPos( 2 )                                 +
                    AlwLmtUsr( *NO )                            +
                    VldCkr( CBX247V )                           +
                    HlpId( *CMD )                               +
                    HlpPnlGrp( CBX247H )                        +
                    Text( 'Add Watch Definition')

         Parm       SSNID         *Name        10               +
                    Min( 1 )                                    +
                    Vary( *YES )                                +
                    Prompt('Session ID')

         Parm       WCHPGM        Q0001                         +
                    Min( 1 )                                    +
                    Choice( *NONE )                             +
                    Prompt( 'Watch program' )

         Parm       CALLWCHPGM    *Char         7               +
                    Rstd( *YES )                                +
                    Dft( *WCHEVT )                              +
                    SpcVal(( *STRWCH ) ( *ENDWCH ))             +
                    SngVal(( *WCHEVT ))                         +
                    Max( 2 )                                    +
                    Full( *YES )                                +
                    Expr( *YES )                                +
                    Prompt( 'Call watch program' )

         Parm       WCHMSG        E0001                         +
                    Dft( *NONE )                                +
                    SngVal(( *NONE ))                           +
                    Max( 100 )                                  +
                    Prompt( 'Watch for message' )

         Parm       WCHMSGQ       E0002                         +
                    Max( 3 )                                    +
                    Choice( *NONE )                             +
                    PmtCtl( P0001 )                             +
                    Prompt( 'Watched message queue' )

         Parm       WCHJOB        E0003                         +
                    Dft( * )                                    +
                    SngVal(( * ))                               +
                    Max( 5 )                                    +
                    PmtCtl( P0001 )                             +
                    Prompt( 'Watched job' )

         Parm       WCHLICLOG     E0004                         +
                    Dft( *NONE )                                +
                    SngVal(( *NONE *NON ))                      +
                    Max( 5 )                                    +
                    Prompt( 'Watch for LIC log entry')

         Parm       WCHPAL        E0005                         +
                    Dft( *NONE )                                +
                    SngVal(( *NONE ))                           +
                    Max( 5 )                                    +
                    Prompt( 'Watch for PAL entry' )

         Parm       RUNPTY        *Int2                         +
                    Dft( 25 )                                   +
                    Range( 1 99 )                               +
                    PassVal( *NULL )                            +
                    Prompt( 'Run priority' )

         PARM       TEXT          *Char        72               +
                    Dft( *BLANK )                               +
                    SpcVal(( *Blank '' ))                       +
                    Vary( *YES )                                +
                    Expr( *YES )                                +
                    Prompt( 'Text ''description''' )


Q0001:   Qual                    *Name         10               +
                    Min( 1 )                                    +
                    Expr( *YES )

         Qual                    *Name         10               +
                    Dft( *LIBL )                                +
                    SpcVal(( *LIBL ) ( *CURLIB *CURLIB ))       +
                    Expr( *YES )                                +
                    Prompt( 'Library' )

E0001:   Elem                     *Generic      7               +
                    SpcVal(( *ALL ) ( *IMMED ))                 +
                    Min( 1 )                                    +
                    Expr( *YES )                                +
                    Prompt( 'Message to watch' )

         Elem                     *Char        72               +
                    Dft( *NONE )                                +
                    SpcVal(( *NONE  '' ))                       +
                    Expr( *YES )                                +
                    Vary( *YES )                                +
                    Prompt( 'Comparison data' )

         Elem                     *Char        10               +
                    Rstd( *YES )                                +
                    Dft( *MSGDTA )                              +
                    SpcVal(( *MSGDTA ) ( *FROMPGM ) ( *TOPGM )) +
                    Prompt( 'Compare against' )

         Elem                     *Char        10               +
                    Rstd( *YES )                                +
                    Dft( *ALL )                                 +
                    SpcVal(( *ALL    )                          +
                           ( *COMP   )                          +
                           ( *DIAG   )                          +
                           ( *ESCAPE )                          +
                           ( *INFO   )                          +
                           ( *INQ    )                          +
                           ( *NOTIFY )                          +
                           ( *SCOPE  )                          +
                           ( *STATUS ))                         +
                    Prompt( 'Message type' )

         Elem                    *Char         10               +
                    Rstd( *YES )                                +
                    Dft( *GE )                                  +
                    SpcVal(( *GE )                              +
                           ( *EQ )                              +
                           ( *GT )                              +
                           ( *LT )                              +
                           ( *LE ))                             +
                    Prompt( 'Relational operator' )

         Elem                    *Int2                          +
                    Dft( 00 )                                   +
                    Range( 0 99 )                               +
                    Expr( *YES )                                +
                    Prompt( 'Severity code' )

E0002:   Elem                    Q0002                          +
                    Dft( *SYSOPR )                              +
                    SngVal(( *SYSOPR ) ( *JOBLOG ) ( *HSTLOG )) +
                    Prompt( 'Message queue' )

Q0002:   Qual                    *Name         10               +
                    Min( 1 )                                    +
                    Expr( *YES )

         Qual                    *Name         10               +
                    Dft( *LIBL )                                +
                    SpcVal(( *LIBL ))                           +
                    Expr( *YES )                                +
                    Prompt( 'Library' )

E0003:   Elem                    Q0003                          +
                    Choice( *NONE )                             +
                    Prompt( 'Job name' )


Q0003:   Qual                    *Generic      10               +
                    SpcVal(( *ALL ))                            +
                    Min( 1 )                                    +
                    Expr( *YES )

         Qual                    *Generic      10               +
                    SpcVal(( *ALL ))                            +
                    Min( 1 )                                    +
                    Expr( *YES )                                +
                    Prompt( 'User' )

         Qual                    *Char          6               +
                    Dft( *ALL )                                 +
                    Range( '000001' '999999' )                  +
                    SpcVal(( *ALL ))                            +
                    Full( *YES )                                +
                    Expr( *YES )                                +
                    Prompt( 'Number' )

E0004:   Elem                    *Char          4               +
                    SpcVal(( *ALL ))                            +
                    Min( 1 )                                    +
                    Full( *YES )                                +
                    Expr( *YES )                                +
                    Choice( '0000-FFFF, *ALL, *NONE' )          +
                    Prompt( 'Major code' )

         Elem                    *Char          4               +
                    SpcVal(( *ALL ))                            +
                    Min( 1 )                                    +
                    Full( *YES )                                +
                    Expr( *YES )                                +
                    Choice( '0000-FFFF, *ALL' )                 +
                    Prompt( 'Minor code' )

         Elem                    *Char         72               +
                    Dft( *NONE )                                +
                    SpcVal(( *NONE  '' ))                       +
                    Expr( *YES )                                +
                    Vary( *YES )                                +
                    Prompt( 'Comparison data' )

         Elem                    *Char         10               +
                    Rstd( *YES )                                +
                    Dft( *ALL )                                 +
                    SpcVal(( *ALL       )                       +
                           ( *TDENBR    )                       +
                           ( *TASKNAME  )                       +
                           ( *SVRTYPE   )                       +
                           ( *JOBNAME   )                       +
                           ( *JOBUSR    )                       +
                           ( *JOBNBR    )                       +
                           ( *THDID     )                       +
                           ( *EXCPID    )                       +
                           ( *MODNAME   )                       +
                           ( *MODRUNAME )                       +
                           ( *MODEPNAME )                       +
                           ( *MODOFFSET )                       +
                           ( *MODTSP    ))                      +
                    Prompt( 'Compare against' )

E0005:   Elem                    *Char          8               +
                    SpcVal(( *ALL ))                            +
                    Min( 1 )                                    +
                    Expr( *YES )                                +
                    Prompt( 'System reference code' )

         Elem                    *Char         10               +
                    Dft( *NONE )                                +
                    SpcVal(( *NONE  '' ))                       +
                    Expr( *YES )                                +
                    Vary( *YES )                                +
                    Prompt( 'Comparison data' )

         Elem                    *Char         10               +
                    Rstd( *YES )                                +
                    Dft( *RSCNAME )                             +
                    SpcVal(( *RSCNAME  )                        +
                           ( *RSCTYPE  )                        +
                           ( *RSCMODEL ))                       +
                    Prompt( 'Compare against' )

P0001:   PmtCtl     Ctl( WCHMSG )                               +
                    Cond(( *NE *NONE ))

         Dep        Ctl( &WCHMSG *EQ *NONE )                    +
                    Parm(( WCHMSGQ ) ( WCHJOB ))                +
                    NbrTrue( *EQ 0 )                            +
                    MsgId( CPD39C3 )

         Dep        Ctl( *ALWAYS )                              +
                    Parm(( WCHMSG    )                          +
                         ( WCHLICLOG )                          +
                         ( WCHPAL    ))                         +
                    NbrTrue( *GT 0 )                            +
                    MsgId( CPF39E4 )

