<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Dšhring													|
| All rights reserved.																	|
| Author: Nils Dšhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc Rockdot_Zend_Form_Element_Month extends Zend_Form_Element_Text
 * handles html5 form-element "month"
 * <input type="month" ...
 * 
 * @author_________nils.doehring
 * @version________1.0        
 * @lastmodified___$Date: $ 
 * @revision_______$Revision: $ 
 * @copyright______Copyright (c) Block Forest
 * @package________Rockdot_Zend_Form        
 *
 * @dependencies
 * @import: Zend_Form_Element_Text		 
 */
require_once('Zend/Form/Element/Text.php');

class Rockdot_Zend_Form_Element_Month extends Zend_Form_Element_Text{
/*	+-----------------------------------------------------------------------------------+
	| 	contruct and init functionallity
	+-----------------------------------------------------------------------------------+  */
   /**
    * @desc 
    * initialize Zend_Form_Element_Text with the type "month"
	* @see 'Zend/Form/Element/Text.php' 
	* 
	* @input-required:
	* $spec may be:
     * - string: name of element
     * - array: options with which to configure element
     * - Zend_Config: Zend_Config with options for configuring element
     *
     * @param  string|array|Zend_Config $spec
     * @return void
     * @throws Zend_Form_Exception if no element name after initialization
    */
	public function __construct($spec, $options = NULL){
        //overwrite the default type (text) even if set by User
		$options['type'] = 'month';
        parent::__construct($spec, $options);
    }
}