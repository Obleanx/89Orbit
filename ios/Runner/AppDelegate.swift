import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var blurView: UIVisualEffectView?
    var alertController: UIAlertController?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didTakeScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.screenCaptureDidChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func didTakeScreenshot() {
        showBlurAndAlert(message: "Screenshots are not allowed.")
    }
    
    @objc func screenCaptureDidChange() {
        if UIScreen.main.isCaptured {
            showBlurAndAlert(message: "Screen recording is not allowed.")
        } else {
            removeBlurAndAlert()
        }
    }
    
    func showBlurAndAlert(message: String) {
        DispatchQueue.main.async {
            if self.blurView == nil {
                let blurEffect = UIBlurEffect(style: .dark)
                self.blurView = UIVisualEffectView(effect: blurEffect)
                self.blurView?.frame = self.window?.bounds ?? CGRect.zero
                self.blurView?.alpha = 0.9
                self.window?.addSubview(self.blurView!)
            }
            
            if self.alertController == nil {
                self.alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.removeBlurAndAlert()
                }
                self.alertController?.addAction(okAction)
                self.window?.rootViewController?.present(self.alertController!, animated: true, completion: nil)
            }
        }
    }
    
    func removeBlurAndAlert() {
        DispatchQueue.main.async {
            self.blurView?.removeFromSuperview()
            self.blurView = nil
            self.alertController?.dismiss(animated: true, completion: nil)
            self.alertController = nil
        }
    }
}