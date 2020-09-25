<?php
include_once "DB.php";


class UserSeatmapModel{
    protected $db;

    public function __construct(){
        $this-> db = DB::getInstance();
    }

    public function getUserSeatmaps()
    {
        $query = "SELECT * FROM user_seatmap";
        $result = $this->db->query($query);
        return $result;
    }

    public function addUserSeatmap(int $id_user,int $id_seatmap,float $coordinate_x,float $coordinate_y): bool
    {
        $queryAdd = "INSERT INTO `user_seatmap`( `id_user`, `id_seatmap`,`coordinate_x`, `coordinate_y`)VALUES ('$id_user','$id_seatmap', '$coordinate_x', '$coordinate_y')";
        $result = $this->db->query($queryAdd);
        return $result;
    }

    public function editUserSeatmap(int $id_user, int $id_seatmap,float $coordinate_x, float $coordinate_y): bool
    {
        $queryEdit =  "UPDATE `user_seatmap` SET `coordinate_x`='$coordinate_x',`coordinate_y`='$coordinate_y' WHERE id_user='$id_user' AND id_seatmap='$id_seatmap'";
        $result = $this->db->query($queryEdit);
        return $result;
    }

    public function deleteUserPosition(int $id_seatmap, int $id_user): bool
    {
        $queryDelete = "DELETE FROM `user_seatmap` WHERE id_seatmap='$id_seatmap' AND  id_user= '$id_user'";
        $result = $this->db->query($queryDelete);
        return $result;
    }

    public function getUserInSeatmap(int $id_seatmap){
        $query = "SELECT * FROM `user`  JOIN `user_seatmap` WHERE `user`.id = `user_seatmap`.id_user AND `user_seatmap`.id_seatmap ='$id_seatmap'";
        $result = $this->db->query($query);
        return $result;
    }

    public function getUserWithoutPosision(){
        $query = "SELECT `user`.id, `user`.username, `user`.avatar FROM `user`  LEFT JOIN  `user_seatmap` ON `user_seatmap`.id_user = `user`.id WHERE `user_seatmap`.id_user IS NULL AND `user`.status = 'active'";
        $result = $this->db->query($query);
        return $result;
    }

    public function isUserHasPosition(int $id_user,int $id_seatmap){
        $query = "SELECT COUNT(id_user) AS `count` FROM `user_seatmap` WHERE  `user_seatmap`.id_user = '$id_user' AND `user_seatmap`.id_seatmap='$id_seatmap'";
        $result = $this->db->query($query);

        return $result;
    }

}
