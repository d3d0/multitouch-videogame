////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITactualObject.as
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

import id.aggregators.IAggregable;
import flash.display.DisplayObject;

/**
 * The TactualObject Interface acts as a base to both the <code>Blob</code> and
 * <code>Cluster</code> objects.  It is established to be flexable to eventually
 * support fiducials and other complex marker types.
 * 
 * <p>This interface describes a simple set of properties, associated with every
 * tactual object, such as position, positional change, and dimensions.  Also
 * packaged within this interface are function stubs that provide for validity
 * and param checking.</p>
 */
public interface ITactualObject extends IAggregable, IHistoryObject, IDisposable
{
	
	/**
	 * The ID of this TactualObject.
	 */
	function get id():int;
	function set id(value:int):void;
	
	/**
	 * Number that specifies the tactual object's horizontal position,
	 * in pixels, within the context of the application.
	 */
	function get x():Number;
	function set x(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's vertical position,
	 * in pixels, within the context of the application.
	 */
	function get y():Number;
	function set y(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's change in horizontal position,
	 * in pixels, within the context of the application.
	 */
	function get dx():Number;
	function set dx(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's change in vertical position,
	 * in pixels, within the context of the application.
	 */
	function get dy():Number;
	function set dy(value:Number):void;
	
	/**
	* Number that specifies the width of the tactual object's contact area.
	*/
	//function get sizeX():Number;
	//function set sizeX(value:Number):void;
	
	/**
	* Number that specifies the height of the tactual object's contact area.
	*/
	//function get sizeY():Number;
	//function set sizeY(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's force of contact.
	 */
	function get pressure():Number;
	function set pressure(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's width, in pixels.
	 */
	function get width():Number;
	function set width(value:Number):void;
	
	/**
	 * Number that specifies the tactual object's height, in pixels.
	 */
	function get height():Number;
	function set height(value:Number):void;
	
	/**
	 * Unsigned integer that specifies the lifecycles a tactual object
	 * has incurred.  This may be best described as the total number of
	 * times a tactual object has been placed, lifed, and placed again
	 * onto a multi touch enabled surface.
	 */
	function get existences():uint;
	function set existences(value:uint):void;
	
	/**
	 * The TactualObject's owner
	 */
	function get owner():DisplayObject;//ITouchObject;
	//function set owner(value:IEventDispatcher):void;
	
	/**
	 * The TactualObject's target
	 */
	function get target():DisplayObject;
	
	function get targetRediscovery():Boolean;
	function set targetRediscovery(value:Boolean):void;
	
	function get hasNewTarget():Boolean;
	function set hasNewTarget(value:Boolean):void;
	
	function get oldTarget():DisplayObject;
	
	/**
	 * Enumerated value that specifies the last action prefomed upon the
	 * tactual object by the <code>BlobManager</code>.
	 */
	function get state():uint;
	function set state(value:uint):void;
	
	/**
	 * Enumerated value that specifies the type of tactual object this
	 * is.
	 */
	 
	function get type():uint;
	function set type(value:uint):void;
	
	/**
	 * Used to determine the relation of one TactualObject to another.
	 * 
	 * @param	object The target which to compare against.
	 * @return	A value between 0 and 1, 0 being none, and 1 an exact match,
	 * which represents the relation of the TactualObject to its target.
	 */
	//function checkValidity(object:ITactualObject):Number;
	
	function discoverChild():void;
	function disposeChild():void;
	
	function discoverTarget():void;
	function disposeTarget():void;
	
	/**
	 * Used to determine if a TactualObject has values.
	 * @return
	 */
	function hasParams():Boolean;
	
	/**
	 * Called to show debug information by drawing into the target.
	 */
	//function draw(target:DisplayObject = null):void;
	
}
	
}