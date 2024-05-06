/*
Insper, 2024-1, Lógica da Computação, APS
Jerônimo de Abreu Afrange

Define a parte léxica usando o flex.
Desempenha papel similar ao Tokenizer do compilador da disciplina.
*/

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	enum yytokentype {
		NUMBER						= 258,
		STRING						= 259,
		AA_ROOF         			= 260,
		AA_STORY        			= 261,
		AA_GROUND_FLOOR 			= 262,
		AA_SELECTOR     			= 263,
		IDENT						= 264,
		ASSIGN_1_VARDEC_2			= 265,	// pombo
		ASSIGN_2					= 266,	// agora
		ASSIGN_3					= 267,	// is
		PRINT_1						= 268,	// where
		PRINT_2_PESSOA				= 269,	// estou
		PRINT_2_ELEVADOR			= 270,	// está
		WHILE_1						= 271,	// enquanto
		WHILE_2						= 272,	// waiting
		WHILE_3_CALL_ENTER_LEAVE_2	= 273,	// elevador
		IF							= 274,	// térreo
		QUESTION					= 275, 	// ?
		VARDEC_1					= 276,	// grab
		VARDEC_ASSIGN				= 277,	// é
		CALL_1						= 278,	// call
		ENTER_1						= 279,	// enter
		LEAVE_1						= 280,	// leave
		PUSH_BUTTON_1				= 281,	// push
		PUSH_BUTTON_2				= 282,	// botão
		PUSH_BUTTON_3				= 283,	// for
		PUSH_BUTTON_4				= 284,	// o
		PUSH_BUTTON_5				= 285,	// piso
		SUBIR_ESCADA_1				= 286, 	// subir
		DESCER_ESCADA_1				= 287, 	// descer
		SUBIR_DESCER_ESCADA_2		= 288,	// stairs
		OR							= 289,	// or
		AND 						= 290,	// and
		EQUAL						= 291, 	// ==
		GREATER_THAN				= 292, 	// >
		LESS_THAN					= 293, 	// <
		NOT_EQUAL					= 294, 	// !=
		GREATER_EQUAL				= 295,	// >=
		LESS_EQUAL					= 296,	// <=
		ADD							= 297,	// +
		SUB 						= 298, 	// -
		CAT 						= 299,	// ..
		MULT						= 300, 	// *
		DIV							= 301,	// /
		NOT 						= 302,	// not
		OPENPAR						= 303, 	// (
		CLOSEPAR					= 304,	// )
		GROUND						= 305,	// ground
		ORDINAL 					= 306,
		TAB            				= 499,
		EOL             			= 500
	};

	char strval[64];
	int intval;

%}

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
"\n"						{ return EOL; }
[0-9]+						{ intval = atoi(yytext); return NUMBER; }
[a-zA-Z]+[a-zA-Z_]*			{ sprintf(strval, "%s", yytext); return IDENT; }
[ ]  						{ /* ignora espaços */ }
.      						{ printf("Mystery character %c\n", *yytext); }

%%

main(int argc, char **argv)
{
  int token;

  while(token = yylex()) {
    printf("%d", token);
    if(token == IDENT) printf(" = %s\n", strval);
	else if (token == NUMBER) printf(" = %d\n", intval);
	else if (token == STRING) printf(" = %s\n", strval);
    else printf("\n");
  }
}


