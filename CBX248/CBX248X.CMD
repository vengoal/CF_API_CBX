/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RMVWCHDFN )                                        */
/*           Pgm( CBX248 )                                           */
/*           SrcMbr( CBX248X )                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd        Prompt( 'Remove Watch Definition' )         +
                    MaxPos( 1 )                                 +
                    AlwLmtUsr( *NO )                            +
                    VldCkr( CBX248V )                           +
                    HlpId( *CMD )                               +
                    HlpPnlGrp( CBX248H )                        +
                    Text( 'Remove Watch Definition')

         Parm       SSNID         *Name        10               +
                    Min( 1 )                                    +
                    Vary( *YES )                                +
                    PmtCtlPgm( CBX248P )                        +
                    Prompt('Session ID')

         Parm       ENDWCH        *Char         5               +
                    Rstd( *YES )                                +
                    Dft( *NO )                                  +
                    SpcVal(( *YES ) ( *NO ))                    +
                    Expr( *YES )                                +
                    PmtCtl( WCHACT )                            +
                    Prompt( 'End watch' )

WchAct:  PmtCtl     Ctl( SSNID )                                +
                    Cond(( *EQ *YES ))                          +
                    NbrTrue( *EQ 1 )

