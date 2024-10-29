     **
     **  Program . . :  CBX166O
     **  Description :  Copy Data Queue Description - POP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  System iNetwork Programming Tips Newsletter
     **  Date  . . . :  December 14, 2006
     **
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter identifying the
     **                           data queue description to retrieve
     **                           attribute information about.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt
     **                           string returning the data queue
     **                           information for the specified
     **                           data queue.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX166O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX166O )
     **              Module( CBX166O )
     **              ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      256a

     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D DTAQ_STD        c                   '0'
     D DTAQ_DDM        c                   '1'
     D SEQ_KEYED       c                   'K'
     **-- Global variables:
     D Idx             s             10i 0

     **-- RDQD0100 format:
     D RDQD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  MsgLen                       10i 0
     D  KeyLen                       10i 0
     D  Seq                           1a
     D  IncSndId                      1a
     D  FrcInd                        1a
     D  TxtDsc                       50a
     D  Type                          1a
     D  AutRcl                        1a
     D                                1a
     D  NbrCurMsg                    10i 0
     D  NbrMsgAlc                    10i 0
     D  DtaQ_Nam                     10a
     D  DtaQ_Lib                     10a
     D  MaxMsgAlw                    10i 0
     D  InlNbrMsg                    10i 0
     D  DtaQ_Size                    10i 0
     **-- RDQD0200 format:
     D RDQD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  AppcDevD                     10a
     D  Mode                          8a
     D  RmtLocNam                     8a
     D  LclLocNam                     8a
     D  RmtNetId                      8a
     D  RmtDtaQ_Nam                  10a
     D  RmtDtaQ_Lib                  10a
     D  DtaQ_Name                    10a
     D  DtaQ_Lib                     10a
     D  RdbNam                       18a

     **-- Retrieve data queue description:
     D RtvDtqDsc       Pr                  ExtPgm( 'QMHQRDQD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  DtaQ_q                       20a   Const
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkEnt                    10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                       512a          Options( *VarSize )
     **
     D  CalStkEntLen                 10i 0 Const  Options( *NoPass )
     D  CalStkEntQlf                 20a   Const  Options( *NoPass )
     D  DspWait                      10i 0 Const  Options( *NoPass )
     **
     D  CalStkEntTyp                 20a   Const  Options( *NoPass )
     D  CcsId                        10i 0 Const  Options( *NoPass )
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
     D CBX166O         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    20a
     D  PxCmdStr                  32674a   Varying
     **
     D CBX166O         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    20a
     D  PxCmdStr                  32674a   Varying

      /Free

        RtvDtqDsc( RDQD0100
                 : %Size( RDQD0100 )
                 : 'RDQD0100'
                 : PxKeyPrm1
                 );

        If  RDQD0100.Type = DTAQ_DDM;

          RtvDtqDsc( RDQD0200
                   : %Size( RDQD0200 )
                   : 'RDQD0200'
                   : PxKeyPrm1
                   );

        Else;
          Clear  RDQD0200;
        EndIf;


        ExSr  FmtDtaQ_Inf;

        *InLr = *On;
        Return;


        BegSr  FmtDtaQ_Inf;

          RDQD0100.TxtDsc = DblQuotes( RDQD0100.TxtDsc );

          If  RDQD0100.Type = DTAQ_STD;

            PxCmdStr += '??TYPE(*STD) ';
            PxCmdStr += '??MAXLEN(' + %Char( RDQD0100.MsgLen ) + ') ';

            If  RDQD0100.FrcInd = 'Y';
              PxCmdStr += '??FORCE(*YES) ';
            Else;
              PxCmdStr += '??FORCE(*NO) ';
            EndIf;

            Select;
            When  RDQD0100.Seq = 'F';
              PxCmdStr += '??SEQ(*FIFO) ';

            When  RDQD0100.Seq = 'L';
              PxCmdStr += '??SEQ(*LIFO) ';

            Other;
              PxCmdStr += '??SEQ(*KEYED) ';
            EndSl;

            If  RDQD0100.Seq = SEQ_KEYED;
              PxCmdStr += '??KEYLEN(' + %Char( RDQD0100.KeyLen ) + ') ';
            EndIf;

            If  RDQD0100.IncSndId = 'Y';
              PxCmdStr += '??SENDERID(*YES) ';
            Else;
              PxCmdStr += '??SENDERID(*NO) ';
            EndIf;

            Select;
            When  RDQD0100.DtaQ_Size = -1;
              PxCmdStr += '??SIZE(*MAX16MB ' +
                           %Char( RDQD0100.InlNbrMsg ) + ') ';

            When  RDQD0100.DtaQ_Size = -2;
              PxCmdStr += '??SIZE(*MAX2GB '  +
                           %Char( RDQD0100.InlNbrMsg ) + ') ';

            Other;
              PxCmdStr += '??SIZE(' + %Char( RDQD0100.DtaQ_Size ) + ' ' +
                                      %Char( RDQD0100.InlNbrMsg ) + ') ';
            EndSl;

            If  RDQD0100.AutRcl = '1';
              PxCmdStr += '??AUTORCL(*YES) ';
            Else;
              PxCmdStr += '??AUTORCL(*NO) ';
            EndIf;

          Else;
            PxCmdStr += '??TYPE(*DDM) ';
            PxCmdStr += '??RMTDTAQ(' + %Trim( RDQD0200.RmtDtaQ_Lib ) +
                                 '/' + %Trim( RDQD0200.RmtDtaQ_Nam ) + ') ';

            If  RDQD0200.RmtLocNam = '*RDB';
              PxCmdStr += '??RMTLOCNAME(*RDB) ';
              PxCmdStr += '??RDB(' + %Trim( RDQD0200.RdbNam ) + ') ';

            Else;
              PxCmdStr += '??RMTLOCNAME(' + %Trim( RDQD0200.RmtLocNam ) + ') ';
              PxCmdStr += '??DEV(' + %Trim( RDQD0200.AppcDevD ) + ') ';
              PxCmdStr += '??LCLLOCNAME(' + %Trim( RDQD0200.LclLocNam ) + ') ';
              PxCmdStr += '??MODE(' + %Trim( RDQD0200.Mode ) + ') ';
              PxCmdStr += '??RMTNETID(' + %Trim( RDQD0200.RmtNetId ) + ') ';
            EndIf;
          EndIf;

          If  RDQD0100.TxtDsc = *Blanks;
            PxCmdStr += '??TEXT(*BLANK)';
          Else;
            PxCmdStr += '??TEXT(''' + RDQD0100.TxtDsc + ''')';
          EndIf;

        EndSr;

        BegSr  *PsSr;

          If  Not *InLr;
            *InLr = *On;

            MovPgmMsg( *Blanks
                     : '*DIAG'
                     : 1
                     : '*PGMBDY'
                     : 1
                     : ERRC0100
                     );

            SndEscMsg( 'CPF0011': '' );

            Return;
          EndIf;

        EndSr  '*CANCL';

      /End-Free

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
     **-- Send diagnostic message:  ------------------------------------------**
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
     **-- Send escape message:  ----------------------------------------------**
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
