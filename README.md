# Q-Less Clues

An app to help you learn and improve at the dice game, Q-Less

## How It Works

There are 3 components to the Q-Less Clues Solver:

1. [Word selection](#word-selection)
1. [Backtracking solver](#backtracking-solver)
1. [Validation](#validation)

### Word Selection

Q-Less Clues relies on the [NASPA Word List](https://www.scrabbleplayers.org/w/NASPA_Word_List), the "official word reference for SCRABBLE play in the United States and Canada", as of writing, September 9, 2022. It starts with this list, then, using the letters rolled by the player, filters down to only those words which are spellable with the resulting letters. This tends to be somewhere from 400-800 words on average (by manual testing, so not robust).

Next, Q-Less Clues uses the [Google Web Trillion Word Corpus](https://ai.googleblog.com/2006/08/all-our-n-gram-are-belong-to-you.html) to optionally filter the words used in its solver down to only those most recognizable. Currently, the default is to limit words to those appearing in the top 10,000. This often results in 50-200 usable words.

### Backtracking Solver

Q-Less Clues uses a backtracking algorithm to discover solutions for a single game. Most of the code can be found in [BacktrackingSolver.swift](/QLessCluesApp/Source/Services/Solver/BacktrackingSolver.swift).

For the first word, it finds the least frequent letter among the available words, and attempts to start the game with only those words. This reduces the overall time complexity, since we'll definitely need to use that letter in our solution, and we would rather not solve most of the board only to be left with that single letter at the end of the game, with nowhere to place it. By consuming it first, we avoid a lot of extra wasted searches.

The backtracking algorithm works as follows:

1. Collect the remaining letters in a set, called A
1. If we have no letters remaining, we've found a solution
   - Return the solution, remove the most recently added word and return its letters to A, then backtrack
1. Place the chosen starting word, called B, on the board
1. From the set A, remove the letters found in B
1. Iterate over each row and column in the board:
   - Assume we have the letters p, q in our current row or column
   - For each letter in our current row or column, generated Regexes of the form:
     - `[A]*p[A]*`
     - `[A]*p[A]*q[A*]`
     - `[A]*q[A]*`
1. Find all words among our available words that match any of the Regexes
   - If there are no words available, remove the most recently added word and return its letters to A, then backtrack
1. For each word, return to step 2 and repeat

### Validation

Once the solver has found a "solution" we need to validate it's actually valid by the rules of the game:

- All the words in the solution are connected
- All words are at least 3 letters long
- Words are made up only of the letters initially rolled
- There are only 12 letters used

Often, the backtracking algorithm will place a word on the board along a row or column where it makes a valid word and connection with another word, but it will be adjacent to an unrelated word on the neighbouring row or column, creating invalid 2 letter words. The backtracking algorithm doesn't look for these, it leaves it up to the validator to later filter these solutions out.

The validator does so by looking for all connected letters in each row or column and checking if they create valid words in our initial corpus. If all the letters do, then the word is considered valid and shown to the user

## Screenshots

| Solution Viewer                                                          | Solutions List                                                        | Data Entry                               |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------- | ---------------------------------------- |
| ![Tile grid of a single solution for a Q-Less game](/media/Solution.png) | ![List of possible solutions for a Q-Less game](/media/Solutions.png) | ![Letter entry form](/media/NewPlay.png) |

## Contributing

### Requirements

- Swift 5.7+
- SwiftLint
- Xcode 14+

### Steps

1. Fork and clone this repo
1. Write your changes
1. Run `swiftlint` for styling conformance
   - It should automatically run as you work in the Xcode project
1. Open a PR with your changes
