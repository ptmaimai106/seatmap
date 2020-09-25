<?php

include_once "../model/entity/seatmap.php";
include_once "../model/seatmap_model.php";

require_once "../smarty/mySmarty.php";
session_start();

define("SITE_ROOT", realpath(dirname(__FILE__)));


class SeatmapController{
    public $seatmap;
    public $smarty;
    public $messageUpload;
    public $message;
    public $breadcrumbs;

    private static $instance;


    private function __construct(){
        $this->seatmap = new SeatmapModel();
        $this->messageUpload = "";
        $this->message="";
        $this->smarty = new MySmarty();
        $this->breadcrumbs = $this->showBreadCrumb();
    }

    public static function getInstance(){
        if(!isset(self::$instance)){
            self::$instance = new SeatmapController();
        }
        return self::$instance;
    }

    function invoke($message){

        $this->smarty->assign("breadcrumbs", $this->breadcrumbs);

        $this->smarty->assign('message', $message);
        $this->smarty->assign('seatmapList', $this->getSeatmaps());
        $this->smarty->display('seatmap.tpl');
    }

    public function handler(){
        if(isset($_POST['add-seatmap'])){
            $this->message = $this->uploadSeatmap();
        }
        else if(isset($_POST['update-seatmap'])){
            $this->message = $this->editSeatmap();
        }else if(isset($_POST['delete-seatmap'])){
            $this->message = $this->deleteSeatmap();
        }
        else if(isset($_GET['id'])){
            print_r($_GET['id']);
            return true;
        }
        else{
            $this->message="";
        }
        $this->invoke($this->message);

    }

    function showBreadCrumb():array {
        $currentUrl = $_SERVER['REQUEST_URI'];
        $breadCrumb = [
            "Seatmap management" => $currentUrl
        ];
        return $breadCrumb;
    }

    function getSeatmaps(): array
     {
        $seatmapData = $this->seatmap->getSeatmaps();
        $seatmapList = array();
        if(is_object($seatmapData)){
            while($row = $seatmapData->fetch_assoc()){
                $seatMap = new Seatmap($row['id'], $row['name'], $row['filename'], $row['create_at'], $row['update_at']);
                array_push($seatmapList, $seatMap);
            }
        }
        return $seatmapList;
    }

    function uploadImage(): bool
    {
        $target_dir = SITE_ROOT."/seatmap/";
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

    function uploadSeatmap(): string
    {
        $name = htmlentities($_POST['name']);
        if($this->uploadImage() ==false){
            return $this->messageUpload;
        }
        $filename = "seatmap/".basename($_FILES["image"]["name"]);

        $insert_id = $this->seatmap->addSeatmap($name, $filename);
        if($insert_id){
            return 'Add seatmap success';
        }
        return "Add seatmap failure";
    }

    function editSeatmap(): string
     {
        $id = htmlentities($_POST['id']);
        $name = htmlentities($_POST['name']);
        $filename = htmlentities($_POST['image_seatmap']);

        if($_FILES["image"]["name"]){
            if($this->uploadImage() == false)
                 return $this->messageUpload;
            $filename = "seatmap/".basename($_FILES["image"]["name"]);
        }

        $result = $this->seatmap->editSeatmap($id, $name, $filename);
        if($result){
            return "Update seat-map info success";
        }
        return "Update seat-map info failed";
    }

     function deleteSeatmap(){
        $id = htmlentities($_POST['id_d']);
        if(isset($id)){
            $result = $this->seatmap->deleteSeatmap($id);
            if($result){
                return "Delete seatmap successfully";
            }else {
                return "Delete seatmap failed";
            }
        }
    }

}

if(isset($_SESSION['logined']) ){
    $seatmapController =  SeatmapController::getInstance();
    $seatmapController->handler();
}else {
    header("Location: /seatmap/login");
}

