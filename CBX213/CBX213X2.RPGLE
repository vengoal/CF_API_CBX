     **
     **  Program . . : CBX213X2
     **  Description : Change SIGNOFF command to always specify LOG(*LIST).
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
     **                Pgm( QGPL/CBX213X2 )
     **                PgmDta( *JOB 20 'SIGNOFF   QSYS      ' )
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
     **    CrtRpgmod   Module( CBX213X2 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX213X2 )
     **                Module( CBX213X2 )
     **                ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  JobNam                       26a   Overlay( PgmSts: 244 )
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )

     **-- Global variables:
     D CmdStr          s          32000a   Varying
     D KwdStr          s            512a   Varying

     **-- Change command exit information:
     D CHGC0100        Ds         32060    Qualified
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
     **-- Set prompt control:
     D SetPmtCtl       Pr         10240a   Varying
     D  PxKdwStr                  10240a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying
     D  PxPmtCtl                      2a   Const  Varying

     **-- Entry parameters:
     D CBX213X2        Pr
     D  PxCmdExitInf                       LikeDs( CHGC0100 )
     D  PxRplCmd                  32000a
     D  PxRplCmdLen                  10i 0
     **
     D CBX213X2        Pi
     D  PxCmdExitInf                       LikeDs( CHGC0100 )
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

            If  %Scan( 'LOG(': CmdStr ) = *Zero;
              CmdStr += ' ?*LOG(*LIST)';
            Else;

              KwdStr = ExtKwdVal( CmdStr: 'LOG' );
              CmdStr = StpKwdVal( CmdStr: 'LOG' );
              KwdStr = InsKwdVal( KwdStr: '*LIST': '*NOLIST' );

              If  PxCmdExitInf.PmtInd = *On;
                KwdStr = SetPmtCtl( KwdStr: 'LOG': '?*' );
              EndIf;

              CmdStr += ' ' + KwdStr;
            EndIf;

            PxRplCmd = CmdStr;
            PxRplCmdLen = %Len( CmdStr );
          EndIf;
        EndIf;

        *InLr = *On;
        Return;

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

          If  KwdBeg > 2  And  %Subst( PxCmdStr: KwdBeg - 2: 1 ) = '?';
            KwdBeg -= 2;
          EndIf;

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
     **-- Set prompt control:
     P SetPmtCtl       B
     D                 Pi         10240a   Varying
     D  PxKwdStr                  10240a   Const  Varying
     D  PxCmdKwd                     10a   Const  Varying
     D  PxPmtCtl                      2a   Const  Varying

     D Null            c                   ''
     D KwdStr          s          10240a   Varying
     D KwdPos          s             10i 0

      /Free

        KwdPos = %Scan( PxCmdKwd: PxKwdStr );

        If  KwdPos > *Zero;

          If  KwdPos > 2;

            If  %Subst( PxKwdStr: KwdPos - 2 ) = '?';
              KwdStr = %Replace( PxPmtCtl: PxKwdStr: KwdPos - 2: 2 );
            EndIf;
          EndIf;

          If  KwdStr = *Blanks;
            KwdStr = %Replace( PxPmtCtl: PxKwdStr: KwdPos: 0 );
          EndIf;

          Return  KwdStr;
        EndIf;

        Return  Null;

      /End-Free

     P SetPmtCtl       E
