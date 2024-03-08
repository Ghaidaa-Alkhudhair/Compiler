%{
#include "Phase2.h"
#include "Phase2.tab.h"
#include <stdio.h>
#include <string.h>
#include<stdlib.h>

extern int yylineno;
extern FILE* yyin;
extern int yyerror (char* msg);
extern char * yytext;
extern int yylex();
//extern struct symbols;

void insert(char name[], char type[]);
char * lookup(char name[], int scope);
int isSameType(char type1[], char type2[]);
int alreadyExist(char name[], int scope);
void comparisonOpError(char type1[], char type2[]);
void conditionStatementError(char msg[], char type[]);
void declarationError(char name[]);
void assignmentError(char type1[], char type2[]);
void duplicateVariableError(char name[]);


int variable_counter=0;
int scope = 1;
%}

%union {struct symbols s;}

%type <s> exp factor term type simple_exp assign_stmt comparison_op ;

%token <s> START END IF THEN ELSE IFEND READ WRITE REPEAT UNTIL
%token <s> INT DOUBLE
%token <s> INT_LITERAL STRING_LITERAL DBL_LITERAL ID
%token <s> ASSIGN PLUS MINUS MULT DIV EQ LT LE GT GE NE LPAREN RPAREN

%%
Program :START stmt_sequence END ;

stmt_sequence :statment ';' stmt_sequence
              | statment ';' ;

statment :dec_stmt
         | if_stmt
         | repeat_stmt
         | assign_stmt
         | read_stmt
         | write_stmt ;

dec_stmt :type ID
    {strcpy($2.type, $1.type);
            if(alreadyExist($2.name, scope))
            duplicateVariableError($2.name);
            else
            insert($2.name , $2.type);
                  } ;

    type :INT {strcpy($$.type, "int");}
    | DOUBLE {strcpy($$.type, "double");};


if_stmt :IF exp {if (alreadyExist($2.name, scope)) {
                 if ( ! isSameType($2.type, "boolean"))
                 conditionStatementError("In IF stmt, the expression should be boolean not", $2.type);}
                 else {declarationError($2.name);}} THEN stmt_sequence if_else_prime

if_else_prime : IFEND| ELSE stmt_sequence IFEND
    
repeat_stmt :REPEAT stmt_sequence UNTIL exp {if (alreadyExist($4.name, scope)) {
                                             if ( ! isSameType($4.type, "boolean"))
                                             conditionStatementError("In REPEAT, the expression should be boolean not", $4.type);}
                                             else {declarationError($4.name);}} ;

assign_stmt :ID ASSIGN exp {if(alreadyExist($1.name, scope)){
                            if ( ! isSameType(lookup($1.name , scope), $3.type) )
                            assignmentError(lookup($1.name , scope), $3.type);}
                            else {declarationError($1.name);}};

read_stmt :READ ID { if(!alreadyExist($2.name, scope)) declarationError($2.name); };

write_stmt :WRITE LPAREN exp RPAREN {if(!alreadyExist($3.name, scope)) declarationError($3.name);}
           | WRITE LPAREN STRING_LITERAL RPAREN;



    
exp :simple_exp comparison_op simple_exp {if(alreadyExist($1.name, scope)){
                                          if(alreadyExist($3.name, scope)){
                                          if(isSameType($1.type, $3.type)){
                                          strcpy($$.type, "boolean");
                                          }
                                          else{
                                          strcpy($$.type, "NA");
                                          comparisonOpError($1.type, $3.type);
                                          }
                                          }
                                          else
                                          declarationError($3.name);}
                                          else
                                          declarationError($1.name);}
    |simple_exp;
    
comparison_op :EQ
              |LT
              |LE
              |GT
              |GE
              |NE;

