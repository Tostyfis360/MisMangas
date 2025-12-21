//
//  UIImage.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat) async -> UIImage? {
        let scale = min(1, width / size.width)
        let size = CGSize(width: width, height: size.height * scale)
        return await byPreparingThumbnail(ofSize: size)
    }
}
