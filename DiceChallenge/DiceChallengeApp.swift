//
//  DiceChallengeApp.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

@main
struct DiceChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if targetEnvironment(macCatalyst)
                .onReceive(NotificationCenter.default.publisher(for: UIScene.willConnectNotification)) { _ in
                    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 640, height: 1020)
                    }
                }
                #endif
        }
    }
}
