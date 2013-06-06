define [
  'hbsTemplate'
  'application'
  'views/base/page_view'
], (hbs, app, PageView) ->
  class HomeView extends PageView
    listView: null
    tabPane: null
    region: 'main'
    template: hbs['home/templates/home']

    listen:
      'projectready mediator': 'updateTitle'

    events:
      'click .btn-block': 'onButton'

    initialize: (options) ->
      super

      @error = false

      @currentTab = options.tab || "userstories"

      unless @listView?
        throw new Error("You must define the list view class in the HomeView subclass")
      unless @createRoute?
        throw new Error("You must define the create route in the HomeView subclass")

      @listenTo @collection, 'sync', @onFetch

    onFetch: ->
      @stopListening @collection, 'sync', @onFetch
      @updateTitle()
      @view = new @listView
        autoRender: true
        container: @$(".listing")
        collection: @collection

    getTemplateData: ->
      createRoute: @createRoute
      tabs: @_getTabs()

    updateTitle: ->
      @publishEvent 'updatetitle', [_.find(@_getTabs(), active: true).value, app.session.getProjectName()].join ' in '

    onButton: (event) ->
      url = event.currentTarget.id
      @publishEvent '!router:route', url

    _getTabs: ->
      [
        {
          key: 'userstories'
          value: 'Stories'
          active: @currentTab == 'userstories'
        }
        {
          key: 'tasks'
          value: 'Tasks'
          active: @currentTab == 'tasks'
        }
        {
          key: 'defects'
          value: 'Defects'
          active: @currentTab == 'defects'
        }
      ]