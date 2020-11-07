////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IDescriptorEvent.as
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

import flash.display.InteractiveObject;

/**
 * The IDescriptorEvent interface is implemented by every gesture event type for
 * presumed emumeration support via <code>list()</code>.
 */
public interface IDescriptorEvent
{
	
	/**
	 * Indicates whether the Alt key is active (true) or inactive (false).
	 */
	function get altKey():Boolean;
	function set altKey(value:Boolean):void;
	
	/**
	 * Indicates whether the command key is activated (Mac only).
	 */
	function get commandKey():Boolean;
	function set commandKey(value:Boolean):void;
	
	/**
	 * Indicates whether the Control key is activated on Mac and
	 * whether the Ctrl key is activated on Windows or Linux.
	 */
	function get controlKey():Boolean;
	function set controlKey(value:Boolean):void;
	
	/**
	 * On Windows or Linux, indicates whether the Ctrl key is
	 * active (true) or inactive (false).
	 */
	function get ctrlKey():Boolean;
	function set ctrlKey(value:Boolean):void;
	
	/**
	 * Indicates whether the Shift key is active (true) or inactive (false).
	 */
	function get shiftKey():Boolean;
	function set shiftKey(value:Boolean):void;
	
	
	
	/**
	 * The horizontal position as a number local to the object
	 * the TouchEvent is raised.
	 */
	function get localX():Number;
	function set localX(value:Number):void;
	
	/**
	 * The vertical position as a number local to the object
	 * the TouchEvent is raised.
	 */
	function get localY():Number;
	function set localY(value:Number):void;
	
	/**
	 * Returns the horizontal position as a number relative to the 
	 * stage.
	 */
	function get stageX():Number;
	
	/**
	 * Returns the vertical posiiton as a number relative to the
	 * stage.
	 */
	function get stageY():Number;



	/**
	 * A reference to a display list object that is related to the event.
	 */
	function get relatedObject():InteractiveObject;
	function set relatedObject(value:InteractiveObject):void;
	
}
	
}