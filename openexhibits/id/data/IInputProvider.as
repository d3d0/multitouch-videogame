////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IInputProvider.as
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

import id.core.IDisposable;
import id.managers.IValidationManagerHook;
import id.tracker.ITrackerHook;
import id.utils.Enumerable;

public interface IInputProvider extends IValidationManagerHook, ITrackerHook, IDisposable
{
	
	function set settings(object:Enumerable):void;
	function bloom():void;
	
}

}