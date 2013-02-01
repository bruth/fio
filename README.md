# inputio.js

Set of utilities function for getting/setting data in HTML input and select
form fields more consistent with proper type coercion and validation.

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
<script>require(['inputio'], function() { ... })</script>
```

#### Traditional

```html
<script src="jquery.js"></script>
<script src="inputio.js"></script>
```

### Functions


`getInputValue(selector)` - Gets the input value given the selector.

`setInputValue(selector, value)` - Sets the input value for the selector.

`coerceValue(value, type)` - Coerces some value for the given type. This is
generally performed after `getInputValue` is used.

`validateValue(value, type)` - Validates a value is of the given type. Returns
a boolean denoting the result.
