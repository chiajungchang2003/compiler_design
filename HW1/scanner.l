%{
#include <stdio.h>
int myline = 1;
int extend = 0;
int prag_State = 0;
char want[300] = "\0";

void add(char*current){
    strcat(want,current);
}

void clearBuff(){
    want[0] = '\0';
}
%}

Keywords "for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long"
Macros "NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN"
Identifiers [_]*[a-zA-Z][a-zA-Z0-9_]*|[_]+[a-zA-Z0-9_]*
Operators "++"|"--"|"&&"|"||"|"=="|"!="|"<="|">="|"<"|">"|"="|"!"|"&"|"|"|"%"|"/"|"*"|"-"|"+"
Puncuations ":"|";"|","|"."|"{"|"}"|"["|"]"|"("|")"
Integer [+-]?(0|[1-9][0-9]*)
Float [+-]?("."[0-9]+|[0-9]+"."[0-9]*)
String \".*\"
Character '[a-zA-Z0-9"$()_`\\]*'|'\\[0abertfvn'"?]'|'\\([0-7]{1,3})'|'\\u([0-9]{1,4})'|'\\U([0-9]{1,8})'|'\\x([0-9]+)'|('\+'|'\-'|'\*'|'\/'|'^'|'%'|'&'|'#'|'!'|'@'|'\?'|'\['|'\]'|'\{'|'\}'|'\|'|'\\\\')
SingleCommentStart "//"
MultiCommentStart "/"+"*"
SingleCommentExtend "\\"
Pragma "#pragma"
Space [ \t]

PRAGSRCON		^[ \t]*#pragma[ \t]+source[ \t]+on[ \t]*\n
PRAGSRCOFF		^[ \t]*#pragma[ \t]+source[ \t]+off[ \t]*\n
PRAGTOKENON			^[ \t]*#pragma[ \t]+token[ \t]+on[ \t]*\n
PRAGTOKENOFF		^[ \t]*#pragma[ \t]+token[ \t]+off[ \t]*\n

%x multicomment
%x comment
%x SOURCEOFF
%x TOKENOFF
%x BOTHOFF

%%

{PRAGSRCON} {prag_State = 0;printf("%d:%s", myline, yytext); myline++;}
{PRAGSRCOFF} {prag_State = 1; BEGIN(SOURCEOFF); myline++;}
{PRAGTOKENON} {prag_State = 0;printf("%d:%s", myline, yytext); myline++;}
{PRAGTOKENOFF} {prag_State = 2; printf("%d:%s", myline, yytext); BEGIN(TOKENOFF); myline++;}
{SingleCommentStart} {add(yytext);BEGIN(comment);}
{MultiCommentStart} {add(yytext); BEGIN(multicomment);}


<comment>{SingleCommentExtend} {add(yytext); extend = 1;}
<comment>(\n) {add(yytext); if(prag_State == 0 | prag_State == 2){printf("%d:%s",myline,want);} myline++; clearBuff(); if(extend == 0){if(prag_State == 0){BEGIN(INITIAL);} if(prag_State == 1){BEGIN(SOURCEOFF);} if(prag_State == 2){BEGIN(TOKENOFF);} if(prag_State == 3){BEGIN(BOTHOFF);}} extend = 0;}
<comment>([^\n]) {add(yytext);}
<multicomment>(\n) {add(yytext); if(prag_State == 0 | prag_State == 2){printf("%d:%s",myline,want);} myline++; clearBuff();}
<multicomment>("*/") {add(yytext); if(prag_State == 0){BEGIN(INITIAL);} if(prag_State == 1){BEGIN(SOURCEOFF);} if(prag_State == 2){BEGIN(TOKENOFF);} if(prag_State == 3){BEGIN(BOTHOFF);}}
<multicomment>. {add(yytext);}

<SOURCEOFF>{PRAGSRCON} {prag_State = 0; printf("%d:%s", myline, yytext); BEGIN(INITIAL);myline++;}
<SOURCEOFF>{PRAGSRCOFF} {prag_State = 1; myline++;}
<SOURCEOFF>{PRAGTOKENON} {prag_State = 1; myline++;}
<SOURCEOFF>{PRAGTOKENOFF} {prag_State = 3; BEGIN(BOTHOFF); myline++;}
<SOURCEOFF>{SingleCommentStart} {add(yytext); BEGIN(comment);}
<SOURCEOFF>{MultiCommentStart} {add(yytext); BEGIN(multicomment);}

