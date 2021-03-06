[![Build Status](https://travis-ci.org/lightsprint09/Sourcing.svg?branch=master)](https://travis-ci.org/lightsprint09/Sourcing)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/lightsprint09/Sourcing/branch/master/graph/badge.svg)](https://codecov.io/gh/lightsprint09/Sourcing)

# Sourcing

Typesafe and flexible abstraction for TableView &amp; CollectionView DataSources written in Swift. It helps you to seperate concerns and keep ViewControllers light. By operating on data providers replacing your view implementation is easy at any time.

## Documentation

Read the [docs](https://lightsprint09.github.io/Sourcing). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).


## Quick Demo
Setting up your Cell by implementing `ConfigurableCell` & `ReuseIdentifierProviding`.
```swift
import Sourcing

class TrainCell: UITableViewCell, ConfigurableCell {
   @IBOutlet var nameLabel: UILabel!
   
   func configure(with train: Train) {
      nameLabel.text = train.name
   }
}

//If the reuse identifier is the same as the class name.
extension TrainCell: ReuseIdentifierProviding {}

let trainCellConfiguration = CellConfiguration<TrainCell>()
let fetchResultsController: NSFetchedResultsController<Train> = //
let dataProvider = FetchedResultsDataProvider(fetchedResultsController: fetchResultsController)
let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: trainCellConfiguration)

tableView.dataSource = dataSource

//Add this to sync data changes to the table view.
let changeAnimator = TableViewChangeAnimator(tableView: tableView, dataProviderObservable: dataProvider.observable)
```

## Requirements

- iOS 9.3+
- Xcode 9.3+
- Swift 4.1

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Specify the following in your `Cartfile`: `3.0 is currently work in progress. Last stabel release is `2.4.3`

```ogdl
github "lightsprint09/Sourcing" "master"
```
## Contributing
See CONTRIBUTING for details.

## Contact
Lukas Schmidt ([Mail](mailto:lukas.la.schmidt@deutschebahn.com), [@lightsprint09](https://twitter.com/lightsprint09))

## License
Sourcing is released under the MIT license. See LICENSE for details.
