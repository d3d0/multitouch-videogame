////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ActivatorEvent.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.events
{

import id.core.ITactualObject;

import flash.display.InteractiveObject;
import flash.events.Event;

/**
 * The GestureEvent class provides a reference to all available gesture analysis modules
 * via their package path and class name.
 * 
 * <pre>
 * <b>GestureWorks currently supports:</b>
 *  GestureFlick
 *  GestureRotate
 *  GestureScale
 *  GestureScroll
 * </pre>
 * 
 * <p>Gesture3DRotate should be implemented at or mid alpha release, Implementation is is
 * simply a matter of migrating code from a previous version of the gesture module.</p>
 */
public dynamic class ActivatorEvent extends Event implements IDescriptorEvent
{
	
	public static const RELEASE:String = "activatorRelease";
		
	/**
	 * @private
	 */
	protected var _localX:Number;
	
	/**
	 * @private
	 */
	protected var _localY:Number;
	
	/**
	 * @private
	 */
	protected var _stageX:Number;
	
	/**
	 * @private
	 */
	protected var _stageY:Number;
	
	/**
	 * @private
	 */
	protected var _relatedObjects:Array;
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * Default constructor.
     */
	public function ActivatorEvent
	(
	 	type:String, bubbles:Boolean = false, cancelable:Boolean = false,
		localX:Number = NaN, localY:Number = NaN,
		stageX:Number = NaN, stageY:Number = NaN,
		relatedObject:InteractiveObject = undefined,
		tactualObjects:Array = null
	)
	{
		super(type, bubbles, cancelable);
		
		_localX = localX;
		_localY = localY;
		
		_stageX = stageX;
		_stageY = stageY;
		
		_relatedObject = relatedObject;
		_tactualObjects = [];
		
		if(tactualObjects)
		for(var idx:uint=0; idx<tactualObjects.length; idx++)
		{
			_tactualObjects.push(tactualObjects[idx]);
		}
	}
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	/**
	 * Indicates whether the Alt key is active (true) or inactive (false).
	 */
	public function get altKey():Boolean { return false; }
	public function set altKey(value:Boolean):void
	{
	}
	
	/**
	 * Indicates whether the command key is activated (Mac only).
	 */
	public function get commandKey():Boolean { return false; }
	public function set commandKey(value:Boolean):void
	{
	}
	
	/**
	 * Indicates whether the Control key is activated on Mac and
	 * whether the Ctrl key is activated on Windows or Linux.
	 */
	public function get controlKey():Boolean { return false; }
	public function set controlKey(value:Boolean):void
	{
	}
	
	/**
	 * On Windows or Linux, indicates whether the Ctrl key is
	 * active (true) or inactive (false).
	 */
	public function get ctrlKey():Boolean { return false; }
	public function set ctrlKey(value:Boolean):void
	{
	}
	
	/**
	 * Indicates whether the Shift key is active (true) or inactive (false).
	 */
	public function get shiftKey():Boolean { return false; }
	public function set shiftKey(value:Boolean):void
	{
	}
	
	/**
	 * Returns the horizontal position as a number local to the object
	 * the TouchEvent is raised.
	 */
	public function get localX():Number { return _localX; }
	public function set localX(value:Number):void
	{
	}
	
	/**
	 * Returns the vertical position as a number local to the object
	 * the TouchEvent is raised.
	 */
	public function get localY():Number { return _localY; }
	public function set localY(value:Number):void
	{
	}
	
	/**
	 * Return the horizontal position as a number relative to the 
	 * stage.
	 */
	public function get stageX():Number { return _stageX; }
	
	/**
	 * Returns the vertical position as a number relative to the
	 * stage.
	 */
	public function get stageY():Number { return _stageY; }
	
	/**
	 * A reference to a display list object that is related to the event.
	 */
	public function get relatedObject():InteractiveObject { return _relatedObject; }
	public function set relatedObject(value:InteractiveObject):void
	{
		_relatedObject = value;
	}
	
	 /**
	  * Returns a collection of <code>ITactualObjects</code> which cased the
	  * GestureEvent to be raised at its target.
	  */
	public function get tactualObjects():Array { return _tactualObjects; }

	////////////////////////////////////////////////////////////
	// Methods: Overrides
	////////////////////////////////////////////////////////////
	override public function clone():Event {
		var event:ActivatorEvent = new ActivatorEvent(type, bubbles, cancelable);

		for (var p:String in this)
		{
			event[p] = this[p];
		}

		return event;
	}
	
	
}

}