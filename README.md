# InputIO

InputIO is a set of utilities for getting/setting data in HTML input and select
form fields more consistently type coercion and validation.

It follows these conventions:

- Disabled fields are ignored when getting values, but will be set if a value exists for it
- Only checkboxes and radio buttons that _checked_ are returned
- Selectors pointing to inputs will be treated as a multi-value fields and will return an array on get (as well as expect an array when set). This of course excludes radio buttons due to the constraint mentioned above.
- Checkbox and radio buttons are set via their value
- Values are coerced based on their `type` attribute if one exists and falls back to an attempted coercion based on the contents of the value
- Empty values are coerced to `null`

### Requirements

- [jQuery](http://jquery.com)
- [Datejs](http://www.datejs.com/) (only if you are doing date parsing)

### Download

- [Uncompressed](https://raw.github.com/bruth/inputio.js/master/build/inputio.js)
- [Compressed](https://raw.github.com/bruth/inputio.js/master/dist/inputio.js)

### Install

#### AMD

```html
<script src="require.js"></script>
<script>require(['inputio'], function(InputIO) { ... })</script>
```

#### Traditional

```html
<script src="jquery.js"></script>
<script src="inputio.js"></script>
```

### API

#### InputIO.get(selector)

Gets the input value given the selector.

#### InputIO.set(selector, value)

Sets the input value for the selector.

#### InputIO.coerce(value, type)

Coerces some value for the given type. This is generally performed after
`getInputValue` is used.

#### InputIO.check(value, type)

Validates a value is of the given type. Returns a boolean denoting the result.

### Examples

#### Checkboxes:

```html
<input type=checkbox name=cbox1 value=foo checked>
<input type=checkbox name=cbox1 value=bar>
<input type=checkbox name=cbox1 value=baz checked>
```

```javascript
InputIO.get('[name=cbox1]'); // ['foo', 'baz']
```

#### Multiple Inputs

```html
<input name=range1 value=1>
<input name=range1 value=2>
```

```javascript
InputIO.get('[name=range1]'); // [1, 2]
```

#### Disable Input

```html
<input name=range2 value=1>
<input name=range2 value=2 disabled>
```

```javascript
InputIO.get('[name=range2]'); // 1
```
