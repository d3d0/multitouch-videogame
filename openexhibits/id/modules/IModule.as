////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IModule.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.modules
{

import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="error", type="id.events.ModuleEvent")]
[Event(name="progress", type="id.events.ModuleEvent")]
[Event(name="ready", type="id.events.ModuleEvent")]
[Event(name="unload", type="id.events.ModuleEvent")]

public interface IModule extends IEventDispatcher
{
	
	function get factory():IModuleFactory;
	
	function get error():Boolean;
	function get loaded():Boolean;
	function get ready():Boolean;
	
	function get url():String;
	
	function load
	(
		applicationDomain:ApplicationDomain = null,
		securityDomain:SecurityDomain = null,
		bytes:ByteArray = null/*,
		moduleFactory:IModuleFactory = null*/
	)
	:void;
	
	function release():void;
	function unload():void;
	
}

}