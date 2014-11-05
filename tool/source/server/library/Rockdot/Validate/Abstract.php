<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Dšhring													|
| All rights reserved.																	|
| Author: Nils Dšhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc abstract Validation object for extending
 * 
 * @override/abstract
 * isValid
 * 
 * @author          nils.doehring
 * @version         
 * @lastmodified:   
 * @copyright       Copyright (c) Block Forest
 * @package         Rockdot_Validate
 *
 * @dependencies
 * @import: Rockdot_Validate_Exception	 
 */
require_once('Rockdot/Validate/Exception.php');
	
abstract class Rockdot_Validate_Abstract{
/*	+-----------------------------------------------------------------------------------+
	| 	class-member-vars
	+-----------------------------------------------------------------------------------+  */			
	/**
	* common validation options 
	* @var boolean
	*/
	protected $message = 'input is invalid';
	
	/**
	* flag if the current tested rule have an error
	* @var boolean
	*/
	private $isValid = true;
/*	+-----------------------------------------------------------------------------------+
	| 	class constructor - set init-parameters
	+-----------------------------------------------------------------------------------+  */	
	/**
	* @description
	* inits the validation-object, method is final an cannot be overriden
	* use init() for prepending initialisation
	*	
	* @input-required:
	* @param -> $_options  :array
	*
	* @access public
	*/
	public function __construct(array $_options = array()){
		if(!empty($_options)){
			$this->setOptions($_options);
		}
	}
	
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
	
	/**
	* @desc 
	* abstract method defined must be overridden
	* validates objetcs value an returns a boolean
	*
	* @input-required
	* @param $value :mixed  //the tested value
	*
	* @return boolean	
	*
	* @access public
	*/
	abstract public function isValid($value);
	
	/**
	* @description
	* retuns message
	*
	* @void
	*
	* @return :string
	*
	* @access public
	*/
	public function getMessage(){
		return($this->message);
	}
	
	/**
	* @description
	* sets message
	*
	* @input-required:
	* @param -> $message  :string
	*
	* @return :$this
	*
	* @access public
	*/
	public function setMessage($message){
		if(!is_string($message)){
			throw new Rockdot_Validate_Exception('message must be type of string', 2003);		
		}
		$this->message = $message;
	return $this;
	}
}