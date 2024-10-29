/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX165M                                            */
/*  Description : Data Queue Commands - Create commands              */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Programming Tips Newsletter        */
/*  Date  . . . : December 14, 2006                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     command objects for the Copy Data Queue       */
/*                     Description commands.                         */
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
/*    CrtClPgm    Pgm( CBX166M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm      &UtlLib

     Dcl      &UtlLib       *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX166                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX166                  +
                 Module( &UtlLib/CBX166 )        +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX166V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX166V                 +
                 Module( &UtlLib/CBX166V )       +
                 ActGrp( *CALLER )


     CrtRpgMod   &UtlLib/CBX166O                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX166O                 +
                 Module( &UtlLib/CBX166O )       +
                 ActGrp( *CALLER )


     CrtPnlGrp   &UtlLib/CBX166H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/CPYDTAQD )                        +
                 Pgm( CBX166 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX166X )                              +
                 VldCkr( CBX166V )                              +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX166H )                           +
                 HlpId( *CMD )                                  +
                 PmtOvrPgm( CBX166O )


     SndPgmMsg   Msg( 'Copy Data Queue Description command'    *Bcat +
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
