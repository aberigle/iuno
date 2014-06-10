do ->
  class API

    path  : "https://twitter.com/i/toast_poll?oldest_unread_id=0"

    execute: (message = {}, path, method, callback) ->      
      xhr = new XMLHttpRequest
      xhr.onreadystatechange = (event) =>
        if xhr.readyState is 4          
          callback? event.target

      xhr.open method, @path + path, true
      if method in ["POST","PUT", "PATCH"]
        xhr.send JSON.stringify message
      else
        xhr.send()

  class API.Module

    api  : null
    name : null

    constructor : (@api) ->

    execute: (message, path, method, callback) ->
      @api.execute message, @name + path, method, callback

    _get: (path, callback) -> @execute null, path, "GET", callback

    _post: (message, path, callback) -> @execute message, path, "POST", callback

    _put: (message, path, callback) -> @execute message, path, "PUT", callback

    _del: (path, callback) -> @execute null, path, "DELETE", callback

  class API.Twitter extends API.Module

    constructor: ->
      super
      @name = ""

    get: (callback) -> @_get "", callback

  _api = new API

  window.API =
    clickUrl : "https://twitter.com/i/notifications"
    twitter  : new API.Twitter _api

  return

