////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ModuleEvent.as
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

public class ModuleEvent extends Event
{
	include "../core/Version.as"

	public static const ERROR:String = "moduleError";
	public static const PROGRESS:String = "progress";
	public static const READY:String = "moduleReady";
	public static const UNLOAD:String = "unload";

	public var bytesLoaded:Number;
	public var bytesTotal:Number;
	
	public var message:String;

	public function ModuleEvent
	(
		type:String,
		bubbles:Boolean = false,
		cancelable:Boolean = false,
		bytesLoaded:Number = 0,
		bytesTotal:Number = 0,
		message:String = ""
	)
	{
		super(type, bubbles, cancelable);
		
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
		
		this.message = message;
	}

	override public function clone():Event
	{
		return new ModuleEvent
		(
			type,
			bubbles,
			cancelable,
			bytesLoaded,
			bytesTotal,
			message
		);
	}

}
	
}