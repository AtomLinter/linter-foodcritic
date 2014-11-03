linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"
pathModule = require 'path'

class LinterFoodcritic extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.ruby']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'foodcritic'

  linterName: 'foodcritic'

  # A regex pattern used to extract information from the executable's output.
  regex: null  # check getCmdAndArgs function

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-foodcritic.foodcriticExecutablePath', ->
      @executablePath = atom.config.get 'linter-foodcritic.foodcriticExecutablePath'

    extraArgs = ""
    atom.config.observe 'linter-foodcritic.foodcriticExtraArgs', ->
      extraArgs = atom.config.get 'linter-foodcritic.foodcriticExtraArgs'
    @cmd += " #{extraArgs}"

  getCmdAndArgs: (filePath) ->
    # find metadata.rb recursively in parent folders
    filePath = atom.workspace.getActiveTextEditor().getPath()
    console.log('Filepath:' + filePath)
    fileDir = pathModule.dirname(filePath)
    @cwd = pathModule.dirname(findFile(fileDir, 'metadata.rb'))
    # change filePath to be relative to @cwd
    filePath = filePath.replace(@cwd, '').replace(/\\/g, '/').replace(/^\//, '')
    @regex = "(?<message>.+:\\s.+):\\s+(./)?(?:#{filePath}|[\\w+\\._]+):(?<line>\\d+)"
    console.log('CWD: ' + @cwd)
    super(filePath)

  destroy: ->
    atom.config.unobserve 'linter-foodcritic.foodcriticExecutablePath'

module.exports = LinterFoodcritic
