////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	HistoryObject.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{

import flash.events.EventDispatcher;

public class HistoryObject extends EventDispatcher implements IHistoryObject
{

	////////////////////////////////////////////////////////////
	// Variables
	////////////////////////////////////////////////////////////
	
	private static const MAX_HISTORY:uint = 200;
	private static const MAX_HISTORY_CLEANED:uint = 60;
	private static const MAX_HISTORY_SEGMENTS:uint = 10;
	
	protected var _creationTime:Number;
	
	protected var _history:Vector.<Object> = new Vector.<Object>();
	protected var _historySegments:Array = [];

	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	public function get creationTime():Number { return _creationTime; }
	public function set creationTime(value:Number):void {
		_creationTime = value;
	}
	
	public function get history():Vector.<Object> {
		return _history;
	}
	
	public function get combinedHistory():Vector.<Object>
	{
		var idx:int;
		var ret:Vector.<Object> = new Vector.<Object>();
		
		for(idx=0; idx<_historySegments.length; idx++)
		{
			ret = ret.concat(_historySegments[idx]);
		}
		
		return ret.concat(_history);
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	public function pushSnapshot():void {
		_history.push(info());
		
		if (_history.length >= MAX_HISTORY)
		{
			_history.splice(0, MAX_HISTORY - MAX_HISTORY_CLEANED);
		}
		
		if(_historySegments.length >= MAX_HISTORY_SEGMENTS)
		{
			_historySegments.splice(0, MAX_HISTORY_SEGMENTS);
		}
	}
	
	public function segment():void {
		_historySegments.push(_history);
		_history = new Vector.<Object>();
	}
	
	public function info():Object
	{
		// override me
		return { };
	}

}
	
}