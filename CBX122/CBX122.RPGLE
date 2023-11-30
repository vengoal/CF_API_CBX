     **
     **  Program . . : CBX122
     **  Description : Subsystem job monitor
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : August 19, 2004
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Object APIs - data queue APIs:
     **    QCLRDTAQ       Clear data queue     Clears the specified data queue
     **                                        for all entries.
     **
     **    QRCVDTAQ       Send data queue      Receives a data queue entry from
     **                                        the specified data queue.  It is
     **                                        possible to specify a timeout
     **                                        value to wait on entries arriving
     **                                        in the data queue.
     **
     **                                        By default the received entry is
     **                                        is removed from the data queue.
     **
     **    QSNDDTAQ       Send data queue      Adds a data queue entry to the
     **                                        specified data queue.
     **
     **                                        The storage allocated for each
     **                                        entry will be equal to the value
     **                                        specified as the data queue's
     **                                        maximum entry length.
     **
     **    QMHRDQMQ       Retrieve data        Retrieves one or more entries
     **                   queue message        from the specified data queue
     **                                        without removing the entries.
     **
     **  Work management API:
     **    QUSRJOBI       Retrieve job         Retrieves specific information
     **                   information          about a specific job, covering
     **                                        all attributes and other state
     **                                        and runtime related information.
     **
     **  Miscellaneous APIs:
     **    QWCCVTDT      Convert date and      Converts date and time values from
     **                  time format           one format to another, including a
     **                                        system timestamp of type *DTS to
     **                                        character format.
     **
     **  Message handling API:
     **    QMHSNDM       Send message          Sends a message to the specified
     **                                        non-program message queue - here
     **                                        an informational message is sent
     **                                        to the current user running this
     **                                        program.
     **
     **
     **  Program description:
     **
     **    This program waits on the specified data queue for entries to
     **    arrive.  Each received data queue entry is, if identified
     **    correctly and the job it points to is found in the monitor
     **    control file CBX122F, processed in accordance with the event:
     **
     **    1. A job start notification entry generates an informational
     **       message saying the job has started, to the message queue
     **       specified in the monitor control file.  The timestamps
     **       defining the time the job entered the system and the time
     **       the job became active are included in the message.
     **
     **       The job id and job information structure is further added to
     **       a seperate data queue holding information about all jobs
     **       currently being monitored.
     **
     **    2. A job end notification entry generates an informational
     **       message saying the job has ended, to the message queue
     **       specified in the monitor control file.  The timestamp for
     **       the job end time as well as job end severity and processing
     **       time used is included in the message.
     **
     **       The job information and id stored in the job monitor data
     **       queue is removed from the data queue.
     **
     **    3. Every time a data queue entry is received or the data queue
     **       wait times out the entries in the job monitor data queue are
     **       retrieved and each job's current status is being checked.
     **
     **       In case a monitored job is either held or waiting on a message
     **       an informational message describing the event is being sent to
     **       the message queue specified in the monitor control file.
     **
     **
     **   Exit point documentation:
     **     http://publib.boulder.ibm.com/iseries/v5r2/ic2924/info/apis/xjobntfy.htm
     **
     **     Check also APAR SE06696 for changes to NTFY0100 format.
     **
     **
     **   Prerequisites:
     **     Create system default data queue:
     **
     **     CRTDTAQ DTAQ( QSYS/QSYSDTAQ )
     **             MAXLEN( 144 )
     **             SEQ( *KEYED )
     **             KEYLEN( 4 )
     **             SIZE( *MAX2GB )
     **             AUTORCL( *YES )
     **             TEXT( 'Exit point: QIBM_QWT_JOBNOTIFY -default data queue' )
     **
     **
     **     Create exit point data queue:
     **
     **     CRTDTAQ DTAQ( QGPL/JOBNOTIFY )
     **             MAXLEN( 144 )
     **             SEQ( *KEYED )
     **             KEYLEN( 4 )
     **             SIZE( *MAX2GB )
     **             AUTORCL( *YES )
     **             TEXT( 'Exit point: QIBM_QWT_JOBNOTIFY -format: NTFY0100' )
     **
     **
     **   Exit point registration:
     **     Register exit point subsystem and data queue:
     **       - Subsystem QINTER in any library for job start and end events
     **         events example (see exit point documentation for details on
     **         the PGMDTA format):
     **
     **     ADDEXITPGM EXITPNT( QIBM_QWT_JOBNOTIFY )
     **                FORMAT( NTFY0100 )
     **                PGMNBR( *LOW )
     **                PGM( QGPL/JOBNOTIFY )
     **                PGMDTA( *JOB 24 '0003QINTER    *ANY      ' )
     **
     **     - Restart subsystem(s) to make change take effect.
     **
     **
     **   Create monitor application data queue:
     **
     **     CRTDTAQ DTAQ( QGPL/MONSBSJOB )
     **             MAXLEN( 256 )
     **             SEQ( *KEYED )
     **             KEYLEN( 26 )
     **             SIZE( *MAX2GB )
     **             AUTORCL( *YES )
     **             TEXT( 'Monitor subsystem jobs.' )
     **
     **
     **  Programmer's notes:
     **    To ensure that the arriving data queue entries are processed
     **    immediately, this program should be submitted to a job queue
     **    available for a never ending processing type of job:
     **
     **      SbmJob Cmd( CALL PGM( CBX122 ))
     **             Job( MONSBSJOB )
     **             JobQ( <job queue name> )
     **
     **    To end the job controlled, run the following command:
     **
     **      EndJob Job( MONSBSJOB )
     **             Option( *CNTRLD )
     **             Delay( 30 )
     **
     **    Option controlled and delay 30 seconds will allow the job
     **    to detect the end request and stop processing gracefully.
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX122 )
     **               DbgView( *NONE )
     **
     **    CrtPgm     Pgm( CBX122 )
     **               Module( CBX122 )
     **               ActGrp( QILE )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
     **-- File specifications:
     FCBX122F   IF   E           K Disk
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      256a
     **-- Global declarations:
     D Idx             s             10i 0
     D MsgDta          s            128a   Varying
     D MsgKey          s              4a
     D MsgQ            s             10a
     D JobSts          s              4a
     D JobEntDts       s             20a   Inz( *All'0' )
     D JobStrDts       s             20a   Inz( *All'0' )
     D JobEndDts       s             20a   Inz( *All'0' )
     D JobMsgEnt       s                   Like( JobMsg )
     **-- Job start & end notification message:
     D JobMsg          Ds                  Qualified
     D  MsgId                        10a
     D  MsgFmt                        2a
     D  JobIdInt                     16a
     D  JobIdQ                       26a
     D   JobNam                      10a   Overlay( JobIdQ: 1 )
     D   JobUsr                      10a   Overlay( JobIdQ: *Next )
     D   JobNbr                       6a   Overlay( JobIdQ: *Next )
     D  JobQ                         20a
     D   JobQnam                     10a   Overlay( JobQ: 1 )
     D   JobQlib                     10a   Overlay( JobQ: *Next )
     D  JobEntDts                     8a
     D  JobStrDts                     8a
     D  JobEndDts                     8a
     D  JobTyp                        1a
     D  JobSubTyp                     1a
     D  JobEndSev                    10i 0
     D  JobPrcTimMs                  20i 0
     D  Res2                         32a
     **-- Data queue API parameters:
     D DqDta           Ds           144    Qualified
     D  MsgId                        10a
     D  MsgFmt                        2a
     **
     D DqDtaLen        s              5p 0
     D DqKey           s              4a   Inz( '0000' )
     D DqSndInfo       s              1a
     **-- RDMQ0200 format:
     D RDQM0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  MsgRtn                       10i 0
     D  MsgAvl                       10i 0
     D  KeyLenRtn                    10i 0
     D  KeyLenAvl                    10i 0
     D  TxtLenRtn                    10i 0
     D  TxtLenAvl                    10i 0
     D  EntLenRtn                    10i 0
     D  EntLenAvl                    10i 0
     D  OfsMsgEnt                    10i 0
     D  DtqLibNam                    10a
     D  DtqEnts                   10240a
     **-- Entry format:
     D DtqEnt          Ds                  Qualified  Based( pDtqEnt )
     D  OfsNxtEnt                    10i 0
     D  MsgEnqTod                     8a
     D  MsgEnqLen                    10i 0
     D  MsgDta                     1024a
     D   MsgKey                            Like( RDQS0200.Key )
     D                                     Overlay( MsgDta )
     **-- RDQS0200 selection format:
     D RDQS0200        Ds                  Qualified
     D  SelTyp                        1a   Inz( 'K' )
     D  KeySchOrd                     2a   Inz( 'GT' )
     D                                1a
     D  MsgBytRtv                    10i 0 Inz( %Len( JobMsg ))
     D  KeyBytRtv                    10i 0 Inz( %Len( RDQS0200.Key ))
     D  KeyLen                       10i 0 Inz( %Len( RDQS0200.Key ))
     D  Key                          26a   Inz( *Blanks )
     **-- Convert date & time:
     D CvtDtf          Pr                  ExtPgm( 'QWCCVTDT' )
     D  CdInpFmt                     10a   Const
     D  CdInpVar                     17a   Const  Options( *VarSize )
     D  CdOutFmt                     10a   Const
     D  CdOutVar                     17a          Options( *VarSize )
     D  CdError                      10i 0 Const
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  JiRcvVar                  32767a          Options( *VarSize )
     D  JiRcvVarLen                  10i 0 Const
     D  JiFmtNam                      8a   Const
     D  JiJobNamQ                    26a   Const
     D  JiJobIntId                   16a   Const
     D  JiError                   32767a          Options( *NoPass: *VarSize )
     D  JiRstStc                      1a          Options( *NoPass )
     **-- Send Message:
     D SndMsg          Pr                  ExtPgm( 'QMHSNDM' )
     D  SmMsgId                       7a   Const
     D  SmMsgFq                      20a   Const
     D  SmMsgDta                    512a   Const  Options( *VarSize )
     D  SmMsgDtaLen                  10i 0 Const
     D  SmMsgTyp                     10a   Const
     D  SmMsgQq                    1000a   Const  Options( *VarSize )
     D  SmMsgQnbr                    10i 0 Const
     D  SmMsgQrpy                    20a   Const
     D  SmMsgKey                      4a
     D  SmError                      10i 0 Const
     **
     D  SmCcsId                      10i 0 Const  Options( *NoPass )
     **-- Clear data queue:
     D ClrDtaQ         Pr                  ExtPgm( 'QCLRDTAQ' )
     D  CqName                       10a   Const
     D  CqLib                        10a   Const
     D  CqKeyOrder                    2a   Const  Options( *NoPass )
     D  CqKeyLen                      3p 0 Const  Options( *NoPass )
     D  CqKey                       256a   Const  Options( *VarSize: *NoPass )
     D  CqError                    1024a          Options( *VarSize: *Nopass )
     **-- Receive data queue entry:
     D RcvDtaQe        Pr                  ExtPgm( 'QRCVDTAQ' )
     D  RqName                       10a   Const
     D  RqLib                        10a   Const
     D  RqDtaLen                      5p 0
     D  RqDta                     32767a          Options( *VarSize )
     D  RqWait                        5p 0 Const
     D  RqKeyOrder                    2a   Const  Options( *NoPass )
     D  RqKeyLen                      3p 0 Const  Options( *NoPass )
     D  RqKey                       256a   Const  Options( *VarSize: *NoPass )
     D  RqSndInLg                     3p 0 Const  Options( *NoPass)
     D  RqSndInfo                    44a          Options( *VarSize: *Nopass )
     D  RqRmvMsg                     10a   Const  Options( *Nopass )
     D  RqDtaRcvLen                   5p 0 Const  Options( *Nopass )
     D  RqError                    1024a          Options( *VarSize: *Nopass )
     **-- Send data queue entry:
     D SndDtaQe        Pr                  ExtPgm( 'QSNDDTAQ' )
     D  SqName                       10a   Const
     D  SqLib                        10a   Const
     D  SqDtaLen                      5p 0 Const
     D  SqDta                     32767a   Const  Options( *VarSize )
     D  SqKeyLen                      3p 0 Const  Options( *NoPass )
     D  SqKey                       256a   Const  Options( *VarSize: *NoPass )
     D  SqAsyRqs                     10a   Const  Options( *NoPass )
     D  SqJrnDta                     10a   Const  Options( *NoPass )
     **-- Retrieve data queue message:
     D RtvDtqMsg       Pr                  ExtPgm( 'QMHRDQM' )
     D  RqRcvVar                  32767a          Options( *VarSize )
     D  RqRcvVarLen                  10i 0 Const
     D  RqFmtNam                     10a   Const
     D  RqDtgQq                      20a   Const
     D  RqMsgSel                     10a   Const
     D  RqMsgSelLen                  10i 0 Const
     D  RqMsgSelFmt                   8a   Const
     D  RqError                   32767a          Options( *NoPass: *VarSize)
     **-- Get active job status:
     D GetJobSts       Pr             4a
     D  PxJobId                      26a   Const
     **-- Get job monitor status:
     D GetMonSts       Pr              n
     D  PxJobNam                     10a   Const
     D  PxJobUsr                     10a   Const
     **-- Get monitor message queue:
     D GetMonMsgQ      Pr            10a
     D  PxJobNam                     10a   Const
     D  PxJobUsr                     10a   Const

      /Free

        DoW  Not *InLr;

          RcvDtaQe( 'JOBNOTIFY'
                  : 'QGPL'
                  : DqDtaLen
                  : DqDta
                  : 25
                  : 'GT'
                  : %Size( DqKey )
                  : DqKey
                  : 0
                  : DqSndInfo
                  );

          Select;
          When  %Error;
            Leave;

          When  DqDtaLen > *Zero;

            If  DqDta.MsgFmt = '01';
              ExSr  PrcJobMsg;
            EndIf;

            Reset  DqKey;
          EndSl;

          ExSr  ChkMonJobs;

          *InLr = %Shtdn();
        EndDo;

        Return;

        BegSr  PrcJobMsg;

          JobMsg = DqDta;

          Select;
          When  DqKey = '0001';

            If  GetMonStS( JobMsg.JobNam: JobMsg.JobUsr ) = *On;
              ExSr  AddJobEnt;
            EndIf;

          When  DqKey = '0002';

            If  GetMonStS( JobMsg.JobNam: JobMsg.JobUsr ) = *On;
              ExSr  RmvJobEnt;
            EndIf;
          EndSl;

        EndSr;

        BegSr  AddJobEnt;

          SndDtaQe( 'MONSBSJOB'
                  : 'QGPL'
                  : %Size( JobMsg )
                  : JobMsg
                  : %Size( JobMsg.JobIdQ )
                  : JobMsg.JobIdQ
                  );

          CvtDtf( '*DTS': JobMsg.JobEntDts: '*YYMD': JobEntDts: 0 );
          CvtDtf( '*DTS': JobMsg.JobStrDts: '*YYMD': JobStrDts: 0 );

          MsgQ = GetMonMsgQ( JobMsg.JobNam: JobMsg.JobUsr );

          MsgDta = 'Job '                        +
                   %TrimR( JobMsg.JobNam )       +
                   ' entered system at '         +
                   %Char( %Timestamp( JobEntDts
                                    : *ISO0
                                    ))           +
                   ' started at '                +
                   %Char( %Timestamp( JobStrDts
                                    : *ISO0
                                    ))           +
                   '.';

          SndMsg( 'CPF9897'
                : 'QCPFMSG   *LIBL'
                : MsgDta
                : %Len( MsgDta )
                : '*INFO'
                : MsgQ + '*LIBL'
                : 1
                : *Blanks
                : MsgKey
                : 0
                );

        EndSr;

        BegSr  RmvJobEnt;

          RcvDtaQe( 'MONSBSJOB'
                  : 'QGPL'
                  : DqDtaLen
                  : JobMsgEnt
                  : 0
                  : 'EQ'
                  : %Size( JobMsg.JobIdQ )
                  : JobMsg.JobIdQ
                  : 0
                  : DqSndInfo
                  );

          CvtDtf( '*DTS': JobMsg.JobEndDts: '*YYMD': JobEndDts: 0 );

          MsgQ = GetMonMsgQ( JobMsg.JobNam: JobMsg.JobUsr );

          MsgDta  = 'Job '                          +
                    %TrimR( JobMsg.JobNam )         +
                    ' ended at '                    +
                    %Char( %Timestamp( JobEntDts
                                     : *ISO0
                                     ))             +
                    ' severity '                    +
                    %Char( JobMsg.JobEndSev )       +
                    ' using '                       +
                    %Char( JobMsg.JobPrcTimMs )     +
                    ' milliseconds.';

          SndMsg( 'CPF9897'
                : 'QCPFMSG   *LIBL'
                : MsgDta
                : %Len( MsgDta )
                : '*INFO'
                : MsgQ + '*LIBL'
                : 1
                : *Blanks
                : MsgKey
                : 0
                );

        EndSr;

        BegSr  ChkMonJobs;

          RDQS0200.Key = *Blanks;

          DoU  RDQM0200.MsgRtn >= RDQM0200.MsgAvl;

            RtvDtqMsg( RDQM0200
                     : %Size( RDQM0200 )
                     : 'RDQM0200'
                     : 'MONSBSJOB QGPL'
                     : RDQS0200
                     : %Size( RDQS0200 )
                     : 'RDQS0200'
                     : ERRC0100
                     );

            If  ERRC0100.BytAvl = *Zero;

              pDtqEnt  =  %Addr( RDQM0200 ) + RDQM0200.OfsMsgEnt;

              For  Idx = 1  To RDQM0200.MsgRtn;

                ExSr  ChkJobSts;

                pDtqEnt  =  %Addr( RDQM0200 ) + DtqEnt.OfsNxtEnt;
              EndFor;
            EndIf;

            RDQS0200.Key = JobMsg.JobIdQ;
          EndDo;

        EndSr;

        BegSr  ChkJobSts;

          JobMsg = %Subst( DtqEnt.MsgDta
                         : %Size( DtqEnt.MsgKey ) + 1
                         : DtqEnt.MsgEnqLen
                         );

          JobSts = GetJobSts( JobMsg.JobIdQ );

          If  JobSts = 'MSGW'  Or
              JobSts = 'HLD ';

            CvtDtf( '*DTS': JobMsg.JobStrDts: '*YYMD': JobStrDts: 0 );

            MsgQ = GetMonMsgQ( JobMsg.JobNam: JobMsg.JobUsr );

            MsgDta = 'Job '                    +
                     %TrimR( JobMsg.JobNbr )   + '/'  +
                     %TrimR( JobMsg.JobUsr )   + '/'  +
                     %TrimR( JobMsg.JobNam )   +
                     ' currently has status '  +
                     %TrimR( JobSts )          +
                     '.';

            SndMsg( 'CPF9897'
                  : 'QCPFMSG   *LIBL'
                  : MsgDta
                  : %Len( MsgDta )
                  : '*INFO'
                  : MsgQ + '*LIBL'
                  : 1
                  : *Blanks
                  : MsgKey
                  : 0
                  );

          EndIf;

        EndSr;

        BegSr  *InzSr;

          ClrDtaQ( 'MONSBSJOB': 'QGPL' );

        EndSr;

      /End-Free

     **-- Get active job status:  --------------------------------------------**
     P GetJobSts       B
     D                 Pi             4a
     D  PxJobId                      26a   Const
     **
     D JOBI0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  IntJobId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  ActJobSts                     4a   Overlay( JOBI0200: 108 )
     D  MsgRpy                       10a   Overlay( JOBI0200: 191 )

      /Free

        RtvJobInf( JOBI0200
                 : %Size( JOBI0200 )
                 : 'JOBI0200'
                 : PxJobId
                 : *Blank
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;

        Else;
          Return  JOBI0200.ActJobSts;
        EndIf;

      /End-Free

     P GetJobSts       E
     **-- Get job monitor status:  -------------------------------------------**
     P GetMonSts       B
     D                 Pi              n
     D  PxJobNam                     10a   Const
     D  PxJobUsr                     10a   Const

      /Free

        Chain  ( PxjobNam: PxJobUsr )  CBX122F;

        If  %Found;
          Return  *On;

          Else;
            Chain  ( PxJobNam: '*ANY' )  CBX122F;

            If  %Found;
              Return  *On;

            Else;
              Return  *Off;

            EndIf;
          EndIf;

      /End-Free

     P GetMonSts       E
     **-- Get monitor message queue:  ----------------------------------------**
     P GetMonMsgQ      B
     D                 Pi            10a
     D  PxJobNam                     10a   Const
     D  PxJobUsr                     10a   Const

      /Free

        Chain  ( PxJobNam: PxJobUsr )  CBX122F;

        If  %Found;
          Return  CXNMSQ;

        Else;
          Chain  ( PxJobNam: '*ANY' )  CBX122F;

          If  %Found;
            Return  CXNMSQ;

          Else;
            Return  'QSYSOPR';

          EndIf;
        EndIf;

      /End-Free

     P GetMonMsgQ      E
