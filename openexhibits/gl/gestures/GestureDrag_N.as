////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureDrag_N.as
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
 * Gesture defining a dragging motion, such as when two fingers move over an object.
 *
 * <p>This gesture is made available for event listening via the <code>GestureEvent.GESTURE_DRAG</code>
 * reference.</p>
 * 
 * <p>The <code>GestureEvent</code> instance passed to an event handler for this type of gesture
 * will contain the <code>dx</code> and <code>dy</code> properties referencing the magnitude of the displacement in the x and y direction.</p>
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
 * @includeExample GestureDragExample.as
 */

public class GestureDrag_N extends Gesture
{

	protected var pointCount:int = -1;
	
	override protected function initialize():void
	{
		super.initialize();
		
		_objCount = 0;
		_objCountMin = 1;
		_objCountMax = int.MAX_VALUE;
		
		_objState = TactualObjectState.UPDATED;
		_objType = TactualObjectType.POINT;
		
		_objHistoryCount = 2;
	}
	
	override public function process(... tactualObjects:Array):Object
	{
		if
		(
			//(pointCount != -1 && pointCount != tactualObjects.length)
			pointCount != -1 &&
			pointCount != tactualObjects.length &&
			!(_objType & TactualObjectType.CLUSTER)
		)
		{
			return null;
		}
		
		var cpt_x:Number = 0;
		var cpt_y:Number = 0;
		
		var ppt_x:Number = 0;
		var ppt_y:Number = 0;
		
		var n:uint;
		var u:uint = tactualObjects.length
		
		var idx:int;
		var tO:ITactualObject;
		
		for(idx=0; idx<u; idx++)
		{
			tO = tactualObjects[idx];
			n = tO.history.length;
			
			cpt_x += tO.x;
			cpt_y += tO.y;
			
			ppt_x += tO.history[n - 1].x;
			ppt_y += tO.history[n - 1].y;
		}
		
		cpt_x /= u;
		cpt_y /= u;
		
		ppt_x /= u;
		ppt_y /= u;
		
		referencePoint = new Point(cpt_x, cpt_y);
		
		var draggingReference = tO.owner.parent;
		if (draggingReference)
		{
			var cpt:Point = draggingReference.globalToLocal(new Point(cpt_x, cpt_y));
			var ppt:Point = draggingReference.globalToLocal(new Point(ppt_x, ppt_y));
			
			cpt_x = cpt.x;
			cpt_y = cpt.y;
			
			ppt_x = ppt.x;
			ppt_y = ppt.y;
		}
		
		return {
			dx: cpt_x - ppt_x,
			dy: cpt_y - ppt_y
		}
		
	}

}

}