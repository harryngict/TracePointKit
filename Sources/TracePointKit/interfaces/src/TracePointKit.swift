//
//  TracePointKit.swift
//  TracePointKit
//
//  Created by Harry Nguyezn on 01/10/25.
//

import Foundation

// MARK: - TracePointKit

/// @mockable
public protocol TracePointKit: AnyObject {
  func infor(_ tag: String, _ message: String)
  func warning(_ tag: String, _ message: String)
  func error(_ tag: String, _ message: String)
  func success(_ tag: String, _ message: String)
}
