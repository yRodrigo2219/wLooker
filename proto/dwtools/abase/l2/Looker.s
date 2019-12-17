( function _Looker_s_() {

'use strict';

/**
 * Collection of light-weight routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison or operation on several similar data structures, for replication. Several other modules used this to traverse abstract data structures.
  @module Tools/base/Looker
*/

/**
 * @file Looker.s.
 */

/**
 * Collection of light-weight routines to traverse complex data structure.
 * @namespace Tools( module::Looker )
 * @memberof module:Tools/base/Looker
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

}

let _global = _global_;
let _ = _global_.wTools;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_realGlobal_ );

// --
// iterator
// --

function iteratorIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( it.iterator !== it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

/**
 * Makes iterator for Looker.
 *
 * @param {Object} o - Options map
 * @function iteratorMake
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function iteratorMake( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( this.Iterator ) );
  _.assert( _.objectIs( this.Iteration ) );
  _.assert( _.objectIs( o.Looker ) );
  _.assert( o.Looker === this );
  _.assert( o.looker === undefined );
  _.assert( 0 <= o.revisiting && o.revisiting <= 2 );

  /* */

  let iterator = Object.create( o.Looker );
  Object.assign( iterator, this.Iterator );
  Object.assign( iterator, o );
  if( o.iteratorExtension )
  Object.assign( iterator, o.iteratorExtension );
  Object.preventExtensions( iterator );

  delete iterator.it;

  iterator.iterator = iterator;

  if( iterator.revisiting < 2 )
  {
    if( iterator.revisiting === 0 )
    iterator.visitedContainer = _.containerAdapter.from( new Set );
    else
    iterator.visitedContainer = _.containerAdapter.from( new Array );
  }

  if( iterator.root === null )
  iterator.root = iterator.src;

  if( iterator.defaultUpToken === null && !iterator.fast )
  iterator.defaultUpToken = _.strsShortest( iterator.upToken );

  if(  iterator.fast )
  {
    delete iterator.childrenCounter;
    delete iterator.level;
    delete iterator.path;
    delete iterator.lastPath;
    delete iterator.lastSelected;
    delete iterator.upToken;
    delete iterator.defaultUpToken;
    delete iterator.logicalLevel;
    delete iterator.context;
  }
  else
  {
    if( iterator.path === null )
    iterator.path = iterator.defaultUpToken;
    iterator.lastPath = iterator.path;
  }

  /* important assert, otherwise copying options from iteration could cause problem */
  _.assert( iterator.it === undefined );
  if( !iterator.fast )
  {
    _.assert( _.numberIs( iterator.level ) );
    _.assert( _.strIs( iterator.defaultUpToken ) );
    _.assert( _.strIs( iterator.path ) );
    _.assert( _.strIs( iterator.lastPath ) );
  }

  return iterator;
}

// --
// iteration
// --

function iterationIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

/**
 * @function iterationMake
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function iterationMake()
{
  let it = this;
  let newIt = it.iterationMakeAct();

  if( !it.fast )
  newIt.logicalLevel = it.logicalLevel + 1; /* xxx : level and logicalLevel should have the same value if no reinit done */

  _.assert( arguments.length === 0 );

  return newIt;
}

//

