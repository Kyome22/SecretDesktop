/*
 SecretModel.swift
 SecretDesktop

 Created by Takuto Nakamura on 2023/12/09.
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
import SpiceKey

protocol SecretModel: AnyObject {
    var isHiddenPublisher: AnyPublisher<Bool, Never> { get }
    var keyCombination: KeyCombination { get }

    func toggle()
    func closePanels()
    func resetPanels()
}

final class SecretModelImpl: SecretModel {
    private let isHiddenSubject = CurrentValueSubject<Bool, Never>(false)
    var isHiddenPublisher: AnyPublisher<Bool, Never> {
        isHiddenSubject.eraseToAnyPublisher()
    }

    let keyCombination = KeyCombination(.h, .sftCmd)
    private var panels = [SecretPanel]()

    init() {}

    func toggle() {
        isHiddenSubject.value.toggle()
        if isHiddenSubject.value {
            NSScreen.screens.forEach { screen in
                let panel = SecretPanel(screen.displayID, screen.frame)
                panels.append(panel)
                panel.orderFrontRegardless()
                panel.setImage()
                panel.fadeIn()
            }
        } else {
            panels.forEach { $0.fadeOut() }
            panels.removeAll()
        }
    }

    func closePanels() {
        if isHiddenSubject.value {
            toggle()
        }
    }

    func resetPanels() {
        panels.forEach { $0.setImage() }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class SecretModelMock: SecretModel {
        var isHiddenPublisher: AnyPublisher<Bool, Never> {
            Just(false).eraseToAnyPublisher()
        }
        let keyCombination = KeyCombination(.h, .sftCmd)

        func toggle() {}
        func closePanels() {}
        func resetPanels() {}
    }
}
