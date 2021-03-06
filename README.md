## README

This is a simple app that exposes a key/value store with a couple interesting features:

* Every object is exposed under the `/objects/:id` route, where ID can be
  something like `users/one`. You can change the `objects` to something like
  `api` in `config/routes.rb`

* Conditional Updates: When doing an update or delete, you are required
  to pass the old uuid for the object as the `:old_id` parameter.

* Audit Log: The `db_objects` table is append-only, so if you want to do
  some sort of event-sourcing thing, that's totally possible. I still
  need to add some sort of capability to do events beyond simple CRUD.

* Because it's backed by Postgres' JSON, you're able to extract your models
  into separate tables. I'm going to add something to make this process easy
  and update those extra tables with database triggers.

Overall, this should be a much better alternative to mongo when bootstrapping
a rails API fronting a rich front-end.

To see the controller signatures, the best reference is `test/controllers/objects_controller_test.rb`


### Todo:

* Write some triggers to "render" the dbobjects table into other database tables.
* On those extracted models, override `update_attributes` to use `ObjectLink#update`
* Write an angular service that wraps this whole thing
* Look into using redis pub/sub to allow push notifications for updated
  objects - Firebase style.
* Write an in-memory object store for test purposes - since there's only
  a single table and really only two operations on it, that should be
  easy.
* Build in some sort of unit of work helper for multiple object transactions
* Branch out a sample app to show how this is better (or worse?) than the status quo
