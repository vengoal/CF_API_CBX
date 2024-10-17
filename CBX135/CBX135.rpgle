     **
     **  Program . . : CBX135
     **  Description : Change object attribute - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : May 12, 2005
     **
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Object-related APIs:
     **    QLICOBJD      Change object
     **                  description
     **
     **    QUSROBJD      Retrieve object       Retrieves object information for
     **                  description           the specified object, including
     **                                        the variety of object attributes
     **                                        returned by the DSPOBJD and the
     **                                        RTVOBJD commands.
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
     **  Programmer's notes:
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX135 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX135 )
     **              Module( CBX135 )
     **              ActGrp( CBX135 )
     **
     **
     **-- Control specifications:  -------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      256a
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     **
     D SRC_FIL_NAM     c                    1
     D SRC_CHG_DTS     c                    2
     D OBJ_CMP_LVL     c                    3
     D OBJ_CTL_LVL     c                    4
     D OBJ_LIC_PGM     c                    5
     D OBJ_PTF_ID      c                    6
     D OBJ_APAR        c                    7
     D OBJ_ALW_CHG     c                    8
     D OBJ_USR_ATR     c                    9
     D OBJ_TXT_DSC     c                   10
     D RES_DUC         c                   11
     D PRD_LOD_ID      c                   12
     D PRD_OPT_ID      c                   13
     D PRD_COM_ID      c                   14
     D UPD_LUD         c                   15
     D RES_CHG_DTS     c                   16
     D RES_MBR_DUC     c                   17
     **-- Global variables:
     D ChgDts          Ds
     D  NbrElm                        5i 0
     D  ChgDat                        7a
     D  ChgTim                        6a
     **
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a

     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RoRcvVar                  32767a          Options( *VarSize )
     D  RoRcvVarLen                  10i 0 Const
     D  RoFmtNam                      8a   Const
     D  RoObjNamQ                    20a   Const
     D  RoObjTyp                     10a   Const
     D  RoError                   32767a          Options( *VarSize )
     **- Change object description:
     D ChgObjD         Pr                  ExtPgm( 'QLICOBJD' )
     D  CoRtnLib                     10a
     D  CoObjNam_q                   20a   Const
     D  CoObjTyp                     10a   Const
     D  CoChgObjInf                1024a   Const  Options( *VarSize )
     D  CoError                   32767a          Options( *VarSize )
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

     **-- Change object attribute:
     D ChgObjAtr       Pr            10i 0
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     D  PxAtrId                      10i 0 Const
     D  PxAtrVal                     50a   Const  Varying
     **-- Get object source file:
     D GetObjSrcF      Pr            20a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Get object source member:
     D GetObjSrcM      Pr            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     D CBX135          Pr
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
     D CBX135          Pi
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

        ExSr  InzParms;

        If  PxSrcFil_q <> '*SAME'  Or  PxSrcMbr <> '*SAME';

          If  PxSrcFil_q = '*SAME';
            PxSrcFil_q = GetObjSrcF( PxObjNam_q: PxSrcMbr );
          EndIf;

          If  PxSrcMbr = '*SAME';
            PxSrcMbr = GetObjSrcM( PxObjNam_q: PxSrcMbr );
          EndIf;

          ChgObjAtr( PxObjNam_q: PxObjTyp: SRC_FIL_NAM: PxSrcFil_q + PxSrcMbr );
        EndIf;

        If  PxSrcChgDts.NbrElm > 1;

          ChgObjAtr( PxObjNam_q
                   : PxObjTyp
                   : SRC_CHG_DTS
                   : PxSrcChgDts.ChgDat + PxSrcChgDts.ChgTim
                   );
        EndIf;

        If  PxAlwChg <> '2';

          ChgObjAtr( PxObjNam_q: PxObjTyp: OBJ_ALW_CHG: PxAlwChg );
        EndIf;

        If  PxUsrAtr <> '*SAME';

          ChgObjAtr( PxObjNam_q: PxObjTyp: OBJ_USR_ATR: PxUsrAtr );
        EndIf;

        If  PxTxtDsc <> '*SAME';

          ChgObjAtr( PxObjNam_q: PxObjTyp: OBJ_TXT_DSC: PxTxtDsc );
        EndIf;

        If  PxUseCnt <> '0';

          ChgObjAtr( PxObjNam_q: PxObjTyp: RES_DUC: PxUseCnt );
        EndIf;

        If  PxLstUsd <> '0';

          ChgObjAtr( PxObjNam_q: PxObjTyp: UPD_LUD: PxLstUsd );
        EndIf;

        If  PxChgDts <> '0';

          ChgObjAtr( PxObjNam_q: PxObjTyp: RES_CHG_DTS: PxChgDts );
        EndIf;

        If  PxMbrCnt <> '*NONE';

          ChgObjAtr( PxObjNam_q: PxObjTyp: RES_MBR_DUC: PxMbrCnt );
        EndIf;

        Exit();
        Return;

        BegSr  InzParms;

          If  PxSrcChgDts.NbrElm > 1;

            If  PxSrcChgDts.ChgDat = '0010000';
              PxSrcChgDts.ChgDat = %Char( %Date(): *CYMD0 );
            EndIf;

            If  PxSrcChgDts.ChgTim = '999999';
              PxSrcChgDts.ChgTim = %Char( %Time(): *HMS0 );
            EndIf;
          EndIf;

        EndSr;

      /End-Free

     **-- Change object attribute:  ------------------------------------------**
     P ChgObjAtr       B
     D                 Pi            10i 0
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     D  PxAtrId                      10i 0 Const
     D  PxAtrVal                     50a   Const  Varying

     **-- Change object description Api parameters:
     D RtnLib          s             10a
     **
     D ObjInf          Ds                  Qualified
     D  NbrObjAtr                    10i 0 Inz( 1 )
     D  ObjAtr                             LikeDs( ObjAtr )
     **
     D ObjAtr          Ds                  Qualified
     D  AtrKey                       10i 0
     D  DtaLen                       10i 0
     D  Data                         50a

      /Free

        ObjInf.ObjAtr.AtrKey = PxAtrId;
        ObjInf.ObjAtr.DtaLen = %Size( PxAtrVal );
        ObjInf.ObjAtr.Data   = PxAtrVal;

        ChgObjD( RtnLib
               : PxObjNam_q
               : PxObjTyp
               : ObjInf
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        Else;
          SndCmpMsg( 'Object attribute changed.' );
        EndIf;

          Return   0;

      /End-Free

     **
     P ChgObjAtr       E
     **-- Get object source file:  -------------------------------------------**
     P GetObjSrcF      B
     D                 Pi            20a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  SrcFil                       20a   Overlay( OBJD0200: 151 )

      /Free

        RtvObjD( OBJD0200
               : %Size( OBJD0200 )
               : 'OBJD0200'
               : PxObjNam_q
               : PxObjTyp
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;

        Else;
          Return  OBJD0200.SrcFil;
        EndIf;

      /End-Free

     P GetObjSrcF      E
     **-- Get object source member:  -----------------------------------------**
     P GetObjSrcM      B
     D                 Pi            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  SrcMbr                       20a   Overlay( OBJD0200: 171 )

      /Free

        RtvObjD( OBJD0200
               : %Size( OBJD0200 )
               : 'OBJD0200'
               : PxObjNam_q
               : PxObjTyp
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;

        Else;
          Return  OBJD0200.SrcMbr;
        EndIf;

      /End-Free

     P GetObjSrcM      E
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
