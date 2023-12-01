     **
     **  Program . . :  CBX249
     **  Description :  Add Watch Definition - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **  Programmer's notes:
     **    This program adopts authority from user profile QSECOFR in
     **    order to perform the requested profile swaps successfully, if
     **    *WCHDFN was specified for the STRWCHDFN command's USRPRF
     **    parameter.
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX249 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX249 )
     **               Module( CBX249 )
     **               UsrPrf( *OWNER )
     **               ActGrp( *NEW )
     **
     **    ChgObjOwn  Obj( CBX249 )
     **               ObjType( *PGM )
     **               NewOwn( QSECOFR )
     **
     **    ChgPgm     Pgm( CBX249 )
     **               RmvObs( *ALL )
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
     D Idx             s             10i 0
     D IdxQue          s             10i 0
     D IdxJob          s             10i 0
     D StrSsnId        s             10a
     D GenSsnId        s             10a   Varying
     **
     D PrfHdlCur       s             12a   Inz( *LoVal )
     D PrfHdlNew       s             12a   Inz( *LoVal )
     **
     D WchMsgQue_q     s             20a   Dim( 3 )
     D NbrMsgQue       s             10i 0
     D WchJobNam_q     s             26a   Dim( 5 )
     D NbrJobNam       s             10i 0
     **
     D NbrSpcAut       s             10i 0
     D SpcAutLst       s             10a   Dim( 8 )
     D AutFlg          s              1a
     **
     D rc              s             10i 0
     D pRFILE          s               *
     D pRIOFB          s               *

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

     **-- File record buffer:
     D CBX247F       E Ds                  ExtName( CBX247F )  Qualified

     **-- Global constants:
     D NULL            c                   ''
     D ADP_PRV_INVLVL  c                   1
     D OFS_MSGDTA      c                   16
     **
     D MSG_FIX_LEN     c                   100
     D LIC_FIX_LEN     c                   32
     D PAL_FIX_LEN     c                   32
     **-- Search type constants:
     D KEY_EQ          s             10i 0 Inz( x'0B000100' )
     D KEY_NEXTEQ      s             10i 0 Inz( x'0E000100' )
     D NO_LOCK         s             10i 0 Inz( x'00000001' )

     **-- Watch session definition table:
     D AppTbl_q        Ds                  Qualified
     D  AppTbl                       10a   Inz( 'CBX247F' )
     D  AppLib                       10a   Inz( 'QGPL' )

     **-- Watch session attributes:
     D WchSsnAtr       Ds                  Qualified  Inz
     D  LenInf                       10i 0 Inz( %Size( WchSsnAtr ))
     D  RunPty                       10i 0
     D  OfsWchPgmOpt                 10i 0 Inz( 16 )
     D  NbrWchPgmOpt                 10i 0
     D  WchPgmOpt                    10a   Dim( 2 )
     **-- Watch for message:
     D WchMsgStr       Ds                  Qualified  Inz
     D  NbrMsg                       10i 0
     D  WchMsg                    18432a
     **
     D WchMsgStrLen    s             10i 0
     D WchMsgOfs       s            256    Based( pWchMsgOfs )
     **
     D WchMsgEnt       Ds           256    Qualified
     D  EntLen                       10i 0
     D  MsgId                         7a
     D                                1a   Inz( *Allx'00' )
     D  WchMsgQue_q                  20a
     D   WchMsgQue                   10a   Overlay( WchMsgQue_q:  1 )
     D   MsgQueLib                   10a   Overlay( WchMsgQue_q: 11 )
     D  WchJobNam_q                  26a
     D   WchJobNam                   10a   Overlay( WchJobNam_q:  1 )
     D   WchJobUsr                   10a   Overlay( WchJobNam_q: 11 )
     D   WchJobNbr                    6a   Overlay( WchJobNam_q: 21 )
     D                                6a   Inz( *Allx'00' )
     D  OfsMsgCmpDta                 10i 0
     D  LenMsgCmpDta                 10i 0
     D  CmpAgs                       10a
     D  MsgTyp                       10a
     D  RelOpr                        3a
     D                                1a   Inz( *Allx'00' )
     D  SevCod                       10i 0
     D  CmpDta                       72a
     **-- Watch for LIC log:
     D WchLicStr       Ds                  Qualified  Inz
     D  NbrLic                       10i 0
     D  WchLic                     2500a
     **
     D WchLicStrLen    s             10i 0
     D WchLicOfs       s            256    Based( pWchLicOfs )
     **
     D WchLicLogEnt    Ds           256    Qualified  Inz
     D  EntLen                       10i 0
     D  LogMajCod                     4a
     D  LogMinCod                     4a
     D  OfsLogCmpDta                 10i 0
     D  LenLogCmpDta                 10i 0
     D  CmpAgs                       10a
     D                                2a
     D  CmpDta                       72a
     **-- Watch for PAL:
     D WchPalStr       Ds                  Qualified  Inz
     D  NbrPal                       10i 0
     D  WchPal                     1000a
     **
     D WchPalStrLen    s             10i 0
     D WchPalOfs       s            256    Based( pWchPalOfs )
     **
     D WchPalEnt       Ds           256    Qualified  Inz
     D  EntLen                       10i 0
     D  SysRefCod                     8a
     D  OfsPalCmpDta                 10i 0
     D  LenPalCmpDta                 10i 0
     D  CmpAgs                       10a
     D                                2a
     D  CmpDta                       10a

     **-- Start watch:
     D StrWch          Pr                  ExtPgm( 'QSCSWCH' )
     D  SsnId                        10a   Const
     D  StrSsnId                     10a
     D  WchPgm_q                     20a   Const
     D  WchMsg                    32767a   Const  Options( *VarSize )
     D  WchLicLog                 32767a   Const  Options( *VarSize )
     D  Error                      1024a          Options( *VarSize )
     D  WchSsnAtr                  1024a   Const  Options( *VarSize: *NoPass )
     D  WchPal                    32767a   Const  Options( *VarSize: *NoPass )
     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get profile handle:
     D GetPrfHdlNoPwd  Pr                  ExtProc( 'QsyGetProfileHandleNoPwd' )
     D  PrfHdl                       12a
     D  UsrPrf                       10a   Const
     D  PwdVal                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Set profile handle:
     D SetPrfHdl       Pr                  ExtProc( 'QsySetToProfileHandle' )
     D  PrfHdl                       12a   Const
     D  Error                     32767a          Options( *VarSize: *NoPass )
     **-- Release profile handle:
     D RlsPrfHdl       Pr                  ExtProc( 'QsyReleaseProfileHandle' )
     D  PrfHdl                       12a   Const
     D  Error                     32767a          Options( *VarSize: *NoPass )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
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

     **-- Align structure length:
     D Align           Pr            10i 0
     D  PxStrLen                     10i 0 Value
     D  PxAlgBdy                     10i 0 Value
     **-- Get object owner:
     D GetObjOwn       Pr            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
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
     D WchPgm_q        Ds                  Qualified
     D  WchPgm                       10a
     D  PgmLib                       10a
     **
     D CalWcp          Ds                  Qualified
     D  NbrElm                        5i 0
     D  WcpEvt                        7a   Dim( 2 )
     **
     D WchMsg          Ds         12284    Qualified
     D  NbrElm                        5i 0
     D  DisLst                        5i 0 Dim( 5 )
     **
     D WchMsgLst       Ds                  Qualified  Based( pWchMsgLst )
     D  NbrVal                        5i 0
     D  MsgWch                        7a
     D  CmpDta                       72a   Varying
     D  CmpAgs                       10a
     D  MsgTyp                       10a
     D  RelOpr                       10a
     D  SevCod                        5i 0
     **
     D WchMsgQue       Ds           128    Qualified
     D  NbrElm                        5i 0
     D  DisLst                        5i 0 Dim( 3 )
     **
     D MsgQueLst       Ds                  Qualified  Based( pMsgQueLst )
     D  NbrVal                        5i 0
     D  MsgQue_q                     20a
     D   MsgQueNam                   10a   Overlay( MsgQue_q:  1 )
     D   MsgQueLib                   10a   Overlay( MsgQue_q: 11 )
     **
     D WchJob          Ds           256    Qualified
     D  NbrElm                        5i 0
     D  DisLst                        5i 0 Dim( 5 )
     **
     D WchJobLst       Ds                  Qualified  Based( pWchJobLst )
     D  NbrVal                        5i 0
     D  JobNam_q                     26a
     D   JobNam                      10a   Overlay( JobNam_q:  1 )
     D   UsrPrf                      10a   Overlay( JobNam_q: 11 )
     D   JobNbr                       6a   Overlay( JobNam_q: 21 )
     **
     D WchLic          Ds           512    Qualified
     D  NbrElm                        5i 0
     D  DisLst                        5i 0 Dim( 5 )
     **
     D WchLicLst       Ds                  Qualified  Based( pWchLicLst )
     D  NbrVal                        5i 0
     D  MajCod                        4a
     D  MinCod                        4a
     D  CmpDta                       72a   Varying
     D  CmpAgs                       10a
     **
     D WchPal          Ds           256    Qualified
     D  NbrElm                        5i 0
     D  DisLst                        5i 0 Dim( 5 )
     **
     D WchPalLst       Ds                  Qualified  Based( pWchPalLst )
     D  NbrVal                        5i 0
     D  SysRefCod                     8a
     D  CmpDta                       10a   Varying
     D  CmpAgs                       10a
     **
     D CBX249          Pr
     D  PxSsnId                      10a   Varying
     D  PxUsrPrf                     10a
     D  PxVfyPgmOwn                  10a
     **
     D CBX249          Pi
     D  PxSsnId                      10a   Varying
     D  PxUsrPrf                     10a
     D  PxVfyPgmOwn                  10a

      /Free

        ExSr  ChkAut;

        pRFILE = Ropen( 'QGPL/CBX247F': 'rr, rtncode=N' );

        If  pRFILE <> *Null;
          GetPrfHdlNoPwd( PrfHdlCur: '*CURRENT': '*NOPWDCHK': ERRC0100 );

          Select;
          When  PxSsnId = '*ALL';
            ExSr  StrAllWch;

          When  %Scan( '*': PxSsnId ) > 1;
            ExSr  StrGenWch;

          Other;
            ExSr  StrSngWch;
          EndSl;

          rc = Rclose( pRFILE );

          RlsPrfHdl( PrfHdlCur: ERRC0100 );
        EndIf;

        *InLr = *On;
        Return;

        BegSr  ChkAut;

          NbrSpcAut = 3;
          SpcAutLst( 1 ) = '*ALLOBJ';
          SpcAutLst( 2 ) = '*JOBCTL';
          SpcAutLst( 3 ) = '*SERVICE';

          If  PxUsrPrf = '*WCHDFN';
            NbrSpcAut = 4;
            SpcAutLst( 4 ) = '*SECADM';
          EndIf;

          ChkSpcAut( AutFlg
                   : PgmSts.UsrPrf
                   : SpcAutLst
                   : NbrSpcAut
                   : ADP_PRV_INVLVL
                   : ERRC0100
                   );

          If  ERRC0100.BytAvl > *Zero  Or  AutFlg = 'N';
            SndEscMsg( 'CPFB304': NULL );
          EndIf;

        EndSr;

        BegSr  StrSngWch;

          pRIOFB = Rreadk( pRFILE
                         : %Addr( CBX247F )
                         : %Size( CBX247F )
                         : KEY_EQ + NO_LOCK
                         : %Addr( PxSsnId: *Data )
                         : %Len( PxSsnId )
                         );

          If  RIOFB.NbrBytRw > *Zero;

            ExSr  StrWchDfn;
          EndIf;

        EndSr;

        BegSr  StrGenWch;

          GenSsnId = %TrimR( PxSsnID: ' *' );

          pRIOFB = Rreadk( pRFILE
                         : %Addr( CBX247F )
                         : %Size( CBX247F )
                         : KEY_EQ + NO_LOCK
                         : %Addr( GenSsnId: *Data )
                         : %Len( GenSsnId )
                         );

          DoW  RIOFB.NbrBytRw > *Zero;

            ExSr  StrWchDfn;

            pRIOFB = Rreadk( pRFILE
                           : %Addr( CBX247F )
                           : %Size( CBX247F )
                           : KEY_NEXTEQ + NO_LOCK
                           : %Addr( GenSsnId: *Data )
                           : %Len( GenSsnId )
                           );
          EndDo;

        EndSr;

        BegSr  StrAllWch;

          pRIOFB = Rreadf( pRFILE
                         : %Addr( CBX247F )
                         : %Size( CBX247F )
                         : NO_LOCK
                         );

          DoW  RIOFB.NbrBytRw > *Zero;

            ExSr  StrWchDfn;

            pRIOFB = Rreadn( pRFILE
                           : %Addr( CBX247F )
                           : %Size( CBX247F )
                           : NO_LOCK
                           );
          EndDo;

        EndSr;

        BegSr  StrWchDfn;

          ExSr  LodWchDfn;

          ExSr  LodWchPrm;

          If  PxUsrPrf = '*WCHDFN';

            If  PxVfyPgmOwn = '*YES'  And
                CBX247F.CRTUSR <> GetObjOwn( WchPgm_q: '*PGM' );

              SndDiagMsg( 'CPF9897'
                        : 'Watch definition ' + %TrimR( CBX247F.SSNID )  +
                          ' did not start, incorrect watch program owner.'
                        );

              LeaveSr;
            EndIf;

            GetPrfHdlNoPwd( PrfHdlNew: CBX247F.CRTUSR: '*NOPWDCHK': ERRC0100 );

            SetPrfHdl( PrfHdlNew: ERRC0100 );
            RlsPrfHdl( PrfHdlNew: ERRC0100 );
          EndIf;

          StrWch( CBX247F.SSNID
                : StrSsnId
                : WchPgm_q
                : WchMsgStr
                : WchLicStr
                : ERRC0100
                : WchSsnAtr
                : WchPalStr
                );

          If  PxUsrPrf = '*WCHDFN';
            SetPrfHdl( PrfHdlCur );
          EndIf;

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          SndCmpMsg( 'Watch definition ' + %TrimR( CBX247F.SSNID ) +
                     ' was succesfully started.');

          Reset  WchSsnAtr;
          Reset  WchMsgStr;
          Reset  WchLicStr;
          Reset  WchPalStr;

        EndSr;

        BegSr  LodWchDfn;

          WchPgm_q  = CBX247F.WCHPGM;
          CalWcp    = CBX247F.CALWCP;
          WchMsg    = CBX247F.WCHMSG;
          WchMsgQue = CBX247F.WCHMSQ;
          WchJob    = CBX247F.WCHJOB;
          WchLic    = CBX247F.WCHLIC;
          WchPal    = CBX247F.WCHPAL;

        EndSr;

        BegSr  LodWchPrm;

          ExSr  LodSsnAtr;

          ExSr  LodMsgPrm;

          ExSr  LodMsgStr;

          ExSr  LodLicStr;

          ExSr  LodPalStr;

        EndSr;

        BegSr  LodMsgStr;

          pWchMsgOfs = %Addr( WchMsgStr.WchMsg );

          For  Idx = 1  to  WchMsg.NbrElm;
            pWchMsgLst = %Addr( WchMsg ) + WchMsg.DisLst(Idx);

            If  WchMsgLst.MsgWch = '*NONE';
              Leave;
            EndIf;

            WchMsgEnt.MsgId  = WchMsgLst.MsgWch;
            WchMsgEnt.MsgTyp = WchMsgLst.MsgTyp;
            WchMsgEnt.RelOpr = WchMsgLst.RelOpr;
            WchMsgEnt.SevCod = WchMsgLst.SevCod;

            WchMsgEnt.LenMsgCmpDta = %Len( WchMsgLst.CmpDta );
            WchMsgEnt.OfsMsgCmpDta = MSG_FIX_LEN;

            If  WchMsgEnt.LenMsgCmpDta = *Zero;
              WchMsgEnt.CmpAgs = *Blanks;
            Else;
              WchMsgEnt.CmpAgs = WchMsgLst.CmpAgs;
            EndIf;

            WchMsgEnt.CmpDta = WchMsgLst.CmpDta;

            WchMsgEnt.EntLen = WchMsgEnt.OfsMsgCmpDta + WchMsgEnt.LenMsgCmpDta;

            WchMsgEnt.EntLen = Align( WchMsgEnt.EntLen: 4 );

            ExSr  LodMsgQue;
          EndFor;

        EndSr;

        BegSr  LodMsgQue;

          For  IdxQue = 1  to  NbrMsgQue;
            WchMsgEnt.WchMsgQue_q = WchMsgQue_q(IdxQue);

            If  WchMsgEnt.WchMsgQue_q = '*JOBLOG';
              ExSr  LodJobNam;
            Else;
              WchMsgEnt.WchJobNam_q = *Blanks;

              ExSr  AddMsgEnt;
            EndIf;
          EndFor;

        EndSr;

        BegSr  LodJobNam;

          For  IdxJob = 1  to  NbrJobNam;
            WchMsgEnt.WchJobNam_q = WchJobNam_q(IdxJob);

            If  %Scan( '*': WchMsgEnt.WchJobNam ) > *Zero  Or
                %Scan( '*': WchMsgEnt.WchJobUsr ) > *Zero;

              If  WchMsgEnt.WchJobNbr = '*ALL';
                WchMsgEnt.WchJobNbr = *Blanks;
              EndIf;
            EndIf;

            ExSr  AddMsgEnt;
          EndFor;

        EndSr;

        BegSr  AddMsgEnt;

          WchMsgStrLen += WchMsgEnt.EntLen;
          WchMsgStr.NbrMsg += 1;

          WchMsgOfs = WchMsgEnt;

          pWchMsgOfs += WchMsgEnt.EntLen;

        EndSr;

        BegSr  LodLicStr;

          pWchLicOfs = %Addr( WchLicStr.WchLic );

          For  Idx = 1  to  WchLic.NbrElm;
            pWchLicLst = %Addr( WchLic ) + WchLic.DisLst(Idx);

            If  WchLicLst.MajCod = '*NON';
              Leave;
            EndIf;

            WchLicLogEnt.LogMajCod = WchLicLst.MajCod;
            WchLicLogEnt.LogMinCod = WchLicLst.MinCod;

            WchLicLogEnt.LenLogCmpDta = %Len( WchLicLst.CmpDta );
            WchLicLogEnt.OfsLogCmpDta = LIC_FIX_LEN;

            If  WchLicLogEnt.LenLogCmpDta = *Zero;
              WchLicLogEnt.CmpAgs = *Allx'00';
            Else;
              WchLicLogEnt.CmpAgs = WchLicLst.CmpAgs;
            EndIf;

            WchLicLogEnt.CmpDta = WchLicLst.CmpDta;

            WchLicLogEnt.EntLen = WchLicLogEnt.OfsLogCmpDta +
                                  WchLicLogEnt.LenLogCmpDta;

            WchLicLogEnt.EntLen = Align( WchLicLogEnt.EntLen: 4 );

            ExSr  AddLicEnt;
          EndFor;

        EndSr;

        BegSr  AddLicEnt;

          WchLicStrLen += WchLicLogEnt.EntLen;
          WchLicStr.NbrLic += 1;

          WchLicOfs = WchLicLogEnt;

          pWchLicOfs += WchLicLogEnt.EntLen;

        EndSr;

        BegSr  LodPalStr;

          pWchPalOfs = %Addr( WchPalStr.WchPal );

          For  Idx = 1  to  WchPal.NbrElm;
            pWchPalLst = %Addr( WchPal ) + WchPal.DisLst(Idx);

            If  WchPalLst.SysRefCod = '*NONE';
              Leave;
            EndIf;

            WchPalEnt.SysRefCod = WchPalLst.SysRefCod;

            WchPalEnt.OfsPalCmpDta = PAL_FIX_LEN;
            WchPalEnt.LenPalCmpDta = %Len( WchPalLst.CmpDta );

            If  WchPalEnt.LenPalCmpDta = *Zero;
              WchPalEnt.CmpAgs = *Allx'40';
            Else;
              WchPalEnt.CmpAgs = WchPalLst.CmpAgs;
            EndIf;

            WchPalEnt.CmpDta = WchPalLst.CmpDta;

            WchPalEnt.EntLen = WchPalEnt.OfsPalCmpDta + WchPalEnt.LenPalCmpDta;

            WchPalEnt.EntLen = Align( WchPalEnt.EntLen: 4 );

            ExSr  AddPalEnt;

          EndFor;

        EndSr;

        BegSr  AddPalEnt;

          WchPalStrLen += WchPalEnt.EntLen;
          WchPalStr.NbrPal += 1;

          WchPalOfs = WchPalEnt;

          pWchPalOfs += WchPalEnt.EntLen;

        EndSr;

        BegSr  LodMsgPrm;

          NbrMsgQue = WchMsgQue.NbrElm;

          For  Idx = 1  to  WchMsgQue.NbrElm;
            pMsgQueLst = %Addr( WchMsgQue ) + WchMsgQue.DisLst(Idx);

            WchMsgQue_q(Idx) = MsgQueLst.MsgQue_q;
          EndFor;

          If  WchMsg.NbrElm > *Zero  And  WchMsgQue.NbrElm = *Zero;
            WchMsgQue_q(1) = '*SYSOPR';
            NbrMsgQue = 1;
          EndIf;

          NbrJobNam = WchJob.NbrElm;

          For  Idx = 1  to  WchJob.NbrElm;
            pWchJobLst = %Addr( WchJob ) + WchJob.DisLst(Idx);

            WchJobNam_q(Idx) = WchJobLst.JobNam_q;
          EndFor;

        EndSr;

        BegSr  LodSsnAtr;

          For  Idx = 1  to  CalWcp.NbrElm;

            If  CalWcp.WcpEvt(Idx) <> '*WCHEVT';
              WchSsnAtr.NbrWchPgmOpt += 1;
              WchSsnAtr.WchPgmOpt(WchSsnAtr.NbrWchPgmOpt)= CalWcp.WcpEvt(Idx);
            EndIf;
          EndFor;

          WchSsnAtr.RunPty = CBX247F.RUNPTY;

        EndSr;

        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

      /End-Free

     **-- Align structure length:
     P Align           B
     D                 Pi            10i 0
     D  PxStrLen                     10i 0 Value
     D  PxAlgBdy                     10i 0 Value

     **-- Local variable:
     D Int             s             10i 0

      /Free

        Int = %Div( PxStrLen: PxAlgBdy );

        If  %Rem( PxStrLen: PxAlgBdy ) > *Zero;
          Int += 1;
        EndIf;

        Return  Int * PxAlgBdy;

      /End-Free

     P Align           E
     **-- Get object owner:
     P GetObjOwn       B
     D                 Pi            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  ObjLibRtn                    10a
     D  ObjASP                       10i 0
     D  ObjOwn                       10a
     D  ObjDmn                        2a

      /Free

         RtvObjD( OBJD0100
                : %Size( OBJD0100 )
                : 'OBJD0100'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );

         If  ERRC0100.BytAvl > *Zero;
           Return  *Blanks;

         Else;
           Return  OBJD0100.ObjOwn;
         EndIf;

      /End-Free

     P GetObjOwn       E
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

     **-- Local variable:
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
