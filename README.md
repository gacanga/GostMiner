# GostMiner

Free, open-source multi-coin GPU miner for NVIDIA cards. **No dev fee.**

| Algorithm | Option | Coins |
|---|---|---|
| gostd (GOST R 34.11-2012 "Streebog", chained) | `--algo gostd` (default) | GOSTcoin (GST) |
| Lyra2REv2 | `--algo lyra2v2` | Bitmark (MARKS) and other Lyra2REv2 coins |

- NVIDIA GPUs from Maxwell (GTX 900) to Blackwell (RTX 50), Windows 10/11 x64 and Linux x86-64 (glibc 2.34+).
- Stratum pool mining, and solo mining on a local GOSTcoin wallet (getwork).
- Every share found on the GPU is checked again on the CPU before it is sent; the CPU references are checked against
  real blocks at start-up.

Français : [README.fr.md](README.fr.md).

## Download

Binaries are on the [Releases](https://github.com/gacanga/GostMiner/releases) page (Windows zip, Linux tar.gz),
with their SHA-256. The same files are on the downloads page of the
[Crypto Connection](https://crypto-connection.net/#/downloads) pool.

| File | SHA-256 |
|---|---|
| GostMiner-v0.4.0-win64-cuda12.zip | `09f66040c2f79fc3d64997ddeb68699a49cef6dc7343dc327fde4b258ed45104` |
| GostMiner-v0.4.0-linux-x64-cuda12.tar.gz | `4241171b0d0461dc48ed6eb785191665fd1c62b17151afcd3c2a0b0d4a3e92dd` |

Check a file before you run it: Windows (PowerShell) `Get-FileHash FILE -Algorithm SHA256`, Linux `sha256sum FILE`.

## Quick start

Pool mining, with the Crypto Connection pool as an example (1 % pool fee, ports: GOSTcoin 4033, Bitmark 4043):

```
GOSTcoin, Windows:  gostminer.exe --pool crypto-connection.net:4033 --user YOUR_GST_ADDRESS.rig1 --pass x
GOSTcoin, Linux:    ./gostminer --pool crypto-connection.net:4033 --user YOUR_GST_ADDRESS.rig1 --pass x
Bitmark,  Windows:  gostminer.exe --algo lyra2v2 --pool crypto-connection.net:4043 --user YOUR_MARKS_ADDRESS.rig1 --pass x
Bitmark,  Linux:    ./gostminer --algo lyra2v2 --pool crypto-connection.net:4043 --user YOUR_MARKS_ADDRESS.rig1 --pass x
```

Any stratum pool of these coins works: replace the host and the port. The packages also contain
`start_pool.bat` / `start_pool.sh` (GOSTcoin) and `start_bitmark.bat` / `start_bitmark.sh` (Bitmark): put your
address, the pool host and its port in them (in v0.4.0 they still say `pool.example.com`), then run them; they
restart the miner automatically. `test.bat` / `test.sh` check every GPU against both algorithms.

## Options

| Option | Meaning |
|---|---|
| `--algo A` | `gostd` (GOSTcoin, default) or `lyra2v2` (Bitmark) |
| `--pool HOST:PORT --user ADDRESS.WORKER --pass x` | stratum pool; `--pass d=64` asks the pool for a fixed difficulty if it supports it |
| `--gpus 0,1,2` | GPUs to use (default: all) |
| `--kernel N` | gostd: force a kernel variant (default: each GPU measures the 5 variants for 3 s and keeps the fastest) |
| `--intensity N` | lyra2v2: 2^N hashes per launch (default 22 on GPUs up to 20 SM, 23-24 on larger ones, limited by the GPU memory) |
| `--stats S` | statistics every S seconds (default 30) |
| `--log FILE` | also write the log to FILE |
| `--selftest` | check every GPU against the coin's consensus hash and exit |
| `--bench S` | hash for S seconds without a pool |
| `--conf gostcoin.conf --port 8795` | solo on a local GOSTcoin wallet (getwork, gostd) |

## Checks

At start-up the miner checks its CPU references against real blocks: GOSTcoin genesis block, a coinbase transaction id
and a merkle root; Bitmark block 2490869 hash, its lyra2rev2 proof of work and merkle root. If it prints `WRONG`, do
not mine. The lyra2v2 GPU self test must find the nonce of Bitmark block 2490869.

## CUDA errors and overclocking

If a GPU reports a CUDA error, the miner writes the last pool messages to the log and exits with code 3; the start
scripts restart it after 5 s (a clean restart is the safe way to recover a GPU).

The gostd kernel loads the GPU core harder than older gostd miners. On P104-100 / GTX 10xx cards a core overclock
(+100 or +200 MHz) caused "illegal memory access" errors in our tests; with the core at stock clock there was none.
Keep the core at stock (a memory offset and a power limit are fine) and lower it if the error appears.

Typical speed on a P104-100 (GTX 1070 class) at 160 W, core at stock: gostd 21-23 MH/s, lyra2v2 36-37 MH/s.

## Build

- Windows: CUDA 12.9 and Visual Studio 2022 (C++ tools), then `windows\build_miner.bat` (output `dev\gostminer.exe`).
- Linux: CUDA 12.9 (`CUDA_HOME`) and gcc / g++ 11 or later, then `linux/build_linux.sh` (output `dev/gostminer-linux`).
- Machine code for every GPU generation CUDA 12.9 targets (sm_50 to sm_120) plus PTX; set `GM_ARCHS` to build fewer,
  e.g. `GM_ARCHS=-arch=sm_61`.
- The C references must be built with `-fno-strict-aliasing`: Lyra2.c breaks the C aliasing rules and gcc -O2 would
  otherwise compute a wrong lyra2rev2 (the start-up check catches it).

## Licence

GNU GPL v3 (`LICENSE`, `COPYING.txt`): the lyra2v2 GPU kernels come from ccminer 2.3.1. Third-party code and its
licences are listed in `NOTICE.txt`.
