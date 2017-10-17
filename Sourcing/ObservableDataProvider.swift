//
//  Copyright (C) DB Systel GmbH.
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

import Foundation

/// A DataPrvider that can be observes for changes.
public protocol ObservableDataProvider {
    
    /// Observe the changes of the DataProvider.
    ///
    /// Can be use to animate changes in a TableView or in any other view hirachy.
    ///
    /// - Parameter observer: gets called when updates are available. If nil the DataProvider could
    /// not calculate the updates, but new data is availabe. Reload you complete view when this happens.
    
    /// To unregister call ``
    /// - Returns: An opaque object to act as the observer.
    func addObserver(observer: ([DataProviderUpdate]?) -> Void) -> NSObjectProtocol
    
    /// Removes given observer from the receiver’s dispatch table.
    ///
    /// - Parameter observer: The observer to remove
    func removeObserver(observer: Any)
}
