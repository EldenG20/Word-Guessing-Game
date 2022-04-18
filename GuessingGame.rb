require 'net/http'

#method to take the html line as a string and extract the word or definition
def getRandomWord(string)
  randomWord = ""
  words = string.split(">")
  words2 = words[1].split("<")
  return words2[0]
end

def addLettersToRandomWord(string, stringHint)
  stringArray = string.chars
  stringHintArray = stringHint.chars
  underscoreCount = 0
  numberOfHintLetters = 0

  for char in stringHintArray
    if char == '_'
      underscoreCount += 1
    end
  end

  while ((numberOfHintLetters < string.length() / 3) and (underscoreCount > 2))
    hintletterPos = rand(string.length())

    if (stringHintArray[hintletterPos] == '_')
      stringHintArray[hintletterPos] = stringArray[hintletterPos]
      numberOfHintLetters += 1
      underscoreCount -= 1
    end

  end
  stringHint = stringHintArray.join

return stringHint
end
cont = true

while (cont)
  # Save the html body of randomword.com to a string to extract the random word and definition
  body = Net::HTTP.get(URI('https://randomword.com/'))
  randomWordString = body.lines(chomp: true)[60].strip
  randomDefinitionString = body.lines(chomp: true)[61].strip

  randomWord = getRandomWord(randomWordString).strip()
  randomDefinition = getRandomWord(randomDefinitionString).strip()

  randomWordHint = ""
  randomWord.length().times {randomWordHint += "_"}

  guess = ""
  guess_count = 0
  guess_limit = 3
  out_of_guesses = false

  puts "You have three guesses to correctly guess a word, based on its definition"
  puts "The definition of the word is:\n\n" + randomDefinition + "\n"
  puts "\nThe word is " + randomWord.length().to_s + " letters long."

  while guess != randomWord and !out_of_guesses
    if guess_count < guess_limit
      puts "Adding " + (randomWord.length() / 3).to_s + " hint letters to the word:"
      randomWordHint = addLettersToRandomWord(randomWord, randomWordHint)
      puts randomWordHint
      puts "You have " + (guess_limit - guess_count).to_s + " guesses left."
      puts "Enter your guess: "
      guess = gets.chomp().downcase()
      guess_count += 1
    else
      out_of_guesses = true
    end
  end

  if out_of_guesses
    puts "You ran out of guesses. You Lose."
    puts "The secret word was: " + randomWord
  else
    puts "That is the correct word. You Won!"
  end

  puts "Would you like to play again? Enter y or n."
  choice = gets.chomp().downcase()
  if (choice != "y")
    cont = false
  end
end
if cont == false
  puts "Exiting game. Goodbye."
end
