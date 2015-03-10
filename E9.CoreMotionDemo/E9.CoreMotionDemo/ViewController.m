#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () {
    CMStepCounter*              stepCounter;
    CMPedometer*                pedometer;
    CMMotionActivityManager*    activityManager;
    CMAltimeter*                altimeter;
}

@property (weak, nonatomic) IBOutlet UILabel *numOfSteps;
@property (weak, nonatomic) IBOutlet UILabel *activity;
@property (weak, nonatomic) IBOutlet UILabel *altitude;
@property (weak, nonatomic) IBOutlet UILabel *presure;
@property (weak, nonatomic) IBOutlet UISegmentedControl *meter;
@property (weak, nonatomic) IBOutlet UITextView *logView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.logView.layer setCornerRadius:3];

    self.meter.selectedSegmentIndex = 0;
    [self installStepCounter];

    [self installActivityManager];
    
    [self installAltimeter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchMeter:(id)sender {
    self.numOfSteps.text = @"0";
    switch (self.meter.selectedSegmentIndex) {
        case 0:
            [self installStepCounter];
            break;
        case 1:
            [self installPedometer];
            break;
        default:
            break;
    }
}

- (void)installStepCounter {
    if (![CMStepCounter isStepCountingAvailable]) {
        [self appendLog:@"CMStepCounter is unavailable."];
        return;
    }
    [self appendLog:@"Use CMStepCounter."];
    [pedometer stopPedometerUpdates];
    stepCounter = [[CMStepCounter alloc]init];
    [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:0 withHandler:^(NSInteger numberOfSteps, NSDate* timestamp, NSError* error) {
        if (!error) {
            [self showNumOfSteps:[NSNumber numberWithInteger:numberOfSteps]];
            [self appendLog:[NSString stringWithFormat:@"StepCounter update: %@ steps now.", self.numOfSteps.text]];
        }
    }];
}

- (void)installPedometer {
    if (![CMPedometer isStepCountingAvailable]) {
        [self appendLog:@"CMPedometer is unavailable."];
        return;
    }
    [self appendLog:@"Use CMPedometer."];
    [stepCounter stopStepCountingUpdates];
    pedometer = [[CMPedometer alloc]init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData* data, NSError* error){
        if (!error) {
            [self performSelectorOnMainThread:@selector(showNum:) withObject:data.numberOfSteps waitUntilDone:YES];
            [self appendLog:[NSString stringWithFormat:@"Pedometer update: %@ steps now.", self.numOfSteps.text]];
        }
    }];
}

- (void)installActivityManager {
    if (![CMMotionActivityManager isActivityAvailable]) {
        [self appendLog:@"CMMotionActivityManager is unavailable."];
        return;
    }
    [self appendLog:@"CMActivityManager start."];
    activityManager = [[CMMotionActivityManager alloc]init];
    [activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity* activity) {
        if (activity.stationary) {
            self.activity.text = @"Stationary";
        }else if (activity.walking) {
            self.activity.text = @"Walking";
        }else if (activity.running) {
            self.activity.text = @"Running";
        }else if (activity.automotive) {
            self.activity.text = @"Automotive";
        }else if (activity.cycling) {
            self.activity.text = @"Cycling";
        }else {
            self.activity.text = @"Unknown";
        }
        [self appendLog:[NSString stringWithFormat:@"Activity:%@ StartTime:%@ Confidence:%d",
                         self.activity.text,
                         [self getTime:activity.startDate],
                         (int)activity.confidence]];
    }];
}

- (void)installAltimeter {
    if (![CMAltimeter isRelativeAltitudeAvailable]) {
        [self appendLog:@"CMAltimeter is unavailable."];
        return;
    }
    [self appendLog:@"CMAltimeter start."];
    altimeter = [[CMAltimeter alloc]init];
    [altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
        if (!error) {
            self.altitude.text  = [NSString stringWithFormat:@"%0.2f", [altitudeData.relativeAltitude doubleValue]];
            self.presure.text   = [NSString stringWithFormat:@"%0.2f", [altitudeData.pressure doubleValue]];
            [self appendLog:[NSString stringWithFormat:@"RelativeAltitude:%@ Presure:%@", self.altitude.text, self.presure.text]];
        }
    }];
}

- (void)showNumOfSteps:(NSNumber*)number {
    self.numOfSteps.text = [number stringValue];
}

- (void)appendLog:(NSString*)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* curTimeStr = [self getTime:[NSDate date]];
        NSLog(@"%@", log);
        self.logView.text = [NSString stringWithFormat:@"%@: %@\n%@", curTimeStr, log, self.logView.text];
    });
}

- (NSString*)getTime:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss:SSS"];
    return [dateFormatter stringFromDate:date];
}

@end