/**
 * @function iterationRemake
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function iterationRemake()
{
  let it = this;
  let newIt = it.iterationMakeAct();

  if( !it.fast )
  newIt.logicalLevel = it.logicalLevel;

  _.assert( arguments.length === 0 );

  return newIt;
}

//

/**
 * @function iterationMakeAct
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function iterationMakeAct()
{
  let it = this;

  // _.assert( arguments.length === 0 );
  // _.assert( it.level >= 0 );
  // _.assert( _.objectIs( it.iterator ) );
  // _.assert( _.objectIs( it.Looker ) );
  // _.assert( it.looker === undefined );
  // _.assert( _.numberIs( it.level ) && it.level >= 0 );
  // _.assert( _.numberIs( it.logicalLevel ) && it.logicalLevel >= 0 );

  let newIt = Object.create( it.iterator );
  Object.assign( newIt, it.Looker.Iteration );
  if( it.iterator.iterationExtension )
  Object.assign( newIt, it.iterator.iterationExtension );
  Object.preventExtensions( newIt );

  for( let k in it.Looker.IterationPreserve )
  newIt[ k ] = it[ k ];

  if( it.iterationPreserve )
  for( let k in it.iterationPreserve )
  newIt[ k ] = it[ k ];

  if( it.iterator !== it )
  newIt.down = it;

  return newIt;
}

//

/**
 * @function select
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function select( e, k )
{
  let it = this;

  _.assert( arguments.length === 2, 'Expects two argument' );
  _.assert( _.objectIs( it.down ) );
  if( !it.fast )
  _.assert( it.level >= 0 );

  if( e === undefined )
  {
    if( _.setIs( it.src ) )
    e = [ ... it.src ][ k ];
    else if( _.hashMapIs( it.src ) )
    e = it.src.get( k );
    else if( it.src )
    e = it.src[ k ];
    else
    e = undefined;
  }

  /*
    assigning key / src should goes first
  */

  it.key = k;
  it.src = e;

  if( !it.fast )
  {
    it.level = it.level+1;

    let k2 = k;
    if( k2 === null )
    k2 = e;
    if( !_.strIs( k2 ) )
    k2 = _.strShort( k2 );
    let hasUp = _.strIs( k2 ) && _.strHasAny( k2, it.upToken );
    if( hasUp )
    k2 = '"' + k2 + '"';

    // if( _.strEnds( it.path, it.upToken ) )
    // {
    //   // it.path = it.path + k2;
    //   it.path = it.onPathJoin( it.path, it.defaultUpToken, k2 );
    // }
    // else
    // {
    //   it.path = it.onPathJoin( it.path, it.defaultUpToken, k2 );
    // }

    it.index = it.down.childrenCounter;
    it.path = it.onPathJoin( it.path, it.upToken, it.defaultUpToken, k2 );

    it.iterator.lastPath = it.path;
    it.iterator.lastSelected = it;
  }

  return it;
}

// --
// visit
// --

/**
 * @function look
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function look()
{
  let it = this;

  if( !it.fast )
  _.assert( it.level >= 0 );
  _.assert( arguments.length === 0 );

  it.visiting = it.canVisit();
  if( !it.visiting )
  return it;

  it.visitUp();

  it.ascending = it.canAscend();
  if( it.ascending )
  {
    it.ascend( function( eit )
    {
      eit.look();
    });
  }

  it.visitDown();
  return it;
}

//

/**
 * @function visitUp
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  it.visitUpEnd()

}

//

/**
 * @function visitUpBegin
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */


function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );
  // if( !it.visiting )
  // return;

  if( it.down && !it.fast )
  it.down.childrenCounter += 1;

  // if( it.iterator.revisiting < 2 )
  // {
  //   if( it.iterator.visitedContainer.indexOf( it.src ) !== -1 )
  //   it.revisited = true;
  // }

  _.assert( it.continue );

  if( it.continue )
  it.srcChanged();

}

//

