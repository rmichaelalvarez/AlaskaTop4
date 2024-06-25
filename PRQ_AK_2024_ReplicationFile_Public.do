********************************************************************************
/*
   J. Andrew Sinclair, R. Michael Alvarez, Christian R. Grose, Betsy Sinclair
   
   Paper: Alaska 2022 Top-4/RCV, Submitted June 2023
                                 RR Re-submitted Jan. 2024
								 Final Version Submitted May 2024
								 Replication File June 2024
   

   This replication file loads the data used in the analysis and replicates
        the analysis in the text of the paper.  
		
		This is the complete code, but due to our current research we are 
		not releasing the original dataset until 2026.
	
   
		
   ** Note: 
   ---> This uses tabout beta version 3.09
        To install, you have to install manually from here:
                  https://tabout.net.au/docs/home.php
        The standard version of tabout is version 2.
		    Do not use tabout version 2 for replicating our results.
   
   ---> This uses coefplot 1.7.5 29jan2015 Ben Jann
   
   ---> This uses mplotoffset 1.1.1 14mar2015
   
   ** Also Note: you will need to adjust file paths to match
                 where you store the data & want the outputs
				 on your computer!
	  
	
      For questions, please contact: asinclair@cmc.edu	
   
*/
********************************************************************************





********************************************************************************
* Setup

* Clear out anything already open:
capture log close
clear all

* Set working conditions, graphics font:
set more off
graph set window fontface "Arial"

* ID User Name, File Path Type:		  
if `"`c(os)'"' == "MacOSX" global stem `"/users/`c(username)'/"'
if `"`c(os)'"' == "Windows" global stem `"C:/Users/`c(username)'/"'

* Set Directory:
global projdir `"${stem}/Dropbox/Primary Projects/Alaska 2022/AK Paper Submission Folder/PRQ Final Submission May 2024/PRQ AK 2024 Data and Code"'
cd "${projdir}"

* Set up Log File:
log using ///
  "PRQ_AK_2024_Replication_Public_LOG.log" ///
  , replace

* Check programs:
which tabout
which coefplot 
which mplotoffset

* Open Data File:
use "Alaska2022Data_ReplicationReady.dta"
 
 
 
 

 
 
	
/*  Tables, Figures, and Results. */

svyset [pw=Weight] 

* Table 1.  Data from: https://www.elections.alaska.gov/election-results/

        /* Note: the summary pages do not give the RCV results.
		         You have to click "Ranked Choice Voting Tabulations"
				 on the right side of the page to see the RCV 
				 results for each race. 
				 */

* Table 2, RCV results, Senate  
   
   *** Round 1
   svy: tab SEN_R1, percent format(%9.0f)
   tabout SEN_R1 ///
     using "tables and figures/Table2.txt", ///
	 replace ///
	 svy oneway mult(100) c(col) format(0)
   
   *** Round 2/3
   forvalues i=2/3 {
     svy: tab SEN_R`i', percent format(%9.0f)
     tabout SEN_R`i' ///
       using "tables and figures/Table2.txt", ///
	   append ///
	   svy oneway mult(100) c(col) format(0) 	
   }

   *** In Text Comments near Table 2:
   **** House preference question recovers approximately the first round of the House RCV (In the footnote.)
   svy: tab HousePref, percent format(%9.0f)
   **** House Preference related to first round Senate Vote (main text)
   svy: tab HousePref SEN_R1, row percent format(%9.0f)
   **** 92% of Murkowski's 1st round support is from Peltola supporters:
   svy: tab HousePref SEN_R1, col percent format(%9.0f)
   **** Chesbro 1st rounders picked Murkowski in 2nd round on survey:
      svy: tab SEN_Order1 SEN_Order2, row percent format(%9.0f)
  
* Table 3, AK SEN Round 1 by Factional Type    
  *** look at the data
  svy: tab faction SEN_Order1, row percent format(%9.0f)
  svy: tab IDEO5 SEN_Order1, row percent format(%9.0f)
  
  *** Add the column percentages to Table 3 -->
  svy: tab faction, percent format(%9.0f)
  svy: tab IDEO5, percent format(%9.0f)
  svy: tab ideoparty, percent format(%9.0f)
  svy: tab no_impeach, percent format(%9.0f)
  
  *** Make Table 3
  tabout faction IDEO5 ideoparty no_impeach SEN_Order1 ///
     using "tables and figures/Table3.txt", ///
	    replace ///
	    svy mult(100) c(row) format(0)  
 
  *** In Text Comments, Footnotes
  **** How many supported *specific* people (in the bulleted list)
  tab AK_110 
  svy: tab AK_110, percent format(%9.2f)
  
 
 
 
 
* Table 4, AK SEN Pairwise Comparisons
  
  ** Make Table 4
  forvalues i=5/7 {
  	 svy: tab AK_20`i' mythPID3, col percent format(%9.0f)
  }
  
  tabout h2h_* mythPID3 ///
     using "tables and figures/Table4.txt", ///
	    replace ///
	    svy mult(100) c(col) format(0) 
   *** In text comments
     **** Before Table 4 (Murkowski wins only 19% of her party)
	 svy: tab SEN_R1 mythPID3, col percent format(%9,0f)
     ****
     svy: proportion h2h_CT  
	 **** Voting strategy among Ds/Inds; secondary claim: 1-in-3 of Murkowski voters
	 svy, subpop(if mythPID3<=2): tab  SEN_R1 votestrategy, percent format(%9.0f)
	 svy, subpop(if mythPID3<=2): tab  SEN_R1 votestrategy, row percent format(%9.0f)  
     **** The 8% who prefer Chesbro but vote Murkowski
	 svy, subpop(if mythPID3==1): tab SEN_R1 h2h_MC, percent format(%9.0f)
	 **** 38% split murkowski/Peltola 
	 svy: tab murkpelt, percent format(%9.0f)
 
   
 
 
