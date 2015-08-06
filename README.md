# ABOUT ROM

Examples for a talk about using rom-rb. Uses a simple blog setup with Users, Posts and Comments. Use the console to play around:


    $ ./console

    ROM >> command(:users).create.call(name: 'Alice')
    => {:id=>1, :email=>nil, :name=>"Alice"}

    ROM >> relation(:users).first
    => {:id=>1, :email=>nil, :name=>"Alice"}



## NOTES

- rom-sql wraps around the (excellent) Sequel gem
- rom-mongo wraps around the Moped gem
- rom-redis wraps around the Redis gem