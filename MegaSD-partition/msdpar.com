=Partition tool for OCM/MSX++ MegaSD v1.0d by Cayce-MSX 2024>?�z	�a� 2�:?�/���: 
>2���:\ �(!��	��=2�:] �  	>2�l:^ �-(3!] ������}� ��x���x���>2�y���2�>2���:] !14��	����02�!_ �����x���y2�>2� y?�z	8\:?�/F��:?�?(˯�H(�L(8�E(�QF��>�2��> 2��:?�0!��	/��2�>2��>2����i	:�� ���[�:��(�����i��M���i	�2�<2�!EFD 6 ��:��02E:��(,_ !G ���	>-2F:G� :H2G:I2H> 2I�:�W:�G:�͇0��:�<���2��2�Þ�O2�!�~��(	�( �Y !00>��	!#T ���:��(\�(X�(Ty�_ !r>0��	����!t>���	>#2q�x�(>M2�\P�:��
>K2���:�!� ���	>B2�C�i	:��(�(:��(<2�Þ:�<�(2�Þ>2�Þ�:��A2�:�G��02��x(>-2�x��/�/�02�:<��?0�x2��02�͢��i	>2��2�:�W:�G:�͇0��:��ʁ<2��2�ٷ(��(� >2���!>yݾ  zݾ {ݾ(:��(�<2����i	�������:��02:�_>-2 � !��	�i	:�� :��(:�_ � !���	s�i	� 0>!6��	##>����	#�i	�Z 0>!R��	##>����	?�i	 _>!n��	[�i	���!Axݾ  |ݾ }ݾ(�i	���!�_:�O̓�:�O̓J�i	:�G>���2<:�W:�G:�͇0�����ٷ���;������!<��q�r�s�p�t�u>�w��w	!FGw �����:�O>�!<�o�����i	����i	��i	� �o� ���x���Db� �!�O�~�(	�(! �Y !�0>��	!�#�  ����i	�� G�:�<�c���2�x2��50����:�O>�!<�o�s2
x2�2z2	��>���5>��>�!�o��:	G>��2%>�!%�o��>�2�222:
�>��:
�>��:
G>���O !�	">O   !L��o���*L�	�~�(� :� :�>�����~��>2�~2�~	2�~
2�!�N�V�^ !L>O����o����:g:� �!
���~�_�~	�W�~
�O�~���!�~�>��:<2��:�_:�W:�O�h��7��� �{��G:<x������>�!�o������^�V	�N
�n�f�F�                                 ���       :�����C���?�O�!_���y�� ����#�7�MEGASCSI ver2.15�����*��!�� ������:�! `� :������ :�! ` � :�! `@� �!6! @�:��^ � �#��:�� �� ��!L:��� �w �#��:�! ` � �!L �^ !�0>��	�~2��~2��~2��~2��~2��~2��~2��~�/�/�/�/�02��~��02�!��V	�^
>���	!�V�^>���	��O:��y���	� �ɷ7�G:� �7�x�����!  �g!� ~�(� #(��#~�(� #(���|ݽ(02!� ~� #(��|�(	~� # �� +~� (�(#��}�7����ɽ?м(?��G�x��������!�����w ���w����w�p�q��w�w>
�w�u�t!��u
�t�~ �(��H
>> ����w�~ ��c
� >H>Bw#�4�4z�(!��F(�z(�!  ��R��>��N(>��w�ݾ ʫ
>ݾ ҭ
���zK �^!  ��j�R0?��WY}���
��
�0�
�Aw#�4�4����V +�F~�0 	+�5�5�#�~ �(�(� $>B>#w#�4�4>Hw#>&w#�4�4�4�4�~�(� >+
>-w#�4�4�~ݾ�i(ݖG�~w#�4��n
�f���w�~=_ ���~�?G�F�p�#���n
�f�^�V�N ����~��(�(�(+~��w	�>$w�4�F�N������                          ����!+�� ��� �    ~_�08'�:0#z�(�E���  {�0O	�&���#��� �� {�0�@�:�@�~ ����?��� ���������%���&�&�&����ɷ � <�o� x�8	��j� ��=!!��8##��O7Ɇ#FO��         *** ERROR: $MSDPAR - Partition tool for OCM/MSX++ MegaSD v1.0d
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