* Table 5, Attitudes Towards AK's Election System by Party  

  ** Examine Data  
  foreach Q in confidence easy benefit AKsystem {
  	svy: tab exp_`Q' mythPID3, col percent format(%9.0f)
  }
  
   ** Make Table
   tabout exp_* mythPID3 ///
     using "tables and figures/Table5.txt", ///
	    replace ///
	    svy mult(100) c(col) format(0)  
  
* Table 6, Primary Type Preferences by Party  
  
  ** Examine Data
  forvalues i=1/3 {
  	svy: tab primpref`i' mythPID3, col percent format(%9.0f)
  }
  

  ** Make Table 6
    tabout primpref* mythPID3  ///
     using "tables and figures/Table6.txt", ///
	    replace ///
	    svy mult(100) c(col) format(0)  
    
  *** In text near Table 6
  **** Primary Preference branching summary
  svy: tab ruleorder, missing percent format(%9.0f)
     ***** to check on ordering:
     tab ruleorder primpref1, missing
	 tab ruleorder primpref2 if primpref1==1, missing
	 tab ruleorder primpref3 if primpref1==2, missing
 
 
* Figure 1. Figure 2: Multinomial Logist Regression for Primary Type 
 
svy, over(mythPID3): mean POP_*


* Run the Model
svy: mlogit ruleorder ib1.mythPID3 ///
                      c.POP_antielite c.POP_antiexpert c.POP_nationalID ///
                      ib1.over50 ib1.male2 ib1.white ib1.collplus ///
      , baseoutcome(1)
 estimates store MPSA2023_MNL
 

