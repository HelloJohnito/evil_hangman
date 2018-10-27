var GLOBAL_PLIST= {
  1: ["a"],
  2: ["to", "be", "as"],
  3: ["ate", "ape", "bat", "bad", "cat", "baa", "poo", "ace", "att"],
  4: ["cate", "cope", "bast", "grim", "arts"]
};
var INPUT =  document.getElementById('input');
var WORD = document.getElementById('word');
var SUBMIT = document.getElementById('submit').addEventListener("click", submit);

var WORD_LENGTH = 3;
var WORD_LIST;
var CURRENT_KEY = "";


function submit(){  
  var equivalenceDictionary = partitionWord(WORD_LIST, CURRENT_KEY, INPUT.value);
  console.log(equivalenceDictionary);
  setWordListAndKey(equivalenceDictionary);
  console.log(WORD_LIST);
  console.log(CURRENT_KEY);
  render(CURRENT_KEY);
  return;
}


function partitionWord(wordList, startKey, userInput){
  var dictionary = {};
  var key = startKey;
  
  for(var i = 0; i < wordList.length; i++){
    var currentWord = wordList[i];
    var currentKey = key;
    for(var j = 0; j < currentWord.length; j++){
      if(currentWord[j] === userInput){
        currentKey = replaceCharAtIndex(currentKey, userInput, j);
      }
    }
    if(currentKey in dictionary){
      dictionary[currentKey].push(currentWord);
    } else {
      dictionary[currentKey] = [currentWord];
    }  
  }
  return dictionary;
}


function setWordListAndKey(dictionary){
  var length = 0;
  var currentKey;
  var listOfKeys = [];
  
  for(var key in dictionary){
    if(dictionary[key].length > length){
      currentKey = key; 
      length = dictionary[key].length;
    } else if (dictionary[key].length === length){
      listOfKeys.push(currentKey);
      currentKey = key;
    }
  }
  listOfKeys.push(currentKey);
  
  ///select random but for now use 0;
  WORD_LIST = dictionary[listOfKeys[0]];
  CURRENT_KEY = listOfKeys[0];
}


function replaceCharAtIndex(word, char, index){
  var newString = "";
  for(var i = 0; i < word.length; i++){
    if(i === index){
        newString += char;
    }
    else {
      newString += word[i];
    }
  }
  return newString;
}


function render(word){
  WORD.innerHTML = word;
  INPUT.value = "";
  return;
}


function main(){
  WORD_LIST = GLOBAL_PLIST[WORD_LENGTH];
  for(var z = 0; z < WORD_LENGTH; z++){
    CURRENT_KEY += "_";
  }
}
main();
