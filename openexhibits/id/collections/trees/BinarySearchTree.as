////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	BinarySearchTree.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.collections.trees{		import id.collections.ICollection;	import id.collections.IComparable;	import id.collections.IIterable;	import id.collections.IIterator;		public class BinarySearchTree implements ICollection, IComparable, IIterable	{				////////////////////////////////////////////////////////////		// Variables		////////////////////////////////////////////////////////////		private var _root:TreeNode;		private var _compareFunction:Function;				////////////////////////////////////////////////////////////		// Constructor: Default		////////////////////////////////////////////////////////////		public function BinarySearchTree() {						initialize();		}				////////////////////////////////////////////////////////////		// Methods: Initialization		////////////////////////////////////////////////////////////		private function initialize():void {					}				////////////////////////////////////////////////////////////		// Properties: Public		////////////////////////////////////////////////////////////		public function set compareFunction(value:Function):void {			_compareFunction = value;		}						////////////////////////////////////////////////////////////		// Methods: ICollection		////////////////////////////////////////////////////////////				//-----------------------------------		// Methods: Public		//-----------------------------------		public function add(data:*):void {					}		public function clear():void {					}				public function contains(data:*):Boolean {			return false;		}		public function destroy():void {				}		public function isEmpty():Boolean {			return false;		}		public function map(f:Function):void {					}				public function backMap(f:Function):void {					}				public function remove(data:*):* {			return null;		}		public function size():uint {			return NaN;		}		public function toArray():Array {			return null;		}		public function toString():String {			return null;		}						////////////////////////////////////////////////////////////		// Methods: IComparable		////////////////////////////////////////////////////////////				//-----------------------------------		// Methods: Public		//-----------------------------------		public function compareTo(obj:*):int {			//if(!_compareFunction)			//	return NaN;						return NaN;		}						////////////////////////////////////////////////////////////		// Methods: IComparable		////////////////////////////////////////////////////////////				//-----------------------------------		// Methods: Public		//-----------------------------------		public function iterator():IIterator {			return null;		}			}	}