/**
 * @function visitUpEnd
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function visitUpEnd()
{
  let it = this;

  if( it.continue === _.dont )
  it.continue = false;
  _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.strType( it.continue ) );

  it.visitPush();

}

//

/**
 * @function visitDown
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  _.assert( it.visiting );
  // if( it.visiting )
  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  return it;
}

//

/**
 * @function visitDownBegin
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function visitDownBegin()
{
  let it = this;

  it.ascending = false;

  _.assert( it.visiting );
  // if( !it.visiting )
  // return;

  // if( !it.iterable )
  // it.onTerminal();

  it.visitPop();

}

//

/**
 * @function visitDownEnd
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function visitDownEnd()
{
  let it = this;
}

//

function visitPush()
{
  let it = this;

  if( it.iterator.visitedContainer )
  if( it.visitCounting && it.iterable )
  {
    it.iterator.visitedContainer.push( it.src );
    it.visitCounting = true;
  }

}

//

function visitPop()
{
  let it = this;

  if( it.iterator.visitedContainer && it.iterator.revisiting !== 0 )
  if( it.visitCounting && it.iterable )
  if( _.arrayIs( it.iterator.visitedContainer.original ) || !it.revisited )
  {
    if( _.arrayIs( it.iterator.visitedContainer.original ) )
    _.assert
    (
      Object.is( it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ], it.src ),
      () => `Top-most visit ${it.path} does not match ${it.src} <> ${it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ]}`
    );
    it.iterator.visitedContainer.pop( it.src );
    it.visitCounting = false;
  }

}

//

/**
 * @function canVisit
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function canVisit()
{
  let it = this;

  if( !it.recursive && it.down )
  return false;

  // if( !it.withStem && it.root === it.src )
  // return false;

  return true;
}

//

/**
 * @function canAscend
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function canAscend()
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
  else if( it.revisited )
  return false;

  _.assert( _.numberIs( it.recursive ) );
  if( it.recursive > 0 && !it.fast )
  if( !( it.level < it.recursive ) )
  return false;

  return true;
}

//

function canSibling()
{
  let it = this;

  if( !it.continue || it.continue === _.dont )
  return false;

  if( !it.iterator.continue || it.iterator.continue === _.dont )
  return false;

  return true;
}

//

function ascend( onIteration )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( _.routineIs( onIteration ) );
  _.assert( onIteration.length === 0 || onIteration.length === 1 );
  _.assert( !!it.continue );
  _.assert( !!it.iterator.continue );
  _.assert( _.routineIs( it.ascendAct ), `Expects routine {- ascendAct -}` )

  return it.ascendAct( onIteration, it.src );
  // return it._ascend( onIteration, it.src );
}

// //
//
// function _ascend( onIteration )
// {
//   let it = this;
//
//   _.assert( arguments.length === 1 );
//
//   if( _.arrayLike( it.src ) )
//   {
//     it.iterable = 'long-like';
//     return it._longAscend( onIteration );
//   }
//   else if( _.mapLike( it.src ) )
//   {
//     it.iterable = 'map-like';
//     return it._mapAscend( onIteration );
//   }
//   else if( _.hashMapLike( it.src ) )
//   {
//     it.iterable = 'hash-map-like';
//     return it._hashMapAscend( onIteration );
//   }
//   else if( _.setLike( it.src ) )
//   {
//     it.iterable = 'set-like';
//     return it._setAscend( onIteration );
//   }
//   else
//   {
//     it.iterable = false;
//     return it._termianlAscend( onIteration );
//   }
//
// }

//

function _longAscend( onIteration, src )
{
  let it = this;

  if( it.fast )
  var newIt = it.iterationMake();

  for( let k = 0 ; k < src.length ; k++ )
  {
    let e = src[ k ];
    let eit;

    if( it.fast )
    eit = newIt.select( e, k );
    else
    eit = it.iterationMake().select( e, k );

    onIteration.call( it, eit );

    if( !it.canSibling() )
    break;
  }

}

//

function _mapAscend( onIteration, src )
{
  let it = this;

  if( it.fast )
  var newIt = it.iterationMake();

  for( let k in src )
  {
    let e = src[ k ];
    let eit;

    if( it.fast )
    eit = newIt.select( e, k );
    else
    eit = it.iterationMake().select( e, k );

    onIteration.call( it, eit );

    if( !it.canSibling() )
    break;

  }

}

//

function _hashMapAscend( onIteration, src )
{
  let it = this;

  if( it.fast )
  var newIt = it.iterationMake();

  for( var [ k, e ] of src )
  {
    let eit;

    if( it.fast )
    eit = newIt.select( e, k );
    else
    eit = it.iterationMake().select( e, k );

    onIteration.call( it, eit );

    if( !it.canSibling() )
    break;

  }

}

//

function _setAscend( onIteration, src )
{
  let it = this;

  if( it.fast )
  var newIt = it.iterationMake();

  for( let e of src )
  {
    let k = e;
    let eit;

    if( it.fast )
    eit = newIt.select( e, k );
    else
    eit = it.iterationMake().select( e, k );

    onIteration.call( it, eit );

    if( !it.canSibling() )
    break;

  }

}

//

function _termianlAscend( onIteration, src )
{
  let it = this;

  it.onTerminal( src );

}

//

function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0 );

  it.iterableEval();

  if( it.onSrcChanged )
  {
    it.onSrcChanged();
  }

  it.revisitedEval();

}

//

function iterableEval()
{
  let it = this;

  _.assert( arguments.length === 0 );

  if( _.arrayLike( it.src ) )
  {
    it.iterable = 'long-like';
    it.ascendAct = it._longAscend;
  }
  else if( _.mapLike( it.src ) )
  {
    it.iterable = 'map-like';
    it.ascendAct = it._mapAscend;
  }
  else if( _.hashMapLike( it.src ) )
  {
    it.iterable = 'hash-map-like';
    it.ascendAct = it._hashMapAscend;
  }
  else if( _.setLike( it.src ) )
  {
    it.iterable = 'set-like';
    it.ascendAct = it._setAscend;
  }
  else
  {
    it.iterable = false;
    it.ascendAct = it._termianlAscend;
  }

}

//

function revisitedEval()
{
  let it = this;

  _.assert( arguments.length === 0 );

  if( it.iterator.visitedContainer )
  if( it.iterable )
  {
    if( it.iterator.visitedContainer.has( it.src ) )
    it.revisited = true;
  }

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

function onSrcChanged()
{
}

//

function onPathJoin( selectorPath, upToken, defaultUpToken, selectorName )
{
  let it = this;
  let result;

  _.assert( arguments.length === 4 );

  if( _.strEnds( selectorPath, upToken ) )
  {
    result = selectorPath + selectorName;
  }
  else
  {
    result = selectorPath + defaultUpToken + selectorName;
  }

  return result;
}

// --
// relations
// --

/**
 * Default options for {@link module:Tools/base/Looker.Looker.look} routine.
 * @typedef {Object} Defaults
 * @property {Function} onUp
 * @property {Function} onDown
 * @property {Function} onTerminal
 * @property {Function} ascend
 * @property {Function} onIterable
 * @property {Boolean} own = 0;
 * @property {Number} recursive = Infinity
 * @property {Boolean} trackingVisits = 1
 * @property {String} upToken = '/'
 * @property {String} path = null
 * @property {Number} level = 0
 * @property {Number} logicalLevel = 0
 * @property {*} src = null
 * @property {*} root = null
 * @property {*} context = null
 * @property {Object} Looker = null
 * @property {Object} it = null
 * @property {Boolean} iterationPreserve = null
 * @property {*} iterationExtension = null
 * @property {*} iteratorExtension = null
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

let Defaults = Object.create( null );

Defaults.onUp = onUp;
Defaults.onDown = onDown;
Defaults.onTerminal = onTerminal;
Defaults.onSrcChanged = onSrcChanged;
Defaults.onPathJoin = onPathJoin;
// Defaults.own = 0;
Defaults.fast = 0;
Defaults.recursive = Infinity;
// Defaults.withStem = 1;
// Defaults.trackingVisits = 1; /* xxx */
Defaults.revisiting = 0;
Defaults.upToken = '/';
Defaults.defaultUpToken = null;
Defaults.path = null;
Defaults.level = 0;
Defaults.logicalLevel = 0;
Defaults.src = null;
Defaults.root = null;
Defaults.context = null;
Defaults.Looker = null;
Defaults.it = null;
Defaults.iterationPreserve = null;
Defaults.iterationExtension = null;
Defaults.iteratorExtension = null;

