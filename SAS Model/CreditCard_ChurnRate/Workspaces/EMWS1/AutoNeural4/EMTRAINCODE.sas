*------------------------------------------------------------*;
* AutoNeural4: Create decision matrix;
*------------------------------------------------------------*;
data WORK.Attrition_Flag;
  length   Attrition_Flag                   $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="1"
           DECISION2="0"
           ;
  format   COUNT 10.
           ;
Attrition_Flag="1"; COUNT=1627; DATAPRIOR=0.16065962279055; TRAINPRIOR=0.16065962279055; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
Attrition_Flag="0"; COUNT=8500; DATAPRIOR=0.83934037720944; TRAINPRIOR=0.83934037720944; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify Attrition_Flag(type=PROFIT label=Attrition_Flag);
label DECISION1= '1';
label DECISION2= '0';
run;
quit;
data EM_AutoNeural4;
set EMWS1.Part2_TRAIN(keep=
Attrition_Flag G_Contacts_Count_12_mon G_Customer_Age G_Months_Inactive_12_mon
G_Months_on_book G_Total_Relationship_Count G_Total_Trans_Ct
RANGE_LOG_Total_Trans_Amt RANGE_SQRT_Avg_Utilization_Ratio
RANGE_SQRT_Total_Amt_Chng_Q4_Q1 RANGE_SQRT_Total_Ct_Chng_Q4_Q1
RANGE_Total_Revolving_Bal );
run;
*------------------------------------------------------------* ;
* AutoNeural4: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    Attrition_Flag(DESC) G_Contacts_Count_12_mon(ASC) G_Customer_Age(ASC)
   G_Months_Inactive_12_mon(ASC) G_Months_on_book(ASC)
   G_Total_Relationship_Count(ASC) G_Total_Trans_Ct(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* AutoNeural4: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    RANGE_LOG_Total_Trans_Amt RANGE_SQRT_Avg_Utilization_Ratio
   RANGE_SQRT_Total_Amt_Chng_Q4_Q1 RANGE_SQRT_Total_Ct_Chng_Q4_Q1
   RANGE_Total_Revolving_Bal
%mend DMDBVar;
*------------------------------------------------------------*;
* AutoNeural4: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_AutoNeural4
dmdbcat=WORK.AutoNeural4_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
Attrition_Flag
;
run;
quit;
*------------------------------------------------------------* ;
* AutoNeural4: Interval Inputs Macro ;
*------------------------------------------------------------* ;
%macro INTINPUTS;
    RANGE_LOG_Total_Trans_Amt RANGE_SQRT_Avg_Utilization_Ratio
   RANGE_SQRT_Total_Amt_Chng_Q4_Q1 RANGE_SQRT_Total_Ct_Chng_Q4_Q1
   RANGE_Total_Revolving_Bal
%mend INTINPUTS;
*------------------------------------------------------------* ;
* AutoNeural4: Binary Inputs Macro ;
*------------------------------------------------------------* ;
%macro BININPUTS;

%mend BININPUTS;
*------------------------------------------------------------* ;
* AutoNeural4: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro NOMINPUTS;
    G_Contacts_Count_12_mon G_Customer_Age G_Months_Inactive_12_mon
   G_Months_on_book G_Total_Relationship_Count G_Total_Trans_Ct
%mend NOMINPUTS;
*------------------------------------------------------------* ;
* AutoNeural4: Ordinal Inputs Macro ;
*------------------------------------------------------------* ;
%macro ORDINPUTS;

%mend ORDINPUTS;
* set printing options;
;
options linesize = 80;
options pagesize = 6000;
options nonumber;
options nocenter;
options nodate;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_autonet_title  , NOQUOTE))";
*;
*------------------------------------------------------------*;
* Autoneural: search / SINGLE LAYER;
;
*------------------------------------------------------------*;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*;
netoptions ranscale = 1;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 1 : DIRECT : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=1800 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 2 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 2 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
%sysfunc(sasmsg(sashelp.dmine, starthistory_note , NOQUOTE));
data EMWS1.AutoNeural4_HISTORY;
length _func_ _status_ _step_ $16;
label _func_ = "%sysfunc(sasmsg(sashelp.dmine, rpt_function_vlabel  , NOQUOTE))";
label _status_ = "%sysfunc(sasmsg(sashelp.dmine, rpt_status_vlabel  , NOQUOTE))";
label _iter_ = "%sysfunc(sasmsg(sashelp.dmine, rpt_iteration_vlabel  , NOQUOTE))";
label _step_ = "%sysfunc(sasmsg(sashelp.dmine, rpt_step_vlabel  , NOQUOTE))";
_func_ = '';
_status_ = '';
_step_ = 'SINGLE LAYER 1';
set
_anfit(where=(_name_ eq 'OVERALL' and _iter_ eq 0))
;
run;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=TANH;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 2 : TANH : ))";
prelim 16 outest=_anpre pretime=56 preiter=8
tech = Default
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 2 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=899 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 13 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 13 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 3 : NORMAL : ))";
prelim 16 outest=_anpre pretime=56 preiter=8
tech = Default
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 3 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=897 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 8 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 8 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=SINE;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 4 : SINE : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 1 SINGLE LAYER trial # 4 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=894 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 13 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 13 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 1 : DIRECT : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 1 : DIRECT : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=891 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 0 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 0 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 2 : TANH : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 2 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=891 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 1 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 1 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=GAUSS;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 3 : NORMAL : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 3 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=888 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 0 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 0 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=SINE;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 4 : SINE : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 2 SINGLE LAYER trial # 4 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=887 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 13 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 13 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 1 : DIRECT : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 1 : DIRECT : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=887 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 15 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 15 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 2 : TANH : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 2 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=886 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 8 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 8 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=GAUSS;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 3 : NORMAL : ))";
prelim 16 outest=_anpre pretime=55 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 3 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=881 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 8 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 8 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=SINE;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 4 : SINE : ))";
prelim 16 outest=_anpre pretime=54 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 3 SINGLE LAYER trial # 4 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=876 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 4 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 4 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 1 : TANH : ))";
prelim 16 outest=_anpre pretime=54 preiter=11
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 1 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=871 maxiter=22
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 1 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 1 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=GAUSS;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 2 : NORMAL : ))";
prelim 16 outest=_anpre pretime=54 preiter=11
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 2 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=864 maxiter=22
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 0 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 0 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=SINE;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 3 : SINE : ))";
prelim 16 outest=_anpre pretime=53 preiter=11
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 4 SINGLE LAYER trial # 3 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=863 maxiter=22
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 21 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 21 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=TANH;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 1 : TANH : ))";
prelim 16 outest=_anpre pretime=53 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 1 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=862 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 0 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 0 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=GAUSS;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 2 : NORMAL : ))";
prelim 16 outest=_anpre pretime=53 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 2 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=855 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 2 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 2 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 3 : SINE : ))";
prelim 16 outest=_anpre pretime=53 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 5 SINGLE LAYER trial # 3 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=848 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 0 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 0 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
Hidden 4 / id = H1x5_ act=TANH;
connect interval H1x5_;
connect nominal H1x5_;
connect H1x5_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 1 : TANH : ))";
prelim 16 outest=_anpre pretime=52 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 1 : TANH : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=841 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 9 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 9 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
Hidden 4 / id = H1x5_ act=GAUSS;
connect interval H1x5_;
connect nominal H1x5_;
connect H1x5_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 2 : NORMAL : ))";
prelim 16 outest=_anpre pretime=52 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 2 : NORMAL : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=834 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 9 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 9 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
Hidden 4 / id = H1x5_ act=SINE;
connect interval H1x5_;
connect nominal H1x5_;
connect H1x5_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 3 : SINE : ))";
prelim 16 outest=_anpre pretime=51 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Search # 6 SINGLE LAYER trial # 3 : SINE : ))";
train estiter=1 outest=_anest outfit=_anfit maxtime=826 maxiter=15
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 3 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 3 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Direct connection;
;
*------------------------------------------------------------*;
connect interval Attrition_Flag;
connect nominal Attrition_Flag;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
*;
netoptions ranscale = 1;
*;
initial
inest = EMWS1.AutoNeural4_ESTDS bylabel;
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_prelim_title  ,NOQUOTE, Final Training))";
prelim 16 outest=_anpre pretime=51 preiter=8
tech = Default
inest = EMWS1.AutoNeural4_ESTDS bylabel
;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_train_title  ,NOQUOTE, Final Training))";
train estiter=1 outest=_anest outfit=_anfit maxtime=819 maxiter=5
tech = Default;
;
run;
*;
proc print data=_anfit(where=(_name_ eq 'OVERALL')) noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
*------------------------------------------------------------*;
* Extract best iteration;
;
*------------------------------------------------------------*;
%global _iter;
data _null_;
set _anfit(where=(_NAME_ eq 'OVERALL'));
retain _min 1e+64;
if _VMISC_ < _min then do;
_min = _VMISC_;
call symput('_iter',put(_ITER_, 6.));
end;
run;
*;
data EMWS1.AutoNeural4_ESTDS;
set _anest;
if _ITER_ eq 5 then do;
output;
stop;
end;
run;
*;
data EMWS1.AutoNeural4_OUTFIT;
set _anfit;
if _ITER_ eq 5 and _NAME_ eq "OVERALL" then do;
output;
stop;
end;
run;
*;
title9 " ";
title10 "%sysfunc(sasmsg(sashelp.dmine, rpt_selectediteration_title  , NOQUOTE, _VMISC_))";
proc print data=EMWS1.AutoNeural4_OUTFIT noobs;
var _iter_ _aic_ _averr_ _misc_
_vaverr_ _vmisc_
;
run;
title9;
title10;
*------------------------------------------------------------*;
* AutoNeural Final Network;
;
*------------------------------------------------------------*;
*;
proc neural data=EM_AutoNeural4 dmdbcat=WORK.AutoNeural4_DMDB
validdata=EMWS1.Part2_VALIDATE
;
*;
nloptions noprint;
performance alldetails noutilfile;
input %INTINPUTS / level=interval id=interval;
input %NOMINPUTS / level=nominal id=nominal;
target Attrition_Flag / level=NOMINAL id=Attrition_Flag
;
*------------------------------------------------------------*;
* Layer #1;
;
*------------------------------------------------------------*;
Hidden 4 / id = H1x1_ act=GAUSS;
connect interval H1x1_;
connect nominal H1x1_;
connect H1x1_ Attrition_Flag;
Hidden 4 / id = H1x2_ act=TANH;
connect interval H1x2_;
connect nominal H1x2_;
connect H1x2_ Attrition_Flag;
Hidden 4 / id = H1x3_ act=TANH;
connect interval H1x3_;
connect nominal H1x3_;
connect H1x3_ Attrition_Flag;
Hidden 4 / id = H1x4_ act=SINE;
connect interval H1x4_;
connect nominal H1x4_;
connect H1x4_ Attrition_Flag;
*;
initial inest= EMWS1.AutoNeural4_ESTDS bylabel;
train tech=none;
code file="D:\478\project\CreditCard_ChurnRate\Workspaces\EMWS1\AutoNeural4\SCORECODE.sas"
group=AutoNeural4
;
;
code file="D:\478\project\CreditCard_ChurnRate\Workspaces\EMWS1\AutoNeural4\RESIDUALSCORECODE.sas"
group=AutoNeural4
residual
;
;
score data=EMWS1.Part2_TRAIN out=_NULL_
outfit=WORK.FIT1
role=TRAIN
outkey=EMWS1.AutoNeural4_OUTKEY;
score data=EMWS1.Part2_VALIDATE out=_NULL_
outfit=WORK.FIT2
outkey=EMWS1.AutoNeural4_OUTKEY;
score data=EMWS1.Part2_TEST out=_NULL_
outfit=WORK.FIT3
role=TEST
outkey=EMWS1.AutoNeural4_OUTKEY;
run;
data EMWS1.AutoNeural4_OUTFIT;
merge WORK.FIT1 WORK.FIT2 WORK.FIT3;
run;
*------------------------------------------------------------*;
* Generate Weights Plotting data set;
*------------------------------------------------------------*;
data tempweight ( drop = _tech_ _decay_ _seed_ _nobj_ _obj_ _objerr_ _averr_ _p_num_ where= (_type_ eq "PARMS"));
set EMWS1.AutoNeural4_ESTDS;
run;
proc sort;
by _name_;
run;
proc transpose data=tempweight out=EMWS1.AutoNeural4_WEIGHTS;
by _name_;
run;
data EMWS1.AutoNeural4_WEIGHTS;
set EMWS1.AutoNeural4_WEIGHTS;
FROM = ktrim(kleft(kscan(_LABEL_, 1, '-->')));
TO = ktrim(kleft(kscan(_LABEL_, 2, '>')));
WEIGHT = COL1;
if (TO eq '') or (FROM eq '') then delete;
label _LABEL_ ="%sysfunc(sasmsg(sashelp.dmine, meta_label_vlabel  , NOQUOTE))" FROM = "%sysfunc(sasmsg(sashelp.dmine, rpt_from_vlabel  , NOQUOTE))" TO = "%sysfunc(sasmsg(sashelp.dmine, rpt_into_vlabel  , NOQUOTE))" WEIGHT =
   "%sysfunc(sasmsg(sashelp.dmine, rpt_weight_vlabel  , NOQUOTE))";
keep FROM TO WEIGHT _LABEL_;
run;
* restore printing options;
;
title10;
options linesize=95;
options pagesize=10000;
options nonumber;
options nocenter;
options nodate;
*;
