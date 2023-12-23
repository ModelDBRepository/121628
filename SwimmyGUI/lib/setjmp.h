/*
** Copyright (C) 1991 DJ Delorie, 24 Kirsten Ave, Rochester NH 03867-2954
**
** This file is distributed under the terms listed in the document
** "copying.dj", available from DJ Delorie at the address above.
** A copy of "copying.dj" should accompany this file; if not, a copy
** should be available from where this file was obtained.  This file
** may not be distributed without a verbatim copy of "copying.dj".
**
** This file is distributed WITHOUT ANY WARRANTY; without even the implied
** warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

#ifndef _SETJMP_H_
#define _SETJMP_H_

#ifdef __cplusplus
extern "C" {
#endif

#if 0
/* this is the gcc version */
typedef struct {
  unsigned long eax;
  unsigned long ebx;
  unsigned long ecx;
  unsigned long edx;
  unsigned long esi;
  unsigned long edi;
  unsigned long ebp;
  unsigned long esp;
  unsigned long eip;
  unsigned short es;
  unsigned short fs;
  unsigned short gs;
  unsigned short ss;
} jmp_buf[1];

#else
/* this is the borland version. Useful for compiling under gcc to make
dlls that can be loaded by .exe made with borland4.5 */
typedef struct __jmp_buf {
    unsigned    j_ebp;
    unsigned    j_ebx;
    unsigned    j_edi;
    unsigned    j_esi;
    unsigned    j_esp;
    unsigned    j_ret;
    unsigned    j_excep;
    unsigned    j_context;
}   jmp_buf[1];
#endif

extern int setjmp(jmp_buf);
extern void longjmp(jmp_buf, int);

#ifdef __cplusplus
}
#endif

#endif
