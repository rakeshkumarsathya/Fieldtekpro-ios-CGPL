//
//  DLPieChart.m
//  DLPieChart
//
//  Created by Dilip Lilaramani on 5/29/13.
//  Copyright (c) 2013 Dilip Lilaramani. All rights reserved.
//

#import "DLPieChart.h"
#import <QuartzCore/QuartzCore.h>

#import "MISViewController.h"


#import "Response.h"

#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)


#define OFFSET 20

@interface SliceLayer : CAShapeLayer
{
    // ViewController *viewC;
    
}

@property (nonatomic, assign) CGFloat   value;

@property (nonatomic, assign) CGFloat   percentage;
@property (nonatomic, assign) double    startAngle;
@property (nonatomic, assign) double    endAngle;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, strong) NSString  *text;


- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end

@implementation SliceLayer

@synthesize text = _text;
@synthesize value = _value;
@synthesize percentage = _percentage;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize isSelected = _isSelected;




- (NSString*)description
{
    return [NSString stringWithFormat:@"value:%f, percentage:%0.0f, start:%f, end:%f", _value, _percentage, _startAngle/M_PI*180, _endAngle/M_PI*180];
}
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}
- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])
    {
        if ([layer isKindOfClass:[SliceLayer class]]) {
            self.startAngle = [(SliceLayer *)layer startAngle];
            self.endAngle = [(SliceLayer *)layer endAngle];
        }
    }
    return self;
}
- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if(!currentAngle) currentAngle = from;
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}
@end

@interface DLPieChart (Private)
- (void)updateTimerFired:(NSTimer *)timer;
- (SliceLayer *)createSliceLayer;
- (CGSize)sizeThatFitsString:(NSString *)string;
- (void)updateLabelForLayer:(SliceLayer *)pieLayer value:(CGFloat)value;
- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection;
@end

@implementation DLPieChart
{
    NSInteger _selectedSliceIndex;
    //pie view, contains all slices
    UIView  *_pieView;
    
    //animation control
    NSTimer *_animationTimer;
    NSMutableArray *_animations;
    int tag;
}

static NSUInteger kDefaultSliceZOrder = 100;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize startPieAngle = _startPieAngle;

@synthesize animationSpeed = _animationSpeed;
@synthesize pieCenter = _pieCenter;
@synthesize pieRadius = _pieRadius;
@synthesize showLabel = _showLabel;
@synthesize labelFont = _labelFont;
@synthesize labelColor = _labelColor;
@synthesize labelShadowColor = _labelShadowColor;
@synthesize labelRadius = _labelRadius;
@synthesize selectedSliceStroke = _selectedSliceStroke;
@synthesize selectedSliceOffsetRadius = _selectedSliceOffsetRadius;
@synthesize showPercentage = _showPercentage;

@synthesize DLDataArray, DLColorsArray,DLPieChartView;

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _pieView = [[UIView alloc] initWithFrame:frame];
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_pieView];
        
        _selectedSliceIndex = -1;
        _animations = [[NSMutableArray alloc] init];
        
        _animationSpeed = 0.5;
        _startPieAngle = M_PI_2*3;
        _selectedSliceStroke = 3.0;
        
        self.pieRadius = MIN(frame.size.width/2, frame.size.height/2) - 10;
        self.pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.labelFont = [UIFont boldSystemFontOfSize:MAX((int)self.pieRadius/10, 5)];
        _labelColor = [UIColor whiteColor];
        _labelRadius = _pieRadius/2;
        _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
        
        
        _showLabel = YES;
        _showPercentage = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.pieCenter = center;
        self.pieRadius = radius;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        _pieView = [[UIView alloc] initWithFrame:self.bounds];
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_pieView atIndex:0];
        
        _selectedSliceIndex = -1;
        _animations = [[NSMutableArray alloc] init];
        
        _animationSpeed = 0.5;
        _startPieAngle = M_PI_2*3;
        _selectedSliceStroke = 3.0;
        
        CGRect bounds = [[self layer] bounds];
        self.pieRadius = MIN(bounds.size.width/2, bounds.size.height/2) - 10;
        self.pieCenter = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        self.labelFont = [UIFont boldSystemFontOfSize:MAX((int)self.pieRadius/10, 5)];
        _labelColor = [UIColor whiteColor];
        _labelRadius = _pieRadius/2;
        _selectedSliceOffsetRadius = MAX(10, _pieRadius/10);
        
        _showLabel = YES;
        _showPercentage = YES;
    }
    
    return self;
}

- (void)setPieCenter:(CGPoint)pieCenter
{
    [_pieView setCenter:pieCenter];
    _pieCenter = CGPointMake(_pieView.frame.size.width/2, _pieView.frame.size.height/2);
}

- (void)setPieRadius:(CGFloat)pieRadius
{
    _pieRadius = pieRadius;
    CGPoint origin = _pieView.frame.origin;
    CGRect frame = CGRectMake(origin.x+_pieCenter.x-pieRadius, origin.y+_pieCenter.y-pieRadius, pieRadius*2, pieRadius*2);
    _pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    [_pieView setFrame:frame];
    [_pieView.layer setCornerRadius:_pieRadius];
}

- (void)setPieBackgroundColor:(UIColor *)color
{
    [_pieView setBackgroundColor:color];
}

#pragma mark - manage settings

