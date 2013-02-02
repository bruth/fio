((root, factory) ->
    if typeof define is 'function' and define.amd
        # AMD
        define ['jquery'], (jQuery) ->
            root.InputIO = factory(jQuery)
    else
        # Browser globals
        root.InputIO= factory(root.jQuery)
) @, (jQuery) ->

    # Simple test to check if date.js is installed
    dateJSInstalled = Date.CultureInfo?

    getType = ($el) -> $el.attr('type') or $el.data('type')

    get = (selector) ->
        multi = false

        # Remove disabled fields from the set
        $el = $(selector).not(':disabled')

        # Set multi if dealing with a checkbox group before
        # filtering out the unchecked boxes
        if $el.is('input[type=checkbox]') and $el.length > 1
            multi = true

        # For check-based inputs, only include the checked values
        if $el.is('input[type=radio],input[type=checkbox]')
            $el = $el.filter(':checked')

        # Multi-selects are handled by jQuery
        if $el.is 'select[multiple]'
            multi = true
            value = coerce($el.val(), getType($el))
        # Get values with multiple elements in the set. It is assumed
        # the selector is targeted to a group of elements representing
        # one or more values such as range query.
        else if multi or $el.length > 1
            multi = true

            value = []
            for e in $el
                $e = $(e)
                value.push(coerce($e.val(), getType($e)))
        else
            value = coerce($el.val(), getType($el))

        # Handle empty values
        if not value? or value is ''
            value = if multi then [] else null
        return value


    set = (selector, value) ->
        multi = false

        $el = $(selector)

        # Checkboxes and radios must all be passed an array otherwise the
        # value attribute will be overwritten. Multi-selects don't actually
        # need an array since an array is checked for internally. This is
        # merely for explicitness.
        if $el.is('select[multiple],input[type=radio],input[type=checkbox]')
            multi = true

        # Inputs that are no inherently 'multi' need to be set per element
        # in the set
        if not multi and $el.length > 1
            if not $.isArray value
                value = [value]
            for x, i in value
                $($el[i]).val x
            return

        if multi and not $.isArray value
            value = [value]
        else if not multi and $.isArray value
            value = value[0]
        $el.val value
        return

    coerceDate = (v) ->
        if not dateJSInstalled
            throw new Error('date.js must be installed to properly dates')
        Date.parse v

    coercers =
        boolean: (v) -> Boolean v
        number: (v) -> parseFloat v
        string: (v) -> v.toString()
        date: coerceDate
        datetime: coerceDate
        time: coerceDate

    # Attempts to coerce some 'raw' value into the specified type
    # otherwise undefined is return.
    coerce = (value, type) ->
        if not value? or value is '' then return null

        if $.isArray value
            cleaned = []
            for x in value
                if (x = coerce x, type) then cleaned.push x
            if cleaned.length then cleaned else null
        else
            if coercers[type]? then coercers[type](value) else value

    checkers =
        boolean: (v) -> $.type(v) is 'boolean'
        number: (v) -> $.type(v) is 'number'
        string: (v) -> $.type(v) is 'string'
        date: (v) -> $.type(v) is 'date'
        datetime: (v) -> $.type(v) is 'date'
        time: (v) -> $.type(v) is 'date'

    # Validates the value is of the specified type
    check = (value, type) ->
        if checkers[type]? then checkers[type](value) else true

    { get , set, coerce, coercers, check, checkers }
