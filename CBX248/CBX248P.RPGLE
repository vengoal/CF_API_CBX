     **
     **  Program . . :  CBX248P
     **  Description :  Remove Watch Definition - PCP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  iPro Developer Insight, 2012.
     **
     **
     **  Program description:
     **    Prompt control program defining whether specified watch is
     **    active or not.
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX248P )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX248P )
     **               Module( CBX248P )
     **               BndSrvPgm( CBX248 )
     **               ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

     **-- Retrieve watch information:
     D RtvWchInf       Pr                  ExtPgm( 'QSCRWCHI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SsnId                        10a   Const
     D  Error                     32767a          Options( *VarSize )

     **-- Check if watch is active:
     D ChkWchAct       Pr              n
     D  PxSsnId                      10a   Value  Varying  Options( *Trim )

     **-- Entry parameters:
     D Cmd             Ds                  Qualified
     D  CmdNam                       10a
     D  PrmNam                       10a
     **
     D CBX248P         Pr
     D  PxCmd                              LikeDs( Cmd )
     D  PxPrmVal                     10a
     D  PxRtnVal                     10a
     **
     D CBX248P         Pi
     D  PxCmd                              LikeDs( Cmd )
     D  PxPrmVal                     10a
     D  PxRtnVal                     10a

      /Free

        If  ChkWchAct( PxPrmVal ) = *On;
          PxRtnVal = '*YES';
        Else;
          PxRtnVal = '*NO';
        EndIf;

        *InLr = *On;
        Return;

      /End-Free

     **-- Check if watch is active:
     P ChkWchAct       B
     D                 Pi              n
     D  PxSsnId                      10a   Value  Varying  Options( *Trim )

     **-- Watch information:
     D WCHI0100        Ds         65535    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0 Inz( 24 )
     D  Origin                       10a
     D  UserId                       10a
     D  Status                       10a
     D  StrJobNam                    10a
     D  StrJobUsr                    10a
     D  StrJobNbr                     6a
     D                                4a
     D  StrJobCcsId                  10i 0
     D  WchSsnTyp                    10a
     D  WchPgmNam                    10a
     D  WchPgmLib                    10a
     D                                2a
     D  RunPty                       10i 0
     D  LenTimWch                    10i 0
     D  TimItv                       10i 0
     D  StrWchDts                     8a
     D  OfsWchPgmOpt                 10i 0
     D  NbrWchPgmOpt                 10i 0
     D  OfsMsgInf                    10i 0
     D  NbrMsg                       10i 0
     D  OfsLicLogInf                 10i 0
     D  NbrLicLog                    10i 0
     D  OfsPalInf                    10i 0
     D  NbrPal                       10i 0
     D  Data                       1024a
     **
     D WchPgmOpt       s             10a   Dim( 12 )

      /Free

        RtvWchInf( WCHI0100
                 : %Size( WCHI0100 )
                 : 'WCHI0100'
                 : PxSsnId
                 : ERRC0100
                 );


         If  ERRC0100.BytAvl > *Zero;
           Return  *Off;

         Else;
           Return  *On;
         EndIf;

      /End-Free

     P ChkWchAct       E
