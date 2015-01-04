#import "OGLView.h"

@implementation OGLView

- (id)initWithFrame:(CGRect)frame {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    self = [super initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