- (void)setShowPercentage:(BOOL)showPercentage
{
    _showPercentage = showPercentage;
    for(SliceLayer *layer in _pieView.layer.sublayers)
    {
        CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
        [textLayer setHidden:!_showLabel];
        if(!_showLabel) return;
        NSString *label;
        if(_showPercentage)
            label = [NSString stringWithFormat:@"%0.0f", layer.percentage*100];
        else
            label = (layer.text)?layer.text:[NSString stringWithFormat:@"%0.0f", layer.value];
        
        CGSize size = [label sizeWithFont:self.labelFont];
        
        
        if(M_PI*2*_labelRadius*layer.percentage < MAX(size.width,size.height))
        {
            [textLayer setString:@""];
        }
        else
        {
            [textLayer setString:@""];
            [textLayer setString:label];
            [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
        }
    }
}

#pragma mark - Pie Reload Data With Animation

- (void)reloadData
{
    if (_dataSource)
    {
        CALayer *parentLayer = [_pieView layer];
        NSArray *slicelayers = [parentLayer sublayers];
        
        _selectedSliceIndex = -1;
        [slicelayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SliceLayer *layer = (SliceLayer *)obj;
            if(layer.isSelected)
                [self setSliceDeselectedAtIndex:idx];
        }];
        
        double startToAngle = 0.0;
        double endToAngle = startToAngle;
        
        NSUInteger sliceCount = [_dataSource numberOfSlicesInPieChart:self];
        
        double sum = 0.0;
        double values[sliceCount];
        for (int index = 0; index < sliceCount; index++) {
            values[index] = [_dataSource pieChart:self valueForSliceAtIndex:index];
            sum += values[index];
        }
        
        double angles[sliceCount];
        for (int index = 0; index < sliceCount; index++) {
            double div = 0;
            if (sum == 0){
            }
            else{
                
                div = values[index] / sum;
              //  if (div>0)
//                {
//                    
//                if (div>0 && div<0.05)
//                {
//                   angles[index] = M_PI * 2 * div+1;
//
//                }
//                   else if (div>0.9 && div<1)
//                   {
//                       angles[index] = M_PI * 2 * div-1;
// 
//                   }
//                    else
//                    {
//                        angles[index] = M_PI * 2 * div;
//                    }
//                }
//                else
//                {
                    angles[index] = M_PI * 2 * div;
               // }
            }
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:_animationSpeed];
        
        [_pieView setUserInteractionEnabled:NO];
        
        __block NSMutableArray *layersToRemove = nil;
        /*[CATransaction setCompletionBlock:^{
         
         [layersToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         [obj removeFromSuperlayer];
         }];
         
         [layersToRemove removeAllObjects];
         
         for(SliceLayer *layer in _pieView.layer.sublayers)
         {
         [layer setZPosition:kDefaultSliceZOrder];
         }
         
         [_pieView setUserInteractionEnabled:YES];
         }];
         */
        for(SliceLayer *layer in _pieView.layer.sublayers)
        {
            [layer setZPosition:kDefaultSliceZOrder];
        }
        
        [_pieView setUserInteractionEnabled:YES];
        
        BOOL isOnStart = ([slicelayers count] == 0 && sliceCount);
        NSInteger diff = sliceCount - [slicelayers count];
        layersToRemove = [NSMutableArray arrayWithArray:slicelayers];
        
        BOOL isOnEnd = ([slicelayers count] && (sliceCount == 0 || sum <= 0));
        if(isOnEnd)
        {
            for(SliceLayer *layer in _pieView.layer.sublayers){
                [self updateLabelForLayer:layer value:0];
                [layer createArcAnimationForKey:@"startAngle"
                                      fromValue:[NSNumber numberWithDouble:_startPieAngle]
                                        toValue:[NSNumber numberWithDouble:_startPieAngle]
                                       Delegate:self];
                [layer createArcAnimationForKey:@"endAngle"
                                      fromValue:[NSNumber numberWithDouble:_startPieAngle]
                                        toValue:[NSNumber numberWithDouble:_startPieAngle]
                                       Delegate:self];
            }
            [CATransaction commit];
            return;
        }

        for(int index = 0; index < sliceCount; index ++)
        {
            SliceLayer *layer;

            endToAngle += angles[index];
            
            double startFromAngle = _startPieAngle + startToAngle;
            double endFromAngle = _startPieAngle + endToAngle;
            
            if( index >= [slicelayers count] )
            {
                layer = [self createSliceLayer];
                if (isOnStart)
                    startFromAngle = endFromAngle = _startPieAngle;
                [parentLayer addSublayer:layer];
                diff--;
            }
            else
            {
                SliceLayer *onelayer = [slicelayers objectAtIndex:index];
                if(diff == 0 || onelayer.value == (CGFloat)values[index])
                {
                    layer = onelayer;
                    [layersToRemove removeObject:layer];
                }
                else if(diff > 0)
                {
                    layer = [self createSliceLayer];
                    [parentLayer insertSublayer:layer atIndex:index];
                    diff--;
                }
                else if(diff < 0)
                {
                    while(diff < 0)
                    {
                        [onelayer removeFromSuperlayer];
                        [parentLayer addSublayer:onelayer];
                        diff++;
                        onelayer = [slicelayers objectAtIndex:index];
                        if(onelayer.value == (CGFloat)values[index] || diff == 0)
                        {
                            layer = onelayer;
                            [layersToRemove removeObject:layer];
                            break;
                        }
                    }
                }
            }
            
            
            layer.value = values[index];
            layer.percentage = (sum)?layer.value/sum:0;
            
            
            
            UIColor *color = nil;
            if([_dataSource respondsToSelector:@selector(pieChart:colorForSliceAtIndex:)])
            {
                color = [_dataSource pieChart:self colorForSliceAtIndex:index];
            }
            
            if(!color)
            {
                color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
            }
            
            [layer setFillColor:color.CGColor];
            if([_dataSource respondsToSelector:@selector(pieChart:textForSliceAtIndex:)])
            {
                layer.text = [_dataSource pieChart:self textForSliceAtIndex:index];
            }
            
            [self updateLabelForLayer:layer value:values[index]];
            [layer createArcAnimationForKey:@"startAngle"
                                  fromValue:[NSNumber numberWithDouble:startFromAngle]
                                    toValue:[NSNumber numberWithDouble:startToAngle+_startPieAngle]
                                   Delegate:self];
            [layer createArcAnimationForKey:@"endAngle"
                                  fromValue:[NSNumber numberWithDouble:endFromAngle]
                                    toValue:[NSNumber numberWithDouble:endToAngle+_startPieAngle]
                                   Delegate:self];
            startToAngle = endToAngle;
        }
        [CATransaction setDisableActions:YES];
        for(SliceLayer *layer in layersToRemove)
        {
            [layer setFillColor:[self backgroundColor].CGColor];
            [layer setDelegate:nil];
            [layer setZPosition:0];
            CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
            [textLayer setHidden:YES];
        }
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

#pragma mark - Animation Delegate + Run Loop Timer

- (void)updateTimerFired:(NSTimer *)timer;
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
        CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
        CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
        
        CGPathRef path = CGPathCreateArc(_pieCenter, _pieRadius, interpolatedStartAngle, interpolatedEndAngle);
        [obj setPath:path];
        CFRelease(path);
        
        {
            CALayer *labelLayer = [[obj sublayers] objectAtIndex:0];
            CGFloat interpolatedMidAngle = (interpolatedEndAngle + interpolatedStartAngle) / 2;
            [CATransaction setDisableActions:YES];
            [labelLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(interpolatedMidAngle)), _pieCenter.y + (_labelRadius * sin(interpolatedMidAngle)))];
            [CATransaction setDisableActions:NO];
        }
    }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (_animationTimer == nil) {
        static float timeInterval = 1.0/60.0;
        // Run the animation timer on the main thread.
        // We want to allow the user to interact with the UI while this timer is running.
        // If we run it on this thread, the timer will be halted while the user is touching the screen (that's why the chart was disappearing in our collection view).
        _animationTimer= [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    
    [_animations addObject:anim];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)animationCompleted
{
    [_animations removeObject:anim];
    
    if ([_animations count] == 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

#pragma mark - Touch Handing (Selection Notification)

- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SliceLayer *pieLayer = (SliceLayer *)obj;
        CGPathRef path = [pieLayer path];
        
        if (CGPathContainsPoint(path, &transform, point, 0)) {
            [pieLayer setLineWidth:_selectedSliceStroke];
            [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
            [pieLayer setLineJoin:kCALineJoinBevel];
            [pieLayer setZPosition:MAXFLOAT];
            selectedIndex = idx;
        } else {
            [pieLayer setZPosition:kDefaultSliceZOrder];
            [pieLayer setLineWidth:0.0];
        }
    }];
    return selectedIndex;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    
    [self getCurrentSelectedOnTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    [self notifyDelegateOfSelectionChangeFrom:_selectedSliceIndex to:selectedIndex];
    [self touchesCancelled:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    for (SliceLayer *pieLayer in pieLayers) {
        [pieLayer setZPosition:kDefaultSliceZOrder];
        [pieLayer setLineWidth:0.0];
    }
}

#pragma mark - Selection Notification

- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection
{
    
    if (previousSelection != newSelection)
    {
        if (previousSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
        {
            [_delegate pieChart:self willDeselectSliceAtIndex:previousSelection];
        }
        
        _selectedSliceIndex = newSelection;
        
        if (newSelection != -1)
        {
            if([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
            if(previousSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                [_delegate pieChart:self didDeselectSliceAtIndex:previousSelection];
            if([_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
            [self setSliceSelectedAtIndex:newSelection];
        }
        
        if(previousSelection != -1)
        {
            [self setSliceDeselectedAtIndex:previousSelection];
            if([_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                [_delegate pieChart:self didDeselectSliceAtIndex:previousSelection];
        }
    }
    else if (newSelection != -1)
    {
        SliceLayer *layer = [_pieView.layer.sublayers objectAtIndex:newSelection];
        if(_selectedSliceOffsetRadius > 0 && layer){
            
            if (layer.isSelected) {
                if ([_delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)])
                    [_delegate pieChart:self willDeselectSliceAtIndex:newSelection];
                [self setSliceDeselectedAtIndex:newSelection];
                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)])
                    [_delegate pieChart:self didDeselectSliceAtIndex:newSelection];
            }
            else {
                if ([_delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)])
                    [_delegate pieChart:self willSelectSliceAtIndex:newSelection];
                [self setSliceSelectedAtIndex:newSelection];
                if (newSelection != -1 && [_delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)])
                    [_delegate pieChart:self didSelectSliceAtIndex:newSelection];
            }
        }
    }
    
}

#pragma mark - Selection Programmatically Without Notification

- (void)setSliceSelectedAtIndex:(NSInteger)index
{
    if(_selectedSliceOffsetRadius <= 0)
        return;
    SliceLayer *layer = [_pieView.layer.sublayers objectAtIndex:index];
    if (layer && !layer.isSelected) {
        CGPoint currPos = layer.position;
        double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
        CGPoint newPos = CGPointMake(currPos.x + _selectedSliceOffsetRadius*cos(middleAngle), currPos.y + _selectedSliceOffsetRadius*sin(middleAngle));
        layer.position = newPos;
        layer.isSelected = YES;
    }
}

- (void)setSliceDeselectedAtIndex:(NSInteger)index
{
    if(_selectedSliceOffsetRadius <= 0)
        return;
    SliceLayer *layer = [_pieView.layer.sublayers objectAtIndex:index];
    if (layer && layer.isSelected) {
        layer.position = CGPointMake(0, 0);
        layer.isSelected = NO;
    }
}

#pragma mark - Pie Layer Creation Method

- (SliceLayer *)createSliceLayer
{
    SliceLayer *pieLayer = [SliceLayer layer];
    [pieLayer setZPosition:0];
    [pieLayer setStrokeColor:NULL];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)[self.labelFont fontName]);
    [textLayer setFont:font];
    CFRelease(font);
    [textLayer setFontSize:self.labelFont.pointSize];
    [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [textLayer setForegroundColor:self.labelColor.CGColor];
    if (self.labelShadowColor) {
        [textLayer setShadowColor:self.labelShadowColor.CGColor];
        [textLayer setShadowOffset:CGSizeZero];
        [textLayer setShadowOpacity:1.0f];
        [textLayer setShadowRadius:2.0f];
    }
    CGSize size = [@"0" sizeWithFont:self.labelFont];
    [CATransaction setDisableActions:YES];
    [textLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [textLayer setPosition:CGPointMake(_pieCenter.x + (_labelRadius * cos(0)), _pieCenter.y + (_labelRadius * sin(0)))];
    
    [CATransaction setDisableActions:NO];
    [pieLayer addSublayer:textLayer];
    return pieLayer;
}

- (void)updateLabelForLayer:(SliceLayer *)pieLayer value:(CGFloat)value
{
    CATextLayer *textLayer = [[pieLayer sublayers] objectAtIndex:0];
    
    [textLayer setHidden:!_showLabel];
    if(!_showLabel) return;
    NSString *label;
    if(_showPercentage)
        label = [NSString stringWithFormat:@"%0.0f", pieLayer.percentage*100];
    else
        
        label = (pieLayer.text)?pieLayer.text:[NSString stringWithFormat:@"%0.0f", value];
    
    CGSize size = [label sizeWithFont:self.labelFont];
    [CATransaction setDisableActions:YES];
    
//    [textLayer setString:label];
//    [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
    
//    if(M_PI*2*_labelRadius*pieLayer.percentage < MAX(size.width,size.height) || value <= 0)
    if(M_PI*2*_labelRadius*pieLayer.percentage > MAX(size.width,size.height) || value > 0)
    {
        [textLayer setString:label];
        [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];

    }
    else if (M_PI*2*_labelRadius*pieLayer.percentage == 0 || value == 0)
    {
        [textLayer setString:@""];

    }
    else
    {
        [textLayer setString:label];
        [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
    }
    
    }

#pragma mark My Delegate Methods
- (void)renderInLayer:(DLPieChart *)layerHostingView dataArray:(NSMutableArray*)dataArray
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Breakdown"])
    {
        if([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            
            self.DLDataArray = [dataArray objectAtIndex:1];
            self.DLPieChartView = layerHostingView;
            
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPHONE) {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:8]];
            }
            if (IS_IPAD) {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
                
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            else if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
            }
            
            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            
             if ([dataArray count])
             {
            [self drawLegends:layerHostingView dataArray:dataArray];
             }
        }
        else
        {
            NSArray *colorsArray;
        
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = dataArray;
            self.DLPieChartView = layerHostingView;
            
            colorsArray = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor blueColor], nil];
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[colorsArray objectAtIndex:i]];
            }
            
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:8]];
                
            }
            if (IS_IPAD) {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
             if ([dataArray count])
             {
            [self drawLegends:layerHostingView dataArray:dataArray];
             }
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Notification"])
    {
        if ([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = [dataArray objectAtIndex:0];
            self.DLPieChartView = layerHostingView;
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
             if (![dataArray count])
             {
             }
            else
            {
            [self drawLegends:layerHostingView dataArray:dataArray];
            }
           
        }
       else if ([self.selectedIdentifier isEqualToString:@"SingleClick"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = [dataArray objectAtIndex:0];
            self.DLPieChartView =layerHostingView;
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
             if ([dataArray count])
             {
            [self drawLegends:layerHostingView dataArray:dataArray];
             }
        }

        else
        {
            NSArray *colorsArray;

            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = dataArray;
            self.DLPieChartView = layerHostingView;
            colorsArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:50.0/255 green:205.0/255 blue:50.0/255 alpha:1.0],[UIColor colorWithRed:51.0/255 green:51.0/255 blue:255.0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:255.0/255 blue:0/255 alpha:1.0], nil];
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[colorsArray objectAtIndex:i]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
            }
            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            
            if ([dataArray count])
            {
                [self drawLegends:layerHostingView dataArray:dataArray];

            }
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Order"])
    {
        if ([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = [dataArray objectAtIndex:0];
            self.DLPieChartView = layerHostingView;
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            if (![dataArray count])
            {
            }
            else
            {
                [self drawLegends:layerHostingView dataArray:dataArray];
            }
            
        }
        else if ([self.selectedIdentifier isEqualToString:@"SingleClick"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = [dataArray objectAtIndex:0];
            self.DLPieChartView =layerHostingView;
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            if ([dataArray count])
            {
                [self drawLegends:layerHostingView dataArray:dataArray];
            }
        }
        
        else
        {
            NSArray *colorsArray;
            
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = dataArray;
            self.DLPieChartView = layerHostingView;
            colorsArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:50.0/255 green:205.0/255 blue:50.0/255 alpha:1.0],[UIColor colorWithRed:51.0/255 green:51.0/255 blue:255.0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:255.0/255 blue:0/255 alpha:1.0], nil];
            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[colorsArray objectAtIndex:i]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
            }
            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            
            if ([dataArray count])
            {
                [self drawLegends:layerHostingView dataArray:dataArray];
                
            }
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Permit"])
    {
        NSArray *piechartColorsArray;

        if ([self.selectedIdentifier isEqualToString:@"FirstPieChart"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            
            self.DLDataArray = dataArray;
            self.DLPieChartView = layerHostingView;
            
            piechartColorsArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:255.0/255.0 green:255.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:0/255 blue:255.0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:128.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:1.0], nil];

            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[piechartColorsArray objectAtIndex:i]];
            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
               // [layerHostingView setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:10]];
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
//                Helvetica Neue
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];

            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];

            [layerHostingView reloadData];
            if ([dataArray count])
            {
            [self drawLegends:layerHostingView dataArray:dataArray];
            }
        }
        else if ([self.selectedIdentifier isEqualToString:@"SecondPieChart"])
        {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = dataArray ;
            self.DLPieChartView = layerHostingView;
            piechartColorsArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:255.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:128.0/255 blue:0/255 alpha:1.0], nil];

            for(int i=0;i<self.DLDataArray.count;i++)
            {
                [self.DLColorsArray addObject:[piechartColorsArray objectAtIndex:i]];
            }
