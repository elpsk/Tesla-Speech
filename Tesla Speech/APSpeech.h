//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
  APSpeechStatusOk = 0,
  APSpeechStatusKo
} APSpeechStatus;

typedef enum
{
  APSpeechLanguageITA = 0,
  APSpeechLanguageENG,
  APSpeechLanguageESP,
  APSpeechLanguageFRE,
  APSpeechLanguageDEU
} APSpeechLanguage;


@interface APSpeech : NSObject

@property (nonatomic, assign) int language;

- (APSpeechStatus) SpeechThis:(NSString*)text inLanguage:(APSpeechLanguage)lang;

@end
