////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Native.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.data.native
{

import id.core.ApplicationGlobals;
import id.data.IInputProvider;
import id.events.DataProviderEvent;
import id.system.SystemHook;
import id.tracker.ITracker;
import id.utils.Enumerable;

import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.utils.getDefinitionByName;

/**
 * This data receiver provides support for the <code>TouchEvent</code>
 * propagation found in Flash Player 10.1.  
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10.1
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class Native extends SystemHook implements IInputProvider
{
	
	private var _touchEvent:Class;
	private var _touchCatcher:Sprite;
	
	private var _touchList:Vector.<int>;
	private var _touchQueue:Vector.<int>;
	
	private var _settings:Enumerable;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Creates a new Native object.
     * 
     * @throws ReferenceError The Flash <code>TouchEvent</code> must exist in
     * the local domain.  Compiling against Flash Player 10.0 is the most common
     * reason this exception will be raised.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function Native()
	{
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		
		_touchEvent = getDefinitionByName("flash.events.TouchEvent") as Class;
		if(!_touchEvent)
		{
			throw new ReferenceError("flash.events::TouchEvent was not found in the ApplicationDomain!");
		}
		
		_touchCatcher = new Sprite();
		//_touchCatcher.mouseChildren = false;
		
		_touchList = new Vector.<int>();
		_touchQueue = new Vector.<int>();
		
		_touchCatcher.addEventListener(_touchEvent.TOUCH_BEGIN, touchCatcher_touchBeginHandler);
		_touchCatcher.addEventListener(_touchEvent.TOUCH_END, touchCatcher_touchEndHandler);
		_touchCatcher.addEventListener(_touchEvent.TOUCH_MOVE, touchCatcher_touchMoveHandler);
	}
	
	override public function Dispose():void
	{
		if (_touchCatcher.parent)
		{
			_touchCatcher.parent.removeChild(_touchCatcher);
		}
		
		_touchCatcher.removeEventListener(_touchEvent.TOUCH_BEGIN, touchCatcher_touchBeginHandler);
		_touchCatcher.removeEventListener(_touchEvent.TOUCH_END, touchCatcher_touchEndHandler);
		_touchCatcher.removeEventListener(_touchEvent.TOUCH_MOVE, touchCatcher_touchMoveHandler);

		ApplicationGlobals.application.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
	}
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	public function get settings():Enumerable { return _settings; }
	public function set settings(object:Enumerable):void
	{
		if(object == _settings)
			return;
			
		_settings = object;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	public function bloom():void
	{
		if(!_settings)
		{
			throw new IllegalOperationError("Settings must first be defined!");
		}
		   
		if(!_tracker)
		{
			throw new IllegalOperationError("Tracker must first be defined!");
		}

		if(!Multitouch.supportsTouchEvents || !Multitouch.maxTouchPoints)
		{			
			dispatchEvent(new DataProviderEvent(DataProviderEvent.ERROR, false, false));
			return;
		}
		else
		{		
		}
		
		ApplicationGlobals.application.stage.addChild(_touchCatcher);
		ApplicationGlobals.application.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		
		stage_resizeHandler(null);
		dispatchEvent(new DataProviderEvent(DataProviderEvent.ESTABLISHED, false, false));
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Tracker Modifications
	////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////
	// Methods: Validation Manager
	////////////////////////////////////////////////////////////
	override public function validationComplete():void
	{
		_touchList = null;
		_touchList = new Vector.<int>();
		
		for(var idx:uint=0; idx<_touchQueue.length; idx++)
		_tracker.queueRemoval(
		{
			id: _touchQueue[idx]
		});
		
		_touchQueue = null;
		_touchQueue = new Vector.<int>();
	}
	
	
	////////////////////////////////////////////////////////////
	// Methods: Override
	////////////////////////////////////////////////////////////
	override public function start():void
	{
		ApplicationGlobals.application.stage.addChild(_touchCatcher);
	}
	
	override public function stop():void
	{
		ApplicationGlobals.application.stage.removeChild(_touchCatcher);
	}
	
	override public function restart():void
	{
	}

	////////////////////////////////////////////////////////////
	// Events: TouchCatcher
	////////////////////////////////////////////////////////////
	private function touchCatcher_touchBeginHandler(event:*):void
	{		
		_touchList.push(event.touchPointID);
		_tracker.queueAddition(
		{
			id: event.touchPointID,
			pressure: event.pressure,
			
			x: event.stageX,
			y: event.stageY
		});
	}
	
	private function touchCatcher_touchMoveHandler(event:*):void
	{
		//Logger.log("Native", "touch move: " + event.touchPointID, Logger.NOTICE);
		
		_tracker.queueUpdate(
		{
			id: event.touchPointID,
			pressure: event.pressure,
			
			x: event.stageX,
			y: event.stageY
		});
	}
	
	private function touchCatcher_touchEndHandler(event:*):void
	{
		//Logger.log("Native", "touch end: " + event.touchPointID, Logger.NOTICE);
		
		if (_touchList.indexOf(event.touchPointID) != -1)
		{
			_touchQueue.push(event.touchPointID);
			return;
		}
		
		_tracker.queueRemoval(
		{
			id: event.touchPointID
		});
	}

	////////////////////////////////////////////////////////////
	// Events: Stage
	////////////////////////////////////////////////////////////
	private function stage_resizeHandler(event:Event):void
	{
		var stageWidth:Number = ApplicationGlobals.application.stage.stageWidth;
		var stageHeight:Number = ApplicationGlobals.application.stage.stageHeight;
		
		_touchCatcher.graphics.clear();
		_touchCatcher.graphics.beginFill(0x000000, 0);
		_touchCatcher.graphics.drawRect(0, 0, stageWidth, stageHeight);
		_touchCatcher.graphics.endFill();
	}
	
	////////////////////////////////////////////////////////////
	// Events: TrackerHook
	////////////////////////////////////////////////////////////
	override protected function onTrackerChanged(tracker:ITracker):void
	{
		// do stuff
	}
}
	
}