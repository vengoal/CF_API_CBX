/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( DSPTCPSVR )                                       */
/*            Pgm( CBX1692 )                                         */
/*            SrcMbr( CBX1692X )                                     */
/*            Allow( *INTERACT *IPGM *IREXX *IMOD )                  */
/*            HlpPnlGrp( CBX1692H )                                  */
/*            HlpId( *CMD )                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Display TCP/IP Servers' )

          Parm     SVRTYP      *Char       1                    +
                   Rstd( *YES )                                 +
                   Dft( *ALL )                                  +
                   SpcVal(( *ALL     '*' )                      +
                          ( *TCPIP   'T' )                      +
                          ( *HOSTNFS 'U' ))                     +
                   Prompt( 'Server type' )

