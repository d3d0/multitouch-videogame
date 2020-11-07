////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureHold_N.as
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
import flash.utils.getTimer;
import flash.utils.Dictionary;

/**
 * Gesture defining a holding action, such as when two fingers are placed on an object and held in position.
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_HOLD</code>
 * reference.</p>
 * 
 * 
 * <pre>
 *  <b>Gesture requirements</b>
 *   objCount="1"
 *   objState="added | updated"
 * 
 *  <b>Gesture extrinsic influences</b>
 *   disables="[]"
 *   restrictive="false"
 * </pre>
 * 
 * @includeExample GestureHoldExample.as
 */


public class GestureHold_N extends Gesture
{

	protected var pointCount:int = -1;
	
	override protected function initialize():void
	{
		super.initialize();
		
		_objCount = 0;
		_objCountMin = 1;
		_objCountMax = int.MAX_VALUE;
		
		_objState = TactualObjectState.UPDATED | TactualObjectState.NONE | TactualObjectState.REMOVED ;
		_objType = TactualObjectType.POINT;
		
		_objHistoryCount = 2;
	}
	
	override public function process(... tactualObjects:Array):Object
	{
		var k:String;
		var idx:uint;
		
		var points:Array;
		var tO:ITactualObject;
		var tOs:Dictionary;
		
		var dispatachable:Boolean;
		var found:Boolean;
		var time:Number;
		
		/*
		cache =
		{
			dispatched: false,
			points: []
		}
		*/
		
		/**
		 * There are two ways to do this.  I've broken the algorithms out for visibility
		 * purposes only. It would be simple enough to combine both iterative processes
		 * and incure only the overhead of another conditional per iteration.
		 */
		
		if(cache)
		{
			points = cache.points;
			tOs = tracker.tactualObjects;
			
			// if we have dispatched already, verify all origional points still exist
			if(cache.dispatched)
			{
				found = true;
				
				for(idx=0; idx<points.length; idx++)
				{
					tO = tOs[points[idx]];
					if(tO && tO.state != TactualObjectState.REMOVED)
					//if(tOs.hasOwnProperty(points[idx]))
					{
						continue;
					}
					
					found = false;
					break;
				}
				
				tO = null;
				
				if(!found)
				{
					cache.points = null;
					delete cache.points;
					
					cache = null;
				}
				
				return false;
			}
			
			// if we have not dispatched yet, verify all origional points exist and determine
			// if dispatching is required.
			else
			{
				dispatachable = true;
				found = true;
				time = cache.pointTime;
				
				for(idx=0; idx<points.length; idx++)
				{
					if (tOs.hasOwnProperty(points[idx]))
					{
						if(getTimer() - time < 1000)
						{
							dispatachable = false;
							break;
						}
						
						continue;
					}
					
					found = false;
					break;
				}
				
				if(!found)
				{
					cache.points = null;
					delete cache.points;
					
					return false;
				}
				
				if(!dispatachable)
				{
					return false;
				}
				
				cache.dispatched = true;
				referencePoint = new Point(0,0);
				
				return {};
				
				// return dispatachable ? {} : false ;
			}
			
			// we will never get here.
			// for asthetics, I have not removed the above else statement.
		}
		
		// point req check.
		
		if
		(
			(pointCount != -1 && pointCount != tactualObjects.length)
		)
		{
			return null;
		}
		
		cache =
		{
			dispatched: false,
			
			points: [],
			pointTime: getTimer()
		};
		
		points = cache.points;
		
		for(idx=0; idx<tactualObjects.length; idx++)
		{
			points.push(tactualObjects[idx].id);
		}
		
		return false;
	}
	
}

}