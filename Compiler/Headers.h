#include <stdlib.h>
#include <string.h>
#include <stdio.h>
extern int yylineno;


struct symbols{
char name[45];
char  type[45];
double value; //double or int
//int scope;
}symbol;

struct variable{
char name[45];
int scope;
char type[45];
};

 
struct variable variables[50];


void insert(char name[], char type[]); //Add the variable to the variables list
char * lookup (char name[], int scope); // Returns type 
int isSameType(char type1[], char type2[]);// returns one when two variables are form the same type
int alreadyExist(char variable[], int scope); //returns one when the variable already exist in the variable list
void comparisonOpError(char type1[], char type2[]);
void conditionStatementError(char msg[], char type[]);
void declarationError(char name[]);
void assignmentError(char type1[], char type2[]);
void duplicateVariableError(char name[]);
