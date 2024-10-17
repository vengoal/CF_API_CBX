     **
     **  Program . . : CBX136M
     **  Description : Materialize Resource Management Data - example
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : May 26, 2005
     **
     **
     **  Compile options:
     **
     **    CrtRpgMod Module( CBX136M )  DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX136M )
     **              Module( CBX136M )
     **              ActGrp( QILE )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- Global constants:
     D AUX_STORAGE     c                   x'12'
     **-- Global variables:
     D Idx             s              5i 0

     **-- Resource management data:
     D RscMgtDta       Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( RscMgtDta ))
     D  BytAvl                       10i 0
     D  TimDay                        8a
     D  RscDtaStr
     D   CtlInf                      64a   Overlay( RscDtaStr: 1 )
     D    NbrAsp                      5i 0 Overlay( CtlInf:  1 )
     D    NbrAlcAux                   5i 0 Overlay( CtlInf: *Next )
     D    NbrUlcAux                   5i 0 Overlay( CtlInf: *Next )
     D    Rsv1                        2a   Overlay( CtlInf: *Next )
     D    MaxAuxTmp                  20i 0 Overlay( CtlInf: *Next )
     D    Rsv2                       12a   Overlay( CtlInf: *Next )
     D    OfsUnitInf                 10i 0 Overlay( CtlInf: *Next )
     D    NbrUnitMir                  5i 0 Overlay( CtlInf: *Next )
     D    MirMainStg                 10i 0 Overlay( CtlInf: *Next )
     D    Rsv3                        2a   Overlay( CtlInf: *Next )
     D    CurAuxTmp                  20i 0 Overlay( CtlInf: *Next )
     D    NbrBytPag                  10i 0 Overlay( CtlInf: *Next )
     D    NbrIndAsp                   5u 0 Overlay( CtlInf: *Next )
     D    NbrDskAsp                   5u 0 Overlay( CtlInf: *Next )
     D    NbrBasAsp                   5u 0 Overlay( CtlInf: *Next )
     D    NbrDsuBas                   5u 0 Overlay( CtlInf: *Next )
     D    NbrDsuSas                   5u 0 Overlay( CtlInf: *Next )
     D    Rsv4                        2a   Overlay( CtlInf: *Next )
     D   RscDta                   65455a   Overlay( RscDtaStr: *Next )
     **-- ASP information:
     D RmdAspInf       Ds                  Based( pAspInf )  Qualified
     D  AspInf                      160a   Dim( 256 )
     D   AspNbr                       5i 0 Overlay( AspInf:  1 )
     D   AspCtlFlg                    1a   Overlay( AspInf: *Next )
     D   AspOvfRcy                    1a   Overlay( AspInf: *Next )
     D   NbrAlcAux                    5u 0 Overlay( AspInf: *Next )
     D   Rsv1                         2a   Overlay( AspInf: *Next )
     D   AspMedCap                   20i 0 Overlay( AspInf: *Next )
     D   Rsv2                         8a   Overlay( AspInf: *Next )
     D   AspSpcAvl                   20i 0 Overlay( AspInf: *Next )
     D   AspEvtThr                   20i 0 Overlay( AspInf: *Next )
     D   AspEvtThp                    5i 0 Overlay( AspInf: *Next )
     D   AspAddFlg                    2a   Overlay( AspInf: *Next )
     D   AspCmpRcy                    1a   Overlay( AspInf: *Next )
     D   Rsv3                         3a   Overlay( AspInf: *Next )
     D   AspSysStg                   20i 0 Overlay( AspInf: *Next )
     D   AspOvfStg                   20i 0 Overlay( AspInf: *Next )
     D   SpcAlcErr                   10i 0 Overlay( AspInf: *Next )
     D   SpcAlcMch                   10i 0 Overlay( AspInf: *Next )
     D   SpcAlcTrc                   10i 0 Overlay( AspInf: *Next )
     D   SpcAlcMsd                   10i 0 Overlay( AspInf: *Next )
     D   SpcAlcMic                   10i 0 Overlay( AspInf: *Next )
     D   Rsv4                         4a   Overlay( AspInf: *Next )
     D   AvlStgLlm                   20i 0 Overlay( AspInf: *Next )
     D   PrtSpcCap                   20i 0 Overlay( AspInf: *Next )
     D   UnpspcCap                   20i 0 Overlay( AspInf: *Next )
     D   PrtSpcAvl                   20i 0 Overlay( AspInf: *Next )
     D   UnpSpcAvl                   20i 0 Overlay( AspInf: *Next )
     D   Rsv5                        32a   Overlay( AspInf: *Next )
     **-- Disk unit information:
     D RmdUnitInf      Ds                  Based( pUnitInf )  Qualified
     D  UnitInf                     208a   Dim( 128 )
     D   DevTyp                       8a   Overlay( UnitInf:  1 )
     D    DskTyp                      4a   Overlay( DevTyp:  1 )
     D    DskMod                      4a   Overlay( DevTyp: *Next )
     D   DevId                        8a   Overlay( UnitInf: *Next )
     D    UnitNbr                     5i 0 Overlay( DevId :  1 )
     D    UnitRsv1                    6a   Overlay( DevId : *Next )
     D   Rsv1                         4a   Overlay( UnitInf: *Next )
     D   AspNbr                       5i 0 Overlay( UnitInf: *Next )
     D   LglMirSts                    1a   Overlay( UnitInf: *Next )
     D   MirUnitSts                   1a   Overlay( UnitInf: *Next )
     D   UnitMedCap                  20i 0 Overlay( UnitInf: *Next )
     D   UnitStgCap                  20i 0 Overlay( UnitInf: *Next )
     D   UnitSpcAvl                  20i 0 Overlay( UnitInf: *Next )
     D   UnitSpcSys                  20i 0 Overlay( UnitInf: *Next )
     D   Rsv2                         6a   Overlay( UnitInf: *Next )
     D   UnitCtlFlg                   2a   Overlay( UnitInf: *Next )
     D   Rsv3                        16a   Overlay( UnitInf: *Next )
     D   Rsv4                        42a   Overlay( UnitInf: *Next )
     D   UnitId                      22a   Overlay( UnitInf: *Next )
     D    SrlNbr                     10a   Overlay( UnitId :  1 )
     D    RscNam                     10a   Overlay( UnitId : *Next )
     D    UnitRsv2                    2a   Overlay( UnitId : *Next )
     D   UsgInf                      64a   Overlay( UnitInf: *Next )
     D    BtfTms                     10i 0 Overlay( UsgInf:  1 )
     D    BtfFms                     10i 0 Overlay( UsgInf: *Next )
     D    RdtTms                     10i 0 Overlay( UsgInf: *Next )
     D    RdtFms                     10i 0 Overlay( UsgInf: *Next )
     D    PbtFms                     10i 0 Overlay( UsgInf: *Next )
     D    RpdFms                     10i 0 Overlay( UsgInf: *Next )
     D    UnitRsv3                    8a   Overlay( UsgInf: *Next )
     D    SmpCnt                     10i 0 Overlay( UsgInf: *Next )
     D    NobCnt                     10i 0 Overlay( UsgInf: *Next )
     D    UnitRsv4                   24a   Overlay( UsgInf: *Next )
     **-- API control data:
     D MatCtlDta       Ds                  Qualified
     D  SltOpt                        1a   Inz( AUX_STORAGE )
     D  Rsv                           7a   Inz( *Allx'00' )

     **-- Materialize resource management data:
     D MatRmd          Pr                  ExtProc('_MATRMD')
     D  Rcv                                Like( RscMgtDta )
     D  Ctl                                Like( MatCtlDta )

      /Free

        MatRmd( RscMgtDta: MatCtlDta );

        pAspInf = %Addr( RscMgtDta.RscDta );
        pUnitInf = %Addr( RscMgtDta ) + RscMgtDta.OfsUnitInf;

        For  Idx = 1  to RscMgtDta.NbrAsp;
          RmdAspInf.AspInf(Idx) = RmdAspInf.AspInf(Idx);
        EndFor;

        For  Idx = 1  to RscMgtDta.NbrAlcAux;
          RmdUnitInf.UnitInf(Idx) = RmdUnitInf.UnitInf(Idx);
        EndFor;

        *InLr = *On;
        Return;

      /End-Free

