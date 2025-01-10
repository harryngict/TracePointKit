//
//  TracePointKitDemoView.swift
//  Example
//
//  Created by Harry Nguyezn on 01/10/25.
//

import SwiftUI
import TracePointKit

struct TracePointKitDemoView: View {
  // MARK: Lifecycle

  init(tracePointKit: TracePointKit) {
    self.tracePointKit = tracePointKit
  }

  // MARK: Internal

  var body: some View {
    Text("TracePointKitDemoView")
      .onAppear {
        tracePointKit.infor("com.example.demo", "print infor")
        tracePointKit.warning("com.example.demo", "print warning")
        tracePointKit.error("com.example.demo", "print error")
      }
  }

  // MARK: Private

  private let tracePointKit: TracePointKit
}
