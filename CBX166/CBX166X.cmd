/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( CPYDTAQD )                                        */
/*            Pgm( CBX166 )                                          */
/*            VldCkr( CBX166V )                                      */
/*            SrcMbr( CBX166X )                                      */
/*            HlpPnlGrp( CBX166H )                                   */
/*            HlpId( *CMD )                                          */
/*            PmtOvrPgm( CBX166O )                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Copy Data Queue Description' )

          Parm     FROMDTAQ    Q0001                            +
                   Min( 1 )                                     +
                   Choice( *NONE )                              +
                   Keyparm( *YES )                              +
                   Prompt( 'From data queue' 1 )

          Parm     TODTAQ      Q0002                            +
                   Min( 1 )                                     +
                   Choice( *NONE )                              +
                   Prompt( 'To data queue' 2 )

          Parm     TYPE        *Char       5                    +
                   Rstd( *YES )                                 +
                   Dft( *STD )                                  +
                   SpcVal(( *STD )  ( *DDM ))                   +
                   Expr( *YES )                                 +
                   Prompt( 'Type' 3 )

          Parm     MAXLEN      *Int4                            +
                   Range( 1  64512 )                            +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Maximum entry length' 4 )

          Parm     FORCE       *Char       5                    +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *NO ) ( *YES ))                     +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Force to auxiliary storage' 5 )

          Parm     SEQ         *Char      10                    +
                   Rstd( *YES )                                 +
                   Dft( *FIFO )                                 +
                   SpcVal(( *FIFO ) ( *LIFO ) ( *KEYED ))       +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Sequence' 6 )

          Parm     KEYLEN      *Int2                            +
                   Range( 1  256 )                              +
                   Expr( *YES )                                 +
                   PmtCtl( P0003 )                              +
                   Prompt( 'Key length' 7 )

          Parm     SENDERID    *Char       5                    +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *NO ) ( *YES ))                     +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Include sender ID' 8 )

          Parm     SIZE        E0001                            +
                   Choice( *NONE )                              +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Queue size' 9 )

          Parm     AUTORCL     *Char       5                    +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *NO ) ( *YES ))                     +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Automatic reclaim' 10 )

          Parm     RMTDTAQ     Q0003                            +
                   Choice( *NONE )                              +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Remote data queue' 11 )

          Parm     RMTLOCNAME  *Cname      8                    +
                   SpcVal(( *RDB ))                             +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Remote location' 12 )

          Parm     RDB         *Name      18                    +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Relational database' 13 )

          Parm     DEV         *Name      10                    +
                   Dft( *LOC )                                  +
                   SpcVal(( *LOC ))                             +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'APPC device description' 14 )

          Parm     LCLLOCNAME  *Cname      8                    +
                   Dft( *LOC )                                  +
                   SpcVal(( *LOC ) ( *NETATR ))                 +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Local location' 15 )

          Parm     MODE        *Cname      8                    +
                   Dft( *NETATR )                               +
                   SpcVal(( *NETATR ))                          +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Mode' 16 )

          Parm     RMTNETID    *Cname      8                    +
                   Dft( *LOC )                                  +
                   SpcVal(( *LOC ) ( *NETATR ) ( *NONE ))       +
                   Expr( *YES )                                 +
                   PmtCtl( P0002 )                              +
                   Prompt( 'Remote network identifier' 17 )

          Parm     TEXT        *Char      50                    +
                   Dft( *BLANK )                                +
                   SpcVal(( *BLANK '' ))                        +
                   Expr( *YES )                                 +
                   Vary( *YES )                                 +
                   Prompt( 'Text ''description''' 18 )

          Parm     AUT         *Name      10                    +
                   Dft( *LIBCRTAUT )                            +
                   SpcVal(( *LIBCRTAUT )                        +
                          ( *CHANGE    )                        +
                          ( *ALL       )                        +
                          ( *USE       )                        +
                          ( *EXCLUDE   ))                       +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Authority' 19 )


Q0001:    Qual                 *Name      10                    +
                   Min( 1 )                                     +
                   Expr( *YES )

          Qual                 *Name      10                    +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL )  ( *CURLIB *CURLIB ))       +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

Q0002:    Qual                 *Name      10                    +
                   Min( 1 )                                     +
                   Expr( *YES )

          Qual                 *Name      10                    +
                   Dft( *CURLIB )                               +
                   SpcVal(( *CURLIB *CURLIB ))                  +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )

Q0003:    Qual                 *Name      10                    +
                   Expr( *YES )

          Qual                 *Name      10                    +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL )  ( *CURLIB *CURLIB ))       +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )


E0001:    Elem                 *Int4                            +
                   Dft( *MAX16MB )                              +
                   Rel( *GT 0 )                                 +
                   SpcVal(( *MAX16MB -1 ) ( *MAX2GB  -2 ))      +
                   Expr( *YES )                                 +
                   Prompt( 'Maximum number of entries' )

          Elem                 *Int4                            +
                   Dft( 16 )                                    +
                   Rel( *GT 0 )                                 +
                   Expr( *YES )                                 +
                   Prompt( 'Initial number of entries' )


P0001:    PmtCtl   Ctl( TYPE )                                  +
                   Cond(( *NE '*DDM' ))

P0002:    PmtCtl   Ctl( TYPE )                                  +
                   Cond(( *EQ '*DDM' ))

P0003:    PmtCtl   Ctl( SEQ )                                   +
                   Cond(( *EQ '*KEYED' ))


          Dep      Ctl( &SEQ *NE '*KEYED' )                     +
                   Parm(( KEYLEN ))                             +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CPD9501 )

          Dep      Ctl( &SEQ *EQ '*KEYED' )                     +
                   Parm(( KEYLEN ))                             +
                   MsgId( CPD9502 )

          Dep      Ctl( &TYPE *EQ '*STD' )                      +
                   Parm(( RMTDTAQ    )                          +
                        ( RMTLOCNAME )                          +
                        ( DEV        )                          +
                        ( LCLLOCNAME )                          +
                        ( MODE       )                          +
                        ( RMTNETID   )                          +
                        ( RDB        ))                         +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CPD9263 )

          Dep      Ctl( &TYPE *EQ '*DDM' )                      +
                   Parm(( MAXLEN   )                            +
                        ( SEQ      )                            +
                        ( KEYLEN   )                            +
                        ( FORCE    )                            +
                        ( SENDERID )                            +
                        ( SIZE     )                            +
                        ( AUTORCL  ))                           +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CPD9266 )

          Dep      Ctl( &TYPE *EQ '*STD' )                      +
                   Parm(( MAXLEN ))                             +
                   MsgId( CPD9267 )

          Dep      Ctl( &TYPE *EQ '*DDM' )                      +
                   Parm(( RMTDTAQ ) ( RMTLOCNAME ))             +
                   MsgId( CPD9268 )

          Dep      Ctl( &RMTLOCNAME *EQ *RDB )                  +
                   Parm(( RDB ))                                +
                   MsgId( CPD9191 )

          Dep      Ctl( RDB )                                   +
                   Parm(( &RMTLOCNAME *EQ *RDB ))               +
                   MsgId( CPD9192 )

          Dep      Ctl( &RMTLOCNAME *EQ *RDB )                  +
                   Parm(( DEV        )                          +
                        ( LCLLOCNAME )                          +
                        ( MODE       )                          +
                        ( RMTNETID   ))                         +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CPD9266 )

          Dep      Ctl( &TYPE *EQ '*DDM' )                      +
                   Parm(( &MODE *NE SNASVCMG )                  +
                        ( &MODE *NE CPSVCMG  ))                 +
                   MsgId( CPD2707 )

