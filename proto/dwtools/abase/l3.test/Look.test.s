( function _Looker_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../l3/Looker.s' );

  _.include( 'wTesting' );
  _.include( 'wStringer' );

}

var _global = _global_;
var _ = _global_.wTools;

/*
cls && node builder\include\dwtools\abase\l3.test\Looker.test.s && node builder\include\dwtools\abase\l4.test\LookerExtra.test.s && node builder\include\dwtools\abase\l4.test\Replicator.test.s && node builder\include\dwtools\abase\l5.test\Selector.test.s && node builder\include\dwtools\abase\l6.test\SelectorExtra.test.s && node builder\include\dwtools\abase\l6.test\LookerComparator.test.s
*/

// --
// tests
// --

function look( test )
{

  var structure1 =
  {
    a : 1,
    b : 's',
    c : [ 1,3 ],
    d : [ 1,{ date : new Date() } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1,2,3 ]),
  }

  var expectedUpPaths = [ '/', '/a', '/b', '/c', '/c/0', '/c/1', '/d', '/d/0', '/d/1', '/d/1/date', '/e', '/f', '/g' ];
  var expectedDownPaths = [ '/a', '/b', '/c/0', '/c/1', '/c', '/d/0', '/d/1/date', '/d/1', '/d', '/e', '/f', '/g', '/' ];
  var expectedUpIndinces = [ null, 0, 1, 2, 0, 1, 3, 0, 1, 0, 4, 5, 6 ];
  var expectedDownIndices = [ 0, 1, 0, 1, 2, 0, 0, 1, 3, 4, 5, 6, null ];

  var gotUpPaths = [];
  var gotDownPaths = [];
  var gotUpIndinces = [];
  var gotDownIndices = [];

  var it = _.look( structure1, handleUp1, handleDown1 );
  // var it = _.look({ src : structure1, onUp : handleUp1, onDown : handleDown1 });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );
  test.is( _.lookIteratorIs( Object.getPrototypeOf( it ) ) );
  test.is( _.lookerIs( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) ) );
  test.is( Object.getPrototypeOf( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) ) === null );
  test.is( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) === it.Looker );
  test.is( Object.getPrototypeOf( it ) === it.iterator );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );
  test.case = 'indices on up';
  test.identical( gotUpIndinces, expectedUpIndinces );
  test.case = 'indices on down';
  test.identical( gotDownIndices, expectedDownIndices );

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
    gotUpIndinces.push( it.index );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownIndices.push( it.index );
  }

}

//

function lookRecursive( test )
{

  var structure1 =
  {
    a1 :
    {
      b1 :
      {
        c1 : 'abc',
        c2 : 'c2',
      },
      b2 : 'b2',
    },
    a2 : 'a2',
  }

  /* */

  test.open( 'recursive : 0' );

  var expectedUpPaths = [ '/' ];
  var expectedDownPaths = [ '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 0,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 0' );

  /* */

  test.open( 'recursive : 1' );

  var expectedUpPaths = [ '/', '/a1', '/a2' ];
  var expectedDownPaths = [ '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 1,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 1' );

  /* */

  test.open( 'recursive : 2' );

  var expectedUpPaths = [ '/', '/a1', '/a1/b1', '/a1/b2', '/a2' ];
  var expectedDownPaths = [ '/a1/b1', '/a1/b2', '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 2,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 2' );

  /* */

  test.open( 'recursive : Infinity' );

  var expectedUpPaths = [ '/', '/a1', '/a1/b1', '/a1/b1/c1', '/a1/b1/c2', '/a1/b2', '/a2' ];
  var expectedDownPaths = [ '/a1/b1/c1', '/a1/b1/c2', '/a1/b1', '/a1/b2', '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : Infinity,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : Infinity' );

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
  }

}

//

