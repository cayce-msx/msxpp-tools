=Partition tool for OCM/MSX++ MegaSD v1.0c by Cayce-MSX 2024>?�|	�a� 2�:?�/���: 
>2���:\ �(!��	��=2�:] �  	>2�l:^ �-(3!] ������}� ��x���x���>2�y���2�>2���:] !14��	����02�!_ �����x���y2�>2� y?�|	8\:?�/H��:?�?(˯�H(�L(8�E(�QH��>�2��> 2��:?�0!��	1��2�>2��>2����k	:�� ���[�:��(�����i��M���k	�2�<2�!GHD 6 ��:��02G:��(,_ !I ���	>-2H:I� :J2I:K2J> 2K�:�W:�G:�͇0��:�<���2��2�Þ�O2�!�~��(	�( �Y !20>��	! #V ���:��(\�(X�(Ty�_ !t>0��	����!v>���	>#2s�x�(>M2�\P�:��
>K2���:�!� ���	>B2�E�k	:��(�(:��(<2�Þ:�<�(2�Þ>2�Þ�:��A2�:�G��02��x(>-2�x��/�/�02�:>��?0�x2��02�͢��k	>2��2�:�W:�G:�͇0��:��ʁ<2��2�ٷ(��(� >2���!@yݾ  zݾ {ݾ(:��(�<2����k	�������:��02:�_>-2 � !��	
�k	:�� :��(:�_ � !���	u�k	� 0>!8��	##>����	%�k	�Z 0>!T��	##>����	A�k	 _>!p��	]�k	���!Cxݾ  |ݾ }ݾ(�k	���!�_:�O̓�:�O̓L�k	:�G>���2>:�W:�G:�͇0�����ٷ	���=������!>��q�r�s�p�t�u>�w��w	!HIw �����:�O>�!>�o�����k	����k	��k	� �o� ���x���Db� �!�O�~�(	�(! �Y !�0>��	!�#�  ����k	�� G�:�<�e���2�x2��50����:�O>�!>�o�s2
x2�2z2	��>���5>��>�!�o��:	G>��2%>�!%�o��>�2�222:
�>��:
�>��:
G>���O !�	">O   !N��o���*N�	�~�(� :� :�>�����~��>2�~2�~	2�~
2�!�N�V�^ !N>O����o����:g:� �!���~�_�~	�W�~
�O�~���!�~�>��:<2��:�_:�W:�O�h��7��� �{��G:<x������>�!�o������^�V	�N
�n�f�F�                                 ���       :�����C���?�O�!_���y�� ����#�7�MEGASCSI ver2.15�����*��!�� ������:�! `� :������ :�! ` � :�! `@� �!8! @�:��^ � �#��:��� ���!N:��� �w �#��:�! ` � �!N �^ !�0>��	�~2��~2��~2��~2��~2��~2��~2��~�/�/�/�/�02��~��02�!��V	�^
>���	!�V�^>���	��O:��y���	� �ɷ7�G:� �7�x�����!  �g!� ~�(� #(��#~�(� #(���|ݽ(02!� ~� #(��|�(	~� # �� +~� (�(#��}�7����ɽ?м(?��G�x��������!�����w ���w����w�p�q��w�w>
�w�u�t!��u
�t�~ �(��J
>> ����w�~ ��e
� >H>Bw#�4�4z�(!��F(�z(�!  ��R��>��N(>��w�ݾ ʭ
>ݾ ү
���zK �^!  ��j�R0?��WY}���
��
�0�
�Aw#�4�4����V +�F~�0 	+�5�5�#�~ �(�(� $>B>#w#�4�4>Hw#>&w#�4�4�4�4�~�(� >+
>-w#�4�4�~ݾ�k(ݖG�~w#�4��n
�f���w�~=_ ���~�?G�F�p�#���n
�f�^�V�N ����~��(�(�(+~��w	�>$w�4�F�N������                          ����!-�� ��� �    ~_�08'�:0#z�(�G���  {�0O	�(���#��� �� {�0�B�:�B�~ ����?��� ���������%���(�(�(����ɷ � <�o� x�8	��j� ��=!!��8##��O7Ɇ#FO��         *** ERROR: $MSDPAR - Partition tool for OCM/MSX++ MegaSD v1.0c
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
$Partition mapped to drive  :

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