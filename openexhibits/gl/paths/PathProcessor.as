////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PathProcessor.as
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
import id.core.ITactualObject;

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

use namespace id_internal;

public class PathProcessor
{
	
	public static var NumPoints:int = 100;
	public static var SquareSize:Number = 250.0;
	public static var HalfDiagonal = 0.5*Math.sqrt(2*SquareSize*SquareSize);
	
	public function PathProcessor()
	{
		super();
	}
	
	/**
	 *  Silently errors with -inf.
	 */
	public static function CompareRawToNormalizedPathCollection(tO:ITactualObject, pathCollection:Vector.<Path>):Object
	{
		var idx:int;
		
		var path:Path = new Path();
		var history:Vector.<Object> = tO.combinedHistory;
		//var matches:Vector.<PathMatch> = new Vector.<PathMatch>();
		
		for(idx=0; idx<history.length; idx++)
		{
			path.collection_x.push(history[idx].x);
			path.collection_y.push(history[idx].y);
		}
		
		path.initialize();
		
		var b:Number = +Infinity;
		var t:int;
		
		for (var i = 0; i < pathCollection.length; i++)
		{
			var d = PathDistance(path.collection, pathCollection[i].collection);
			trace("path diff sum", pathCollection[i].name, d);
			
			if (d < b)
			{
				b = d;
				t = i;
			}
		}
		
		if(b > 75)
		{
			return null;
		}
		
		var score = 1.0 - (b / HalfDiagonal);
		return {path: pathCollection[t], score: score};
	}
	
	// Helper functions
	
	public static function Resample(points, n)
	{
		var I = PathLength(points) / (n - 1); // interval length
		var D = 0.0;
		var newpoints = new Array(points[0]);
		for (var i = 1; i < points.length; i++)
		{
			var d = Distance(points[i - 1], points[i]);
			if ((D + d) >= I)
			{
				var qx = points[i - 1].x + ((I - D) / d) * (points[i].x - points[i - 1].x);
				var qy = points[i - 1].y + ((I - D) / d) * (points[i].y - points[i - 1].y);
				var q = new Point(qx, qy);
				newpoints[newpoints.length] = q; // append new point 'q'
				points.splice(i, 0, q); // insert 'q' at position i in points s.t. 'q' will be the next i
				D = 0.0;
			}
			else D += d;
		}
		// somtimes we fall a rounding-error short of adding the last point, so add it if so
		if (newpoints.length == n - 1)
		{
			newpoints[newpoints.length] = points[points.length - 1];
		}
		return newpoints;
	}

	public static function ScaleToSquare(points, size)
	{
		var B = BoundingBox(points);
		var newpoints = new Array();
		for (var i = 0; i < points.length; i++)
		{
			var qx = points[i].x * (size / B.width);
			var qy = points[i].y * (size / B.height);
			newpoints[newpoints.length] = new Point(qx, qy);
		}
		return newpoints;
	}			
	public static function TranslateToOrigin(points)
	{
		var c = Centroid(points);
		var newpoints = new Array();
		for (var i = 0; i < points.length; i++)
		{
			var qx = points[i].x - c.x;
			var qy = points[i].y - c.y;
			newpoints[newpoints.length] = new Point(qx, qy);
		}
		return newpoints;
	}
	
	public static function PathLength(points)// find the total path length by adding the distance between all data points
	{
		var d = 0.0;
		for (var i = 1; i < points.length; i++)
			d += Distance(points[i - 1], points[i]);
		return d;
	}
	
	public static function Distance(p1, p2) // finds the distance between two points
	{
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		return Math.sqrt(dx * dx + dy * dy);
	}
	public static function Centroid(points)
	{
		var x = 0.0, y = 0.0;
		for (var i = 0; i < points.length; i++)
		{
			x += points[i].x;
			y += points[i].y;
		}
		x /= points.length;
		y /= points.length;
		return new Point(x, y);
	}
	public static function BoundingBox(points)
	{
		var minX = +Infinity, maxX = -Infinity, minY = +Infinity, maxY = -Infinity;
		for (var i = 0; i < points.length; i++)
		{
			if (points[i].x < minX)
				minX = points[i].x;
			if (points[i].x > maxX)
				maxX = points[i].x;
			if (points[i].y < minY)
				minY = points[i].y;
			if (points[i].y > maxY)
				maxY = points[i].y;
		}
		return new Rectangle(minX, minY, maxX - minX, maxY - minY);
	}
	
