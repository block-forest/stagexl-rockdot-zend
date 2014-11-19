<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc footerscript helper
 *
 * @see http://framework.zend.com/manual/de/zend.view.helpers.html
 * 
 * @author          nils.doehring
 * @version         
 * @lastmodified:   
 * @copyright       Copyright (c) Block Forest
 * @package         Rockdot_Zend_View_Helper
 *
 * @dependencies
 * @import: Zend_View_Helper_HeadScript	
 */
require_once('Zend/View/Helper/HeadScript.php');
 
class Rockdot_Zend_View_Helper_Script extends Zend_View_Helper_HeadScript{
/*	+-----------------------------------------------------------------------------------+
	| 	member vars
	+-----------------------------------------------------------------------------------+  */			
	/**
	* Needs a different namespace than standard _HeadScript view helper   
	* @var  :string
	*/  
    protected $_regKey = 'Zend_View_Helper_Script'; 
     
	/**
	* @desc
	* view helaper to add js files 
	*
	* @void
	*
	* @return :string
	*
	* @access public
	*/
    public function script() {
        return parent::headScript();
    }
}