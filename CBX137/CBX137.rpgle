     **
     **  Program . . : CBX137
     **  Description : Retrieve disk attributes - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : June 16, 2005
     **
     **
     **  Program summary
     **  ---------------
     **
     **  General Configuration APIs:
     **    QYASPOL       Open list of ASPs     Generates a list of ASPs or
     **                                        information about an ASP,
     **                                        including identification of all
     **                                        ASPs configured to a system,
     **                                        attributes of an ASP, unassigned
     **                                        disk units or disk units assigned
     **                                        to an ASP.
     **
     **  Open list APIs:
     **    QGYCTLE       Get list entries      To retrieve open lists entries
     **                                        from an already open list the
     **                                        QGYGTLE (Get List Entries) API
     **                                        is available.
     **
     **    QGYCLST       Close list            This API closes the previously
     **                                        opened list identified by the
     **                                        request handle parameter.
     **                                        Storage allocated is freed.
     **
     **
     **  Message handling API:
     **    QMHSNDPM      Send program message  Sends a message to a program stack
     **                                        entry (current, previous, etc.) or
     **                                        an external message queue.
     **
     **                                        Both messages defined in a message
     **                                        file and immediate messages can be
     **                                        used. For specific message types
     **                                        only one or the other is allowed.
     **
     **
     **  Activation Group and Control Flow APIs:
     **    CEETREC       Normal end            Performs a normal ending of the
     **                                        activation group containing the
     **                                        nearest control boundary.
     **
     **                                        If the call stack entry for the
     **                                        control boundary is also the
     **                                        oldest call stack entry in the
     **                                        activation group, the activation
     **                                        group ends, provided that call
     **                                        stack entries were ended.
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Programmer's notes:
     **    Prior to V5R3 all Open List APIs are found in the QGY library.
     **    To run this program at V5R2 and earlier, library QGY needs to be
     **    in the job's library list.
     **
     **    Open List APIs are located in option 12 - 'Host Servers' - of the
     **    operation system, and this option needs to be installed for these
     **    APIs to be available.  Running the command DSPSFWRSC enables you
     **    to verify the presence of this option.
     **
     **
     **  Compile options:
     **
     **    CrtRpgMod Module( CBX137 )  DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX137 )
     **              Module( CBX137 )
     **              ActGrp( CBX137 )
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
     D  MsgDta                      128a
     **-- API parameters:
     D GetRcdNbr       s             10i 0 Inz( 0 )
     **-- ASP information:
     D YASP0300        Ds                  Qualified  Inz
     D  AspNbr                       10i 0
     D  DskTyp                        4a
     D  DskMod                        4a
     D  DskSrlNbr                    10a
     D  RscNam                       10a
     D  DskUnitNbr                   10i 0 Inz( -1 )
     D  DskCap                       10i 0
     D  DskStgAvl                    10i 0
     D  DskStgSys                    10i 0
     D  MirUnitPtc                    1a
     D  MirUnitRpt                    1a
     D  MirUnitSts                    1a
     D                                1a
     D  UnitCtl                      10i 0
     D  BlkTfrToMs                   10i 0
     D  BlkTfrFrMs                   10i 0
     D  RqsTfrToMs                   10i 0
     D  RqsTfrFrMs                   10i 0
     D  PmbTfrFrMs                   10i 0
     D  RqsPdtFrMs                   10i 0
     D  SamCnt                       10i 0
     D  NotBusyCnt                   10i 0
     D  CmpSts                        1a
     D  DskPtcTyp                     1a
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 0 )
     D  SrtInf                       12a   Dim( 10 )
     D   KeyFldOfs                   10i 0 Overlay( SrtInf :  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtInf :  5 )
     D   KeyFldTyp                    5i 0 Overlay( SrtInf :  9 )
     D   SrtOrd                       1a   Overlay( SrtInf : 11 )
     D   Rsv                          1a   Overlay( SrtInf : 12 )
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  Handle                        4a
     D  RcdLen                       10i 0
     D  InfSts                        1a
     D  Dts                          13a
     D  LstSts                        1a
     D                                1a
     D  InfLen                       10i 0
     D  Rcd1                         10i 0
     D                               40a
     **-- Filter information:
     D FtrInf          Ds
     D  SizFtrEnt                    10i 0 Inz( %Size( FtrInf ))
     D  FtrKey                       10i 0 Inz( 1 )
     D  SizFtrDta                    10i 0 Inz( %Size( FtrDta ))
     D  FtrDta                       10i 0 Inz( -1 )
     **-- Global variables:
     D MsgKey          s              4a
     D MsgTxt          s            512a   Varying
     D CmdStr          s            512a   Varying
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     **
     D BINARY_S        c                   0
     D ASCEND          c                   '1'
     **-- Open list of ASPs:
     D LstAsps         Pr                  ExtPgm( 'QYASPOL' )
     D  LaRcvVar                  65535a          Options( *VarSize )
     D  LaRcvVarLen                  10i 0 Const
     D  LaLstInf                     80a
     D  LaNbrRcdRtn                  10i 0 Const
     D  LaNbrFlt                     10i 0 Const
     D  LaFltInf                     32a   Const  Options( *VarSize )
     D  LaFmtNam                      8a   Const
     D  LaError                    1024a          Options( *VarSize )
     D  LaSrtInf                   1024a   Const  Options( *VarSize: *NoPass )
     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QGYGTLE' )
     D  GlRcvVar                  65535a          Options( *VarSize )
     D  GlRcvVarLen                  10i 0 Const
     D  GlHandle                      4a   Const
     D  GlLstInf                     80a
     D  GlNbrRcdRtn                  10i 0 Const
     D  GlRtnRcdNbr                  10i 0 Const
     D  GlError                    1024a          Options( *VarSize )
     **-- Close list:
     D CloseLst        Pr                  ExtPgm( 'QGYCLST' )
     D  ClHandle                      4a   Const
     D  ClError                    1024a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  SpMsgId                       7a   Const
     D  SpMsgFq                      20a   Const
     D  SpMsgDta                    128a   Const
     D  SpMsgDtaLen                  10i 0 Const
     D  SpMsgTyp                     10a   Const
     D  SpCalStkE                    10a   Const  Options( *VarSize )
     D  SpCalStkCtr                  10i 0 Const
     D  SpMsgKey                      4a
     D  SpError                    1024a          Options( *VarSize )
     **-- Normal end:
     D Exit            Pr                  ExtProc( 'CEETREC' )
     D  cel_rc_mod                   10i 0 Const  Options( *NoPass )
     D  user_rc                      10i 0 Const  Options( *NoPass )

     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     D CBX137          Pr
     D  PxDskOpt                     10a
     D  PxDskUnitNbr                 10p 0
     D  PxAspNbr                      3p 0
     D  PxDskTyp                      4a
     D  PxDskMod                      4a
     D  PxDskSrlNbr                  10a
     D  PxRscNam                     10a
     D  PxDskCap                     10p 0
     D  PxDskStgAvl                  10p 0
     D  PxDskStgSys                  10p 0
     D  PxMirUnitPtc                  1a
     D  PxMirUnitRpt                  1a
     D  PxMirUnitSts                  1a
     D  PxUnitCtl                     2p 0
     D  PxBlkTfrToMs                 10p 0
     D  PxBlkTfrFrMs                 10p 0
     D  PxRqsTfrToMs                 10p 0
     D  PxRqsTfrFrMs                 10i 0
     D  PxPmbTfrFrMs                 10i 0
     D  PxRqsPdtFrMs                 10i 0
     D  PxSamCnt                     10i 0
     D  PxNotBusyCnt                 10i 0
     D  PxCmpSts                      1a
     D  PxDskPtcTyp                   1a
     **
     D CBX137          Pi
     D  PxDskOpt                     10a
     D  PxDskUnitNbr                 10p 0
     D  PxAspNbr                      3p 0
     D  PxDskTyp                      4a
     D  PxDskMod                      4a
     D  PxDskSrlNbr                  10a
     D  PxRscNam                     10a
     D  PxDskCap                     10p 0
     D  PxDskStgAvl                  10p 0
     D  PxDskStgSys                  10p 0
     D  PxMirUnitPtc                  1a
     D  PxMirUnitRpt                  1a
     D  PxMirUnitSts                  1a
     D  PxUnitCtl                     2p 0
     D  PxBlkTfrToMs                 10p 0
     D  PxBlkTfrFrMs                 10p 0
     D  PxRqsTfrToMs                 10p 0
     D  PxRqsTfrFrMs                 10i 0
     D  PxPmbTfrFrMs                 10i 0
     D  PxRqsPdtFrMs                 10i 0
     D  PxSamCnt                     10i 0
     D  PxNotBusyCnt                 10i 0
     D  PxCmpSts                      1a
     D  PxDskPtcTyp                   1a

      /Free

        If  PxDskOpt = '*FIRST';

          SrtInf.NbrKeys      = 1;
          SrtInf.KeyFldOfs(1) = 33;
          SrtInf.KeyFldLen(1) = 4;
          SrtInf.KeyFldTyp(1) = BINARY_S;
          SrtInf.SrtOrd(1)    = ASCEND;
          SrtInf.Rsv(1)       = x'00';

          GetRcdNbr += 1;

          LstAsps( YASP0300
                 : %Size( YASP0300 )
                 : LstInf
                 : GetRcdNbr
                 : 1
                 : FtrInf
                 : 'YASP0300'
                 : ERRC0100
                 : SrtInf
                 );

          ExSr  ChkApiRtn;

        Else;

          If  LstInf.LstSts = '2'  And  LstInf.RcdNbrTot <= GetRcdNbr;
            Reset  YASP0300;

          ElseIf  GetRcdNbr = *Zero;
            Reset  YASP0300;

          Else;
            GetRcdNbr += 1;

            GetLstEnt( YASP0300
                     : %Size( YASP0300 )
                     : LstInf.Handle
                     : LstInf
                     : 1
                     : GetRcdNbr
                     : ERRC0100
                     );

            ExSr  ChkApiRtn;
          EndIf;
        EndIf;

        ExSr  SetRtnPrm;

        If  PxDskUnitNbr = -1;
          CloseLst( LstInf.Handle: ERRC0100 );

          Exit();
        EndIf;

        Return;


        BegSr ChkApiRtn;

          If  ERRC0100.BytAvl > *Zero;

            If  ERRC0100.BytAvl < OFS_MSGDTA;
              ERRC0100.BytAvl = OFS_MSGDTA;
            EndIf;

            SndEscMsg( ERRC0100.MsgId
                     : 'QCPFMSG'
                     : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl-OFS_MSGDTA )
                     );
          EndIf;

          If  LstInf.RcdNbrRtn = *Zero;
            Reset  YASP0300;
          EndIf;

        EndSr;

        BegSr SetRtnPrm;

          If  %Addr( PxDskUnitNbr ) <> *Null;
            PxDskUnitNbr = YASP0300.DskUnitNbr;
          EndIf;

          If  %Addr( PxAspNbr ) <> *Null;
            PxAspNbr = YASP0300.AspNbr;
          EndIf;

          If  %Addr( PxDskTyp ) <> *Null;
            PxDskTyp = YASP0300.DskTyp;
          EndIf;

          If  %Addr( PxDskMod ) <> *Null;
            PxDskMod = YASP0300.DskMod;
          EndIf;

          If  %Addr( PxDskSrlNbr ) <> *Null;
            PxDskSrlNbr = YASP0300.DskSrlNbr;
          EndIf;

          If  %Addr( PxRscNam ) <> *Null;
            PxRscNam = YASP0300.RscNam;
          EndIf;

          If  %Addr( PxDskCap ) <> *Null;
            PxDskCap = YASP0300.DskCap;
          EndIf;

          If  %Addr( PxDskStgAvl ) <> *Null;
            PxDskStgAvl = YASP0300.DskStgAvl;
          EndIf;

          If  %Addr( PxDskStgSys ) <> *Null;
            PxDskStgSys = YASP0300.DskStgSys;
          EndIf;

          If  %Addr( PxMirUnitPtc ) <> *Null;
            PxMirUnitPtc = YASP0300.MirUnitPtc;
          EndIf;

          If  %Addr( PxMirUnitRpt ) <> *Null;
            PxMirUnitRpt = YASP0300.MirUnitPtc;
          EndIf;

          If  %Addr( PxMirUnitSts ) <> *Null;
            PxMirUnitSts = YASP0300.MirUnitSts;
          EndIf;

          If  %Addr( PxUnitCtl ) <> *Null;
            PxUnitCtl = YASP0300.UnitCtl;
          EndIf;

          If  %Addr( PxBlkTfrToMs ) <> *Null;
            PxBlkTfrToMs = YASP0300.BlkTfrToMs;
          EndIf;

          If  %Addr( PxBlkTfrFrMs ) <> *Null;
            PxBlkTfrFrMs = YASP0300.BlkTfrFrMs;
          EndIf;

          If  %Addr( PxRqsTfrToMs ) <> *Null;
            PxRqsTfrToMs = YASP0300.RqsTfrToMs;
          EndIf;

          If  %Addr( PxRqsTfrFrMs ) <> *Null;
            PxRqsTfrFrMs = YASP0300.RqsTfrFrMs;
          EndIf;

          If  %Addr( PxPmbTfrFrMs ) <> *Null;
            PxPmbTfrFrMs = YASP0300.PmbTfrFrMs;
          EndIf;

          If  %Addr( PxRqsPdtFrMs ) <> *Null;
            PxRqsPdtFrMs = YASP0300.RqsPdtFrMs;
          EndIf;

          If  %Addr( PxSamCnt ) <> *Null;
            PxSamCnt = YASP0300.SamCnt;
          EndIf;

          If  %Addr( PxNotBusyCnt ) <> *Null;
            PxNotBusyCnt = YASP0300.NotBusyCnt;
          EndIf;

          If  %Addr( PxCmpSts ) <> *Null;
            PxCmpSts = YASP0300.CmpSts;
          EndIf;

          If  %Addr( PxDskPtcTyp ) <> *Null;
            PxDskPtcTyp = YASP0300.DskPtcTyp;
          EndIf;

        EndSr;

      /End-Free

     **-- Send escape message:  ----------------------------------------------**
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
