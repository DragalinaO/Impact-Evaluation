////////////////////////////////////////////////////////////////////////////////
/* Impact Evaluations for Social Programs

////////////////////////////////////////////////////////////////////////////////
/ Problem Set 1 - due 21/11/2024 23:59 
/ Submit on Moodle
/ with the format PS1_Ogor.do 
////////////////////////////////////////////////////////////////////////////////

/ Author: Charlotte Robert
/ Heidelberg University - Winter Semester 2024/25
/ Student version
*/
////////////////////////////////////////////////////////////////////////////////
// Grade: /10
////////////////////////////////////////////////////////////////////////////////

/* !!!!!!!!!!!!!!!!!!!!!!!! Remember:
To execute a do-file:
- highligh the command on your do
- press Ctrl + d or click on the button "Execute"
Do NOT copy-paste in the window command 
*/


////////////////////////////////////////////////////////////////////////////////
*** Part 1 (5pt): Working with Stata  
/*
Answer questions directly on the do file
Make your code visible in your answer to each question: your results should be replicable using your dofile only. 
Using slash star, copy all tables on the do file. Export your graphs and join them to your email when submitting your PS. 
You may need to search for commands that were not yet introduced in the tutorial - learning to Google questions is an essential skill! 
0.5pt per correct answer, 0.25 if partly correct.
*/
////////////////////////////////////////////////////////////////////////////////
clear all
// Set your working directory 
cd "C:\Users\rw316\Desktop\impact evaluation"

//Load the data - we are using data directly available in stata
sysuse nlsw88.dta , clear
describe, fullnames //have a look at the variables in the data 

browse

// Q1: How many observations are there? How many variables? How many individuals live in the south?

// Re-label the variable "south" so that the value "1" is labeled "yes" and "0" is labeled "no". 

count

label define south_test 1 "yes", add
label define south_test 0 "no", add
label values south south_test
tab south

/*observations: 2246; variables: 17; individuals living in the south: 942
*/

 
// Q2: Give the mean, the sd, the 10th percentile, the 25th percentile and the median of the hourly wage in this country. 

tabstat wage, stats(N mean sd p10 p25 p50)

** Fernanda's comment: Here, you did not provide the result as a comment.. -0.25 points

// Q3: Generate a new variable "wage_group" that takes the value "1" if the individual earns more (>=) 
// than the average hourly wage in the sample, and "0" if not (<). Don't forget to label the variable and its values. 
// How many individuals earn more than the mean? Which profession is the most frequent in the "richer" group? 
// In the "poorer" group? Give frequencies and percentage shares. 


* Calculate the mean wage
summarize wage
local mean_wage = r(mean)


generate wage_group = wage
replace wage_group = 0 if wage_group < r(mean) // "poorer individuals "
replace wage_group = 1 if wage_group >= r(mean) // "richer individuals"

label define group_test 0 "poorer",add
label define group_test 1 "richer",add 
label values wage_group group_test
tab wage_group
/*
814 individuals earn more than the mean wage, which are 36.24% of our sample. 
63.76% (1432) of the sample earns less than the mean wage. 
*/

tab occupation wage_group, col 

/* the most frequent occupation among richer individuals (222 people) is Professional/Technical(27.34%).
The most frequent occupation among poorer individuals (518) is Sales (36.35 %)
*/ 

// Q4: Drop individuals for which there is missing information in the variables industry, occupation, grade, union, hours and tenure !!!using a loop!!!. 
ssc install mdesc, replace 
mdesc 

