class window.CardView extends Backbone.View
  className: 'card'

  template: _.template '<div class="bg" style="background-image: url(img/cards/<%= rankName %>-<%= suitName %>.png)"></div>'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @model.attributes
    @$el.addClass 'covered' unless @model.get 'revealed'

