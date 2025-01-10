//
//  TracePointKitImp.swift
//  TracePointKitImp
//
//  Created by Harry Nguyezn on 01/10/25.
//

import TracePointKit

public final class TracePointKitImp: TracePointKit {
  // MARK: Lifecycle

  public init(isEnabled: Bool) {
    self.isEnabled = isEnabled
  }

  // MARK: Public

  public func infor(_ tag: String, _ message: String) {
    guard isEnabled else { return }
    print("ℹ️ [\(tag)] \(message)")
  }

  public func warning(_ tag: String, _ message: String) {
    guard isEnabled else { return }
    print("⚠️ [\(tag)] \(message)")
  }

  public func error(_ tag: String, _ message: String) {
    guard isEnabled else { return }
    print("❌ [\(tag)] \(message)")
  }

  public func success(_ tag: String, _ message: String) {
    guard isEnabled else { return }
    print("✅ [\(tag)] \(message)")
  }

  // MARK: Private

  private let isEnabled: Bool
}
