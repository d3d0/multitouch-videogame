////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITrackerHook.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.tracker
{

import id.core.IDisposable;
import flash.events.IEventDispatcher;

/**
 * The ITrackerHook interface defines the basic set of APIs required for the
 * implementing class.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public interface ITrackerHook extends IEventDispatcher, IDisposable
{
	
	function get tracker():ITracker;
	function set tracker(value:ITracker):void;
	
	function start():void;
	function stop():void;
	function restart():void;
	
}

}