# COVID19 - EvoCyclone
Respirateur artificiel permettant 10 à 30 cycles par minute. 


[![Watch the video](https://raw.githubusercontent.com/libre/evocyclone/master/docs/images/preview-video1.jpg)](https://youtu.be/QGe1vSHL8Ds)

![Home Evo Photo](https://raw.githubusercontent.com/libre/evocyclone/master/docs/images/evocylone-software.png)
![Home Evo Photo](https://raw.githubusercontent.com/libre/evocyclone/master/docs/images/evocyclone-g1.jpg)
![Home Evo Photo](https://raw.githubusercontent.com/libre/evocyclone/master/docs/images/evocyclone-g2.jpg)
![Home Evo Photo](https://raw.githubusercontent.com/libre/evocyclone/master/docs/images/evocyclone-g3.jpg)

-	**Lowtech**
-	**Lowdiy**
-	**Lowcost**
-	**Évolutif en fonction du matériel à disposition.** 


Le premier problème dans tous les projets est la situation de confinement. Il est compliqué de reproduire les projets GPL actuels. 

C'est pourquoi nous nous sommes basés sur un appareil à réaliser à partir des matériaux à disposition. Ici, pignon et chaine de vélo, moteur d'essuie-glace de voiture et l'unité alimentant en 12V.
Ce développement permet l'ajout d'un capteur cardiaque, d'un capteur de pression et d'autres appareils de précision.  Ce qu'il fait et comment nous l'avons construit. Le principe est basé sur un appareil simple et robuste avec comme principe une élution à partir d'un minimum de matériaux. 

## Vérsion Basic EvoCyclo  :
-	2 x pignons de vélo
-	4 x roue de patins à roulettes ou roller : Permet d’éviter les frictions sur la ballon et évite que celui-ci soit endommagé pendant un temps d’utilisation long. 
-	1 x chaines de vélo
-	2 x plaques en bois.
-	1 profil L du chantier.
-	1 **moteur d'essuie-glace** avant 12v (VW polo small) par exemple (max 4A)
-	1 Alim 12v / Module conversion 12v>5v. 
-	Un module Steppeur:  Circuit double pont en H pour le pilotage du moteur (vitesse, sens). 
Exemple : https://www.amazon.com/Comimark-VNH2SP30-Stepper-Monster-Replace/dp/B07V3KR6N6
-	1 x **Arduino UNO** (pièce de base pour le pilotage d'EvoCyclone).
-	1 x bouton ON/OFF. 
-	1 x sélecteur de vitesse 4 positions.
-	1 capteur IR https://www.amazon.fr/Rokoo-capteur-d%C3%A9vitement-dobstacles-infrarouge/dp/B0768KL78F ou récupérer d’une télécommande. Pour la détection d’absence du ballon. 
-	En option, 1 capteur IR pour la détection d’arrêt inopiné du moteur ou « forçage » anormal de celui-ci. (Pas intégrée, mais possible de l’ajouter). 


## Version Connected : 
Évolution vers une version connectée en Wifi avec détection l’absence du ballon, alarme et pilotage à distance.  
-	 1 x OrangePIZero + (GPIO ARM 1Ghz) (pince à 700Mhz) 512Mbram. Ou RassberyPI
-	 1 x LCD ex : 16/20x4 … 
-	 1 x Menu LCD  Select MENU

L'idée étant d'utiliser le principe du cavalier (jumper) afin d'activer ou non les fonctionnalités.  Les défis que nous avons rencontrés permettent le développement en Kit afin de permettre à certains de travailler différents aspects des projets. 
Le plus important c’est que ce soit un manuel de montage permettre la mise en œuvre d'un système complet avec des systèmes de sécurité permettant de le produire avec des composants faciles à trouver même dans les zones les plus reculées.
Resistancecovid, nous sommes un groupe de passionnés d'informatique de diverses régions d'Europe. Nous travaillons activement à la mise en œuvre de protocoles d'impression 3D pour répondre aux besoins présents et futurs du personnel infirmier devant le Covid-19.

## Test de performance :
-	10 à 30 cycles par minute. 
-	Tenue opérationnelle pendant 3 jours nonstops sans endommager le ballon.  
-	Détection absence de ballon et permet un remplacement rapide et sans que la machine soit manipulée. 
-	Testée et validée avec deux modèles de ballon (Français et Belge adulte). 

## Section projet : 

- [Plan](evocyclone-plan/README.md)
- [Firmware](evocyclone-firmware/README.md)
- [Softwares](evocyclone-softwares/README.md)

## Authors : 
- Saïd Deraoui
- Thierry Morea

## Contributor
- Vapula
- Owerach
- Kryogenyx
