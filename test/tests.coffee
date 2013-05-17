define ['fio'], (fio) ->

    QUnit.start()

    coerce = fio.coerce
    check = fio.check
    get = fio.get
    set = fio.set

    test 'coerce values', ->

        types = ['number', 'string', 'boolean', 'date',
            'datetime', 'time']

        for type in types
            equal coerce(null, type), null
            equal coerce(undefined, type), null
            if type is 'boolean'
                equal coerce('', type), false
            else
                equal coerce('', type), null

        equal coerce('8', 'number'), 8
        equal coerce('8.0', 'number'), 8.0
        deepEqual coerce(['1', '2'], 'number'), [1, 2]
        deepEqual coerce(NaN, 'number'), null
        deepEqual coerce('foo', 'number'), null
        deepEqual coerce(true, 'number'), null
        deepEqual coerce(false, 'number'), null

        equal coerce(8, 'string'), '8'
        equal coerce(8.0, 'string'), '8'      # WTF?!
        equal coerce(8.1, 'string'), '8.1'
        equal coerce(true, 'string'), 'true'
        equal coerce(false, 'string'), 'false'

        equal coerce('true', 'boolean'), true
        equal coerce('foo', 'boolean'), true

        # Months are 0-based, thus the 9 here.. it actually means October
        deepEqual coerce('Oct 12, 2013', 'date'), new Date(2013, 9, 12)
        deepEqual coerce('...', 'date'), null
        deepEqual coerce('foobar', 'date'), null
        deepEqual coerce('2012-10-14 3:40 pm', 'time'), new Date(2012, 9, 14, 15, 40, 0)

    test 'type attrs', ->
        equal get('[name=type1]'), 3.3
        equal get('[name=type2]'), true
        equal get('[name=type3]'), false
        deepEqual get('[name=type4]'), new Date(2013, 2, 2)

    test 'validate value', ->
        equal check(null, 'number'), false
        equal check(null, 'string'), false
        equal check(null, 'date'), false
        equal check(null, 'time'), false
        equal check(null, 'datetime'), false


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
            set $('[name=cbox1]'), setMulti[i]
            deepEqual get($('[name=cbox1]')), getMulti[i]

        # multi-select
        for i in [0..setMulti.length-1]
            set $('[name=select-multi]'), setMulti[i]
            deepEqual get($('[name=select-multi]')), getMulti[i]


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
            set $('[name=rad1]'), setSingle[i]
            deepEqual get($('[name=rad1]')), getSingle[i]

        # single select
        for i in [0..setSingle.length-1]
            set $('[name=select]'), setSingle[i]
            deepEqual get($('[name=select]')), getSingle[i]


    test 'set/get single checkbox', ->
        set $('[name=cbox2]'), 'foo'
        deepEqual get($('[name=cbox2]')), 'foo'

        set $('[name=cbox2]'), ''
        deepEqual get($('[name=cbox2]')), null

        set $('[name=cbox2]'), 'unknown'
        deepEqual get($('[name=cbox2]')), null

        set $('[name=cbox2]'), ['foo']
        deepEqual get($('[name=cbox2]')), 'foo'

    test 'set/get multi text', ->
        deepEqual get($('[name=range1]')), ['1', '2']

        set $('[name=range1]'), [3, 5]
        deepEqual get($('[name=range1]')), ['3', '5']

        set $('[name=range1]'), 4
        deepEqual get($('[name=range1]')), ['4', '5']

        set $('[name=range1]'), [9, 8, 7]
        deepEqual get($('[name=range1]')), ['9', '8']

        deepEqual get($('[name=range2]')), '1'
        set $('[name=range2]'), [5, 6]
        deepEqual get($('[name=range2]')), '5'
