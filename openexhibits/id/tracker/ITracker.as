////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITracker.as
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

import id.managers.IValidationManagerHook;

import flash.utils.Dictionary;

/**
 * The ITracker interface defines the basic set of APIs required for the
 * GestureWorks core tracking system.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public interface ITracker extends IValidationManagerHook
{
	
	function get tactualObjects():Dictionary;
	function get tactualObjectCount():uint;
	
	function get additionList():Vector.<uint>;
	function get removalList():Vector.<uint>;
	
	function get frequency():uint;
	function set frequency(value:uint):void;
	
	function get ghostTolerance():uint;
	function set ghostTolerance(value:uint):void;
	
	function queueAddition(object:Object):void;
	function queueRemoval(object:Object):void;
	function queueUpdate(object:Object):void;
	
	function queueAdditions(collection:Vector.<Object>):void;
	function queueRemovals(collection:Vector.<Object>):void;
	function queueUpdates(collection:Vector.<Object>):void;
	
	function cripple():void;
	
	function start():void;
	function stop():void;
	function reset():void;
	
	function clear():void;
	
}

}