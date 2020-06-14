# sudsolv

Solves a solvable sudoku or identifies an unsolvable one.

without compilation you can do:
# Usage: runhaskell ss.hs -f path_to_file

or compile with ghc --make ss.hs
# Usage ./ss -f path_to_file



where the file expects following format for each puzzle

Grid 1
000000000
000000000
000000000
000000000
000000000
000000000
000000000
000000000
000000000
Grid 2
123456789
000000000
000000000
000000000
000000000
000000000
000000000
000000000
000000000
.
.
.

there are 2 example inputs, one is the files from project euler "p096_sudoku.txt"
and unsolvable has 2 sudoku grids which are unsolvable.





