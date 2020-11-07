////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	EventUtil.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.utils
{

import id.core.ApplicationGlobals;
import id.core.DescriptorAssembly;
import id.core.HistoryObject;
import id.core.id_internal;
import id.core.ITactualObject;
import id.utils.StringUtil;
import gl.events.TouchEvent;

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

use namespace id_internal;

/**
 * 
 * Utilities to help with event dispatching or event handling.
 */
public class EventUtil
{
	include "../core/Version.as";
	
	/**
     * @private
     */
	public static var eventsAttached:Boolean;
    
	/**
     * @private
     */
	public static function attachEvents(application:Object):void
	{
		
	}
	
	/**
     * @private
     */
	public static function createTouchEvent
	(
		name:String,
		localX:Number, localY:Number,
		stageX:Number, stageY:Number,
		relatedObject:InteractiveObject,
		tactualObject:ITactualObject
	)
	:TouchEvent
	{
		if(!eventsAttached)
		{
			
		}
		
		return null;
	}
	
	/**
     * 
     * 
     * @param event
     * @param assembly
     * 
     * @return The <code>MouseEvent</code> equivalent of the passed <code>TouchEvent</code>
     */
	public static function degradateTouchEvent(event:TouchEvent, assembly:Object):MouseEvent
	{
		var ret_event:MouseEvent;
		var ret_name:String;
		
		//var assembly:Object = ApplicationGlobals.descriptorAssembly;
		var degradationMap:Object =
		ret_name = assembly
		[
			DescriptorAssembly.TOUCH_DEGRADATION_MAP
		];
		
		ret_name = degradationMap[event.type];
		
		if(StringUtil.isEmpty(ret_name))
		{
			return null;
		}
		
		ret_event = new MouseEvent(
			ret_name,
			true,
			false,
			event.localX,
			event.localY,
			event.relatedObject,
			event.ctrlKey,
			event.altKey,
			event.shiftKey
		);
		
		return ret_event;
	}
	
	/**
     * @private
     */
	public static function get mouseEventMap():Object
	{
		return {};
	}
	
	/**
     * @private
     */
	public static function get touchEventMap():Object
	{
		return {};
	}

}

}