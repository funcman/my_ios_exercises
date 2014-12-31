#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hello:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Hi, iOS!"
                                                    message: @"Sorry, I'm too late..."
                                                   delegate: self
                                          cancelButtonTitle: @"That's OK."
                                          otherButtonTitles: nil, nil];
    [alert show];
}

@end
