# Antena discono casera 80–1300 MHz

Construye una discono de banda ancha para escáner o SDR por unos 25–40 €, con varilla de aluminio, dos bujes torneados y piezas imprimibles en 3D.

![Medidas](img/discono_medidas.svg)

| | |
|---|---|
| Cobertura | 80 a más de 1000 MHz (FM, aviación, marina, AIS, DAB+, UHF) |
| Polarización | Vertical, omnidireccional, 0–2 dBi |
| Tamaño | Cono Ø94 cm × 81 cm, disco Ø66 cm |
| Materiales | ≈10 m de varilla Ø4 mm, barra de aluminio Ø40 y Ø50, conector N |
| Nivel | Bricolaje básico, una tarde |

## Contenido

```
GUIA.md               Guía completa: medidas, materiales, paso a paso, ajuste e instalación
calcular_discono.py   Calculadora de medidas para cualquier frecuencia mínima
3d/
  discono_3d.scad     Piezas paramétricas (OpenSCAD)
  stl/                9 piezas listas para imprimir
  LEEME.txt           Material, orientación y uso de cada pieza
img/                  Dibujo acotado y vista de las piezas
```

## Empezar

1. Lee la [guía](GUIA.md).
2. ¿Otra frecuencia mínima? `python3 calcular_discono.py 50`
3. Imprime las piezas de [`3d/stl`](3d/stl) en PETG o ASA; para otras medidas edita los parámetros de `discono_3d.scad` y exporta con OpenSCAD:
   ```bash
   openscad -D 'PART="spacer"' -o spacer.stl 3d/discono_3d.scad
   ```

## Aviso

Las medidas se basan en las proporciones clásicas de la discono y son un punto de partida: compruébalas con un analizador (NanoVNA) antes de instalarla. Instala siempre descargador y toma de tierra.

## Comunidad

Proyecto compartido en [BricoHams · Radioafición, hazlo tú mismo](https://t.me/bricohams). Mejoras, fotos de montajes y medidas reales son bienvenidas mediante issues o pull requests.
