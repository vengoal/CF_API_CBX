     **
     **  Program . . : CBX1691
     **  Description : Data Queue Sample Application - TCPSVR Protocol
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX1691 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX1691 )
     **               Module( CBX1691 )
     **               ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'CBX169B' )

     **-- Global constants:
     D APP_DTQ_INB     c                   'CBX169I'
     D APP_DTQ_OUT     c                   'CBX169O'
     D APP_DTQ_LIB     c                   'QGPL'
     **-- Global variables:
     D LogTrn          s              1a

     **-- TCPSVR server request:
     D TcpSvrRqs       Ds          8192    Qualified
     D  DtaPtc                        6a
     D  TrnId                        16a
     D  RqsId                         6a
     D  MsgFmt                        8a
     D  MsgLng                        3a
     **-- TCPSVR server response:
     D TcpSvrRsp       Ds          8192    Qualified  Inz
     D  DtaPtc                        6a   Inz( 'TCPSVR' )
     D  TrnId                        16a
     D  RqsId                         6a
     D  EvtCod                        4s 0
     D  ErrCod                        4s 0
     D  EvtMsgOfs                     4s 0
     D  ErrMsgOfs                     4s 0

     **-- Get TCP/IP server list:
     D GetSvrLst       Pr                  ExtPgm( 'CBX16911' )
     D  PxTcpSvrRqs                        Like( TcpSvrRqs )
     D  PxTcpSvrRsp                        Like( TcpSvrRsp )
     **-- Get TCP/IP server attributes:
     D GetSvrAtr       Pr                  ExtPgm( 'CBX16912' )
     D  PxTcpSvrRqs                        Like( TcpSvrRqs )
     D  PxTcpSvrRsp                        Like( TcpSvrRsp )

     **-- Get from data queue:
     D GetDtaQ         Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     **-- Put to data queue - keyed:
     D PutDtaQk        Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     **-- Retrieve message:
     D RtvMsg          Pr          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgF_q                     20a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Add transaction log record:
     D AddTrnLog       Pr
     D  PxTrnId                      16a   Const
     D  PxDtaPtc                      6a   Const
     D  PxRqsId                       6a   Const
     D  PxRqsTyp                      1a   Const
     D  PxLogDta                   4096a   Const  Varying  Options( *VarSize )
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
     D CBX1691         Pr
     D  PxLogTrn                      1a
     **
     D CBX1691         Pi
     D  PxLogTrn                      1a

      /Free

        If  %Parms >= 1;
          LogTrn = PxLogTrn;
        Else;
          LogTrn = 'Y';
        EndIf;

        DoW  %Shtdn() = *Off;

          TcpSvrRqs = GetDtaQ( APP_DTQ_INB: APP_DTQ_LIB );

          If  TcpSvrRqs > *Blanks;

            If  LogTrn = 'Y';

              AddTrnLog( TcpSvrRqs.TrnId
                       : TcpSvrRqs.DtaPtc
                       : TcpSvrRqs.RqsId
                       : 'I'
                       : TcpSvrRqs
                       );
            EndIf;

            If  TcpSvrRqs.DtaPtc = 'TCPSVR';

              Select;
              When  TcpSvrRqs.RqsId = 'SVRLST';

                Monitor;
                  GetSvrLst( TcpSvrRqs: TcpSvrRsp );
                On-Error;
                  ExSr  RtnExcErr;
                EndMon;

              When  TcpSvrRqs.RqsId = 'SVRATR';

                Monitor;
                  GetSvrAtr( TcpSvrRqs: TcpSvrRsp );
                On-Error;
                  ExSr  RtnExcErr;
                EndMon;

              Other;
                ExSr  RtnRqsErr;
              EndSl;

            Else;
              ExSr  RtnPtcErr;
            EndIf;

            PutDtaQk( APP_DTQ_OUT: APP_DTQ_LIB: TcpSvrRsp: TcpSvrRsp.TrnId );

            If  LogTrn = 'Y';

              AddTrnLog( TcpSvrRsp.TrnId
                       : TcpSvrRsp.DtaPtc
                       : TcpSvrRsp.RqsId
                       : 'O'
                       : TcpSvrRsp
                       );
            EndIf;
          EndIf;
        EndDo;


        *InLr = *On;
        Return;


        BegSr  RtnPtcErr;

          Reset  TcpSvrRsp;

          TcpSvrRsp.TrnId  = TcpSvrRqs.TrnId;
          TcpSvrRsp.RqsId  = TcpSvrRqs.RqsId;
          TcpSvrRsp.EvtCod = *Zero;
          TcpSvrRsp.ErrCod = 0101;

        EndSr;

        BegSr  RtnRqsErr;

          Reset  TcpSvrRsp;

          TcpSvrRsp.TrnId  = TcpSvrRqs.TrnId;
          TcpSvrRsp.RqsId  = TcpSvrRqs.RqsId;
          TcpSvrRsp.EvtCod = *Zero;
          TcpSvrRsp.ErrCod = 0111;

        EndSr;

        BegSr  RtnExcErr;

          Reset  TcpSvrRsp;

          TcpSvrRsp.TrnId  = TcpSvrRqs.TrnId;
          TcpSvrRsp.RqsId  = TcpSvrRqs.RqsId;
          TcpSvrRsp.EvtCod = *Zero;
          TcpSvrRsp.ErrCod = 0001;

        EndSr;

      /End-Free
