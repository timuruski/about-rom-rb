# ABOUT ROM

Examples for a talk about using rom-rb. Uses a simple blog setup with Users, Posts and Comments. Use the console to play around:


    $ ./run scenarios/basic

    ROM >> command(:users).create.call(name: 'Alice')
    => {:id=>1, :email=>nil, :name=>"Alice"}

    ROM >> relation(:users).first
    => {:id=>1, :email=>nil, :name=>"Alice"}


## NOTES

- rom-sql wraps around the (excellent) Sequel gem
- rom-mongo wraps around the Mongo gem
- rom-redis wraps around the Redis gem

## Basics

ROM is not a framework, it's a toolkit. What does that even mean? Out of the box ROM doesn't do anything. Fully assembled, ROM _still_ kind of doesn't do anything.

Step 1: Setup ROM
Step 2: Define your relations and commands
Step 3: Build some sort of interface on top of ROM

## Nested Inputs

## Multi-store implementation

## Understanding Transproc

## Serious Business
