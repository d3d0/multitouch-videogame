////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Requires.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.system
{

import id.events.SystemEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getDefinitionByName;
import flash.utils.Proxy;
import flash.utils.Dictionary;

public class Requires
{
	
	include "../core/Version.as"
	
	private static var _dispatcher:EventDispatcher = new EventDispatcher();
	private static var _list:Dictionary = new Dictionary(true);

	public static function get list():Dictionary
	{
		return _list;
	}
	
	public static function establish(object:Object, ... args):void
	{
		if(!((args.length - 1) % 2))
		{
			throw new ArgumentError("Arguments count is invalid!");
		}
		
		if(_list.hasOwnProperty(object))
		{
			throw new Error("Object requesting requrements has already been established!");
		}
		
		var register:Dictionary = SystemRegister.getRegisters();
		
		var k:String;
		var idx:uint;
		var type:String;
		
		var failed:Boolean;
		var messages:Array = [];
		
		for(idx=0; idx<args.length; idx++)
		{
			if(!(idx % 2))
			{
				type = args[idx];
				continue;
			}
			
			if(!register[type])
			{
				failed = true;
				messages.push("System type not found: " + type);
			}
			
			for(k in args[idx])
			{
				if
				(
				 	!register[type] ||
					!register[type][k]
				)
				{
					failed = true;
					messages.push(type + " not found: " + k);
					
					continue;
				}
				else
				if((register[type][k] as Version).compareTo(args[idx][k]) == -1)
				{
					failed = true;
					messages.push(type + " version requirement mismatch: " + k);
				}
			}
		}
		
		_list[object.toString()] = 
		{
			args: args.splice(0, 1),
			messages: messages
		}
		
		if(failed)
		{
			dispatchEvent(new SystemEvent(SystemEvent.DEPENDENCY_ERROR, false, false, messages.join("\n")));
		}
	}
	
	public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public static function dispatchEvent(event:Event):Boolean
	{
        return _dispatcher.dispatchEvent(event);
    }

    public static function hasEventListener(type:String):Boolean
	{
        return _dispatcher.hasEventListener(type);
    }

    public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        _dispatcher.removeEventListener(type, listener, useCapture);
    }

    public static function willTrigger(type:String):Boolean
	{
		return _dispatcher.willTrigger(type);
    }

}

}