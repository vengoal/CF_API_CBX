     **
     **  Program . . : CBX213X4
     **  Description : Change device description prior to STRPRTWTR
     **  Author  . . : Carsten Flensburg
     **
     **
     **
     **  IBM documentation:
     **    http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/apis/xcartv.htm
     **
     **  Prerequisite:
     **    *IOSYSCFG special authority required:
     **      Program object owner . . . :  QSECOFR
     **      Program attribute USRPRF . :  *OWNER
     **
     **    Register the commands that should be retrieved:
     **
     **    AddExitPgm ExitPnt( QIBM_QCA_RTV_COMMAND )
     **               Format( RTVC0100 )
     **               PgmNbr( *LOW )
     **               Pgm( QGPL/CBX213X4 )
     **               PgmDta( *JOB 20 'STRPRTWTR QSYS      ' )
     **
     **
     **  Programmer's notes:
     **    The Work with Registration Info (WRKREGINF) command can be used
     **    to verify and change or remove the registration:
     **
     **    WrkRegInf   ExitPnt( QIBM_QCA_RTV_COMMAND ), select option 8.
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX213X4 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX213X4 )
     **                Module( CBX213X4 )
     **                ActGrp( *CALLER )
     **
     **
     **-- Control spec:  -----------------------------------------------------**
     H Option( *SrcStmt )

     **-- Global variables:
     D CmdOrg          s          32000a   Varying
     D CmdRpl          s          32000a   Varying
     D CmdStr          s           1024a   Varying  Inz

     **-- Retrieve command exit information:
     D CmdExitInf      Ds         32060    Qualified
     D  ExitName                     20a
     D  ExitFmt                       8a
     D  CmdNam                       10a
     D  CmdLib                       10a
     D                                4a
     D  OfsOrgCmd                    10i 0
     D  LenOrgCmd                    10i 0
     D  OfsRplCmd                    10i 0
     D  LenRplCmd                    10i 0
      /If Defined( *V5R4 )
     D  PxyChnOfs                    10i 0
     D  NbrPxyChnE                   10i 0
      /EndIf

     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                     1024a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )

     **-- Command analyzer retrieve exit point parameter:
     D CBX213X4        Pr
     D  PxCmdExitInf                       LikeDs( CmdExitInf )

     D CBX213X4        Pi
     D  PxCmdExitInf                       LikeDs( CmdExitInf )

      /Free

        If  PxCmdExitInf.ExitName = 'QIBM_QCA_RTV_COMMAND'  And
            PxCmdExitInf.ExitFmt  = 'RTVC0100';

          CmdOrg =  %SubSt( PxCmdExitInf
                          : PxCmdExitInf.OfsOrgCmd + 1
                          : PxCmdExitInf.LenOrgCmd
                          );

          CmdRpl =  %SubSt( PxCmdExitInf
                          : PxCmdExitInf.OfsRplCmd + 1
                          : PxCmdExitInf.LenRplCmd
                          );

          If  CmdRpl > *Blanks;
            CmdOrg = CmdRpl;
          EndIf;

          If  PxCmdExitInf.CmdNam =  'STRPRTWTR';

            If  %Scan( 'DEV(CPHP001)': CmdOrg ) >  *Zero;
              CmdStr = 'CHGDEVPRT DEVD(CPHP001) MSGQ(CPHPMSGQ)';
            EndIf;

            If  %Scan( 'DEV(CPHP002)': CmdOrg ) >  *Zero;
              CmdStr = 'CHGDEVPRT DEVD(CPHP002) MSGQ(CPHPMSGQ)';
            EndIf;

            If  %Scan( 'DEV(CPHP003)': CmdOrg ) >  *Zero;
              CmdStr = 'CHGDEVPRT DEVD(CPHP002) MSGQ(CPHPMSGQ)';
            EndIf;

            If  CmdStr > *Blank;
              Monitor;
                ExcCmd( CmdStr: %Len( CmdStr ));

              On-Error;
                // Ignore...
              EndMon;
            EndIf;
          EndIf;
        EndIf;

        *InLr = *On;
        Return;

      /End-Free
