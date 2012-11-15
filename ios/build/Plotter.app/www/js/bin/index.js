// Generated by CoffeeScript 1.4.0
var App, app,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

App = (function() {

  function App() {
    this.receivedEvent = __bind(this.receivedEvent, this);

    this.onDeviceReady = __bind(this.onDeviceReady, this);

    this.bindEvents = __bind(this.bindEvents, this);
    this.bindEvents();
  }

  App.prototype.bindEvents = function() {
    return document.addEventListener('deviceready', this.onDeviceReady, false);
  };

  App.prototype.onDeviceReady = function() {
    return this.receivedEvent('deviceready');
  };

  App.prototype.receivedEvent = function(id) {
    var listeningElement, parentElement, receivedElement;
    parentElement = document.getElementById(id);
    listeningElement = parentElement.querySelector('.listening');
    receivedElement = parentElement.querySelector('.received');
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    return console.log("Received Event: " + id);
  };

  return App;

})();

app = new App;
