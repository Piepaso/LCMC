grammar FOOL;
 
@lexer::members {
public int lexicalErrors=0;
}
   
/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/
  
prog  : progbody EOF ;
     
progbody : LET dec+ IN exp SEMIC  #letInProg        /* dec+ = dec dec* */
         | exp SEMIC              #noDecProg
         ;
  
dec : VAR ID COLON type ASS exp SEMIC  #vardec
    | FUN ID COLON type LPAR (ID COLON type (COMMA ID COLON type)* )? RPAR (LET dec+ IN)? exp SEMIC   #fundec
    ;
           
exp     : exp TIMES exp #times
        | exp DIV exp   #div
        | exp PLUS  exp #plus
        | exp MINUS exp #minus
        | NOT exp #not
        | exp AND exp #and
        | exp OR exp #or
        | exp EQ  exp   #eq
        | exp LESSEQ exp #lesseq
        | exp GTSEQ exp #gtseq
        | LPAR exp RPAR #pars
    	| MINUS? NUM #integer
	    | TRUE #true     
	    | FALSE #false
	    | IF exp THEN CLPAR exp CRPAR ELSE CLPAR exp CRPAR  #if   
	    | PRINT LPAR exp RPAR #print
	    | ID #id
	    | ID LPAR (exp (COMMA exp)* )? RPAR #call
        ; 
             
type    : INT #intType
        | BOOL #boolType
 	    ;  
 	  		  
/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

PLUS  	: '+' ;
MINUS	: '-' ; 
TIMES   : '*' ;
DIV     : '/' ;
LPAR	: '(' ;
RPAR	: ')' ;
CLPAR	: '{' ;
CRPAR	: '}' ;
SEMIC 	: ';' ;
COLON   : ':' ; 
COMMA	: ',' ;
EQ	    : '==' ;
LESSEQ  : '<=' ;
GTSEQ   : '>=' ;
OR      : '||' ;
AND     : '&&' ;
NOT     : '!' ;
ASS	    : '=' ;
TRUE	: 'true' ;
FALSE	: 'false' ;
IF	    : 'if' ;
THEN	: 'then';
ELSE	: 'else' ;
PRINT	: 'print' ;
LET     : 'let' ;	
IN      : 'in' ;	
VAR     : 'var' ;
FUN	    : 'fun' ;	  
INT	    : 'int' ;
BOOL	: 'bool' ;
NUM     : '0' | ('1'..'9')('0'..'9')* ;

ID  	: ('a'..'z'|'A'..'Z')('a'..'z' | 'A'..'Z' | '0'..'9')* ;


WHITESP  : ( '\t' | ' ' | '\r' | '\n' )+    -> channel(HIDDEN) ;

COMMENT : '/*' .*? '*/' -> channel(HIDDEN) ;
 
ERR   	 : . { System.out.println("Invalid char "+getText()+" at line "+getLine()); lexicalErrors++; } -> channel(HIDDEN); 


