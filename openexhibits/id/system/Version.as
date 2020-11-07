////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Version.as
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

import id.lang.IComparable;
import id.utils.StringUtil;

public class Version implements IComparable
{
	
	include "../core/Version.as"
	
	public static const ALPHA:String = "alpha";
	public static const BETA:String = "beta";
	public static const RC:String = "rc";
	public static const R:String = "r";
	
	public var majorVersion:uint;
	public var minorVersion:uint;
	public var microVersion:uint;
	public var buildNumber:uint;
	
	public var qualifier:String;
	
	public static const FORMAT_STRING:String = "<majorVersion>.<minorVersion>.<microVersion>.<buildNumber>";
	public static const FORMAT_ORDER:Array =
	[
		"majorVersion",
		"minorVersion",
		"microVersion",
		"buildNumber"
	];
	
	public function Version(value:Object, format:String = FORMAT_STRING)
	{
		var bundle:Object;
		var k:String;
		
		if(value is String)
		{
			bundle = StringUtil.tokenize(value as String, format);
		}
		else
		if(value is Object)
		{
			bundle = value;
		}

		for(k in bundle)
		{
			if(!this.hasOwnProperty(k))
			{
				continue;
			}
			
			this[k] = bundle[k];
		}
	}
	
	public function compareTo(o:Object):int
	{
		if (o is String)
		{
			o = new Version(o);
		}
		
		var v:Version = o as Version;
		if(!v)
		{
			throw new ArgumentError("Cannot compare to an object not of my type!");
		}
		
		var idx:uint;
		var vValue:Object;
		var tValue:Object;
		
		for(idx=0; idx<FORMAT_ORDER.length; idx++)
		{
			vValue = v[FORMAT_ORDER[idx]];
			tValue = this[FORMAT_ORDER[idx]];
			
			if(vValue == tValue)
			{
				continue;
			}
			
			if(vValue < tValue)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		
		return 0;
	}
	
	public function toString():String
	{
		return majorVersion + "." + minorVersion + "." + microVersion + "." + buildNumber ;
	}

}

}