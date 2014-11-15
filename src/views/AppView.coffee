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
        playerScore = @model.get('playerHand').realScore()
        dealerScore = @model.get('dealerHand').realScore()

        if (playerScore > 21)
          $('.topView').prepend("<h1>You BUSTED!!!</h1>")
        else if (dealerScore > 21)
          $('.topView').prepend("<h1>Dealer BUSTED!!!</h1>")
        else if (dealerScore >= playerScore)
          $('.topView').prepend("<h1>The House ALWAYS Wins!!!</h1>")
        else
          $('.topView').prepend("<h1>You Won!!!</h1>")
        @$('button').remove()
        $('h1').append("<button class='restart-button'>Play Again</button>")
        console.log @model.get('deck')


  render: ->
    @$el.children().detach()
    console.log(@model)
    @$el.html @template(@model)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

