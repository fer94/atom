//
//  Atom.h
//  Atomic Class
//
//  Created by Fernando Cervantes on 2/15/12.
//  Copyright (c) 2012 Fernando Cervantes. All rights reserved.
//
//  Version 1.0

#import <UIKit/UIKit.h>

#define ALog(NSString, ...) if (([[[UIDevice currentDevice].model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound) && loggingEnabled == TRUE) NSLog(NSString, ##__VA_ARGS__)
#define ZLog(FORMAT, ...) fprintf(stderr,"%s", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLogSkipLine ZLog(@"\n");
#define NSLogSkipLines(x) for (int z = 0; z < x; z++) ZLog(@"\n");
#define SIM(x) if ([[[UIDevice currentDevice].model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound){x;}
#define GRAPHIC_CONCEPT_NORMAL @"normal"
#define GRAPHIC_CONCEPT_DOTTED @"dotted"
#define GRAPHIC_CONCEPT_DOTTED_HORIZONTAL @"dotted_horizontal"
#define GRAPHIC_CONCEPT_DOTTED_VERTICAL @"dotted_vertical"
#define DATE_TYPE_hhmmss [NSArray arrayWithObjects:@"h", @"m", @"s", nil]
#define DATE_TYPE_MMDDYYYY [NSArray arrayWithObjects:@"M", @"D", @"Y", nil]
#define DATE_TYPE_MMDDYYYYhhmmss [NSArray arrayWithObjects:@"M", @"D", @"Y", @"h", @"m", @"s", nil]
#define DATE_TYPE_MMDDYYYYWWhhmmss [NSArray arrayWithObjects:@"M", @"D", @"Y", @"W", @"h", @"m", @"s", nil]
#define DATE_TYPE_MMDDYYYYhhmmssWW [NSArray arrayWithObjects:@"M", @"D", @"Y", @"h", @"m", @"s", @"W", nil]
#define DATE_TYPE_YYYYMMDD [NSArray arrayWithObjects:@"Y", @"M", @"D", nil]
#define DATE_TYPE_YYYYMMDDhhmmss [NSArray arrayWithObjects:@"Y", @"M", @"D", @"h", @"m", @"s", nil]
#define DATE_TYPE_YYYYMMDDWWhhmmss [NSArray arrayWithObjects:@"Y", @"M", @"D", @"W", @"h", @"m", @"s", nil]
#define DATE_TYPE_YYYYMMDDhhmmssWW [NSArray arrayWithObjects:@"Y", @"M", @"D", @"h", @"m", @"s", @"W", nil]
#define DATE_TYPE_FRIENDLY [NSArray arrayWithObjects:@"xx", nil]
#define DEVICE_RESOLUTION_TYPE_LONG 1
#define DEVICE_RESOLUTION_TYPE_SHORT 2
#define NOTIFICATION_SOUND_DEFAULT @"~default"

@interface Atom : UIViewController

#pragma mark - Device Information
-(NSString *) getDeviceOrientation;
-(NSString *) getDeviceType;
-(NSString *) getDeviceVersion;
-(int) getDeviceResolutionType;
-(BOOL) checkIfDeviceIsRetinaCapable;
-(BOOL) checkIfDeviceIsSimulated;

#pragma mark - Console Logging
-(void) logBoolean:(BOOL)boolean withName:(NSString *)name;
-(void) logArray:(NSArray *)array sorted:(BOOL)sorted;
-(void) logDate:(NSDate *)date;
-(void) enableLog;
-(void) disableLog;

#pragma mark - File Logging
-(void) logToFile:(NSString *)string;
-(NSString *) getLogFromLogFile;
-(void) clearLogFile;
-(void) createLogFile;
-(void) removeLogFile;

#pragma mark - Directory Paths
-(NSString *) getDirectoryPathDocuments;
-(NSString *) getDirectoryPathDocumentsWithSubDirectory:(NSString *)subDirectory;

