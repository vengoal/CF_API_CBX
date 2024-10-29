     **
     **  Program . . :  CBX166
     **  Description :  Copy Data Queue Description - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  System iNetwork Programming Tips Newsletter
     **  Date  . . . :  December 14, 2006
     **
     **
     **  Program description:
     **    Validity checking program for data queue existence.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX166 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX166 )
     **              Module( CBX166 )
     **              ActGrp( *NEW )
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
     **-- Global variables:
     D CmdStr          s           1024a   Varying
     **-- Global constants:
     D OFS_MSGDTA      c                   16

     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLen                 10i 0 Const
     D  OptCtlBlkFmt                  8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAvl                 10i 0
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgF_q                       20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                      1024a          Options( *VarSize )
     **-- Move program messages:
     D MovPgmMsg       Pr                  ExtPgm( 'QMHMOVPM' )
     D  MsgKey                        4a   Const
     D  MsgTyps                      10a   Const  Options( *VarSize )  Dim( 4 )
     D  NbrMsgTyps                   10i 0 Const
     D  ToCalStkE                  4102a   Const  Options( *VarSize )
     D  ToCalStkCnt                  10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkLen                  10i 0 Const  Options( *NoPass )
     D  ToCalStkEq                   20a   Const  Options( *NoPass )
     D  ToCalStkEdt                  10a   Const  Options( *NoPass )
     D  FrCalStkEad                    *   Const  Options( *NoPass )
     D  FrCalStkCnt                  10i 0 Const  Options( *NoPass )

     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  PxCmdStr                   1024a   Const  Varying
     **-- Double quotes:
     D DblQuotes       Pr           256a   Varying
     D  PxTxtDsc                    256a   Value  Varying
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
     D Size            Ds
     D  NbrElm                        5i 0
     D  MaxNbr                       10i 0
     D  InlNbr                       10i 0
     **
     D CBX166          Pr
     D  PxFrmDtaQ_q                        LikeDs( ObjNam_q )
     D  PxToDtaQ_q                         LikeDs( ObjNam_q )
     D  PxType                        5a
     D  PxMaxLen                     10i 0
     D  PxForce                       5a
     D  PxSeq                        10a
     D  PxKeyLen                      5i 0
     D  PxIncSndId                    5a
     D  PxSize                             LikeDs( Size )
     D  PxAutRcl                      5a
     D  PxRmtDtaQ_q                        LikeDs( ObjNam_q )
     D  PxRmtLocNam                   8a
     D  PxRdbNam                     18a
     D  PxAppcDevD                   10a
     D  PxLclLocNam                   8a
     D  PxMode                        8a
     D  PxRmtNetId                    8a
     D  PxTxtDsc                     50a   Varying
     D  PxObjAut                     10a
     **
     D CBX166          Pi
     D  PxFrmDtaQ_q                        LikeDs( ObjNam_q )
     D  PxToDtaQ_q                         LikeDs( ObjNam_q )
     D  PxType                        5a
     D  PxMaxLen                     10i 0
     D  PxForce                       5a
     D  PxSeq                        10a
     D  PxKeyLen                      5i 0
     D  PxIncSndId                    5a
     D  PxSize                             LikeDs( Size )
     D  PxAutRcl                      5a
     D  PxRmtDtaQ_q                        LikeDs( ObjNam_q )
     D  PxRmtLocNam                   8a
     D  PxRdbNam                     18a
     D  PxAppcDevD                   10a
     D  PxLclLocNam                   8a
     D  PxMode                        8a
     D  PxRmtNetId                    8a
     D  PxTxtDsc                     50a   Varying
     D  PxObjAut                     10a

      /Free

        CmdStr = 'CRTDTAQ DTAQ(' + %Trim( PxToDtaQ_q.ObjLib ) + '/' +
                                   %Trim( PxToDtaQ_q.ObjNam ) + ') ';

        CmdStr += 'TYPE(' + %Trim( PxType ) + ') ';

        If  PxType = '*STD';

          CmdStr += 'MAXLEN(' + %Char( PxMaxLen ) + ') ';
          CmdStr += 'FORCE(' + %Trim( PxForce ) + ') ';
          CmdStr += 'SEQ(' + %Trim( PxSeq ) + ') ';

          If  PxSeq = '*KEYED';
            CmdStr += 'KEYLEN(' + %Char( PxKeyLen ) + ') ';
          EndIf;

          CmdStr += 'SENDERID(' + %Trim( PxIncSndId ) + ') ';

          Select;
          When  PxSize.MaxNbr = -1;
            CmdStr += 'SIZE(*MAX16MB ' + %Char( PxSize.InlNbr ) + ') ';

          When  PxSize.MaxNbr = -2;
            CmdStr += 'SIZE(*MAX2GB ' + %Char( PxSize.InlNbr ) + ') ';

          Other;
            CmdStr += 'SIZE(' + %Char( PxSize.MaxNbr ) + ' ' +
                                %Char( PxSize.InlNbr ) + ') ';
          EndSl;

          CmdStr += 'AUTORCL(' + %Trim( PxAutRcl ) + ') ';

        Else;
          CmdStr += 'RMTDTAQ(' + %Trim( PxRmtDtaQ_q.ObjLib ) + '/' +
                                 %Trim( PxRmtDtaQ_q.ObjNam ) + ') ';

          CmdStr += 'RMTLOCNAME(' + %Trim( PxRmtLocNam ) + ') ';

          If  PxRmtLocNam = '*RDB';
            CmdStr += 'RDB(' + %Trim( PxRdbNam ) + ') ';

          Else;
            CmdStr += 'DEV(' + %Trim( PxAppcDevD ) + ') ';
            CmdStr += 'LCLLOCNAME(' + %Trim( PxLclLocNam ) + ') '           ;
            CmdStr += 'MODE(' + %Trim( PxMode ) + ') ';
            CmdStr += 'RMTNETID(' + %Trim( PxRmtNetId ) + ') '              ;
          EndIf;
        EndIf;

        CmdStr += 'TEXT(''' + DblQuotes( PxTxtDsc ) + ''')';

        PrcCmd( CmdStr );


        *InLr = *On;
        Return;

      /End-Free

     **-- Process command:  --------------------------------------------------**
     P PrcCmd          B                   Export
     D                 Pi            10i 0
     D  PxCmdStr                   1024a   Const  Varying

     **-- Local variables:
     D OptCtlBlk       Ds                  Qualified
     D  TypPrc                       10i 0 Inz( 2 )
     D  DBCS                          1a   Inz( '0' )
     D  PmtAct                        1a   Inz( '2' )
     D  CmdStx                        1a   Inz( '0' )
     D  MsgRtvKey                     4a   Inz( *Allx'00' )
     D  Rsv                           9a   Inz( *Allx'00' )
     **
     D ChgCmd          s          32767a
     D ChgCmdAvl       s             10i 0
     **-- API error data structure:
     D ERRC0100_L      Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0

      /Free

        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : OptCtlBlk
               : %Size( OptCtlBlk )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          MovPgmMsg( *Blanks
                   : '*DIAG'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100_L
                   );

          SndEscMsg( ERRC0100.MsgId
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

          Return  -1;

        Else;
          MovPgmMsg( *Blanks
                   : '*COMP'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100
                   );

          Return  *Zero;
        EndIf;

      /End-Free

     P PrcCmd          E
     **-- Double quotes:  ----------------------------------------------------**
     P DblQuotes       B
     D                 Pi           256a   Varying
     D  PxTxtDsc                    256a   Value  Varying

     D Pos             s             10i 0

      /Free

          Pos = %Scan( '''': PxTxtDsc );

          DoW  Pos > *Zero;
            PxTxtDsc = %Replace( '''': PxTxtDsc: Pos: 0 );

            If  Pos + 2 <= %Len( PxTxtDsc );
              Pos = %Scan( '''': PxTxtDsc: Pos + 2 );
            Else;
              Pos = *Zero;
            EndIf;
          EndDo;

          Return  %TrimR( PxTxtDsc );

      /End-Free

     P DblQuotes       E
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
