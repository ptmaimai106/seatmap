<?php
include_once "../model/user_modal.php";
include_once "../model/entity/user.php";

require "../smarty/mySmarty.php";
session_start();


define("SITE_ROOT", realpath(dirname(__FILE__)));

class UserController{

    public $user;
    public $smarty;
    public $message;
    public $messageUpload;
    public $breadcrumbs;

    private static $instance;

    public $csrf_a;
    public $csrf_u;
    public $csrf_d;

    private function __construct(){
        $this->user = new UserModel();
        $this->message = "";
        $this->messageUpload = "";
        $this->smarty = new MySmarty();
        $this->breadcrumbs = $this->showBreadCrumb();

        if(!$_SESSION['csrf_a'] ){
            $this->csrf_a =md5(uniqid());
            $_SESSION['csrf_a'] =  $this->csrf_a;
        }else $this->csrf_a = $_SESSION['csrf_a'];

        if(!$_SESSION['csrf_d']){
            $this->csrf_d = md5(uniqid());
            $_SESSION['csrf_d'] =  $this->csrf_d;

        }else $this->csrf_d = $_SESSION['csrf_d'];

        if(!$_SESSION['csrf_u']){
            $this->csrf_u = md5(uniqid());
            $_SESSION['csrf_u'] =  $this->csrf_u;

        }else $this->csrf_u = $_SESSION['csrf_u'];

    }

    public static function getInstance(){
        if(!isset(self::$instance)){
            self::$instance = new UserController();
        }
        return self::$instance;
    }

    public function handler(){
        $method = $_SERVER["REQUEST_METHOD"];
        if($method == "POST"){

            if(isset($_POST['add-user']) && $_POST['csrf_a'] == $_SESSION['csrf_a']){
                $this->message = $this->addUser();
            }
            if(isset($_POST['update-user']) && $_POST['csrf_u'] == $_SESSION['csrf_u']) {
                $this->message = $this->editUser();
            }
            if(isset($_POST['delete-user']) && $_POST['csrf_d'] == $_SESSION['csrf_d']){
                $this->message = $this->deleteUser();
            }
        }else {
            $page = $_GET['p'];
            if( ctype_digit($page) == false && $page!= ""){
                $this->showErrorPage();
                die();
            } else if (intval($page) > $this->getNumPage()){
                $this->showErrorPage();
                die();
            }
            else{
                $this->message = "";
            }
        }

        $this->invoke($this->message);
    }

    function invoke( $message)
    {
        $this->smarty->assign("breadcrumbs", $this->breadcrumbs);
        $this->smarty->assign('message', $message);
        $this->smarty->assign('page', $_GET['p']);
        $this->smarty->assign('numPage', $this->getNumPage());
        $this->smarty->assign('userList', $this->getUsers());

        $this->smarty->assign('csrf_a', $this->csrf_a);
        $this->smarty->assign('csrf_u', $this->csrf_u);
        $this->smarty->assign('csrf_d', $this->csrf_d);

        $this->smarty->display('user.tpl');
    }

    function showErrorPage(){
        $this->smarty->display("error.tpl");
    }

    function showBreadCrumb() : array {
        $currentUrl = $_SERVER['REQUEST_URI'];
        $breadCrumb = [
            "User Management" => $currentUrl
        ];
        return $breadCrumb;
    }

    function getCountUser(): int
    {
        $data = $this->user->getCountUser();
        if(is_object($data)){
            $row = $data->fetch_assoc();
            return $row['count'];
        }
        return 0;
    }

    function getNumPage(): int {
        $countUser = $this->getCountUser();
        $numPage = $countUser%10 == 0 ? $countUser/10 : $countUser/10 +1;
        return $numPage;
    }

    function uploadAvatar(): bool
    {
        $target_dir = SITE_ROOT."/upload/";
        $target_file = $target_dir.basename($_FILES["image"]["name"]);
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

        if($imageFileType != "jpg" && $imageFileType!= "png" && $imageFileType!= "jpeg" && $imageFileType!= "gif"){
            $this->messageUpload = "Only JPG, JPEG, PNG, GIF file are allowed. ";
            return false;
        }
        $check = getimagesize($_FILES["image"]["tmp_name"]);
        if($check == false){
            $this->messageUpload = "Your file is not an image";
            return false;
        }

        if($_FILES["image"]["size"] > 500000){
            $this->messageUpload= "Your file is too large";
            return false;
        }

        if(move_uploaded_file($_FILES['image']['tmp_name'], $target_file)){
            $this->messageUpload = "Upload success ";
            return true;
        }else{
            $this->messageUpload = "Upload failed";
            return false;
        }

    }

    function getUsers() : array
    {
        if($_GET['p']){
            $userData = $this->user->getUsers($_GET['p']);
        }else {
            $userData = $this->user->getUsers(0);
        }

        $userList = array();
        if(is_object($userData)){
            while ($row = $userData->fetch_assoc()){
                $user = new User($row['id'],$row['username'], $row['email'], $row['avatar'], $row['status'], $row['create_at'], $row['update_at']);
                array_push($userList, $user);
            }
        }
        return $userList;
    }

    function addUser() : string
    {
        $username =htmlentities($_POST['username']) ;
        $email = htmlentities($_POST['email']) ;
        if($this->uploadAvatar() == false){
            return $this->messageUpload;
        }

        $avatar = "upload/".basename($_FILES["image"]["name"]);
          if($this->user->findEmail($email) == 0){
            $insert_id = $this->user->addUser($username, $email, $avatar);
            if($insert_id) {
                return 'Add user success';
            }
            return 'Add user failure';
        }else {
            return 'Email is exist';
        }
    }

    function editUser(): string
    {
        $id = htmlentities($_POST['id']);
        $username = htmlentities($_POST['username']);
        $email = htmlentities($_POST['email']);
        $status = htmlentities($_POST['status']);
        $avatar=htmlentities($_POST['avatar']);

        if($_FILES["image"]["name"]){
            if($this->uploadAvatar() == false) {
                return $this->messageUpload;
            }
            $avatar="upload/".basename($_FILES["image"]["name"]);
        }

        if( $this->user->findEmail($email) == 1){
            $result= $this->user->editUser($id, $username, $email, $avatar, $status);
            return $result ?  "Update user info success" : "Update user info failed";
        }
        return "Email is exist";
    }

    function deleteUser(): string
    {
        $id = htmlentities($_POST['id_d']);
        if(isset($id)){
            $result = $this->user->deleteUser($id);
            return $result ? "Delete user successfully" : "Delete user failed";
        }else return "Cannot delete user";

    }
}

if($_SESSION['logined']){
    $userController = UserController::getInstance();
    $userController->handler();
}else {
    header("Location: /seatmap/login");
}