#pragma mark - Strings
-(int) getCountOfRepetitionsOfString:(NSString *)a inString:(NSString *)b caseSensitive:(BOOL)sensitive;
-(int) getCountOfWordsInString:(NSString *)string;
-(BOOL) checkIfString:(NSString *)a containsString:(NSString *)b;
-(BOOL) checkIfString:(NSString *)a containsAllCharactersInString:(NSString *)b;
-(BOOL) checkIfString:(NSString *)a containsAnyCharactersInString:(NSString *)b;
-(NSString *) getStringFromArray:(NSArray *)array separateComponentsBy:(NSString *)separator;
-(NSString *) getString:(NSString *)string withUppercaseCharacterAtIndex:(int)index;
-(NSString *) getString:(NSString *)string withUppercaseCharactersFromIndex:(int)initialIndex toIndex:(int)finalIndex;
-(NSString *) getString:(NSString *)string withLowercaseCharacterAtIndex:(int)index;
-(NSString *) getString:(NSString *)string withLowercaseCharactersFromIndex:(int)initialIndex toIndex:(int)finalIndex;
-(NSString *) getStringWhileRemovingLetters:(NSString *)string removeSpaces:(BOOL)removeSpaces;
-(NSString *) getStringWhileRemovingNumbers:(NSString *)string removeSpaces:(BOOL)removeSpaces;
-(NSString *) getString:(NSString *)string whileRemovingCharacters:(NSString *)characters;
-(NSString *) getString:(NSString *)string whileMaintainingCharacters:(NSString *)characters removeSpaces:(BOOL)removeSpaces;

#pragma mark - Arrays
-(NSArray *) getArrayOfCombinedArray:(NSArray *)arrayOne withArray:(NSArray *)arrayTwo;
-(NSArray *) getArrayWithAscendingOrderOfObjects:(NSArray *)array;
-(NSArray *) getArrayWithDescendingOrderOfObjects:(NSArray *)array;
-(BOOL) checkIfArray:(NSArray *)array containsString:(NSString *)string;
-(BOOL) checkIfArray:(NSArray *)array containsStrings:(NSArray *)strings;
-(int) getCountOfRepetitionsOfString:(NSString *)string inArray:(NSArray *)array caseSensitive:(BOOL)sensitive;

#pragma mark - Dictionaries
-(NSDictionary *) getDictionaryOfCombinedDictionary:(NSDictionary *)dictionaryA withDictionary:(NSDictionary *)dictionaryB;

#pragma mark - Common Values
-(float) attainSpeedOfLightInMetersOverSeconds;
-(float) attainGravitationalForceOfEarthInMetersPerSecondSquared;
-(NSArray *) attainAlphabetInArray;
-(NSString *) attainAlphabetInString;

