     **
     **  Program . . : CBX1692E
     **  Description : Display TCP/IP Servers - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX1692E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX1692E )
     **               Module( CBX1692E )
     **               ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'CBX169B' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

     **-- Global constants:
     D APP_DTQ_INB     c                   'CBX169I'
     D APP_DTQ_OUT     c                   'CBX169O'
     D APP_DTQ_LIB     c                   'QGPL'

     **-- Global variables:
     D StrOfs          s             10i 0
     D StrLen          s             10i 0

     **-- UIM constants:
     D PNLGRP2         c                   'CBX1692P2 '
     D RDS_OPT_INZ     c                   'N'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
     D INC_EXP         c                   'Y'
     D CPY_VAR         c                   'Y'
     D CPY_VAR_NO      c                   'N'
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  EntLocOpt                     4a
     D  FncRqs                       10i 0 Inz
     **-- UIM constants:
     D APP_PRTF        c                   'QPRINT    *LIBL'
     D ODP_SHR         c                   'N'
     D SPLF_NAM        c                   'PDSPTCPSVR'
     D SPLF_USRDTA     c                   'DSPTCPSVR'
     D EJECT_NO        c                   'N'
     D CLO_NRM         c                   'M'
     D RES_OK          c                   0
     D RES_ERR         c                   1

     **-- TCPSVR server attributes request - SVRATR:
     D SvrAtrRqs       Ds          8192    Qualified
     D  DtaPtc                        6a   Inz( 'TCPSVR' )
     D  TrnId                        16a
     D  RqsId                         6a   Inz( 'SVRATR' )
     D  MsgFmt                        8a   Inz( 'SVRA0100' )
     D  MsgLng                        3a   Inz( 'ENU' )
     **
     D  SvrNam                       30a
     **-- TCPSVR server attributes response:
     D SvrAtrRsp       Ds          8192    Qualified
     D  DtaPtc                        6a
     D  TrnId                        16a
     D  RqsId                         6a
     D  EvtCod                        4s 0
     D  ErrCod                        4s 0
     D  EvtMsgOfs                     4s 0
     D  ErrMsgOfs                     4s 0
     D  RspDtaOfs                     4s 0
     **
     D SvrAtrDta       Ds                  Qualified  Based( pSvrAtrDta )
     D  SvrTyp                        1a
     D  SvrNam                       30a
     D  AutStr                        4a
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  StrCmd                       64a
     D  EndCmd                       64a

     **-- UIM API return structures:
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  SvrTyp                        1a
     D  SvrKey                       30a
     D  SvrNam                       30a
     D  AutStr                        4a
     **-- UIM Panel display record:
     D DspRcd          Ds                  Qualified  Inz
     D  SvrTyp                        1a
     D  SvrNam                       30a
     D  AutStr                        4a
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  StrCmd                       64a
     D  EndCmd                       64a

     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     **-- Function key - call:
     D Type1           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  FncKey                       10i 0
     **-- Action list option/Pull-down field choice - call (type 3/9):
     D Type3           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  LstNam                       10a
     D  LstEntHdl                     4a
     D  OptNbr                       10i 0
     D  FncQlf                       10i 0
     D  PdwFldNam                    10a

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
     **-- Delete list:
     D DltLst          Pr                  ExtPgm( 'QUIDLTL' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
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
     **-- Add print application:
     D AddPrtApp       Pr                  ExtPgm( 'QUIADDPA' )
     D  AppHdl                        8a   Const
     D  PrtDevF_q                    20a   Const
     D  AltFilNam                    10a   Const
     D  ShrOpnDtaPth                  1a   Const
     D  UsrDta                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Remove print application:
     D RmvPrtApp       Pr                  ExtPgm( 'QUIRMVPA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )

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

     **-- Get universal unique identifier:
     D GetUUID         Pr            16a
     **-- Put to data queue:
     D PutDtaQ         Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )

     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D CBX1692E        Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX1692E        Pi
     D  PxUimExit                          LikeDs( UimExit )

      /Free

          Select;
          When  PxUimExit.TypCall = 1;
            Type1 = PxUimExit;

            If  Type1.FncKey = 21;
              ExSr  PrtJobPnl;
            EndIf;

          When  PxUimExit.TypCall = 3;
            Type3 = PxUimExit;

            If  Type3.OptNbr = 5;
              ExSr  DspSvrDta;
            EndIf;
          EndSl;

        Return;


        BegSr  PrtJobPnl;

          AddPrtApp( Type1.AppHdl
                   : APP_PRTF
                   : SPLF_NAM
                   : ODP_SHR
                   : SPLF_USRDTA
                   : ERRC0100
                   );

          PrtPnl( Type1.AppHdl
                : 'PRTHDR'
                : EJECT_NO
                : ERRC0100
                );

          PrtPnl( Type1.AppHdl
                : 'PRTLST'
                : EJECT_NO
                : ERRC0100
                );

          RmvPrtApp( Type1.AppHdl
                   : CLO_NRM
                   : ERRC0100
                   );

          SndCmpMsg( 'List has been printed.' );

        EndSr;

        BegSr  DspSvrDta;

          GetLstEnt( Type3.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : Type3.LstNam
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type3.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );

          Clear  DspRcd;

          DspRcd.SvrTyp = LstEnt.SvrTyp;
          DspRcd.SvrNam = LstEnt.SvrNam;
          DspRcd.AutStr = LstEnt.AutStr;

          SvrAtrRqs.TrnId = GetUUID();
          SvrAtrRqs.SvrNam = LstEnt.SvrKey;

          PutDtaQ( APP_DTQ_INB: APP_DTQ_LIB: SvrAtrRqs );

          SvrAtrRsp = GetDtaQk( APP_DTQ_OUT: APP_DTQ_LIB: SvrAtrRqs.TrnId );

          If  SvrAtrRsp.DtaPtc = *Blanks;
            SndEscMsg( 'Server job currently not active' );
          EndIf;

          If  SvrAtrRsp.ErrCod = *Zeros;
            pSvrAtrDta = %Addr( SvrAtrRsp ) + SvrAtrRsp.RspDtaOfs;

            DspRcd.PgmNam = SvrAtrDta.PgmNam;
            DspRcd.PgmLib = SvrAtrDta.PgmLib;
            DspRcd.StrCmd = SvrAtrDta.StrCmd;
            DspRcd.EndCmd = SvrAtrDta.EndCmd;
          EndIf;

          PutDlgVar( Type3.AppHdl
                   : DspRcd
                   : %Size( DspRcd )
                   : 'DSPRCD'
                   : ERRC0100
                   );

          DspPnl( Type3.AppHdl: UIM.FncRqs: PNLGRP2: RDS_OPT_INZ: ERRC0100 );

        EndSr;

      /End-Free

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

     **
     P SndCmpMsg       E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying

     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9898'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*CTLBDY'
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

     P SndEscMsg       E
