module.exports =
  config:
    foodcriticExecutablePath:
      type: 'string'
      default: 'foodcritic'
    foodcriticExtraArgs:
      type: 'string'
      default: ''

  activate: ->
    console.log 'activate linter-foodcritic'