#pragma mark - Conversions
-(float) convertKelvinToFahrenheit:(float)kelvin round:(BOOL)round;
-(float) convertKelvinToCelsius:(float)kelvin round:(BOOL)round;
-(float) convertFahrenheitToKelvin:(float)fahrenheit round:(BOOL)round;
-(float) convertFahrenheitToCelsius:(float)fahrenheit round:(BOOL)round;
-(float) convertCelsiusToKelvin:(float)celsius round:(BOOL)round;
-(float) convertCelsiusToFahrenheit:(float)celsius round:(BOOL)round;
-(float) convertPoundsToKilograms:(float)pounds round:(BOOL)round;
-(float) convertPoundsToOunces:(float)pounds round:(BOOL)round;
-(float) convertPoundsToGrams:(float)pounds round:(BOOL)round;
-(float) convertKilogramsToPounds:(float)kilograms round:(BOOL)round;
-(float) convertKilogramsToOunces:(float)kilograms round:(BOOL)round;
-(float) convertKilogramsToGrams:(float)kilograms round:(BOOL)round;
-(float) convertDegreesToRadians:(float)degrees round:(BOOL)round;
-(float) convertRadiansToDegrees:(float)radians round:(BOOL)round;
-(float) convertGallonsToQuarts:(float)gallons round:(BOOL)round;
-(float) convertGallonsToLiters:(float)gallons round:(BOOL)round;
-(float) convertGallonsToPints:(float)gallons round:(BOOL)round;
-(float) convertGallonsToCups:(float)gallons round:(BOOL)round;
-(float) convertQuartsToGallons:(float)quarts round:(BOOL)round;
-(float) convertQuartsToLiters:(float)quarts round:(BOOL)round;
-(float) convertQuartsToPints:(float)quarts round:(BOOL)round;
-(float) convertQuartsToCups:(float)quarts round:(BOOL)round;
-(float) convertLitersToGallons:(float)liters round:(BOOL)round;
-(float) convertLitersToQuarts:(float)liters round:(BOOL)round;
-(float) convertLitersToPints:(float)liters round:(BOOL)round;
-(float) convertLitersToCups:(float)liters round:(BOOL)round;
-(float) convertPintsToGallons:(float)pints round:(BOOL)round;
-(float) convertPintsToQuarts:(float)pints round:(BOOL)round;
-(float) convertPintsToLiters:(float)pints round:(BOOL)round;
-(float) convertPintsToCups:(float)pints round:(BOOL)round;
-(float) convertCupsToGallons:(float)cups round:(BOOL)round;
-(float) convertCupsToQuarts:(float)cups round:(BOOL)round;
-(float) convertCupsToLiters:(float)cups round:(BOOL)round;
-(float) convertCupsToPints:(float)cups round:(BOOL)round;
-(float) convertMilesToKilometers:(float)miles round:(BOOL)round;
-(float) convertKilometersToMiles:(float)kilometers round:(BOOL)round;
-(float) convertYardsToMeters:(float)yards round:(BOOL)round;
-(float) convertYardsToFeet:(float)yards round:(BOOL)round;
-(float) convertYardsToInches:(float)yards round:(BOOL)round;
-(float) convertYardsToCentimeters:(float)yards round:(BOOL)round;
-(float) convertYardsToMillimeters:(float)yards round:(BOOL)round;
-(float) convertMetersToYards:(float)meters round:(BOOL)round;
-(float) convertMetersToFeet:(float)meters round:(BOOL)round;
-(float) convertMetersToInches:(float)meters round:(BOOL)round;
-(float) convertMetersToCentimeters:(float)meters round:(BOOL)round;
-(float) convertMetersToMillimeters:(float)meters round:(BOOL)round;
-(float) convertFeetToYards:(float)feet round:(BOOL)round;
-(float) convertFeetToMeters:(float)feet round:(BOOL)round;
-(float) convertFeetToInches:(float)feet round:(BOOL)round;
-(float) convertFeetToCentimeters:(float)feet round:(BOOL)round;
-(float) convertFeetToMillimeters:(float)feet round:(BOOL)round;
-(float) convertInchesToYards:(float)inches round:(BOOL)round;
-(float) convertInchesToMeters:(float)inches round:(BOOL)round;
-(float) convertInchesToFeet:(float)inches round:(BOOL)round;
-(float) convertInchesToCentimeters:(float)inches round:(BOOL)round;
-(float) convertInchesToMillimeters:(float)inches round:(BOOL)round;
-(float) convertCentimetersToYards:(float)centimeters round:(BOOL)round;
-(float) convertCentimetersToMeters:(float)centimeters round:(BOOL)round;
-(float) convertCentimetersToFeet:(float)centimeters round:(BOOL)round;
-(float) convertCentimetersToInches:(float)centimeters round:(BOOL)round;
-(float) convertCentimetersToMillimeters:(float)centimeters round:(BOOL)round;
-(float) convertMillimetersToYards:(float)millimeters round:(BOOL)round;
-(float) convertMillimetersToMeters:(float)millimeters round:(BOOL)round;
-(float) convertMillimetersToFeet:(float)millimeters round:(BOOL)round;
-(float) convertMillimetersToInches:(float)millimeters round:(BOOL)round;
-(float) convertMillimetersToCentimeters:(float)millimeters round:(BOOL)round;
-(float) convertYearsToMonths:(float)years round:(BOOL)round;
-(float) convertYearsToWeeks:(float)years round:(BOOL)round;
-(float) convertYearsToDays:(float)years round:(BOOL)round;
-(float) convertYearsToHours:(float)years round:(BOOL)round;
-(float) convertYearsToMinutes:(float)years round:(BOOL)round;
-(float) convertYearsToSeconds:(float)years round:(BOOL)round;
-(float) convertMonthsToYears:(float)months round:(BOOL)round;
-(float) convertMonthsToWeeks:(float)months round:(BOOL)round;
-(float) convertMonthsToDays:(float)months round:(BOOL)round;
-(float) convertMonthsToHours:(float)months round:(BOOL)round;
-(float) convertMonthsToMinutes:(float)months round:(BOOL)round;
-(float) convertMonthsToSeconds:(float)months round:(BOOL)round;
-(float) convertWeeksToYears:(float)weeks round:(BOOL)round;
-(float) convertWeeksToMonths:(float)weeks round:(BOOL)round;
-(float) convertWeeksToDays:(float)weeks round:(BOOL)round;
-(float) convertWeeksToHours:(float)weeks round:(BOOL)round;
-(float) convertWeeksToMinutes:(float)weeks round:(BOOL)round;
-(float) convertWeeksToSeconds:(float)weeks round:(BOOL)round;
-(float) convertDaysToYears:(float)days round:(BOOL)round;
-(float) convertDaysToMonths:(float)days round:(BOOL)round;
-(float) convertDaysToWeeks:(float)days round:(BOOL)round;
-(float) convertDaysToHours:(float)days round:(BOOL)round;
-(float) convertDaysToMinutes:(float)days round:(BOOL)round;
-(float) convertDaysToSeconds:(float)days round:(BOOL)round;
-(float) convertHoursToYears:(float)hours round:(BOOL)round;
-(float) convertHoursToMonths:(float)hours round:(BOOL)round;
-(float) convertHoursToWeeks:(float)hours round:(BOOL)round;
-(float) convertHoursToDays:(float)hours round:(BOOL)round;
-(float) convertHoursToMinutes:(float)hours round:(BOOL)round;
-(float) convertHoursToSeconds:(float)hours round:(BOOL)round;
-(float) convertMinutesToYears:(float)minutes round:(BOOL)round;
-(float) convertMinutesToMonths:(float)minutes round:(BOOL)round;
-(float) convertMinutesToWeeks:(float)minutes round:(BOOL)round;
-(float) convertMinutesToDays:(float)minutes round:(BOOL)round;
-(float) convertMinutesToHours:(float)minutes round:(BOOL)round;
-(float) convertMinutesToSeconds:(float)minutes round:(BOOL)round;
-(float) convertSecondsToYears:(float)seconds round:(BOOL)round;
-(float) convertSecondsToMonths:(float)seconds round:(BOOL)round;
-(float) convertSecondsToWeeks:(float)seconds round:(BOOL)round;
-(float) convertSecondsToDays:(float)seconds round:(BOOL)round;
-(float) convertSecondsToHours:(float)seconds round:(BOOL)round;
-(float) convertSecondsToMinutes:(float)seconds round:(BOOL)round;

