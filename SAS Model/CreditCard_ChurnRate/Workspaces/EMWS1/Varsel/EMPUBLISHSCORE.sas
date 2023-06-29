******************************************;
*** Begin Scoring Code from PROC DMINE ***;
******************************************;

length _WARN_ $ 4;
label _WARN_ = "Warnings";


/*----G_Total_Trans_Ct begin----*/
length _NORM3 $ 3;
_NORM3 = put( Total_Trans_Ct , BEST3. );
%DMNORMIP( _NORM3 )
drop _NORM3;
select(_NORM3);
  when('10' ) G_Total_Trans_Ct = 0;
  when('11' ) G_Total_Trans_Ct = 2;
  when('12' ) G_Total_Trans_Ct = 0;
  when('13' ) G_Total_Trans_Ct = 1;
  when('14' ) G_Total_Trans_Ct = 0;
  when('15' ) G_Total_Trans_Ct = 0;
  when('16' ) G_Total_Trans_Ct = 1;
  when('17' ) G_Total_Trans_Ct = 0;
  when('18' ) G_Total_Trans_Ct = 1;
  when('19' ) G_Total_Trans_Ct = 1;
  when('20' ) G_Total_Trans_Ct = 2;
  when('21' ) G_Total_Trans_Ct = 4;
  when('22' ) G_Total_Trans_Ct = 4;
  when('23' ) G_Total_Trans_Ct = 5;
  when('24' ) G_Total_Trans_Ct = 5;
  when('25' ) G_Total_Trans_Ct = 5;
  when('26' ) G_Total_Trans_Ct = 5;
  when('27' ) G_Total_Trans_Ct = 5;
  when('28' ) G_Total_Trans_Ct = 5;
  when('29' ) G_Total_Trans_Ct = 5;
  when('30' ) G_Total_Trans_Ct = 5;
  when('31' ) G_Total_Trans_Ct = 5;
  when('32' ) G_Total_Trans_Ct = 5;
  when('33' ) G_Total_Trans_Ct = 5;
  when('34' ) G_Total_Trans_Ct = 5;
  when('35' ) G_Total_Trans_Ct = 4;
  when('36' ) G_Total_Trans_Ct = 3;
  when('37' ) G_Total_Trans_Ct = 4;
  when('38' ) G_Total_Trans_Ct = 3;
  when('39' ) G_Total_Trans_Ct = 2;
  when('40' ) G_Total_Trans_Ct = 2;
  when('41' ) G_Total_Trans_Ct = 2;
  when('42' ) G_Total_Trans_Ct = 1;
  when('43' ) G_Total_Trans_Ct = 1;
  when('44' ) G_Total_Trans_Ct = 1;
  when('45' ) G_Total_Trans_Ct = 2;
  when('46' ) G_Total_Trans_Ct = 1;
  when('47' ) G_Total_Trans_Ct = 2;
  when('48' ) G_Total_Trans_Ct = 3;
  when('49' ) G_Total_Trans_Ct = 3;
  when('50' ) G_Total_Trans_Ct = 3;
  when('51' ) G_Total_Trans_Ct = 2;
  when('52' ) G_Total_Trans_Ct = 4;
  when('53' ) G_Total_Trans_Ct = 4;
  when('54' ) G_Total_Trans_Ct = 4;
  when('55' ) G_Total_Trans_Ct = 5;
  when('56' ) G_Total_Trans_Ct = 5;
  when('57' ) G_Total_Trans_Ct = 5;
  when('58' ) G_Total_Trans_Ct = 6;
  when('59' ) G_Total_Trans_Ct = 5;
  when('60' ) G_Total_Trans_Ct = 6;
  when('61' ) G_Total_Trans_Ct = 6;
  when('62' ) G_Total_Trans_Ct = 6;
  when('63' ) G_Total_Trans_Ct = 5;
  when('64' ) G_Total_Trans_Ct = 6;
  when('65' ) G_Total_Trans_Ct = 6;
  when('66' ) G_Total_Trans_Ct = 6;
  when('67' ) G_Total_Trans_Ct = 6;
  when('68' ) G_Total_Trans_Ct = 6;
  when('69' ) G_Total_Trans_Ct = 6;
  when('70' ) G_Total_Trans_Ct = 6;
  when('71' ) G_Total_Trans_Ct = 6;
  when('72' ) G_Total_Trans_Ct = 7;
  when('73' ) G_Total_Trans_Ct = 7;
  when('74' ) G_Total_Trans_Ct = 6;
  when('75' ) G_Total_Trans_Ct = 7;
  when('76' ) G_Total_Trans_Ct = 7;
  when('77' ) G_Total_Trans_Ct = 7;
  when('78' ) G_Total_Trans_Ct = 7;
  when('79' ) G_Total_Trans_Ct = 7;
  when('80' ) G_Total_Trans_Ct = 7;
  when('81' ) G_Total_Trans_Ct = 7;
  when('82' ) G_Total_Trans_Ct = 7;
  when('83' ) G_Total_Trans_Ct = 7;
  when('84' ) G_Total_Trans_Ct = 7;
  when('85' ) G_Total_Trans_Ct = 7;
  when('86' ) G_Total_Trans_Ct = 7;
  when('87' ) G_Total_Trans_Ct = 7;
  when('88' ) G_Total_Trans_Ct = 7;
  when('89' ) G_Total_Trans_Ct = 7;
  when('90' ) G_Total_Trans_Ct = 7;
  when('91' ) G_Total_Trans_Ct = 7;
  when('92' ) G_Total_Trans_Ct = 7;
  when('93' ) G_Total_Trans_Ct = 7;
  when('94' ) G_Total_Trans_Ct = 7;
  when('95' ) G_Total_Trans_Ct = 7;
  when('96' ) G_Total_Trans_Ct = 7;
  when('97' ) G_Total_Trans_Ct = 7;
  when('98' ) G_Total_Trans_Ct = 7;
  when('99' ) G_Total_Trans_Ct = 7;
  when('100' ) G_Total_Trans_Ct = 7;
  when('101' ) G_Total_Trans_Ct = 7;
  when('102' ) G_Total_Trans_Ct = 7;
  when('103' ) G_Total_Trans_Ct = 7;
  when('104' ) G_Total_Trans_Ct = 7;
  when('105' ) G_Total_Trans_Ct = 7;
  when('106' ) G_Total_Trans_Ct = 7;
  when('107' ) G_Total_Trans_Ct = 7;
  when('108' ) G_Total_Trans_Ct = 7;
  when('109' ) G_Total_Trans_Ct = 7;
  when('110' ) G_Total_Trans_Ct = 7;
  when('111' ) G_Total_Trans_Ct = 7;
  when('112' ) G_Total_Trans_Ct = 7;
  when('113' ) G_Total_Trans_Ct = 7;
  when('114' ) G_Total_Trans_Ct = 7;
  when('115' ) G_Total_Trans_Ct = 7;
  when('116' ) G_Total_Trans_Ct = 7;
  when('117' ) G_Total_Trans_Ct = 7;
  when('118' ) G_Total_Trans_Ct = 7;
  when('119' ) G_Total_Trans_Ct = 7;
  when('120' ) G_Total_Trans_Ct = 7;
  when('121' ) G_Total_Trans_Ct = 7;
  when('122' ) G_Total_Trans_Ct = 7;
  when('123' ) G_Total_Trans_Ct = 7;
  when('124' ) G_Total_Trans_Ct = 7;
  when('125' ) G_Total_Trans_Ct = 7;
  when('126' ) G_Total_Trans_Ct = 7;
  when('127' ) G_Total_Trans_Ct = 7;
  when('128' ) G_Total_Trans_Ct = 7;
  when('129' ) G_Total_Trans_Ct = 7;
  when('130' ) G_Total_Trans_Ct = 7;
  when('131' ) G_Total_Trans_Ct = 7;
  when('132' ) G_Total_Trans_Ct = 7;
  when('134' ) G_Total_Trans_Ct = 7;
  when('138' ) G_Total_Trans_Ct = 7;
  when('139' ) G_Total_Trans_Ct = 7;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Total_Trans_Ct="Grouped Levels for  Total_Trans_Ct";
