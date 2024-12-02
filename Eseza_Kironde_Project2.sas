
***Eseza Kironde Project 2***


*Calling kpsmoking and calling it kpsmoking1;
libname x "C:\Users\nesez\OneDrive\Desktop\BIOS 531 - SAS\fall2023";

data work.kpsmoking2;
	set x.kpsmoking;
	run;

*Sort data;
proc sort data=work.kpsmoking2;
 by id;
run;


proc freq data= work.kpsmoking2;
run;
/*This shows there is no missing data for id, race, date, dob,
age, cig_day, yearssmoke, ae3, ae6, smoke3, smoke6, treatment, site.

Will exclude cig_day and years_smoke from coding 9 to missing because numeric*/


*Code for changing a score of 9;
data work.kpsmoking2;
	set x.kpsmoking;
if hispanic=9 then hispanic=.;
if female= 9 then female =.;
if employ= 9 then employ = .;
if mstatus = 9 then mstatus =.;
if scms1=9 then scms1=.;
if scms2=9 then scms2=.;
if scms3=9 then scms3=.;
if scms4=9 then scms4=.;
if scms5=9 then scms5=.;
if scms6=9 then scms6=.;
if scms7=9 then scms7=.;
if scms8=9 then scms8=.;
if scms9=9 then scms9=.;
if scms10=9 then scms10=.;
if ae3 = 9 then ae3 =.;
if ae6 = 9 then ae6 =.;
if smoke3 = 9 then smoke3 =.;
if smoke6 = 9 then smoke6 =.;

/*Reversing the Likart scale for 7, 8, and 10*/
scms7_old=scms7;
scms8_old=scms8;
scms10_old=scms10;

scms7=6-scms7;
scms8=6-scms8;
scms10=6-scms10;

drop scms7_old scms8_old scms10_old;

/*Calculating scms mean*/
 if n(of scms1-scms10)=10 then scms_mean= mean(of scms1-scms10);
 if n(of scms1-scms10)=9 then scms_mean= mean(of scms1-scms10);

 /*new variable for non-white*/
if race ne "White" then race= "nonwhite";
/*Dichotomize race?*/

/*if race = "White" then race= 1;
if race= "nonwhite" then race= 0;*/

run;
*Creating a column for white and non white;
data work.kpsmoking3;
	set work.kpsmoking2;
	if race= "White" then Non_White = 0;
	else Non_White = 1;
	run;

**PART B**;

proc print data= work.kpsmoking3;
run;

proc means data= work.kpsmoking3 n mean std;
  var female Non_White age years_smoke cig_day  scms_mean;
    class treatment;
	output out=work.kpsmoking4
	mean=meanfemale meanNon_White meanage meanyears_smoke meancig_day  meanscms_mean
	std=stdfemale stdNon_White stdage stdyears_smoke stdcig_day  stdscms_mean
	n=nfemale nNon_White nage nyears_smoke ncig_day  nscms_mean;
run;

proc means n mean std data=work.kpsmoking3;
    var female Non_White age years_smoke cig_day  scms_mean;
   run;


proc print data= work.kpsmoking4;
run; 

 
*For Overall;
data work.overall;
   set work.kpsmoking4;
     if treatment= " ";
      omage = round(meanage, 0.01);
      omyear = round(meanyears_smoke, 0.01);
      omcig = round(meancig_day, 0.01);
	  omeanscms = round(meanscms_mean, 0.01);

	  omfemale = round(meanfemale*100, 0.01); 
	  omnonwhite= round(meanNon_White*100, 0.01);

      osage = round(stdage, 0.01);
      osyear = round(stdyears_smoke, 0.01);
      oscig = round(stdcig_day, 0.01);
	  osmeanscms = round(stdscms_mean, 0.01);

	  onfemale = round(nfemale, 0.01);
	  onnonwhite = round(nNon_White, 0.01);

   keep omage -- onnonwhite;
run;

*For Treatment A;
data work.treatmentA;
   set work.kpsmoking4;
     if Treatment = "A";
      amage = round(meanage, 0.01);
      amyear = round(meanyears_smoke, 0.01);
      amcig = round(meancig_day, 0.01);
	  ameanscms = round(meanscms_mean, 0.01);

	  amfemale = round(meanfemale*100, 0.01); 
	  amnonwhite= round(meanNon_White*100, 0.01);

      asage = round(stdage, 0.01);
      asyear = round(stdyears_smoke, 0.01);
      ascig = round(stdcig_day, 0.01);
	  asmeanscms = round(stdscms_mean, 0.01);

	  anfemale = round(nfemale, 0.01);
	  annonwhite = round(nNon_White, 0.01);

	  keep amage -- annonwhite;
	run;

