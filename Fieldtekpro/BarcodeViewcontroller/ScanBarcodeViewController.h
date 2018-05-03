//
//  ScanBarcodeViewController.h
//  AssetAssessment
//
//  Created by Deepak Gantala on 3/11/15.
//  Copyright (c) 2015 Deepak Gantala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanBarcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;

    UIView *_highlightView;
    
    IBOutlet UIView *barCodeView;
}

@property (nonatomic,weak)id delegate;



@end