foreach var of varlist* {
    drop if missing(`var')
	}

mdesc
** Fernanda's comment:
/*
foreach var of varlist* {
  2.     drop if missing(`var')
  3.         }
(0 observations deleted)
(0 observations deleted)
(0 observations deleted)
(0 observations deleted)
(0 observations deleted)
(2 observations deleted)
(0 observations deleted)
(0 observations deleted)
(0 observations deleted)
(0 observations deleted)
(14 observations deleted)
(4 observations deleted)
(367 observations deleted)
(0 observations deleted)
(1 observation deleted)
(0 observations deleted)
(10 observations deleted)
(0 observations deleted)
*/


*What should be deleated* -0.25 points 
/*foreach var in industry occupation grade union hours tenure {
    drop if missing(`var')
}

/* (14 observations deleted)
(4 observations deleted)
(2 observations deleted)
(367 observations deleted)
(1 observation deleted)
(10 observations deleted) 
*/

// Q5: According to this sample, is there a !!significant!! difference in hourly wage between married and single people? 
// Is there also a significant difference in terms of usual hours worked? 
// Can you think of an explanation for these results? 


tabstat wage, stats(N mean sd min max p25 p50 p75) by(married)

/* To test if the difference in wage and hours worked is significant we need to perform a t-test. 

The analysis shows that single individuals earn a statistically significantly higher mean wage than married individuals, with an estimated mean difference of 0.477 and a confidence interval above 0

Single individuals work statistically significantly more hours per week than married individuals, with an estimated mean difference of 3.476
The p-value <0.0001 indicates strong evidence against the null hypothesis of no difference.

Reasons: Single individuals might gravitate towards jobs with higher pay, possibly due to fewer family-related responsibilities or greater focus on career advancement. They could also have more time to dedicate for tenure.

*/

ttest wage, by(married)

ttest hours, by(married)

// Q6: Is there a significant difference between people that were never married and those that were? 
// Are these results in line with what you found for Q5? How many individuals are divorced? 

ttest wage, by(never_married)

ttest hours, by(never_married)

tab married never_married

/*
There are 443 divorced individuals.

Individuals who have never been married earn statistically significantly higher wages on average compared to those who have been married. The estimated difference in mean wages is -1.007

However, individuals that have been married work 2.78317 more hours than individuals who have never been married, hinting toward the pay difference being due to more hours worked compared to Q5.

*/

// Q7: Check the distribution of hourly wages in this country using a graph. What can you say? 

ssc install schemepack, replace
ssc install blindschemes, replace 
set scheme plotplain, permanently

set scheme tab1
histogram wage
graph export "wage-distribution.png", as (png) replace
/*
The graph is positively skewed, meaning the median is smaller than the mean and there are few people that earn a lot more than the average.
*/

// Check how many individuals in the sample earn more than 40$ per hour. Which occupation 
// is the most frequent among these individuals? 

generate top_earner = wage
replace top_earner = 0 if top_earner <= 40
replace top_earner = 1 if top_earner > 40

tab occupation top_earner
/*
Out of 17 top earners, 5 of them work in Sales, which is the most frequent occupation among this group. 

However, after dropping all the data with missing variables, there are no more high earning individuals in the data
*/

// Q8: Regress hourly wages on marriage status, and interpret the coefficient. 

regress wage married

/*
The regression confirms that married individuals earn significantly lower wages compared to single individuals, with a mean difference of about 
0.48. However, marital status explains only a small fraction (R squared is low) of the variation in wages, suggesting that other factors are more important in determining earnings.
*/

// Q9: In a second regression, regress hourly wages on marriage status, controlling 
// for usual hours worked. What can you say about the results? 
regress wage married hours

/*
Once we account for hours worked, the difference in wages between married and single individuals is no longer statistically significant. This indicates that the previously observed wage penalty for married individuals is largely attributable to the fact that they tend to work fewer hours. Model is also imroved with a higher adjusted R squared, however it is still low. Only 1.83% of variations can be explained with our model.

Usual hours worked is a significant predictor of wages, with longer work hours associated with higher pay
*/

// Q10: Create a graph that represents the relationship between the average hourly wage and the 
// average usual hours worked for each occupation. (Hint: collapse function might be useful here)  
collapse (mean) wage hours, by(occupation)
list

scatter wage hours, mlabel(occupation) xlabel(, angle(45)) ylabel(, angle(0)) ///
    title("Relationship Between Average Wage and Hours by Occupation") ///
    xtitle("Average Hours Worked") ytitle("Average Hourly Wage")
	
graph export "Average-wage-and-usual-occupation-hours.png", as (png) replace

////////////////////////////////////////////////////////////////////////////////
*** Part 2 (5pt): Questions about Baird et al. 2011 - Cash or conditions? Evidence 
*** from a cash transfer experiment
*** Answer directly in the dofile 
////////////////////////////////////////////////////////////////////////////////

// Q1 (1pt): What is the research question the authors address in their paper?
// Why is it relevant?

/*
The researchers address whether Conditional Cash Transfers (CCTs) are more effective than Unconditional Cash Transfers (UCTs)
in improving educational outcomes, such as school attendance and learning, and reducing early marriage and teenage pregnancy
among schoolgirls in Malawi. This question is relevant because it informs policymakers about the comparative advantages of 
targeted incentives (CCTs) versus direct financial support (UCTs) in achieving long-term developmental goals in low-income 
settings.

They also experiment with providing the transfers to the parents compared to the school girls
*/

// Q2 (2pt): Explain the difference between conditional cash transfers and unconditional cash transfers.
// What are the advantages and disadvantages of both transfers? (2pts)

/*
CCTs: Require recipients to meet specific conditions to receive the cash, such as maintaining a minimum 80% attendance rate,
as outlined in the experiment. The advantage of CCTs is that they are more targeted and can influence participants to 
achieve positive spillover effects, such as improved performance in mathematics and language. However, these programs are
more complex to implement, and monitoring compliance adds administrative costs. Additionally, meta-analyses suggest that 
targeted transfers may not always outperform UCTs, as the benefits often come at the expense of students who drop out due to
an inability to meet the program's conditions.

UCTs: These transfers are unconditional and not tied to any specific compliance requirements, making them simpler to 
administer. They can have positive effects for populations at risk of exclusion also called CCT noncomplying strata in the paper.
For example, in the study, several girls in both treatment arms were unable to continue school despite receiving cash 
transfers and had to drop out. However, girls in the UCT treatment group showed lower rates of early marriage and pregnancy
compared to girls who dropped out of the CCT program. The main disadvantage of UCTs is their higher cost and the lack of a 
specific condition, which can be perceived by regulators or the public as less fair compared to targeted programs.

*/

// Q3 (2pt): According to the authors, why is there a significant reduction in teen pregnancies and marriage in 
// the UCT arm but no significant effect in the CCT arm?  

/*
According to the authors, the significant reduction in teenage pregnancies and marriages in the UCT arm is due to its 
direct income effect on those who dropped out of school. Unlike the CCT arm, which focuses on keeping girls in school to 
delay marriage and pregnancy, the UCT arm impacted behavior among dropouts by providing financial resources. This financial
support likely reduced economic pressures that often lead to early marriage and childbearing.

In contrast, the CCT arm showed no significant effect on teen pregnancies or marriage because its influence relied on 
preventing school dropouts, which represented a smaller group in the sample. Although CCTs were effective in increasing 
school enrollment and attendance, they had minimal impact on reducing these outcomes for those who dropped out, making their 
overall effect on marriage and pregnancy negligible.
*/
