/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX249M                                            */
/*  Description : Start Watch Definition - Create command            */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : iPro Developer Insight, 2012.                      */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Start Watch Definition command objects as     */
/*                     well as a sample watch exit program.          */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*                     The command processing program will adopt     */
/*                     authority from user profile QSECOFR when      */
/*                     running.                                      */
/*                                                                   */
/*                                                                   */
/*  Requirements:      This program must be run by a user profile    */
/*                     having *ALLOBJ special authority.             */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX249M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX249                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )

     CrtPgm      &UtlLib/CBX249                  +
                 Module( &UtlLib/CBX249 )        +
                 UsrPrf( *OWNER )                +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX249V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX249V                 +
                 Module( &UtlLib/CBX249V )       +
                 ActGrp( *NEW )


     ChgObjOwn   Obj( &UtlLib/CBX249 )           +
                 ObjType( *PGM )                 +
                 NewOwn( QSECOFR )


     CrtPnlGrp   &UtlLib/CBX249H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtRpgMod   &UtlLib/CBX250                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX250                  +
                 Module( &UtlLib/CBX250 )        +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX2501                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX2501                 +
                 Module( &UtlLib/CBX2501 )       +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX2502                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX2502                 +
                 Module( &UtlLib/CBX2502 )       +
                 ActGrp( *NEW )


     CrtCmd      Cmd( &UtlLib/STRWCHDFN )                       +
                 Pgm( CBX249 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX249X )


     SndPgmMsg   Msg( 'Start Watch Definition cmd succesfully'  *Bcat +
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
