/*********************************************************************/
/*  All right, title and interest in and to the software             */ 
/*  (the "Software") and the accompanying documentation or           */ 
/*  materials (the "Documentation"), including all proprietary       */ 
/*  rights, therein including all patent rights, trade secrets,      */ 
/*  trademarks and copyrights, shall remain the exclusive            */ 
/*  property of Hewlett-Packard Development Company, L.P.            */ 
/*  No interest, license or any right respecting the Software        */ 
/*  and the Documentation, other than expressly granted in           */ 
/*  the Software License Agreement, is granted by implication        */ 
/*  or otherwise.                                                    */ 
/*                                                                   */
/*  (C) Copyright 2000-2012 Hewlett-Packard Development Company, L.P.*/
/*  All rights reserved.                                             */
/*********************************************************************/
/*********************************************************************/
/*  Name        : CheckStandards.rex                                 */
/*  Description : This REXX utility will enforce various COBOL       */
/*                programming standards.  Standards violations       */
/*                are written to filename.STD report file in the     */
/*                same directory as filename.                        */
/*                                                                   */
/*  Arguments   : filename      - file name                          */
/*                                                                   */
/*  Example     : rexx CheckStandards m:\ut\server\srce\CSDF0230.cbl */
/*                                                                   */
/*********************************************************************/
/*********************************************************************/
/*                                                                   */
/*  2013-11 - PB - Add OS/400 to valid tags                          */
/*  2013-12 - PB - Update script with code from 7.4 version          */
/*  2014-03 - PB - Add DBSRCE modules to TIMR_exception list         */
/*                                                                   */
/*********************************************************************/
/*********************************************************************/

if arg(1) = '?' then
  do i = 1 to 100
    if left(sourceline(i),2) = '/*' then
      say sourceline(i)
    else
      exit
  end

debug = value('CHECKDEBUG',,'ENVIRONMENT')
if debug = 'ON' then trace ?I

parse upper arg filename options

/*
**  Determine execution environment:
**  1) invoked as rexx routine or SPF edit macro
**  2) check filename based on execution environment
*/

   parse source env type pgmName

   if word(pgmName,words(pgmName)) = 'ISREDIT' then
      sw_cmd = 'spf'
   else
      sw_cmd = 'cmd'

if pos( "S", options ) > 0 then
  sw_screen = 1
else
  sw_screen = 0

call Check_filename

say "Checking member: " filename

/*
**  Initialize variables
*/

/* bypassPS switched to bypass checking. Can be removed when system fully complies with standards */
bypassPS = 1     /* matching PS */

byPass9990 = 0   /* 9990 paragraph */
returnCd = 0
ctr_pgm_exit = 0
ctr_record = 0
ctr_error  = 0
ctr_tag  = 0
ctr_if = 0
ctr_evaluate = 0
ctr_paragraph_lines = 0
ctr_paragraph = 0
ctr_perform = 0
sw_eof   = 0
sw_skip_read = 0
exit_paragraph = ""
exit_perform = ""
last_seq = ""
flowerbox_processed = 0
reading_flowerbox = 0
reading_flowerbox_updates = 0
reading_flowerbox_member = 0
flowerbox.0 = 0
ctr_flowerbox_lines = 0
MemberNameFound = 0
RemarksFound = 0
DomainFound = 0
ClassFound = 0
ChangesSectionFound = 0
P9990_Found = 0
tag_found = 0
All_Keywords_Found = 0
XCWWPGWS_Found = 0
XCWWCRHT_Found = 0
pre_flowerbox_record.0 = 0
pre_flowerbox_record_num.0 = 0
isOnline = 0
CPL.0 = 0
CPS.0 = 0
P0000. = 0
in9990 = 0
inCopyReplacing = 0
inWS = 0
P0000_exception = 'XCWLCOMM XCWL0003 CCWLPGAL CCWLACCT CCWLPGA XCWL0035 CCWL7515 CCWL7516 CCWLFPA CCWLOPDU FCWLFUND NCWLBGND NCWLMIBO SCWLSEGF XCWL0510 XCWLBUFR XCWLDTLK XCWLSIR'
TIMR_Found = 0
/* TIMR_exception = 'SRQ SDU' */
TIMR_exception = "SRQ SDU SIA SIB SIC SID SIF SIG SIK SIN SIT SIU SIV"

msgsField = 'L0760-MESSAGE-NUMBER',
            'LADDV-ADPROV-MSG',
            'LADDV-ADPSTL-MSG',
            'LADDV-MUNICP-MSG',
            'LADDV-PARISH-MSG',
            'LADDV-RESTYP-MSG',
            'LADDV-CLNY-TXT-MSG',
            'R1470-MESSAGE-NUMBER',
            'R1480-MESSAGE-NUMBER',
            'WGLOB-MSG-REF-INFO',
            'WS-DEL-PRINT-MSG',
            'WS-ERR-MSG (WS-INDX)',
            'WS-MSG-REF-ERR',
            'WS-MSG-REF-PRCESD',
            'WS-MSG-REF-RQST',
            'WS-RDALG-KEY'

