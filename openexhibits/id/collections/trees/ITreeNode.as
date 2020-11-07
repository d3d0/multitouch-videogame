////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITreeNode.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.collections.trees{		public interface ITreeNode	{				/*		function get data():*;		function set data(value:* = null):void;				function get childCount():uint;		function get siblingCount():uint;				function get children():List;		function get parent():ITreeNode;		function get root():ITreeNode;				function isRoot():Boolean;		*/				/**		 * gets the data from the node.		 * @return the data element of any type		 */		//function getData() : *;				/**		 * sets the data on the node.		 * @param data a data element to set, of any type.		 */		//function setData(data : * = null) : void				/**		 * gets the parent of the ITreeNode		 * @return	the ITreeNode that is the parent, else null.		 */				//function getParent() : ITreeNode;				/**		 * gets the root ITreeNode of the tree.		 * @return the ITreeNode that is the root of the tree structure.		 */		//function getRoot() : ITreeNode;				/**		 * is this ITreeNode the root of the tree?		 * @return true if the ITreeNode is the root, false otherwise.		 */		//function isRoot() : Boolean;				/**		 * @return the number of <em>direct</em> children this ITreeNode has.		 */		//function getChildCount() : int;				/**		 * returns the count of siblings an ITreeNode has.		 * This is the same as the number of children of the parent minus the current ITreeNode.		 * @return the number of brothers and sisters of our current ITreeNode.		 */		//function getSiblingCount() : int;				/**		 * returns a List of ITreeNode instances that represent the children of the ITreeNode		 * @return a List of ITreeNode instances.		 */		//function getChildren() : List;				/**		 * returns a List of ITreeNode instances that represent the siblings of the ITreeNode		 * @return a List of ITreeNode instances.		 */		//function getSiblings() : List;				/**		 * returns the height of a tree, from the current ITreeNode		 * @return the height of the tree, from 1 to ....		 */		//function getHeight() : int;				/**		 * returns the level of an ITreeNode. A tree starts from level 0.		 * @return the level of the current ITreeNode.		 */		//function getLevel() : int;			}	}