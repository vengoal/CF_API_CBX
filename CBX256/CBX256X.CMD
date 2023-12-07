/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( DSPJOBSCN )                                        */
/*           Pgm( CBX2561 )                                          */
/*           VldCkr( CBX256V )                                       */
/*           SrcMbr( CBX256X )                                       */
/*           HlpPnlGrp( CBX256H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
    Cmd        Prompt( 'Display Job Screen' )                   +
               MaxPos( 2 )                                      +
               AlwLmtUsr( *NO )                                 +
               VldCkr( CBX256V )                                +
               HlpId( *CMD )                                    +
               HlpPnlGrp( CBX256H )                             +
               Text( 'Display Job Screen' )


    Parm       JOB      Q0001               +
               Min(1)                       +
               Choice(*NONE)                +
               Prompt('Job name')

    Parm       TIMEOUT  *Int2               +
               Dft( 25 )                    +
               Range( 5  3600 )             +
               Expr( *YES )                 +
               Choice( 'Seconds, 5-3600' )  +
               Prompt( 'Request time-out' )

Q0001:                                      +
    Qual                *Name        10     +
               Min( 1 )                     +
               Expr( *YES )

    Qual                *Name        10     +
               Min( 1 )                     +
               Expr( *YES )                 +
               Prompt( 'User' )

    Qual                *Char         6     +
               Min( 1 )                     +
               Range( '000000' '999999' )   +
               Full( *YES )                 +
               Expr( *YES )                 +
               Prompt( 'Number' )

