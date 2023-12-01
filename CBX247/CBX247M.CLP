/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX247M                                            */
/*  Description : Watch Definition Commands - Create command         */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : iPro Developer Insight, 2012.                      */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Watch Defintion Commands' objects.            */
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
/*    CrtClPgm    Pgm( CBX247M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX247                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX247                  +
                 Module( &UtlLib/CBX247 )        +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX247V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX247V                 +
                 Module( &UtlLib/CBX247V )       +
                 ActGrp( *NEW )


     CrtPnlGrp   &UtlLib/CBX247H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtRpgMod   &UtlLib/CBX248                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX248                  +
                 Module( &UtlLib/CBX248 )        +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX248V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX248V                 +
                 Module( &UtlLib/CBX248V )       +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX248P                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX248P                 +
                 Module( &UtlLib/CBX248P )       +
                 ActGrp( *NEW )


     CrtPnlGrp   &UtlLib/CBX248H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/ADDWCHDFN )                       +
                 Pgm( CBX247 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX247X )

     CrtCmd      Cmd( &UtlLib/RMVWCHDFN )                       +
                 Pgm( CBX248 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX248X )


     SndPgmMsg   Msg( 'Watch Definition commands succesfully'   *Bcat +
                      'created in library'                      *Bcat +
                      &UtlLib                                   *Tcat +
                      '.' )                                           +
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
