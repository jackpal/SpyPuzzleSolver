# SpyPuzzleSolver

A solver for Spy Puzzle game levels.

Uses an A-Star search algorithm. Can quickly solve many simple levels.

# Limitations

- Single threaded.
- If run multiple times on the same level, may produce different equivalent solutions.
  - This is probably due to the use of a Swift set in the A* implementation. Swift
    sets are intentionally designed to iterate their contents in random order.
  - This can probably be fixed by biasing the A* path length estimates.
- Does not do long range planning.
- Levels with important items hidden behind doors will take a long time to solve.

# Dependencies

- [A-Star](https://github.com/Dev1an/A-Star) A Swift A-Star graph search algorithm.
- [SpyPuzzleGameState](https://github.com/jackpal/SpyPuzzleGameState) The game state and rules for the
Spy Puzzle game.

# Dependents

[SpyPuzzleApp](https://github.com/jackpal/SpyPuzzleApp) is an iOS App that uses this solver. 
[SpyPuzzleCLI](https://github.com/jackpal/SpyPuzzleCLI) is a command-line-tool that uses this solver. 
