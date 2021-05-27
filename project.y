%token CONSTANT INCREMENT DECREMENT PLUSE MINUSE MULE DIVE IF ELSE WHILE DO FOR BREAK CONTINUE SWITCH CASE DEFAULT COLON OPENBRACE CLOSEBRACE RETURN VOID OPENBRACKET CLOSEBRACKET COMMA BOOLEAN INTEGER FLOAT DOUBLE LONG CHAR STRING TRUE FALSE SEMICOLON VARIABLE INTEGERNUMBER FLOATNUMBER TEXT CHARACTER

%right ASSIGN EE
%left GREATERTHAN LESSTHAN GREATERE LESSE NOTE AND OR NOT
%left PLUS MINUS 
%left DIVISION MULTIPLUCATION REMAINDER
%right POWER
%nonassoc IFX
%nonassoc ELSE
%nonassoc UMINUS



%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);
	FILE * yyin;
    FILE * f1;
    int sym[26];
%}

%%

program:
        stmt               
        ;

stmt:
        type VARIABLE SEMICOLON                                                                     {printf("Declaration\n");}

		| VARIABLE ASSIGN expr SEMICOLON	                                                        {printf("Assignment\n");}

		| type VARIABLE ASSIGN expr	SEMICOLON	                                                    {printf("Declaration and Assignment\n");}

        | CONSTANT type VARIABLE ASSIGN expr SEMICOLON                                              {printf("Constant assignment\n");}

        | IF OPENBRACKET boolexprs CLOSEBRACKET blockscope %prec IFX                                {printf("If statement\n");}

		| IF OPENBRACKET boolexprs CLOSEBRACKET blockscope	 ELSE blockscope	                    {printf("If-Elsestatement\n");}

        | WHILE OPENBRACKET boolexprs CLOSEBRACKET blockscope                                       {printf("While loop\n");}

        | DO blockscope WHILE OPENBRACKET boolexprs CLOSEBRACKET SEMICOLON	                        {printf("Do while\n");}

        | assignmentoperator SEMICOLON                                                              {printf("Increments\n");}
        
        | FOR OPENBRACKET INTEGER VARIABLE ASSIGN INTEGERNUMBER SEMICOLON boolexprs SEMICOLON for_increment CLOSEBRACKET  blockscope	 {printf("For loop\n");}

        | SWITCH OPENBRACKET VARIABLE CLOSEBRACE OPENBRACE caseExpression CLOSEBRACE      {printf("Switch case\n");}
        
        | functionType VARIABLE OPENBRACKET functionArguments CLOSEBRACKET OPENBRACE stmt_list RETURN expr SEMICOLON CLOSEBRACE {printf("function\n");}

        ;

type: INTEGER
	| FLOAT
	| DOUBLE
	| LONG
	| CHAR
	| STRING
	| BOOLEAN
	;

functionArguments:
    type VARIABLE
    | type VARIABLE COMMA functionArguments
    |
    ;

functionType:
    VOID
    | type
    ;    

expr:
        INTEGERNUMBER                   { $$ =$1; }
        | VARIABLE                      { $$ =$1; }
        | MINUS expr %prec UMINUS       { $$ = -$2; }
        | expr PLUS expr                { $$ = $1 + $3; }
        | expr MINUS expr               { $$ = $1 - $3; }
        | expr MULTIPLUCATION expr      { $$ = $1 * $3; }
        | expr DIVISION expr            { $$ = $1 / $3; }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        | expr REMAINDER expr           { $$ = $1 % $3; }
		| expr POWER expr               { $$ = $1 ^ $3; }
        | boolexprs 
        | assignmentoperator
        ;
boolexprs:
        expr AND expr                   { $$ = $1 && $3; }
		| expr OR expr                  { $$ = $1 || $3; }
		| NOT expr                      { $$ = ! $2; }
        | expr LESSTHAN expr            { $$ = $1 < $3; }
        | expr GREATERTHAN expr         { $$ = $1 > $3; }
        | expr GREATERE expr            { $$ = $1 >= $3; }
        | expr LESSE expr               { $$ = $1 <= $3; }
        | expr NOTE expr                { $$ = $1 != $3; }
        | expr EE expr                  { $$ = $1 == $3;  }
        ;

        

assignmentoperator:
        VARIABLE  INCREMENT                 { $$ = $1+1; }
		| VARIABLE DECREMENT                { $$ = $1+1; }
		| VARIABLE PLUSE expr               { $1 = $1+$3; }
		| VARIABLE MINUSE expr              { $1 = $1-$3; }
		| VARIABLE MULE expr                { $1 = $1*$3; }
		| VARIABLE DIVE expr                { $1 = $1/$3; }
		;

for_increment:
        assignmentoperator
        | VARIABLE ASSIGN expr  
        ;


blockscope:	
            OPENBRACE stmt_list CLOSEBRACE	{printf("Stmt brace\n");}
			| OPENBRACE CLOSEBRACE	
		    ;

stmt_list:
        stmt                 
        | stmt_list stmt        
        ;

caseExpression:	
		CASE caseCondition COLON stmt_list BREAK SEMICOLON  caseExpression  		
        | DEFAULT COLON stmt_list BREAK SEMICOLON                              
		;

caseCondition:
        VARIABLE
        | INTEGERNUMBER
        | FLOATNUMBER
        | TEXT
        | CHARACTER
        ;

        
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
     yyin = fopen("test.txt", "r");
	f1=fopen("output.txt","w");
	
   if(!yyparse())
	{
		printf("\nParsing complete\n");
		fprintf(f1,"hello there");
	}
	else
	{
		printf("\nParsing failed\n");
		return 0;
	}
	fclose(yyin);
	fclose(f1);
    return 0;
}