/*----Total_Trans_Ct end----*/

/*----G_Contacts_Count_12_mon begin----*/
length _NORM1 $ 1;
_NORM1 = put( Contacts_Count_12_mon , BEST1. );
%DMNORMIP( _NORM1 )
drop _NORM1;
select(_NORM1);
  when('0' ) G_Contacts_Count_12_mon = 4;
  when('1' ) G_Contacts_Count_12_mon = 4;
  when('2' ) G_Contacts_Count_12_mon = 3;
  when('3' ) G_Contacts_Count_12_mon = 2;
  when('4' ) G_Contacts_Count_12_mon = 2;
  when('5' ) G_Contacts_Count_12_mon = 1;
  when('6' ) G_Contacts_Count_12_mon = 0;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Contacts_Count_12_mon="Grouped Levels for  Contacts_Count_12_mon";
/*----Contacts_Count_12_mon end----*/

/*----G_Months_Inactive_12_mon begin----*/
length _NORM1 $ 1;
_NORM1 = put( Months_Inactive_12_mon , BEST1. );
%DMNORMIP( _NORM1 )
drop _NORM1;
select(_NORM1);
  when('0' ) G_Months_Inactive_12_mon = 0;
  when('1' ) G_Months_Inactive_12_mon = 4;
  when('2' ) G_Months_Inactive_12_mon = 3;
  when('3' ) G_Months_Inactive_12_mon = 2;
  when('4' ) G_Months_Inactive_12_mon = 1;
  when('5' ) G_Months_Inactive_12_mon = 3;
  when('6' ) G_Months_Inactive_12_mon = 3;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Months_Inactive_12_mon="Grouped Levels for  Months_Inactive_12_mon";
