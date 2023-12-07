     **
     **  Program . . :  CBX2561
     **  Description :  Display Job Screen - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer, 2012.
     **
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX2561 )
     **               DbgView( *NONE )
     **
     **    CrtPgm     Pgm( CBX2561 )
     **               Module( CBX2561 )
     **               ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )

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
     D  MsgDta                     1024a

     **-- Global variables:
     D CmdBuf          s             10i 0 Inz( -1 )
     D InpHnd          s             10i 0 Inz( -1 )
     D BufSiz          s             10i 0 Inz( 8192 )
     D BytRead         s             10i 0
     D DspMode27x132   s               n   Inz( *On )
     D FncKey          s               n   Inz( *On )
     D rc              s             10i 0
     **
     D FldCnt          s             10i 0
     D FldIdx          s             10i 0
     **
     D FldInf          Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  FldTyp                        1a
     D  FldRow                       10i 0
     D  FldCol                       10i 0
     D  DtaLen                       10i 0
     D                               11a
     D  pFldDta                        *
     **
     D FldDta          s           1024a   Based( FldInf.pFldDta )
     **
     D FldLst          Ds                  Dim( 256 )  Qualified
     D  FldRow                        3u 0
     D  FldCol                        3u 0
     D  FldVal                     1024a   Varying
     **
     D SpcAutLst       s             10a   Dim( 8 )
     D AutFlg          s              1a
     **
     D CPFA312         Ds                  Qualified
     D  BufSiz                       10i 0
     D  IncVal                       10i 0
     D  MaxSiz                       10i 0
     D  DspBufSiz                    10i 0
     **
     D pInpDta         s               *   Inz( *Null )
     **
     D InpDta          Ds                  Qualified   Based( pInpDta )
     D  CsrRow                        3u 0
     D  CsrCol                        3u 0
     D  AID                           1a
     D  Data                       6300a
     **-- Global constants:
     D NULL            c                   ''
     D ADP_PRV_INVLVL  c                   1
     D OFS_MSGDTA      c                   16
     D TMO_SEC_25      c                   25
     **
     D QSN_SA_WHT      c                   x'22'
     D QSN_SA_WHT_RI   c                   x'23'
     D QSN_SA_RED      c                   x'28'
     D QSN_CC1_LOCKBD  c                   x'20'
     D QSN_CC2_NO_IC   c                   x'40'
     D QSN_ROW_COL     c                   0
     D QSN_KEY_ENTER   c                   x'F1'
     D QSN_KEY_F2      c                   x'32'
     D QSN_KEY_F3      c                   x'33'
     D QSN_KEY_F5      c                   x'35'
     D QSN_MODE_24X80  C                   '3'
     D QSN_MODE_...
     D  27X132         c                   '4'

     **-- Program data:
     D PgmDta          Ds                  Qualified
     D  DtqNam_q                     20a
     D   DtqNam                      10a   Inz( 'CBX256Q' )
     D                                     Overlay( DtqNam_q:  1 )
     D   DtqLib                      10a   Overlay( DtqNam_q: 11 )
     D  DtqKey                       16a
     D  RpyKey                       16a
     **-- Message formats:
     D RqsRcd          Ds                  Qualified
     D  RcdTyp                        6a   Inz( 'GETSCR' )
     D                              250a
     **
     D DtaRcd          Ds                  Qualified
     D  RcdTyp                        6a
     D  RtnCod                        1a
     D  CsrRow                        3u 0
     D  CsrCol                        3u 0
     D  ScnRows                       3u 0
     D  ScnCols                       3u 0
     D  ScnMod                        1a
     D  CmdEsc                        1a
     D  CmdVal                        1a
     D                               14a
     D  BufSiz                       10i 0
     D  DtaBuf                     6500a

     **-- JITP0100 format:
     D JITP0100        Ds                  Qualified
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  TgtJobNam                    10a
     D  TgtJobUsr                    10a
     D  TgtJobNbr                     6a
     D                                2a   Inz( *Allx'00' )
     D  OfsPgmDta                    10i 0 Inz( 56 )
     D  LenPgmDta                    10i 0 Inz( %Size( PgmDta ))
     D  PgmDta                     2000a

     **-- Query display mode support:
     D QryModSup       Pr            10i 0 ExtProc( 'QsnQryModSup' )
     D  DspMode                       1a   Const
     D  ModeInd                       1a   Options( *Omit )
     D  Handle                       10i 0 Options( *Omit )
     D  Error                        10i 0 Options( *Omit )
     **-- Create command buffer:
     D CrtCmdBuf       Pr            10i 0 ExtProc( 'QsnCrtCmdBuf' )
     D  InitSize                     10i 0 Const
     D  IncAmt                       10i 0 Options( *Omit )  Const
     D  MaxSize                      10i 0 Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Create input buffer:
     D CrtInpBuf       Pr            10i 0 ExtProc( 'QsnCrtInpBuf' )
     D  InitSize                     10i 0 Const
     D  IncrAmt                      10i 0 Options( *Omit )  Const
     D  MaxSize                      10i 0 Options( *Omit )  Const
     D  InpBuf                       10i 0 Options( *Omit )
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Clear buffer:
     D ClrBuf          Pr            10i 0 ExtProc( 'QsnClrBuf' )
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Clear screen:
     D ClrScr          pr            10i 0 ExtProc( 'QsnClrScr' )
     D  Mode                          1a   Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Delete buffer:
     D DltBuf          Pr            10i 0 ExtProc( 'QsnDltBuf' )
     D  BufHnd                       10i 0 Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Put output command:
     D PutOutCmd       Pr            10i 0 ExtProc( 'QsnPutOutCmd' )
     D  OutCmd                        1a   Const
     D  CmdDta                    32767a   Options( *Omit: *VarSize )  Const
     D  CmdDtaLen                    10i 0 Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Retrieve pointer to data in input buffer:
     D RtvDta          Pr              *   ExtProc( 'QsnRtvDta' )
     D  InpBuf                       10i 0 Const
     D  InpDtaPtr                      *   Options( *Omit )
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Retrieve field information:
     D RtvFldInf       Pr            10i 0 ExtProc( 'QsnRtvFldInf' )
     D  InpBuf                       10i 0 Const
     D  FldNbr                       10i 0 Const
     D  RcvVar                    32767a   Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Read input fields:
     D ReadMdt         Pr            10i 0 ExtProc( 'QsnReadMDT' )
     D  CcByte1                       1a   Const
     D  CcByte2                       1a   Const
     D  FldCnt                       10i 0 Options( *Omit )
     D  InpBuf                       10i 0 Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Set cursor address:
     D SetCsrAdr       Pr            10i 0 ExtProc( 'QsnSetCsrAdr' )
     D  FldID                        10i 0 Options( *Omit )  Const
     D  CsrRow                       10i 0 Options( *Omit )  Const
     D  CsrCol                       10i 0 Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Write data:
     D WrtDta          Pr            10i 0 ExtProc( 'QsnWrtDta' )
     D  Data                      32767a   Const  Options( *VarSize )
     D  DataLen                      10i 0 Const
     D  FldID                        10i 0 Options( *Omit ) Const
     D  Row                          10i 0 Options( *Omit ) Const
     D  Col                          10i 0 Options( *Omit ) Const
     D  StrMonoAtr                    1a   Options( *Omit ) Const
     D  EndMonoAtr                    1a   Options( *Omit ) Const
     D  StrClrAtr                     1a   Options( *Omit ) Const
     D  EndClrAtr                     1a   Options( *Omit ) Const
     D  CmdBuf                       10i 0 Options( *Omit ) Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )

     **-- Call job interrupt program:
     D JobItpPgm       Pr                  ExtPgm( 'QWCJBITP' )
     D  InpVar                    32767a          Options( *VarSize )
     D  FmtNam                        8a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
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
     D  Error                     32767a          Options( *VarSize )
     **-- Receive program message:
     D RcvPgmMsg       Pr                  ExtPgm( 'QMHRCVPM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  CalStkE                     256a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  MsgKey                        4a   Const
     D  Wait                         10i 0 Const
     D  MsgAct                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  CalStkElen                   10i 0 Const  Options( *NoPass )            call stack counter
     D  CalStkEq                     20a   Const  Options( *NoPass )            call stack counter
     D  CalStkEtyp                   20a   Const  Options( *NoPass )            call stack counter
     D  CcsId                        10i 0 Const  Options( *NoPass )            call stack counter
     **-- Generate universal unique identifier:
     D GenUuid         Pr                  ExtProc( '_GENUUID' )
     D  UUID_template                  *   Value
     **-- Test bit in string:
     D tstbts          Pr            10i 0 ExtProc( 'tstbts' )
     D  string                         *   Value
     D  bitofs                       10u 0 Value
     **-- Register activation group exit:
     D CEE4RAGE        Pr
     D  procedure                      *   ProcPtr  Const
     D  feedback                     12a   Options( *omit )
     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                     4096a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )
     **-- Send data queue entry:
     D SndDtaQe        Pr                  ExtPgm( 'QSNDDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0 Const
     D  Dta                       32767a   Const  Options( *VarSize )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  AscRqs                       10a   Const  Options( *NoPass )
     D  JrnDta                       10a   Const  Options( *NoPass )
     **-- Receive data queue entry:
     D RcvDtaQe        Pr                  ExtPgm( 'QRCVDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0
     D  Dta                       32767a          Options( *VarSize )
     D  Wait                          5p 0 Const
     D  KeyOrder                      2a   Const  Options( *NoPass )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  SndInLg                       3p 0 Const  Options( *NoPass)
     D  SndInfo                      44a          Options( *VarSize: *Nopass )
     D  RmvMsg                       10a   Const  Options( *Nopass )
     D  DtaRcvLen                     5p 0 Const  Options( *Nopass )
     D  Error                     32767a          Options( *VarSize: *Nopass )

     **-- Cleanup:
     D Cleanup         Pr
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Create commnunication data queue:
     D CrtComDtq       Pr
     D  PxDtqNam                     10a   Const  Varying  Options( *Trim )
     D  PxDtqLib                     10a   Const  Varying  Options( *Trim )
     **-- Run command:
     D RunCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
     **-- Get universal unique identifier:
     D GetUUID         Pr            16a
     **-- Put to data queue - keyed:
     D PutDtaQk        Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const
     **-- Send completion message:
     D SndCompMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                   3000a   Const  Varying  Options( *Omit )
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D JobNam_q        Ds                  Qualified
     D  JobNam                       10a
     D  JobUsr                       10a
     D  JobNbr                        6a
     **
     D CBX2561         Pr
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxCmdTmo                      5i 0
     **
     D CBX2561         Pi
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxCmdTmo                      5i 0

      /Free

        ExSr  GetRmtScn;

        DoU  InpDta.Aid = QSN_KEY_F3;

          ClrScr( DtaRcd.ScnMod: *Omit: *Omit: *Omit );

          rc = PutOutCmd( DtaRcd.CmdVal
                        : DtaRcd.DtaBuf
                        : DtaRcd.BufSiz
                        : *Omit
                        : *Omit
                        : ERRC0100
                        );

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          SetCsrAdr( *Omit: DtaRcd.CsrRow: DtaRcd.CsrCol: CmdBuf: *Omit: *Omit);

          If  FncKey = *On;
            ExSr  WrtFncKey;
          EndIf;

          ReadMdt( QSN_CC1_LOCKBD
                 : QSN_CC2_NO_IC
                 : FldCnt
                 : InpHnd
                 : CmdBuf
                 : *Omit
                 : ERRC0100
                 );

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          pInpDta = RtvDta( InpHnd: *Omit: *Omit );

          ExSr  RtvInpDta;

          Select;
          When  InpDta.Aid = QSN_KEY_F2;
            FncKey = FncKey = *Off;

          When  InpDta.Aid = QSN_KEY_F5;
            ExSr  GetRmtScn;
          EndSl;

          ClrBuf( CmdBuf: *Omit );
        EndDo;

        Cleanup();

        SndCompMsg( 'CPF9897': 'DSPJOBSCN command completed successfully.' );

        *InLr = *On;
        Return;


        BegSr  GetRmtScn;

          PgmDta.DtqKey = GetUUID();
          PgmDta.RpyKey = GetUUID();

          JITP0100.PgmNam = 'CBX2562';
          JITP0100.PgmLib = PgmSts.PgmLib;
          JITP0100.TgtJobNam = PxJobNam_q.JobNam;
          JITP0100.TgtJobUsr = PxJobNam_q.JobUsr;
          JITP0100.TgtJobNbr = PxJobNam_q.JobNbr;
          JITP0100.PgmDta = PgmDta;

          Monitor;
            JobItpPgm( JITP0100: 'JITP0100': ERRC0100 );
          On-Error;
            SndEscMsg( 'CPF9898': 'QCPFMSG': 'Release must be V5R4 or higher');
          EndMon;

          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;

          PutDtaQk( PgmDta.DtqNam: PgmDta.DtqLib: RqsRcd: PgmDta.DtqKey );

          DtaRcd = GetDtaQk( PgmDta.DtqNam
                           : PgmDta.DtqLib
                           : PgmDta.RpyKey
                           : PxCmdTmo
                           );

          Select;
          When  DtaRcd.RcdTyp = *Blanks;
            SndEscMsg( 'CPF9898'
                     : 'QCPFMSG'
                     : 'Request timed out'
                     );

          When  DtaRcd.RtnCod = '0';
            ExSr  LogDiagMsg;

            SndEscMsg( 'CPF9898'
                     : 'QCPFMSG'
                     : 'Error occurred while retrieving remote screen'
                     );

          When  DtaRcd.ScnMod = '4'  And  DspMode27x132 = *Off;
            SndEscMsg( 'CPF9898'
                     : 'QCPFMSG'
                     : 'Display mode 27x132 not supported by current device.'
                     );
          EndSl;

        EndSr;

        BegSr  RtvInpDta;

          For  FldIdx = 1  To  FldCnt;

            RtvFldInf( InpHnd: FldIdx: FldInf: %Size( FldInf ): *Omit: *Omit );

            FldLst(FldIdx).FldVal = %Subst( FldDta: 1: FldInf.DtaLen );
            FldLst(FldIdx).FldRow = FldInf.FldRow;
            FldLst(FldIdx).FldCol = FldInf.FldCol;
          EndFor;

        EndSr;

        BegSr  WrtFncKey;

          WrtDta( 'F3=Exit'
                : 7
                : QSN_ROW_COL
                : DtaRcd.ScnRows
                : DtaRcd.ScnCols - 19
                : QSN_SA_WHT_RI
                : QSN_SA_WHT
                : QSN_SA_RED
                : QSN_SA_WHT
                : CmdBuf
                : *Omit
                : *Omit
                );

          WrtDta( 'F5=Refresh'
                : 10
                : QSN_ROW_COL
                : DtaRcd.ScnRows
                : DtaRcd.ScnCols - 10
                : QSN_SA_WHT_RI
                : QSN_SA_WHT
                : QSN_SA_RED
                : QSN_SA_WHT
                : CmdBuf
                : *Omit
                : *Omit
                );

        EndSr;

        BegSr  LogDiagMsg;

          ERRC0100 = %Subst( DtaRcd.DtaBuf: 1: DtaRcd.BufSiz );

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndDiagMsg( ERRC0100.MsgId
                    : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                    );

        EndSr;

        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

        BegSr  *InzSr;

          SpcAutLst( 1 ) = '*JOBCTL';

          ChkSpcAut( AutFlg
                   : PgmSts.UsrPrf
                   : SpcAutLst
                   : 1
                   : ADP_PRV_INVLVL
                   : ERRC0100
                   );

          If  ERRC0100.BytAvl > *Zero  Or  AutFlg = 'N';
            SndEscMsg( 'CPFB0CE': 'QCPFMSG': '*JOBCTL' );
          EndIf;

          CEE4RAGE( %Paddr( Cleanup ): *Omit );

          If  QryModSup( QSN_MODE_27X132: *Omit: *Omit: *Omit ) = *Zero;
            DspMode27x132 = *Off;
          EndIf;

          DoU ERRC0100.BytAvl = *Zero;
            InpHnd  = CrtInpBuf( BufSiz: *Omit: *Omit: *Omit: ERRC0100 );

            If  ERRC0100.BytAvl > *Zero  And  ERRC0100.MsgId = 'CPFA312';
              CPFA312 = ERRC0100.MsgDta;
              BufSiz = CPFA312.DspBufSiz;
            Else;

              Leave;
            EndIf;
          EndDo;

          CmdBuf  = CrtCmdBuf( BufSiz: *Omit: *Omit: *Omit: *Omit );

          PgmDta.DtqLib = PgmSts.PgmLib;

          If  ChkObj( PgmDta.DtqNam_q: '*DTAQ' ) = *Off;
            CrtComDtq( PgmDta.DtqNam: PgmDta.DtqLib );
          EndIf;

        EndSr;

      /End-Free

     **-- Delete buffers:
     P Cleanup         B
     D                 Pi

      /Free

        If  CmdBuf > -1;
          DltBuf( CmdBuf: ERRC0100 );
        EndIf;

        If  InpHnd > -1;
          DltBuf( InpHnd: ERRC0100 );
        EndIf;

      /End-Free

     P Cleanup         E
     **-- Check object existence:
     P ChkObj          B
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
     **-- Create communication data queue:
     P CrtComDtq       B
     D                 Pi
     D  PxDtqNam                     10a   Const  Varying  Options( *Trim )
     D  PxDtqLib                     10a   Const  Varying  Options( *Trim )

      /Free

        RunCmd( 'CRTDTAQ DTAQ(' + PxDtqLib   + '/' +
                                  PxDtqNam   + ')' +
                       ' TYPE(*STD)'               +
                       ' MAXLEN(8192)'             +
                       ' FORCE(*NO)'               +
                       ' SEQ(*KEYED)'              +
                       ' KEYLEN(16)'               +
                       ' SENDERID(*YES) '          +
                       ' SIZE(*MAX2GB 256)'        +
                       ' AUTORCL(*YES)'            +
                       ' AUT(*CHANGE)'
              );

        Return;

      /End-Free

     P CrtComDtq       E
     **-- Run command:
     P RunCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying

     **-- Message information structure:
     D RCVM0100        Ds                  Qualified
     D  BytPrv                       10i 0
     D  BytAvl                       10i 0
     D  MsgSev                       10i 0
     D  MsgId                         7a
     D  MsgTyp                        2a
     D  MsgKey                        4a

      /Free

        Monitor;
          ExcCmd( PxCmdStr: %Len( PxCmdStr ));

        On-Error;
          Return -1;
        EndMon;

        RcvPgmMsg( RCVM0100
                 : %Size( RCVM0100 )
                 : 'RCVM0100'
                 : '*'
                 : *Zero
                 : '*LAST'
                 : *Blanks
                 : *Zero
                 : '*REMOVE'
                 : ERRC0100
                 );

        Return *Zero;

      /End-Free

     P RunCmd          E
     **-- Get universal unique identifier:
     P GetUUID         B                   Export
     D                 Pi            16a

     **-- UUID template:
     D UUID_t          Ds                  Qualified
     D  BytPrv                       10u 0 Inz( %Size( UUID_t ))
     D  BytAvl                       10u 0
     D                                8a   Inz( *Allx'00' )
     D  UUID                         16a

      /Free

        GenUuid( %Addr( UUID_t ));

        Return  UUID_t.UUID;

      /End-Free

     P GetUUID         E
     **-- Put to data queue - keyed:
     P PutDtaQk        B                   Export
     D                 Pi
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )

      /Free

        SndDtaQe( PxDtqNam
                : PxDtqLib
                : %Len( PxDtqEnt )
                : PxDtqEnt
                : %Len( PxDtqKey )
                : PxDtqKey
                );

        Return;

      /End-Free

     P PutDtaQk        E
     **-- Get from data queue - keyed:
     P GetDtaQk        B                   Export
     D                 Pi         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const

     D DtaLen          s              5p 0
     D DtaRcv          s          65535a
     D SndInfo         s             36a

      /Free

        RcvDtaQe( PxDtqNam
                : PxDtqLib
                : DtaLen
                : DtaRcv
                : PxDtqWait
                : 'EQ'
                : %Len( PxDtqKey )
                : PxDtqKey
                : *Zero
                : SndInfo
                : '*YES'
                : %Size( DtaRcv )
                : ERRC0100
                );

        Return  %Subst( DtaRcv: 1: DtaLen );

      /End-Free

     P GetDtaQk        E
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
     **-- Send completion message:
     P SndCompMsg      B                   Export
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                   3000a   Const  Varying  Options( *Omit )
     **
     D MsgKey          s              4a
     D MsgDta          s           3000a   Varying

      /Free

        If  %Addr( PxMsgDta ) = *Null;
          MsgDta = NULL;
        Else;
          MsgDta = PxMsgDta;
        EndIf;

        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
                 : MsgDta
                 : %Len( MsgDta )
                 : '*COMP'
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

     P SndCompMsg      E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
                 : PxMsgF + '*LIBL'
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
