define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  class NavigationView extends View
    template: hbs['navigation/templates/navigation']

    listen:
      'navigation:show mediator': 'show'

    events:
      'click button[data-target]': 'doNavigate'

    doNavigate: (e) ->
      @trigger 'navigate', e.currentTarget.getAttribute('data-target')

    show: ->
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/(\spage\stransition\scenter)?$/, ' page transition right'))
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/(transition\s)?left/, 'transition center'))
      $('#mask').show()
      $('#mask').on('click', _.bind(@hide, this))

    hide: ->
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/center/, 'left'))
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/right/, 'center'))
      $('#mask').off('click', _.bind(@hide, this))
      $('#mask').hide()
      @publishEvent 'navigation:hide'

    getTemplateData: ->
      timeRemaining: 4
      timeRemainingUnits: 'Days'
      percentAccepted: 50
      pointsAccepted: 6
      totalPoints: 12
      activeDefects: 3
      buttons: [
        {
          displayName: 'Tracking Board'
          viewHash: 'board'
        }
        {
          displayName: if app.session.isSelfMode() then 'My Work' else 'My Team'
          viewHash: 'userstories'
        }
        # {
        #   displayName: 'Burndown Chart'
        #   viewHash: 'burndown'
        # }
        {
          displayName: 'Recent Activity'
          viewHash: 'recentActivity'
        }
      ]