     **-----------------------------------------------------------------------**
     **
     **  Compile options required:
     **    CrtBndRpg   Pgm( <library>/CBX903A )
     **                SrcFile( <library>/QRPGLESRC )
     **
     **  Valid source string symbols:
     **    One sign symbol . :  - or +
     **    Decimal point . . :  .
     **    Comma . . . . . . :  ,
     **    Blank . . . . . . :  x'40
     **    Digit . . . . . . :  x'F0' - x'F9'
     **    Currency symbol as defined by mask
     **
     **-- Header Specifications:  --------------------------------------------**
     H DftActGrp( *No )
     **-- Global constants:
     D T_SIGNED        c                   x'00'
     D T_FLOAT         c                   x'01'
     D T_ZONED         c                   x'02'
     D T_PACKED        c                   x'03'
     D T_UNSIGNED      c                   x'0A'
     **-- Symbol mask:
     D Mask            Ds
     D  CurSym                        1a   Inz( '$' )
     D  ComSym                        1a   Inz( '.' )
     D  DecPntSym                     1a   Inz( ',' )
     **-- Conversion template:
     D DPA_Template_T  Ds
     D  SclTyp                        1a
     D  RcvLen                        5i 0
     D   DecPos                       3i 0 Overlay( RcvLen: 1 )
     D   TotDig                       3i 0 Overlay( RcvLen: 2 )
     D  Rsv                          10i 0 Inz
     **-- Convert external format to numeric:
     D CVTEFN          Pr                  ExtProc( '_CVTEFN' )
     D  RcvVar                         *   Value
     D  RcvAtr                             Const  Like( DPA_Template_T )
     D  Source                         *   Value
     D  SrcLen                       10u 0 Const
     D  SymMsk                             Const  Like( Mask )
     **
     D Source          s             25a   Inz( '-12.345.678,912' )
     D Packed          s             15p 4
     D Binary          s             10i 0
     **
     **-- Zoned & Packed:
     C                   Eval      SclTyp     = T_PACKED
     C                   Eval      DecPos     = %DecPos( Packed )
     C                   Eval      TotDig     = %Len( Packed )
     **
     C                   CallP     CVTEFN( %Addr( Packed )
     C                                   : DPA_Template_T
     C                                   : %Addr( Source )
     C                                   : %Len( %TrimR( Source ))
     C                                   : Mask
     C                                   )
     **
      /free
            Dsply     ( %Trim( Source ) + ' --> ' +  %char( Packed )) ;
      /end-free
     **-- Binary & Float:
     C                   Eval      SclTyp     = T_SIGNED
     C                   Eval      RcvLen     = %Size( Binary )
     **
     C                   CallP     CVTEFN( %Addr( Binary )
     C                                   : DPA_Template_T
     C                                   : %Addr( Source )
     C                                   : %Len( %TrimR( Source ))
     C                                   : Mask
     C                                   )
     **
      /free
            Dsply     ( %Trim( Source ) + ' --> ' +  %char( Binary )) ;
      /end-free
     **
     C                   Return
     **
