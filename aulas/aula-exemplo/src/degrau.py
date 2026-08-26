"""Ensaio ao degrau: identificação de um modelo de primeira ordem com atraso."""

import numpy as np


def modelo_foptd(t, K, tau, theta):
    """Resposta ao degrau unitário de K*exp(-theta*s)/(tau*s + 1)."""
    y = np.zeros_like(t)
    depois = t >= theta
    y[depois] = K * (1.0 - np.exp(-(t[depois] - theta) / tau))
    return y


def identifica(t, y, degrau=1.0):
    """Método dos dois pontos (Smith): 28,3 % e 63,2 % do valor final."""
    K = (y[-1] - y[0]) / degrau
    t1 = np.interp(0.283 * y[-1], y, t)
    t2 = np.interp(0.632 * y[-1], y, t)
    tau = 1.5 * (t2 - t1)
    theta = t2 - tau
    return K, tau, theta


if __name__ == "__main__":
    t = np.linspace(0, 20, 400)
    y = modelo_foptd(t, K=2.0, tau=3.0, theta=1.5)
    print("K = %.2f, tau = %.2f s, theta = %.2f s" % identifica(t, y))
