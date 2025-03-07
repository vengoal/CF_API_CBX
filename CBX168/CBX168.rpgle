     **
     **  Program . . : CBX168
     **  Description : Work with Data Queues - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 8, 2007
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX168 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX168 )
     **                Module( CBX168 )
     **                ActGrp( *NEW )
     **
     **-- Header specifications:  --------------------------------------------**
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
     **
     D BIN_SGN         c                   0
     D NUM_ZON         c                   2
     D CHAR_NLS        c                   4
     D SORT_ASC        c                   '1'
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX168P   *LIBL     '
     D PNLGRP          c                   'CBX168P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
     D PRM_IFC_0       c                   0
     D CLO_NORM        c                   'M'
     D FNC_EXIT        c                   -4
     D FNC_CNL         c                   -8
     D KEY_F05         c                   5
     D KEY_F17         c                   17
     D KEY_F18         c                   18
     D RTN_ENTER       c                   500
     D HLP_WDW         c                   'N'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'

     **-- Global variables:
     D Idx             s             10i 0
     D SysDts          s               z

     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     **-- List attributes structure:
     D LstAtr          Ds                  Qualified
     D  LstCon                        4a
     D  ExtPgmVar                    10a
     D  DspPos                        4a
     D  AlwTrim                       1a

     **-- UIM Panel exit prgram record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX168E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  DtqNam                       10a
     D  DtqLib                       10a
     D  DtqTyp                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  DtqPos                       20a
     D  DtqNam                       10a
     D  DtqLib                       10a
     D  DtqTyp                       10a
     D  DtqDsc                       50a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )

     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0 Inz( 1 )
     D  NbrKeyRtn                    10i 0 Inz( %Elem( LstApi.KeyFld ))
     D  KeyFld                       10i 0 Dim( 1 )

     **-- Object information:
     D ObjInf          Ds          4096    Qualified
     D  ObjNam_q                     20a
     D   ObjNam                      10a   Overlay( ObjNam_q: 1 )
     D   ObjLib                      10a   Overlay( ObjNam_q: *Next )
     D  ObjTyp                       10a
     D  InfSts                        1a
     D                                1a
     D  FldNbrRtn                    10i 0
     D  Data                               Like( KeyInf )
     **-- Key information:
     D KeyInf          Ds                  Qualified  Based( pKeyInf )
     D  FldInfLen                    10i 0
     D  KeyFld                       10i 0
     D  DtaTyp                        1a
     D                                3a
     D  DtaLen                       10i 0
     D  Data                        256a
     **-- Object information key fields:
     D KEY0200         Ds                  Qualified
     D  InfSts                        1a
     D  ExtObjAtr                    10a
     D  TxtDsc                       50a
     D  UsrDfnAtr                    10a
     D  OrdLibL                      10i 0
     D                                5a
     **-- Authority control:
     D AutCtl          Ds                  Qualified
     D  AutFmtLen                    10i 0 Inz( %Size( AutCtl ))
     D  CalLvl                       10i 0 Inz( 0 )
     D  DplObjAut                    10i 0 Inz( 0 )
     D  NbrObjAut                    10i 0 Inz( 0 )
     D  DplLibAut                    10i 0 Inz( 0 )
     D  NbrLibAut                    10i 0 Inz( 0 )
     D                               10i 0 Inz( 0 )
     D  ObjAut                       10a   Dim( 10 )
     D  LibAut                       10a   Dim( 10 )
     **-- Selection control:
     D SltCtl          Ds
     D  SltFmtLen                    10i 0 Inz( %Size( SltCtl ))
     D  SltOmt                       10i 0 Inz( 0 )
     D  DplSts                       10i 0 Inz( 20 )
     D  NbrSts                       10i 0 Inz( 1 )
     D                               10i 0 Inz( 0 )
     D  Status                        1a   Inz( '*' )
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 4 )
     D  SrtStr                       12a   Dim( 4 )
     D   KeyFldOfs                   10i 0 Overlay( SrtStr:  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtStr:  5 )
     D   KeyFldTyp                    5i 0 Overlay( SrtStr:  9 )
     D   SrtOrd                       1a   Overlay( SrtStr: 11 )
     D   Rsv                          1a   Overlay( SrtStr: 12 )
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

     **-- Open list of objects:
     D LstObjs         Pr                  ExtPgm( 'QGYOLOBJ' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  SrtInf                     1024a   Const  Options( *VarSize )
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  AutCtl                     1024a   Const  Options( *VarSize )
     D  SltCtl                     1024a   Const  Options( *VarSize )
     D  NbrKeyRtn                    10i 0 Const
     D  KeyFld                       10i 0 Const  Options( *VarSize )  Dim( 32 )
     D  Error                      1024a          Options( *VarSize )
     **
     D  JobIdInf                    256a          Options( *NoPass: *VarSize )
     D  JobIdFmt                      8a   Const  Options( *NoPass )
     **
     D  AspCtl                      256a          Options( *NoPass: *VarSize )
     **-- Get open list entry:
     D GetOplEnt       Pr                  ExtPgm( 'QGYGTLE' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  Handle                        4a   Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  RtnRcdNbr                    10i 0 Const
     D  Error                      1024a          Options( *VarSize )
     **-- Close list:
     D CloseLst        Pr                  ExtPgm( 'QGYCLST' )
     D  Handle                        4a   Const
     D  Error                      1024a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )

     **-- Open display application:
     D OpnDspApp       Pr                  ExtPgm( 'QUIOPNDA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  FulScrHlp                     1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Display panel:
     D DspPnl          Pr                  ExtPgm( 'QUIDSPP' )
     D  AppHdl                        8a   Const
     D  FncRqs                       10i 0
     D  PnlNam                       10a   Const
     D  ReDspOpt                      1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  UsrTsk                        1a   Const  Options( *NoPass )
     D  CalStkCnt                    10i 0 Const  Options( *NoPass )
     D  CalMsgQue                   256a   Const  Options( *NoPass: *VarSize )
     D  MsgKey                        4a   Const  Options( *NoPass )
     D  CsrPosOpt                     1a   Const  Options( *NoPass )
     D  FinLstEnt                     4a   Const  Options( *NoPass )
     D  ErrLstEnt                     4a   Const  Options( *NoPass )
     D  WaitTim                      10i 0 Const  Options( *NoPass )
     D  CalMsgQueLen                 10i 0 Const  Options( *NoPass )
     D  CalQlf                       20a   Const  Options( *NoPass )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Add list entry:
     D AddLstEnt       Pr                  ExtPgm( 'QUIADDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  EntLocOpt                     4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QUIGETLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  PosOpt                        4a   Const
     D  CpyOpt                        1a   Const
     D  SltCri                       20a   Const
     D  SltHdl                        4a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve list attributes:
     D RtvLstAtr       Pr                  ExtPgm( 'QUIRTVLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  AtrRcv                    32767a          Options( *VarSize )
     D  AtrRcvLen                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Set list attributes:
     D SetLstAtr       Pr                  ExtPgm( 'QUISETLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  LstCon                        4a   Const
     D  ExtPgmVar                    10a   Const
     D  DspPos                        4a   Const
     D  AlwTrim                       1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Delete list:
     D DltLst          Pr                  ExtPgm( 'QUIDLTL' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Close application:
     D CloApp          Pr                  ExtPgm( 'QUICLOA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )

     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D CBX168          Pr
     D  PxDtqNam_q                         LikeDs( ObjNam_q )
     D  PxDtqTyp                     10a
     D  PxLstOrd                     10a
     **
     D CBX168          Pi
     D  PxDtqNam_q                         LikeDs( ObjNam_q )
     D  PxDtqTyp                     10a
     D  PxLstOrd                     10a

      /Free

        OpnDspApp( UIM.AppHdl
                 : PNLGRP_Q
                 : SCP_AUT_RCL
                 : PRM_IFC_0
                 : HLP_WDW
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;

        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );

        ExSr  BldHdrRcd;
        ExSr  BldDtqLst;

        DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;

          DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          Select;
          When  UIM.FncRqs = RTN_ENTER;
            Leave;

          When  UIM.FncRqs = KEY_F17;
            ExSr  PosLstTop;

          When  UIM.FncRqs = KEY_F18;
            ExSr  PosLstBot;
          EndSl;

          GetDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );

          If  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
            ExSr  GetLstPos;
            ExSr  DltDtqLst;
          EndIf;

          If  UIM.FncRqs = KEY_F05;
            ExSr  BldDtqLst;
            ExSr  SetLstPos;
          EndIf;

          ExSr  BldHdrRcd;
        EndDo;

        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );

        *InLr = *On;
        Return;


        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

        BegSr  BldDtqLst;

          UIM.EntLocOpt = 'FRST';

          ExSr  InzApiPrm;

          LstApi.RtnRcdNbr = 1;

          LstObjs( ObjInf
                 : %Size( ObjInf )
                 : LstInf
                 : -1
                 : SrtInf
                 : PxDtqNam_q
                 : '*DTAQ'
                 : AutCtl
                 : SltCtl
                 : LstApi.NbrKeyRtn
                 : LstApi.KeyFld
                 : ERRC0100
                 );

          If  ERRC0100.BytAvl = *Zero  And  LstInf.RcdNbrRtn > *Zero;
            ExSr  AddDtqEnt;

            DoW  LstInf.RcdNbrTot > LstApi.RtnRcdNbr;
              LstApi.RtnRcdNbr += 1;

              GetOplEnt( ObjInf
                       : %Size( ObjInf )
                       : LstInf.Handle
                       : LstInf
                       : 1
                       : LstApi.RtnRcdNbr
                       : ERRC0100
                       );

              If  ERRC0100.BytAvl > *Zero;
                Leave;
              EndIf;

              ExSr  AddDtqEnt;
            EndDo;
          EndIf;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_COMP
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );

          CloseLst( LstInf.Handle: ERRC0100 );

        EndSr;

        BegSr  AddDtqEnt;

          ExSr  GetKeyDta;

          If  PxDtqTyp = '*ALL'  Or
              PxDtqTyp = '*DDM'  And  KEY0200.ExtObjAtr = 'DDMDTAQUE'  Or
              PxDtqTyp = '*STD'  And  KEY0200.ExtObjAtr = *Blanks;

            LstEnt.Option = *Zero;

            LstEnt.DtqPos    = ObjInf.ObjNam_q;
            LstEnt.DtqNam    = ObjInf.ObjNam;
            LstEnt.DtqLib    = ObjInf.ObjLib;
            LstEnt.DtqTyp    = KEY0200.ExtObjAtr;
            LstEnt.DtqDsc    = KEY0200.TxtDsc;

            AddLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : UIM.EntLocOpt
                     : UIM.LstHdl
                     : ERRC0100
                     );

            UIM.EntLocOpt = 'NEXT';
          EndIf;

        EndSr;

        BegSr  GetKeyDta;

          pKeyInf = %Addr( ObjInf.Data );

          For  Idx = 1  To ObjInf.FldNbrRtn;

            Select;
            When  KeyInf.KeyFld = 200;
              KEY0200 = %Subst( KeyInf.Data: 1: KeyInf.DtaLen );
            EndSl;

            If  Idx < ObjInf.FldNbrRtn;
              pKeyInf = pKeyInf + KeyInf.FldInfLen;
            EndIf;
          EndFor;

        EndSr;

        BegSr  GetLstPos;

          RtvLstAtr( UIM.AppHdl: 'DTLLST': LstAtr: %Size( LstAtr ): ERRC0100 );

          If  LstAtr.DspPos <> 'TOP';

            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : 'HNDL'
                     : 'Y'
                     : *Blanks
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );

            LstEntPos = LstEnt;
          EndIf;

        EndSr;

        BegSr  SetLstPos;

          If  LstAtr.DspPos <> 'TOP';

            LstEnt = LstEntPos;

            PutDlgVar( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : ERRC0100
                     );

            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'FSLT'
                     : 'N'
                     : 'EQ        DTQPOS'
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );

            If  ERRC0100.BytAvl = *Zero;

              SetLstAtr( UIM.AppHdl
                       : 'DTLLST'
                       : LIST_SAME
                       : EXIT_SAME
                       : UIM.EntHdl
                       : TRIM_SAME
                       : ERRC0100
                       );

            EndIf;
          EndIf;

        EndSr;

        BegSr  BldHdrRcd;

          SysDts = %Timestamp();

          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';
          HdrRcd.DtqNam = PxDtqNam_q.ObjNam;
          HdrRcd.DtqLib = PxDtqNam_q.ObjLib;
          HdrRcd.DtqTyp = PxDtqTyp;

          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );

        EndSr;

        BegSr  PosLstTop;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  PosLstBot;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_BOT
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  DltDtqLst;

          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );

        EndSr;

        BegSr  InzApiPrm;

          LstApi.KeyFld(1) = 200;

          SrtInf.NbrKeys   = 2;

          If  PxLstOrd = '*DTAQ';
            SrtInf.KeyFldOfs(1) = 1;
            SrtInf.KeyFldLen(1) = %Size( LstEnt.DtqNam );
            SrtInf.KeyFldOfs(2) = 11;
            SrtInf.KeyFldLen(2) = %Size( LstEnt.DtqLib );
          Else;
            SrtInf.KeyFldOfs(1) = 11;
            SrtInf.KeyFldLen(1) = %Size( LstEnt.DtqLib );
            SrtInf.KeyFldOfs(2) = 1;
            SrtInf.KeyFldLen(2) = %Size( LstEnt.DtqNam );
          EndIf;

          SrtInf.KeyFldTyp(1) = CHAR_NLS;
          SrtInf.SrtOrd(1)    = SORT_ASC;
          SrtInf.Rsv(1)       = x'00';

          SrtInf.KeyFldTyp(2) = CHAR_NLS;
          SrtInf.SrtOrd(2)    = SORT_ASC;
          SrtInf.Rsv(2)       = x'00';

        EndSr;

      /End-Free

     **-- Send escape message:
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
