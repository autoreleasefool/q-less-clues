from collections import Counter

# Manually verified max # of times a letter can appear
max_letter_counts = {
	'a': 2,
	'b': 3,
	'c': 2,
	'd': 3,
	'e': 2,
	'f': 2,
	'g': 2,
	'h': 2,
	'i': 2,
	'j': 1,
	'k': 2,
	'l': 3,
	'm': 2,
	'n': 3,
	'o': 3,
	'p': 2,
	'q': 0,
	'r': 3,
	's': 2,
	't': 3,
	'u': 1,
	'v': 1,
	'w': 2,
	'x': 1,
	'y': 1,
	'z': 1
}

with open('./QLessClues/QLessClues/Resources/words.txt', 'r') as f:
	words = [word.strip().lower() for word in f.readlines()]

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

with open('./QLessClues/QLessClues/Resources/words.txt', 'w') as f:
	[f.write(f"{word}\n") for word in words if is_valid_word(word)]
