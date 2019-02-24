( function _Looker_s_() {

'use strict';

/**
 * Collection of light-weight routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison or operation on several similar data structures. Please see wComparator which based on the module for comparison.
  @module Tools/base/Looker
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
// looker
// --

function lookerIteratorMake( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( this.Iterator ) );
  _.assert( _.objectIs( o.Looker ) );
  _.assert( o.looker === undefined );

  /* */

  let iterator = Object.create( o.Looker );
  Object.assign( iterator, this.Iterator );
  Object.assign( iterator, o );
  if( o.iteratorExtension )
  Object.assign( iterator, o.iteratorExtension );

  delete iterator.it;

  iterator.iterator = iterator;

  if( iterator.trackingVisits )
  {
    iterator.visited = [];
  }

  if( iterator.path === null )
  iterator.path = iterator.upToken;
  iterator.lastPath = iterator.path;

  Object.preventExtensions( iterator );

  _.assert( iterator.it === undefined );
  _.assert( iterator.level !== undefined );
  _.assert( iterator.path !== undefined );
  _.assert( _.strIs( iterator.lastPath ) );

  return iterator;
}

// --
// iterator
// --

function iteratorIterationMakeAct()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.iterator ) );
  // _.assert( _.objectIs( it.looker ) );
  _.assert( _.objectIs( it.Looker ) );
  _.assert( it.looker === undefined );
  _.assert( _.numberIs( it.level ) && it.level >= 0 );
  _.assert( _.numberIs( it.logicalLevel ) && it.logicalLevel >= 0 );

  let newIt = Object.create( it.iterator );
  Object.assign( newIt, it.Looker.Iteration );
  Object.preventExtensions( newIt );

  for( let k in it.Looker.IterationPreserve )
  newIt[ k ] = it[ k ];

  if( it.iterator !== it )
  newIt.down = it;

  return newIt;
}

//

function iteratorIteration()
{
  let it = this;
  let newIt = it.iterationAct();

  newIt.logicalLevel = it.logicalLevel + 1;

  _.assert( arguments.length === 0 );

  return newIt;
}

//

function iteratorReiteration()
{
  let it = this;
  let newIt = it.iterationAct();

  newIt.logicalLevel = it.logicalLevel;

  _.assert( arguments.length === 0 );

  return newIt;
}

//

function iteratorSelect( k )
{
  let it = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.down ) );

  it.level = it.level+1;

  let k2 = k;

  if( _.strIs( k2 ) && _.strHas( k2, it.upToken ) )
  k2 = '"' + k2 + '"';

  it.path = it.path !== it.upToken ? it.path + it.upToken + k2 : it.path + k2;
  it.iterator.lastPath = it.path;
  it.iterator.lastSelect = it;
  it.key = k;
  it.index = it.down.hasChildren;

  if( it.src )
  it.src = it.src[ k ];
  else
  it.src = undefined;

  return it;
}

//

function iteratorLook()
{
  let it = this;

  _.assert( it.level >= 0 );
  _.assert( arguments.length === 0 );

  it.visiting = it.canVisit();
  if( !it.visiting )
  return it;

  it.visitUp();

  it.ascending = it.canAscend();
  if( it.ascending === false )
  return it.visitDown();

  it.onAscend( function( eit )
  {
    eit.look();
  });

  if( !it.iterable )
  it.onTerminal();

  return it.visitDown();
}

//

function iteratorVisitUp() // xxx
{
  let it = this;

  it.ascending = true;

  if( !it.visiting )
  return;

  if( it.down )
  it.down.hasChildren += 1;

  if( it.iterator.trackingVisits )
  {
    if( it.visited.indexOf( it.src ) !== -1 )
    it.visitedManyTimes = true;
  }

  _.assert( it.continue );

  if( it.continue )
  it.iterable = it.onIterable( it.src );

  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  if( it.continue === _.dont )
  it.continue = false;
  _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.strType( it.continue ) );

  it.visitBeginMaybe()

}

//

