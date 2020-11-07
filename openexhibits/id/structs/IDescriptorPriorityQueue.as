////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2010 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     IDescriptorPriorityQueue.as
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
public interface IDescriptorPriorityQueue
{

	function get next():IDescriptor;
	function get prev():IDescriptor;
	
	function addDescriptor(descriptor:IDescriptor):void;
	function removeDescriptor(descriptor:IDescriptor):void;

	function hasNext():Boolean;
	function hasPrev():Boolean;
	
	function clear():void;
	function destroy():void;
	function reset():void;
	
	function isEmpty():Boolean;

}

}