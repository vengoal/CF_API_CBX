/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX232M                                            */
/*  Description : Work with Jobs - Create command                    */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Programming Tips Newsletter        */
/*  Date  . . . : May 26, 2011                                       */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with Jobs command objects.               */
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
/*    CrtClPgm    Pgm( CBX232M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtMsgF     MsgF( &UtlLib/CBX232M )  Aut( *USE )

     AddMsgD     CBX0101                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'User name must be *CURUSR if CURUSR is +
                       specified.' )                                  +
                 SecLvl( *NONE )

     AddMsgD     CBX0102                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'Current user can only be specified if +
                       STATUS(*ACTIVE) is requested.' )               +
                 SecLvl( *NONE )

     AddMsgD     CBX0103                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'Please specify current user.' )                +
                 SecLvl( *NONE )

     AddMsgD     CBX0106                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'Active status can only be specified if +
                       STATUS(*ACTIVE) is requested.' )               +
                 SecLvl( *NONE )

     AddMsgD     CBX0111                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'Completion status can only be specified if +
                       STATUS(*OUTQ) is requested.' )                 +
                 SecLvl( *NONE )

     AddMsgD     CBX0121                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'If JOB(*ALL) and USER(*ALL) is specified, +
                       STATUS must be *ACTIVE or *JOBQ.' )            +
                 SecLvl( *NONE )

     AddMsgD     CBX0122                                              +
                 MsgF( &UtlLib/CBX232M )                              +
                 Msg( 'If JOB(*ALL) and USER(*ALL) is specified, +
                       STATUS must be *ACTIVE or *JOBQ.' )            +
                 SecLvl( *NONE )

     CrtRpgMod   &UtlLib/CBX232                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX232                  +
                 Module( &UtlLib/CBX232 )        +
                 ActGrp( *NEW )

     CrtRpgMod   &UtlLib/CBX232E                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX232E                 +
                 Module( &UtlLib/CBX232E )       +
                 ActGrp( *CALLER )

     CrtRpgMod   &UtlLib/CBX232L                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX232L                 +
                 Module( &UtlLib/CBX232L )       +
                 ActGrp( *CALLER )

     CrtRpgMod   &UtlLib/CBX232V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )

     CrtPgm      &UtlLib/CBX232V                 +
                 Module( &UtlLib/CBX232V )       +
                 ActGrp( *NEW )


     CrtPnlGrp   &UtlLib/CBX232H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )

     CrtPnlGrp   &UtlLib/CBX232P                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )


     CrtCmd      Cmd( &UtlLib/WRKJOBS )                         +
                 Pgm( CBX232 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX232X )                              +
                 Allow( *INTERACT *IPGM *IREXX *IMOD )          +
                 AlwLmtUsr( *NO )                               +
                 MsgF( &UtlLib/CBX232M )                        +
                 HlpPnlGrp( CBX232H )                           +
                 HlpId( *CMD )


     SndPgmMsg   Msg( 'Work with Jobs command successfully' *Bcat +
                      'created in library'                  *Bcat +
                      &UtlLib                               *Tcat +
                      '.' )                                       +
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
