%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
%}

%union { 
    int intVal;
    double dVal;
    char* string;
};

%type<intVal>   START
%type<string>   COMPONENT_LIST COMPONENT DECLARATION FUNC SCALAR_DECLARATION  ARRAY_DECLARATION TYPES IDENTS IDENT IDENT_W_INIT IDENT_WO_INIT ARRAY_DIM ARRAY_DIMS ARRAY_IDENT ARRAY_IDENTS ARRAY_IDENT_W_INIT ARRAY_IDENT_WO_INIT ARRAY_CONTENT CONTENTS CONTENT FUNC_DEF FUNC_DECL PARAMS PARAM COMPOUND_STMT_LIST COMPOUND_STMT STMTS COMPOUND_ITEM EXPR_STMT IF_ELSE_STMT SWITCH_STMT WHILE_STMT IF_ELSE_STMT END_STMT FOR_INVOC DO_WHILE_STMT SOLE_WHILE_STMT SWITCH_CLAUSES SWITCH_CLAUSE IF_COMPOUND_STMT
%type<string>   EXPR ASSIGN_EXPR LOGIC_OR_EXPR UNARY_EXPR LOGIC_AND_EXPR BIT_OR_EXPR BIT_XOR_EXPR BIT_AND_EXPR EQVAL_EXPR RELATE_EXPR SHIFT_EXPR ADDSUB_EXPR MULDIV_EXPR UNARY_OPERS NORMAL_EXPR VAR TYPE_CASTING NORMAL_FUNC NORMAL_ARRAY NORMAL_ARRAY_DIMS NORMAL_ARRAY_DIM NORMAL_FUNC_PARAMS EXPR_TERM
%type<string>   STMT SWITCH_BODY SWITCH_CLAUSE_LIST FOR_STMT SWITCH_CLAUSES SWITCH_CLAUSE_W_STMT SWITCH_CLAUSE_WO_STMT FOR_INVOC_HEAD FOR_INVOC_MID FOR_INVOC_END
%token<string> TOKEN_STR TOKEN_CHAR TOKEN_ID
%token<dVal> TOKEN_FLOAT
%token<intVal> TOKEN_NULL TOKEN_INT
%token<string> KEYWORD_FOR KEYWORD_DO KEYWORD_WHILE KEYWORD_BREAK KEYWORD_CONTI KEYWORD_IF KEYWORD_ELSE KEYWORD_RETURN KEYWORD_STRUCT KEYWORD_CASE KEYWORD_SWITCH KEYWORD_DEFAULT
%token<string> PUNC_SEMICOL PUNC_COMMA PUNC_DOT PUNC_LEFT_BRA PUNC_RIGHT_BRA PUNC_LEFT_BRAC PUNC_RIGHT_BRAC PUNC_LEFT_PAR PUNC_RIGHT_PAR PUNC_COLON
%token<string> TYPE_ID
%token<string> OP_ADDONE OP_MINUSONE OP_LOGIC_AND OP_LOGIC_OR OP_EQUIVALANCE OP_NOT_EQUIVALANCE OP_LE OP_GE OP_LT OP_GT OP_EQUAL OP_NOT OP_BIT_AND OP_BIT_OR OP_PERCENT OP_DIVIDE OP_MUL OP_MINUS OP_ADD OP_ASSIGN OP_BIT_XOR OP_SHIFT_L OP_SHIFT_R OP_LOGIC_NOT OP_BIT_NOT

%left PUNC_COMMA
%right OP_ASSIGN 
%left OP_LOGIC_OR 
%left OP_LOGIC_AND
%left OP_BIT_OR
%left OP_BIT_XOR
%left OP_BIT_AND 
%left OP_EQUIVALANCE OP_NOT_EQUIVALANCE 
%left OP_GE OP_GT OP_LE OP_LT 
%left OP_SHIFT_L OP_SHIFT_R 
%left OP_ADD OP_MINUS 
%left OP_MUL OP_DIVIDE OP_PERCENT
%right OP_LOGIC_NOT OP_BIT_NOT OP_ADDONE OP_MINUSONE

%%

START
    :   COMPONENT_LIST {
        printf("%s",$1);
        free($1);
        $$ = 1;
    }
    ;

COMPONENT_LIST
    :   COMPONENT_LIST COMPONENT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   COMPONENT
    ;

COMPONENT
    :   DECLARATION
    |   FUNC
    ;

