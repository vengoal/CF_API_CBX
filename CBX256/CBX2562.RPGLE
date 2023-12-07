     **
     **  Program . . :  CBX2562
     **  Description :  Display Job Screen - Exit Program
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer, 2012.
     **
     **
     **  Program description:
     **    This program will retrieve the current screen and pass back the
     **    retrieved screen buffer through a data queue to the requesting
     **    job.
     **
     **
     **  Prerequisite:
     **    This program must be registered with the QIBM_QWC_JOBITPPGM exit
     **    point, in order for the Call Job Interrupt Program (QWCJBITP) API
     **    to be enabled to specify this program as the job interrupt exit
     **    program:
     **
     **      AddExitPgm  ExitPnt( QIBM_QWC_JOBITPPGM )
     **                  Format( JITP0100 )
     **                  PgmNbr( *LOW )
     **                  Pgm( <library>/CBX2562 )
     **                  Text( 'Job interrupt exit program' )
     **
     **    The Job Interrupt Exit Program is documented here:
     **      http://publib.boulder.ibm.com/infocenter/iseries/v7r1m0/topic/apis/
     **        xwcjbitp.htm
     **
     **    To allow the registered exit program to interrupt a specified
     **    job, the system value QALWJOBITP must be set appropriately,
     **    which must be one of the following two values:
     **
     **      1. ChgSysVal   SysVal( QALWJOBITP )
     **                     Value( '1' )
     **
     **      Running the above command will cause the system to allow
     **      jobs to be interrupted to run user-defined exit programs.
     **
     **      All new jobs becoming active will default to be uninterruptible
     **      and must have their interrupt status explicitly changed before
     **      job interruption will be allowed.
     **
     **      2. ChgSysVal   SysVal( QALWJOBITP )
     **                     Value( '2' )
     **
     **      Running the above command will cause the system to allow
     **      jobs to be interrupted to run user-defined exit programs.
     **
     **      All new jobs becoming active will default to be interruptible
     **      and will implicitly allow job interruption to take place,
     **      without any further action being required.
     **
     **    Leaving the QALWJOBITP system value at it's default value '0'
     **    will cause the system to disallow all attempts to run any
     **    registered job interrupt exit programs.
     **
     **    The QALWJOBITP system value is documented here:
     **      http://publib.boulder.ibm.com/infocenter/iseries/v7r1m0/topic/rzakz/
     **        rzakzqalwjobitp.htm
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX2562 )
     **               DbgView( *NONE )
     **
     **    CrtPgm     Pgm( CBX2562 )
     **               Module( CBX2562 )
     **               ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                     1024a
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
     D  JobId2                       16a   Overlay( PgmSts: 254 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )

     **-- Global constants:
     D TMO_SEC_25      c                   25
     D NULL            c                   ''
     **
     D QSN_SAV_SCREEN  c                   x'02'
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
     **-- Global variables:
     D Mode            s              1a
     D ScnRows         s             10i 0
     D ScnCols         s             10i 0
     D CsrRow          s             10i 0
     D CsrCol          s             10i 0
     D BufSiz          s             10i 0 Inz( 8192 )
     **
     D InpHnd          s             10i 0
     D CmdBuf          s             10i 0
     D BytRead         s             10i 0
     D rc              s             10i 0
     **
     D pInpDta         s               *   Inz( *Null )
     **
     D InpDta          Ds                  Qualified   Based( pInpDta )
     D  InpEsc                        1a
     D  InpCmd                        1a
     D  Data                       6300a
     **
     D CPFA312         Ds                  Qualified
     D  BufSiz                       10i 0
     D  IncVal                       10i 0
     D  MaxSiz                       10i 0
     D  DspBufSiz                    10i 0

     **-- Exit program data:
     D PgmDta          Ds                  Qualified
     D  DtqNam_q                     20a
     D   DtqNam                      10a   Overlay( DtqNam_q:  1 )
     D   DtqLib                      10a   Overlay( DtqNam_q: 11 )
     D  DtqKey                       16a
     D  RpyKey                       16a
     **-- Message formats:
     D RqsRcd          Ds                  Qualified
     D  RcdTyp                        6a
     D                              250a
     **
     D DtaRcd          Ds                  Qualified
     D  RcdTyp                        6a   Inz( 'SAVSCR' )
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

     **-- Get cursor address (no wait):
     D GetCsrAdr       Pr            10I 0 ExtProc( 'QsnGetCsrAdr' )
     D  CsrRow                       10I 0 Options( *Omit )
     D  CsrCol                       10I 0 Options( *Omit )
     D  EnvHnd                       10I 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Retrieve screen dimensions:
     D RtvScrDim       Pr            10i 0 ExtProc( 'QsnRtvScrDim' )
     D  Rows                         10i 0
     D  Cols                         10i 0
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Retrieve display mode:
     D RtvMod          Pr             1a   ExtProc( *CNOWIDEN: 'QsnRtvMod' )
     D  Mode                          1a   Options( *Omit )
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Create input buffer:
     D CrtInpBuf       Pr            10i 0 ExtProc( 'QsnCrtInpBuf' )
     D  InitSize                     10i 0 Const
     D  IncrAmt                      10i 0 Options( *Omit )  Const
     D  MaxSize                      10i 0 Options( *Omit )  Const
     D  InpBuf                       10i 0 Options( *Omit )
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Delete buffer:
     D DltBuf          Pr            10i 0 ExtProc( 'QsnDltBuf' )
     D  BufHnd                       10i 0 Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Put input command:
     D PutInpCmd       Pr            10i 0 ExtProc( 'QsnPutInpCmd' )
     D  InpCmd                        1a   Const
     D  CmdDta                    32767a   Options( *Omit: *VarSize )  Const
     D  CmdDtaLen                    10i 0 Options( *Omit )  Const
     D  NbrByt                       10i 0 Options( *Omit )
     D  InpBuf                       10i 0 Options( *Omit )  Const
     D  CmdBuf                       10i 0 Options( *Omit )  Const
     D  EnvHnd                       10i 0 Options( *Omit )  Const
     D  Error                              Options( *Omit )  Like( ERRC0100 )
     **-- Retrieve pointer to data in input buffer:
     D RtvDta          Pr              *   ExtProc( 'QsnRtvDta' )
     D  InpBuf                       10i 0 Const
     D  InpDtaPtr                      *   Options( *Omit )
     D  Error                              Options( *Omit )  Like( ERRC0100 )

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

     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const
     **-- Put to data queue - keyed:
     D PutDtaQk        Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )

     **-- Entry parameters:
     D CBX2562         Pr
     D  PxPgmDta                           LikeDs( PgmDta )
     D  PxPgmDtaLen                   5i 0
     **
     D CBX2562         Pi
     D  PxPgmDta                           LikeDs( PgmDta )
     D  PxPgmDtaLen                   5i 0

      /Free

        RqsRcd = GetDtaQk( PxPgmDta.DtqNam
                         : PxPgmDta.DtqLib
                         : PxPgmDta.DtqKey
                         : TMO_SEC_25
                         );

        If  RqsRcd.RcdTyp = 'GETSCR';

          ExSr  SetUp;

          DtaRcd.RtnCod  = '1';
          DtaRcd.ScnMod = RtvMod( *Omit: *Omit: *Omit );

          DtaRcd.CsrRow = CsrRow;
          DtaRcd.CsrCol = CsrCol;
          DtaRcd.ScnRows = ScnRows;
          DtaRcd.ScnCols = ScnCols;

          BytRead = PutInpCmd( QSN_SAV_SCREEN
                             : *Omit
                             : *Omit
                             : *Omit
                             : InpHnd
                             : *Omit
                             : *Omit
                             : ERRC0100
                             );

          If  ERRC0100.BytAvl > *Zero;
            DtaRcd.RtnCod  = '0';
            DtaRcd.BufSiz = ERRC0100.BytAvl;
            DtaRcd.DtaBuf = ERRC0100;

          Else;
            pInpDta = RtvDta( InpHnd: *Omit: *Omit );

            DtaRcd.CmdEsc = InpDta.InpEsc;
            DtaRcd.CmdVal = InpDta.InpCmd;

            DtaRcd.BufSiz = BytRead - 2;
            DtaRcd.DtaBuf = %Subst( InpDta.Data: 1: DtaRcd.BufSiz );
          EndIf;

          DltBuf( InpHnd: *Omit );

          PutDtaQk( PxPgmDta.DtqNam
                  : PxPgmDta.DtqLib
                  : DtaRcd
                  : PxPgmDta.RpyKey
                  );
        EndIf;

        *InLr = *On;
        Return;

        BegSr  SetUp;

          RtvScrDim( ScnRows: ScnCols: *Omit: *Omit );
          GetCsrAdr( CsrRow: CsrCol: *Omit: *Omit );

          DoU ERRC0100.BytAvl = *Zero;
            InpHnd  = CrtInpBuf( BufSiz: *Omit: *Omit: *Omit: ERRC0100 );

            If  ERRC0100.BytAvl > *Zero  And  ERRC0100.MsgId = 'CPFA312';
              CPFA312 = ERRC0100.MsgDta;

              BufSiz = CPFA312.DspBufSiz;
            Else;

              Leave;
            EndIf;
          EndDo;

        EndSr;

        BegSr  *PsSr;

          If  Not *InLr;
            *InLr = *On;

            Return;
          EndIf;

        EndSr  '*CANCL';

      /End-Free

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
