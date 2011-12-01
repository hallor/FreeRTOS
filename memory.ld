MEMORY
{
  flash(rx): ORIGIN = 0x00000000, LENGTH = 32K
  sram(rwx): ORIGIN = 0x10000000+384, LENGTH = 8K-384
}
INCLUDE linkscript.ld
