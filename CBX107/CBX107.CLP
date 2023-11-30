/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX107 and CBX107O                                 */
/*  Description : Set profile exit program command                   */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : Club Tech iSeries Programming Tips Newsletter      */
/*  Date  . . . : September 4, 2003                                  */
/*                                                                   */
/*  Program function:  SETPRFEXIT command processing program         */
/*                                                                   */
/*                                                                   */
/*  Program summary                                                  */
/*  ---------------                                                  */
/*                                                                   */
/*  Work management APIs:                                            */
/*    QWTSETPX       Set profile exit   Sets for a user profile      */
/*                   program            the exit program to call     */
/*                                      defined by the specified     */
/*                                      format and the values of     */
/*                                      the exit flags.              */
/*                                                                   */
/*    QWTRTVPX       Retrieve profile   Retrieves the values of      */
/*                   exit program       the exit flags currently     */
/*                                      set for the user profile     */
/*                                      and the exit point format    */
/*                                      specified.                   */
/*                                                                   */
/*    QMHMOVPM       Move program       Moves one or more program    */
/*                   message            messages of the specified    */
/*                                      message type(s) to the       */
/*                                      specified earlier call       */
/*                                      level.                       */
/*                                                                   */
/*                                      Message sender information   */
/*                                      is not changed by the API,   */
/*                                      but escape messages are      */
/*                                      automatically changed to     */
/*                                      diagnostic messages.         */
/*                                                                   */
/*    QMHRSNEM       Resend escape      Resends an escape message    */
/*                   message            from the current call level  */
/*                                      to a specified earlier call  */
/*                                      level.                       */
/*                                                                   */
/*                                      During this process the      */
/*                                      generated exception will be  */
/*                                      percolated back to that call */
/*                                      level.                       */
/*                                                                   */
/*                                                                   */
/*  Programmer's notes:                                              */
/*    Currently supported by the profile exit APIs are the           */
/*    preattention and presystem request exit points                 */
/*    QIBM_QWT_PREATTNPGMS respectively QIBM_QWT_SYSREQPGMS.         */
/*    Both are managed through either the WRKREGINF facility         */
/*    or the ADDEXITPGM and RMVEXITPGM commands.                     */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm   Pgm( CBX107 )                                       */
/*               SrcFile( QCLSRC )                                   */
/*               SrcMbr( *PGM )                                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm      ( &UsrPrf                +
                &XitFmt                +
                &XitOpt                +
              )

/*-- Parameters:  ---------------------------------------------------*/
     Dcl        &UsrPrf      *Char    10
     Dcl        &XitFmt      *Char     8
     Dcl        &XitOpt      *Char    34

     Dcl        &PgmNbr      *Char     4   x'00000008'
     Dcl        &Flags       *Char    32

/*-- Global error monitoring:  --------------------------------------*/
     MonMsg     CPF0000      *N        GoTo Error


     RtvUsrPrf  &UsrPrf       RtnUsrPrf( &UsrPrf )

     ChgVar     &Flags        %Sst( &XitOpt  3  32 )

     Call       QWTSETPX    ( &PgmNbr            +
                              &Flags             +
                              &XitFmt            +
                              &UsrPrf            +
                              x'00000000'        +
                            )

     SndPgmMsg  Msg( 'Profile exit programs have been set.' )   +
                MsgType( *COMP )

 Return:
     Return

/*-- Error handling:  -----------------------------------------------*/
 Error:
     Call      QMHMOVPM    ( '    '                                  +
                             '*DIAG'                                 +
                             x'00000001'                             +
                             '*PGMBDY'                               +
                             x'00000001'                             +
                             x'0000000800000000'                     +
                           )

     Call      QMHRSNEM    ( '    '                                  +
                             x'0000000800000000'                     +
                           )

 EndPgm:
     EndPgm
