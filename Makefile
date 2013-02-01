all:
	coffee -b -o build/ -c src/
	coffee -b -o test/ -c src/ test/
	node r.js -o build.js
