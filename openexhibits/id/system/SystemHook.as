////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	SystemHook.as
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

import id.core.IDisposable;
import id.managers.IValidationManager;
import id.managers.IValidationManagerHook;
import id.managers.ValidationManager;
import id.tracker.ITracker;
import id.tracker.ITrackerHook;
import id.tracker.Tracker;

import flash.events.EventDispatcher;

//--------------------------------------------------------------------------
/**
 * The SystemHook class provides the combined functionality of the
 * <code>TrackerHook</code> and <code>ValidationManagerHook</code>.  This
 * object allows the developer full access to both core systems in
 * GestureWorks.  The validation and tracking system cycles become exposed
 * by extending and provinding additional scaffolding.
 * 
 * Direct ex
 * By extending and providing additional scaffolding, the
 * validation and tracking system cycles become exposed 
 * 
 * 
 * The Aggregator class lets you extend it to create point clustering
 * algorithms.  It extends the <code>SystemHook</code> which provides low
 * level access to the internal mechanisms in GestureWorks.  This immediatly
 * provides access to the methods exposed by the validation system and also
 * gives access to the internal point tracking system.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class SystemHook extends EventDispatcher
	implements ITrackerHook, IValidationManagerHook, IDisposable
{
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
    
    /**
     * @private
     * 
     * The <code>Tracker</code> instance.
     */
	protected var _tracker:ITracker;
    
    /**
     * @private
     * 
     * The <code>ValidationManager</code> instance.
     */
	protected var _validationManager:IValidationManager;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function SystemHook()
	{
		//tracker = Tracker.getInstance();
		//validationManager = ValidationManager.getInstance();
	}
	
    //--------------------------------------------------------------------------
    //
    //  Destructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Destructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function Dispose():void
	{
		// override me
	}
	
    /**
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function get tracker():ITracker { return _tracker; }
	public function set tracker(value:ITracker):void
	{
		if(value == _tracker)
			return;
        
		_tracker = value;
		onTrackerChanged(value);
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

	public function start():void { }
	public function stop():void { }
	public function restart():void { }
	
	public function validationBeginning():void { }
	public function validationComplete():void { }

	protected function onTrackerChanged(tracker:ITracker):void
	{
		// override me
	}

	protected function onValidationManagerChanged(validationManager:IValidationManager):void
	{
		// override me
	}
	
}
}