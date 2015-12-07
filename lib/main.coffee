{BufferedProcess, CompositeDisposable} = require 'atom'
pathModule = require 'path'
XRegExp = require('xregexp').XRegExp
helpers = require 'atom-linter'

module.exports =
  config:
    executablePath:
      type: 'string'
      default: 'foodcritic'
    extraArgs:
      type: 'string'

  activate: ->
    @subscriptions = new CompositeDisposable
    @MessageRegexp = null
    @subscriptions.add atom.config.observe 'foodcritic.executablePath', (executablePath) =>
      @executablePath = executablePath
    @subscriptions.add atom.config.observe 'foodcritic.extraArgs', (extraArgs) =>
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
        cwd = pathModule.dirname(helpers.findFile(fileDir, 'metadata.rb'))
        if cwd is '.'
          atom.notifications.addWarning('[foodcritic] No metadata.rb found, not linting!', {dismissable: true})
          return Promise.resolve([])
        currentFileRelPath = pathModule.relative(cwd, currentFilePath)
        # change filePath to be relative to @cwd
        filePath = currentFileRelPath.replace(/\\/g, '/').replace(/^\//, '')
        regex = "(?<text>.+:\\s.+):\\s+(./)?(?<filePath>#{filePath}|[\\w+\\._]+):(?<line>\\d+)"
        if @extraArgs
          args = @extraArgs.split(' ').concat ['.']
        else
          args = ['.']
        helpers.exec(@executablePath, args, {cwd: cwd}).then (output) ->
          return [] unless output?
          messages = []
          @MessageRegexp ?= XRegExp regex, ''
          XRegExp.forEach output, @MessageRegexp, (match, i) ->
            match.line ?= 0
            normFilePath = pathModule.normalize(match.filePath)
            if normFilePath is currentFileRelPath
              msg = {
                type: 'Error',
                text: match.text,
                filePath: currentFilePath,
                range: helpers.rangeFromLineNumber(textEditor, match.line - 1)
              }
              messages.push msg if msg.range?
          messages
