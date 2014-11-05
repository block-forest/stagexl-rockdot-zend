<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Dšhring													|
| All rights reserved.																	|
| Author: Nils Dšhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc forces all script to https (redirects http-reqquests to https)
 * 
 * @author_________nils.doehring
 * @version________1.0        
 * @lastmodified___$Date: $ 
 * @revision_______$Revision: $ 
 * @copyright______Copyright (c) Block Forest
 *
 * @dependencies
 * @import: Zend_Controller_Action_HelperBroker
 * @import: Zend_Controller_Plugin_Abstract		
 * @import: Rockdot_Http_Request
 * @import: Rockdot_Http_Response
 */
require_once('Zend/Controller/Plugin/Abstract.php');
require_once('Zend/Layout.php');
require_once('Rockdot/Http/Request.php');
require_once('Rockdot/Http/Response.php');
 
class Rockdot_Zend_Plugin_SslSwitch extends Zend_Controller_Plugin_Abstract{
/*	+-----------------------------------------------------------------------------------+
	| 	member vars
	+-----------------------------------------------------------------------------------+  */	
	/**
	* @desc Enviroments that support SSl
	* @var  :array
	*/
	private $_sslSupportedEnvs = array();
/*	+-----------------------------------------------------------------------------------+
	| 	class constructor - set init-parameters
	+-----------------------------------------------------------------------------------+  */
	/**
	* @desc
	* init paths for premanent-redirects
	*	
	* @input-optional:
	* @param -> $_config  :array|Zend_Config|Rockdot_Config
	*
	* @access public
	*/
	public function __construct($_config = array()){
		if(is_array($_config) && !empty($_config)){
			$this->_sslSupportedEnvs = $_config;
		}
		elseif($_config instanceof Zend_Config || $_config instanceof Rockdot_Config){
			$this->_sslSupportedEnvs = $_config->toArray();	
		}
	}
	
	/**
	* @autocalled by callstack in Zend_Controller_Plugin_Abstract
	*
	* @desc
	* switches all request to https if they're not already
	*
	* @input-required:
	* @param -> $request :Zend_Controller_Request_Abstract
	*	
	* @return none
	*
	* @access public
	*/
    public function routeStartup(Zend_Controller_Request_Abstract $request){
        try{
			//-------------------------------------------------------------
			//switch protocols to https if defined in navigation-node (ssl = true) 
			if(!Rockdot_Http_Request::isSSL() && in_array(APPLICATION_ENV, $this->_sslSupportedEnvs)){
				Rockdot_Http_Response::forwardSsl();
			}
			//----------------------------------------------------------
		}
		catch(Exception $e){
		
		}   	
    }
	
	/**
	* @autocalled by callstack in Zend_Controller_Plugin_Abstract
	*
	* @desc
	* displays (https) in header-title  in non productionmode
	*
	* @input-required:
	* @param -> $request :Zend_Controller_Request_Abstract
	*	
	* @return none
	*
	* @access public
	*/
    public function postDispatch(Zend_Controller_Request_Abstract $request){
        try{
			//-------------------------------------------------------------
			//switch protocols to https if defined in navigation-node (ssl = true) 
			if(!Rockdot_Http_Request::isSSL() && !in_array(APPLICATION_ENV, $this->_sslSupportedEnvs)){
				Zend_Layout::getMvcInstance()->getView()->headTitle('(https)', 'PREPEND')->setSeparator(' - ');	
			}
			//----------------------------------------------------------
		}
		catch(Exception $e){
		
		}   	
    }
}