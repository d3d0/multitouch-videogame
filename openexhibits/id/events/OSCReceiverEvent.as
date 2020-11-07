////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	OSCReceiverEvent.as
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

import id.net.osc.OSCPacket;
import flash.events.Event;

public class OSCReceiverEvent extends Event
{
	
	public static const PACKET_RECEIVED:String = "packetReceived";
	
	public var packet:OSCPacket;
	
	public function OSCReceiverEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, packet:OSCPacket = null) {
		super(type, bubbles, cancelable);
		
		this.packet = packet;
	}

	override public function clone():Event {
		 return new OSCReceiverEvent(type, bubbles, cancelable, packet);
	}
	
}

}