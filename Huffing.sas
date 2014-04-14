%*;/*
\begin{lstlisting}[language=SAS,caption=Huffing.sas,label=huffing.sas]
*/
/*
Huffing.sas

Merge the death files with the SuperMICAR files, parse the SuperMICAR literals,
and search for huffing deaths.

*/

libname sm     'c:\data\poisoning\SuperMICAR';
libname death  'c:\data\death';
%include "c:\user\poisoning\SuperMICAR\spell.sas";

%macro mergeDandSM(year);
/*
 merge the death and supermicar files and save to SuperMICAR directory
*/
data death&year;
   set death.dea20&year(keep=certno age autopsy cnty_inj cnty_occ cnty_res dob educ
                     emergent facility fac_type geozip hisp ind_lit injplace injpnchs
                     inj_caus inj_date married mltcse1-mltcse20 occ_lit occ_sam race
                     referred res_yr sex smoking statebir st_inj st_occ st_res
                     transax underly underly3 zipcode dth_date);
   Year = put(year(dth_date),4.);
   label Year = 'Year of death';
run;
proc sort data=death&year;
   by certno;
run;

data superm&year;
   infile "c:\data\death\supermicar\dealit01.f&year" lrecl=1114 missover pad;
   input
      @1    certno    $char10.
      @11   linea     $char120.
      @131  lineb     $char120.
      @251  linec     $char120.
      @371  lined     $char120.
      @491  linea_int $char20.
      @511  lineb_int $char20.
      @531  linec_int $char20.
      @551  lined_int $char20.
      @571  duetob    $char1.
      @572  duetoc    $char1.
      @573  duetod    $char1.
      @574  lineother $char240.
      @814  descrip   $char250.
      @1064 place     $char50.
      ;
run;
proc sort data=superm&year;
   by certno;
run;

data sm.WaSM20&year;
   merge death&year superm&year;
   by certno;
run;
%mend;

%mergeDandSM(03);
%mergeDandSM(04);
%mergeDandSM(05);
%mergeDandSM(06);
%mergeDandSM(07);
%mergeDandSM(08);
%mergeDandSM(09);
%mergeDandSM(10);


/*
read data for 2011
*/
data death11;
   set death.dea2011(keep=certno age autopsy cnty_inj cnty_occ cnty_res dob educ
                     emergent facility fac_type geozip hisp ind_lit injplace injpnchs
                     inj_caus inj_date married mltcse1-mltcse20 occ_lit occ_sam race
                     referred res_yr sex smoking statebir st_inj st_occ st_res
                     transax underly underly3 zipcode dth_date);
   Year = put(year(dth_date),4.);
   label Year = 'Year of death';
run;
proc sort data=death11;
   by certno;
run;

data superm11;                        ;
   infile 'c:\data\death\supermicar\DeathLit2011.csv' delimiter = ',' 
      MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat certno    $10. ;
   informat linea     $120.;      
   informat lineb     $120.;      
   informat linec     $120.;      
   informat lined     $120.;       
   informat linea_int $20. ;  
   informat lineb_int $20. ;  
   informat linec_int $20. ;  
   informat lined_int $20. ;   
   informat duetob    $1.  ;     
   informat duetoc    $1.  ;     
   informat duetod    $1.  ;     
   informat lineother $240.;  
   informat descrip   $250.;      
   informat place     $50. ;     

   input                              
      certno    $        
      linea     $      
      lineb     $      
      linec     $      
      lined     $      
      linea_int $  
      lineb_int $  
      linec_int $  
      lined_int $  
      duetob    $    
      duetoc    $    
      duetod    $    
      lineother $  
      descrip   $     
      place     $    
   ;                                  
run; 
proc sort data=superm11;
   by certno;
run;
/*
I exclude 7 records that are in the SuperMICAR file but not in the death file
*/
data sm.WaSM2011;
   merge death11(in=indeath) superm11(in=insm);
   by certno;
   if not indeath then delete;
