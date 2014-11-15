class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    @trigger('done') if @minScore() > 21

  stand: ->
    @trigger('stand')

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  computerPlay: ->
    if not @models[0].get 'revealed'
      @models[0].flip()

    [minScore, maxScore] = @scores()

    if (minScore >= 17) or (21 >= maxScore >= 18)
      @trigger('done')
    else
      @hit()
      @computerPlay()
