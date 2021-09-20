//
//  NewsItem.swift
//  NewsItem
//
//  Created by Manish Punia on 20/09/21.
//

import Foundation

struct NewItemList:Decodable {
    var hits:[NewsItem]
}


struct NewsItem:Decodable, Encodable,Hashable {
    
    var id:Int?
    var created_at:String?
    var author:String?
    var title:String?
    var points:Int?
    var parent_id:Int?
    var story_text:String?
    var url:String?
    var comment_text:String?
    
    var children:[NewsItem]?
}
