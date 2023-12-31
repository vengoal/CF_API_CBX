     **
     **  Program . . :  CBX2502
     **  Description :  Watch event exit program - CPF4131 Level check
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **  Parameters:
     **      1   Watch option setting   Input    Char(10)
     **      2   Session Id             Input    Char(10)
     **      3   Error detected         Output   Char(10)
     **      4   Event data             Input    Char(*)
     **
     **
     **      Allowed values for the "Watch option setting" parameter are:
     **
     **      *MSGID      A match on a message id or immediate/impromptu message,
     **                  message type, message severity and any associated
     **                  comparison data specified on WCHMSG parameter occurred.
     **
     **      *LICLOG     A match on a LIC log andany associated comparison data
     **                  specified on the WCHLICLOG parameter occurred.
     **
     **      *PAL        A match on a Product Activity Log (PAL) and any
     **                  associated comparison data specified on the WCHPAL
     **                  parameter occurred.
     **
     **      *STRWCH     The watch program will be called before starting
     **                  watching for any event.
     **
     **      *ENDWCH     The watch program will be called when the watch session
     **                  is ending.  Possible reasons might be:
     **
     **                   o  End Watch (ENDWCH) command or End Watch (QSCEWCH)
     **                      API was issued.
     **
     **                   o  One or more of the watch for event jobs ended
     **                      abnormally or ended by user action.
     **
     **                  Note: A watch session might end because an error was
     **                  detected on the watch exit program.  In this case, the
     **                  watch program will not be called at *ENDWCH time.
     **
     **
     **      The "Session ID" parameter contains the name of the watch session
     **      that is calling the user exit program.
     **
     **
     **      Allowed values for the "Error detected" parameter are:
     **
     **      *ERROR      Error detected by watch exit program. The watch session
     **                  that was passed in Session ID parameter will be ended.
     **                  If the watch session to be ended originally specified
     **                  multiple messages or LIC log entries or PAL entries, all
     **                  of them will no longer be watched. CPI3999 message will
     **                  be sent to the job log and the history log to indicate
     **                  an error in the exit program caused the watch session to
     **                  be ended.
     **
     **      <blanks>    No error detected by watch exit program.
     **
     **      Allowed values for the "Event data" parameter when *MSGID is
     **      specified for the "Watch option setting" parameter will be the
     **      following structure:
     **
     **          OFFSET     TYPE         FIELD
     **          Dec  Hex
     **            0    0   BINARY(4)    Length of watch information
     **            4    4   CHAR(7)      Message watched
     **           11    B   CHAR(1)      Reserved
     **           12    C   CHAR(10)     Message queue name
     **           22   16   CHAR(10)     Message queue library
     **           32   20   CHAR(10)     Job name
     **           42   2A   CHAR(10)     User name
     **           52   34   CHAR(6)      Job number
     **           58   3A   BINARY(4)    Original replacement data length
     **           62   3E   CHAR(256)    Sending program name
     **          318  13E   CHAR(10)     Sending module name
     **          328  148   BINARY(4)    Offset to sending procedure name
     **          332  14C   BINARY(4)    Length of sending procedure name
     **          336  150   CHAR(10)     Receiving program name
     **          346  15A   CHAR(10)     Receiving module name
     **          356  164   BINARY(4)    Offset to receiving procedure name
     **          360  168   BINARY(4)    Length of receiving procedure name
     **          364  16C   BINARY(4)    Message severity
     **          368  170   CHAR(10)     Message type
     **          378  17A   CHAR(8)      Message timestamp
     **          386  182   CHAR(4)      Message key
     **          390  186   CHAR(10)     Message file name
     **          400  190   CHAR(10)     Message file library
     **          410  19A   CHAR(2)      Reserved
     **          412  19C   BINARY(4)    Offset to comparison data
     **          416  1A0   BINARY(4)    Length of comparison data
     **          420  1A4   CHAR(10)     Compare against
     **          430  1AE   CHAR(2)      Reserved
     **          432  1B0   BINARY(4)    Comparison data CCSID
     **          436  1B4   BINARY(4)    Offset where comparison data was found
     **          440  1B8   BINARY(4)    Offset to replacement data
     **          444  1BC   BINARY(4)    Length of replacement data
     **          448  1C0   BINARY(4)    Replacement data CCSID
     **          452  1C4   CHAR(10)     Sending user profile
     **          462  1CE   CHAR(10)     Target job name
     **          472  1D8   CHAR(10)     Target job user name
     **          482  1E2   CHAR(6)      Target job number
     **           *   *     CHAR(*)      Sending procedure name
     **           *   *     CHAR(*)      Receiving procedure name
     **           *   *     CHAR(*)      Message comparison data
     **           *   *     CHAR(*)      Message replacement data
     **
     **      Allowed values for the "Event data" parameter when *LICLOG is
     **      specified for the "Watch option setting" parameter will be the
     **      following structure:
     **
     **          OFFSET     TYPE         FIELD
     **          Dec  Hex
     **            0    0   BINARY(4)    Length of watch information
     **            4    4   CHAR(4)      LIC Log major code
     **            8    8   CHAR(4)      LIC Log minor code
     **           12    C   CHAR(8)      LIC Log identifier
     **           20   14   CHAR(8)      LIC Log timestamp
     **           28   1C   CHAR(8)      TDE number
     **           36   24   CHAR(16)     Task name
     **           52   34   CHAR(30)     Server type
     **           82   52   CHAR(2)      Exception ID
     **           84   54   CHAR(10)     LIC job name
     **           94   5E   CHAR(10)     LIC user name
     **          104   68   CHAR(6)      LIC job number
     **          110   6E   CHAR(4)      Reserved
     **          114   72   CHAR(8)      Thread ID
     **          122   7A   CHAR(8)      LIC module compile timestamp
     **          130   82   CHAR(8)      LIC module offset
     **          138   8A   CHAR(8)      LIC module RU name
     **          146   92   CHAR(48)     LIC module name
     **          194   DA   CHAR(128)    LIC module entry point name
     **          322  142   CHAR(1)      LIC log compare against specified
     **          323  143   CHAR(1)      Reserved
     **          324  144   BINARY(4)    Offset to comparison data
     **          328  148   BINARY(4)    Length of comparison data
     **          332  14C   CHAR(10)     LIC log compare against
     **           *    *    CHAR(*)      LIC log comparison data
     **
     **      Allowed values for the "Event data" parameter when *PAL is specified
     **      for the "Watch option setting" parameter will be the following
     **      structure:
     **
     **          OFFSET     TYPE         FIELD
     **          Dec  Hex
     **            0    0   BINARY(4)    Length of watch information
     **            4    4   CHAR(8)      System reference code
     **           12    C   CHAR(10)     Device name
     **           22   16   CHAR(4)      Device type
     **           26   1A   CHAR(4)      Model
     **           30   1E   CHAR(15)     Serial number
     **           45   2D   CHAR(10)     Resource name
     **           55   37   CHAR(8)      Log identifier
     **           63   3F   CHAR(8)      PAL timestamp
     **           71   47   CHAR(4)      Reference code
     **           75   4B   CHAR(8)      Secondary code
     **           83   53   CHAR(8)      Table identifier
     **           91   5B   CHAR(1)      Reserved
     **           92   5C   BINARY(4)    Sequence
     **           96   60   BINARY(4)    Offset to comparison data
     **           100  64   BINARY(4)    Length of comparison data
     **           104  68   CHAR(10)     PAL compare against
     **           *   *     CHAR(*)      PAL comparison data
     **
     **      Allowed values for the "Event data" parameter when *STRWCH or
     **      *ENDWCH is specified for the "Watch option setting" parameter will
     **      be the following structure:
     **
     **          OFFSET     TYPE         FIELD
     **          Dec  Hex
     **            0    0   BINARY(4)    Length of watch information
     **          (always 4 at this time)
     **
     **
     **  Add watch definition command:
     **    AddWchDfn SsnId( LOGLVLCHK )
     **              WchPgm( CBX2502 )
     **              CallWchPgm( *STRWCH *ENDWCH )
     **              WchMsg(( CPF4131 *NONE *MSGDTA *ALL *GE 00 ))
     **              WchMsgQ(( *JOBLOG ))
     **              WchJob(( *ALL/*ALL ))
     **              Text( 'Forward job level check messages to message queue LOGLVLCHK')
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX2502 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX2502 )
     **              Module( CBX2502 )
     **              ActGrp( WCHEVT )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         Sds                  Qualified
     D  JobUsr                       10a   Overlay( PgmSts: 254 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
     **-- Global variables:
     D MsgKey          s              4a
     D MsgTxt          s           1024a   Varying
     D SysPtnID        s            512a   Varying
     **-- Global constants:
     D NULL            c                   ''
     D NO_WAIT         c                   0
     D JOB_CCSID       c                   0
     D PTN_STC_INF     c                   1
     D KEEP_STS        c                   '*SAME'
     D RTN_ERROR       c                   '*ERROR'
     D RTN_OK          c                   ' '
     D MSG_QUE_Q       c                   'QTVDEVICE QUSRSYS'

     **-- Watch event message ID data structure:
     D WchMsgId        Ds         65535    Qualified  Based( pWchMsgId )
     D  DtaLen                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgQue_q                     20a
     D   MsgQueNam                   10a   Overlay( MsgQue_q:  1 )
     D   MsgQueLib                   10a   Overlay( MsgQue_q: 11 )
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     D                                4a
     D  SndPgmNam                   256a
     D  SndModNam                    10a
     D  OfsSndPrcNam                 10i 0
     D  LenSndPrcNam                 10i 0
     D  RcvPgmNam                    10a
     D  RcvModNam                    10a
     D  OfsRcvPrcNam                 10i 0
     D  LenRcvPrcNam                 10i 0
     D  MsgSev                       10i 0
     D  MsgTyp                       10a
     D  MsgDts                        8a
     D  MsgKey                        4a
     D  MsgFil_q                     20a
     D   MsgFilNam                   10a   Overlay( MsgFil_q:  1 )
     D   MsgFilLib                   10a   Overlay( MsgFil_q: 11 )
     D                                2a
     D  OfsCmpDta                    10i 0
     D  LenCmpDta                    10i 0
     D  CmpAgainst                   10a
     D                                2a
     D  CmpDtaCcsId                  10i 0
     D  OfsCmpDtaFnd                 10i 0
     D  OfsMsgDta                    10i 0
     D  LenMsgDta                    10i 0
     D  MsgDtaCcsId                  10i 0
     **
     D MsgDta          s           3000a   Varying
     D MsgCmpDta       s           1000a   Varying
     D SndPrcNam       s           1000a   Varying
     D RcvPrcNam       s           1000a   Varying

     **-- Retrieve watch information:
     D RtvWchInf       Pr                  ExtPgm( 'QSCRWCHI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SsnId                        10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Send message:
     D SndMsg          Pr                  ExtPgm( 'QMHSNDM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  MsgQue_q                   1000a   Const  Options( *VarSize )
     D  MsgQueNbr                    10i 0 Const
     D  MsgQueRpy                    20a   Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     D  CcsId                        10i 0 Const  Options( *NoPass )
     **-- Receive non-program message:
     D RcvMsg          Pr                  ExtPgm( 'QMHRCVM' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  MsgQue_q                     20a   Const
     D  MsgTyp                       10a   Const
     D  MsgKey                        4a   Const
     D  Wait                         10i 0 Const
     D  MsgAct                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  CcsId                        10i 0 Const  Options( *NoPass )
     D  AlwDftRpyRjt                 10i 0 Const  Options( *NoPass )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLn                  10i 0 Const
     D  OptCtlBlkFm                   8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAv                  10i 0
     D  Error                     32767a          Options( *VarSize )

     **-- Get message text:
     D GetMsgTxt       Pr          1024a   Varying
     D  PxMsgQue_q                   20a   Const
     D  PxMsgKey                      4a   Const
     **-- Get watch user profile:
     D GetWchUsr       Pr            10a
     D  PxSsnId                      10a   Const
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  CmdStr                     1024a   Const  Varying
     **-- Get object qualified name:
     D GetObjQual      Pr            21a   Varying
     D  PxObjNam_q                   20a   Const

     **-- Entry parameters:
     D CBX2505         Pr
     D  PxWchOptSet                  10a
     D  PxSsnId                      10a
     D  PxErrDtc                     10a
     D  PxEvtDta                  65535a
     **
     D CBX2505         Pi
     D  PxWchOptSet                  10a
     D  PxSsnId                      10a
     D  PxErrDtc                     10a
     D  PxEvtDta                  65535a

      /Free

        PxErrDtc = RTN_OK;

        Select;
        When  PxWchOptSet = '*MSGID';
          ExSr  PrcMsgOpt;

        When  PxWchOptSet = '*STRWCH';
          ExSr  StrWchOpt;

        When  PxWchOptSet = '*ENDWCH';
          ExSr  EndWchOpt;
        EndSl;

        If  PxErrDtc = RTN_ERROR;
          ExSr  EndWchOpt;
        EndIf;

        Return;


        BegSr  StrWchOpt;

          MsgTxt = 'Watch session ' + %TrimR( PxSsnId ) + ' started.';

          SndMsg( *Blanks
                : *Blanks
                : MsgTxt
                : %Len( MsgTxt )
                : '*INFO'
                : GetWchUsr( PxSsnId ) + 'QUSRSYS'
                : 1
                : *Blanks
                : MsgKey
                : ERRC0100
                );

        EndSr;

        BegSr  EndWchOpt;

          MsgTxt = 'Watch session ' + %TrimR( PxSsnId ) + ' ended.';

          SndMsg( *Blanks
                : *Blanks
                : MsgTxt
                : %Len( MsgTxt )
                : '*INFO'
                : GetWchUsr( PxSsnId ) + 'QUSRSYS'
                : 1
                : *Blanks
                : MsgKey
                : ERRC0100
                );

        EndSr;

        BegSr  PrcMsgOpt;

          pWchMsgId = %Addr( PxEvtDta );

          // If  WchMsgId.MsgId = 'CPD3E3F'  Or
          //     WchMsgId.MsgId = 'CPIAD03'  Or
          //     WchMsgId.MsgId = 'CPIAD06';

            MsgDta = %Subst( WchMsgId
                           : WchMsgId.OfsMsgDta + 1
                           : WchMsgId.LenMsgDta
                           );

            SndMsg( WchMsgId.MsgId
                  : WchMsgId.MsgFil_q
                  : MsgDta
                  : %Len( MsgDta )
                  : '*INFO'
                  : MSG_QUE_Q
                  : 1
                  : *Blanks
                  : MsgKey
                  : ERRC0100
                  );

            If  ERRC0100.BytAvl > *Zero;
              PxErrDtc = RTN_ERROR;
            Else;
              PxErrDtc = RTN_OK;
            EndIf;
          // EndIf;

        EndSr;

        BegSr  *InzSr;

          If  ChkObj( MSG_QUE_Q: '*MSGQ' ) = *Off;

            PrcCmd( 'CRTMSGQ MSGQ(' + GetObjQual( MSG_QUE_Q ) + ') '      +
                            'TEXT(''Sign-on server job log message queue'')'
                  );
          EndIf;

        EndSr;

      /End-Free

     **-- Get message text:
     P GetMsgTxt       B
     D                 Pi          1024a   Varying
     D  PxMsgQue_q                   20a   Const
     D  PxMsgKey                      4a   Const

     **-- Message information structure:
     D RCVM0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  MsgSev                       10i 0
     D  MsgId                         7a
     D  MsgTyp                        2s 0
     D  MsgKey                        4a
     D  MsgFilNam                    10a
     D  MsgFilLib_s                  10a
     D  MsgFilLib_u                  10a
     D  SndJobNam                    10a
     D  SndJobUsr                    10a
     D  SndJobNbr                     6a
     D  SndPgmNam                    12a
     D                                4a
     D  DatSnt                        7s 0
     D  TimSnt                        6s 0
     D  TimSntMs                      6s 0
     D  SndUsrPrf                    10a
     D                                1a
     D  CcsIdStsTxt                  10i 0
     D  CcsIdStsDta                  10i 0
     D  AlrOpt                        9a
     D  CcsIdMsgTxt                  10i 0
     D  CcsIdMsgDta                  10i 0
     D  DtaLenRtn                    10i 0
     D  DtaLenAvl                    10i 0
     D  MsgLenRtn                    10i 0
     D  MsgLenAvl                    10i 0
     D  HlpLenRtn                    10i 0
     D  HlpLenAvl                    10i 0
     D  VarDta                    32767a

      /Free

        RcvMsg( RCVM0200
              : %Size( RCVM0200 )
              : 'RCVM0200'
              : PxMsgQue_q
              : '*RPY'
              : PxMsgKey
              : NO_WAIT
              : KEEP_STS
              : ERRC0100
              : JOB_CCSID
              );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  NULL;

        When  RCVM0200.BytAvl = *Zero;
          Return  NULL;

        Other;
          Return  %Subst( RCVM0200.VarDta
                        : RCVM0200.DtaLenRtn + 1
                        : RCVM0200.MsgLenRtn
                        );
        EndSl;

      /End-Free

     P GetMsgTxt       E
     **-- Get watch user profile:
     P GetWchUsr       B
     D                 Pi            10a
     D  PxSsnId                      10a   Const

     **-- Watch information:
     D WCHI0100        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  Origin                       10a
     D  UserId                       10a
     D  Status                       10a
     D  StrJobNam                    10a
     D  StrJobUsr                    10a
     D  StrJobNbr                     6a
     D                                4a
     D  StrJobCcsId                  10i 0
     D  WchSsnTyp                    10a
     D  WchPgmNam                    10a
     D  WchPgmLib                    10a
     D                                2a
     D  RunPty                       10i 0
     D  LenTimWch                    10i 0
     D  TimItv                       10i 0
     D  StrWchDts                     8a
     D  OfsWchPgmOpt                 10i 0
     D  NbrWchPgmOpt                 10i 0
     D  OfsMsgInf                    10i 0
     D  NbrMsg                       10i 0
     D  OfsLicLogInf                 10i 0
     D  NbrLicLog                    10i 0
     D  OfsPalInf                    10i 0
     D  NbrPal                       10i 0
     D  Data                       1024a
     **
     D WchPgmOpt       s             10a   Dim( 12 )

      /Free

        RtvWchInf( WCHI0100
                 : %Size( WCHI0100 )
                 : 'WCHI0100'
                 : PxSsnId
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  PgmSts.CurUsr;

        Else;
          Return  WCHI0100.UserId;
        EndIf;

      /End-Free

     P GetWchUsr       E
     **-- Check object existence:
     P ChkObj          B                   Export
     D                 Pi              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a

      /Free

        RtvObjD( OBJD0100
               : %Size( OBJD0100 )
               : 'OBJD0100'
               : PxObjNam_q
               : PxObjTyp
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Off;

        Else;
          Return  *On;
        EndIf;

      /End-Free

     P ChkObj          E
     **-- Process command:
     P PrcCmd          B                   Export
     D                 Pi            10i 0
     D  PxCmdStr                   1024a   Const  Varying

     **-- Local variables:
     D CPOP0100        Ds                  Qualified
     D  TypPrc                       10i 0 Inz( CMD_LIN_RUN )
     D  DBCS                          1a   Inz( IGN_DBCS )
     D  PmtAct                        1a   Inz( PMT_SLT )
     D  CmdStx                        1a   Inz( SYS_STX )
     D  MsgRtvKey                     4a   Inz( *Allx'00' )
     D  CmdCcsId                     10i 0 Inz( JOB_CCSID )
     D  Rsv                           9a   Inz( *Allx'00' )
     **
     D CMD_LIN_RUN     c                   2
     D JOB_CCSID       c                   0
     D PMT_SLT         c                   '2'
     D SYS_STX         c                   '0'
     D IGN_DBCS        c                   '0'
     **
     D ChgCmd          s          32767a
     D ChgCmdAvl       s             10i 0

      /Free

        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : CPOP0100
               : %Size( CPOP0100 )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
        Else;
          Return  *Zero;
        EndIf;

      /End-Free

     P PrcCmd          E
     **-- Get object qualified name:
     P GetObjQual      B
     D                 Pi            21a   Varying
     D  PxObjNam_q                   20a   Const

      /Free

        Return  %Trim( %Subst( PxObjNam_q: 11: 10 )) + '/' +
                %Trim( %Subst( PxObjNam_q:  1: 10 ));

      /End-Free

     P GetObjQual      E
