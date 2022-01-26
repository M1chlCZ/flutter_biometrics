import Flutter
import UIKit
import Foundation
import LocalAuthentication

public class SwiftFlutterBiometricsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "flutter_biometrics", binaryMessenger: registrar.messenger())
      let instance = SwiftFlutterBiometricsPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "getPlatformVersion") {
                 result("iOS " + UIDevice.current.systemVersion)
      }else if (call.method == "getPlatformBiometrics") {
             let res = checkAuth()
                 result(res)
      }

    }

    func checkAuth() -> String {
         let authType = LocalAuthManager.shared.biometricType
            switch authType {
            case .none:
                return "nothing"
            case .touchID:
                return "TouchID"
            case .faceID:
                return "FaceID"
            default:
                return "nothing"
            }
     }
  }

  public class LocalAuthManager: NSObject {

      public static let shared = LocalAuthManager()
      private let context = LAContext()
      private let reason = "Your Request Message"
      private var error: NSError?

      enum BiometricType: String {
          case none
          case touchID
          case faceID
      }

      private override init() {

      }

      // check type of local authentication device currently support
      var biometricType: BiometricType {
          guard self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
              return .none
          }

          if #available(iOS 11.0, *) {
              switch context.biometryType {
              case .none:
                  return .none
              case .touchID:
                  return .touchID
              case .faceID:
                  return .faceID
              @unknown default:
                  return .none
              }
          } else {
              return self.context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) ? .touchID : .none
          }
      }
  }