////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchMove.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.touches
{
	
import id.core.ITactualObject;
import id.core.TactualObjectState;
import flash.geom.Point;

/**
 * Touch move gesture, for use when a user drags a single finger. This is
 * similar to the <code>MOUSE_MOVE</code> AS3 event.
 * 
 * <p>This gesture is made available for event listening via the <code>TouchEvent.TOUCH_DOWN</code>
 * reference.</p>
 * 
 * <p>The <code>TouchEvent</code> instance passed to an event handler for this gesture
 * will contain the following informational properties, aside from what is innately
 * available on the <code>TouchEvent</code>:</p>
 * 
 * <ul>
 * 	<li>
 * 		<strong>dx</strong>:
 * 			The horizontal magnitude of change since the last TouchMove event was processed.
 * 	</li>
 * 
 * 	<li>
 * 		<strong>dy</strong>:
 * 			The vertical magnitude of change since the last TouchMove event was processed.
 * 	</li>
 * </ul>
 * 
 * 
 */
public class TouchMove extends Touch
{

	////////////////////////////////////////////////////////////
	// Initialization: Override
	////////////////////////////////////////////////////////////
	override protected function initialize():void {
		_objCount = 1;
		_objState = TactualObjectState.UPDATED;
		
		_objHistoryCount = 1;
	}
	
	override public function get priority():uint
	{
        return 192;
		//return (_priority | (1<<8)) | 64 ;
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
		var n:uint = obj1.history.length;
		
		//var history1:Point = obj1.target.
		//var history2:Point = obj1.target.globalToLocal(new Point(obj1.history[n - 1].x, obj1.history[n - 1].y));
		
		var dx:int = obj1.x - obj1.history[n - 1].x;
		var dy:int = obj1.y - obj1.history[n - 1].y;
		
		if(!dx && !dy)
		{
			return null;
		}
		
		return {
			dx: dx,
			dy: dy
		};
	}
	
}
	
}