function testPaths( test )
{

  let upc = 0;
  function onUp()
  {
    let it = this;
    let expectedPaths = [ '/', '/a', '/d', '/d/b', '/d/c' ];
    test.identical( it.path, expectedPaths[ upc ] );
    upc += 1;
  }
  let downc = 0;
  function onDown()
  {
    let it = this;
    let expectedPaths = [ '/a', '/d/b', '/d/c', '/d', '/' ];
    test.identical( it.path, expectedPaths[ downc ] );
    downc += 1;
  }

  /* */

  var src =
  {
    a : 11,
    d :
    {
      b : 13,
      c : 15,
    }
  }
  var got = _.look
  ({
    src : src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  test.identical( got, got );
  test.identical( upc, 5 );
  test.identical( downc, 5 );

  /* */

}

//

function callbacksComplex( test )
{
  let ups = [];
  let dws = [];

  /* - */

  let expUps =
  [
    '/',
    '/null',
    '/undefined',
    '/boolean.true',
    '/boolean.false',
    '/string.defined',
    '/string.empty',
    '/number.zero',
    '/number.small',
    '/number.big',
    '/number.infinity.positive',
    '/number.infinity.negative',
    '/number.nan',
    '/number.signed.zero.negative',
    '/number.signed.zero.positive',
    '/bigInt.zero',
    '/bigInt.small',
    '/bigInt.big',
    '/regexp.simple1',
    '/regexp.simple2',
    '/regexp.simple3',
    '/regexp.simple4',
    '/regexp.simple5',
    '/regexp.complex0',
    '/regexp.complex1',
    '/regexp.complex2',
    '/regexp.complex3',
    '/regexp.complex4',
    '/regexp.complex5',
    '/regexp.complex6',
    '/regexp.complex7',
    '/date.now',
    '/date.fixed',
    '/buffer.node',
    '/buffer.raw',
    '/buffer.bytes',
    '/array.simple',
    '/array.simple/0',
    '/array.simple/1',
    '/array.complex',
    '/array.complex/0',
    '/array.complex/0/null',
    '/array.complex/0/undefined',
    '/array.complex/0/boolean.true',
    '/array.complex/0/boolean.false',
    '/array.complex/0/string.defined',
    '/array.complex/0/string.empty',
    '/array.complex/0/number.zero',
    '/array.complex/0/number.small',
    '/array.complex/0/number.big',
    '/array.complex/0/number.infinity.positive',
    '/array.complex/0/number.infinity.negative',
    '/array.complex/0/number.nan',
    '/array.complex/0/number.signed.zero.negative',
    '/array.complex/0/number.signed.zero.positive',
    '/array.complex/0/bigInt.zero',
    '/array.complex/0/bigInt.small',
    '/array.complex/0/bigInt.big',
    '/array.complex/0/regexp.simple1',
    '/array.complex/0/regexp.simple2',
    '/array.complex/0/regexp.simple3',
    '/array.complex/0/regexp.simple4',
    '/array.complex/0/regexp.simple5',
    '/array.complex/0/regexp.complex0',
    '/array.complex/0/regexp.complex1',
    '/array.complex/0/regexp.complex2',
    '/array.complex/0/regexp.complex3',
    '/array.complex/0/regexp.complex4',
    '/array.complex/0/regexp.complex5',
    '/array.complex/0/regexp.complex6',
    '/array.complex/0/regexp.complex7',
    '/array.complex/0/date.now',
    '/array.complex/0/date.fixed',
    '/array.complex/0/buffer.node',
    '/array.complex/0/buffer.raw',
    '/array.complex/0/buffer.bytes',
    '/array.complex/0/array.simple',
    '/array.complex/0/array.simple/0',
    '/array.complex/0/array.simple/1',
    '/array.complex/0/array.complex',
    '/array.complex/0/array.complex/0',
    '/array.complex/0/array.complex/1',
    '/array.complex/0/set',
    '/array.complex/0/set/null',
    '/array.complex/0/hashmap',
    '/array.complex/0/hashmap/element0',
    '/array.complex/0/hashmap/element1',
    '/array.complex/0/map',
    '/array.complex/0/map/element0',
    '/array.complex/0/map/element1',
    '/array.complex/0/recursion.self',
    '/array.complex/1',
    '/array.complex/1/null',
    '/array.complex/1/undefined',
    '/array.complex/1/boolean.true',
    '/array.complex/1/boolean.false',
    '/array.complex/1/string.defined',
    '/array.complex/1/string.empty',
    '/array.complex/1/number.zero',
    '/array.complex/1/number.small',
    '/array.complex/1/number.big',
    '/array.complex/1/number.infinity.positive',
    '/array.complex/1/number.infinity.negative',
    '/array.complex/1/number.nan',
    '/array.complex/1/number.signed.zero.negative',
    '/array.complex/1/number.signed.zero.positive',
    '/array.complex/1/bigInt.zero',
    '/array.complex/1/bigInt.small',
    '/array.complex/1/bigInt.big',
    '/array.complex/1/regexp.simple1',
    '/array.complex/1/regexp.simple2',
    '/array.complex/1/regexp.simple3',
    '/array.complex/1/regexp.simple4',
    '/array.complex/1/regexp.simple5',
    '/array.complex/1/regexp.complex0',
    '/array.complex/1/regexp.complex1',
    '/array.complex/1/regexp.complex2',
    '/array.complex/1/regexp.complex3',
    '/array.complex/1/regexp.complex4',
    '/array.complex/1/regexp.complex5',
    '/array.complex/1/regexp.complex6',
    '/array.complex/1/regexp.complex7',
    '/array.complex/1/date.now',
    '/array.complex/1/date.fixed',
    '/array.complex/1/buffer.node',
    '/array.complex/1/buffer.raw',
    '/array.complex/1/buffer.bytes',
    '/array.complex/1/array.simple',
    '/array.complex/1/array.simple/0',
    '/array.complex/1/array.simple/1',
    '/array.complex/1/array.complex',
    '/array.complex/1/array.complex/0',
    '/array.complex/1/array.complex/1',
    '/array.complex/1/set',
    '/array.complex/1/set/null',
    '/array.complex/1/hashmap',
    '/array.complex/1/hashmap/element0',
    '/array.complex/1/hashmap/element1',
    '/array.complex/1/map',
    '/array.complex/1/map/element0',
    '/array.complex/1/map/element1',
    '/array.complex/1/recursion.self',
    '/set',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/hashmap',
    '/hashmap/element0',
    '/hashmap/element0/null',
    '/hashmap/element0/undefined',
    '/hashmap/element0/boolean.true',
    '/hashmap/element0/boolean.false',
    '/hashmap/element0/string.defined',
    '/hashmap/element0/string.empty',
    '/hashmap/element0/number.zero',
    '/hashmap/element0/number.small',
    '/hashmap/element0/number.big',
    '/hashmap/element0/number.infinity.positive',
    '/hashmap/element0/number.infinity.negative',
    '/hashmap/element0/number.nan',
    '/hashmap/element0/number.signed.zero.negative',
    '/hashmap/element0/number.signed.zero.positive',
    '/hashmap/element0/bigInt.zero',
    '/hashmap/element0/bigInt.small',
    '/hashmap/element0/bigInt.big',
    '/hashmap/element0/regexp.simple1',
    '/hashmap/element0/regexp.simple2',
    '/hashmap/element0/regexp.simple3',
    '/hashmap/element0/regexp.simple4',
    '/hashmap/element0/regexp.simple5',
    '/hashmap/element0/regexp.complex0',
    '/hashmap/element0/regexp.complex1',
    '/hashmap/element0/regexp.complex2',
    '/hashmap/element0/regexp.complex3',
    '/hashmap/element0/regexp.complex4',
    '/hashmap/element0/regexp.complex5',
    '/hashmap/element0/regexp.complex6',
    '/hashmap/element0/regexp.complex7',
    '/hashmap/element0/date.now',
    '/hashmap/element0/date.fixed',
    '/hashmap/element0/buffer.node',
    '/hashmap/element0/buffer.raw',
    '/hashmap/element0/buffer.bytes',
    '/hashmap/element0/array.simple',
    '/hashmap/element0/array.simple/0',
    '/hashmap/element0/array.simple/1',
    '/hashmap/element0/array.complex',
    '/hashmap/element0/array.complex/0',
    '/hashmap/element0/array.complex/1',
    '/hashmap/element0/set',
    '/hashmap/element0/set/null',
    '/hashmap/element0/hashmap',
    '/hashmap/element0/hashmap/element0',
    '/hashmap/element0/hashmap/element1',
    '/hashmap/element0/map',
    '/hashmap/element0/map/element0',
    '/hashmap/element0/map/element1',
    '/hashmap/element0/recursion.self',
    '/hashmap/element1',
    '/hashmap/element1/null',
    '/hashmap/element1/undefined',
    '/hashmap/element1/boolean.true',
    '/hashmap/element1/boolean.false',
    '/hashmap/element1/string.defined',
    '/hashmap/element1/string.empty',
    '/hashmap/element1/number.zero',
    '/hashmap/element1/number.small',
    '/hashmap/element1/number.big',
    '/hashmap/element1/number.infinity.positive',
    '/hashmap/element1/number.infinity.negative',
    '/hashmap/element1/number.nan',
    '/hashmap/element1/number.signed.zero.negative',
    '/hashmap/element1/number.signed.zero.positive',
    '/hashmap/element1/bigInt.zero',
    '/hashmap/element1/bigInt.small',
    '/hashmap/element1/bigInt.big',
    '/hashmap/element1/regexp.simple1',
    '/hashmap/element1/regexp.simple2',
    '/hashmap/element1/regexp.simple3',
    '/hashmap/element1/regexp.simple4',
    '/hashmap/element1/regexp.simple5',
    '/hashmap/element1/regexp.complex0',
    '/hashmap/element1/regexp.complex1',
    '/hashmap/element1/regexp.complex2',
    '/hashmap/element1/regexp.complex3',
    '/hashmap/element1/regexp.complex4',
    '/hashmap/element1/regexp.complex5',
    '/hashmap/element1/regexp.complex6',
    '/hashmap/element1/regexp.complex7',
    '/hashmap/element1/date.now',
    '/hashmap/element1/date.fixed',
    '/hashmap/element1/buffer.node',
    '/hashmap/element1/buffer.raw',
    '/hashmap/element1/buffer.bytes',
    '/hashmap/element1/array.simple',
    '/hashmap/element1/array.simple/0',
    '/hashmap/element1/array.simple/1',
    '/hashmap/element1/array.complex',
    '/hashmap/element1/array.complex/0',
    '/hashmap/element1/array.complex/1',
    '/hashmap/element1/set',
    '/hashmap/element1/set/null',
    '/hashmap/element1/hashmap',
    '/hashmap/element1/hashmap/element0',
    '/hashmap/element1/hashmap/element1',
    '/hashmap/element1/map',
    '/hashmap/element1/map/element0',
    '/hashmap/element1/map/element1',
    '/hashmap/element1/recursion.self',
    '/map',
    '/map/element0',
    '/map/element0/null',
    '/map/element0/undefined',
    '/map/element0/boolean.true',
    '/map/element0/boolean.false',
    '/map/element0/string.defined',
    '/map/element0/string.empty',
    '/map/element0/number.zero',
    '/map/element0/number.small',
    '/map/element0/number.big',
    '/map/element0/number.infinity.positive',
    '/map/element0/number.infinity.negative',
    '/map/element0/number.nan',
    '/map/element0/number.signed.zero.negative',
    '/map/element0/number.signed.zero.positive',
    '/map/element0/bigInt.zero',
    '/map/element0/bigInt.small',
    '/map/element0/bigInt.big',
    '/map/element0/regexp.simple1',
    '/map/element0/regexp.simple2',
    '/map/element0/regexp.simple3',
    '/map/element0/regexp.simple4',
    '/map/element0/regexp.simple5',
    '/map/element0/regexp.complex0',
    '/map/element0/regexp.complex1',
    '/map/element0/regexp.complex2',
    '/map/element0/regexp.complex3',
    '/map/element0/regexp.complex4',
    '/map/element0/regexp.complex5',
    '/map/element0/regexp.complex6',
    '/map/element0/regexp.complex7',
    '/map/element0/date.now',
    '/map/element0/date.fixed',
    '/map/element0/buffer.node',
    '/map/element0/buffer.raw',
    '/map/element0/buffer.bytes',
    '/map/element0/array.simple',
    '/map/element0/array.simple/0',
    '/map/element0/array.simple/1',
    '/map/element0/array.complex',
    '/map/element0/array.complex/0',
    '/map/element0/array.complex/1',
    '/map/element0/set',
    '/map/element0/set/null',
    '/map/element0/hashmap',
    '/map/element0/hashmap/element0',
    '/map/element0/hashmap/element1',
    '/map/element0/map',
    '/map/element0/map/element0',
    '/map/element0/map/element1',
    '/map/element0/recursion.self',
    '/map/element1',
    '/map/element1/null',
    '/map/element1/undefined',
    '/map/element1/boolean.true',
    '/map/element1/boolean.false',
    '/map/element1/string.defined',
    '/map/element1/string.empty',
    '/map/element1/number.zero',
    '/map/element1/number.small',
    '/map/element1/number.big',
    '/map/element1/number.infinity.positive',
    '/map/element1/number.infinity.negative',
    '/map/element1/number.nan',
    '/map/element1/number.signed.zero.negative',
    '/map/element1/number.signed.zero.positive',
    '/map/element1/bigInt.zero',
    '/map/element1/bigInt.small',
    '/map/element1/bigInt.big',
    '/map/element1/regexp.simple1',
    '/map/element1/regexp.simple2',
    '/map/element1/regexp.simple3',
    '/map/element1/regexp.simple4',
    '/map/element1/regexp.simple5',
    '/map/element1/regexp.complex0',
    '/map/element1/regexp.complex1',
    '/map/element1/regexp.complex2',
    '/map/element1/regexp.complex3',
    '/map/element1/regexp.complex4',
    '/map/element1/regexp.complex5',
    '/map/element1/regexp.complex6',
    '/map/element1/regexp.complex7',
    '/map/element1/date.now',
    '/map/element1/date.fixed',
    '/map/element1/buffer.node',
    '/map/element1/buffer.raw',
    '/map/element1/buffer.bytes',
    '/map/element1/array.simple',
    '/map/element1/array.simple/0',
    '/map/element1/array.simple/1',
    '/map/element1/array.complex',
    '/map/element1/array.complex/0',
    '/map/element1/array.complex/1',
    '/map/element1/set',
    '/map/element1/set/null',
    '/map/element1/hashmap',
    '/map/element1/hashmap/element0',
    '/map/element1/hashmap/element1',
    '/map/element1/map',
    '/map/element1/map/element0',
    '/map/element1/map/element1',
    '/map/element1/recursion.self',
    '/level1',
    '/level1/null',
    '/level1/undefined',
    '/level1/boolean.true',
    '/level1/boolean.false',
    '/level1/string.defined',
    '/level1/string.empty',
    '/level1/number.zero',
    '/level1/number.small',
    '/level1/number.big',
    '/level1/number.infinity.positive',
    '/level1/number.infinity.negative',
    '/level1/number.nan',
    '/level1/number.signed.zero.negative',
    '/level1/number.signed.zero.positive',
    '/level1/bigInt.zero',
    '/level1/bigInt.small',
    '/level1/bigInt.big',
    '/level1/regexp.simple1',
    '/level1/regexp.simple2',
    '/level1/regexp.simple3',
    '/level1/regexp.simple4',
    '/level1/regexp.simple5',
    '/level1/regexp.complex0',
    '/level1/regexp.complex1',
    '/level1/regexp.complex2',
    '/level1/regexp.complex3',
    '/level1/regexp.complex4',
    '/level1/regexp.complex5',
    '/level1/regexp.complex6',
    '/level1/regexp.complex7',
    '/level1/date.now',
    '/level1/date.fixed',
    '/level1/buffer.node',
    '/level1/buffer.raw',
    '/level1/buffer.bytes',
    '/level1/array.simple',
    '/level1/array.simple/0',
    '/level1/array.simple/1',
    '/level1/array.complex',
    '/level1/array.complex/0',
    '/level1/array.complex/1',
    '/level1/set',
    '/level1/set/null',
    '/level1/hashmap',
    '/level1/hashmap/element0',
    '/level1/hashmap/element1',
    '/level1/map',
    '/level1/map/element0',
    '/level1/map/element1',
    '/level1/recursion.self',
    '/level1/recursion.super',
    '/recursion.self'
  ]

  let expDws =
  [
    '/null',
    '/undefined',
    '/boolean.true',
    '/boolean.false',
    '/string.defined',
    '/string.empty',
    '/number.zero',
    '/number.small',
    '/number.big',
    '/number.infinity.positive',
    '/number.infinity.negative',
    '/number.nan',
    '/number.signed.zero.negative',
    '/number.signed.zero.positive',
    '/bigInt.zero',
    '/bigInt.small',
    '/bigInt.big',
    '/regexp.simple1',
    '/regexp.simple2',
    '/regexp.simple3',
    '/regexp.simple4',
    '/regexp.simple5',
    '/regexp.complex0',
    '/regexp.complex1',
    '/regexp.complex2',
    '/regexp.complex3',
    '/regexp.complex4',
    '/regexp.complex5',
    '/regexp.complex6',
    '/regexp.complex7',
    '/date.now',
    '/date.fixed',
    '/buffer.node',
    '/buffer.raw',
    '/buffer.bytes',
    '/array.simple/0',
    '/array.simple/1',
    '/array.simple',
    '/array.complex/0/null',
    '/array.complex/0/undefined',
    '/array.complex/0/boolean.true',
    '/array.complex/0/boolean.false',
    '/array.complex/0/string.defined',
    '/array.complex/0/string.empty',
    '/array.complex/0/number.zero',
    '/array.complex/0/number.small',
    '/array.complex/0/number.big',
    '/array.complex/0/number.infinity.positive',
    '/array.complex/0/number.infinity.negative',
    '/array.complex/0/number.nan',
    '/array.complex/0/number.signed.zero.negative',
    '/array.complex/0/number.signed.zero.positive',
    '/array.complex/0/bigInt.zero',
    '/array.complex/0/bigInt.small',
    '/array.complex/0/bigInt.big',
    '/array.complex/0/regexp.simple1',
    '/array.complex/0/regexp.simple2',
    '/array.complex/0/regexp.simple3',
    '/array.complex/0/regexp.simple4',
    '/array.complex/0/regexp.simple5',
    '/array.complex/0/regexp.complex0',
    '/array.complex/0/regexp.complex1',
    '/array.complex/0/regexp.complex2',
    '/array.complex/0/regexp.complex3',
    '/array.complex/0/regexp.complex4',
    '/array.complex/0/regexp.complex5',
    '/array.complex/0/regexp.complex6',
    '/array.complex/0/regexp.complex7',
    '/array.complex/0/date.now',
    '/array.complex/0/date.fixed',
    '/array.complex/0/buffer.node',
    '/array.complex/0/buffer.raw',
    '/array.complex/0/buffer.bytes',
    '/array.complex/0/array.simple/0',
    '/array.complex/0/array.simple/1',
    '/array.complex/0/array.simple',
    '/array.complex/0/array.complex/0',
    '/array.complex/0/array.complex/1',
    '/array.complex/0/array.complex',
    '/array.complex/0/set/null',
    '/array.complex/0/set',
    '/array.complex/0/hashmap/element0',
    '/array.complex/0/hashmap/element1',
    '/array.complex/0/hashmap',
    '/array.complex/0/map/element0',
    '/array.complex/0/map/element1',
    '/array.complex/0/map',
    '/array.complex/0/recursion.self',
    '/array.complex/0',
    '/array.complex/1/null',
    '/array.complex/1/undefined',
    '/array.complex/1/boolean.true',
    '/array.complex/1/boolean.false',
    '/array.complex/1/string.defined',
    '/array.complex/1/string.empty',
    '/array.complex/1/number.zero',
    '/array.complex/1/number.small',
    '/array.complex/1/number.big',
    '/array.complex/1/number.infinity.positive',
    '/array.complex/1/number.infinity.negative',
    '/array.complex/1/number.nan',
    '/array.complex/1/number.signed.zero.negative',
    '/array.complex/1/number.signed.zero.positive',
    '/array.complex/1/bigInt.zero',
    '/array.complex/1/bigInt.small',
    '/array.complex/1/bigInt.big',
    '/array.complex/1/regexp.simple1',
    '/array.complex/1/regexp.simple2',
    '/array.complex/1/regexp.simple3',
    '/array.complex/1/regexp.simple4',
    '/array.complex/1/regexp.simple5',
    '/array.complex/1/regexp.complex0',
    '/array.complex/1/regexp.complex1',
    '/array.complex/1/regexp.complex2',
    '/array.complex/1/regexp.complex3',
    '/array.complex/1/regexp.complex4',
    '/array.complex/1/regexp.complex5',
    '/array.complex/1/regexp.complex6',
    '/array.complex/1/regexp.complex7',
    '/array.complex/1/date.now',
    '/array.complex/1/date.fixed',
    '/array.complex/1/buffer.node',
    '/array.complex/1/buffer.raw',
    '/array.complex/1/buffer.bytes',
    '/array.complex/1/array.simple/0',
    '/array.complex/1/array.simple/1',
    '/array.complex/1/array.simple',
    '/array.complex/1/array.complex/0',
    '/array.complex/1/array.complex/1',
    '/array.complex/1/array.complex',
    '/array.complex/1/set/null',
    '/array.complex/1/set',
    '/array.complex/1/hashmap/element0',
    '/array.complex/1/hashmap/element1',
    '/array.complex/1/hashmap',
    '/array.complex/1/map/element0',
    '/array.complex/1/map/element1',
    '/array.complex/1/map',
    '/array.complex/1/recursion.self',
    '/array.complex/1',
    '/array.complex',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set',
    '/hashmap/element0/null',
    '/hashmap/element0/undefined',
    '/hashmap/element0/boolean.true',
    '/hashmap/element0/boolean.false',
    '/hashmap/element0/string.defined',
    '/hashmap/element0/string.empty',
    '/hashmap/element0/number.zero',
    '/hashmap/element0/number.small',
    '/hashmap/element0/number.big',
    '/hashmap/element0/number.infinity.positive',
    '/hashmap/element0/number.infinity.negative',
    '/hashmap/element0/number.nan',
    '/hashmap/element0/number.signed.zero.negative',
    '/hashmap/element0/number.signed.zero.positive',
    '/hashmap/element0/bigInt.zero',
    '/hashmap/element0/bigInt.small',
    '/hashmap/element0/bigInt.big',
    '/hashmap/element0/regexp.simple1',
    '/hashmap/element0/regexp.simple2',
    '/hashmap/element0/regexp.simple3',
    '/hashmap/element0/regexp.simple4',
    '/hashmap/element0/regexp.simple5',
    '/hashmap/element0/regexp.complex0',
    '/hashmap/element0/regexp.complex1',
    '/hashmap/element0/regexp.complex2',
    '/hashmap/element0/regexp.complex3',
    '/hashmap/element0/regexp.complex4',
    '/hashmap/element0/regexp.complex5',
    '/hashmap/element0/regexp.complex6',
    '/hashmap/element0/regexp.complex7',
    '/hashmap/element0/date.now',
    '/hashmap/element0/date.fixed',
    '/hashmap/element0/buffer.node',
    '/hashmap/element0/buffer.raw',
    '/hashmap/element0/buffer.bytes',
    '/hashmap/element0/array.simple/0',
    '/hashmap/element0/array.simple/1',
    '/hashmap/element0/array.simple',
    '/hashmap/element0/array.complex/0',
    '/hashmap/element0/array.complex/1',
    '/hashmap/element0/array.complex',
    '/hashmap/element0/set/null',
    '/hashmap/element0/set',
    '/hashmap/element0/hashmap/element0',
    '/hashmap/element0/hashmap/element1',
    '/hashmap/element0/hashmap',
    '/hashmap/element0/map/element0',
    '/hashmap/element0/map/element1',
    '/hashmap/element0/map',
    '/hashmap/element0/recursion.self',
    '/hashmap/element0',
    '/hashmap/element1/null',
    '/hashmap/element1/undefined',
    '/hashmap/element1/boolean.true',
    '/hashmap/element1/boolean.false',
    '/hashmap/element1/string.defined',
    '/hashmap/element1/string.empty',
    '/hashmap/element1/number.zero',
    '/hashmap/element1/number.small',
    '/hashmap/element1/number.big',
    '/hashmap/element1/number.infinity.positive',
    '/hashmap/element1/number.infinity.negative',
    '/hashmap/element1/number.nan',
    '/hashmap/element1/number.signed.zero.negative',
    '/hashmap/element1/number.signed.zero.positive',
    '/hashmap/element1/bigInt.zero',
    '/hashmap/element1/bigInt.small',
    '/hashmap/element1/bigInt.big',
    '/hashmap/element1/regexp.simple1',
    '/hashmap/element1/regexp.simple2',
    '/hashmap/element1/regexp.simple3',
    '/hashmap/element1/regexp.simple4',
    '/hashmap/element1/regexp.simple5',
    '/hashmap/element1/regexp.complex0',
    '/hashmap/element1/regexp.complex1',
    '/hashmap/element1/regexp.complex2',
    '/hashmap/element1/regexp.complex3',
    '/hashmap/element1/regexp.complex4',
    '/hashmap/element1/regexp.complex5',
    '/hashmap/element1/regexp.complex6',
    '/hashmap/element1/regexp.complex7',
    '/hashmap/element1/date.now',
    '/hashmap/element1/date.fixed',
    '/hashmap/element1/buffer.node',
    '/hashmap/element1/buffer.raw',
    '/hashmap/element1/buffer.bytes',
    '/hashmap/element1/array.simple/0',
    '/hashmap/element1/array.simple/1',
    '/hashmap/element1/array.simple',
    '/hashmap/element1/array.complex/0',
    '/hashmap/element1/array.complex/1',
    '/hashmap/element1/array.complex',
    '/hashmap/element1/set/null',
    '/hashmap/element1/set',
    '/hashmap/element1/hashmap/element0',
    '/hashmap/element1/hashmap/element1',
    '/hashmap/element1/hashmap',
    '/hashmap/element1/map/element0',
    '/hashmap/element1/map/element1',
    '/hashmap/element1/map',
    '/hashmap/element1/recursion.self',
    '/hashmap/element1',
    '/hashmap',
    '/map/element0/null',
    '/map/element0/undefined',
    '/map/element0/boolean.true',
    '/map/element0/boolean.false',
    '/map/element0/string.defined',
    '/map/element0/string.empty',
    '/map/element0/number.zero',
    '/map/element0/number.small',
    '/map/element0/number.big',
    '/map/element0/number.infinity.positive',
    '/map/element0/number.infinity.negative',
    '/map/element0/number.nan',
    '/map/element0/number.signed.zero.negative',
    '/map/element0/number.signed.zero.positive',
    '/map/element0/bigInt.zero',
    '/map/element0/bigInt.small',
    '/map/element0/bigInt.big',
    '/map/element0/regexp.simple1',
    '/map/element0/regexp.simple2',
    '/map/element0/regexp.simple3',
    '/map/element0/regexp.simple4',
    '/map/element0/regexp.simple5',
    '/map/element0/regexp.complex0',
    '/map/element0/regexp.complex1',
    '/map/element0/regexp.complex2',
    '/map/element0/regexp.complex3',
    '/map/element0/regexp.complex4',
    '/map/element0/regexp.complex5',
    '/map/element0/regexp.complex6',
    '/map/element0/regexp.complex7',
    '/map/element0/date.now',
    '/map/element0/date.fixed',
    '/map/element0/buffer.node',
    '/map/element0/buffer.raw',
    '/map/element0/buffer.bytes',
    '/map/element0/array.simple/0',
    '/map/element0/array.simple/1',
    '/map/element0/array.simple',
    '/map/element0/array.complex/0',
    '/map/element0/array.complex/1',
    '/map/element0/array.complex',
    '/map/element0/set/null',
    '/map/element0/set',
    '/map/element0/hashmap/element0',
    '/map/element0/hashmap/element1',
    '/map/element0/hashmap',
    '/map/element0/map/element0',
    '/map/element0/map/element1',
    '/map/element0/map',
    '/map/element0/recursion.self',
    '/map/element0',
    '/map/element1/null',
    '/map/element1/undefined',
    '/map/element1/boolean.true',
    '/map/element1/boolean.false',
    '/map/element1/string.defined',
    '/map/element1/string.empty',
    '/map/element1/number.zero',
    '/map/element1/number.small',
    '/map/element1/number.big',
    '/map/element1/number.infinity.positive',
    '/map/element1/number.infinity.negative',
    '/map/element1/number.nan',
    '/map/element1/number.signed.zero.negative',
    '/map/element1/number.signed.zero.positive',
    '/map/element1/bigInt.zero',
    '/map/element1/bigInt.small',
    '/map/element1/bigInt.big',
    '/map/element1/regexp.simple1',
    '/map/element1/regexp.simple2',
    '/map/element1/regexp.simple3',
    '/map/element1/regexp.simple4',
    '/map/element1/regexp.simple5',
    '/map/element1/regexp.complex0',
    '/map/element1/regexp.complex1',
    '/map/element1/regexp.complex2',
    '/map/element1/regexp.complex3',
    '/map/element1/regexp.complex4',
    '/map/element1/regexp.complex5',
    '/map/element1/regexp.complex6',
    '/map/element1/regexp.complex7',
    '/map/element1/date.now',
    '/map/element1/date.fixed',
    '/map/element1/buffer.node',
    '/map/element1/buffer.raw',
    '/map/element1/buffer.bytes',
    '/map/element1/array.simple/0',
    '/map/element1/array.simple/1',
    '/map/element1/array.simple',
    '/map/element1/array.complex/0',
    '/map/element1/array.complex/1',
    '/map/element1/array.complex',
    '/map/element1/set/null',
    '/map/element1/set',
    '/map/element1/hashmap/element0',
    '/map/element1/hashmap/element1',
    '/map/element1/hashmap',
    '/map/element1/map/element0',
    '/map/element1/map/element1',
    '/map/element1/map',
    '/map/element1/recursion.self',
    '/map/element1',
    '/map',
    '/level1/null',
    '/level1/undefined',
    '/level1/boolean.true',
    '/level1/boolean.false',
    '/level1/string.defined',
    '/level1/string.empty',
    '/level1/number.zero',
    '/level1/number.small',
    '/level1/number.big',
    '/level1/number.infinity.positive',
    '/level1/number.infinity.negative',
    '/level1/number.nan',
    '/level1/number.signed.zero.negative',
    '/level1/number.signed.zero.positive',
    '/level1/bigInt.zero',
    '/level1/bigInt.small',
    '/level1/bigInt.big',
    '/level1/regexp.simple1',
    '/level1/regexp.simple2',
    '/level1/regexp.simple3',
    '/level1/regexp.simple4',
    '/level1/regexp.simple5',
    '/level1/regexp.complex0',
    '/level1/regexp.complex1',
    '/level1/regexp.complex2',
    '/level1/regexp.complex3',
    '/level1/regexp.complex4',
    '/level1/regexp.complex5',
    '/level1/regexp.complex6',
    '/level1/regexp.complex7',
    '/level1/date.now',
    '/level1/date.fixed',
    '/level1/buffer.node',
    '/level1/buffer.raw',
    '/level1/buffer.bytes',
    '/level1/array.simple/0',
    '/level1/array.simple/1',
    '/level1/array.simple',
    '/level1/array.complex/0',
    '/level1/array.complex/1',
    '/level1/array.complex',
    '/level1/set/null',
    '/level1/set',
    '/level1/hashmap/element0',
    '/level1/hashmap/element1',
    '/level1/hashmap',
    '/level1/map/element0',
    '/level1/map/element1',
    '/level1/map',
    '/level1/recursion.self',
    '/level1/recursion.super',
    '/level1',
    '/recursion.self',
    '/'
  ]

  var generated = _.diagnosticStructureGenerate({ depth : 1, defaultComplexity : 5, defaultLength : 2 });

  clean();
  _.look({ src : generated.structure, onUp, onDown });
  test.identical( ups, expUps );
  test.identical( dws, expDws );

  /* - */

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
  }

} /* end of function callbacksComplex */

//

function revisiting( test )
{
  let ups = [];
  let dws = [];

  let structure =
  {
    arr : [ 0, { a : 1, b : null, c : 3 }, 4 ],
  }
  structure.arr[ 1 ].b = structure.arr;
  structure.arr2 = structure.arr;

  /* - */

  test.case = 'revisiting : 0';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2'
  ]
  var got = _.look({ src : structure, revisiting : 0, onUp, onDown });

  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  test.case = 'revisiting : 1';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var got = _.look({ src : structure, revisiting : 1, onUp, onDown });

  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  test.case = 'revisiting : 2';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var got = _.look({ src : structure, revisiting : 2, onUp : onUp2, onDown });
  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
    logger.log( 'up', it.level, it.path );
  }

  function onUp2( e, k, it )
  {
    ups.push( it.path );
    logger.log( 'up', it.level, it.path );
    if( it.level >= 3 )
    it.continue = false;
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    logger.log( 'down', it.level, it.path );
  }

}