if sw_cmd = 'cmd' then
   call Process_Cmd
else
   call Process_Spf

name = Filespec( "name", filename )
parse var name name58 "." .
name58 = Substr( name58, 5 )

call check_exceptions
if result = 'y' then do
   call no_standard
   exit 99
end

if translate(Substr( name, 3, 1 )) = "B" ,
 | translate(Substr( name, 3, 1 )) = "R" then
   isOnline = 0
else
   isOnline = 1

if translate(Substr( name, 2, 1 )) = "C" then do
   sw_copy_member = 1
   byPass9990 = 1
end
else
   sw_copy_member = 0

if translate(Substr( name, 2, 3 )) = "SRQ" then do
   byPass9990 = 1
end

if translate(Substr( name, 2, 2 )) = "SI" then do
   byPass9990 = 1
end

if translate(Left( name, 8 )) = "XSOM0010" then do
   bypass9990 = 1
end

/*
**  Retrieve all records before the flower box
*/
do until reading_flowerbox | sw_eof
   call Get_Next_Record
end

if sw_eof then do
   call Missing_flowerbox
   exit 99
end
/*
**  Retrieve the flower box
*/
do until \reading_flowerbox | sw_eof
   call process_FlowerBox
   call Get_Next_Record
end

if sw_eof then do
   call Missing_flowerbox
   exit 99
end

/*
**  Check lines saved before flowerbox
*/

i = 1
saved_record = record
saved_ctr_record = ctr_record
do while i <= pre_flowerbox_record.0
   record = pre_flowerbox_record.i
   ctr_record = pre_flowerbox_record_num.i
   call Validate_Tag
   i = i + 1
end
record = saved_record
ctr_record = saved_ctr_record

/*
**  Retrieve the next record to process
*/


if \sw_copy_member then do
   do until paragraph = "PROCEDURE" | sw_eof
      if wordpos('COMP',record) > 0 | wordpos('COMP.',record) > 0 then do
         msg = "COMP found. Please use BINARY."
         call Error_Routine
      end

      call Get_Next_Record
   end

   if paragraph = "PROCEDURE" then
      call Get_Next_Record
end

/* call Get_Next_Record */

/*
**  Process remaining records in the file
*/

do while \sw_eof

   call General_Edits


   /*
   ** working storage copybook has no paragraph name
   */
   if wordPos(substr(name,2,2),"CW CS CF ") > 0 then
      nop
   else do
       if paragraph <> ""       then call Process_Paragraph

       if verb = "EXIT"         then call Process_EXIT
       if verb = "IF"           then call Process_IF
       if verb = "END-IF"       then call Process_END_IF
       if verb = "EVALUATE"     then call Process_EVALUATE
       if verb = "END-EVALUATE" then call Process_END_EVALUATE
       if verb = "PERFORM"      then call Process_PERFORM
       if verb = "GO"           then call Process_GO
       if verb = "COPY"         then call Process_COPY
       if verb = "MOVE"         then call Process_MOVE
   end

   if sw_sentence           then call Process_Sentence

   call Get_Next_Record

end

   call Keyword_Validation
/* call CheckUnsedTags  */
call CheckPS
call Check9990
call Check0000
call CheckTIMR
call Display_Errors

   message = "Checking completed with" ctr_error "error(s)"
   if sw_cmd = 'cmd' then
      say message
   else do
      'ISREDIT LINE_AFTER 0 = NOTELINE "'message'"'
      'ISREDIT locate special'
      'ISREDIT locate special'
   end

return returnCd
/*
**********************************************************************
**  Invoked as a Rexx command file, get the filename
**********************************************************************
*/
Process_Cmd:
/* *******************************************************************
**  if no parameter supplied, prompt for a file name
********************************************************************** */
   do while filename = ""
      Say "Enter a filename name to test:"
      Pull filename .
   end
   filename = Translate( filename )
/*
**  Make sure the file exists
*/
   if Stream( filename, "C", "Query Exists" ) = "" then do
      say "Filename (" || filename || ") not found"
      exit 99
   end

return
/*
**********************************************************************
**  Invoked as a SPF edit macro, get the filename and set up for SPF
**********************************************************************
*/
Process_Spf:

'ISREDIT MACRO NOPROCESS (PARM)'
'ISPEXEC CONTROL ERRORS CANCEL'
'ISREDIT (filename) = DATASET'
'ISREDIT RESET SPECIAL'

'ISREDIT (modified) = DATA_CHANGED'
if (modified=YES) then
   'ISREDIT SAVE'

ZEDLMSG = 'Executing ' || word(pgmName,1)
'ISPEXEC SETMSG MSG(ISRZ000)'

