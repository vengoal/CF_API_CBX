     **-----------------------------------------------------------------------**
     **
     **  Compile options required:
     **    CrtBndRpg   Pgm( <library>/CBX903B )
     **                SrcFile( <library>/QRPGLESRC )
     **
     **-- Header Specifications:  --------------------------------------------**
     H DftActGrp( *No )
     **-- Global constants:
     ** See QSYSINC/MIH.MICPTCOM:
     D T_SIGNED        c                   x'00'
     D T_FLOAT         c                   x'01'
     D T_ZONED         c                   x'02'
     D T_PACKED        c                   x'03'
     D T_UNSIGNED      c                   x'0A'
     **-- Conversion template:
     D DPA_Template_T  Ds                  Based( pDPA )
     D  SclTyp                        1a
     D  RcvLen                        5i 0
     D   DecPos                       3i 0 Overlay( RcvLen: 1 )
     D   TotDig                       3i 0 Overlay( RcvLen: 2 )
     D  Rsv                          10i 0
     **
     D SrcTpl          s                   Like( DPA_Template_T )
     D TgtTpl          s                   Like( DPA_Template_T )
     **-- Late bound copy numeric variable:
     D LBCPYNV         Pr                  ExtProc( '_LBCPYNV' )
     D  Target                         *   Value
     D  Target_Tpl                         Const Like( DPA_Template_T )
     D  Source                         *   Value
     D  Source_Tpl                         Const Like( DPA_Template_T )
     **
     **-- - with rounding:
     D LBCPYNVR        PR                  extproc( '_LBCPYNVR' )
     D  Target                         *   Value
     D  Target_Tpl                         Const Like( DPA_Template_T )
     D  Source                         *   Value
     D  Source_Tpl                         Const Like( DPA_Template_T )
     **
     **-- Example structures:
     D SrcDs           Ds
     D  Fields25                     25a
     D  P12_3                        12p 3 Inz( -12345678.915 )
     **
     D TgtDs           Ds
     D  Fields38                     38a
     D  S11_2                        11s 2
     **
     C                   Eval      pDPA   = %Addr( SrcTpl )
     C                   Eval      SclTyp = T_PACKED
     C                   Eval      TotDig = 12
     C                   Eval      DecPos = 3
     C                   Eval      Rsv    = 0
     **
     C                   Eval      pDPA   = %Addr( TgtTpl )
     C                   Eval      SclTyp = T_ZONED
     C                   Eval      TotDig = 11
     C                   Eval      DecPos = 2
     C                   Eval      Rsv    = 0
     **
     C                   CallP     LBCPYNVR( %Addr( TgtDs ) + 38
     C                                     : TgtTpl
     C                                     : %Addr( SrcDs ) + 25
     C                                     : SrcTpl
     C                                     )
     **
      /free
            Dsply     ( %char( P12_3 ) + ' --> ' +  %char( S11_2 ) ) ;
      /end-free
     **
     C                   return
     **
