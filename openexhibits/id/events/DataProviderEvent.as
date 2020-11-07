////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	DataProviderEvent.as
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
 * Dispatched when a Blob collection is made available by the interpeter.
 */
public class DataProviderEvent extends Event
{
	
	public static const ERROR:String = "error";
	public static const ESTABLISHED:String = "established";

	public function DataProviderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}

	override public function clone():Event {
		 return new DataProviderEvent(type, bubbles, cancelable);
	}

}
	
}