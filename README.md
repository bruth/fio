# fio

"fio" (form IO) is a utility for getting/setting data in input and select form fields by following a set of semantics.

It follows these semantics:

- Disabled fields are ignored when getting values, but values will be set if one is available
- Only checkboxes and radio buttons that are _checked_ are returned
- Selectors pointing to multiple inputs will be treated as a multi-value fields and will return an array on get (as well as expect an array when set). This of course excludes radio buttons due to the constraint mentioned above.
- Checkbox and radio buttons are set via their value
- Values are coerced based on the `data-type` attribute if one is present and falls back to the `type` attribute
- Empty values are coerced to `null`

### Requirements

- [jQuery](http://jquery.com)
- [Datejs](http://www.datejs.com/) (only if you are doing date parsing)

### Download

- [Uncompressed](https://raw.github.com/bruth/fio/master/build/fio.js)
- [Compressed](https://raw.github.com/bruth/fio/master/dist/fio.js)

### Install

#### AMD

```html
<script src="require.js"></script>
<script>require(['fio'], function(fio) { ... })</script>
```

#### Traditional

```html
<script src="jquery.js"></script>
<script src="fio.js"></script>
```

### API

#### fio.get(selector)

Gets the input value given the selector.

#### fio.set(selector, value)

Sets the input value for the selector.

#### fio.coerce(value, type)

Coerces some value for the given type. This is generally performed after
`getInputValue` is used.

#### fio.check(value, type)

Validates a value is of the given type. Returns a boolean denoting the result.

### Examples

#### Checkboxes:

```html
<input type=checkbox name=cbox1 value=foo checked>
<input type=checkbox name=cbox1 value=bar>
<input type=checkbox name=cbox1 value=baz checked>
```

```javascript
fio.get('[name=cbox1]'); // ['foo', 'baz']
```

#### Multiple Inputs

```html
<input name=range1 value=1>
<input name=range1 value=2>
```

```javascript
fio.get('[name=range1]'); // [1, 2]
```

#### Disable Input

```html
<input name=range2 value=1>
<input name=range2 value=2 disabled>
```

```javascript
fio.get('[name=range2]'); // 1
```
