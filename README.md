# sudsolv

Solves a solvable sudoku or identifies an unsolvable one.
Implemenets constraint propagation, until possible, then searches with a guess that has the least options.

USAGE:

Run without compilation:
```
runhaskell ss.hs -f path_to_file
```

or compile for performance speedup
```
ghc -O2 ss.hs
./ss -f path_to_file
```

or use stdin 
```
cat puzzles | ./ss -i
```



The file expects following format for each puzzle
(0 represents empty square)
```
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
```

there are 2 example inputs, one is the files from project euler "p096_sudoku.txt"
and unsolvable has 2 sudoku grids which are unsolvable.
