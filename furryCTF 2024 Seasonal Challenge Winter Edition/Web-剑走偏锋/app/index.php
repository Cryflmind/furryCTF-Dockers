<?php

error_reporting(0);
highlight_file(__FILE__);

//flag is in 51ag.txt, but how to get it?

if (isset($_GET['furry']) && isset($_POST['CTF'])) {
    $furry = $_GET['furry'];
    $CTF = $_POST['CTF'];
    if (!preg_match("/[a-zA-Z0-9_@%&?*:\-\+\"|`;\[\]]/",$furry) && !preg_match("/[a-zA-Z0-9_@%&*:\-\+\"|`;\[\]]/",$CTF)){
            echo "Success:";
            system("cat ".$furry.$CTF);
        }else{
            echo("No Hack uwu.");
        }
}

//note: There're two files: 5lag.txt and flag.txt

?>