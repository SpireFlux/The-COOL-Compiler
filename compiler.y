%{
	#include <stdio.h>
	#include <stdlib.h>
	int yylex();
	int yyerror();
	extern FILE *yyin;
%}
   
%token TRUE FALSE STRING INTEGER OB CB NOT EQ LET LTE LT COMP DIV OCB CCB SS COMMA COL ASSIGN AT DOT IF THEN ELSE FI WHILE LOOP POOL IN CASE OF TYPEOF ESAC NEW ISVOID SUB ADD MUL CLASS INHERITS TYPE ID
 %right ASSIGN
    %precedence NOT
    %nonassoc LT EQ LTE
    %left ADD SUB
     %left MUL DIV
    %precedence ISVOID
    %precedence COMP
    %precedence AT
    %precedence DoT

%% 
stmt : program;
features: feature SS features 
		|
		;
classes: class SS classes1
		;
classes1: class SS classes1
		|
		;
formals: COMMA formal formals
		|
		;
exprs: COMMA expr exprs
		|
		;
program: classes
		;
class: CLASS TYPE INHERITS TYPE OCB features CCB
		|
		CLASS TYPE OCB features CCB 
		;
feature:  ID OB formal formals CB COL TYPE OCB expr 		  CCB
		| ID OB CB COL TYPE OCB expr CCB
		| ID COL TYPE ASSIGN expr
		| ID COL TYPE 
		;
formal: ID COL TYPE
		;

expressplus: expr SS expressplus | ;

express: COMMA ID COL TYPE ASSIGN expr express|
	;


cases: ID COL TYPE TYPEOF expr SS cases1;

cases1: ID COL TYPE TYPEOF expr SS cases1 | ;

expr : TRUE 
	| FALSE 
	| STRING 
	| INTEGER 
	| ID
	 | OB expr CB 
	 |NOT expr 
	 | expr EQ expr 
	 | expr LTE expr 
	 | expr LT expr 
	 | COMP expr 
	 | expr DIV expr 
	 | expr MUL expr 
	 | expr SUB expr 
	 | expr ADD expr 
	 | ISVOID expr 
	 | NEW TYPE 
	 | CASE expr OF cases ESAC
	 | LET ID COL TYPE ASSIGN expr express IN expr
	 | LET ID COL TYPE express IN expr
	 | OCB expressplus CCB
	 | WHILE expr LOOP expr POOL
	 | IF expr THEN expr ELSE expr FI 
	 | ID ASSIGN expr 
	 | expr AT TYPE DOT ID OB expr exprs CB 
	 | expr DOT ID OB expr exprs CB
	 | expr DOT ID OB CB
	 | expr AT TYPE DOT ID OB CB
	 | ID OB expr exprs CB
	 | ID OB CB
	  ;
%%

int yyerror(char *msg)
{
	printf("Invalid Expression: The issue is this ---> %s", msg);
	return 1; 
}

void main()
{
	
	yyin=fopen("SampleInput.txt", "r");
	do 
	{
	 if(yyparse())
	 {
	  printf("\n Failure");
	  exit(0);
	 }
	} while (!feof(yyin));
	printf("Success");
}
