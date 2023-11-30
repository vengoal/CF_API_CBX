/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX213X3                                           */
/*  Description : Query/400 RUNQRY Command Exit Program              */
/*  Author  . . : Carsten Flensburg                                  */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*  Program function:  This program retrieves the query name and     */
/*                     overrides the query printer file to use the   */
/*                     query name as the query printer output        */
/*                     spooled file name.  If no query name is       */
/*                     found, the query file name is used as the     */
/*                     spooled file name.                            */
/*                                                                   */
/*                     For the program to work as devised you must   */
/*                     register it for the retrieve command exit     */
/*                     point, following the instructions found       */
/*                     below.                                        */
/*                                                                   */
/*                                                                   */
/*  Exit program registration:                                       */
/*    In the following example library QGPL is specified as the      */
/*    exit program's library.  If you choose to place the CBX213X3   */
/*    RUNQRY command exit program elsewhere, please change the       */
/*    ADDEXITPGM command below accordingly.                          */
/*                                                                   */
/*    AddExitPgm   ExitPnt( QIBM_QCA_RTV_COMMAND )                   */
/*                 Format( RTVC0100 )                                */
/*                 PgmNbr( *LOW )                                    */
/*                 Pgm( QGPL/CBX213X3 )                              */
/*                 Text( 'Query/400 printer file override' )         */
/*                 PgmDta( *JOB 20 'RUNQRY    QSYS' )                */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX213X3 )                                    */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
    Pgm   &RTVC0100

    Dcl   &RTVC0100   *Char  1024

    Dcl   &ExpNam     *Char    20  Stg( *Defined )  Defvar( &RTVC0100   1 )
    Dcl   &ExpFmt     *Char     8  Stg( *Defined )  Defvar( &RTVC0100  21 )
    Dcl   &CmdNam     *Char    10  Stg( *Defined )  Defvar( &RTVC0100  29 )
    Dcl   &CmdLib     *Char    10  Stg( *Defined )  Defvar( &RTVC0100  39 )
    Dcl   &Resv       *Char     4  Stg( *Defined )  Defvar( &RTVC0100  49 )
    Dcl   &OfsOrgCmd  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  53 )
    Dcl   &LenOrgCmd  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  57 )
    Dcl   &OfsRplCmd  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  61 )
    Dcl   &LenRplCmd  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  65 )
    Dcl   &OfsPxyChn  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  69 )
    Dcl   &NbrPxyEnt  *Int      4  Stg( *Defined )  Defvar( &RTVC0100  73 )

    Dcl   &CmdStr     *Char   128
    Dcl   &DspOrgCmd  *Int      4
    Dcl   &Ofs        *Int      4
    Dcl   &QryDsp     *Int      4
    Dcl   &QryLen     *Int      4

    Dcl   &JobName    *Char    10
    Dcl   &UsrCls     *Char    10

    Dcl   &BATCH      *Char     1      '0'

    MonMsg   ( CPF0000  MCH0000 )


    If      (( &ExpNam = 'QIBM_QCA_RTV_COMMAND' )  *And        +
             ( &ExpFmt = 'RTVC0100' ))  Do

    If       ( &CmdNam = 'RUNQRY' )     Do

    RtvUsrPrf  UsrPrf( *CURRENT )  UsrCls( &UsrCls )

    If       ( &UsrCls = '*SECOFR' )    Do

    CallSubr   Subr( GetJobNam )

    OvrPrtF    QPQUPRFIL   SplfName( &JobName )  OvrScope( *JOB )
    EndDo
    EndDo
    EndDo

    Subr       Subr( GetJobNam )

      ChgVar     &DspOrgCmd  ( &OfsOrgCmd + 1 )
      ChgVar     &CmdStr     %Sst( &RTVC0100  &DspOrgCmd  &LenOrgCmd )

      DoFor      Var( &Ofs )  From( 7 )  To( 40 )  By( 1 )

      Select
      When     ( %Sst( &CmdStr  &Ofs  5 )  = ' QRY(' )       Do
      ChgVar     &QryDsp    ( &Ofs + 5 )
      EndDo

      When     ( %Sst( &CmdStr  &Ofs  10 ) = ' QRYFILE((' )  Do
      ChgVar     &QryDsp    ( &Ofs + 10 )
      EndDo

      When     ( %Sst( &CmdStr &Ofs 1 )    = '/' )           Do
      If       ( &QryDsp = 0 )    Leave

      ChgVar     &QryDsp    ( &Ofs + 1 )
      EndDo

      When     ( %Sst( &CmdStr &Ofs 1 )    = ')' )           Do
      If       ( &QryDsp = 0 )    Leave

      ChgVar     &QryLen    ( &Ofs - &QryDsp )
      ChgVar     &JobName    %Sst( &CmdStr  &QryDsp  &QryLen )

      Leave
      EndDo
      EndSelect

      EndDo

    EndSubr

    EndPgm