//            for (int i = 0; i<self.DLDataArray.count; i++)
//            {
//                [self.DLColorsArray addObject:[[[dataArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:i]];
//            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
                
            }
            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
            [layerHostingView reloadData];
            if ([dataArray count])
            {
            [self drawLegends:layerHostingView dataArray:dataArray];
            }
        }
          else
          {
            if(!self.DLDataArray)
                DLDataArray = [[NSMutableArray alloc] init];
            [self.DLColorsArray removeAllObjects];
            if(!self.DLColorsArray)
                DLColorsArray = [[NSMutableArray alloc] init];
            self.DLDataArray = [dataArray objectAtIndex:1];
             //self.DLDataArray = dataArray;

            self.DLPieChartView = layerHostingView;
              
              piechartColorsArray = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:153.0/255 green:0/255 blue:153.0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:215.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:127.0/255 blue:80.0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:128.0/255 blue:255.0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:186.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:0/255 green:128.0/255 blue:0/255 alpha:1.0],[UIColor colorWithRed:145.0/255 green:186.0/255 blue:0/255 alpha:1.0], nil];
              
              for(int i=0;i<self.DLDataArray.count;i++)
              {
                  [self.DLColorsArray addObject:[piechartColorsArray objectAtIndex:i]];
              }
//            for(int i=0;i<self.DLDataArray.count;i++)
//            {
//                [self.DLColorsArray addObject:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
//            }
            [layerHostingView setDataSource:self];
            [layerHostingView setDelegate:self];
            
            //[self.pieChartLeft setStartPieAngle:M_PI_2];
            [layerHostingView setAnimationSpeed:1.0];
            [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
            if (IS_IPAD)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:(14-DLDataArray.count/2)]];
            }
            if (IS_IPHONE)
            {
                [layerHostingView setLabelFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
            }
            [layerHostingView setShowPercentage:NO];
            [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            if (IS_IPAD) {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
                
            }
            if (IS_IPHONE)
            {
                [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
            }
            [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
            [layerHostingView setUserInteractionEnabled:YES];
            [layerHostingView setLabelShadowColor:[UIColor blackColor]];
            
              if ([dataArray count])
              {
            [self drawLegends:layerHostingView dataArray:dataArray];
              }
              else
              {
                  [self drawLegends:layerHostingView dataArray:nil];
  
              }
              [layerHostingView reloadData];

        }
        
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Availability"])
    {
        NSArray *colorsArray;
        
        if(!self.DLDataArray)
            DLDataArray = [[NSMutableArray alloc] init];
        [self.DLColorsArray removeAllObjects];
        if(!self.DLColorsArray)
            DLColorsArray = [[NSMutableArray alloc] init];
        self.DLDataArray = dataArray;
        self.DLPieChartView = layerHostingView;
        colorsArray = [NSMutableArray arrayWithObjects:[UIColor blueColor],[UIColor greenColor],[UIColor redColor], nil];
        for(int i=0;i<self.DLDataArray.count;i++)
        {
            [self.DLColorsArray addObject:[colorsArray objectAtIndex:i]];
        }
        [layerHostingView setDataSource:self];
        [layerHostingView setDelegate:self];
        
        //[self.pieChartLeft setStartPieAngle:M_PI_2];
        [layerHostingView setAnimationSpeed:1.0];
        [layerHostingView setPieRadius:((MIN(layerHostingView.frame.size.width, layerHostingView.frame.size.height) - OFFSET*4))/2];
        if (IS_IPAD)
        {
            [layerHostingView setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:(14-DLDataArray.count/2)]];
        }
        if (IS_IPHONE)
        {
            [layerHostingView setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:10]];
        }
        [layerHostingView setShowPercentage:NO];
        [layerHostingView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        if (IS_IPAD) {
            [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+OFFSET, layerHostingView.pieRadius+OFFSET)];
            
        }
        if (IS_IPHONE)
        {
            [layerHostingView setPieCenter:CGPointMake(layerHostingView.pieRadius+5, layerHostingView.pieRadius+OFFSET)];
        }
        [layerHostingView setLabelRadius:(layerHostingView.pieRadius*0.65)];
        [layerHostingView setUserInteractionEnabled:YES];
        [layerHostingView setLabelShadowColor:[UIColor blackColor]];
        
        [layerHostingView reloadData];
        
         if ([dataArray count])
         {
        [self drawLegends:layerHostingView dataArray:dataArray];
         }
        
    }

}
- (void)customamizeDraw:(DLPieChart*)pieChart
              pieCentre:(CGPoint)pieCentre
         animationSpeed:(CGFloat)speed
            labelRadius:(CGFloat)labelRadius
{
    [pieChart setAnimationSpeed:speed];
    [pieChart setLabelRadius:labelRadius];
    [pieChart setPieCenter:pieCentre];
    //    [pieChart setTag:1];
    [pieChart reloadData];
}

