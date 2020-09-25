<?php

class User_Seatmap{
    public $id;
    public $id_user;
    public $id_seatmap;
    public $coordinate_x;
    public $coordinate_y;
    public $create_at;
    public $update_at;


    public function __construct($id, $id_user, $id_seatmap, $coordinate_x, $coordinate_y, $create_at){
        $this->id = $id;
        $this->id_user = $id_user;
        $this->id_seatmap = $id_seatmap;
        $this->coordinate_x= $coordinate_x;
        $this->coordinate_y = $coordinate_y;
        $this->create_at = $create_at;
    }
}