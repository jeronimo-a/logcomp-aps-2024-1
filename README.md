# Lógica da Computação, 2024-1

## APS: Uma Linguagem de Programação

Jerônimo de Abreu Afrange

### Ideia:
Linguagem de programação que funciona com base no movimento de um elevador imaginário. Isso é feito a partir de dois valores principais: o andar no qual o elevador está e o andar no qual o programador está. Todo o IO que existe na linguagem são esses dois valores, sendo que para input, só é possível escolher o andar inicial do elevador.

O andar do elevador pode ser alterado o chamando de determinado andar, ou apertando os botões de dentro dele quando o programador estiver dentro. O andar do programador pode ser alterado pegando as escadas ou pegando o elevador. Ambos os valores podem ser apenas incrementados ou decrementados, e isso ocorre ao final de cada linha de instrução que esteja fora de um loop e de uma condicional. Para o programador entrar no elevador, ele tem que ter chamado o elevador e esperá-lo chegar.

A condição dos loops *while* é sempre a mesma: o elevador não estar no mesmo andar que o programador. A condição das cláuslas *if* também é sempre a mesma: estar no piso térreo (0). Variáveis são pombos, só podem ser capturados no telhado, portanto, o programador só pode definir varíaveis quando estiver no telhado, e ele só pode chegar lá pelas escadas.

No começo de cada arquivo de código, o programador deve especificar o número de andares do prédio desenhando uma ASCII art de um prédio cujo número de linhas que ela ocupa é a altura do prédio. O prédio deve ter, no mínimo, o andar dois andares contando com o térreo. O programador deve também fornecer uma entrada no começo, que é o andar inicial do elevador. O andar inicial do elevador também será especificado na ASCII art.

### EBNF:

```
roof         = "   _!_";
story        = "  |o o|";
ground_floor = "__|_#_|__";

INPUT = roof, "\n", story, ["$"], "\n", {story, ["$"], "\n"}, ground_floor, ["$"], "\n";

BLOCK = INPUT, {STATEMENT};

TABBED_STAT  = "\t", STATEMENT;

STATEMENT = {"\n"}, (ASSIGN_STAT | PRINT_STAT | WHILE_STAT | IF_STAT | DECLARE_STAT | CALL_STAT | ENTER_STAT | LEAVE_STAT | PUSH_STAT | UP_STAT | DOWN_STAT), "\n";

ASSIGN_STAT  = "pombo", ident, "agora", "is", B_EXPRESSION;
PRINT_STAT   = "where", ("estou" | "está"), "?", "?", "?";
WHILE_STAT   = "enquanto", "waiting", "elevador", "\n", {TABBED_STAT, "\n"};
IF_STAT      = "térreo", "?", "?", "?", "\n", {TABBED_STAT}; 
DECLARE_STAT = "grab", "pombo", ident, ["é", B_EXPRESSION];
CALL_STAT    = "call", "elevador";
ENTER_STAT   = "enter", "elevador";
LEAVE_STAT   = "leave", "elevador";
PUSH_STAT    = "push", "botão", "for", "o", story_number, "piso";
UP_STAT      = "subir", "stairs";
DOWN_STAT    = "descer", "stairs";

B_EXPRESSION = B_TERM, {"or", B_TERM};
B_TERM       = R_EXPRESSION, {"and", R_EXPRESSION};
R_EXPRESSION = EXPRESSION, {("==" | ">" | "<" | "!=" | ">=" | "<="), EXPRESSION};
EXPRESSION   = TERM, {("+" | "-" | ".."), TERM};
TERM         = FACTOR, {("/" | "*"), FACTOR};

FACTOR = num | str | ident | ("+" | "-" | "not", FACTOR) | ("(", B_EXPRESSION, ")") | ("where", ("estou", "está"));

story_number = ("ground" | num);

digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";

letter = "A" | "B" | "C" | "D" | "E" | "F" | "G"
       | "H" | "I" | "J" | "K" | "L" | "M" | "N"
       | "O" | "P" | "Q" | "R" | "S" | "T" | "U"
       | "V" | "W" | "X" | "Y" | "Z" | "a" | "b"
       | "c" | "d" | "e" | "f" | "g" | "h" | "i"
       | "j" | "k" | "l" | "m" | "n" | "o" | "p"
       | "q" | "r" | "s" | "t" | "u" | "v" | "w"
       | "x" | "y" | "z" ;

symbol = "[" | "]" | "{" | "}" | "(" | ")" | "<" | ">"
       | "'" | '"' | "=" | "|" | "." | "," | ";" | "-" 
       | "+" | "*" | "?" | "\n" | "\t" | "\r" | "\f" | "\b" ;

num   = digit, {digit};
ident = letter, {digit | letter | "_"};
str   = '"', {digit | letter | symbol}, '"';
```
