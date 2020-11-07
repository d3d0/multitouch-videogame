////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	NameUtil.as
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

import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;

[ExcludeClass]

/**
 * @private
 */
public class NameUtil
{
	
	include "../core/Version.as";
	
	private static var counter:int = 0;
	
	public static function createUniqueName(object:Object):String {
		if(!object) return null;
		
		var name:String = getQualifiedClassName(object);
		
		var index:int = name.indexOf("::");
		if(index != -1)
			name = name.substr(index + 2);
		
		var charCode:int = name.charCodeAt(name.length - 1);
		if(charCode >= 48 && charCode <= 57)
			name += "_";
		
		return name + counter++;
	}
	
	public static function displayObjectToString(displayObject:DisplayObject):String {
		var result:String;

		for(var o:DisplayObject=displayObject; o!=null; o=o.parent){
			if(o.parent && o.stage && o.parent == o.stage) break;
			
			var s:String = o.name;
			/*if(o is IRepeterClient) {
				var indices:Array = IRepeterClient(o).instanceIndices;
				if(indices)
					s += "[" + indices.join("][") + "]";
			}*/
			
			result = result == null ? s : s + "." + result;
		}
		
		return result;
	}
	
	public static function displayObjectToShortString(displayObject:DisplayObject):String
	{
		return getQualifiedClassName(displayObject);
	}
	
	public static function displayObjectParentalCount(displayObject:DisplayObject):uint
	{
		var count:uint = 0;
		for(var o:DisplayObject=displayObject; o!=null; o=o.parent)
		{
			if(o.parent && o.stage && o.parent == o.stage)
				break;
				
			count++;
		}
		
		return count;
	}
	
}
	
}