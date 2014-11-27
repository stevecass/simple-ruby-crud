simple-ruby-crud
================

A very simple command-line CRUD app using a CSV file for storage

Things to think about:
* parser.rb - uses the built-in CSV module to create an array of hashes from a CSV file. Also writes such an array back to CSV.
* person.rb - knows how to instantiate itself from a hash and represent itself as a hash.
* time_helper.rb - non-simple data types need to be encoded as strings somehow. We need to be consistent in how we do this.
* Should the person class have that ```to_display``` method? Where else could that go?
* How might you rewrite this app to be more MVC?
* Is writing the whole CSV file on every save a good idea? Do we have any choice?
