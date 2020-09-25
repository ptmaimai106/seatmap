<?php
include_once "DB.php";


class UserModel{
    protected $db;

    public function __construct(){
        $this-> db = DB::getInstance();
    }

    public function getUsers($page)
    {
        $page = addslashes($page);
        $page = intval($page);
        if($page>1){
            $from = 10*($page -1);
            $to=10*$page;
            $query = "SELECT * FROM `user` LIMIT $from, $to";
        }else{
            $query = "SELECT * FROM `user` LIMIT 10";
        }
        $result = $this->db->query($query);
        return $result;
    }

    public function getCountUser()
    {
        $query = "SELECT COUNT(id) AS `count` FROM `user`";
        $result = $this->db->query($query);
        return $result;
    }

    public function addUser(string $username, string $email, string $avatar):bool
    {
        $queryAdd = "INSERT INTO `user`( `username`, `email`,`avatar`)VALUES ('$username','$email','$avatar')";
        $result = $this->db->query($queryAdd);

        return $result;
    }

    public function editUser(int $id,string $username,string $email,string $avatar, string $status): bool
    {
        $queryEdit =  "UPDATE `user` SET `username`='$username',`email`='$email',`avatar`='$avatar', `status`='$status' WHERE id=$id";

//        echo $queryEdit;
//        die();
        $result = $this->db->query($queryEdit);
        return $result;
    }

    public function deleteUser( int $id): bool
    {
        $queryDelete = "DELETE FROM `user` WHERE id=$id ";
        $result = $this->db->query($queryDelete);
        return $result;
    }

    public function findEmail (string $email): int
    {
        $query = "SELECT * FROM  `user` WHERE `user`.email = '$email'";
        $result = $this->db->query($query);

        return $result->num_rows;
    }

}