	public static function PathDistance(pts1, pts2) // finds the average difference between points in both paths
	{
		var d = 0.0;
		for (var i = 0; i < pts1.length; i++) // assumes pts1.length == pts2.length
			d += Distance(pts1[i], pts2[i]);
		return d / pts1.length;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	public static function CompareRawToNormalizedPath(obj:ITactualObject, path:PathCollection):Number
	{
		return 0;
	}
	*/
	
	/*
	public static function CompareRawToNormalizedPath1(obj:ITactualObject, path:PathCollection, debugContainer:Sprite):Number
	{
		// 1: normalize the recorded path segment distance
		// 2: normalize the user recorded path and segment distance
		
		var idx:uint;
		
		var path:Vector.<Point> = new Vector.<Point>();
		var userPath:Vector.<Point> = new Vector.<Point>();
		
		var pt:Point;
		var pt_x:Number;
		var pt_y:Number;
		var pt_last_x:Number = pt.x;
		var pt_last_y:Number = pt.y;
		
		var distance:Number;
		var distance_normalized:Number;
		
		for(idx=0; idx<path.collection_x.length; idx++)
		{
			
		}
		
		return 0;
	}
	*/
	
	/*
	public static function CompareRawToNormalizedPath2(obj:ITactualObject, path:PathCollection, debugContainer:Sprite):Number
	{
		var n:int = obj.history.length - 1;
		if(!n || n < 2)
		{
			return Number.NEGATIVE_INFINITY;
		}
		
		if(!path.length || path.length < 2)
		{
			return Number.NEGATIVE_INFINITY;
		}
		
		var h:Object = obj.history[0];
		var idx:int;
		var idk:int;
		var idj:int;

		// determine raw path dimensions
		
		var bottom:int;
		var left:int;
		var right:int;
		var top:int;
		
		var width:int;
		var height:int;

		bottom = top = h.y;
		left = right = h.x;
		
		// unnecessary overhead. Migrate to the tactual object.
		for(idx=0; idx<n; idx++)
		{
			h = obj.history[idx];
			
			if(h.x < left) left = h.x;
			if(h.x > right) right = h.x;
			if(h.y < top) top = h.y;
			if(h.y > bottom) bottom = h.y;
		}
		
		width = right - left;
		height = bottom - top;
		
		//trace(width, height);
		//trace(top, right, bottom, left);
		
		if(width < 0 || height < 0)
		{
			return Number.NEGATIVE_INFINITY;
		}
		
		// determine average, normalized-scaled, seperation distance
		
		
		
		
		var ratio:int = width > height ? width : height ;
		var ratio_target:int = ratio;
		var ratio_exact:Number;
		
		var ratio_width:Number = width / path.width;
		var ratio_height:Number = height / path.height;
		
		
		var area:int;
		var area_total:int;
		for(idx=0; idx<path.length; idx++)
		{
			area_total += Math.abs(path.collection_x[idx] * ratio_width) + Math.abs(path.collection_y[idx] * ratio_height);
		}
		
		
		//trace("ratio:", ratio);
		
		var x1:int;
		var y1:int;
		
		var x2:int;
		var y2:int;
		
		var x3:int;
		var y3:int;
		
		var xVal:int;
		var yVal:int;
		
		var dx:int = (path.collection_x[0] - path.collection_x[1]) * ratio_width; // ratio;
		var dy:int = (path.collection_y[0] - path.collection_y[1]) * ratio_height;// ratio;
		
		var distance:int = Math.sqrt(dx*dx + dy*dy);
		var distance_target:int = distance;
		var distance_last:int;
		
		//trace("distance:", distance);

		// process based on the avg distance
		
		var matchValue:Number = 0;
		
		
		// CALCULATE the approximate # of datapoints 
		
		
		
		
		
		// TODO: Implement checking for next point distance from interpolate.
		// This assumes the input data delta is <= the recorded data delta.
		
		if(debugContainer)
		{
			debugContainer.graphics.clear();
			
			debugContainer.graphics.lineStyle(2, 0xffffff, 1.0, true);
			debugContainer.graphics.moveTo(path.collection_x[0] * ratio_width + left, path.collection_y[0] * ratio_height + top);
		
			for(idx=1; idx<path.length; idx++)
			{
				debugContainer.graphics.lineTo(path.collection_x[idx] * ratio_width + left, path.collection_y[idx] * ratio_height + top);
			}
		}
		
		var actual:Number;
		var current:Number;
		var partial:Number;
		
		var path_left:int;
		var path_right:int;
		var path_top:int;
		var path_bottom:int;
		
		var path_height:int;
		var path_width:int;
		
		idk = 0;
		idj = 0;
		for(idx=0; idx<n; idx++)
		{
			h = obj.history;
			
			x1 = h[idj].x - left;
			y1 = h[idj].y - top;
			
			x2 = h[idx].x - left;
			y2 = h[idx].y - top;
			
			//area += x2 + y2;
			
			dx = x1 - x2;
			dy = y1 - y2;
			
			distance = Math.sqrt(dx*dx + dy*dy);
			if (distance < distance_target && idx)
			{
				continue;
			}
			else
			if (distance >= distance_target || !idx)
			{
				//ratio_exact = distance / distance_target ;
				
				var pnt:Point = Point.interpolate(new Point(x2,y2), new Point(x1,y1), distance_target / distance);
				xVal = pnt.x;
				yVal = pnt.y;
				
				//xVal = x1 + ratio_exact * (x2 - x1);
				//yVal = y1 + ratio_exact * (y2 - y1);
				
				//xVal = ratio_exact * (x2 - x1) ;
				//yVal = ratio_exact * (y2 - y1);
				
				//xVal = x2;// *  ratio_exact;
				//yVal = y2;// *  ratio_exact;
			}
			
			idj = idx;
			
			if(debugContainer)
			{
				debugContainer.graphics.lineStyle(2, 0x33ff33, 0.85, true);
				debugContainer.graphics.drawCircle(xVal + left, yVal + top, 5);
			}

			// calculate 3x3 distance mod
			
			x1 = path.collection_x[idk] * ratio_width;// ratio_target;
			y1 = path.collection_y[idk] * ratio_height;// ratio_target;
			
			if(debugContainer)
			{
				debugContainer.graphics.lineStyle(2, 0x3333ff, 0.85, true);
				debugContainer.graphics.drawCircle(x1 + left, y1 + top, 5);
				
				debugContainer.graphics.lineStyle(1, 0xff9999, 0.85, true);
				debugContainer.graphics.moveTo(x1 + left, y1 + top);
				debugContainer.graphics.lineTo(xVal + left, yVal + top);
			}
			
			if(x1 - xVal < x1 + xVal)
			//{
			//	
			//}
			//x2 = Math.min(x1 - xVal, x1 + xVal) + x1 ;
			//y2 = Math.min(y1 - yVal, y1 + yVal) + y1 ;
			
			dx = x1 - xVal;
			dy = y1 - yVal;
			
			//trace("location:", xVal, yVal);
			//trace("expected:", x1, y1);

			distance = Math.sqrt(dx*dx + dy*dy);
			
			//matchValue += distance;// * distance_target;
			//matchValue += (Math.abs(xVal) + Math.abs(yVal))+ (distance_target * (distance / distance_target));
				// OLD matchValue += (Math.abs(path.collection_x[idk] * ratio_width - xVal) distance_target + Math.abs(path.collection_y[idk] * ratio_height - yVal) * distance_target) + (distance_target * (distance / distance_target));
			
			if(idk < path.length - 1)
			{
				ratio =  width > height ? width : height ;
				
				var path_x:int = path.collection_x[idk] * ratio_width;//ratio;
				var path_y:int = path.collection_y[idk] * ratio_height;//ratio
				
				if(path_x < path_left) path_left = path_x;
				if(path_x > path_right) path_right = path_x;
				if(path_y < path_top) path_top = path_y;
				if(path_y > path_bottom) path_bottom = path_y;
				
				path_width = path_right - path_left;
				path_height = path_bottom - path_top;
				
				//area = path_width * path_height;// * ratio * ratio;
				area += Math.abs(path.collection_x[idk] * ratio_width) + Math.abs(path.collection_y[idk] * ratio_height);
				
				idk++;
			}
			
			//if(++idk >= path.size)
			//{
			//	break;
			//}
			
			actual  = Math.abs(area_total - area) / area_total;
			current = Math.abs(area_total - matchValue) / area_total;
			partial = Math.abs(area - matchValue) / area;
			
			trace(
				"match % @", idx + "/" + n, ":\t",
				
				Math.abs(area - matchValue) / area,
				Math.abs(area - matchValue) / area + (Math.abs(area_total - matchValue) / area_total) * 0.5,
				Math.abs(area - matchValue) / area + (Math.abs(area_total - area) / area_total),
				
				(partial + current * .5),
				(partial + actual),
				
				"\t", area_total, area, matchValue, distance
			);
			
			//if(idx / n > 0.5 && (partial + current * .5) > 1 && (partial + actual) > 1)
			//{
			//	return Number.NEGATIVE_INFINITY;
			//}
			
		}
		
		if(debugContainer)
		{
			
			debugContainer.graphics.lineStyle(2, 0xffffff, 1.0, true);
			//debugContainer.graphics.moveTo(path.collection_x[0] * ratio + left, path.collection_y[0] * ratio + top);
			debugContainer.graphics.moveTo(path.collection_x[0] * ratio_width + left, path.collection_y[0] * ratio_height + top);
			
			ratio =  width > height ? width : height ;
			
			for(idx=1; idx<path.length; idx++)
			{
				//debugContainer.graphics.lineTo(path.collection_x[idx] * ratio + left, path.collection_y[idx] * ratio + top);
				debugContainer.graphics.lineTo(path.collection_x[idx] * ratio_width + left, path.collection_y[idx] * ratio_height + top);
			}
		}
		
		return (partial + current * .5);
		
	}
	
	private var dx_old:int;
	private var dy_old:int;
	*/
	
}

}