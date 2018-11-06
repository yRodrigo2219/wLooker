( function _Looker_s_() {

'use strict';

/**
  @module Tools/base/Looker - Collection of light-weight routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison or operation on several similar data structures. Please see wComparator which based on the module for comparison.
*/

/**
 * @file Looker.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

}

let _global = _global_;
let Self = _global_.wTools;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_realGlobal_ );

// --
// look
// --

function lookerIterator( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( this.Iterator ) );

  /* */

  let iterator = Object.create( o.looker );
  Object.assign( iterator, this.Iterator );
  Object.assign( iterator, o );

  iterator.iterator = iterator;

  // if( iterator.root === null )
  // iterator.root = iterator.src;
  //
  // if( iterator.root2 === null )
  // iterator.root2 = iterator.src2;

  if( iterator.trackingVisits )
  {
    iterator.visited = [];
    iterator.visited2 = [];
  }

  if( iterator.path === null )
  iterator.path = iterator.delimteter;

  iterator.lastPath = iterator.path;

  // iterator.key = null;
  // iterator.looking = true;

  Object.preventExtensions( iterator );

  _.assert( iterator.level !== undefined );
  _.assert( iterator.path !== undefined );
  _.assert( _.strIs( iterator.lastPath ) );

  return iterator;
}

//

function iteratorIteration()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.iterator ) );
  _.assert( _.objectIs( it.looker ) );

  let newIt = Object.create( it.iterator );
  Object.assign( newIt, it.looker.Iteration );
  Object.preventExtensions( newIt );

  newIt.level = it.level;
  newIt.path = it.path;
  newIt.src = it.src;
  newIt.src2 = it.src2;

  return newIt;
}

//

function iterationIteration()
{
  let it = this;

  _.assert( arguments.length === 0 );

  let newIt = it.iterator.iteration.call( it )

  newIt.down = it;

  return newIt;
}

//

function iteratorSelect( k )
{
  let it = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.down ) );
  _.assert( !!it.src );

  it.level = it.level+1;
  it.path = it.path !== it.delimteter ? it.path + it.delimteter + k : it.path + k;
  it.iterator.lastPath = it.path;
  it.key = k;
  it.index = it.down.hasChildren;
  it.src = it.src[ k ];

  it.select2( k );

  return it;
}

//

function iteratorSelect2( k )
{
  let it = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.down ) );

  return it.onSelect2( it );

  // if( it.src2 )
  // it.src2 = it.src2[ k ];
  // else
  // it.src2 = undefined;
  //
  // return it;
}

//

function onSelect2()
{
  let it = this;

  if( it.src2 )
  it.src2 = it.src2[ it.key ];
  else
  it.src2 = undefined;

  return it;
}

//

function iteratorLook()
{
  let it = this;

  _.assert( it.level >= 0 );
  _.assert( arguments.length === 0 );

  let keepLooking = true;
  if( !it.recursive && it.down )
  keepLooking = false;

  if( !keepLooking )
  return it;

  /* up */

  up();

  /* level */

  if( it.levelLimit !== 0 )
  if( !( it.level < it.levelLimit ) )
  keepLooking = false;

  _.assert( _.boolIs( it.looking ) );
  _.assert( _.boolIs( it.iterator.looking ) );

  if( keepLooking === false )
  {}
  else if( it.looking === false )
  keepLooking = false;
  else if( it.iterator.looking === false )
  keepLooking = false;
  else if( it.visitedManyTimes )
  keepLooking = false;
  else if( it.ascending === false )
  keepLooking = false;

  if( keepLooking === false )
  return down();

  /* iterate */

  if( _.arrayIs( it.src ) || _.argumentsArrayIs( it.src ) )
  {

    for( let k = 0 ; k < it.src.length ; k++ )
    {

      handleElement( k );

      if( !it.iterator.looking || it.iterator.looking === _.dont )
      break;

    }

  }
  else if( _.objectLike( it.src ) )
  {

    for( let k in it.src )
    {

      if( it.own )
      if( !_ObjectHasOwnProperty.call( it.src,k ) )
      continue;

      handleElement( k );

      if( !it.iterator.looking || it.iterator.looking === _.dont )
      break;

    }

  }
  else
  {
    if( it.onTerminal )
    it.onTerminal.call( it, it.src, it.key, it );
  }

  /* end */

  return down();

  /* element */

  function handleElement( k )
  {

    // if( it.recursive || it.root === it.src )
    {
      let itNew = it.iteration().select( k );
      itNew.look();
    }

  }

  /* up */

  function up()
  {

    if( it.trackingVisits )
    {
      if( it.visited.indexOf( it.src ) !== -1 )
      it.visitedManyTimes = true;
      it.visited.push( it.src );
      it.visited2.push( it.src2 );
    }

    it.ascending = true;
    if( it.down )
    {
      it.down.hasChildren += 1;
    }

    if( it.visitingRoot || it.root !== it.src )
    {
      _.assert( _.routineIs( it.onUp ) );
      let r = it.onUp.call( it, it.src, it.key, it );
      if( it.looking === true && r !== undefined )
      it.looking = r;
      if( it.looking === _.dont )
      it.looking = false;
      _.assert( _.boolIs( it.looking ), () => 'Expects it.onUp returns boolean, but got ' + _.strTypeOf( it.looking ) );
    }

  }

  /* down */

  function down()
  {
    it.ascending = false;

    if( it.visitingRoot || it.root !== it.src )
    {
      if( it.onDown )
      it.result = it.onDown.call( it, it.src, it.key, it );
    }

    if( it.trackingVisits )
    {
      _.assert( Object.is( it.visited[ it.visited.length-1 ], it.src ) );
      it.visited.pop();
      _.assert( Object.is( it.visited2[ it.visited2.length-1 ], it.src2 ) );
      it.visited2.pop();
    }

    return it;
  }

}

