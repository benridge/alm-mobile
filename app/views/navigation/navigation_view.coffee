BaseView = require '../view'
template = require './templates/navigation'

module.exports = class NavigationView extends BaseView

  initialize: (options) ->
    @router = options.router

  el: '#content'

  events:
    'click button[data-target]': 'doNavigate'

  template: template

  settings:
    workType: 'myWork'

  doNavigate: (e) ->
    console.log 'nav to', e.currentTarget.getAttribute 'data-target'
    @router.navigate e.currentTarget.getAttribute('data-target'), trigger: true

  getSetting: (setting) -> @settings[setting]

  getRenderData: ->
    timeRemaining: 4
    timeRemainingUnits: 'days'
    percentAccepted: 50
    pointsAccepted: 6
    totalPoints: 12
    activeDefects: 3
    buttons: [
      {
        displayName: if @getSetting('workType') is 'myWork' then 'My Work' else 'My Team'
        viewHash: 'home'
      }
      {
        displayName: 'Tracking Board'
        viewHash: 'board'
      }
      {
        displayName: 'Burndown Chart'
        viewHash: 'burndown'
      }
      {
        displayName: 'Recent Activity'
        viewHash: 'recentActivity'
      }
    ]

  render: ->
    super
