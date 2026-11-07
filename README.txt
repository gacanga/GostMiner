GostMiner 0.4.0 - multi-coin GPU miner for NVIDIA. No dev fee.
  --algo gostd   (default)  GOSTcoin (GST)
  --algo lyra2v2            Bitmark (MARKS) and other Lyra2REv2 coins

NVIDIA GPUs from Maxwell (GTX 900) to Blackwell (RTX 50), Windows 10/11 x64 and Linux x86-64 (glibc 2.34+).
Driver: a recent NVIDIA driver (CUDA 12.9 support for the newest cards; any 525+ driver for Pascal/Turing/Ampere/Ada).

Pool mining (stratum):
  GOSTcoin, Windows: gostminer.exe --pool HOST:PORT --user YOUR_GST_ADDRESS.rig1 --pass x
  GOSTcoin, Linux:   ./gostminer --pool HOST:PORT --user YOUR_GST_ADDRESS.rig1 --pass x
  Bitmark,  Windows: gostminer.exe --algo lyra2v2 --pool HOST:PORT --user YOUR_MARKS_ADDRESS.rig1 --pass x
  Bitmark,  Linux:   ./gostminer --algo lyra2v2 --pool HOST:PORT --user YOUR_MARKS_ADDRESS.rig1 --pass x
  or edit and run start_pool.bat / start_pool.sh (GOSTcoin) or start_bitmark.bat / start_bitmark.sh (Bitmark):
  they restart the miner automatically.

Options:
  --algo A         gostd (GOSTcoin, default) or lyra2v2 (Bitmark)
  --gpus 0,1,2     GPUs to use (default: all)
  --kernel N       gostd: force a kernel variant (default: each GPU measures the 5 variants for 3 s, keeps the fastest)
  --intensity N    lyra2v2: 2^N hashes per launch (default 22 on GPUs up to 20 SM, 23-24 on larger ones,
                   limited by the GPU memory)
  --stats S        statistics every S seconds (default 30)
  --log FILE       also write the log to FILE
  --selftest       check every GPU against the coin's consensus hash and exit (test.bat / test.sh check both)
  --bench S        hash for S seconds without a pool
  Solo on a local GOSTcoin wallet (getwork, gostd): --conf gostcoin.conf --port 8795

Checks: at start-up the miner checks its CPU references against real blocks (GOSTcoin: genesis block, a coinbase
transaction id and a merkle root; Bitmark: block 2490869 hash, its lyra2rev2 proof of work and merkle root). If it
prints WRONG, do not mine. The lyra2v2 GPU self test must find the nonce of Bitmark block 2490869. Every GPU result
is checked again on the CPU before it is sent.

CUDA errors: if a GPU reports a CUDA error, the miner writes the last pool messages to the log and exits with
code 3; the start scripts restart it after 5 s (a clean restart is the safe way to recover a GPU).

Overclocking (gostd): this kernel loads the GPU core harder than older gostd miners. On P104-100 / GTX 10xx cards a
core overclock (+100 or +200 MHz) caused "illegal memory access" errors in our tests; with the core at stock clock
there was none. Keep the core at stock (a memory offset is fine) and lower it if the error appears.

Typical speed on a P104-100 (GTX 1070 class) at 160 W, core at stock: gostd 21-23 MH/s, lyra2v2 36-37 MH/s.

Licence: GNU GPL v3 (the lyra2v2 kernels come from ccminer), see NOTICE.txt and COPYING.txt. Source code:
GostMiner-v0.4.0-src.tar.gz.
