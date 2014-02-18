//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APSpeech.h"
#import <AVFoundation/AVFoundation.h>

#define URL @"http://www.translate.google.com/translate_tts?tl=%@&q=%@"
#define UA  @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7.5; rv:2.0.1) Gecko/20100101 Firefox/4.1.2"

@interface APSpeech () <AVAudioPlayerDelegate>
{
  AVAudioPlayer *_Player;
  NSString *_path;
}
@end


@implementation APSpeech

- (APSpeechStatus) SpeechThis:(NSString*)text inLanguage:(APSpeechLanguage)lang
{
  NSArray  *paths              = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  _path                        = [documentsDirectory stringByAppendingPathComponent:@"currentSpeech.mp3"];

  NSString *urlString          = [NSString stringWithFormat:URL, [self getLanguage:lang], text];

  NSURL *url                   = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];

  [request setValue:UA forHTTPHeaderField:@"User-Agent"];
  
  NSURLResponse* response = nil;
  NSError* error          = nil;
  NSData *data            = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if ( error )
    return APSpeechStatusKo;

  [data writeToFile:_path atomically:YES];
  
  NSError *err;
  if ( [[NSFileManager defaultManager] fileExistsAtPath:_path] )
  {
    if ( _Player && [_Player isPlaying] ) {
      [_Player stop];
      _Player = nil;
    }
    
    _Player          = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_path] error:&err];
    _Player.delegate = self;

    if ( error )
      return APSpeechStatusKo;
    
    [_Player prepareToPlay];
    [_Player setNumberOfLoops:1];
    [_Player play];

    return APSpeechStatusOk;
  }
  
  return APSpeechStatusKo;
}

- (NSString*) getLanguage:(APSpeechLanguage)lang
{
  switch (lang)
  {
    case APSpeechLanguageITA: return @"it";
    case APSpeechLanguageENG: return @"en";
    case APSpeechLanguageFRE: return @"fr";
    case APSpeechLanguageDEU: return @"de";
    case APSpeechLanguageESP: return @"es";
    default: return @"it";
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}

@end

