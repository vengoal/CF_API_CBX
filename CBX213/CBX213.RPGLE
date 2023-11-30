     **
     **  Program . . :  CBX213
     **  Description :  Work with Command Exit Programs - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  System iNetwork Programming Tips Newsletter
     **  Date  . . . :  March 25, 2010
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX213 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX213 )
     **              Module( CBX213 )
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
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
     D CMP_EQ          c                   1
     D ALL_EXIT_FMT    c                   '*ALL'
     D ALL_EXIT_PGM    c                   -1
     D RTV_CMD_EXIT    c                   'QIBM_QCA_RTV_COMMAND'
     D CHG_CMD_EXIT    c                   'QIBM_QCA_CHG_COMMAND'
     **-- Global variables:
     D Idx             s             10i 0
     D SysDts          s               z
     D CntHdl          s             16a   Inz( *Blanks )
     D ExpNam          s             20a
     D ExpFmt          s              8a

     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX213P   *LIBL     '
     D PNLGRP          c                   'CBX213P   '
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
     D  ExitPg                       20a   Inz( 'CBX213E   *LIBL' )

     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified  Inz
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  ExpNam                       20a
     D  ExpDsc                       50a
     D  CmdExit                      10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  PgmNbr                       10u 0
     D  PgmNam_q                     20a
     D   PgmNam                      10a   Overlay( PgmNam_q:  1 )
     D   PgmLib                      10a   Overlay( PgmNam_q: 11 )
     D  PgmDsc                       50a
     D  CmdNam_q                     20a
     D   CmdNam                      10a   Overlay( CmdNam_q:  1 )
     D   CmdLib                      10a   Overlay( CmdNam_q: 11 )
     D  CmdDsc                       50a
     D  FmtNam                        8a
     D  PgmDta                       22a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
     **-- Exit point information:
     D EXTI0100        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  CntHdl                       16a   Inz
     D  OfsLstEnt                    10i 0
     D  NbrLstEnt                    10i 0
     D  LenLstEnt                    10i 0
     **
     D ExpEnt          Ds                  Qualified  Based( pLstEnt )
     D  ExpNam                       20a
     D  ExpFmtNam                     8a
     D  MaxNbrExtPgm                 10i 0
     D  CurNbrExtPgm                 10i 0
     D  AlwDeReg                      1a
     D  AlwChgEpCtl                   1a
     D  RegExtPnt                     1a
     D  PpEpNamAdd                   10a
     D  PpEpLibAdd                   10a
     D  PpEpFmtAdd                    8a
     D  PpEpNamRmv                   10a
     D  PpEpLibRmv                   10a
     D  PpEpFmtRmv                    8a
     D  PpEpNamRtv                   10a
     D  PpEpLibRtv                   10a
     D  PpEpFmtRtv                    8a
     D  ExpDscInd                     1a
     D  ExpDscMsgF                   10a
     D  ExpDscLib                    10a
     D  ExpDscMsId                    7a
     D  ExpTxtDsc                    50a
     **-- Exit point information:
     D EXTI0300        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  CntHdl                       16a
     D  OfsPgmEnt                    10i 0
     D  NbrPgmEnt                    10i 0
     D  LenPgmEnt                    10i 0
     **
     D PgmEnt          Ds                  Qualified  Based( pLstEnt )
     D  OfsNxtEnt                    10i 0
     D  ExitPntNam                   20a
     D  ExitPntFmt                    8a
     D  RegExitPnt                    1a
     D  CompEnt                       1a
     D                                2a
     D  ExitPgmNbr                   10i 0
     D  ExitPgmNam                   10a
     D  ExitPgmLib                   10a
     D  ExitPgmDscI                   1a
     D  ExitMsfNam                   10a
     D  ExitMsfLib                   10a
     D  ExitMsgId                     7a
     D  ExitPgmTxt                   50a
     D                                2a
     D  PgmDtaCcsId                  10i 0
     D  OfsPgmDta                    10i 0
     D  LenPgmDta                    10i 0
     D  ThdSafe                       1a
     D  MltThdAcn                     1a
     D  MtaSysVal                     1a
     D                                1a
     **
     D PgmDta          s            256a   Varying
     **-- Exit program selection criteria:
     D PgmSltCri       Ds                  Qualified
     D  NbrCri                       10i 0 Inz( 0 )
     D  SltEnt                             Dim( 1 )
     D   SizCriEnt                   10i 0 Overlay( SltEnt: 1 )
     D                                     Inz( %Size( PgmSltCri.SltEnt ))
     D   CmpOpr                      10i 0 Overlay( SltEnt: *Next )
     D                                     Inz( CMP_EQ )
     D   StrPos                      10i 0 Overlay( SltEnt: *Next )
     D                                     Inz( *Zero )
     D   DtaLen                      10i 0 Overlay( SltEnt: *Next )
     D   CmpDta                     256a   Overlay( SltEnt: *Next )

     **-- Retrieve exit point information:
     D RtvExitInf      Pr                  ExtProc('QusRetrieveExitInformation')
     D  ConHdl                       16a   Const
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ExitPntNam                   20a   Const
     D  ExitPntFmt                    8a   Const
     D  ExitPgmNbr                   10i 0 Const
     D  SltInf                    32767a   Const  Options( *VarSize )
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                     3096a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve message:
     D RtvMsg          Pr                  ExtPgm( 'QMHRTVM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  RplSubVal                    10a   Const
     D  RtnFmtChr                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  RtvOpt                       10a   Const  Options( *NoPass )
     D  CvtCcsId                     10i 0 Const  Options( *NoPass )
     D  RplCcsId                     10i 0 Const  Options( *NoPass )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
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
     **-- Open print application:
     D OpnPrtApp       Pr                  ExtPgm( 'QUIOPNPA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  PrtDevF_q                    20a   Const
     D  AltFilNam                    10a   Const
     D  ShrOpnDtaPth                  1a   Const
     D  UsrDta                       10a   Const
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
     **-- Print panel:
     D PrtPnl          Pr                  ExtPgm( 'QUIPRTP' )
     D  AppHdl                        8a   Const
     D  PrtPnlNam                    10a   Const
     D  EjtOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
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

     **-- Retrieve message text:
     D RtvMsgTxt       Pr          1024a   Varying
     D  PxMsgId                       7a   Value
     D  PxMsgFil                     10a   Value
     D  PxMsgFilLib                  10a   Value
     D  PxMsgDta                   1024a   Const  Varying
     D                                     Options( *NoPass: *Trim )
     **-- Get object description:
     D GetObjDsc       Pr            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D SltCri          Ds                  Qualified
     D  NbrElm                        5i 0
     D  CmdNam_q                     20a
     D   CmdNam                      10a   Overlay( CmdNam_q:  1 )
     D   CmdLib                      10a   Overlay( CmdNam_q: 11 )
     D  PgmNam_q                     20a
     D   PgmNam                      10a   Overlay( PgmNam_q:  1 )
     D   PgmLib                      10a   Overlay( PgmNam_q: 11 )
     **
     D CBX213          Pr
     D  PxCmdExit                    10a
     D  PxSltCri                           LikeDs( SltCri )
     **
     D CBX213          Pi
     D  PxCmdExit                    10a
     D  PxSltCri                           LikeDs( SltCri )

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
        ExSr  BldCmdLst;

        DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;

          DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );

          Select;
          When  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;

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
            ExSr  DltCmdLst;
          EndIf;

          If  UIM.FncRqs = KEY_F05;
            ExSr  BldCmdLst;
            ExSr  SetLstPos;
          EndIf;

          ExSr  BldHdrRcd;
        EndDo;

        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );

        *InLr = *On;
        Return;

        BegSr  BldCmdlst;

          UIM.EntLocOpt = 'FRST';

          ExSr  SetSltCri;

          DoU  CntHdl = *Blanks;

            RtvExitInf( CntHdl
                      : EXTI0300
                      : %Size( EXTI0300 )
                      : 'EXTI0300'
                      : HdrRcd.ExpNam
                      : ALL_EXIT_FMT
                      : ALL_EXIT_PGM
                      : PgmSltCri
                      : ERRC0100
                      );

            If  ERRC0100.BytAvl > *Zero;
              Leave;

            Else;
              CntHdl = EXTI0300.CntHdl;
            EndIf;

            ExSr  PrcLstEnt;
          EndDo;

        EndSr;

        BegSr  SetSltCri;

          Select;
          When  PxSltCri.CmdNam <> '*ANY'  And  PxSltCri.CmdLib <> '*ANY';
            PgmSltCri.NbrCri = 1;
            PgmSltCri.DtaLen(PgmSltCri.NbrCri) = %Size( PxSltCri.CmdNam_q );
            PgmSltCri.CmpDta(PgmSltCri.NbrCri) = PxSltCri.CmdNam_q;

          When  PxSltCri.CmdNam <> '*ANY';
            PgmSltCri.NbrCri = 1;
            PgmSltCri.DtaLen(PgmSltCri.NbrCri) = %Size( PxSltCri.CmdNam );
            PgmSltCri.CmpDta(PgmSltCri.NbrCri) = PxSltCri.CmdNam;

          When  PxSltCri.CmdLib <> '*ANY';
            PgmSltCri.NbrCri = 1;
            PgmSltCri.StrPos(PgmSltCri.NbrCri) += %Size( PxSltCri.CmdNam );
            PgmSltCri.DtaLen(PgmSltCri.NbrCri) = %Size( PxSltCri.CmdLib );
            PgmSltCri.CmpDta(PgmSltCri.NbrCri) = PxSltCri.CmdLib;
          EndSl;

        EndSr;

        BegSr  PrcLstEnt;

          pLstEnt = %Addr( EXTI0300 ) + EXTI0300.OfsPgmEnt;

          For Idx = 1  To EXTI0300.NbrPgmEnt;

            If  PgmEnt.LenPgmDta <= *Zero;
              PgmDta = NULL;

            Else;
              PgmDta = %Subst( EXTI0300
                             : PgmEnt.OfsPgmDta + 1
                             : PgmEnt.LenPgmDta
                             );
            EndIf;

            ExSr  VldSltCri;

            If  PgmEnt.OfsNxtEnt > *Zero;
              pLstEnt = %Addr( EXTI0300 ) + PgmEnt.OfsNxtEnt;
            EndIf;
          EndFor;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_COMP
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  VldSltCri;

          If  PxSltCri.PgmNam = '*ANY'  Or
              PxSltCri.PgmNam = PgmEnt.ExitPgmNam;

            If  PxSltCri.PgmLib = '*ANY'  Or
                PxSltCri.PgmLib = PgmEnt.ExitPgmLib;

              ExSr  PutLstEnt;
            EndIf;
          EndIf;

        EndSr;

        BegSr  PutLstEnt;

          LstEnt.Option   = *Zero;
          LstEnt.PgmNam   = PgmEnt.ExitPgmNam;
          LstEnt.PgmLib   = PgmEnt.ExitPgmLib;
          LstEnt.PgmNbr   = PgmEnt.ExitPgmNbr;

          LstEnt.CmdNam_q = PgmDta;
          LstEnt.CmdDsc   = GetObjDsc( LstEnt.CmdNam_q: '*CMD' );
          LstEnt.FmtNam   = PgmEnt.ExitPntFmt;
          LstEnt.PgmDta   = '''' + PgmDta + '''';

          ExSr  GetPgmTxt;

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

        EndSr;

        BegSr  GetPgmTxt;

          If  PgmEnt.ExitPgmDscI = '1';
            LstEnt.PgmDsc = PgmEnt.ExitPgmTxt;
          Else;
            LstEnt.PgmDsc = RtvMsgTxt( PgmEnt.ExitMsgId
                                     : PgmEnt.ExitMsfNam
                                     : PgmEnt.ExitMsfLib
                                     );
          EndIf;

          If  LstEnt.PgmDsc = '*BLANK';
            LstEnt.PgmDsc   = GetObjDsc( LstEnt.PgmNam_q: '*PGM' );
          EndIf;

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
                     : 'EQ        PGMNBR'
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

        BegSr  DltCmdLst;

          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );

        EndSr;

        BegSr  BldHdrRcd;

          SysDts = %Timestamp();

          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';
          HdrRcd.CmdExit = PxCmdExit;

          ExSr  InzHdrRcd;

          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );

        EndSr;

        BegSr  InzHdrRcd;

          If  PxCmdExit = '*CHG';
            HdrRcd.ExpNam = CHG_CMD_EXIT;
          Else;
            HdrRcd.ExpNam = RTV_CMD_EXIT;
          EndIf;

          RtvExitInf( CntHdl
                    : EXTI0100
                    : %Size( EXTI0100 )
                    : 'EXTI0100'
                    : HdrRcd.ExpNam
                    : ALL_EXIT_FMT
                    : ALL_EXIT_PGM
                    : PgmSltCri
                    : ERRC0100
                    );

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          pLstEnt = %Addr( EXTI0100 ) + EXTI0100.OfsLstEnt;

          If  ExpEnt.ExpDscInd = '1';
            HdrRcd.ExpDsc = ExpEnt.ExpTxtDsc;
          Else;
            HdrRcd.ExpDsc = RtvMsgTxt( ExpEnt.ExpDscMsId
                                     : ExpEnt.ExpDscMsgF
                                     : ExpEnt.ExpDscLib
                                     );
          EndIf;

        EndSr;

        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

      /End-Free

     **-- Retrieve message text:
     P RtvMsgTxt       B                   Export
     D                 Pi          1024a   Varying
     D  PxMsgId                       7a   Value
     D  PxMsgFil                     10a   Value
     D  PxMsgFilLib                  10a   Value
     D  PxMsgDta                   1024a   Const  Varying
     D                                     Options( *NoPass: *Trim )

     **-- Local variables:
     D MsgDta          s           1024a   Varying
     **-- Local constants:
     D NULL            c                   ''
     D RPL_SUB_VAL     c                   '*YES'
     D IGN_FMT_CTL     c                   '*NO'
     D JOB_CCSID       c                   0
     **-- Return structure:
     D RTVM0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  RtnMsgLen                    10i 0
     D  RtnMsgAvl                    10i 0
     D  RtnHlpLen                    10i 0
     D  RtnHlpAvl                    10i 0
     D  Msg                        1024a

      /Free

        If  %Parms >= 4;
          MsgDta = PxMsgDta;
        EndIf;

        RtvMsg( RTVM0100
              : %Size( RTVM0100 )
              :'RTVM0100'
              : PxMsgId
              : PxMsgFil + PxMsgFilLib
              : MsgDta
              : %Len( MsgDta )
              : RPL_SUB_VAL
              : IGN_FMT_CTL
              : ERRC0100
              );

        If  ERRC0100.BytAvl = *Zero;
          Return  %SubSt( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen );

        Else;
          Return  NULL;
        EndIf;

      /End-Free

     P RtvMsgTxt       E
     **-- Get object description:
     P GetObjDsc       B
     D                 Pi            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  ObjDsc                       50a   Overlay( OBJD0200: 101 )

      /Free

         RtvObjD( OBJD0200
                : %Size( OBJD0200 )
                : 'OBJD0200'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );

         If  ERRC0100.BytAvl > *Zero;
           Return  *Blanks;

         Else;
           Return  OBJD0200.ObjDsc;
         EndIf;

      /End-Free

     P GetObjDsc       E
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
     **-- Send completion message:
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return  0;

        EndIf;

      /End-Free

     P SndCmpMsg       E
