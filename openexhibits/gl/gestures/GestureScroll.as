////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureScroll.as
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

import flash.display.DisplayObject;
import flash.geom.Point;
import flash.system.Capabilities;

/**
 * Gesture defining a scrolling motion, such as when two adjacent fingers move together
 * along a line.
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_SCROLL</code>
 * reference.</p> 
 * 
 * <p>The <code>GestureEvent</code> instance passed to an event handler for this type of gesture
 * will contain a <code>scrollX</code> property referencing the scroll gesture's horizontal 
 * magnitude, and a <code>scrollY</code> property referencing the gesture's vertical magnitude.</p>
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
 * @includeExample GestureScrollExample.as
 */
public class GestureScroll extends Gesture
{
    
    /* private static consts */
    //private static const SPATIAL_TOLERANCE:Number = 100
	
    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void {
        _objCount = 2;
        _objState = TactualObjectState.NONE | TactualObjectState.UPDATED ;
        _objType = TactualObjectType.POINT;
        
        _objHistoryCount = 1;
        
        _disables = 
        [
         "gestureRotate",
         "gestureScale",
         "touchMove"
        ];
    }
    
    ////////////////////////////////////////////////////////////
    // Methods: Processing Override & Support
    ////////////////////////////////////////////////////////////
    /**
     * @see gl.core.Descriptor#process()
     */
    override public function process(... tactualObjects:Array):Object {
        super.process();

        var obj1:ITactualObject = tactualObjects[0] as ITactualObject;
        var obj2:ITactualObject = tactualObjects[1] as ITactualObject;

		/*
		var distance:int = Point.distance
		(
			new Point(obj1.x, obj1.y),
			new Point(obj2.x, obj2.y)
		);
		
		trace(distance);
		
		if (distance > SPATIAL_TOLERANCE)
		{
			return false;
		}
		*/

        var owner:DisplayObject = obj1.owner;
        
        var lpt1:Point = owner.globalToLocal(new Point(obj1.x, obj1.y));
        var lpt2:Point = owner.globalToLocal(new Point(obj2.x, obj2.y));
        
        var n1:int = obj1.history.length;
        var n2:int = obj2.history.length;
        
        var ppt1:Point = owner.globalToLocal
        (
            n1 ?
            new Point
            (
                obj1.history[n1 - 1].x,
                obj1.history[n1 - 1].y
            ) :
            new Point
            (
                obj1.x,
                obj1.y
            )
        );
        
        var ppt2:Point = owner.globalToLocal
        (
            n2 ?
            new Point
            (
                obj2.history[n2 - 1].x,
                obj2.history[n2 - 1].y
            ) :
            new Point
            (
                obj2.x,
                obj2.y
            )
        );

        var cpt1:Point = Point.interpolate(lpt1, lpt2, 0.5);
        var cpt2:Point = Point.interpolate(ppt1, ppt2, 0.5);

        referencePoint = Point.interpolate(cpt1, cpt2, 0.5);
        
        return {
            scrollX: cpt1.x - cpt2.x,
            scrollY: cpt1.y - cpt2.y
        };
    }
    
}
    
}