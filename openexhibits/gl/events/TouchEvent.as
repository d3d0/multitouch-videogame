////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchEvent.as
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

import id.core.id_internal;
import id.core.ITactualObject;

import flash.display.InteractiveObject;
import flash.events.Event;

use namespace id_internal;

/**
 * The TouchEvent class provides a reference to all available touch analysis modules via their
 * package path and class name.
 * 
 * <pre>
 * <b>GestureWorks currently supports:</b>
 *  TouchDown
 *  TouchMove
 *  TouchUp
 *  TouchTap
 *  TouchDoubleTap
 * </pre>
 * 
 * <p>Due to the intrinsic nature of the tracker, TouchDoubleTap is by no means a forced analysys.
 * If desired, TouchTrippleTap and Touch_N_Tap are available pathways for development.</p>
 * 
 * <p>Note: TouchHold will not be supported until id.core.ClusterTypes is implemented. TouchIn
 * and TouchOut are also not implemented due to <code>ITactualObject</code> child reassociation
 * forcefully disabled.  <code>ITactualObject</code> child rediscovery will become enabled
 * after, again, id.core.ClusterTypes is fully implemented.  Reasons for disabling the above
 * are related to increases in front end performance.</p>
 */
public dynamic class TouchEvent extends Event implements IDescriptorEvent
{
	
	/**
	 * The TouchEvent.TOUCH_DOWN constant defines the value of the touch analysis module class
	 * for a touch down event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchDown"
	 */
	public static const TOUCH_DOWN:String = "touchDown";
	
	/**
	 * The TouchEvent.TOUCH_HOLD constant defines the value of the touch analysis module class
	 * for a touch hold event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchHold"
	 */
	public static const TOUCH_HOLD:String = "touchHold";
	
	/**
	 * The TouchEvent.TOUCH_MOVE constant defines the value of the touch analysis module class
	 * for a touch move event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchMove"
	 */
	public static const TOUCH_MOVE:String = "touchMove";
	
	/**
	 * The TouchEvent.TOUCH_UP constant defines the value of the touch analysis module class
	 * for a touch up event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchUp"
	 */
	public static const TOUCH_UP:String = "touchUp";
	
	/**
	 * The TouchEvent.TOUCH_IN constant defines the value of the touch analysis module class
	 * for a touch in event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchIn"
	 */
	public static const TOUCH_IN:String = "touchIn";
	
	/**
	 * The TouchEvent.TOUCH_OUT constant defines the value of the touch analysis module class
	 * for a touch out event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchOut"
	 */
	public static const TOUCH_OUT:String = "touchOut";
	
	/**
	 * The TouchEvent.TOUCH_TAP constant defines the value of the touch analysis module class
	 * for a touch tap event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchTap"
	 */
	public static const TOUCH_TAP:String = "touchTap";
	
	/**
	 * The TouchEvent.TOUCH_DOUBLE_TAP constant defines the value of the touch analysis module
	 * class for a touch double tap.
	 * 
	 * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>true</td></tr>
     *   <tr><td><code>cancelable</code></td><td>true</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The object that is currently
	 *     processing the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The object that dispatched the event;
     *     it is not always the object that is currently processing the event.  Use
	 *     the <code>currentTarget</code> property to access the object at which the
	 *     event has bubbled to.</td></tr>
     * </table>
	 * 
	 * @eventType "touchDoubleTap"
	 */
	public static const TOUCH_DOUBLE_TAP:String = "touchDoubleTap";
	
	
	/**
	 * @private
	 */
	protected var _isPrimaryTouchPoint:Boolean;

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
	protected var _relatedObject:InteractiveObject;
	
	/**
	 * @private
	 */
	protected var _touchPointID:int;
	
	
	/**
	 * @private
	 */
	id_internal var _stageX:Number;
	
	/**
	 * @private
	 */
	id_internal var _stageY:Number;
	
	/**
	 * @private
	 */
	id_internal var _tactualObject:ITactualObject;
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * Default constructor.
     */
	public function TouchEvent
	(
		type:String,
		bubbles:Boolean = false,
		cancelable:Boolean = false,
		
		touchPointID:int = 0,
		isPrimaryTouchPoint:Boolean = false,
		
		localX:Number = NaN,
		localY:Number = NaN,
		
		sizeX:Number = NaN,
		sizeY:Number = NaN,
		pressure:Number = NaN,

		relatedObject:InteractiveObject = undefined,
		
		ctrlKey:Boolean = false,
		altKey:Boolean = false,
		shiftKey:Boolean = false,
		commandKey:Boolean = false,
		controlKey:Boolean = false
	)
	{
		super(type, bubbles, cancelable);
		
		_touchPointID = touchPointID;
		_isPrimaryTouchPoint = isPrimaryTouchPoint;
		
		_localX = localX;
		_localY = localY;
		
		_relatedObject = relatedObject;
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
	 * Indicates wether or not this TouchEvent was generated by the first point
	 * of interest 
	 */
	public function get isPrimaryTouchPoint():Boolean { return _isPrimaryTouchPoint; }
	public function set isPrimaryTouchPoint(value:Boolean):void
	{
		_isPrimaryTouchPoint = value;
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
	 * Returns the horizontal position as a number relative to the 
	 * stage.
	 */
	public function get stageX():Number { return _stageX; }
	
	/**
	 * Returns the vertical posiiton as a number relative to the
	 * stage.
	 */
	public function get stageY():Number { return _stageY; }

	/**
	 *  A reference to the container which generated this TouchEvent.
	 *  The container does not necessairly represent the target, but rather
	 *  the object which is processing gestures; most commonly the point/blob
	 *  container.
	 *
	 *  @see id.core.ITouchObject#blobContainerEnabled
	 */
	public function get relatedObject():InteractiveObject { return _relatedObject; }
	public function set relatedObject(value:InteractiveObject):void
	{
		_relatedObject = value;
	}
    
    /**
     *  Returns the tactual object which caused the TouchEvent to
     *  be raised at its target.
     *  
     *  @see id.core.ITactualObject
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
	 *  @playerversion Flash Lite 4.0
     */
	public function get tactualObject():ITactualObject { return _tactualObject; }

	////////////////////////////////////////////////////////////
	// Methods: Overrides
	////////////////////////////////////////////////////////////
	override public function clone():Event {
		var event:TouchEvent = new TouchEvent(type, bubbles, cancelable);

		for (var p:String in this)
		{
			event[p] = this[p];
		}

		return event;
	}
	
}
	
}