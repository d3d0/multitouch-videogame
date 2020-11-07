////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureRotate.as
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

/**
 * Gesture defining rotation, such as when two fingers are moved around a central
 * point.
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_ROTATE</code>
 * reference.</p>
 * 
 * <p>The <code>GestureEvent</code> instance passed to an event handler for this type of gesture
 * will contain a <code>value</code> property referencing the degree of rotational
 * change.</p>
 * 
 * <pre>
 *  <b>Gesture requirements</b>
 *   objCount="2"
 *   objState="added | updated"
 * 
 *  <b>Gesture extrinsic influences</b>
 *   disables="[]"
 *   restrictive="false"
 * </pre>
 * 
 * @includeExample GestureRotateExample.as
 */
public class GestureRotate extends Gesture
{
    
    /* private static consts */
    private static const RAD_DEG:Number = 180 / Math.PI ;
    
    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void
    {
        _objCount = 2;
        _objState = TactualObjectState.NONE | TactualObjectState.UPDATED;
        _objType = TactualObjectType.POINT | TactualObjectType.CLUSTER ;
        
        _objHistoryCount = 2;
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
        
        var value:Number;
        
        var obj1:ITactualObject = tactualObjects[0] as ITactualObject;
        var obj2:ITactualObject = tactualObjects[1] as ITactualObject;
        
        var n1:uint = obj1.history.length;
        var n2:uint = obj2.history.length;
        
        var x1:int = obj1.x
        var x2:int = obj2.x;
        var x3:int = obj1.history[n1 - 1].x;
        var x4:int = obj2.history[n2 - 1].x;
        
        var y1:int = obj1.y;
        var y2:int = obj2.y;
        var y3:int = obj1.history[n1 - 1].y;
        var y4:int = obj2.history[n2 - 1].y;

        var dx1:int = x1 - x3;
        var dx2:int = x2 - x4;
        var dy1:int = y1 - y3;
        var dy2:int = y2 - y4;

        var dr1:int = Math.sqrt(dx1 * dx1 + dy1 * dy1);
        var dr2:int = Math.sqrt(dx2 * dx2 + dy2 * dy2);
		
        var ratio:Number =
            dr2 && dr1 ? /*int(*/(dr2 / (dr1 + dr2))/* * 10) / 10*/ : !dr2 ? 0 : 1 ;
		
        referencePoint = Point.interpolate
        (
            new Point(x1, y1),
            new Point(x2, y2),
            ratio <= 0.2 ? 0 : ratio >= 0.8 ? 1 : 0.5
        );
        
		//var a1:Number = calcAngle(x1 - x2, y1 - y2);
		//var a2:Number = calcAngle(x3 - x4, y3 - y4);

		//value = a1 - a2;
        value = (calcAngle(x1 - x2, y1 - y2) - calcAngle(x3 - x4, y3 - y4)) || 0 ;
        
		/*
		trace("\n");
		trace(a1);
		trace(a2);
		trace(x1, x2, y1, y2);
		trace(x3, x4, y3, y4);
		trace(value);
		*/
		
        return {
            value: value
        };
    }
    
    private function calcAngle(adjacent:Number, opposite:Number):Number
    {
        if(adjacent == 0)
            return opposite < 0 ? 270 : 90 ;
            
        if(opposite == 0)
            return adjacent < 0 ? 180 : 0 ;
         
        if(opposite > 0)
            return adjacent > 0 ?
                Math.atan(opposite / adjacent) * RAD_DEG :
                180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
        else
            return adjacent > 0 ?
                360 - Math.atan( -opposite / adjacent) * RAD_DEG :
                180 + Math.atan(-opposite / -adjacent) * RAD_DEG ;
            
        return NaN;
    }
    
}
    
}