     **
     **  Program . . :  CBX2611
     **  Description :  Inquiry Handling Exit Program: Ignore CPA32B2
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer, 2013.
     **
     **
     **
     **  Exit point name:  QIBM_QMH_HDL_INQEXT
     **
     **  Exit point format name:  INQE0100
     **
     **
     **    An inquiry handling exit program is called in an interactive job
     **    when an inquiry message has been sent to the *EXT message queue
     **    and the job would be interrupted by the Display Program Messages
     **    screen to obtain a reply. The exit program can send a reply to the
     **    inquiry message, so the interactive user is not interrupted to
     **    provide a reply to the inquiry message.
     **
     **
     **    Parameters:
     **
     **      1   Type of call                    Input    Binary(4)
     **      2   Qualified message queue name    Input    Char(20)
     **      3   Message key                     Input    Char(4)
     **      4   Message identifier              Input    Char(7)
     **
     **
     **    Type of call
     **
     **      The reason the exit program is being called.
     **      The valid values are:
     **
     **        1  Inquiry needs reply
     **
     **    Message queue name
     **
     **      The name of the message queue containing the inquiry message.
     **      A special value of *EXT will be specified, indicating that the
     **      inquiry message was sent to the job's external message queue.
     **
     **    Message key
     **
     **      The message reference key of the inquiry message that needs
     **      a reply. This is a binary value.
     **
     **    Message identifier
     **
     **      The message identifier of the inquiry message that needs a
     **      reply. This value will be blank for an impromptu message.
     **
     **
     **
     **  Register exit program:
     **    AddExitPgm  ExitPnt( QIBM_QMH_HDL_INQEXT )
     **                Format( INQE0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX2611 )
     **
     **
     **  Activate exit program for current job:
     **    AddEnvVar EnvVar( SQL_VFY_ALTER_IGNORE )
     **              Value( Y )
     **              Level( *JOB )
     **
     **  Deactivate exit program for current job:
     **    RmvEnvVar EnvVar( SQL_VFY_ALTER_IGNORE )
     **              Level( *JOB )
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX2611 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX2611 )
     **              Module( CBX2611 )
     **              ActGrp( INQEXT )
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
     **-- Global constants:
     D NULL            c                   ''
     D INQ_NEED_RPY    c                   1
     D NO_WAIT         c                   0
     D JOB_CCSID       c                   0
     D KEEP_STS        c                   '*SAME'

     **-- Message information structure:
     D RCVM0300        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  MsgSev                       10i 0
     D  MsgId                         7a
     D  MsgTyp                        2s 0
     D  MsgKey                        4a
     D  MsgFilNam                    10a
     D  MsgFilLib_s                  10a
     D  MsgFilLib_u                  10a
     D  AlrOpt                        9a
     D  CcsIdStsTxt                  10i 0
     D  CcsIdStsDta                  10i 0
     D  CcsIdMsgTxt                  10i 0
     D  CcsIdMsgDta                  10i 0
     D  DtaLenRtn                    10i 0
     D  DtaLenAvl                    10i 0
     D  MsgLenRtn                    10i 0
     D  MsgLenAvl                    10i 0
     D  HlpLenRtn                    10i 0
     D  HlpLenAvl                    10i 0
     D  SndLenRtn                    10i 0
     D  SndLenAvl                    10i 0
     D  VarDta                        1a
     **
     D MsgTxt          s           1024a   Varying
     D MsgDta          s           1024a   Varying
     **-- Sender information structure:
     D SndInf          Ds                  Qualified  Based( pSndInf )
     D  SndJob                       10a
     D  SndJobUsr                    10a
     D  SndJobNbr                     6a
     D  DatSnt                        7a
     D  TimSnt                        6a
     D  SndTyp                        1a
     D  RcvTyp                        1a
     D  SndPgmNam                    12a
     D  SndModNam                    10a
     D  SndPrcNam                   256a
     D                                1a
     D  SndNbrStmt                   10i 0
     D  SndPgmStmt                   30a
     D  RcvPgmNam                    10a
     D  RcvModNam                    10a
     D  RcvPrcNam                   256a
     D                               10a
     D  RcvNbrStmt                   10i 0
     D  RcvPgmStmt                   30a
     D                                2a
     D  DisLngSndPgm                 10i 0
     D  LenLngSndPgm                 10i 0
     D  DisLngSndPrc                 10i 0
     D  LenLngSndPrc                 10i 0
     D  DisLngRcvPrc                 10i 0
     D  LenLngRcvPrc                 10i 0
     D  MicSec                        6a
     D  SndUsrPrf                    10a
     **
     D LngSndPgm       s           1024a   Varying
     D LngSndPrc       s           1024a   Varying
     D LngRcvPrc       s           1024a   Varying

     **-- Send reply message:
     D SndRpyMsg       Pr                  ExtPgm( 'QMHSNDRM' )
     D  MsgKey                        4a   Const
     D  MsgQue_q                     20a   Const
     D  RpyTxt                     1024a   Const  Options( *VarSize )
     D  RpyTxtLen                    10i 0 Const
     D  RmvMsg                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  CcsId                        10i 0 Const  Options( *NoPass )
     D  AlwDftRpyRjc                 10a   Const  Options( *NoPass )
     **-- Receive program message:
     D RcvPgmMsg       Pr                  ExtPgm( 'QMHRCVPM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  CalStkE                     256a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  MsgKey                        4a   Const
     D  Wait                         10i 0 Const
     D  MsgAct                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  CalStkEnLn                   10i 0 Const  Options( *NoPass )
     D  CalStkEq                     20a   Const  Options( *NoPass )
     D  CalStkEnTp                   20a   Const  Options( *NoPass )
     D  CcsId                        10i 0 Const  Options( *NoPass )
     D  AlwDftRpRj                   10a   Const  Options( *NoPass )
     **-- Get environment variable:
     D getenv          Pr              *   ExtProc( 'getenv' )
     D  EnvDta                         *   Value  Options(*String)

     **-- Get string:
     D GetStrVal       Pr          1024a   Varying
     D  PxStrPtr                       *   Value
     **-- Send reply value:
     D SndRpyVal       Pr            10i 0
     D  PxMsgQue_q                   20a   Const
     D  PxMsgKey                      4a   Const
     D  PxRpyVal                    128a   Varying  Const

     **-- Entry parameters:
     D CBX2611         Pr
     D  PxTypCall                    10i 0
     D  PxMsgQue_q                   20a
     D  PxMsgKey                      4a
     D  PxMsgId                       7a
     **
     D CBX2611         Pi
     D  PxTypCall                    10i 0
     D  PxMsgQue_q                   20a
     D  PxMsgKey                      4a
     D  PxMsgId                       7a

      /Free

        If  PxTypCall = INQ_NEED_RPY;

          If  PxMsgId = 'CPA32B2';

            If  GetStrVal( getenv( 'SQL_VFY_ALTER_IGNORE' )) = 'Y';

              RcvPgmMsg( RCVM0300
                       : %Size( RCVM0300 )
                       : 'RCVM0300'
                       : '*EXT'
                       : *Zero
                       : '*ANY'
                       : PxMsgKey
                       : *Zero
                       : '*SAME'
                       : ERRC0100
                       );

              If  ERRC0100.BytAvl = *Zero;
                pSndInf = %Addr( RCVM0300.VarDta ) + RCVM0300.DtaLenRtn +
                                                     RCVM0300.MsgLenRtn +
                                                     RCVM0300.HlpLenRtn;

                If  SndInf.SndPgmNam = 'QDBCHGFI'  And
                    SndInf.SndModNam = 'QDBCHGFI'  And
                    SndInf.SndPrcNam = 'VFYALTER';

                  SndRpyVal( PxMsgQue_q: PxMsgKey: 'I' );
                EndIf;
              EndIf;
            EndIf;
          EndIf;
        EndIf;

        *InLr = *On;
        Return;

        BegSr  *PsSr;

          If  *InLr = *On;
            Return;

          Else;
            *InLr = *On;
          EndIf;

          // Log unexpected error should be performed here...

          Return;

        EndSr;

      /End-Free

     **-- Get string value:
     P GetStrVal       B                   Export
     D                 Pi          1024a   Varying
     D  PxStrPtr                       *   Value

      /Free

        If  PxStrPtr = *Null;
          Return  NULL;

        Else;
          Return  %Str( PxStrPtr );
        EndIf;

      /End-Free

     P GetStrVal       E
     **-- Send reply value:
     P SndRpyVal       B                   Export
     D                 Pi            10i 0
     D  PxMsgQue_q                   20a   Const
     D  PxMsgKey                      4a   Const
     D  PxRpyVal                    128a   Varying  Const

      /Free

        SndRpyMsg( PxMsgKey
                 : PxMsgQue_q
                 : PxRpyVal
                 : %Len( PxRpyVal )
                 : '*NO'
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return  *Zero;
        EndIf;

      /End-Free

     P SndRpyVal       E