run;

/*
read the SuperMICAR data for 2012
*/
data death12;
   set death.dea2012(keep=certno age autopsy cnty_inj cnty_occ cnty_res dob educ
                     emergent facility fac_type geozip hisp ind_lit injplace injpnchs
                     inj_caus inj_date married mltcse1-mltcse20 occ_lit occ_sam race
                     referred res_yr sex smoking statebir st_inj st_occ st_res
                     transax underly underly3 zipcode dth_date);
   Year = put(year(dth_date),4.);
   label Year = 'Year of death';
run;
proc sort data=death12;
   by certno;
run;

data superm12;                        ;
   infile 'c:\data\death\supermicar\DeathLit2012Q6.csv' delimiter = ',' 
      MISSOVER DSD lrecl=32767 firstobs=2 ;
   informat certno    $10. ;
   informat linea     $120.;      
   informat lineb     $120.;      
   informat linec     $120.;      
   informat lined     $120.;       
   informat linea_int $20. ;  
   informat lineb_int $20. ;  
   informat linec_int $20. ;  
   informat lined_int $20. ;   
   informat duetob    $1.  ;     
   informat duetoc    $1.  ;     
   informat duetod    $1.  ;     
   informat lineother $240.;  
   informat descrip   $250.;      
   informat place     $50. ;     

   input                              
      certno    $        
      linea     $      
      lineb     $      
      linec     $      
      lined     $      
      linea_int $  
      lineb_int $  
      linec_int $  
      lined_int $  
      duetob    $    
      duetoc    $    
      duetod    $    
      lineother $  
      descrip   $     
      place     $    
   ;                                  
run; 
proc sort data=superm12;
   by certno;
run;
/*
delete 18 supermicar records that are not in the death file
*/
data sm.WaSM2012;
   merge death12(in=indeath) superm12(in=insm);
   by certno;
   if not indeath then delete;
run;

/*
Step 2. Parse the literal entries.
Even though there is limited usefulness in combining words and checking spelling as
I did in the drug word analysis, the programs are already written, so it is easy to do,
and therefore I do it.
*/


%macro HuffExtract(datayear);
/*
Identify possible huffing deaths and extract them for review.
Steps:
1. Exclude suicides
2. Prepare file with individual words and phrases from literal text
3. Extract records with possible huffing words
4. Combine those with original file and exclude some non-huffing deaths


Procedure to convert literal entries to individual words
1. Combine the literals into one string
2. Divide string into words.
3. Remove all punctuation from each word
4. Correct spelling with the "spell" format
5. Convert brand names to their generic equivalent
6. Use do loop to put each word into a separate field.
*/

data temp1;
   length literal $ 970;
   set sm.WaSM&datayear(where=(underly3 not between 'X60' and 'X84'));
   literal = trim(linea)||" "||trim(lineb)||" "||trim(linec)||" "||trim(lined)||" "
              ||trim(lineother)||" "||trim(descrip);

   array words{75} $ 35 worda1-worda75;

   j = 0;
   do i = 1 to 75;
      j = j+1;
      words{i} = scan(literal,j," .<(+&!$*);^-/,%|\`=:[]");
      words{i} = compress(words{i},"'");
      words{i} = put(words{i}, $spell.);
