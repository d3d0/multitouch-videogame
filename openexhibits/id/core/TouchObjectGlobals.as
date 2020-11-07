////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchObjectGlobals.as
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

/**
 * @private
 * 
 * These static references are available to every TouchObject instantiation.
 */
public class TouchObjectGlobals
{
	
	/**
	 * @private
	 */
	public static var topLevelContainer:Array = [];
	
	
	
	/**
	 * @private
	 */
	id_internal static var activatorEvent:Class;
	
	/**
	 * @private
	 */
	id_internal static var gestureEvent:Class;
	
	/**
	 * @private
	 */
	id_internal static var pathEvents:Array;
	
	
	
	/**
	 * @private
	 */
	id_internal static var affineTransformations:Boolean;

	/**
	 * @private
	 */
	id_internal static var affineTransform_release:String = "RELEASE";

	/**
	 * @private
	 */
	id_internal static var affineTransform_release_event:String;
	
	/**
	 * @private
	 */
	id_internal static var affineTransform_rotate:String = "GESTURE_ROTATE";
	
	/**
	 * @private
	 */
	id_internal static var affineTransform_rotate_event:String;
	
	/**
	 * @private
	 */
	id_internal static var affineTransform_scale:String = "GESTURE_SCALE";
	
	/**
	 * @private
	 */
	id_internal static var affineTransform_scale_event:String;
	
	
	//id_internal static var degradeTouchEvents:Boolean = !CONFIG::FLASH_AUTHORING ? true : false ;
id_internal static var degradeTouchEvents:Boolean =  true;
		
}
	
}