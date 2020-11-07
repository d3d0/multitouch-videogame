////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IList.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.collections.lists{		import id.collections.ICollection;		public interface IList extends ICollection	{				function getFirst():*;		function getLast():*;		function getElementAt(index:int):*;				function insertFirst(data:*):Boolean;		function insertLast(data:*):Boolean;		function insertAt(index:int, data:*):Boolean;				function removeFirst():*;		function removeLast():*;		function removeElementAt(index:int):*;		//function removeDataItem(data:*, compar:Function):*;				//function find(data:*, compar:Function);		//function findFromIndex(index:int, data:*, compar:Function):*;					}	}