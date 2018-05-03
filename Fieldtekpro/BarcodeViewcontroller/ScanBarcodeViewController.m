//
//  ScanBarcodeViewController.m
//  AssetAssessment
//
//  Created by Deepak Gantala on 3/11/15.
//  Copyright (c) 2015 Deepak Gantala. All rights reserved.
//

#import "ScanBarcodeViewController.h"
#import "MyNotifcationsViewController.h"
#import "CreateNotificationViewController.h"

 
@interface ScanBarcodeViewController ()

@end

@implementation ScanBarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [barCodeView addSubview:_highlightView];

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }

    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];

    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];

    _prevLayer.frame = self.view.frame;

    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [barCodeView.layer addSublayer:_prevLayer];
    
    if ([_prevLayer.connection isVideoOrientationSupported]) {
        
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        
        [_prevLayer.connection setVideoOrientation:orientation];
    }
   
    [_session startRunning];
    [barCodeView bringSubviewToFront:_highlightView];
  
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
                {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
                }
        }
        if (detectionString != nil)
            {
            if ([detectionString length])

            NSLog(@"detectionString : %@",detectionString);
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:detectionString forKey:@"scanned"];
            [defaults synchronize];
          
            [self barCodeScanningMethod];
         }
        break;
    }
    _highlightView.frame = highlightViewRect;

        //   else
        //     _label.text = @"(none)";
}

-(IBAction)cancelBarcodeScanning:(id)sender{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"scanned"];
    [defaults synchronize];
    
    [self barCodeScanningMethod];
}

-(void)barCodeScanningMethod{

    [self stopScannerWithScanningValue];
    
    if ([(CreateNotificationViewController *)self.delegate respondsToSelector:@selector(dismissScanView)]) {
        [(CreateNotificationViewController *)self.delegate dismissScanView];
    }
    
    if ([(MyNotifcationsViewController *)self.delegate respondsToSelector:@selector(dismissScanView)]) {
        [(MyNotifcationsViewController *)self.delegate dismissScanView];
    }
    
 
}

- (void)stopScannerWithScanningValue{
    [_session stopRunning];
    [_prevLayer removeFromSuperlayer];
    [_prevLayer setHidden:YES];
    _prevLayer = nil;
    [_highlightView setHidden:YES];
    
    _session = nil;
        // Handling the QR code value here...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
