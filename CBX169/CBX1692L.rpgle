     **
     **  Program . . : CBX1692L
     **  Description : Display TCP/IP Servers - UIM List Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX1692L )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX1692L )
     **               Module( CBX1692L )
     **               ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'CBX169B' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a

     **-- Global constants:
     D MAX_LST_ENT     c                   24
     **
     D APP_DTQ_INB     c                   'CBX169I'
     D APP_DTQ_OUT     c                   'CBX169O'
     D APP_DTQ_LIB     c                   'QGPL'
     **-- Global variables:
     D Idx             s             10i 0
     D RtnEntNbr       s             10i 0
     D CurEntNbr       s             10i 0

     **-- TCPSVR server list request - SVRLST:
     D SvrLstRqs       Ds          8192    Qualified
     D  DtaPtc                        6a   Inz( 'TCPSVR' )
     D  TrnId                        16a
     D  RqsId                         6a   Inz( 'SVRLST' )
     D  MsgFmt                        8a   Inz( 'SVRL0100' )
     D  MsgLng                        3a   Inz( 'ENU' )
     D  MsgOfsVal                    30a
     D  NbrEntRqs                     4s 0
     **
     D  SvrTyp                        1a
     **-- TCPSVR server list response:
     D SvrLstRsp       Ds          8192    Qualified
     D  DtaPtc                        6a
     D  TrnId                        16a
     D  RqsId                         6a
     D  EvtCod                        4s 0
     D  ErrCod                        4s 0
     D  EvtMsgOfs                     4s 0
     D  ErrMsgOfs                     4s 0
     D  RspDtaOfs                     4s 0
     D  MsgOfsVal                    30a
     D  NbrEntRtn                     4s 0
     D  RtnEntLen                     4s 0
     **
     D SvrLstDta       Ds          8192    Qualified  Based( pSvrLstDta )
     D  SvrTyp                        1a
     D  SvrKey                       30a
     D  SvrNam                       30a
     D  AutStr                        4a

     **-- UIM constants:
     D LIST_TOP        c                   'TOP'
     D LIST_BOT        c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D POS_SAME        c                   'SAME'
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     D  LstCnt                        4a

     **-- UIM exit program interfaces:
     **-- Incomplete list:
     D Type6           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D                               10a
     D  LstNam                       10a
     D  IncLstDir                    10i 0
     D  NbrEntRqd                    10i 0

     **-- UIM Panel control record:
     D CtlRcd          Ds                  Qualified
     D  Action                        4a
     D  EntLocOpt                     4a
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified  Inz
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  SvrTyp                        1a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  SvrTyp                        1a
     D  SvrKey                       30a
     D  SvrNam                       30a
     D  AutStr                        4a

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

     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D CBX1692L        Pr
     D  PxType6                            LikeDs( Type6 )
     **
     D CBX1692L        Pi
     D  PxType6                            LikeDs( Type6 )

      /Free

        GetDlgVar( PxType6.AppHdl
                 : HdrRcd
                 : %Size( HdrRcd )
                 : 'HDRRCD'
                 : ERRC0100
                 );

        GetDlgVar( PxType6.AppHdl
                 : CtlRcd
                 : %Size( CtlRcd )
                 : 'CTLRCD'
                 : ERRC0100
                 );

        If  CtlRcd.Action = 'LIST'  Or  CtlRcd.Action = 'F05';
          ExSr  InzEntLst;
        EndIf;

        ExSr  AddEntLst;

        CtlRcd.EntLocOpt = UIM.EntLocOpt;
        CtlRcd.Action = *Blanks;

        PutDlgVar( PxType6.AppHdl
                 : CtlRcd
                 : %Size( CtlRcd )
                 : 'CTLRCD'
                 : ERRC0100
                 );

        Return;


        BegSr  InzEntLst;

          UIM.EntLocOpt = 'FRST';

          SvrLstRqs.TrnId = GetUUID();
          SvrLstRqs.SvrTyp = HdrRcd.SvrTyp;
          SvrLstRqs.MsgOfsVal = *Blanks;

          RtnEntNbr = *Zero;

        EndSr;


        BegSr  AddEntLst;

          CurEntNbr = *Zero;

          If  PxType6.NbrEntRqd > MAX_LST_ENT;
            SvrLstRqs.NbrEntRqs = MAX_LST_ENT;
          Else;
            SvrLstRqs.NbrEntRqs = PxType6.NbrEntRqd;
          EndIf;

          PutDtaQ( APP_DTQ_INB: APP_DTQ_LIB: SvrLstRqs );

          SvrLstRsp = GetDtaQk( APP_DTQ_OUT: APP_DTQ_LIB: SvrLstRqs.TrnId );

          If  SvrLstRsp.DtaPtc = *Blanks;
            SndEscMsg( 'Server job currently not active' );
          EndIf;

          If  SvrLstRsp.ErrCod = *Zeros;
            pSvrLstDta = %Addr( SvrLstRsp ) + SvrLstRsp.RspDtaOfs;

            For  Idx = 1  to  SvrLstRsp.NbrEntRtn;

              ExSr  PutLstEnt;

              If  Idx < SvrLstRsp.NbrEntRtn;
                pSvrLstDta += SvrLstRsp.RtnEntLen;
              EndIf;
            EndFor;
          EndIf;

          Select;
          When  SvrLstRsp.ErrCod > *Zero;
            UIM.LstCnt = LIST_COMP;

          When  SvrLstRsp.MsgOfsVal = *Blanks;
            UIM.LstCnt = LIST_COMP;

          Other;
            UIM.LstCnt = LIST_TOP;
          EndSl;

          SetLstAtr( PxType6.AppHdl
                   : 'DTLLST'
                   : UIM.LstCnt
                   : EXIT_SAME
                   : POS_SAME
                   : TRIM_SAME
                   : ERRC0100
                   );

          SvrLstRqs.MsgOfsVal = SvrLstRsp.MsgOfsVal;

        EndSr;

        BegSr  PutLstEnt;

          CurEntNbr += 1;

          LstEnt.Option = *Zero;

          LstEnt.SvrTyp = SvrLstDta.SvrTyp;
          LstEnt.SvrKey = SvrLstDta.SvrKey;
          LstEnt.SvrNam = SvrLstDta.SvrNam;
          LstEnt.AutStr = SvrLstDta.AutStr;

          AddLstEnt( PxType6.AppHdl
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

      /End-Free
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
