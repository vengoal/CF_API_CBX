     **
     **  Program . . : CBX213X1
     **  Description : Change compile commands to include debug information.
     **  Author  . . : Carsten Flensburg
     **
     **
     **
     **  IBM documentation:
     **    http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/apis/xcachg.htm
     **
     **  Prerequisite:
     **    Register the commands that should be checked and, if required,
     **    changed:
     **
     **    AddExitPgm  ExitPnt( QIBM_QCA_CHG_COMMAND )
     **                Format( CHGC0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX213X1 )
     **                PgmDta( *JOB 20 'CRTRPGPGM QSYS      ' )
     **
     **    AddExitPgm  ExitPnt( QIBM_QCA_CHG_COMMAND )
     **                Format( CHGC0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX213X1 )
     **                PgmDta( *JOB 20 'CRTCLPGM  QSYS      ' )
     **
     **    AddExitPgm  ExitPnt( QIBM_QCA_CHG_COMMAND )
     **                Format( CHGC0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX213X1 )
     **                PgmDta( *JOB 20 'CRTRPGMOD QSYS      ' )
     **
     **    AddExitPgm  ExitPnt( QIBM_QCA_CHG_COMMAND )
     **                Format( CHGC0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX213X1 )
     **                PgmDta( *JOB 20 'CRTBNDRPG QSYS      ' )
     **
     **    AddExitPgm  ExitPnt( QIBM_QCA_CHG_COMMAND )
     **                Format( CHGC0100 )
     **                PgmNbr( *LOW )
     **                Pgm( QGPL/CBX213X1 )
     **                PgmDta( *JOB 20 'CRTCLMOD  QSYS      ' )
     **
     **
     **  Programmer's notes:
     **    The Work with Registration Info (WRKREGINF) command can be used
     **    to verify and change or remove the registration:
     **
     **    WrkRegInf   ExitPnt( QIBM_QCA_CHG_COMMAND ), select option 8.
     **
     **
     **  Compile options:
     **    CrtRPgmod   Module( CBX213X1 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX213X1 )
     **                Module( CBX213X1 )
     **                ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0 Inz
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
     **-- Call stack entry id:
     D ToCalStkE       Ds                  Qualified
     D  ToCalStkCnt                  10i 0 Inz( 1 )
     D  ToCalStkEq                   20a   Inz( '*NONE     *NONE' )
     D  ToCalStkIdLen                10i 0 Inz( %Size( ToCalStkE.ToCalStkId ))
     D  ToCalStkId                   10a   Inz( '*PGMBDY' )

     **-- Global variables:
     D CmdStr          s          32000a   Varying
     D KwdStr          s          10240a   Varying

     **-- Change command exit information:
     D CmdExitInf      Ds         32060    Qualified
     D  ExitName                     20a
     D  ExitFmt                       8a
     D  CmdNam                       10a
     D  CmdLib                       10a
     D  AlwChg                         n
     D  PmtInd                         n
     D                                2a
     D  CmdStrOfs                    10i 0
     D  CmdStrLen                    10i 0
      /If Defined( *V5R4 )
     D  PxyChnOfs                    10i 0
     D  NbrPxyChnE                   10i 0
      /EndIf

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
     **-- Resend escape messages:
     D RsnEscMsg       Pr                  ExtPgm( 'QMHRSNEM' )
     D  MsgKey                        4a   Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkEnt                5120a   Const  Options( *VarSize )
     D  ToCalStkEntLn                10i 0 Const
     D  ToCalStkFmt                   8a   Const
     D  FrCalStkAdr                  16a   Const
     D  FrCalStkCnt                  10i 0 Const

     **-- Strip keyword values:
     D StpKwdVal       Pr         32000a   Varying
     D  PxCmdStr                  32000a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying
     **-- Extract keyword values:
     D ExtKwdVal       Pr         10240a   Varying
     D  PxCmdStr                  10240a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying
     **-- Insert keyword value:
     D InsKwdVal       Pr         10240a   Varying
     D  PxKwdStr                  10240a   Const  Varying
     D  PxKwdVal                     32a   Const  Varying
     D  PxRplVal                     32a   Const  Varying  Options( *NoPass )

     **-- Command analyzer change exit point parameter group:
     D CBX213X1        Pr
     D  PxCmdExitInf                       LikeDs( CmdExitInf )
     D  PxRplCmd                  32000a
     D  PxRplCmdLen                  10i 0

     D CBX213X1        Pi
     D  PxCmdExitInf                       LikeDs( CmdExitInf )
     D  PxRplCmd                  32000a
     D  PxRplCmdLen                  10i 0

      /Free

        If  PxCmdExitInf.ExitName = 'QIBM_QCA_CHG_COMMAND'  And
            PxCmdExitInf.ExitFmt  = 'CHGC0100';

          PxRplCmd = *Blanks;
          PxRplCmdLen = *Zero;

          If  PxCmdExitInf.AlwChg = *On;

            CmdStr = %SubSt( PxCmdExitInf
                           : PxCmdExitInf.CmdStrOfs + 1
                           : PxCmdExitInf.CmdStrLen
                           );

            If  PxCmdExitInf.PmtInd = *On  And  %SubSt( CmdStr: 1: 1 ) <> '?';
               CmdStr = '?' + CmdStr;
            EndIf;

            Select;
            When  PxCmdExitInf.CmdNam = 'CRTRPGPGM'  Or
                  PxCmdExitInf.CmdNam = 'CRTCLPGM';

              ExSr  AddDbgOpt;

            When  PxCmdExitInf.CmdNam = 'CRTRPGMOD'  Or
                  PxCmdExitInf.CmdNam = 'CRTBNDRPG'  Or
                  PxCmdExitInf.CmdNam = 'CRTCLMOD';

              ExSr  AddDbgView;
            EndSl;
          EndIf;
        EndIf;

        *InLr = *On;
        Return;

        BegSr  AddDbgOpt;

          If  %Scan( 'OPTION(': CmdStr ) = *Zero;
            CmdStr += ' OPTION(*SRCDBG)';
          Else;

            KwdStr = ExtKwdVal( CmdStr: 'OPTION' );
            CmdStr = StpKwdVal( CmdStr: 'OPTION' );
            KwdStr = InsKwdVal( KwdStr: '*SRCDBG': '*NOSRCDBG' );
            CmdStr += ' ' + KwdStr;
          EndIf;

            PxRplCmd = CmdStr;
            PxRplCmdLen = %Len( CmdStr );

        EndSr;

        BegSr  AddDbgView;

          Select;
          When  %Scan( 'DBGVIEW(': CmdStr ) = *Zero;
            CmdStr += ' DBGVIEW(*LIST)';

            PxRplCmd = CmdStr;
            PxRplCmdLen = %Len( CmdStr );

          When  ExtKwdVal( CmdStr: 'DBGVIEW' ) <> 'DBGVIEW(*LIST)';
            CmdStr = StpKwdVal( CmdStr: 'DBGVIEW' );
            CmdStr += ' DBGVIEW(*LIST)';

            PxRplCmd = CmdStr;
            PxRplCmdLen = %Len( CmdStr );
          EndSl;

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

            RsnEscMsg( *Blanks
                     : ERRC0100
                     : ToCalStkE
                     : %Size( ToCalStkE )
                     : 'RSNM0100'
                     : '*'
                     : *Zero
                     );

            Return;
          EndIf;

        EndSr  '*CANCL';

      /End-Free

     **-- Strip keyword values:
     P StpKwdVal       B
     D                 Pi         32000a   Varying
     D  PxCmdStr                  32000a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying

     D Null            c                   ''
     D KwdBeg          s             10i 0
     D KwdEnd          s             10i 0
     D ScnArg          s              2a   Varying

      /Free

        KwdBeg = %Scan( PxCmdKwd: PxCmdStr );

        If  KwdBeg > *Zero;

          If  %Subst( PxCmdStr: KwdBeg + %Len( PxCmdKwd ): 2 ) = '((';
            ScnArg = '))';
          Else;
            ScnArg = ')';
          EndIf;

          KwdEnd = %Scan( ScnArg: PxCmdStr: KwdBeg ) + %Len( ScnArg );

          Select;
          When  KwdEnd > *Zero  And  KwdEnd <= %Len( PxCmdStr );
            Return  %Subst( PxCmdStr: 1: KwdBeg - 1 ) +
                    %Subst( PxCmdStr: KwdEnd );

          When  KwdEnd > *Zero;
            Return  %Subst( PxCmdStr: 1: KwdBeg - 1 );

          EndSl;
        EndIf;

        Return  Null;

      /End-Free

     P StpKwdVal       E
     **-- Extract keyword values:
     P ExtKwdVal       B
     D                 Pi         10240a   Varying
     D  PxCmdStr                  10240a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying

     D Null            c                   ''
     D KwdBeg          s             10i 0
     D KwdEnd          s             10i 0
     D ScnArg          s              2a   Varying

      /Free

        KwdBeg = %Scan( PxCmdKwd: PxCmdStr );

        If  KwdBeg > *Zero;

          If  %Subst( PxCmdStr: KwdBeg + %Len( PxCmdKwd ): 2 ) = '((';
            ScnArg = '))';
          Else;
            ScnArg = ')';
          EndIf;

          KwdEnd = %Scan( ScnArg: PxCmdStr: KwdBeg ) + %Len( ScnArg );

          If  KwdEnd > *Zero;
            Return  %Subst( PxCmdStr: KwdBeg: KwdEnd - KwdBeg );
          EndIf;
        EndIf;

        Return  Null;

      /End-Free

     P ExtKwdVal       E
     **-- Insert keyword value:
     P InsKwdVal       B
     D                 Pi         10240a   Varying
     D  PxKwdStr                  10240a   Const  Varying
     D  PxKwdVal                     32a   Const  Varying
     D  PxRplVal                     32a   Const  Varying  Options( *NoPass )

     D Null            c                   ''
     D KwdStr          s          10240a   Varying
     D KwdVal          s             34a   Varying
     D RplVal          s             34a   Varying
     D ValBeg          s             10i 0
     D RplPos          s             10i 0 Inz

      /Free

        ValBeg = %Scan( '(': PxKwdStr );

        If  ValBeg = *Zero  Or  %Scan( PxKwdVal: PxKwdStr: ValBeg ) > *Zero;
          KwdStr = PxKwdStr;
        Else;

          If  %Parms = 3;

            If  %Subst( PxKwdStr: ValBeg: 2 ) = '((';
              RplVal = '(' + PxRplVal + ')';
            Else;
              RplVal = PxRplVal;
            EndIf;

            RplPos = %Scan( RplVal: PxKwdStr );
          EndIf;

          If  %Subst( PxKwdStr: ValBeg: 2 ) = '((';
            KwdVal = '(' + PxKwdVal + ')';
          Else;
            KwdVal = PxKwdVal;
          EndIf;

          If  RplPos > *Zero;
            KwdStr = %Replace( KwdVal: PxKwdStr: RplPos: %Len( RplVal ));
          Else;
            KwdVal += ' ';
            KwdStr = %Replace( KwdVal: PxKwdStr: ValBeg + 1: 0 );
          EndIf;

        EndIf;

        Return  KwdStr;

      /End-Free

     P InsKwdVal       E
