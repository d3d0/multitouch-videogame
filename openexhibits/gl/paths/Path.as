////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Path.as
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
import id.utils.Iterable;
import id.utils.IComparable;

import flash.geom.Point;

use namespace id_internal;

public class Path /*implements Iterable, IComparable, IDisposable*/
{
	id_internal var collection:Array;
	id_internal var collection_x:Vector.<Number>;
	id_internal var collection_y:Vector.<Number>;
	
	public var eventClass:Class;
	public var name:String;
	
	public var width:Number;
	public var height:Number;
	public var size:int;
	
	public function Path()
	{
		super();
		
		collection = [];
		collection_x = new Vector.<Number>();
		collection_y = new Vector.<Number>();
		
		size = 0;
	}
	
	public function initialize():void
	{
		// workaround for the $1 recognizer
		
		size = collection_x.length;
		
		var idx:int;
		for(idx=0; idx<size; idx++)
		{
			collection.push(new Point(collection_x[idx], collection_y[idx]));
		}
		
		normalize();
	}
	
	public function normalize():void
	{
		collection = PathProcessor.Resample(collection, PathProcessor.NumPoints);
		collection = PathProcessor.ScaleToSquare(collection, PathProcessor.SquareSize);
		collection = PathProcessor.TranslateToOrigin(collection);
	}
	
	//public function get 
	
	
	/*
	public function get xNodes():Array { return null; }
	public function get yNodes():Array { return null; }
	
	public function get nodes():Vector.<Point> { return null;}
	*/
	
}

}