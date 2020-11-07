////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureTilt_YZ.as
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
 * Gesture defining a tilting motion in 3D, such as when two fingers are placed on stage and helo in position and a third finger move move vertically or horizontally.
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_TILT</code>
 * reference.</p>
 * 
 * <p>The <code>GestureEvent</code> instance passed to an event handler for this type of gesture
 * will contain a <code>tiltX</code> property referencing the magnitude of the rotation in the ZY plane.</p>
 * 
 * <pre>
 *  <b>Gesture requirements</b>
 *   objCount="3"
 *   objState="added | updated"
 * 
 *  <b>Gesture extrinsic influences</b>
 *   disables="[
 *		"gestureRotate",
 *       "gestureScale",
 *       "gestureScroll",
 *       "touchMove"]"
 *   restrictive="false"
 * </pre>
 * 
 * @includeExample GestureTiltYZExample.as
 */
public class GestureTilt_YZ extends Gesture
{

    ////////////////////////////////////////////////////////////
    // Initialization: Override
    ////////////////////////////////////////////////////////////
    override protected function initialize():void {
        _objCount = 3;
        _objState = TactualObjectState.NONE | TactualObjectState.UPDATED ;
        _objType = TactualObjectType.POINT;
        
        _objHistoryCount = 1;
        
        _disables =
        [
         "gestureRotate",
         "gestureScale",
         "gestureScroll",
         "touchMove"
        ];
        
        //_objPrecision = "exact";
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
        var obj3:ITactualObject = tactualObjects[2] as ITactualObject;

        var lpt1:Point = new Point(obj1.x, obj1.y);
        var lpt2:Point = new Point(obj2.x, obj2.y);
        var lpt3:Point = new Point(obj3.x, obj3.y);

        var n1:int = obj1.history.length;
        var n2:int = obj2.history.length;
        var n3:int = obj3.history.length;

        var ppt1:Point = n1 ?
            new Point
            (
                obj1.history[n1 - 1].x,
				obj1.history[n3 - 1].y
            ) :
            new Point(obj1.x, obj1.y);
            
        var ppt2:Point = n2 ?
            new Point
            (
                obj2.history[n2 - 1].x,
				obj2.history[n3 - 1].y
            ) :
            new Point(obj2.x, obj2.y);
            
        var ppt3:Point = n3 ?
            new Point
            (
                obj3.history[n3 - 1].x,
                obj3.history[n3 - 1].y
            ) :
            new Point(obj3.x, obj3.y);

        var cpt1:Point = new Point
        (
            (lpt1.x + lpt2.x + lpt3.x) / 3,
			(lpt1.y + lpt2.y + lpt3.y) / 3
        );
        
        var cpt2:Point = new Point
        (
            (ppt1.x + ppt2.x + ppt3.x) / 3,
			(ppt1.y + ppt2.y + ppt3.y) / 3
        );

        referencePoint = cpt1;
        
        return {
            tiltX: cpt1.x - cpt2.x
        };
        
    }
    
}
    
}