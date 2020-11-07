////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IDataManager.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.managers
{

import flash.events.IEventDispatcher;

public interface IDataManager extends IEventDispatcher
{

	function get data():XML;
	function set data(value:XML):void;
	
	function get components():XMLList;
	function get touchCore():XMLList;
	function get touchPhysics():XMLList;
	function get touchLib():XMLList;
	
	function get dataPath():String;
	function set dataPath(value:String):void;

}

}