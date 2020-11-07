////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITactualObjectManagerClient.as
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

import id.core.ITactualObject;
import flash.events.IEventDispatcher;
	
/**
 * @private
 */
public interface ITactualObjectManagerClient extends IEventDispatcher
{
	
	function addTactualObject(tO:ITactualObject):void;
	function removeTactualObject(tO:ITactualObject):void;
	
}
	
}