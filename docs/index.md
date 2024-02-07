---
title: "Puppetfile Resolver"
layout: default
---
[![Open Issues](https://img.shields.io/github/issues/glennsarti/puppetfile-resolver)](https://github.com/glennsarti/puppetfile-resolver/issues)
[![License](https://img.shields.io/github/license/glennsarti/puppetfile-resolver)](https://github.com/glennsarti/puppetfile-resolver)
[![Gem Version](https://img.shields.io/gem/v/puppetfile-resolver)](https://rubygems.org/gems/puppetfile-resolver)

{% include sections.md %}

---

⚠⚠⚠ This project is no longer being maintained ⚠⚠⚠

It's is now forked by [Puppet (nee Puppetlabs)](https://github.com/puppetlabs/puppetfile-resolver), and Puppet now owns the [Ruby Gem](https://rubygems.org/gems/puppetfile-resolver).


# Puppetfile Resolver

The [Puppetfile](https://puppet.com/docs/pe/latest/puppetfile.html) is used by Puppet to manage the collection of modules used by a Puppet master. The Puppetfile is then used by tools like [R10K](https://github.com/puppetlabs/r10k) and [Code Manager](https://puppet.com/docs/pe/latest/code_mgr_how_it_works.html#how-code-manager-works) to download and install the required modules.

However, the Puppetfile is designed to have explicit dependencies, that is, **all** modules and **all** of the dependencies must be specified in Puppetfile. This is very different to formats like `Gemfile` (Ruby) or `package.json` (NodeJS) where dependencies are brought in as needed.

Using explicit dependencies is great in a configuration management system like Puppet, but it puts the burden on updates onto the user.

This library includes all of the code to parse a Puppetfile and then calculate a dependency graph to try and resolve all of the module dependencies and versions. The resolver can also restrict on Puppet version, for example, only Modules which support Puppet 6.

**Note** This library is in active development!

## Supported Searchers

See "Module Searchers" in the [Architecture](./architecture) for more information about searchers.

Currently supported searchers:

* Git Clone
* GitHub
* GitLab
* Local FileSystem
* Puppet Forge

## To Do

- Could do with more tests
- Add YARD documentation
