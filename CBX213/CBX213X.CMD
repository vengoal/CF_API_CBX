/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKCMDEXIT )                                       */
/*           Pgm( CBX213 )                                           */
/*           SrcMbr( CBX213X )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX213H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Command Exit Pgms' )

             Parm       CMDEXIT     *Char      10                    +
                        Rstd( *YES )                                 +
                        Dft( *CHG )                                  +
                        SpcVal(( *CHG  )   ( *RTV  ))                +
                        Prompt( 'Command exit type' )

             Parm       SELECT        E0001                          +
                        Prompt( 'Select' )

 E0001:      Elem                   Q0001                            +
                        Prompt( 'Command' )

             Elem                   Q0001                            +
                        Prompt( 'Exit program' )

 Q0001:      Qual                   *Name                            +
                        Dft( *ANY )                                  +
                        SpcVal(( *ANY ))                             +
                        Expr( *YES )

             Qual                   *Name                            +
                        Dft( *ANY )                                  +
                        SpcVal(( *ANY ))                             +
                        Expr( *YES )                                 +
                        Prompt( 'Library' )

