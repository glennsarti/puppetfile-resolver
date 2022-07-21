# Change Log

All notable changes to the "puppet-editor-services" repository will be documented in this file.

Check [Keep a Changelog](http://keepachangelog.com/) for recommendations on how to structure this file.

## Unreleased

## 0.6.2 - 2022-07-21

### Fixed

- ([GH-38](https://github.com/glennsarti/puppetfile-resolver/pull/38)) Support using commits for GClone spec searcher, correctly print errors ([beechtom](https://github.com/beechtom))

## 0.6.1 - 2022-06-23

### Fixed

- ([GH-36](https://github.com/glennsarti/puppetfile-resolver/pull/36)) Fix bugs in Git spec searchers ([beechtom](https://github.com/beechtom))

## 0.6.0 - 2022-06-13

### Added

- ([GH-33](https://github.com/glennsarti/puppetfile-resolver/issues/33)) Adds git clone method to search for metadata file ([logicminds](https://github.com/logicminds))
- ([GH-29](https://github.com/glennsarti/puppetfile-resolver/issues/29)) Add GitLab URL support

## 0.5.0 - 2020-12-16

### Added

- ([GH-22](https://github.com/glennsarti/puppetfile-resolver/issues/22)) Add a formal configuration system
- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/9f96040ff0747ca78e5cc5cb3f53518a0af7b1dd)) Add support for HTTP Proxies ([beechtom](https://github.com/beechtom))

### Changed

- ([GH-21](https://github.com/glennsarti/puppetfile-resolver/issues/21)) Migrated to GitHub Actions

### Removed

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/5985bda7dd64524847981bbdb1b8c0a80b98419a)) Removed support for Ruby 2.1 (Puppet 4)

## 0.4.0 - 2020-09-09

### Fixed

- ([GH-15](https://github.com/glennsarti/puppetfile-resolver/pull/15)) Accept forge module specifications without versions as valid ([beechtom](https://github.com/beechtom))
- ([GH-16](https://github.com/glennsarti/puppetfile-resolver/pull/16)) Support version ranges when resolving dependencies ([beechtom](https://github.com/beechtom))

### Added

- ([GH-14](https://github.com/glennsarti/puppetfile-resolver/pull/14)) Read Puppetfile document model from resolution result ([beechtom](https://github.com/beechtom))

## 0.3.0 - 2020-07-11

### Fixed

- ([GH-7](https://github.com/glennsarti/puppetfile-resolver/issues/7)) Sample usage file doesn't work
- ([GH-10](https://github.com/glennsarti/puppetfile-resolver/issues/10)) Fix for legacy style metadata.json dependencies

## 0.2.0 - 2020-03-20

### Added

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/6f267240b387d8399c5821415243c2ab426446f2)) Add flag to ignore :latest validation errors

## 0.1.0 - 2020-03-04

### Added

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/67678ff4d5b52f5afabe6c141167fc10e582f86e)) Add magic comments for Puppetfile parser

## 0.0.3 - 2019-11-25

### Fixed

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/0793b9e4fa0acefd6c52aff7fb170c96b09a0311)) OpenSSL errors cause resolution to fail

## 0.0.2 - 2019-11-21

### Added

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/522a22a7d7715822212704807486b8954ee64ce3)) Added support for Ruby 2.1.9

### Fixed

- ([Commit](https://github.com/glennsarti/puppetfile-resolver/commit/5bd5253873e012c6a4d0b4474a3a90c8feaaeafc)) Use plain version range

## 0.0.1 - 2019-11-04

### Added

- Initial release of the puppetfile-resolver
