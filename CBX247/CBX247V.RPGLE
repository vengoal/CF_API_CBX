     **
     **  Program . . :  CBX247V
     **  Description :  Add Watch Definition - VCP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **
     **  Program description:
     **    This program checks the existence of the specified watch
     **    session ID.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX247V )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX247V )
     **              Module( CBX247V )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     **-- Watch session definition table:
     D AppTbl_q        Ds                  Qualified
     D  AppTbl                       10a   Inz( 'CBX247F' )
     D  AppLib                       10a   Inz( 'QGPL' )

     **-- Open file:
     D Ropen           Pr              *   ExtProc( '_Ropen' )
     D  pRFile                         *   Value  Options( *String )
     D  pMode                          *   Value  Options( *String )
     **-- Close file:
     D Rclose          Pr            10i 0 ExtProc( '_Rclose' )
     D  pRFile                         *   Value
     **-- Locate record:
     D Rlocate         Pr              *   ExtProc( '_Rlocate' )
     D  pRFile                         *   Value
     D  pKey                           *   Value
     D  KeyLength                    10u 0 Value
     D  Options                      10i 0 Value

     **-- Retrieve watch information:
     D RtvWchInf       Pr                  ExtPgm( 'QSCRWCHI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SsnId                        10a   Const
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
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve message description:
     D RtvMsgD         Pr                  ExtPgm( 'QMHRTVM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  MsgId                         7a   Const
     D  MsgF_q                       20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  RplSubVal                    10a   Const
     D  RtnFmtChr                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  RtvOpt                       10a   Const  Options( *NoPass )
     D  CvtCcsId                     10i 0 Const  Options( *NoPass )
     D  DtaCcsId                     10i 0 Const  Options( *NoPass )

     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Check if watch is active:
     D ChkWchAct       Pr              n
     D  PxSsnId                      10a   Value  Varying  Options( *Trim )
     **-- Check table key:
     D ChkTblKey       Pr              n
     D  PxTblKey                     10a   Value  Varying  Options( *Trim )
     **-- Retrieve message:
     D RtvMsg          Pr          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D CBX247V         Pr
     D  PxSsnId                      10a   Varying
     **
     D CBX247V         Pi
     D  PxSsnId                      10a   Varying

      /Free

        If  ChkWchAct( PxSsnId ) = *On;
          SndDiagMsg( 'CPD0006'
                    : '0000' + RtvMsg( 'CPF39E3': 'QCPFMSG': PxSsnId )
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  ChkObj( AppTbl_q: '*FILE' ) = *On;

          If  ChkTblKey( PxSsnId ) = *On;
            SndDiagMsg( 'CPD0006'
                      : '0000' + RtvMsg( 'CPF39E3': 'QCPFMSG': PxSsnId )
                      );

            SndEscMsg( 'CPF0002': '' );
          EndIf;
        EndIf;

        *InLr = *On;
        Return;

      /End-Free

     **-- Check object existence:
     P ChkObj          B
     D                 Pi              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     **-- Object information:
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
     **-- Check if watch is active:
     P ChkWchAct       B
     D                 Pi              n
     D  PxSsnId                      10a   Value  Varying  Options( *Trim )

     **-- Watch information:
     D WCHI0100        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0 Inz( 24 )
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
           Return  *Off;

         Else;
           Return  *On;
         EndIf;

      /End-Free

     P ChkWchAct       E
     **-- Check table key:
     P ChkTblKey       B
     D                 Pi              n
     D  PxTblKey                     10a   Value  Varying  Options( *Trim )

     **-- Local variables:
     D rc              s             10i 0
     D pRFILE          s               *
     D pRIOFB          s               *
     D KeyFnd          s               n   Inz( *Off )

     **-- Record buffer:
     D QATOCSTART    E DS         65535    ExtName( QATOCSTART )  Qualified
     **-- Search type constants:
     D KEY_EQ          s             10i 0 Inz( x'0B000100' )
     D KEY_NEXTEQ      s             10i 0 Inz( x'0E000100' )
     D NO_LOCK         s             10i 0 Inz( x'00000001' )
     **-- I/O feedback structure:
     D RIOFB           Ds                  Based( pRIOFB )  Qualified
     D  pKey                           *
     D  pSysParm                       *
     D  RcdRrn                       10u 0
     D  NbrBytRw                     10i 0
     D  BlkCnt                        5i 0
     D  BitFld                        1a
     D                               20a
     **-- I/O feedback structure:
     D RFILE           Ds                  Based( pRFILE )  Qualified
     D  Res1                         16a
     D  pBufInp                        *
     D  pBufOut                        *
     D  Res2                         48a
     D  RIOFBx                             LikeDs( RIOFB )
     D  Res3                         32a
     D  BufLen                       10u 0
     D  Res4                         28a
     D  pNulMapInp                     *
     D  pNulMapOut                     *
     D  pNulKeyMap                     *
     D  Res5                         48a
     D  MinLen                       10i 0
     D  NulMapLen                     5i 0
     D  NulKeyMapLen                  5i 0
     D  Res6                          8a

      /Free

        pRFILE = Ropen( %TrimR( AppTbl_q.AppLib ) + '/' +
                        %TrimR( AppTbl_q.AppTbl )
                      : 'rr, rtncode=N'
                      );

        If  pRFILE <> *Null;

          pRIOFB = Rlocate( pRFILE
                          : %Addr( PxTblKey: *Data )
                          : %Len( PxTblKey )
                          : KEY_EQ + NO_LOCK
                          );

          If  RIOFB.NbrBytRw > *Zero;
            KeyFnd = *On;
          EndIf;

          rc = Rclose( pRFILE );
        EndIf;

        Return  KeyFnd;

      /End-Free

     P ChkTblKey       E
     **-- Retrieve message:
     P RtvMsg          B
     D                 Pi          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Local variables:
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
               : PxMsgFil + '*LIBL'
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
     **-- Send diagnostic message:
     P SndDiagMsg      B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Local variables:
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

     **-- Local variables:
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
