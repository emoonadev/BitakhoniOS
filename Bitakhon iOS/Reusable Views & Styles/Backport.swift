//
// Created by Mickael Belhassen on 09/01/2022.
//

import SwiftUI

// https://davedelong.com/blog/2021/10/09/simplifying-backwards-compatibility-in-swift/
struct Backport<Content> {
    let content: Content

    init(content: Content) {
        self.content = content
    }
}

extension View {
    var backport: Backport<Self> { Backport(content: self) }
}

extension Backport where Content: View {

    @ViewBuilder func neverAutocapitalization() -> some View {
        if #available(iOS 15, *) {
            content.textInputAutocapitalization(.never)
        } else {
            content.autocapitalization(.none)
        }
    }

}