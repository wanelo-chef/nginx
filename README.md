nginx Cookbook
==============

This cookbook will be a drop-in replacement for the `nginx` cookbook maintained
by Opscode, hosted at [Github](https://github.com/opscode-cookbooks/nginx).

This cookbook should be considered **alpha** until version 1.0.0. Internals may
change at any time.

## Running tests

Integration tests use Vagrant with SmartOS.

* Install Vagrant
* Install vagrant-smartos-zones: `vagrant plugin install
  vagrant-smartos-zones`

```bash
bundle exec kitchen verify
```
