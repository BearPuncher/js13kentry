# A Square actor
class SquareActor extends Actor
  constructor: (x, y, direction = 0, @width = 0, @height = 0) ->
    super(x, y, direction)

  setDimensions: (@width, @height) =>

  drawDebug: () ->
    unless @stage? or @stage.getContext()?
      console.log('Stage context cannot is null, or there is no context set')
      return
    context = @stage.getContext()
    context.translate(@position.getX(), @position.getY())
    context.rotate(@direction)

    # Translate out and draw with position at center
    context.translate(-@width / 2 , -@height / 2)
    context.fillStyle = "#FF0000"
    context.fillRect(0, 0 , @width, @height)
    context.translate(@width / 2 , @height / 2)

    # Draw direction
    context.beginPath()
    context.moveTo(0, 0)
    context.lineTo(@width / 2, 0)
    context.lineWidth = 1
    context.strokeStyle = "#000000"
    context.stroke()
    context.closePath()

    context.rotate(-@direction)
    context.translate(-@position.getX(), -@position.getY())