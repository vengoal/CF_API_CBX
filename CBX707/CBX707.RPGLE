     **
     **  Program . . : CBX707
     **  Description : Password validation exit program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Program description:
     **
     **    After proper registration of this program as a password validation
     **    exit program (see below), this program will be called whenever the
     **    Change Password (CHGPWD) command or the Change Password (QSYCHGPW)
     **    API is executed.
     **
     **    More than one program can be registered to the password validation
     **    exit point and the validation programs will be called in turn until
     **    all programs have been called - or a until a reject return code is
     **    received.
     **
     **    The objective of the password validation process in this program
     **    is to prevent users from changing passwords again within a given
     **    time frame from when the password was last changed.  You should
     **    change the program constant PWD_CHGBLK_HOURS to the number of hours
     **    for which you want to block a repeated change of a user profile's
     **    password.
     **
     **
     **  Exit point documentation:
     **    http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/apis/xsyvlphr.htm
     **
     **
     **  Exit point registration:
     **
     **    ChgSysVal  SysVal( QPWDVLDPGM )
     **               Value( *REGFAC )
     **
     **    AddExitPgm ExitPnt( QIBM_QSY_VLD_PASSWRD )
     **               Format( VLDP0100 )
     **               PgmNbr( 1 )
     **               Pgm( <library name>/CBX707 )
     **               Text( 'Password validation exit program' )
     **
     **
     **  Compilation specification:
     **
     **    CrtRpgMod  Module( CBX707 )
     **               DbgView( *NONE )
     **               Aut( *USE )
     **
     **    CrtPgm     Pgm( CBX707 )
     **               Module( CBX707 )
     **               ActGrp( *NEW )
     **               Aut( *USE )
     **
     **    ChgPgm     Pgm( CBX707 )
     **               RmvObs( *ALL )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- Exit format VLDP0100:
     D VLDP0100_T      Ds         65535    Qualified  Based( p_T )
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
     D OldPwd          s            128a   Varying
     D NewPwd          s            128a   Varying

     **-- Global constants:
     D PWD_CHGBLK_...
     D  HOURS          c                   24
     **
     D PWD_ACCEPT      c                   '0'
     D PWD_REJECT      c                   '1'
     **-- Global variables:
     D DFT_RTNCOD      s               n   Inz( PWD_REJECT )
     D PwdChgDts       s               z

     **-- Retrieve user information:
     D RtvUsrInf       Pr                  ExtPgm( 'QSYRUSRI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  UsrPrf                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Convert date & time:
     D CvtDtf          Pr                  ExtPgm( 'QWCCVTDT' )
     D  InpFmt                       10a   Const
     D  InpVar                       17a   Const  Options( *VarSize )
     D  OutFmt                       10a   Const
     D  OutVar                       17a          Options( *VarSize )
     D  Error                        10i 0 Const
     D  InpTimZon                    10a   Const  Options( *NoPass )
     D  OutTimZon                    10a   Const  Options( *NoPass )
     D  TimZonInf                   111a          Options( *VarSize: *NoPass )
     D  TimZonInfLen                 10i 0 Const  Options( *NoPass )
     D  PrcInd                        1a   Const  Options( *NoPass )
     D  InpTimInd                     1a   Const  Options( *NoPass )

     **-- Get user profile password system *DTS:
     D GetPwdSdt       Pr             8a
     D  PxUsrPrf                     10a   Value
     **-- Convert system *DTS to timestamp:
     D CvtSdtDts       Pr              z
     D  PxSysDts                      8a   Value

     **-- Parameters:
     D CBX707          Pr
     D  VLDP0100                           LikeDs( VLDP0100_T )
     D  PxRtnInd                      1a
     **
     D CBX707          Pi
     D  VLDP0100                           LikeDs( VLDP0100_T )
     D  PxRtnInd                      1a

      /Free

        PxRtnInd = PWD_ACCEPT;

        If  VLDP0100.ExpNam = 'QIBM_QSY_VLD_PASSWRD'  And
            VLDP0100.ExpFmtNam = 'VLDP0100';

          OldPwd = %Subst( VLDP0100: VLDP0100.OfsOldPwd+1: VLDP0100.LenOldPwd );
          NewPwd = %Subst( VLDP0100: VLDP0100.OfsNewPwd+1: VLDP0100.LenNewPwd );

          PwdChgDts = CvtSdtDts( GetPwdSdt( VLDP0100.UsrPrf ));

          If %Diff( %TimeStamp(): PwdChgDts: *HOURS ) < PWD_CHGBLK_HOURS;

            PxRtnInd = PWD_REJECT;
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

     **-- Get user profile password system *DTS:
     P GetPwdSdt       B
     D                 Pi             8a
     D  PxUsrPrf                     10a   Value

     **-- User information:
     D USRI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  UsrPrf                       10a
     D  PrvSgoDts                    13a   Overlay( USRI0100:  19 )
     D   PrvSgoDat                    7a   Overlay( USRI0100:  19 )
     D   PrvSgoTim                    6a   Overlay( USRI0100:  26 )
     D                                1a   Overlay( USRI0100:  32 )
     D  InvSgo                       10i 0 Overlay( USRI0100:  33 )
     D  PrfSts                       10a   Overlay( USRI0100:  37 )
     D  PwdChgSdt                     8a   Overlay( USRI0100:  47 )
     D  NoPwdI                        1a   Overlay( USRI0100:  55 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a

      /Free

        RtvUsrInf( USRI0100
                 : %Size( USRI0100 )
                 : 'USRI0100'
                 : PxUsrPrf
                 : ERRC0100
                 );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;

        When  USRI0100.PwdChgSdt = *Blanks;
          Return  *Blanks;

        Other;
          Return  USRI0100.PwdChgSdt;
        EndSl;

      /End-Free

     P GetPwdSdt       E
     **-- Convert system *DTS to timestamp:
     P CvtSdtDts       B
     D                 Pi              z
     D  PxSysDts                      8a   Value

     **-- Local constants:
     D MIC_SEC         c                   '1'
     **-- Local variables:
     D SysDts          s             20a
     **
     D TimZonInf       Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  TimZonNam                    10a
     D                                1a
     D  CurDstInd                     1a
     D  CurUtcOfs                    10i 0
     D  CurZonNam                    50a
     D  CurAbvNam                    10a
     D  CurMsgId                      7a
     D  CurMsgF                      10a
     D  CurMsgFlib                   10a
     **

      /Free

        If  PxSysDts = *Blanks;
          Return  *LoVal;

        Else;
          CvtDtf( '*DTS'
                : PxSysDts
                : '*YYMD'
                : SysDts
                : *Zero
                : '*SYS'
                : '*SYS'
                : TimZonInf
                : %Size( TimZonInf )
                : MIC_SEC
                );

          Return  %Timestamp( SysDts: *ISO0 );
        EndIf;

      /End-Free

     P CvtSdtDts       E
