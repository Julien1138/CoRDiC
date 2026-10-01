# CoRDiC

Implémentation VHDL générique de l'algorithme **CORDIC** (*COordinate Rotation DIgital Computer*) pour FPGA, avec deux blocs prêts à l'emploi :

- **`CoRDiC_PolarToRect`** : conversion polaire → rectangulaire (module, angle) → (X, Y) ;
- **`CoRDiC_RectToPolar`** : conversion rectangulaire → polaire (X, Y) → (module, angle).

Le cœur est itératif (une itération par cycle d'horloge), n'utilise que des additions, des soustractions et des décalages, et s'adapte à la largeur des bus qu'on lui connecte (ports `std_logic_vector` non contraints).

## Arborescence

```
.
├── Sources/                    Code VHDL synthétisable (bibliothèque CoRDiC_Lib)
│   ├── CoRDiC_Pack.vhd         Types (t_CordicState, t_CordicMode) et déclarations des composants
│   ├── CoRDiC.vhd              Cœur CORDIC itératif (modes Rotation / Vector)
│   ├── CoRDiC_Atan.vhd         Table des arctan(2^-i), 64 entrées sur 64 bits
│   ├── CoRDiC_ShiftN.vhd       Décaleur arithmétique combinatoire (>> N)
│   ├── CoRDiC_KFactorCorrection.vhd  Correction du gain K (multiplication par ≈ 0,60725)
│   ├── CoRDiC_PolarToRect.vhd  Bloc polaire → rectangulaire
│   └── CoRDiC_RectToPolar.vhd  Bloc rectangulaire → polaire
├── Test_Bench/                 Bancs de test (bibliothèque work)
├── ModelSim_Project/           Projet ModelSim (CoRDiC.mpf)
├── ISE_Project/                Projet Xilinx ISE 12.2 + wrapper de synthèse
└── Documentation/              Feuille de calcul CoRDiC.xlsx (calcul des constantes)
```

## Principe

À chaque itération `i`, le cœur applique une micro-rotation d'angle `±atan(2^-i)` :

```
X(i+1) = X(i) - d·Y(i)·2^-i
Y(i+1) = Y(i) + d·X(i)·2^-i
Z(i+1) = Z(i) - d·atan(2^-i)
```

Le sens `d` dépend du mode choisi par le générique `g_Mode` :

| Mode       | Critère sur `d`     | Résultat (à K près)                                        |
|------------|---------------------|------------------------------------------------------------|
| `Rotation` | signe de `Z`        | `X = X0·cos Z0 - Y0·sin Z0`, `Y = Y0·cos Z0 + X0·sin Z0`, `Z → 0` |
| `Vector`   | signe de `Y`        | `X = √(X0² + Y0²)`, `Y → 0`, `Z = Z0 + atan(Y0/X0)`        |

Les sorties `X` et `Y` du cœur sont multipliées par le gain CORDIC `K ≈ 1,64676`. Le bloc `CoRDiC_KFactorCorrection` compense ce gain en multipliant par `1/K ≈ 0,60725` (constante `0x4DBA76D421AF3D30`).

## Représentation des données

- **X, Y, module** : entiers signés en complément à 2.
- **Angles (Z)** : angle binaire signé sur toute la largeur du bus, où la pleine échelle correspond à un tour complet. Pour un bus de 16 bits :

  | Valeur   | Angle  |
  |----------|--------|
  | `0x2000` | 45°    |
  | `0x4000` | 90°    |
  | `0x7FFF` | ≈ 180° |
  | `0x8000` | -180°  |
  | `0xC000` | -90°   |

- **Précision interne** : les registres X, Y et Z du cœur ont une largeur double de celle des ports, pour limiter la perte de précision au fil des itérations.

## Blocs

### `CoRDiC` (cœur)

```vhdl
ins_CoRDiC : CoRDiC
   generic map ( g_Mode => Rotation )   -- ou Vector
   port map
   (
      clk_i => clk, rst_i => rst,
      Start_i => start, Done_o => done,
      X_i => x_in, Y_i => y_in, Z_i => z_in,
      X_o => x_out, Y_o => y_out, Z_o => z_out
   );
```

| Port      | Sens | Description                                      |
|-----------|------|--------------------------------------------------|
| `clk_i`   | in   | Horloge                                          |
| `rst_i`   | in   | Reset asynchrone, actif à '1'                    |
| `Start_i` | in   | Impulsion : charge X_i, Y_i, Z_i et lance le calcul |
| `Done_o`  | out  | Impulsion d'un cycle en fin de calcul            |
| `X_i`, `Y_i`, `Z_i` | in  | Conditions initiales                  |
| `X_o`, `Y_o`, `Z_o` | out | Résultats (non corrigés du gain K)    |

Le nombre d'itérations est égal à la largeur de `Z_i` : un bus d'angle de 16 bits donne 16 itérations, donc environ 16 cycles d'horloge par calcul.

Le cœur ne couvre que la moitié droite du cercle trigonométrique (angles dans ]-90°, 90°[). Les blocs de conversion ci-dessous ramènent les entrées dans ce domaine.

### `CoRDiC_PolarToRect`

Entrées `Magnitude_i`, `Angle_i` ; sorties `X_o`, `Y_o`, protocole `Start_i` / `Done_o`.

- Pré-traitement : si l'angle est hors de ]-90°, 90°[, on lui ajoute 180° (le bit de signe est remplacé par le bit suivant) et on prend l'opposé du module.
- Cœur en mode `Rotation`, avec `X0 = module`, `Y0 = 0` et `Z0 = angle`.
- Post-traitement : correction du gain K sur X et Y.

### `CoRDiC_RectToPolar`

Entrées `X_i`, `Y_i` ; sorties `Magnitude_o`, `Angle_o`, protocole `Start_i` / `Done_o`.

- Pré-traitement : si `X < 0`, on prend l'opposé de X et de Y et on mémorise qu'il faudra ajouter 180° au résultat.
- Cœur en mode `Vector`, avec `Z0 = 0`.
- Post-traitement : correction du gain K sur le module et, si nécessaire, inversion du MSB de l'angle (+180°).

## Contraintes d'utilisation

- Les vecteurs X, Y et Z d'entrée et de sortie d'un même cœur doivent avoir la même largeur que leurs homologues : `X_i` et `X_o`, `Y_i` et `Y_o`, `Z_i` et `Z_o` (aucune assertion ne le vérifie encore).
- La largeur de `Z` est limitée à 64 bits par la table d'arctangentes, et doit être une puissance de 2 (8, 16, 32…) pour que le compteur d'itérations soit bien dimensionné.
- La correction du gain K est limitée à 64 bits.
- Les fichiers de `Sources/` doivent être compilés dans une bibliothèque nommée **`CoRDiC_Lib`**.
- Le code utilise le paquetage non standard `ieee.std_logic_signed` (Synopsys).

## Simulation

### ModelSim

Ouvrir `ModelSim_Project/CoRDiC.mpf`, faire *Compile All*, puis simuler l'un des bancs de test de la bibliothèque `work`.

Pour compiler à la main, compiler d'abord le paquetage, puis les blocs de base, puis les blocs de haut niveau :

```tcl
vlib CoRDiC_Lib
vlib work
vcom -2002 -work CoRDiC_Lib Sources/CoRDiC_Pack.vhd
vcom -2002 -work CoRDiC_Lib Sources/CoRDiC_Atan.vhd Sources/CoRDiC_ShiftN.vhd Sources/CoRDiC_KFactorCorrection.vhd
vcom -2002 -work CoRDiC_Lib Sources/CoRDiC.vhd
vcom -2002 -work CoRDiC_Lib Sources/CoRDiC_PolarToRect.vhd Sources/CoRDiC_RectToPolar.vhd
vcom -2002 -work work Test_Bench/*.vhd
vsim work.CoRDiC_PolarToRect_tb
```

### Bancs de test

| Banc de test               | Ce qu'il exerce                                                    |
|----------------------------|--------------------------------------------------------------------|
| `CoRDiC_tb`                | Cœur en mode Rotation : X = 0x8000, Y = 0, Z = 0x2000 (45°)        |
| `CoRDiC_PolarToRect_tb`    | Module 0x01000000, angle 0x40000000 (90°), bus 32 bits             |
| `CoRDiC_RectToPolar_tb`    | X = -0x8000, Y = 0x8000 (point à 135°)                             |
| `CoRDiC_Atan_tb`           | Parcours des 16 premières entrées de la table d'arctangentes       |
| `CoRDiC_ShiftN_tb`         | Décalages successifs de 0 à 15 bits                                |

Ces bancs de test génèrent des stimuli mais ne contrôlent pas les résultats : il faut vérifier les chronogrammes à l'œil.

## Synthèse

Le projet `ISE_Project/CoRDiC.xise` (Xilinx ISE 12.2) cible un **Spartan-3E XC3S1200E-4FG320**. Le top-level `CoRDiC_Synthesis_Wrapper` fixe les largeurs des bus (X et Y sur 32 bits, Z sur 16 bits) et instancie le cœur en mode `Rotation`.

## Documentation

`Documentation/Feuille de calcul CoRDiC.xlsx` est la feuille de calcul utilisée pour obtenir les constantes (table des arctangentes, facteur K).

## Pistes d'amélioration

- Ajouter des assertions sur la cohérence des largeurs de bus (plusieurs `TODO` dans le code).
- Rendre les bancs de test auto-vérifiants.
- Migrer de `std_logic_signed` vers `numeric_std` seul.

## Auteur

Julien Aupart
