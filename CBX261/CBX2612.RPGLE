     **
     **  Program . . :  CBX2612
     **  Description :  Reply Handling Exit Program: Ignore CPA32B2
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer, 2013.
     **
     **
     **
     **  Exit point name:  QIBM_QMH_REPLY_INQ
     **
     **  Exit point format name:  RPYI0100
     **
     **
     **    A reply handling exit program is called when a reply is sent to an
     **    inquiry message. The operating system calls the user-written exit
     **    program identified through the registration facility. The program is
     **    called after the system validates the reply, but before the reply is
     **    sent to the inquiry message. For some inquiry messages, a reply
     **    handling exit program can indicate that the reply should be rejected.
     **
     **    When an exit program indicates that the reply should be rejected, a
     **    diagnostic message (CPD2476 Reply rejected by a reply handling exit
     **    program) is sent to the caller of the send reply function.
     **
     **
     **    Parameters:
     **
     **      1   Type of call                    Input    Binary(4)
     **      2   Qualified message queue name    Input    Char(20)
     **      3   Message key                     Input    Char(4)
     **      4   Message identifier              Input    Char(7)
     **      5   Reply                           I/O      Char(*)
     **      6   Length of reply                 I/O      Bin(4)
     **      7   CCSID of reply                  I/O      Bin(4)
     **      8   Reply action return code        Output   Bin(4)
     **
     **
     **    Type of call
     **
     **      The reason the exit program is being called.
     **      The valid values are:
     **
     **        0  Reply notification - no action allowed
     **        1  Reply validation requested
     **        2  Default reply validation requested
     **        3  Default reply notification
     **        4  Reply rejected notification
     **        5  Replaced reply not valid
     **        6  Reply replaced notification
     **        7  Reply cannot be sent notification
     **
     **      For values 0, 4, 5 and 6 parameter 8 will be ignored.
     **      For values 4 and 7 parameter 5 will be blank and
     **      parameters 6 and 7 will be zero.
     **
     **    Message queue name
     **
     **      The qualified name of the message queue containing the inquiry
     **      message. A special value of *EXT can be specified, indicating
     **      that the inquiry message was sent to the job's external message
     **      queue.
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
     **    Reply
     **
     **      The reply sent to an inquiry message. If a reply is being
     **      replaced by an exit program, the new value is specified.
     **
     **    Length of reply
     **
     **      The length of the specified reply. The maximum value is 132.
     **      If a reply is being replaced with a default reply value, a
     **      value of zero can be specified.
     **
     **    CCSID of reply
     **
     **      The coded character set of the specified reply.
     **      The valid values are:
     **
     **            0  The message reply text is in the CCSID of the
     **               current job
     **
     **        65535  The message text will not be converted
     **
     **        CCSID  Specify a valid CCSID that your message reply
     **               is in. Valid values are in the range 1 to 65535
     **
     **    Reply action code
     **
     **      The return code to indicate whether the reply should be
     **      rejected, accepted or replaced.
     **      The valid values are:
     **
     **        0  The reply should be rejected
     **        1  The reply should be accepted
     **        2  The reply should be replaced
     **
     **
     **  Register exit program:
     **    AddExitPgm  ExitPnt( QIBM_QMH_REPLY_INQ )
     **                Format( RPYI0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX2612 )
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
     **    CrtRpgMod Module( CBX2612 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX2612 )
     **              Module( CBX2612 )
     **              ActGrp( INQRPY )
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
     D JOB_CCSID       c                   0
     D DFT_RPY_NTF     c                   3
     D RPY_ACT_ACP     c                   1
     D RPY_ACT_RPL     c                   2
     D SQL_VFY_CNL     c                   'C'
     D SQL_VFY_IGN     c                   'I'

     **-- Get environment variable:
     D getenv          Pr              *   ExtProc( 'getenv' )
     D  EnvDta                         *   Value  Options(*String)

     **-- Get string:
     D GetStrVal       Pr          1024a   Varying
     D  PxStrPtr                       *   Value

     **-- Entry parameters:
     D CBX2612         Pr
     D  PxTypCall                    10i 0
     D  PxMsgQue_q                   20a
     D  PxMsgKey                      4a
     D  PxMsgId                       7a
     D  PxMsgRpy                    264a
     D  PxRpyLen                     10i 0
     D  PxRpyCcsId                   10i 0
     D  PxRtnActCod                  10i 0
     **
     D CBX2612         Pi
     D  PxTypCall                    10i 0
     D  PxMsgQue_q                   20a
     D  PxMsgKey                      4a
     D  PxMsgId                       7a
     D  PxMsgRpy                    264a
     D  PxRpyLen                     10i 0
     D  PxRpyCcsId                   10i 0
     D  PxRtnActCod                  10i 0

      /Free

        PxRtnActCod = RPY_ACT_ACP;

        If  PxTypCall = DFT_RPY_NTF;

          If  PxMsgId = 'CPA32B2';

            If  PxRpyLen > *Zero  And
                %Subst( PxMsgRpy: 1: PxRpyLen ) = SQL_VFY_CNL;

              If  GetStrVal( getenv( 'SQL_VFY_ALTER_IGNORE' )) = 'Y';

                PxMsgRpy    = SQL_VFY_IGN;
                PxRpyLen    = %Len( SQL_VFY_IGN );
                PxRpyCcsId  = JOB_CCSID;
                PxRtnActCod = RPY_ACT_RPL;
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

          PxRtnActCod = RPY_ACT_ACP;

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

