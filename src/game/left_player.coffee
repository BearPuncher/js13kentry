class LeftPlayer extends Player
  constructor: (x, y) ->
    super(x, y)

  _render: () ->
    @drawDebug()

  _update: (step) =>
    x = @position.x
    y = @position.y

    stepFraction = (step / 100)

    friction = 1.5
    acceleration = 2

    # D - FIRE
    if @controller.isPressed(Keys.D)
      @shoot(step)

    # W - UP
    if @controller.isPressed(Keys.W)
      if @vely > -@maxSpeed
        @vely -= acceleration * stepFraction
        @vely = -@maxSpeed if @vely < -@maxSpeed
    else if @vely < 0
      @vely += friction * stepFraction
      @vely = 0 if @vely > 0

    # S - DOWN
    if @controller.isPressed(Keys.S)
      if @vely < @maxSpeed
        @vely += acceleration * stepFraction
        @vely = @maxSpeed if @vely > @maxSpeed
    else if @vely > 0
      @vely -= friction * stepFraction
      @vely = 0 if @vely < 0

    newPosition = new Circle(new Vector(x, y + @vely), @radius)
    if @stage.isCircleInBounds(newPosition)
      @setPosition(x, y + @vely)

    @updateBody()