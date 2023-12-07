/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKJOBS )                                          */
/*           Pgm( CBX232 )                                           */
/*           SrcMbr( CBX232X )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           VldCkr( CBX232V )                                       */
/*           MsgF( CBX232M )                                         */
/*           HlpPnlGrp( CBX232H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Jobs' )

             Parm       JOB         *Generic     10                  +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *CURRENT ))                +
                        Prompt('Job name')

             Parm       USER        *Generic     10                  +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *CURRENT ) ( *CURUSR ))    +
                        Prompt( 'User name' )

             Parm       STATUS      *Char        10                  +
                        Rstd(*YES)                                   +
                        Dft( *ACTIVE )                               +
                        SpcVal(( *ACTIVE ) ( *JOBQ ) ( *OUTQ )       +
                               ( *ALL ) ( *NONOUTQ ))                +
                        Prompt( 'Job status')

             Parm       JOBTYPE     *Char         1                  +
                        Rstd( *YES )                                 +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL    '*' )                       +
                               ( *AUTO   'A' )                       +
                               ( *BATCH  'B' )                       +
                               ( *INTER  'I' )                       +
                               ( *SBSMON 'M' )                       +
                               ( *SPLRDR 'R' )                       +
                               ( *SPLWTR 'W' )                       +
                               ( *SYS    'S' )                       +
                               ( *SCPF   'X' ))                      +
                        Prompt( 'Job type' )

             Parm       CURUSR      *Sname       10                  +
                        Dft( *NOCHK )                                +
                        SpcVal(( *NOCHK  ' ' ))                      +
                        PmtCtl( P0001 )                              +
                        Prompt( 'Current user' )

             Parm       ACTSTS      *Char        10                  +
                        Rstd( *YES )                                 +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL )                              +
                               ( *CNDW  CNDW )                       +
                               ( *DEQA  DEQA )                       +
                               ( *DEQW  DEQW )                       +
                               ( *DLYW  DLYW )                       +
                               ( *DSC   DSC  )                       +
                               ( *DSPA  DSPA )                       +
                               ( *DSPW  DSPW )                       +
                               ( *END   END  )                       +
                               ( *EOFA  EOFA )                       +
                               ( *EOFW  EOFW )                       +
                               ( *EOJ   EOJ  )                       +
                               ( *EVTW  EVTW )                       +
                               ( *GRP   GRP  )                       +
                               ( *HLD   HLD  )                       +
                               ( *HLDT  HLDT )                       +
                               ( *ICFA  ICFA )                       +
                               ( *ICFW  ICFW )                       +
                               ( *INEL  INEL )                       +
                               ( *JVAA  JVAA )                       +
                               ( *JVAW  JVAW )                       +
                               ( *LCKW  LCKW )                       +
                               ( *MSGW  MSGW )                       +
                               ( *MTXW  MTXW )                       +
                               ( *PRTA  PRTA )                       +
                               ( *PRTW  PRTW )                       +
                               ( *PSRW  PSRW )                       +
                               ( *RUN   RUN  )                       +
                               ( *SELW  SELW )                       +
                               ( *SEMW  SEMW )                       +
                               ( *SIGS  SIGS )                       +
                               ( *SIGW  SIGW )                       +
                               ( *SRQ   SRQ  )                       +
                               ( *THDW  THDW )                       +
                               ( *TIMA  TIMA )                       +
                               ( *TIMW  TIMW ))                      +
                        PmtCtl( P0002 )                              +
                        Prompt( 'Active status' )

             Parm       COMPSTS     *Char        10                  +
                        Rstd( *YES )                                 +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *NORMAL ) ( *ABNORMAL ))   +
                        PmtCtl( P0003 )                              +
                        Prompt( 'Completion status' )


P0001:       PmtCtl     Ctl( USER )                                  +
                        Cond(( *EQ '*CURUSR' ))

P0002:       PmtCtl     Ctl( STATUS )                                +
                        Cond(( *EQ '*ACTIVE' ))

P0003:       PmtCtl     Ctl( STATUS )                                +
                        Cond(( *EQ '*OUTQ' ))


             Dep        Ctl( &USER *NE '*CURUSR' )                   +
                        Parm(( CURUSR ))                             +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0101 )

             Dep        Ctl( &STATUS *NE '*ACTIVE' )                 +
                        Parm(( ACTSTS ))                             +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0106 )

             Dep        Ctl( &USER *EQ '*CURUSR' )                   +
                        Parm(( &STATUS *EQ '*ACTIVE' ))              +
                        NbrTrue( *EQ 1 )                             +
                        MsgId( CBX0102 )

             Dep        Ctl( &USER *EQ '*CURUSR' )                   +
                        Parm(( &CURUSR *EQ ' ' ))                    +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0103 )

             Dep        Ctl( &STATUS *NE '*OUTQ' )                   +
                        Parm(( COMPSTS ))                            +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0111 )

             Dep        Ctl( &JOB *EQ '*ALL' )                       +
                        Parm(( &USER *EQ '*ALL' )                    +
                             ( &STATUS *EQ '*ALL' ))                 +
                        NbrTrue( *LE 1 )                             +
                        MsgId( CBX0121 )

             Dep        Ctl( &JOB *EQ '*ALL' )                       +
                        Parm(( &USER *EQ '*ALL' )                    +
                             ( &STATUS *EQ '*OUTQ' ))                +
                        NbrTrue( *LE 1 )                             +
                        MsgId( CBX0122 )