/*
If a combo contains the words 'I' and 'V' consecutively, then
combine them into one word.  Adjust the value of i in order to
count the words correctly for these cases.

If a word is preceded by any of the words NON, NOT, or NO, then
combine the two words with a space between. Adjust the word count.

Combine CARBON, NITROUS, POLY, DESMETHYL, ISOPROPYL, or METHYL with 
the following word, with a space between.

Combine DEXTRO with the following word, without a space between.

Combine DECANOATE or SULFATE with the previous word, with a space between.

If CHLORAL is followed by HYDRATE, combine them into one entry.
If COCA is followed by ETHYLENE, combine them into one entry.
If ETHYL is followed by ALCOHOL, combine them into one entry.
If ETHEL is followed by ALCOHOL, combine them, and spell it ETHYL ALCOHOL.
If ETHYL is followed by CHLORIDE, combine them into one entry.
If VALPROIC is followed by ACID, combine them into one entry.
If SALICYLIC is followed by ACID, combine them into one entry.
If DICHLOROPHENOXYACETIC is followed by ACID, combine them into one entry.
if PAIN is followed by RELIEVER or RELIEVERS, combine them.
if MUSCLE is followed by RELAXANTS, RELAXANT, RELAXER, or RELAXERS, combine them.
if FEN is followed by PHEN, combine them
if BETA is followed by BLOCKER or BLOCKERS, combine them
if FLUORINATED is followed by HYDROCARBON, combine them

other words to combine:
HYDROGEN SULFIDE
HYDROGEN CHLORIDE
GAMMA HYDROXYBUTYRATE (first combine HYDROXY BUTYRATE if they are separate)
CALCIUM CHANNEL BLOCKER
MS CONTIN
DES METHYL (no space between)
METHYLENE DIOXYMETHAMPHETAMINE (no space between)
MIS HAP (no space between)
DILTIAZEM HYDROCHLORIDE
OXALIC ACID
GABA and PENTIN (no space between)
SULFURIC ACID
CAR EXHAUST
ENGINE EXHAUST
VEHICLE EXHAUST
AUTO EXHAUST
AUTOMOBILE EXHAUST
PRODUCTS OF COMBUSTION
GASOLINE VAPOR
SMOKE INHALATION
COMPRESSED NITROGEN
INERT GAS
NATURAL GAS
COMPRESSED AIR
FK 506 (no space)
ETHYLENE GLYCOL
AMYL NITRATE
CANNED AIR
*/
      X = 0;
      if i ge 2 and words{i} ne "                    " then do;
         if words{i} = "V" and words{i-1} = "I" then do;
            words{i-1} = compress(words{i-1}||words{i});
            X = 1;
            end;
         if  words{i-1} in ("NON","NOT","NO") then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if  words{i-1} in ("CARBON","NITROUS","POLY","DESMETHYL","ISOPROPYL",
               "METHYL") then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if  words{i-1} = "DEXTRO" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            end;
         if words{i} in ("DECANOATE","SULFATE") then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ALCOHOL" and words{i-1} = "ETHYL" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ALCOHOL" and words{i-1} = "ETHEL" then do;
            words{i-1} = "ETHYL ALCOHOL";
            X = 1;
            end;
         if words{i} = "HYDRATE" and words{i-1} = "CHLORAL" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ETHYLENE" and words{i-1} = "COCA" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "CHLORIDE" and words{i-1} = "ETHYL" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "VALPROIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "SALICYLIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "DICHLOROPHENOXYACETIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "EXHAUST" and words{i-1} in ("CAR","ENGINE","VEHICLE",
               "AUTO","AUTOMOBILE") then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} in ("RELIEVER","RELIEVERS") and words{i-1} = "PAIN" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} in ("RELAXANTS","RELAXER","RELAXANT","RELAXERS") and
               words{i-1} = "MUSCLE" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "PHEN" and words{i-1} = "FEN" then do;
            words{i-1} = trim(words{i-1})||"-"||trim(words{i});
            X = 1;
            end;
         if words{i} in ("BLOCKER","BLOCKERS") and words{i-1} = "BETA" then do;
            words{i-1} = trim(words{i-1})||"-"||trim(words{i});
            X = 1;
            end;
         if words{i} = "HYDROCARBON" and words{i-1} = "FLUORINATED" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "SULFIDE" and words{i-1} = "HYDROGEN" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "CHLORIDE" and words{i-1} = "HYDROGEN" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} in ("BUTYRATE","BUTYRIC") and words{i-1} = "HYDROXY" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            if i ge 3 then do;
               if words{i-1} in ("HYDROXYBUTYRATE","HYDROXYBUTYRIC") and
                     words{i-2} = "GAMMA" then do;
                  words{i-2} = trim(words{i-2})||" "||trim(words{i-1});
                  X = 2;
                  end;
               end;
            end;
         if words{i} in ("HYDROXYBUTYRATE","HYDROXYBUTYRIC") and
               words{i-1} = "GAMMA" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "GAMMA HYDROXYBUTYRIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "CONTIN" and words{i-1} = "MS" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "METHYL" and words{i-1} = "DES" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            end;
         if words{i} = "DIOXYMETHAMPHETAMINE" and words{i-1} = "METHYLENE" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            end;
         if words{i} = "HAP" and words{i-1} = "MIS" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            end;
         if words{i} = "HYDROCHLORIDE" and words{i-1} = "DILTIAZEM" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "OXALIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "ACID" and words{i-1} = "SULFURIC" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "VAPOR" and words{i-1} = "GASOLINE" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "PENTIN" and words{i-1} = "GABA" then do;
            words{i-1} = "GABAPENTIN";
            X = 1;
            end;
         if words{i} = "INHALATION" and words{i-1} = "SMOKE" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "GAS" and words{i-1} in ("INERT","NATURAL") then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} in ("AIR","NITROGEN") and words{i-1} = "COMPRESSED" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         if words{i} = "506" and words{i-1} = "FK" then do;
            words{i-1} = trim(words{i-1})||trim(words{i});
            X = 1;
            end;
	 if words{i} = "GLYCOL" and words{i-1} = "ETHYLENE" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
	 if words{i} = "NITRATE" and words{i-1} = "AMYL" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
	 if words{i} = "AIR" and words{i-1} = "CANNED" then do;
            words{i-1} = trim(words{i-1})||" "||trim(words{i});
            X = 1;
            end;
         end;

      if i ge 3 and words{i} ne "                    " then do;
         if words{i} in ("BLOCKER","BLOCKERS") and words{i-1} = "CHANNEL" and
               words{i-2} = "CALCIUM" then do;
            words{i-2} = trim(words{i-2})||" "||trim(words{i-1})||" "||trim(words{i});
            X = 2;
            end;
         if words{i} = ("COMBUSTION") and words{i-1} = "OF" and
               words{i-2} = "PRODUCTS" then do;
            words{i-2} = trim(words{i-2})||" "||trim(words{i-1})||" "||trim(words{i});
            X = 2;
            end;
         end;