*For Treatment B;
data work.treatmentB;
   set work.kpsmoking4;
     if Treatment = "B";
      bmage = round(meanage, 0.01);
      bmyear = round(meanyears_smoke, 0.01);
      bmcig = round(meancig_day, 0.01);
	  bmeanscms = round(meanscms_mean, 0.01);

	  bmfemale = round(meanfemale*100, 0.01); 
	  bmnonwhite= round(meanNon_White*100, 0.01);

      bsage = round(stdage, 0.01);
      bsyear = round(stdyears_smoke, 0.01);
      bscig = round(stdcig_day, 0.01);
	  bsmeanscms = round(stdscms_mean, 0.01);

	  bnfemale = round(nfemale, 0.01);
	  bnnonwhite = round(nNon_White, 0.01);

	  keep bmage -- bnnonwhite;

	run;

data work.final;
	merge work.overall work.treatmentA work.treatmentB;
run;

proc print data= work.final;
run;

*Creating Table1;
data _null_;

   set work.final;
   file print;
   put
/*
 1234567890123456789012345678901234567890123456789012345678901234567890 */
"                            Baseline Characteristics                            "/
"Variable                 |     Group A    |      Group B      |     Overall     "/
"-------------------------+----------------+-------------------+-----------------"/
"Female"                  @26 "|" anfemale "(" amfemale"%)"
                          @44 "|" bnfemale "(" bmfemale "%)"
                          @63 "|" onfemale "(" omfemale "%)"
/
"Non-White"               @26 "|" annonwhite "(" +1 amnonwhite "%)" 
                          @44 "|" bnnonwhite "(" +1 bmnonwhite "%)"
                          @63 "|" onnonwhite "(" +1 omnonwhite "%)"
/
"Age at Last Birthday"    @26 "|" amage "(+/-" +1 asage ")" 
                          @44 "|" bmage "(+/-" +1 bsage ")"
                          @63 "|" omage "(+/-" +1 osage ")"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
/
"Number of Years Smoking" @26 "|" amyear "(+/-" +1 asyear ")" 
                          @44 "|" bmyear "(+/-" +1 bsyear ")"
                          @63 "|" omyear "(+/-" +1 osyear ")"
/
"Number of Cigs/day"      @26 "|" amcig "(+/-" +1 ascig  ")"
                          @44 "|" bmcig "(+/-" +1 bscig ")"
                          @63 "|" omcig "(+/-" +1 oscig ")"
/
"SCMS Mean"               @26 "|" ameanscms "(+/-" +1 asmeanscms ")" 
                          @44 "|" bmeanscms "(+/-" +1 bsmeanscms ")"
                          @63 "|" omeanscms "(+/-" +1 osmeanscms ")"
///
"*Statistics reported are N and %AGE for Female and Non-white and MEAN +/- SD for rest"
;;
run;





*TABLE 2 FOR SMOKING CESSATION;
proc means data= work.kpsmoking3 sum mean;
  var smoke3 smoke6;
    class treatment;
	output out=work.smokingcessation
	sum=nsmoke3 nsmoke6
	mean=meansmoke3 meansmoke6;
run;


*For Group A;
data work.smokeA;
   set work.smokingcessation;
     if treatment = "A";
	amsmoke3= round(meansmoke3*100, 0.01);
	ansmoke3= round(nsmoke3, 0.01);
	amsmoke6= round(meansmoke6*100, 0.01);
	ansmoke6=round(nsmoke6,0.01);

	  keep amsmoke3 -- ansmoke6;

	run;
*For Group B;
data work.smokeB;
   set work.smokingcessation;
     if treatment = "B";
	bmsmoke3= round(meansmoke3*100, 0.01);
	bnsmoke3= round(nsmoke3, 0.01);
	bmsmoke6= round(meansmoke6*100, 0.01);
	bnsmoke6=round(nsmoke6,0.01);

	  keep bmsmoke3 -- bnsmoke6;

	run;

	*For Overall;
