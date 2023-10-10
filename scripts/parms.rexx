/*   REXX      */
/*
**  BuildM101M087Parm.rex.
  **  This REXX utility will build the parameter card for I99PM101 and I99DM087
  **  it reads the list of file names and extract the date and sequence number 
  **  portion to build the corresponding parameter cards for each file
*/
/*
**		CHG#		DESCRIPTION
**    R00304 	28/09/2010 WO#307
**						AMEX FILE EXTENSION CHANGE FROM AMX TO TXT
**						AMEX CCID CHANGE FROM PRSEGM TO PRUSEG
**		R00304  18/10/2010 WO#309
**            AMEX FILE NAME CHANGE
**		R00351  23/11/2010 WO#352
**            AMEX FILE NAME CHANGE
**		R01049  05/08/2013 WO#1050
**            AMEX FILE NAME CHANGE
*/

returnCd = 0
parse upper arg filename
filename=strip(filename)
errcnt = 0

name101 = "I99PM101"
name087 = "I99DM087"

/* create output file */

outFile101 = name101 || '.cvt'
outFile087 = name087 || '.cvt'

address cmd 'del ' outFile101
address cmd 'del ' outFile087

/*say ' '*/
say 'Generating Parameter Cards, please wait....'
/*say ' '*/


do while lines(filename) > 0
   record = linein( filename )

   parse upper var record record temp
   
/* write the parm according to different type of file */

   if (strip(substr(record,25,3)) = 'DOM') then do
      call writeDOM
   end

   if (strip(substr(record,21,3)) = 'BCA') then do
      call writeBCA
   end

   if (strip(substr(record,19,3)) = 'BBV') then do
      call writeBBV
   end

/* R00304   if (strip(substr(record,19,3)) = 'AMX') then do */
/* R01049   if (strip(substr(record,31,3)) = 'TXT') then do */
   if (strip(substr(record,39,3)) = 'TXT') then do      

      call writeAMX
   end

   if (strip(substr(record,1,1)) = '1') then do
      call writeBCM
   end

end

if errcnt > 0 then do
   message = 'problem ' || filename 
   say message
end


/* close file */
rc = lineout(filename)
rc = lineout(outFile101)
rc = lineout(outFile087)


return



/*------------------*/
writeDOM:
/*------------------*/
/* parm for 2-Stage Autopay Banamex */

outLine = 'PROCESS DATE        =20' || substr(record,4,2) || '-' 
outLine = outLine || substr(record,6,2) || '-' || substr(record,8,2)
       
rc = lineout(outFile101,outLine)

outLine = 'SEQUENCE NUMBER     ='   || substr(record,22,2)

rc = lineout(outFile101,outLine)

outLine = 'BANAMEX CCID        =000081235886'

rc = lineout(outFile101,outLine)


return


/*------------------*/
writeBCA:
/*------------------*/
/* parm for Credit Card Banamex */

outLine = 'PROCESS DATE        =20' || substr(record,4,2) || '-' 
outLine = outLine || substr(record,6,2) || '-' || substr(record,8,2)
       
rc = lineout(outFile087,outLine)

outLine = 'SEQUENCE NUMBER     ='   || substr(record,18,2)

rc = lineout(outFile087,outLine)

outLine = 'BANAMEX CCID        =81235886'

rc = lineout(outFile087,outLine)


return



/*------------------*/
writeBBV:
/*------------------*/
/* parm for 2-Stage Autopay Bancomer */

outLine = 'PROCESS DATE        =20' || substr(record,4,2) || '-' 
outLine = outLine || substr(record,6,2) || '-' || substr(record,8,2)
       
rc = lineout(outFile101,outLine)

outLine = 'SEQUENCE NUMBER     ='   || substr(record,16,2)

rc = lineout(outFile101,outLine)

outLine = 'BANCOMER CCID       =PRSEGM'

rc = lineout(outFile101,outLine)


return



/*------------------*/
writeAMX:
/*------------------*/
/* parm for Credit Card American Experss */

/*R00304 outLine = 'PROCESS DATE        =20' || substr(record,4,2) || '-' */
/*R00304 outLine = outLine || substr(record,6,2) || '-' || substr(record,8,2) */
/*R01049 outLine = 'PROCESS DATE        =' || substr(record,22,4) || '-' */
/*R01049 outLine = outLine || substr(record,26,2) || '-' || substr(record,28,2) */
outLine = 'PROCESS DATE        =' || substr(record,23,4) || '-'
outLine = outLine || substr(record,27,2) || '-' || substr(record,29,2)
       
rc = lineout(outFile087,outLine)

/*R00304 outLine = 'SEQUENCE NUMBER     ='   || substr(record,16,2) */
outLine = 'SEQUENCE NUMBER     =01'

rc = lineout(outFile087,outLine)

/* R00304  outLine = 'AMEX CCID           =PRSEGM' */
/* R00351  outLine = 'AMEX CCID           =PRUSEG' */
outLine = 'AMEX CCID           =BAYFIT'

rc = lineout(outFile087,outLine)

/* R01049 ADD TIMESTAMP */
outLine = 'AMEX TIMESTAMP      =' || substr(record,32,6)

rc = lineout(outFile087,outLine) 


return


/*------------------*/
writeBCM:
/*------------------*/
/* parm for Credit Card Bancomer */

outLine = 'PROCESS DATE        =20' || substr(record,3,2) || '-' 
outLine = outLine || substr(record,5,2) || '-' || substr(record,7,2)
       
rc = lineout(outFile087,outLine)

outLine = 'SEQUENCE NUMBER     ='   || substr(record,11,2)

rc = lineout(outFile087,outLine)

outLine = 'BANCOMER CCID       =6089148'

rc = lineout(outFile087,outLine)


return




