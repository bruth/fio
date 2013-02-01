((root, factory) ->
    if typeof define is 'function' and define.amd
        # AMD
        define ['jquery'], (jQuery) ->
            factory(jQuery)
    else
        # Browser globals
        root.inputio = factory(root.jQuery)
) @, (jQuery) ->

    # Simple test to check if date.js is installed
    dateJSInstalled = Boolean(Date.CultureInfo)

    getInputValue = (selector) ->
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
            value = $el.val()
        # Get values with multiple elements in the set. It is assumed
        # the selector is targeted to a group of elements representing
        # one or more values such as range query.
        else if multi or $el.length > 1
            multi = true
            value = ($(e).val() for e in $el)
        else
            value = $el.val()

        # Handle empty values
        if not value? or value is ''
            value = if multi then [] else null
        return value


    setInputValue = (selector, value) ->
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


    # Attempts to coerce some 'raw' value into the specified type
    # otherwise undefined is return.
    coerceValue = (value, type) ->
        if not value? or value is '' then return null
        if $.isArray value
            cleaned = []
            for x in value
                if (x = coerceValue x, type) then cleaned.push x
            if cleaned.length then cleaned else null
        else
            switch type
                when 'boolean' then Boolean value
                when 'number' then parseFloat value
                when 'string' then value.toString()
                when 'date', 'datetime', 'time'
                    if not dateJSInstalled
                        throw new Error('date.js must be installed to properly dates')
                    Date.parse value


    # Validates the value is of the specified type
    validateValue = (value, type) ->
        switch type
            when 'boolean', 'number', 'string'
                $.type(value) is type
            when 'date', 'datetime', 'time'
                $.type(value) is 'date'
            else false


    { getInputValue, setInputValue, coerceValue, validateValue }