#pragma mark - Calculations
-(float) calculateTaxOfPrice:(float)price round:(BOOL)round addTaxToPrice:(BOOL)addTax;
-(float) calculateAverageOfNumbers:(NSArray *)arrayWithNumbers round:(BOOL)round;
-(float) calculatePercentageChangeFromNumber:(float)a toNumber:(float)b round:(BOOL)round;
-(float) calculatePercentageOfNumber:(float)a inNumber:(float)b round:(BOOL)round;
-(float) calculateNumberOfPercentage:(float)percentage ofNumber:(float)number round:(BOOL)round;
-(float) calculateHypotenuseOfA:(float)a andB:(float)b round:(BOOL)round;
-(float) calculateCircumferenceWithDiameter:(float)diameter round:(BOOL)round;
-(float) calculateCircumferenceWithRadius:(float)radius round:(BOOL)round;
-(float) calculateDiameterWithCircumference:(float)circumference round:(BOOL)round;
-(float) calculateDiameterWithRadius:(float)radius round:(BOOL)round;
-(float) calculateRadiusWithCircumference:(float)circumference round:(BOOL)round;
-(float) calculateRadiusWithDiameter:(float)diameter round:(BOOL)round;
-(float) calculateAreaOfSideA:(float)sideA andSideB:(float)sideB round:(BOOL)round;
-(float) calculatePerimeterOfSideA:(float)sideA andSideB:(float)sideB round:(BOOL)round;
-(float) calculateDensityWithKilograms:(float)mass andCubicMeters:(float)volume round:(BOOL)round;
-(float) calculateSpeedWithMeters:(float)distance andSeconds:(float)time round:(BOOL)round;
-(float) calculateAccelerationWithInitialMetersOverSeconds:(float)initialVelocty andFinalMetersOverSeconds:(float)finalVelocity andSeconds:(float)deltaTime round:(BOOL)round;
-(float) calculateMomentumWithKilograms:(float)mass andMetersOverSeconds:(float)velocity round:(BOOL)round;
-(float) calculateForceWithKilograms:(float)mass andMetersOverSquareSeconds:(float)acceleration round:(BOOL)round;
-(float) calculateWorkWithNewtons:(float)force andMeters:(float)distance round:(BOOL)round;
-(float) calculatePowerWithJoules:(float)work andSeconds:(float)time round:(BOOL)round;
-(float) calculateKineticEnergyWithKilograms:(float)mass andMetersOverSeconds:(float)velocity round:(BOOL)round;
-(float) calculateCurrentWithVolts:(float)voltage andOhms:(float)resistance round:(BOOL)round;
-(float) calculateElectricalPowerWithVolts:(float)voltage andAmperes:(float)current round:(BOOL)round;

