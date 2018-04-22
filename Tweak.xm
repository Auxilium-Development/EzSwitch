#import <objc/runtime.h>	//Import all required headers
#import <AVFoundation/AVFoundation.h>

@interface _CDBatterySaver	//Define all required functtions for Low Power Mode from interface _CDBatterySaver
+(id)batterySaver;
-(BOOL)setPowerMode:(long long)arg1 error:(id *)arg2;
@end

@interface SBOrientationLockManager	//Define all required functions for Rotation Lock from interface SBOrientationLockManager
+(instancetype)sharedInstance;
-(BOOL)isUserLocked;
-(void)lock;
-(void)unlock;
-(void)myIsUserLocked;
@end

NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.chilaxan.ezswitchprefs.plist"];	//Sets up variable "path" to the path to the preferences file
NSDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];	//Creates a dictionary to pull our preferences from

static BOOL isEnabled = (BOOL)[[settings objectForKey:@"enabled"]?:@TRUE boolValue];	//Load whether or not tweak is enabled
static NSInteger preference = (NSInteger)[[settings objectForKey:@"preferences"]?:@9 integerValue];	//Check which option is enabled in array

%hook SpringBoard	//Hook SpringBoardto watch for void

- (void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 {	//Hook ringer switch
	if(arg1==1) {	//If Ringer is going toward mute
		if (isEnabled) {	//Check if tweak is enabled
			if (preference==0) {	//Check what is selected in preferences array			
				SBOrientationLockManager *orientationManager = [%c(SBOrientationLockManager) sharedInstance];	//Sets Rotation Lock to off
				[orientationManager unlock];
				}	
			if (preference==1){	//Check what is selected in preferences array
				[[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:0 error:nil];	//Sets Low Power Mode to off
			}
			if (preference==2) {	//Check what is selected in preferences array
				AVCaptureDevice *flashlight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	//Sets up variable "flashlight" with public apis
				if ([flashlight isTorchAvailable] && [flashlight isTorchModeSupported:AVCaptureTorchModeOn]) {	//Checks if flash exists and if flashlight mode is supported
					BOOL success = [flashlight lockForConfiguration:nil];	//Sets up flashlight to be configured
					if (success) {
						[flashlight setTorchMode:AVCaptureTorchModeOff];	//Sets Flashlight to off
						[flashlight unlockForConfiguration];	//Unlocks Flashlight for additional configuration
					}
				}
			}
		} else {
			%orig;	//If the tweak is disabled, returns original arguments
		}
	} 
	if(arg1==0) {	//If Ringer is going toward unmute
		if (isEnabled) {	//Checks if tweak is enabled
			if (preference==0) {	//Check what is selected in preferences array
				SBOrientationLockManager *orientationManager = [%c(SBOrientationLockManager) sharedInstance];	//Sets Rotation Lock to on
					[orientationManager lock];
			}	
			if (preference==1){	//Check what is selected in preferences array
					[[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:1 error:nil];	//Sets Low Power Mode to on
			}
			if (preference==2) {	//Check what is selected in preferences array
				AVCaptureDevice *flashlight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	//Sets up variable "flashlight" with public apis
				if ([flashlight isTorchAvailable] && [flashlight isTorchModeSupported:AVCaptureTorchModeOn]) {	//Checks if flash exists and if flashlight mode is supported
					BOOL success = [flashlight lockForConfiguration:nil];	//Sets up flashlight to be configured
					if (success) {
						[flashlight setTorchMode:AVCaptureTorchModeOn];	//Sets Flashlight to on
						[flashlight unlockForConfiguration];	//Unlocks Flashlight for additional configuration
					}
				}
			}
		} else {
			%orig;	//If the tweak is disabled, returns original arguments
		}
	}
}	
%end	//End of hook