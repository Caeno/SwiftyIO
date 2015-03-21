# CoreDataContext
CoreDataContext is a Cocoa Touch Framework written in Swift to allow fast integration of Core Data into your iOS projects, and easy data operations on defined entities.

## Version 1.0 Released
This release version brings advances to the Library:
* Allow defining a Primary Key data type different than a String: the type is defined by the second Type parameter in EntityDataSource declaration (check out the following sample). This is reflected on methods that use PK's as parameters such as *find* and *delete*.
* Adds Autonumber Primary Key generation: the first version only allowed String Primary Keys that was pre-loaded with a custom UUID value when an entity was created. The new version allows you to set an Autonumber generation. The implementation is very simple (record count + 1).
* Allow defining a Custom Primary Key generation: Aside from the UUID and Autonumber generators, you can customize your own primary key generator function.
* Allows defining no Primary Key generation: you case you want to work PK record based.
* Fix documentation of parameters in methods.

## Installation
CoreDataContext is fully implemented in **Swift**, and is distributed as a Cocoa Touch Framework Library, and is also available via CocoaPods.

> **Cocoa Touch Frameworks requires minimum deployment target of iOS 8**. To use CoreDataContext on projects that need to support iOS 7, you need to include the Source Code directly in your project.

### Manual Installation
CoreDataContext is packaged as a Xcode Project with two targets:
1. CoreDataContext_iOS: a Cocoa Touch Framework to be linked with iOS projects.
2. CoreDataCOntext_OSX: a Cocoa Framework to be linked with OS X projects.

You can download or clone the code to your project, or clone this repo as a Submodule, then add the Framework as a Linked Binary in your App's target, based on the needed platform.

#### If you're using deployment target of iOS 7
Add the following files to your source:

* **BaseDataContext.swift** - Base Data Context class.
* **EntityDataSource.swift** - Base Entity Data Source class, provides all the CRUD features of CoreDataContext.
* **Extensions/NSManagedObjectContext+Helpers.swift** - Provides extensions to NSManagedObjectContext class used by base classes.
* **Extensions/EntityDataSource+iOS.swift** - Provides extensions to the Data Source base class specific for iOS. *Shouldn't be included in OS X targets*.
* **Helpers/CoreDataTableViewController.swift** - An helper base class to easy load UITableViewControllers from data fetched with CoreDataContext. *It's iOS specific and shouldn't be included in OS X targets*.

# Usage
CoreDataContext provides very simple API for interacting with your Core Data Model entities. First you need to derive from ***BaseDataContext***, which contains all the interactions with the *NSManagedObjectContext*. Set the name of the model using it's super initializer. Declare the properties to access your entities using the generic ***EntityDataSource*** class, and initilize then with the entity and key field name, as the template from the Sample Project:

```
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
entityKeyGeneration: PrimaryKeyGeneration.AutoNumber);

self.notes = EntityDataSource(managedObjectContext: moc,
entityName: "Note",
entityKeyName: "noteId",
entityKeyGeneration: PrimaryKeyGeneration.UUID);            
}
}

}
```

Optionally you can set your data Context as a Singleton, adding the property:

```
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


Checkout the source for [EntityDataSource.swift](https://github.com/raverotec/CoreDataContext/blob/master/CoreDataContext/EntityDataSource.swift) to see all the available methods. Follows a short list:

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
The **NotesApp** Project is an very simple note taking iOS App, that employs CoreDataContext to provide simple model management. You can see and download the Sample project code from it's [GitHub Repository](https://github.com/ravero/NotesApp).

# Notes
This library is not thread safe. It's best suited to be running as a Singleton. It's main target is for small and simple projects that employs no complex Core Data Models.

Thanks for using CoreDataContext. If you like this API please contribute and help us making a bigger and more complete Core Data API using the power of Swift!! You're welcome to Fork this repo and do your Pull Requests. 
