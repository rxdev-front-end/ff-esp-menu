#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "imgui.h"
#include "imgui_impl_metal.h"
#include "esp.hpp"

void drawMenu();

@interface OverlayVC : UIViewController <MTKViewDelegate>
@property (nonatomic, strong) MTKView *view;
@property (nonatomic, strong) id<MTLCommandQueue> queue;
@end

@implementation OverlayVC
- (void)viewDidLoad {
    [super viewDidLoad];
    id<MTLDevice> dev = MTLCreateSystemDefaultDevice();
    self.queue = [dev newCommandQueue];
    self.view = [[MTKView alloc] initWithFrame:self.view.bounds device:dev];
    self.view.delegate = self;
    self.view.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.view.opaque = NO;
    self.view.userInteractionEnabled = YES;
    [self.view setPreferredFramesPerSecond:60];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.view];
    [self.view addConstraints:@[
        [self.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]]];
    
    IMGUI_CHECKVERSION(); ImGui::CreateContext();
    ImGui::GetIO().IniFilename = nullptr;
    ImGui::StyleColorsDark();
    ImGui_ImplMetal_Init(dev);
    ESP::init();
}

- (void)drawInMTKView:(MTKView *)view {
    ImGui::GetIO().DisplaySize = ImVec2(view.bounds.size.width, view.bounds.size.height);
    id<MTLCommandBuffer> cmd = [self.queue commandBuffer];
    MTLRenderPassDescriptor *rp = view.currentRenderPassDescriptor;
    if (!rp) { [cmd commit]; return; }
    
    ImGui_ImplMetal_NewFrame(rp); ImGui::NewFrame();
    ESP::tick(); drawMenu(); ImGui::Render();
    
    id<MTLRenderCommandEncoder> enc = [cmd renderCommandEncoderWithDescriptor:rp];
    ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), cmd, enc);
    [enc endEncoding]; [cmd presentDrawable:view.currentDrawable]; [cmd commit];
}
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {}
@end

__attribute__((constructor))
static void on_load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        win.windowLevel = UIWindowLevelAlert + 100;
        win.backgroundColor = [UIColor clearColor];
        win.rootViewController = [OverlayVC new];
        win.hidden = NO;
    });
}
