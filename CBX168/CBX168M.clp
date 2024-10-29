/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX168M                                            */
/*  Description : Work with Data Queues - Create command             */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Programming Tips Newsletter        */
/*  Date  . . . : February 8, 2007                                   */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with Data Queues command objects.        */
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
/*    CrtClPgm    Pgm( CBX168M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error



     CrtRpgMod   &UtlLib/CBX168                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX168                  +
                 Module( &UtlLib/CBX168 )        +
                 ActGrp( *NEW )


     CrtRpgMod   &UtlLib/CBX168E                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX168E                 +
                 Module( &UtlLib/CBX168E )       +
                 ActGrp( *CALLER )


     CrtRpgMod   &UtlLib/CBX168V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX168V                 +
                 Module( &UtlLib/CBX168V )       +
                 ActGrp( *CALLER )


     CrtPnlGrp   &UtlLib/CBX168H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX168P                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/WRKDTAQ2 )                        +
                 Pgm( CBX168 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX168X )                              +
                 VldCkr( CBX168V )                              +
                 Allow( *INTERACT *IPGM *IREXX *IMOD )          +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX168H )                           +
                 HlpId( *CMD )


     SndPgmMsg   Msg( 'Work with Data Queues command'        *Bcat +
                      'successfully created in library'      *Bcat +
                      &UtlLib                                *Tcat +
                      '.' )                                        +
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