return
/*
**********************************************************************
**  General edits
**********************************************************************
*/
General_Edits:
/*
**  Check for code in area A
*/
   if Substr( record, 1, 1 ) = ' ' & Substr( record, 2, 3 ) <>  '   ' then do
      msg = "code found in columns 9-11"
      call Error_Routine
   end
/*
**  Check for a space after a comma
*/
   pos = Pos( ",", record )
   quotes = 0

   i = pos - 1
   do while i >= 8
      if substr(record,i,1) = "'" then do
         quotes = quotes + 1
         if quotes = 2 then do
            quotes = 0
         end
      end
      i = i - 1
   end

   if substr(name,2,2) <> 'CW' ,
   &  pos > 0 ,
   &  quotes = 0 then do
      if Substr( record, pos + 1, 1 ) <> " " then do
         msg = "a space must follow a comma"
         call Error_Routine
      end
   end

   if word(record,1) = 'GOBACK' ,
   |  word(record,1) = 'STOP' then do
      ctr_pgm_exit = ctr_pgm_exit + 1
      if ctr_pgm_exit > 1 then do
         msg = "Multiple Program Exits not allowed"
         call Error_Routine
      end
   end

return
/*
**********************************************************************
**  Process paragraph name found
**********************************************************************
*/
Process_Paragraph:

   current_paragraph = paragraph
   ctr_paragraph = ctr_paragraph + 1
   ctr_perform = 0

   if paragraph = '9990-INIT-WORKING-STORAGE' then do
      in9990 = 1
   end

   if paragraph = '9990-INIT-WORKING-STORAGE-X' then do
      in9990 = 0
   end

/*
**  Validate new paragraph name
*/
   if exit_paragraph = "" then do
      ctr_paragraph_lines = 0
      call Validate_Paragraph
      exit_paragraph = paragraph || "-X"
      return
   end
/*
**  Check for dummy paragraphs
*/
   if ctr_paragraph_lines = 1 then do
      msg = "dummy paragraph found (" paragraph ")"
      call Error_Routine
      return
   end
/*
**  Check for matching paragraph name with a '-X' suffix
*/
   if paragraph <> exit_paragraph then do
      msg = "exit paragraph name (" paragraph ") should be:" exit_paragraph
      call Error_Routine
      return
   end
/*
**  Matching paragraph name found, check for EXIT statement
*/
   call Get_Next_Record
   if verb =  "GOBACK" & exit_paragraph = "0000-MAINLINE-X" then
      nop
   else do
      if verb <> "EXIT" then do
         msg = "EXIT verb must follow paragraph name (" exit_paragraph ")"
         call Error_Routine
         sw_skip_read = 1
      end
   end
/*
**  Reset, so we can process the next paragraph
*/
   exit_paragraph = ""

return
/*
**********************************************************************
**  Validate paragraph name for copy/source member
**********************************************************************
*/
Validate_Paragraph:

/*
** working storage copybook has no paragraph name
*/
   temp = Translate( paragraph, " ", "-" )

   if sw_copy_member then do
      call Validate_Copy
      seq = Word( temp, 2 )
   end
   else do
      seq = Word( temp, 1 )
   end
/*
**  Validate sequence number component of paragraph name
*/
   if Datatype( seq ) = "CHAR" | Length( seq ) <> 4 then do
      msg = "paragraph sequence (" seq ") must be 4 numeric digits"
      call Error_Routine
      return
   end

   if seq <= last_seq then do
      msg = "change paragraph ordering - sequence (" seq ") should be > (" last_seq ")"
      call Error_Routine
      return
   end

   last_seq = seq

return


Validate_Copy:

   t1 = Word( temp, 1 )

   if t1 <> name58 ,
   &  left(t1,1) <> ':' then do
      msg = "paragraph qualifier (" t1 ") should be (" name58 ")"
      call Error_Routine
      return
   end

return
/*
**********************************************************************
**  EXIT processing
**********************************************************************
*/
Process_EXIT:

   exit_paragraph = ""

return

/*
**********************************************************************
**  Flower Box Processing
**********************************************************************
*/
Process_FlowerBox:

  parse upper var record '**' word1 word2 word3
  if substr(word1,1,6) = "MEMBER" then do
        MemberNameFound = 1
        parse var record ":" MemberName RestOfMemberLine
        if MemberName = "" then do
            parse var record "MEMBER" MemberName RestOfMemberLine
        end
        MemberName = strip(translate(MemberName,' ','.'))
        mStrippedName = strip(substr(name,1,lastpos('.',name)-1))
        if (mStrippedName <> MemberName) then do
           msg = "Module name <"||mStrippedName||"> different from flowerbox name <"||MemberName||">"
           call Error_Routine
        end
  end

  if substr(word1,1,7) = "REMARKS" then do
        RemarksFound = 1
  end

  if substr(word1,1,6) = "DOMAIN" then do
        DomainFound = 1
        parse var record ":" DomainName RestOfDomainLine
        if DomainName = "" then do
            parse var record "DOMAIN" DomainName RestOfDomainLine
        end
        if (Pos(DomainName, 'ACAGATBCCLCMCVPOPRRISYTXUW' ) > 0) then nop
        else do
           msg = "Incorrect domain name specified: <"||DomainName||">"
           call Error_Routine
        end
  end
