class App
  # Application Constructor
  constructor: ->
      @.bindEvents()
  # Bind Event Listeners
  #
  # Bind any events that are required on startup. Common events are:
  # 'load', 'deviceready', 'offline', and 'online'.
  bindEvents: =>
    document.addEventListener 'deviceready', @.onDeviceReady, false
  # deviceready Event Handler
  #
  # The scope of 'this' is the event. In order to call the 'receivedEvent'
  # function, we must explicity call 'app.receivedEvent(...);'
  onDeviceReady: =>
    @.receivedEvent 'deviceready'
  # Update DOM on a Received Event
  receivedEvent: (id) =>
    console.log "Received Event: #{id}"

#start app
app = new App