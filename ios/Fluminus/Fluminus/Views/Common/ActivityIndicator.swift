//
//  ActivityIndicator.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import SwiftUI

private struct _ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context _: UIViewRepresentableContext<_ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.hidesWhenStopped = true
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context _: UIViewRepresentableContext<_ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicator: View {
    @Binding var isShown: Bool

    var body: some View {
        _ActivityIndicator(isAnimating: $isShown, style: .large)
            .frame(width: 80, height: 80)
            .background(Color.secondary)
            .foregroundColor(.primary)
            .cornerRadius(10)
            .opacity(isShown ? 0.5 : 0)
    }
}

#if DEBUG
struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isShown: .constant(true))
    }
}
#endif