//

/**
 * @typedef {Object} looker
 * @property {Object} Looker
 * @property {Object} Iterator
 * @property {Object} Iteration
 * @property {Boolean} IterationPreserve
 * @property {} iterator
 * @memberof module:Tools/base/Looker.Tools( module::Looker ).Defaults
 */

let Looker = Defaults.Looker = Object.create( null );

Looker.constructor = function Looker(){};
Looker.Looker = Looker;
Looker.Iterator = null;
Looker.Iteration = null;
Looker.IterationPreserve = null;

Looker.iteratorIs = iteratorIs;
Looker.iteratorMake = iteratorMake;

Looker.iterationIs = iterationIs,
Looker.iterationMake = iterationMake;
Looker.iterationRemake = iterationRemake;
Looker.iterationMakeAct = iterationMakeAct;
Looker.select = select;

Looker.look = look;
Looker.visitUp = visitUp;
Looker.visitUpBegin = visitUpBegin;
Looker.visitUpEnd = visitUpEnd;
Looker.visitDown = visitDown;
Looker.visitDownBegin = visitDownBegin;
Looker.visitDownEnd = visitDownEnd;
Looker.visitPush = visitPush;
Looker.visitPop = visitPop;
Looker.canVisit = canVisit;

Looker.canAscend = canAscend;
Looker.canSibling = canSibling;
Looker.ascend = ascend;
// Looker._ascend = _ascend;
Looker._longAscend = _longAscend;
Looker._mapAscend = _mapAscend;
Looker._hashMapAscend = _hashMapAscend;
Looker._setAscend = _setAscend;
Looker._termianlAscend = _termianlAscend;
Looker.srcChanged = srcChanged;
Looker.iterableEval = iterableEval;
Looker.revisitedEval = revisitedEval;

//

/**
 * @typedef {Object} Iterator
 * @property {} iterator = null
 * @property {} iterationMakeAct = iterationMakeAct
 * @property {} iterationMake = iterationMake
 * @property {} iterationRemake = iterationRemake
 * @property {} select = select
 * @property {} look = look
 * @property {} visitUp = visitUp
 * @property {} visitUpBegin = visitUpBegin
 * @property {} visitUpEnd = visitUpEnd
 * @property {} visitDown = visitDown
 * @property {} visitDownBegin = visitDownBegin
 * @property {} visitDownEnd = visitDownEnd
 * @property {} canVisit = canVisit
 * @property {} canAscend = canAscend
 * @property {} path = null
 * @property {} lastPath = null
 * @property {} lastSelected = null
 * @property {} continue = true
 * @property {} key = null
 * @property {} error = null
 * @property {} visitedContainer = null
 * @memberof module:Tools/base/Looker.Tools( module::Looker ).Defaults.Looker
 */

