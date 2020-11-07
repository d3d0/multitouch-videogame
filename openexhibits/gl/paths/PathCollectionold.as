////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PathCollection.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.paths
{

import id.core.id_internal;
import id.core.IDisposable;
import id.utils.IComparable;
import id.utils.Iterable;
import id.utils.Iterator;
import flash.geom.Point;

use namespace id_internal;

public class PathCollection implements IComparable, Iterable, IDisposable
{

	private static const SEPERATION_ANGLE:int = 15;
	private static const SEPERATION_DISTANCE:int = 25;

	id_internal var collection:Array;
	id_internal var collection_x:Vector.<Number>;
	id_internal var collection_y:Vector.<Number>;
	id_internal var size:int;
	
	private var scaled:Vector.<Point>;
	private var invalid:Boolean;
	
	public var name:String;
	
	public var bottom:Number = 0;
	public var left:Number = 0;
	public var right:Number = 0;
	public var top:Number = 0;
	
	public var width:Number;
	public var height:Number;
	
	public var eventClass:Class;

	public function PathCollection()
	{
		super();
		
		collection_x = new Vector.<Number>(); // [];
		collection_y = new Vector.<Number>(); // [];
		
		size = 0;
	}
	
	public function Dispose():void
	{
		collection_x = null;
		collection_y = null;
		
		scaled = null;
		
		size = 0;
	}
	
	public function get data():Object
	{
		if (invalid)
		{
			scale();
		}
		
		return scaled;
	}
	
	public function get length():int
	{
		return size;
	}
	
	private function establishDimensions(lastX:int, lastY:int):void
	{
		if(!size)
		{
			left = right = lastX;
			top = bottom = lastY;
			
			return;
		}
		
		if (lastX < left) left = lastX;
		if (lastX > right) right = lastX;
		if (lastY < top) top = lastY;
		if (lastY > bottom) bottom = lastY;
		
		width = right - left;
		height = bottom - top;
	}
	
	/*
	private function validate():void
	{
		if(!size)
		{
			return;
		}
		
		var ratio:Number = 1 / (width > height ? width : height) ;
		
		scaled = new Vector.<Point>();
		
		var idx:int;
		for(idx=0; idx<size; idx++)
		{
			// overhead ><
			scaled.push
			(
				new Point
				(
					(collection_x[idx] - left) * ratio,
					(collection_y[idx] - top) * ratio
				)
			);
			
			//scaled_x[idx] = (collection_x[idx] - left) * ratio;
			//scaled_y[idx] = (collection_y[idx] - top) * ratio;
		}
		
		invalid = false;
	}
	*/
	
	public function addPoint(xVal:int, yVal:int, isAnchor:Boolean = false):Boolean
	{
		if(!size)
		{
			collection_x.push(xVal);
			collection_y.push(yVal);
			
			invalid = true;
			establishDimensions(xVal, yVal);
			
			size++;
			
			return true;
		}
		else
		{
			var x1:int = collection_x[size - 1];
			var y1:int = collection_y[size - 1];
			
			var dx:int = x1 - xVal;
			var dy:int = y1 - yVal;
			
			var distance:int = Math.sqrt(dx*dx + dy*dy);
			if (distance < SEPERATION_DISTANCE && !isAnchor)
			{
				return false;
			}
			else
			if
			(
				(distance < SEPERATION_DISTANCE && isAnchor) ||
				(distance > SEPERATION_DISTANCE)
			)
			{
				var ratio:Number = SEPERATION_DISTANCE / distance ;
				
				xVal = x1 + ratio * (xVal - x1);
				yVal = y1 + ratio * (yVal - y1);
			}
			
			collection_x.push(xVal);
			collection_y.push(yVal);
			
			invalid = true;
			establishDimensions(xVal, yVal);
			
			size++;
			
			return true;
		}
		
		return false;
	}
	
	public function addAnchorPoint(xVal:int, yVal:int):void
	{
		addPoint(xVal, yVal, true);
	}
	
	public function scale(ratio:Number = NaN):void
	{
		if(!size)
		{
			return;
		}
		
		if(isNaN(ratio))
		if(invalid)
		{
			ratio = 1 / (width > height ? width : height) ;
			trace("RATIO:", ratio);
		}
		else
		{
			return;
		}
		
		scaled = new Vector.<Point>();
		
		var idx:int;
		for(idx=0; idx<size; idx++)
		{
			// overhead ><
			scaled.push
			(
				new Point
				(
					(collection_x[idx] - left) * ratio,
					(collection_y[idx] - top) * ratio
				)
			);
			
			//scaled_x[idx] = (collection_x[idx] - left) * ratio;
			//scaled_y[idx] = (collection_y[idx] - top) * ratio;
		}
		
		invalid = false;
	}
	
	public function getPoint(index:int):Point
	{
		if(index > size)
		{
			throw new RangeError("Index out of bounds");
		}
		
		if (invalid)
		{
			scale();
		}
		
		return new Point
		(
			collection_x[index],
			collection_y[index]
		);
	}
	
	public function createIterator():Iterator
	{
		if (invalid)
		{
			scale();
		}
		
		return new PathCollectionIterator(scaled);
	}
	
	public function compareTo(obj:*):int
	{
		if(!obj is PathCollection)
		{
			throw new ArgumentError("Object must be of type PathCollection!");
		}
		
		return 0;
	}

}

}