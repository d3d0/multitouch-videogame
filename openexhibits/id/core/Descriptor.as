////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Descriptor.as
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

import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.utils.getQualifiedClassName;
import flash.display.DisplayObject;

//use namespace id_internal;
	
public class Descriptor extends EventDispatcher implements IDescriptor
{
	
	/**
	 * @private
	 */
	protected var _priority:uint;
	
	/**
	 * @private
	 */
	protected var _objCount:uint;
	protected var _objCountMax:int = -1;
	protected var _objCountMin:int = -1;
	
	/**
	 * @private
	 */
	protected var _objState:uint;
	
	/**
	 * @private
	 */
	protected var _objType:uint;
	
	/**
	 * @private
	 */
	protected var _objHistoryCount:uint;
	
	/**
	 * @private
	 */
	//protected var _restrictive:Boolean;

	/**
	 * @private
	 */
	protected var _cache:*;

	/**
	 * @private
	 */
	protected var _disables:Array;

	/**
	 * @private
	 */
	protected var _eventTarget:DisplayObject;

	/**
	 * @private
	 */
	protected var _history:Object;
	
	/**
	 * @private
	 */
	protected var _referencePoint:Point;
	
	/**
	 * @private
	 */
	protected var _name:String;
	
	/**
	 * @private
	 */
	protected var _shortName:String;
	
	/**
	 * @private
	 */
	protected var _tracker:ITracker;

	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * Default constructor.
     */
	public function Descriptor() {
		super();
		
		initialize();
	}
	
	/**
	 * This method is called after the default constructor has finished.
	 */
	protected function initialize():void {
		// overrite me
	}

	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	/**
	 * @private
	 */
	public function get priority():uint { 
		if(!_priority)
		{
			_priority = _objCount * 10 + (_disables ? _disables.length : 0) ;// + _restrictive; 
		}
		
		return _priority;
	}
	
	/**
	 * The required number of <code>ITactualObjects</code> required for the
	 * analysis module.
	 * 
	 * @default 	undefined
	 */
	public function get objCount():uint { return _objCount; }
	public function get objCountMax():int { return _objCountMax; }
	public function get objCountMin():int { return _objCountMin; }
	
	/*
	 * @private
	 */
	/*id_internal function set objCount(value:uint):void
	{
		_objCount = value;
	}
	*/
	
	/**
	 * The required state of the <code>ITactualObjects</code> required for the
	 * analysis module.
	 * 
	 * @default 	undefined
	 */
	public function get objState():uint { return _objState; }
	
	/*
	 * @private
	 */
	/*id_internal function set objState(value:uint):void
	{
		_objState = value;
	}
	*/
	
	/**
	 * The required type of the <code>ITactualObjects</code> required for the
	 * analysis module.
	 * 
	 * @default 	undefined
	 */
	public function get objType():uint { return _objType; }
	
	/*
	 * @private
	 */
	/*id_internal function set objType(value:uint):void
	{
		_objType = value;
	}
	*/
	
	/**
	 * The required number of histories of the <code>ITactualObject</code> required
	 * for the analysis module.
	 * 
	 * @default 	undefined
	 */
	public function get objHistoryCount():uint { return _objHistoryCount; }
	
	/*
	 * @private
	 */
	/*id_internal function set objHistoryCount(value:uint):void
	{
		_objHistoryCount = value;
	}
	*/
	
	/**
	 * Defines whether the gesture analysis module prevents further use of the specified
	 * <code>ITactualObject</code>s after initial processing.  This flag enables a
	 * gesture to become decupled from the current <code>ITactualObject</code> environment. 
	 * 
	 * @default 	false
	 */
	//public function get restrictive():Boolean { return _restrictive; }

	/**
	 * A gesture may choose to disable others with lower priority.  e.g. Gesture_Hold, which
	 * invovles all five points of the hand, would idealy disable Touch_Move.
	 * 
	 * @default 	undefined
	 */
	public function get disables():Array { return _disables; }
	
	/*
	id_internal function set disables(value:Array):void
	{
		_disables = value;
	}
	*/

	public function get cache():* { return _cache; }
	public function set cache(value:*):void
	{
		_cache = value;
	}
	
	public function get tracker():ITracker { return _tracker; }
	public function set tracker(value:ITracker):void
	{
		_tracker = value;
	}

	public function get eventTarget():DisplayObject { return _eventTarget; }
	public function set eventTarget(value:DisplayObject):void
	{
		_eventTarget = value;
	}

	/**
	 * Not yet hooked up.
	 */
	public function get history():Object { return _history; }
	public function set history(value:Object):void {
		_history = value;
	}
	
	/**
	 * Not yet hooked up.
	 */
	public function get referencePoint():Point { return _referencePoint; }
	public function set referencePoint(value:Point):void {
		_referencePoint = value;
	}
	
	/**
	 * Returns the gesture's full name inclusive of its package.
	 */
	public function get name():String {
		if(!_name)
		{
			_name = getQualifiedClassName(this);
		}
		
		return _name;
	}
	
	/**
	 * Returns the gesture's shortname.
	 */
	public function get shortName():String {
		if(!_shortName)
		{
			var split:Array = _name.split("::");
			_shortName = split[split.length - 1];
		}
		
		return _shortName;
	}

	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	/**
	 * @private
	 * 
	 * @param	gesture
	 * @return
	 */
	public function compareTo(gesture:IDescriptor):int {
		return gesture.priority > _priority ? 1 : gesture.priority < _priority ? -1 : 0 ; 
	}
	
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
    public function process(... tactualObjects:Array):Object
    {
        return false;
    }
	
}

}