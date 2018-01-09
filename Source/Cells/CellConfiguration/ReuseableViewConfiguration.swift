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

import UIKit

#if os(iOS) || os(tvOS)
    /// The reusable view configuration can decide if it can configure a given view with an object or not.
    /// If matching, it is able to configure the view with the object. A configuration can be registered at the collection view or table view
    /// with the configurations nib, reuse identifier and element kind for later dequeuing.
    ///
    /// - Note: By conforming to `StaticSupplementaryViewConfiguring` it can be statically proofen that a view and object matches each other.
    /// - Note: Dequeuing a view is not part of configuration.
    /// - SeeAlso: `SupplementaryViewConfiguring`
    /// - SeeAlso: `StaticSupplementaryViewConfiguring`
    public struct ReuseableViewConfiguration<ReuseableView, ObjectInSection>: StaticReuseableViewConfiguring {
        
        public typealias View = ReuseableView
        public typealias Object = ObjectInSection
        
        /// The reuse identifier which will be used to register and deque the cell.
        public let reuseIdentifier: String
        public var type: ReuseableViewType
        
        /// The nib which visualy represents view.
        public let nib: UINib?
        
        /// A block to configure the view with given object at the given index path.
        public let configuration: ((View, IndexPath, Object) -> Void)?
        
        /// Creates an instance of `BasicCellConfiguration`.
        ///
        /// - Parameters:
        ///   - reuseIdentifier: the reuse identifier for registering & dequeuing views
        ///   - type: the type of the reuseable view
        ///   - nib: the nib which visualy represents view. Defaults to `nil`.
        ///   - configuration: a block to configure the view with given object at the given index path.
        public init(reuseIdentifier: String, type: ReuseableViewType, nib: UINib? = nil, configuration: ((View, IndexPath, Object) -> Void)?) {
            self.reuseIdentifier = reuseIdentifier
            self.type = type
            self.nib = nib
            self.configuration = configuration
        }
        
        /// Configures the given view with at the index path with the given object.
        ///
        /// - Parameters:
        ///   - view: the view to configure
        ///   - indexPath: index path of the view
        ///   - object: the object which relates to the view
        public func configure(_ view: AnyObject, at indexPath: IndexPath, with object: Any) {
            guard let view = view as? View, let object = object as? Object else {
                return
            }
            configuration?(view, indexPath, object)
        }
    }
    
    /// Creates an instance of `BasicCellConfiguration`.
    /// Uses the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - type: the type of the reuseable view. Defaults to `.cell`.
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - configuration: a block to configure the view with given object at the given index path.
    extension ReuseableViewConfiguration where ReuseableView: ReuseIdentifierProviding {
        public init(type: ReuseableViewType = .cell, nib: UINib? = nil, configuration: @escaping ((ReuseableView, IndexPath, Object) -> Void)) {
            self.reuseIdentifier = ReuseableView.reuseIdentifier
            self.nib = nib
            self.type = type
            self.configuration = configuration
        }
    }
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing views.
    ///   - type: the type of the reuseable view. Defaults to `.cell`
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension ReuseableViewConfiguration where ReuseableView: ConfigurableCell, ReuseableView.ObjectToConfigure == Object {
        public init(reuseIdentifier: String, type: ReuseableViewType = .cell, nib: UINib? = nil,
                    additionalConfiguration: ((ReuseableView, IndexPath, Object) -> Void)? = nil) {
            self.reuseIdentifier = reuseIdentifier
            self.nib = nib
            self.type = type
            self.configuration = { view, indexPath, object in
                view.configure(with: object)
                additionalConfiguration?(view, indexPath, object)
            }
        }
    }
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    /// In addition it uses the `ReuseIdentifierProviding` as a reuse identifier.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - SeeAlso: `ReuseIdentifierProviding`
    /// - Parameters:
    ///   - type: the type of the reuseable view. Defaults to `.cell`
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension ReuseableViewConfiguration where ReuseableView: ConfigurableCell & ReuseIdentifierProviding, ReuseableView.ObjectToConfigure == Object {
        public init(type: ReuseableViewType = .cell, nib: UINib? = nil, additionalConfiguration: ((ReuseableView, IndexPath, Object) -> Void)? = nil) {
            self.init(reuseIdentifier: View.reuseIdentifier, type: type, nib: nib, configuration: { (view, indexPath, object) in
                view.configure(with: object)
                additionalConfiguration?(view, indexPath, object)
            })
        }
    }
#endif
