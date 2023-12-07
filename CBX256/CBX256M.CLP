/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . :  CBX256M                                           */
/*  Description :  Display Job Screen - Create command               */
/*  Author  . . :  Carsten Flensburg                                 */
/*  Published . :  iPro Developer, 2012.                             */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Display Job Screen command objects.           */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*  Prerequisite:      Specify the appropriate value for the         */
/*                     QALWJOBITP system value, defined by the       */
/*                     &AlwJobItp variable declaration below,        */
/*                     prior to compiling this program.              */
/*                                                                   */
/*                     If you do not alter the default value of      */
/*                     '0' for the &AlwJobItp variable, no job       */
/*                     interrupt exit program will be allowed to     */
/*                     run.                                          */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX256M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     Dcl    &AlwJobItp      *Char      1    '0'

 /* To allow the job interrupt exit program to be run following an */
 /*   explicit setting in the job to be interrupted, replace the   */
 /*   above &AlwJobItp variable declaration with the one below:    */
 /*                                                                */
 /*  Dcl    &AlwJobItp      *Char      1    '1'                    */

 /* To allow the job interrupt exit program to be run without an   */
 /*   explicit setting in the job to be interrupted, replace the   */
 /*   above &AlwJobItp variable declaration with the one below:    */
 /*                                                                */
 /*  Dcl    &AlwJobItp      *Char      1    '2'                    */


     MonMsg      CPF0000    *N        GoTo Error


     AddLibLe    &UtlLib
     MonMsg      CPF2103

     CrtRpgMod   &UtlLib/CBX2561                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *NONE )

     CrtPgm      &UtlLib/CBX2561                 +
                 Module( &UtlLib/CBX2561 )       +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX2562                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *NONE )

     CrtPgm      &UtlLib/CBX2562                 +
                 Module( &UtlLib/CBX2562 )       +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX256V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *NONE )

     CrtPgm      &UtlLib/CBX256V                 +
                 Module( &UtlLib/CBX256V )       +
                 ActGrp( *NEW )


     CrtPnlGrp   &UtlLib/CBX256H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtCmd      Cmd( &UtlLib/DSPJOBSCN )                       +
                 Pgm( CBX2561 )                                 +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX256X )                              +
                 HlpPnlGrp( CBX256H )                           +
                 HlpId( *CMD )                                  +
                 PrdLib( &UtlLib )

     SndPgmMsg   Msg( 'Display Job Screen command'        *Bcat +
                      'successfully created in library'   *Bcat +
                      &UtlLib                             *Tcat +
                      '.' )                                     +
                 MsgType( *COMP )


     ChgSysVal   SysVal( QALWJOBITP )                 +
                 Value( &AlwJobItp )

     AddExitPgm  ExitPnt( QIBM_QWC_JOBITPPGM )        +
                 Format( JITP0100 )                   +
                 PgmNbr( *LOW )                       +
                 Pgm( &UtlLib/CBX2562 )               +
                 Text( 'Job interrupt exit program for DSPJOBSCN command' )

     SndPgmMsg   Msg( 'Display Job Screen command'        *Bcat +
                      'successfully configured.' )              +
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