simple_exp  :simple_exp PLUS term {  if(alreadyExist($1.name, scope)){
                                     if(alreadyExist($3.name, scope)){
                                     if( isSameType(lookup($1.name , scope), "int") && isSameType(lookup($3.name , scope), "int")){
                                     strcpy( $$.type , "int");
                                     $$.value = $1.value + $3.value;}
                                     if(isSameType(lookup($1.name , scope), "double") || isSameType(lookup($3.name , scope), "double")){
                                     strcpy( $$.type , "double");
                                     $$.value = $1.value + $3.value;
                                     }}
                                     else{
                                         declarationError($3.name);
                                     }}
                                     else{
                                         declarationError($1.name);
                                     }
}
            |simple_exp MINUS term{  if(alreadyExist($1.name, scope)){
                                     if(alreadyExist($3.name, scope)){
                                     if( isSameType(lookup($1.name , scope), "int") && isSameType(lookup($3.name , scope), "int")){
                                     strcpy( $$.type , "int");
                                     $$.value = $1.value - $3.value;}
                                     if(isSameType(lookup($1.name , scope), "double") || isSameType(lookup($3.name , scope), "double")){
                                     strcpy( $$.type , "double");
                                     $$.value = $1.value - $3.value;
                                     }}
                                     else{
                                        declarationError($3.name);
                                     }}
                                     else{
                                        declarationError($1.name);
                                    }
                    }

            | term ;

term :term MULT factor {  if(alreadyExist($1.name, scope)){
                          if(alreadyExist($3.name, scope)){
                          if( isSameType(lookup($1.name , scope), "int") && isSameType(lookup($3.name , scope), "int")){
                          strcpy( $$.type , "int");
                          $$.value = $1.value * $3.value;}
                          if(isSameType(lookup($1.name , scope), "double") || isSameType(lookup($3.name , scope), "double")){
                          strcpy( $$.type , "double");
                          $$.value = $1.value * $3.value;
                          }}
                          else{
                          declarationError($3.name);
                          }}
                          else{
                          declarationError($1.name);
                          }
}
     | term DIV factor{  if(alreadyExist($1.name, scope)){
                         if(alreadyExist($3.name, scope)){
                         if( isSameType(lookup($1.name , scope), "int") && isSameType(lookup($3.name , scope), "int")){
                         strcpy( $$.type , "int");
                         $$.value = $1.value / $3.value;}
                         if(isSameType(lookup($1.name , scope), "double") || isSameType(lookup($3.name , scope), "double")){
                         strcpy( $$.type , "double");
                         $$.value = $1.value / $3.value;
                         }}
                         else{
                             declarationError($3.name);
                         }}
                         else{
                             declarationError($1.name);
                         }
                }
     | factor ;
    
factor : LPAREN exp RPAREN
       | INT_LITERAL { strcpy($$.type, "int");}
       | DBL_LITERAL { strcpy($$.type, "double");}
       | ID  { strcpy($$.type, lookup($1.name, scope));};

%%
int main (int argc, char *argv[])
{
        yyin=fopen(argv[1],"r");
        
    if(!yyparse())
    printf("\nParsing complete\n");
    else
    printf("\nParsing failed\n");
    
    fclose(yyin);
    return 0;
}

extern int yyerror(char* msg)
{
    printf("\n %s in line: %d %s \n", msg, (yylineno), yytext);
    return 0;
}
    
    
    void insert(char name[], char type[])
    {
        strcpy(variables[variable_counter].name, name);
        strcpy(variables[variable_counter].type, type);
        variables[variable_counter].scope = 1;
        variable_counter++;
    }


    char * lookup(char name[], int scope)
    {
        for(int i=0; i<variable_counter; i++)
            if(strcmp(variables[i].name, name) == 0 && variables[i].scope == scope)
                return variables[i].type;
        return "NA";
    }

    int isSameType(char type1[], char type2[])
    {
        if(strcmp(type1, type2) == 0)
            return 1;
        return 0;
    }

    int alreadyExist(char name[], int scope)
    {
        for(int i=0; i<variable_counter; i++)
            if(strcmp(variables[i].name, name) == 0 && variables[i].scope == scope)
                return 1;

        return 0;
    }


    void duplicateVariableError(char name[])
    {
        printf("Line :%d : varibale name '%s' is used before\n", yylineno, name);
    }
    
    void assignmentError(char type1[], char type2[])
    {
        printf("Line :%d : Incopmatible type: Assigning %s to %s\n", yylineno, type2, type1);
    }
    
    void declarationError(char name[])
    {
        printf("Line :%d : cannot find symbol \"%s\"\n", yylineno, name);
    }
    
    void conditionStatementError(char msg[], char type[])
    {
        printf("Line :%d : %s %s\n", yylineno, msg, type);
    }
    
    void comparisonOpError(char type1[], char type2[])
    {
        printf("Line :%d : Incompatible type: Comparison operator between %s and %s\n", yylineno, type1, type2);
    }
