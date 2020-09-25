<?php

require_once "smarty/Smarty.class.php";
session_start();


$smarty=new Smarty();
$smarty->setTemplateDir('view');
$smarty->setCompileDir('view_c');
$smarty->error_reporting = E_ALL & ~E_NOTICE;

$logined = $_SESSION['logined'];


if($logined){
   $smarty->display('home.tpl');

}else {
    header("Location: /seatmap/login");
}

?>
