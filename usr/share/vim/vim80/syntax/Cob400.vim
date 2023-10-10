" Vim syntax file
" Language:   Cob400
" Maintainer: Tim Pope <vimNOSPAM@tpope.info>
"     (formerly Davyd Ondrejko <vondraco@columbus.rr.com>)
"     (formerly Sitaram Chamarty <sitaram@diac.com> and
"		    James Mitchell <james_mitchell@acm.org>)
" $Id: Cob400.vim,v 1.2 2007/05/05 18:23:43 vimboss Exp $

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" MOST important - else most of the keywords wont work!
if version < 600
  set isk=@,48-57,-
else
  setlocal isk=@,48-57,-
endif

syn case ignore

syn cluster Cob400Start      contains=Cob400AreaA,Cob400AreaB,Cob400Comment,Cob400Compiler
syn cluster Cob400AreaA      contains=Cob400Paragraph,Cob400Section,Cob400Division
"syn cluster Cob400AreaB      contains=
syn cluster Cob400AreaAB     contains=Cob400Line
syn cluster Cob400Line       contains=Cob400Reserved
syn match   Cob400Marker     "^\%( \{,5\}[^ ]\)\@=.\{,6}" nextgroup=@Cob400Start
syn match   Cob400Space      "^ \{6\}"  nextgroup=@Cob400Start
syn match   Cob400AreaA      " \{1,4\}"  contained nextgroup=@Cob400AreaA,@Cob400AreaAB
syn match   Cob400AreaB      " \{5,\}\|- *" contained nextgroup=@Cob400AreaB,@Cob400AreaAB
syn match   Cob400Comment    "[/*C].*$" contained
syn match   Cob400Compiler   "$.*$"     contained
syn match   Cob400Line       ".*$"      contained contains=Cob400Reserved,@Cob400Line

syn match   Cob400Division       "[A-Z][A-Z0-9-]*[A-Z0-9]\s\+DIVISION\."he=e-1 contained contains=Cob400DivisionName
syn keyword Cob400DivisionName   contained IDENTIFICATION ENVIRONMENT DATA PROCEDURE
syn match   Cob400Section        "[A-Z][A-Z0-9-]*[A-Z0-9]\s\+SECTION\."he=e-1  contained contains=Cob400SectionName
syn keyword Cob400SectionName    contained CONFIGURATION INPUT-OUTPUT FILE WORKING-STORAGE LOCAL-STORAGE LINKAGE
syn match   Cob400Paragraph      "\a[A-Z0-9-]*[A-Z0-9]\.\|\d[A-Z0-9-]*[A-Z]\."he=e-1             contained contains=Cob400ParagraphName
syn keyword Cob400ParagraphName  contained PROGRAM-ID SOURCE-COMPUTER OBJECT-COMPUTER SPECIAL-NAMES FILE-CONTROL I-O-CONTROL


