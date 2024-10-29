/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( SNDDTAQE )                                        */
/*            Pgm( QSNDDTAQ )                                        */
/*            SrcMbr( CBX1652X )                                     */
/*            HlpPnlGrp( CBX1652H )                                  */
/*            HlpId( *CMD )                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Send Data Queue Entry' )

          Parm     DTAQ        *Name      10                    +
                   Min( 1 )                                     +
                   Expr( *YES )                                 +
                   Prompt( 'Data queue' )

          Parm     DTAQLIB     *Name      10                    +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL )  ( *CURLIB *CURLIB ))       +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

          Parm     DATALEN     *Dec      ( 5 0 )                +
                   Range( 1  3000 )                             +
                   Expr( *YES )                                 +
                   Prompt( 'Entry data length' )

          Parm     DATA        *Char    3000                    +
                   Expr( *YES )                                 +
                   Rel( *NE ' ' )                               +
                   Prompt( 'Entry data' )

          Parm     KEYLEN      *Dec      ( 3 0 )                +
                   Dft( *NONE )                                 +
                   SpcVal(( *NONE  0  ))                        +
                   Range( 1  256 )                              +
                   Expr( *YES )                                 +
                   Prompt( 'Key length' )

          Parm     KEY         *Char     256                    +
                   Dft( *NONE )                                 +
                   SpcVal(( *NONE  ' ' ))                       +
                   Expr( *YES )                                 +
                   Prompt( 'Key data' )

          Parm     ASYNCH      *Char      10                    +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *NO ) ( *YES ))                     +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Asynchronous request' )

          Parm     JRNENT      *Char      10                    +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *NO ) ( *YES ))                     +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Data from journal entry' )


          Dep      Ctl( &KEYLEN *EQ 0 )                         +
                   Parm(( KEY ))                                +
                   NbrTrue( *EQ 0 )

          Dep      Ctl( &KEYLEN *NE 0 )                         +
                   Parm(( KEY ))                                +
                   NbrTrue( *ALL )

