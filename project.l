%{
    #include "y.tab.h"
	 #include <stdlib.h>
	 #include <stdio.h>
    void yyerror(char *);
%}

%%

"const"                        return CONSTANT;
"+"						       return PLUS;
"-"						       return MINUS;
"*"						       return MULTIPLUCATION;
"/"						       return DIVISION;
"++"					       return INCREMENT;
"--"					       return DECREMENT;
"^"						       return POWER;
"="						       return ASSIGN;
"%"						       return REMAINDER;
"&&"					       return AND;
"||"					       return OR;
"!"						       return NOT;
"+="					       return PLUSE;
"-="					       return MINUSE;
"*="					       return MULE;
"/="					       return DIVE;
">"         	 		       return GREATERTHAN;
"<"         	 		       return LESSTHAN;
">="         	 		       return GREATERE;
"<="             		       return LESSE;
"=="             		       return EE;
"!="             		       return NOTE;
"if"             		       return IF;
"else"           		       return ELSE;
"while"          		       return WHILE;
"do"					       return DO;
"for"          			       return FOR;
"break"                        return BREAK;
"continue"                     return CONTINUE;
"switch"                       return SWITCH;
"case"                         return CASE;
"default"                      return DEFAULT; 
":"                            return COLON; 
"{"                            return OPENBRACE;
"}"                            return CLOSEBRACE;
"return"                       return RETURN;
"void"                         return VOID;
"("                            return OPENBRACKET;
")"                            return CLOSEBRACKET;
","                            return COMMA;
"bool"				           return BOOLEAN;
"int"					       return INTEGER;
"float"					       return FLOAT;
"double"				       return DOUBLE;
"long"					       return LONG;
"char"					       return CHAR;
"string"				       return STRING;
"true"					       return TRUE;
"false"					       return FALSE;
";"                            return SEMICOLON;

[a-zA-z][_a-zA-z0-9]*          return VARIABLE;
[0-9]+											{yylval = atoi(yytext); return INTEGERNUMBER;}
[0-9]+\.[0-9]+									{yylval = atof(yytext); return FLOATNUMBER;}
\".*\"											{yylval=yytext;return TEXT;} // for copying the i/p token
\'.?\'											{yylval=yytext;return CHARACTER;}
[\t\n]+											/* ignore whitespace and newline */;
.                                               {yyerror("UnExpectedToken");}
%%

int yywrap(void) {
    return 1;
}
