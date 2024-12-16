import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register plugins with the Flutter engine.
    GeneratedPluginRegistrant.register(with: self)

    // Additional setup if needed can go here.

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
