# lazywake
[![Code Climate GPA](https://codeclimate.com/github/mach-kernel/lazywake/badges/gpa.svg)](https://codeclimate.com/github/mach-kernel/lazywake)
[![CircleCI](https://circleci.com/gh/mach-kernel/lazywake/tree/master.svg?style=shield)](https://circleci.com/gh/mach-kernel/lazywake/tree/master)
* [Homepage](https://rubygems.org/gems/lazywake)
* [Documentation](http://rubydoc.info/gems/lazywake/frames)

**NOTE:** This is still a work in progress and a lot of features are not done yet. I fill things in as I go!

## Description
A better wake-on-lan utility that saves hostname to hardware address mappings. 

## Getting Started

##### Wake a host by name
`lazywake myhost`

##### Wake a host, then do something

```bash
lazywake myhost echo 'done'
# => done
```

##### Wake a host, wait for it to come up, then use the SSH plugin to log in
```bash
lazywake myhost ssh
# => (...myhost's MOTD)
``` 

## Plugins

A `plugin` is a subclass of `Lazywake::Command::Default` that implements additional behavior for sake of terseness and readability.

Consider connecting to an SSH host after sending a magic packet:

Doing `lazywake myhost ssh user@myhost` seems redundant: we know our current user and the destination host. We can do less typing, so why not just `lazywake myhost ssh`?

### Creating a plugin
In typical Ruby fashion, there's a DSL for this!

##### Define the foobar command
```ruby
Lazywake::Command.describe do 
  # Program to locate via `which`
  name 'foobar'

  # How long should we wait for the host to wake up? In this case, we would
  # send 10 packets, 1 per second, stopping on first reply and replacing the
  # process, or waiting 10s for all 10 pings to time out.
  await_for 10

  # Before we replace the process,
  # you can do whatever manipulations you'd like on the args
  map_proc do |args|
    args[0].upcase!
  end
end
```

## Credits
Copyright (c) David Stancu 2016 
See LICENSE.txt for details.