DECLARATION
    :   SCALAR_DECLARATION {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<scalar_decl>%s</scalar_decl>",$1);
        free($1);
    }
    |   ARRAY_DECLARATION {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<array_decl>%s</array_decl>",$1);
        free($1);
    }
    ;

TYPES
    :   TYPE_ID
    ;

SCALAR_DECLARATION
    :   TYPES IDENTS PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

IDENTS
    :   IDENTS PUNC_COMMA IDENT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   IDENT
    ;

IDENT
    :   IDENT_W_INIT
    |   IDENT_WO_INIT
    ;

IDENT_W_INIT
    :   TOKEN_ID OP_EQUAL EXPR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   OP_MUL TOKEN_ID OP_EQUAL EXPR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        free($1);
        free($2);
        free($3);
        free($4);
    }
    ;

IDENT_WO_INIT
    :   TOKEN_ID
    |   OP_MUL TOKEN_ID {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

ARRAY_DECLARATION
    :   TYPES ARRAY_IDENTS PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

ARRAY_IDENTS
    :   ARRAY_IDENTS PUNC_COMMA ARRAY_IDENT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   ARRAY_IDENT
    ;

ARRAY_IDENT
    :   ARRAY_IDENT_WO_INIT
    |   ARRAY_IDENT_W_INIT
    ;

ARRAY_IDENT_W_INIT
    :   TOKEN_ID ARRAY_DIMS OP_EQUAL ARRAY_CONTENT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        free($1);
        free($2);
        free($3);
        free($4);
    }
    ;

