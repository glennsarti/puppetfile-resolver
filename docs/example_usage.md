---
---

# Example Usage

{% include sections.md %}

---

This example reads in a Puppet file from `'/path/to/Puppetfile'` and outputs any validation errors to the console

``` ruby
puppetfile_path = '/path/to/Puppetfile'

# Parse the Puppetfile into an object model
content = File.open(puppetfile_path, 'rb') { |f| f.read }
require 'puppetfile-resolver'
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
