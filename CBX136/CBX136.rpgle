     **
     **  Program . . : CBX136
     **  Description : Retrieve ASP information - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : May 26, 2005
     **
     **
     **  Program summary
     **  ---------------
     **
     **  General Configuration APIs:
     **    QYASPOL       Open list of ASPs     Generates a list of ASPs or
     **                                        information about an ASP,
     **                                        including identification of all
     **                                        ASPs configured to a system,
     **                                        attributes of an ASP, unassigned
     **                                        disk units or disk units assigned
     **                                        to an ASP.
     **
     **  Open list APIs:
     **    QGYCLST       Close list            This API closes the previously
     **                                        opened list identified by the
     **                                        request handle parameter.
     **                                        Storage allocated is freed.
     **
     **
     **  Message handling API:
     **    QMHSNDPM      Send program message  Sends a message to a program stack
     **                                        entry (current, previous, etc.) or
     **                                        an external message queue.
     **
     **                                        Both messages defined in a message
     **                                        file and immediate messages can be
     **                                        used. For specific message types
     **                                        only one or the other is allowed.
     **
     **  Programmer's notes:
     **    Prior to V5R3 all Open List APIs are found in the QGY library.
     **    To run this program at V5R2 and earlier, library QGY needs to be
     **    in the job's library list.
     **
     **    Open List APIs are located in option 12 - 'Host Servers' - of the
     **    operation system, and this option needs to be installed for these
     **    APIs to be available.  Running the command DSPSFWRSC enables you
     **    to verify the presence of this option.
     **
     **
     **  Compile options:
     **
     **    CrtRpgMod Module( CBX136 )  DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX136 )
     **              Module( CBX136 )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
     **-- Global constants:
     D OFS_MSGDTA      c                   16

     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0 Inz( 1 )
     **-- ASP information:
     D YASP0200        Ds                  Qualified
     D  AspNbr                       10i 0
     D  NbrDskUnits                  10i 0
     D  AspCapTot                    10i 0
     D  AspCapAvl                    10i 0
     D  AspCapTotPtc                 10i 0
     D  AspCapAvlPtc                 10i 0
     D  AspCapTotUnp                 10i 0
     D  AspCapAvlUnp                 10i 0
     D  AspSysStg                    10i 0
     D  OvrFlwStg                    10i 0
     D  SpcAlcErrLog                 10i 0
     D  SpcAlcMchLog                 10i 0
     D  SpcAlcMchTrc                 10i 0
     D  SpcAlcMsd                    10i 0
     D  SpcAlcMic                    10i 0
     D  StgThhPct                    10i 0
     D  AspTyp                        2a
     D  OvrFlwRcyRsl                  1a
     D  EndImdCtl                     1a
     D  CmpRcyPol                     1a
     D  CmpDskUniAsp                  1a
     D  BalSts                        1a
     D  BalTyp                        1a
     D  BalDatTim                    13a
     D                                3a
     D  BalDtaMov                    10i 0
     D  BalDtaRem                    10i 0
     D  TrcDur                       10i 0
     D  TrcSts                        1a
     D  TrcDatTim                    13a
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 0 )
     D  SrtInf                       12a   Dim( 10 )
     D   KeyFldOfs                   10i 0 Overlay( SrtInf :  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtInf :  5 )
     D   KeyFldTyp                    5i 0 Overlay( SrtInf :  9 )
     D   SrtOrd                       1a   Overlay( SrtInf : 11 )
     D   Rsv                          1a   Overlay( SrtInf : 12 )
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  Handle                        4a
     D  RcdLen                       10i 0
     D  InfSts                        1a
     D  Dts                          13a
     D  LstSts                        1a
     D                                1a
     D  InfLen                       10i 0
     D  Rcd1                         10i 0
     D                               40a
     **-- Filter information:
     D FtrInf          Ds                  Qualified
     D  SizFtrEnt                    10i 0 Inz( %Size( FtrInf ))
     D  FtrKey                       10i 0 Inz( 1 )
     D  SizFtrDta                    10i 0 Inz( %Size( FtrInf.FtrDta ))
     D  FtrDta                       10i 0
     **-- Global variables:
     D MsgKey          s              4a
     D MsgTxt          s            512a   Varying
     D CmdStr          s            512a   Varying
     **-- Open list of ASPs:
     D LstAsps         Pr                  ExtPgm( 'QYASPOL' )
     D  LaRcvVar                  65535a          Options( *VarSize )
     D  LaRcvVarLen                  10i 0 Const
     D  LaLstInf                     80a
     D  LaNbrRcdRtn                  10i 0 Const
     D  LaNbrFlt                     10i 0 Const
     D  LaFltInf                     32a   Const  Options( *VarSize )
     D  LaFmtNam                      8a   Const
     D  LaError                    1024a          Options( *VarSize )
     D  LaSrtInf                   1024a   Const  Options( *VarSize: *NoPass )
     **-- Close list:
     D CloseLst        Pr                  ExtPgm( 'QGYCLST' )
     D  ClHandle                      4a   Const
     D  ClError                    1024a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  SpMsgId                       7a   Const
     D  SpMsgFq                      20a   Const
     D  SpMsgDta                    128a   Const
     D  SpMsgDtaLen                  10i 0 Const
     D  SpMsgTyp                     10a   Const
     D  SpCalStkE                    10a   Const  Options( *VarSize )
     D  SpCalStkCtr                  10i 0 Const
     D  SpMsgKey                      4a
     D  SpError                    1024a          Options( *VarSize )

     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     D CBX136          Pr
     D  PxAspNbr                     10i 0
     D  PxRtnAsp                      3p 0
     D  PxNbrUnit                    10p 0
     D  PxCapTot                     10p 0
     D  PxCapAvl                     10p 0
     D  PxCapTotPtc                  10p 0
     D  PxCapAvlPtc                  10p 0
     D  PxCapTotUnp                  10p 0
     D  PxCapAvlUnp                  10p 0
     D  PxSysStg                     10p 0
     D  PxOflStg                     10p 0
     D  PxThreshold                   3p 0
     D  PxAspTyp                      2a
     D  PxBalSts                      1a
     D  PxBalTyp                      1a
     D  PxBalDatTim                  13a
     D  PxBalDtaMov                  10p 0
     D  PxBalDtaRem                  10p 0
     D  PxTrcSts                      1a
     D  PxTrcDur                     10p 0
     D  PxTrcDatTim                  13a
     **
     D CBX136          Pi
     D  PxAspNbr                     10i 0
     D  PxRtnAsp                      3p 0
     D  PxNbrUnit                    10p 0
     D  PxCapTot                     10p 0
     D  PxCapAvl                     10p 0
     D  PxCapTotPtc                  10p 0
     D  PxCapAvlPtc                  10p 0
     D  PxCapTotUnp                  10p 0
     D  PxCapAvlUnp                  10p 0
     D  PxSysStg                     10p 0
     D  PxOflStg                     10p 0
     D  PxThreshold                   3p 0
     D  PxAspTyp                      2a
     D  PxBalSts                      1a
     D  PxBalTyp                      1a
     D  PxBalDatTim                  13a
     D  PxBalDtaMov                  10p 0
     D  PxBalDtaRem                  10p 0
     D  PxTrcSts                      1a
     D  PxTrcDur                     10p 0
     D  PxTrcDatTim                  13a

      /Free

        FtrInf.FtrDta = PxAspNbr;

        LstAsps( YASP0200
               : %Size( YASP0200 )
               : LstInf
               : 1
               : 1
               : FtrInf
               : 'YASP0200'
               : ERRC0100
               : SrtInf
               );

        If  ERRC0100.BytAvl > *Zero;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        Else;
          If  LstInf.RcdNbrRtn > *Zero;

            ExSr  PrcLstEnt;

            CloseLst( LstInf.Handle: ERRC0100 );
          EndIf;
        EndIf;

        *InLr = *On;
        Return;


        BegSr PrcLstEnt;

          If  %Addr( PxRtnAsp ) <> *Null;
            PxRtnAsp = YASP0200.AspNbr ;
          EndIf;

          If  %Addr( PxNbrUnit ) <> *Null;
            PxNbrUnit = YASP0200.NbrDskUnits;
          EndIf;

          If  %Addr( PxCapTot ) <> *Null;
            PxCapTot = YASP0200.AspCapTot;
          EndIf;

          If  %Addr( PxCapAvl ) <> *Null;
            PxCapAvl = YASP0200.AspCapAvl;
          EndIf;

          If  %Addr( PxCapTotPtc ) <> *Null;
            PxCapTotPtc = YASP0200.AspCapTotPtc;
          EndIf;

          If  %Addr( PxCapAvlPtc ) <> *Null;
            PxCapAvlPtc = YASP0200.AspCapAvlPtc;
          EndIf;

          If  %Addr( PxCapTotUnp ) <> *Null;
            PxCapTotUnp = YASP0200.AspCapTotUnp;
          EndIf;

          If  %Addr( PxCapAvlUnp ) <> *Null;
            PxCapAvlUnp = YASP0200.AspCapAvlUnp;
          EndIf;

          If  %Addr( PxSysStg ) <> *Null;
            PxSysStg = YASP0200.AspSysStg;
          EndIf;

          If  %Addr( PxOflStg ) <> *Null;
            PxOflStg = YASP0200.OvrFlwStg;
          EndIf;

          If  %Addr( PxThreshold ) <> *Null;
            PxThreshold = YASP0200.StgThhPct;
          EndIf;

          If  %Addr( PxAspTyp ) <> *Null;
            PxAspTyp = YASP0200.AspTyp;
          EndIf;

          If  %Addr( PxBalSts ) <> *Null;
            PxBalSts = YASP0200.BalSts;
          EndIf;

          If  %Addr( PxBalTyp ) <> *Null;
            PxBalTyp = YASP0200.BalTyp;
          EndIf;

          If  %Addr( PxBalDatTim ) <> *Null;
            PxBalDatTim = YASP0200.BalDatTim;
          EndIf;

          If  %Addr( PxBalDtaMov ) <> *Null;
            PxBalDtaMov = YASP0200.BalDtaMov;
          EndIf;

          If  %Addr( PxBalDtaRem ) <> *Null;
            PxBalDtaRem = YASP0200.BalDtaRem;
          EndIf;

          If  %Addr( PxTrcDur ) <> *Null;
            PxTrcDur = YASP0200.TrcDur;
          EndIf;

          If  %Addr( PxTrcSts ) <> *Null;
            PxTrcSts = YASP0200.TrcSts;
          EndIf;

          If  %Addr( PxTrcDatTim ) <> *Null;
            PxTrcDatTim = YASP0200.TrcDatTim;
          EndIf;
        EndSr;

      /End-Free

     **-- Send escape message:  ----------------------------------------------**
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
                 : PxMsgF + '*LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return   0;
        EndIf;

      /End-Free

     P SndEscMsg       E