/* **********************************************************************
**       List of valid Domains
**         AC              ACCOUNTING
**         AG              AGENCY
**         AT              ACTUARIAL/VALUATION
**         BC              BILLING AND COLLECTION
**         CL              CLIENT
**         CM              CLAIMS
**         CV              COVERAGE
**         PO              POLICY
**         PR              PRODUCT
**         RI              REINSURANCE
**         SY              SYSTEM (includes TPI and security)
**         TX              TAX
**         UW              UNDERWRITING
** **********************************************************************
*/

  if substr(word1,1,5) = "CLASS" then do
        ClassFound = 1
        msg = "Class is obsolete"
        call Error_Routine
  end

/*
  Sep 2000, Luis Sanchez.
  Added 'else' statements to make them nested 'IFs'.
*/

  if word1 = "RELEASE" & word2 = "DESCRIPTION" then do
        ChangesSectionFound = 1
  end
/*else
    if (substr(word1,1,4) = "DATE" & substr(word2,1,4) = "AUTH") then do
          ChangesSectionFound = 1
    end
    else
      if (substr(word1,1,4) = "DATE" & substr(word2,1,3) = "REL") then do
            ChangesSectionFound = 1
      end
*/
  if ChangesSectionFound  then do
      if Substr( record, 7, 50) = copies("*",50) then do
         flowerbox_processed = 1
         reading_flowerbox = 0
      end
      if Substr( record, 1, 6) <> "      " then do
         call Collect_Tag
      end
  end

return

/*
***************************************
** Logic for Collecting tag information
***************************************
*/
Collect_Tag:

        tag_found = 0
        ws_sub = 1
        do until tag_found | ws_sub > ctr_tag
                if Substr( record, 1,6) == tag.ws_sub then do
                        tag_found = 1
                end
                else do
                        ws_sub = ws_sub + 1
                end
        end

        if \tag_found  then do
                ctr_tag = ctr_tag + 1
                tag.ctr_tag = Substr( record, 1, 6)
                tagUsed.ctr_tag = ''
                tagLineNum.ctr_tag = ctr_record
        end

return
/*
***************************************
** Logic for Validating tag information
***************************************
*/
Validate_Tag:

if reading_flowerbox  then return

if \flowerbox_processed then do
   i = pre_flowerbox_record.0 + 1
   pre_flowerbox_record.i = record
   pre_flowerbox_record_num.i = ctr_record
   pre_flowerbox_record.0 = i
   return
end

/* SEP 2000, Luis Sanchez:  Add NTDEV, NTPROD to valid tags                           */
/* NOV 2013, Phil Beeney:  Add OS/400 to valid tags                                   */
/* old line:  if wordPos(strip(Substr( record, 1,6)),"DB2 MVS NT") > 0 then return    */
/* old line:  if wordPos(strip(Substr( record, 1,6)),"DB2 MVS EBCDIC ASCII MVSCIC NT NTPROD NTDEV PROD DEVENV VACOB") > 0 then return */
/* old line:  if wordPos(strip(Substr( record, 1,6)),"NONZOS ZOS DEVENV PROD ASCII EBCDIC OS400 VACOB") > 0 then return */
/* new line:                                                                          */
              if wordPos(strip(Substr( record, 1,6)),"NONZOS ZOS DEVENV PROD ASCII EBCDIC OS400 VACOB OS/400") > 0 then return
/* end of change */

tag_found = 0
ws_sub = 1
do until tag_found | ws_sub > ctr_tag
  if compare(Substr( record, 1,6),tag.ws_sub) = 0 then do
          tag_found = 1
          tagUsed.ws_sub = 'Y'
  end
  else do
          ws_sub = ws_sub + 1
  end
end

if \tag_found  then do
  msg = "Invalid TAG found <" ||substr( record, 1, 6) ||">.  Tag needs to be in flower box to be valid."
  call Error_Routine
end

return

/*
**********************************************************************
**  IF processing
**********************************************************************
*/
Process_IF:

   ctr_if = ctr_if + 1
/*
** If statements should only be nested to 3 levels
*/
   if ctr_if > 3 then do
      msg = "IF structure is nested to (" ctr_if ") levels"
      call Error_Routine
   end

   t1 = Wordpos( 'OR', record ) + 0
   if t1 > 0 & t1 < Words( record ) then do
   /* work around for SPF */
      if Word( record, t1 ) = 'OR' then do
         msg = "IF condition should be split onto two lines"
         call Error_Routine
      end
   end

   t1 = Wordpos( 'AND', record )
   if t1 > 0 & t1 < Words( record ) then do
   /* work around for SPF */
      if Word( record, t1 ) = 'AND' then do
         msg = "IF condition should be split onto two lines"
         call Error_Routine
      end
   end

