simple-ruby-crud
================

A very simple command-line CRUD app using a CSV file for storage

Things to think about:
* parser.rb - uses ruby's built-in CSV module to create an array of hashes from a CSV file. Writes such an array back to CSV.
* person.rb - knows how to instantiate itself from a hash and represent itself as a hash.
* time_helper.rb - non-simple data types need to be encoded as strings somehow. We need to be consistent in how we do this.
* Should the person class have that ```to_display``` method? Where else could that go?
* How might you rewrite this app to be more MVC?
* Is writing the whole CSV file on every save a good idea? Do we have any choice if we're using CSV files?
* What does the app do well? What's not so good about it? 
* Does it have the right classes? Are the class boundaries correct? How do we decided what's a class and what's a module?
* What would be involved in changing the storage from CSV to something else? What classes would need to change?
