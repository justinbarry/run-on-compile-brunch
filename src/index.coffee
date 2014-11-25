
module.exports = class RunOnCompilePlugin
  brunchPlugin: yes
  constructor: (@config)->
    cfg = @config?.plugins?.runOnCompile ? {}

    # we won't even attempt to run anything if the command isn't provided.
    if cfg.command?
      @runOnCompile = true
      @commandToRun = cfg.command
      @failureMessage = cfg.failureMessage ? "Command Failed"
    else
      @runOnCompile = false

  onCompile: ()=>
    return unless @runOnCompile
    exec = require('child_process').exec;
    exec @commandToRun, (error, stdout, stderr) ->
      console.log stdout
      if error?
        notifier = require('node-notifier')
        notifier.notify
          'title': @failureMessage
          'message': stdout.split("\n")[1]