/*
If we have formed all the separate words, then output them:
*/
      if words{i} = "                    " and i le 75 then do;
         nword = i-1;
         output temp1;
         return;
         end;
      if i = 75 then do;
         nword = 75;
         output temp1;
         end;
      if X = 1 then i = i-1;
      if X = 2 then i = i-2;
      end /* end do i = 1 to 75*/;
run;

/*
Procedure to put each word on a separate record:
Read temp1 and output each individual word to a new record.
Create a new field (word_generic) which has brand names converted to generic name.
*/
data temp2(keep=certno word underly underly3);
   set temp1;

   array words{75} $ 35 worda1-worda75;

   do i = 1 to 75;
      word = put(words{i}, $spell.);
      if word ne "" then output temp2;
/*
If we have output all the separate words, then go to next case:
*/
      if words{i} = "                    " and i le 75 then return;
      if i = 75 then return;
      end /* end do i = 1 to 75*/;
run;
/*
Unduplicate the drug words within certificates.
*/
Proc sort data=temp2 out=temp3 nodupkey;
   by certno word;
run;

proc sort data=temp3;
   by word;
run;

/*
Read in the list of vsm words and word roots.
*/
data huffword1;
   set temp3;
   where 
     (word contains 'HUFF'		or
      word contains 'SNIFF'		or
      word contains 'POPP' 		or
      word contains 'BAG' 		or
      word contains 'INHAL' 		or
      word contains 'GLUE' 		or
      word contains 'GASOLINE' 		or
      word contains 'BUTANE' 		or
      word contains 'NITROUS OXIDE' 	or
      word contains 'DUSTER' 		or
      word contains 'CLEAN' 		or
      word contains 'WHIPPED' 		or
      word contains 'COMPRESSED AIR' 	or
      word contains 'INERT GAS' 	or
      word contains 'VOLATILE' 		or
      word contains 'DIFLUOROETHANE'	or
      word contains 'DIFLUOROMETHANE'	or
      word contains 'AEROSOL' 		or
      word contains 'ETHYL CHLORIDE'	or
      word contains 'TOLUENE'		or
      word contains 'CHLOROETHANE'	or
      word contains 'AMYL NITRATE' 	or
      word contains 'CANNED AIR'	or
      word contains 'COMPRESSED NITROGEN')
      and
      word not in ('SMOKE INHALATION',
      	       	   'GARBAGE',
		   'LUMBAGO',
		   'AIRBAGS',
      	           'AIRBAG')
      ;
