# SwiftyIO Changelog

## Version 1.2.0
Released 29th Apr 2015, maintenance and new features.

* Renamed the Library from *CoreDataContext* to **SwiftyIO**. This is the new [repository address](https://github.com/ravero/SwiftyIO). The old repository will keep the changes up to 1.1 version. Make sure to update your Podfile.
* The ***BaseDataContext*** class now inherits from NSObject. This allows it and it's subclasses to be accessed from Objective-C.
* Added the method ***clearDatabase*** to ***BaseDataContext*** class, that deletes the SQL file for the model.
* Added the method ***printDatabasePath*** to ***BaseDataContext*** class, which is useful in case you may need to debug the SQLite file of the current model.
* Support for OSX in the Cocoapods package.

## Version 1.1.0
Released 8th Apr 2015, maintenance.

* Updated for Swift 1.2 syntax changes.

## Version 1.0
This release version brings advances to the Library:

* Allow defining a Primary Key data type different than a String: the type is defined by the second Type parameter in EntityDataSource declaration (check out the following sample). This is reflected on methods that use PK's as parameters such as *find* and *delete*.
* Adds Autonumber Primary Key generation: the first version only allowed String Primary Keys that was pre-loaded with a custom UUID value when an entity was created. The new version allows you to set an Autonumber generation. The implementation is very simple (record count + 1).
* Allow defining a Custom Primary Key generation: Aside from the UUID and Autonumber generators, you can customize your own primary key generator function.
* Allows defining no Primary Key generation: you case you want to work PK record based.
* Fix documentation of parameters in methods.
