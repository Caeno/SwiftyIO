# SwiftyIO
<img src="https://dl.dropboxusercontent.com/u/31981409/GitHub/SwiftyIO/Images/SwiftyIORoundedIcon_Logo.png" align="right" hspace="20" />

SwiftyIO is a Cocoa Touch Framework written in Swift to allow fast integration of Core Data into your iOS and OS X projects, and provide a set of classes to easily operate on your entity objects.

This library is perfect for small to medium complexity projects, since it allows you fast setup of your Model and persistence, and abstracts away complexity of working with NSManagedObjectContext and NSManagedObjects. It also provides useful helpers such as CoreDataTableViewController to allow easy setup of iOS Table Views that reads data from an entity.

Just give it a try and provide your feedback to grow it even better!

## Installation
SwiftyIO is fully implemented in **Swift**, and is distributed as a Cocoa Touch Framework Library project. You can install from Cocoapods:

```
platform :ios, '8.0'
use_frameworks!

pod 'SwiftyIO', '~> 1.2'
```

> **Cocoa Touch Frameworks requires minimum deployment target of iOS 8**. To use SwiftyIO on projects that need to support iOS 7, you need to include the Source Code directly in your project.

### Manual Installation
SwiftyIO is packaged as a Xcode Project with two targets:

1. SwiftyIO_iOS: a Cocoa Touch Framework to be linked with iOS projects.
2. SwiftyIO_OSX: a Cocoa Framework to be linked with OS X projects.

You can download or clone the code to your project, or clone this repo as a Submodule, then add the Framework as a Linked Binary in your App's target, based on the needed platform.

#### If you're using deployment target of iOS 7
Add the following files to your source:

* **BaseDataContext.swift** - Base Data Context class.
* **EntityDataSource.swift** - Base Entity Data Source class, provides all the CRUD features of SwiftyIO.
* **Extensions/NSManagedObjectContext+Helpers.swift** - Provides extensions to NSManagedObjectContext class used by base classes.
* **Extensions/EntityDataSource+iOS.swift** - Provides extensions to the Data Source base class specific for iOS. *Shouldn't be included in OS X targets*.
* **Helpers/CoreDataTableViewController.swift** - An helper base class to easy load UITableViewControllers from data fetched with SwiftyIO. *It's iOS specific and shouldn't be included in OS X targets*.

# Usage
SwiftyIO provides very simple API for interacting with your Core Data Model entities. First you need to derive from ***BaseDataContext***, which setups your Core Data Stack and provides the *NSManagedObjectContext*. Set the name of the model using it's super initializer. Declare the properties to access your entities using the generic ***EntityDataSource*** class, and initilize then with the entity and key field name, as the template from the Sample Project:

```swift
class NotesContext: BaseDataContext {

    //
    // MARK: - Entity Data Source Properties

    var categories: EntityDataSource<Category, NSNumber>!
    var notes: EntityDataSource<Note, NSString>!

    //
    // MARK: - Initializers

    init() {
        super.init(resourceName: "Notes")

        if let moc = self.managedObjectContext {
            self.categories = EntityDataSource(managedObjectContext: moc,
                entityName: "Category",
                entityKeyName: "categoryId",
                entityKeyGeneration: PrimaryKeyGeneration.AutoNumber)

            self.notes = EntityDataSource(managedObjectContext: moc,
                entityName: "Note",
                entityKeyName: "noteId",
                entityKeyGeneration: PrimaryKeyGeneration.UUID)
        }
    }

}
```

Optionally you can set your data Context as a Singleton, adding the property:

```Swift
//
// MARK: - Singleton

class var sharedInstance: NotesContext {
    struct Singleton {
        static var instance: NotesContext?
        static var token: dispatch_once_t = 0
    }

    dispatch_once(&Singleton.token) {
        Singleton.instance = NotesContext()
    }

    return Singleton.instance!
}
```

Be sure to replace the types appropriately. A few things to note:

* EntityDataSource expects two types to be defined, the first is your entity class, a type that must derive form *NSManagedObject*, the second is the type of the Primary Key Fields. It must be a type supported by the Core Data. Also you must use Foundation classes, such as *NSNumber* for integers and *NSString* for Strings.
* Primary keys can be auto-generated, using a sequence number, an ID or a custom closure that you provide.

A Template Xcode Snippet is available in this [Gist](https://gist.github.com/ravero/852e32e1e6fc5044d153).

## Data Operations
Data Operations with SwiftyIO are provided by the ***EntityDataSource*** class. It's a generic wrapper around an entity, that allow you to easily create, query, edit and delete objects.

### Creting Objects
Creating and configuring objects is very simple with SwiftyIO, supose you want to add a category of Notes:

```swifty
let newCategory = NotesContext.categories.add {
  $0.name = "Recipes"
}
```

The Add method receives a Closure parameter that passes the created object allowing you to set it's properties on a single pass. The object is returned to the caller and automatically persisted.

This is a single example of how you can use SwiftyIO to become more productive. Checkout the source for [EntityDataSource.swift](https://github.com/ravero/SwiftyIO/blob/master/CoreDataContext/EntityDataSource.swift) to see all the available methods. Follows a short list:

* **add**: add a new entity record.
* **create**: add an empty record.
* **clear**: remove all records from the entity.
* **count**: count records on the entity, optionally providing an predicate to filter.
* **delete**: remove a record from the entity.
* **getAll**: gets all records in this entity, optionally providing sorting descriptors.
* **find**: get the record specified by the ID or nil if not exists.
* **first**: gets the first record provided by the predicate.
* **filter**: gets a list o records filtered by a predicate, optionally providing sort descriptors.
* **update**: a record data.

# Sample Project
The **NotesApp** Project is an very simple note taking iOS App, that employs SwiftyIO to provide simple model management. You can see and download the Sample project code from it's [GitHub Repository](https://github.com/ravero/NotesApp).

# Notes
This library is not thread safe. It's best suited to be running as a Singleton. It's main target is for small and simple projects that employs no complex Core Data Models.

Thanks for using SwiftyIO. If you like this API please contribute and help us making a bigger and more complete Core Data API using the power of Swift!! You're welcome to Fork this repo and do your Pull Requests.

# Version History
The Current available version is 1.2. Check out the [full Changelog](CHANGELOG.md).
