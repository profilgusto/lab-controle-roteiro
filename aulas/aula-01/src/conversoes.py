"""Conversões entre as contas do CLP e as grandezas físicas da planta TQ CE117.

Este módulo é importado pelos demais scripts da aula. O cartão A/D--D/A do
CompactLogix trabalha em contas: -32768 a +32767 contas correspondem a
-10,5 a +10,5 V.
"""

CONTAS_FUNDO = 32768      # contas correspondentes ao fundo de escala do cartão
VOLTS_FUNDO = 10.5        # fundo de escala do cartão A/D--D/A, em volts
CONTA_MAX = 32767         # 2**15 - 1: maior valor que cabe num INT do Logix
VOLTS_ATUADOR = 10.0      # tensão máxima aceita pelos atuadores da planta

# Ganho de cada instrumento, em unidade de engenharia por volt.
GANHO = {
    "Program:MainProgram.FT2_ADC": (1.0, "L/min"),
    "Program:MainProgram.TT5_ADC": (10.0, "°C"),
    "Program:MainProgram.PT_ADC": (100.0, "mbar"),
    "Program:MainProgram.LT_ADC": (10.0, "% do tanque"),
}


def conta_para_volts(conta):
    """Converte a conta lida do CLP na tensão presente na entrada do cartão."""
    return conta * VOLTS_FUNDO / CONTAS_FUNDO


def volts_para_conta(volts):
    """Converte uma tensão de comando na conta a ser escrita no CLP."""
    return int(round(volts * CONTAS_FUNDO / VOLTS_FUNDO))


def pct_para_conta(pct):
    """Converte o comando em porcentagem (0 a 100 %) na conta escrita no CLP.

    O comando é saturado antes da conversão: nenhum valor fora da faixa de
    0 a 10 V chega ao atuador, e a conta resultante nunca estoura o INT.
    """
    pct = max(0.0, min(100.0, float(pct)))
    conta = volts_para_conta(VOLTS_ATUADOR * pct / 100.0)
    return min(conta, CONTA_MAX)


def para_engenharia(tag, conta):
    """Devolve (tensão em volts, valor em unidade de engenharia, unidade)."""
    volts = conta_para_volts(conta)
    ganho, unidade = GANHO.get(tag, (1.0, "V"))
    return volts, volts * ganho, unidade
