//
//  CJImageModel.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/15.
//

import Foundation
import UIKit

public struct CJImageModel: CJBaseModel {
    var imageUrl: String?       // 图片的网络地址
    var imagePath: String?      // 图片的本地地址
    
    // MARK: - Equatable
    public static func == (lhs: CJImageModel, rhs: CJImageModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.imagePath == rhs.imagePath
    }
    
    // MARK: - Init
    public init() {
        
    }

    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case imageUrl
        case imagePath
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let imagePath = try container.decode(String.self, forKey: .imagePath)
        
        self.imageUrl = imageUrl
        self.imagePath = imagePath
        //self.init(id: id, componentType: componentType, data: data, layout: layout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(imagePath, forKey: .imagePath)
    }
    
    // MARK: Getter
    public var image: UIImage? {
        if imagePath != nil && imagePath!.count > 0 {
            return UIImage(named: imagePath!)
        } else if imageUrl != nil && imageUrl!.count > 0 {
            return UIImage(contentsOfFile: imageUrl!)
        } else {
            return nil
        }
    }
}
