/*
 SecretDesktopAppModel.swift
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
import SpiceKey

protocol SecretDesktopAppModel: ObservableObject {
    associatedtype SM: SecretModel
    associatedtype MVM: MenuViewModel

    var secretModel: SM { get }
}

final class SecretDesktopAppModelImpl: SecretDesktopAppModel {
    typealias SM = SecretModelImpl
    typealias MVM = MenuViewModelImpl

    let secretModel: SM
    private var spiceKey: SpiceKey?
    private var cancellables = Set<AnyCancellable>()

    init() {
        secretModel = SM()

        NotificationCenter.default
            .publisher(for: NSApplication.didFinishLaunchingNotification)
            .sink { [weak self] _ in
                self?.applicationDidFinishLaunching()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.applicationWillTerminate()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                self?.secretModel.closePanels()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
            .sink { [weak self] _ in
                self?.secretModel.resetPanels()
            }
            .store(in: &cancellables)
    }

    private func applicationDidFinishLaunching() {
        spiceKey = SpiceKey(secretModel.keyCombination, keyDownHandler: { [weak self] in
            self?.secretModel.toggle()
        })
        spiceKey?.register()

        Task { @MainActor in
            secretModel.toggle()
        }
    }

    private func applicationWillTerminate() {
        spiceKey?.unregister()
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class SecretDesktopAppModelMock: SecretDesktopAppModel {
        typealias SM = SecretModelMock
        typealias MVM = MenuViewModelMock

        let secretModel = SM()
    }
}