#pragma mark - Transformations
-(CGAffineTransform) getTransformationExitUp:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitDown:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitLeft:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitRight:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitUpLeft:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitUpRight:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitDownLeft:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationExitDownRight:(id)object forView:(UIView *)view;
-(CGAffineTransform) getTransformationCollapse;

#pragma mark - Object Detections
-(BOOL) checkIfFrame:(CGRect)frameOne collidesWithFrame:(CGRect)frameTwo;

#pragma mark - Animations
-(void) animateImageView:(UIImageView *)imageView withImagePaths:(NSArray *)arrayOfPaths withDuration:(float)duration withRepeats:(int)repeats;
-(void) animateImageView:(UIImageView *)imageView withConstantImagePath:(NSString *)string withNumber:(int)first toNumber:(int)last withDuration:(float)duration withRepeats:(int)repeats;
-(void) animateObjectWiggle:(id)object;
-(void) animateObjectOnCollision:(id)objectOne suckObject:(id)objectTwo withDelay:(float)delay withDuration:(float)duration;

#pragma mark - Photography
-(UIImage *) getImageWithInvertedPixelsOfImage:(UIImage *)image;
-(UIImage *) getImageWithUnsaturatedPixelsOfImage:(UIImage *)image;
-(UIImage *) getImageWithBlendedImages:(UIImage *)image1 secondImage:(UIImage *)image2 withAlpha:(float)alpha;
-(UIImage *) getImageWithOverlayedImage:(UIImage *)image1 overlayImage:(UIImage *)image2 withAlpha:(float)alpha;
-(UIImage *) getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha;

#pragma mark - Core Graphics
-(void) createCoreGraphicsContextWithFrame:(CGRect)frame;
-(void) createCoreGraphicsContextWithFrame:(CGRect)frame withRetina:(BOOL)retina;
-(void) removeCoreGraphicsContext;
-(UIImage *) getImageFromCoreGraphicsContext;
-(void) drawOnImageView:(UIImageView *)canvas fromLocation:(CGPoint)oldLoc toLocation:(CGPoint)newLoc withGraphicConcept:(NSString *)concept;
-(void) drawOnImageView:(UIImageView *)canvas fromLocation:(CGPoint)oldLoc toLocation:(CGPoint)newLoc withBrush:(UIImage *)brush withBrushSize:(float)brushSize;

#pragma mark - Encrypting and Decrypting
-(NSString *) getEncryptedString:(NSString *)string;
-(NSString *) getDecryptedString:(NSString *)string;

#pragma mark - HTML Parsing
-(NSString *) getContentsOfURL:(NSString *)address;
-(UIImage *) getImageFromURL:(NSString *)fileURL;

