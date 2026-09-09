"""Valida os kernels VRT embutidos em curva_de_nivel_algorithm.py.

GDAL rejeita um KernelFilteredSource cujo numero de coeficientes nao seja
Size*Size (ou Size, no caso separavel), quebrando so o nivel de suavizacao
afetado. Foi exatamente o que aconteceu com o kernel 13x13 do nivel "Alto".
"""
import os
import re

SRC = os.path.join(os.path.dirname(__file__), '..',
                   'curva_de_nivel_algorithm.py')


def test_kernels():
    src = open(SRC).read()
    found = re.findall(r'<Size>(\d+)</Size><Coefs>([^<]*)</Coefs>', src)
    assert len(found) == 4, f'esperados 4 kernels, achados {len(found)}'
    centro = {}
    for size, coefs in found:
        size = int(size)
        values = [float(v) for v in coefs.split()]
        assert len(values) == size * size, \
            f'kernel {size}x{size}: {len(values)} coefs, esperado {size*size}'
        assert abs(sum(values) - 1.0) < 1e-4, \
            f'kernel {size}x{size}: soma {sum(values)}'
        centro[size] = values[len(values) // 2]

    # Kernel maior tem de suavizar mais: coeficiente central menor.
    # Sem isso, "Alto" (13x13) vira uma copia de "Medio" (7x7).
    assert centro[13] < centro[7] < centro[3], \
        f'niveis de suavizacao nao progridem: {centro}'


if __name__ == '__main__':
    test_kernels()
    print('ok')
