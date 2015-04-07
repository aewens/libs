$ =
    create: (selector, id) ->
        elem = document.createElement(selector)
        elem.id = id unless id is undefined
        $.load(elem)
    query: (selector) ->
        document.querySelectorAll(selector)[0]
    get: (selector) ->
        element = $.query(selector)
        if element is undefined
            return null
        else
            element
    mult: (element) -> element.length is 1
    many: (element) ->
        if $.mult(element) then element[0] else element
    find: (selector) ->
        element = $.query(selector)
        return null if element is undefined
        $.load($.many(element))
    wrap: (term) ->
        if term instanceof HTMLElement
            $.load(term)
        else
            $.find(term)
    unwrap: (obj) -> obj.ret
    load: (element) ->
        obj =
            ret: element
            add: (dom) ->
                element.appendChild dom.element
                $.load(element)
            into: (elem) ->
                elem.appendChild element
                $.load(element)
            css: ->
                switch arguments.length
                    when 1
                        arg = arguments[0]
                        if typeof(arg) is "object"
                            for k, v of arg
                                element.style[k] = v
                            return $.load(element)
                        else if typeof(arg) is "string"
                            return element.style[arg]
                        else
                            return $.load(element)
                    when 2
                        k = arguments[0]
                        v = arguments[1]
                        element.style[k] = v
                        return $.load(element)
                    else
                        return $.load(element)
            on: (event, fn) ->
                element.addEventListener(event, fn)
                $.load(element)
            val: ->
                switch arguments.length
                    when 0
                        return element.value
                    when 1
                        return element.value = arguments[0]
                    else 
                        return $.load(element)
            html: ->
                switch arguments.length
                    when 0
                        return element.innerHTML
                    when 1
                        return element.innerHTML = arguments[0]
                    else
                        return $.load(element)
            attr:
                get: (a) ->
                    element.getAttribute(a)
                set: (k, v) ->
                    element.setAttribute(k, v)
                    $.load(element)
                has: (a) ->
                    element.hasAttribute(a)
            group:
                add: (klass) ->
                    element.classList.add(klass)
                    $.load(element)
                remove: (klass) ->
                    element.classList.remove(klass)
                    $.load(element)
                has: (klass) ->
                    element.classList.contains(klass)
                    $.load(element)
                toggle: (klass) ->
                    element.classList.toggle(klass)
                    $.load(element)
        obj
        
window._dom = $
