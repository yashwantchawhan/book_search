import UIKit
import Flutter
import AVFoundation
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate {
    let motionManager = CMMotionManager()

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
           let batteryLevel = UIDevice.current.batteryLevel
           if batteryLevel < 0 {
               result(0)
           } else {
               result(Int(batteryLevel * 100))
           }
          case MethodChannelConstants.getDeviceName:
              result(UIDevice.current.name)
          case MethodChannelConstants.getOSVersion:
              result(UIDevice.current.systemVersion)
          case MethodChannelConstants.toggleFlashlight:
              if let args = call.arguments as? [String: Any],
                     let on = args["on"] as? Bool {
                      self.toggleFlash(on: on)
                      result("Flash set to \(on ? "on" : "off")")
                  } else {
                      result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing or invalid 'on' parameter", details: nil))
                  }
           case MethodChannelConstants.getGyroscopeData:
              self.getGyroData(result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      }
  }
    
    func getGyroData(result: @escaping FlutterResult) {
            if motionManager.isGyroAvailable {
                motionManager.gyroUpdateInterval = 1.0 / 50.0
                motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] data, error in
                    if let data = data {
                        let gyroData: [String: Double] = [
                            "x": data.rotationRate.x,
                            "y": data.rotationRate.y,
                            "z": data.rotationRate.z
                        ]
                        result(gyroData)
                        self?.motionManager.stopGyroUpdates() // stop if single read
                    } else if let error = error {
                          print("⚠️ GYRO_ERROR.")
                          let defaultData: [String: Double] = ["x": 0.0, "y": 0.0, "z": 0.0]
                          result(defaultData)
                    }
                }
            } else {
                 print("⚠️ Gyroscope is not available on this device. Returning default values.")
                 let defaultData: [String: Double] = ["x": 0.0, "y": 0.0, "z": 0.0]
                 result(defaultData)

            }
        }

    func toggleFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("⚠️ Torch not available.")
            return
        }

        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: 1.0)
                print("✅ Torch turned ON")
            } else {
                device.torchMode = .off
                print("✅ Torch turned OFF")
            }
            device.unlockForConfiguration()
        } catch {
            print("⚠️ Torch error: \(error)")
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
