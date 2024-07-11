CREATE	DATABASE	Bank_Analysis;
use Bank_Analysis;

SELECT * FROM Finance_1;
SELECT * FROM Finance_2;

#---------------- 1st KPI (Year wise loan amount states)------------------------#
SELECT YEAR(issue_d) as 'year' , round(sum(loan_amnt),2) As Total_loan_amount,count(loan_amnt) as Count_loans,
			avg(loan_amnt) as Avg_loan_amount,max(loan_amnt) as Min_Loan_Amount, min(loan_amnt) as Min_Loan_Amount,
            round(stddev(loan_amnt),2) as StdDev_Loan_Amount
 FROM Finance_1
 GROUP BY 1
 ORDER BY 1;
 
 #------------------2nd KPI (Grade and Sub Grade Wise revol_val)-------------------------#
 
 SELECT a.Grade,a.Sub_grade,round(sum(b.revol_bal),2) as Total_Revol_Bal
 from finance_1 as a join finance_2 as b
 on a.id = b.id
 group by 1,2
 order by 1;
 
 SELECT a.Grade,sum(b.revol_bal) as Total_Revol_Bal
 from finance_1 as a join finance_2 as b
 on a.id = b.id
 group by 1
 order by 1;
 
 SELECT a.SUB_Grade,  sum(b.revol_bal) as Total_Revol_Bal
 from finance_1 as a join finance_2 as b
 on a.id = b.id
 group by 1
 order by 1;
 
 
 #------------- 3rd KPI (Total payment for verified Status vs Total payment for Non Verified Status)------------------#
 
 SELECT a.verification_status, CONCAT("$ ", FORMAT(ROUND(SUM(total_pymnt) / 1000000, 2), 2), 'M') AS Total_payment
FROM finance_1 AS a
JOIN finance_2 AS b ON a.id = b.id
GROUP BY a.verification_status
HAVING a.verification_status <> 'source verified';
 
 #----------------- 4th KPI (State wise and month wise loan status)------------------------#

SELECT State,`Month`,Loan_status from (
SELECT Distinct addr_state as State, monthname(issue_d) as 'Month',month(issue_d), loan_status
from finance_1
group by 1,2,3,4
order by 1,3)a;

 #---------------- 5th KPI (Home Ownership vs last payment date status)----------------------------#
 
select a.home_ownership,year(b.last_pymnt_d) ,concat("$ ",format(round(sum(last_pymnt_amnt)/10000,2),2),'k') AS Total_payment
from finance_1 as a join finance_2 as b 
on a.id = b.id
group by 1,2
order by 1;

select a.home_ownership,count(last_pymnt_amnt) AS Total_payment
from finance_1 as a join finance_2 as b 
on a.id = b.id
group by 1
order by 1;
