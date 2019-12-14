%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "main.tab.h"
%}

variable [a-zA-Z]
digit [0-9]
header		"#".*
Comment		[//].*

	

%%
"CASE" 			{return CASE;}
"SWITCH" 		{return SWITCH;}
"DEFAULT" 		{return DEFAULT;}
{digit}+	{yylval = atoi(yytext); return NUM; }
"PRINT" 	{return PRINT; }
"ELSE IF"	{return ELSEIF;}
"IF" 			   {return IF;   }
"ELSE" 		   {return ELSE; }
"{" 		   {return START;  }
"}"  		   {return END;	}
"FOR" 		   {return FOR;}
"WHILE"		   {return WHILE;}
"FACTORIAL"		{return FACTORIAL;}
"ODDEVEN"		{return ODDEVEN;}
"SIN"		   {return SIN;}
"COS"          {return COS;}
"TAN"          {return TAN;}
"LOG"			{return LOG;}
"INTEGER"  		{return INT;}
"CHAR" 		     {return CHAR;}
"FLOAT"			 {return FLOAT;}
"IN"			{return IN;}
"RANGE"			{return RANGE;}
"LOOP"			{return LOOP;}
"A"			{return A;}
"div"        {return div;}
"main"	   {printf("\nmain function strat\n"); return MAIN; }
{Comment}		{printf("\nSingle line comment found :: ");ECHO;printf("\n");}
{header}  				{printf("\nHeader file found :\n");ECHO;printf("\n");}
[-+/*<>=,():;%^]     {yylval = yytext[0];	return *yytext;	}
{variable}	    {ECHO;printf(" "); yylval = *yytext - 'a'; return	VAR; }

[ ]*	    			{}
[\n]*					{}
[\t]*					{}
.						{printf("\nUnknown syntax : %s\n",yytext);}


%%
