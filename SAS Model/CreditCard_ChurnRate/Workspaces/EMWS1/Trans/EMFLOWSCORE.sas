*------------------------------------------------------------*;
* Computed Code;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TRANSFORM: Avg_Utilization_Ratio , sqrt(max(Avg_Utilization_Ratio-0, 0.0)/0.999);
*------------------------------------------------------------*;
drop Trans_SCALEVAR_1;
label SQRT_Avg_Utilization_Ratio = 'Transformed Avg_Utilization_Ratio';
length SQRT_Avg_Utilization_Ratio 8;
if Avg_Utilization_Ratio eq . then SQRT_Avg_Utilization_Ratio = .;
else do;
Trans_SCALEVAR_1 = max(Avg_Utilization_Ratio-0, 0.0)/0.999;
if Trans_SCALEVAR_1 >= 0 then SQRT_Avg_Utilization_Ratio = Sqrt(Trans_SCALEVAR_1);
else SQRT_Avg_Utilization_Ratio = .;
end;
*------------------------------------------------------------*;
* TRANSFORM: Total_Amt_Chng_Q4_Q1 , sqrt(max(Total_Amt_Chng_Q4_Q1-0, 0.0)/3.397);
*------------------------------------------------------------*;
drop Trans_SCALEVAR_2;
label SQRT_Total_Amt_Chng_Q4_Q1 = 'Transformed Total_Amt_Chng_Q4_Q1';
length SQRT_Total_Amt_Chng_Q4_Q1 8;
if Total_Amt_Chng_Q4_Q1 eq . then SQRT_Total_Amt_Chng_Q4_Q1 = .;
else do;
Trans_SCALEVAR_2 = max(Total_Amt_Chng_Q4_Q1-0, 0.0)/3.397;
if Trans_SCALEVAR_2 >= 0 then SQRT_Total_Amt_Chng_Q4_Q1 = Sqrt(Trans_SCALEVAR_2);
else SQRT_Total_Amt_Chng_Q4_Q1 = .;
end;
*------------------------------------------------------------*;
* TRANSFORM: Total_Ct_Chng_Q4_Q1 , sqrt(max(Total_Ct_Chng_Q4_Q1-0, 0.0)/3.714);
*------------------------------------------------------------*;
drop Trans_SCALEVAR_3;
label SQRT_Total_Ct_Chng_Q4_Q1 = 'Transformed Total_Ct_Chng_Q4_Q1';
length SQRT_Total_Ct_Chng_Q4_Q1 8;
if Total_Ct_Chng_Q4_Q1 eq . then SQRT_Total_Ct_Chng_Q4_Q1 = .;
else do;
Trans_SCALEVAR_3 = max(Total_Ct_Chng_Q4_Q1-0, 0.0)/3.714;
if Trans_SCALEVAR_3 >= 0 then SQRT_Total_Ct_Chng_Q4_Q1 = Sqrt(Trans_SCALEVAR_3);
else SQRT_Total_Ct_Chng_Q4_Q1 = .;
end;
*------------------------------------------------------------*;
* TRANSFORM: Total_Trans_Amt , log(max(Total_Trans_Amt-510, 0.0)/17974 + 1);
*------------------------------------------------------------*;
drop Trans_SCALEVAR_5;
label LOG_Total_Trans_Amt = 'Transformed Total_Trans_Amt';
length LOG_Total_Trans_Amt 8;
if Total_Trans_Amt eq . then LOG_Total_Trans_Amt = .;
else do;
Trans_SCALEVAR_5 = max(Total_Trans_Amt-510, 0.0)/17974;
if Trans_SCALEVAR_5 + 1 > 0 then LOG_Total_Trans_Amt = log(Trans_SCALEVAR_5 + 1);
else LOG_Total_Trans_Amt = .;
end;