ARRAY_CONTENT
    :   PUNC_LEFT_BRA CONTENTS PUNC_RIGHT_BRA {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

CONTENTS
    :   CONTENTS PUNC_COMMA CONTENT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   CONTENT
    ;

CONTENT
    :   EXPR
    |   ARRAY_CONTENT
    ;

ARRAY_IDENT_WO_INIT
    :   TOKEN_ID ARRAY_DIMS {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

ARRAY_DIMS
    :   ARRAY_DIMS ARRAY_DIM {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   ARRAY_DIM
    ;

ARRAY_DIM
    :   PUNC_LEFT_BRAC EXPR PUNC_RIGHT_BRAC {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   PUNC_LEFT_BRAC PUNC_RIGHT_BRAC {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

FUNC
    :   FUNC_DEF {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<func_def>%s</func_def>",$1);
        free($1);
    }
    |   FUNC_DECL {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<func_decl>%s</func_decl>",$1);
        free($1);
    }
    ;

FUNC_DECL
    :   TYPES IDENT_WO_INIT PUNC_LEFT_PAR PUNC_RIGHT_PAR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    |   TYPES IDENT_WO_INIT PUNC_LEFT_PAR PARAMS PUNC_RIGHT_PAR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        strcat($$,$6);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
        free($6);
    }
    ;

PARAMS
    :   PARAMS PUNC_COMMA PARAM {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   PARAM
    ;

PARAM
    :   TYPES OP_MUL TOKEN_ID {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   TYPES TOKEN_ID {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

FUNC_DEF
    :   TYPES IDENT_WO_INIT PUNC_LEFT_PAR PUNC_RIGHT_PAR COMPOUND_STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    |   TYPES IDENT_WO_INIT PUNC_LEFT_PAR PARAMS PUNC_RIGHT_PAR COMPOUND_STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        strcat($$,$6);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
        free($6);
    }
    ;


STMTS
    :   STMTS STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   STMT
    ;

STMT
    :   EXPR_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   IF_ELSE_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   SWITCH_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   WHILE_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   FOR_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   END_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    |   COMPOUND_STMT {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen($1)+100,"<stmt>%s</stmt>",$1);
        free($1);
    }
    ;

EXPR_STMT
    :   EXPR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

IF_ELSE_STMT
    :   KEYWORD_IF PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR COMPOUND_STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    |   KEYWORD_IF PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR IF_COMPOUND_STMT KEYWORD_ELSE COMPOUND_STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        strcat($$,$6);
        strcat($$,$7);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
        free($6);
        free($7);
    }
    ;

IF_COMPOUND_STMT
    :   COMPOUND_STMT
    ;

SWITCH_STMT
    :   KEYWORD_SWITCH PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR SWITCH_BODY {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+100)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    ;

SWITCH_BODY
    :   PUNC_LEFT_BRA PUNC_RIGHT_BRA {
        $$ = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_LEFT_BRA SWITCH_CLAUSES PUNC_RIGHT_BRA {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

SWITCH_CLAUSES  
    :   SWITCH_CLAUSE_LIST
    ;

SWITCH_CLAUSE_LIST
    :   SWITCH_CLAUSE_LIST SWITCH_CLAUSE {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   SWITCH_CLAUSE
    ;

SWITCH_CLAUSE
    :   SWITCH_CLAUSE_W_STMT
    |   SWITCH_CLAUSE_WO_STMT
    ;

SWITCH_CLAUSE_W_STMT
    :   KEYWORD_CASE EXPR PUNC_COLON STMTS {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        free($1);
        free($2);
        free($3);
        free($4);
    }
    |   KEYWORD_DEFAULT PUNC_COLON STMTS {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

SWITCH_CLAUSE_WO_STMT
    :   KEYWORD_CASE EXPR PUNC_COLON {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   KEYWORD_DEFAULT PUNC_COLON {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;

WHILE_STMT
    :   DO_WHILE_STMT
    |   SOLE_WHILE_STMT
    ;

DO_WHILE_STMT
    :   KEYWORD_DO STMT KEYWORD_WHILE PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        strcat($$,$6);
        strcat($$,$7);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
        free($6);
        free($7);
    }

SOLE_WHILE_STMT
    :   KEYWORD_WHILE PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    ;

FOR_STMT
    :   KEYWORD_FOR FOR_INVOC STMT {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

FOR_INVOC
    :   FOR_INVOC_HEAD FOR_INVOC_MID FOR_INVOC_END {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

FOR_INVOC_HEAD
    :   PUNC_LEFT_PAR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_LEFT_PAR EXPR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

FOR_INVOC_MID
    :   EXPR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_SEMICOL
    ;

FOR_INVOC_END
    :   EXPR PUNC_RIGHT_PAR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_RIGHT_PAR
    ;

END_STMT
    :   KEYWORD_BREAK PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   KEYWORD_RETURN PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   KEYWORD_RETURN EXPR PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   KEYWORD_CONTI PUNC_SEMICOL {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    ;


COMPOUND_STMT
    :   PUNC_LEFT_BRA PUNC_RIGHT_BRA {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_LEFT_BRA COMPOUND_STMT_LIST PUNC_RIGHT_BRA {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

COMPOUND_STMT_LIST
    :   COMPOUND_STMT_LIST COMPOUND_ITEM {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   COMPOUND_ITEM
    ;

COMPOUND_ITEM
    :   DECLARATION
    |   STMT
    ;

EXPR
    :   ASSIGN_EXPR {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        sprintf($$,"%s",$1);
    }
    |   VAR {
        $$ = $1;
    }
    |   TOKEN_NULL {
        $$ = (char *)malloc(100*sizeof(char));
        sprintf($$,"<expr>%d</expr>",$1);
    }
    ;

ASSIGN_EXPR
    :   LOGIC_OR_EXPR 
    |   LOGIC_OR_EXPR OP_EQUAL ASSIGN_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

LOGIC_OR_EXPR
    :   LOGIC_AND_EXPR 
    |   LOGIC_OR_EXPR OP_LOGIC_OR LOGIC_AND_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

LOGIC_AND_EXPR
    :   BIT_OR_EXPR  
    |   LOGIC_AND_EXPR OP_LOGIC_AND BIT_OR_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

BIT_OR_EXPR
    :   BIT_XOR_EXPR
    |   BIT_OR_EXPR OP_BIT_OR BIT_XOR_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

BIT_XOR_EXPR
    :   BIT_AND_EXPR
    |   BIT_XOR_EXPR OP_BIT_XOR BIT_AND_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

BIT_AND_EXPR
    :   EQVAL_EXPR
    |   BIT_AND_EXPR OP_BIT_AND EQVAL_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

EQVAL_EXPR
    :   RELATE_EXPR
    |   EQVAL_EXPR OP_EQUIVALANCE RELATE_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   EQVAL_EXPR OP_NOT_EQUIVALANCE RELATE_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

RELATE_EXPR
    :   SHIFT_EXPR
    |   RELATE_EXPR OP_GE SHIFT_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   RELATE_EXPR OP_GT SHIFT_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   RELATE_EXPR OP_LE SHIFT_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   RELATE_EXPR OP_LT SHIFT_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

SHIFT_EXPR
    :   ADDSUB_EXPR 
    |   SHIFT_EXPR OP_SHIFT_L ADDSUB_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   SHIFT_EXPR OP_SHIFT_R ADDSUB_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

ADDSUB_EXPR
    :   MULDIV_EXPR
    |   ADDSUB_EXPR OP_ADD MULDIV_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   ADDSUB_EXPR OP_MINUS MULDIV_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

MULDIV_EXPR
    :   UNARY_EXPR
    |   MULDIV_EXPR OP_MUL UNARY_EXPR  {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   MULDIV_EXPR OP_DIVIDE UNARY_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    |   MULDIV_EXPR OP_PERCENT UNARY_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

UNARY_EXPR
    :   NORMAL_EXPR 
    |   UNARY_OPERS UNARY_EXPR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free(temp);
    }
    ;

UNARY_OPERS
    :   OP_ADD
    |   OP_MINUS
    |   OP_ADDONE
    |   OP_MINUSONE
    |   OP_MUL
    |   OP_LOGIC_NOT
    |   OP_BIT_NOT
    |   OP_BIT_AND
    |   TYPE_CASTING
    ;

TYPE_CASTING
    :   PUNC_LEFT_PAR TYPES PUNC_RIGHT_PAR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    |   PUNC_LEFT_PAR TYPES OP_MUL PUNC_RIGHT_PAR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        free($1);
        free($2);
        free($3);
        free($4);
    }
    ;

NORMAL_EXPR
    :   EXPR_TERM
    |   EXPR_TERM NORMAL_FUNC {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free(temp);
    }
    |   TOKEN_ID NORMAL_ARRAY {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free(temp);
    }
    |   NORMAL_EXPR OP_ADDONE {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free(temp);
    }
    |   NORMAL_EXPR OP_MINUSONE {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free(temp);
    }
    |   PUNC_LEFT_PAR EXPR PUNC_RIGHT_PAR {
        char *temp = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        temp[0] = '\0';
        strcpy(temp,$1);
        strcat(temp,$2);
        strcat(temp,$3);
        $$ = (char *)malloc((strlen(temp)+100)*sizeof(char));
        $$[0] = '\0';
        snprintf($$,strlen(temp)+100,"<expr>%s</expr>",temp);
        free($1);
        free($2);
        free($3);
        free(temp);
    }
    ;

NORMAL_FUNC
    :   PUNC_LEFT_PAR PUNC_RIGHT_PAR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   PUNC_LEFT_PAR NORMAL_FUNC_PARAMS PUNC_RIGHT_PAR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

NORMAL_FUNC_PARAMS
    :   EXPR PUNC_COMMA EXPR PUNC_COMMA EXPR {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,$4);
        strcat($$,$5);
        free($1);
        free($2);
        free($3);
        free($4);
        free($5);
    }
    ;

NORMAL_ARRAY
    :   PUNC_LEFT_BRAC PUNC_RIGHT_BRAC {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   NORMAL_ARRAY_DIMS
    ;

NORMAL_ARRAY_DIMS
    :   NORMAL_ARRAY_DIMS NORMAL_ARRAY_DIM {
        $$ = (char *)malloc((strlen($1)+strlen($2)+1)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        free($1);
        free($2);
    }
    |   NORMAL_ARRAY_DIM
    ;

NORMAL_ARRAY_DIM
    :   PUNC_LEFT_BRAC EXPR PUNC_RIGHT_BRAC {
        $$ = (char *)malloc((strlen($1)+strlen($2)+strlen($3)+10)*sizeof(char));
        $$[0] = '\0';
        strcpy($$,$1);
        strcat($$,$2);
        strcat($$,$3);
        free($1);
        free($2);
        free($3);
    }
    ;

EXPR_TERM
    :   TOKEN_INT {
        $$ = (char *)malloc(100*sizeof(char));
        $$[0] = '\0';
        sprintf($$,"<expr>%d</expr>",$1);
    }
    |   TOKEN_ID {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        sprintf($$,"<expr>%s</expr>",$1);
        free($1);
    }
    |   TOKEN_FLOAT {
        $$ = (char *)malloc(100*sizeof(char));
        $$[0] = '\0';
        sprintf($$,"<expr>%f</expr>",$1);
    }
    |   TOKEN_CHAR {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        sprintf($$,"<expr>%s</expr>",$1);
        free($1);
    }
    |   TOKEN_STR {
        $$ = (char *)malloc((strlen($1)+100)*sizeof(char));
        $$[0] = '\0';
        sprintf($$,"<expr>%s</expr>",$1);
        free($1);
    }

VAR
    :   SCALAR_DECLARATION
    |   ARRAY_DECLARATION
    ;




%%
int main(void) {
    yyparse();
    return 0;
}
int yyerror(char * msg);