This document details the Stata analysis steps for the nlsw88 dataset, which contains information on a group of women in their 30s and early 40s to study labor force patterns. The code for each step or question is shown below.
---
### Q1: Browse and Analyze the Dataset

#### 1.1: Set Your Working Directory

```stata
cd "C:\Users\rw316\Desktop\impact evaluation"
```

#### 1.2: Load the Data

```stata
sysuse nlsw88.dta, clear
```

#### 1.3: Describe the Data

```stata
describe, fullnames
```

```
Contains data from C:\Program Files\Stata18\ado\base/n/nlsw88.dta
 Observations:         2,246                  NLSW, 1988 extract
    Variables:            17                  1 May 2022 22:52
                                              (_dta has notes)
-------------------------------------------------------------------------------
Variable      Storage   Display    Value
    name         type    format    label      Variable label
-------------------------------------------------------------------------------
idcode          int     %8.0g                 NLS ID
age             byte    %8.0g                 Age in current year
race            byte    %8.0g      racelbl    Race
married         byte    %8.0g      marlbl     Married
never_married   byte    %16.0g     nev_mar    Never married
grade           byte    %8.0g                 Current grade completed
collgrad        byte    %16.0g     gradlbl    College graduate
south           byte    %9.0g      southlbl   Lives in the south
smsa            byte    %9.0g      smsalbl    Lives in SMSA
c_city          byte    %16.0g     ccitylbl   Lives in a central city
industry        byte    %23.0g     indlbl     Industry
occupation      byte    %22.0g     occlbl     Occupation
union           byte    %8.0g      unionlbl   Union worker
wage            float   %9.0g                 Hourly wage
hours           byte    %8.0g                 Usual hours worked
ttl_exp         float   %9.0g                 Total work experience (years)
tenure          float   %9.0g                 Job tenure (years)
-------------------------------------------------------------------------------
Sorted by: idcode
```

#### 1.4: Browse the Data

```stata
browse
```

#### 1.5: Count Observations

```stata
count
```


```
2,246 of observations
```

#### 1.6: Relabel the Variable "south"

```stata
label define south_test 1 "yes", add
label define south_test 0 "no", add
label values south south_test
```

#### 1.7: Tabulate the "south" Variable

```stata
tab south
```

```
   Lives in |
  the south |      Freq.     Percent        Cum.
------------+-----------------------------------
         no |      1,304       58.06       58.06
        yes |        942       41.94      100.00
------------+-----------------------------------
      Total |      2,246      100.00
```
---

### Q2: Descriptive Statistics for Hourly Wage

Compute the mean, standard deviation, 10th percentile, 25th percentile, and median (50th percentile) for the hourly wage variable.

```stata
tabstat wage, stats(N mean sd p10 p25 p50)
```

*Sample output:*

```
    Variable |         N      Mean        SD       p10       p25       p50
-------------+------------------------------------------------------------
        wage |      2246  7.766949  5.755523  3.220612  4.259257   6.27227
---------------------------------------------------------------------------
```

---

### Q3: Generate a New Variable "wage_group"

Create a new variable `wage_group` that takes the value "1" if an individual earns more than or equal to the average hourly wage and "0" if less. Then, label the variable and examine its distribution along with the occupation breakdown by wage group.

#### Step 3.1: Calculate the Mean Wage

```stata
summarize wage
```


```
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
        wage |      2,246    7.766949    5.755523   1.004952   40.74659
```

Store the mean wage in a local macro:

```stata
local mean_wage = r(mean)
```

#### Step 3.2: Generate and Replace "wage_group"

```stata
generate wage_group = wage
replace wage_group = 0 if wage_group < r(mean) // poorer individuals
replace wage_group = 1 if wage_group >= r(mean) // richer individuals
```

#### Step 3.3: Label the "wage_group" Variable

```stata
label define group_test 0 "poorer", add
label define group_test 1 "richer", add 
label values wage_group group_test
```

#### Step 3.4: Display Frequency of "wage_group"

```stata
tab wage_group
```


```
 wage_group |      Freq.     Percent        Cum.
------------+-----------------------------------
     poorer |      1,432       63.76       63.76
     richer |        814       36.24      100.00
------------+-----------------------------------
      Total |      2,246      100.00
```

*Observation: 814 individuals earn more than the mean wage (36.24% of the sample) while 1,432 earn less (63.76%).*

#### Step 3.5: Tabulate Occupation by "wage_group"

```stata
tab occupation wage_group, col
```


