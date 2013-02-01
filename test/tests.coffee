define [
    'inputio'
], (inputio) ->

    QUnit.start()

    coerceValue = inputio.coerceValue
    validateValue = inputio.validateValue
    getInputValue = inputio.getInputValue
    setInputValue = inputio.setInputValue

    test 'coerce values', ->

        types = ['number', 'string', 'boolean', 'date',
            'datetime', 'time']

        for type in types
            equal coerceValue(null, type), null
            equal coerceValue(undefined, type), null
            equal coerceValue('', type), null

        equal coerceValue('8', 'number'), 8
        equal coerceValue('8.0', 'number'), 8.0
        deepEqual coerceValue(['1', '2'], 'number'), [1, 2]
        deepEqual coerceValue(NaN, 'number'), NaN
        deepEqual coerceValue('foo', 'number'), NaN
        deepEqual coerceValue(true, 'number'), NaN
        deepEqual coerceValue(false, 'number'), NaN

        equal coerceValue(8, 'string'), '8'
        equal coerceValue(8.0, 'string'), '8'      # WTF?!
        equal coerceValue(8.1, 'string'), '8.1'
        equal coerceValue(true, 'string'), 'true'
        equal coerceValue(false, 'string'), 'false'

        equal coerceValue('true', 'boolean'), true
        equal coerceValue('foo', 'boolean'), true

        # Months are 0-based, thus the 9 here.. it actually means October
        deepEqual coerceValue('Oct 12, 2013', 'date'), new Date(2013, 9, 12)
        deepEqual coerceValue('...', 'date'), null
        deepEqual coerceValue('foobar', 'date'), null
        deepEqual coerceValue('2012-10-14 3:40 pm', 'time'), new Date(2012, 9, 14, 15, 40, 0)


    test 'validate value', ->
        equal validateValue(null, 'number'), false
        equal validateValue(null, 'string'), false
        equal validateValue(null, 'date'), false
        equal validateValue(null, 'time'), false
        equal validateValue(null, 'datetime'), false


    test 'set/get values - multi', ->

        setMulti = [
            ['bar']
            ['foo']
            ['bar', 'baz']
            'baz'
            []
            null
            ''
            'unknown'
            ['unknown']
            ['bar', 'baz']
        ]
        getMulti = [
            ['bar']
            ['foo']
            ['bar', 'baz']
            ['baz']
            []
            []
            []
            []
            []
            ['bar', 'baz']
        ]

        # checkbox group
        for i in [0..setMulti.length-1]
            setInputValue $('[name=cbox1]'), setMulti[i]
            deepEqual getInputValue($('[name=cbox1]')), getMulti[i]

        # multi-select
        for i in [0..setMulti.length-1]
            setInputValue $('[name=select-multi]'), setMulti[i]
            deepEqual getInputValue($('[name=select-multi]')), getMulti[i]


    test 'set/get values - single', ->
        setSingle = [
            'bar'
            'foo'
            ['baz']
            []
            null
            ''
            'unknown'
            ['unknown']
            'foo'
        ]
        getSingle = [
            'bar'
            'foo'
            'baz'
            null
            null
            null
            null
            null
            'foo'
        ]

        # radio
        for i in [0..setSingle.length-1]
            setInputValue $('[name=rad1]'), setSingle[i]
            deepEqual getInputValue($('[name=rad1]')), getSingle[i]

        # single select
        for i in [0..setSingle.length-1]
            setInputValue $('[name=select]'), setSingle[i]
            deepEqual getInputValue($('[name=select]')), getSingle[i]


    test 'set/get single checkbox', ->
        setInputValue $('[name=cbox2]'), 'foo'
        deepEqual getInputValue($('[name=cbox2]')), 'foo'

        setInputValue $('[name=cbox2]'), ''
        deepEqual getInputValue($('[name=cbox2]')), null

        setInputValue $('[name=cbox2]'), 'unknown'
        deepEqual getInputValue($('[name=cbox2]')), null

        setInputValue $('[name=cbox2]'), ['foo']
        deepEqual getInputValue($('[name=cbox2]')), 'foo'

    test 'set/get multi text', ->
        deepEqual getInputValue($('[name=range1]')), ['1', '2']

        setInputValue $('[name=range1]'), [3, 5]
        deepEqual getInputValue($('[name=range1]')), ['3', '5']

        setInputValue $('[name=range1]'), 4
        deepEqual getInputValue($('[name=range1]')), ['4', '5']

        setInputValue $('[name=range1]'), [9, 8, 7]
        deepEqual getInputValue($('[name=range1]')), ['9', '8']

        deepEqual getInputValue($('[name=range2]')), '1'
        setInputValue $('[name=range2]'), [5, 6]
        deepEqual getInputValue($('[name=range2]')), '5'
