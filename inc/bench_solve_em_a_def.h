#ifdef BENCH
   INTEGER, EXTERNAL :: rsl_internal_microclock
   INTEGER btimex, solve_tim
#define SOLVE_START     solve_tim = rsl_internal_microclock()
#define SOLVE_END       solve_tim = rsl_internal_microclock() - solve_tim
#define BENCH_DECL(A)   integer A
#define BENCH_INIT(A)   A=0
#define BENCH_START(A)  btimex=rsl_internal_microclock()
#define BENCH_END(A)    A=A+rsl_internal_microclock()-btimex
#define BENCH_REPORT(A) write(0,*)'A= ',A
BENCH_DECL(exch1)
BENCH_DECL(exch2)
BENCH_DECL(exch3)
BENCH_DECL(exch4)
BENCH_DECL(exch5)
BENCH_DECL(exch6)
BENCH_DECL(exch7)
BENCH_DECL(exch8)
BENCH_DECL(exch9)
BENCH_DECL(exch10)
BENCH_DECL(exch11)
BENCH_DECL(exch12)
BENCH_DECL(exch13)
BENCH_DECL(exch14)
BENCH_DECL(exch15)
BENCH_DECL(exch16)
BENCH_DECL(exch17)
BENCH_DECL(exch18)
BENCH_DECL(exch19)
BENCH_DECL(exch20)
BENCH_DECL(exch21)
BENCH_DECL(exch22)
BENCH_DECL(exch23)
BENCH_DECL(exch24)
BENCH_DECL(exch25)
BENCH_DECL(exch26)
BENCH_DECL(exch23)
BENCH_DECL(exch24)
BENCH_DECL(exch25)
BENCH_DECL(exch26)
BENCH_DECL(exch27)
BENCH_DECL(exch28)
BENCH_DECL(exch29)
BENCH_DECL(exch30)
BENCH_DECL(exch31)
BENCH_DECL(exch32)
BENCH_DECL(exch33)
BENCH_DECL(exch34)
BENCH_DECL(exch35)
BENCH_DECL(exch36)
BENCH_DECL(exch37)
BENCH_DECL(exch38)
BENCH_DECL(exch39)
BENCH_DECL(exch40)
BENCH_DECL(exch41)
BENCH_DECL(exch42)
BENCH_DECL(exch43)
BENCH_DECL(exch44)
BENCH_DECL(exch45)
BENCH_DECL(exch46)
BENCH_DECL(exch47)
BENCH_DECL(exch48)
BENCH_DECL(exch49)
BENCH_DECL(exch50)
BENCH_DECL(exch51)
BENCH_DECL(exch52)
BENCH_DECL(exch53)
BENCH_DECL(exch54)
BENCH_DECL(exch55)
BENCH_DECL(exch56)
BENCH_DECL(exch57)
BENCH_DECL(exch58)
BENCH_DECL(exch59)
BENCH_DECL(exch60)
BENCH_DECL(exch61)
BENCH_DECL(exch62)
BENCH_DECL(exch63)
BENCH_DECL(exch64)
BENCH_DECL(exch65)
BENCH_DECL(exch66)
BENCH_DECL(exch67)
BENCH_DECL(exch68)
BENCH_DECL(exch69)
BENCH_DECL(exch70)
BENCH_DECL(exch71)
BENCH_DECL(exch72)
BENCH_DECL(exch73)
BENCH_DECL(exch74)
BENCH_DECL(exch75)
BENCH_DECL(exch76)
BENCH_DECL(exch77)
BENCH_DECL(exch78)
BENCH_DECL(exch79)
BENCH_DECL(exch80)
BENCH_DECL(exch81)
BENCH_DECL(exch82)
BENCH_DECL(exch83)
BENCH_DECL(exch84)
BENCH_DECL(exch85)
BENCH_DECL(exch86)
BENCH_DECL(exch87)
BENCH_DECL(exch88)
BENCH_DECL(exch89)
BENCH_DECL(exch90)
BENCH_DECL(exch91)
BENCH_DECL(exch92)
BENCH_DECL(exch93)
BENCH_DECL(exch94)
BENCH_DECL(exch95)
BENCH_DECL(exch96)
BENCH_DECL(exch97)
BENCH_DECL(exch98)
BENCH_DECL(exch99)
BENCH_DECL(exch100)
BENCH_DECL(exch101)
BENCH_DECL(exch102)
BENCH_DECL(exch103)
BENCH_DECL(exch104)
BENCH_DECL(exch105)
BENCH_DECL(exch106)
BENCH_DECL(exch107)
BENCH_DECL(exch108)
BENCH_DECL(exch109)
BENCH_DECL(exch110)
BENCH_DECL(exch111)
BENCH_DECL(exch112)
BENCH_DECL(exch113)
BENCH_DECL(exch114)
#else
#define SOLVE_START
#define SOLVE_END
#define BENCH_INIT(A)
#define BENCH_START(A)
#define BENCH_END(A)
#define BENCH_REPORT(A)
#endif