     **
     **  Program . . : CBX708
     **  Description : Password check exit program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Program description:
     **
     **    After proper registration of this program as a password check exit
     **    program (see below), this program will be called whenever a user
     **    profile's password is changed, irrespective of the command or API
     **    performing the password change.
     **
     **    More than one program can be registered to the password check exit
     **    point and the check programs will be called in turn until all check
     **    programs have been called - or a until a negative return code is
     **    received.  The old password value will always be set to *NOPWD and
     **    the old password length set to 12.
     **
     **
     **  Exit point documentation:
     **    http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/apis/xsyvlphr.htm
     **
     **
     **  Exit point registration:
     **
     **    AddExitPgm ExitPnt( QIBM_QSY_CHK_PASSWRD )
     **               Format( CHKP0100 )
     **               PgmNbr( 1 )
     **               Pgm( <library name>/CBX708 )
     **               Text( 'Password check exit program' )
     **
     **
     **  Audit journal registration:
     **
     **    Journal code 'T'; Entry type 'CP'; Output format 'J5':
     **
     **    Offset  Type       Field
     **      642   Char(1)    Password Changed; Y=Yes
     **      967   Char(10)   Password Composition Conformance
     **
     **      Indicates whether the new password conforms to the password
     **      composition rules:
     **
     **      *PASSED   Checked and conforms.
     **
     **      *SYSVAL   Checked but does not conform because of a system
     **                value based rule.
     **
     **      *EXITPGM  Checked but does not conform because of an exit
     **                program response.
     **
     **      *NONE     Not checked; *NONE was specified for the new password.
     **
     **      *NOCHECK  Not checked; password was changed.
     **
     **      This field has meaning only when the Password Changed field
     **      contains a Y.
     **
     **
     **  Job log registration:
     **
     **    Message ID . . . . . . :   CPI22AE
     **
     **    Message . . . . :   Password does not meet all password rules.
     **
     **    Cause . . . . . :   The new password does not meet the password rules
     **      specified by the QPWDxxxxxx system values, or one of the programs registered
     **      for the QIBM_QSY_CHK_PASSWRD exit point has indicated that the password does
     **      not meet the installation specific rules.
     **
     **    Technical description . . . . . . . . :   An exception was signaled by
     **      QSYPWDCR that indicates the new password value does not conform to the
     **      password composition rules.
     **
     **
     **
     **  Compilation specification:
     **
     **    CrtRpgMod  Module( CBX708 )
     **               DbgView( *NONE )
     **               Aut( *USE )
     **
     **    CrtPgm     Pgm( CBX708 )
     **               Module( CBX708 )
     **               ActGrp( *NEW )
     **               Aut( *USE )
     **
     **    ChgPgm     Pgm( CBX708 )
     **               RmvObs( *ALL )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  PgmLib                       10a   Overlay( PgmSts:  81 )
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

     **-- Exit format CHKP0100:
     D CHKP0100_T      Ds         65535    Qualified  Based( p_T )
     D  ExpNam                       20a
     D  ExpFmtNam                     8a
     D  PwdLvl                       10i 0
     D  UsrPrf                       10a
     D                                2a
     D  OfsOldPwd                    10i 0
     D  LenOldPwd                    10i 0
     D  CcsOldPwd                    10i 0
     D  OfsNewPwd                    10i 0
     D  LenNewPwd                    10i 0
     D  CcsNewPwd                    10i 0
     **
     D OldPwd          s            512a   Varying
     D NewPwd          s            512a   Varying
     D ChkPwd          s            512a   Varying

     **-- Global constants:
     D PWD_ACCEPT      c                   '0'
     D PWD_LOGAUD      c                   '1'
     **
     D CHR_STR         c                   0
     D CAS_INS_DFT     c                   0
     **-- Global variables:
     D DFT_RTNCOD      s               n   Inz( PWD_LOGAUD )

     **-- Check spelling format CHKW0200:                                   --**
     D CHKW0200        Ds          4096    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  NbrWrdRtn                    10i 0
     D  NbrWrdAvl                    10i 0
     D  OfsWrdEnt                    10i 0
     D  LenWrdEnt                    10i 0
     D                               10i 0
     **
     D WrdInfEnt       Ds                  Qualified  Based( pWrdInfEnt )
     D  OfsWrd                       10i 0
     D  LenWrd                       10i 0
     D  MisSpl                        1a
     **-- Dictionary format (input):
     D DctEntInp       Ds                  Qualified
     D  OfsDctEnt                    10i 0 Inz( 12 )
     D  NbrDctEnt                    10i 0
     D                               10i 0 Inz( 0 )
     D  DctEnt                       20a   Dim( 8 )
     D   DctNam                      10a   Overlay( DctEnt: 1 )
     D   DctLib                      10a   Overlay( DctEnt: *Next )
     **-- Dictionary format (output):
     D DctEntOut       Ds                  Qualified
     D  NbrDctRtn                    10i 0
     D  NbrDctAvl                    10i 0
     D  DctEnt                       20a   Dim( 8 )
     D   DctNam                      10a   Overlay( DctEnt: 1 )
     D   DctLib                      10a   Overlay( DctEnt: *Next )

     **-- Convert string:
     D CvtString       Pr                  ExtPgm( 'QTQCVRT' )
     D  InpCcsId                     10i 0 Const
     D  InpStrTyp                    10i 0 Const
     D  InpStr                    32767a   Const  Options( *VarSize )
     D  InpStrSiz                    10i 0 Const
     D  OutCcsId                     10i 0 Const
     D  OutStrTyp                    10i 0 Const
     D  OutCvtAlt                    10i 0 Const
     D  OutStrSiz                    10i 0 Const
     D  OutStr                    32767a          Options( *VarSize )
     D  OutStrLenRt                  10i 0
     D  NotSup                       10i 0
     D  FB                           10i 0 Dim( 3 )
     **-- Convert case:
     D CvtCase         Pr                  ExtProc( 'QlgConvertCase' )
     D  RqsBlk                       22a   Const
     D  InpDta                    32767a   Const  Options( *VarSize )
     D  OutDta                    32767a          Options( *VarSize )
     D  DtaLen                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNam_q                     26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
     **-- Check spelling:
     D ChkSpl          Pr                  ExtPgm( 'QTWCHKSP' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  WrdLst                    32767a   Const  Options( *VarSize )
     D  WrdLstLen                    10i 0 Const
     D  InpDct                      172a   Const  Options( *VarSize )
     D  InpDctLen                    10i 0 Const
     D  OutDct                      168a   Const  Options( *VarSize )
     D  OutDctLen                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )

     **-- Get job ccsid:
     D JobCcsId        Pr            10i 0
     **-- Convert string by CCSID:
     D CvtStrCcsId     Pr          1024a   Varying
     D  PxCcsId                      10i 0 Const
     D  PxCvtStr                   1024a   Const
     D  PxCvtStrLen                  10i 0 Const
     **-- To upper case:
     D ToUpper         Pr          4096a   Varying
     D  InpStr                     4096a   Const  Varying

     **-- Parameters:
     D CBX708          Pr
     D  CHKP0100                           LikeDs( CHKP0100_T )
     D  PxRtnInd                      1a
     **
     D CBX708          Pi
     D  CHKP0100                           LikeDs( CHKP0100_T )
     D  PxRtnInd                      1a

      /Free

        If  CHKP0100.ExpNam = 'QIBM_QSY_CHK_PASSWRD'  And
            CHKP0100.ExpFmtNam = 'CHKP0100';

          PxRtnInd = DFT_RTNCOD;

          If  CHKP0100.CcsNewPwd = JobCcsId();
            NewPwd = %Subst( CHKP0100
                           : CHKP0100.OfsNewPwd + 1
                           : CHKP0100.LenNewPwd
                           );

          Else;
            NewPwd = CvtStrCcsId( CHKP0100.CcsNewPwd
                                : %Subst( CHKP0100
                                        : CHKP0100.OfsNewPwd + 1
                                        : CHKP0100.LenNewPwd
                                        )
                                : CHKP0100.LenNewPwd
                                );
          EndIf;

          DctEntInp.NbrDctEnt = 1;
          DctEntInp.DctNam(1) = 'CBX708D';
          DctEntInp.DctLib(1) = PgmSts.PgmLib;

          ChkPwd = ToUpper( %TrimR( NewPwd: '_0123456789' ));

          ChkSpl( CHKW0200
                : %Size( CHKW0200 )
                : 'CHKW0200'
                : ChkPwd
                : %Len( ChkPwd )
                : DctEntInp
                : %Size( DctEntInp )
                : DctEntOut
                : %Size( DctEntOut )
                : ERRC0100
                );

          If  ERRC0100.BytAvl = *Zero;
            pWrdInfEnt = %Addr( CHKW0200 ) + CHKW0200.OfsWrdEnt;

            If  CHKW0200.NbrWrdRtn > *Zero;

              Select;
              When  WrdInfEnt.MisSpl = x'00';
                PxRtnInd = PWD_LOGAUD;

              When  WrdInfEnt.MisSpl = x'01';
                PxRtnInd = PWD_ACCEPT;
              EndSl;

            EndIf;
          EndIf;
        EndIf;

        *InLr = *On;
        Return;


        BegSr  *PsSr;

          If  *InLr = *On;
            Return;

          Else;
            *InLr = *On;
          EndIf;

          PxRtnInd = DFT_RTNCOD;

          Return;

        EndSr;

      /End-Free

     **-- Get job ccsid:
     P JobCcsId        B
     D                 Pi            10i 0
     **-- Job info format JOBI0400:
     D JOBI0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  CcsId                        10i 0 Overlay( JOBI0400: 301 )
     D  CcsIdDft                     10i 0 Overlay( JOBI0400: 373 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0

      /Free

        RtvJobInf( JOBI0400
                 : %Size( JOBI0400 )
                 : 'JOBI0400'
                 : '*'
                 : *Blank
                 : ERRC0100
                 );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  -1;

        When  JOBI0400.CcsId = 65535;
          Return  JOBI0400.CcsIdDft;

        Other;
          Return  JOBI0400.CcsId;
        EndSl;

      /End-Free

     P JobCcsId        E
     **-- Convert string by CCSID:
     P CvtStrCcsId     B
     D                 Pi          1024a   Varying
     D  PxCcsId                      10i 0 Const
     D  PxCvtStr                   1024a   Const
     D  PxCvtStrLen                  10i 0 Const

     **-- Local variables:
     D OutStr          s           1024a
     D OutStrLenRt     s             10i 0
     D NotSup          s             10i 0
     D FB              s             10i 0 Dim( 3 )
     **-- Local constants:
     D CHR_STR         c                   0
     D CAS_INS_DFT     c                   0

      /Free

        CvtString( PxCcsId
                 : CHR_STR
                 : PxCvtStr
                 : PxCvtStrLen
                 : JobCcsId()
                 : CHR_STR
                 : CAS_INS_DFT
                 : %Size( OutStr )
                 : OutStr
                 : OutStrLenRt
                 : NotSup
                 : FB
                 );

        Return  %Subst( OutStr: 1: OutStrLenRt );

      /End-Free

     P CvtStrCcsId     E
     **-- To upper case:
     P ToUpper         B
     D                 Pi          4096a   Varying
     D  PxInpStr                   4096a   Const  Varying
     **
     D OutStr          s           4096a

     **-- Convert case parameters & constants:
     D RqsCtlBlk       Ds                  Qualified
     D  RqsType                      10i 0 Inz( CVT_BY_CCSID )
     D  CCSID                        10i 0 Inz( JOB_CCSID )
     D  CaseRqs                      10i 0 Inz
     D                               10a   Inz( *Allx'00')
     **
     D CVT_BY_CCSID    c                   1
     D JOB_CCSID       c                   0
     D TO_LOWER        c                   1
     D TO_UPPER        c                   0

      /Free

        If  %Len( PxInpStr ) > *Zero;

         RqsCtlBlk.CaseRqs = TO_UPPER;

         CvtCase( RqsCtlBlk: PxInpStr: OutStr: %Len( PxInpStr ): ERRC0100 );

         If  ERRC0100.BytAvl = *Zero;
           Return  %TrimR( OutStr );
         EndIf;
       EndIf;

       Return  PxInpStr;

      /End-Free

     P ToUpper         E
