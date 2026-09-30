#!/usr/bin/env python3
"""
Calculadora de medidas para una antena discono casera.

Uso:
  python3 calcular_discono.py              # 80 MHz (valor por defecto)
  python3 calcular_discono.py 50           # frecuencia mínima en MHz
  python3 calcular_discono.py 70 --angulo 30 --buje-cono 40 --buje-disco 50

Proporciones clásicas (Kandoian):
  varilla del cono  = λ/4 a la frecuencia mínima = 7500 / f (cm)
  diámetro del disco = 0,7 × diámetro de la boca del cono
  separación disco-cono = 0,3 × diámetro del buje del cono
Las medidas son de partida: compruébalas con un analizador (NanoVNA).
"""
import argparse
import math

ap = argparse.ArgumentParser(description="Medidas de una discono casera")
ap.add_argument("fmin", nargs="?", type=float, default=80.0, help="frecuencia mínima en MHz (defecto 80)")
ap.add_argument("--angulo", type=float, default=30.0, help="ángulo de cada varilla del cono respecto al eje (defecto 30°)")
ap.add_argument("--buje-cono", type=float, default=40.0, help="diámetro del buje del cono en mm (defecto 40)")
ap.add_argument("--buje-disco", type=float, default=50.0, help="diámetro del buje del disco en mm (defecto 50)")
ap.add_argument("--insercion", type=float, default=12.0, help="mm de varilla del cono que entran en el buje (defecto 12)")
ap.add_argument("--insercion-disco", type=float, default=15.0, help="mm de varilla del disco que entran en el buje (defecto 15)")
ap.add_argument("--varillas", type=int, default=8, help="varillas por elemento (defecto 8)")
a = ap.parse_args()

L = 7500.0 / a.fmin                                  # cm, varilla del cono
ang = math.radians(a.angulo)
boca = 2 * L * math.sin(ang)                          # cm
alto = L * math.cos(ang)                              # cm
disco = 0.7 * boca                                    # cm
rad_disco = disco / 2
libre_disco = rad_disco - a.buje_disco / 20           # cm fuera del buje
gap = 0.3 * a.buje_cono                               # mm
fmax_util = a.fmin * 12

print(f"\nDISCONO para frecuencia mínima {a.fmin:g} MHz  (cono de {2*a.angulo:g}°, {a.varillas}+{a.varillas} varillas)\n")
rows = [
    ("Varilla del cono (desde el vértice)", f"{L:.1f} cm"),
    ("  corte recomendado (+inserción, se recorta luego)", f"{L + a.insercion/10 + 0.5:.1f} cm"),
    ("Diámetro de la boca del cono", f"{boca:.1f} cm"),
    ("Altura del cono", f"{alto:.1f} cm"),
    ("Diámetro del disco", f"{disco:.1f} cm"),
    ("Varilla del disco (desde el centro)", f"{rad_disco:.1f} cm"),
    ("  corte con buje de %g mm" % a.buje_disco, f"{libre_disco + a.insercion_disco/10:.1f} cm ({libre_disco:.1f} libres)"),
    ("Separación disco-cono", f"{gap:.0f} mm"),
    ("Separación angular entre varillas", f"{360/a.varillas:g}°"),
    ("Varilla total necesaria", f"{a.varillas*(L + a.insercion/10 + 0.5 + libre_disco + a.insercion_disco/10)/100:.1f} m"),
    ("Rango útil aproximado", f"{a.fmin:g} – {fmax_util:.0f} MHz"),
]
w = max(len(r[0]) for r in rows)
for k, v in rows:
    print(f"  {k:<{w}}  {v}")
print()
