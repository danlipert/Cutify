#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@interface CaptureSessionManager : NSObject {

}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;
@property (nonatomic, retain) id delegate;

@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void)addStillImageOutput;
- (void)captureStillImage;

@end
