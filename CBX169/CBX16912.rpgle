     **
     **  Program . . : CBX16912
     **  Description : Data Queue Sample Application - SVRATR Request
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX16912 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX16912 )
     **               Module( CBX16912 )
     **               ActGrp( *CALLER )
     **
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt: *NoDebugIo )  BndDir( 'CBX169B' )

     **-- Input file:
     FQATOCSTARTIF   E           K Disk

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  MsgId                         7a   Overlay( PgmSts:  40 )
     D  Msg                          80a   Overlay( PgmSts:  91 )
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )
     **-- Global constants:
     D RSP_DTA_OFS     c                   68

     **-- TCPSVR server attributes request - SVRATR:
     D SvrAtrRqs       Ds          8192    Qualified
     D  DtaPtc                        6a
     D  TrnId                        16a
     D  RqsId                         6a
     D  MsgFmt                        8a
     D  MsgLng                        3a
     **
     D  SvrNam                       30a
     **-- TCPSVR server attributes response:
     D SvrAtrRsp       Ds          8192    Qualified  Inz
     D  DtaPtc                        6a   Inz( 'TCPSVR' )
     D  TrnId                        16a
     D  RqsId                         6a   Inz( 'SVRATR' )
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

     **-- Format server name:
     D FmtSvrNam       Pr            32a   Varying
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const
     **-- Get server type:
     D GetSvrTyp       Pr             1a
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const
     **-- Add error/event log record:
     D AddErrLog       Pr
     D  PxLogTyp                      6a   Const
     D  PxTrnId                      16a   Const  Options( *Omit )
     D  PxPgmMod                     12a   Const  Options( *Omit )
     D  PxFunction                   12a   Const  Options( *Omit )
     D  PxDiagCod                     4s 0 Const  Options( *Omit )
     D  PxDiagMsg                     7a   Const  Options( *Omit )
     D  PxDiagDta                   512a   Const  Options( *Omit )

     **-- Entry parameters:
     D CBX16912        Pr
     D  PxSvrAtrRqs                        Like( SvrAtrRqs )
     D  PxSvrAtrRsp                        Like( SvrAtrRsp )
     **
     D CBX16912        Pi
     D  PxSvrAtrRqs                        Like( SvrAtrRqs )
     D  PxSvrAtrRsp                        Like( SvrAtrRsp )

      /Free

        SvrAtrRqs = PxSvrAtrRqs;

        ExSr  InzSvrAtr;

        Chain  SvrAtrRqs.SvrNam  QATOCSTART;

        If  %Found;
          ExSr  RtnSvrAtr;
        Else;
          SvrAtrRsp.ErrCod = 2001;
        EndIf;

        PxSvrAtrRsp = SvrAtrRsp;

        Return;


        BegSr  InzSvrAtr;

          Reset  SvrAtrRsp;

          SvrAtrRsp.TrnId = SvrAtrRqs.TrnId;
          SvrAtrRsp.RspDtaOfs = RSP_DTA_OFS;

        EndSr;

        BegSr  RtnSvrAtr;

          pSvrAtrDta = %Addr( SvrAtrRsp ) + SvrAtrRsp.RspDtaOfs;

          SvrAtrDta.SvrTyp = GetSvrTyp( SERVER: SERVERTYPE );
          SvrAtrDta.SvrNam = FmtSvrNam( SERVER: SERVERTYPE );
          SvrAtrDta.AutStr = AUTOSTART;
          SvrAtrDta.PgmNam = PROGRAM;
          SvrAtrDta.PgmLib = LIBRARY;
          SvrAtrDta.StrCmd = EXTSTRCMD;
          SvrAtrDta.EndCmd = EXTENDCMD;

        EndSr;

        BegSr  *PsSr;

          If  Not *InLr;
            *InLr = *On;

            AddErrLog( 'LOGERR'
                     : SvrAtrRqs.TrnId
                     : PgmSts.PgmNam
                     : '*PSSR'
                     : *Omit
                     : PgmSts.MsgId
                     : PgmSts
                     );
          EndIf;

        EndSr  '*CANCL';

      /End-Free
