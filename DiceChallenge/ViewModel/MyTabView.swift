//
//  MyTabView.swift
//  Some Dices
//
//  Created by Alex Oliveira on 24/01/2022.
//

import SwiftUI

struct MyTabView: View {
    @EnvironmentObject var dices: Dices
    @EnvironmentObject var results: Results
    @EnvironmentObject var settings: Settings
    @Binding var selectedTab: String
    @Binding var isShowingFullTabView: Bool
    @Binding var pageTabViewIndexDisplayMode: PageTabViewStyle.IndexDisplayMode

    var body: some View {
        if isShowingFullTabView {
            VStack {
                TabView(selection: $selectedTab) {
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                        }
                        .tag("Settings")

                    DicesView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "dice.fill")
                        }
                        .tag("Dices")

                    ResultsView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle.portrait")
                        }
                        .tag("Results")
                }
                .tabViewStyle(.page(indexDisplayMode: pageTabViewIndexDisplayMode))
                #if os(iOS)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")
                }
                #endif
            }
        } else {
            VStack {
                TabView(selection: $selectedTab) {
                    if selectedTab == "Settings" {
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                            }
                            .tag("Settings")
                    }

                    if selectedTab == "Dices" {
                        DicesView(selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "dice.fill")
                            }
                            .tag("Dices")
                    }

                    if selectedTab == "Results" {
                        ResultsView(selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "list.bullet.rectangle.portrait")
                            }
                            .tag("Results")
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    #if os(iOS)
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")
                    #endif
                }
            }
        }
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView(
            selectedTab: .constant("Dices"),
            isShowingFullTabView: .constant(false),
            pageTabViewIndexDisplayMode: .constant(.always)
        )
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
            .environmentObject(Settings())
    }
}
