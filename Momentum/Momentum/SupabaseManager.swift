//
//  SupabaseManager.swift
//  Momentum
//
//  Created by Wiley, Evan on 3/5/26.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let supabaseURL = URL(string: "https://ckmlpyiujnboppzrqqnp.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrbWxweWl1am5ib3BwenJxcW5wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA0MTg1NjYsImV4cCI6MjA4NTk5NDU2Nn0.i4_6qaQz5nSwZ48idKNhXpUGW5mNXCGFr7CqjAuUU00"

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
