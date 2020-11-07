////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Gesture_N_Finger_N_Tap.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package gl.gestures
{

import id.core.ITactualObject;
import id.core.TactualObjectState;
import id.core.TactualObjectType;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class Gesture_N_Finger_N_Tap extends Gesture
{

	protected var pointCount:int = -1;
	protected var pointExistences:int = -1;

	override protected function initialize():void
	{
		super.initialize();
		
		_objCount = 0;
		_objCountMin = 1;
		_objCountMax = int.MAX_VALUE;
		
		_objState = TactualObjectState.ADDED | TactualObjectState.REMOVED ;
		_objType = TactualObjectType.POINT;
		
		//_objHistoryCount = 2;
	}
	
	override public function process(... tactualObjects:Array):Object
	{
		if(pointExistences == -1)
		{
			return null;
		}
		
		var k:String;
		var idx:int;
		
		//var count:uint;
		//var existences:uint;
		
		var tO:ITactualObject;
		
		if (cache && cache.timedout)
		{
			//cache.existences = null;
			//delete cache.existences;
			
			cache = null;
		}
		
		cache = cache ||
		{
			timeout: -1,
			timedout: false,
			
			existences: 0 //[]
		}
		
		//existences = cache.existences;
		
		for(idx=0; idx<tactualObjects.length; idx++)
		{
			tO = tactualObjects[idx];
			
			//trace("state(" + tO.id + "):", tO.state, tO.existences);
			
			if
			(
				tO.state != TactualObjectState.ADDED ||
				tO.existences != pointExistences
			)
			{
				continue;
			}
			
			//existences.push(tO.existences);
			
			cache.existences++;
		}
		
		/*
		existences.sort(Array.NUMERIC);
		
		for(idx=existences.length - 1; idx>=0; idx--)
		{
			trace(existences[idx]);
			if(existences[idx] == pointExistences)
			{
				count++;
			}
		}
		
		trace(count, pointCount);
		*/
		
		//trace(cache.existences, pointCount);
		
		if(cache.existences != pointCount)
		{
			clearTimeout(cache.timeout);
			cache.timeout = setTimeout(
			function():void
			{
				cache.timedout = true;
			},
			400);
			
			return null;
		}
		
		clearTimeout(cache.timeout);
		
		//cache.existences = null;
		//delete cache.existences;
		
		cache = null;
		
		referencePoint = new Point(0, 0);
		return {};
	}
	
}

}