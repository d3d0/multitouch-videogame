////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	LoggerEvent.as
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


/**
 * Dispatched when a message has been logged to the Logger while compiled for debug mode.
 */
public class LoggerEvent extends Event
{

	public static const MESSAGE:String = "message";

	/**
	 * The contents of the message.
	 */
	public var message:String;

	public function LoggerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, message:String = "") {
		super(type, bubbles, cancelable);
		
		this.message = message;
	}

	override public function clone():Event {
		 return new LoggerEvent(type, bubbles, cancelable, message);
	}

}
	
}