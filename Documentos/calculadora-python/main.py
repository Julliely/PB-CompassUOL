from calculadora import Calculadora

calc = Calculadora()

while True:
    print("\n=== Calculadora ===")
    print("1 - Adição")
    print("2 - Subtração")
    print("3 - Multiplicação")
    print("4 - Divisão")
    print("5 - Porcentagem")
    print("6 - Potenciação")
    print("7 - Sair")

    try:
        opcao = int(input("Escolha a operação: "))
    except ValueError:
        print("Opção inválida. Digite um número de 1 a 7.")
        continue

    match opcao:
        case 1:
            a = float(input("Digite o primeiro número: "))
            b = float(input("Digite o segundo número: "))
            print("Resultado:", calc.adicao(a, b))

        case 2:
            a = float(input("Digite o primeiro número: "))
            b = float(input("Digite o segundo número: "))
            print("Resultado:", calc.subtracao(a, b))

        case 3:
            a = float(input("Digite o primeiro número: "))
            b = float(input("Digite o segundo número: "))
            print("Resultado:", calc.multiplicacao(a, b))

        case 4:
            a = float(input("Digite o primeiro número: "))
            b = float(input("Digite o segundo número: "))
            print("Resultado:", calc.divisao(a, b))

        case 5:
            valor = float(input("Digite o valor: "))
            percentual = float(input("Digite o percentual: "))
            print("Resultado:", calc.porcentagem(valor, percentual))

        case 6:
            base = float(input("Digite a base: "))
            expoente = int(input("Digite o expoente: "))
            print("Resultado:", calc.potenciacao(base, expoente))

        case 7:
            print("Saindo da calculadora...")
            break

        case _:
            print("Opção inválida. Tente novamente.")