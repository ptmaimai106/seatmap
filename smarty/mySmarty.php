<?php

require_once "Smarty.class.php";

class MySmarty extends Smarty {

    public function __construct()
    {
        parent::__construct();

        $this->error_reporting = E_ALL & ~E_NOTICE;
        $this->setTemplateDir('../view');
        $this->setCompileDir('../view_c');
    }
}