#import <UIKit/UIKit.h>

// Declarações das nossas views (que estão nos outros arquivos)
@interface MenuView : UIView
@end
@interface ESPView : UIView
@end

// Janela customizada pra deixar o toque passar pro jogo onde não tiver botão
@interface OverlayWindow : UIWindow
@end

@implementation OverlayWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self || hitView == self.rootViewController.view) {
        return nil; // Deixa o toque ir pro jogo
    }
    return hitView;
}
@end

// Função que injeta as views na tela
static void setupOverlay() {
    // 1. Procura a cena ativa do app
    UIWindowScene *activeScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
            activeScene = (UIWindowScene *)scene;
            break;
        }
    }

    if (!activeScene) return; // Se não achou, tenta no próximo timer

    // 2. Cria a nossa janela em cima do jogo
    OverlayWindow *win = [[OverlayWindow alloc] initWithWindowScene:activeScene];
    win.frame = activeScene.coordinateSpace.bounds;
    win.windowLevel = UIWindowLevelAlert + 100; // Fica por cima de tudo
    win.backgroundColor = [UIColor clearColor];
    
    // 3. Cria o controlador base
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    win.rootViewController = vc;

    // 4. Adiciona a View do ESP (fundo, só desenha)
    ESPView *esp = [[ESPView alloc] initWithFrame:win.bounds];
    [vc.view addSubview:esp];

    // 5. Adiciona a View do Menu (frente, interativo)
    MenuView *menu = [[MenuView alloc] initWithFrame:CGRectMake(40, 100, 220, 100)];
    [vc.view addSubview:menu];

    win.hidden = NO;
}

__attribute__((constructor))
static void on_load() {
    // Espera o jogo carregar e fica tentando injetar a tela até conseguir
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull t) {
            setupOverlay();
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    });
}
