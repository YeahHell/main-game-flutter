// ios/Runner/AppDelegate.swift
import Flutter
import UIKit
import SwiftUI
import AVKit
import iOS_NNSBComponent

@main
@objc class AppDelegate: FlutterAppDelegate {

  // MARK: - App lifecycle
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    configureAppearance()
    configureSBComponent()
    configureAudioSession()
    setupIQKeyboardManager()

    GeneratedPluginRegistrant.register(with: self)

    // Ensure FlutterViewController is embedded in a UINavigationController so we can PUSH
    if let flutterVC = window?.rootViewController as? FlutterViewController {
      let nav = UINavigationController(rootViewController: flutterVC)
      nav.setNavigationBarHidden(true, animated: false)
      window?.rootViewController = nav
      window?.makeKeyAndVisible()

      let channel = FlutterMethodChannel(name: "ksport_minigame",
                                         binaryMessenger: flutterVC.binaryMessenger)

      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "presentGame":
          let args = call.arguments as? [String: Any]
          self.pushSBComponent(from: self.topMost(from: self.window?.rootViewController),
                               args: args,
                               onExit: {
            // Notify Flutter that the game was closed
            channel.invokeMethod("gameClosed", arguments: nil)
          })
          result(nil)

        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Deeplinks
  override func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    handleDeepLink(url)
    return true
  }

  override func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      handleDeepLink(url)
      return true
    }
    return false
  }
}

// MARK: - SB Presenter (Push)
private extension AppDelegate {

  func topMost(from root: UIViewController?) -> UIViewController? {
    var vc = root
    while let presented = vc?.presentedViewController { vc = presented }
    if let nav = vc as? UINavigationController { return nav.visibleViewController }
    if let tab = vc as? UITabBarController { return tab.selectedViewController }
    return vc
  }

  /// Push SBView instead of presenting it. No "X" button.
  func pushSBComponent(from presenter: UIViewController?,
                       args: [String: Any]?,
                       onExit: @escaping () -> Void) {
    // Find a navigation controller to push onto
    let nav: UINavigationController? = (presenter as? UINavigationController)
      ?? presenter?.navigationController
      ?? (window?.rootViewController as? UINavigationController)

    guard let nav = nav else {
      assertionFailure("No UINavigationController available to push SBComponent")
      return
    }

    let tpToken = (args?["tpToken"] as? String) ?? ""
    let meta = (args?["meta"] as? [String: String]) ?? [:]

    let config = SBComponentConfiguration(
      tpToken: tpToken,
      agentId: 4,
      userProfile: nil,
      signInAction: nil,
      signUpAction: nil,
      expiredAction: nil,
      onChangeRotation: { isLandscape in
        UIDevice.current.setValue(isLandscape ? UIInterfaceOrientation.landscapeRight.rawValue
                                              : UIInterfaceOrientation.portrait.rawValue,
                                  forKey: "orientation")
      },
      showToastAction: { _ in },
      metaData: meta
    )

    // No CloseWrapper, push SBView directly
    let root = SBView(configuration: config,
                      onFinish: {
                        // 1) notify Flutter
                        onExit()
                        // 2) go back to Flutter by popping
                        nav.popViewController(animated: true)
                      },
                      onRequestDeposit: { })

    let host = UIHostingController(rootView: root)
    host.hidesBottomBarWhenPushed = true
    nav.pushViewController(host, animated: true)
  }
}

// MARK: - Configs
private extension AppDelegate {
  func configureAppearance() {
    let nav = UINavigationBarAppearance()
    nav.configureWithTransparentBackground()
    nav.backgroundColor = .clear
    nav.shadowColor = .clear
    UINavigationBar.appearance().standardAppearance = nav
    UINavigationBar.appearance().scrollEdgeAppearance = nav
    UINavigationBar.appearance().compactAppearance = nav
    UIBarButtonItem.appearance().tintColor = .clear
  }

  func configureSBComponent() {
    SBComponentInstallConfig.configuration()
  }

  func configureAudioSession() {
    try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
  }

  func setupIQKeyboardManager() {  }

  func handleDeepLink(_ url: URL) {
    // If root is now a UINavigationController, get its FlutterViewController
    let rootVC: UIViewController? = {
      if let nav = window?.rootViewController as? UINavigationController {
        return nav.viewControllers.first
      }
      return window?.rootViewController
    }()

    if let flutterVC = rootVC as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "deep_link", binaryMessenger: flutterVC.binaryMessenger)
      channel.invokeMethod("openURL", arguments: url.absoluteString)
    }
  }
}