#pragma mark - Notification Center
-(void) scheduleNotificationWithDate:(NSDate *)date withMessage:(NSString *)message withSlideToUnlockMessage:(NSString *)slideMessage withDictionary:(NSDictionary *)dictionary withSoundName:(NSString *)soundName withBadge:(BOOL)badge;

#pragma mark - File Storage
-(int) getCountOfAllFilesInDirectory:(NSString *)directory;
-(NSString *) getListOfFilesInDirectoryInString:(NSString *)directory subFiles:(BOOL)subFiles;
-(NSArray *) getListOfFilesInDirectoryInArray:(NSString *)directory subFiles:(BOOL)subFiles;
-(NSString *) getPathForFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(NSString *) getTextFromFileInResources:(NSString *)fileName ofType:(NSString *)extension;
-(NSString *) getTextFromFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(void) writeText:(NSString *)text toFile:(NSString *)fileName ofType:(NSString *)extension appending:(BOOL)appending inDirectory:(NSString *)directory;
-(void) saveFile:(NSString *)fileName ofType:(NSString *)extension fromURL:(NSString *)fileIndexPath inDirectory:(NSString *)directoryPath;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(void) saveImageToPhotoAlbums:(UIImage *)image;
-(void) saveImagesToPhotoAlbums:(NSArray *)images;
-(void) saveImageFromURL:(NSString *)imageURL withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(void) saveImageFromURLToPhotoAlbums:(NSString *)imageURL;
-(void) saveImagesFromURLsToPhotoAlbums:(NSArray *)imageURLs;
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(BOOL) checkIfFileExistsInResources:(NSString *)fileName ofType:(NSString *)extension;
-(BOOL) checkIfFileExists:(NSString *)fileName ofType:(NSString *)extension inDirectoryPath:(NSString *)directoryPath;
-(BOOL) checkIfFilesExist:(NSArray *)fileNames ofType:(NSString *)extension inDirectoryPath:(NSString *)directoryPath;
-(void) createDirectory:(NSString *)directoryName inDirectory:(NSString *)directoryPath;
-(void) createDirectories:(NSArray *)directoriesNames inDirectory:(NSString *)directoryPath;
-(void) createStandardDirectoriesWhileRemovingPreviousFiles:(BOOL)removePreviousFiles;
-(void) removeDirectory:(NSString *)directoryName inDirectory:(NSString *)directory;
-(void) removeDirectories:(NSArray *)directoriesNames inDirectory:(NSString *)directory;
-(void) removeFile:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directory;
-(void) removeAllFilesInDirectory:(NSString *)directory includeSubDirectories:(BOOL)inclusion;
-(void) removeAllFilesInDocumentsDirectory;
-(void) removeAllFilesInDocumentsDirectoryAbsolutely;

#pragma mark - User Identity
-(void) createUserIDNumericRandom;
-(void) createUserIDAlphaRandom;
-(void) createUserIDAlphaNumericRandom;
-(void) removeUserID;
-(NSString *) getUserID;

#pragma mark - User Defaults
-(void) saveIntegerToUserDefaults:(int)x forKey:(NSString *)key;
-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key;
-(void) saveBoolToUserDefaults:(bool)x forKey:(NSString *)key;
-(void) saveDoubleToUserDefaults:(double)x forKey:(NSString *)key;
-(void) saveStringToUserDefaults:(NSString *)x forKey:(NSString *)key;
-(void) saveArrayToUserDefaults:(NSArray *)x forKey:(NSString *)key;
-(void) saveURLToUserDefaults:(NSURL *)url forKey:(NSString *)key;
-(void) saveImageToUserDefaults:(UIImage *)image ofType:(NSString *)extension forKey:(NSString *)key;
-(void) saveObjectToUserDefaults:(id)object forKey:(NSString *)key;
-(int) loadIntegerFromUserDefaultsForKey:(NSString *)key;
-(float) loadFloatFromUserDefaultsForKey:(NSString *)key;
-(bool) loadBoolFromUserDefaultsForKey:(NSString *)key;
-(double) loadDoubleFromUserDefaultsForKey:(NSString *)key;
-(NSString *) loadStringFromUserDefaultsForKey:(NSString *)key;
-(NSArray *) loadArrayFromUserDefaultsForKey:(NSString *)key;
-(NSURL *) loadURLFromUserDefaultsForKey:(NSString *)key;
-(UIImage *) loadImageFromUserDefaultsForKey:(NSString *)key;
-(id) loadObjectFromUserDefaultsForKey:(NSString *)key;
-(void) clearValueForKeyInUserDefaults:(NSString *)key;
-(void) clearValuesInUserDefaults;
-(void) removeObjectForKeyInUserDefaults:(NSString *)key;