return
/*
**********************************************************************
**  END_IF processing
**********************************************************************
*/
Process_END_IF:

   ctr_if = ctr_if - 1

return
/*
**********************************************************************
**  EVALUATE processing
**********************************************************************
*/
Process_EVALUATE:

   ctr_evaluate = ctr_evaluate + 1
/*
** Evaluate statements should only be nested to 2 levels
*/
   if ctr_evaluate > 2 then do
      msg = "EVALUATE structure is nested to (" ctr_evaluate ") levels"
      call Error_Routine
   end

return
/*
**********************************************************************
**  END_EVALUATE processing
**********************************************************************
*/
Process_END_EVALUATE:

   ctr_evaluate = ctr_evaluate - 1

return
/*
**********************************************************************
**  PERFORM processing
**********************************************************************
*/
Process_PERFORM:

    ctr_perform = ctr_perform + 1

/*
**  Inline perform, no checking required
*/
   if Words( record ) = 1 then return

/*
**  check position of 9990
*/
   t2 = Word( record, 2 )

   if left(t2,5) = 'TIMR-' then do
      TIMR_Found = 1
   end

   if t2 = '9990-INIT-WORKING-STORAGE' then do
      Call Check9990Position
   end

   if in9990 then do
      found = 0
      if word(record,1) = 'PERFORM' ,
      &  pos('-0000-INIT-PARM-INFO',word(record,2)) > 0 then do
         tmpLine = translate(word(record,2),' ','-')
         i = 1
         do while i <= P0000.0
            if P0000.i = word(tmpLine,1) then do
               found = 1
               P0000.i = ''
               i = P0000.0
            end
            i = i + 1
         end
      end
   end
/*
**  Append '-X' to build the exit paragraph name
*/
   exit_perform = Word( record, 2 ) || "-X"
/*
**  Normal perform, check for THRU statement
*/
   call Get_Next_Record
   if verb <> "THRU" then do
      msg = "THRU" exit_perform "must follow PERFORM from above line"
      call Error_Routine
      sw_skip_read = 1
      return
   end
/*
**  Validate THRU paragraph name
*/
   t1 = changestr('.',Word( record, 2 ),'')

   if t1 <> exit_perform then do
      msg = "THRU paragraph name should be (" exit_perform ")"
      call Error_Routine
      return
   end

return
/*
**********************************************************************
**  GO TO processing
**********************************************************************
*/
Process_GO:
/*
** Can only GO TO the current exit paragraph name
*/
   t1 = Word( record, 3 )
   if t1 <> exit_paragraph then do
      msg = "GO TO paragraph name should be (" exit_paragraph ")"
      call Error_Routine
      return
   end

return
/*
**********************************************************************
**  COPY processing
**********************************************************************
*/
Process_COPY:
/*
** Copy members of the form xCPPnnnn must match chars 5-8 of the member name
*/
   t1 = changestr('.',Word( record, 2 ),'')

   if Substr( t1, 2, 3 ) = "CCP" then do
      if pos('REPLACING',record) > 0 then do
         msg = "COPY REPLACING cannot be used with CICS Processing copybook (CCP)"
         call Error_Routine
      end
   end

   if Substr( t1, 2, 3 ) = "CPL" then do
      i = CPL.0 + 1
      CPL.i = t1
      CPLLineNum.i = ctr_record
      CPL.0 = i
      return
   end

   if Substr( t1, 2, 3 ) = "CPS" then do
      i = CPS.0 + 1
      CPS.i = changestr('CPS',t1,'CPL')
      CPSLineNum.i = ctr_record
      CPS.0 = i
      return
   end

   if Substr( t1, 2, 3 ) <> "CPP" then return

   t2 = Substr( t1, 5 )
   if Datatype( t2 ) <> "NUM" then return

   if t2 <> name58 then do
      msg = "invalid copy member (" t1 ") use xCCLnnnn or xCPLnnnn"
      call Error_Routine
      return
   end

return
/*
**********************************************************************
**  MOVE processing
**********************************************************************
*/
Process_MOVE:

select
  when wordpos(Word(record,4),msgsField) > 0 then
  do
    msgRef = Word( record, 2 )
    if left(msgRef,1) \= "'" then return
    msgRef = strip(msgRef,'B',"'")

    /*
    ** msg-ref-num must be numeric, max 4 characters
    */

    if datatype(right(msgRef,4)) <> 'NUM' then do
       msg = "Message ref number must be numeric (" msgRef ")"
       call Error_Routine
       return
    end

    if length(msgRef) > 10 then do
       msg = "Message source (" msgRef ") exceeded 10 characters"
       call Error_Routine
       return
    end
    /*
    ** The message source must be generic or match chars 5-8 of the member name
    */
    if left(msgRef,6) \= left(name,2)||name58 & substr(msgRef,3,4) \= '0000' & wordpos(msgRef,msgs_exception) = 0 then do
       msg = "Invalid message source (" msgRef ") must be generic or match chars 5-8 of the member name"
       call Error_Routine
       return
    end
  end

  otherwise nop
