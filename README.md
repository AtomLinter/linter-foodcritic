linter-foodcritic
=========================

This linter plugin for [Linter](https://github.com/AtomLinter/Linter) provides an interface to [foodcritic](https://github.com/AtomLinter/linter-foodcritic). It will be used with files that have the “Ruby” syntax.

## Installation
Linter package must be installed in order to use this plugin. If Linter is not installed, please follow the instructions [here](https://github.com/AtomLinter/Linter).

### foodcritic installation
Before using this plugin, you must ensure that `foodcritic` is installed on your system. To install `foodcritic`, do the following:

1. Install [ruby](https://www.ruby-lang.org/).

2. Install [foodcritic](http://acrmp.github.io/foodcritic/) by typing the following in a terminal:
   ```
   gem install foodcritic
   ```
3. Alternatively install ChefDK which already includes foodcritic:
   ```
   https://downloads.getchef.com/chef-dk/
   ```

Now you can proceed to install the linter-foodcritic plugin.

### Plugin installation
```
$ apm install linter-foodcritic
```

## Settings
You can configure linter-foodcritic by editing ~/.atom/config.cson (choose Open Your Config in Atom menu):

#### foodcriticExecutablePath
```
'linter-foodcritic':
  'foodcriticExecutablePath': null # foodcritic path.
```
Run `which foodcritic` to find the path

#### foodcriticExtraArgs
```
'linter-foodcritic':
  'foodcriticExtraArgs': "" # additional arguments to foodcritic
```

## Contributing
If you would like to contribute enhancements or fixes, please do the following:

1. Fork the plugin repository.
1. Hack on a separate topic branch created from the latest `master`.
1. Commit and push the topic branch.
1. Make a pull request.
1. welcome to the club

Please note that modifications should follow these coding guidelines:

- Indent is 2 spaces.
- Code should pass coffeelint linter.
- Vertical whitespace helps readability, don’t be afraid to use it.

Thank you for helping out!

## Donation
[![Share the love!]()
