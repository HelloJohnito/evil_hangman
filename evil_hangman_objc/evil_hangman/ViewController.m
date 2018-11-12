//
//  ViewController.m
//  evil_hangman
//
//  Created by John  Ito lee on 10/27/18.
//  Copyright © 2018 Johnito. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSArray *listOfWords;
    NSMutableArray *currentWordArray;
    int wordLength;
}
-(NSMutableDictionary*)partitionWord: (NSString*)userInput;
-(NSString*)convertArrayToString: (NSArray*)currentWord;
-(NSMutableArray*)convertStringToArray: (NSString*) currentWord;
-(void)setDisplayLabelAndListOfWord: (NSMutableDictionary*)partitionedDic;
@end

@implementation ViewController

@synthesize word = _word;
@synthesize userInput = _userInput;
@synthesize button = _button;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        // code for plist
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"testWord" ofType:@"plist"];
        listOfWords = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        wordLength = 3;
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < [listOfWords count]; i++){
            if([[listOfWords objectAtIndex:i] length] == wordLength){
                [tempArray addObject:[listOfWords objectAtIndex:i]];
            }
        }
        listOfWords = [tempArray copy];
        NSLog(@"%@", listOfWords);
        
        currentWordArray=[[NSMutableArray alloc] init];
        for(int i = 0; i < wordLength; i++){
            [currentWordArray addObject: @"_"];
        }
    }
    return self;
}


- (NSMutableDictionary*) partitionWord: (NSString*)userInput{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray* tempArray;
    
    for(int i = 0; i < [listOfWords count]; i++){
        NSString* currentWordFromList = [listOfWords objectAtIndex:i];
        tempArray = [currentWordArray mutableCopy];
        for(int j = 0; j < [currentWordFromList length]; j++){
            NSString *currentLetter = [currentWordFromList substringWithRange:NSMakeRange(j, 1)];
            if(currentLetter == userInput){
                [tempArray replaceObjectAtIndex: j withObject: currentLetter];
            }
        }
        NSString* stringWordForKey = [self convertArrayToString: tempArray];
        
        if([dictionary objectForKey: stringWordForKey]){
            [[dictionary valueForKey:stringWordForKey] addObject: currentWordFromList];
        }
        else {
            [dictionary setObject: [[NSMutableArray alloc] init] forKey: stringWordForKey];
            [[dictionary valueForKey: stringWordForKey] addObject: currentWordFromList];
        }
    }
    return dictionary;
};


- (void)submit{
    NSString *letter = [self.userInput.text lowercaseString];
    NSMutableDictionary *partitionedDictionary = [self partitionWord:letter];
    [self setDisplayLabelAndListOfWord: partitionedDictionary];
    _word.text = [self convertArrayToString: currentWordArray];
    _userInput.text = @"";
    NSLog(@"%@",listOfWords);
}

- (void) setDisplayLabelAndListOfWord: (NSMutableDictionary*)partitionedDic {
    int count = 0;
    NSArray *tempWordList;
    NSString* tempDisplayWord;
    for(NSString *key in partitionedDic) {
        NSArray *words = [partitionedDic objectForKey:key];
        if(count < [words count]){
            count = (int)[words count];
            tempWordList = words;
            tempDisplayWord = key;
        }
    }
    listOfWords = tempWordList;
    currentWordArray = [self convertStringToArray: tempDisplayWord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    float wordWidth = 320;
    float wordHeight = 50;
    float wordXPos = ((self.view.frame.size.width/2) - (wordWidth/2));
    float wordYPos = ((self.view.frame.size.height/2) - (wordHeight/2));
    _word = [[UILabel alloc] initWithFrame:CGRectMake(wordXPos, wordYPos, wordWidth, wordHeight)];
    _word.text = [self convertArrayToString: currentWordArray];
    _word.textAlignment = NSTextAlignmentCenter;
    _word.font = [UIFont systemFontOfSize: 50];
    [self.view addSubview:_word];
   
    float userInputWidth = 320;
    float userInputHeight = 50;
    float userInputXPos = ((self.word.frame.origin.x));
    float userInputYPos = ((self.word.frame.origin.y) + (wordHeight * 2));
    _userInput = [[UITextField alloc] initWithFrame:CGRectMake(userInputXPos, userInputYPos, userInputWidth, userInputHeight)];
    _userInput.layer.borderColor = [[UIColor blackColor]CGColor];
    _userInput.layer.borderWidth = 1.0;
    _userInput.placeholder = @"Insert a letter";
    _userInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userInput.textAlignment = NSTextAlignmentCenter;
    _userInput.font = [UIFont systemFontOfSize: 30];
    [self.view addSubview:_userInput];
    
    float buttonWidth = 150;
    float buttonHeight = 50;
    float buttonXPos = ((self.userInput.frame.origin.x) + (self.userInput.frame.size.width/4));
    float buttonYPos = ((self.userInput.frame.origin.y) + (self.userInput.frame.size.height *2));
    _button = [[UIButton alloc] initWithFrame:CGRectMake(buttonXPos, buttonYPos, buttonWidth, buttonHeight)];
    [_button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"Submit" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)convertArrayToString: (NSMutableArray*)currentWord {
    NSString* word = @"";
    int length = (int)[currentWord count];
    for(int i = 0; i < length; i++){
        if(i != length - 1){
            NSString* letter = [[currentWord objectAtIndex: i] stringByAppendingString: @" "];
            word = [word stringByAppendingString: letter];
        }
        else{
            word = [word stringByAppendingString: [currentWord objectAtIndex: i]];
        }
    }
    return word;
}

- (NSMutableArray*)convertStringToArray: (NSString*) currentWord{
    NSMutableArray* tempWordArray = [[NSMutableArray alloc] init];
    for(int i = 0; i<[currentWord length]; i++){
        NSString *letter = [currentWord substringWithRange:NSMakeRange(i, 1)];
        if(![letter isEqualToString:@" "]){
            [tempWordArray addObject: letter];
        }
    }
    return tempWordArray;
}

@end

