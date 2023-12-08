/*
 SecretDesktopApp.swift
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

import SwiftUI

@main
struct SecretDesktopApp: App {
    typealias SAM = SecretDesktopAppModelImpl
    @StateObject private var appModel = SAM()

    var body: some Scene {
        MenuBarExtra {
            MenuView(viewModel: SAM.MVM(appModel.secretModel))
        } label: {
            Image(.statusIcon)
                .environment(\.displayScale, 2.0)
        }
    }
}
