# Changelog

## 0.3.11 (2024-03-07)

  * Fix `allow_values_for` matcher when negated ([Tyler Hunt][tylerhunt])

## 0.3.10 (2024-02-08)

  * Support symbol values for `:reject_if` option on
    `accept_nested_attributes_for` ([Tyler Hunt][tylerhunt])

## 0.3.9 (2022-05-04)

  * Allow `:required`/`:optional` aliases with `belongs_to`
    ([Tyler Hunt][tylerhunt])

## 0.3.8 (2021-07-23)

  * Add `:where` option to `have_index` ([Tyler Hunt][tylerhunt])

## 0.3.7 (2021-01-12)

  * Support Rails 6.0, 6.1 ([AGuyNamedRyan][])

## 0.3.6 (2018-05-07)

  * Support Rails 5.2 ([Tyler Hunt][tylerhunt])

## 0.3.5 (2017-06-27)

  * Support Rails 5.1 ([Tyler Hunt][tylerhunt])

## 0.3.4 (2017-04-20)

  * Fix `allow_values_for` matcher ([Tyler Hunt][tylerhunt])
  * Update `allow_values_for` to use the setter on the object if defined
    ([Tyler Hunt][tylerhunt])

## 0.3.3 (2017-01-16)

  * Add `:required`/`:optional` to `belong_to` ([Tyler Hunt][tylerhunt])

## 0.3.2 (2017-01-16)

  * Support Rails 5.0 ([Tyler Hunt][tylerhunt])

## 0.3.1 (2015-10-09)

  * Fix circular reference error in Ruby 2.2 ([Nathaniel Bibler][nbibler])
  * Restore support for Ruby 1.9 ([Nathaniel Bibler][nbibler])

## 0.3.0 (2014-07-21)

  * Support and require RSpec ~> 3.0 ([Tyler Hunt][tylerhunt])
  * Improve documentation ([Olivier Lacan][olivierlacan])

## 0.2.1 (2013-10-18)

  * Require Rails ~> 4.0 ([Tyler Hunt][tylerhunt])

## 0.2.0 (2013-10-18)

  * Remove support Rails 3 ([Tyler Hunt][tylerhunt])
  * Support Rails 4 ([Tyler Hunt][tylerhunt])

## 0.1.2 (2013-06-17)

  * Specify license in gemspec ([Tyler Hunt][tylerhunt])
  * Add missing dependency require statements ([Tyler Hunt][tylerhunt])
  * Restore support for Ruby 1.8 ([Tyler Hunt][tylerhunt])

## 0.1.1 (2012-04-25)

  * Do not rely on a `:with` option having `#to_a` ([Tyler Hunt][tylerhunt])
  * Update `:if`/`:unless` support to use instance ([Tyler Hunt][tylerhunt])

## 0.1.0 (2012-02-26)

  * Support `:if` and `:unless` options ([Tyler Hunt][tylerhunt])
  * Remove support for multiple attributes ([Tyler Hunt][tylerhunt])

## 0.0.12 (2012-01-18)

  * Use the subject instead of making a new instance ([Tyler Hunt][tylerhunt])
  * Make rspec-mocks a runtime dependency ([Tyler Hunt][tylerhunt])

## 0.0.11 (2012-01-18)

  * Support role-based mass-assignment security ([Tyler Hunt][tylerhunt])
  * Fix issue with instance variables in matchers ([Tyler Hunt][tylerhunt])

## 0.0.10 (2011-10-29)

  * Add `accept_nested_attributes_for` matcher ([Tyler Hunt][tylerhunt])
  * Add `allow_values_for` matcher ([Tyler Hunt][tylerhunt])
  * Remove unsupported default scope query methods ([Tyler Hunt][tylerhunt])
  * Update mass-assignment matcher for Rails 3.1 ([Tyler Hunt][tylerhunt])

## 0.0.9 (2011-07-12)

  * Ensure that the association types are matched ([Tyler Hunt][tylerhunt])
  * Fix an issue in the matching logic ([Tyler Hunt][tylerhunt])

## 0.0.8 (2011-07-06)

  * Support Rails 3.1 ([Jacob Swanner][jswanner])

## 0.0.7 (2011-07-05)

  * Add `have_default_scope` matcher ([Tyler Hunt][tylerhunt])

## 0.0.6 (2011-05-09)

  * Add Active Record validation matchers ([Tyler Hunt][tylerhunt])

## 0.0.5 (2011-05-07)

  * Add association matchers ([Tyler Hunt][tylerhunt])

## 0.0.4 (2011-05-07)

  * Add `allow_mass_assignment_of` matcher ([Tyler Hunt][tylerhunt])
  * Add missing dependency require statement ([Tyler Hunt][tylerhunt])
  * Fix a bug in the matcher logic ([Tyler Hunt][tylerhunt])

## 0.0.3 (2011-03-11)

  * Update matchers to assume subject is an instance ([Tyler Hunt][tylerhunt])

## 0.0.2 (2011-03-11)

  * Add additional matchers ([Tyler Hunt][tylerhunt])
  * Require RSpec 2.5 ([Tyler Hunt][tylerhunt])
  * Support multiple attributes ([Tyler Hunt][tylerhunt])

## 0.0.1 (2011-02-21)

  * Initial release ([Tyler Hunt][tylerhunt])

[aguynamedryan]: https://github.com/aguynamedryan
[jswanner]: https://github.com/jswanner
[nbibler]: https://github.com/nbibler
[olivierlacan]: https://github.com/olivierlacan
[tylerhunt]: https://github.com/tylerhunt
