     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- Api error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0 Inz
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
     **-- Global variables:
     D Idx             s             10u 0
     D IdxKey          s             10u 0
     D ApiRcvSiz       s             10u 0
     D MsgTxt          s            512a   Varying
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  NbrKeyRtn                    10i 0 Inz( %Elem( LstApi.KeyFld ))
     D  KeyFld                       10i 0 Dim( 3 )
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D NO_RTN_KEY      c                   0
     D TYP_JOBTHR      c                   0
     D TYP_LCKSPC      c                   1
     D ALL_RCD         c                   0
     D OBJ_LVL         c                   0
     D RCD_LVL         c                   1

     **-- Watch information:
     D WCHI0100        Ds                  Qualified  Based( pWchInf )
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
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
     **-- Lock holder - job/thread format:
     D HlrJobThr       Ds                  Based( pJobThrFmt )  Qualified
     D  HlrInfSiz                    10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  ThdId                         8a
     D                                2a
     D  ThdHdl                       10u 0
     **-- Lock holder - lock space format:
     D HlrLckSpc       Ds                  Based( pLckSpcFmt )  Qualified
     D  HlrInfSiz                    10i 0
     D  HldLckSpcId                  20a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  ThdId                         8a
     D                                2a
     D  ThdHdl                       10u 0
     **-- API return information:
     D PrcNam          s           1024a   Inz  Varying

     **-- Retrieve watch information:
     D RtvWchInf       Pr                  ExtPgm( 'QSCRWCHI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SsnId                        10a   Const
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
     **-- Register termination exit:
     D CeeRtx          Pr                    ExtProc( 'CEERTX' )
     D  procedure                      *     ProcPtr   Const
     D  token                          *     Options( *Omit )
     D  fb                           12a     Options( *Omit )
     **-- Unregister termination exit:
     D CeeUtx          Pr                    ExtProc( 'CEEUTX' )
     D  procedure                      *     ProcPtr   Const
     D  fb                           12a     Options( *Omit )
     **-- Copy memory:
     D memcpy          Pr              *   ExtProc( '_MEMMOVE' )
     D pOutMem                         *   Value
     D pInpMem                         *   Value
     D iMemSiz                       10u 0 Value

     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send message by type:
     D SndMsgTyp       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     D  PxMsgTyp                     10a   Const
     **-- Terminate program:
     D TrmPgm          Pr
     D  pPtr                           *

     **-- Entry parameters:
     D CBX251          Pr
     D  PxSsnId                      10a
     **
     D CBX251          Pi
     D  PxSsnId                      10a

      /Free

        ApiRcvSiz = 65535;
        pWchInf   = %Alloc( ApiRcvSiz );

        WCHI0100.BytAvl = *Zero;

        DoU  WCHI0100.BytAvl <= ApiRcvSiz  Or  ERRC0100.BytAvl > *Zero;

          If  WCHI0100.BytAvl > ApiRcvSiz;
            ApiRcvSiz  = WCHI0100.BytAvl;
            pWchInf    = %ReAlloc( pWchInf: ApiRcvSiz );
          EndIf;

          RtvWchInf( WCHI0100
                   : ApiRcvSiz
                   : 'WCHI0100'
                   : PxSsnId
                   : ERRC0100
                   );
        EndDo;

        CeeRtx( %Paddr( TrmPgm ): pWchInf: *Omit );

        If  ERRC0100.BytAvl > *Zero;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
        Else;

          ExSr  PrcLstEnt;

          SndCmpMsg( 'Watch API example completed normally.' );
        EndIf;

        CeeUtx( %Paddr( TrmPgm ): *Omit );

        TrmPgm( pWchInf );

        *InLr = *On;
        Return;

        BegSr  PrcLstEnt;


        EndSr;

      /End-Free

     **-- Send completion message:  ------------------------------------------**
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
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

     **
     P SndCmpMsg       E
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
     **-- Send message by type:  ---------------------------------------------**
     P SndMsgTyp       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     D  PxMsgTyp                     10a   Const
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : PxMsgTyp
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

     P SndMsgTyp       E
     **-- Terminate program:  ------------------------------------------------**
     P TrmPgm          B
     D                 Pi
     D  pPtr                           *

      /Free

        DeAlloc  pPtr;

        *InLr = *On;

        Return;

      /End-Free

     P TrmPgm          E
