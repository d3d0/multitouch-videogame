////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	OSCPacket.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.net.osc
{

public class OSCPacket
{
	
	private var _alive:Array = [];
	private var _set:Array = [];
	
	public function OSCPacket()
	{
	}
	
	public function get alive():Array { return _alive; }
	public function get set():Array { return _set; }
	
	public function appendAlive(item:OSCBundle):void
	{
		_alive.push(item);
	}
	
	public function appendSet(item:OSCBundle):void
	{
		_set.push(item);
	}
	
	public function hasAlive():Boolean { return _alive.length > 0; }
	public function hasSet():Boolean { return _set.length > 0; }
	
	public function isComplete():Boolean { return hasAlive() && hasSet(); }
	
}

}