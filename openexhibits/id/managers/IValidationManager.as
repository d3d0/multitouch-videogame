////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IValidationManager.as
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

/**
 * @private
 */
public interface IValidationManager
{	
	function addHook(hook:IValidationManagerHook):void;
	function removeHook(hook:IValidationManagerHook):void;
	
	function invalidateClient(client:IValidationManagerClient):void;
	function validateClient(client:IValidationManagerClient):void;
	
}

}