<TOKENOFF>{PRAGSRCON} {prag_State = 2; printf("%d:%s", myline, yytext);myline++;}
<TOKENOFF>{PRAGSRCOFF} {prag_State = 3; BEGIN(BOTHOFF); myline++;}
<TOKENOFF>{PRAGTOKENON} {prag_State = 0; printf("%d:%s", myline, yytext); BEGIN(INITIAL);myline++;}
<TOKENOFF>{PRAGTOKENOFF} {prag_State = 2; myline++;}
<TOKENOFF>{SingleCommentStart} {add(yytext); BEGIN(comment);}
<TOKENOFF>{MultiCommentStart} {add(yytext); BEGIN(multicomment);}

<BOTHOFF>{PRAGSRCON} {prag_State = 2; printf("%d:%s", myline, yytext); BEGIN(TOKENOFF); myline++;}
<BOTHOFF>{PRAGSRCOFF} {prag_State = 3; myline++;}
<BOTHOFF>{PRAGTOKENON} {prag_State = 1; BEGIN(SOURCEOFF);myline++;}
<BOTHOFF>{PRAGTOKENOFF} {prag_State = 3; myline++;}
<BOTHOFF>{SingleCommentStart} {add(yytext); BEGIN(comment);}
<BOTHOFF>{MultiCommentStart} {add(yytext); BEGIN(multicomment);}


{Keywords} {printf("#key:%s\n",yytext); add(yytext);}
{Macros} {printf("#macro:%s\n",yytext); add(yytext);}
{Operators} {printf("#op:%s\n",yytext); add(yytext);}
{Puncuations} {printf("#punc:%s\n",yytext); add(yytext);}
{Float} {printf("#float:%s\n",yytext); add(yytext);}
{Integer} {printf("#integer:%s\n",yytext); add(yytext);}
{String} {printf("#string:%s\n",yytext); add(yytext);}
{Character} {printf("#char:%s\n",yytext); add(yytext);}
{Identifiers} {printf("#id:%s\n",yytext); add(yytext);}
{Space} {add(yytext);}
\n {add(yytext); printf("%d:%s", myline,want); myline++; clearBuff();}
. {add(yytext);}

<SOURCEOFF>{Keywords} {printf("#key:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Macros} {printf("#macro:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Operators} {printf("#op:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Puncuations} {printf("#punc:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Float} {printf("#float:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Integer} {printf("#integer:%s\n",yytext); add(yytext);}
<SOURCEOFF>{String} {printf("#string:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Character} {printf("#char:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Identifiers} {printf("#id:%s\n",yytext); add(yytext);}
<SOURCEOFF>{Space} {add(yytext);}
<SOURCEOFF>\n {myline++; clearBuff();}
<SOURCEOFF>. {add(yytext);}

<TOKENOFF>{Keywords} {add(yytext);}
<TOKENOFF>{Macros} {add(yytext);}
<TOKENOFF>{Operators} {add(yytext);}
<TOKENOFF>{Puncuations} {add(yytext);}
<TOKENOFF>{Float} {add(yytext);}
<TOKENOFF>{Integer} {add(yytext);}
<TOKENOFF>{String} {add(yytext);}
<TOKENOFF>{Character} {add(yytext);}
<TOKENOFF>{Identifiers} {add(yytext);}
<TOKENOFF>{Space} {add(yytext);}
<TOKENOFF>\n {add(yytext); printf("%d:%s", myline,want); myline++; clearBuff();}
<TOKENOFF>. {add(yytext);}

<BOTHOFF>{Keywords} {add(yytext);}
<BOTHOFF>{Macros} {add(yytext);}
<BOTHOFF>{Operators} {add(yytext);}
<BOTHOFF>{Puncuations} {add(yytext);}
<BOTHOFF>{Float} {add(yytext);}
<BOTHOFF>{Integer} {add(yytext);}
<BOTHOFF>{String} {add(yytext);}
<BOTHOFF>{Character} {add(yytext);}
<BOTHOFF>{Identifiers} {add(yytext);}
<BOTHOFF>{Space} {add(yytext);}
<BOTHOFF>\n {myline++; clearBuff();}
<BOTHOFF>. {add(yytext);}


%%

int main(int argc, char* argv[])
{
    yylex() ;
    return 0;   
}
