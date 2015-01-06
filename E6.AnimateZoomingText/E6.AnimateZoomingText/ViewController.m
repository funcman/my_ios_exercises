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

- (IBAction)play:(id)sender {
    CABasicAnimation *zooming = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zooming.duration = 0.2;
    zooming.repeatCount = 1;
    zooming.autoreverses = YES;
    zooming.fromValue = [NSNumber numberWithFloat:1.0];
    zooming.toValue = [NSNumber numberWithFloat:0.5];
    zooming.delegate = self;

    [[self.label layer]addAnimation:zooming forKey:@""];
}

- (void)animationDidStart:(CAAnimation *)anim {
    [[[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Hi, funcman!" otherButtonTitles:nil]show];
}

@end
