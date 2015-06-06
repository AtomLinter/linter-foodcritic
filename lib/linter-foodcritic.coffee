linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"
pathModule = require 'path'

class LinterFoodcritic extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.ruby.chef']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: null

  linterName: 'foodcritic'

  # A regex pattern used to extract information from the executable's output.
  regex: null  # check getCmdAndArgs function


  constructor: (editor)->
    super(editor)
    @pathSubscription = atom.config.observe 'linter-foodcritic.foodcriticExecutablePath', =>
      @executablePath = atom.config.get 'linter-foodcritic.foodcriticExecutablePath'

    @extraArgs = ""
    @argsSubscription = atom.config.observe 'linter-foodcritic.foodcriticExtraArgs', =>
      @extraArgs = atom.config.get 'linter-foodcritic.foodcriticExtraArgs'

  getCmdAndArgs: (filePath) ->
    # find metadata.rb recursively in parent folders
    editor = atom.workspace.getActiveTextEditor()
    if editor?
      filePath = editor.getPath()
      fileDir = pathModule.dirname(filePath)
      @cwd = pathModule.dirname(findFile(fileDir, 'metadata.rb'))
      # change filePath to be relative to @cwd
      filePath = filePath.replace(@cwd, '').replace(/\\/g, '/').replace(/^\//, '')

    @regex = "(?<message>.+:\\s.+):\\s+(./)?(?:#{filePath}|[\\w+\\._]+):(?<line>\\d+)"

    {
      command: @executablePath,
      args: @extraArgs.split(' ').concat [filePath]
    }

  destroy: ->
    super
    @pathSubscription.dispose()
    @argsSubscription.dispose()

module.exports = LinterFoodcritic
