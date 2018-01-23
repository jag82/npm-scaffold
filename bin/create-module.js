NAME=$1
NAME_CAPITALIZED=$(echo $NAME | sed 's/.*/\u&/')

if [[ -z $NAME ]]
then
  echo "Please enter a lower case name (e.g. npm-scaffold randy)"
  exit 1
fi

echo "creating module $NAME, with default constructor $NAME_CAPITALIZED"

#clean
#rm -rf $NAME

#create npm module
mkdir $NAME
cd $NAME

echo '
{
  "name": "@jag82/'"$NAME"'",
  "version": "1.0.0",
  "description": "",
  "main": "'"$NAME"'.js",
  "scripts": {
    "test": "tape tests/**/*.tests.js | tap-notify | faucet || true",
    "test-watch": "chokidar-cmd -t **/*.js -t *.js -c \"npm run test\""
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/jag82/'"$NAME"'.git"
  },
  "keywords": [
  ],
  "author": "Jag Chadha",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/jag82/'"$NAME"'/issues"
  },
  "homepage": "https://github.com/jag82/'"$NAME"'#readme"
}
' > package.json

#add dependencies
npm i --save-dev tape tape-catch tap-notify faucet chokidar-cmd

#entrypoint
echo "
function $NAME_CAPITALIZED() {
    console.log('constructor: $NAME_CAPITALIZED');
}

$NAME_CAPITALIZED.prototype.bark = function() {
    console.log('bark!');
    return 'bark';
}

module.exports = $NAME_CAPITALIZED
" > $NAME.js

#add tests
mkdir tests
cd tests

echo "
const test = require('tape-catch');
const assert = require('assert');

const $NAME_CAPITALIZED = require('./../$NAME.js');

test('positive control', function(t){
    t.equal(1, 1);
    t.deepEqual({ a: { b: 2 } }, { a: { b: 2 } });
    t.end();    
});

test.skip('negative control', function(t) {
    t.equal(0, 1);
    t.end();
});

test('can be instantiated', function(t){
    const $NAME = new $NAME_CAPITALIZED();

    t.equal($NAME.bark(), 'bark');

    t.end();
});
" > $NAME.tests.js

#run tests
npm run test
