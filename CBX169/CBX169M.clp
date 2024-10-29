/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX169M                                            */
/*  Description : Data Queue Sample Application - Build Application  */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Programming Tips Newsletter        */
/*  Date  . . . : February 22, 2007                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Data Queue Sample Application objects.        */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     application objects.                          */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     application library.                          */
/*                                                                   */
/*                     NOTE: Binder language source should reside    */
/*                           in source file QSRVSRC.                 */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX168M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &AppLib

     Dcl    &AppLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtDtaQ     DtaQ( &AppLib/CBX169I )                        +
                 MaxLen( 8192 )                                 +
                 Force( *NO )                                   +
                 Seq( *FIFO )                                   +
                 SenderId( *NO )                                +
                 Size( *MAX2GB 16 )                             +
                 AutoRcl( *YES )                                +
                 Text( 'Sample application inbound transactions' )

     CrtDtaQ     DtaQ( &AppLib/CBX169O )                        +
                 MaxLen( 8192 )                                 +
                 Force( *NO )                                   +
                 Seq( *KEYED )                                  +
                 KeyLen( 16 )                                   +
                 SenderId( *NO )                                +
                 Size( *MAX2GB 16 )                             +
                 AutoRcl( *YES )                                +
                 Text( 'Sample application outbound transcations' )


     CrtBndDir   BndDir( &AppLib/CBX169B )  Aut( *USE )

     AddBndDirE  BndDir( &AppLib/CBX169B )       +
                 Obj(( &AppLib/CBX169 *SRVPGM ))


     CrtPf       &AppLib/CBX1691F                +
                 SrcFile( &AppLib/QDDSSRC )      +
                 SrcMbr( *FILE )

     CrtPf       &AppLib/CBX1692F                +
                 SrcFile( &AppLib/QDDSSRC )      +
                 SrcMbr( *FILE )


     CrtRpgMod   &AppLib/CBX169                  +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtSrvPgm   &AppLib/CBX169                  +
                 Module( &AppLib/CBX169 )        +
                 Export( *SRCFILE )              +
                 SrcFile( QSRVSRC )              +
                 SrcMbr( CBX169B )               +
                 ActGrp( *CALLER )


     CrtRpgMod   &AppLib/CBX1691                 +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX1691                 +
                 Module( &AppLib/CBX1691 )       +
                 ActGrp( *NEW )

     CrtRpgMod   &AppLib/CBX16911                +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX16911                +
                 Module( &AppLib/CBX16911 )      +
                 ActGrp( *CALLER )

     CrtRpgMod   &AppLib/CBX16912                +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX16912                +
                 Module( &AppLib/CBX16912 )      +
                 ActGrp( *CALLER )


     CrtPnlGrp   &AppLib/CBX1691H                +
                 SrcFile( &AppLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtCmd      Cmd( &AppLib/RUNDTAQSVR )       +
                 Pgm( CBX1691 )                  +
                 SrcFile( &AppLib/QCMDSRC )      +
                 SrcMbr( CBX1691X )              +
                 AlwLmtUsr( *NO )                +
                 HlpPnlGrp( CBX1691H )           +
                 HlpId( *CMD )


     CrtRpgMod   &AppLib/CBX1692                 +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX1692                 +
                 Module( &AppLib/CBX1692 )       +
                 ActGrp( *NEW )


     CrtRpgMod   &AppLib/CBX1692E                +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX1692E                +
                 Module( &AppLib/CBX1692E )      +
                 ActGrp( *CALLER )


     CrtRpgMod   &AppLib/CBX1692L                +
                 SrcFile( &AppLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &AppLib/CBX1692L                +
                 Module( &AppLib/CBX1692L )      +
                 ActGrp( *CALLER )


     CrtPnlGrp   &AppLib/CBX1692H                +
                 SrcFile( &AppLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &AppLib/CBX1692P                +
                 SrcFile( &AppLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &AppLib/DSPTCPSVR )                  +
                 Pgm( CBX1692 )                            +
                 SrcFile( &AppLib/QCMDSRC )                +
                 SrcMbr( CBX1692X )                        +
                 Allow( *INTERACT *IPGM *IREXX *IMOD )     +
                 AlwLmtUsr( *NO )                          +
                 HlpPnlGrp( CBX1692H )                     +
                 HlpId( *CMD )


     SndPgmMsg   Msg( 'Data Queue Sample Application'        *Bcat +
                      'successfully created in library'      *Bcat +
                      &AppLib                                *Tcat +
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