data work.smokeoverall;
   set work.smokingcessation;
     if treatment = " ";
	omsmoke3= round(meansmoke3*100, 0.01);
	onsmoke3= round(nsmoke3, 0.01);
	omsmoke6= round(meansmoke6*100, 0.01);
	onsmoke6=round(nsmoke6,0.01);

	  keep omsmoke3 -- onsmoke6;

	run;

data work.smokefinal;
	merge work.smokeA work.smokeB work.smokeoverall;
run;

proc print data= work.smokefinal;
run;



data _null_;

   set work.smokefinal;
   file print;
   put
/*
 1234567890123456789012345678901234567890123456789012345678901234567890 */
"		Count (%) Reporting Resumed at  		    |"/
"Variable    |  Three Months    |      Six Months   |"/
"------------+------------------+-------------------|"/

"Group A" @13 "|" ansmoke3 "("amsmoke3"%)"  
         @32 "|" ansmoke6  "("amsmoke3"%)" 
/
"Group B" @13 "|" bnsmoke3 "(" bmsmoke3"%)" 
         @32 "|" bnsmoke6  "(" bmsmoke6"%)" 
/
"Overall" @13 "|" onsmoke3 "(" omsmoke3"%)" 
         @32 "|" onsmoke6  "(" omsmoke6"%)"  
///
"*Statistics reported are N and MEAN %age"
;;
run;




*TABLE3 FOR ADVERSE EVENTS BY TREATMENT GROUP AND CENTER;


proc means data=work.kpsmoking3;
	var ae3 ae6;
	class treatment;
	output out = work.table3
		sum = ae3sum ae6sum;
run;

*Doing Overall Adverse Effects;
data table3to;
	set work.table3;
		if treatment = " ";
			oae3 = round (ae3sum, 0.01);
			oae6 = round (ae6sum, 0.01);
			oaet = oae3 + oae6;
			keep oae3 -- oaet;
run;

*Doing Overall for Treatment A;
data table3ta;
	set work.table3;
		if treatment = "A";
			aae3 = round (ae3sum, 0.01);
			aae6 = round (ae6sum, 0.01);
			aaet = aae3 + aae6;
			keep aae3 -- aaet;
run;

*Doing Overall and for Treatment B;
data table3tb;
	set work.table3;
		if treatment = "B";
			bae3 = round (ae3sum, 0.01);
			bae6 = round (ae6sum, 0.01);
			baet = bae3 + bae6;
			keep bae3 -- baet;
run;

proc means data=work.kpsmoking3;
	var ae3 ae6;
	class site;
	output out = work.table3
		sum = ae3sums ae6sums; 
;
run;

*Doing for Site 1 (Glenlake) and Overall;
data table3sg;
	set work.table3;
		if site= 1;
			Gae3 = round (ae3sums, 0.01);
			Gae6 = round (ae6sums, 0.01);
			Gaet = Gae3 + Gae6;
			keep Gae3 -- Gaet;
run;

*Doing for Site 2 (Southwood) and Overall;
data table3ss;
	set work.table3;
		if site= 2;
			Sae3 = round (ae3sums, 0.01);
			Sae6 = round (ae6sums, 0.01);
			Saet =  Sae3 + Sae6;
			keep Sae3 -- Saet;
run;

data work.completetable3;
	merge table3to table3ta table3tb table3sg table3ss;
run;

proc print data= work.completetable3;
run;




data _null_;

   set work.completetable3;
   file print;
   put
/*
 1234567890123456789012345678901234567890123456789012345678901234567890 */
"                     Number of Adverse Events Reported at                       "/
"Variable                 |   Three Months   |    Six Months   |     Overall     "/
"-------------------------+------------------+-----------------+-----------------"/
"Overall"                 @26 "|"oae3
                          @45 "|" oae6 
                          @63 "|" oaet 
/
"Group A"                 @26 "|" aae3
                          @45 "|" aae6
                          @63 "|" aaet 
/
"Group B"                 @26 "|" bae3 
                          @45 "|" bae6
                          @63 "|" baet                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
/
"Glenlake Center"         @26 "|" Gae3
                          @45 "|" Gae6
                          @63 "|" Gaet
/
"Southwood Center"        @26 "|" Sae3
                          @45 "|" Sae6
                          @63 "|" Saet
///
"*Statistics reported are total sum"
;;
run;