end

return
/*
**********************************************************************
**  End of SENTENCE processing
**********************************************************************
*/
Process_Sentence:
/*
**  End-If must be used with all If statements
*/
   if ctr_if <> 0 then do
      msg = "IF structure is missing END-IF"
      call Error_Routine
   end
/*
**  End-Evaluate must be used with all Evaluate statements
*/
   if ctr_evaluate <> 0 then do
      msg = "EVALUATE structure is missing END-EVALUATE"
      call Error_Routine
   end
/*
**  Reset counters
*/
   ctr_if = 0
   ctr_evaluate = 0

return
/*
**********************************************************************
**  Get the next record to process
**********************************************************************
*/
Get_Next_Record:
/*
**  Some edits require prereading of a record. When the edit fails the
**  skip_read switch is set so we can process the current record.
*/
   if sw_skip_read then do
      sw_skip_read = 0
      return
   end
/*
**  Read until we find a record to process
*/
   sw_good_record = 0
   do until sw_good_record
      call Read_Record
   end

   if sw_eof then return

   if \flowerbox_processed then do
      if Substr( record, 7, 50) = "**************************************************" then do
         reading_flowerbox = 1
      end
   end

   if reading_flowerbox then do
      return
   end

   record_in = record
/*
**  End of a sentence is indicated by a period as the last character
**  of the record
*/
   if Right( strip(record,'t'), 1 ) = "." then sw_sentence = 1
   else                             sw_sentence = 0
/*
**  Convert characters to upper case, truncate leading 7 characters
**  and trailing period
*/
   record = Translate( Substr( record, 8, len - 7 - sw_sentence ) )
/*
**  The first word in the record will be either a paragraph name or
**  a COBOL verb
*/
   if Substr( record, 1, 1 ) <> " " then do
      paragraph = Word( record, 1 )
      verb = ""
   end
   else do
      verb = Word( record, 1 )
      paragraph = ""
   end

   if word(record,1) = 'WORKING-STORAGE' then do
      inWS = 1
   end

   if word(record,1) = 'LINKAGE' ,
   |  word(record,1) = 'PROCEDURE' then do
      inWS = 0
   end

   if paragraph = "COPY" then do
      verb = paragraph
      paragraph = ""

      if word(record,3) = 'REPLACING' then do
         inCopyReplacing = 1
      end

      if inCopyReplacing then do
         if right(strip(record_in,'T'),1) = '.' ,
         &  substr(record_in,7,1) = ' ' then do
            inCopyReplacing = 0
         end
      end

      if inWS then do
         t1 = word(record,2)
         if Substr( t1, 2, 3 ) = "CWL" ,
         &  wordpos(t1,P0000_exception) = 0 & translate(Substr(name,2,2)) \= "SI" then do
            i = P0000.0 + 1
            P0000.i = substr(t1,5)
            P0000.0 = i
            return
         end
      end
   end
   else do
      if inCopyReplacing then do
         if right(strip(record_in,'T'),1) = '.' ,
         &  substr(record_in,7,1) = ' ' then do
            inCopyReplacing = 0
         end
      end
   end

/*
**  Count lines for current paragraph
*/
   ctr_paragraph_lines = ctr_paragraph_lines + 1

return
/*
**********************************************************************
**  Read one record at a time
**********************************************************************
*/
Read_Record:
/*
**  Set switch when end-of-file is encountered
*/
   if Lines(filename) = 0 then do
      call Stream filename, "C", "Close"
      sw_eof = 1
      sw_good_record = 1
      return
   end
/*
**  Count number of records read
*/
   record = Linein(filename)
   ctr_record = ctr_record + 1

/*
**  Check for NULL characters in the record
*/

   stp = length(record)
   if stp \= 0 then do
       counter = 1
       do while counter <= stp
           mChar = Substr(record, counter, 1)
           mHex = c2x(mChar)
           if pos('00', mHex) then do
              msg = "Null Character Found"
              call Error_Routine
           end
           counter = counter + 1
       end
   end

/*
**  Check for tab characters in the record
*/
   if Pos( "09"x, record ) > 0 then do
      msg = "Tab character found on line"
      call Error_Routine
   end
/*
**  Check for a valid tag
*/
   tag = substr( record, 1,6)
   if \reading_flowerbox then do
      if tag \= '      ' then do
         call Validate_Tag
      end
   end
/*
** if reading flower box records, add the tag to the collection
** otherwise search for the tag in the collection.
**
** if not found, write out an error message.
*/

/*
**  Check the length of the record
*/
   len = Length(record)
   if (len < 8) then return

   if (strip(substr(record,73)) <> '') then do
     msg = "Code found past column 72"
     call Error_Routine
   end

/*
**  Check for mixed case letters
*/
parse upper var record temprecord

