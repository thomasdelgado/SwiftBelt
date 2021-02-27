//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import SwiftUI

@available(iOS 14.0, *)
struct ThumbsAlertView: View {
    var parent: UIViewController
    var manager: StoreReviewManager


    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: close) {
                    Image(systemName: "xmark")
                        .font(Font.body.bold())
                }.padding()
            }
            Text("Enjoying the app so far?")
                .font(.title2)
                .layoutPriority(1)
            Text("Let us know")
                .font(.body)
            HStack(spacing: 30) {
                Button(action: thumbsUp, label: {
                    Image(systemName: "hand.thumbsup")
                        .resizable()
                }).frame(width: 50, height: 50)
                Button(action: thumbsDown, label: {
                    Image(systemName: "hand.thumbsdown")
                        .resizable()
                }).frame(width: 50, height: 50)
            }
            .padding()
            .padding()
            .padding()
        }
        .background(Color.clear)

    }

    func close() {
        parent.dismiss(animated: true) {}
    }

    func thumbsUp() {
        parent.dismiss(animated: true) {
            manager.showStoreReview()
        }
    }

    func thumbsDown() {
        parent.dismiss(animated: true) {
            manager.showFeedbackAlert()
        }
    }
}

@available(iOS 14.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbsAlertView(parent: UIViewController(), manager: StoreReviewManager.shared)
    }
}
