---
---

# Architecture

{% include sections.md %}

---

## Why a library and not a CLI tool?

Due to all of the different needs of tool developers, this is offered as a library instead of full blown CLI tool. For example, the needs of a VSCode Extensions developer are very different than that of the Puppet Developer Kit developer.

Therefore this is a library which is intended to be used by tool developers to create useful tools for users, and not really for direct use by users.

Note that a CLI is included (`puppetfile-cli.rb`) only as an example of how to create a tool using this library.

## Architecture

``` text
                    +-----------------+   +-----------------+   +-----------------+
                    | Forge Searcher  |   | Github Searcher |   | Local Searcher  |
                    +-------+---------+   +--------+--------+   +-------+---------+
                            |                      |                    |
                            +----------------------+--------------------+
                                                   |
                                                   |
                                                   V
            +--------+                        +----------+                          +-------------------+
-- Text --> | Parser | -- Document Model -+-> | Resolver | -- Dependency Graph -+-> | Resolution Result |
            +--------+                    |   +----------+                      |   +-------------------+
                                          |                                     |
                                          |                                     |
                                          V                                     V
                                    +-----------+                         +------------+
                                    | Document  |                         | Resolution |
                                    | Validator |                         | Validator  |
                                    +-----------+                         +------------+
```

### Workflow

The workflow of the library is, hopefully, straightforward:

1. A list of modules needed, typically expressed as a Puppetfile is parsed into a Document Model.  This model means that additional parsers can be added a later time, or users can craft their own Document Model and not need a parser at all. See _Creating a document model_ below for more information.

2. The Document Model can then, optionally, be validated

3. The Resolver can then be called on the Document Model, which outputs a Resolution Result (if successful) or an appropriate error

4. The Resolution Result can also be validated according to Puppetfile rules. For example, it must not include modules which were not declared in the Puppetfile.

### Puppetfile Parser

The parser converts the content of a Puppetfile into a document model (`PuppetfileResolver::Puppetfile::Document`).

See [Parsers](./parsers) for more information about the available parsers.

### Creating a document model

A user of the library can craft a document model object in any fashion they require. To do so, first the user needs to create a blank document model (`PuppetfileResolver::Puppetfile::Document.new('')`), and call `add_module` with an appropriately created module definition:

- `PuppetfileResolver::Puppetfile::ForgeModule`
- `PuppetfileResolver::Puppetfile::GitModule`
- `PuppetfileResolver::Puppetfile::LocalModule`
- `PuppetfileResolver::Puppetfile::SvnModule`

Note that the `PuppetfileResolver::Puppetfile::InvalidModule` class should not really be used as it will cause validation errors. Typically this is used by parsers to express that it found a module definition but it could not determine the type of module it is.

A complete example is shown below, where it creates a document of all the latest modules in the `module_list` array

``` ruby
module_list = ['puppetlabs/stdlib']

# Build the document model from the module names, defaulting to the latest version of each module
model = PuppetfileResolver::Puppetfile::Document.new('')
module_list.each do |mod_name|
  model.add_module(
    PuppetfileResolver::Puppetfile::ForgeModule.new(mod_name).tap { |mod| mod.version = :latest }
  )
end
```


### Puppetfile Document Validation

Even though a Puppetfile can be parsed, doesn't mean it's valid. For example, defining a module twice.

### Puppetfile Resolution

Given a Puppetfile document model, the library can attempt to recursively resolve all of the modules and their dependencies. The resolver be default will not be strict, that is, missing dependencies will not throw an error, and will attempt to also be resolved. When in strict mode, any missing dependencies will throw errors.

### Module Searchers

The Puppetfile resolution needs information about all of the available modules and versions, and does this through calling various Specification Searchers. Currently Puppet Forge, Github and Local FileSystem searchers are implemented. Additional searchers could be added, for example GitLab or SVN.

The result is a dependency graph listing all of the modules, dependencies and version information.

### Resolution validation

Even though a Puppetfile can be resolved, doesn't mean it is valid. For example, missing module dependencies are not considered valid.

### Dependency Graph

The resolver uses the [Molinillo](https://github.com/CocoaPods/Molinillo) ruby gem for dependency resolution. Molinillo is used in Bundler, among other gems, so it's well used and maintained project.

### Example usage

``` ruby
puppetfile_path = '/path/to/Puppetfile'

# Parse the Puppetfile into an object model
content = File.open(puppetfile_path, 'rb') { |f| f.read }
require 'puppetfile-resolver/puppetfile/parser/r10k_eval'
puppetfile = ::PuppetfileResolver::Puppetfile::Parser::R10KEval.parse(content)

# Make sure the Puppetfile is valid
unless puppetfile.valid?
  puts 'Puppetfile is not valid'
  puppetfile.validation_errors.each { |err| puts err }
  exit 1
end

# Create the resolver
# - Use the document we just parsed (puppetfile)
# - Don't restrict by Puppet version (nil)
resolver = PuppetfileResolver::Resolver.new(puppetfile, nil)

# Configure the resolver
cache                 = nil  # Use the default inmemory cache
ui                    = nil  # Don't output any information
module_paths          = []   # List of paths to search for modules on the local filesystem
allow_missing_modules = true # Allow missing dependencies to be resolved
opts = { cache: cache, ui: ui, module_paths: module_paths, allow_missing_modules: allow_missing_modules }

# Resolve
result = resolver.resolve(opts)

# Output resolution validation errors
result.validation_errors.each { |err| puts "Resolution Validation Error: #{err}\n"}
```
