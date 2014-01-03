//
//  Atom.m
//  Atomic Class
//
//  Created by Fernando Cervantes on 2/15/12.
//  Copyright (c) 2012 Fernando Cervantes. All rights reserved.
//
//  Version 1.0

#import "Atom.h"

@implementation Atom

#define LOG_FILENAME @"Log"
#define SAFE_DIRECTORYNAME @"Safe"
#define USER_IDENTITY_LENGTH 10
#define ARC4RANDOM_MAX 0x100000000

BOOL loggingEnabled = TRUE;

#pragma mark - Device Information
-(NSString *) getDeviceOrientation {
    NSString * result;
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        result = @"Portrait";
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        result = @"Portrait_Upside_Down";
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        result = @"Landscape_Left";
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        result = @"Landscape_Right";
    } else {
        result = @"Unavailable";
    }
    
    return result;
}

-(NSString *) getDeviceType {
    return [UIDevice currentDevice].model;
}

-(NSString *) getDeviceVersion {
    return [[UIDevice currentDevice] systemVersion];
}

-(int) getDeviceResolutionType {
    int result = 0;
    
    NSString * deviceModel = [[UIDevice currentDevice].model lowercaseString];
    
    if (([deviceModel rangeOfString:@"iphone"].location != NSNotFound) || ([deviceModel rangeOfString:@"ipod"].location != NSNotFound)) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            result = DEVICE_RESOLUTION_TYPE_LONG;
        } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            result = DEVICE_RESOLUTION_TYPE_SHORT;
        }
    } else {
        result = DEVICE_RESOLUTION_TYPE_SHORT;
    }
    
    return result;
}

-(BOOL) checkIfDeviceIsRetinaCapable {
    bool result;
    if ([[UIScreen mainScreen] scale] == 2.0) result = TRUE; else result = FALSE;
    
    return result;
}

-(BOOL) checkIfDeviceIsSimulated {
    return ([[[UIDevice currentDevice].model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound);
}

#pragma mark - Console Logging
-(void) logBoolean:(BOOL)boolean withName:(NSString *)name {
    ALog(@"%@: %s", name, (boolean ? "TRUE" : "FALSE"));
}

-(void) logArray:(NSArray *)array sorted:(BOOL)sorted {
    NSString * result = @"";
    
    if ([array count] != 0) {
        result = [NSString stringWithFormat:@"Items in array: %lu", (unsigned long)[array count]];
        result = [result stringByAppendingFormat:@"\nSorted: %s", (sorted ? "TRUE" : "FALSE")];
        
        if (sorted == TRUE) {
            array = [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        }
        
        for (int x = 0; x < [array count]; x++) {
            result = [result stringByAppendingFormat:@"\n%d: %@", x, [array objectAtIndex:x]];
        }
    } else {
        result = @"No Items In Array";
    }
    ALog(@"%@", result);
}

-(void) logDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekdayCalendarUnit) fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger weekday = [dateComponents weekday];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    NSString * weekdayName;
    
    if (weekday == 1) weekdayName = @"Sunday";
    else if (weekday == 2) weekdayName = @"Monday";
    else if (weekday == 3) weekdayName = @"Tuesday";
    else if (weekday == 4) weekdayName = @"Wednesday";
    else if (weekday == 5) weekdayName = @"Thursday";
    else if (weekday == 6) weekdayName = @"Friday";
    else if (weekday == 7) weekdayName = @"Saturday";
    
    ALog(@"Year: %d\nMonth: %d\nDay: %d\nWeekday: %d, %@\nHour: %d\nMinute: %d\nSecond: %d", (int)year, (int)month, (int)day, (int)weekday, weekdayName, (int)hour, (int)minute, (int)second);
}

-(void) enableLog {
    loggingEnabled = TRUE;
}

-(void) disableLog {
    loggingEnabled = FALSE;
}

#pragma mark - File Logging
-(void) logToFile:(NSString *)string {
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger year = [[calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]] year];
    NSInteger month = [[calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]] month];
    NSInteger day = [[calendar components:(NSDayCalendarUnit) fromDate:[NSDate date]] day];
    NSInteger hour = [[calendar components:(NSHourCalendarUnit) fromDate:[NSDate date]] hour];
    NSInteger minute = [[calendar components:(NSMinuteCalendarUnit) fromDate:[NSDate date]] minute];
    NSInteger second = [[calendar components:(NSSecondCalendarUnit) fromDate:[NSDate date]] second];
    
    NSString * timeOfDay;
    
    if (hour > 12) {
        hour=hour-12;
        timeOfDay = [NSString stringWithFormat:@"PM"];
    } else {
        timeOfDay = [NSString stringWithFormat:@"AM"];
    }
    
    NSString * monthFormat;
    NSString * dayFormat;
    NSString * hourFormat;
    NSString * minuteFormat;
    NSString * secondFormat;
    
    if (month < 10) monthFormat = [NSString stringWithFormat:@"0%d", (int)month];
    else monthFormat = [NSString stringWithFormat:@"%d", (int)month];
    
    if (day < 10) dayFormat = [NSString stringWithFormat:@"0%d", (int)day];
    else dayFormat = [NSString stringWithFormat:@"%d", (int)day];
    
    if (hour < 10) hourFormat = [NSString stringWithFormat:@"0%d", (int)hour];
    else hourFormat = [NSString stringWithFormat:@"%d", (int)hour];
    
    if (minute < 10) minuteFormat = [NSString stringWithFormat:@"0%d", (int)minute];
    else minuteFormat = [NSString stringWithFormat:@"%d", (int)minute];
    
    if (second < 10) secondFormat = [NSString stringWithFormat:@"0%d", (int)second];
    else secondFormat = [NSString stringWithFormat:@"%d", (int)second];
    
    NSString * dataToWrite = [NSString stringWithFormat:@"\n%@/%@/%d %@:%@:%@%@: %@", monthFormat, dayFormat, (int)year, hourFormat, minuteFormat, secondFormat, timeOfDay, string];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] == nil) {
            [dataToWrite writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
        } else {
            NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            [fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]];
            [fileHandle writeData:[dataToWrite dataUsingEncoding:NSUTF8StringEncoding]];
        }
    } else {
        [dataToWrite writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
    }
}

-(NSString *) getLogFromLogFile {
    NSString * result;
    
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    NSString * dataFromFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([dataFromFile isEqualToString:@""] || dataFromFile == NULL || dataFromFile == nil) {
            result = @"";
            ALog(@"Log File Empty");
        } else {
            result = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        }
    } else {
        ALog(@"Log File Not Found");
        result = @"";
    }
    
    return result;
}

-(void) clearLogFile {
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [@"" writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
        ALog(@"Log File Cleared");
    } else {
        ALog(@"Log File Does Not Exist");
    }
}

-(void) createLogFile {
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        ALog(@"Log File Already Exists");
    } else {
        [@"" writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
        ALog(@"Log File Created");
    }
}

-(void) removeLogFile {
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL itemRemoved = [fileManager removeItemAtPath:filePath error:&error];
        if (itemRemoved == TRUE) {
            ALog(@"Log File Removed");
        } else {
            ALog(@"Log File Removal Failed");
        }
    } else {
        ALog(@"Log File Does Not Exist");
    }
}

#pragma mark - Directory Paths
-(NSString *) getDirectoryPathDocuments {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString *) getDirectoryPathDocumentsWithSubDirectory:(NSString *)subDirectory {
    NSString * result = @"";
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if ([subDirectory characterAtIndex:0] == '/') {
        result = [documentsDirectory stringByAppendingFormat:@"%@", subDirectory];
    } else {
        result = [documentsDirectory stringByAppendingFormat:@"/%@", subDirectory];
    }
    
    return result;
}

#pragma mark - Strings
-(int) getCountOfRepetitionsOfString:(NSString *)a inString:(NSString *)b caseSensitive:(BOOL)sensitive {
    NSUInteger count = -1, length = [b length];
    NSRange range = NSMakeRange(0, length);
    
    if (sensitive == TRUE) {
        while (range.location != NSNotFound) {
            range = [b rangeOfString:a options:0 range:range];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            
            count++;
        }
    } else {
        while (range.location != NSNotFound) {
            range = [[b lowercaseString] rangeOfString:[a lowercaseString] options:0 range:range];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            
            count++;
        }
    }
    
    return (int)count;
}