"syn match Cob400Keys "^\a\{1,6\}" contains=Cob400Reserved
syn keyword Cob400Reserved contained ACCEPT ACCESS ADD ADDRESS ADVANCING AFTER ALPHABET ALPHABETIC
syn keyword Cob400Reserved contained ALPHABETIC-LOWER ALPHABETIC-UPPER ALPHANUMERIC ALPHANUMERIC-EDITED ALS
syn keyword Cob400Reserved contained ALTERNATE AND ANY ARE AREA AREAS ASCENDING ASSIGN AT AUTHOR BEFORE BINARY
syn keyword Cob400Reserved contained BLANK BLOCK BOTTOM BY CANCEL CBLL CD CF CH CHARACTER CHARACTERS CLASS
syn keyword Cob400Reserved contained CLOCK-UNITS CLOSE Cob400 CODE CODE-SET COLLATING COLUMN COMMA COMMON
syn keyword Cob400Reserved contained COMMUNICATIONS COMPUTATIONAL COMPUTE CONTENT CONTINUE
syn keyword Cob400Reserved contained CONTROL CONVERTING CORR CORRESPONDING COUNT CURRENCY DATE DATE-COMPILED
syn keyword Cob400Reserved contained DATE-WRITTEN DAY DAY-OF-WEEK DE DEBUG-CONTENTS DEBUG-ITEM DEBUG-LINE
syn keyword Cob400Reserved contained DEBUG-NAME DEBUG-SUB-1 DEBUG-SUB-2 DEBUG-SUB-3 DEBUGGING DECIMAL-POINT
syn keyword Cob400Reserved contained DELARATIVES DELETE DELIMITED DELIMITER DEPENDING DESCENDING DESTINATION
syn keyword Cob400Reserved contained DETAIL DISABLE DISPLAY DIVIDE DIVISION DOWN DUPLICATES DYNAMIC EGI ELSE EMI
syn keyword Cob400Reserved contained ENABLE END-ADD END-COMPUTE END-DELETE END-DIVIDE END-EVALUATE END-IF
syn keyword Cob400Reserved contained END-MULTIPLY END-OF-PAGE END-READ END-RECEIVE END-RETURN
syn keyword Cob400Reserved contained END-REWRITE END-SEARCH END-START END-STRING END-SUBTRACT END-UNSTRING
syn keyword Cob400Reserved contained END-WRITE EQUAL ERROR ESI EVALUATE EVERY EXCEPTION EXIT
syn keyword Cob400Reserved contained EXTEND EXTERNAL FALSE FD FILLER FINAL FIRST FOOTING FOR FROM
syn keyword Cob400Reserved contained GENERATE GIVING GLOBAL GREATER GROUP HEADING HIGH-VALUE HIGH-VALUES I-O
syn keyword Cob400Reserved contained IN INDEX INDEXED INDICATE INITIAL INITIALIZE
syn keyword Cob400Reserved contained INITIATE INPUT INSPECT INSTALLATION INTO IS JUST
syn keyword Cob400Reserved contained JUSTIFIED KEY LABEL LAST LEADING LEFT LENGTH LOCK MEMORY
syn keyword Cob400Reserved contained MERGE MESSAGE MODE MODULES MOVE MULTIPLE MULTIPLY NATIVE NEGATIVE NEXT NO NOT
syn keyword Cob400Reserved contained NUMBER NUMERIC NUMERIC-EDITED OCCURS OF OFF OMITTED ON OPEN
syn keyword Cob400Reserved contained OPTIONAL OR ORDER ORGANIZATION OTHER OUTPUT OVERFLOW PACKED-DECIMAL PADDING
syn keyword Cob400Reserved contained PAGE PAGE-COUNTER PERFORM PF PH PIC PICTURE PLUS POINTER POSITION POSITIVE
syn keyword Cob400Reserved contained PRINTING PROCEDURES PROCEDD PROGRAM PURGE QUEUE QUOTES
syn keyword Cob400Reserved contained RANDOM RD READ RECEIVE RECORD RECORDS REDEFINES REEL REFERENCE REFERENCES
syn keyword Cob400Reserved contained RELATIVE RELEASE REMAINDER REMOVAL REPLACE REPLACING REPORT REPORTING
syn keyword Cob400Reserved contained REPORTS RERUN RESERVE RESET RETURN RETURNING REVERSED REWIND REWRITE RF RH
syn keyword Cob400Reserved contained RIGHT ROUNDED RUN SAME SD SEARCH SECTION SECURITY SEGMENT SEGMENT-LIMITED
syn keyword Cob400Reserved contained SELECT SEND SENTENCE SEPARATE SEQUENCE SEQUENTIAL SET SIGN SIZE SORT
syn keyword Cob400Reserved contained SORT-MERGE SOURCE STANDARD
syn keyword Cob400Reserved contained STANDARD-1 STANDARD-2 START STATUS STOP STRING SUB-QUEUE-1 SUB-QUEUE-2
syn keyword Cob400Reserved contained SUB-QUEUE-3 SUBTRACT SUM SUPPRESS SYMBOLIC SYNC SYNCHRONIZED TABLE TALLYING
syn keyword Cob400Reserved contained TAPE TERMINAL TERMINATE TEST TEXT THAN THEN THROUGH THRU TIME TIMES GO TO TOP
syn keyword Cob400Reserved contained TRAILING TRUE TYPE UNIT UNSTRING UNTIL UP UPON USAGE USE USING VALUE VALUES
syn keyword Cob400Reserved contained VARYING WHEN WITH WORDS WRITE
syn match   Cob400Reserved contained "\<CONTAINS\>"
syn match   Cob400Reserved contained "\<\(IF\|INVALID\|END\|EOP\)\>"
syn match   Cob400Reserved contained "\<ALL\>"

syn cluster Cob400Line     add=Cob400Constant,Cob400Number,Cob400Pic,Cob400Signs
syn keyword Cob400Constant SPACE SPACES NULL ZERO ZEROES ZEROS LOW-VALUE LOW-VALUES

syn match   Cob400Number      "\<-\=\d*\.\=\d\+\>" contained
syn match   Cob400Number      "\.$" contained
syn match   Cob400Signs       "\ [-,+,=,*]\ " contained
syn match   Cob400Signs       "[-,+,=,*]\ " contained
syn match   Cob400Signs       "[),(,>,<]" contained
syn match   Cob400Pic		"\<S*9\+\>" contained
syn match   Cob400Pic		"\<$*\.\=9\+\>" contained
syn match   Cob400Pic		"\<Z*\.\=9\+\>" contained
syn match   Cob400Pic		"\<V9\+\>" contained
syn match   Cob400Pic		"\<9\+V\>" contained
syn match   Cob400Pic		"\<-\+[Z9]\+\>" contained
syn match   Cob400Todo		"todo" contained containedin=Cob400Comment

