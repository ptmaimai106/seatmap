<?php

class User{
    public $id;
    public $username;
    public $email;
    public $avatar;
    public $status;
    public $create_at;
    public $update_at;

    public function __construct($id, $username, $email, $avatar,$status, $create_at, $update_at){
        $this->id = $id;
        $this->username = $username;
        $this->email = $email;
        $this->avatar= $avatar;
        $this->create_at = $create_at;
        $this->status = $status;
        $this->update_at = $update_at;
    }

}