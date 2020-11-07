////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PathCollectionIterator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.paths
{

import id.utils.Iterator;
import flash.geom.Point;

public class PathCollectionIterator implements Iterator
{
	
	private var normalized:Vector.<Point>;
	//private var _normalized_x:Array;
	//private var _normalized_y:Array;
	
	//private var _size:int;
	
	private var position:int;
	
	//public function PathCollectionIterator(normalized_x:Array, normalized_y:Array, size:int)
	public function PathCollectionIterator(normalized:Vector.<Point>)
	{
		super();
		
		this.normalized = normalized;
		
		//_normalized_x = normalized_x;
		//_normalized_y = normalized_y;
		
		//_size = size;
	}
	
	public function get next():*
	{
		return hasNext() ? normalized[position++] : null ;
	}
	
	public function get size():int
	{
		return normalized.length;
	}
	
	public function reset():void
	{
		position = 0;
	}
	
	public function hasNext():Boolean
	{
		return normalized.length >= position + 1;
	}
	
}

}