** Figure 1: The Coefplot
estimates restore MPSA2023_MNL
coefplot ///
    (MPSA2023_MNL, keep(Closed_Partisan:*) ///
             label ("Prefer Closed Primary") ///
			 msymbol(o) mcolor(black)) ///
    (MPSA2023_MNL, keep(Open_Partisan:*) ///
             label ("Prefer Open Primary") ///
			 msymbol(oh) mcolor(black)) ///		
    (MPSA2023_MNL, keep(Top_2:*) ///
             label ("Prefer Top-2 Primary") ///
			 msymbol(x) mcolor(black)) ///				 
	 , scheme(burd) ///
	 xline(0, lcolor(black)) drop(_cons) ciopts(lcolor(black)) ///
	    legend(pos(6) col(1)) ///
		xtitle("Estimate and 95% CIs" "Multinomial Logistic Regression") ///
		  headings( ///
		     2.mythPID3="{bf: Party ID}" ///
			 POP_antielite="{bf: Populism Scores}" ///
		     0.over50="{bf: Controls}") ///
	note("Base outcome is preference for Top-4/RCV.", span pos(5))
	graph display, ysize(6) xsize(4)
    graph export "tables and figures/Fig1.emf", replace
                                   

** Figure 2: Marginsplot
estimates restore MPSA2023_MNL
 
 *** Do 3 sets of marginsplots, then combine
 local fig2interiortextsize large
 **** Fig 2a
