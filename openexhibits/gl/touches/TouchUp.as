////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchUp.as
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
	
//import id.core.ITactualObject;
import id.core.TactualObjectState;
import id.core.ITactualObject;

/**
 * Touch up gesture, for use when a user taps with a single finger and then releases.
 * This is similar to the <code>MOUSE_UP</code> AS3 event.
 * 
 * This gesture is made available for event listening via the <code>TouchEvent.TOUCH_UP</code>
 * reference.
 * 
 * The <code>TouchEvent</code> instance passed to an event handler for this gesture
 * will contain no additional informational properties aside from what is innately available
 * on the <code>TouchEvent</code>.
 */
public class TouchUp extends Touch
{

	////////////////////////////////////////////////////////////
	// Initialization: Override
	////////////////////////////////////////////////////////////
	override protected function initialize():void {
		_objCount = 1;
		_objState = TactualObjectState.REMOVED | TactualObjectState.TARGET_CHANGED ;
	}
	
	override public function get priority():uint
	{
        return 128;
		//return (_priority | (1<<8)) | 32 ;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Processing Override & Support
	////////////////////////////////////////////////////////////
	/**
	 * @see gl.core.Descriptor#process()
	 */
	override public function process(... tactualObjects:Array):Object {
		super.process();
		
		var tO:ITactualObject = tactualObjects[0] as ITactualObject;
		eventTarget = tO.hasNewTarget ? tO.oldTarget : null ;
		
		return { };
	}
	
}
	
}