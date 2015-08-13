# Understanding ROM (Ruby Object Mapper)

## Section 1: Building blocks of ROM

- Introduce the concept of Relations and Commands
- Based on [Command Query Separation](http://martinfowler.com/bliki/CommandQuerySeparation.html), queries (or
  Commands) are used to read the state of the datastore, and Commands
  are used to change it. This isn't a strict implementation, as we'll
  see.
- Relations provide an interface to the underlying datastore and so they
  must be written to use its specific mechanisms.
- In their most basic form, relations return arrays of hashes.
- Commands start with the three most common cases, Create, Update and
  Delete, but other command types can be created that are specific to
  the datastore.
- Commands return the result of their operation, for instance a Create
  will return the resulting records that were persisted.


## Section 2: Basic Mappers in ROM

- The heart of ROM is Mappers and mapping data from one format to
  another.
- In their most basic form, Mappers let you transform an array of hashes
  into an array of business objects.
- Mappers provide a powerful toolset for structuring, destructuring
  and transforming graphs of data.


## Section 3: Active Record pattern with ROM

- Introduce a basic scoped query with ActiveRecord (the gem) and show
  how to build the equivalent thing in ROM.
- Introduce a more complex, relationship query with ActiveRecord to
  illustrate use of JOINs and combined queries.
- Demonstrate an operation that is difficult (or impossible) with
  ActiveRecord and then demonstrate how to build it with ROM.


## Section 4: Multi-datastore usage

- Demonstrate how ROM can be used to tie together data across multiple
  datastores.
- Maybe use the InMemory store to show a simple memory-cache system that
  combines with more persistent objects.


## Section 5: Conclusions and Warnings

- ROM provides a powerful toolset.
- Make sure you need it.
- It introduces a lot of complexity that might be a surprise if you're
  used to a more magical environment like Rails, etc.
