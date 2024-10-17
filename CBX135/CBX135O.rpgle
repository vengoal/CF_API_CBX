     **
     **  Program . . : CBX135O
     **  Description : Change object attributes - prompt override program
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : May 12, 2005
     **
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter identifying the
     **                           object to retrieve attribute
     **                           information about.
     **
     **    PxKeyPrm2   INPUT      Key parameter specifying the
     **                           object type.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt
     **                           string returning the current
     **                           attribute setting of the
     **                           specified object.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX135O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX135O )
     **              Module( CBX135O )
     **              ActGrp( CBX135 )
     **
     **
     **-- Control specification:  --------------------------------------------**
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

     **-- Object description structure:
     D OBJD0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  TxtDsc                       50a   Overlay( OBJD0400: 101 )
     D  SrcFil_q                     20a   Overlay( OBJD0400: 151 )
     D   SrcFil                      10a   Overlay( OBJD0400: 151 )
     D   SrcLib                      10a   Overlay( OBJD0400: 161 )
     D  SrcMbr                       10a   Overlay( OBJD0400: 171 )
     D  SrcChgDts                    13a   Overlay( OBJD0400: 181 )
     D   SrcChgDat                    7a   Overlay( OBJD0400: 181 )
     D   SrcChgTim                    6a   Overlay( OBJD0400: 188 )
     D  AlwChg                        1a   Overlay( OBJD0400: 482 )
     D  UsrAtr                       10a   Overlay( OBJD0400: 484 )

     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RoRcvVar                  32767a          Options( *VarSize )
     D  RoRcvVarLen                  10i 0 Const
     D  RoFmtNam                      8a   Const
     D  RoObjNamQ                    20a   Const
     D  RoObjTyp                     10a   Const
     D  RoError                   32767a          Options( *VarSize )
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
     D  SpError                   32767a          Options( *VarSize )

     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying

     D CBX135O         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    20a
     D  PxKeyPrm2                    10a
     D  PxCmdStr                  32674a   Varying
     **
     D CBX135O         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    20a
     D  PxKeyPrm2                    10a
     D  PxCmdStr                  32674a   Varying

      /Free

        RtvObjD( OBJD0400
               : %Size( OBJD0400 )
               : 'OBJD0400'
               : PxKeyPrm1
               : PxKeyPrm2
               : ERRC0100
               );

        If  ERRC0100.BytAvl > *Zero;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndDiagMsg( ERRC0100.MsgId
                    : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                    );

          SndEscMsg( 'CPF0011': '' );

        Else;
          ExSr  RtvAtrVal;
        EndIf;

        *InLr = *On;
        Return;


        BegSr  RtvAtrVal;

          If  OBJD0400.SrcFil_q = *Blanks;
            PxCmdStr += '?<SRCF(*BLANK) ';
          Else;
            PxCmdStr += '?<SRCF(' + %Trim( OBJD0400.SrcLib ) + '/' +
                                    %Trim( OBJD0400.SrcFil ) + ') ';
          EndIf;

          If  OBJD0400.SrcMbr = *Blanks;
            PxCmdStr += '?<SRCMBR(*BLANK) ';
          Else;
            PxCmdStr += '?<SRCMBR(' + %Trim( OBJD0400.SrcMbr ) + ') ';
          EndIf;

          If  OBJD0400.SrcChgDts = *Blanks;
            PxCmdStr += '?<SRCCHGDTS(*SAME) ';
          Else;
            PxCmdStr += '?<SRCCHGDTS(' +
                        %Char( %Date( OBJD0400.SrcChgDat: *CYMD0 ): *JOBRUN0 ) +
                        ' ' +
                        %Char( %Time( OBJD0400.SrcChgTim: *HMS0  ): *JOBRUN0 ) +
                        ') ';
          EndIf;

          If  OBJD0400.AlwChg = '1';
            PxCmdStr += '?<ALWCHG(*YES) ';
          Else;
            PxCmdStr += '?*ALWCHG(*NO) ';
          EndIf;

          If  OBJD0400.UsrAtr = *Blanks;
            PxCmdStr += '?<USRDFNATR(*BLANK) ';
          Else;
            PxCmdStr += '?<USRDFNATR(' + %Trim( OBJD0400.UsrAtr ) + ') ';
          EndIf;

          If  OBJD0400.TxtDsc = *Blanks;
            PxCmdStr += '?<TEXT(*BLANK) ';
          Else;
            PxCmdStr += '?<TEXT(''' + OBJD0400.TxtDsc + ''') ';
          EndIf;

        EndSr;

      /End-Free

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
