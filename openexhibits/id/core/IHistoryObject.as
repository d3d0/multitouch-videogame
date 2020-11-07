////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IHistoryObject.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{

import flash.events.IEventDispatcher;

/**
 * The HistoryObject Interface defines fundumental behavior for objects 
 * that wish to maintain object states as histories.
 */
public interface IHistoryObject extends IEventDispatcher
{
	
	/**
	 * Returns the creation time of the object in application ms.
	 */
	function get creationTime():Number;
	
	/**
	 * Returns the last history segment.
	 */
	function get history():Vector.<Object>;
	
	/**
	 * Returns the combined history.
	 */
	function get combinedHistory():Vector.<Object>

	/**
	 * Forces the object implementing this interface to record its current
	 * state.
	 */
	function pushSnapshot():void;
	
	/**
	 * Forces the object implementing this interface to segment its history,
	 * effectively re-establishing the beginning of this object's history
	 * at the time of segmentation.
	 */
	function segment():void;
	
	/**
	 * Returns an object representing the current state of this object.
	 */
	function info():Object;
	
	/**
	 * Returns the string representation of the params associated with this
	 * object.
	 */
	function toString():String;
}
	
}