function iteratorVisitDown()
{
  let it = this;

  it.ascending = false;

  if( !it.visiting )
  return;

  it.visitEndMaybe();

  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  return it;
}

//

function iteratorVisitBegin()
{
  let it = this;

  if( it.iterator.trackingVisits )
  {
    it.visited.push( it.src );
  }

}

//

function iteratorVisitBeginMaybe()
{
  let it = this;

  if( it.iterator.trackingVisits && it.trackingVisits )
  it.visitBegin();

}

//

function iteratorVisitEnd()
{
  let it = this;

  if( it.iterator.trackingVisits )
  {
    _.assert( Object.is( it.visited[ it.visited.length-1 ], it.src ), () => 'Top-most visit does not match ' + it.path );
    it.visited.pop();
  }

}

//

function iteratorVisitEndMaybe()
{
  let it = this;

  if( it.iterator.trackingVisits && it.trackingVisits )
  it.visitEnd();

  it.trackingVisits = 0;

}

//

function iteratorCanVisit()
{
  let it = this;

  if( !it.recursive && it.down )
  return false

  if( !it.visitingRoot && it.root === it.src )
  return false;

  return true
}

//

function iteratorCanAscend()
{
  let it = this;

  _.assert( _.boolIs( it.continue ) );
  _.assert( _.boolIs( it.iterator.continue ) );

  if( !it.ascending )
  return false;

  if( it.continue === false )
  return false;
  else if( it.iterator.continue === false )
  return false;
  else if( it.visitedManyTimes )
  return false;

  // if( it.levelLimit !== 0 )
  // if( !( it.level < it.levelLimit ) )
  // return false;

  _.assert( _.numberIs( it.recursive ) );
  if( it.recursive > 0 )
  if( !( it.level < it.recursive ) )
  return false;

  // if( it.levelLimit !== 0 )
  // if( !( it.level < it.levelLimit ) )
  // return false;

  return true;
}

// --
// handler
// --

function onUp( e,k,it )
{
}

//

function onDown( e,k,it )
{
}

//

function onTerminal()
{
  let it = this;
  return it;
}

//

function onAscend( onIteration )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( _.routineIs( onIteration ) );
  _.assert( onIteration.length === 0 || onIteration.length === 1 );
  _.assert( !!it.continue );
  _.assert( !!it.iterator.continue );

  if( it.iterable === 'array-like' )
  {

    for( let k = 0 ; k < it.src.length ; k++ )
    {
      // debugger;
      let eit = it.iteration().select( k )/*.select2( k )*/;

      onIteration.call( it, eit );

      if( !it.continue || it.continue === _.dont )
      break;

      if( !it.iterator.continue || it.iterator.continue === _.dont )
      break;

    }

  }
  else if( it.iterable === 'map-like' )
  {

    for( let k in it.src )
    {

      if( it.own )
      if( !_ObjectHasOwnProperty.call( it.src, k ) )
      continue;

      // debugger;
      let eit = it.iteration().select( k )/*.select2( k )*/;

      onIteration.call( it, eit );

      if( !it.continue || it.continue === _.dont )
      break;

      if( !it.iterator.continue || it.iterator.continue === _.dont )
      break;

    }

  }

}

//

function onIterable( src )
{
  let it = this;

  if( _.arrayLike( src ) )
  {
    return 'array-like';
  }
  else if( _.mapLike( src ) )
  {
    return 'map-like';
  }
  else
  {
    return false;
  }

}

// --
// relations
// --

let Defaults = Object.create( null );

Defaults.onUp = onUp;
Defaults.onDown = onDown;
Defaults.onTerminal = onTerminal;
Defaults.onAscend = onAscend;
Defaults.onIterable = onIterable;
Defaults.own = 0;
Defaults.recursive = Infinity;
Defaults.visitingRoot = 1;
Defaults.trackingVisits = 1;
// Defaults.levelLimit = 0;
Defaults.upToken = '/';
Defaults.path = null;
Defaults.level = 0;
Defaults.logicalLevel = 0;
Defaults.src = null;
Defaults.root = null;
Defaults.context = null;
Defaults.Looker = null;
Defaults.it = null;
Defaults.iterationCurrent = null;
Defaults.iteratorExtension = null;

