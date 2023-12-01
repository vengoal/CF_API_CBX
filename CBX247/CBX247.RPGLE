     **
     **  Program . . :  CBX247
     **  Description :  Add Watch Definition - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX247 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX247 )
     **              Module( CBX247 )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

      /copy SQLCLI_H

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
     **
     D WchMsgQue_q     s             20a   Dim( 3 )
     D NbrMsgQue       s             10i 0
     D WchJobNam_q     s             26a   Dim( 5 )
     D NbrJobNam       s             10i 0
     **
     D rc              s                   Like( SQLRETURN )
     D env             s                   Like( SQLHENV )
     D conn            s                   Like( SQLHDBC )
     D stmt            s                   Like( SQLHSTMT )
     **
     D SQLStmt         s           4096a   Varying
     D SQLTable        s             21a   Varying

     **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
     **
     D SQL_IGN_INT     c                   0
     **
     D MSG_FIX_LEN     c                   100
     D LIC_FIX_LEN     c                   32
     D PAL_FIX_LEN     c                   32

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

     **-- Watch definition:
     D WchDfn          Ds                  Qualified
     D  SsnId                        10a
     D  WchPgm_q                     20a
     D  CalWcp                       20a
     D  WchMsg                    12284a
     D  WchMsgQue                   128a
     D  WchJob                      256a
     D  WchLic                      512a
     D  WchPal                      256a
     D  RunPty                        5i 0
     D  TxtDsc                       72a
     D  CrtUsr                       10a
     **-- SQL value lengths - taken at runtime:
     D lenParm1        s             10i 0 Inz( %Size( SQLValue.SsnId  ))
     D lenParm2        s             10i 0 Inz( %Size( SQLValue.WchPgm_q ))
     D lenParm3        s             10i 0 Inz( %Size( SQLValue.CalWcp ))
     D lenParm4        s             10i 0 Inz( %Size( SQLValue.WchMsg ))
     D lenParm5        s             10i 0 Inz( %Size( SQLValue.WchMsgQue ))
     D lenParm6        s             10i 0 Inz( %Size( SQLValue.WchJob ))
     D lenParm7        s             10i 0 Inz( %Size( SQLValue.WchLic ))
     D lenParm8        s             10i 0 Inz( %Size( SQLValue.WchPal ))
     D lenParm10       s             10i 0 Inz( %Size( SQLValue.TxtDsc ))
     D lenParm11       s             10i 0 Inz( %Size( SQLValue.CrtUsr ))
     **-- SQL insert values:
     D SQLValue        Ds                  Qualified
     D  SsnId                        10a
     D  WchPgm_q                     20a
     D  CalWcp                       20a
     D  WchMsg                    12284a
     D  WchMsgQue                   128a
     D  WchJob                      256a
     D  WchLic                      512a
     D  WchPal                      256a
     D  RunPty                        5i 0
     D  TxtDsc                       72a
     D  CrtUsr                       10a

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
     **-- Register activation group exit:
     D CEE4RAGE        Pr
     D  procedure                      *   ProcPtr  Const
     D  feedback                     12a   Options( *omit )

     **-- Cleanup:
     D Cleanup         Pr
     **-- Check error:
     D Check_error     Pr
     D  rc                           10i 0 Value
     D  env                                Like( SQLHENV )   Value
     D  conn                               Like( SQLHDBC )   Value
     D  stmt                               Like( SQLHSTMT )  Value
     D  function                     50a   Varying  Const
     **-- Align structure length:
     D Align           Pr            10i 0
     D  PxStrLen                     10i 0 Value
     D  PxAlgBdy                     10i 0 Value
     **-- Double quotes:
     D DblQuotes       Pr          4096a   Varying
     D  PxString                   4096a   Value  Varying
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Get object library:
     D GetObjLib       Pr            10a
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
     D ObjNam_q        Ds                  Qualified
     D  ObjNam                       10a
     D  ObjLib                       10a
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
     D CBX247          Pr
     D  PxSsnId                      10a   Varying
     D  PxWchPgm_q                         LikeDs( ObjNam_q )
     D  PxCalWcp                           LikeDs( CalWcp )
     D  PxWchMsg                           LikeDs( WchMsg )
     D  PxWchMsgQue                        LikeDs( WchMsgQue )
     D  PxWchJob                           LikeDs( WchJob )
     D  PxWchLic                           LikeDs( WchLic )
     D  PxWchPal                           LikeDs( WchPal )
     D  PxRunPty                      5i 0
     D  PxTxtDsc                     72a   Varying
     **
     D CBX247          Pi
     D  PxSsnId                      10a   Varying
     D  PxWchPgm_q                         LikeDs( ObjNam_q )
     D  PxCalWcp                           LikeDs( CalWcp )
     D  PxWchMsg                           LikeDs( WchMsg )
     D  PxWchMsgQue                        LikeDs( WchMsgQue )
     D  PxWchJob                           LikeDs( WchJob )
     D  PxWchLic                           LikeDs( WchLic )
     D  PxWchPal                           LikeDs( WchPal )
     D  PxRunPty                      5i 0
     D  PxTxtDsc                     72a   Varying

      /Free

        ExSr  InzSqlCli;

        ExSr  LodWchDfn;

        ExSr  LodWchPrm;

        StrWch( PxSsnId
              : StrSsnId
              : PxWchPgm_q
              : WchMsgStr
              : WchLicStr
              : ERRC0100
              : WchSsnAtr
              : WchPalStr
              );

        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;

        ExSr  RunSqlStm;

        ExSr  EndSqlCli;

        SndCmpMsg( 'Watch definition ' + PxSsnId +
                   ' was succesfully added and watch started.');

        *InLr = *On;
        Return;


        BegSr  LodWchDfn;

          If  PxWchPgm_q.ObjLib = '*LIBL';
            PxWchPgm_q.ObjLib = GetObjLib( PxWchPgm_q: '*PGM' );
          EndIf;

          WchDfn.SsnId     = PxSsnId;
          WchDfn.WchPgm_q  = PxWchPgm_q;
          WchDfn.CalWcp    = PxCalWcp;
          WchDfn.WchMsg    = PxWchMsg;
          WchDfn.WchMsgQue = PxWchMsgQue;
          WchDfn.WchJob    = PxWchJob;
          WchDfn.WchLic    = PxWchLic;
          WchDfn.WchPal    = PxWchPal;
          WchDfn.TxtDsc    = PxTxtDsc;
          WchDfn.CrtUsr    = PgmSts.CurUsr;

          If  %Addr( PxRunPty ) = *Null;
            WchDfn.RunPty  = *Zero;
          Else;
            WchDfn.RunPty  = PxRunPty;
          EndIf;

        EndSr;

        BegSr  LodWchPrm;

          ExSr  GetSsnAtr;

          ExSr  GetMsgPrm;

          ExSr  LodMsgStr;

          ExSr  LodLicStr;

          ExSr  LodPalStr;

        EndSr;

        BegSr  LodMsgStr;

          pWchMsgOfs = %Addr( WchMsgStr.WchMsg );

          For  Idx = 1  to  PxWchMsg.NbrElm;
            pWchMsgLst = %Addr( PxWchMsg ) + PxWchMsg.DisLst(Idx);

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

          For  Idx = 1  to  PxWchLic.NbrElm;
            pWchLicLst = %Addr( PxWchLic ) + PxWchLic.DisLst(Idx);

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

          For  Idx = 1  to  PxWchPal.NbrElm;
            pWchPalLst = %Addr( PxWchPal ) + PxWchPal.DisLst(Idx);

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

        BegSr  GetMsgPrm;

          NbrMsgQue = PxWchMsgQue.NbrElm;

          For  Idx = 1  to  PxWchMsgQue.NbrElm;
            pMsgQueLst = %Addr( PxWchMsgQue ) + PxWchMsgQue.DisLst(Idx);

            WchMsgQue_q(Idx) = MsgQueLst.MsgQue_q;
          EndFor;

          If  PxWchMsg.NbrElm > *Zero  And  PxWchMsgQue.NbrElm = *Zero;
            WchMsgQue_q(1) = '*SYSOPR';
            NbrMsgQue = 1;
          EndIf;

          NbrJobNam = PxWchJob.NbrElm;

          For  Idx = 1  to  PxWchJob.NbrElm;
            pWchJobLst = %Addr( PxWchJob ) + PxWchJob.DisLst(Idx);

            WchJobNam_q(Idx) = WchJobLst.JobNam_q;
          EndFor;

        EndSr;

        BegSr  GetSsnAtr;

          For  Idx = 1  to  PxCalWcp.NbrElm;

            If  PxCalWcp.WcpEvt(Idx) <> '*WCHEVT';
              WchSsnAtr.NbrWchPgmOpt += 1;
              WchSsnAtr.WchPgmOpt(WchSsnAtr.NbrWchPgmOpt)= PxCalWcp.WcpEvt(Idx);
            EndIf;
          EndFor;

          If  %Addr( PxRunPty ) = *Null;
            WchSsnAtr.RunPty = *Zero;
          Else;
            WchSsnAtr.RunPty = PxRunPty;
          EndIf;

        EndSr;

        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

        BegSr  RunSqlStm;

          Eval-Corr  SQLValue = WchDfn;

          rc = SQLExecute( stmt );

          Check_error( rc: env: conn: stmt: 'SQLExecute()' );

        EndSr;

        BegSr  InzSqlCli;

          CEE4RAGE( %Paddr( Cleanup ): *Omit );

          SQLTable = %TrimR( AppTbl_q.AppLib ) + '/' +
                     %TrimR( AppTbl_q.AppTbl );

          SQLAllocEnv( env );

          SQLSetEnvAttrI( env
                        : SQL_ATTR_ENVHNDL_COUNTER
                        : SQL_TRUE
                        : %Size( SQLINTEGER )
                        );

          SQLSetEnvAttrI( env
                        : SQL_ATTR_OUTPUT_NTS
                        : SQL_FALSE
                        : %size( SQLINTEGER )
                        );

          SQLAllocConnect( env: conn );

          SQLSetConnectAttrI( conn
                            : SQL_ATTR_DBC_SYS_NAMING
                            : SQL_TRUE
                            : %Size( SQLINTEGER )
                            );

          SQLSetConnectAttrI( conn
                            : SQL_ATTR_COMMIT
                            : SQL_TXN_NO_COMMIT
                            : %Size( SQLINTEGER )
                            );

          rc = SQLConnect( conn
                         : '*LOCAL'
                         : SQL_NTS
                         : *Null
                         : SQL_NTS
                         : *Null
                         : SQL_NTS
                         );

          Check_error( rc: env: conn: stmt: 'SQLConnect()' );

          If  ChkObj( AppTbl_q: '*FILE' ) = *Off;
            ExSr  RunTblCrt;
          EndIf;

          SQLAllocStmt( conn : stmt );

          SQLStmt = 'INSERT INTO ' + SQLTable + ' '                    +
                    '(SSNID,  WCHPGM, CALWCP, WCHMSG, WCHMSQ, WCHJOB,' +
                    ' WCHLIC, WCHPAL, RUNPTY, TXTDSC, CRTUSR) '        +
                    'VALUES(?,?,?,?,?,?,?,?,?,?,?)';

          rc = SQLPrepare( stmt: SQLStmt: SQL_NTS );

          Check_error( rc: env: conn: stmt: 'SQLPrepare()' );

          ExSr  BndPrmMrk;

        EndSr;

        BegSr  BndPrmMrk;

          rc = SQLBindParameter( stmt
                               : 1
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.SsnId )
                               : *Zero
                               : %Addr( SQLValue.SsnId )
                               : SQL_IGN_INT
                               : lenParm1
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 2
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchPgm_q )
                               : *Zero
                               : %Addr( SQLValue.WchPgm_q )
                               : SQL_IGN_INT
                               : lenParm2
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 3
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.CalWcp )
                               : *Zero
                               : %Addr( SQLValue.CalWcp )
                               : SQL_IGN_INT
                               : lenParm3
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 4
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchMsg )
                               : *Zero
                               : %Addr( SQLValue.WchMsg )
                               : SQL_IGN_INT
                               : lenParm4
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 5
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchMsgQue )
                               : *Zero
                               : %Addr( SQLValue.WchMsgQue )
                               : SQL_IGN_INT
                               : lenParm5
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 6
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchJob )
                               : *Zero
                               : %Addr( SQLValue.WchJob )
                               : SQL_IGN_INT
                               : lenParm6
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 7
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchLic )
                               : *Zero
                               : %Addr( SQLValue.WchLic )
                               : SQL_IGN_INT
                               : lenParm7
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 8
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.WchPal )
                               : *Zero
                               : %Addr( SQLValue.WchPal )
                               : SQL_IGN_INT
                               : lenParm8
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 9
                               : SQL_PARAM_INPUT
                               : SQL_SMALLINT
                               : SQL_SMALLINT
                               : %Len( SQLValue.RunPty )
                               : %DecPos( SQLValue.RunPty )
                               : %Addr( SQLValue.RunPty )
                               : SQL_IGN_INT
                               : *Omit
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 10
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.TxtDsc )
                               : *Zero
                               : %Addr( SQLValue.TxtDsc )
                               : SQL_IGN_INT
                               : lenParm10
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

          rc = SQLBindParameter( stmt
                               : 11
                               : SQL_PARAM_INPUT
                               : SQL_CHAR
                               : SQL_CHAR
                               : %Size( SQLValue.CrtUsr )
                               : *Zero
                               : %Addr( SQLValue.CrtUsr )
                               : SQL_IGN_INT
                               : lenParm11
                               );

          Check_error( rc: env: conn: stmt: 'SQLBindParameter()' );

        EndSr;

        BegSr  RunTblCrt;

          rc = SQLAllocStmt( conn : stmt );

          Check_error( rc: env: conn: stmt: 'SQLAllocStmt()' );

          SQLStmt = 'CREATE TABLE ' + SQLTable + ' ('                  +
                    'SSNID  CHAR  (10)   NOT NULL WITH DEFAULT, '      +
                    'WCHPGM CHAR  (20)   NOT NULL WITH DEFAULT, '      +
                    'CALWCP CHAR  (20)   NOT NULL WITH DEFAULT, '      +
                    'WCHMSG CHAR (12284) FOR BIT DATA NOT NULL WITH DEFAULT, ' +
                    'WCHMSQ CHAR (128)   FOR BIT DATA NOT NULL WITH DEFAULT, ' +
                    'WCHJOB CHAR (256)   FOR BIT DATA NOT NULL WITH DEFAULT, ' +
                    'WCHLIC CHAR (512)   FOR BIT DATA NOT NULL WITH DEFAULT, ' +
                    'WCHPAL CHAR (256)   FOR BIT DATA NOT NULL WITH DEFAULT, ' +
                    'RUNPTY NUMERIC (2,0)    NOT NULL WITH DEFAULT, '          +
                    'TXTDSC CHAR  (72)   NOT NULL WITH DEFAULT, '              +
                    'CRTUSR CHAR  (10)   NOT NULL WITH DEFAULT, '              +
                    'CRTDTS TIMESTAMP    NOT NULL WITH DEFAULT'                +
                    ') RCDFMT WCHDFNR';

          rc = SQLExecDirect( stmt: SQLStmt: SQL_NTS );

          Check_error( rc: env: conn: stmt: 'SQLExecDirect()' );

          SQLStmt = 'LABEL ON TABLE ' + SQLTable + ' IS '          +
                    '''Watch definition system table''';

          SQLExecDirect( stmt: SQLStmt: SQL_NTS );

          SQLStmt = 'LABEL ON COLUMN ' + SQLTable + ' '             +
                    '(SSNID IS ''Session ID'', '                    +
                    'WCHPGM IS ''Watch program'', '                 +
                    'CALWCP IS ''Call watch program'', '            +
                    'WCHMSG IS ''Watch for message'', '             +
                    'WCHMSQ IS ''Watch message queue'', '           +
                    'WCHJOB IS ''Watch job'', '                     +
                    'WCHLIC IS ''Watch LIC log'', '                 +
                    'WCHPAL IS ''Watch PAL'', '                     +
                    'RUNPTY IS ''Run priority'', '                  +
                    'TXTDSC IS ''Text description'', '              +
                    'CRTUSR IS ''Create user'', '                   +
                    'CRTDTS IS ''Create timestamp'' )';

          SQLExecDirect( stmt: SQLStmt: SQL_NTS );

          SQLStmt = 'LABEL ON COLUMN ' + SQLTable + ' '            +
                    '(SSNID TEXT IS ''Identifier'', '              +
                    'WCHPGM TEXT IS ''Object name'', '             +
                    'CALWCP TEXT IS ''*WCHEVT,*STRWCH,*ENDWCH'', ' +
                    'WCHMSG TEXT IS ''Message list'', '            +
                    'WCHMSQ TEXT IS ''Message queue list'', '      +
                    'WCHJOB TEXT IS ''Job list'', '                +
                    'WCHLIC TEXT IS ''LIC entry list'', '          +
                    'WCHPAL TEXT IS ''PAL entry list'', '          +
                    'RUNPTY TEXT IS ''00-99'', '                   +
                    'TXTDSC TEXT IS ''Description'', '             +
                    'CRTUSR TEXT IS ''User profile'', '            +
                    'CRTDTS TEXT IS ''Timestamp'' )';

          SQLExecDirect( stmt: SQLStmt: SQL_NTS );

          SQLStmt = 'ALTER  TABLE ' + SQLTable + ' ADD PRIMARY KEY(SSNID)';

          SQLExecDirect( stmt: SQLStmt: SQL_NTS );

          SQLFreeStmt( stmt : SQL_DROP );

        EndSr;

        BegSr  EndSqlCli;

          Cleanup();

        EndSr;

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
     **-- Get object library:
     P GetObjLib       B
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
           Return  OBJD0100.ObjLibRtn;
         EndIf;

      /End-Free

     P GetObjLib       E
     **-- Deallocate/disconnect SQL CLI handles
     P Cleanup         B
     D                 Pi

      /Free

        If  stmt <> SQL_NULL_HSTMT;
          SQLFreeStmt( stmt :SQL_DROP );

          stmt = SQL_NULL_HSTMT;
        EndIf;

        If  conn <> SQL_NULL_HDBC;
          SQLDisconnect( conn );
          SQLFreeConnect( conn );

          conn = SQL_NULL_HDBC;
        EndIf;

        If  env <> SQL_NULL_HENV;
          SQLFreeEnv( env );

          env = SQL_NULL_HENV;
        EndIf;

      /End-Free

     P Cleanup         E
     **-- Check for an error in processed SQL statement:
     P Check_error     B
     D                 Pi
     D  rc                           10i 0 Value
     D  env                                Like( SQLHENV )   Value
     D  conn                               Like( SQLHDBC )   Value
     D  stmt                               Like( SQLHSTMT )  Value
     D  function                     50a   Varying  Const

     **-- Local variables:
     D sqlstate        s              6a
     D sqlcode         s                   Like( SQLINTEGER )
     D msgbytes        s                   Like( SQLSMALLINT )
     D errmsg          s            513a
     D rtnmsg          s           1024a   Varying

      /Free

        If  rc = SQL_NO_DATA_FOUND  Or  rc = SQL_SUCCESS;

          Return;
        EndIf;

        SQLError( env
                : conn
                : stmt
                : sqlstate
                : sqlcode
                : errmsg
                : %Size( errmsg )
                : msgbytes
                );

        If  rc < SQL_SUCCESS;

          If  msgbytes > *Zero;
            SndDiagMsg( 'CPF9897': %Subst( errmsg: 1: msgbytes ));
          EndIf;

          rtnmsg = Function     + ' failed.  '        +
                   'RC= '       + %Char( rc )         + ', '  +
                   'SQLCODE= '  + %Char( sqlcode )    + ', '  +
                   'SQLSTATE= ' + %Trim( sqlstate )   + '.';

          SndEscMsg( 'CPF9897': rtnmsg );

        Else;
          If  msgbytes > *Zero;
            SndDiagMsg( 'CPF9897': %Subst( errmsg: 1: msgbytes ));
          EndIf;

          rtnmsg = Function     + ' succeeded.  '     +
                   'RC= '       + %Char( rc )         + ', '  +
                   'SQLCODE= '  + %Char( sqlcode )    + ', '  +
                   'SQLSTATE= ' + %Trim( sqlstate )   + '.';

          SndDiagMsg( 'CPF9897': rtnmsg );
        EndIf;

        Return;

      /End-Free

     P Check_error     E
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
     **-- Double quotes:
     P DblQuotes       B
     D                 Pi          4096a   Varying
     D  PxString                   4096a   Value  Varying

     **-- Local variable:
     D Pos             s             10i 0

      /Free

          If  PxString = *Blanks;

            Return  PxString;
          Else;
            Pos = %Scan( '''': PxString );

            DoW  Pos > *Zero;
              PxString = %Replace( '''': PxString: Pos: 0 );

              If  Pos + 2 <= %Len( PxString );
                Pos = %Scan( '''': PxString: Pos + 2 );
              Else;
                Pos = *Zero;
              EndIf;
            EndDo;
          EndIf;

          Return  '''' + %TrimR( PxString  ) + '''';

      /End-Free

     P DblQuotes       E
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

     **-- Local variable:
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
