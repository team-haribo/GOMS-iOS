//
//  Bundle.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/25.
//

import Foundation

// MARK: - Swift Bundle Accessor

private class BundleFinder {}

extension Foundation.Bundle {
    /// Since GCMS is a application, the bundle for classes within this module can be used directly.
    static let module = Bundle(for: BundleFinder.self)
}

// MARK: - Objective-C Bundle Accessor

@objc
public class GCMSResources: NSObject {
    @objc public class var bundle: Bundle {
        return .module
    }
}
