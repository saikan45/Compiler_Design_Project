%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int data[60];
	int switchnum;
	int ifdone[200];
	int ifptr = 0;
%}

/* bison declarations */

%token NUM LOOP VAR IN RANGE IF ELSE A MAIN INT FLOAT CHAR START END FOR WHILE ODDEVEN PRINT SIN COS TAN LOG FACTORIAL CASE DEFAULT SWITCH ELSEIF div
%nonassoc IFX
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'

/* Grammar rules and actions follow.  */

%%

program: MAIN ':' START line END {printf("Main function END\n");}
	 ;

line: /* NULL */

	| line statement
	;

statement: ';'			
	| declaration ';'		{  }

	| expression ';' 			{   printf(" expression: %d\n", $1); $$=$1;
		printf("\n");
		}
	
	| VAR '=' expression ';' { 
							printf("\n variable value: %d\n",$3);
							data[$1]=$3;
							$$=$3;
							printf("\n");
						} 
   
	| WHILE '(' NUM '<' NUM ')' START statement END {
	                                int i;
	                                printf("\nWHILE Loop execution\n");
	                                for(i=$3 ; i<$5 ; i++) {printf("\nloop iteration : %d expression value: %d \n", i,$8);}
	                               printf("\n");									
				               }

	| SWITCH '(' NUM ')' {
		switchnum = $3;
		printf("Switch Case :: %d\n",switchnum);
	} START SWITCHCASE END {
		
		printf("\n");
	}


	

	| PRINT '(' expression ')' ';' {printf("\nPrint : %d\n",$3);
		printf("\n");
		}

	| FACTORIAL '(' NUM ')' ';' {
		
		int i;
		int f=1;
		for(i=1;i<=$3;i++)
		{
			f=f*i;
		}
		printf("FACTORIAL of %d is : %d\n",$3,f);
		printf("\n");

		}


	| ODDEVEN '(' NUM ')' ';' {
		printf("Odd Even Number detection \n");

		if($3 %2 ==0){
			printf("Number : %d is -> Even\n",$3);
		}
		else{
			printf("Number is :%d is -> Odd\n",$3);
		}
		
		printf("\n");
		}

	| A TYPE VAR '(' NUM ')' ';' {
		
		
		printf("Size of the ARRAY is : %d\n",$5);
	}

	
	| LOOP '(' NUM ',' NUM ',' NUM ')' START statement END {
	                                int i;
	                                
	                                for(i=$3 ; i<$5 ; i=i+$7 ) 
	                                {printf("\n FOR loop iteration  i: %d expression value : %d\n", i,$10);}
	                                printf("\n");

				               }

	| ifgrammer 			               
	;
ifgrammer	: IF '(' expression ')' START expression ';' END {
	ifptr++;
	if($3>0){
		printf("IF EXECUTED\n");
		ifdone[ifptr]=1;
	}
} elseifgrammer {
	ifptr--;
}
elseifgrammer	: ELSEIF '(' expression ')' START expression ';' END {
	if($3>0 && ifdone[ifptr]==0){
		printf("ELSE IF EXCECUTED\n");
		ifdone[ifptr]=1;
	}
} elseifgrammer
				| ELSE START expression ';' END {
					if(ifdone[ifptr]==0){
						printf("ELSE EXCECUTED\n");
					}
				}
				| /* empty */
				;
declaration : TYPE ID1   { }
            ;


TYPE : INT   {printf("interger declaration : \n");}
     | FLOAT  {printf("float declaration : \n");}
     | CHAR   {printf("char declaration : \n");}
     ;




ID1 : ID1 ',' VAR  
    |VAR  
    ;

 SWITCHCASE: casegrammer
 			|casegrammer defaultgrammer
 			;

 casegrammer: /*empty*/
 			| casegrammer casenumber
 			;

 casenumber: CASE NUM ':' expression ';' {
 	printf("Case No : %d & expression value :%d \n",$2,$4);
 	if($2==switchnum){
 		printf("switch case matched\n");
 	}
 }
 			;
 defaultgrammer: DEFAULT ':' expression ';' {
 				printf("\nDefault case & expression value : %d",$3);
 			}
 		;


expression: NUM					{ $$ = $1;  }

	| VAR						{ $$ = data[$1]; }
	
	| expression '+' expression	{printf("\nAddition : %d \n",$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\nSubtraction :%d \n ",$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\nMultiplication :%d \n ",$1*$3); $$ = $1 * $3; }

	| expression '/' expression	{ if($3){
				     					printf("\nDivision : %d \n ",$1/$3);
				     					$$ = $1 / $3;
				     					
				  					}
				  					else{
										$$ = 0;
										printf("\ndivision by zero\n\t");
				  					} 	
				    			}
	
	| expression '^' expression	{printf("\nPower  :%d ^ %d \n",$1,$3,$1 ^ $3);  $$ = pow($1 , $3);}
	| expression '<' expression	{printf("\nLess Than :%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{printf("\nGreater than :%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }

	| '(' expression ')'		{	 $$ = $2; }
    | SIN expression 			{printf("\nValue of SIN(%d) is : %lf\n",$2,sin($2*3.1416/180)); $$=sin($2*3.1416/180);}

	| LOG expression 			{printf("\nValue of Log(%d) is : %lf\n",$2,(log($2))); $$=(log($2));}
	
	;
%%


int  yyerror(char *s){
	printf( "%s\n", s);
}
int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();

    
	return 0;
}
