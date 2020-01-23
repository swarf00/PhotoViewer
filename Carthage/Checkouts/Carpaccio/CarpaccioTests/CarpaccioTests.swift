//
//  CarpaccioTests.swift
//  CarpaccioTests
//
//  Created by Matias Piipari on 07/05/2016.
//  Copyright © 2016 Matias Piipari & Co. All rights reserved.
//

import XCTest
@testable import Carpaccio

class CarpaccioTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSonyRAWConversion() {
        let img1URL = Bundle(for: type(of: self)).url(forResource:"DSC00583", withExtension: "ARW")!

        let tempDir = URL(fileURLWithPath:NSTemporaryDirectory() + "/\(UUID().uuidString)")
        
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: [:])
        
        let converter = RAWImageLoader(imageURL: img1URL, thumbnailScheme: .fullImageWhenThumbnailMissing)
        
        converter.loadThumbnailImage(handler: { thumb, imageMetadata in
            XCTAssertEqual(thumb.size.width, 1616)
            XCTAssertEqual(thumb.size.height, 1080)
            
            XCTAssertEqual(imageMetadata.cameraMaker, "SONY")
            XCTAssertEqual(imageMetadata.cameraModel, "ILCE-7RM2")
            XCTAssertEqual(imageMetadata.ISO, 125.0)
            XCTAssertEqual(imageMetadata.nativeSize.width, 7952.0)
            XCTAssertEqual(imageMetadata.nativeSize.height, 5304.0)
            
            let testedComponents:Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
            let date = imageMetadata.timestamp!
            let components = Calendar(identifier: .gregorian).dateComponents(testedComponents, from: date)
            
            XCTAssertEqual(components.year, 2016)
            XCTAssertEqual(components.day, 16)
            XCTAssertEqual(components.month, 3)
            XCTAssertEqual(components.hour, 16)
            XCTAssertEqual(components.minute, 34)
            XCTAssertEqual(components.second, 21)
        }) { err in
            XCTFail("Error: \(err)")
        }
        
        try! FileManager.default.removeItem(at: tempDir)
    }
    
    func testDistanceMatrixComputation() {
        let resourcesDir = Bundle(for: type(of: self)).resourceURL!
        let imgColl = try! Collection(contentsOfURL: resourcesDir)
        
        // just checking that the matrix computation succeeds.
        let distances = imgColl.distanceMatrix { a, b in
            return Double.infinity
        }
        
        for (r, row) in distances.enumerated() {
            for (c, dist) in row.enumerated() {
                if c > r {
                    XCTAssert(dist.isInfinite)
                }
                else if c == r {
                    XCTAssert(dist == 0)
                }
                else if c < r {
                    XCTAssert(dist.isNaN) // the lower part under diagonal is filled with NaN (for now anyway, until we create a sparse matrix for the purpose)
                }
            }
        }
    }
    
    func testDistanceTableComputation() {
        let resourcesDir = Bundle(for: type(of: self)).resourceURL!
        let imgColl = try! Collection(contentsOfURL: resourcesDir)
        
        let distances = imgColl.distanceTable { a, b in
            return Double.infinity
        }
        
        for (r, row) in distances.enumerated() {
            for (c, dist) in row.enumerated() {
                if c == r {
                    XCTAssert(dist == 0)
                }
                else {
                    XCTAssert(dist.isInfinite)
                }
            }
        }
    }
    
}