" For MicroFocus or other inline comments, include this line.
" syn region  Cob400Comment      start="*>" end="$" contains=Cob400Todo,Cob400Marker

syn match   Cob400BadLine      "[^ D\*$/-].*" contained
" If comment mark somehow gets into column past Column 7.
syn match   Cob400BadLine      "\s\+\*.*" contained
syn cluster Cob400Start        add=Cob400BadLine


syn keyword Cob400GoTo		GOTO
syn keyword Cob400Copy		COPY

" Cob400BAD: things that are BAD NEWS!
syn keyword Cob400BAD		ALTER ENTER RENAMES

syn cluster Cob400Line       add=Cob400GoTo,Cob400Copy,Cob400BAD,Cob400Watch,Cob400EXECs

" Cob400Watch: things that are important when trying to understand a program
syn keyword Cob400Watch		OCCURS DEPENDING VARYING BINARY COMP REDEFINES
syn keyword Cob400Watch		REPLACING RUN
syn match   Cob400Watch		"COMP-[123456XN]"

syn keyword Cob400EXECs		EXEC END-EXEC


syn cluster Cob400AreaA      add=Cob400DeclA
syn cluster Cob400AreaAB     add=Cob400Decl
syn match   Cob400DeclA      "\(0\=1\|77\|78\) " contained nextgroup=Cob400Line
syn match   Cob400Decl		"[1-4]\d " contained nextgroup=Cob400Line
syn match   Cob400Decl		"0\=[2-9] " contained nextgroup=Cob400Line
syn match   Cob400Decl		"66 " contained nextgroup=Cob400Line

syn match   Cob400Watch		"88 " contained nextgroup=Cob400Line

"syn match   Cob400BadID		"\k\+-\($\|[^-A-Z0-9]\)" contained

syn cluster Cob400Line       add=Cob400CALLs,Cob400String,Cob400CondFlow
syn keyword Cob400CALLs		CALL END-CALL CANCEL GOBACK PERFORM END-PERFORM INVOKE THRU EXIT
syn match   Cob400CALLs		"EXIT \+PROGRAM"
syn match   Cob400Extras       /\<VALUE \+\d\+\./hs=s+6,he=e-1

syn match   Cob400String       /"[^"]*\("\|$\)/
syn match   Cob400String       /'[^']*\('\|$\)/

"syn region  Cob400Line        start="^.\{6}[ D-]" end="$" contains=ALL
syn match   Cob400Indicator   "\%7c[D-]" contained

if exists("Cob400_legacy_code")
  syn region  Cob400CondFlow     contains=ALLBUT,Cob400Line start="\<\(IF\|INVALID\|END\|EOP\)\>" skip=/\('\|"\)[^"]\{-}\("\|'\|$\)/ end="\." keepend
endif

" many legacy sources have junk in columns 1-6: must be before others
" Stuff after column 72 is in error - must be after all other "match" entries
if exists("Cob400_legacy_code")
    syn match   Cob400BadLine      "\%73c.*" containedin=ALLBUT,Cob400Comment
else
    syn match   Cob400BadLine      "\%73c.*" containedin=ALL
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_Cob400_syntax_inits")
  if version < 508
    let did_Cob400_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink Cob400BAD      Error
  HiLink Cob400BadID    Error
  HiLink Cob400BadLine  Error
  if exists("g:Cob400_legacy_code")
      HiLink Cob400Marker   Comment
  else
      HiLink Cob400Marker   Error
  endif
  HiLink Cob400CALLs    Function
  HiLink Cob400Comment  Comment
  HiLink Cob400Keys     Comment
  HiLink Cob400AreaB    Special
  HiLink Cob400Compiler PreProc
  HiLink Cob400CondFlow Special
  HiLink Cob400Copy     PreProc
  HiLink Cob400DeclA    Cob400Decl
  HiLink Cob400Decl     Type
  HiLink Cob400Extras   Special
  HiLink Cob400GoTo     Special
  HiLink Cob400Constant Constant
  HiLink Cob400Number   Constant
  HiLink Cob400Signs    Constant
  HiLink Cob400Pic      Constant
  HiLink Cob400Reserved Statement
  HiLink Cob400Division Label
  HiLink Cob400Section  Label
  HiLink Cob400Paragraph Label
  HiLink Cob400DivisionName  Keyword
  HiLink Cob400SectionName   Keyword
  HiLink Cob400ParagraphName Keyword
  HiLink Cob400String   Constant
  HiLink Cob400Todo     Todo
  HiLink Cob400Watch    Special
  HiLink Cob400Indicator Special

  delcommand HiLink
endif

let b:current_syntax = "Cob400"

" vim: ts=6 nowrap
