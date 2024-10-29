     **
     **  Program . . : CBX165V
     **  Description : Display Data Queue Description - VCP
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : November 16, 2006
     **
     **
     **  Program description:
     **    Validity checking program for data queue existence.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX165V )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX165V )
     **              Module( CBX165V )
     **              ActGrp( QILE )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
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
     D  Error                      1024a          Options( *VarSize )

     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const

     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D CBX165V         Pr
     D  PxDtaQ_q                           LikeDs( ObjNam_q )
     D  PxOutOpt                      3a
     **
     D CBX165V         Pi
     D  PxDtaQ_q                           LikeDs( ObjNam_q )
     D  PxOutOpt                      3a

      /Free

        If  ChkObj( PxDtaQ_q: '*DTAQ' ) = *Off;

          SndDiagMsg( 'CPD0006'
                    : '0000Data queue '           +
                       %Trim( PxDtaQ_q.ObjNam )   +
                      ' in library '              +
                       %Trim( PxDtaQ_q.ObjLib )   +
                      ' not found.'
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        *InLr = *On;
        Return;

      /End-Free

     **-- Check object existence:  -------------------------------------------**
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
