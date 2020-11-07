////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	InputTypes.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.data
{

import id.utils.Enumerable;

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.system.ApplicationDomain;

public dynamic class InputTypes extends Enumerable
{
	
	private var _xml:XMLList;
	private var _types:Dictionary;
	
	public function InputTypes(xmlList:XMLList = null)
	{
		if(!xmlList)
			return;
		
		xml = xmlList;
	}
	
	public function set xml(value:XMLList):void
	{
		if(value == _xml)
			return;
		
		_xml = value;
		
		parseXML();
	}
	
	private function parseXML():void
	{
		_types = new Dictionary();
		
		var types:XMLList = _xml.Type;
		for(var idx:uint=0; idx<types.length(); idx++)
		{
			var type:XML = types[idx];
			
			var cls:Class;
			var clsSettings:Class;
			
			try
			{
				cls = getDefinitionByName(type.Package + "::" + type.Class) as Class;
				clsSettings = getDefinitionByName(type.Package + "::" + type.Settings) as Class;
			}
			catch(e:Error)
			{
				continue;
			}
			
			_items[type.@name] = new InputType();
			_items[type.@name].cls = cls;
			_items[type.@name].clsSettings = clsSettings;
			_items[type.@name].xml = type;
		}
	}
	
}

}

class InputType
{
	
	public var cls:Class;
	public var clsSettings:Class;
	public var xml:XML;
	
}