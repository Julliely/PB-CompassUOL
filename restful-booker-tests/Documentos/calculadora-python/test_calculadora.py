import pytest
from calculadora import Calculadora

calc = Calculadora()

# Testes para adição
def test_adicao():
    assert calc.adicao(2, 3) == 5
    assert calc.adicao(-1, 1) == 0
    assert calc.adicao(0, 0) == 0

# Testes para subtração
def test_subtracao():
    assert calc.subtracao(5, 3) == 2
    assert calc.subtracao(0, 3) == -3
    assert calc.subtracao(-2, -3) == 1

# Testes para multiplicação
def test_multiplicacao():
    assert calc.multiplicacao(2, 3) == 6
    assert calc.multiplicacao(-2, 3) == -6
    assert calc.multiplicacao(0, 100) == 0

# Testes para divisão
def test_divisao():
    assert calc.divisao(6, 3) == 2
    assert calc.divisao(-6, 2) == -3
    assert calc.divisao(5, 2) == 2.5
    assert calc.divisao(5, 0) == "Erro: divisão por zero não é permitida."

# Testes para porcentagem
def test_porcentagem():
    assert calc.porcentagem(200, 10) == 20
    assert calc.porcentagem(50, 50) == 25
    assert calc.porcentagem(100, 0) == 0

# Testes para potenciação
def test_potenciacao():
    assert calc.potenciacao(2, 3) == 8
    assert calc.potenciacao(5, 0) == 1
    assert calc.potenciacao(2, -2) == 0.25
    assert calc.potenciacao(-2, 3) == -8