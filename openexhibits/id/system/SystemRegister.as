////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SystemRegister.as
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

public class SystemRegister
{

	include "../core/Version.as"

	public static const APPLICATION:String	= "systemRegister_Application";
	public static const CLASS:String		= "systemRegister_Class";
	public static const COMPONENT:String	= "systemRegister_Component";
	public static const LIBRARY:String		= "systemRegister_Library";
	
	public static var register:SystemRegister = new SystemRegister
	(
		"Common",
		id_internal::VERSION,
		SystemRegisterType.LIBRARY
	);

	private var _name:String;
	private var _type:String;
	private var _version:Version;

	public function SystemRegister(name:String, version:String, type:String)
	{
		_name = name;
		_type = type;
		
		_version = new Version(version);
		
		SystemRegisterImpl.getInstance().registerModule(_name, _version, _type);
	}
	
	public function get name():String
	{
		return _name;
	}
	
	public function get type():String
	{
		return _type;
	}
	
	public function get version():Version
	{
		return _version;
	}
	
	public static function getRegisters():Dictionary
	{
		return SystemRegisterImpl.getInstance().registers;
	}
	
	public static function getTypes():Array
	{
		return SystemRegisterImpl.getInstance().getTypes();
	}
	
	public static function getModules():Array
	{
		return SystemRegisterImpl.getInstance().getModules();
	}

}

}