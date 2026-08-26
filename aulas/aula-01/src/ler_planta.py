"""Leitura periódica das tags da planta TQ CE117 em unidade de engenharia.

Uso (a partir da pasta do script):
    python3 ler_planta.py           # lê uma vez
    python3 ler_planta.py 10 0.5    # 10 leituras a cada 0,5 s
"""

import sys
import time

from pycomm3 import LogixDriver

from conversoes import para_engenharia

PLC_IP = "200.200.200.25"

TAGS = [
    "Program:MainProgram.FT2_ADC",
    "Program:MainProgram.PT_ADC",
    "Program:MainProgram.TT5_ADC",
    "Program:MainProgram.LT_ADC",
]


def le_uma_vez(plc):
    for r in plc.read(*TAGS):
        if r.error:
            print(f"  {r.tag:38s} ERRO: {r.error}")
            continue
        volts, valor, unidade = para_engenharia(r.tag, r.value)
        print(f"  {r.tag:38s} = {r.value:6d} contas "
              f"= {volts:+6.3f} V = {valor:8.2f} {unidade}")


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    periodo = float(sys.argv[2]) if len(sys.argv) > 2 else 0.5

    with LogixDriver(PLC_IP) as plc:
        print("CLP:", plc.info.get("product_name"))
        for k in range(n):
            print(f"--- leitura {k + 1}/{n}  (t = {k * periodo:.1f} s)")
            le_uma_vez(plc)
            if k < n - 1:
                time.sleep(periodo)


if __name__ == "__main__":
    main()
