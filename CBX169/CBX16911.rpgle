     **
     **  Program . . : CBX16911
     **  Description : Data Queue Sample Application - SVRLST Request
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX16911 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX16911 )
     **               Module( CBX16911 )
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
     D MIN_LST_ENT     c                   1
     D MAX_LST_ENT     c                   24
     D RSP_LST_OFS     c                   86

     **-- TCPSVR server list request - SVRLST:
     D SvrLstRqs       Ds          8192    Qualified
     D  DtaPtc                        6a
     D  TrnId                        16a
     D  RqsId                         6a
     D  MsgFmt                        8a
     D  MsgLng                        3a
     D  MsgOfsVal                    30a
     D  NbrEntRqs                     4s 0
     **
     D  SvrTyp                        1a
     **-- TCPSVR server list response:
     D SvrLstRsp       Ds          8192    Qualified  Inz
     D  DtaPtc                        6a   Inz( 'TCPSVR' )
     D  TrnId                        16a
     D  RqsId                         6a   Inz( 'SVRLST' )
     D  EvtCod                        4s 0
     D  ErrCod                        4s 0
     D  EvtMsgOfs                     4s 0
     D  ErrMsgOfs                     4s 0
     D  RspDtaOfs                     4s 0
     D  MsgOfsVal                    30a
     D  NbrEntRtn                     4s 0
     D  RtnEntLen                     4s 0
     **
     D SvrLstDta       Ds                  Qualified  Based( pSvrLstDta )
     D  SvrTyp                        1a
     D  SvrKey                       30a
     D  SvrNam                       30a
     D  AutStr                        4a

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
     D CBX16911        Pr
     D  PxSvrLstRqs                        Like( SvrLstRqs )
     D  PxSvrLstRsp                        Like( SvrLstRsp )
     **
     D CBX16911        Pi
     D  PxSvrLstRqs                        Like( SvrLstRqs )
     D  PxSvrLstRsp                        Like( SvrLstRsp )

      /Free

        SvrLstRqs = PxSvrLstRqs;

        ExSr  InzSvrLst;

        SetLl  SvrLstRqs.MsgOfsVal  QATOCSTART;
        pSvrLstDta = %Addr( SvrLstRsp ) + SvrLstRsp.RspDtaOfs;

        Read  QATOCSTART;
        DoW  Not  %EoF;

          If  SERVERTYPE > *Blank  And  %Scan( 'SERVER(*ALL)': EXTSTRCMD ) = 0;

            If  SvrLstRqs.SvrTyp = '*'  Or  SvrLstRqs.SvrTyp = SERVERTYPE;
              ExSr  AddSvrLst;
            EndIf;
          EndIf;

          If  SvrLstRsp.MsgOfsVal > *Blanks;
            Leave;
          EndIf;

          Read  QATOCSTART;
        EndDo;

        PxSvrLstRsp = SvrLstRsp;

        Return;


        BegSr  InzSvrLst;

          Select;
          When  SvrLstRqs.NbrEntRqs > MAX_LST_ENT;
            SvrLstRqs.NbrEntRqs = MAX_LST_ENT;

          When  SvrLstRqs.NbrEntRqs < MIN_LST_ENT;
            SvrLstRqs.NbrEntRqs = MIN_LST_ENT;
          EndSl;

          Reset  SvrLstRsp;

          SvrLstRsp.TrnId = SvrLstRqs.TrnId;

          SvrLstRsp.NbrEntRtn = *Zero;
          SvrLstRsp.RspDtaOfs = RSP_LST_OFS;
          SvrLstRsp.RtnEntLen = %Size( SvrLstDta );

        EndSr;

        BegSr  AddSvrLst;

          If  SvrLstRsp.NbrEntRtn < SvrLstRqs.NbrEntRqs;
            SvrLstRsp.NbrEntRtn += 1;

            SvrLstDta.SvrTyp = GetSvrTyp( SERVER: SERVERTYPE );
            SvrLstDta.SvrKey = SERVER;
            SvrLstDta.SvrNam = FmtSvrNam( SERVER: SERVERTYPE );
            SvrLstDta.AutStr = AUTOSTART;

            pSvrLstDta += SvrLstRsp.RtnEntLen;
          Else;
            SvrLstRsp.MsgOfsVal = SERVER;
          EndIf;

        EndSr;

        BegSr  *PsSr;

          If  Not *InLr;
            *InLr = *On;

            AddErrLog( 'LOGERR'
                     : SvrLstRqs.TrnId
                     : PgmSts.PgmNam
                     : '*PSSR'
                     : *Omit
                     : PgmSts.MsgId
                     : PgmSts
                     );
          EndIf;

        EndSr  '*CANCL';

      /End-Free
