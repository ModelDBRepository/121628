/* This is file stdio.h */
/* This file may have been modified by DJ Delorie (Jan 1991).  If so,
** these modifications are Coyright (C) 1991 DJ Delorie, 24 Kirsten Ave,
** Rochester NH, 03867-2954, USA.
*/

#ifndef _stdio_h_
#define _stdio_h_

#include <stddef.h> /* for size_t */

#ifndef	STDC_HEADERS
#define STDC_HEADERS
#endif

#define BUFSIZ  4096

#if 0
/* this is the gcc version */
extern  struct  _iobuf {
    int		_cnt;
    char*	_ptr;
    char*	_base;
    int		_bufsiz;
    short	_flag;
    short	_file;
} _iob[];
#else
/* this is the borland version. Useful for compiling under gcc to make
dlls that can be loaded by .exe made with borland4.5 */
/* all I know about this is that fprintf(stderr... works */
extern struct  _iobuf {
        unsigned char  *curp;
        unsigned char  *buffer;
        int             level;
        int             bsize;
        unsigned short  istemp;
        unsigned short  flags;
        short           token;
        char            fd;
        unsigned char   hold;
} _iob[];
#endif

typedef struct _iobuf FILE;

#define _IOFBF    00000
#define _IOREAD   00001
#define _IOWRT    00002
#define _IONBF    00004
#define _IOMYBUF  00010
#define _IOEOF    00020
#define _IOERR    00040
#define _IOSTRG   00100
#define _IOLBF    00200
#define _IORW     00400
#define _IOAPPEND 01000
#define _IOTEXT   02000  /* for MSDOS cr/lf style files */

#define FILENAME_MAX	160 /* in case of ../../../../../../... */
#define FOPEN_MAX	256
#define TMP_MAX		FILENAME_MAX

#define EOF       (-1)

#ifndef NULL
#define NULL      0
#endif

#define stdin     (&_iob[0])
#define stdout    (&_iob[1])
#define stderr    (&_iob[2])
#define stdaux    (&_iob[3])
#define stdprn    (&_iob[4])

#define getc(p) (--(p)->_cnt>=0 ? \
  (int)(*(unsigned char*)(p)->_ptr++) : \
  _filbuf(p))
#define putc(x,p) (--(p)->_cnt>=0? \
  ((int)((unsigned char)((*(p)->_ptr++=(unsigned)(x))))): \
  _flsbuf((unsigned)(x),p))

typedef long fpos_t;
#define fgetpos(stream, pos) (((*(pos) = ftell(stream)) == -1) ? -1 : 0)
#define fsetpos(stream, pos) (fseek((stream), *(pos), SEEK_SET))

extern void (clearerr) (FILE *);
extern void (_fwalk) (void (*)(FILE *));
extern int (fpurge) (FILE *);
extern int (getc) (FILE *);
extern int (putc) (int, FILE *);
extern int (feof) (FILE *);
extern int (ferror) (FILE *);
extern int (fileno) (FILE *);

#define getchar()   getc(stdin)
#define putchar(x)  putc(x,stdout)
#if 0
#define clearerr(p) ((p)->_flag &= ~(_IOERR|_IOEOF))
#define feof(p)     (((p)->_flag&_IOEOF)!=0)
#define ferror(p)   (((p)->_flag&_IOERR)!=0)
#define fileno(p)   ((p)->_file)
#else
#define _F_EOF 0x0020
#define _F_ERR 0x0010
#define feof(p)     (((p)->flags&_F_EOF))
#define ferror(p)   (((p)->flags&_F_ERR))
#define fileno(p)   ((p)->fd)
#endif

#ifdef __cplusplus
extern "C" {
#endif

int    _doprnt(const char*, void *, FILE*);
int    _doscan(FILE*, const char*, void **argp);
int    _doscan_low(FILE *, int (*)(FILE *), int (*)(int, FILE *),
                   const char *, void **);
int    _filbuf(FILE*);
int    _flsbuf(unsigned, FILE*);
int    fclose(FILE*);
int    fcloseall(void);
FILE*  fdopen(int, const char*);
int    fflush(FILE*);
int    fgetc(FILE*);
char*  fgets(char*, int, FILE *);
FILE*  fopen(const char*, const char*);
int    fprintf(FILE*, const char*, ...);
int    fputc(int, FILE*);
int    fputs(const char*, FILE*);
size_t fread(void*, size_t, size_t, FILE*);
FILE*  freopen(const char*, const char*, FILE*);
int    fscanf(FILE*, const char*, ...);
int    fseek(FILE*, long, int);
long   ftell(FILE *);
size_t fwrite(const void*, size_t, size_t, FILE*);
char*  gets(char*);
int    getw(FILE*);
int    pclose(FILE*);
FILE*  popen(const char*, const char*);
int    printf(const char*, ...);
int    puts(const char*);
int    putw(int, FILE*);
void   rewind(FILE*);
int    scanf(const char*, ...);
void   setbuf(FILE*, char*);
void   setbuffer(FILE*, char*, int);
void   setlinebuf(FILE*);
int    setvbuf(FILE*, char*, int, int);
int    sprintf(char*, const char*, ...);
int    sscanf(const char*, const char*, ...);
FILE*  tmpfile(void);
int    ungetc(int, FILE*);
int    vfprintf(FILE*, const char*, ...);
int    vprintf(const char*, ... );
int    vsprintf(char*, const char*, ...);

#ifdef __cplusplus
}
#endif

#ifndef L_ctermid
#define L_ctermid       9 
#endif
#ifndef L_cuserid
#define L_cuserid       9
#endif
#ifndef P_tmpdir
#define P_tmpdir    "/tmp"
#endif
#ifndef L_tmpnam
#define L_tmpnam    (sizeof(P_tmpdir) + 15)
#endif

#ifndef alloca
#define alloca(x)  __builtin_alloca(x)
#endif

#ifndef SEEK_SET
#define SEEK_SET 0
#endif

#ifndef SEEK_CUR
#define SEEK_CUR 1
#endif

#ifndef SEEK_END
#define SEEK_END 2
#endif

#endif /* _stdio_h_ */
