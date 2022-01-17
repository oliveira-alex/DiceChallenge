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
                .onReceive(NotificationCenter.default.publisher(for: UIScene.willConnectNotification)) { _ in
                    #if targetEnvironment(macCatalyst)
                    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 800)
                    }
                    #endif
                }
        }
    }
}
