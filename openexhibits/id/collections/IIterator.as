////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IIterator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.collections
{
	
	public interface IIterator
	{
		
		function current():*;
		
		/**
		 *	Checks to see if another object exists in the collection
		 */
		function hasNext():Boolean;
		
		/**
		 *	Returns the next object in the collection
		 */
		function next():*;
		
		/**
		 *	Resets the iterator.
		 */
		function reset():void;
		
		/**
		 *	Returns the iterator index key
		 */
		function key():uint;
		
		/**
		 *	Removes the last object returned by the iterator.
		 */
		//function remove():Boolean;
	}
	
}