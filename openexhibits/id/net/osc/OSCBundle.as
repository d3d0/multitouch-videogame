////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	OSCBundle.as
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

public class OSCBundle
{

	private var _values:Array = [];

	public static const c:String = "c";
	public static const d:String = "d";
	public static const f:String = "f";
	public static const h:String = "h";
	public static const i:String = "i";
	public static const s:String = "s";
	public static const t:String = "t";
	public static const r:String = "r";
	public static const S:String = "S";
	public static const T:String = "T";
	public static const m:String = "m";
	public static const F:String = "F";
	

	public function OSCBundle(... args)
	{
		for(var idx:uint=0; idx<args.length; idx++)
		{
			appendValue(args[idx][0], args[idx][1]);
		}
	}
	
	public function get values():Array { return _values; }
	
	public function appendValue(type:String, value:String):void
	{
		var bStream:*;
		
		switch(type)
		{
			case T:
				bStream = true;
				break;
			
			case F:
				bStream = false;
				break;
			
			case f:
				bStream = parseFloat(value);
				break;
			
			case i:
				bStream = parseInt(value);
				break;
			
			case s:
				bStream = String(value);
				break;
			
			case h:
				bStream = Number(value);
				break;
			
			default:
				bStream = null;
				break;
		}
		
		if(bStream == null)
			return;
			
		_values.push(bStream);
	}
	

}

}