-(int) getCountOfWordsInString:(NSString *)string {
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSCharacterSet * whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet * nonWhitespace = [whiteSpace invertedSet];
    
    int wordcount = 0;
    
    while(![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
        [scanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
        wordcount++;
    }
    
    return wordcount;
}

-(BOOL) checkIfString:(NSString *)a containsString:(NSString *)b {
    bool result;
    
    if ([a rangeOfString:b].location != NSNotFound) {
        result = TRUE;
    } else {
        result = FALSE;
    }
    
    return result;
}

-(BOOL) checkIfString:(NSString *)a containsAllCharactersInString:(NSString *)b {
    BOOL result = FALSE;
    int charactersFound = 0;
    
    for (int x = 0; x < a.length; x++) {
        for (int y = 0; y < b.length; y++) {
            if ([[a substringWithRange:NSMakeRange(x, 1)] isEqualToString:[b substringWithRange:NSMakeRange(y, 1)]]) {
                charactersFound++;
            }
        }
    }
    
    if (charactersFound == b.length || b.length == 0) {
        result = TRUE;
    } else {
        result = FALSE;
    }
    
    return result;
}

-(BOOL) checkIfString:(NSString *)a containsAnyCharactersInString:(NSString *)b {
    BOOL result = FALSE;
    
    for (int x = 0; x < a.length; x++) {
        for (int y = 0; y < b.length; y++) {
            if ([[a substringWithRange:NSMakeRange(x, 1)] isEqualToString:[b substringWithRange:NSMakeRange(y, 1)]]) {
                result = TRUE;
            }
        }
    }
    
    return result;
}

-(NSString *) getStringFromArray:(NSArray *)array separateComponentsBy:(NSString *)separator {
    NSString * result;
    
    for (int x = 0; x < [array count]; x++) {
        if (x == 0) {
            result = [array objectAtIndex:x];
        } else {
            result = [result stringByAppendingString:[separator stringByAppendingString:[array objectAtIndex:x]]];
        }
    }
    
    return result;
}

-(NSString *) getString:(NSString *)string withUppercaseCharacterAtIndex:(int)index {
    NSString * result;
    
    NSString * part1 = [string substringToIndex:index];
    NSString * letter = [[string substringWithRange:NSMakeRange(index, 1)] uppercaseString];
    NSString * part2 = [string substringFromIndex:index+1];
    
    result = [NSString stringWithFormat:@"%@%@%@", part1, letter, part2];
    
    return result;
}

-(NSString *) getString:(NSString *)string withUppercaseCharactersFromIndex:(int)initialIndex toIndex:(int)finalIndex {
    NSString * result;
    
    NSString * part1 = [string substringToIndex:initialIndex];
    NSString * letter = [[string substringWithRange:NSMakeRange(initialIndex, (finalIndex-initialIndex)+1)] uppercaseString];
    NSString * part2 = [string substringFromIndex:finalIndex+1];
    
    result = [NSString stringWithFormat:@"%@%@%@", part1, letter, part2];
    
    return result;
}

-(NSString *) getString:(NSString *)string withLowercaseCharacterAtIndex:(int)index {
    NSString * result;
    
    NSString * part1 = [string substringToIndex:index];
    NSString * letter = [[string substringWithRange:NSMakeRange(index, 1)] lowercaseString];
    NSString * part2 = [string substringFromIndex:index+1];
    
    result = [NSString stringWithFormat:@"%@%@%@", part1, letter, part2];
    
    return result;
}

-(NSString *) getString:(NSString *)string withLowercaseCharactersFromIndex:(int)initialIndex toIndex:(int)finalIndex {
    NSString * result;
    
    NSString * part1 = [string substringToIndex:initialIndex];
    NSString * letter = [[string substringWithRange:NSMakeRange(initialIndex, (finalIndex-initialIndex)+1)] lowercaseString];
    NSString * part2 = [string substringFromIndex:finalIndex+1];
    
    result = [NSString stringWithFormat:@"%@%@%@", part1, letter, part2];
    
    return result;
}

-(NSString *) getStringWhileRemovingLetters:(NSString *)string removeSpaces:(BOOL)removeSpaces {
    NSString * result;
    NSCharacterSet * numbers;
    
    if (removeSpaces == TRUE) {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    } else {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 "];
    }
    
    NSMutableString * mutableString = [NSMutableString stringWithCapacity:string.length];
    NSScanner * scanner = [NSScanner scannerWithString:string];
    
    while ([scanner isAtEnd] == FALSE) {
        NSString * buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [mutableString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    result = mutableString;
    
    return result;
}

-(NSString *) getStringWhileRemovingNumbers:(NSString *)string removeSpaces:(BOOL)removeSpaces {
    NSString * result;
    NSCharacterSet * alphabet;
    
    if (removeSpaces == TRUE) {
        alphabet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    } else {
        alphabet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
    }
    
    NSMutableString * mutableString = [NSMutableString stringWithCapacity:string.length];
    NSScanner * scanner = [NSScanner scannerWithString:string];
    
    while ([scanner isAtEnd] == FALSE) {
        NSString * buffer;
        if ([scanner scanCharactersFromSet:alphabet intoString:&buffer]) {
            [mutableString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    result = mutableString;
    
    return result;
}

-(NSString *) getString:(NSString *)string whileRemovingCharacters:(NSString *)characters {
    NSString * result;
    NSCharacterSet * charactersSet;
    
    charactersSet = [[NSMutableCharacterSet characterSetWithCharactersInString:characters] invertedSet];
    
    NSMutableString * mutableString = [NSMutableString stringWithCapacity:string.length];
    NSScanner * scanner = [NSScanner scannerWithString:string];
    
    while ([scanner isAtEnd] == FALSE) {
        NSString * buffer;
        if ([scanner scanCharactersFromSet:charactersSet intoString:&buffer]) {
            [mutableString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    result = mutableString;
    
    return result;
}

-(NSString *) getString:(NSString *)string whileMaintainingCharacters:(NSString *)characters removeSpaces:(BOOL)removeSpaces {
    NSString * result;
    NSCharacterSet * charactersSet;
    
    if (removeSpaces == TRUE) {
        charactersSet = [NSMutableCharacterSet characterSetWithCharactersInString:characters];
    } else {
        charactersSet = [NSMutableCharacterSet characterSetWithCharactersInString:[characters stringByAppendingFormat:@" "]];
    }
    
    NSMutableString * mutableString = [NSMutableString stringWithCapacity:string.length];
    NSScanner * scanner = [NSScanner scannerWithString:string];
    
    while ([scanner isAtEnd] == FALSE) {
        NSString * buffer;
        if ([scanner scanCharactersFromSet:charactersSet intoString:&buffer]) {
            [mutableString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    result = mutableString;
    
    return result;
}

#pragma mark - Arrays
-(NSArray *) getArrayOfCombinedArray:(NSArray *)arrayOne withArray:(NSArray *)arrayTwo {
    NSArray * result;
    
    NSMutableArray * a = [[NSMutableArray alloc] initWithArray:arrayOne];
    NSMutableArray * b = [[NSMutableArray alloc] initWithArray:arrayTwo];
    NSMutableArray * x = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [a count]; i++) [x addObject:[a objectAtIndex:i]];
    for (int i = 0; i < [b count]; i++) [x addObject:[b objectAtIndex:i]];
    
    result = [NSArray arrayWithArray:x];
    
    return result;
}

-(NSArray *) getArrayWithAscendingOrderOfObjects:(NSArray *)array {
    NSArray * result;
    
    result = [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return result;
}

-(NSArray *) getArrayWithDescendingOrderOfObjects:(NSArray *)array {
    NSArray * result;
    NSMutableArray * x = [[NSMutableArray alloc] init];
    
    for (int i = (int)[array count]-1; i >= 0; i--) [x addObject:[array objectAtIndex:i]];
    
    result = [NSArray arrayWithArray:x];
    
    return result;
}

-(BOOL) checkIfArray:(NSArray *)array containsString:(NSString *)string {
    bool result = FALSE;
    
    for (int i = 0; i < [array count]; i++) {
        if (result == FALSE && [[array objectAtIndex:i] isEqualToString:string]) result = TRUE;
    }
    
    return result;
}

-(BOOL) checkIfArray:(NSArray *)array containsStrings:(NSArray *)strings {
    bool result = 0;
    int count = 0, extraCount = 0, extraSubCount = 0;
    
    for (int x = 0; x < [array count]; x++) {
        extraSubCount = 0;
        for (int y = 0; y < [strings count]; y++) {
            if ([[strings objectAtIndex:y] isEqualToString:[array objectAtIndex:x]]) extraSubCount++;
        }
        if (extraSubCount > 1) extraCount++;
    }
    
    for (int i = 0; i < [array count]; i++) {
        for (int j = 0; j < [array count]; j++) {
            if (result == FALSE && [[array objectAtIndex:i] isEqualToString:[strings objectAtIndex:j]]) {
                count ++;
            }
        }
    }
    
    result = count + extraCount;
    
    return result;
}

-(int) getCountOfRepetitionsOfString:(NSString *)string inArray:(NSArray *)array caseSensitive:(BOOL)sensitive {
    int result = 0, count = 0;
    
    if (sensitive == TRUE) {
        for (int x = 0; x < [array count]; x++) {
            if ([[array objectAtIndex:x] isEqualToString:string]) count++;
        }
    } else {
        NSMutableArray * lowercaseArray = [[NSMutableArray alloc] init];
        NSString * lowercaseString;
        
        for (int x = 0; x < [array count]; x++) {
            lowercaseString = [[NSString stringWithFormat:@"%@", [array objectAtIndex:x]]lowercaseString];
            [lowercaseArray addObject:lowercaseString];
        }
        
        array = [NSArray arrayWithArray:lowercaseArray];
        
        for (int x = 0; x < [array count]; x++) {
            if ([[array objectAtIndex:x] isEqualToString:[string lowercaseString]]) count++;
        }
    }
    
    result = count;
    return result;
}

#pragma mark - Dictionaries
-(NSDictionary *) getDictionaryOfCombinedDictionary:(NSDictionary *)dictionaryA withDictionary:(NSDictionary *)dictionaryB {
    NSDictionary * result;
    NSMutableDictionary * mergedDictionaries;
    
    [mergedDictionaries addEntriesFromDictionary:dictionaryA];
    [mergedDictionaries addEntriesFromDictionary:dictionaryB];
    
    result = mergedDictionaries;
    
    return result;
}

#pragma mark - Common Values
-(float) attainSpeedOfLightInMetersOverSeconds {
    return 299792458;
}

-(float) attainGravitationalForceOfEarthInMetersPerSecondSquared {
    return 9.80665;
}

-(NSArray *) attainAlphabetInArray {
    NSArray * result;
    
    NSMutableArray * x = [[NSMutableArray alloc] init];
    
    for (char c = 'A'; c <= 'Z'; c++) [x addObject:[NSString stringWithFormat:@"%c", c]];
    
    result = [NSArray arrayWithArray:x];
    
    return result;
}

-(NSString *) attainAlphabetInString {
    return @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
}

#pragma mark - Conversions
-(float) convertKelvinToFahrenheit:(float)kelvin round:(BOOL)round {
    float x = ((kelvin-273.15)*9/5+32);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertKelvinToCelsius:(float)kelvin round:(BOOL)round {
    float x = (kelvin-273.15);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFahrenheitToKelvin:(float)fahrenheit round:(BOOL)round {
    float x = ((fahrenheit-32)*5/9+273.15);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFahrenheitToCelsius:(float)fahrenheit round:(BOOL)round {
    float x = (0.55555556*(fahrenheit-32));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCelsiusToKelvin:(float)celsius round:(BOOL)round {
    float x = (celsius+273.15);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCelsiusToFahrenheit:(float)celsius round:(BOOL)round {
    float x = ((celsius*1.8)+32);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPoundsToKilograms:(float)pounds round:(BOOL)round {
    float x = (pounds/2.2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPoundsToOunces:(float)pounds round:(BOOL)round {
    float x = (pounds*16);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPoundsToGrams:(float)pounds round:(BOOL)round {
    float x = (pounds*453.59237);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertKilogramsToPounds:(float)kilograms round:(BOOL)round {
    float x = (kilograms*2.2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertKilogramsToOunces:(float)kilograms round:(BOOL)round {
    float x = (kilograms*35.273962);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertKilogramsToGrams:(float)kilograms round:(BOOL)round {
    float x = (kilograms*1000);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDegreesToRadians:(float)degrees round:(BOOL)round {
    float x = (degrees*(M_PI/180));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertRadiansToDegrees:(float)radians round:(BOOL)round {
    float x = (radians*(180/M_PI));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertGallonsToQuarts:(float)gallons round:(BOOL)round {
    float x = (gallons*4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertGallonsToLiters:(float)gallons round:(BOOL)round {
    float x = (gallons*3.78541);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertGallonsToPints:(float)gallons round:(BOOL)round {
    float x = (gallons*8);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertGallonsToCups:(float)gallons round:(BOOL)round {
    float x = (gallons*16);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertQuartsToGallons:(float)quarts round:(BOOL)round {
    float x = (quarts/4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertQuartsToLiters:(float)quarts round:(BOOL)round {
    float x = (quarts/1.056688);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertQuartsToPints:(float)quarts round:(BOOL)round {
    float x = (quarts*2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertQuartsToCups:(float)quarts round:(BOOL)round {
    float x = (quarts*4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertLitersToGallons:(float)liters round:(BOOL)round {
    float x = (liters*0.26417);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertLitersToQuarts:(float)liters round:(BOOL)round {
    float x = (liters*1.056688);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertLitersToPints:(float)liters round:(BOOL)round {
    float x = (liters*2.113377);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertLitersToCups:(float)liters round:(BOOL)round {
    float x = (liters*4.22676);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPintsToGallons:(float)pints round:(BOOL)round {
    float x = (pints/8);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPintsToQuarts:(float)pints round:(BOOL)round {
    float x = (pints/2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPintsToLiters:(float)pints round:(BOOL)round {
    float x = (pints/2.113377);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertPintsToCups:(float)pints round:(BOOL)round {
    float x = (pints*2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCupsToGallons:(float)cups round:(BOOL)round {
    float x = (cups/16);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCupsToQuarts:(float)cups round:(BOOL)round {
    float x = (cups/4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCupsToLiters:(float)cups round:(BOOL)round {
    float x = (cups/4.22676);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCupsToPints:(float)cups round:(BOOL)round {
    float x = (cups/2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMilesToKilometers:(float)miles round:(BOOL)round {
    float x = (miles*1.609);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertKilometersToMiles:(float)kilometers round:(BOOL)round {
    float x = (kilometers*0.6214);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYardsToMeters:(float)yards round:(BOOL)round {
    float x = (yards*0.9144);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYardsToFeet:(float)yards round:(BOOL)round {
    float x = (yards*3);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYardsToInches:(float)yards round:(BOOL)round {
    float x = (yards*36);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYardsToCentimeters:(float)yards round:(BOOL)round {
    float x = (yards*91.44);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYardsToMillimeters:(float)yards round:(BOOL)round {
    float x = (yards*914.4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMetersToYards:(float)meters round:(BOOL)round {
    float x = (meters*1.094);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMetersToFeet:(float)meters round:(BOOL)round {
    float x = (meters*3.281);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMetersToInches:(float)meters round:(BOOL)round {
    float x = (meters*40);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMetersToCentimeters:(float)meters round:(BOOL)round {
    float x = (meters*100);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMetersToMillimeters:(float)meters round:(BOOL)round {
    float x = (meters*1000);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFeetToYards:(float)feet round:(BOOL)round {
    float x = (feet/3);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFeetToMeters:(float)feet round:(BOOL)round {
    float x = (feet*0.3048);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFeetToInches:(float)feet round:(BOOL)round {
    float x = (feet*12);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFeetToCentimeters:(float)feet round:(BOOL)round {
    float x = (feet*30);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertFeetToMillimeters:(float)feet round:(BOOL)round {
    float x = (feet*304.8);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertInchesToYards:(float)inches round:(BOOL)round {
    float x = (inches/36);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertInchesToMeters:(float)inches round:(BOOL)round {
    float x = (inches/40);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertInchesToFeet:(float)inches round:(BOOL)round {
    float x = (inches/12);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertInchesToCentimeters:(float)inches round:(BOOL)round {
    float x = (inches*2.540);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertInchesToMillimeters:(float)inches round:(BOOL)round {
    float x = ((inches*2.540)/10);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCentimetersToYards:(float)centimeters round:(BOOL)round {
    float x = (centimeters/91.44);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCentimetersToMeters:(float)centimeters round:(BOOL)round {
    float x = (centimeters/100);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCentimetersToFeet:(float)centimeters round:(BOOL)round {
    float x = (centimeters/30);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCentimetersToInches:(float)centimeters round:(BOOL)round {
    float x = (centimeters*0.3937);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertCentimetersToMillimeters:(float)centimeters round:(BOOL)round {
    float x = (centimeters/10);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMillimetersToYards:(float)millimeters round:(BOOL)round {
    float x = (millimeters/914.4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMillimetersToMeters:(float)millimeters round:(BOOL)round {
    float x = (millimeters/1000);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMillimetersToFeet:(float)millimeters round:(BOOL)round {
    float x = (millimeters/304.8);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMillimetersToInches:(float)millimeters round:(BOOL)round {
    float x = ((millimeters*10)*0.3937);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMillimetersToCentimeters:(float)millimeters round:(BOOL)round {
    float x = (millimeters*10);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToMonths:(float)years round:(BOOL)round {
    float x = (years*12);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToWeeks:(float)years round:(BOOL)round {
    float x = (years*52.177457);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToDays:(float)years round:(BOOL)round {
    float x = (years*365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToHours:(float)years round:(BOOL)round {
    float x = ((years*365.242199)*24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToMinutes:(float)years round:(BOOL)round {
    float x = (((years*365.242199)*24)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertYearsToSeconds:(float)years round:(BOOL)round {
    float x = ((((years*365.242199)*24)*60)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToYears:(float)months round:(BOOL)round {
    float x = (months/12);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToWeeks:(float)months round:(BOOL)round {
    float x = ((months/12)*52.177457);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToDays:(float)months round:(BOOL)round {
    float x = ((months/12)*365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToHours:(float)months round:(BOOL)round {
    float x = ((months*30.445)*24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToMinutes:(float)months round:(BOOL)round {
    float x = (((months*30.445)*24)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMonthsToSeconds:(float)months round:(BOOL)round {
    float x = ((((months*30.4368499)*24)*60)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToYears:(float)weeks round:(BOOL)round {
    float x = (weeks/52);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToMonths:(float)weeks round:(BOOL)round {
    float x = (weeks/4.32);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToDays:(float)weeks round:(BOOL)round {
    float x = ((weeks/52)*365);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToHours:(float)weeks round:(BOOL)round {
    float x = ((weeks*7)*24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToMinutes:(float)weeks round:(BOOL)round {
    float x = (((weeks*7)*24)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertWeeksToSeconds:(float)weeks round:(BOOL)round {
    float x = ((((weeks*7)*24)*60)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToYears:(float)days round:(BOOL)round {
    float x = (days/365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToMonths:(float)days round:(BOOL)round {
    float x = (days/30.4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToWeeks:(float)days round:(BOOL)round {
    float x = (days/7);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToHours:(float)days round:(BOOL)round {
    float x = (days*24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToMinutes:(float)days round:(BOOL)round {
    float x = ((days*24)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertDaysToSeconds:(float)days round:(BOOL)round {
    float x = (((days*24)*60)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToYears:(float)hours round:(BOOL)round {
    float x = ((hours/24)/365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToMonths:(float)hours round:(BOOL)round {
    float x = (hours/(24*30.4368499));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToWeeks:(float)hours round:(BOOL)round {
    float x = (hours/(24*7));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToDays:(float)hours round:(BOOL)round {
    float x = (hours/24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToMinutes:(float)hours round:(BOOL)round {
    float x = (hours*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertHoursToSeconds:(float)hours round:(BOOL)round {
    float x = ((hours*60)*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToYears:(float)minutes round:(BOOL)round {
    float x = (((minutes/60)/24)/365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToMonths:(float)minutes round:(BOOL)round {
    float x = (((minutes/60)/24)/30.42);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToWeeks:(float)minutes round:(BOOL)round {
    float x = (((minutes/60)/24)/7);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToDays:(float)minutes round:(BOOL)round {
    float x = ((minutes/60)/24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToHours:(float)minutes round:(BOOL)round {
    float x = (minutes/60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertMinutesToSeconds:(float)minutes round:(BOOL)round {
    float x = (minutes*60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToYears:(float)seconds round:(BOOL)round {
    float x = ((((seconds/60)/60)/24)/365.242199);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToMonths:(float)seconds round:(BOOL)round {
    float x = ((((seconds/60)/60)/24)/30.4);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToWeeks:(float)seconds round:(BOOL)round {
    float x = ((((seconds/60)/60)/24)/7);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToDays:(float)seconds round:(BOOL)round {
    float x = (((seconds/60)/60)/24);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToHours:(float)seconds round:(BOOL)round {
    float x = ((seconds/60)/60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) convertSecondsToMinutes:(float)seconds round:(BOOL)round {
    float x = (seconds/60);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

#pragma mark - Calculations
-(float) calculateTaxOfPrice:(float)price round:(BOOL)round addTaxToPrice:(BOOL)addTax {
    float x = 0;
    
    if (addTax == TRUE) x = (price*1.0825);
    else x = (price*0.0825);
    
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateAverageOfNumbers:(NSArray *)arrayWithNumbers round:(BOOL)round {
    float x = 0;
    
    for (int y = 0; y < [arrayWithNumbers count]; y++) {
        x = x + [[arrayWithNumbers objectAtIndex:y] floatValue];
    }
    
    x = (x/[arrayWithNumbers count]);
    
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculatePercentageChangeFromNumber:(float)a toNumber:(float)b round:(BOOL)round {
    float x = ((((b)-a)/a)*100);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculatePercentageOfNumber:(float)a inNumber:(float)b round:(BOOL)round {
    float x = ((a/b)*100);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateNumberOfPercentage:(float)percentage ofNumber:(float)number round:(BOOL)round {
    float x = ((number*percentage)/100);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateHypotenuseOfA:(float)a andB:(float)b round:(BOOL)round {
    float x = (sqrtf((powf(a,2))+(powf(b,2))));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateCircumferenceWithDiameter:(float)diameter round:(BOOL)round {
    float x = (M_PI*diameter);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateCircumferenceWithRadius:(float)radius round:(BOOL)round {
    float x = (M_PI*(radius*2));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateDiameterWithCircumference:(float)circumference round:(BOOL)round {
    float x = (circumference/M_PI);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateDiameterWithRadius:(float)radius round:(BOOL)round {
    float x = (radius*2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateRadiusWithCircumference:(float)circumference round:(BOOL)round {
    float x = ((circumference/M_PI)/2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateRadiusWithDiameter:(float)diameter round:(BOOL)round {
    float x = (diameter/2);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateAreaOfSideA:(float)sideA andSideB:(float)sideB round:(BOOL)round {
    float x = (sideA*sideB);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculatePerimeterOfSideA:(float)sideA andSideB:(float)sideB round:(BOOL)round {
    float x = ((sideA*2)+(sideB*2));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateDensityWithKilograms:(float)mass andCubicMeters:(float)volume round:(BOOL)round {
    float x = (mass/volume);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateSpeedWithMeters:(float)distance andSeconds:(float)time round:(BOOL)round {
    float x = (distance/time);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateAccelerationWithInitialMetersOverSeconds:(float)initialVelocty andFinalMetersOverSeconds:(float)finalVelocity andSeconds:(float)deltaTime round:(BOOL)round {
    float x = ((finalVelocity-initialVelocty)/deltaTime);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateMomentumWithKilograms:(float)mass andMetersOverSeconds:(float)velocity round:(BOOL)round {
    float x = (mass*velocity);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateForceWithKilograms:(float)mass andMetersOverSquareSeconds:(float)acceleration round:(BOOL)round {
    float x = (mass*acceleration);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateWorkWithNewtons:(float)force andMeters:(float)distance round:(BOOL)round {
    float x = (force*distance);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculatePowerWithJoules:(float)work andSeconds:(float)time round:(BOOL)round {
    float x = (work/time);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateKineticEnergyWithKilograms:(float)mass andMetersOverSeconds:(float)velocity round:(BOOL)round {
    float x = (0.5*(mass*(powf(velocity, 2))));
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateCurrentWithVolts:(float)voltage andOhms:(float)resistance round:(BOOL)round {
    float x = (voltage/resistance);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

-(float) calculateElectricalPowerWithVolts:(float)voltage andAmperes:(float)current round:(BOOL)round {
    float x = (voltage*current);
    if (round == TRUE) x = lroundf((1.0f*x)/1.0f);
    
    return x;
}

#pragma mark - Transformations
-(CGAffineTransform) getTransformationExitUp:(id)object forView:(UIView *)view {
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation(0,-(imageView.frame.origin.y+imageView.frame.size.height));
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation(0,-(button.frame.origin.y+button.frame.size.height));
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitDown:(id)object forView:(UIView *)view {
    int screenHeight = 0;
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight)) {
        screenHeight = view.frame.size.height;
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait || UIInterfaceOrientationPortraitUpsideDown)) {
        screenHeight = view.frame.size.height;
    }
    
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation(0,screenHeight-imageView.frame.origin.y);
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation(0,screenHeight-button.frame.origin.y);
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitLeft:(id)object forView:(UIView *)view {
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation(-(imageView.frame.origin.x+imageView.frame.size.width),0);
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation(-(button.frame.origin.x+button.frame.size.width),0);
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitRight:(id)object forView:(UIView *)view {
    int screenHeight = 0;
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight)) {
        screenHeight = view.frame.size.height;
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait || UIInterfaceOrientationPortraitUpsideDown)) {
        screenHeight = view.frame.size.height;
    }
    
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation((screenHeight-imageView.frame.origin.x),0);
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation((screenHeight-button.frame.origin.x),0);
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitUpLeft:(id)object forView:(UIView *)view {
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation(-(imageView.frame.origin.x+imageView.frame.size.width),-(imageView.frame.origin.y+imageView.frame.size.height));
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation(-(button.frame.origin.x+button.frame.size.width),-(button.frame.origin.y+button.frame.size.height));
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitUpRight:(id)object forView:(UIView *)view {
    int screenHeight = 0;
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight)) {
        screenHeight = view.frame.size.height;
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait || UIInterfaceOrientationPortraitUpsideDown)) {
        screenHeight = view.frame.size.height;
    }
    
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation((screenHeight-imageView.frame.origin.x),-(imageView.frame.origin.y+imageView.frame.size.height));
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation((screenHeight-button.frame.origin.x),-(button.frame.origin.y+button.frame.size.height));
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitDownLeft:(id)object forView:(UIView *)view {
    int screenHeight = 0;
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight)) {
        screenHeight = view.frame.size.height;
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait || UIInterfaceOrientationPortraitUpsideDown)) {
        screenHeight = view.frame.size.height;
    }
    
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation(-(imageView.frame.origin.x+imageView.frame.size.width),screenHeight-imageView.frame.origin.y);
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation(-(button.frame.origin.x+button.frame.size.width),screenHeight-button.frame.origin.y);
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationExitDownRight:(id)object forView:(UIView *)view {
    int screenHeight = 0;
    
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft || UIInterfaceOrientationLandscapeRight)) {
        screenHeight = view.frame.size.height;
    } else if ([UIDevice currentDevice].orientation == UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait || UIInterfaceOrientationPortraitUpsideDown)) {
        screenHeight = view.frame.size.height;
    }
    
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        return CGAffineTransformMakeTranslation((screenHeight-imageView.frame.origin.x),screenHeight-imageView.frame.origin.y);
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        return CGAffineTransformMakeTranslation((screenHeight-button.frame.origin.x),screenHeight-button.frame.origin.y);
    } else {
        return CGAffineTransformMakeTranslation(0, 0);
    }
}

-(CGAffineTransform) getTransformationCollapse {
    return CGAffineTransformMakeScale(0.0001, 0.0001);
}

#pragma mark - Object Detections
-(BOOL) checkIfFrame:(CGRect)frameOne collidesWithFrame:(CGRect)frameTwo {
    return (CGRectIntersectsRect(frameOne, frameTwo));
}

#pragma mark - Animations
-(void) animateImageView:(UIImageView *)imageView withImagePaths:(NSArray *)arrayOfPaths withDuration:(float)duration withRepeats:(int)repeats {
    NSMutableArray * arrayOfImages = [[NSMutableArray alloc] init];
    UIImage * image;
    NSString * imagePath;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrayOfPaths objectAtIndex:0]]];
    
    for (int x = 0; x < [arrayOfPaths count]; x++) {
        imagePath = [NSString stringWithFormat:@"%@", [arrayOfPaths objectAtIndex:x]];
        image = [UIImage imageNamed:imagePath];
        [arrayOfImages addObject:image];
    }
    
    imageView.animationDuration = duration;
    imageView.animationRepeatCount = repeats;
    imageView.animationImages = arrayOfImages;
    [imageView startAnimating];
}

-(void) animateImageView:(UIImageView *)imageView withConstantImagePath:(NSString *)string withNumber:(int)first toNumber:(int)last withDuration:(float)duration withRepeats:(int)repeats {
    NSMutableArray * images = [[NSMutableArray alloc] init];
    
    for (int x = first; x < last+1; x++) {
        [images addObject:[NSString stringWithFormat:@"%@%d", string, x]];
    }
    
    NSArray * imagePaths = [NSArray arrayWithArray:images];
    
    NSMutableArray * arrayOfImages = [[NSMutableArray alloc] init];
    UIImage * image;
    NSString * imagePath;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [imagePaths objectAtIndex:0]]];
    
    for (int x = 0; x < [imagePaths count]; x++) {
        imagePath = [NSString stringWithFormat:@"%@", [imagePaths objectAtIndex:x]];
        image = [UIImage imageNamed:imagePath];
        [arrayOfImages addObject:image];
    }
    
    imageView.animationDuration = duration;
    imageView.animationRepeatCount = repeats;
    imageView.animationImages = arrayOfImages;
    [imageView startAnimating];
}

-(void) animateObjectWiggle:(id)object {
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)object;
        
        [UIView beginAnimations:@"WiggleImageView" context:nil];
        [UIView setAnimationDuration:0.14];
        [UIView setAnimationDelay:0];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:1000000];
        imageView.transform = CGAffineTransformMakeRotation(69);
        imageView.transform = CGAffineTransformMakeRotation(-69);
        [UIView commitAnimations];
    } else if ([object isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)object;
        
        [UIView beginAnimations:@"WiggleButton" context:nil];
        [UIView setAnimationDuration:0.14];
        [UIView setAnimationDelay:0];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:1000000];
        button.transform = CGAffineTransformMakeRotation(69);
        button.transform = CGAffineTransformMakeRotation(-69);
        [UIView commitAnimations];
    }
}

-(void) animateObjectOnCollision:(id)objectOne suckObject:(id)objectTwo withDelay:(float)delay withDuration:(float)duration {
    bool animationsShouldRun = TRUE;
    
    UIImageView * imageViewA; UIImageView * imageViewB;
    UIButton * buttonA; UIButton * buttonB;
    int objectForA, objectForB;
    
    if ([objectOne isKindOfClass:[UIImageView class]]) {
        imageViewA = (UIImageView *)objectOne;
        objectForA = 1;
    } else if ([objectOne isKindOfClass:[UIButton class]]) {
        buttonA = (UIButton *)objectOne;
        objectForA = 2;
    } else {
        animationsShouldRun = FALSE;
    }
    
    if ([objectTwo isKindOfClass:[UIImageView class]]) {
        imageViewB = (UIImageView *)objectTwo;
        objectForB = 1;
    } else if ([objectTwo isKindOfClass:[UIButton class]]) {
        buttonB = (UIButton *)objectTwo;
        objectForB = 2;
    } else {
        animationsShouldRun = FALSE;
    }
    
    if (animationsShouldRun == TRUE) {
        CGAffineTransform scaleDown = CGAffineTransformMakeScale(0.0001, 0.0001);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelay:delay];
        
        if (objectForA == 1) {
            if (objectForB == 1) {
                if (CGRectIntersectsRect(imageViewA.frame, imageViewB.frame)) {
                    imageViewB.center = imageViewA.center;
                    imageViewB.transform = CGAffineTransformConcat(scaleDown, rotate);
                }
            } else if (objectForB == 2) {
                if (CGRectIntersectsRect(imageViewA.frame, buttonB.frame)) {
                    buttonB.center = imageViewA.center;
                    buttonB.transform = CGAffineTransformConcat(scaleDown, rotate);
                }
            }
        } else if (objectForA == 2) {
            if (objectForB == 1) {
                if (CGRectIntersectsRect(buttonA.frame, imageViewB.frame)) {
                    imageViewB.center = buttonA.center;
                    imageViewB.transform = CGAffineTransformConcat(scaleDown, rotate);
                }
            } else if (objectForB == 2) {
                if (CGRectIntersectsRect(buttonA.frame, buttonB.frame)) {
                    buttonB.center = buttonA.center;
                    buttonB.transform = CGAffineTransformConcat(scaleDown, rotate);
                }
            }
        }
        
        [UIView commitAnimations];
    } else {
        ALog(@"Animation Object Not Recognized");
    }
}

#pragma mark - Photography
-(UIImage *) getImageWithInvertedPixelsOfImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 2);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(UIImage *) getImageWithUnsaturatedPixelsOfImage:(UIImage *)image {
	const int RED = 1, GREEN = 2, BLUE = 3;
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width*2, image.size.height*2);
    
    int width = imageRect.size.width, height = imageRect.size.height;
    
    uint32_t * pixels = (uint32_t *) malloc(width*height*sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t * rgbaPixel = (uint8_t *) &pixels[y*width+x];
            uint32_t gray = (0.3*rgbaPixel[RED]+0.59*rgbaPixel[GREEN]+0.11*rgbaPixel[BLUE]);
            
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    UIImage * resultUIImage = [UIImage imageWithCGImage:newImage scale:2 orientation:0];
    CGImageRelease(newImage);
    
    return resultUIImage;
}

-(UIImage *) getImageWithBlendedImages:(UIImage *)image1 secondImage:(UIImage *)image2 withAlpha:(float)alpha {
    CGSize size = image1.size;
    
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 2);
    [image1 drawAtPoint:CGPointZero blendMode:kCGBlendModeOverlay alpha:alpha];
    [image2 drawAtPoint:CGPointZero blendMode:kCGBlendModeOverlay alpha:alpha];
    UIImage * blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendedImage;
}

-(UIImage *) getImageWithOverlayedImage:(UIImage *)image1 overlayImage:(UIImage *)image2 withAlpha:(float)alpha {
    CGSize size = image1.size;
    
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 2);
    [image1 drawAtPoint:CGPointZero blendMode:kCGBlendModeOverlay alpha:1.0];
    [image2 drawAtPoint:CGPointZero blendMode:kCGBlendModeOverlay alpha:alpha];
    UIImage* overlayedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return overlayedImage;
}

-(UIImage *) getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha {
    CGSize size = image.size;
    
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextSetAlpha(context, alpha);
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(CGPointZero.x, CGPointZero.y, image.size.width, image.size.height));
    
    UIImage * tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

#pragma mark - Core Graphics
-(void) createCoreGraphicsContextWithFrame:(CGRect)frame {
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(frame.size, FALSE, 2.0);
    } else {
        UIGraphicsBeginImageContextWithOptions(frame.size, FALSE, 1.0);
    }
}

-(void) createCoreGraphicsContextWithFrame:(CGRect)frame withRetina:(BOOL)retina {
    if (retina == TRUE) UIGraphicsBeginImageContextWithOptions(frame.size, FALSE, 2.0);
    else UIGraphicsBeginImageContext(frame.size);
}

-(void) removeCoreGraphicsContext {
    UIGraphicsEndImageContext();
}

-(UIImage *) getImageFromCoreGraphicsContext {
    return UIGraphicsGetImageFromCurrentImageContext();
}

-(void) drawOnImageView:(UIImageView *)canvas fromLocation:(CGPoint)oldLoc toLocation:(CGPoint)newLoc withGraphicConcept:(NSString *)concept {
    [canvas.image drawInRect:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGContextScaleCTM(context, 2.0, 2.0);
    
    if ([concept isEqualToString:GRAPHIC_CONCEPT_NORMAL]) {
        CGContextMoveToPoint(context, (newLoc.x/2), newLoc.y/2);
        CGContextAddLineToPoint(context, oldLoc.x/2, oldLoc.y/2);
    } else if ([concept isEqualToString:GRAPHIC_CONCEPT_DOTTED]) {
        CGContextMoveToPoint(context, (oldLoc.x/2), (oldLoc.y/2));
        CGContextAddLineToPoint(context, oldLoc.x/2, oldLoc.y/2);
    } else if ([concept isEqualToString:GRAPHIC_CONCEPT_DOTTED_HORIZONTAL]) {
        CGContextMoveToPoint(context, (newLoc.x/2), (oldLoc.y/2));
        CGContextAddLineToPoint(context, newLoc.x/2, newLoc.y/2);
    } else if ([concept isEqualToString:GRAPHIC_CONCEPT_DOTTED_VERTICAL]) {
        CGContextMoveToPoint(context, (oldLoc.x/2), (newLoc.y/2));
        CGContextAddLineToPoint(context, newLoc.x/2, newLoc.y/2);
    }
    
    CGContextStrokePath(context);
    
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
}

-(void) drawOnImageView:(UIImageView *)canvas fromLocation:(CGPoint)oldLoc toLocation:(CGPoint)newLoc withBrush:(UIImage *)brush withBrushSize:(float)brushSize {
    [canvas.image drawInRect:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGContextScaleCTM(context, 2.0, 2.0);
    
    CGContextDrawImage(context, CGRectMake((newLoc.x/2)-(brushSize/2), (newLoc.y/2)-(brushSize/2), brushSize, brushSize), brush.CGImage);
    
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark - Encrypting and Decrypting
-(NSString *) getEncryptedString:(NSString *)string {
    NSString * result = string;
    
    for (int x = 0; x < [result length]; x++) {
        //Equation: ((((x*1700)/4)*566)/(x+1))
        
        if (x % 2 == 0) {
            result = [result stringByReplacingOccurrencesOfString:@" " withString:@"∏Æ"];
        }
        
        result = [result stringByReplacingOccurrencesOfString:@"!" withString:@"Ô"];
        result = [result stringByReplacingOccurrencesOfString:@"?" withString:@"™"];
        result = [result stringByReplacingOccurrencesOfString:@"." withString:@"˜"];
        result = [result stringByReplacingOccurrencesOfString:@"," withString:@"ı"];
        result = [result stringByReplacingOccurrencesOfString:@"/" withString:@"♦"];
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@"é"];
        
        result = [result stringByReplacingOccurrencesOfString:@"0" withString:@"ฟภมล"];
        result = [result stringByReplacingOccurrencesOfString:@"1" withString:@"ŊŋŌō"];
        result = [result stringByReplacingOccurrencesOfString:@"2" withString:@"یۍێۏ"];
        result = [result stringByReplacingOccurrencesOfString:@"3" withString:@"ې٣٤٥٦"];
        result = [result stringByReplacingOccurrencesOfString:@"4" withString:@"٦٧٨"];
        result = [result stringByReplacingOccurrencesOfString:@"5" withString:@"طظعغػ"];
        result = [result stringByReplacingOccurrencesOfString:@"6" withString:@"ؽ۩♪"];
        result = [result stringByReplacingOccurrencesOfString:@"7" withString:@"¥"];
        result = [result stringByReplacingOccurrencesOfString:@"8" withString:@"¼¼"];
        result = [result stringByReplacingOccurrencesOfString:@"9" withString:@"þÙ‰ñÞ"];
        
        result = [result stringByReplacingOccurrencesOfString:@"a" withString:@"$!"];
        result = [result stringByReplacingOccurrencesOfString:@"b" withString:@"~#"];
        result = [result stringByReplacingOccurrencesOfString:@"c" withString:@"_-*)"];
        result = [result stringByReplacingOccurrencesOfString:@"d" withString:@"?>"];
        result = [result stringByReplacingOccurrencesOfString:@"e" withString:@"}:<"];
        result = [result stringByReplacingOccurrencesOfString:@"f" withString:@"++="];
        result = [result stringByReplacingOccurrencesOfString:@"g" withString:@",`."];
        result = [result stringByReplacingOccurrencesOfString:@"h" withString:@"@^"];
        result = [result stringByReplacingOccurrencesOfString:@"i" withString:@"|"];
        result = [result stringByReplacingOccurrencesOfString:@"j" withString:@"&"];
        result = [result stringByReplacingOccurrencesOfString:@"k" withString:@"["];
        result = [result stringByReplacingOccurrencesOfString:@"l" withString:@"'µ"];
        result = [result stringByReplacingOccurrencesOfString:@"m" withString:@"√,"];
        result = [result stringByReplacingOccurrencesOfString:@"n" withString:@"å%"];
        result = [result stringByReplacingOccurrencesOfString:@"o" withString:@"±π"];
        result = [result stringByReplacingOccurrencesOfString:@"p" withString:@"∂"];
        result = [result stringByReplacingOccurrencesOfString:@"q" withString:@"çƒ"];
        result = [result stringByReplacingOccurrencesOfString:@"r" withString:@"≈"];
        result = [result stringByReplacingOccurrencesOfString:@"s" withString:@"ß"];
        result = [result stringByReplacingOccurrencesOfString:@"t" withString:@"ø"];
        result = [result stringByReplacingOccurrencesOfString:@"u" withString:@"‰œ"];
        result = [result stringByReplacingOccurrencesOfString:@"v" withString:@"∫∑"];
        result = [result stringByReplacingOccurrencesOfString:@"w" withString:@"–≠"];
        result = [result stringByReplacingOccurrencesOfString:@"x" withString:@"«"];
        result = [result stringByReplacingOccurrencesOfString:@"y" withString:@"˘¬"];
        result = [result stringByReplacingOccurrencesOfString:@"z" withString:@"Ω†"];
        
        result = [result stringByReplacingOccurrencesOfString:@"A" withString:@"£"];
        result = [result stringByReplacingOccurrencesOfString:@"B" withString:@"∞"];
        result = [result stringByReplacingOccurrencesOfString:@"C" withString:@"¡"];
        result = [result stringByReplacingOccurrencesOfString:@"D" withString:@"¶〇"];
        result = [result stringByReplacingOccurrencesOfString:@"E" withString:@"•"];
        result = [result stringByReplacingOccurrencesOfString:@"F" withString:@"ª"];
        result = [result stringByReplacingOccurrencesOfString:@"G" withString:@"·"];
        result = [result stringByReplacingOccurrencesOfString:@"H" withString:@"‡"];
        result = [result stringByReplacingOccurrencesOfString:@"I" withString:@"›▼×"];
        result = [result stringByReplacingOccurrencesOfString:@"J" withString:@"€"];
        result = [result stringByReplacingOccurrencesOfString:@"K" withString:@"ﬂ"];
        result = [result stringByReplacingOccurrencesOfString:@"L" withString:@"°"];
        result = [result stringByReplacingOccurrencesOfString:@"M" withString:@"⁄メ"];
        result = [result stringByReplacingOccurrencesOfString:@"N" withString:@"¢"];
        result = [result stringByReplacingOccurrencesOfString:@"O" withString:@"§"];
        result = [result stringByReplacingOccurrencesOfString:@"P" withString:@"≠"];
        result = [result stringByReplacingOccurrencesOfString:@"Q" withString:@"‘"];
        result = [result stringByReplacingOccurrencesOfString:@"R" withString:@"¿ธ"];
        result = [result stringByReplacingOccurrencesOfString:@"S" withString:@"¸"];
        result = [result stringByReplacingOccurrencesOfString:@"T" withString:@"„"];
        result = [result stringByReplacingOccurrencesOfString:@"U" withString:@"ω"];
        result = [result stringByReplacingOccurrencesOfString:@"V" withString:@"Φ"];
        result = [result stringByReplacingOccurrencesOfString:@"W" withString:@"＾ۈۉ￣ۊۋ乂ی"];
        result = [result stringByReplacingOccurrencesOfString:@"X" withString:@"ミ"];
        result = [result stringByReplacingOccurrencesOfString:@"Y" withString:@"ヘ"];
        result = [result stringByReplacingOccurrencesOfString:@"Z" withString:@"□"];
    }
    
    return result;
}

-(NSString *) getDecryptedString:(NSString *)string {
    NSString * result = string;
    
    for (int x = 0; x < [result length]; x++) {
        //Equation: ((((x*1700)/4)*566)/(x+1))
        
        result = [result stringByReplacingOccurrencesOfString:@"∏Æ" withString:@" "];
        
        result = [result stringByReplacingOccurrencesOfString:@"Ô" withString:@"!"];
        result = [result stringByReplacingOccurrencesOfString:@"™" withString:@"?"];
        result = [result stringByReplacingOccurrencesOfString:@"˜" withString:@"."];
        result = [result stringByReplacingOccurrencesOfString:@"ı" withString:@","];
        result = [result stringByReplacingOccurrencesOfString:@"♦" withString:@"/"];
        result = [result stringByReplacingOccurrencesOfString:@"é" withString:@"-"];
        
        result = [result stringByReplacingOccurrencesOfString:@"ฟภมล" withString:@"0"];
        result = [result stringByReplacingOccurrencesOfString:@"ŊŋŌō" withString:@"1"];
        result = [result stringByReplacingOccurrencesOfString:@"یۍێۏ" withString:@"2"];
        result = [result stringByReplacingOccurrencesOfString:@"ې٣٤٥٦" withString:@"3"];
        result = [result stringByReplacingOccurrencesOfString:@"٦٧٨" withString:@"4"];
        result = [result stringByReplacingOccurrencesOfString:@"طظعغػ" withString:@"5"];
        result = [result stringByReplacingOccurrencesOfString:@"ؽ۩♪" withString:@"6"];
        result = [result stringByReplacingOccurrencesOfString:@"¥" withString:@"7"];
        result = [result stringByReplacingOccurrencesOfString:@"¼¼" withString:@"8"];
        result = [result stringByReplacingOccurrencesOfString:@"þÙ‰ñÞ" withString:@"9"];
        
        result = [result stringByReplacingOccurrencesOfString:@"$!" withString:@"a"];
        result = [result stringByReplacingOccurrencesOfString:@"~#" withString:@"b"];
        result = [result stringByReplacingOccurrencesOfString:@"_-*)" withString:@"c"];
        result = [result stringByReplacingOccurrencesOfString:@"?>" withString:@"d"];
        result = [result stringByReplacingOccurrencesOfString:@"}:<" withString:@"e"];
        result = [result stringByReplacingOccurrencesOfString:@"++=" withString:@"f"];
        result = [result stringByReplacingOccurrencesOfString:@",`." withString:@"g"];
        result = [result stringByReplacingOccurrencesOfString:@"@^" withString:@"h"];
        result = [result stringByReplacingOccurrencesOfString:@"|" withString:@"i"];
        result = [result stringByReplacingOccurrencesOfString:@"&" withString:@"j"];
        result = [result stringByReplacingOccurrencesOfString:@"[" withString:@"k"];
        result = [result stringByReplacingOccurrencesOfString:@"'µ" withString:@"l"];
        result = [result stringByReplacingOccurrencesOfString:@"√," withString:@"m"];
        result = [result stringByReplacingOccurrencesOfString:@"å%" withString:@"n"];
        result = [result stringByReplacingOccurrencesOfString:@"±π" withString:@"o"];
        result = [result stringByReplacingOccurrencesOfString:@"∂" withString:@"p"];
        result = [result stringByReplacingOccurrencesOfString:@"çƒ" withString:@"q"];
        result = [result stringByReplacingOccurrencesOfString:@"≈" withString:@"r"];
        result = [result stringByReplacingOccurrencesOfString:@"ß" withString:@"s"];
        result = [result stringByReplacingOccurrencesOfString:@"ø" withString:@"t"];
        result = [result stringByReplacingOccurrencesOfString:@"‰œ" withString:@"u"];
        result = [result stringByReplacingOccurrencesOfString:@"∫∑" withString:@"v"];
        result = [result stringByReplacingOccurrencesOfString:@"–≠" withString:@"w"];
        result = [result stringByReplacingOccurrencesOfString:@"«" withString:@"x"];
        result = [result stringByReplacingOccurrencesOfString:@"˘¬" withString:@"y"];
        result = [result stringByReplacingOccurrencesOfString:@"Ω†" withString:@"z"];
        
        result = [result stringByReplacingOccurrencesOfString:@"£" withString:@"A"];
        result = [result stringByReplacingOccurrencesOfString:@"∞" withString:@"B"];
        result = [result stringByReplacingOccurrencesOfString:@"¡" withString:@"C"];
        result = [result stringByReplacingOccurrencesOfString:@"¶〇" withString:@"D"];
        result = [result stringByReplacingOccurrencesOfString:@"•" withString:@"E"];
        result = [result stringByReplacingOccurrencesOfString:@"ª" withString:@"F"];
        result = [result stringByReplacingOccurrencesOfString:@"·" withString:@"G"];
        result = [result stringByReplacingOccurrencesOfString:@"‡" withString:@"H"];
        result = [result stringByReplacingOccurrencesOfString:@"›▼×" withString:@"I"];
        result = [result stringByReplacingOccurrencesOfString:@"€" withString:@"J"];
        result = [result stringByReplacingOccurrencesOfString:@"ﬂ" withString:@"K"];
        result = [result stringByReplacingOccurrencesOfString:@"°" withString:@"L"];
        result = [result stringByReplacingOccurrencesOfString:@"⁄メ" withString:@"M"];
        result = [result stringByReplacingOccurrencesOfString:@"¢" withString:@"N"];
        result = [result stringByReplacingOccurrencesOfString:@"§" withString:@"O"];
        result = [result stringByReplacingOccurrencesOfString:@"≠" withString:@"P"];
        result = [result stringByReplacingOccurrencesOfString:@"‘" withString:@"Q"];
        result = [result stringByReplacingOccurrencesOfString:@"¿ธ" withString:@"R"];
        result = [result stringByReplacingOccurrencesOfString:@"¸" withString:@"S"];
        result = [result stringByReplacingOccurrencesOfString:@"„" withString:@"T"];
        result = [result stringByReplacingOccurrencesOfString:@"ω" withString:@"U"];
        result = [result stringByReplacingOccurrencesOfString:@"Φ" withString:@"V"];
        result = [result stringByReplacingOccurrencesOfString:@"＾ۈۉ￣ۊۋ乂ی" withString:@"W"];
        result = [result stringByReplacingOccurrencesOfString:@"ミ" withString:@"X"];
        result = [result stringByReplacingOccurrencesOfString:@"ヘ" withString:@"Y"];
        result = [result stringByReplacingOccurrencesOfString:@"□" withString:@"Z"];
    }
    
    return result;
}

#pragma mark - HTML Parsing
-(NSString *) getContentsOfURL:(NSString *)address {
    return [NSString stringWithContentsOfURL:[NSURL URLWithString:address] encoding:1 error:nil];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

#pragma mark - Notification Center
-(void) scheduleNotificationWithDate:(NSDate *)date withMessage:(NSString *)message withSlideToUnlockMessage:(NSString *)slideMessage withDictionary:(NSDictionary *)dictionary withSoundName:(NSString *)soundName withBadge:(BOOL)badge {
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = message;
    localNotification.alertAction = slideMessage;
    
    if ([soundName isEqualToString:NOTIFICATION_SOUND_DEFAULT]) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    } else {
        localNotification.soundName = soundName;
    }
    
    if (badge) localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber+1;
    
    localNotification.userInfo = dictionary;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - File Storage
-(int) getCountOfAllFilesInDirectory:(NSString *)directory {
    return (int)[[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil] count];
}

-(NSString *) getListOfFilesInDirectoryInString:(NSString *)directory subFiles:(BOOL)subFiles {
    NSString * result = @"";
    NSString * startDivider = @"\n______________________________\n";
    NSString * endDivider = @"\n______________________________";
    
    NSArray * files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil];
    
    if ([files count] > 0) {
        for (int x = 0; x < [files count]; x++) {
            if (x == 0) {
                if ([[files objectAtIndex:x] pathExtension].length == 0) {
                    result = [startDivider stringByAppendingString:[NSString stringWithFormat:@"\n%@<%@>", result, [files objectAtIndex:x]]];
                } else {
                    result = [startDivider stringByAppendingString:[NSString stringWithFormat:@"\n%@%@", result, [files objectAtIndex:x]]];
                }
                
                if ([[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound) {
                    if (x+1 < [files count] && ([[files objectAtIndex:x+1]rangeOfString:@"/"].location == NSNotFound)) {
                        result = [result stringByAppendingFormat:@"\n"];
                    }
                }
            } else {
                if ([[files objectAtIndex:x] pathExtension].length == 0 && [[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound) {
                    result = [NSString stringWithFormat:@"%@\n<%@>", result, [files objectAtIndex:x]];
                } else if ([[files objectAtIndex:x] rangeOfString:@"/"].location != NSNotFound && subFiles == TRUE) {
                    result = [NSString stringWithFormat:@"%@\n\t%@", result, [files objectAtIndex:x]];
                } else if ([[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound && subFiles == TRUE) {
                    result = [NSString stringWithFormat:@"%@%@", result, [files objectAtIndex:x]];
                } else if ([[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound && subFiles == FALSE) {
                    result = [NSString stringWithFormat:@"%@\n%@", result, [files objectAtIndex:x]];
                }
                
                if ([[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound) {
                    result = [result stringByAppendingFormat:@""];
                } else if ((x != [files count]-1) && ([[files objectAtIndex:x] rangeOfString:@"/"].location != NSNotFound && [[files objectAtIndex:x+1] rangeOfString:@"/"].location == NSNotFound)) {
                    result = [result stringByAppendingFormat:@"\n"];
                }
                
                if ([[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound) {
                    if (x+1 < [files count] && ([[files objectAtIndex:x+1]rangeOfString:@"/"].location == NSNotFound)) {
                        result = [result stringByAppendingFormat:@"\n"];
                    }
                }
                
                if ((x+1 < [files count]) && [[files objectAtIndex:x] rangeOfString:@"/"].location == NSNotFound && [[files objectAtIndex:x-1] pathExtension].length == 0 && ([[files objectAtIndex:x+1] rangeOfString:@"/"].location != NSNotFound || [[files objectAtIndex:x+1] pathExtension].length > 0) && subFiles == TRUE) {
                    result = [result stringByAppendingFormat:@"\n"];
                }
            }
        }
        result = [result stringByAppendingString:endDivider];
    } else {
        ALog(@"No items found in this directory");
    }
    
    return result;
}

-(NSArray *) getListOfFilesInDirectoryInArray:(NSString *)directory subFiles:(BOOL)subFiles {
    NSArray * result;
    
    result = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    
    return result;
}

-(NSString *) getPathForFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    return [NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension];
}

-(NSArray *) getObjectsInDirectory:(NSString *)directory {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    
    NSArray * result = [fm contentsOfDirectoryAtPath:directory error:&error];
    
    return result;
}

-(NSString *) getTextFromFileInResources:(NSString *)fileName ofType:(NSString *)extension {
    NSString * result;
    
    if ([[NSBundle mainBundle] pathForResource:fileName ofType:extension]) {
        result = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:extension] encoding:NSUTF8StringEncoding error:nil];
    } else {
        ALog(@"File Not Found");
        result = @"";
    }
    
    return result;
}

-(NSString *) getTextFromFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSString * result;
    
    NSString * fileAlias = [NSString stringWithFormat:@"%@.%@", fileName, extension];
    NSString * filePath = [directoryPath stringByAppendingPathComponent:fileAlias];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[directoryPath stringByAppendingPathComponent:fileAlias]]) {
        result = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else {
        ALog(@"File Not Found");
        result = @"";
    }
    
    return result;
}

-(void) writeText:(NSString *)text toFile:(NSString *)fileName ofType:(NSString *)extension appending:(BOOL)appending inDirectory:(NSString *)directory {
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, extension]];
    
    if (appending == TRUE) {
        NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]];
        
        [fileHandle writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [text writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void) saveFile:(NSString *)fileName ofType:(NSString *)extension fromURL:(NSString *)fileIndexPath inDirectory:(NSString *)directoryPath {
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileIndexPath]];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension] atomically:YES];
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(void) saveImageToPhotoAlbums:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

-(void) saveImagesToPhotoAlbums:(NSArray *)images {
    for (int x = 0; x < [images count]; x++) {
        UIImage * image = [images objectAtIndex:x];
        
        if (image != nil) UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

-(void) saveImageFromURL:(NSString *)imageURL withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    UIImage * image = [UIImage imageWithData:imageData];
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(void) saveImageFromURLToPhotoAlbums:(NSString *)imageURL {
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage * image = [UIImage imageWithData:imageData];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

-(void) saveImagesFromURLsToPhotoAlbums:(NSArray *)imageURLs {
    NSData * imageData;
    UIImage * image = [[UIImage alloc] init];
    
    for (int x = 0; x < [imageURLs count]; x++) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURLs objectAtIndex:x]]];
        if (imageData != nil) image = [UIImage imageWithData:imageData];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

-(BOOL) checkIfFileExistsInResources:(NSString *)fileName ofType:(NSString *)extension {
    bool result;
    
    if ([[NSBundle mainBundle] pathForResource:fileName ofType:extension]) {
        result = TRUE;
    } else {
        result = FALSE;
    }
    
    return result;
}

-(BOOL) checkIfFileExists:(NSString *)fileName ofType:(NSString *)extension inDirectoryPath:(NSString *)directoryPath {
    bool result;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, extension]]]) {
        result = TRUE;
    } else {
        result = FALSE;
    }
    
    return result;
}

-(BOOL) checkIfFilesExist:(NSArray *)fileNames ofType:(NSString *)extension inDirectoryPath:(NSString *)directoryPath {
    bool result = TRUE;
    
    for (int x = 0; x < [fileNames count]; x++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [fileNames objectAtIndex:x], extension]]] && result == TRUE) {
            result = TRUE;
        } else {
            result = FALSE;
        }
    }
    
    return result;
}

-(void) createDirectory:(NSString *)directoryName inDirectory:(NSString *)directoryPath {
    NSString * directoryAlias = [directoryPath stringByAppendingPathComponent:directoryName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryAlias]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryAlias withIntermediateDirectories:FALSE attributes:nil error:nil];
        ALog(@"Directory created with name: %@", directoryName);
    } else {
        ALog(@"Directory \"%@\" already exists", directoryName);
    }
}

-(void) createDirectories:(NSArray *)directoriesNames inDirectory:(NSString *)directoryPath {
    NSString * log = [NSString stringWithFormat:@"Directories created: %d\n", (int)[directoriesNames count]];
    
    for (int x = 0; x < [directoriesNames count]; x++) {
        NSString * directoryAlias = [directoryPath stringByAppendingPathComponent:[directoriesNames objectAtIndex:x]];
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryAlias withIntermediateDirectories:FALSE attributes:nil error:nil];
        log = [log stringByAppendingString:[NSString stringWithFormat:@"%d: %@\n", x, [directoriesNames objectAtIndex:x]]];
    }
    
    ALog(@"%@", log);
}

-(void) createStandardDirectoriesWhileRemovingPreviousFiles:(BOOL)removePreviousFiles {
    NSArray * directoriesNames = [NSArray arrayWithObjects:@"Images", @"Audio", @"Text", @"XML", @"Other", SAFE_DIRECTORYNAME, nil];
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (removePreviousFiles == TRUE) {
        NSFileManager * fileManager = [[NSFileManager alloc] init];
        for (NSString * file in [fileManager contentsOfDirectoryAtPath:directoryPath error:nil]) {
            if ((![file isEqualToString:[NSString stringWithFormat:@"%@.txt", LOG_FILENAME]]) && (![file isEqualToString:[NSString stringWithFormat:@"%@", SAFE_DIRECTORYNAME]])) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directoryPath, file] error:nil];
            }
        }
    }
    
    NSString * log = @"";
    NSMutableArray * directoriesCreated = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < [directoriesNames count]; x++) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [directoriesNames objectAtIndex:x]]]]) {
            NSString * directoryAlias = [directoryPath stringByAppendingPathComponent:[directoriesNames objectAtIndex:x]];
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryAlias withIntermediateDirectories:FALSE attributes:nil error:nil];
            log = [log stringByAppendingString:[NSString stringWithFormat:@"%d: %@\n", x+1, [directoriesNames objectAtIndex:x]]];
            [directoriesCreated addObject:[directoriesNames objectAtIndex:x]];
        }
    }
    
    log = [[NSString stringWithFormat:@"Directories Created: %d\n", (int)[directoriesCreated count]] stringByAppendingString:log];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.%@", LOG_FILENAME, @"txt"];
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [directory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [@"" writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
    }
    
    ALog(@"%@", log);
}

-(void) removeDirectory:(NSString *)directoryName inDirectory:(NSString *)directory {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", directoryName]]]) {
        BOOL itemRemoved = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, directoryName] error:&error];
        if (itemRemoved == TRUE) {
            ALog(@"Directory \"%@\" Removed", directoryName);
        } else {
            ALog(@"Directory \"%@\" Removal Failed", directoryName);
        }
    } else {
        ALog(@"Directory \"%@\" does not exist", directoryName);
    }
}

-(void) removeDirectories:(NSArray *)directoriesNames inDirectory:(NSString *)directory {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSString * directoryName;
    
    for (int x = 0; x < [directoriesNames count]; x++) {
        directoryName = [directoriesNames objectAtIndex:x];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", directoryName]]]) {
            BOOL itemRemoved = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, directoryName] error:&error];
            if (itemRemoved == TRUE) {
                ALog(@"Directory \"%@\" Removed", directoryName);
            } else {
                ALog(@"Directory \"%@\" Removal Failed", directoryName);
            }
        } else {
            ALog(@"Directory \"%@\" does not exist", directoryName);
        }
    }
}

-(void) removeFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directory {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, extension]]]) {
        BOOL itemRemoved = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.%@", directory, fileName, extension] error:&error];
        if (itemRemoved == TRUE) {
            ALog(@"Item \"%@\" Removed", fileName);
        } else {
            ALog(@"Item \"%@\" Removal Failed", fileName);
        }
    } else {
        ALog(@"Item \"%@\" does not exist", fileName);
    }
}

-(void) removeAllFilesInDocumentsDirectory {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for (NSString * file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        if ((![file isEqualToString:[NSString stringWithFormat:@"%@.txt", LOG_FILENAME]]) && (![file isEqualToString:[NSString stringWithFormat:@"%@", SAFE_DIRECTORYNAME]])) {
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        }
    }
    
    if ([[fileManager contentsOfDirectoryAtPath:directory error:&error] count] == 0) {
        ALog(@"Files Removed");
    }
}

-(void) removeAllFilesInDirectory:(NSString *)directory includeSubDirectories:(BOOL)inclusion {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    if (inclusion == TRUE) {
        for (NSString * file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
            if ((![file isEqualToString:[NSString stringWithFormat:@"%@.txt", LOG_FILENAME]]) && (![file isEqualToString:[NSString stringWithFormat:@"%@", SAFE_DIRECTORYNAME]])) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
            }
        }
    } else {
        NSString * file;
        for (file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
            if ([file pathExtension].length > 0 && (![file isEqualToString:[NSString stringWithFormat:@"%@.txt", LOG_FILENAME]]) && (![file isEqualToString:[NSString stringWithFormat:@"%@", SAFE_DIRECTORYNAME]])) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
            }
        }
    }
    
    if ([[fileManager contentsOfDirectoryAtPath:directory error:&error] count] == 0) {
        ALog(@"Files Removed");
    }
}

-(void) removeAllFilesInDocumentsDirectoryAbsolutely {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for (NSString * file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
    }
    
    if ([[fileManager contentsOfDirectoryAtPath:directory error:&error] count] == 0) {
        ALog(@"Files Removed");
    }
}

#pragma mark - User Identity
-(void) createUserIDNumericRandom {
    NSString * userID = @"";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userID"] == nil) {
        for (int x = 0; x < USER_IDENTITY_LENGTH; x++) {
            int y = (arc4random() % 10);
            userID = [userID stringByAppendingFormat:@"%d", y];
        }
        
        [defaults setObject:userID forKey:@"userID"];
    } else {
        ALog(@"User ID has already been created.");
    }
}

-(void) createUserIDAlphaRandom {
    NSString * userID = @"";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userID"] == nil) {
        for (int x = 0; x < USER_IDENTITY_LENGTH; x++) {
            NSString * y = @"";
            
            NSMutableArray * arrayWithText = [[NSMutableArray alloc] init];
            NSString * lettersToUse = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
            
            NSArray * arrayWithAlphabet = [lettersToUse componentsSeparatedByString:@" "];
            int randomNum;
            
            [arrayWithText addObject:[arrayWithAlphabet objectAtIndex:6]];
            randomNum = ((arc4random() % 25)+1);
            NSString * letter = [NSString stringWithFormat:@"%@", [arrayWithAlphabet objectAtIndex:randomNum]];
            y = [y stringByAppendingString:letter];
            
            userID = [userID stringByAppendingFormat:@"%@", y];
        }
        [defaults setObject:userID forKey:@"userID"];
    } else {
        ALog(@"User ID has already been created.");
    }
}

-(void) createUserIDAlphaNumericRandom {
    NSString * userID = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userID"] == nil) {
        for (int x = 0; x < USER_IDENTITY_LENGTH; x++) {
            int rand = (arc4random() % 2)+1;
            
            if (rand == 1) {
                int y = (arc4random() % 10);
                userID = [userID stringByAppendingFormat:@"%d", y];
            } else if (rand == 2) {
                NSString * y = @"";
                
                NSMutableArray * arrayWithText = [[NSMutableArray alloc] init];
                NSString * lettersToUse = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
                
                NSArray * arrayWithAlphabet = [lettersToUse componentsSeparatedByString:@" "];
                int randomNum;
                
                [arrayWithText addObject:[arrayWithAlphabet objectAtIndex:6]];
                randomNum = ((arc4random() % 25)+1);
                NSString * letter = [NSString stringWithFormat:@"%@", [arrayWithAlphabet objectAtIndex:randomNum]];
                y = [y stringByAppendingString:letter];
                
                userID = [userID stringByAppendingFormat:@"%@", y];
            }
        }
        [defaults setObject:userID forKey:@"userID"];
    } else {
        ALog(@"User ID has already been created.");
    }
}

-(void) removeUserID {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userID"] != nil) {
        [defaults setValue:nil forKey:@"userID"];
        [defaults removeObjectForKey:@"userID"];
    } else {
        ALog(@"No user ID to remove.");
    }
}

-(NSString *) getUserID {
    NSString * result = @"";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userID"] != nil) {
        result = [defaults objectForKey:@"userID"];
    } else {
        result = nil;
        ALog(@"No user ID has been created.");
    }
    
    return result;
}

#pragma mark - User Defaults
-(void) saveIntegerToUserDefaults:(int)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveBoolToUserDefaults:(bool)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveDoubleToUserDefaults:(double)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveStringToUserDefaults:(NSString *)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveArrayToUserDefaults:(NSArray *)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:x forKey:key];
    [userDefaults synchronize];
}

-(void) saveURLToUserDefaults:(NSURL *)url forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setURL:url forKey:key];
    [userDefaults synchronize];
}

-(void) saveImageToUserDefaults:(UIImage *)image ofType:(NSString *)extension forKey:(NSString *)key {
    NSData * data;
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        data = UIImagePNGRepresentation(image);
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"]) {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
}

-(void) saveObjectToUserDefaults:(id)object forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

-(int) loadIntegerFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[userDefaults integerForKey:key];
}

-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}

-(bool) loadBoolFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

-(double) loadDoubleFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults doubleForKey:key];
}

-(NSString *) loadStringFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

-(NSArray *) loadArrayFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

-(NSURL *) loadURLFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults URLForKey:key];
}

-(UIImage *) loadImageFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [UIImage imageWithData:[userDefaults objectForKey:key]];
}

-(id) loadObjectFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

-(void) clearValueForKeyInUserDefaults:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:key];
    [userDefaults synchronize];
}

-(void) clearValuesInUserDefaults {
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
}

-(void) removeObjectForKeyInUserDefaults:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

#pragma mark - Alerts
-(void) showAlertViewWithTitle:(NSString *)title withText:(NSString *)text withCancelButtonName:(NSString *)cancelButtonName {
    if (cancelButtonName == nil) cancelButtonName = @"Dismiss";
    
    NSString * titleLowercase = [title substringFromIndex:1];
    char titleUppercase = [[title uppercaseString] characterAtIndex:0];
    NSString * titleCombination = [NSString stringWithFormat:@"%c%@", titleUppercase, titleLowercase];
    
    NSString * textLowercase = [text substringFromIndex:1];
    char textUppercase = [[text uppercaseString] characterAtIndex:0];
    NSString * textCombination = [NSString stringWithFormat:@"%c%@", textUppercase, textLowercase];
    
    NSString * cancelButtonNameLowercase = [cancelButtonName substringFromIndex:1];
    char cancelButtonNameUppercase = [[cancelButtonName uppercaseString] characterAtIndex:0];
    NSString * cancelButtonNamecombination = [NSString stringWithFormat:@"%c%@", cancelButtonNameUppercase, cancelButtonNameLowercase];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:titleCombination message:textCombination delegate:self cancelButtonTitle:cancelButtonNamecombination otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Date
-(NSDate *) getCurrentDate {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:dateComponents];
}

-(NSArray *) getCurrentDateInArrayWithMilitaryTime:(BOOL)militaryTime {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int currentHour;
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    
    if (militaryTime == TRUE) {
        currentHour = (int)[[calendar components:(NSHourCalendarUnit) fromDate:[NSDate date]] hour];
    } else {
        currentHour = (int)[[calendar components:(NSHourCalendarUnit) fromDate:[NSDate date]] hour];
        if (currentHour > 12) (currentHour=currentHour-12);
    }
    
    NSArray * result = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"Year: %d", (int)[dateComponents year]],
                        [NSString stringWithFormat:@"Month: %d", (int)[dateComponents month]],
                        [NSString stringWithFormat:@"Day: %d", (int)[dateComponents day]],
                        [NSString stringWithFormat:@"Hour: %d", currentHour],
                        [NSString stringWithFormat:@"Minute: %d", (int)[dateComponents minute]],
                        [NSString stringWithFormat:@"Second: %d", (int)[dateComponents second]],
                        [NSString stringWithFormat:@"Weekday: %d", (int)[dateComponents weekday]], nil];
    
    return result;
}

-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:month];
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:day];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:year];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year hour:(int)hour minute:(int)minute {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:month];
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:day];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:year];
    [dateFormatter setDateFormat:@"HH"];
    [dateComponents setHour:hour];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMinute:minute];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year hour:(int)hour minute:(int)minute second:(int)second {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:month];
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:day];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:year];
    [dateFormatter setDateFormat:@"HH"];
    [dateComponents setHour:hour];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMinute:minute];
    [dateFormatter setDateFormat:@"SS"];
    [dateComponents setSecond:second];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSDate *) getDateOfCurrentDateAfterNumberOfDaysPassed:(int)daysPassed {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:[dateComponents day]+daysPassed];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSDate *) getDateOfDate:(NSDate *)date afterNumberOfDaysPassed:(int)daysPassed {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:[dateComponents day]+daysPassed];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSDate *) getDateOfDate:(NSDate *)date beforeNumberOfDaysPassed:(int)daysPassed {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:[dateComponents day]-daysPassed];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

/*-(NSArray *) getWeekendDatesInMonth:(int)month inYear:(int)year contained:(BOOL)contained {
 NSArray * result = [[NSArray alloc] init];
 NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
 
 NSCalendar * calendar = [NSCalendar currentCalendar];
 NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSWeekOfMonthCalendarUnit | NSWeekCalendarUnit) fromDate:[NSDate date]];
 [dateComponents setMonth:month];
 
 [dateComponents setYear:[dateComponents year]];
 [dateComponents setMonth:[dateComponents month]+1];
 [dateComponents setDay:0];
 
 NSDate * tempDate = [calendar dateFromComponents:dateComponents];
 NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"dd"];
 
 int daysInMonth = [[dateFormatter stringFromDate:tempDate] intValue];
 
 NSMutableArray * weekBeginnings = [[NSMutableArray alloc] init];
 NSMutableArray * weekEndings = [[NSMutableArray alloc] init];
 
 [dateFormatter setDateFormat:@"MM"];
 [dateFormatter setDateFormat:@"DD"];
 [dateFormatter setDateFormat:@"YYYY"];
 
 for (int x = 1; x <= daysInMonth; x++) {
 [dateComponents setMonth:month];
 [dateComponents setDay:x];
 [dateComponents setYear:year];
 
 NSDate * date = [calendar dateFromComponents:dateComponents];
 
 NSDateComponents * newDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSWeekOfMonthCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
 
 if (x == 1) {
 [weekBeginnings addObject:[NSNumber numberWithInt:1]];
 } else if (x == daysInMonth) {
 [weekEndings addObject:[NSNumber numberWithInt:daysInMonth]];
 } else {
 if ([newDateComponents weekday] == 1) [weekBeginnings addObject:[NSNumber numberWithInt:x]];
 if ([newDateComponents weekday] == 7) [weekEndings addObject:[NSNumber numberWithInt:x]];
 }
 }
 
 for (int x = 0; x < [weekEndings count]; x++) {
 int weekBeginning = [[weekBeginnings objectAtIndex:x] intValue];
 int weekEnding = [[weekEndings objectAtIndex:x] intValue];
 
 [dateComponents setMonth:month];
 [dateComponents setDay:weekBeginning];
 [dateComponents setYear:year];
 
 NSDate * date1 = [calendar dateFromComponents:dateComponents];
 
 [dateComponents setMonth:month];
 [dateComponents setDay:weekEnding];
 [dateComponents setYear:year];
 
 NSDate * date2 = [calendar dateFromComponents:dateComponents];
 
 NSArray * dates = [NSArray arrayWithObjects:date1, date2, nil];
 
 [mutableArray addObject:dates];
 }
 
 result = [mutableArray copy];
 
 return result;
 }*/

-(NSDate *) getDateOfCurrentDateBeforeNumberOfDaysPassed:(int)daysPassed {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:[dateComponents day]-daysPassed];
    
    NSDate * result = [calendar dateFromComponents:dateComponents];
    
    return result;
}

-(NSArray *) getArrayFromDate:(NSDate *)date dateType:(NSArray *)dateType {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSArray * result;
    NSMutableArray * format = [[NSMutableArray alloc] init];
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger weekday = [dateComponents weekday];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    if (dateType != nil) {
        for (int x = 0; x < [dateType count]; x++) {
            if ([[dateType objectAtIndex:x] isEqualToString:@"Y"]) {
                [format addObject:[NSNumber numberWithInt:(int)year]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"M"]) {
                [format addObject:[NSNumber numberWithInt:(int)month]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"D"]) {
                [format addObject:[NSNumber numberWithInt:(int)day]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"W"]) {
                [format addObject:[NSNumber numberWithInt:(int)weekday]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"h"]) {
                [format addObject:[NSNumber numberWithInt:(int)hour]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"m"]) {
                [format addObject:[NSNumber numberWithInt:(int)minute]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"s"]) {
                [format addObject:[NSNumber numberWithInt:(int)second]];
            } else if ([[dateType objectAtIndex:x] isEqualToString:@"xx"]) {
                [format addObject:[NSString stringWithFormat:@"Year: %d", (int)year]];
                [format addObject:[NSString stringWithFormat:@"Month: %d", (int)month]];
                [format addObject:[NSString stringWithFormat:@"Day: %d", (int)day]];
                [format addObject:[NSString stringWithFormat:@"Weekday: %d", (int)weekday]];
                [format addObject:[NSString stringWithFormat:@"Hour: %d", (int)hour]];
                [format addObject:[NSString stringWithFormat:@"Minute: %d", (int)minute]];
                [format addObject:[NSString stringWithFormat:@"Second: %d", (int)second]];
            }
        }
    } else {
        [format addObject:[NSNumber numberWithInt:(int)year]];
        [format addObject:[NSNumber numberWithInt:(int)month]];
        [format addObject:[NSNumber numberWithInt:(int)day]];
        [format addObject:[NSNumber numberWithInt:(int)weekday]];
        [format addObject:[NSNumber numberWithInt:(int)hour]];
        [format addObject:[NSNumber numberWithInt:(int)minute]];
        [format addObject:[NSNumber numberWithInt:(int)second]];
    }
    
    result = [NSArray arrayWithArray:format];
    
    return result;
}

-(int) getCurrentYear {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]] year];
}

-(int) getCurrentMonth {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]] month];
}

-(int) getCurrentDay {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSDayCalendarUnit) fromDate:[NSDate date]] day];
}

-(int) getCurrentHourWithMilitaryTime:(BOOL)militaryTime {
    int result;
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if (militaryTime == TRUE) {
        result = (int)[[calendar components:(NSHourCalendarUnit) fromDate:[NSDate date]] hour];
    } else {
        result = (int)[[calendar components:(NSHourCalendarUnit) fromDate:[NSDate date]] hour];
        if (result > 12) result = result - 12;
    }
    
    return result;
}

-(int) getCurrentMinute {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSMinuteCalendarUnit) fromDate:[NSDate date]] minute];
}

-(int) getCurrentSecond {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSSecondCalendarUnit) fromDate:[NSDate date]] second];
}

-(int) getCurrentWeekday {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSWeekdayCalendarUnit) fromDate:[NSDate date]] weekday];
}

-(int) getCurrentWeekOfMonth {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSWeekOfMonthCalendarUnit) fromDate:[NSDate date]] weekOfMonth];
}

-(int) getCurrentWeekOfYear {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return (int)[[calendar components:(NSWeekOfYearCalendarUnit) fromDate:[NSDate date]] weekOfYear];
}

-(int) getYearOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getMonthOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getDayOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getHourOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getMinuteOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getSecondOfDate:(NSDate *)date {
    int result = 0;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss"];
    
    result = [[dateFormatter stringFromDate:date] intValue];
    
    return result;
}

-(int) getWeekdayOfDate:(NSDate *)date {
    int result = 0;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
    
    result = (int)[dateComponents weekday];
    
    return result;
}

-(int) getWeekOfMonthOfDate:(NSDate *)date {
    int result = 0;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    
    result = (int)[dateComponents weekOfMonth];
    
    return result;
}

-(int) getWeekOfYearOfDate:(NSDate *)date {
    int result = 0;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:date];
    
    result = (int)[dateComponents weekOfYear];
    
    return result;
}

-(int) getDaysInMonth:(int)month inYear:(int)year {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    
    [dateComponents setMonth:month];
    [dateComponents setYear:year];
    
    NSDate * date = [calendar dateFromComponents:dateComponents];
    
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    return (int)daysRange.length;
}

-(int) getDaysFromDate:(NSDate *)initialDate untilDate:(NSDate *)endDate {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:initialDate] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:initialDate] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:initialDate] intValue]];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:endDate] intValue]];
    
    NSDate * reminderDate = [calendar dateFromComponents:dateComponents];
    NSTimeInterval timeInterval = [reminderDate timeIntervalSinceDate:initialDate];
    
    return roundf(timeInterval/86400);
}

-(int) getDaysFromCurrentDateUntilDay:(int)endDay inMonth:(int)endMonth inYear:(int)endYear {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    
    NSDate * initialDate = [calendar dateFromComponents:dateComponents];
    
    [dateFormatter setDateFormat:@"DD"];
    [dateComponents setDay:endDay];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:endMonth];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:endYear];
    
    NSDate * endDate = [calendar dateFromComponents:dateComponents];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:endDate] intValue]];
    
    NSDate * reminderDate = [calendar dateFromComponents:dateComponents];
    NSTimeInterval timeInterval = [reminderDate timeIntervalSinceDate:initialDate];
    
    return roundf(timeInterval/86400);
}

-(int) getDaysFromCurrentDateUntilDate:(NSDate *)endDate {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate * initialDate = [calendar dateFromComponents:dateComponents];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:[NSDate date]] intValue]];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponents setDay:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponents setMonth:[[dateFormatter stringFromDate:endDate] intValue]];
    [dateFormatter setDateFormat:@"YYYY"];
    [dateComponents setYear:[[dateFormatter stringFromDate:endDate] intValue]];
    
    NSDate * reminderDate = [calendar dateFromComponents:dateComponents];
    NSTimeInterval timeInterval = [reminderDate timeIntervalSinceDate:initialDate];
    
    return roundf(timeInterval/86400);
}

-(int) getDaysFromDay:(int)initialDay inMonth:(int)initialMonth inYear:(int)initialYear untilDay:(int)endDay inMonth:(int)endMonth inYear:(int)endYear {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents * dateComponentsA = [[NSDateComponents alloc] init];
    NSDateComponents * dateComponentsB = [[NSDateComponents alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponentsA setDay:initialDay];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponentsA setMonth:initialMonth];
    [dateFormatter setDateFormat:@"yyyy"];
    [dateComponentsA setYear:initialYear];
    
    [dateFormatter setDateFormat:@"dd"];
    [dateComponentsB setDay:endDay];
    [dateFormatter setDateFormat:@"MM"];
    [dateComponentsB setMonth:endMonth];
    [dateFormatter setDateFormat:@"yyyy"];
    [dateComponentsB setYear:endYear];
    
    NSDate * beginningDate = [calendar dateFromComponents:dateComponentsA];
    NSDate * reminderDate = [calendar dateFromComponents:dateComponentsB];
    
    NSTimeInterval timeInterval = [reminderDate timeIntervalSinceDate:beginningDate];
    
    return roundf(timeInterval/86400);
}

-(NSString *) getStringOfDateIntervalInHoursBetweenDate:(NSDate *)initialDate andDate:(NSDate *)finalDate {
    NSString * result = @"";
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSTimeInterval timeInterval = [finalDate timeIntervalSinceDate:initialDate];
    float hours = floor(timeInterval / 3600);
    float minutes = floor((timeInterval - hours*3600) / 60);
    
    result = [NSString stringWithFormat:@"%02.0f:%02.0f", hours, minutes];
    
    return result;
}

-(NSString *) getStringFromDate:(NSDate *)date dateType:(NSArray *)dateType {
    NSString * result = @"";
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSString * format = @"";
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger weekday = [dateComponents weekday];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    if (dateType != nil) {
        for (int x = 0; x < [dateType count]; x++) {
            if (x == ([dateType count]-1)) {
                if ([[dateType objectAtIndex:x] isEqualToString:@"Y"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)year];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"M"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)month];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"D"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)day];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"W"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)weekday];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"h"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)hour];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"m"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)minute];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"s"]) {
                    format = [format stringByAppendingFormat:@"%d", (int)second];
                }
            } else {
                if ([[dateType objectAtIndex:x] isEqualToString:@"Y"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)year];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"M"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)month];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"D"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)day];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"W"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)weekday];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"h"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)hour];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"m"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)minute];
                } else if ([[dateType objectAtIndex:x] isEqualToString:@"s"]) {
                    format = [format stringByAppendingFormat:@"%d|", (int)second];
                }
            }
            
            if ([[dateType objectAtIndex:x] isEqualToString:@"xx"]) {
                format = [NSString stringWithFormat:@"Year: %d, Month: %d, Day: %d, Weekday: %d, Hour: %d, Minute: %d, Second: %d", (int)year, (int)month, (int)day, (int)weekday, (int)hour, (int)minute, (int)second];
            }
        }
    } else {
        format = [NSString stringWithFormat:@"%d|%d|%d|%d|%d|%d|%d", (int)year, (int)month, (int)day, (int)weekday, (int)hour, (int)minute, (int)second];
    }
    
    result = format;
    
    return result;
}

-(NSString *) getNameOfMonth:(int)month {
    NSString * result = @"";
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    [dateComponents setMonth:month];
    
    result = [dateFormatter stringFromDate:[calendar dateFromComponents:dateComponents]];
    
    return result;
}

#pragma mark - Random
-(int) getRandomIntFromNumber:(int)min toNumber:(int)max inclusive:(BOOL)inclusive {
    int result;
    
    if (inclusive == TRUE) {
        result = (arc4random() % (max-(min-1)))+(min);
    } else {
        result = (arc4random() % (max-(min+1)))+(min+1);
    }
    
    return result;
}

-(float) getRandomFloatFromFloatNumber:(NSString *)min toFloatNumber:(NSString *)max inclusive:(BOOL)inclusive {
    float result = 0.00;
    int minimum, maximum;
    NSString * minFixed = min;
    NSString * maxFixed = max;
    
    if ([min rangeOfString:@"."].location != NSNotFound && [max rangeOfString:@"."].location != NSNotFound) {
        NSString * minDecimalsStringInitial = (NSString *) [[min componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString * maxDecimalsStringInitial = (NSString *) [[max componentsSeparatedByString:@"."] objectAtIndex:1];
        
        if (minDecimalsStringInitial.length > maxDecimalsStringInitial.length) {
            int difference = (int)(minDecimalsStringInitial.length-maxDecimalsStringInitial.length);
            
            minFixed = [min substringToIndex:((min.length-1)-difference+1)];
        } else if (minDecimalsStringInitial.length < maxDecimalsStringInitial.length) {
            int difference = (int)(maxDecimalsStringInitial.length-minDecimalsStringInitial.length);
            
            maxFixed = [max substringToIndex:((max.length-1)-difference+1)];
        }
        
        NSString * minDigitsBeforeDecimal = (NSString *) [[[NSString stringWithFormat:@"%@", minFixed] componentsSeparatedByString:@"."] objectAtIndex:0];
        NSString * minDecimalsAfterDecimal = (NSString *) [[[NSString stringWithFormat:@"%@", minFixed] componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString * maxDigitsBeforeDecimal = (NSString *) [[[NSString stringWithFormat:@"%@", maxFixed] componentsSeparatedByString:@"."] objectAtIndex:0];
        NSString * maxDecimalsAfterDecimal = (NSString *) [[[NSString stringWithFormat:@"%@", maxFixed] componentsSeparatedByString:@"."] objectAtIndex:1];
        
        int minDigits = [minDigitsBeforeDecimal intValue];
        int minDecimals = [minDecimalsAfterDecimal intValue];
        int maxDigits = [maxDigitsBeforeDecimal intValue];
        int maxDecimals = [maxDecimalsAfterDecimal intValue];
        
        minimum = [[NSString stringWithFormat:@"%d%d", minDigits, minDecimals] intValue];
        maximum = [[NSString stringWithFormat:@"%d%d", maxDigits, maxDecimals] intValue];
        
        if (inclusive == TRUE) {
            result = (arc4random() % (maximum-(minimum-1)))+(minimum);
        } else {
            result = (arc4random() % (maximum-(minimum+1)))+(minimum+1);
        }
        
        NSString * divisionFactorString = @"1";
        
        for (int x = 0; x < minDecimalsAfterDecimal.length; x++) {
            divisionFactorString = [NSString stringWithFormat:@"%@%d", divisionFactorString, 0];
        }
        
        int divisionFactor = [divisionFactorString intValue];
        
        result = result/divisionFactor;
    } else if ([min rangeOfString:@"."].location == NSNotFound && [max rangeOfString:@"."].location == NSNotFound) {
        minFixed = [NSString stringWithFormat:@"%d", [min intValue]*1000000];
        maxFixed = [NSString stringWithFormat:@"%d", [max intValue]*1000000];
        
        int minimum = [minFixed intValue];
        int maximum = [maxFixed intValue];
        
        if (inclusive == TRUE) {
            result = (arc4random() % (maximum-(minimum-1)))+(minimum);
        } else {
            result = (arc4random() % (maximum-(minimum+1)))+(minimum+1);
        }
        
        result = result/1000000;
    }
    
    if ([min floatValue] > [max floatValue]) {
        result = 0.00;
    } else if ([min floatValue] == [max floatValue]) {
        result = 0.00;
    }
    
    return result;
}

-(NSString *) getRandomStringAlphaWithLength:(int)length {
    NSString * result = @"";
    NSMutableArray * arrayWithText = [[NSMutableArray alloc] init];
    NSString * lettersToUse = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
    
    NSArray * arrayWithAlphabet = [lettersToUse componentsSeparatedByString:@" "];
    int randomNum;
    
    for (int x = 0; x < length; x++) {
        [arrayWithText addObject:[arrayWithAlphabet objectAtIndex:6]];
        randomNum = ((arc4random() % 25)+1);
        NSString * letter = [NSString stringWithFormat:@"%@", [arrayWithAlphabet objectAtIndex:randomNum]];
        result = [result stringByAppendingString:letter];
    }
    
    return result;
}

-(NSString *) getRandomStringAlphaNumericWithLength:(int)length {
    NSString * result = @"";
    NSString * userID = @"";
    
    for (int x = 0; x < length; x++) {
        int rand = (arc4random() % 2)+1;
        
        if (rand == 1) {
            int y = (arc4random() % 10);
            userID = [userID stringByAppendingFormat:@"%d", y];
        } else if (rand == 2) {
            NSString * y = @"";
            
            NSMutableArray * arrayWithText = [[NSMutableArray alloc] init];
            NSString * lettersToUse = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
            
            NSArray * arrayWithAlphabet = [lettersToUse componentsSeparatedByString:@" "];
            int randomNum;
            
            [arrayWithText addObject:[arrayWithAlphabet objectAtIndex:6]];
            randomNum = ((arc4random() % 25)+1);
            NSString * letter = [NSString stringWithFormat:@"%@", [arrayWithAlphabet objectAtIndex:randomNum]];
            y = [y stringByAppendingString:letter];
            
            userID = [userID stringByAppendingFormat:@"%@", y];
        }
    }
    result = userID;
    
    return result;
}

-(NSString *) getRandomStringNumericWithLength:(int)length {
    NSString * result = @"";
    NSString * userID = @"";
    
    for (int x = 0; x < length; x++) {
        int y = (arc4random() % 10);
        userID = [userID stringByAppendingFormat:@"%d", y];
        
    }
    
    result = userID;
    
    return result;
}

#pragma mark - Weather
-(NSString *) getCurrentWeatherConditionWithLocation:(CGPoint)location {
    NSString * lat = [NSString stringWithFormat:@"%f", location.x];
    NSString * lon = [NSString stringWithFormat:@"%f", location.y];
    
    int latitude = [lat intValue], longitude = [lon intValue];
    
    NSArray * weatherStatus = [NSArray arrayWithObjects:@"Unavailable", @"Sunny", @"Partly Cloudy", @"Cloudy", @"Mostly Cloudy", @"Clear", @"Wind", @"Rain", @"Showers", @"Thunder", @"Storm", @"Fair", @"Overcast", @"Haze", @"Fog", @"Drizzle", @"Snow", @"Thunderstorm", @"Smoke", nil];
    
    NSString * forecastURL = [NSString stringWithFormat:@"http://www.google.com/ig/api?weather=,,,%i,%i", latitude*1000000, longitude*1000000];
    NSString * forecastData = [NSString stringWithContentsOfURL:[NSURL URLWithString:forecastURL] encoding:1 error:nil];
    NSString * dataForStart = @"<current_conditions><condition data=\"";
    NSString * currentWeather;
    NSString * weatherTomorrow;
    
    if ([forecastData rangeOfString:dataForStart].location != NSNotFound && forecastData != nil) {
        NSArray * weatherArrayFeedA = [forecastData componentsSeparatedByString:@"/><temp_f data=\""];
        NSString * weatherStringFeedA = [weatherArrayFeedA objectAtIndex:0];
        NSArray * weatherArrayFeedB = [weatherStringFeedA componentsSeparatedByString:@"<condition data="];
        
        NSString * weatherToday = [weatherArrayFeedB objectAtIndex:1];
        NSArray * weatherTomorrowArrayFeedA = [forecastData componentsSeparatedByString:@"</forecast_conditions></weather></xml_api_reply>"];
        NSString * weatherTomorrowStringFeedA = [weatherTomorrowArrayFeedA objectAtIndex:0];
        NSArray * weatherTomorrowArrayFeedB = [weatherTomorrowStringFeedA componentsSeparatedByString:@"<forecast_conditions><day_of_week "];
        
        NSString * weatherTomorrowStringFeedB = [weatherTomorrowArrayFeedB objectAtIndex:2];
        NSArray * weatherTomorrowArrayFeedC = [weatherTomorrowStringFeedB componentsSeparatedByString:@"\"/></forecast_conditions>"];
        NSString * weatherTomorrowStringFeedC = [weatherTomorrowArrayFeedC objectAtIndex:0];
        NSArray * weatherTomorrowArrayFeedD = [weatherTomorrowStringFeedC componentsSeparatedByString:@"<condition data=\""];
        NSString * weatherTomorrowStringFeedD = [weatherTomorrowArrayFeedD objectAtIndex:1];
        
        weatherTomorrow = weatherTomorrowStringFeedD;
        NSLog(@"Weather Tomorrow: %@", weatherTomorrow);
        
        for (int x = 0; x < [weatherStatus count]; x++) {
            if ([weatherToday rangeOfString:[weatherStatus objectAtIndex:x]].location != NSNotFound || [weatherToday rangeOfString:[[weatherStatus objectAtIndex:x]lowercaseString]].location != NSNotFound) {
                currentWeather = [weatherStatus objectAtIndex:x];
            }
        }
        
        if (currentWeather == NULL) currentWeather = @"Unavailable";
        
    } else {
        currentWeather = @"Unavailable";
        weatherTomorrow = @"Unavailable";
        NSLog(@"Weather Tomorrow: %@", weatherTomorrow);
    }
    return currentWeather;
}

@end