//

function onSrcChangedElements( test )
{
  let ups = [];
  let dws = [];
  let upNames = [];
  let dwNames = [];

  var a1 = new Obj({ name : 'a1' });
  var a2 = new Obj({ name : 'a2' });
  var b = new Obj({ name : 'b', elements : [ a1, a2 ] });
  var c = new Obj({ name : 'c', elements : [ b ] });

  var expUps = [ '/', '/0', '/0/0', '/0/1' ];
  var expDws = [ '/', '/0', '/0/0', '/0/1' ];
  var expUpNames = [ 'c', 'b', 'a1', 'a2' ];
  var expDwNames = [ 'a1', 'a2', 'b', 'c' ];

  var got = _.look({ src : c, onUp, onDown, onSrcChanged });
  test.identical( ups, expUps );
  test.identical( ups, expDws );
  test.identical( upNames, expUpNames );
  test.identical( dwNames, expDwNames );

  /* - */

  function Obj( o )
  {
    this.str = 'str';
    this.num = 13;
    Object.assign( this, o );
  }

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
    upNames.push( it.src.name );
    logger.log( 'up', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    dwNames.push( it.src.name );
    logger.log( 'down', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onSrcChanged()
  {
    let it = this;
    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = 'Obj';
        it.ascendAct = function objAscend( onIteration, src )
        {
          return this._longAscend( onIteration, src.elements );
        }
      }
    }
  }

}

