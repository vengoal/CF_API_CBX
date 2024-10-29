/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( CLRDTAQ )                                         */
/*            Pgm( QCLRDTAQ )                                        */
/*            SrcMbr( CBX1653X )                                     */
/*            HlpPnlGrp( CBX1653H )                                  */
/*            HlpId( *CMD )                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Clear Data Queue' )

          Parm     DTAQ        *Name      10                    +
                   Min( 1 )                                     +
                   Expr( *YES )                                 +
                   Prompt( 'Data queue' )

          Parm     DTAQLIB     *Name      10                    +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL )  ( *CURLIB *CURLIB ))       +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

          Parm     ORDER       *Char       2                    +
                   Rstd( *YES )                                 +
                   Dft( *NONE )                                 +
                   SpcVal(( *NONE  '  ' )                       +
                          ( *GT    'GT' )                       +
                          ( *LT    'LT' )                       +
                          ( *NE    'NE' )                       +
                          ( *EQ    'EQ' )                       +
                          ( *GE    'GE' )                       +
                          ( *LE    'LE' ))                      +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Key order' )

          Parm     KEYLEN      *Dec      ( 3 0 )                +
                   Dft( *NONE )                                 +
                   SpcVal(( *NONE  0  ))                        +
                   Range( 1  256 )                              +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Key length' )

          Parm     KEY         *Char     256                    +
                   Dft( *NONE )                                 +
                   SpcVal(( *NONE  ' ' ))                       +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Key data' )

          Parm     ERRC0100    *Char       4                    +
                   Constant( x'00000000' )


          Dep      Ctl( &ORDER *EQ '  ' )                       +
                   Parm(( KEYLEN ) ( KEY ))                     +
                   NbrTrue( *EQ 0 )

          Dep      Ctl( &ORDER *NE '  ' )                       +
                   Parm(( KEYLEN ) ( KEY ))                     +
                   NbrTrue( *ALL )

