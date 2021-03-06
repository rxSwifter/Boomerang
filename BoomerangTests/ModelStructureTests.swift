//
//  BoomerangTests.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import XCTest
import Nimble
import Quick

@testable import Boomerang

class ModelStructureSpec: QuickSpec {
    override func spec() {
        describe("a ModelStructure ") {
            it("has everything you need to get started") {
                
                let s = ModelStructure([ModelType]())
                expect(s.models).to(haveCount(0))
                expect(s.children).to(beNil())
                
                let index:IndexPath = IndexPath(item: 0, section: 0)
                expect(s.modelAtIndex(index)).to(beNil())
                
            }
            context ("when initialized with a single 'line'") {
                it ("should not have any child") {
                    let s = ModelStructure(["A","B","C"])
                    expect (s.children).to(beNil())
                    expect (s.models).to(haveCount(3))
                }
                it ("should properly return indexPaths") {
                    let s = ModelStructure(["A","B","C"])
                    
                    expect(s.indexPaths()).to(equal([IndexPath(indexes:[0]),IndexPath(indexes:[1]),IndexPath(indexes:[2])]))
                }
            }
            
            context ("when initialized multiline") {
                it ("should not have models") {
                    let s = ModelStructure(children: [
                        ModelStructure(["A"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    expect (s.models).to(beNil())
                    expect(s.children).to(haveCount(3))
                    
                }
                it ("should should have titles") {
                    let s = ModelStructure(children: [
                        ModelStructure(["A"], sectionModel:"Title")
                        ])
                    expect (s.models).to(beNil())
                    expect(s.children).to(haveCount(1))
                    expect(s.children?.first?.sectionModel as? String).to(equal("Title"))
                }
                
                
                it ("should properly return indexPaths") {
                    let s1 = ModelStructure(children: [
                        ModelStructure(["A","D"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    expect(s1.indexPaths()).to(equal([IndexPath(indexes:[0,0]),IndexPath(indexes:[0,1]),IndexPath(indexes:[1,0]),IndexPath(indexes:[2,0])]))
                    
                    let s2 = ModelStructure(children: [s1,s1])
                    expect(s2.indexPaths()).to(equal([IndexPath(indexes:[0,0,0]),IndexPath(indexes:[0,0,1]),IndexPath(indexes:[0,1,0]),IndexPath(indexes:[0,2,0]),
                                                      IndexPath(indexes:[1,0,0]), IndexPath(indexes:[1,0,1]),IndexPath(indexes:[1,1,0]),IndexPath(indexes:[1,2,0])]))
                }
                it ("should properly return all data as one-line array") {
                    let s1 = ModelStructure(children: [
                        ModelStructure(["A","D"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    
                    expect (s1.allData() as? [String]).to(equal(["A","D","B","C"]))
                    
                    
                    let s2 = ModelStructure(children: [s1,s1])
                    expect(s2.allData() as? [String]).to(equal(["A","D","B","C","A","D","B","C"]))
                }
            }

            
        }
    }
}


