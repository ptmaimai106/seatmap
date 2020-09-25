<?php
require "../smarty/mySmarty.php";
require "../Model/admin.php";

$smarty = new MySmarty();
session_start();


if(isset($_POST['login-btn'])) {
    $username = addslashes($_POST['username']);
    $password = addslashes($_POST['password']);

    if (empty($username)) {
        $smarty->assign("message", "Please enter username");
        $smarty->display('login.tpl');
    } else if (empty($password)) {
        $smarty->assign("message", "Please enter password");
        $smarty->display('login.tpl');
    } else {
        if(checkLogin($username, md5($password))){
            $_SESSION['logined'] = 'logined';
            header("Location: /seatmap");
        }else {
            $smarty->assign("message", "Username or password is wrong");
            $smarty->display('login.tpl');
        }
    }
}
else {
    if($_SESSION['logined']){
        header("Location: /seatmap");
    }else $smarty->display('login.tpl');
}