if record <> temprecord then do

   MixCaseException = 'n'
   MixCaseException_list = FileSpec('drive',pgmName) || FileSpec('path',pgmName) || 'mixedcaseexceptionlist.txt'

   do while lines(MixCaseException_list) > 0 & MixCaseException = 'n'
      if name = translate(strip(linein(MixCaseException_list))) then do
         MixCaseException = 'y'
      end
   end

   call Stream MixCaseException_list, "C", "Close"

   if MixCaseException == 'n' then do

        msg = "Mixed case letters found"
        call Error_Routine
      end
end
/*
**  ignore commented and blank records unless they are in the flower box
*/
   if flowerbox_processed then do
      if Substr( record, 7, 1 ) = "*" then do
         if inCopyReplacing then do
            msg = "No comments in COPY REPLACING allowed"
            call Error_Routine
         end
         return
      end
   end

   if \All_Keywords_Found  then
        call Keyword_Search
/*
**  Found record to process
*/
   sw_good_record = 1

Return
/*
**********************************************************************
**  Error Routine
**********************************************************************
*/
Error_Routine:
   ctr_error = ctr_error + 1
   err.ctr_error = Right( ctr_record, 5 ) ":" msg

return
/*
**********************************************************************
**  Display error messages
**********************************************************************
*/
Display_Errors:

   parse var name fileout "." .
   if sw_copy_member then homeDir="D:\wb\server\qcbllesrc\"
   else                   homeDir="D:\wb\server\srce\"
   homeDir="DESTINO"
   fileout = homeDir||fileout || ".STD"
   if Stream( fileout, "C", "Query Exists" ) <> "" then do
      call RxFuncAdd 'SysFileDelete', 'RexxUtil', 'SysFileDelete'
      call SysFileDelete fileout
   end

   if ctr_error = 0 then return

   if sw_cmd = 'cmd' then
      if sw_screen then call Errors_Screen
      else              call Errors_File
   else                 call Errors_Spf

return
/*
**********************************************************************
**  Display error messages in a file
**********************************************************************
*/
Errors_File:

   call Lineout fileout, filename

   i = 1
   do while i <= ctr_error
      call Lineout fileout, err.i
      i = i + 1
   end

   call Stream fileout, "C", "Close"

return
/*
**********************************************************************
**  Display error messages on the screen
**********************************************************************
*/
Errors_Screen:
/*
**   if ctr_error > 20 then do
**      say ctr_error "errors found. Print messages to a file? (Y/N)"
**      pull answer
**      if answer = "Y" then do
**         call Errors_File
**         say "Messages written to file" fileout
**         exit
**      end
**   end
*/
   say ""
   say filename

   do i = 1 to ctr_error
      say err.i
   end

   say ""

return
/*
**********************************************************************
**  Display error messages in SPF
**********************************************************************
*/
Errors_Spf:

   do i = 1 to ctr_error
      line = Substr( err.i, 1, 5 )
      message = Substr( err.i, 6 )
      'ISREDIT LINE_before ' line ' = NOTELINE "'message'"'
   end

return

/*
**********************************************************************
**  Search for required KEY Words
**********************************************************************
*/
Keyword_Search:

        if sw_copy_member  then return

        if pos("XCWWPGWS", record) > 0 then do
           XCWWPGWS_Found = 1
           x = strip(translate(word(record,words(record)),'  ',"'."))
           if x \= word(translate(name,' ','.'),1) then do
              msg = "Incorrect program name (" || x || ") passed to XCWWPGWS"
              call Error_Routine
           end
        end

        if pos("XCWWCRHT", record) > 0 then  XCWWCRHT_Found = 1

        if XCWWPGWS_Found & XCWWCRHT_Found then do
                All_Keywords_Found = 1
        end

return


/*
**********************************************************************
**  Validate that all required keywords are there
**********************************************************************
*/
Keyword_Validation:

        if sw_copy_member  then return

        ctr_record = "*****"

        if  All_Keywords_Found then return

        if \XCWWPGWS_Found  then do
                msg = "COPY XCWWPGWS not found "
                call Error_Routine
        end

        if \XCWWCRHT_Found  then do
                msg = "COPY XCWWCRHT not found "
                call Error_Routine
        end

return

/*
**********************************************************************
**  Validate existance of 9990 paragraph
**********************************************************************
*/
Check9990:

    if byPass9990 then return

    ctr_record = "*****"

    if \P9990_Found  then do
            msg = "Paragraph 9990-INIT-WORKING-STORAGE not found "
            call Error_Routine
    end

return

/*
**********************************************************************
**  Validate existance of 0000 paragraph
**********************************************************************
*/
Check0000:

    if P0000.0 = 0 then return

    ctr_record = "*****"

    Call SysStemSort "P0000.", "A", "I",,,1
    i = 1
    do while i <= P0000.0
       if P0000.i <> '' then do
            msg = 'PERFORM  ' || P0000.i || '-0000-INIT-PARM-INFO required in 9990'
            call Error_Routine
       end
       i = i + 1
    end

