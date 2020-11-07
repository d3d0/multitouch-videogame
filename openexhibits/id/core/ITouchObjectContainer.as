////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITouchObjectContainer.as
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

import flash.display.DisplayObject;
import flash.geom.Point;

public interface ITouchObjectContainer extends ITouchObject
{
	
	/**
	 * @private
	 *	This param establishes multi gesture support.  If Disabled, this
	 *	object will only support one gesture at a time.
	 */
	//function get multiGestureEnabled():Boolean;
	
	/**
	 * @private
	 */
	//function set multiGestureEnabled(value:Boolean):void;
	
	/**
	 * Determines wether or not the children of the object are touch enabled.  This
	 * is exactly comperable to <code>MouseChildren</code>.
	 * 
	 * @default	true
	 */
	function get touchChildren():Boolean;
	function set touchChildren(value:Boolean):void;
	
	/**
	 * Returns the number of overlays associated with a TouchObjectContainer
	 */
	//function get overlayReferenceCount():uint;
	
	/**
	 * Attaches a DisplayObject as a top most child and omits it from
	 * the processed display list.
	 * 
	 * @param	child The DisplayObject which to add
	 */
	function addChildOverlay(child:DisplayObject):void;
	
	/**
	 * Removes a DisplayObject from the top most children.
	 * 
	 * <p>Note: This method is not yet implemented and will throw an <code>ArgumentError</code></p>
	 * 
	 * @param	child The DisplayObject which to remove
	 */
	function removeChildOverlay(child:DisplayObject):void;
	
	/**
	 * Determines the topmost visible child which is touch enabled by diving into
	 * the application-child heirarchy via a Stage referenced Point.
	 * 
	 * @example This example provides psudo code to determine the top-most object
	 * furthest down the child heirarchy of a TouchObjectContainer based on Stage
	 * coordinates 0, 0.
	 * 
	 * <listing version="3.0">
	 * var pt:Point = new Point(0, 0);
	 * var ret:ITouchObject = someTouchObjectContainer.getTouchObjectUnderPoint(pt);
	 * 
	 * if(!ret)
	 *   return;
	 * 
	 * // Code execution block
	 * </listing>
	 * 
	 * @param	pt the point which to check against, normalized to the <code>Stage</code>
	 * @return	The <code>TouchObject</code> as a reference to its interface, <code>ITouchObject</code>
	 */
	function getTouchObjectUnderPoint(pt:Point):ITouchObject;

}
	
}