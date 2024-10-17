     **
     **  Program . . : CBX135V
     **  Description : Change object attributes - validity checking program
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : May 12, 2005
     **
     **
     **  Program description:
     **    This program checks the existence of the specified object and
     **    verifies some of the specified values.
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX135V )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX135V )
     **              Module( CBX135V )
     **              ActGrp( CBX135 )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  ExcpId                        7a
     D                                1a
     D  ExcpDta                     512a
     **-- Global constants:
     D NULL            c                   ''
     **-- Global variables:
     D ChgDts          Ds
     D  NbrElm                        5i 0
     D  ChgDat                        7a
     D  ChgTim                        6a
     **
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a

     **-- Convert object type to hex:
     D CvtObjTyp       Pr                  ExtPgm( 'QLICVTTP' )
     D  CtCnvOpt                     10a   Const
     D  CtObjSym                     10a   Const
     D  CtObjHex                      2a
     D  CtError                   32767a          Options( *VarSize )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RoRcvVar                  32767a          Options( *VarSize )
     D  RoRcvVarLen                  10i 0 Const
     D  RoFmtNam                      8a   Const
     D  RoObjNamQ                    20a   Const
     D  RoObjTyp                     10a   Const
     D  RoError                   32767a          Options( *VarSize )
     **-- Retrieve member description:
     D RtvMbrD         Pr                  ExtPgm( 'QUSRMBRD' )
     D  RmRcvVar                  32767a          Options( *VarSize )
     D  RmRcvVarLen                  10i 0 Const
     D  RmFmtNam                      8a   Const
     D  RmDbfNam_q                   20a   Const
     D  RmDbfMbr                     10a   Const
     D  RmOvrPrc                      1a   Const
     D  RmError                   32767a          Options( *NoPass: *VarSize )
     D  RmFndMbrPrc                   1a   Const  Options( *NoPass )
     **-- Retrieve message description:
     D RtvMsgD         Pr                  ExtPgm( 'QMHRTVM' )
     D  RtRcvVar                  32767a          Options( *VarSize )
     D  RtRcvVarLen                  10i 0 Const
     D  RtFmtNam                     10a   Const
     D  RtMsgId                       7a   Const
     D  RtMsgFq                      20a   Const
     D  RtMsgDta                    512a   Const  Options( *VarSize )
     D  RtMsgDtaLen                  10i 0 Const
     D  RtRplSubVal                  10a   Const
     D  RtRtnFmtChr                  10a   Const
     D  RtError                   32767a          Options( *VarSize )
     D  RtRtvOpt                     10a   Const  Options( *NoPass )
     D  RtCvtCcsId                   10i 0 Const  Options( *NoPass )
     D  RtDtaCcsId                   10i 0 Const  Options( *NoPass )
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

     **-- Verify object type:
     D VfyObjTyp       Pr              n
     D  PxObjTyp                     10a
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Check object change attribute:
     D ChkObjChgA      Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Check source member existence:
     D ChkSrcMbr       Pr              n
     D  PxFilNam_q                   20a   Const
     D  PxMbrNam                     10a   Const
     **-- Check member existence:
     D ChkMbr          Pr              n
     D  PxFilNam_q                   20a   Const
     D  PxMbrNam                     10a   Const
     **-- Retrieve message:
     D RtvMsg          Pr          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D CBX135V         Pr
     D  PxObjNam_q                         LikeDs( ObjNam_q )
     D  PxObjTyp                     10a
     D  PxSrcFil_q                         LikeDs( ObjNam_q )
     D  PxSrcMbr                     10a
     D  PxSrcChgDts                        LikeDs( ChgDts )
     D  PxAlwChg                      1a
     D  PxUsrAtr                     10a
     D  PxTxtDsc                     50a
     D  PxUseCnt                      1a
     D  PxLstUsd                      1a
     D  PxChgDts                      1a
     D  PxMbrCnt                     10a
     **
     D CBX135V         Pi
     D  PxObjNam_q                         LikeDs( ObjNam_q )
     D  PxObjTyp                     10a
     D  PxSrcFil_q                         LikeDs( ObjNam_q )
     D  PxSrcMbr                     10a
     D  PxSrcChgDts                        LikeDs( ChgDts )
     D  PxAlwChg                      1a
     D  PxUsrAtr                     10a
     D  PxTxtDsc                     50a
     D  PxUseCnt                      1a
     D  PxLstUsd                      1a
     D  PxChgDts                      1a
     D  PxMbrCnt                     10a

      /Free

        If  ChkObj( PxObjNam_q: PxObjTyp ) = *Off;

          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      RtvMsg( 'CPF2105': PxObjNam_q + %Subst( PxObjTyp: 2 ))
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  VfyObjTyp( PxObjTyp ) = *Off;

          SndDiagMsg( 'CPD0006'
                    : '0000' + RtvMsg( 'CPF2101': %Subst( PxObjTyp: 2 ))
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If ChkObjChgA( PxObjNam_q: PxObjTyp ) = *Off;

          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      RtvMsg( 'CPF219B': PxObjNam_q + %Subst( PxObjTyp: 2 ))
                    );

          SndEscMsg( 'CPF0002': '' );
        EndIf;

        If  PxSrcFil_q.ObjNam <> '*SAME';

          If  ChkSrcMbr( PxSrcFil_q: PxSrcMbr ) = *Off;

            SndDiagMsg( 'CPD0006'
                      : '0000' + RtvMsg( 'CPF3029': PxSrcMbr + PxSrcFil_q )
                      );

            SndEscMsg( 'CPF0002': '' );
          EndIf;
        EndIf;

        If  PxMbrCnt <> '*NONE';

          If  PxObjTyp <> '*FILE';

            SndDiagMsg( 'CPD0006'
                      : '0000' + RtvMsg( 'CPF2210': %Subst( PxObjTyp: 2 ))
                      );

            SndEscMsg( 'CPF0002': '' );
          EndIf;

          If  ChkMbr( PxObjNam_q: PxMbrCnt ) = *Off;

            SndDiagMsg( 'CPD0006'
                      : '0000' + RtvMsg( 'CPF3029': PxMbrCnt + PxObjNam_q )
                      );

            SndEscMsg( 'CPF0002': '' );
          EndIf;
        EndIf;

        *InLr = *On;

        Return;


      /End-Free

     **-- Verify object type:  -----------------------------------------------**
     P VfyObjTyp       B
     D                 Pi              n
     D  PxObjTyp                     10a
     **
     D ObjTypHex       s              2a

      /Free

        CvtObjTyp( '*SYMTOHEX': PxObjTyp: ObjTypHex: ERRC0100 );

        If  ERRC0100.BytAvl = *Zero;
          Return  *On;

        Else;
          Return  *Off;
        EndIf;

      /End-Free

     P VfyObjTyp       E
     **-- Check object existence:  -------------------------------------------**
     P ChkObj          B                   Export
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
     **-- Check object change attribute:  ------------------------------------**
     P ChkObjChgA      B
     D                 Pi              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  AlwChg                        1a   Overlay( OBJD0400: 482 )

      /Free

        RtvObjD( OBJD0400
               : %Size( OBJD0400 )
               : 'OBJD0400'
               : PxObjNam_q
               : PxObjTyp
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Off;

        Else;
          Return  OBJD0400.AlwChg;
        EndIf;

      /End-Free

     P ChkObjChgA      E
     **-- Check source member existence:  ------------------------------------**
     P ChkSrcMbr       B                   Export
     D                 Pi              n
     D  PxFilNam_q                   20a   Const
     D  PxMbrNam                     10a   Const
     **
     D MBRD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  DbfNam                       10a
     D  DbfLib                       10a
     D  MbrNam                       10a
     D  FilAtr                       10a
     D  SrcTyp                       10a
     D  CrtDts                       13a
     D  SrcChgDts                    13a
     D  TxtDsc                       50a
     D  SrcFil                        1a
     **
     D NOT_PRC_OVR     c                   '0'
     D SRC_TYP         c                   '1'

      /Free

        RtvMbrD( MBRD0100
               : %Size( MBRD0100 )
               : 'MBRD0100'
               : PxFilNam_q
               : PxMbrNam
               : NOT_PRC_OVR
               : ERRC0100
               );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  *Off;

        When  MBRD0100.SrcFil <> SRC_TYP;
          Return  *Off;

        Other;
          Return  *On;
        EndSl;

      /End-Free

     P ChkSrcMbr       E
     **-- Check member existence:  -------------------------------------------**
     P ChkMbr          B                   Export
     D                 Pi              n
     D  PxFilNam_q                   20a   Const
     D  PxMbrNam                     10a   Const
     **
     D MBRD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  DbfNam                       10a
     D  DbfLib                       10a
     D  MbrNam                       10a
     D  FilAtr                       10a
     D  SrcTyp                       10a
     D  CrtDts                       13a
     D  SrcChgDts                    13a
     D  TxtDsc                       50a
     D  SrcFil                        1a
     **
     D NOT_PRC_OVR     c                   '0'

      /Free

        RtvMbrD( MBRD0100
               : %Size( MBRD0100 )
               : 'MBRD0100'
               : PxFilNam_q
               : PxMbrNam
               : NOT_PRC_OVR
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Off;

        Else;
          Return  *On;
        EndIf;

      /End-Free

     P ChkMbr          E
     **-- Retrieve message:  -------------------------------------------------**
     P RtvMsg          B
     D                 Pi          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D RTVM0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  RtnMsgLen                    10i 0
     D  RtnMsgAvl                    10i 0
     D  RtnHlpLen                    10i 0
     D  RtnHlpAvl                    10i 0
     D  Msg                        4096a
     **
     D RPL_SUB_VAL     c                   '*YES'
     D NOT_FMT_CTL     c                   '*NO'

      /Free

        RtvMsgD( RTVM0100
               : %Size( RTVM0100 )
               : 'RTVM0100'
               : PxMsgId
               : 'QCPFMSG   *LIBL'
               : PxMsgDta
               : %Len( PxMsgDta )
               : RPL_SUB_VAL
               : NOT_FMT_CTL
               : ERRC0100
               );

        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  NULL;

        When  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen ) = PxMsgId;
          Return  %Subst( RTVM0100.Msg
                        : RTVM0100.RtnMsgLen + 1
                        : RTVM0100.RtnHlpLen
                        );

        Other;
          Return  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen );
        EndSl;

      /End-Free

     P RtvMsg          E
     **-- Send diagnostic message:  ------------------------------------------**
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
     **-- Send escape message:  ----------------------------------------------**
     P SndEscMsg       B
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