```
+-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

                      |      wage_group
           Occupation |    poorer     richer |     Total
----------------------+----------------------+----------
Professional/Technica |        95        222 |       317 
                      |      6.67      27.34 |     14.17 
----------------------+----------------------+----------
       Managers/Admin |       106        158 |       264 
                      |      7.44      19.46 |     11.80 
----------------------+----------------------+----------
                Sales |       518        208 |       726 
                      |     36.35      25.62 |     32.45 
----------------------+----------------------+----------
   Clerical/Unskilled |        69         33 |       102 
                      |      4.84       4.06 |      4.56 
----------------------+----------------------+----------
            Craftsmen |        36         17 |        53 
                      |      2.53       2.09 |      2.37 
----------------------+----------------------+----------
           Operatives |       208         38 |       246 
                      |     14.60       4.68 |     11.00 
----------------------+----------------------+----------
            Transport |        28          0 |        28 
                      |      1.96       0.00 |      1.25 
----------------------+----------------------+----------
             Laborers |       259         27 |       286 
                      |     18.18       3.33 |     12.78 
----------------------+----------------------+----------
              Farmers |         0          1 |         1 
                      |      0.00       0.12 |      0.04 
----------------------+----------------------+----------
        Farm laborers |         9          0 |         9 
                      |      0.63       0.00 |      0.40 
----------------------+----------------------+----------
              Service |        12          4 |        16 
                      |      0.84       0.49 |      0.72 
----------------------+----------------------+----------
    Household workers |         2          0 |         2 
                      |      0.14       0.00 |      0.09 
----------------------+----------------------+----------
                Other |        83        104 |       187 
                      |      5.82      12.81 |      8.36 
----------------------+----------------------+----------
                Total |     1,425        812 |     2,237 
                      |    100.00     100.00 |    100.00
```

*Observation: The most frequent occupation among richer individuals (222 people) is **Professional/Technical** (27.34%), while among poorer individuals (518 people) it is **Sales (36.35%)**.*

---

### Q4: Drop Individuals with Missing Information

Drop observations with missing values in the variables `industry`, `occupation`, `grade`, `union`, `hours`, and `tenure` using a loop.

```stata
foreach var in industry occupation grade union hours tenure { 
    drop if missing(`var')
}

/* Expected output messages:
   (14 observations deleted)
   (4 observations deleted)
   (2 observations deleted)
   (367 observations deleted)
   (1 observation deleted)
   (10 observations deleted)
*/
```

---

### Q5: Differences in Hourly Wage and Usual Hours Worked by Marital Status

Examine descriptive statistics and perform t-tests to assess differences between married and single individuals.

#### Step 5.1: Descriptive Statistics by Marital Status

```stata
tabstat wage, stats(N mean sd min max p25 p50 p75) by(married)
```

#### Step 5.2: t-tests for Wage and Hours

```stata
ttest wage, by(married)
ttest hours, by(married)
```

*Observation: Single individuals earn a significantly higher mean wage and work more hours per week than married individuals. One possible explanation is that single individuals may opt for higher-paying jobs or work longer hours due to fewer family responsibilities.*

---

### Q6: Differences by Never Married Status and Divorced Count

Perform t-tests comparing individuals who were never married versus those who were, and tabulate the `married` and `never_married` variables to count divorced individuals.

#### Step 6.1: t-tests for Never Married Status

```stata
ttest wage, by(never_married)
ttest hours, by(never_married)
```

#### Step 6.2: Tabulate Married vs. Never Married

```stata
tab married never_married
```

*Observation: There are 443 divorced individuals. The results indicate that individuals who have never been married earn significantly higher wages, while those who have been married work more hours, suggesting that wage differences may be driven by hours worked.*

---

### Q7: Distribution of Hourly Wages and Top Earners

Plot the distribution of hourly wages and examine the occupation distribution of individuals earning more than \$40 per hour.

#### Step 7.1: Set Up Graph Schemes and Plot Histogram

```stata
ssc install schemepack, replace
ssc install blindschemes, replace 
set scheme plotplain, permanently
set scheme tab1
histogram wage
graph export "wage-distribution.png", as(png) replace
```

*Observation: The histogram is positively skewed, indicating that the median wage is lower than the mean wage, with a few individuals earning considerably more.*

#### Step 7.2: Identify Top Earners and Tabulate Occupation

```stata
generate top_earner = wage
replace top_earner = 0 if top_earner <= 40
replace top_earner = 1 if top_earner > 40
tab occupation top_earner
```

*Observation: Out of 17 top earners, 5 work in Sales—the most frequent occupation among top earners. Note that after dropping observations with missing variables, there may be no high earners left.*

---

### Q8: Regression of Hourly Wage on Marital Status

Run a regression of hourly wage on marital status.

```stata
regress wage married
```

*Observation: The regression confirms that married individuals earn significantly lower wages than single individuals (approximately 0.48 lower on average). However, marital status explains only a small portion of wage variation (low R-squared).*

---

### Q9: Regression of Hourly Wage on Marital Status, Controlling for Hours Worked

Run a regression including both marital status and usual hours worked.

```stata
regress wage married hours
```

*Observation: After controlling for hours worked, the wage difference between married and single individuals becomes statistically insignificant. This suggests that the lower wages among married individuals are largely driven by them working fewer hours. The model's adjusted R-squared increases slightly, though overall explanatory power remains low.*

---

### Q10: Graphing the Relationship Between Average Wage and Hours Worked by Occupation

Collapse the data to compute the mean hourly wage and mean hours worked for each occupation, then create a scatter plot with occupations labeled.

#### Step 10.1: Collapse Data by Occupation and List Results

```stata
collapse (mean) wage hours, by(occupation)
list
```

#### Step 10.2: Create the Scatter Plot

```stata
scatter wage hours, mlabel(occupation) xlabel(, angle(45)) ylabel(, angle(0)) ///
    title("Relationship Between Average Wage and Hours by Occupation") ///
    xtitle("Average Hours Worked") ytitle("Average Hourly Wage")
graph export "Average-wage-and-usual-occupation-hours.png", as(png) replace

