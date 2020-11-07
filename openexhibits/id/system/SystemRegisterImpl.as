////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SystemRegisterImpl.as
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

import flash.utils.Dictionary;
import id.core.id_internal;
import id.system.Version;
import id.system.SystemRegisterType;

public class SystemRegisterImpl
{
	
	include "../core/Version.as"
	
	private static var _instance:SystemRegisterImpl = new SystemRegisterImpl();
	public static function getInstance():SystemRegisterImpl
	{
		return _instance;
	}
	
	public function SystemRegisterImpl()
	{
		_registers = new Dictionary();
	}
	
	private var _registers:Dictionary;
	public function get registers():Dictionary
	{
		return _registers;
	}
	
	public function getTypes():Array
	{
		var k:String;
		var ret:Array = [];
		
		for(k in _registers)
		{
			ret.push(k);
		}
		
		return ret;
	}
	
	public function getModules():Array
	{
		var k:String;
		var j:String;
		
		var ret:Array = [];
		
		for(k in _registers)
		for(j in _registers[k])
		{
			ret.push(j);
		}
		
		return ret;
	}
	
	public function registerModule(name:String, version:Version, type:String):void
	{
		if(!_registers[type])
		{
			_registers[type] = {};
		}
		
		if(_registers[type].hasOwnProperty(name))
		{
			throw new Error(name + " has already been registered against the system!");
		}
		
		_registers[type][name] = version;
	}
}

}