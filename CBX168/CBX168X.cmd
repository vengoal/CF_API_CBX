/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKDTAQ2 )                                         */
/*           Pgm( CBX168 )                                           */
/*           SrcMbr( CBX168X )                                       */
/*           VldCkr( CBX168V )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX168H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Data Queues' )

          Parm     DTAQ        Q0001                            +
                   Min( 1 )                                     +
                   Choice( *NONE )                              +
                   Prompt( 'Data queue' )

          Parm     TYPE        *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *ALL )                                  +
                   SpcVal(( *ALL ) ( *STD ) ( *DDM ))           +
                   Prompt( 'Data queue type' )

          Parm     ORDER       *Char       10                   +
                   Dft( *DTAQ )                                 +
                   Rstd( *YES )                                 +
                   SpcVal(( *DTAQ )                             +
                          ( *LIB  ))                            +
                   Expr( *YES )                                 +
                   Prompt( 'Sort order' )


 Q0001:   Qual                 *Generic    10                   +
                   SpcVal(( *ALL ))                             +
                   Min( 1 )                                     +
                   Expr( *YES )

          Qual                 *Name                            +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL    )                          +
                          ( *CURLIB  )                          +
                          ( *USRLIBL )                          +
                          ( *ALLUSR  )                          +
                          ( *ALL     ))                         +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

