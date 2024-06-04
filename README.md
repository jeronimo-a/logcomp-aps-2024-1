# Lógica da Computação, 2024-1

## APS: Uma Linguagem de Programação

Jerônimo de Abreu Afrange

### Ideia:
Linguagem de programação que funciona com base no movimento de um elevador imaginário. Isso é feito a partir de dois valores principais: o andar no qual o elevador está e o andar no qual o programador está. Quanto aos *inputs*, só é possível escolher o andar inicial do elevador e a quantidade de andares do prédio. O programador sempre começa no térreo.

O andar do elevador pode ser alterado o chamando de determinado andar, ou apertando os botões de dentro dele quando o programador estiver dentro dele. O andar do programador pode ser alterado pegando as escadas ou pegando o elevador. Ambos os valores podem ser apenas incrementados ou decrementados, e isso ocorre ao final de cada linha de instrução que esteja fora de um loop e de uma condicional. Para o programador entrar no elevador, eles têm que estar no mesmo andar.

A condição dos loops *while* podem ser somente duas: o elevador não estar no mesmo andar que o programador, ou o elevador não estar no andar no qual ele deveria estar. A condição das cláuslas *if* é sempre a mesma: estar no piso térreo (0). Variáveis são pombos, só podem ser capturados no telhado, portanto, o programador só pode definir varíaveis quando estiver no telhado, e ele só pode chegar lá pelas escadas. Os pombos (variáveis) só podem mudar de valor no piso térreo.

No começo de cada arquivo de código, o programador deve especificar o número de andares do prédio desenhando uma ASCII *art* de um prédio cujo número de linhas que ela ocupa é a altura do prédio. O prédio deve ter, no mínimo, dois andares contando com o térreo. O programador deve também fornecer uma entrada no começo, que é o andar inicial do elevador, com o marcador `$` no andar em questão.

### EBNF:
`language.ebnf`

### Utilização:
1. Fornecer o código fonte JJ para o analisador léxico e sintático:
`./analyzer < sample_code.jj`
2. Rodar o *script* de pós processamento e interpretação:
`./script`

A `Makefile` também está disponível

### Exemplos:
1. `exemplo1.jj` potencialização de números inteiros
2. `exemplo2.jj` 