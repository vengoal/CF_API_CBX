/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( RUNDTAQSVR )                                      */
/*            Pgm( CBX1691 )                                         */
/*            SrcMbr( CBX1691X )                                     */
/*            HlpPnlGrp( CBX1691H )                                  */
/*            HlpId( *CMD )                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Run Data Queue Server' )

          Parm     LOGTRN      *Char       1                    +
                   Rstd( *YES )                                 +
                   Dft( *YES )                                  +
                   SpcVal(( *YES 'Y' ) ( *NO  'N' ))            +
                   Prompt( 'Log transactions' )

