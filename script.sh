make
./aps < teste.jj
python3 postpro.py .intermediate.lua
python3 compilador/main.py .intermediate.lua
