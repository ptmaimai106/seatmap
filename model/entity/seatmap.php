<?php

class Seatmap{
    public $id;
    public $name;
    public $filename;
    public $create_at;
    public $update_at;

    public function __construct($id, $name, $filename, $create_at, $update_at){
        $this->id = $id;
        $this->name = $name;
        $this->filename = $filename;
        $this->create_at = $create_at;
        $this->update_at = $update_at;
    }
}