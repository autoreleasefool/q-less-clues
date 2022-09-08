from collections import Counter
from os import path

# Manually verified max # of times a letter can appear
max_letter_counts = {
	'A': 2,
	'B': 3,
	'C': 2,
	'D': 3,
	'E': 2,
	'F': 2,
	'G': 2,
	'H': 2,
	'I': 2,
	'J': 1,
	'K': 2,
	'L': 3,
	'M': 2,
	'N': 3,
	'O': 3,
	'P': 2,
	'Q': 0,
	'R': 3,
	'S': 2,
	'T': 3,
	'U': 1,
	'V': 1,
	'W': 2,
	'X': 1,
	'Y': 1,
	'Z': 1
}

def has_valid_length(word):
	'''
	Words must be at least 3 letters long, and there are a max of 12 letters in the game
	'''
	return len(word) >= 3 and len(word) <= 12

def has_valid_letters(word):
	'''
	Compare # of letters in the word to each letter's max possible # of appearances
	'''
	letters = Counter(word)
	return all(letters[l] <= max_letter_counts[l] for l in letters)

def has_valid_vowels(word):
	'''
	There are only 3 dice with vowels, so more than 3 vowels is impossible
	'''
	letters = Counter(word)
	vowels = 'aeiou'
	return sum(letters[l] for l in vowels) <= 3

def is_valid_word(word):
	'''
	Checks if a word is valid by a number of rules
	'''
	return has_valid_length(word) and has_valid_letters(word) and has_valid_vowels(word)

file_path = path.abspath(path.dirname(__file__))
with open(path.join(file_path, 'words.txt'), 'r') as f:
	words = [word.split()[0].strip().upper() for word in f.readlines()]
	words = set([word for word in words if is_valid_word(word)])


with open(path.join(file_path, '..', 'QLessClues', 'QLessClues', 'Resources', 'words.txt'), 'w') as f:
	[f.write(f"{word}\n") for word in sorted(words)]

with open(path.join(file_path, 'freq.csv'), 'r') as f:
	frequencies = [line.strip().upper().split(',') for line in f.readlines()]

with open(path.join(file_path, '..', 'QLessClues', 'QLessClues', 'Resources', 'freq.csv'), 'w') as f:
	[f.write(f"{freq[0]},{freq[1]}\n") for freq in frequencies if freq[0] in words]
