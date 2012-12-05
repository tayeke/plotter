class App
  # Application Constructor
  constructor: ->
      @.shows = []
      @.browser_testing = false
  # Bind Event Listeners
  #
  # Bind any events that are required on startup. Common events are:
  # 'load', 'deviceready', 'offline', and 'online'.
  bindEvents: =>
    @.receivedEvent 'body loaded'
    $ =>
      unless @.browser_testing
        document.addEventListener 'deviceready', @.onDeviceReady, false
      else
        @.onDeviceReady()
  # deviceready Event Handler
  #
  # The scope of 'this' is the event. In order to call the 'receivedEvent'
  # function, we must explicity call 'app.receivedEvent(...);'
  onDeviceReady: =>
    @.receivedEvent 'deviceready'
    @.database = window.localStorage
    @.receivedEvent 'localstorage ready'
    # @.insertShow('Dexter')
    @.getAllShows()
    @.domReady()
  domReady: =>
    @.receivedEvent 'adding jquery functionality in domReady'
    $('#newShow').submit (e) =>
      e.preventDefault()
      $new_title = $('input[name="show_title"]')
      @.insertShow $new_title.val()
      $new_title.val ''
  receivedEvent: (id) =>
    console.log "Received Event: #{id}"
  getAllShows: =>
    selection = @.database.getItem 'shows'
    if selection
      all_shows = JSON.parse selection
      @.addShow(show) for show in all_shows
    else
      @.shows = []
  addShow: (_show) =>
    @.shows.push new Show(_show)
  removeShow: (_show) =>
    i = @.shows.indexOf _show
    @.shows.splice i,1
    @.storeShows()
  insertShow: (title) =>
    @.receivedEvent "Created: #{title}"
    new_show = 
      title: title
      season: 1
      episode: 1
    @.shows.push new Show(new_show)
    @.storeShows()
  storeShows: =>
    data = []
    data.push(show.attributes) for show in @.shows
    @.database.setItem 'shows', JSON.stringify(data)
  dataError: (err) =>
    alert "Sorry there was an error processing data: #{err.code} : #{err.msg}"
  dataSuccess: =>
    # data input successfull


class Show
  constructor: (show) ->
    @.attributes = {}
    @.attributes[key] = val for key, val of show
    @.createElement()
    @.bindEvents()
    @.render()
  bindEvents: =>
    @.$el.click (me) =>
      @.remove()
      app.removeShow @
  increment: (param) =>
    @.attributes[param] += 1
    app.storeShows()
  decrement: (param) =>
    @.attributes[param] -= 1
    app.storeShows()
  render: =>
    @.$el.html("<a href=\"#\">#{@.attributes.title}<span class=\"chevron\"></span></a>")
    $('#shows').append @.$el
  createElement: =>
    @.$el = $('<li>')
  remove: =>
    @.$el.remove()

#start app
@app = new App