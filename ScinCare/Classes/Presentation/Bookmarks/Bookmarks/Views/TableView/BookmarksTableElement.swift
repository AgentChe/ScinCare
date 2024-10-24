//
//  BookmarksTableElement.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

final class BookmarksTableElement {
    let catalog: Catalog
    var selected: Bool?
    
    init(
        catalog: Catalog,
        selected: Bool?
    ) {
        self.catalog = catalog
        self.selected = selected
    }
}
