////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ValidationManager.as
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

import id.core.id_internal;
import id.core.ITouchObject;
import id.core.TouchObjectGlobals;

import flash.events.Event;

use namespace id_internal;

public class ValidationManager implements IValidationManager
{
	
	////////////////////////////////////////////////////////////
	// Singleton data and functions
	////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 * The sole instance of this singleton class.
     */
	private static var instance:ValidationManager;// = new ValidationManager();
	
	/**
	 * @return The Validation Manager singleton.
	 */
	public static function getInstance():ValidationManager
	{
		if(!instance)
			instance = new ValidationManager();
		
		return instance;
	}

	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	public function ValidationManager()
	{
		super();
				
		application = TouchObjectGlobals.topLevelContainer[0];
		validationHooks = new Vector.<IValidationManagerHook>();
	}
	
	////////////////////////////////////////////////////////////
	// Validation Variables
	////////////////////////////////////////////////////////////
	private var application:Object;
	private var eventsAttached:Boolean;
	
	private var waitedAFrame:Boolean;
	
	private var invalidationFlag:Boolean;
	private var invalidationQueue:Vector.<IValidationManagerClient>;// = new Vector.<IValidationManagerClient>();
	
	private var validationHooks:Vector.<IValidationManagerHook>;
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	public function addHook(hook:IValidationManagerHook):void
	{
		validationHooks.push(hook);
	}
	
	public function removeHook(hook:IValidationManagerHook):void
	{
		var index:int = validationHooks.indexOf(hook);
		if (index == -1)
			return;
			
		validationHooks.splice(index, 1);
	}
	
	public function invalidateClient(client:IValidationManagerClient):void
	{
		if(!invalidationFlag && application)
		{
			invalidationFlag = true;
			
			if(!eventsAttached)
			{
				attachEvents(application);
			}
			
			invalidationQueue = new Vector.<IValidationManagerClient>();
		}
		
		if(invalidationQueue.indexOf(client) != -1)
		{
			return;
		}
		
		invalidationQueue.push(client);
	}
	
	private function validateTactualObjects():void
	{
		for(var idx:uint=0; idx<invalidationQueue.length; idx++)
		{
			invalidationQueue[idx].validateTactualObjects();
		}

		eventsAttached = false;

		invalidationFlag = false;
		invalidationQueue = null;
	}
	
	public function validateClient(client:IValidationManagerClient):void
	{
		trace("ValidationManager::validating:", client);
	}

	/*
	public function validateNow():void
	{
		trace("ValidationManager::forcing validation!");
	}
	*/

	private function attachEvents(application:Object):void
	{
		if(!waitedAFrame)
		{
			application.stage.addEventListener(Event.ENTER_FRAME, waitAFrame);
		}
		else
		{
			application.stage.addEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		}
		
		eventsAttached = true;
	}
	
	private function application_enterFrameHandler(event:Event):void
	{
		//trace("\nbeginning");
		application.stage.removeEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		
		var hook:IValidationManagerHook
		
		for each(hook in validationHooks)
		{
			hook.validationBeginning();
		}
		
		validateTactualObjects();
		
		for each(hook in validationHooks)
		{
			hook.validationComplete();
		}
	}
	
	private function waitAFrame(event:Event):void
	{
		application.stage.removeEventListener(Event.ENTER_FRAME, waitAFrame);
		application.stage.addEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		
		waitedAFrame = true;
	}

}

}