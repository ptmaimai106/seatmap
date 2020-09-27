<?php
include_once "../model/user_seatmap_model.php";
include_once "../model/entity/user_seatmap.php";
include_once "../model/seatmap_model.php";

require_once "../smarty/mySmarty.php";
session_start();


class UserSeatmapController{
    public $userSeatmap;
    public $smarty;
    public $seatmap;
    public $breadcrumbs;

    private static $instance;
    private function __construct(){
        $this->userSeatmap = new UserSeatmapModel();
        $this->seatmap = new SeatmapModel();
        $this->smarty = new MySmarty();
        $this->breadcrumbs = $this->showBreadCrumb();

    }

    public static function getInstance(){
        if(!isset(self::$instance)){
            self::$instance = new UserSeatmapController();
        }
        return self::$instance;
    }

    public function handler(){
        $method = $_SERVER["REQUEST_METHOD"];
        if($method == "GET"){
            $id = $_GET['id'];
            if(ctype_digit($id)){
                $this->showSeatMap();
            }
            else{
                $this->showErrorPage();
            }
        } else {
            if($_POST['remove']){
                $this->deleteUserPosition();
//                $this->showSeatMap();
                    return true;
            }else{
                $this->changeUserPosition();
                return true;
            }
        }
    }

    function showErrorPage(){
        $this->smarty->display("error.tpl");
    }

    function showBreadCrumb(): array {
        $currentUrl = $_SERVER['REQUEST_URI'];
        $lastIndexFlash = strrpos($currentUrl, '/', -1);
        $breadCrumb = [
            "Seatmap Management  " => substr($currentUrl,0, $lastIndexFlash),
            "Seatmap Detail " => $_SERVER['REQUEST_URI']
        ];
        return $breadCrumb;
    }

    function showSeatMap(){
        $id_seatmap = htmlentities($_GET['id']);
        $current_seatmap = $this->seatmap->getSeatmap($id_seatmap);

        if($current_seatmap->num_rows == 0){
            $this->showErrorPage();
        }else {
            $seatmap_data = $current_seatmap->fetch_assoc();
            $this->smarty->assign("breadcrumbs", $this->breadcrumbs);
            $this->smarty->assign('seatmapList',$this->seatmap->getSeatmaps());
            $this->smarty->assign('userList', $this->getUserAvailable());

            $this->smarty->assign('hasPositionUsers', $this->getUserInSeatmap($id_seatmap));
            $this->smarty->assign('seatmap', $seatmap_data);
            $this->smarty->display('seatmap_detail.tpl');
        }
    }

     function getUserAvailable(){
        return $this->userSeatmap->getUserWithoutPosision();
    }

     function isUserInSeatmap(int $id_user, int $id_seatmap): bool
     {
        $result = $this->userSeatmap->isUserHasPosition($id_user, $id_seatmap);
        $row = $result->fetch_assoc();
        if($row['count'] == 0) return false;
        return true;
    }

     function getUserInSeatmap(int $id_seatmap){
        return $this->userSeatmap->getUserInSeatmap($id_seatmap);
    }

     function changeUserPosition()
     {
        $id_seatmap = htmlentities($_POST['seatmap']);
        $id_user = htmlentities($_POST['user']);
        $coordinate_x = htmlentities($_POST['x']);
        $coordinate_y = htmlentities($_POST['y']);

        if($this->isUserInSeatmap($id_user, $id_seatmap) ){
            return  $this->userSeatmap->editUserSeatmap($id_user,$id_seatmap, $coordinate_x, $coordinate_y);
        }else {
            return $this->userSeatmap->addUserSeatmap($id_user, $id_seatmap, $coordinate_x, $coordinate_y);
        }
    }

     function deleteUserPosition(): bool
     {
        $id_seatmap = htmlentities($_POST['seatmap']);
        $id_user =htmlentities($_POST['user']) ;
        return $this->userSeatmap->deleteUserPosition($id_seatmap, $id_user);

    }

}

if($_SESSION["logined"]){
    $userSeatmapController =  UserSeatmapController::getInstance();
    $userSeatmapController->handler();
}else {
    header("Location: /seatmap/login");
}
