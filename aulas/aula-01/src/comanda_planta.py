"""Comando da válvula S e da bomba PUMP2 da planta TQ CE117, em porcentagem.

O intertravamento de segurança é feito aqui, no supervisório: a bomba só é
acionada se a válvula proporcional estiver totalmente aberta. O CLP não
implementa essa proteção.

Uso (a partir da pasta do script):
    python3 comanda_planta.py <VALVE_%> <PUMP2_%>
    python3 comanda_planta.py 100 25
"""

import sys

from pycomm3 import LogixDriver

from conversoes import pct_para_conta

PLC_IP = "200.200.200.25"

TAG_VALVE = "Program:MainProgram.VALVE_DAC"
TAG_PUMP2 = "Program:MainProgram.PUMP2_DAC"

VALVE_MIN_PARA_BOMBA = 100.0   # abertura mínima da válvula para liberar PUMP2


def main():
    if len(sys.argv) != 3:
        sys.exit(f"Uso: {sys.argv[0]} <VALVE_%> <PUMP2_%>")

    valve_pct = float(sys.argv[1])
    pump2_pct = float(sys.argv[2])

    if pump2_pct > 0 and valve_pct < VALVE_MIN_PARA_BOMBA:
        sys.exit(f"ERRO: PUMP2 = {pump2_pct:.0f} % com a válvula em "
                 f"{valve_pct:.0f} %. Abra a válvula em "
                 f"{VALVE_MIN_PARA_BOMBA:.0f} % antes de acionar a bomba.")

    valve = pct_para_conta(valve_pct)
    pump2 = pct_para_conta(pump2_pct)

    with LogixDriver(PLC_IP) as plc:
        print(f"Conectado em {PLC_IP} ({plc.info.get('product_name')})")
        print(f"Escrevendo VALVE_DAC = {valve} ({valve_pct:.0f} %) | "
              f"PUMP2_DAC = {pump2} ({pump2_pct:.0f} %)")
        for r in plc.write((TAG_VALVE, valve), (TAG_PUMP2, pump2)):
            if r.error:
                sys.exit(f"ERRO ao escrever em {r.tag}: {r.error}")
        print("Escrita confirmada pelo CLP.")


if __name__ == "__main__":
    main()
