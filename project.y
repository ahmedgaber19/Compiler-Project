%token CONSTANT INCREMENT DECREMENT PLUSE MINUSE MULE DIVE IF ELSE WHILE DO FOR BREAK SWITCH CASE DEFAULT COLON OPENBRACE CLOSEBRACE RETURN OPENBRACKET CLOSEBRACKET COMMA BOOLEAN INTEGER FLOAT DOUBLE LONG CHAR STRING SEMICOLON VARIABLE INTEGERNUMBER FLOATNUMBER TEXT CHARACTER TRUE FALSE CONTINUE

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
    int yydebug = 1;
    void yyerror(char *);
    int yylex(void);
	FILE * yyin;
    FILE * f1;
    int sym[26];
%}

%%

program:
        stmt_list               
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
        
        | FOR OPENBRACKET foriterator SEMICOLON boolexprs SEMICOLON assignmentoperator CLOSEBRACKET  blockscope	 {printf("For loop\n");}
        
        | SWITCH OPENBRACKET VARIABLE CLOSEBRACKET OPENBRACE caseExpression CLOSEBRACE      {printf("Switch case\n");}
        
        | type VARIABLE OPENBRACKET functionArguments CLOSEBRACKET blockscope {printf("function\n");}
        
        | callfn

        | RETURN expr SEMICOLON

        | BREAK SEMICOLON

        | CONTINUE SEMICOLON
        
        ;

callfn:   type VARIABLE ASSIGN VARIABLE OPENBRACKET callfnarg CLOSEBRACKET SEMICOLON
        | VARIABLE ASSIGN VARIABLE OPENBRACKET callfnarg CLOSEBRACKET SEMICOLON
        | VARIABLE OPENBRACKET callfnarg CLOSEBRACKET SEMICOLON
        | VARIABLE OPENBRACKET CLOSEBRACKET SEMICOLON

        ;

callfnarg1:   VARIABLE
            | INTEGERNUMBER                   
            | FLOATNUMBER
            | CHARACTER
            | TEXT;
callfnarg: callfnarg1
         | callfnarg1 COMMA callfnarg
         
    ;

type: INTEGER
	| FLOAT
	| DOUBLE
	| LONG
	| CHAR
	| STRING
	| BOOLEAN
	;
foriterator:  INTEGER VARIABLE ASSIGN INTEGERNUMBER
            | VARIABLE ASSIGN INTEGERNUMBER
            | VARIABLE
            | assignmentoperator
            ;


functionArguments:  type VARIABLE
                  | type VARIABLE COMMA functionArguments
                  |
                  ;


  

expr:
        INTEGERNUMBER                   
        | FLOATNUMBER
        | CHARACTER
        | TEXT                    
        | MINUS expr %prec UMINUS       { $$ = -$2; }
        | expr PLUS expr                { $$ = $1 + $3; }
        | expr MINUS expr               { $$ = $1 - $3; }
        | expr MULTIPLUCATION expr      { $$ = $1 * $3; }
        | expr DIVISION expr            { $$ = $1 / $3; }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        | expr REMAINDER expr           { $$ = $1 % $3; }
		| expr POWER expr               { $$ = $1 ^ $3; }
        | boolexprs
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
        | VARIABLE 
        | TRUE
        | FALSE
        ;



assignmentoperator:
        VARIABLE  INCREMENT                 { $$ = $1+1; }
		| VARIABLE DECREMENT                { $$ = $1-1; }
		| VARIABLE PLUSE expr               { $1 = $1+$3; }
		| VARIABLE MINUSE expr              { $1 = $1-$3; }
		| VARIABLE MULE expr                { $1 = $1*$3; }
		| VARIABLE DIVE expr                { $1 = $1/$3; }
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
		fprintf(f1,"I can not parse");
		printf("\nParsing failed\n");
		return 0;
	}
	fclose(yyin);
	fclose(f1);
    return 0;
}
