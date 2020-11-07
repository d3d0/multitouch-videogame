////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PathDictionary.as
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
//import id.core.ApplicationGlobals;

import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.utils.ByteArray;

use namespace id_internal;

public class PathDictionary
{
	
	private static var regEx:RegExp = new RegExp(/(x|y)=?([0-9]*\.*[0-9]*)/g); // new RegExp(/\(x=.*?, *y=.*?\)/g);
	
	public static function AddPath(path:Path):void
	{
		
	}
	
	public static function AddCoordinatePath(name:String, xCoords:Array, yCoords:Array):void
	{
		
	}
	
	
	public static function AddSerializedPath(name:String, path:ByteArray):void
	{
		
	}
	
	public static function AddSerializedStringPath(eventClass:Class, name:String, path:String):void
	{
		_instance.queueDeserialization(eventClass, name, path);
	}
	
	public static function AddSerializedCoordinatePath(name:String, xCoords:String, yCoords:String):void
	{
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	private static var _instance:PathDictionary = new PathDictionary();
	
	public static function getInstance():PathDictionary
	{
		return _instance;
	}
	
	
	

	private var interval:int;
	private var queue:Array =
	[
	/*
	{
		name: "pathName",
		path: Path
	}
	*/
	];
	
	public var paths:Object = {};
	
	public function PathDictionary()
	{
	}
	
	public function queueDeserialization(eventClass:Class, name:String, pathData:*):void
	{
		var path:Path = new Path();
		
		path.eventClass = eventClass;
		path.name = name;
		
		paths[name] = path;
		queue.push({object: path, data: pathData});

		if(!interval)
		{
			interval = setInterval(deserialize, 1);
		}
	}
	
	public function deserialize():void
	{
		if(!queue.length)
		{
			clearInterval(interval);
			interval = 0;
			
			return;
		}

		var item:Object = queue.pop();

		var path:Path = item.object;
		var pathData:* = item.data;
		
		var bottom:Number;
		var left:Number;
		var right:Number;
		var top:Number;
		
		var width:Number;
		var height:Number;
		
		if(pathData is String)
		{
			var idx:int;
			var result:Array = regEx.exec(pathData);
			var value:Number;
			
			while(result)
			{
				value = result[2];
				
				
				switch(result[1])
				{
					case "x":
					
						if(isNaN(left))
						{
							left = right = value;
						}
						else
						{
							if(value < left) left = value;
							if(value > right) right = value;
						}
						
						path.collection_x.push(result[2]);
					break;
					
					case "y":
					
						if(isNaN(bottom))
						{
							bottom = top = value;
						}
						else
						{
							if(value < top) top = value;
							if(value > bottom) bottom = value;
						}
						
						path.collection_y.push(result[2]);
					break;
				}
	
				result = regEx.exec(pathData);
			}
	
			if(path.collection_x.length != path.collection_y.length)
			{
				throw new Error("Deserialization of path (" + path.name + ") has errored.  Coordinate lists are unbalanced!");
			}
		}
		else
		if(pathData is ByteArray)
		{
			// byte array serialization
		}
		
		//trace("deserialized:", path.name);
		
		//path.name = item.name;
		
		width = right - left;
		height = bottom - top;
		
		//trace(width, height);
		
		path.width = width;
		path.height = height;
		//path.size = path.collection_x.length;
		
		path.initialize();

		paths[item.name] = path; //normalizeSegmentDistance(path);
	}
	
	/*
	private function normalizeSegmentDistance(path:Path):Path
	{
		if(!path)
		{
			throw new Error("Path is undefined!");
		}
		
		var idx:uint;
		
		var distance:Number;
		var segmentDistance:Number;

		if(path.length < 2)
		{
			return path;
		}
		
		trace("\nNormalizing segment distance for:", path.name);
		
		var collection_x:Vector.<Number> = path.collection_x;
		var collection_y:Vector.<Number> = path.collection_y;
		
		var collection_nx:Vector.<Number> = new Vector.<Number>();
		var collection_ny:Vector.<Number> = new Vector.<Number>();
		
		var x1:Number;
		var x2:Number;
		var y1:Number;
		var y2:Number;
		
		x1 = collection_x[0];
		x2 = collection_x[1];
		
		y1 = collection_y[0];
		y2 = collection_y[1];
		
		var dx:Number;
		var dy:Number;
		
		dx = x2 - x1;
		dy = y2 - y1;

		collection_nx.push(x1);
		collection_ny.push(y1);

		segmentDistance = Math.sqrt(dx*dx + dy*dy);

		trace("--> recorded segmentDistance:", segmentDistance);
		
		var angle:Number;
		var xN:Number;
		var yN:Number;

		for(idx=1; idx<collection_x.length; idx++)
		{
			x2 = collection_x[idx];
			y2 = collection_y[idx];
			
			dx = x2 - x1;
			dy = y2 - y1;
			
			distance = Math.sqrt(dx*dx + dy*dy);
			
			trace("--> discovered segmentDistance:", distance);
			
			//if(distance < SEGMENT_LENGTH)
			//{
			//	continue;
			//}
			
			while(distance >= SEGMENT_LENGTH)
			{
				angle = Math.atan((y2 - y1) / (x2 - x1));
				
				if(Math.abs(angle)> (Math.PI/2)-0.5){
					if(angle>0){
						angle = (Math.PI/2)-0.5;
					}
					if(angle<0){
						angle = -((Math.PI/2)-0.5);
					}
				}
				
				xN = SEGMENT_LENGTH * Math.cos(angle) + x1;
				yN = SEGMENT_LENGTH * Math.sin(angle) + y1;
				
				collection_nx.push(xN);
				collection_ny.push(yN);
				
				dx = xN - x1;
				dy = yN - y1;
				
				trace("--> calculated segmentDistance:", Math.sqrt(dx*dx + dy*dy));
				
				x1 = xN;
				y1 = yN;
				
				dx = x2 - xN;
				dy = y2 - yN;
				
				distance = Math.sqrt(dx*dx + dy*dy);
				
				trace("--> remaining distance:", distance);
			}
			
			
			
		}
		
		//var app:MovieClip = id.core.ApplicationGlobals.application as MovieClip;
		//var offset_x:Number = 400;
		//var offset_y:Number = 200;
		//var ratio:Number = 400;

		//app.graphics.lineStyle(3, 0xffffff, 0.75, true);
		//app.graphics.moveTo(collection_x[0] * ratio + offset_x, collection_y[0] * ratio + offset_y);

		//for(idx=1; idx<collection_x.length; idx++)
		//{
		//	app.graphics.lineTo(collection_x[idx] * ratio + offset_x, collection_y[idx] * ratio + offset_y)
		//	app.graphics.drawCircle(collection_x[idx] * ratio + offset_x, collection_y[idx] * ratio + offset_y, 3);
		//}
		
		//app.graphics.lineStyle(3, 0x990000, 0.75, true);
		//app.graphics.moveTo(collection_nx[0] * ratio + offset_x, collection_ny[0] * ratio + offset_y);

		//for(idx=1; idx<collection_nx.length; idx++)
		//{
		//	app.graphics.lineTo(collection_nx[idx] * ratio + offset_x, collection_ny[idx] * ratio + offset_y)
		//	app.graphics.drawCircle(collection_nx[idx] * ratio + offset_x, collection_ny[idx] * ratio + offset_y, 3);
		//}
		
		return path;
	}
	
	private static var SEGMENT_LENGTH:Number = 0.06;
	*/
	
	
	
}

}