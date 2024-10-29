/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX165M                                            */
/*  Description : Data Queue Commands - Create commands              */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Programming Tips Newsletter        */
/*  Date  . . . : November 16, 2006                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     command objects for the Create Data Queue     */
/*                     Description, Send Data Queue Entry and        */
/*                     Clear Data Queue commands.                    */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX165M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX165                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX165                  +
                 Module( &UtlLib/CBX165 )        +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX165V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX165V                 +
                 Module( &UtlLib/CBX165V )       +
                 ActGrp( *CALLER )


     CrtPnlGrp   &UtlLib/CBX165H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX165P                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtPnlGrp   &UtlLib/CBX1652H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX1653H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/DSPDTAQD )                        +
                 Pgm( CBX165 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX165X )                              +
                 VldCkr( CBX165V )                              +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX165H )                           +
                 HlpId( *CMD )

     CrtCmd      Cmd( &UtlLib/SNDDTAQE )                        +
                 Pgm( QSNDDTAQ )                                +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX1652X )                             +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX1652H )                          +
                 HlpId( *CMD )

     CrtCmd      Cmd( &UtlLib/CLRDTAQ )                         +
                 Pgm( QCLRDTAQ )                                +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX1653X )                             +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX1653H )                          +
                 HlpId( *CMD )


     SndPgmMsg   Msg( 'Display Data Queue Description command' *Bcat +
                      'successfully created in library'        *Bcat +
                      &UtlLib                                  *Tcat +
                      '.' )                                          +
                 MsgType( *COMP )

     SndPgmMsg   Msg( 'Send Data Queue Entries command'        *Bcat +
                      'successfully created in library'        *Bcat +
                      &UtlLib                                  *Tcat +
                      '.' )                                          +
                 MsgType( *COMP )

     SndPgmMsg   Msg( 'Clear Data Queue command'               *Bcat +
                      'successfully created in library'        *Bcat +
                      &UtlLib                                  *Tcat +
                      '.' )                                          +
                 MsgType( *COMP )


     Call        QMHMOVPM    ( '    '                 +
                               '*COMP'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )

     RmvMsg      Clear( *ALL )

     Return

/*-- Error handling:  -----------------------------------------------*/
 Error:
     Call        QMHMOVPM    ( '    '                 +
                               '*DIAG'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )

     Call        QMHRSNEM    ( '    '                 +
                               x'0000000800000000'    +
                             )

 EndPgm:
     EndPgm
