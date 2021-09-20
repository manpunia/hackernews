//
//  NewsItemViewModel.swift
//  NewsItemViewModel
//
//  Created by Manish Punia on 20/09/21.
//

import Foundation

struct NewsItemListViewModel {
   private var items:[NewsItem]
    init(items: [NewsItem]) {
        self.items = items
    }
}

extension NewsItemListViewModel {
    
    var numberOfSections: Int{
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        return self.items.count
    }
    
    func itemAtIndex(_ index: Int) -> NewsItemViewModel {
        let item = self.items[index]
        return NewsItemViewModel(item)
    }
    
   mutating func add(items: [NewsItem])
    {
        self.items.append(contentsOf: items)
    }
}

struct NewsItemViewModel {
    private let item: NewsItem
    
}

extension NewsItemViewModel
{
    init(_ item: NewsItem) {
        self.item = item
    }
}

extension NewsItemViewModel
{
    var title: String
    {
        return self.item.title ?? (self.item.story_text ?? "")
    }
    
    var subtitle: String
    {
        if let url = self.item.url
        {
            return url
        }
        else
        {
            return "No URL found"
        }
    }
}
