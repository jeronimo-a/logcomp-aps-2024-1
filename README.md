# Lógica da Computação, 2024-1

## APS: Uma Linguagem de Programação

Jerônimo de Abreu Afrange

### Ideia:
Linguagem de programação que funciona com base no movimento de um elevador imaginário. Isso é feito a partir de dois valores principais: o andar no qual o elevador está e o andar no qual o programador está. Todo o IO que existe na linguagem são esses dois valores, sendo que para *input*, só é possível escolher o andar inicial do elevador e a quantidade de andares do prédio. O programador sempre começa no térreo.

<font color="red"> Para o *output* ser minimamente legível, foi incluida também uma instrução de *print* que imprime qualquer valor. Nos arquivos exemplo, no entanto, essa instrução será usada somente para facilitar a compreensão do leitor. </font>

O andar do elevador pode ser alterado o chamando de determinado andar, ou apertando os botões de dentro dele quando o programador estiver dentro dele. O andar do programador pode ser alterado pegando as escadas ou pegando o elevador. Ambos os valores podem ser apenas incrementados ou decrementados, e isso ocorre ao final de cada linha de instrução que esteja fora de um loop e de uma condicional. Para o programador entrar no elevador, ele tem que ter chamado o elevador e esperá-lo chegar.

A condição dos loops *while* podem ser somente duas: o elevador não estar no mesmo andar que o programador, ou o elevador não estar no andar no qual ele deveria estar. A condição das cláuslas *if* é sempre a mesma: estar no piso térreo (0). Variáveis são pombos, só podem ser capturados no telhado, portanto, o programador só pode definir varíaveis quando estiver no telhado, e ele só pode chegar lá pelas escadas.

No começo de cada arquivo de código, o programador deve especificar o número de andares do prédio desenhando uma ASCII *art* de um prédio cujo número de linhas que ela ocupa é a altura do prédio. O prédio deve ter, no mínimo, dois andares contando com o térreo. O programador deve também fornecer uma entrada no começo, que é o andar inicial do elevador.

### EBNF:
`language.ebnf`