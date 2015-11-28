linter-foodcritic
=========================

This linter plugin for [Linter](https://github.com/atom-community/linter)
provides an interface to [foodcritic](http://www.foodcritic.io/). It will be
used with files that have the
["Chef" syntax](https://atom.io/packages/language-chef).

## Installation
Linter package must be installed in order to use this plugin. If Linter is not
installed, please follow the instructions
[here](https://github.com/AtomLinter/Linter).

### foodcritic installation
Before using this plugin, you must ensure that `foodcritic` is installed on
your system. To install `foodcritic`, do the following:

1. Install [ruby](https://www.ruby-lang.org/).

2. Install [foodcritic](http://www.foodcritic.io/) by typing the following in a terminal:
   ```ShellSession
   gem install foodcritic
   ```
3. Alternatively install ChefDK which already includes foodcritic: https://downloads.chef.io/chef-dk/

Now you can proceed to install the `linter-foodcritic` plugin.

### Plugin installation
```ShellSession
$ apm install linter-foodcritic
```
