%{
#include <stdio.h>
#include <stdlib.h>
char a[300];
char temp[300];
int lineNo = 1;

int yyerror(char * msg) {
    printf("\nError at parsing : %s\n",yytext);
    fprintf(stderr, "Error at line %d\n",lineNo);
    exit(1);
}

char* clean_space(char* target){
    a[0] = '\0';
    int count = 0;
    for(int i = 0; i <= strlen(target); i++){
        if(target[i] != ' '){
            a[count++] = target[i];
        }
    }
    a[count+1] = '\0';
    return a;
}

char* copyS(char*current){
    char* temp = (char*)malloc((strlen(current)+10)*sizeof(char));
    temp[0] = '\0';
    strcpy(temp,current);
    return temp;
}

#include "y.tab.h"
%}

String      (\"[^[\""!"]]+\")
Char        (\'[^\''!']\')
Identifiers [_]*[a-zA-Z][a-zA-Z0-9_]*|[_]+[a-zA-Z0-9_]*
Integer (0|[1-9][0-9]*)
Float ("."[0-9]+|[1-9]+[0-9]*"."[0-9]*|0.[0-9]+)
Space [ \t\r]+
Types ("const"[ \t]*)?(("signed"|"unsigned")[ \t]*)?(("long long"|"long"|"short")[ \t]*)?"int"|("const"[ \t]*)?(("signed"|"unsigned")[ \t]*)?("long long"|"long"|"short"|"char")|("const"[ \t]*)?("signed"|"unsigned"|"float"|"double"|"void")|"const"


%%
{Types}     {yylval.string = copyS(clean_space(yytext));return(TYPE_ID);}
{Integer}   {yylval.intVal = atoi(yytext); return(TOKEN_INT);}
{Float}     {yylval.dVal = atof(yytext); return(TOKEN_FLOAT);}
"NULL"      {yylval.intVal = 0; return(TOKEN_NULL);}
"for"       {yylval.string = copyS(yytext); return(KEYWORD_FOR);}
"do"        {yylval.string = copyS(yytext); return(KEYWORD_DO);}
"while"     {yylval.string = copyS(yytext); return(KEYWORD_WHILE);}
"break"     {yylval.string = copyS(yytext); return(KEYWORD_BREAK);}
"continue"  {yylval.string = copyS(yytext); return(KEYWORD_CONTI);}
"if"        {yylval.string = copyS(yytext); return(KEYWORD_IF);}
"else"      {yylval.string = copyS(yytext); return(KEYWORD_ELSE);}
"return"    {yylval.string = copyS(yytext); return(KEYWORD_RETURN);}
"struct"    {yylval.string = copyS(yytext); return(KEYWORD_STRUCT);}
"switch"    {yylval.string = copyS(yytext); return(KEYWORD_SWITCH);}
"case"      {yylval.string = copyS(yytext); return(KEYWORD_CASE);}
"default"   {yylval.string = copyS(yytext); return(KEYWORD_DEFAULT);}
":"         {yylval.string = copyS(yytext); return(PUNC_COLON);}
";"         {yylval.string = copyS(yytext); return(PUNC_SEMICOL);}
","         {yylval.string = copyS(yytext); return(PUNC_COMMA);}
"."         {yylval.string = copyS(yytext); return(PUNC_DOT);}
"{"         {yylval.string = copyS(yytext); return(PUNC_LEFT_BRA);}
"}"         {yylval.string = copyS(yytext); return(PUNC_RIGHT_BRA);}
"["         {yylval.string = copyS(yytext); return(PUNC_LEFT_BRAC);}
"]"         {yylval.string = copyS(yytext); return(PUNC_RIGHT_BRAC);}
"("         {yylval.string = copyS(yytext); return(PUNC_LEFT_PAR);}
")"         {yylval.string = copyS(yytext); return(PUNC_RIGHT_PAR);}
"++"        {yylval.string = copyS(yytext); return(OP_ADDONE);}
"--"        {yylval.string = copyS(yytext); return(OP_MINUSONE);}
"&&"        {yylval.string = copyS(yytext); return(OP_LOGIC_AND);}
"||"        {yylval.string = copyS(yytext); return(OP_LOGIC_OR);}
"=="        {yylval.string = copyS(yytext); return(OP_EQUIVALANCE);}
"!="        {yylval.string = copyS(yytext); return(OP_NOT_EQUIVALANCE);}
"<="        {yylval.string = copyS(yytext); return(OP_LE);}
">="        {yylval.string = copyS(yytext); return(OP_GE);}
"<"         {yylval.string = copyS(yytext); return(OP_LT);}
">"         {yylval.string = copyS(yytext); return(OP_GT);}
">>"        {yylval.string = copyS(yytext); return(OP_SHIFT_R);}
"<<"        {yylval.string = copyS(yytext); return(OP_SHIFT_L);}
"="         {yylval.string = copyS(yytext); return(OP_EQUAL);}
"!"         {yylval.string = copyS(yytext); return(OP_LOGIC_NOT);}
"&"         {yylval.string = copyS(yytext); return(OP_BIT_AND);}
"|"         {yylval.string = copyS(yytext); return(OP_BIT_OR);}
"^"         {yylval.string = copyS(yytext); return(OP_BIT_XOR);}
"%"         {yylval.string = copyS(yytext); return(OP_PERCENT);}
"/"         {yylval.string = copyS(yytext); return(OP_DIVIDE);}
"*"         {yylval.string = copyS(yytext); return(OP_MUL);}
"-"         {yylval.string = copyS(yytext); return(OP_MINUS);}
"+"         {yylval.string = copyS(yytext); return(OP_ADD);}
"~"         {yylval.string = copyS(yytext); return(OP_BIT_NOT);}
{Identifiers}  {yylval.string = copyS(yytext); return(TOKEN_ID);}
{Space}     {}
{String}    {yylval.string = copyS(yytext); return(TOKEN_STR);}
{Char}      {yylval.string = copyS(yytext); return(TOKEN_CHAR);}
\n          {lineNo += 1;}


%%