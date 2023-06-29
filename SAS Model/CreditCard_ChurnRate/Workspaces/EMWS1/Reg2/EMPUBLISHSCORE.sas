*************************************;
*** begin scoring code for regression;
*************************************;

length _WARN_ $4;
label _WARN_ = 'Warnings' ;

length I_Attrition_Flag $ 17;
label I_Attrition_Flag = 'Into: Attrition_Flag' ;
*** Target Values;
array REG2DRF [2] $17 _temporary_ ('1' '0' );
label U_Attrition_Flag = 'Unnormalized Into: Attrition_Flag' ;
format U_Attrition_Flag $CHAR17.;
length U_Attrition_Flag $ 17;
*** Unnormalized target values;
array REG2DRU[2] $ 17 _temporary_ ('1                '  '0                ' );

drop _DM_BAD;
_DM_BAD=0;

*** Check RANGE_LOG_Total_Trans_Amt for missing values ;
if missing( RANGE_LOG_Total_Trans_Amt ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check RANGE_SQRT_Avg_Utilization_Ratio for missing values ;
if missing( RANGE_SQRT_Avg_Utilization_Ratio ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check RANGE_SQRT_Total_Amt_Chng_Q4_Q1 for missing values ;
if missing( RANGE_SQRT_Total_Amt_Chng_Q4_Q1 ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check RANGE_SQRT_Total_Ct_Chng_Q4_Q1 for missing values ;
if missing( RANGE_SQRT_Total_Ct_Chng_Q4_Q1 ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Check RANGE_Total_Revolving_Bal for missing values ;
if missing( RANGE_Total_Revolving_Bal ) then do;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;

*** Generate dummy variables for G_Contacts_Count_12_mon ;
drop _1_0 _1_1 _1_2 _1_3 ;
*** encoding is sparse, initialize to zero;
_1_0 = 0;
_1_1 = 0;
_1_2 = 0;
_1_3 = 0;
if missing( G_Contacts_Count_12_mon ) then do;
   _1_0 = .;
   _1_1 = .;
   _1_2 = .;
   _1_3 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Contacts_Count_12_mon , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '2'  then do;
      if _dm12 <= '1'  then do;
         if _dm12 = '0'  then do;
            _1_0 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '1'  then do;
               _1_1 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '2'  then do;
            _1_2 = 1;
            _dm_find = 1;
         end;
      end;
   end;
   else do;
      if _dm12 = '3'  then do;
         _1_3 = 1;
         _dm_find = 1;
      end;
      else do;
         if _dm12 = '4'  then do;
            _1_0 = -1;
            _1_1 = -1;
            _1_2 = -1;
            _1_3 = -1;
            _dm_find = 1;
         end;
      end;
   end;
   if not _dm_find then do;
      _1_0 = .;
      _1_1 = .;
      _1_2 = .;
      _1_3 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_Customer_Age ;
drop _2_0 _2_1 _2_2 _2_3 _2_4 _2_5 _2_6 _2_7 _2_8 _2_9 ;
*** encoding is sparse, initialize to zero;
_2_0 = 0;
_2_1 = 0;
_2_2 = 0;
_2_3 = 0;
_2_4 = 0;
_2_5 = 0;
_2_6 = 0;
_2_7 = 0;
_2_8 = 0;
_2_9 = 0;
if missing( G_Customer_Age ) then do;
   _2_0 = .;
   _2_1 = .;
   _2_2 = .;
   _2_3 = .;
   _2_4 = .;
   _2_5 = .;
   _2_6 = .;
   _2_7 = .;
   _2_8 = .;
   _2_9 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Customer_Age , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '4'  then do;
      if _dm12 <= '10'  then do;
         if _dm12 <= '1'  then do;
            if _dm12 = '0'  then do;
               _2_0 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm12 = '1'  then do;
                  _2_1 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm12 = '10'  then do;
               _2_0 = -1;
               _2_1 = -1;
               _2_2 = -1;
               _2_3 = -1;
               _2_4 = -1;
               _2_5 = -1;
               _2_6 = -1;
               _2_7 = -1;
               _2_8 = -1;
               _2_9 = -1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 <= '3'  then do;
            if _dm12 = '2'  then do;
               _2_2 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm12 = '3'  then do;
                  _2_3 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm12 = '4'  then do;
               _2_4 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   else do;
      if _dm12 <= '7'  then do;
         if _dm12 <= '6'  then do;
            if _dm12 = '5'  then do;
               _2_5 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm12 = '6'  then do;
                  _2_6 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm12 = '7'  then do;
               _2_7 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '8'  then do;
            _2_8 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '9'  then do;
               _2_9 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   if not _dm_find then do;
      _2_0 = .;
      _2_1 = .;
      _2_2 = .;
      _2_3 = .;
      _2_4 = .;
      _2_5 = .;
      _2_6 = .;
      _2_7 = .;
      _2_8 = .;
      _2_9 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_Months_Inactive_12_mon ;
drop _3_0 _3_1 _3_2 _3_3 ;
*** encoding is sparse, initialize to zero;
_3_0 = 0;
_3_1 = 0;
_3_2 = 0;
_3_3 = 0;
if missing( G_Months_Inactive_12_mon ) then do;
   _3_0 = .;
   _3_1 = .;
   _3_2 = .;
   _3_3 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Months_Inactive_12_mon , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '2'  then do;
      if _dm12 <= '1'  then do;
         if _dm12 = '0'  then do;
            _3_0 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '1'  then do;
               _3_1 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '2'  then do;
            _3_2 = 1;
            _dm_find = 1;
         end;
      end;
   end;
   else do;
      if _dm12 = '3'  then do;
         _3_3 = 1;
         _dm_find = 1;
      end;
      else do;
         if _dm12 = '4'  then do;
            _3_0 = -1;
            _3_1 = -1;
            _3_2 = -1;
            _3_3 = -1;
            _dm_find = 1;
         end;
      end;
   end;
   if not _dm_find then do;
      _3_0 = .;
      _3_1 = .;
      _3_2 = .;
      _3_3 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_Months_on_book ;
drop _4_0 _4_1 _4_2 _4_3 _4_4 _4_5 _4_6 _4_7 ;
*** encoding is sparse, initialize to zero;
_4_0 = 0;
_4_1 = 0;
_4_2 = 0;
_4_3 = 0;
_4_4 = 0;
_4_5 = 0;
_4_6 = 0;
_4_7 = 0;
if missing( G_Months_on_book ) then do;
   _4_0 = .;
   _4_1 = .;
   _4_2 = .;
   _4_3 = .;
   _4_4 = .;
   _4_5 = .;
   _4_6 = .;
   _4_7 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Months_on_book , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '4'  then do;
      if _dm12 <= '2'  then do;
         if _dm12 <= '1'  then do;
            if _dm12 = '0'  then do;
               _4_0 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm12 = '1'  then do;
                  _4_1 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm12 = '2'  then do;
               _4_2 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '3'  then do;
            _4_3 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '4'  then do;
               _4_4 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   else do;
      if _dm12 <= '6'  then do;
         if _dm12 = '5'  then do;
            _4_5 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '6'  then do;
               _4_6 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '7'  then do;
            _4_7 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '8'  then do;
               _4_0 = -1;
               _4_1 = -1;
               _4_2 = -1;
               _4_3 = -1;
               _4_4 = -1;
               _4_5 = -1;
               _4_6 = -1;
               _4_7 = -1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   if not _dm_find then do;
      _4_0 = .;
      _4_1 = .;
      _4_2 = .;
      _4_3 = .;
      _4_4 = .;
      _4_5 = .;
      _4_6 = .;
      _4_7 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_Total_Relationship_Count ;
drop _5_0 _5_1 ;
if missing( G_Total_Relationship_Count ) then do;
   _5_0 = .;
   _5_1 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Total_Relationship_Count , BEST12. );
   %DMNORMIP( _dm12 )
   if _dm12 = '2'  then do;
      _5_0 = -1;
      _5_1 = -1;
   end;
   else if _dm12 = '1'  then do;
      _5_0 = 0;
      _5_1 = 1;
   end;
   else if _dm12 = '0'  then do;
      _5_0 = 1;
      _5_1 = 0;
   end;
   else do;
      _5_0 = .;
      _5_1 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_Total_Trans_Ct ;
drop _6_0 _6_1 _6_2 _6_3 _6_4 _6_5 _6_6 ;
*** encoding is sparse, initialize to zero;
_6_0 = 0;
_6_1 = 0;
_6_2 = 0;
_6_3 = 0;
_6_4 = 0;
_6_5 = 0;
_6_6 = 0;
if missing( G_Total_Trans_Ct ) then do;
   _6_0 = .;
   _6_1 = .;
   _6_2 = .;
   _6_3 = .;
   _6_4 = .;
   _6_5 = .;
   _6_6 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_Total_Trans_Ct , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '3'  then do;
      if _dm12 <= '1'  then do;
         if _dm12 = '0'  then do;
            _6_0 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '1'  then do;
               _6_1 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '2'  then do;
            _6_2 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '3'  then do;
               _6_3 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   else do;
      if _dm12 <= '5'  then do;
         if _dm12 = '4'  then do;
            _6_4 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '5'  then do;
               _6_5 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '6'  then do;
            _6_6 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '7'  then do;
               _6_0 = -1;
               _6_1 = -1;
               _6_2 = -1;
               _6_3 = -1;
               _6_4 = -1;
               _6_5 = -1;
               _6_6 = -1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   if not _dm_find then do;
      _6_0 = .;
      _6_1 = .;
      _6_2 = .;
      _6_3 = .;
      _6_4 = .;
      _6_5 = .;
      _6_6 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** If missing inputs, use averages;
if _DM_BAD > 0 then do;
   _P0 = 0.1606531472;
   _P1 = 0.8393468528;
   goto REG2DR1;
end;

*** Compute Linear Predictor;
drop _TEMP;
drop _LP0;
_LP0 = 0;

***  Effect: G_Contacts_Count_12_mon ;
_TEMP = 1;
_LP0 = _LP0 + (    10.3817746596154) * _TEMP * _1_0;
_LP0 = _LP0 + (   -1.49876773797484) * _TEMP * _1_1;
_LP0 = _LP0 + (   -2.35801711307433) * _TEMP * _1_2;
_LP0 = _LP0 + (   -2.97249918772596) * _TEMP * _1_3;

***  Effect: G_Customer_Age ;
_TEMP = 1;
_LP0 = _LP0 + (    2.22280714321663) * _TEMP * _2_0;
_LP0 = _LP0 + (    0.55396613507131) * _TEMP * _2_1;
_LP0 = _LP0 + (    0.36763034302522) * _TEMP * _2_2;
_LP0 = _LP0 + (    0.73529014749264) * _TEMP * _2_3;
_LP0 = _LP0 + (    0.28721727135228) * _TEMP * _2_4;
_LP0 = _LP0 + (    0.34944535613054) * _TEMP * _2_5;
_LP0 = _LP0 + (    0.02351069804945) * _TEMP * _2_6;
_LP0 = _LP0 + (    0.02656914315862) * _TEMP * _2_7;
_LP0 = _LP0 + (   -0.52306095830666) * _TEMP * _2_8;
_LP0 = _LP0 + (   -1.58947924989746) * _TEMP * _2_9;

***  Effect: G_Months_Inactive_12_mon ;
_TEMP = 1;
_LP0 = _LP0 + (    1.93442994592416) * _TEMP * _3_0;
_LP0 = _LP0 + (    0.25547544870263) * _TEMP * _3_1;
_LP0 = _LP0 + (   -0.05199559333037) * _TEMP * _3_2;
_LP0 = _LP0 + (   -0.43660685323986) * _TEMP * _3_3;

***  Effect: G_Months_on_book ;
_TEMP = 1;
_LP0 = _LP0 + (    0.33024095014074) * _TEMP * _4_0;
_LP0 = _LP0 + (    1.87406466097242) * _TEMP * _4_1;
_LP0 = _LP0 + (    0.05140677360087) * _TEMP * _4_2;
_LP0 = _LP0 + (   -0.02532161967319) * _TEMP * _4_3;
_LP0 = _LP0 + (   -0.19785598742973) * _TEMP * _4_4;
_LP0 = _LP0 + (    -0.3652879335495) * _TEMP * _4_5;
_LP0 = _LP0 + (    -0.3993425659673) * _TEMP * _4_6;
_LP0 = _LP0 + (   -0.39418210877959) * _TEMP * _4_7;

***  Effect: G_Total_Relationship_Count ;
_TEMP = 1;
_LP0 = _LP0 + (    1.32581361504555) * _TEMP * _5_0;
_LP0 = _LP0 + (   -0.45999950924435) * _TEMP * _5_1;

***  Effect: G_Total_Trans_Ct ;
_TEMP = 1;
_LP0 = _LP0 + (    4.83374456426453) * _TEMP * _6_0;
_LP0 = _LP0 + (    1.58499106292006) * _TEMP * _6_1;
_LP0 = _LP0 + (    1.04107991036594) * _TEMP * _6_2;
_LP0 = _LP0 + (    0.76565700907091) * _TEMP * _6_3;
_LP0 = _LP0 + (    0.22646441643163) * _TEMP * _6_4;
_LP0 = _LP0 + (   -0.24324898771911) * _TEMP * _6_5;
_LP0 = _LP0 + (   -2.40602314074359) * _TEMP * _6_6;

***  Effect: RANGE_LOG_Total_Trans_Amt ;
_TEMP = RANGE_LOG_Total_Trans_Amt ;
_LP0 = _LP0 + (    5.64434364069834 * _TEMP);

***  Effect: RANGE_SQRT_Avg_Utilization_Ratio ;
_TEMP = RANGE_SQRT_Avg_Utilization_Ratio ;
_LP0 = _LP0 + (    -0.7800643379072 * _TEMP);

***  Effect: RANGE_SQRT_Total_Amt_Chng_Q4_Q1 ;
_TEMP = RANGE_SQRT_Total_Amt_Chng_Q4_Q1 ;
_LP0 = _LP0 + (   -1.53057847945614 * _TEMP);

***  Effect: RANGE_SQRT_Total_Ct_Chng_Q4_Q1 ;
_TEMP = RANGE_SQRT_Total_Ct_Chng_Q4_Q1 ;
_LP0 = _LP0 + (   -9.58493912094583 * _TEMP);

***  Effect: RANGE_Total_Revolving_Bal ;
_TEMP = RANGE_Total_Revolving_Bal ;
_LP0 = _LP0 + (   -1.65847459861618 * _TEMP);

*** Naive Posterior Probabilities;
drop _MAXP _IY _P0 _P1;
_TEMP =     7.19103563021546 + _LP0;
if (_TEMP < 0) then do;
   _TEMP = exp(_TEMP);
   _P0 = _TEMP / (1 + _TEMP);
end;
else _P0 = 1 / (1 + exp(-_TEMP));
_P1 = 1.0 - _P0;

REG2DR1:


*** Posterior Probabilities and Predicted Level;
label P_Attrition_Flag1 = 'Predicted: Attrition_Flag=1' ;
label P_Attrition_Flag0 = 'Predicted: Attrition_Flag=0' ;
P_Attrition_Flag1 = _P0;
_MAXP = _P0;
_IY = 1;
P_Attrition_Flag0 = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
I_Attrition_Flag = REG2DRF[_IY];
U_Attrition_Flag = REG2DRU[_IY];

*************************************;
***** end scoring code for regression;
*************************************;
