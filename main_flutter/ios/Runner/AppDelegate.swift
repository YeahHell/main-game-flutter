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

    if let flutterVC = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "ksport_minigame",
                                         binaryMessenger: flutterVC.binaryMessenger)

      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "presentGame":
          let args = call.arguments as? [String: Any]
          self.presentSBComponent(from: self.topMost(from: self.window?.rootViewController),
                                  args: args,
                                  onExit: {
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

// MARK: - SB Presenter
private extension AppDelegate {

  func topMost(from root: UIViewController?) -> UIViewController? {
    var vc = root
    while let presented = vc?.presentedViewController { vc = presented }
    if let nav = vc as? UINavigationController { return nav.visibleViewController }
    if let tab = vc as? UITabBarController { return tab.selectedViewController }
    return vc
  }

  func presentSBComponent(from presenter: UIViewController?,
                          args: [String: Any]?,
                          onExit: @escaping () -> Void) {
    guard let presenter = presenter, presenter.presentedViewController == nil else { return }

    let tpToken = (args?["tpToken"] as? String) ?? ""
    let meta = (args?["meta"] as? [String: String]) ?? [:]

    let config = SBComponentConfiguration(
      tpToken: tpToken,
      agentId: 25,
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

    let root = SBView(configuration: config,
                      onFinish: { onExit() },
                      onRequestDeposit: {  })

    let wrapped = CloseWrapper(root: root, onExit: onExit)
    let host = UIHostingController(rootView: wrapped)
    host.modalPresentationStyle = .fullScreen
    presenter.present(host, animated: true)
  }
}

struct CloseWrapper<Content: View>: View {
  @Environment(\.dismiss) private var dismiss
  let root: Content
  let onExit: () -> Void
  var body: some View {
      ZStack(alignment: .topLeading) {
          root
          Button {
              onExit()
              dismiss()
          } label: {
              Image(systemName: "xmark")
                  .font(.system(size: 14, weight: .semibold))
                  .padding(8)
                  .foregroundColor(.gray)
          }
      }
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
    if let flutterVC = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "deep_link", binaryMessenger: flutterVC.binaryMessenger)
      channel.invokeMethod("openURL", arguments: url.absoluteString)
    }
  }
}
