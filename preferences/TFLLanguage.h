// TFLLanguage.h
// TubeFixLegacy
//
// "Language" setting for the settings pane: auto, en or ru.

#import <Foundation/Foundation.h>

NSString *TFLChosenLanguage(void);

// call after the setting changed, before reloading specifiers
void TFLLanguageDidChange(void);
