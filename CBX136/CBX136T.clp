/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX136T                                            */
/*  Description : Retrieve ASP information - sample program          */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : Club Tech iSeries Programming Tips Newsletter      */
/*  Date  . . . : May 26, 2005                                       */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX136T )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm

     Dcl        &RtnAsp      *Dec      3
     Dcl        &NbrUnit     *Dec     10
     Dcl        &CapTot      *Dec     10
     Dcl        &CapAvl      *Dec     10
     Dcl        &Threshold   *Dec      3
     Dcl        &AspTyp      *Char     2

     Dcl        &AspUsedPct  *Dec   (  9 4 )
     Dcl        &StgBufPct   *Dec   (  9 4 )
     Dcl        &RtnAspC     *Char     3
     Dcl        &StgBufPctC  *Char     8


     RtvAspInf  Asp( *SYSASP )              +
                RtnAsp( &RtnAsp)            +
                NbrUnit( &NbrUnit )         +
                CapTot( &CapTot )           +
                CapAvl( &CapAvl )           +
                Threshold( &Threshold )     +
                AspTyp( &AspTyp )

     ChgVar     &AspUsedPct   ((( &CapTot - &CapAvl ) * 100 ) / &CapTot )

     ChgVar     &StgBufPct      ( &Threshold - &AspUsedPct )

     If ( &StgBufPct <  5 )    Do

     ChgVar     &RtnAspC     &RtnAsp
     ChgVar     &StgBufPctC  &StgBufPct

     SndPgmMsg  MsgId( CPF9897 )                                +
                MsgF( QCPFMSG )                                 +
                MsgDta( 'ASP number'                      *Bcat +
                        &RtnAspC                          *Bcat +
                        'threshold buffer percentage is'  *Bcat +
                        &StgBufPctC                       *Tcat +
                        '.')                                    +
                ToMsgQ( *SYSOPR )

     EndDo

 EndPgm:
     EndPgm
