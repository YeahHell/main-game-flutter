//
//  BasicGameProcessor.swift
//  Runner
//
//  Created by Karen on 11/09/2025.
//

import Flutter
import SwiftUI
import UIKit
import Mega645
import Power655
import LDMD5
import Lodesieutoc


extension AppDelegate {
    func presentBasicGame(nav: UINavigationController, args: [String: Any], channel: FlutterMethodChannel) {
        print("present Mega Game arguments: \(args)")
        let id = args["id"] as? String ?? ""
        let tpToken = args["tpToken"] as? String ?? ""
        let balance = args["balance"] as? Double ?? 0
        
        var gameView: AnyView?
        if id == "techplay_mn_1008" {
            gameView = AnyView(
                Mega645(token: tpToken, balance: balance) {
                    self.requestDeposit(nav: nav, channel: channel, gameID: id)
                }.ignoresSafeArea(edges: .top)
            )
        } else if id == "techplay_mn_1009" {
            gameView = AnyView(
                Power655(token: tpToken, balance: balance) {
                    self.requestDeposit(nav: nav, channel: channel, gameID: id)
                }.ignoresSafeArea(edges: .top)
            )
        } else if id == "techplay_lodemd5" {
            LDMD5.shared.prepare()
            LDMD5.shared.setToken(tpToken)
            gameView = AnyView(
                LDMD5LauncherView(onFinish: {
                    nav.popViewController(animated: true)
                    self.isGameActive = false
                }, onRequestDeposit: {
                    self.requestDeposit(nav: nav, channel: channel, gameID: id)
                }).navigationBarHidden(true)
                    .ignoresSafeArea(.all)
            )
        } else if id == "techplay_lode_virtual" {
            LDST.shared.prepare()
            LDST.shared.setToken(tpToken)
            gameView = AnyView(
                LDSTLauncherView(onFinish: {
                    nav.popViewController(animated: true)
                    self.isGameActive = false
                }, onRequestDeposit: {
                    self.requestDeposit(nav: nav, channel: channel, gameID: id)
                }).ignoresSafeArea(.all)
            )
        }
        
        let host = UIHostingController(rootView: AnyView(gameView))
        host.hidesBottomBarWhenPushed = true
        nav.pushViewController(host, animated: true)

        DispatchQueue.main.async {
            nav.interactivePopGestureRecognizer?.isEnabled = true
            nav.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