-(void)drawLegends:(DLPieChart *)layerHostingView dataArray:(NSMutableArray*)dataArray
{
    UIView *legendsView = [[UIView alloc] init];
    legendsView.frame = CGRectMake(layerHostingView.pieCenter.x+layerHostingView.pieRadius+OFFSET*2, 10, 150, 200);
    [legendsView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    UIScrollView *legendsScrollView = [[UIScrollView alloc] init];
    legendsScrollView.frame = CGRectMake(0, 0, legendsView.frame.size.width, legendsView.frame.size.height);
    [legendsScrollView setBackgroundColor:[UIColor clearColor]];
    [legendsView addSubview:legendsScrollView];
    
    //legend view border
    //[legendsView.layer setBorderColor:[UIColor blackColor].CGColor];
    //[legendsView.layer setBorderWidth:2.0];
    //[legendsView.layer setCornerRadius:5.0];
    
    CGFloat legendX,legendY,legendWidth, legendHeight;
    
    NSLog(@"hosting:%@ centre:%@ radius:%f",NSStringFromCGRect(layerHostingView.frame),NSStringFromCGPoint(layerHostingView.pieCenter),(layerHostingView.pieRadius));
    legendX = layerHostingView.pieCenter.x+layerHostingView.pieRadius+OFFSET*2;
    legendY = OFFSET*2;
    legendWidth = layerHostingView.frame.size.width - OFFSET*2 - (layerHostingView.pieRadius*2);
    
    legendHeight = layerHostingView.pieRadius * 2 - OFFSET;
    
    legendsView.frame = CGRectMake(legendX, legendY, legendWidth, legendHeight);
    legendsScrollView.frame = CGRectMake(0, 0, legendsView.frame.size.width, legendsView.frame.size.height);
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Breakdown"])
    {
        [legendsView setBackgroundColor:[UIColor whiteColor]];

        if ([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            int y = 5;
            
            // [legendsScrollView removeFromSuperview];
            
            //labels
            for (int i=0;i<[[dataArray objectAtIndex:0]count];i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                if (IS_IPHONE)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 100, 30)];
                    lbl.numberOfLines = 2;
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                }
                if (IS_IPAD)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 255, 25)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                lbl.text = [NSString stringWithFormat:@"%@ (%@)",[[dataArray objectAtIndex:0]objectAtIndex:i],[[dataArray objectAtIndex:1]objectAtIndex:i]];
                // lbl.text = [NSString stringWithFormat:@"%@ ",[dataArray objectAtIndex:i]];
                
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
        
        else
        {
            //labels
            int y = 5;
            NSArray *tempArray = [NSArray arrayWithObjects:@"Total Breakdowns",@"Frequency",@"Total PM Offline", nil];
            for (int i=0;i<tempArray.count;i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                if (IS_IPHONE)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 250, 20)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                }
                if (IS_IPAD)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
                
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
                
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Notification"])
    {
        [legendsView setBackgroundColor:[UIColor whiteColor]];

        NSMutableArray *sampleArray,*headerTextArray,*typeArray;
        if (sampleArray == nil || typeArray == nil || headerTextArray == nil)
        {
            sampleArray = [NSMutableArray new];
            headerTextArray = [NSMutableArray new];
            typeArray = [NSMutableArray new];

        }
        else
        {
            [sampleArray removeAllObjects];
            [headerTextArray removeAllObjects];
            [typeArray removeAllObjects];

        }
        
        Response *res_obj;
        res_obj = [Response sharedInstance];
        UILabel *lbl;
        if ([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            int y = 5;
            for (int i=0;i<[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0]count];i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                
                if (IS_IPHONE) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 90, 30)];
                    lbl.numberOfLines = 2;
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                    
                }
                else if (IS_IPAD) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                
                lbl.text = [NSString stringWithFormat:@"%@-%@ (%@)",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i],[[dataArray objectAtIndex:0] objectAtIndex:i]];
               
               [typeArray addObject:[NSString stringWithFormat:@"%@-%@",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i]]] ;
                
                res_obj.notifTypeArray  = typeArray;
                if (lbl.text.length) {
                    
                    if (lbl.text.length >2) {
                        [sampleArray addObject:[lbl.text substringToIndex:2]];
                        [headerTextArray addObject:lbl.text];

                    }
                    else{
                    
                        [sampleArray addObject:@""];
                        [headerTextArray addObject:@""];

                    }
                }
                else{
                
                    [sampleArray addObject:@""];
                    [headerTextArray addObject:@""];

                }
                
                res_obj.myArray = [NSArray arrayWithObjects:sampleArray, nil];
                res_obj.notifHeaderArray = [NSArray arrayWithObjects:headerTextArray, nil];

                //
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            //        [sampleArray addObject:[lbl.text substringToIndex:2]];
            //  res_obj.myArray = [NSArray arrayWithObjects: lbl.text, nil];
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
       else if ([self.selectedIdentifier isEqualToString:@"SingleClick"])
       {
           int y = 5;
           for (int i=0;i<[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0]count];i++)
           {
               btn = [UIButton buttonWithType:UIButtonTypeCustom];
               if (IS_IPHONE) {
                   btn.frame = CGRectMake(0, y, 25, 25);
                   
               }
               else if (IS_IPAD) {
                   btn.frame = CGRectMake(0, y, 25, 25);
                   
               }
               btn.tag = i;
               [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
               btn.backgroundColor = [DLColorsArray objectAtIndex:i];
               [legendsScrollView addSubview:btn];
               
               if (IS_IPHONE) {
                   lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 90, 30)];
                   lbl.numberOfLines = 2;
                   [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                   
               }
               else if (IS_IPAD) {
                   lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                   [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
               }
               
               lbl.text = [NSString stringWithFormat:@"%@-%@ (%@)",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i],[[dataArray objectAtIndex:0] objectAtIndex:i]];
               
               if (lbl.text.length) {
                   
                   if (lbl.text.length >2) {
                       [sampleArray addObject:[lbl.text substringToIndex:2]];
                       [headerTextArray addObject:lbl.text];

                   }
                   else{
                       
                       [sampleArray addObject:@""];
                       [headerTextArray addObject:@""];

                   }
               }
               else{
                   
                   [sampleArray addObject:@""];
                   [headerTextArray addObject:@""];

               }
               
               res_obj.myArray = [NSArray arrayWithObjects:sampleArray, nil];
               res_obj.notifHeaderArray = [NSArray arrayWithObjects:headerTextArray, nil];

               //
               lbl.backgroundColor = [UIColor clearColor];
               [lbl setAdjustsFontSizeToFitWidth:YES];
               [legendsScrollView addSubview:lbl];
               
               y += lbl.frame.size.height+5;
           }
           //        [sampleArray addObject:[lbl.text substringToIndex:2]];
           //  res_obj.myArray = [NSArray arrayWithObjects: lbl.text, nil];
           
           legendsScrollView.contentSize = CGSizeMake(0, y);
           
           [layerHostingView addSubview:legendsView];
       }

        else
        {
            //labels
            int y = 5;
            NSArray *tempArray = [NSArray arrayWithObjects:@"Completed",@"In progress",@"Outstanding",nil];
            for (int i=0;i<tempArray.count;i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                
                if (IS_IPHONE) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 20)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];

                    
                }
                else if (IS_IPAD) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];

                    
                }
                
                lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
                
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Order"])
    {
        [legendsView setBackgroundColor:[UIColor whiteColor]];
        
        NSMutableArray *sampleArray,*headerTextArray,*typeArray;
        if (sampleArray == nil || typeArray == nil || headerTextArray == nil)
        {
            sampleArray = [NSMutableArray new];
            headerTextArray = [NSMutableArray new];
            typeArray = [NSMutableArray new];
            
        }
        else
        {
            [sampleArray removeAllObjects];
            [headerTextArray removeAllObjects];
            [typeArray removeAllObjects];
            
        }
        
        Response *res_obj;
        res_obj = [Response sharedInstance];
        UILabel *lbl;
        if ([self.selectedIdentifier isEqualToString:@"DoubleClick"])
        {
            int y = 5;
            for (int i=0;i<[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0]count];i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                
                if (IS_IPHONE) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 90, 30)];
                    lbl.numberOfLines = 2;
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                    
                }
                else if (IS_IPAD) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                
                lbl.text = [NSString stringWithFormat:@"%@-%@(%@)",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i],[[dataArray objectAtIndex:0] objectAtIndex:i]];
                
                [typeArray addObject:[NSString stringWithFormat:@"%@-%@",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i]]] ;
                
                res_obj.notifTypeArray  = typeArray;
                if (lbl.text.length) {
                    
                    if (lbl.text.length) {
                        [sampleArray addObject:[lbl.text substringToIndex:4]];
                        [headerTextArray addObject:lbl.text];
                        
                    }
                    else{
                        
                        [sampleArray addObject:@""];
                        [headerTextArray addObject:@""];
                        
                    }
                }
                else{
                    
                    [sampleArray addObject:@""];
                    [headerTextArray addObject:@""];
                    
                }
                
                res_obj.myArray = [NSArray arrayWithObjects:sampleArray, nil];
                res_obj.notifHeaderArray = [NSArray arrayWithObjects:headerTextArray, nil];
                
                //
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            //        [sampleArray addObject:[lbl.text substringToIndex:2]];
            //  res_obj.myArray = [NSArray arrayWithObjects: lbl.text, nil];
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
        else if ([self.selectedIdentifier isEqualToString:@"SingleClick"])
        {
            int y = 5;
            for (int i=0;i<[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0]count];i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                
                if (IS_IPHONE) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 90, 30)];
                    lbl.numberOfLines = 2;
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                    
                }
                else if (IS_IPAD) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                
                lbl.text = [NSString stringWithFormat:@"%@-%@ (%@)",[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] objectAtIndex:i],[[[[dataArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] objectAtIndex:i],[[dataArray objectAtIndex:0] objectAtIndex:i]];
                
                if (lbl.text.length) {
                    
                    if (lbl.text.length >2) {
                        [sampleArray addObject:[lbl.text substringToIndex:2]];
                        [headerTextArray addObject:lbl.text];
                        
                    }
                    else{
                        
                        [sampleArray addObject:@""];
                        [headerTextArray addObject:@""];
                        
                    }
                }
                else{
                    
                    [sampleArray addObject:@""];
                    [headerTextArray addObject:@""];
                    
                }
                
                res_obj.myArray = [NSArray arrayWithObjects:sampleArray, nil];
                res_obj.notifHeaderArray = [NSArray arrayWithObjects:headerTextArray, nil];
                
                //
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            //        [sampleArray addObject:[lbl.text substringToIndex:2]];
            //  res_obj.myArray = [NSArray arrayWithObjects: lbl.text, nil];
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
        
        else
        {
            //labels
            int y = 5;
            NSArray *tempArray = [NSArray arrayWithObjects:@"Completed",@"In progress",@"Outstanding",nil];
            for (int i=0;i<tempArray.count;i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                    
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                    
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                
                if (IS_IPHONE) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 20)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                    
                    
                }
                else if (IS_IPAD) {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                    
                    
                }
                
                lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
                
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
    }
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Permit"])
    {
        [legendsView setBackgroundColor:[UIColor whiteColor]];

        NSMutableArray *textArray = [NSMutableArray new];
    
        Response *res_obj = [Response sharedInstance];
        
        if ([self.selectedIdentifier isEqualToString:@"FirstPieChart"])
        {
            //labels
            int y = 5;
            NSArray *tempArray = [NSArray arrayWithObjects:@"Created",@"Prepared",@"Closed", nil];
            
            for (int i=0;i<tempArray.count;i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                if (IS_IPHONE)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 250, 20)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                }
                if (IS_IPAD)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
                
                lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
                
               // NSString *str = lbl.text;
                
                //[textArray addObject:str];
//                res_obj.permitTextArray = [NSArray arrayWithObjects:textArray, nil];
//                NSLog(@"res_obj.permitTextArray %@",res_obj.permitTextArray);
                
                [textArray removeAllObjects];
                [textArray addObjectsFromArray:[NSArray arrayWithObjects:@"Crea",@"Prep",@"Clsd", nil]];
                res_obj.permitTextArray = textArray;

                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
        else if ([self.selectedIdentifier isEqualToString:@"SecondPieChart"])
        {
            //labels
            int y = 5;
            NSArray *tempArray = [NSArray arrayWithObjects:@"Not Issued",@"Partially Issued",@"Issued", nil];
            for (int i=0;i<tempArray.count;i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                if (IS_IPHONE)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 250, 20)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                }
                if (IS_IPAD)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                }
            
                lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
            
                if (lbl.text.length) {
                    [textArray addObject:lbl.text];
                }
                else{
                
                    [textArray addObject:@""];
                }
                
                res_obj.permitSecondTextArray = [NSArray arrayWithObjects:textArray, nil];
                NSLog(@"res_obj.permitTextArray %@",res_obj.permitSecondTextArray);
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
                
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
       
         else
        {
            //labels
            int y = 5;
//            NSArray *tempArray = [NSArray arrayWithObjects:@"Not Issued",@"Partially Issued",@"Issued", nil];
            for (int i=0;i<[[dataArray objectAtIndex:0]count];i++)
            {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (IS_IPHONE) {
                    btn.frame = CGRectMake(0, y, 20, 20);
                }
                else if (IS_IPAD) {
                    btn.frame = CGRectMake(0, y, 25, 25);
                }
                
                btn.tag = i;
                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [DLColorsArray objectAtIndex:i];
                [legendsScrollView addSubview:btn];
                UILabel *lbl;
                if (IS_IPHONE)
                {

                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 80, 25)];
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
                    lbl.numberOfLines = 2;

                }
                if (IS_IPAD)
                {
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 150, 30)];
                    
                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
                    lbl.numberOfLines = 2;

                }
                
                lbl.text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:0] objectAtIndex:i]];
                
                lbl.backgroundColor = [UIColor clearColor];
                [lbl setAdjustsFontSizeToFitWidth:YES];
                [legendsScrollView addSubview:lbl];
                
                y += lbl.frame.size.height+5;
                
            }
            
            legendsScrollView.contentSize = CGSizeMake(0, y);
            
            [layerHostingView addSubview:legendsView];
        }
