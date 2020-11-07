////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ICollection.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.collections{	public interface ICollection	{				/**		 *	Adds data to the collection.		 */		function add(data:*):void;				/**		 *	Removes an element from the collection with the specified data.		 */		function remove(data:*):*								/**		 *	Removes all elements from the list but does not free data.		 */		function clear():void;		/**		 *	Destroys the entire collection.		 */		function destroy():void;								/**		 *	Checks if the collection has an element with the specified data.		 */		function contains(data:*):Boolean;		/**		 *	Returns the size as boolean of the collection.		 */		function isEmpty():Boolean;				/**		 *	Returns the size of the collection.		 */		function size():uint;						/**		 *	Applies a function to every element in the collection.		 */		function map(f:Function):void;				/**		 *	Applies a function to every element in the colection in reverse order.		 */		function backMap(f:Function):void;								/**		 *	Returns the collection represented by an unsorted array.		 */		function toArray():Array;		/**		 *	Returns the collection represented by a string literal.		 */		function toString():String;	}	}