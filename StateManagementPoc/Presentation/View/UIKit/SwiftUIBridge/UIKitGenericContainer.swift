//
//  UIKitGenericContainer.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


import SwiftUI
import UIKit

struct UIKitGenericContainer<VC: UIViewController>: UIViewControllerRepresentable {

    let builder: () -> VC

    init(builder: @escaping () -> VC) {
        self.builder = builder
    }

    func makeUIViewController(context: Context) -> VC {
        builder()
    }

    func updateUIViewController(_ uiViewController: VC, context: Context) {
        // intentionally unimplemented
    }
}
