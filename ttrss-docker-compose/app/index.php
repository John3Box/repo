<?php 
   require_once("Mobile-Detect-2.8.37/Mobile_Detect.php");
   $detect = new Mobile_Detect;
   if ( $detect->isMobile() ) {
      header("Location: /mobile/index.htm");
   } else {
      header("Location: /tt-rss/");
   }
   return;
