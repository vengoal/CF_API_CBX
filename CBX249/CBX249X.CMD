/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( STRWCHDFN )                                        */
/*           Pgm( CBX249 )                                           */
/*           SrcMbr( CBX249X )                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd        Prompt( 'Start Watch Definition' )          +
                    MaxPos( 2 )                                 +
                    AlwLmtUsr( *NO )                            +
                    VldCkr( CBX249V )                           +
                    HlpId( *CMD )                               +
                    HlpPnlGrp( CBX249H )                        +
                    Text( 'Start Watch Definition')

         Parm       SSNID         *Generic     10               +
                    Min( 1 )                                    +
                    SpcVal(( *ALL ))                            +
                    Vary( *YES )                                +
                    Prompt('Session ID')

         Parm       USRPRF        *Char        10               +
                    Rstd( *YES )                                +
                    Dft( *CURRENT )                             +
                    SpcVal(( *CURRENT ) ( *WCHDFN ))            +
                    Expr( *YES )                                +
                    Prompt( 'User profile' )

         Parm       VFYPGMOWN     *Char        10               +
                    Rstd( *YES )                                +
                    Dft( *YES )                                 +
                    SpcVal(( *YES ) ( *NO ))                    +
                    Expr( *YES )                                +
                    PmtCtl( P0001 )                             +
                    Prompt( 'Verify watch program owner' )

P0001:   PmtCtl     Ctl( USRPRF )                               +
                    Cond(( *EQ  *WCHDFN ))

