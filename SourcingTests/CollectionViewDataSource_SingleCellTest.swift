//
//  Copyright (C) 2016 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  CollectionViewDataSourceTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 22.08.16.
//

import XCTest
import UIKit
@testable import Sourcing

// swiftlint:disable force_cast
class CollectionViewDataSourceSingleCellTest: XCTestCase {

    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var dataModificator: DataModificatorMock!
    var collectionViewMock: UICollectionViewMock!
    var realCollectionView: UICollectionView!
    var cell: CellConfiguration<UICollectionViewCellMock<Int>>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        collectionViewMock = UICollectionViewMock()
        cell = CellConfiguration(cellIdentifier: cellIdentifier)
        realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        dataModificator = DataModificatorMock()
    }
    
    func testSetDataSource() {
        //When
        _ = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cell: cell)
        
        //Then
        XCTAssertEqual(collectionViewMock.executionCount.reloaded, 1)
        XCTAssertNotNil(collectionViewMock.dataSource)
        XCTAssertNotNil(collectionViewMock.prefetchDataSource)
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig = CellConfiguration<UICollectionViewCellMock<Int>>(cellIdentifier: cellIdentifier, nib: nib)
        
        //When
        _ = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cell: cellConfig)
        
        //Then
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 1)
        XCTAssertNotNil(collectionViewMock.registerdNibs[cellIdentifier] as Any)
    }

    func testNumberOfSections() {
        //Given
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cell: cell)
        let sectionCount = dataSource.numberOfSections(in: realCollectionView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cell: cell)
        let rowCount = dataSource.collectionView(realCollectionView, numberOfItemsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }

    func testDequeCells() {
        //Given
        var didCallAdditionalConfigurtion = false
        let cell = CellConfiguration<UICollectionViewCellMock<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguration: { _, _ in
            didCallAdditionalConfigurtion = true
        })
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cell: cell)
        let cellAtIdexPath = dataSource.collectionView(realCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        
        //Then
        let mockCell = (collectionViewMock.cellDequeueMock.cells[cellIdentifier] as! UICollectionViewCellMock<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(collectionViewMock.cellDequeueMock.dequeueCellReuseIdentifiers.first, cellIdentifier)
        XCTAssertTrue(cellAtIdexPath is UICollectionViewCellMock<Int>)
        XCTAssertTrue(didCallAdditionalConfigurtion)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<UICollectionViewCellMock<Int>>(cellIdentifier: cellIdentifier)
        let dataProviderMock = DataProviderMock<Int>()
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProviderMock,
                                                  cell: cellConfig, dataModificator: dataModificator)
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.collectionView(realCollectionView, moveItemAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataModificator.destinationIndexPath, toIndexPath)
    }
    
    @available(iOS 10.0, *)
    func testPrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock,
                                                                                         dataProvider: dataProviderMock, cell: cell)
        
        //When
        let prefetchedIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.collectionView(realCollectionView, prefetchItemsAt: prefetchedIndexPaths)
        
        //Then
        guard let x = dataProviderMock.prefetchedIndexPaths else {
            return XCTFail()
        }
        XCTAssertEqual(x, prefetchedIndexPaths)
    }
    
    @available(iOS 10.0, *)
    func testCenclePrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock,
                                                                                    dataProvider: dataProviderMock, cell: cell)
        
        //When
        let canceldIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.collectionView(realCollectionView, cancelPrefetchingForItemsAt: canceldIndexPaths)
        
        //Then
        guard let x = dataProviderMock.canceledPrefetchedIndexPaths else {
            return XCTFail()
        }
        XCTAssertEqual(x, canceldIndexPaths)
    }
    
    func testCanMoveCellAtIndexPath() {
        dataModificator.canMoveItemAt = true
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider,
                                                  cell: cell, dataModificator: dataModificator)
        
        //Then
        XCTAssertTrue(dataSource.collectionView(realCollectionView, canMoveItemAt: IndexPath(item: 0, section: 0)))
    }
}