/*----Months_Inactive_12_mon end----*/

/*----G_Total_Relationship_Count begin----*/
length _NORM1 $ 1;
_NORM1 = put( Total_Relationship_Count , BEST1. );
%DMNORMIP( _NORM1 )
drop _NORM1;
select(_NORM1);
  when('1' ) G_Total_Relationship_Count = 0;
  when('2' ) G_Total_Relationship_Count = 0;
  when('3' ) G_Total_Relationship_Count = 1;
  when('4' ) G_Total_Relationship_Count = 2;
  when('5' ) G_Total_Relationship_Count = 2;
  when('6' ) G_Total_Relationship_Count = 2;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Total_Relationship_Count="Grouped Levels for  Total_Relationship_Count
        ";
/*----Total_Relationship_Count end----*/

/*----G_Customer_Age begin----*/
length _NORM2 $ 2;
_NORM2 = put( Customer_Age , BEST2. );
%DMNORMIP( _NORM2 )
drop _NORM2;
select(_NORM2);
  when('26' ) G_Customer_Age = 9;
  when('27' ) G_Customer_Age = 9;
  when('28' ) G_Customer_Age = 10;
  when('29' ) G_Customer_Age = 8;
  when('30' ) G_Customer_Age = 2;
  when('31' ) G_Customer_Age = 7;
  when('32' ) G_Customer_Age = 6;
  when('33' ) G_Customer_Age = 6;
  when('34' ) G_Customer_Age = 8;
  when('35' ) G_Customer_Age = 8;
  when('36' ) G_Customer_Age = 8;
  when('37' ) G_Customer_Age = 7;
  when('38' ) G_Customer_Age = 6;
  when('39' ) G_Customer_Age = 7;
  when('40' ) G_Customer_Age = 4;
  when('41' ) G_Customer_Age = 3;
  when('42' ) G_Customer_Age = 7;
  when('43' ) G_Customer_Age = 4;
  when('44' ) G_Customer_Age = 5;
  when('45' ) G_Customer_Age = 5;
  when('46' ) G_Customer_Age = 5;
  when('47' ) G_Customer_Age = 6;
  when('48' ) G_Customer_Age = 4;
  when('49' ) G_Customer_Age = 6;
  when('50' ) G_Customer_Age = 6;
  when('51' ) G_Customer_Age = 7;
  when('52' ) G_Customer_Age = 6;
  when('53' ) G_Customer_Age = 6;
  when('54' ) G_Customer_Age = 2;
  when('55' ) G_Customer_Age = 4;
  when('56' ) G_Customer_Age = 5;
  when('57' ) G_Customer_Age = 7;
  when('58' ) G_Customer_Age = 6;
  when('59' ) G_Customer_Age = 1;
  when('60' ) G_Customer_Age = 8;
  when('61' ) G_Customer_Age = 4;
  when('62' ) G_Customer_Age = 4;
  when('63' ) G_Customer_Age = 8;
  when('64' ) G_Customer_Age = 8;
  when('65' ) G_Customer_Age = 9;
  when('66' ) G_Customer_Age = 0;
  when('67' ) G_Customer_Age = 10;
  when('68' ) G_Customer_Age = 0;
  when('70' ) G_Customer_Age = 10;
  when('73' ) G_Customer_Age = 10;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Customer_Age="Grouped Levels for  Customer_Age";
