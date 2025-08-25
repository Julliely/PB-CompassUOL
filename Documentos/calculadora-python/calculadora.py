class Calculadora:
    def adicao(self, a, b):
        return a + b

    def subtracao(self, a, b):
        return a - b

    def multiplicacao(self, a, b):
        return a * b

    def divisao(self, a, b):
        if b == 0:
            return "Erro: divisão por zero não é permitida."
        return a / b

    def porcentagem(self, valor, percentual):
        return (valor * percentual) / 100

    def potenciacao(self, base, expoente):
        resultado = 1
        if expoente < 0:
            for _ in range(-expoente):
                resultado *= base
            return 1 / resultado
        else:
            for _ in range(expoente):
                resultado *= base
            return resultado