#pragma mark - Alerts
-(void) showAlertViewWithTitle:(NSString *)title withText:(NSString *)text withCancelButtonName:(NSString *)cancelButtonName;

#pragma mark - Date
-(NSDate *) getCurrentDate;
-(NSArray *) getCurrentDateInArrayWithMilitaryTime:(BOOL)militaryTime;
-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year;
-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year hour:(int)hour minute:(int)minute;
-(NSDate *) getDateWithMonth:(int)month day:(int)day year:(int)year hour:(int)hour minute:(int)minute second:(int)second;
-(NSDate *) getDateOfCurrentDateAfterNumberOfDaysPassed:(int)daysPassed;
-(NSDate *) getDateOfCurrentDateBeforeNumberOfDaysPassed:(int)daysPassed;
-(NSDate *) getDateOfDate:(NSDate *)date afterNumberOfDaysPassed:(int)daysPassed;
-(NSDate *) getDateOfDate:(NSDate *)date beforeNumberOfDaysPassed:(int)daysPassed;
-(NSArray *) getArrayFromDate:(NSDate *)date dateType:(NSArray *)dateType;
-(int) getCurrentYear;
-(int) getCurrentMonth;
-(int) getCurrentDay;
-(int) getCurrentHourWithMilitaryTime:(BOOL)militaryTime;
-(int) getCurrentMinute;
-(int) getCurrentSecond;
-(int) getCurrentWeekday;
-(int) getCurrentWeekOfMonth;
-(int) getCurrentWeekOfYear;
-(int) getYearOfDate:(NSDate *)date;
-(int) getMonthOfDate:(NSDate *)date;
-(int) getDayOfDate:(NSDate *)date;
-(int) getHourOfDate:(NSDate *)date;
-(int) getMinuteOfDate:(NSDate *)date;
-(int) getSecondOfDate:(NSDate *)date;
-(int) getWeekdayOfDate:(NSDate *)date;
-(int) getWeekOfMonthOfDate:(NSDate *)date;
-(int) getWeekOfYearOfDate:(NSDate *)date;
-(int) getDaysInMonth:(int)month inYear:(int)year;
-(int) getDaysFromCurrentDateUntilDate:(NSDate *)endDate;
-(int) getDaysFromCurrentDateUntilDay:(int)endDay inMonth:(int)endMonth inYear:(int)endYear;
-(int) getDaysFromDate:(NSDate *)initialDate untilDate:(NSDate *)endDate;
-(int) getDaysFromDay:(int)initialDay inMonth:(int)initialMonth inYear:(int)initialYear
             untilDay:(int)endDay inMonth:(int)endMonth inYear:(int)endYear;
-(NSString *) getStringOfDateIntervalInHoursBetweenDate:(NSDate *)initialDate andDate:(NSDate *)finalDate;
-(NSString *) getStringFromDate:(NSDate *)date dateType:(NSArray *)dateType;
-(NSString *) getNameOfMonth:(int)month;

#pragma mark - Random
-(int) getRandomIntFromNumber:(int)min toNumber:(int)max inclusive:(BOOL)inclusive;
-(float) getRandomFloatFromFloatNumber:(NSString *)min toFloatNumber:(NSString *)max inclusive:(BOOL)inclusive;
-(NSString *) getRandomStringAlphaWithLength:(int)length;
-(NSString *) getRandomStringAlphaNumericWithLength:(int)length;
-(NSString *) getRandomStringNumericWithLength:(int)length;

#pragma mark - Weather
-(NSString *) getCurrentWeatherConditionWithLocation:(CGPoint)location;

@end