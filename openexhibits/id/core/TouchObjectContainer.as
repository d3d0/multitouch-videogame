////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchObjectContainer.as
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

import id.utils.NameUtil;
import id.utils.StringUtil;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;
import flash.geom.Point;

use namespace id_internal;

/**
 * The TouchObjectContainer class is the base class for all touch enabled
 * objects that require additional display list management. 
 * 
 * <pre>
 * 	<b>Properties</b>
 * 	 blobContainer="undefined"
 * 	 blobContainerEnabled="false"
 * 	 touchChildren="true"
 * 
 *   topLevel="false"
 * </pre>
 */
public class TouchObjectContainer extends TouchObject implements ITouchObjectContainer
{
	
	/* params */
	private var _defaults:Object =
	{
		touchChildren: true
	}
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * Default constructor.
     */
	public function TouchObjectContainer()
	{
		super();
		
		setParams({}, _defaults);
	}

	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	/**
	 * @private
	 */
	/*public function get multiGestureEnabled():Boolean { return _params.multiGestureEnabled; }*/
	
	/**
	 * @private
	 */
	/*public function set multiGestureEnabled(value:Boolean):void {
		// I considered switching on and off the ability to have multiple gestures preformed
		// on an object at the same time however, I instead chose to adheard to the existing
		// psudo ownership of objects to their first blob sets.
		
		_params.multiGestureEnabled = value;
	}*/
		
	/**
	 * Determines wether or not the children of the TouchObjectContainer are touch enabled.  This
	 * is exactly comperable to <code>MouseChildren</code>.
	 * 
	 * @default	true
	 */
	public function get touchChildren():Boolean { return _params.touchChildren; }
	public function set touchChildren(value:Boolean):void {
		if(value == _params.touchChildren)
			return;
			
		var n:int = numChildren;
		for(var idx:uint=0; idx<n; idx++)
		{
			var child:ITouchObjectContainer = getChildAt(idx) as ITouchObjectContainer;
			if (child)
			{
				child.touchChildren = value;
			}
		}
		
		_params.touchChildren = value;
	}
	
	////////////////////////////////////////////////////////////
	// Properties: Override
	////////////////////////////////////////////////////////////
	/**
	 * Returns the number of children of this object minus the
	 * <code>overlayReferenceCount</code>.
	 */
	override public function get numChildren():int {
		return super.numChildren - overlayReferenceCount;
	}
    
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
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
	public function getTouchObjectUnderPoint(pt:Point):ITouchObject
	{
		
		//trace("\n" + StringUtil.padLeft("", " ", NameUtil.displayObjectParentalCount(this)), name);
		
		var n:int = numChildren;
		for(var idx:int=n-1; idx>=0; idx--)
		{
			//var child:ITouchObjectContainer = getChildAt(idx) as ITouchObjectContainer;
			var dO:DisplayObject = getChildAt(idx);
			var child:ITouchObjectContainer = ((dO as Loader) ? (dO as Loader).content : dO) as ITouchObjectContainer ;
			
			//trace(StringUtil.padLeft("", " ", NameUtil.displayObjectParentalCount(getChildAt(idx))), getChildAt(idx).name);
			if(!child)
			{
				continue;
			}
			
			if(!child.visible || !child.hitTestPoint(pt.x, pt.y, true))
			{
				continue;
			}

			return child.touchChildren ? child.getTouchObjectUnderPoint(pt) : child ;
		}
		
		return this;
	}
	
	//-----------------------------------
	// Methods: Overlays
	//-----------------------------------
	private var _overlays:Array = new Array();
	
	/**
	 * Returns the number of overlays associated with a TouchObjectContainer
	 */
	id_internal function get overlayReferenceCount():uint {
		return _overlays.length;
	}
	
	/**
	 * Attaches a DisplayObject as a top most child and omits it from
	 * the processed display list.
	 * 
	 * @param	child The DisplayObject which to add
	 */
	public function addChildOverlay(child:DisplayObject):void
	{
		var index:int = super.numChildren;
		
		$addChildAt(child, index);
		
		_overlays.push(child);
	}
	
