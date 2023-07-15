lw   $v0 128($zero) # Make sure to load the value 86 at line 32 of the .coe (00000000000000000000000001010110)
add  $v1 $v0 $v0
sw   $v1 132 $zero
sub  $a0 $v1 $v0 
addi $a1 $v1 12
and  $a2 $a1 $v1
or   $a3 $a2 $v0
nor  $t0 $a2 $v0
slt  $a2 $a1 $a0
beq  $zero $zero -32
lw   $t0, 132($zero) # Used to verify correct execution of the program.