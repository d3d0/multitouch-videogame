////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PerformanceMonitor.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.ui
{

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.system.System;
import flash.text.TextField;
import flash.utils.getTimer;

/**
 * On-screen performance statistics provided for evaluation of application
 * performance during development.
 * 
 * <p>A PerformanceMonitor instance, when added to the stage, will sit in the upper
 * left corner of the application, and will track the application's frames per 
 * second and total memory usage.</p>
 * 
 * <p>An instance of the PerformanceMonitor class is created at runtime 
 * if the <code>debug</code> configuration value is set to <code>true</code>.</p>
 */
public class PerformanceMonitor extends Sprite
{
	
	////////////////////////////////////////////////////////////
	// Variables
	////////////////////////////////////////////////////////////
	/* objects */
	private var txt_fps:TextField;
	private var txt_memory:TextField;
	
	private var _frames:int;
	private var _memory:Number;
	
	private var _timer:int;
	private var _ms:int;
	private var _mslast:int;
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
     *  Constructor.
     */
	public function PerformanceMonitor() {
		super();
		
		txt_fps = new TextField();
		txt_fps.y = 0;
		txt_fps.height = 15;
		txt_fps.textColor = 0xcccccc;
		addChild(txt_fps);

		txt_memory = new TextField();
		txt_memory.y = 12;
		txt_memory.height = 15;
		txt_memory.textColor = 0xcccccc;
		addChild(txt_memory);
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Event Handlers
	////////////////////////////////////////////////////////////
	private function enterFrameHandler(event:Event):void {
		_timer = getTimer();
		_frames++;
		
		if(_timer - 1000 > _mslast)
		{
			_mslast = _timer;
			_memory = Number((System.totalMemory / 1048576).toFixed(3));
			
			txt_fps.text = "FPS: " + _frames + " / " + stage.frameRate;
			txt_memory.text = "MEM: " + _memory;
			
			_frames = 0;
			
		}
		
	}
}
	
}