	/**
	 * Removes a DisplayObject from the top most children.
	 * 
	 * @param	child The DisplayObject which to remove
	 * @throws	RangeError The discovered child index is not a number greater then or equal to 0. 
	 */
	public function removeChildOverlay(child:DisplayObject):void
	{
		var index:int = _overlays.indexOf(child);
		if (index == -1)
		{
			throw new RangeError("Specified child overlay does not exist in the display list!");
		}
		
		$removeChildAt(getChildIndex(child));
		_overlays.splice(index, 1);
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Overrides
	////////////////////////////////////////////////////////////
	
	//-----------------------------------
	// Methods: Add Child
	//-----------------------------------
	//CONFIG::FLASH_AUTHORING
	//{
	/**
	 * @private
	 * 
	 * @param	child
	 * @return
	 */
	override public function addChild(child:DisplayObject):DisplayObject
	{
        var formerParent:DisplayObjectContainer = child.parent;
        if (formerParent && !(formerParent is Loader))
            formerParent.removeChild(child);
		
		var index:int = overlayReferenceCount ? Math.max(0, super.numChildren - overlayReferenceCount/* - 1*/) : super.numChildren ;

		addingChild(child);
		$addChildAt(child, index);
		childAdded(child);
		
		return child;
	}
	
	/**
	 * @private
	 * 
	 * @param	child
	 * @param	index
	 * @return
	 */
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject
	{
        var formerParent:DisplayObjectContainer = child.parent;
        if (formerParent && !(formerParent is Loader))
            formerParent.removeChild(child);
			
		if(overlayReferenceCount)
			index = Math.min(index, Math.max(0, super.numChildren - overlayReferenceCount/* - 1*/));

		addingChild(child);
		$addChildAt(child, index);
		childAdded(child);
		
		return child;
	}
	
	/**
	 * 
	 * @param	child
	 */
	id_internal function addingChild(child:DisplayObject):void
	{
		var target:ITouchObject = child as ITouchObject
		if(!target)
		{
			return;
		}
		
		if(!target.blobContainerEnabled)
		{
			target.blobContainer = blobContainer
		}
	}
	
	id_internal function childAdded(child:DisplayObject):void {
		
	}
	//}
	
	//-----------------------------------
	// Methods: Remove Child
	//-----------------------------------
	//CONFIG::FLASH_AUTHORING
	//{
	/**
	 * @private
	 * 
	 * @param	child
	 * @return
	 */
	override public function removeChild(child:DisplayObject):DisplayObject {
		removingChild(child);
		$removeChild(child);
		childRemoved(child);
		
		return child;
	}
	
	/**
	 * @private
	 * 
	 * @param	index
	 * @return
	 */
	override public function removeChildAt(index:int):DisplayObject {
		var child:DisplayObject = getChildAt(index);
		
		removingChild(child);
		$removeChild(child);
		childRemoved(child);
		
		return child;
	}
	
	/**
	 * @private
	 * 
	 * @param	child
	 */
	id_internal function removingChild(child:DisplayObject):void {
		//
	}
	
	/**
	 * @private
	 * 
	 * @param	child
	 */
	id_internal function childRemoved(child:DisplayObject):void {
		//
	}
	//}
	
	////////////////////////////////////////////////////////////
	// Methods: Preserved
	////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 * 
	 * @param	child
	 * @param	index
	 * @return
	 */
	id_internal final function $addChildAt(child:DisplayObject, index:int):DisplayObject
	{
		return super.addChildAt(child, index);
	}
	
	/**
	 * @private
	 * 
	 * @param	child
	 * @return
	 */
	id_internal final function $removeChild(child:DisplayObject):DisplayObject
	{
		return super.removeChild(child);
	}
	
	/**
	 * @private
	 * 
	 * @param	index
	 * @return
	 */
	id_internal final function $removeChildAt(index:int):DisplayObject
	{
		return super.removeChildAt(index);
	}

	
}
	
}