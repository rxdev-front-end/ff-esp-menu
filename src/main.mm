#import <UIKit/UIKit.h>

@interface MenuView : UIView
@end
@interface ESPView : UIView
@end

__attribute__((constructor))
static void on_load() {
    // Aumentei pra 5 segundos pra dar tempo do jogo carregar a tela de login
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // 1. Procura a janela principal do jogo
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        if (keyWindow) {
            // 2. Adiciona as views direto na View principal do jogo
            UIViewController *rootVC = keyWindow.rootViewController;
            
            ESPView *esp = [[ESPView alloc] initWithFrame:keyWindow.bounds];
            [rootVC.view addSubview:esp];

            MenuView *menu = [[MenuView alloc] initWithFrame:CGRectMake(40, 100, 220, 100)];
            [rootVC.view addSubview:menu];

            // 3. TESTE DE VIDA: Alerta na tela pra provar que a dylib rodou
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ollie" message:@"Dylib injetada com sucesso!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Fechar" style:UIAlertActionStyleDefault handler:nil]];
            [rootVC presentViewController:alert animated:YES completion:nil];
            
        } else {
            // Se não achou a janela, loga (se tiver como ver)
            NSLog(@"[ollie] Erro: Nao foi possivel encontrar a keyWindow.");
        }
    });
}
