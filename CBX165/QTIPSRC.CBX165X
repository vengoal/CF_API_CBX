/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( DSPDTAQD )                                        */
/*            Pgm( CBX165 )                                          */
/*            VldCkr( CBX165V )                                      */
/*            SrcMbr( CBX165X )                                      */
/*            HlpPnlGrp( CBX165H )                                   */
/*            HlpId( *CMD )                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Display Data Queue Description' )

          Parm     DTAQ        Q0001                            +
                   Min( 1 )                                     +
                   Choice( *NONE )                              +
                   Prompt( 'Data queue' )

          Parm     OUTPUT      *Char       3                    +
                   Rstd( *YES )                                 +
                   Dft( * )                                     +
                   SpcVal(( * 'DSP' ) ( *PRINT 'PRT' ))         +
                   Prompt( 'Output' )

Q0001:    Qual                 *Name      10                    +
                   Min( 1 )                                     +
                   Expr( *YES )

          Qual                 *Name       10                   +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL )  ( *CURLIB *CURLIB ))       +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

