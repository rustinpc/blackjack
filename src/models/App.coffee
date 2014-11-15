# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set('deck', deck = new Deck())
    @set('playerHand', deck.dealPlayer())
    @set('dealerHand', deck.dealDealer())
    @get('playerHand').on 'stand', =>
      @set('dealerTurn', true)
      @computerPlay()
    @get('playerHand').on 'done', =>
      @set('gameOver', true)

  gameOver: false

  dealerTurn: false

  computerPlay: ->
    [cardOne] = @get('dealerHand').models
    console.log("before", cardOne)
    if not cardOne.get 'revealed'
      cardOne.flip()
      console.log("flipped", cardOne)
    else
      console.log("not flipped", cardOne)
    [dealerMinScore, dealerMaxScore] = @get('dealerHand').scores()
    [playerMinScore, playerMaxScore] = @get('playerHand').scores()

    if (dealerMinScore >= 17) or (21 >= dealerMaxScore >= 18) or  @get('dealerHand').realScore() >= @get('playerHand').realScore()
      @set('gameOver', true)
    else
      @get('dealerHand').hit()
      @computerPlay()

  deal: ->
    console.log('deal')
    if(@get('deck').models.length < 10)
      @set('deck', deck = new Deck())
    @set('playerHand', @get('deck').dealPlayer())
    @set('dealerHand', @get('deck').dealDealer())
    @set('gameOver', false)
    @set('dealerTurn', false)


