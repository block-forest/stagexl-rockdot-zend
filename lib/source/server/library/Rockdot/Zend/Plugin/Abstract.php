<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc abstract Filter object for extending
 * @notice never use user-input as option parameter 
 *
 * @override/abstract
 * isValid
 * 
 * @author          nils.doehring
 * @version         
 * @lastmodified:   
 * @copyright       Copyright (c) Block Forest
 * @package         Rockdot_Filter
 *
 * @dependencies
 * @import: Rockdot_Filter_Exception	 
 */
require_once('Rockdot/Filter/Exception.php');
	
abstract class Rockdot_Filter_Abstract{
/*	+-----------------------------------------------------------------------------------+
	| 	class-member-vars
	+-----------------------------------------------------------------------------------+  */			
	/**
	* common validation options 
	* @var boolean
	*/
	protected $value;
/*	+-----------------------------------------------------------------------------------+
	| 	class constructor - set init-parameters
	+-----------------------------------------------------------------------------------+  */	
	/**
	* @description
	* inits the filter-object, method is final an cannot be overriden
	* use init() for prepending initialisation
	*	
	* @input-required:
	* @param -> $_options  :array
	*
	* @access public
	*/
	public function __construct(){}
	
	/**
	* @desc 
	* abstract method defined must be overridden
	* filters objetcs value an returns a boolean
	*
	* @input-required
	* @param $value :mixed  //the tested value
	*
	* @return boolean	
	*
	* @access public
	*/
	abstract public function filter($value);
		
	/**
	* @description
	* setOptions
	*
	* @void
	*
	* @return :string
	*
	* @access public
	*/
	public function setOptions(array $_options = array()){
		//set-options
		if(!empty($_options)){
			foreach($_options as $name => $_args){
				$func = (string) 'set'.ucwords(strtolower($name));
				if(method_exists($this, $func)){
					$_args = array($_args);	
					if(!empty($_args)){
						call_user_func_array(array($this, $func), $_args);	
					}
				}
				else{
					throw new Rockdot_Filter_Exception('Param/Method does not exist');		
				}
			}
		}	
	return $this;
	}
		
}