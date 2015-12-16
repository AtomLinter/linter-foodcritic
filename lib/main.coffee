{CompositeDisposable} = require 'atom'
pathModule = require 'path'
helpers = require 'atom-linter'

module.exports =
  config:
    executablePath:
      type: 'string'
      default: 'foodcritic'
    extraArgs:
      title: 'Extra Arguments'
      description: 'Extra arguments to pass to foodcritic'
      type: 'string'
      default: ''

  activate: ->
    @subscriptions = new CompositeDisposable
    @MessageRegexp = /(FC\d{3}:\s.+):(?:.+):(\d+)/g
    @subscriptions.add atom.config.observe 'linter-foodcritic.executablePath', (executablePath) =>
      @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-foodcritic.extraArgs', (extraArgs) =>
      @extraArgs = extraArgs

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      name: 'foodcritic'
      grammarScopes: ['source.ruby.chef']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        currentFilePath = textEditor.getPath()
        fileDir = pathModule.dirname(currentFilePath)
        cwd = pathModule.dirname(helpers.find(fileDir, 'metadata.rb'))
        if cwd is '.'
          atom.notifications.addWarning('[foodcritic] No metadata.rb found, not linting!', {dismissable: true})
          return Promise.resolve([])
        if @extraArgs
          args = @extraArgs.split(' ').concat [currentFilePath]
        else
          args = [currentFilePath]
        regex = @MessageRegexp
        helpers.exec(@executablePath, args, {cwd: cwd}).then (output) ->
          return [] unless output?
          messages = []
          while((match = regex.exec(output)) isnt null)
            match.line = 1 if typeof match[2] is 'undefined' or match[2] < 1
            messages.push {
              type: 'Error',
              text: match[1],
              filePath: currentFilePath,
              range: helpers.rangeFromLineNumber(textEditor, match[2] - 1)
            }
          return messages
