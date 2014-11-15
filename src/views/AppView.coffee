class window.AppView extends Backbone.View
  className: 'topView'

  template: _.template '
    <button class="hit-button">Hit!</button>
    <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()

  initialize: ->
    @render()
    @model.on 'change:dealerTurn', =>
      @$('button').remove()
      ##console.log(@$('.topView'));
      ##$('.topView').prepend("<h1>Done!!!</h1>")
    @model.on 'change:gameOver', =>
      [playerMinScore, playerMaxScore] = @model.get('playerHand').scores()
      [dealerMinScore, dealerMaxScore] = @model.get('dealerHand').scores()

      if(playerMaxScore > 21)
        playerScore = playerMinScore
      else
        playerScore = playerMaxScore

      if(dealerMaxScore > 21)
        dealerScore = dealerMinScore
      else
        dealerScore = dealerMaxScore

      if (playerScore > 21)
        $('.topView').prepend("<h1>You BUSTED!!!</h1>")
      else if (dealerScore > 21)
        $('.topView').prepend("<h1>Dealer BUSTED!!!</h1>")
      else if (dealerScore >= playerScore)
        $('.topView').prepend("<h1>The House ALWAYS Wins!!!</h1>")
      else
        $('.topView').prepend("<h1>You Won!!!</h1>")

  render: ->
    @$el.children().detach()
    console.log(@model)
    @$el.html @template(@model)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

