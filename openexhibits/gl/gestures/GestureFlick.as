////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureFlick.as
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

/**
 * Gesture defining a flick motion, such as when one finger accelerates across an object.
 *
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_FLICK</code>
 * reference.</p>
 * 
 * <p>The <code>GestureEvent</code> instance passed to an event handler for this type of gesture
 * will contain an <code>accelerationX</code>, and <code>accelerationY</code> property referencing
 * the magnitude of change in x and y positions as well as <code>velocityX</code> and <code>velocityY</code>
 * values referencing the rate of change in x and y positions.</p>
 * 
 * <pre>
 *  <b>Gesture requirements</b>
 *   objCount="1"
 *   objState="removing"
 * 
 *  <b>Gesture extrinsic influences</b>
 *   disables="[]"
 *   restrictive="false"
 * </pre>
 * 
 * @includeExample GestureFlickExample.as
 */
public class GestureFlick extends Gesture
{
    
    /* private static consts */
    private static const SPATIAL_TOLERANCE:Number = 1.0; //1.75;
    private static const TEMPORAL_TOLERANCE:Number = 50;
    
    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void
	{
        _objCount = 1;
        _objState = TactualObjectState.REMOVED;
        _objType = TactualObjectType.POINT;
        
        _objHistoryCount = 4;
    }
    
    ////////////////////////////////////////////////////////////
    // Methods: Processing Override & Support
    ////////////////////////////////////////////////////////////
    /**
     * @see gl.core.Descriptor#process()
     */
    override public function process(... tactualObjects:Array):Object
	{
        super.process();
        
        var obj1:ITactualObject = tactualObjects[0] as ITactualObject;
        
        var n:uint = obj1.history.length;
        var history:Vector.<Object> = obj1.history;

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
            return false;
        
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