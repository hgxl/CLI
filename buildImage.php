<?php

$images = scandir("component/fixture/assets/image");

$name = "";
$path = "";

foreach ($images as $image){

    if($image === "." || $image === ".."){
        continue;
    }

    $image = strtolower($image);

    $path .= $image . "\n";

    $image = preg_replace("#\-#", " ", $image);
    $image = preg_replace("#\.jpg#", "", $image);
    $image = ucfirst($image);

    $name .= $image . "\n";

}
file_put_contents("name.txt", $name);
file_put_contents("path.txt", $path);