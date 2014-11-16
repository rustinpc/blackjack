class window.AppView extends Backbone.View
  className: 'topView'

  template: _.template '
    <button class="hit-button">Hit!</button>
    <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': ->
      @model.get('playerHand').hit()
    'click .stand-button': ->
      @model.get('playerHand').stand()
    'click .restart-button': ->
      @model.deal()
      @render()

  initialize: ->
    @render()
    @model.on 'change:dealerTurn', =>
      @$('button').remove() if @model.get('dealerTurn')

    @model.on 'change:gameOver', =>
      if @model.get('gameOver')
        @endGame()
    setTimeout(@endAtStart,100)

  endAtStart: =>
    if @model.get('blackjack')
      @endGame('blackjack')

  endGame: (blackjack) ->
    if blackjack
      playerScore = @model.get('playerHand').twentyOne()
      dealerScore = @model.get('dealerHand').twentyOne()
    else
      playerScore = @model.get('playerHand').realScore()
      dealerScore = @model.get('dealerHand').realScore()
    if (playerScore > 21)
      @model.dealerWin()
      $('.topView').prepend("<h1>You BUSTED!!!</h1>")
    else if (dealerScore > 21)
      @model.playerWin()
      $('.topView').prepend("<h1>Dealer BUSTED!!!</h1>")
    else if (dealerScore > playerScore)
      @model.dealerWin()
      $('.topView').prepend("<h1>The House ALWAYS Wins!!!</h1>")
    else if (dealerScore == playerScore)
      $('.topView').prepend("<h1>Tie!!! It's a push!</h1>")
    else
      $('.topView').prepend("<h1>You Won!!!</h1>")
      @model.playerWin()
    @$('button').remove()
    $('h1').append("<br /><button class='restart-button'>Play Again</button>")
    $('.winCount').remove()
    @addScores()

  addScores: ->
    $('.topView').prepend("<div class='winCount'>You: " + @model.playerWins + "<br />Dealer: " + @model.dealerWins) + "</div>"

  render: ->
    @$el.children().detach()
    @$el.html @template(@model)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @addScores()