run;
proc sort data=huffword1 nodupkey;
   by certno;
run;
proc sort data=temp1;
   by certno;
run;
data huffword&datayear;
   merge temp1 huffword1(in=inhuffword);
   by certno;
   if inhuffword;
   if 
      index(literal,'CARBON MONOXIDE')		ge 1 or
      index(literal,'PRODUCTS OF COMBUSTION') 	ge 1 or
      index(literal,'AUTOMOBILE EXHAUST') 	ge 1
      then delete;
run;
%mend /*HuffExtract*/;

%HuffExtract(2003);
%HuffExtract(2004);
%HuffExtract(2005);
%HuffExtract(2006);
%HuffExtract(2007);
%HuffExtract(2008);
%HuffExtract(2009);
%HuffExtract(2010);
%HuffExtract(2011);
%HuffExtract(2012);

data sm.HuffExtract2003to2011;
   set huffword2003 huffword2004 huffword2005 huffword2006 huffword2007 
       huffword2008 huffword2009 huffword2010 huffword2011;
run;

data sm.HuffExtract2003to2012;
   set sm.huffextract2003to2011 huffword2012;
run;

data sm.HuffExtractPreConfirm;
   length confirmed $ 1;
   set sm.HuffExtract2003to2012;
   confirmed = '';
run;

/*
codes for confirmed
N = not a vsm death
Y = a vsm death
D = inhalation of illicit drug such as heroin or cocaine, but no vsm
S = suffocation only, no indication of a volatile substance
P = probable vsm, but not classified 'Y' to err on side of caution (e.g. a record
    that describes inhaling a volatile substance but without any words indicating misuse)

if inhalation of a volatile substance is mentioned with mention of another drug, 
then I classify it as VSM ('Y').
*/
/*
To manually classify the records:

data tempconfirm;
   set sm.HuffExtractPreConfirm;
run;
proc fsedit data=tempconfirm;
run;

data sm.HuffExtractConfirmed;
   set tempconfirm;
run;
*/

/*
The classified records are in the file sm.HuffExtractConfirmed
*/

/*
results
(for deaths occurring in Washington)

                                  15:17 Tuesday, January 7, 2014  21

                         The FREQ Procedure

                                         Cumulative    Cumulative
   confirmed    Frequency     Percent     Frequency      Percent
   --------------------------------------------------------------
   D                   5        2.13             5         2.13
   N                 160       68.09           165        70.21
   P                   5        2.13           170        72.34
   S                  14        5.96           184        78.30
   Y                  51       21.70           235       100.00

*/

/*
Create the file I will use for analysis
*/
data sm.huffdeaths;
   set sm.HuffExtractConfirmed;
   where cnty_occ ne '00' and confirmed in ('Y','P');
run;


/*
\end{lstlisting}
*/
