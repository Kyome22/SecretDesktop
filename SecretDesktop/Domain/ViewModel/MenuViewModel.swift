/*
 MenuViewModel.swift
 SecretDesktop

 Created by Takuto Nakamura on 2023/12/08.
 Copyright 2023 Takuto Nakamura

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import AppKit
import Combine
import SwiftUI

protocol MenuViewModel: ObservableObject {
    var isHidden: Bool { get set }
    var keyEquivalent: KeyEquivalent { get }
    var eventModifiers: EventModifiers { get }

    init(_ secretModel: SecretModel)

    func toggle()
    func openAbout()
    func terminateApp()
}

final class MenuViewModelImpl: MenuViewModel {
    @Published var isHidden: Bool = false
    let keyEquivalent: KeyEquivalent
    let eventModifiers: EventModifiers

    private let secretModel: SecretModel
    private var cancellables = Set<AnyCancellable>()

    init(_ secretModel: SecretModel) {
        self.secretModel = secretModel
        keyEquivalent = secretModel.keyCombination.key.keyEquivalent
        eventModifiers = secretModel.keyCombination.modifierFlags.eventModifiers

        secretModel.isHiddenPublisher
            .sink { [weak self] isHidden in
                self?.isHidden = isHidden
            }
            .store(in: &cancellables)
    }

    func toggle() {
        secretModel.toggle()
    }

    func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        let mutableAttrStr = NSMutableAttributedString()
        var attr: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.textColor]
        mutableAttrStr.append(NSAttributedString(string: String(localized: "oss"), attributes: attr))
        let url = "https://github.com/Kyome22/SecretDesktop"
        attr = [.foregroundColor: NSColor.url, .link: url]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel(options: [key: mutableAttrStr])
    }

    func terminateApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MenuViewModelMock: MenuViewModel {
        @Published var isHidden: Bool = false
        let keyEquivalent = KeyEquivalent("h")
        let eventModifiers: EventModifiers = [.shift, .command]

        init(_ secretModel: SecretModel) {}
        init() {}

        func toggle() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
