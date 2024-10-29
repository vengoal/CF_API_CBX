     **
     **  Program . . : CBX169
     **  Description : Data Queue Sample Application - Service Functions
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 22, 2007
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX169 )
     **               DbgView( *LIST )
     **
     **    CrtSrvPgm  SrvPgm( CBX169 )
     **               Module( CBX169 )
     **               Export( *SRCFILE )
     **               SrcFile( QSRVSRC )
     **               SrcMbr( CBX169B )
     **               ActGrp( *CALLER )
     **
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H NoMain  Option( *SrcStmt: *NoDebugIo )

     **-- Log files:
     FCBX1691F  O    E           K Disk    Block( *No )  UsrOpn
     FCBX1692F  O    E           K Disk    Block( *No )

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  AppNam                        9a   Overlay( PgmNam )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a

     **-- Global constants:
     D APP_DTQ_INB     c                   'CBX169I'
     D APP_DTQ_OUT     c                   'CBX169O'
     D APP_DTQ_LIB     c                   'QGPL'
     D TMO_SEC_25      c                   25

     **-- Send data queue entry:
     D SndDtaQe        Pr                  ExtPgm( 'QSNDDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0 Const
     D  Dta                       32767a   Const  Options( *VarSize )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  AscRqs                       10a   Const  Options( *NoPass )
     D  JrnDta                       10a   Const  Options( *NoPass )
     **-- Receive data queue entry:
     D RcvDtaQe        Pr                  ExtPgm( 'QRCVDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0
     D  Dta                       32767a          Options( *VarSize )
     D  Wait                          5p 0 Const
     D  KeyOrder                      2a   Const  Options( *NoPass )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  SndInLg                       3p 0 Const  Options( *NoPass)
     D  SndInfo                      44a          Options( *VarSize: *Nopass )
     D  RmvMsg                       10a   Const  Options( *Nopass )
     D  DtaRcvLen                     5p 0 Const  Options( *Nopass )
     D  Error                     32767a          Options( *VarSize: *Nopass )
     **-- Retrieve message description:
     D RtvMsgD         Pr                  ExtPgm( 'QMHRTVM' )
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
     D  DtaCcsId                     10i 0 Const  Options( *NoPass )
     **-- Generate universal unique identifier:
     D GenUuid         Pr                  ExtProc( '_GENUUID' )
     D  UUID_template                  *   Value

     **-- Retrieve message:
     D RtvMsg          Pr          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgF_q                     20a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Get universal unique identifier:
     D GetUUID         Pr            16a
     **-- Put to data queue:
     D PutDtaQ         Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
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
     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     **-- Format server name:
     D FmtSvrNam       Pr            32a   Varying
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const
     **-- Get server type:
     D GetSvrTyp       Pr             1a
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const
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

     **-- Retrieve message:
     P RtvMsg          B                   Export
     D                 Pi          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgF_q                     20a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D RTVM0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  RtnMsgLen                    10i 0
     D  RtnMsgAvl                    10i 0
     D  RtnHlpLen                    10i 0
     D  RtnHlpAvl                    10i 0
     D  Msg                        4096a
     **
     D NULL            c                   ''
     D RPL_SUB_VAL     c                   '*YES'
     D NOT_FMT_CTL     c                   '*NO'

      /Free

        RtvMsgD( RTVM0100
               : %Size( RTVM0100 )
               : 'RTVM0100'
               : PxMsgId
               : PxMsgF_q
               : PxMsgDta
               : %Len( PxMsgDta )
               : RPL_SUB_VAL
               : NOT_FMT_CTL
               : ERRC0100
               );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  NULL;

        When  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen ) = PxMsgId;
          Return  %Subst( RTVM0100.Msg
                        : RTVM0100.RtnMsgLen + 1
                        : RTVM0100.RtnHlpLen
                        );

        Other;
          Return  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen );
        EndSl;

      /End-Free

     P RtvMsg          E
     **-- Get universal unique identifier:
     P GetUUID         B                   Export
     D                 Pi            16a

     **-- UUID template:
     D UUID_t          Ds                  Qualified
     D  BytPrv                       10u 0 Inz( %Size( UUID_t ))
     D  BytAvl                       10u 0
     D                                8a   Inz( *Allx'00' )
     D  UUID                         16a

      /Free

        GenUuid( %Addr( UUID_t ));

        Return  UUID_t.UUID;

      /End-Free

     P GetUUID         E
     **-- Put to data queue:
     P PutDtaQ         B                   Export
     D                 Pi
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )

      /Free

        SndDtaQe( PxDtqNam
                : PxDtqLib
                : %Len( PxDtqEnt )
                : PxDtqEnt
                );

        Return;

      /End-Free

     P PutDtaQ         E
     **-- Get from data queue:
     P GetDtaQ         B                   Export
     D                 Pi         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const

     D DtaLen          s              5p 0
     D DtaRcv          s          65535a

      /Free

        RcvDtaQe( PxDtqNam
                : PxDtqLib
                : DtaLen
                : DtaRcv
                : TMO_SEC_25
                );

        Return  %Subst( DtaRcv: 1: DtaLen );

      /End-Free

     P GetDtaQ         E
     **-- Put to data queue - keyed:
     P PutDtaQk        B                   Export
     D                 Pi
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )

      /Free

        SndDtaQe( PxDtqNam
                : PxDtqLib
                : %Len( PxDtqEnt )
                : PxDtqEnt
                : %Len( PxDtqKey )
                : PxDtqKey
                );

        Return;

      /End-Free

     P PutDtaQk        E
     **-- Get from data queue - keyed:
     P GetDtaQk        B                   Export
     D                 Pi         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )

     D DtaLen          s              5p 0
     D DtaRcv          s          65535a
     D SndInfo         s             36a

      /Free

        RcvDtaQe( PxDtqNam
                : PxDtqLib
                : DtaLen
                : DtaRcv
                : TMO_SEC_25
                : 'EQ'
                : %Len( PxDtqKey )
                : PxDtqKey
                : *Zero
                : SndInfo
                : '*YES'
                : %Size( DtaRcv )
                : ERRC0100
                );

        Return  %Subst( DtaRcv: 1: DtaLen );

      /End-Free

     P GetDtaQk        E
     **-- Format server name:
     P FmtSvrNam       B                   Export
     D                 Pi            32a   Varying
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const

      /Free

        Select;
        When  PxSvrTyp = 'T';
          Return  %Trim( PxSvrNam );

        When  %Subst( PxSvrNam: 1: 3) = 'NFS';
          Return  '*' + %Trim( PxSvrNam );

        When  %Subst( PxSvrNam: 1: 4) = 'HOST';
          Return  '*' + %Trim( %Subst( PxSvrNam: 5 ));

        Other;
          Return  '*' + %Trim( PxSvrNam );
        EndSl;

      /End-Free

     P FmtSvrNam       E
     **-- Get server type:
     P GetSvrTyp       B                   Export
     D                 Pi             1a
     D  PxSvrNam                     32a   Const
     D  PxSvrTyp                      1a   Const

      /Free

        Select;
        When  PxSvrTyp = 'T';
          Return  PxSvrTyp;

        When  %Subst( PxSvrNam: 1: 3) = 'NFS';
          Return  'N';

        When  %Subst( PxSvrNam: 1: 4) = 'HOST';
          Return  'H';

        Other;
          Return  'H';
        EndSl;

      /End-Free

     P GetSvrTyp       E
     **-- Add transaction log record:
     P AddTrnLog       B                   Export
     D                 Pi
     D  PxTrnId                      16a   Const
     D  PxDtaPtc                      6a   Const
     D  PxRqsId                       6a   Const
     D  PxRqsTyp                      1a   Const
     D  PxLogDta                   4096a   Const  Varying  Options( *VarSize )

      /Free

        LGTSTP = %Timestamp();
        LGTYPE = 'LOGTRN';

        LGTRID = PxTrnId;
        LGDTPC = PxDtaPtc;
        LGRQID = PxRqsId;
        LGRQTP = PxRqsTyp;
        LGDATA = PxLogDta;

        Write  CBX1692R;

      /End-Free

     P AddTrnLog       E
     **-- Add error/event log record:
     P AddErrLog       B                   Export
     D                 Pi
     D  PxLogTyp                      6a   Const
     D  PxTrnId                      16a   Const  Options( *Omit )
     D  PxPgmMod                     12a   Const  Options( *Omit )
     D  PxFunction                   12a   Const  Options( *Omit )
     D  PxDiagCod                     4s 0 Const  Options( *Omit )
     D  PxDiagMsg                     7a   Const  Options( *Omit )
     D  PxDiagDta                   512a   Const  Options( *Omit )

      /Free

        Open  CBX1691F;

        Clear  CBX1691R;

        LGTSTP = %Timestamp();
        LGTYPE = PxLogTyp;

        If  %Addr( PxTrnId ) <> *Null;
          LGTRID = PxTrnId;
        EndIf;

        If  %Addr( PxPgmMod ) <> *Null;
          LGPGMN = PxPgmMod;
        EndIf;

        If  %Addr( PxFunction ) <> *Null;
          LGFUNC = PxFunction;
        EndIf;

        If  %Addr( PxDiagCod ) <> *Null;
          LGDGCD = PxDiagCod;
        EndIf;

        If  %Addr( PxDiagMsg ) <> *Null;
          LGDGMS = PxDiagMsg;
        EndIf;

        If  %Addr( PxDiagDta ) <> *Null;
          LGDGDT = PxDiagDta;
        EndIf;

        Write  CBX1691R;

        Close  CBX1691F;

      /End-Free

     P AddErrLog       E
