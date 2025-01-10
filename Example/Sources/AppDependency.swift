//
//  AppDependency.swift
//  Example
//
//  Created by Harry Nguyezn on 01/10/25.
//

import TracePointKit

// MARK: - AppDependency

protocol AppDependency: AnyObject {
  var tracePointKit: TracePointKit { get }
}

// MARK: - AppDependencyImp

final class AppDependencyImp: AppDependency {
  // MARK: Lifecycle

  init(tracePointKit: TracePointKit) {
    self.tracePointKit = tracePointKit
  }

  // MARK: Internal

  let tracePointKit: TracePointKit
}
