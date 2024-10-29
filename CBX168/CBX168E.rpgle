     **
     **  Program . . : CBX168E
     **  Description : Work with Data Queues - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : February 8, 2007
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX168E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX168E )
     **               Module( CBX168E )
     **               ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
     **-- UIM constants:
     D RES_OK          c                   0
     D RES_ERR         c                   1

     **-- UIM API return structures:
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  DtqNam_q                     20a
     D  DtqNam                       10a
     D  DtqLib                       10a
     D  DtqTyp                       10a
     D  DtqDsc                       50a

     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     **-- Action list option/Pull-down field choice:
     D Type5           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  LstNam                       10a
     D  LstEntHdl                     4a
     D  OptNbr                       10i 0
     D  FncQlf                       10i 0
     D  ActRes                       10i 0
     D  PdwFldNam                    10a

     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )

     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QUIGETLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  PosOpt                        4a   Const
     D  CpyOpt                        1a   Const
     D  SltCri                       20a   Const
     D  SltHdl                        4a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Update list entry:
     D UpdLstEnt       Pr                  ExtPgm( 'QUIUPDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  Option                        4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Remove list entry:
     D RmvLstEnt       Pr                  ExtPgm( 'QUIRMVLE' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )

     **-- Get object description:
     D GetObjDsc       Pr            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const

     **-- Entry parameters:
     D CBX168E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX168E         Pi
     D  PxUimExit                          LikeDs( UimExit )

      /Free

          If  PxUimExit.TypCall = 5;
            Type5 = PxUimExit;

            If  Type5.ActRes = RES_OK;

              Select;
              When  Type5.OptNbr = 4;
                ExSr  DltLstEnt;

              When  Type5.OptNbr = 13;
                ExSr  ChgLstEnt;
              EndSl;
            EndIf;
          EndIf;

        Return;


        BegSr  DltLstEnt;

          RmvLstEnt( Type5.AppHdl
                   : 'DTLLST'
                   : 'Y'
                   : Type5.LstEntHdl
                   : ERRC0100
                   );

        EndSr;

        BegSr  ChgLstEnt;

          GetLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type5.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );

          LstEnt.DtqDsc = GetObjDsc( LstEnt.DtqNam_q: '*DTAQ' );

          UpdLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'SAME'
                   : UIM.EntHdl
                   : ERRC0100
                   );

        EndSr;

      /End-Free

     **-- Get object description:
     P GetObjDsc       B
     D                 Pi            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  ObjDsc                       50a   Overlay( OBJD0200: 101 )

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
           Return  OBJD0200.ObjDsc;
         EndIf;

      /End-Free

     P GetObjDsc       E
