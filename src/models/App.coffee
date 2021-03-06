# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set('deck', deck = new Deck())
    @set('playerHand', deck.dealPlayer())
    @set('dealerHand', deck.dealDealer())
    @reInit()

  blackjack: false;

  gameOver: false

  dealerTurn: false

  dealerWins: 0

  playerWins: 0

  dealerWin: ->
    @dealerWins += 1

  playerWin: ->
    @playerWins += 1

  reInit: ->
    @get('playerHand').on 'stand', =>
      @set('dealerTurn', true)
      @computerPlay()
    @get('playerHand').on 'done', =>
      @set('gameOver', true)
    if @get('dealerHand').twentyOne() == 21
      @set('blackjack', true)
      @computerPlay()
    else if @get('playerHand').twentyOne() == 21
      @set('gameOver', true)
      @set('blackjack', true)


  computerPlay: ->
    [cardOne] = @get('dealerHand').models
    if not cardOne.get 'revealed'
      cardOne.flip()
    [dealerMinScore, dealerMaxScore] = @get('dealerHand').scores()
    [playerMinScore, playerMaxScore] = @get('playerHand').scores()

    if (dealerMinScore >= 17) or (21 >= dealerMaxScore >= 18) or  @get('dealerHand').realScore() >= @get('playerHand').realScore()
      @set('gameOver', true)
    else
      @get('dealerHand').hit()
      @computerPlay()

  deal: ->
    if(@get('deck').models.length < 10)
      @set('deck', deck = new Deck())
    @set('playerHand', @get('deck').dealPlayer())
    @set('dealerHand', @get('deck').dealDealer())
    @set('gameOver', false)
    @set('dealerTurn', false)
    @reInit()


