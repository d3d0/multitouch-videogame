////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureScale_N.as
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

import id.core.ICluster;
import id.core.ITactualObject;
import id.core.TactualObjectState;
import id.core.TactualObjectType;

import flash.geom.Point;

public class GestureScale_N extends GestureRotate
{
	
	private static const RAD_DEG:Number = 180 / Math.PI ;
	
	protected var pointCount:int = -1;
	
	override protected function initialize():void
	{
		super.initialize();
		
		_objCount = 0;
		_objCountMin = 2;
		_objCountMax = int.MAX_VALUE;
		
		_objState = TactualObjectState.NONE | TactualObjectState.UPDATED ;
		_objType = TactualObjectType.POINT | TactualObjectType.CLUSTER ;
		
		_objHistoryCount = 2;
	}
	
	override public function process(... tactualObjects:Array):Object
	{
		var idx:int;
		
		if
		(
			pointCount != -1 &&
			pointCount != tactualObjects.length &&
			!(_objType & TactualObjectType.CLUSTER)
		)
		{
			return null;
		}
		
		/**
		 * Algorithm
		 */
		
        var initialWidth:int;
        var initialScale:Number;
        
        var value:Number;
		
        var obj1:ITactualObject = tactualObjects[0] as ITactualObject;
        var obj2:ITactualObject = tactualObjects[1] as ITactualObject;
        
        var n1:uint = obj1.history.length;
        var n2:uint = obj2.history.length;
        
        var x1:int = obj1.x
        var x2:int = obj2.x;
        var x3:int = obj1.history[n1 - 1].x;
        var x4:int = obj2.history[n2 - 1].x;
        var x5:int = obj1.history[0].x;
        var x6:int = obj2.history[0].x;
        
        var y1:int = obj1.y;
        var y2:int = obj2.y;
        var y3:int = obj1.history[n1 - 1].y;
        var y4:int = obj2.history[n2 - 1].y;
        var y5:int = obj1.history[0].y;
        var y6:int = obj2.history[0].y;

        var dx1:int = x1 - x3;
        var dx2:int = x2 - x4;
        var dx3:int;
        
        var dy1:int = y1 - y3;
        var dy2:int = y2 - y4;
        var dy3:int;

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

        dx1 = x2 - x1;
        dy1 = y2 - y1;
        dx2 = x4 - x3;
        dy2 = y4 - y3;

        dr1 = Math.sqrt(dx1 * dx1 + dy1 * dy1);
        dr2 = Math.sqrt(dx2 * dx2 + dy2 * dy2);
        
        initialWidth = history ? history.initialWidth : null ;
        initialScale = history ? history.initialScale :
            int
            (
            ((obj1.owner.scaleX + obj1.owner.scaleY) / 2) * 10
            )
            / 10
        ;

        if(!initialWidth)
        {
            dx3 = x5 - x6;
            dy3 = y5 - y6;
            initialWidth = Math.sqrt(dx3 * dx3 + dy3 * dy3);
        }

        value = (dr1 - dr2) / (initialWidth / initialScale);

        return {
            value: value,
            
            initialWidth: initialWidth,
            initialScale: initialScale
        };
	}

}

}