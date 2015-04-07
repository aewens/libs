# Maybe
M = (xs...) ->
    if M.nothing(xs)
        return M.None()
    else
        if xs instanceof M 
            return xs
        else 
            return M.Some(xs)
M.nothing = (x) ->
    switch "#{x}"
        when null then return true
        when undefined then return true
        when "false" then return true
        when "" then return true
        else return false
        
M.error = "I'm sorry Dave, I'm afraid I can't do that"
M.Some = (x) -> new M.fn.init(true, x)
M.None =     -> new M.fn.init(false, null)
M.fn = M.prototype =
    init: (usable, x) ->
        throw @error if x == null and usable
        if usable
            if x.length > 1
                @list = true
                @x = x.map (y) -> new M(y)
                @value = @x
                @usable = @all()
            else if x[0] != undefined and x[0].length >= 1
                @list = true
                @x = x[0].map (y) -> new M(y)
                @value = @x
                @usable = @all()
            else
                @usable = usable
                @list = false
                @x = x[0]
                @value = @x
        else
            @usable = usable
            @list = false
            @x = x
            @value = @x
        @
    maybe: (x) -> new M(x)
    of: (x) -> new M(x)
    orSome: (x) -> 
        if @list then (if @all() then @x else x)
        else if @usable then @x else x
    orElse: (x) -> 
        if @list then (if @any() then @ else new M(x))
        else if @usable then @  else new M(x)
    elsewise: (x) -> 
        xs = if @list then @x else new M([@x]).x
        if @any() then new M(xs).bind((x) -> x) else x
    otherwise: (x) -> @orSome(x)
    elser: (x) -> @orElse(x)
    diverge: (x) -> @elsewise(x)
    choose: (x, y) -> if @x then x else y
    swap: (x, y) -> @x = if @x then x else y
    bind: (fn) ->
        if @list then @x.map (x) -> x.bind(fn)
        else if @usable then fn(@x) else @
    lift: (fn) -> 
        if @list then @bind(fn).map (x) -> new M(x) 
        else new M(@bind(fn))
    bond: (fn) ->
        self = this
        (y) -> 
            if self.list then self.x.map (x) -> self.bond(f)(y)
            else if self.usable then fn(self.x, y) else self
    hoist: (fn) ->
        self = this
        (y) -> 
            if @list then @bond(fn)(y).map (x) -> new M(x)
            else new M(@bond(fn)(y))
    merge: (fn) ->
        self = this
        (y) -> 
            if @list then @bond(fn)(y.x).map (x) -> new M(x)
            else new M(@bond(fn)(y.x))
    some: -> 
        if @usable 
            if @list then @x.filter((x) -> x.isSome).map (x) -> x.x
            else @x
        else throw M.error
    isSome: -> @usable
    isNone: -> !@isSome()
    toString: -> if @usable then "Some(#{@x})" else "None"
    to_s: -> @toString()
    show: -> @some()
    all: ->
        xs = if @list then @x else new M([@x]).x
        l0 = xs.length
        l1 = xs.filter((x) -> x.isSome()).length
        l0 == l1
    any: ->
        xs = if @list then @x else new M([@x]).x
        xs.filter((x) -> x.isSome()).length > 0
    unwrap: -> if @list then @x.map (x) -> x.x else @x
    open: -> @unwrap()
    pick  : (f, g) -> if @all() then new M(@x).bind(f) else new M(@x).bind(g)
    select: (f, g) -> if @any() then new M(@x).bind(f) else new M(@x).bind(g)
    choose: (x, y) -> if @all() then x else y
    decide: (x, y) -> if @any() then x else y
M.fn.init.prototype = M.fn

window._M = M