margins, at(  ///
         POP_antielite=(0(.125)1) ///
		 mythPID3=(3) ///
		 POP_antiexpert=.5 POP_nationalID=.5 ///
		 over50=1 male2=1 white=1 collplus=1) predict(outcome(1)) predict(outcome(4))			

 mplotoffset, xdimension(POP_antielite) recast(line) offset(0) ///
   ytitle("Pr(Preference)", size(`fig2interiortextsize')) ///
   ylabel(0(.25)1) ////
   xtitle("Anti-elite Populism Score", size(`fig2interiortextsize')) ///
   xlabel(0(.25)1) ///
   plot1opts(lcolor(black) lpattern(dash) lwidth(thick)) ///
   plot2opts(lcolor(black) lpattern(solid) lwidth(thick)) ///
   recastci(rarea) ///
   ci1opts(fcolor(gray) fintensity(25) lcolor(black)) ///
   ci2opts(fcolor(gray) fintensity(10) lcolor(black)) ///
   legend(order(3 "Pr(Prefer Top-4)" 4 "Pr(Prefer Closed)") ///
   symxsize(*3) rows(1) pos(6) span) ///
   scheme(burd) ///
   title("") 

    graph save "tables and figures/Fig2a.gph", replace
   
  **** Fig 2b   
margins, at(  ///
         POP_antiexpert=(0(.25)1) ///
		 mythPID3=(3) ///
		 POP_antielite=.5 POP_nationalID=.5 ///
		 over50=1 male2=1 white=1 collplus=1) predict(outcome(1)) predict(outcome(4))
  
 mplotoffset, xdimension(POP_antiexpert) recast(line) offset(0) ///
   ytitle("Pr(Preference)", size(`fig2interiortextsize')) ///
   ylabel(0(.25)1) ////
   xtitle("Anti-expert Populism Score", size(`fig2interiortextsize')) ///
   xlabel(0(.25)1) ///
   plot1opts(lcolor(black) lpattern(dash) lwidth(thick)) ///
   plot2opts(lcolor(black) lpattern(solid) lwidth(thick)) ///
   recastci(rarea) ///
   ci1opts(fcolor(gray) fintensity(25) lcolor(black)) ///
   ci2opts(fcolor(gray) fintensity(10) lcolor(black)) ///
   legend(order(3 "Pr(Prefer Top-4)" 4 "Pr(Prefer Closed)") ///
   symxsize(*3) rows(1) pos(6) span) ///
   scheme(burd) ///
   title("") 

    graph save "tables and figures/Fig2b.gph", replace  
	
  **** Fig 2c 	
margins, at(  ///
         POP_nationalID=(0(.25)1) ///
		 mythPID3=(3) ///
		 POP_antielite=.5 POP_antiexpert=.5 ///
		 over50=1 male2=1 white=1 collplus=1) predict(outcome(1)) predict(outcome(4))
  
 mplotoffset, xdimension(POP_nationalID) recast(line) offset(0) ///
   ytitle("Pr(Preference)", size(`fig2interiortextsize')) ///
   ylabel(0(.25)1) ////
   xtitle("National Identity Populism Score", size(`fig2interiortextsize')) ///
   xlabel(0(.25)1) ///
   plot1opts(lcolor(black) lpattern(dash) lwidth(thick)) ///
   plot2opts(lcolor(black) lpattern(solid) lwidth(thick)) ///
   recastci(rarea) ///
   ci1opts(fcolor(gray) fintensity(25) lcolor(black)) ///
   ci2opts(fcolor(gray) fintensity(10) lcolor(black)) ///
   legend(order(3 "Pr(Prefer Top-4)" 4 "Pr(Prefer Closed)") ///
   symxsize(*3) rows(1) pos(6) span) ///
   scheme(burd) ///
   title("") 

    graph save "tables and figures/Fig2c.gph", replace  	
  
	 grc1leg "tables and figures/Fig2a.gph" ///
	         "tables and figures/Fig2b.gph" ///
			 "tables and figures/Fig2c.gph" ///
			 , ///
			 scheme(burd) col(1) ///
			 iscale(.9) 
			 *title("Predicted Probabilities, 95% CIs", pos(11) size(large))*
	 graph display, ysize(7.5) xsize(4) 
	 graph export "tables and figures/Fig2.emf", replace			  
  
 
 *** In text discussion following Figures 1 and 2:
  **** Populism averages (in footnote)
  svy, over(mythPID3): mean POP_*
 
 
/* 4.  Appendix. */ 

* Fig. A1: Distribution of the Sample Survey Weight.

histogram Weight, frequency xlabel(0(2)12, format(%9.0f)) scheme(burd)

* Table A4: Pairs of Candidate Rankings 


  
  svy: tab SEN_Order1 SEN_Order2, cell percent format(%9.0f)
  
  tabout SEN_Order1 SEN_Order2 ///
     using "tables and figures/TableA4.txt", ///
	    replace ///
	    svy mult(100) c(cell) format(0)  
 

  *** Comment on the strategy question
  svy: tab AK_211 SEN_Order2, missing cell percent format(%9.0f)

* Table A5: Populism Questions

  /* This is background information on the questions,
     Not data. */

 
  ** Table A6: Populism Scores
     **** This replaces one that used a binary preference on the last Senate round.
    tabout pop4* prespref ///
     using "tables and figures/TableA6.txt", ///
	    replace ///
	    svy mult(100) c(col) format(0) 
	*** supplement 
	svy: tab prespref, format(%9.0f) percent 
	svy: tab AK_105, format(%9.0f) percent 	
	*** In text comment	
    svy: mean popscale, over(faction)
	
 ** Table A7	
 *** For a discussion of the populism scores and primary preferences directly:
 
  foreach q in 401 402 403 406 {
  	di "#####################"
  	di "Question `q'"
  	svy: tab pop`q' ruleorder, percent format(%9.0f) row
  }
  
  *** Other looks at the data
  svy, subpop(if mythPID3!=3): tab POP_antielite ruleorder, cell percent format(%9.0f)
  svy, subpop(if mythPID3==3): tab POP_antielite ruleorder, cell percent format(%9.0f)
  
  svy, subpop(if mythPID3!=3): tab POP_antielite ruleorder, row percent format(%9.0f)
  svy, subpop(if mythPID3==3): tab POP_antielite ruleorder, row  percent format(%9.0f)
  
  *** Output table A7
    tabout POP_antielite ruleorder if mythPID3!=3 ///
     using "tables and figures/TableA7.txt", ///
	    replace ///
	    svy mult(100) c(cell) format(0)   
		
    tabout POP_antielite ruleorder if mythPID3==3 ///
     using "tables and figures/TableA7.txt", ///
	    append ///
	    svy mult(100) c(cell) format(0)   	
		

		
* A Final Note

tab SGEN AK_503 
		
		
		
*fin 
log close
beep
exit  		
  
  
	