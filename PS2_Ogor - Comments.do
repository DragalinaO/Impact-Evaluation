*Replicating Table 1:  PROPORTION OF PUPILS RECEIVING DEWORMING TREATMENT IN PSDP


clear all 
set more off

global path = "C:\Users\rw316\Desktop\impact evaluation\PS2"
cd "$path" 

/*(a) First thing we need to show is that the groups were similar prior to the intervention. This is what Table I does.

(i) Why do we need to show this?
In order to show that the difference comes indeed from the treatment. 
*/
/*
(ii) We will use namelist and schoolvar datasets. Open both and familiarize yourself with the
variables and the data in general.
*/
use namelist, clear

browse

 
 /*
 (b) Open the namelist dataset. Since we are interested in the pretreatment variables, we should
restrict the sample to the earliest visit by dropping all observations from all later visits.
 */

 keep if visit == 981

 */(c) It seems that in the original paper there were some issues with duplicate observations. The authors detected these and marked them using the variable dupid. Drop the duplicate observations. (This means that you will find some differences in results compared to the published tables; the authors admitted to this)
*/

drop if dupid==2

/*
(d) Now merge the dataset with the pupq dataset. Use pupid as the unique identifier.
*/
* Merge with the pupils questionnaire dataset		
merge 1:1 pupid using pupq


/*
(e) Create the following variables:
(i) Share of days absent from school in previous 4 weeks (they have 5 school days/week in
Kenya) (see absdays_98_6).
(ii) Child is often sick (see fallsick_98_37).
(iii) Child is clean (see clean_98_15).
*/

gen preatt_98 = (20-absdays_98_6)/20 

gen soften_98 = (fallsick_98_37==3) 
replace soften_98 = . if fallsick_98_37==. 

gen clean_98 = (clean_98_15==1) 
replace clean_98 = . if clean_98_15==.

/*
Read footnote a) to Table I. The authors use school averages weighted by population.
 We want to replicate entire Panel A and the following variables of Panel B: Attendance recorded in school registers; Blood in stool; Child is often sick; Malaria; Child is clean. 
 
 You can use collapse command in stata, using the (mean) option to generate averages across groups (remember, by school), and (count) will generate the number of students in a particular school. 
 When doing summarize, use analytical weights by number of pupils aweight (see help).

*/

/*
(g) In order to examine the group difference, use a regression model that regresses the variable of interest on group treatments 1 and 2 (wgrp1 wgrp2). Again, use analytical weights as in the step above (aweight), weight again by number of pupils per school
*/

*** Panel A
preserve
collapse sex elg98 stdgap yrbirth preatt_98 bloodst_98_58 soften_98 malaria_98_48 clean_98 wgrp* (count) npup = pupid, by(schid)
bysort wgrp: sum sex elg98 stdgap yrbirth [aw=npup]
foreach var in sex elg98 stdgap yrbirth { 
	regress `var' wgrp1 wgrp2 [aw=npup]
	}
restore	

*** Panel B
preserve

drop if pupdate_98_1=="" &  schid_98_2==. 
collapse (mean) preatt_98 bloodst_98_58 soften_98 malaria_98_48 clean_98 wgrp* (count) npup = pupid, by(schid)
* Summary stats and "t-tests"
bys wgrp: sum preatt_98 bloodst_98_58 soften_98 malaria_98_48 clean_98 [aw=npup]
foreach var in preatt_98 bloodst_98_58 soften_98 malaria_98_48 clean_98 { 
	regress `var' wgrp1 wgrp2 [aw=npup]
	} 
	
restore	
	

/*(h) In order to replicate Panel C, we need to use the school level data in schoolvar.dta. We want to
replicate the following variables: Distance from Lake Victoria; Pupil population; School latrines
per pupil; Proportion moderate-heavy infections in zone; Group 1 pupils within 3km; Group 1
pupil within 3-6 km; Total primary school pupils within 3km; Total primary school pupils within
3-6 km. No need for weighting here, otherwise follow the same procedure as for Panels A and B
*/

*** Panel C

use "schoolvar", clear

bysort wgrp: sum distlake pup_pop latr_pup z_inf98 pop1_3km_updated pop1_36k_updated  popT_3km_updated popT_36k_updated

gen wgrp1 = (wgrp==1)
gen wgrp2 = (wgrp==2)
gen wgrp3 = (wgrp==3)
foreach var in distlake pup_pop latr_pup z_inf98 pop1_3km_updated pop1_36k_updated  popT_3km_updated popT_36k_updated { 
	regress `var' wgrp1 wgrp2
	} 

	
**Fernanda's comments: code 2/4, Excel/Latex: 1/4, comments: 1/2
** The do-file is missing code to export the results to Excel or LaTeX. I could not find any Excel or LaTeX file. The only output is a picture in the pdf, which is not in LaTeX format. Additionally, I do not see any brief explanation of the results.