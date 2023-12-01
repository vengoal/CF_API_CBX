     **
     **  Program . . :  CBX248
     **  Description :  Remove Watch Definition - VCP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX248 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX248 )
     **              Module( CBX248 )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )

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

     **-- Watch session definition table:
     D AppTbl_q        Ds                  Qualified
     D  AppTbl                       10a   Inz( 'CBX247F' )
     D  AppLib                       10a   Inz( 'QGPL' )
     **-- Global variables:
     D rc              s             10i 0
     D pRFILE          s               *
     D pRIOFB          s               *
     **
     D SpcAutLst       s             10a   Dim( 8 )
     D AutFlg          s              1a
     **-- Search type constants:
     D KEY_EQ          s             10i 0 Inz( x'0B000100' )
     D KEY_NEXTEQ      s             10i 0 Inz( x'0E000100' )
     D NO_LOCK         s             10i 0 Inz( x'00000001' )
     **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
     D ADP_PRV_INVLVL  c                   1

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
     **-- Read by key:
     D Rreadk          Pr              *   ExtProc( '_Rreadk' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLength                    10u 0 Value
     D  Options                      10i 0 Value
     D  pKey                           *   Value
     D  KeyLength                    10u 0 Value
     **-- Read first record:
     D Rreadf          Pr              *   ExtProc( '_Rreadf' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLen                       10u 0 Value
     D  Options                      10i 0 Value
     **-- Read next record:
     D Rreadn          Pr              *   ExtProc( '_Rreadn' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLen                       10u 0 Value
     D  Options                      10i 0 Value
     **-- Delete record:
     D Rdelete         Pr              *   ExtProc( '_Rdelete' )
     D  pRFile                         *   Value
     **-- Update a record:
     D Rupdate         Pr              *   ExtProc( '_Rupdate' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLength                    10u 0 Value
     **-- Release a record lock:
     D Rrlslck         Pr            10i 0 ExtProc( '_Rrlslck' )
     D  pRFile                         *   Value

     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- End watch:
     D EndWch          Pr                  ExtPgm( 'QSCEWCH' )
     D  SsnId                        10a   Const
     D  Error                      1024a          Options( *VarSize )
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

     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D CBX248          Pr
     D  PxSsnId                      10a   Varying
     D  PxEndWch                      5a
     **
     D CBX248          Pi
     D  PxSsnId                      10a   Varying
     D  PxEndWch                      5a

      /Free

        SpcAutLst( 1 ) = '*ALLOBJ';
        SpcAutLst( 2 ) = '*SERVICE';

        ChkSpcAut( AutFlg
                 : PgmSts.UsrPrf
                 : SpcAutLst
                 : 2
                 : ADP_PRV_INVLVL
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero  Or  AutFlg = 'N';
          SndEscMsg( 'CPFB304': NULL );
        EndIf;

        pRFILE = Ropen( %TrimR( AppTbl_q.AppLib ) + '/' +
                        %TrimR( AppTbl_q.AppTbl )
                      : 'rr+, rtncode=N'
                      );

        If  pRFILE <> *Null;

          pRIOFB = Rlocate( pRFILE
                          : %Addr( PxSsnId: *Data )
                          : %Len( PxSsnId )
                          : KEY_EQ
                          );

          If  RIOFB.NbrBytRw > *Zero;
            pRIOFB = Rdelete( pRFILE );

          EndIf;

          rc = Rclose( pRFILE );

          SndCmpMsg( 'Watch definition ' + PxSsnId +
                     ' was succesfully removed.'
                   );

          If  PxEndWch = '*YES';
            EndWch( PxSsnId: ERRC0100 );

            If  ERRC0100.BytAvl > *Zero;
             ExSr  EscApiErr;

            Else;
              SndCmpMsg( 'Watch definition ' + PxSsnId +
                         ' was succesfully ended.'
                       );
            EndIf;
          EndIf;
        EndIf;

        *InLr = *On;
        Return;


        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

      /End-Free

     **-- Send completion message:
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying

     **-- Local variable:
     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return  0;

        EndIf;

      /End-Free

     P SndCmpMsg       E
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
