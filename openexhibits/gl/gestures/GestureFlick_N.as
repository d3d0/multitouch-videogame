////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureFlick_N.as
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

import id.core.ICluster;
import id.core.ITactualObject;
import id.core.TactualObjectState;
import id.core.TactualObjectType;

import flash.geom.Point;
import flash.utils.getTimer;

public class GestureFlick_N extends Gesture
{

    private static const SPATIAL_TOLERANCE:Number = 1.0;
    private static const TEMPORAL_TOLERANCE:Number = 50;

	protected var pointCount:int = -1;

	override protected function initialize():void
	{
		super.initialize();
		
		_objCount = 1;
		
		_objState = TactualObjectState.UPDATED | TactualObjectState.REMOVED;
		_objType = TactualObjectType.POINT | TactualObjectType.CLUSTER;
	}
	
	override public function process(... tactualObjects:Array):Object
	{
		var idx:int;
		
		var tC:ICluster = tactualObjects[0] as ICluster;
		var tO:ITactualObject;
		
		// tO = tactualObjects[0];
		
		//trace("---> GestureFlick_N(" + pointCount + ")::" + (tO.type == TactualObjectType.POINT ? "POINT" : "CLUSTER"), tO.state, tO.target.toString());
		
		/*
		// this works for 1+ points //2+ points unless N or 2
		if(!tC && pointCount > 2) //(pointCount != -1 || pointCount != 2))
		{
			return null;
		}
		*/
		
		/**
		 * Starting Conditions
		 */
		 
		if(!this.cache)
		{
			// N Points
			if(pointCount == -1)
			{
				cache = {};
			}
			
			// 2+ Points
			else
			if(tC && tC.tactualObjectCount == pointCount)
			{
				cache = {ids: []/*, x: [], y: []*/};
				
				for(idx=0; idx<tC.tactualObjectCount; idx++)
				{
					tO = tC.tactualObjects[idx];
					
					cache.ids.push(tO.id);
					trace(tO.id);
					//cache.x.push(tO.x);
					//cache.y.push(tO.y);
				}
			}
			
			return null;
		}
		
		var complete:Boolean;
		var found:Boolean;
		var tX:ITactualObject;
		
		tO = tactualObjects[0] as ITactualObject;
		
		/**
		 * Ending Conditions
		 */
		
		// N Points
		if(pointCount == -1)
		{
			//if(tC || tO.state != TactualObjectState.REMOVED)
			if(!tC && tO.state == TactualObjectState.REMOVED)
			{
				complete = true;
			}
		}
		
		/*
		// 2 Points || 5 Points
		else
		if(pointCount == 2 || pointCount == 5)
		{
			if(!tC && tO.state == TactualObjectState.REMOVED)
			{
				complete = true;
			}
		}
		*/
		
		// > 2 Points
		else
		//if(tC)
		{
			for(idx=0; idx<cache.ids.length; idx++)
			{
				tX = tracker.tactualObjects[cache.ids[idx]];
				if(!tX || tX.state == TactualObjectState.REMOVED)
				{
					continue;
				}
				
				found = true;
				break;
			}
			
			if(!found)
			{
				complete = true;
			}
		}
		
		// return if !complete
		if(!complete)
		{
			return null;
		}
		
		cache = null;
		
		
		/**
		 * Algorithm
		 */
		
        var history:Vector.<Object> = tO.combinedHistory;
		var n:uint = history.length;
		
		if(n < 4)
		{
			return null;
		}
		
        if(getTimer() - history[n - 1].time > TEMPORAL_TOLERANCE)
        {
            return null;
        }
		
        var dtaX:Number = history[n - 2].x - history[n - 3].x;
        var dtbX:Number = history[n - 3].x - history[n - 4].x;
        
        var dtaY:Number = history[n - 2].y - history[n - 3].y;
        var dtbY:Number = history[n - 3].y - history[n - 4].y;
        
        var ddtX:Number = dtaX - dtbX;
        var ddtY:Number = dtaY - dtbY;
        
        if(Math.abs(ddtX) < SPATIAL_TOLERANCE && Math.abs(ddtY) < SPATIAL_TOLERANCE)
		{
			trace("returning here @ spacial");
            return null;
		}
		
		referencePoint = new Point(history[0].x, history[0].y);
		
		return {
            accelerationX: ddtX,
            accelerationY: ddtY,
            velocityX: dtaX,
            velocityY: dtaY
        };
	}

}

}