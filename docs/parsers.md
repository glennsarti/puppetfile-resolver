---
---

# Parsers

{% include sections.md %}

---


## The R10KEval Parser

 The R10KEval Parser (`R10KEval`) uses the same parsing logic as the [R10K Parser](https://github.com/puppetlabs/r10k/blob/master/lib/r10k/puppetfile.rb). In the future other parsers may be added, such as a [Ruby AST based parser](https://github.com/puppetlabs/r10k/pull/885).

### Using the parser

``` ruby
# Parse the Puppetfile into an object model
content = File.open(options[:path], 'rb') { |f| f.read }
require 'puppetfile-resolver/puppetfile/parser/r10k_eval'
puppetfile = ::PuppetfileResolver::Puppetfile::Parser::R10KEval.parse(content)
```

Firstly `require` the `r10k_eval` parser. Note that the Puppetfile Resolver does not automatically require any parsers and is left the user the choose the best parser.  Once required, call the `parse` method with a string of the content.

### Magic comments
Sometimes it necessary to instruct the Resolver to ignore certain rules, for example ignoring the Puppet restrictions on a module because it has old metadata. The R10KEval Parser can read ruby comments which have special meanings, similar to how [rubocop](https://docs.rubocop.org/en/stable/) uses [magic comments](https://docs.rubocop.org/en/stable/configuration/#disabling-cops-within-source-code).

The R10KEval Parser uses the magic comment of `# resolver:disable` to disable tasks.  For example;

You can set a comment for one module like this:

``` ruby
mod 'puppetlabs-stdlib', :latest # resolver:disable Dependency/All
```

or for many modules by wrapping the modules like this:

``` ruby
# resolver:disable Dependency/All
mod 'puppetlabs-stdlib', :latest
mod 'puppetlabs-apache', '1.0.0'
# resolver:ensable Dependency/All
```

You can also set multiple items by using a comma like this:

``` ruby
mod 'puppetlabs-stdlib', :latest # resolver:disable Dependency/All,Dependency/Puppet
```

Note there is no space between items.

The available settings are:

| Setting Name        | Description |
| --------------------| ----------- |
| `Dependency/Puppet` | Instructs the resolver to ignore any Puppet version in its dependency traversal for the specified modules. Useful for modules with outdated metadata.json information |
| `Dependency/All`    | Instructs the resolver to ignore any, and all, dependencies in its dependency traversal of the specified module. Useful for modules with outdated metadata.json information. |