//         {
//            int y = 5;
//            
//            // [legendsScrollView removeFromSuperview];
//            
//            //labels
//            for (int i=0;i<[[dataArray objectAtIndex:0] count];i++)
//            {
//                btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                if (IS_IPHONE) {
//                    btn.frame = CGRectMake(0, y, 25, 25);
//                }
//                else if (IS_IPAD) {
//                    btn.frame = CGRectMake(0, y, 25, 25);
//                }
//                btn.tag = i;
//                [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
////                for (int j=0;j<[[dataArray objectAtIndex:1] count];j++)
////                {
////                    NSString *indexString =[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:1] objectAtIndex:j]];
////                    if (![indexString isEqualToString:@"0"])
////                    {
////                        btn.backgroundColor = [DLColorsArray objectAtIndex:j];
////
////                    }
////// 
////                }
//                [legendsScrollView addSubview:btn];
//                UILabel *lbl;
//                if (IS_IPHONE)
//                {
//                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 80, 30)];
//                    lbl.numberOfLines = 2;
//                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:10]];
//                }
//                if (IS_IPAD)
//                {
//                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 255, 25)];
//                    
//                    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
//                }
//               // lbl.text = [NSString stringWithFormat:@"%@ (%@)",[dataArray objectAtIndex:i],[dataArray objectAtIndex:i]];
//                
//                lbl.text = [NSString stringWithFormat:@"%@ ",[[dataArray objectAtIndex:0] objectAtIndex:i]];
//            
//                lbl.backgroundColor = [UIColor clearColor];
//                [lbl setAdjustsFontSizeToFitWidth:YES];
//                [legendsScrollView addSubview:lbl];
//                
//                y += lbl.frame.size.height+5;
//            }
//             for (int j=0;j<[[dataArray objectAtIndex:1] count];j++)
//             {
//                 NSString *indexString =[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:1] objectAtIndex:j]];
//                 if (![indexString isEqualToString:@"0"])
//                 {
//                     btn.backgroundColor = [DLColorsArray objectAtIndex:j];
//                     
//                 }
//                 //
//             }
//
////                    else
////                    {
////                        NSLog(@"Yes");
////                    }
//            legendsScrollView.contentSize = CGSizeMake(0, y);
//            
////            [layerHostingView addSubview:legendsView];
//             //   }
//                
//           // }
//             [layerHostingView addSubview:legendsView];
//
//        }
    }
    
    else if ([[defaults objectForKey:@"PiechartStatus"] isEqualToString:@"Availability"])
    {
        [legendsView setBackgroundColor:[UIColor whiteColor]];

        //labels
        int y = 5;
        NSArray *tempArray = [NSArray arrayWithObjects:@"Total Breakdown Time",@"Frequency",@"Total PM Offline ", nil];
        for (int i=0;i<tempArray.count;i++)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (IS_IPHONE) {
                btn.frame = CGRectMake(0, y, 20, 20);
                
            }
            else if (IS_IPAD) {
                btn.frame = CGRectMake(0, y, 25, 25);
                
            }
            
            btn.tag = i;
            [btn addTarget:self action:@selector(legendClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [DLColorsArray objectAtIndex:i];
            [legendsScrollView addSubview:btn];
            UILabel *lbl;
            if (IS_IPHONE)
            {
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 250, 20)];
                
                [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
            }
            if (IS_IPAD)
            {
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 250, 25)];
                
                [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15]];
            }
            lbl.text = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:i]];
            
            lbl.backgroundColor = [UIColor clearColor];
            [lbl setAdjustsFontSizeToFitWidth:YES];
            [legendsScrollView addSubview:lbl];
            
            y += lbl.frame.size.height+5;
            
        }
        legendsScrollView.contentSize = CGSizeMake(0, y);
        
        [layerHostingView addSubview:legendsView];
    }
    

}

-(void)legendClicked:(UIButton*)selectedButton
{
    [MISViewController handleTapGesture:selectedButton];
    
 
}
#pragma mark - DLPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(DLPieChart *)pieChart
{
    return self.DLDataArray.count;
}

- (CGFloat)pieChart:(DLPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.DLDataArray objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(DLPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //if(pieChart == self.pieChartRight) return nil;
    return [self.DLColorsArray objectAtIndex:(index % self.DLColorsArray.count)];
}

#pragma mark - DLPieChart Delegate
- (void)pieChart:(DLPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    // NSLog(@"did select slice at index %lu",(unsigned long)index);
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    NSLog(@"What is the label at this index %@", [self.DLDataArray objectAtIndex:index]);
    _sliceIndex = (unsigned long)index;
    
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.DLDataArray objectAtIndex:index]];
    //    NSLog(@"indexvalue = %@",_sliceIndex);
    
    
}



@end
