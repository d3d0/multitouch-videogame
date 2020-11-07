////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IDescriptor.as
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

import id.tracker.ITracker;

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
import flash.geom.Point;

public interface IDescriptor extends IEventDispatcher
{
	
	/**
	 * @private
	 */
	function get priority():uint;
	
	/**
	 * The required number of <code>ITactualObject</code>s required for the
	 * analysis module.
	 */
	function get objCount():uint;
	function get objCountMax():int;
	function get objCountMin():int;
	
	/**
	 * The required 
	 * The required number of <code>ITactualObject</code>s required for the
	 * analysis module in
	 */
	//function get objCountOwnerAffinity():uint;
	
	/**
	 * The required state of the <code>ITactualObject</code>s required for the
	 * analysis module.
	 */
	function get objState():uint;
	
	/**
	 * The required object type of the <code>ITactualObject</code>s required for
	 * the analysis module.
	 */
	function get objType():uint;
	
	/**
	 * The required number of histories of the <code>ITactualObject</code> required
	 * for the analysis module.
	 */
	function get objHistoryCount():uint;
	
	/**
	 * Defines whether the gesture analysis module prevents further use of the specified
	 * <code>ITactualObject</code>s after initial processing.
	 */
	//function get restrictive():Boolean;
	
	function get cache():*;
	function set cache(value:*):void;
	
	function get tracker():ITracker;
	function set tracker(value:ITracker):void;
	
	/**
	 * A gesture may choose to disable others with lower priority.  e.g. Gesture_Hold,
	 * which invovles all five points of the hand, would idealy disable Touch_Move.
	 */
	function get disables():Array;

	function get eventTarget():DisplayObject;
	function set eventTarget(value:DisplayObject):void;

	/**
	 * These methods allow the gesture to push and pull history, from the last successful
	 * return, into the touch object.
	 */
	function get history():Object;
	function set history(value:Object):void;

	/**
	 * Not yet hooked up.
	 */
	function get referencePoint():Point;
	function set referencePoint(value:Point):void;
	
	/**
	 * Returns the gesture's full name inclusive of its package.
	 */
	function get name():String;
	
	/**
	 * Returns the gesture's shortname.
	 */
	function get shortName():String;
	
	/**
	 * @private
	 * 
	 * @param	gesture
	 * @return
	 */
	function compareTo(gesture:IDescriptor):int;

	/**
	 * Main entrypoint into specific analysis module processing.  This is called
	 * automatically by the <code>TouchObject</code> or <code>TouchMovieClip</code>
	 * at the end of its validation cycle.
	 * 
	 * <p>Each gesture has a specific set of return values.  Please reference the
	 * documentation for more information.</p>
	 * 
	 * @param	tactualObjects A collection of <code>ITactualObjects</code> required by
	 *   the analysis module.
	 * @return	The analysis module's result as an associative array.
	 */
	function process(... tactualObjects:Array):Object;

}

}