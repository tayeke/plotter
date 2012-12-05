class App
  # Application Constructor
  constructor: ->
      @.shows = []
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
    @.database = window.openDatabase 'plotter_development', '1.0', 'Plotter Data', 200000
    @.database.transaction @.populateDB, @.dataError, @.dataSuccess
    # @.insertShow('Dexter')
    @.getAllShows()
    @.domReady()
  domReady: =>
    $('#newShow').submit (e) =>
      e.preventDefault()
      $new_title = $('input[name="show_title"]')
      @.insertShow $new_title.val()
      $new_title.val ''
  receivedEvent: (id) =>
    console.log "Received Event: #{id}"
  populateDB: (db) =>
    db.executeSql 'CREATE TABLE IF NOT EXISTS SHOWS (id INTEGER PRIMARY KEY AUTOINCREMENT, title varchar(255) NOT NULL, season INTEGER DEFAULT 1, episode INTEGER DEFAULT 1)'
  getAllShows: =>
    showsSelected = (db, results) =>
      if len = results.rows.length
        @.addShow(results.rows.item(x)) for x in [0..len-1]
        # console.log("Row = " + i + " ID = " + results.rows.item(i).id + " Data =  " + results.rows.item(i).data);

    getShows = (db) =>
      db.executeSql "SELECT * FROM SHOWS", @.dataError, showsSelected

    @.database.transaction getShows, @.dataError
  addShow: (_show) =>
    @.shows.push new Show(_show)
  removeShow: (_show) =>
    i = @.shows.indexOf _show
    @.shows.splice i,1
  insertShow: (title) =>
    afterCreated = (db, results) =>
      @.shows.push new Show(results.rows.item(0))
    afterInsert = (db, results) =>
      db.executeSql "SELECT * FROM SHOWS WHERE id = #{results.insertId}", @.dataError, afterCreated
    createShow = (db) ->
      db.executeSql "INSERT INTO SHOWS (title) VALUES ('#{title}')", @.dataError, afterInsert
    @.database.transaction createShow, @.dataError
  dataError: (err) =>
    alert "Sorry there was an error processing data: #{err.code} : #{err.msg}"
  dataSuccess: =>
    # data input successfull


class Show
  constructor: (show) ->
    @[key] = val for key, val of show
    @.createElement()
    @.bindEvents()
    @.render()
  bindEvents: =>
    @.$el.click (me) =>
      @.delete()
      @.remove()
      app.removeShow @
  increment: (param) =>
    success = =>
      @[param] += 1
    update = (db) =>
      db.executeSql "UPDATE SHOWS SET #{param} = (#{param} + 1) WHERE id = '#{@.id}'", app.dataError, success
    app.database.transaction update, app.dataError
  decrement: (param) =>
    success = =>
      @[param] -= 1
    update = (db) =>
      db.executeSql "UPDATE SHOWS SET #{param} = (#{param} - 1) WHERE id = '#{@.id}'", app.dataError, success
    app.database.transaction update, app.dataError
  render: =>
    @.$el.html("<a href=\"#\">#{@.title}<span class=\"chevron\"></span></a>")
    $('#shows').append @.$el
  createElement: =>
    @.$el = $('<li>')
  delete: =>
    remove = (db) =>
      db.executeSql "DELETE FROM SHOWS WHERE id = '#{@.id}'", app.dataError
    app.database.transaction remove, app.dataError
  remove: =>
    @.$el.remove()

#start app
app = new App