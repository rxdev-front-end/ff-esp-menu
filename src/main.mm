#import <UIKit/UIKit.h>

@interface MenuView : UIView
@end
@interface ESPView : UIView
@end

__attribute__((constructor))
static void on_load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // 1. Cria a janela invisível por cima de tudo
        UIWindow *win = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        win.windowLevel = UIWindowLevelAlert + 100;
        win.backgroundColor = [UIColor clearColor];
        
        // 2. Cria um controlador vazio só pra segurar as views
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor clearColor];
        win.rootViewController = vc;

        // 3. Adiciona o ESPView (fundo, só desenha)
        ESPView *esp = [[ESPView alloc] initWithFrame:win.bounds];
        [vc.view addSubview:esp];

        // 4. Adiciona o MenuView (frente, interativo)
        MenuView *menu = [[MenuView alloc] initWithFrame:CGRectMake(40, 100, 220, 100)];
        [vc.view addSubview:menu];

        win.hidden = NO;
    });
}
