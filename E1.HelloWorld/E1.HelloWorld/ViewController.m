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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"Sorry, I'm too late..."
                                                       delegate: self
                                              cancelButtonTitle: @"That's OK."
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView:self.view];
}

- (IBAction)ask:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                    message: @"Are you iPhone or iPad?"
                                                   delegate: self
                                          cancelButtonTitle: @"It's a secret."
                                          otherButtonTitles: @"I'm iPhone.", @"Oh, I'm iPod.", @"iPad is me.", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(![alertView.message isEqualToString:@"Are you iPhone or iPad?"]) return;
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    NSString *words;
    switch (buttonIndex) {
        case 1:
        case 2:
        case 3: {
            if(         [device isEqualToString:@"iPho"] && 1==buttonIndex ) {
                words = @"Hi, iPhone!";
            }else if(   [device isEqualToString:@"iPod"] && 2==buttonIndex ) {
                words = @"Hi, iPod!";
            }else if(   [device isEqualToString:@"iPad"] && 3==buttonIndex ) {
                words = @"Hi, iPad!";
            }else {
                words = @"Hi, Swindler!";
            }
        }break;
        default: {
            words = @"哦";
        }break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                    message: nil
                                                   delegate: self
                                          cancelButtonTitle: words
                                          otherButtonTitles: nil];
    [alert show];
}

@end
