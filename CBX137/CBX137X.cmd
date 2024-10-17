/*-------------------------------------------------------------------*/
/*                                                                   */
/* Compile options:                                                  */
/*                                                                   */
/*   CrtCmd Cmd( RTVDSKATR )                                         */
/*          Pgm( CBX137 )                                            */
/*          SrcMbr( CBX137X )                                        */
/*          Allow((*IPGM) (*BPGM) (*IMOD) (*BMOD) (*IREXX) (*BREXX)) */
/*          HlpPnlGrp( CBX137H )                                     */
/*          HlpId( *CMD )                                            */
/*                                                                   */
/*-------------------------------------------------------------------*/
           Cmd     Prompt( 'Retrieve Disk Attributes' )

           Parm    DISK       *Char      10                +
                   Rstd( *YES )                            +
                   Dft( *FIRST )                           +
                   SpcVal(( *FIRST )  ( *NEXT ))           +
                   Expr( *YES )                            +
                   Prompt( 'Disk unit' )

           Parm    RTNUNIT    *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RTNUNIT    (10 0)' )

           Parm    ASPNBR     *Dec      (  3 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for ASPNBR      (3 0)' )

           Parm    TYPE       *Char        4               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for TYPE          (4)' )

           Parm    MODEL      *Char        4               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for MODEL         (4)' )

           Parm    SRLNBR     *Char       10               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for SRLNBR       (10)' )

           Parm    RSRCNAME   *Char       10               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RSRCNAME     (10)' )

           Parm    DISKCAP    *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for DISKCAP    (10 0)' )

           Parm    STGAVL     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for STGAVL     (10 0)' )

           Parm    STGSYS     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for STGSYS     (10 0)' )

           Parm    MIRUNITPTC *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for MIRUNITPTC    (1)' )

           Parm    MIRUNITRPT *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for MIRUNITRPT    (1)' )

           Parm    MIRUNITSTS *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for MIRUNITSTS    (1)' )

           Parm    UNITCTL    *Dec      (  2 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for UNITCTL     (2 0)' )

           Parm    BLKTFRTO   *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BLKTFRTO   (10 0)' )

           Parm    BLKTFRFRM  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BLKTFRFRM  (10 0)' )

           Parm    RQSDTATO   *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RQSDTATO   (10 0)' )

           Parm    RQSDTAFRM  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RQSDTAFRM  (10 0)' )

           Parm    PERMBLKFRM *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for PERMBLKFRM (10 0)' )

           Parm    RQSPERMFRM *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RQSPERMFRM (10 0)' )

           Parm    SAMPLECNT  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for SAMPLECNT  (10 0)' )

           Parm    NOTBUSYCNT *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for NOTBUSYCNT (10 0)' )

           Parm    COMPSTS    *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for COMPSTS       (1)' )

           Parm    DISKPTCTYP *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for DISKPTCTYP    (1)' )

