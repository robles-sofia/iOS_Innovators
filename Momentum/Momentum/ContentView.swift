//
//  ContentView.swift
//  Momentum
//
//  Created by Michael Shelton on 2/26/26.
//

import SwiftUI
internal import PostgREST
import Supabase

struct ContentView: View {
    @State private var status = "Loading..."

        var body: some View {
            Text(status)
                .padding()
                .task {
                    await testSupabase()
                }
        }

        func testSupabase() async {
            do {
                let response = try await SupabaseManager.shared.client
                    .from("habits")
                    .select()
                    .limit(1)
                    .execute()

                status = "✅ Connected! Response bytes: \(response.data.count)"
            } catch {
                status = "❌ Error: \(error.localizedDescription)"
            }
        }
}

#Preview {
    ContentView()
}
