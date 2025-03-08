
---
title: "Impact Evaluations for Social Programs"
date: "Winter Semester 2022"
---
```{r}
*** Part 1 (5pt): Working with Stata
///////////////////////////////////////////////////////////////////////////////
// Set your working directory
cd \"..\"
// Load the data - nlsw88.dta: The NLSW88 data contains data of a group of women in their 30s and early 40s to study labor force patterns.
sysuse nlsw88.dta, clear
describe, fullnames // have a look at the variables in the data
// Q1: How many observations are there? How many variables? How many individuals live
// in the south?


// Re-label the variable \"south\" so that the value \"1\" is labeled \"yes\" and \"0\" is labeled \"no\".
// Q2: Give the mean, the sd, the 10th percentile, the 25th percentile and the median
// of the hourly wage in this country.
// Q3: Generate a new variable \"wage_group\" that takes the value \"1\" if the individual
// earns more (>=)
// than the average hourly wage in the sample, and \"0\" if not (<). Don't forget to label
// the variable and its values.
// How many individuals earn more than the mean? Which profession is the most frequent
// in the \"richer\" group?
// In the \"poorer\" group? Give frequencies and percentage shares.
// Q4: Drop individuals for which there is missing information in the variables industry, 
// occupation, grade, union, hours and tenure !!! using a loop !!!.
// Q5: According to this sample, is there a !!significant!! difference in hourly wage
// between married and single people?
// Is there also a significant difference in terms of usual hours worked?
// Can you think of an explanation for these results?
// Q6: Is there a significant difference between people that were never married and those that were?
// Are these results in line with what you found for Q5? How many individuals are divorced?
// Q7: Check the distribution of hourly wages in this country using a graph. What can you say?
// Check how many individuals in the sample earn more than 40$ per hour. Which occupation
// is the most frequent among these individuals?
// Q8: Regress hourly wages on marriage status, and interpret the coefficient.
// Q9: In a second regression, regress hourly wages on marriage status, controlling
// for usual hours worked. What can you say about the results?
// Q10: Create a graph that represents the relationship between the average hourly wage
// and the average usual hours worked for each occupation. (Hint: collapse function might be useful here)
///////////////////////////////////////////////////////////////////////////////
*** Part 2 (5pt): Questions about Baird et al. 2011 - Cash or conditions? Evidence
*** from a cash transfer experiment
*** Answer directly in the dofile
///////////////////////////////////////////////////////////////////////////////
// Q1 (1pt): What is the research question the authors address in their paper?
// Why is it relevant?
// Q2 (2pt): Explain the difference between conditional cash transfers and unconditional cash transfers.
// What are the advantages and disadvantages of both transfers? (2pts)
// Q3 (2pt): According to the authors, why is there a significant reduction in teen pregnancies and marriage in
// the UCT arm but no significant effect in the CCT arm?
")