//

function onUpElements( test )
{
  let ups = [];
  let dws = [];
  let upNames = [];
  let dwNames = [];

  var a1 = new Obj({ name : 'a1' });
  var a2 = new Obj({ name : 'a2' });
  var b = new Obj({ name : 'b', elements : [ a1, a2 ] });
  var c = new Obj({ name : 'c', elements : [ b ] });

  var expUps = [ '/', '/0', '/0/0', '/0/1' ];
  var expDws = [ '/', '/0', '/0/0', '/0/1' ];
  var expUpNames = [ 'c', 'b', 'a1', 'a2' ];
  var expDwNames = [ 'a1', 'a2', 'b', 'c' ];

  var got = _.look({ src : c, onUp, onDown });
  test.identical( ups, expUps );
  test.identical( ups, expDws );
  test.identical( upNames, expUpNames );
  test.identical( dwNames, expDwNames );

  /* - */

  function Obj( o )
  {
    this.str = 'str';
    this.num = 13;
    Object.assign( this, o );
  }

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = 'Obj';
        it.ascendAct = function objAscend( onIteration, src )
        {
          return this._longAscend( onIteration, src.elements );
        }
      }
    }

    ups.push( it.path );
    upNames.push( it.src.name );
    logger.log( 'up', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    dwNames.push( it.src.name );
    logger.log( 'down', it.level, it.path, it.src ? it.src.name : '' );
  }

}

//

function lookOptionRoot( test )
{

  var structure1 =
  {
    a : 1,
    b : 's',
    c : [ 1,3 ],
    d : [ 1,{ date : new Date() } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1,2,3 ]),
  }

  var it = _.look({ src : structure1, onUp : handleUp1, onDown : handleDown1, root : structure1 });
  
  test.case = 'root declared';
  var got = Object.getPrototypeOf( it ).root;
  var expected = structure1;
  test.identical( got, expected );

  function handleUp1( e, k, it )
  {
    gotUpPaths1.push( it.path );
    gotUpIndinces1.push( it.index );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths1.push( it.path );
    gotDownIndices1.push( it.index );
  }

  function handleUp2( e, k, it )
  {
    gotUpPaths2.push( it.path );
    gotUpIndinces2.push( it.index );
  }

  function handleDown2( e, k, it )
  {
    gotDownPaths2.push( it.path );
    gotDownIndices2.push( it.index );
  }

}

// --
// declare
// --

var Self =
{

  name : 'Tools.base.l3.Look',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {

    lookOptionRoot,
    look,
    lookRecursive,
    testPaths,
    callbacksComplex,

    revisiting,
    onSrcChangedElements,
    onUpElements,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
