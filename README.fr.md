# GostMiner

Mineur GPU multi-coins, libre et gratuit, pour cartes NVIDIA. **Sans frais de développeur.**

| Algorithme | Option | Coins |
|---|---|---|
| gostd (GOST R 34.11-2012 « Streebog », enchaîné) | `--algo gostd` (par défaut) | GOSTcoin (GST) |
| Lyra2REv2 | `--algo lyra2v2` | Bitmark (MARKS) et autres coins Lyra2REv2 |

- Cartes NVIDIA de Maxwell (GTX 900) à Blackwell (RTX 50), Windows 10/11 x64 et Linux x86-64 (glibc 2.34 ou plus).
- Minage en pool (stratum), et en solo sur un wallet GOSTcoin local (getwork).
- Chaque part trouvée par le GPU est revérifiée sur le CPU avant envoi ; les références CPU sont contrôlées sur de
  vrais blocs au démarrage.

English: [README.md](README.md).

## Téléchargement

Les binaires sont sur la page [Releases](https://github.com/gacanga/GostMiner/releases) (zip Windows, tar.gz Linux),
avec leur SHA-256. Les mêmes fichiers sont sur la page Téléchargements de la pool
[Crypto Connection](https://crypto-connection.net/#/downloads).

| Fichier | SHA-256 |
|---|---|
| GostMiner-v0.4.0-win64-cuda12.zip | `09f66040c2f79fc3d64997ddeb68699a49cef6dc7343dc327fde4b258ed45104` |
| GostMiner-v0.4.0-linux-x64-cuda12.tar.gz | `4241171b0d0461dc48ed6eb785191665fd1c62b17151afcd3c2a0b0d4a3e92dd` |

Vérifiez un fichier avant de le lancer : Windows (PowerShell) `Get-FileHash FICHIER -Algorithm SHA256`, Linux
`sha256sum FICHIER`.

## Démarrage rapide

Minage en pool, avec la pool Crypto Connection en exemple (frais de pool 1 %, ports : GOSTcoin 4033, Bitmark 4043) :

```
GOSTcoin, Windows :  gostminer.exe --pool crypto-connection.net:4033 --user VOTRE_ADRESSE_GST.rig1 --pass x
GOSTcoin, Linux :    ./gostminer --pool crypto-connection.net:4033 --user VOTRE_ADRESSE_GST.rig1 --pass x
Bitmark,  Windows :  gostminer.exe --algo lyra2v2 --pool crypto-connection.net:4043 --user VOTRE_ADRESSE_MARKS.rig1 --pass x
Bitmark,  Linux :    ./gostminer --algo lyra2v2 --pool crypto-connection.net:4043 --user VOTRE_ADRESSE_MARKS.rig1 --pass x
```

Toute pool stratum de ces coins fonctionne : changez l'hôte et le port. Les paquets contiennent aussi
`start_pool.bat` / `start_pool.sh` (GOSTcoin) et `start_bitmark.bat` / `start_bitmark.sh` (Bitmark) : mettez-y votre
adresse, l'hôte de la pool et son port (en v0.4.0 ils indiquent encore `pool.example.com`), puis lancez-les ; ils
relancent le mineur automatiquement. `test.bat` / `test.sh` testent chaque carte sur les deux algorithmes.

## Options

| Option | Rôle |
|---|---|
| `--algo A` | `gostd` (GOSTcoin, par défaut) ou `lyra2v2` (Bitmark) |
| `--pool HOTE:PORT --user ADRESSE.WORKER --pass x` | pool stratum ; `--pass d=64` demande une difficulté fixe à la pool si elle le permet |
| `--gpus 0,1,2` | cartes utilisées (par défaut : toutes) |
| `--kernel N` | gostd : variante de noyau forcée (par défaut, chaque carte mesure les 5 variantes 3 s et garde la plus rapide) |
| `--intensity N` | lyra2v2 : 2^N hashs par lancement (par défaut 22 jusqu'à 20 SM, 23-24 au-delà, limité par la mémoire de la carte) |
| `--stats S` | statistiques toutes les S secondes (30 par défaut) |
| `--log FICHIER` | écrit aussi le journal dans FICHIER |
| `--selftest` | teste chaque carte sur le hash de consensus du coin, puis quitte |
| `--bench S` | calcule S secondes sans pool |
| `--conf gostcoin.conf --port 8795` | solo sur un wallet GOSTcoin local (getwork, gostd) |

## Contrôles

Au démarrage, le mineur vérifie ses références CPU sur de vrais blocs : bloc genèse de GOSTcoin, identifiant d'une
coinbase et racine merkle ; hash du bloc Bitmark 2490869, sa preuve de travail lyra2rev2 et sa racine merkle. S'il
affiche `WRONG`, ne minez pas. L'autotest GPU lyra2v2 doit retrouver le nonce du bloc Bitmark 2490869.

## Erreurs CUDA et overclocking

Si une carte signale une erreur CUDA, le mineur écrit les derniers messages de la pool dans le journal et quitte avec
le code 3 ; les scripts de lancement le relancent après 5 s (un redémarrage propre est le moyen sûr de récupérer
une carte).

Le noyau gostd sollicite le cœur du GPU plus que les anciens mineurs gostd. Sur P104-100 / GTX 10xx, un overclock du
cœur (+100 ou +200 MHz) a provoqué des erreurs « illegal memory access » lors de nos essais ; avec le cœur
d'origine, aucune. Laissez le cœur d'origine (décalage mémoire et limite de puissance : sans problème) et baissez-le
si l'erreur apparaît.

Vitesse typique sur une P104-100 (classe GTX 1070) à 160 W, cœur d'origine : gostd 21-23 MH/s, lyra2v2 36-37 MH/s.

## Compilation

- Windows : CUDA 12.9 et Visual Studio 2022 (outils C++), puis `windows\build_miner.bat` (sortie `dev\gostminer.exe`).
- Linux : CUDA 12.9 (`CUDA_HOME`) et gcc / g++ 11 ou plus, puis `linux/build_linux.sh` (sortie `dev/gostminer-linux`).
- Code machine pour toutes les générations de GPU visées par CUDA 12.9 (sm_50 à sm_120) plus PTX ; `GM_ARCHS` permet
  d'en compiler moins, par exemple `GM_ARCHS=-arch=sm_61`.
- Les références C doivent être compilées avec `-fno-strict-aliasing` : Lyra2.c enfreint les règles d'aliasing du C
  et gcc -O2 calculerait sinon un lyra2rev2 faux (le contrôle au démarrage le détecte).

## Licence

GNU GPL v3 (`LICENSE`, `COPYING.txt`) : les noyaux GPU lyra2v2 viennent de ccminer 2.3.1. Le code tiers et ses
licences sont listés dans `NOTICE.txt`.
