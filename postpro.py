import sys

SIGNAL = "### SIGNAL ###"
SKIP_MOVE_SIGNAL = "### SKIP MOVE ###"

def main():
    source = sys.argv[1]
    with open(source, "r") as file:
        text = file.read().split("\n")

    new_text = str()
    scope_stack = list()

    # remove linhas em branco
    in_header = True
    for line in text:

        # flag de já inclusão de um MoveElevator
        added = False

        # se a linha for vazia, ignora
        if line == "": continue

        # verifica se é o signal
        if line == SIGNAL:
            in_header = False
            continue

        # se ainda não chegou no signal, reinicia o loop
        if in_header:
            new_text += line + "\n"
            continue

        # flags de abertura e fechamento de escopo
        is_while = "while" in line
        is_end = "end" in line
        is_if = "if" in line

        # se for abertura de escopo, faz um push na stack de escopos
        if is_while or is_if:
            scope_stack.append(1)

        # se for fechamento de escopo, faz um pop na stack de escopos e adiciona um MoveElevator()
        if is_end:
            scope_stack.pop()
            if SKIP_MOVE_SIGNAL not in line: new_text += "MoveElevator()\n"
            else: line = line.replace(SKIP_MOVE_SIGNAL, "")
            added = True

        # adiciona a linha ao programa atualizado
        new_text += line + "\n"

        # adiciona um move elevator se ainda não tiver sido adicionado nesta iteração e a stack estiver vazia
        if len(scope_stack) == 0 and not added:
            new_text += "MoveElevator()\n"
            added = True

    # escreve no arquivo de entrada
    with open(source, "w") as file:
        file.write(new_text)

if __name__ == "__main__":
    main()