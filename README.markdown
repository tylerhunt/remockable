# Remockable

[![Build Status][travis-image]][travis]

[travis]: http://travis-ci.org/tylerhunt/remockable
[travis-image]: https://secure.travis-ci.org/tylerhunt/remockable.png

A collection of RSpec 2 matchers to simplify your web app specs.


## Background

The goal of this project is to provide a modern replacement to the now
unmaintained Remarkable project. Remarkable was a great asset when Rails 2.3
was current, but now that Rails 3 has become mainstream, a gap has been left
by still unreleased Remarkable 4.0.

In looking at the code for Remarkable to determine the feasibility of continuing
work on Remarkable itself, it seems clear that the scope of that project has
outgrown its usefulness for most users. It was with this conclusion in mind that
Remockable was born. It's an attempt to start with a clean slate but maintain
the original goal of Remarkable in spirit.


## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'remockable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remockable


## Usage

Remockable provides matchers for use with Active Model and Active Record
classes.

### Active Model Matchers

The following Active Model matchers are supported:

  * `allow_mass_assignment_of`
  * `validate_acceptance_of`
  * `validate_confirmation_of`
  * `validate_exclusion_of`
  * `validate_format_of`
  * `validate_inclusion_of`
  * `validate_length_of`
  * `validate_numericality_of`
  * `validate_presence_of`

### Active Record Matchers

The following Active Record matchers are supported:

  * `have_column`
  * `have_index`
  * `have_scope`
  * `have_default_scope`
  * `belong_to`
  * `have_one`
  * `have_many`
  * `have_and_belong_to_many`
  * `validate_associated`
  * `validate_uniqueness_of`


## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Added some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.


## Copyright

Copyright © 2010-2012 Tyler Hunt. See LICENSE for details.
