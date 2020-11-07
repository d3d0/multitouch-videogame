////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITouchObject.as
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

import id.managers.ITactualObjectManagerClient;
import id.managers.IValidationManagerClient;
import id.tracker.ITrackerClient;

import flash.accessibility.AccessibilityProperties;
import flash.display.IBitmapDrawable;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.display.Stage;
import flash.events.IEventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;

public interface ITouchObject extends
	IInvalidating, ITrackerClient, ITactualObjectManagerClient, IValidationManagerClient, IBitmapDrawable, IEventDispatcher
{
	
	include "../core/IDisplayObjectInterface.as"
	
	/**
	 * Establishes the TouchObject as a blob container, which may be acted upon during
	 * blob targeting and owner selection.
	 * 
	 * <p> If set to true, the TouchObject becomes enabled for secondary blob clustering
	 * and gesture processing and analysis. When gesture listeners are applied, if the
	 * TouchObject is transparent to target and owner selection, the respective gestures
	 * will not fire because no blobs are available for processing.  State switching is
	 * not automated as gestures are added and removed because it may interfere with
	 * the developer's programmatic intent.</p>
	 * 
	 * @default false
	 * 
	 * @param	value A boolean representing this object's container state.
	 */
	function get blobContainerEnabled():Boolean;
	function set blobContainerEnabled(value:Boolean):void;
	
	function get pointTargetRediscovery():Boolean;
	function set pointTargetRediscovery(value:Boolean):void;
	
	/**
	 * @private
	 */
	function get blobContainer():ITouchObject;
	
	/**
	 * @private
	 */
	function set blobContainer(obj:ITouchObject):void;
	
	/**
	 * @private
	 */
	function get topLevel():Boolean;
	
	/**
	 * @private
	 */
	function set topLevel(value:Boolean):void;
	
	/**
	 * @private
	 */
	function get topLevelContainer():ITouchObject;
	
	
	/**
	 * @private
	 */
	function get affineOrigin():Point;
	
	/**
	 * @private
	 */
	function get affineOriginStage():Point;
	
	
	/**
	 * @private
	 */
	function registerDragHandler(target:ITouchObject, f:Function, force:Boolean = false):int;
	
	/**
	 * @private
	 */
	function unregisterDragHandler(target:ITouchObject, f:Function, force:Boolean = false):int;
	
	
	
	
	/**
	 * This method determines if a particular gesture is processing, or has been processed
	 * and not yet released. 
	 * 
	 * @param	value The gesture's shortname which to process.
	 * @return	A boolean representing the existance of the respective gesture's history.
	 */
	//function hasGestureHistory(value:String):Boolean;
	
	/**
	 * This method determines if a particular touch is processing, or has been processed
	 * and not yet released.  Because of the intrinsic nature of multi-touch, a
	 * <code>TouchObject</code> may have multiple touch downs without their respective
	 * touch ups.  This method is accurate to the point where you may retrieve the total number
	 * tactual objects owned by, or targeted to the TouchObject.
	 * 
	 * @param	value The touch shortname which to process.
	 * @return	A boolean representing the existance of the respective touch's history.
	 */
	//function hasTouchHistory(value:String):Boolean;
	
	function getDescriptorHistory(descriptor:String, partial:Boolean = false):Object;
	function hasDescriptorHistory(descriptor:String, partial:Boolean = false):Boolean;
	
	function discoverTactualObjectContainer():void;
	
}

}