# Remockable

[![Build][build-image]][build]
[![Maintainability][codeclimate-image]][codeclimate]
[![Gem Version][rubygems-image]][rubygems]

[build]: https://github.com/tylerhunt/remockable/actions/workflows/build.yml?query=branch%3Amaster
[build-image]: https://github.com/tylerhunt/remockable/actions/workflows/build.yml/badge.svg
[codeclimate]: https://codeclimate.com/github/tylerhunt/remockable/maintainability
[codeclimate-image]: https://api.codeclimate.com/v1/badges/c95736ab7cca49228f5c/maintainability
[rubygems]: https://badge.fury.io/rb/remockable
[rubygems-image]: https://badge.fury.io/rb/remockable.svg

A collection of RSpec 3 matchers to simplify your web app specs.

*Note:* Rails 3 support was dropped in version 0.2.


## Background

The goal of this project is to provide a modern replacement to the now
unmaintained Remarkable project. Remarkable was a great asset when Rails 2.3
was current, but a gap has been left by the unreleased Remarkable 4.0 since the
release of Rails 3 and 4.

In looking at the code for Remarkable to determine the feasibility of continuing
work on Remarkable itself, it seems clear that the scope of that project has
outgrown its usefulness for most users. It was with this conclusion in mind that
Remockable was born. It’s an attempt to start with a clean slate but maintain
the original goal of Remarkable in spirit.


## Installation

Add this line to your application’s `Gemfile`:

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

  * `allow_values_for`
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

### Options

Options may be passed to the matchers in the same way they’re passed to the
macros. For instance, when dealing with `has_many :through` associations, you
could specify the following:

``` ruby
it { should have_many :subscriptions, through: :customers }
```


## Contributing

  1. Fork it.
  2. Create your feature branch (`git checkout -b my-new-feature`).
  3. Commit your changes (`git commit -am 'Added some feature'`).
  4. Push to the branch (`git push origin my-new-feature`).
  5. Create a new Pull Request.


## Copyright

Copyright © 2010–2022 Tyler Hunt. See LICENSE for details.
