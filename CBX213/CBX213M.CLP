/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX213M                                            */
/*  Description : Command Exit Programs - create commands            */
/*  Author  . . : Carsten Flensburg                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Command Exit Program Commands objects.        */
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
/*    CrtClPgm    Pgm( CBX213M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX213                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX213                  +
                 Module( &UtlLib/CBX213 )        +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX213E                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX213E                 +
                 Module( &UtlLib/CBX213E )       +
                 ActGrp( *CALLER )

     CrtRpgMod   &UtlLib/CBX2132                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX2132                 +
                 Module( &UtlLib/CBX2132 )       +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX2132V                +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX2132V                +
                 Module( &UtlLib/CBX2132V )      +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX2133                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX2133                 +
                 Module( &UtlLib/CBX2133 )       +
                 ActGrp( *NEW )


     CrtPnlGrp   &UtlLib/CBX213H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX2132H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX2133H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX213P                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/WRKCMDEXIT )                      +
                 Pgm( CBX213 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX213X )                              +
                 Allow( *INTERACT *IPGM *IREXX *IMOD )          +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX213H )                           +
                 HlpId( *CMD )

     CrtCmd      Cmd( &UtlLib/ADDCMDEXIT )                      +
                 Pgm( CBX2132 )                                 +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX2132X )                             +
                 VldCkr( CBX2132V )                             +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX2132H )                          +
                 HlpId( *CMD )

     CrtCmd      Cmd( &UtlLib/RMVCMDEXIT )                      +
                 Pgm( CBX2133 )                                 +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX2133X )                             +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX2133H )                          +
                 HlpId( *CMD )


     SndPgmMsg   Msg( 'Command Exit Programs commands'    *Bcat +
                      'successfully created in library'   *Bcat +
                      &UtlLib                             *Tcat +
                      '.' )                                     +
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
