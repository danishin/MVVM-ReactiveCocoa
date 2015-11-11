////
////  Models.swift
////  MVVMTutorial
////
////  Created by Daniel Shin on 2015-11-08.
////  Copyright © 2015 Daniel Shin. All rights reserved.
////
//
//import Realm
//import RealmSwift
//
//class Dog: Object {
//  dynamic var name = ""
//  dynamic var owner: Person?
//  var owners: [Person] {
//    // Realm doesn't persist this property because it only has a getter defined
//    // Define "owners" as the inverse relationship to Person.dogs
//    return linkingObjects(Person.self, forProperty: "dogs")
//  }
//}
//
//class Person: Object {
//  dynamic var tmpID = -1
//  
//  dynamic var id = 0
//  dynamic var name = ""
//  dynamic var birthdate = NSDate(timeIntervalSince1970: 1)
//  
//  // RealmOptional properties should always be declared with `let`, as assigning to them directly will not work as desired
//  var age = RealmOptional<Int>()
//  // List properties do not need to be marked as dynamic to be observable unlike normal properties
//  let dogs = List<Dog>()
//  
//  // Computed properties are automatically ignored
//  var first_name: String {
//    return name.characters.split(" ").map(String.init).first!
//  }
//  
//  override static func primaryKey() -> String? {
//    return "id"
//  }
//  
//  override static func ignoredProperties() -> [String] {
//    return ["tmpID"]
//  }
//}
//
//class Book: Object {
//  dynamic var id = 0
//  dynamic var price = 0
//  dynamic var title = ""
//  
//  override static func indexedProperties() -> [String] {
//    return ["title"]
//  }
//}
//
//class Example {
//  
//  func main() {
//    let realm = try! Realm()
//    
//    /// To-One Relationships
//    let daniel = Person()
//    let rex = Dog()
//    rex.owner = daniel
//    
//    /// To-Many Relationships
//    let someDogs = realm.objects(Dog).filter("name contains 'Fido'")
//    daniel.dogs.appendContentsOf(someDogs)
//    daniel.dogs.append(rex)
//    
//    try! realm.write {
//      var person = realm.create(Person.self, value: ["Jane", 27])
//      person.age.value = 28
//    }
//    
//    let author = Person()
//    author.name = "David Foster Wallace"
//    
//    try! realm.write {
//      realm.add(author)
//    }
//    
//    /// Updating Objects
//    try! realm.write {
//      // Update an object with a transaction
//      author.name = "Thomas Pynchon"
//    }
//    
//    /// Updating Objects with Primary Keys
//    // If you have a primary key on your model, you can update an object or insert a new one if it doesn't exist yet.
//    let cheeseBook = Book()
//    cheeseBook.id = 1
//    cheeseBook.title = "Cheese Recipes"
//    cheeseBook.price = 9000
//    
//    try! realm.write {
//      // if a book with primary key id of 1 was not in the database, this would create a new book instead
//      realm.add(cheeseBook, update: true)
//      
//      // You can also partially update objects with primary keys by passing the subset of values you wish to update, along with the primary key
//      realm.create(Book.self, value: ["id": 1, "price": 9000.0], update: true)
//    }
//    
//    // Key-Value Coding
//    let persons = realm.objects(Person)
//    try! realm.write {
//      persons.first?.setValue(true, forKey: "isFirst")
//      persons.setValue("Earth", forKey: "planet")
//    }
//    
//    /// Deleting Objects
//    try! realm.write {
//      realm.delete(cheeseBook)
//      
//      realm.deleteAll()
//    }
//    
//    /// Queries
//    // Filtering
//    realm.objects(Dog).filter("color = 'tan' AND name BEGINSWITH 'B'")
//    
//    let predicate = NSPredicate(format: "color = %@ AND name BEGINSWITH %@", "tan", "B")
//    realm.objects(Dog).filter(predicate)
//    
//    // Sorting
//    realm.objects(Dog).filter("color = 'tan'").sorted("name")
//    
//    // Chaining
//    realm.objects(Dog).filter("color = 'tan'").filter("name BEGINSWITH 'B'")
//    
//    // Auto-Updating
//    // Results are live, auto-updating views into the underlying data, which means results never have to be re-fetched.
//    // Modifying objects that affect the query will be reflected in the results immediately.
//    let puppies = realm.objects(Dog).filter("age < 2")
//    puppies.count == 0
//    
//    try! realm.write {
//      realm.create(Dog.self, value: ["name": "Fido", "age": 1])
//    }
//    
//    puppies.count == 1
//    
//    // This property of Results not only keeps Realms fast and efficient, it allows your code to be simpler and more reactive
//    // For example, your view controller relies on the results of a query, you can store the Results in a property and access it without having to make sure to refresh its data prior to each access
//    // You can subscribe to Realm Notifications to know when Realm data is updated, indicating when your app's UI should be refreshed without having to re-fetch your Results
//    
//    // Sinc results are auto-updating, it's important to not rely on indices & counts staying constant.
//    // The only time a Results is frozen is when fast-enumerating over it, making it possible to mutate the objets matching a query while enumerating over it
//    
//    try! realm.write {
//      realm.objects(Person).filter("age == 10").forEach { $0.name + "1" }
//    }
//    
//    /// Realms
//    // Realm() returns a Realm object that maps to a file called "default.realm" under the Documents folder of your app
//    do {
//      let _ = try Realm(configuration: getRealmConfigurationForUser(1))
//    } catch let error as NSError {
//      error.localizedDescription
//    }
//    
//    // Realm objects can only be accessed from the thread on which they were first created
//    
//    /// Threading
//    // Insert million objet in background queue
//    dispatch_async(dispatch_get_global_queue(0, 0)) {
//      autoreleasepool {
//        let realm = try! Realm()
//        
//        (0..<1000).forEach { id in
//          realm.beginWrite()
//          
//          (0..<1000).forEach { id2 in
//            realm.create(Person.self, value: [
//              "name": String(id),
//              "birthdate": NSDate(timeIntervalSince1970: NSTimeInterval(id2))
//            ])
//          }
//          
//          // Commit the write transaction to make this data available to other threads.
//          try! realm.commitWrite()
//        }
//      }
//    }
//    
//    /// Notifications
//    // Realm instances send out notifications to other instances on other threads every time a write transaction is committed
//    
//    // The notification stays active as long as a reference is held to the returned notification token.
//    let token = realm.addNotificationBlock { notification, realm in
//      // UPDATE UI
//    }
//    token.description
//    /// Key-Value Observation
//    
//    /// Testing
//    let _ = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
//    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test"
//    
//    
//    
//  }
//  
//  // When you want to support quickly switching between accounts
//  func getRealmConfigurationForUser(user_id: Int) -> Realm.Configuration {
//    var config = Realm.Configuration()
//    
//    config.path = NSURL.fileURLWithPath(config.path!)
//      .URLByDeletingLastPathComponent?
//      .URLByAppendingPathComponent(String(user_id))
//      .URLByAppendingPathExtension("realm")
//      .path
//    
//    return config
//  }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
