//
//  ContentView.swift
//  Example
//
//  Created by Harry Nguyezn on 01/10/25.
//

import SwiftUI

struct ContentView: View {
  // MARK: Lifecycle

  init(dependency: AppDependency) {
    self.dependency = dependency
  }

  // MARK: Internal

  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: TracePointKitDemoView(tracePointKit: dependency.tracePointKit)) {
          Text("Tap to open TracePointKitDemo")
        }
      }
      .navigationTitle("Kits")
    }
  }

  // MARK: Private

  private let dependency: AppDependency
}