// --
// relations
// --

let Defaults = Object.create( null );

Defaults.onUp = function( e,k,it ){ return it.looking };
Defaults.onTerminal = function( e,k,it ){ return it.result };
Defaults.onDown = function( e,k,it ){ return it.result };
Defaults.onSelect2 = onSelect2;

Defaults.own = 0;
Defaults.recursive = 1;
Defaults.visitingRoot = 1;

Defaults.trackingVisits = 1;
Defaults.levelLimit = 0;

Defaults.delimteter = '/';
Defaults.path = null;

Defaults.counter = 0;
Defaults.level = 0;

Defaults.src = null;
Defaults.root = null;

Defaults.src2 = null;
Defaults.root2 = null;

Defaults.context = null;
Defaults.looker = null;

// Object.freeze( Defaults );

//

let Iteration = Object.create( null );

Iteration.iteration = iterationIteration;
Iteration.hasChildren = 0;
Iteration.level = 0,
Iteration.path = '/';
Iteration.key = null;
Iteration.index = null;
Iteration.src = null;
Iteration.src2 = null;
Iteration.result = true;
Iteration.looking = true;
Iteration.ascending = true;
Iteration.visitedManyTimes = false;
Iteration._ = null;
Iteration.down = null;

Object.freeze( Iteration );

//

let Iterator = _global.wTools.Iterator = _global.wTools.Iterator || Object.create( null );

Iterator.iterator = null;
Iterator.iteration = iteratorIteration;
Iterator.select = iteratorSelect;
Iterator.select2 = iteratorSelect2;
Iterator.look = iteratorLook;

Iterator.path = null;
Iterator.lastPath = null;
Iterator.looking = true;
Iterator.key = null;

Iterator.root = null;
Iterator.root2 = null;
Iterator.visited = null;
Iterator.visited2 = null;

Object.freeze( Iterator );

//

let Looker = Object.create( null );
Looker.looker = Looker;
Looker.iterator = lookerIterator;
Looker.Iterator = Iterator;
Looker.Iteration = Iteration;
Looker.Defaults = Defaults;

// Object.freeze( Looker );

Defaults.looker = Looker;

// --
// expose
// --

function _look_pre( routine, args )
{
  let o;

  if( args.length === 1 )
  {
    if( _.numberIs( args[ 0 ] ) )
    o = { accuracy : args[ 0 ] }
    else
    o = args[ 0 ];
  }
  else if( args.length === 2 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ] };
  }
  else if( args.length === 3 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ], onDown : args[ 2 ] };
  }
  else _.assert( 0,'look expects single options map, 2 or 3 arguments' );

  if( o.looker && _.prototypeOf( o.looker, o ) )
  {
    return o;
  }

  o.looker = o.looker || routine.defaults.looker;

  _.mapComplementPreservingUndefines( o, routine.defaults );
  _.routineOptionsPreservingUndefines( routine, o, o.looker.Defaults );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should Expects exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onUp should Expects exactly three arguments' );

  let iterator = o.looker.iterator( o );
  let iteration = iterator.iteration();

  return iteration;
}

//

function _look_body( it )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.looker ) );
  _.assert( _.prototypeOf( it.looker, it ) );

  return it.look();
}

_look_body.defaults = Object.create( Defaults );

//

let look = _.routineFromPreAndBody( _look_pre, _look_body );

var defaults = look.defaults;

defaults.own = 0;
defaults.recursive = 1;

//

let lookOwn = _.routineFromPreAndBody( _look_pre, _look_body );

var defaults = lookOwn.defaults;

defaults.own = 1;
defaults.recursive = 1;

// --
// declare
// --

let Supplement =
{

  Looker : Looker,
  look : look,
  lookOwn : lookOwn,

}

_.mapSupplement( Self, Supplement );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
