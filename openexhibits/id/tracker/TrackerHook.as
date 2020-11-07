////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TrackerHook.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.tracker
{

import id.core.IDisposable;
import flash.events.EventDispatcher;

public class TrackerHook extends EventDispatcher implements ITrackerHook, IDisposable
{
	
	protected var _tracker:ITracker;
	
	public function TrackerHook()
	{
		//tracker = Tracker.getInstance();
	}
	
	public function Dispose():void
	{
		// override me
	}
	
	public function get tracker():ITracker { return _tracker; }
	public function set tracker(value:ITracker):void
	{
		if(value == _tracker)
			return;

		_tracker = value;
		onTrackerChanged(value);
	}
	
	public function start():void { }
	public function stop():void { }
	public function restart():void { }
	
	protected function onTrackerChanged(tracker:ITracker):void
	{
		// override me
	}
	
}

}