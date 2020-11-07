////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2010 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     DescriptorPriorityQueue.as
//  Author:   Chris Gerber (chris(at)ideum(dot)com)
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.structs
{

import id.core.IDescriptor;

/**
 * @private
 */
public class DescriptorPriorityQueue implements IDescriptorPriorityQueue
{
	
	include "../core/Version.as";
	
	/* variable */
	private var _position:int;
	
	/* objects */
	private var _queue:Array;
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	public function DescriptorPriorityQueue() {
		_queue = new Array();
		_position = -1;
	}
	
	public function get next():IDescriptor {
		_position++;
		return _queue[_position];
	}
	
	public function get prev():IDescriptor {
		_position--;
		return _queue[_position];
	}
	
	public function addDescriptor(descriptor:IDescriptor):void
	{
		_queue.splice(determineIndex(descriptor), 0, descriptor);
	}
	
	public function removeDescriptor(descriptor:IDescriptor):void {
		// implement this later...
		
		for(var idx:uint=0; idx<_queue.length; idx++)
		{
			if(_queue[idx].name == descriptor.name)
				break;
		}
		
		_queue.splice(idx, 1);
	}

	
	public function hasNext():Boolean {
		return (_queue.length && _position < _queue.length - 1);
	}
	
	public function hasPrev():Boolean {
		return (_queue.length && _position > 0);
	}
	
	
	public function clear():void {
		_queue = null;
		_queue = new Array();
	}
	
	public function destroy():void {
		// this would force the GM to reallocate it's gestures.
		// We do NOT want to do this...
	}
	
	public function reset():void {
		_position = -1;
	}
	
	public function isEmpty():Boolean {
		return _queue.length == 0;
	}
	
	private function determineIndex(descriptor:IDescriptor):int
	{
		for(var idx:uint=0; idx<_queue.length; idx++)
		{
			var target:IDescriptor = _queue[idx] as IDescriptor;
			if (target.priority < descriptor.priority)
				return idx;
		}
		
		return _queue.length;
	}

	/*
	private function binarySearch(descriptor:IDescriptor):int {
		var start:int = 0;
		var end:int = _queue.length - 1
		var target:int = 0;
		
		var value:int;
		
		while(start <= end) //<=
		{
			target = (start + end) / 2;
			
			value = (_queue[target] as IDescriptor).compareTo(descriptor);
			
			if(!value)
				return target;
			
			if(value > 0)
				end = target - 1;
			else
			if(value < 0)
				start = target + 1;
		}

		return value;
	}
	*/

	
}
	
}