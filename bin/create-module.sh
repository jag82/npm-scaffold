#!/usr/bin/env bash

NAME=$1
NAME_CAPITALIZED=$(echo $NAME | sed 's/.*/\u&/')

NPM_USERNAME='jag82'
GITHUB_USERNAME='jag82'
FULL_NAME='Jag Chadha'

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
  "name": "@'"$NPM_USERNAME"'/'"$NAME"'",
  "version": "1.0.0",
  "description": "",
  "main": "'"$NAME"'.js",
  "scripts": {
    "test": "nyc tape tests/**/*.tests.js | tap-notify | tap-nyc || true",
    "test-watch": "chokidar-cmd -t **/*.js -t *.js -c \"npm run test\""
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/'"$GITHUB_USERNAME"'/'"$NAME"'.git"
  },
  "keywords": [
  ],
  "author": "'"$FULL_NAME"'",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/'"$GITHUB_USERNAME"'/'"$NAME"'/issues"
  },
  "homepage": "https://github.com/'"$GITHUB_USERNAME"'/'"$NAME"'#readme"
}
' > package.json

#add dependencies
npm i --save-dev tape tape-catch tap-notify tap-nyc chokidar-cmd

#README
echo '
# '"$NAME"'

description

## Installation
```
npm i --save @'"$NPM_USERNAME"'/'"$NAME"'
```

## Usage
```

```


' > README.md

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

cd ..

#run tests
npm run test

#git
echo "
node_modules/
npm-debug.log
" > .gitignore

git init
git remote add origin "https://'"$GITHUB_USERNAME"'@github.com/'"$GITHUB_USERNAME"'/$NAME"
git remote -v
git status