/*----Customer_Age end----*/

/*----G_Months_on_book begin----*/
length _NORM2 $ 2;
_NORM2 = put( Months_on_book , BEST2. );
%DMNORMIP( _NORM2 )
drop _NORM2;
select(_NORM2);
  when('13' ) G_Months_on_book = 7;
  when('14' ) G_Months_on_book = 8;
  when('15' ) G_Months_on_book = 0;
  when('16' ) G_Months_on_book = 7;
  when('17' ) G_Months_on_book = 7;
  when('18' ) G_Months_on_book = 1;
  when('19' ) G_Months_on_book = 8;
  when('20' ) G_Months_on_book = 3;
  when('21' ) G_Months_on_book = 7;
  when('22' ) G_Months_on_book = 2;
  when('23' ) G_Months_on_book = 7;
  when('24' ) G_Months_on_book = 3;
  when('25' ) G_Months_on_book = 2;
  when('26' ) G_Months_on_book = 6;
  when('27' ) G_Months_on_book = 7;
  when('28' ) G_Months_on_book = 5;
  when('29' ) G_Months_on_book = 6;
  when('30' ) G_Months_on_book = 2;
  when('31' ) G_Months_on_book = 7;
  when('32' ) G_Months_on_book = 5;
  when('33' ) G_Months_on_book = 5;
  when('34' ) G_Months_on_book = 4;
  when('35' ) G_Months_on_book = 6;
  when('36' ) G_Months_on_book = 3;
  when('37' ) G_Months_on_book = 3;
  when('38' ) G_Months_on_book = 4;
  when('39' ) G_Months_on_book = 2;
  when('40' ) G_Months_on_book = 6;
  when('41' ) G_Months_on_book = 3;
  when('42' ) G_Months_on_book = 6;
  when('43' ) G_Months_on_book = 5;
  when('44' ) G_Months_on_book = 2;
  when('45' ) G_Months_on_book = 6;
  when('46' ) G_Months_on_book = 2;
  when('47' ) G_Months_on_book = 6;
  when('48' ) G_Months_on_book = 4;
  when('49' ) G_Months_on_book = 3;
  when('50' ) G_Months_on_book = 0;
  when('51' ) G_Months_on_book = 2;
  when('52' ) G_Months_on_book = 2;
  when('53' ) G_Months_on_book = 8;
  when('54' ) G_Months_on_book = 7;
  when('55' ) G_Months_on_book = 8;
  when('56' ) G_Months_on_book = 4;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_Months_on_book="Grouped Levels for  Months_on_book";
/*----Months_on_book end----*/


****************************************;
*** End Scoring Code from PROC DMINE ***;
****************************************;
