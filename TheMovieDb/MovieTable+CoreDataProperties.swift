//
//  MovieTable+CoreDataProperties.swift
//  SKY Test
//
//  Created by Intermat on 10/10/2019.
//  Copyright © 2019 Solucoes Digitais e Mobile. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieTable> {
        return NSFetchRequest<MovieTable>(entityName: "MovieTable")
    }

    @NSManaged public var idMovie: Int64
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var voteAverage: Double

}
