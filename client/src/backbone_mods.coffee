define ['jquery', 'underscore', 'backbone', 'application'], ($, _, Backbone, app) ->
  methodMap =
    'create': 'POST',
    'update': 'POST', #'PUT',
    'patch':  'POST', #'PATCH',
    'delete': 'DELETE',
    'read':   'GET'

  origSync = Backbone.sync
  # Copied from backbone-1.0.0.js
  Backbone.sync = (method, model, options = {}) ->
    headers = options.headers || {}
    # headers.ZSESSIONID = $.cookie('ZSESSIONID') # Rally override!
    # headers.JSESSIONID = $.cookie('JSESSIONID') # Rally override!
    
    # Rally Override!
    options.xhrFields =
      withCredentials: true

    options.headers = headers

    type = methodMap[method]

    # Default options, unless specified.
    _.defaults(options, {
      emulateHTTP: Backbone.emulateHTTP,
      emulateJSON: Backbone.emulateJSON
    })

    # Default JSON-request options.
    params = {type: type, dataType: 'json'}

    # Ensure that we have a URL.
    if !options.url
      params.url = _.result(model, 'url') || urlError()

    # Rally Override! ALM WSAPI adds /create to create URL
    params.url += '/create' if method is 'create'

    # Ensure that we have the appropriate request data.
    if (!options.data? && model && (method == 'create' || method == 'update' || method == 'patch'))
      params.contentType = 'application/json'
      params.data = JSON.stringify({model: (options.attrs or model.toJSON(options))}) #Rally Override!

      # Rally Override!
      params.url += "?key=#{app.session.getSecurityToken()}"

    # For older servers, emulate JSON by encoding the request into an HTML-form.
    if options.emulateJSON
      params.contentType = 'application/x-www-form-urlencoded'
      params.data = if params.data then {model: params.data} else {}

    # For older servers, emulate HTTP by mimicking the HTTP method with `_method`
    # And an `X-HTTP-Method-Override` header.
    if (options.emulateHTTP && (type == 'PUT' || type == 'DELETE' || type == 'PATCH'))
      params.type = 'POST'
      if options.emulateJSON
        params.data._method = type
      beforeSend = options.beforeSend
      options.beforeSend = (xhr) ->
        xhr.setRequestHeader('X-HTTP-Method-Override', type)
        if beforeSend
          return beforeSend.apply(this, arguments)

    # Don't process data on a non-GET request.
    if params.type != 'GET' && !options.emulateJSON
      params.processData = false

    # If we're sending a `PATCH` request, and we're in an old Internet Explorer
    # that still has ActiveX enabled by default, override jQuery to use that
    # for XHR instead. Remove this line when jQuery supports `PATCH` on IE8.
    if (params.type == 'PATCH' && window.ActiveXObject &&
          !(window.external && window.external.msActiveXFilteringEnabled))
      params.xhr = ->
        return new ActiveXObject("Microsoft.XMLHTTP")
      
    error = options.error
    options.error = (xhr, status, thrown) ->
      error?(model, xhr, options)
      model.trigger('error', model, xhr, options)
      if xhr.status is 401 or xhr.status is 0
        # document.cookie = 'ZSESSIONID=; expires=Thu, 01 Jan 1970 00:00:01 GMT;'
        document.cookie = 'JSESSIONID=; expires=Thu, 01 Jan 1970 00:00:01 GMT;'
        Backbone.history.navigate('/login', {trigger: true, replace: true})

    success = options.success
    options.success = (resp, status, xhr) ->
      if resp.OperationResult?.Errors?.length > 0 || resp.CreateResult?.Errors?.length > 0
        options.error(xhr, "ws", null)
      else
        success?(resp, status, xhr)

    # Make the request, allowing the user to override any Ajax options.
    xhr = options.xhr = Backbone.ajax(_.extend(params, options))
    model.trigger('request', model, xhr, options)
    xhr