return

/*
**********************************************************************
**  Validate existance of TIMR paragraph
**********************************************************************
*/
CheckTIMR:

    if sw_copy_member then return

    if wordpos(substr(name,2,3),TIMR_exception) > 0 then return

    if TIMR_Found then return

    ctr_record = "*****"

    msg = 'Performance Monitoring Timer (TIMR) not found'
    call Error_Routine

return

/*
**********************************************************************
**  Validate 9990 position
**********************************************************************
*/
Check9990Position:

    P9990_Found = 1

    if byPass9990 then return

    if isOnline then do
       if ctr_paragraph <> 1 ,
       |  ctr_perform <> 1 then do
          msg = "Paragraph 9990 must be the 1st perform in the 1st paragraph"
          call Error_Routine
       end

       call CheckUnconditional9990

       return
    end

    /* Mainline Batch */

    if wordPos(substr(name,2,3),"SBM SBU") > 0 then do
       if current_paragraph <> '1000-INITIALIZE' ,
        | ctr_perform <> 1 then do
          msg = "Paragraph 9990 must be the 1st perform in the paragraph 1000-INITIALIZE for mainline batch"
          call Error_Routine
       end

       call CheckUnconditional9990

       return
    end

    /* other Batch */

    if ctr_paragraph <> 1 ,
    |  ctr_perform <> 1 then do
       msg = "Paragraph 9990 must be the 1st perform in the 1st paragraph"
       call Error_Routine
    end

    call CheckUnconditional9990

return

/*
**********************************************************************
**  Check for unconditional execution of 9990
**********************************************************************
*/
CheckUnconditional9990:

    if ctr_if <> 0 ,
    | ctr_evaluate <> 0 then do
       msg = "Paragraph 9990 must be executed unconditionally"
       call Error_Routine
    end

return

/*
**********************************************************************
**  Check used tag in flowerbox
**********************************************************************
*/
CheckUnsedTags:

    /* 1st tag may be the one for the creation */

    do i = 2 to ctr_tag
       if tagUsed.i = '' then do
          ctr_record = tagLineNum.i
          msg = 'Tag ' || tag.i || ' in flowerbox not used'
          call Error_Routine
       end
    end

return
/*
**********************************************************************
**  Check PL & PS copybook match
**********************************************************************
*/
CheckPS:

    if bypassPS then return

    exception = ''

    i = 1

    do while i <= CPL.0
       if wordpos(CPL.i,exception) > 0 then
          found = 1
       else
          found = 0

       j = 1
       do while j <= CPS.0 & \found
          if CPL.i = CPS.j then do
             found = 1
          end
          j = j + 1
       end

       if \found then do
          ctr_record = CPLLineNum.i
          msg = 'COPY ' || CPL.i || ' does not have a matching PS Copybook'
          call Error_Routine
       end
       i = i + 1
    end

return
/*
**********************************************************************
**  Check filename
**********************************************************************
*/
Check_filename:

    if sw_cmd = 'cmd' then do
       call sysFileTree filename,'f1','FO'
       parse value FileSpec('name',f1.1) with chk_filename '.' .
       if translate(chk_filename) <> chk_filename then do
          call Filename_Case_Error
          exit 99
       end
    end
    else do
       parse value FileSpec('name',filename) with chk_filename '.' .
       if translate(chk_filename) <> chk_filename then do
          call Filename_Case_Error
          exit 99
       end
    end

return

/*
**********************************************************************
**  Missing flower box
**********************************************************************
*/
Missing_flowerbox:

      msg = "Flower box not found"
      ctr_record = 1
      call Error_Routine
      call Display_Errors

      if sw_cmd = 'cmd' then do
         say msg
      end

return

/*
**********************************************************************
**  Filename must be in upper case
**********************************************************************
*/
Filename_Case_Error:

      msg = "Filename must be in Upper case"
      ctr_record = 1
      call Error_Routine
      call Display_Errors

      if sw_cmd = 'cmd' then do
         say msg
      end


return


/*
**********************************************************************
**  Check if module is on exception list
**********************************************************************
*/
check_exceptions:
procedure expose pgmName filename name

    exception = 'n'

    exception_list = FileSpec('drive',pgmName) || FileSpec('path',pgmName) || 'CheckStandards.txt'

    do while lines(exception_list) > 0 & exception = 'n'
       if name = translate(strip(linein(exception_list))) then do
          exception = 'y'
       end
    end

    call Stream exception_list, "C", "Close"

return exception


/*
**********************************************************************
**  No standard check required
**********************************************************************
*/
no_standard:
procedure expose sw_cmd

    message = 'This module is on the exception list. No check preformed.'

    if sw_cmd = 'cmd' then do
       say message
    end
    else do
       'ISREDIT LINE_before ' 1 ' = NOTELINE "'message'"'
end

return
