import UIKit
import Flutter
import AVFoundation
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
       GeneratedPluginRegistrant.register(with: self)
       setupMethodChannelHandler()
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func setupMethodChannelHandler() {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(
          name: MethodChannelConstants.channel,
          binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { (call, result) in
          print("🚀 Handling method: \(call.method)")
          switch call.method {
          case MethodChannelConstants.getBatteryLevel:
               // UIDevice.current.isBatteryMonitoringEnabled = true
                 result(Int(50))
//                      let batteryLevel = UIDevice.current.batteryLevel
//                      if batteryLevel < 0 {
//                          result(FlutterError(code: "UNAVAILABLE",
//                                              message: "Battery info not available",
//                                              details: nil))
//                      } else {
//                          result(Int(batteryLevel * 100))
//                      }
          case MethodChannelConstants.getDeviceName:
              result(UIDevice.current.name)
          case MethodChannelConstants.getOSVersion:
              result(UIDevice.current.systemVersion)
          case MethodChannelConstants.toggleFlashlight:
              result(nil)
           case MethodChannelConstants.getGyroscopeData:
              result(["x": 0, "y": 0, "z": 0])
          default:
              result(FlutterMethodNotImplemented)
          }
      }
  }
}

struct MethodChannelConstants {
    static let channel = "com.example.book_search/device_info"
    static let getBatteryLevel = "getBatteryLevel"
    static let getDeviceName = "getDeviceName"
    static let getOSVersion = "getOSVersion"
    static let toggleFlashlight = "toggleFlashlight"
    static let getGyroscopeData = "getGyroscopeData"
}
