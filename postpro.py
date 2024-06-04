import sys

SIGNAL = "### SIGNAL ###"

def main():
    source = sys.argv[1]
    with open(source, "r") as file:
        text = file.read().split("\n")

    new_text = str()

    # remove linhas em branco
    in_header = True
    for line in text:
        if line == "": continue
        if line == SIGNAL:
            in_header = False
            continue
        new_text += line + "\n"
        if not in_header: new_text += "MoveElevator()\n"

    # escreve no arquivo de entrada
    with open(source, "w") as file:
        file.write(new_text)

if __name__ == "__main__":
    main()