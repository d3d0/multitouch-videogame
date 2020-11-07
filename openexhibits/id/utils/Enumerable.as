////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Enumerable.as
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

import flash.utils.Proxy;
import flash.utils.flash_proxy;
public dynamic class Enumerable extends Proxy
{
	protected var _items:Object = {};

	public function Enumerable()
	{
	}
	
	override flash_proxy function callProperty(methodName:*, ... args):*
	{
		var ret:*;
		
		switch(methodName.toString())
		{
			default:
				ret = _items[methodName].apply(_items, args);
		}
		
		return ret;
	}
	
	override flash_proxy function getProperty(name:*):*
	{
		return _items[name];
	}
	
	override flash_proxy function setProperty(name:*, value:*):void
	{
		_items[name] = value;
	}
	
}

}