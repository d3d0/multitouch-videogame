////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Gesture.as
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

import id.core.Descriptor;
import id.core.TactualObjectType;

public class Gesture extends Descriptor implements IGesture
{
	
	public function Gesture()
	{
		_objType = TactualObjectType.CLUSTER | TactualObjectType.POINT ;
		
		super();
	}
	
	override public function get priority():uint
	{
		return (super.priority | (1<<8)) << 8 ;
	}
	
}
	
}