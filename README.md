Usage :

```
$ ghc Master
$ ./Master
```

Example Output:

```
 1.	honesty
 2.	alternate
 3.	betrayal
 4.	TfT

3.0000 | 1.5000 | 0.0000 | 3.0000 | 1.8750 |
4.0000 | 2.0000 | 0.5000 | 2.5150 | 2.2538 |
5.0000 | 3.0000 | 1.0000 | 1.0200 | 2.5050 |
3.0000 | 2.4900 | 0.9950 | 3.0000 | 2.3712 |
```

This shows that the program `honesty` scores 3, 1.5, 0, 3, 1.875 when it plays the game
with itself, `alternate`, `betrayal`, and `TfT`, respectively. Etc.

CAUTION : Executing the `Master` will execute *any* executables in the `./players/` directory.
This is a terrible vulnerability. I know.
