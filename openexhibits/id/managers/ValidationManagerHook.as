////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ValidationManagerHook.as
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
	
import id.core.IDisposable;
import flash.events.EventDispatcher;

public class ValidationManagerHook extends EventDispatcher implements IValidationManagerHook, IDisposable
{

	protected var _validationManager:IValidationManager;
	
	public function ValidationManagerHook()
	{
		//validationManager = ValidationManager.getInstance();
	}
	
	public function Dispose():void
	{
		// override me
	}

	public function get validationManager():IValidationManager { return _validationManager; }
	public function set validationManager(value:IValidationManager):void
	{
		if(_validationManager)
		{
			return;
		}
		
		_validationManager = value;
		_validationManager.addHook(this);
		
		onValidationManagerChanged(value);
	}
	
	public function validationBeginning():void { }
	public function validationComplete():void { }

	protected function onValidationManagerChanged(validationManager:IValidationManager):void
	{
		// override me
	}

}

}