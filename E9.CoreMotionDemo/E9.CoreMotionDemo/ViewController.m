#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () {
    CMStepCounter*  stepCounter;
    CMPedometer*    pedometer;
}

@property (weak, nonatomic) IBOutlet UILabel *numOfSteps;
@property (weak, nonatomic) IBOutlet UISegmentedControl *meter;
@property (weak, nonatomic) IBOutlet UITextView *logView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.meter.selectedSegmentIndex = 0;
    [self installStepCounter];
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
    [self appendLog:@"Use CMStepCounter."];
    [pedometer stopPedometerUpdates];
    stepCounter = [[CMStepCounter alloc]init];
    [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:0 withHandler:^(NSInteger numberOfSteps, NSDate* timestamp, NSError* error) {
        if (!error) {
            [self showNum:[NSNumber numberWithInteger:numberOfSteps]];
            [self appendLog:[NSString stringWithFormat:@"StepCounter update: %@ steps now.", self.numOfSteps.text]];
        }
    }];
}

- (void)installPedometer {
    [self appendLog:@"Use CMPedometer."];
    [stepCounter stopStepCountingUpdates];
    pedometer = [[CMPedometer alloc]init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData* data, NSError* error){
        if (!error) {
            [self performSelectorOnMainThread:@selector(showNum:) withObject:data.numberOfSteps waitUntilDone:YES];
            [self appendLog:[NSString stringWithFormat:@"Pedometer update: %@ steps now.", self.numOfSteps.text]];        }
    }];
}

- (void)showNum:(NSNumber*)number {
    self.numOfSteps.text = [number stringValue];
}

- (void)appendLog:(NSString*)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm:ss:SSS"];
        NSString *curTimeStr = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"%@", log);
        self.logView.text = [NSString stringWithFormat:@"%@: %@\n%@", curTimeStr, log, self.logView.text];
    });
}

@end
