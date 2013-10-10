Ruby Spell Corrector
====================

Usage
-----

run `bundle` to install dependencies.

Or run `gem install bundler` if you don't have bundler installed.

run `./prompt` to start a prompt, now enter any incorrect word it will return a correct one if there is any, press C-c to quit.

if it doesn't work, try run `ruby prompt` while inside the folder.

run `spec spec/array_extend_spec.rb` or `spec spec/string_extend_spec.rb` to test out the code once you finish the bundle command.

Challenge
---------

Write a program that reads a large list of English words (e.g. from /usr/share/dict/words on a unix system) into memory, and then reads words from stdin, and prints either the best spelling suggestion, or "NO SUGGESTION" if no suggestion can be found. The program should print ">" as a prompt before reading each word, and should loop until killed.

Your solution should be faster than O(n) per word checked, where n is the length of the dictionary. That is to say, you can't scan the dictionary every time you want to spellcheck a word.

For example:

```
> sheeeeep
sheep
> peepple
people
> sheeple
NO SUGGESTION
```

The class of spelling mistakes to be corrected is as follows:

Case (upper/lower) errors: "inSIDE" => "inside"
Repeated letters: "jjoobbb" => "job"
Incorrect vowels: "weke" => "wake"
Any combination of the above types of error in a single word should be corrected (e.g. "CUNsperrICY" => "conspiracy").

If there are many possible corrections of an input word, your program can choose one in any way you like. It just has to be an English word that is a spelling correction of the input by the above rules.

Final step: Write a second program that *generates* words with spelling mistakes of the above form, starting with correctly spelled English words. Pipe its output into the first program and verify that there are no occurrences of "NO SUGGESTION" in the output.

Solution
--------

spellcorrection.rb contains all the functions.

spec/\*.rb contains all rspec files for testing the functions.

String::Corrector is responsible for loading the dictionary, provide functions for calculating the distance between words.

String has three new functions:

* `remove_repeats` returns a string without any repeats
* `star_vowels` returns a string with all vowels turned into stars
* `correct` returns a correction of the word

Array has one new function:

* `least_of` takes a block then use it to return the element with the lowest score

The corrector works by storing the dictionary of words into hash

The key of hash could take in three forms:
1. the complete word
2. the word without repeated characters
3. the word without repeated characters and with vowels starred

Each key maps to a list of possible candidiates that have collided.

The corrector will first check to see if there is a key for the complete input, if so it returns the first element of the list return from the key, but if not, then it will remove the repeated characters in the input and repeat the procedure above to see if there are any candidates, if there are, it will return the candidate with the smallest levenshtein distance from the input, and if it still can't find the candidates, it will transform the input into the third form, and repeat the procedure, however if it still can't find a match, it will return 'NO SUGGESTION'

The Levenshtein distance, the edit distance between two strings, is implemented in a dynamic programming fashion inspired by the implementation in the [wikipedia page](http://en.wikipedia.org/wiki/Levenshtein_distance) by constructing a matrix which hold the Levenshtein distance bewteen all prefixes of the first string and all prefixes of the second string, then by using dynamic programming we can determine the distance between two full strings as the last value computed.

Space and Time Analysis
-----------------------

The implementation of Levenshtein distanace has a time complexity of O(n\*m) and space complexity of O(n\*m) where n and m are string lengths

The runtime for every word correction is O(n\*m) where n is the length of the input and m is the length of the longest word in the dictionary since it takes constant time to find candidates, then it has to go through the Levenshtein distance to find out the best candidate.


Generator
=========

A simple generator that generates word candidates based on the 3 classes of errors

Usage
=====

run `ruby generator.rb` to see the list of candidates

example:

```
aaAaAAaAaAL
aaAaAAaaAAL
aaAaAaAAAAl
aaAaAaAAAaL
aaAaAaAAaAL
aaAaAaAaAAL
aaAaAaaAAAL
aaAaaAAAAAl
aaAaaAAAAaL
aaAaaAAAaAL
aaAaaAAaAAL
aaAaaAaAAAL
aaAaaaAAAAL
aaaAAAAAAal
aaaAAAAAaAl
aaaAAAAAaaL
aaaAAAAaAAl
aaaAAAAaAaL
aaaAAAAaaAL
aaaAAAaAAAl
aaaAAAaAAaL
aaaAAAaAaAL
...
```

On the sidenote: I don't know why piping outputs from generator.rb into prompt didn't work but if I manually type it in while running prompt, it worked.
