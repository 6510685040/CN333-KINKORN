import Flutter
import UIKit
import FirebaseCore
import FirebaseAppCheck
//import FirebaseAppCheckPlayIntegrity

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    //AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory.self)
    //AppCheck.setAppCheckProviderFactory(AppCheckPlayIntegrityProviderFactory())
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
