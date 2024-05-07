/*
Insper, 2024-1, Lógica da Computação, APS
Jerônimo de Abreu Afrange

Define a parte léxica usando o flex.
Desempenha papel similar ao Tokenizer do compilador da disciplina.
*/

%{
#include "parser.tab.h"
%}

DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENT  		{LETTER}({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+
SPACE       [ ]
COMMENT     %[^\n]*
EOL     	[\n]

%%

"   _!_"    				{ return AA_ROOF; }
"  |o o|"   				{ return AA_STORY; }
"__|_#_|__" 				{ return AA_GROUND_FLOOR; }
"$"							{ return AA_SELECTOR; }
"pombo"						{ return ASSIGN_1_VARDEC_2; }
"agora"						{ return ASSIGN_2; }
"is"						{ return ASSIGN_3; }
"where"						{ return PRINT_1; }
"estou"						{ return PRINT_2_PESSOA; }
"está"						{ return PRINT_2_ELEVADOR; }
"enquanto"					{ return WHILE_1; }
"waiting"					{ return WHILE_2; }
"elevador"					{ return WHILE_3_CALL_ENTER_LEAVE_2; }
"térreo"					{ return IF; }
"?"							{ return QUESTION; }
"grab"						{ return VARDEC_1; }
"é"							{ return VARDEC_ASSIGN; }
"call"						{ return CALL_1; }
"enter"						{ return ENTER_1; }
"leave"						{ return LEAVE_1; }
"push" 						{ return PUSH_BUTTON_1; }
"botão" 					{ return PUSH_BUTTON_2; }
"for" 						{ return PUSH_BUTTON_3; }
"o" 						{ return PUSH_BUTTON_4; }
"piso" 						{ return PUSH_BUTTON_5; }
"subir" 					{ return SUBIR_ESCADA_1; }
"descer"					{ return DESCER_ESCADA_1; }
"stairs"					{ return SUBIR_DESCER_ESCADA_2; }
"or"						{ return OR; }
"and"						{ return AND; }
"=="						{ return EQUAL; }
">"							{ return GREATER_THAN; }
"<"							{ return LESS_THAN; }
"!="						{ return NOT_EQUAL; }
">="						{ return GREATER_EQUAL; }
"<="						{ return LESS_EQUAL; }
"+"							{ return ADD; }
"-"							{ return SUB; }
".."						{ return CAT; }
"*"							{ return MULT; }
"/"							{ return DIV; }
"not"						{ return NOT; }
"("							{ return OPENPAR; }
")"							{ return CLOSEPAR; }
"ground"					{ return GROUND; }
{EOL}						{ return EOL; }
{NUMBER}                    { yylval.num = atoi(yytext); return NUMBER; }
{IDENT}                    	{ yylval.str = strdup(yytext); return IDENT; }
{SPACE}                     ;
{COMMENT}                   ;

%%

int yywrap() {
    return 1;
}


