////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SystemEvent.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.events
{

import flash.events.Event;

public class SystemEvent extends Event
{

	include "../core/Version.as"

	public static const DEPENDENCY_ERROR:String = "systemDependencyError";
	
	public var messages:String;

	public function SystemEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, messages:String = "")
	{
		super(type, bubbles, cancelable);
		
		this.messages = messages;
	}

	override public function clone():Event
	{
		 return new SystemEvent(type, bubbles, cancelable, messages);
	}

}
	
}