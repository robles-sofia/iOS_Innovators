//
//  SettingsView.swift
//  Momentum
//
//  Created by Michael Shelton on 3/2/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var userName: String
    @Binding var backgroundColor: Color
    @Binding var notificationsOn: Bool

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                HStack {
                    TextField("Name", text: $userName)
                    Image(systemName: "pencil")
                        .foregroundStyle(.secondary)
                }
            }

            Section(header: Text("Background")) {
                ColorPicker("Customize", selection: $backgroundColor, supportsOpacity: false)
            }

            Section(header: Text("Notifications")) {
                Toggle("Toggle", isOn: $notificationsOn)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
