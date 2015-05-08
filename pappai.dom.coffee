# Paper & Paint
# Depends on dom.coffee
class CNode
    constructor: ->    
        @PAPER = $.get("#pappai")
        @PAINT = @PAPER.getContext("2d")
        @x = 0
        @y = 0
        @xx = 0
        @yy = 0
        @fcolor = "#000"
        @bcolor = "#fff"
        @scolor = "#000"
    give: (k, v) ->
        @[k] = v
        @
    flag: (opts) ->
        @[k] = v for k, v of opts
        @
    get: (k) -> @[k]
    mid: (x, y) -> [x, y]
    set: (x, y) ->
        @x = x
        @y = y
        xy = @mid(x, y)
        @xx = xy[0]
        @yy = xy[1]
        @
    fg: (color) ->
        @fcolor = color || @fcolor
        @
    bg: (color) ->
        @bcolor = color || @bcolor
        @
    sg: (color) ->
        @scolor = color || @scolor
        @
    line: (xa, ya, xb, yb) ->
        @PAINT.beginPath()
        @PAINT.moveTo(xa, ya)
        @PAINT.lineTo(xb, yb)
        @PAINT.closePath()
        @PAINT.lineWidth = @size ? 1
        @PAINT.strokeStyle = @scolor
        @PAINT.stroke()
    link: (node) ->
        @line(@xx, @yy, node.xx, node.yy) if node instanceof CNode
        @

class CCircle extends CNode
    constructor: (Pappai, radius) ->
        @give("radius", radius)
        @give("pi", Math.PI)
        @give("tau", 2 * Math.PI)
        super
    mid: (x, y) -> [x, y]
    render: ->
        @PAPER.style.backgroundColor = @bcolor
        @PAINT.fillStyle = @fcolor
        @PAINT.strokeStyle = @scolor
        @PAINT.lineWidth = @size ? 1
        @PAINT.beginPath()
        @PAINT.arc(@x, @y, @radius, 0, @tau)
        @PAINT.closePath()
        @PAINT.fill() unless @noFill
        @PAINT.stroke() if @doStroke
        @
        
class CBox extends CNode
    constructor: (Pappai, width, height) ->
        @give("width", width)
        @give("height", height)
        super
    mid: (x, y) ->
        [
            x + (@width/2),
            y + (@height/2)
        ]
    render: ->
        @PAPER.style.backgroundColor = @bcolor
        @PAINT.fillStyle = @fcolor
        @PAINT.strokeStyle = @scolor
        @PAINT.lineWidth = @size ? 1
        @PAINT.beginPath()
        @PAINT.rect(@x, @y, @width, @height)
        @PAINT.closePath()
        @PAINT.fill() unless @noFill
        @PAINT.stroke() if @doStroke
        @
        
class CSquare extends CNode
    constructor: (Pappai, side) ->
        @give("side", side)
        super
    mid: (x, y) ->
        [
            x + (@side/2),
            y + (@side/2)
        ]
    render: ->
        @PAPER.style.backgroundColor = @bcolor
        @PAINT.fillStyle = @fcolor
        @PAINT.strokeStyle = @scolor
        @PAINT.lineWidth = @size ? 1
        @PAINT.beginPath()
        @PAINT.fillRect(@x, @y, @side, @side)
        @PAINT.closePath()
        @PAINT.fill() unless @noFill
        @PAINT.stroke() if @doStroke
        @


Pappai =
    Init: (width, height, theater) ->
        canvas = $.create("canvas", "pappai").into(document.body)
        if theater
            $.find("html").css({
                "margin": 0
                "padding": 0
            })
            $.find("body").css({
                "margin": 0
                "padding": 0
            })
            canvas.attr.set("width",  window.innerWidth)
            canvas.attr.set("height", window.innerHeight)
        else
            canvas.attr.set("width",  width)
            canvas.attr.set("height", height)
            xm = (window.innerHeight - height) / 2
            ym = (window.innerWidth - width) / 2
            canvas.style.margin = "#{xm}px #{ym}px"
    Node: -> new CNode()
    Circle: (radius) -> new CCircle(@, radius)
    Box: (width, height) -> new CBox(@, width, height)
    Square: (side) -> new CSquare(@, side)
        
window.Pappai = Pappai
