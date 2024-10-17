/*-------------------------------------------------------------------*/
/*                                                                   */
/* Compile options:                                                  */
/*                                                                   */
/*   CrtCmd Cmd( RTVASPINF )                                         */
/*          Pgm( CBX136 )                                            */
/*          SrcMbr( CBX136X )                                        */
/*          Allow((*IPGM) (*BPGM) (*IMOD) (*BMOD) (*IREXX) (*BREXX)) */
/*          HlpPnlGrp( CBX136H )                                     */
/*          HlpId( *CMD )                                            */
/*                                                                   */
/*-------------------------------------------------------------------*/
           Cmd     Prompt( 'Retrieve ASP Information' )

           Parm    ASP        *Int4                        +
                   Dft( *SYSASP )                          +
                   SpcVal(( *SYSASP   1 ))                 +
                   Range( 2  255 )                         +
                   Expr( *YES )                            +
                   Prompt( 'ASP number' )

           Parm    RTNASP     *Dec      (  3 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for RTNASP      (3 0)' )

           Parm    NBRUNIT    *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for NBRUNIT    (10 0)' )

           Parm    CAPTOT     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPTOT     (10 0)' )

           Parm    CAPAVL     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPAVL     (10 0)' )

           Parm    CAPTOTPTC  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPTOTPTC  (10 0)' )

           Parm    CAPAVLPTC  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPAVLPTC  (10 0)' )

           Parm    CAPTOTUNP  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPTOTUNP  (10 0)' )

           Parm    CAPAVLUNP  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for CAPAVLUNP  (10 0)' )

           Parm    SYSSTG     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for SYSSTG     (10 0)' )

           Parm    OFLSTG     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for OFLSTG     (10 0)' )

           Parm    THRESHOLD  *Dec      (  3 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for THRESHOLD   (3 0)' )

           Parm    ASPTYP     *Char        2               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for ASPTYP        (2)' )

           Parm    BALSTS     *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BALSTS        (1)' )

           Parm    BALTYP     *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BALTYP        (1)' )

           Parm    BALDATTIM  *Char       13               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BALDATTIM    (13)' )

           Parm    BALDTAMOV  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BALDTAMOV  (10 0)' )

           Parm    BALDTAREM  *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for BALDTAREM  (10 0)' )

           Parm    TRCSTS     *Char        1               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for TRCSTS        (1)' )

           Parm    TRCDUR     *Dec      ( 10 0 )           +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for TRCDUR     (10 0)' )

           Parm    TRCDATTIM  *Char       13               +
                   RtnVal( *YES )                          +
                   Prompt( 'CL var for TRCDATTIM    (13)' )

