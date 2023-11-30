/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX261M                                            */
/*  Description : Exit programs - Build and Configure                */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : iPro Developer, 2013.                              */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures the          */
/*                     exit programs.                                */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     exit programs.                                */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*                                                                   */
/*  NOTE:  This program will register an exit program for the exit   */
/*         point QIBM_QMH_HDL_INQEXT. Do not compile and run this    */
/*         program if this is not acceptable, or if you do not       */
/*         understand the implication of registering the exit        */
/*         program CBX2611.                                          */
/*                                                                   */
/*  NOTE:  This program will register an exit program for the exit   */
/*         point QIBM_QMH_REPLY_INQ. Do not compile and run this     */
/*         program if this is not acceptable, or if you do not       */
/*         understand the implication of registering the exit        */
/*         program CBX2612.                                          */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX261M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod   &UtlLib/CBX2611                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )

     CrtPgm      &UtlLib/CBX2611                 +
                 Module( &UtlLib/CBX2611 )       +
                 ActGrp( INQEXT )


     CrtRpgMod   &UtlLib/CBX2612                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )

     CrtPgm      &UtlLib/CBX2612                 +
                 Module( &UtlLib/CBX2612 )       +
                 ActGrp( INQRPY )


     AddExitPgm  ExitPnt( QIBM_QMH_HDL_INQEXT )  +
                 Format( INQE0100 )              +
                 PgmNbr( *LOW )                  +
                 Pgm( &UtlLib/CBX2611 )

     AddExitPgm  ExitPnt( QIBM_QMH_REPLY_INQ )   +
                 Format( RPYI0100 )              +
                 PgmNbr( *LOW )                  +
                 Pgm( &UtlLib/CBX2612 )


     SndPgmMsg   Msg( 'Exit programs'                     *Bcat +
                      'successfully created in library'   *Bcat +
                      &UtlLib                             *Bcat +
                      'and registered.' )                       +
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

