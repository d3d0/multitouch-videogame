////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Simulator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.data.simulator
{

import id.core.ApplicationGlobals;
import id.data.IInputProvider;
import id.system.SystemHook;
import id.tracker.ITracker;
import id.utils.Enumerable;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.errors.IllegalOperationError;
import flash.ui.Keyboard;

public class Simulator extends SystemHook implements IInputProvider
{
	
	private var _mouseCatcher:Sprite;
	private var _mouseObject:SimulatorObject;
	
	private var _touchList:Vector.<int>;
	private var _touchQueue:Vector.<int>;
	
	private var _simulatorObjects:Vector.<SimulatorObject>;
	
	private var _settings:Enumerable;
	
	////////////////////////////////////////////////////////////
	// Constructors, Destructors, and Initializers
	////////////////////////////////////////////////////////////
	public function Simulator()
	{
		_mouseCatcher = new Sprite();
		_mouseCatcher.doubleClickEnabled = true;
		
		_touchList = new Vector.<int>();
		_touchQueue = new Vector.<int>();
		
		_mouseCatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseCatcher_mouseDownHandler);
		_mouseCatcher.addEventListener(MouseEvent.MOUSE_UP, mouseCatcher_mouseUpHandler);
		_mouseCatcher.addEventListener(MouseEvent.DOUBLE_CLICK, mouseCatcher_mouseDoubleClickHandler);
		
		_simulatorObjects = new Vector.<SimulatorObject>();
	}
	
	override public function Dispose():void
	{
		if (_mouseCatcher.parent)
		{
			_mouseCatcher.parent.removeChild(_mouseCatcher);
		}
		
		_mouseCatcher.removeEventListener(MouseEvent.MOUSE_DOWN, mouseCatcher_mouseDownHandler);
		_mouseCatcher.removeEventListener(MouseEvent.MOUSE_UP, mouseCatcher_mouseUpHandler);
		_mouseCatcher.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseCatcher_mouseDoubleClickHandler);
		
		for each(var sO:SimulatorObject in _simulatorObjects)
		{
			sO.Dispose();
			sO = null;
		}
		
		_simulatorObjects = null;
		
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
		
		ApplicationGlobals.application.stage.addChild(_mouseCatcher);
		ApplicationGlobals.application.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		
		stage_resizeHandler(null);
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Validation Manager
	////////////////////////////////////////////////////////////
	/*
	override public function validationBeginning():void
	{
		var sO:SimulatorObject;
		
		for each(sO in _simulatorObjects)
		_tracker.queueUpdate(
		{
			id: sO.id,
			x: sO.x,
			y: sO.y
		});
	}
	*/
	
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
	// Methods: Tracker Modifications
	////////////////////////////////////////////////////////////
	private function sendAddition(sO:SimulatorObject):void
	{
		_touchList.push(sO.id);
		_tracker.queueAddition(
		{
			id: sO.id,
			x: sO.x,
			y: sO.y
		});
	}
	
	private function sendRemoval(sO:SimulatorObject):void
	{
		if (_touchList.indexOf(sO.id) != -1)
		{
			_touchQueue.push(sO.id);
			return;
		}
		
		_tracker.queueRemoval(
		{
			id: sO.id
		});
	}
	
	private function sendUpdate(sO:SimulatorObject):void
	{
		_tracker.queueUpdate(
		{
			id: sO.id,
			x: sO.x,
			y: sO.y
		});
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Override
	////////////////////////////////////////////////////////////
	override public function start():void
	{
		ApplicationGlobals.application.stage.addChild(_mouseCatcher);
	}
	
	override public function stop():void
	{
		ApplicationGlobals.application.stage.removeChild(_mouseCatcher);
	}
	
	override public function restart():void
	{
	}

	////////////////////////////////////////////////////////////
	// Events: MouseCatcher
	////////////////////////////////////////////////////////////
	private function mouseCatcher_mouseDownHandler(event:MouseEvent):void
	{
		if(_mouseObject)
		{
			mouseCatcher_mouseUpHandler(null);
		}
		
		// determine the point
		_mouseObject = event.target as SimulatorObject;
		if(!_mouseObject)
		{
			_mouseObject = new SimulatorObject();
			_mouseObject.x = event.stageX;
			_mouseObject.y = event.stageY;
		
			_simulatorObjects.push(_mouseObject);
			
			sendAddition(_mouseObject);
		}

		// add point
		if(event.shiftKey || event.ctrlKey)
		{
			_mouseCatcher.addChild(_mouseObject);
		}
		
		_mouseCatcher.addEventListener(MouseEvent.MOUSE_MOVE, mouseCatcher_mouseMoveHandler);
	}
	
	private function mouseCatcher_mouseMoveHandler(event:MouseEvent):void
	{
		_mouseObject.x = event.stageX;
		_mouseObject.y = event.stageY;
		
		sendUpdate(_mouseObject);
	}
	
	private function mouseCatcher_mouseUpHandler(event:MouseEvent):void
	{
		if(!_mouseObject.parent)
		{
			_simulatorObjects.pop();
			sendRemoval(_mouseObject);
		}

		_mouseObject = undefined;
		_mouseCatcher.removeEventListener(MouseEvent.MOUSE_MOVE, mouseCatcher_mouseMoveHandler);
	}

	private function mouseCatcher_mouseDoubleClickHandler(event:MouseEvent):void
	{
		if(event.target == _mouseCatcher)
		{
			return;
		}
		
		_mouseObject = event.target as SimulatorObject;
		
		var index:int = _simulatorObjects.indexOf(_mouseObject)
		if (index == -1)
		{
			throw new Error("Simulator object not found!");
		}
		
		sendRemoval(_mouseObject);
		
		_mouseObject.Dispose();
		_mouseObject = null;
		
		_simulatorObjects.splice(index, 1);
	}

	////////////////////////////////////////////////////////////
	// Events: Stage
	////////////////////////////////////////////////////////////
	private function stage_resizeHandler(event:Event):void
	{
		var stageWidth:Number = ApplicationGlobals.application.stage.stageWidth;
		var stageHeight:Number = ApplicationGlobals.application.stage.stageHeight;
		
		_mouseCatcher.graphics.clear();
		_mouseCatcher.graphics.beginFill(0x000000, 0);
		_mouseCatcher.graphics.drawRect(0, 0, stageWidth, stageHeight);
		_mouseCatcher.graphics.endFill();
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

import id.core.ApplicationGlobals;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.display.SpreadMethod;
import flash.events.MouseEvent;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilterQuality;
import flash.geom.Matrix;

class SimulatorObject extends Sprite
{
	private static var _bevel:BevelFilter =
	new BevelFilter(
		3,
		45,
		0xFFFFFF,
		100,
		0x000000,
		100,
		4,
		4,
		0.5,
		BitmapFilterQuality.HIGH,
		"inner"
	);
	
	private static var _colors:Array =
	[
		0x333399,
		0x3333FF
	];
	
	private static var _alphas:Array =
	[
		1.0,
		1.0
	];
	
	private static var _ratios:Array =
	[
		0x00,
		0xFF
	];
	
	private static var _matrix:Matrix;
	
	private static var _count:int = 0;
	private var _id:int;
	
	public function SimulatorObject()
	{
		if(!_matrix)
		{
			_matrix = new Matrix();
			_matrix.createGradientBox(6, 6, 180, -6, 0);
		}
		
		doubleClickEnabled = true;

		if (_count == int.MAX_VALUE)
		{
			_count = 0;
		}

		_id = _count;
		_count++;

		draw();

		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}
	
	public function Dispose():void
	{
		filters = null;
		
		if (parent)
			parent.removeChild(this);
		
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}
	
	public function get id():int { return _id; }
	
	public function draw():void
	{
		graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix, SpreadMethod.PAD);
		graphics.drawCircle(0, 0, 6);
		graphics.endFill();
		
		this.filters = [_bevel];
	}
	
	private function mouseOverHandler(event:MouseEvent):void
	{
		// glow
	}
	
	private function mouseOutHandler(event:MouseEvent):void
	{
		// unglow
	}
	
}