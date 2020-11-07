////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureTwoFingerTap.as
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

public class GestureTwoFingerTap extends Gesture
{
    
    /* private static consts */
	private static const DISTANCE_TOLERANCE:Number = 15;
    
    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void {
        _objCount = 2;
        _objState = TactualObjectState.REMOVED;
        _objType = TactualObjectType.POINT;
        
        _objHistoryCount = 1;
    }
    
    ////////////////////////////////////////////////////////////
    // Methods: Processing Override & Support
    ////////////////////////////////////////////////////////////
    /**
     * @see gl.core.Descriptor#process()
     */
    override public function process(... tactualObjects:Array):Object {
        super.process();
		
		var idx:uint;
		var tO:ITactualObject;
		
		for(idx=0; idx<tactualObjects.length; idx++)
		{
			tO = tactualObjects[idx];
			if(tO.existences != 1)
			{
				return null;
			}
			
			if
			(
			 	Math.abs(tO.history[0].x - tO.x) > DISTANCE_TOLERANCE ||
				Math.abs(tO.history[0].y - tO.y) > DISTANCE_TOLERANCE
			)
			{
				return null;
			}
		}
		
		var pt1:Point = new Point(tactualObjects[0].x, tactualObjects[0].y);
		var pt2:Point = new Point(tactualObjects[1].x, tactualObjects[1].y);
		
		referencePoint = Point.interpolate(pt1, pt2, 0.5);
		
		return { };
        
    }
    
}

}