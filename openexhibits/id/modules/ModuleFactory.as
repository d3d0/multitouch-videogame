////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ModuleFactory.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.modules
{

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.utils.clearInterval;
import flash.utils.getDefinitionByName;
import flash.utils.setInterval;
import flash.utils.Timer;

public class ModuleFactory extends MovieClip implements IModuleFactory
{
	
	include "../core/Version.as" ;

    //--------------------------------------------------------------------------
    //
    //  Static Constants
    //
    //--------------------------------------------------------------------------
	
	public static const PHASE_INIT:String =			"phaseInit";
	public static const PHASE_RSL_LOAD:String =		"phaseRslLoading";
	public static const PHASE_RSL_ERROR:String =	"phaseRslError";
	public static const PHASE_APP_LOAD:String =		"phaseAppLoading";
	public static const PHASE_APP_START:String =	"phaseAppStart";
	public static const PHASE_APP_RUNNING:String =	"phaseAppRunning";
	
	public static const ERROR:String =				"moduleError";
	public static const READY:String =				"moduleReady";

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	private var lastFrame:int;
	private var nextFrameTimer:Timer;
	private var interval:uint;
	
	private var initialized:Boolean;
	private var loaded:Boolean;
	private var ready:Boolean;
	
	private var phase:String = PHASE_INIT;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	public function ModuleFactory()
	{
		super();
		stop();
		
		graphics.clear();
		graphics.beginFill(0x000000, 0.75);
		graphics.drawRect(0, 0, 100, 100);
		graphics.endFill();
		
		interval = setInterval(frameInterval, 100);
		
		nextFrameTimer = new Timer(100);
		nextFrameTimer.addEventListener(TimerEvent.TIMER, nextFrameTimer_timerHandler);
		
		if(!loaderInfo)
		{
			throw new Error("LoaderInfo is non-existant!");
		}
		
		loaderInfo.addEventListener(Event.INIT, initHandler);
		loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	
	private function updatePhase():void
	{
		//trace("update phase");
		
		switch(phase)
		{
			case PHASE_INIT:
			if(!initialized)
			{
				return;
			}
			phase = PHASE_APP_LOAD;
			break;
			
			case PHASE_APP_LOAD:
			if(!loaded)
			{
				return;
			}
			deferredNextFrame();
			phase = PHASE_APP_START;
			break;
			
			case PHASE_APP_START:
			if(!ready)
			{
				return;
			}
			
			clearInterval(interval);
			
			phase = PHASE_APP_RUNNING;
			dispatchEvent(new Event("ready"));
			//loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			break;
		}
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Frame Specific
    //
    //--------------------------------------------------------------------------
	
	private function docFrameHandler():void
	{
		//trace("doc frame handler");
		
		ready = true;
		updatePhase();
		
		if(currentFrame < totalFrames)
		{
			deferredNextFrame();
		}
	}
	
	private function extraFrameHandler():void
	{
		//trace("extra frame handler");
		
		if(currentFrame < totalFrames)
		{
			deferredNextFrame();
		}
	}
	
	private function deferredNextFrame():void
	{
		//trace("deferred next frame");
		if(currentFrame < framesLoaded)
		{
			nextFrame();
		}
		else
		if(!nextFrameTimer.running)
		{
			nextFrameTimer.start();
		}
	}
	
	private function frameInterval():void
	{
		if
		(
			totalFrames > 2 && framesLoaded >=2 ||
			framesLoaded == totalFrames
		)
		{
			loaded = true;
		}
		
		updatePhase();
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: IModuleFactory
    //
    //--------------------------------------------------------------------------
	
	public function create(... params):Object
	{
		//trace("create:", params);
		
		var clsName:String = info()["className"];
		
		if (clsName == null || clsName == "")
		{
			var url:String = loaderInfo.loaderURL;
			clsName = url.substring
			(
				url.lastIndexOf("/") + 1,
				url.lastIndexOf(".")
			);
		}
		
		var cls:Class = getDefinitionByName(clsName) as Class;
		
		return cls ? new cls() : null;
	}
	
	public function info():Object
	{
		// override me
		
		return {};
	}
	
    //--------------------------------------------------------------------------
	//
	//  Events
	//
	//--------------------------------------------------------------------------
	
	private function initHandler(event:Event):void
	{
		//trace("init handler");
		
		initialized = true;
		updatePhase();
		
		loaderInfo.removeEventListener(Event.INIT, initHandler);
	}
	
	private function completeHandler(event:Event):void
	{
		//trace("complete handler");
		
		loaded = true;
		updatePhase();
		
		loaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
	}
	
	private function enterFrameHandler(event:Event = null):void
	{
		//trace(ready, currentFrame, totalFrames);
		if(!ready && currentFrame == 2)
		{
			//trace("enter frame handler :: condition 1");
			if(totalFrames <= 2)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			
			docFrameHandler();
		}
		
		if(!ready)
		{
			//trace("enter frame handler :: condition 2");
			return;
		}

		if(lastFrame == currentFrame)
		{
			//trace("enter frame handler :: condition 3");
			return;
		}
		
		lastFrame = currentFrame;
		
		if(currentFrame == totalFrames)
		{
			//trace("enter frame handler :: condition 4");
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		extraFrameHandler();
	}
	
	private function nextFrameTimer_timerHandler(event:TimerEvent):void
	{
		if(currentFrame < framesLoaded)
		{
			//trace("next frame timer timer_handler :: condition 1");
			nextFrame();
			nextFrameTimer.reset();
		}
	}

}
	
}