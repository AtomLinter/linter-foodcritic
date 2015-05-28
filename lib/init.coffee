module.exports =
  config:
    foodcriticExecutablePath:
      type: 'string'
      default: ''
    foodcriticExtraArgs:
      type: 'string'
      default: ''

  activate: ->
    console.log 'activate linter-foodcritic'
