<Partition tool for OCM/MSX++ MegaSD v1.0 by Cayce-MSX 2024o� ��x���>?̀	�p� 2�:?�/��: 
>2��:\ �(!��	'�=2�:] �  	>2�l:^ �-(3!] ����}� �x��x��>2�y��2�>2��:] !14��	��02�!_ ���x��y2�>2� y?̀	8\:?�/]�:?�?(˯�H(�L(8�E(�Q]�>�2��> 2��:?�0!��	F�2�>2��>2����o	:�� ���a�%:��(�����t��X���o	�2�<2�!cdD 6 ��:��02c:��(,_ !e ���	>-2d:e� :f2e:g2f> 2g�:�W:�G:�͍0��%:�<���2��2�í�O2�!�~��(	�( �Y !N0>��	!<#r ���:��(\�(X�(Ty�_ !�>0��	����!�>���	>#2��x�(>M2�\P�:��
>K2���:�!� ���	>B2�a�o	:��(�(:��(<2�í:�<�(2�í>2�í�:��A2�:�G��02��x(>-2�x��/�/�02�:Z��?0�x2��02�ͨ��o	>2��2�:�W:�G:�͍0��%:��ʐ<2��2�ٷ(��(� >2���!\yݾ  zݾ {ݾ(:��(�<2����o	�������:��029:�_>-2: � !;��	&�o	:�� :��(:�_ � !���	��o	� 0>!T��	##���	A�o	�Z 0>!p��	##���	]�o	 _>!���	y�o	���!_xݾ  |ݾ }ݾ((�o	���!�_:�O͉�:�O͉a�o	:�G>���2Z:�W:�G:�͍0��%��ٷ��R����!Z��q�r�s�p�t�u>�w��w	!dew �����:�O>�!Z�u�%*���o	����o	��o	����o	��o	� b� �!�O�~�(	�(! �Y !�0>��	!�#�  ����o	�� G�:�<�i��2�x2��;0���:�O>�!Z�u�s2x2�2z2��>���;>��>�!�u��:G>��2+>�!+�u��>�2�222:�>��:�>��:G>���O !�	">O   !j��u���*j�	�~�(� :� :�>�����~��>2�~2�~	2�~
2�!�N�V�^ !j>O����u����:g:� �!(��~�_�~	�W�~
�O�~���!8�~�>��:<2��:�_:�W:�O�n��7��� �{��G:<x������>�!�u������^�V	�N
�n�f�F�                                 ���       :�����I���?�O�!e���y�� ����#�7�MEGASCSI ver2.15�����*��!�� ������:�! `� :������ :�! ` � :�! `@� �!T! @�:��^ � �#��:�� �? ��!j:��� �w �#��:�! ` � �!j �^ !0>��	�~2�~2�~2�~2	�~2
�~2�~2�~�/�/�/�/�02�~��02!�V	�^
>���	!�V�^>���	��O:��y���	� �ɷ7�G:� �7�x�����!  �g!� ~�(� #(��#~�(� #(���|ݽ(02!� ~� #(��|�(	~� # �� +~� (�(#��}�7����ɽ?м(?��G�x��������!�����w ���w����w�p�q��w�w>
�w�u�t!��u
�t�~ �(��N
>> ����w�~ ��i
� >H>Bw#�4�4z�(!��F(�z(�!  ��R��>��N(>��w�ݾ ʱ
>ݾ ҳ
���zK �^!  ��j�R0?��WY}���
��
�0�
�Aw#�4�4����V +�F~�0 	+�5�5�#�~ �(�(� $>B>#w#�4�4>Hw#>&w#�4�4�4�4�~�(� >+
>-w#�4�4�~ݾ�o(ݖG�~w#�4��n
�f���w�~=_ ���~�?G�F�p�#���n
�f�^�V�N ����~��(�(�(+~��w	�>$w�4�F�N������                          ����!1�� ��� �    ~_�08'�:0#z�(�K���  {�0O	�,���#��� �� {�0�F�:�F�~ ����?��� ���������%���,�,�,����ɷ � <�o� x�8	��j� ��=!!��8##��O7Ɇ#FO��         *** ERROR: $MSDPAR - Partition tool for OCM/MSX++ MegaSD v1.0
(C) 2024 Cayce-MSX, based on PARSET by Konamiman.
This program comes with ABSOLUTELY NO WARRANTY.
It's free software, you're welcome to redistribute under certain conditions

$Usage: MSDPAR [<drive>]:
         Shows number of partition currently connected to the drive
         ":" selects the default drive
       MSDPAR [<drive>:]<abs>|<prim>-<ext>
         abs:  Absolute partition number (1 to 256)
         prim: Primary partition number (1 to 4)
         ext:  Extended partition number (1 to 255)
               * If partition is not extended, use ext=0
               * Absolute partitions and primary + extended match as follows:
                 prim + ext       abs
                   1-0             1
                   2-1             2
                   2-2             3
                   2-3             4   etc...
                   3-x & 4-x      Can't use absolute number
       MSDPAR /L              Show all partitions on the disk
       MSDPAR [<drive>:] /Ei  Enable i MegaSD drives (1-8)
$DOS 2 required!
$Invalid partition specification

$Invalid drive specification

$Invalid drive count

$Too many parameters

$No MegaSD found in the specified slot
$The specified drive is not controlled by a MegaSD
$The specified drive does not exist
$The specified partition does not exist
$The specified partition is undefined on this disk
$The specified partition is extended.
           Please specify extended partition number
           in the range 1-255, or use absolute partition number.
$
WARNING: No valid partition connected to this drive
$
WARNING: Drive size and partition size are not equal
$Please RESET to activate drive change (don't power off!)
$/ID /S Partition mapped to drive  :

MegaSD slot:          
Device ID:          
SD Card Id:       #           v_._ serial #        
$Partition number:       
$Start sector:     #      
$Partition length: #      
$Partition type:   #  
$Absolute partition number:    
$*** MegaSD ERROR:                                 
$Device not ready                Data transfer error             Reservation conflict            Other error / arbitration error Format error                    Invalid ID number                Unknown error (code #  )        Par. num.        Type (*=unsupported)         First sector         Size
---------        --------------------         ------------         ----
$                                                                      B
$  --- unused / empty --- MS(X)-DOS, FAT12        MS(X)-DOS, FAT16 <32MiB Extended (CHS)          MS(X)-DOS, FAT16 >32MiB exFAT *                 W95 FAT32 *             W95 FAT32 (LBA) *       W95 FAT16 (LBA)         Extended (LBA)          Hidden FAT12            Hidden FAT16 <32MiB     Hidden FAT16            Hidden W95 FAT32 *      Hidden W95 FAT32 *      Hidden W95 FAT16        �-- Unknown (byte #  ) * J    