//

let Looker = Defaults.Looker = Object.create( null );
Looker.Looker = Looker;
Looker.Iterator = null;
Looker.Iteration = null;
Looker.IterationPreserve = null;
Looker.iterator = lookerIteratorMake;

//

let Iterator = Looker.Iterator = Object.create( null );

Iterator.iterator = null;
Iterator.iterationAct = iteratorIterationMakeAct;
Iterator.iteration = iteratorIteration;
Iterator.reiteration = iteratorReiteration;
Iterator.select = iteratorSelect;
Iterator.look = iteratorLook;
Iterator.visitUp = iteratorVisitUp;
Iterator.visitDown = iteratorVisitDown;
Iterator.visitBegin = iteratorVisitBegin;
Iterator.visitBeginMaybe = iteratorVisitBeginMaybe;
Iterator.visitEnd = iteratorVisitEnd;
Iterator.visitEndMaybe = iteratorVisitEndMaybe;
Iterator.canVisit = iteratorCanVisit;
Iterator.canAscend = iteratorCanAscend;
Iterator.path = null;
Iterator.lastPath = null;
Iterator.lastSelect = null;
Iterator.continue = true;
Iterator.key = null;
Iterator.error = null;
Iterator.visited = null;

_.mapSupplement( Iterator, Defaults );
Object.freeze( Iterator );

//

let Iteration = Looker.Iteration = Object.create( null );
Iteration.hasChildren = 0;
Iteration.level = 0,
Iteration.logicalLevel = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.index = null;
Iteration.src = null;
Iteration.continue = true;
Iteration.ascending = true;
Iteration.visitedManyTimes = false;
Iteration._ = null;
Iteration.iterationCurrent = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.trackingVisits = 1;
Object.freeze( Iteration );

//

let IterationPreserve = Looker.IterationPreserve = Object.create( null );
IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = null;
IterationPreserve.iterationCurrent =  null;
Object.freeze( IterationPreserve );

//

let ErrorLooking = _.error_functor( 'ErrorLooking' );

// --
// expose
// --

function look_pre( routine, args )
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

  o.Looker = o.Looker || routine.defaults.Looker;

  if( _.boolIs( o.recursive ) )
  o.recursive = o.recursive ? Infinity : 1;

  _.assert( o.Looker.Looker === o.Looker );
  _.assert( _.objectIs( o.Looker ) );
  _.assert( o.looker === undefined );
  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should expect exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onUp should expect exactly three arguments' );
  _.assert( _.numberIsInt( o.recursive ), 'Expects integer {- o.recursive -}' );

  if( o.it === null || o.it === undefined )
  {
    let iterator = o.Looker.iterator( o );
    let iteration = iterator.iteration();
    return iteration;
  }
  else
  {
    return o.it;
  }

}

//

function look_body( it )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.Looker ) );
  _.assert( _.prototypeOf( it.Looker, it ) );
  _.assert( it.looker === undefined );

  return it.look();
}

look_body.defaults = Object.create( Defaults );

//

let look = _.routineFromPreAndBody( look_pre, look_body );

var defaults = look.defaults;
defaults.own = 0;
defaults.recursive = Infinity;

//

let lookOwn = _.routineFromPreAndBody( look_pre, look_body );

var defaults = lookOwn.defaults;
defaults.own = 1;
defaults.recursive = Infinity;

//

function lookerIs( looker )
{
  if( !looker )
  return false;
  if( !looker.Looker )
  return false;
  return _.prototypeOf( looker, looker.Looker );
}

//

function lookIteratorIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( it.iterator !== it )
  return false;
  return true;
}

//

function lookIterationIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  return true;
}

// --
// declare
// --

let Supplement =
{

  Looker,
  ErrorLooking,

  look,
  lookOwn,

  lookerIs,
  lookIteratorIs,
  lookIterationIs,

}

_.mapSupplement( Self, Supplement );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
