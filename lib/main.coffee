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
      default: ''
    lintOnFly:
      type: 'boolean'
      default: true

  activate: ->
    @subscriptions = new CompositeDisposable
    @MessageRegexp = null
    @subscriptions.add atom.config.observe 'linter-foodcritic.executablePath', =>
      @executablePath = atom.config.get 'linter-foodcritic.executablePath'
    @subscriptions.add atom.config.observe 'linter-foodcritic.extraArgs', =>
      @extraArgs = atom.config.get 'linter-foodcritic.extraArgs'
    @subscriptions.add atom.config.observe 'foodcritic.executablePath', =>
      @executablePath = atom.config.get 'linter-foodcritic.executablePath'
    @subscriptions.add atom.config.observe 'linter-foodcritic.lintOnFly', =>
      @lintOnFly = atom.config.get 'linter-foodcritic.lintOnFly'

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['source.ruby.chef']
      scope: 'file'
      lintOnFly: @lintOnFly
      lint: (textEditor) =>
        return new Promise (resolve, reject) =>
          currentFilePath = textEditor.getPath()
          fileDir = pathModule.dirname(currentFilePath)
          cwd = pathModule.dirname(helpers.findFile(fileDir, 'metadata.rb'))
          if cwd == '.'
            resolve []
          currentFileRelPath = pathModule.relative(cwd, currentFilePath)
          # change filePath to be relative to @cwd
          filePath = currentFileRelPath.replace(/\\/g, '/').replace(/^\//, '')
          regex = "(?<text>.+:\\s.+):\\s+(./)?(?<filePath>#{filePath}|[\\w+\\._]+):(?<line>\\d+)"
          fOutput = ''
          if @extraArgs
            args = @extraArgs.split(' ').concat ['.']
          else
            args = ['.']
          process = new BufferedProcess
            command: @executablePath
            args: args
            options:
              cwd: cwd
            stdout: (data) ->
              fOutput += data
            exit: (code) ->
              console.log("out: #{fOutput}")
              return resolve [] unless code is 0
              return resolve [] unless fOutput?
              messages = []
              @MessageRegexp ?= XRegExp regex, ''
              XRegExp.forEach fOutput, @MessageRegexp, (match, i) ->
                match.line ?= 0
                normFilePath = pathModule.normalize(match.filePath)
                if normFilePath == currentFileRelPath
                  msg = {
                    type: 'Error',
                    text: match.text,
                    filePath: currentFilePath,
                    range: helpers.rangeFromLineNumber(textEditor, match.line - 1)
                  }
                  messages.push msg if msg.range?
              , this
              resolve messages

          process.onWillThrowError ({error,handle}) ->
            atom.notifications.addError "Failed to run #{@executablePath}",
              detail: "#{error.message}"
              dismissable: true
            handle()
            resolve []