let Iterator = Looker.Iterator = Object.create( null );

Iterator.iterator = null;
Iterator.path = null;
Iterator.lastPath = null;
Iterator.lastSelected = null;
Iterator.continue = true;
Iterator.key = null;
Iterator.error = null;
Iterator.visitedContainer = null;

_.mapSupplement( Iterator, Defaults );
Object.freeze( Iterator );

//

/**
 * @typedef {Object} Iteration
 * @property {} childrenCounter = 0
 * @property {} level = 0
 * @property {} logicalLevel = 0
 * @property {} path = '/'
 * @property {} key = null
 * @property {} index = null
 * @property {} src = null
 * @property {} continue = true
 * @property {} ascending = true
 * @property {} revisited = false
 * @property {} _ = null
 * @property {} down = null
 * @property {} visiting = false
 * @property {} iterable = null
 * @property {} visitCounted = 1
 * @memberof module:Tools/base/Looker.Tools( module::Looker ).Defaults.Looker
 */

let Iteration = Looker.Iteration = Object.create( null );
Iteration.childrenCounter = 0;
Iteration.level = 0,
Iteration.logicalLevel = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.index = null;
Iteration.src = null;
Iteration.continue = true;
Iteration.ascending = true;
Iteration.ascendAct = null;
Iteration.revisited = false; /* xxx */
Iteration._ = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.visitCounting = true;
Object.freeze( Iteration );

//

/**
 * @typedef {Object} IterationPreserve
 * @property {} level = null
 * @property {} path = null
 * @property {} src = null
 * @memberof module:Tools/base/Looker.Tools( module::Looker ).Defaults.Looker
 */

let IterationPreserve = Looker.IterationPreserve = Object.create( null );
IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = null;
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

  if( o.iterationPreserve )
  o.iterationExtension = _.mapSupplement( o.iterationExtension, o.iterationPreserve );
  if( o.iterationPreserve )
  o.iteratorExtension = _.mapSupplement( o.iteratorExtension, o.iterationPreserve );

  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( _.objectIs( o.Looker ), 'Expects options {o.Looker}' );
  _.assert( o.Looker.Looker === o.Looker );
  _.assert( o.looker === undefined );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should expect exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onDown should expect exactly three arguments' );
  _.assert( _.intIs( o.recursive ), 'Expects integer {- o.recursive -}' );

  if( o.Looker === null )
  o.Looker = Looker;

  if( o.it === null || o.it === undefined )
  {
    let iterator = o.Looker.iteratorMake( o );
    o.it = iterator.iterationMake();
    return o.it;
  }
  else
  {

    let iterator = o.it.iterator;
    for( let k in o )
    {
      if( iterator[ k ] === null && o[ k ] !== null && o[ k ] !== undefined )
      {
        iterator[ k ] = o[ k ];
      }
    }

    return o.it;
  }

}

//

function look_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.Looker ) );
  _.assert( _.isPrototypeOf( it.Looker, it ) );
  _.assert( it.looker === undefined );
  return it.look();
}

look_body.defaults = Object.create( Defaults );

//

/**
 * @function look
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

let lookAll = _.routineFromPreAndBody( look_pre, look_body );

var defaults = lookAll.defaults;
// defaults.own = 0;
defaults.recursive = Infinity;

//

// /**
//  * @function lookOwn
//  * @memberof module:Tools/base/Looker.Tools( module::Looker )
//  */
//
// let lookOwn = _.routineFromPreAndBody( look_pre, look_body );
//
// var defaults = lookOwn.defaults;
// defaults.own = 1;
// defaults.recursive = Infinity;

//

/**
 * @function lookerIs
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

function lookerIs( looker )
{
  if( !looker )
  return false;
  if( !looker.Looker )
  return false;
  return _.isPrototypeOf( looker, looker.Looker );
}

//

/**
 * @function lookIteratorIs
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

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

/**
 * @function lookIterationIs
 * @memberof module:Tools/base/Looker.Tools( module::Looker )
 */

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

let NamespaceExtension =
{

  Looker,
  ErrorLooking,

  look : lookAll,
  lookAll,
  // lookOwn,

  lookerIs,
  lookIteratorIs,
  lookIterationIs,

}

let Self = Looker;
_.mapSupplement( _, NamespaceExtension );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
