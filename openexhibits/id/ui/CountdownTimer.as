////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	CountdownTimer.as
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

import id.utils.StringUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

[ExcludeClass]

/**
 * @private
 */
public class CountdownTimer extends Sprite
{
	
	private var _duration:Number;
	
	private var _hours:int;
	private var _minutes:int;
	private var _seconds:int;
	//var _milliseconds:int;

	private var _timer:Timer;
	private var _textField:TextField;
	private var _textFormat:TextFormat;
	
	private var _prefix:String = "";

	public function CountdownTimer()
	{
		super();
		
		mouseChildren = false;
		
		_timer = new Timer(1000);
		_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		
		_textFormat = new TextFormat("Arial", 24, 0xFFFFFF);
		
		_textField = new TextField();
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.defaultTextFormat = _textFormat;
		
		setText();

		addChild(_textField);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	public function set duration(value:Number):void
	{
		if(_timer.running)
			return;
		
		// round off based on the timer's precision
		_duration = Math.round(value / _timer.delay) * _timer.delay ;
		_timer.repeatCount = _duration / _timer.delay ;		
		
		_hours = _duration / (1000 * 60 * 60) ;
		_minutes = (_duration - (_hours * 1000 * 60 * 60)) / (1000 * 60);
		_seconds = (_duration - (_hours * 1000 * 60 * 60) - (_minutes * 1000 * 60)) / (1000) ;
		
		setText();
	}
	
	public function set prefix(value:String):void
	{
		_prefix = value;
		setText();
	}
	

	public function start():void
	{
		_timer.start();
	}
	
	public function stop():void
	{
		_timer.stop();
	}
	
	public function reset():void
	{
	}
	
	private function setText():void
	{
		_textField.text = _prefix + StringUtil.padLeft(String(_hours), "0", 2) + ":" + StringUtil.padLeft(String(_minutes), "0", 2) + ":" + StringUtil.padLeft(String(_seconds), "0", 2);
	}
	
	private function timerHandler(event:TimerEvent):void
	{
		var currentTime:Number = (_duration - _timer.currentCount * _timer.delay);
		
		_hours = currentTime / (1000 * 60 * 60) ;
		_minutes = (currentTime - (_hours * 1000 * 60 * 60)) / (1000 * 60);
		_seconds = (currentTime - (_hours * 1000 * 60 * 60) - (_minutes * 1000 * 60)) / (1000) ;
		
		setText();
	}
	
	private function timerCompleteHandler(event:TimerEvent):void
	{
		_timer.reset();
		dispatchEvent(event);
	}
	
	private function addedToStageHandler(event:Event):void
	{
		// pixel color sampling
		
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
}

}