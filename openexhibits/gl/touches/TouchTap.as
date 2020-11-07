////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchTap.as
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
 * Touch tap gesture, for use when a user taps with a single finger. This is
 * similar to the <code>CLICK</code> AS3 event.
 * 
 * This gesture is made available for event listening via the <code>TouchEvent.TOUCH_TAP</code>
 * reference.
 * 
 * The <code>TouchEvent</code> instance passed to an event handler for this gesture
 * will contain no additional informational properties aside from what is innately available
 * on the <code>TouchEvent</code>.
 */
public class TouchTap extends Touch
{

	/* private static consts */
	private static const DISTANCE_TOLERANCE:Number = 15;
	
	////////////////////////////////////////////////////////////
	// Initialization: Override
	////////////////////////////////////////////////////////////
	override protected function initialize():void {
		_objCount = 1;
		_objState = TactualObjectState.REMOVED;
		
		_objHistoryCount = 1;
	}
	
	override public function get priority():uint
	{
        return 64;
		//return (_priority | (1<<8)) | 16 ;
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
		if (obj1.existences != 1)
			return null;
        
        var x1:int = obj1.history[0].x;
        var y1:int = obj1.history[0].y;

        var x2:int = obj1.x;
        var y2:int = obj1.y;
		
		if(Math.abs(x1 - x2) > DISTANCE_TOLERANCE || Math.abs(y1 - y2) > DISTANCE_TOLERANCE)
			return null;
		
		return { };
	}
	
}
	
}