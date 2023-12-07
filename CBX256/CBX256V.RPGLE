     **
     **  Program . . :  CBX256V
     **  Description :  Display Job Screen - VCP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer, 2012.
     **
     **
     **
     **  Program description:
     **    This program checks the current job type as well as the current
     **    job status of the target job.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX256V )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX256V )
     **              Module( CBX256V )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         SDs                  Qualified  NoOpt
     D  PgmNam           *Proc
     D  Status                        5a   Overlay( PgmSts: 11 )
     D  StmNbr                        8a   Overlay( PgmSts: 21 )
     D  MsgId                         7a   Overlay( PgmSts: 40 )
     D  PgmLib                       10a   Overlay( PgmSts: 81 )
     D  Msg                          80a   Overlay( PgmSts: 91 )
     D  JobId                        26a   Overlay( PgmSts: 244 )
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
     **-- Global constants:
     D NULL            c                   ''
     D TYP_INTERACT    c                   'I'

     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
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
     D  Error                      1024a          Options( *VarSize )

     **-- Get job type:
     D GetJobTyp       Pr             1a
     D  PxJobNam_q                         LikeDs( JobNam_q )
     **-- Get job status:
     D GetJobSts       Pr             4a
     D  PxJobNam_q                         LikeDs( JobNam_q )
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D JobNam_q        Ds                  Qualified
     D  JobNam                       10a
     D  JobUsr                       10a
     D  JobNbr                        6a
     **
     D CBX256V         Pr
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxCmdTmo                      5i 0
     **
     D CBX256V         Pi
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxCmdTmo                      5i 0

      /Free

        If  PxJobNam_q = PgmSts.JobId;

          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      'DSPJOBSCN command cannot be run for the current job.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  GetJobTyp( PxJobNam_q ) <> TYP_INTERACT;

          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      'DSPJOBSCN command only allowed for interactive jobs.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  GetJobSts( PxJobNam_q ) = *Blanks;

          SndDiagMsg( 'CPD0006'
                    : '0000' + 'Job status must be active.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  GetJobSts( PxJobNam_q ) = 'GRP';

          SndDiagMsg( 'CPD0006'
                    : '0000' + 'Job is a currently suspended group job.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  GetJobSts( PxJobNam_q ) = 'DSC';

          SndDiagMsg( 'CPD0006'
                    : '0000' + 'Job is currently disconnected.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        *InLr = *On;
        Return;


      /End-Free

     **-- Get job type:
     P GetJobTyp       B
     D                 Pi             1a
     D  PxJobNam_q                         LikeDs( JobNam_q )

     D JOBI0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  JobIntId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a

      /Free

        RtvJobInf( JOBI0400
                 : %Size( JOBI0400 )
                 : 'JOBI0400'
                 : PxJobNam_q
                 : *Blank
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;

        Else;
          Return  JOBI0400.JobTyp;
        EndIf;

      /End-Free

     P GetJobTyp       E
     **-- Get job status:
     P GetJobSts       B
     D                 Pi             4a
     D  PxJobNam_q                         LikeDs( JobNam_q )

     D JOBI0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  JobIntId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a
     D  ActSts                        4a   Overlay( JOBI0200: 108 )

      /Free

        RtvJobInf( JOBI0200
                 : %Size( JOBI0200 )
                 : 'JOBI0200'
                 : PxJobNam_q
                 : *Blank
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;

        Else;
          Return  JOBI0200.ActSts;
        EndIf;

      /End-Free

     P GetJobSts       E
     **-- Send diagnostic message:
     P SndDiagMsg      B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*DIAG'
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

     P SndDiagMsg      E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
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
