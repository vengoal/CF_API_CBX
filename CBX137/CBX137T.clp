/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX137T                                            */
/*  Description : Retrieve Disk Attributes - sample program          */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : Club Tech iSeries Programming Tips Newsletter      */
/*  Date  . . . : June 16, 2005                                      */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX137T )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm

     Dcl        &RtnUnit     *Dec     10
     Dcl        &AspNbr      *Dec      3
     Dcl        &Type        *Char     4
     Dcl        &Model       *Char     4
     Dcl        &SrlNbr      *Char    10
     Dcl        &UnitCtl     *Dec      2

     Dcl        &RtnUnitC    *Char     5
     Dcl        &UnitCtlC    *Char     2

     RtvDskAtr  Disk( *FIRST )         +
                RtnUnit( &RtnUnit )    +
                AspNbr( &AspNbr )      +
                Type( &Type )          +
                Model( &Model )        +
                SrlNbr( &SrlNbr )      +
                UnitCtl( &UnitCtl )

 RtvNext:
     If ( &RtnUnit >  0 )    Do

     If ( &UnitCtl >  1 )    Do

     ChgVar     &RtnUnitC    &RtnUnit
     ChgVar     &UnitCtlC    &UnitCtl

     SndPgmMsg  MsgId( CPF9897 )                                +
                MsgF( QCPFMSG )                                 +
                MsgDta( 'Disk unit'                       *Bcat +
                        &RtnUnitC                         *Bcat +
                        'currently has unit status'       *Bcat +
                        &UnitCtlC                         *Tcat +
                        '.')                                    +
                ToMsgQ( *SYSOPR )

     EndDo

     RtvDskAtr  Disk( *NEXT )          +
                RtnUnit( &RtnUnit )    +
                AspNbr( &AspNbr )      +
                Type( &Type )          +
                Model( &Model )        +
                SrlNbr( &SrlNbr )      +
                UnitCtl( &UnitCtl )

     GoTo       RtvNext
     EndDo

 EndPgm:
     EndPgm
