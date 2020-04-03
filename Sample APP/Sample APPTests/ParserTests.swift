//
//  Sample_APPTests.swift
//  Sample APPTests
//
//  Created by Vignesh Radhakrishnan on 01/04/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import XCTest
@testable import Sample_APP

class ParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testParserDecode() {
        guard let inputFileURL = Bundle.main.path(forResource: "Sample", ofType: "json", inDirectory: "root") else { return }
      //  let inputFileURL = Bundle.init(for: self.classForCoder).url(forResource: "Sample", withExtension: "json")
        let data = try! Data.init(contentsOf: URL.init(string: inputFileURL)!)
        let photos = try? Parser<Photos>().decode(data: data)
        XCTAssert(photos != nil)
        let photo = photos?.photo?.first
        let expectedPhoto = Photo(id: "4242343242", owner: "test", secret: "dssdada", server: "fdsfsdf", farm: 54, title: "New tree", ispublic: 1, isfriend: 1, isfamily: 1)
        XCTAssertEqual(photo!, expectedPhoto)
        XCTAssertEqual(photo!.id, expectedPhoto.id)
        XCTAssertEqual(photo!.owner, expectedPhoto.owner)
        XCTAssertEqual(photo!.secret, expectedPhoto.secret)
        XCTAssertEqual(photo!.server, expectedPhoto.server)
        XCTAssertEqual(photo!.farm, expectedPhoto.farm)
        XCTAssertEqual(photo!.title, expectedPhoto.title)
        XCTAssertEqual(photo!.ispublic, expectedPhoto.ispublic)
        XCTAssertEqual(photo!.isfriend, expectedPhoto.isfriend)
        XCTAssertEqual(photo!.isfamily, expectedPhoto.isfamily)
    }
    
    func testParserDecodeWithInvalidJSON() {
        let inputFileURL = Bundle.init(for: self.classForCoder).url(forResource: "InvalidSample", withExtension: "json")
        let data = try! Data.init(contentsOf: inputFileURL!)
        let photos = try? Parser<Photos>().decode(data: data)
        XCTAssert(photos == nil, "Problem in parser it is working even required value passed as nil")
    }
    
    func testParserEncode() {
           let photo = Photo(id: "4242343242", owner: "test", secret: "dssdada", server: "fdsfsdf", farm: 54, title: "New tree", ispublic: 1, isfriend: 1, isfamily: 1)
           let data = try? Parser<Photo>().encode(model: photo)
           XCTAssert(data != nil)
           
           let model = try? Parser<Photo>().decode(data: data!)
           XCTAssert(model != nil)
           XCTAssert(model!.id == "2750")
           
       }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
