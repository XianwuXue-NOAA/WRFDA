#include <stdio.h>
#include <stddef.h>
#include "gribw.h"


static unsigned char gds1[ 42] = {
  0,   0,  42,   0, 255,   1,   0,  73,   0,  23, 
128, 187, 218,   0,   0,   0, 128,   0, 187, 218, 
  0,   0,   0,   0,  87, 228,   0,  64,   7, 214, 
133,   7, 214, 133,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds2[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 144,   0,  73, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   9, 196,   9, 196,   9, 196,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds3[ 32] = {
  0,   0,  32,   0, 255,   0,   1, 104,   0, 181, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   3, 232,   3, 232,   3, 232,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds4[ 32] = {
  0,   0,  32,   0, 255,   0,   2, 208,   1, 105, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   1, 244,   1, 244,   1, 244,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds5[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  53,   0,  57, 
  0,  29, 223, 130,   9,  67,   8, 129, 154,  40, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds6[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  53,   0,  45, 
  0,  29, 223, 130,   9,  67,   8, 129, 154,  40, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds8[ 42] = {
  0,   0,  42,   0, 255,   1,   0, 116,   0,  44, 
128, 190,  30,   0,  12,  32, 128,   0, 238, 122, 
  0,   0,   0,   0,  87, 228,   0,  64,   4, 221, 
110,   4, 221, 110,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds21[106] = {
  0,   0, 106,   0,  33,   0, 255, 255,   0,  37, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
  2, 191,  32,  19, 136,   9, 196,  64,   0,   0, 
  0,   0,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,   1, 
 };
static unsigned char gds22[106] = {
  0,   0, 106,   0,  33,   0, 255, 255,   0,  37, 
  0,   0,   0, 130, 191,  32, 128,   1,  95, 144, 
  0,   0,   0,  19, 136,   9, 196,  64,   0,   0, 
  0,   0,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,   1, 
 };
static unsigned char gds23[106] = {
  0,   0, 106,   0,  33,   0, 255, 255,   0,  37, 
129,  95, 144,   0,   0,   0, 128,   0,   0,   0, 
  2, 191,  32,  19, 136,   9, 196,  64,   0,   0, 
  0,   0,   0,   1,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37, 
 };
static unsigned char gds24[106] = {
  0,   0, 106,   0,  33,   0, 255, 255,   0,  37, 
129,  95, 144, 130, 191,  32, 128,   0,   0,   0, 
  0,   0,   0,  19, 136,   9, 196,  64,   0,   0, 
  0,   0,   0,   1,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37,   0,  37,   0,  37, 
  0,  37,   0,  37,   0,  37, 
 };
static unsigned char gds25[ 70] = {
  0,   0,  70,   0,  33,   0, 255, 255,   0,  19, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
  5, 106, 184,  19, 136,  19, 136,  64,   0,   0, 
  0,   0,   0,  72,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,   1, 
 };
static unsigned char gds26[ 70] = {
  0,   0,  70,   0,  33,   0, 255, 255,   0,  19, 
129,  95, 144,   0,   0,   0, 128,   0,   0,   0, 
  5, 106, 184,  19, 136,  19, 136,  64,   0,   0, 
  0,   0,   0,   1,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,  72, 
  0,  72,   0,  72,   0,  72,   0,  72,   0,  72, 
 };
static unsigned char gds27[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  65, 
128,  81,  90, 129, 232,  72,   8, 129,  56, 128, 
  5, 208,  72,   5, 208,  72,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds28[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  65, 
  0,  81,  90,   2,  54, 104,   8,   1, 134, 160, 
  5, 208,  72,   5, 208,  72, 128,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds29[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 145,   0,  37, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
  5, 126,  64,   9, 196,   9, 196,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds30[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 145,   0,  37, 
129,  95, 144,   0,   0,   0, 128,   0,   0,   0, 
  5, 126,  64,   9, 196,   9, 196,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds33[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 181,   0,  46, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
  5, 126,  64,   7, 208,   7, 208,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds34[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 181,   0,  46, 
129,  95, 144,   0,   0,   0, 128,   0,   0,   0, 
  5, 126,  64,   7, 208,   7, 208,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds37[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
  0,   0,   0, 128, 117,  48, 128,   1,  95, 144, 
  0, 234,  96, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73,   0,  72, 
  0,  72,   0,  72,   0,  71,   0,  71,   0,  71, 
  0,  70,   0,  70,   0,  69,   0,  69,   0,  68, 
  0,  67,   0,  67,   0,  66,   0,  65,   0,  65, 
  0,  64,   0,  63,   0,  62,   0,  61,   0,  60, 
  0,  60,   0,  59,   0,  58,   0,  57,   0,  56, 
  0,  55,   0,  54,   0,  52,   0,  51,   0,  50, 
  0,  49,   0,  48,   0,  47,   0,  45,   0,  44, 
  0,  43,   0,  42,   0,  40,   0,  39,   0,  38, 
  0,  36,   0,  35,   0,  33,   0,  32,   0,  30, 
  0,  29,   0,  28,   0,  26,   0,  25,   0,  23, 
  0,  22,   0,  20,   0,  19,   0,  17,   0,  16, 
  0,  14,   0,  12,   0,  11,   0,   9,   0,   8, 
  0,   6,   0,   5,   0,   3,   0,   2, 
 };
static unsigned char gds38[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
  0,   0,   0,   0, 234,  96, 128,   1,  95, 144, 
  2,  73, 240, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73,   0,  72, 
  0,  72,   0,  72,   0,  71,   0,  71,   0,  71, 
  0,  70,   0,  70,   0,  69,   0,  69,   0,  68, 
  0,  67,   0,  67,   0,  66,   0,  65,   0,  65, 
  0,  64,   0,  63,   0,  62,   0,  61,   0,  60, 
  0,  60,   0,  59,   0,  58,   0,  57,   0,  56, 
  0,  55,   0,  54,   0,  52,   0,  51,   0,  50, 
  0,  49,   0,  48,   0,  47,   0,  45,   0,  44, 
  0,  43,   0,  42,   0,  40,   0,  39,   0,  38, 
  0,  36,   0,  35,   0,  33,   0,  32,   0,  30, 
  0,  29,   0,  28,   0,  26,   0,  25,   0,  23, 
  0,  22,   0,  20,   0,  19,   0,  17,   0,  16, 
  0,  14,   0,  12,   0,  11,   0,   9,   0,   8, 
  0,   6,   0,   5,   0,   3,   0,   2, 
 };
static unsigned char gds39[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
  0,   0,   0,   2,  73, 240, 128,   1,  95, 144, 
129, 212, 192, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73,   0,  72, 
  0,  72,   0,  72,   0,  71,   0,  71,   0,  71, 
  0,  70,   0,  70,   0,  69,   0,  69,   0,  68, 
  0,  67,   0,  67,   0,  66,   0,  65,   0,  65, 
  0,  64,   0,  63,   0,  62,   0,  61,   0,  60, 
  0,  60,   0,  59,   0,  58,   0,  57,   0,  56, 
  0,  55,   0,  54,   0,  52,   0,  51,   0,  50, 
  0,  49,   0,  48,   0,  47,   0,  45,   0,  44, 
  0,  43,   0,  42,   0,  40,   0,  39,   0,  38, 
  0,  36,   0,  35,   0,  33,   0,  32,   0,  30, 
  0,  29,   0,  28,   0,  26,   0,  25,   0,  23, 
  0,  22,   0,  20,   0,  19,   0,  17,   0,  16, 
  0,  14,   0,  12,   0,  11,   0,   9,   0,   8, 
  0,   6,   0,   5,   0,   3,   0,   2, 
 };
static unsigned char gds40[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
  0,   0,   0, 129, 212, 192, 128,   1,  95, 144, 
128, 117,  48, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73,   0,  72, 
  0,  72,   0,  72,   0,  71,   0,  71,   0,  71, 
  0,  70,   0,  70,   0,  69,   0,  69,   0,  68, 
  0,  67,   0,  67,   0,  66,   0,  65,   0,  65, 
  0,  64,   0,  63,   0,  62,   0,  61,   0,  60, 
  0,  60,   0,  59,   0,  58,   0,  57,   0,  56, 
  0,  55,   0,  54,   0,  52,   0,  51,   0,  50, 
  0,  49,   0,  48,   0,  47,   0,  45,   0,  44, 
  0,  43,   0,  42,   0,  40,   0,  39,   0,  38, 
  0,  36,   0,  35,   0,  33,   0,  32,   0,  30, 
  0,  29,   0,  28,   0,  26,   0,  25,   0,  23, 
  0,  22,   0,  20,   0,  19,   0,  17,   0,  16, 
  0,  14,   0,  12,   0,  11,   0,   9,   0,   8, 
  0,   6,   0,   5,   0,   3,   0,   2, 
 };
static unsigned char gds41[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
129,  95, 144, 128, 117,  48, 128,   0,   0,   0, 
  0, 234,  96, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,   2,   0,   3,   0,   5,   0,   6, 
  0,   8,   0,   9,   0,  11,   0,  12,   0,  14, 
  0,  16,   0,  17,   0,  19,   0,  20,   0,  22, 
  0,  23,   0,  25,   0,  26,   0,  28,   0,  29, 
  0,  30,   0,  32,   0,  33,   0,  35,   0,  36, 
  0,  38,   0,  39,   0,  40,   0,  42,   0,  43, 
  0,  44,   0,  45,   0,  47,   0,  48,   0,  49, 
  0,  50,   0,  51,   0,  52,   0,  54,   0,  55, 
  0,  56,   0,  57,   0,  58,   0,  59,   0,  60, 
  0,  60,   0,  61,   0,  62,   0,  63,   0,  64, 
  0,  65,   0,  65,   0,  66,   0,  67,   0,  67, 
  0,  68,   0,  69,   0,  69,   0,  70,   0,  70, 
  0,  71,   0,  71,   0,  71,   0,  72,   0,  72, 
  0,  72,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73, 
 };
static unsigned char gds42[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
129,  95, 144,   0, 234,  96, 128,   0,   0,   0, 
  2,  73, 240, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,   2,   0,   3,   0,   5,   0,   6, 
  0,   8,   0,   9,   0,  11,   0,  12,   0,  14, 
  0,  16,   0,  17,   0,  19,   0,  20,   0,  22, 
  0,  23,   0,  25,   0,  26,   0,  28,   0,  29, 
  0,  30,   0,  32,   0,  33,   0,  35,   0,  36, 
  0,  38,   0,  39,   0,  40,   0,  42,   0,  43, 
  0,  44,   0,  45,   0,  47,   0,  48,   0,  49, 
  0,  50,   0,  51,   0,  52,   0,  54,   0,  55, 
  0,  56,   0,  57,   0,  58,   0,  59,   0,  60, 
  0,  60,   0,  61,   0,  62,   0,  63,   0,  64, 
  0,  65,   0,  65,   0,  66,   0,  67,   0,  67, 
  0,  68,   0,  69,   0,  69,   0,  70,   0,  70, 
  0,  71,   0,  71,   0,  71,   0,  72,   0,  72, 
  0,  72,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73, 
 };
static unsigned char gds43[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
129,  95, 144,   2,  73, 240, 128,   0,   0,   0, 
129, 212, 192, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,   2,   0,   3,   0,   5,   0,   6, 
  0,   8,   0,   9,   0,  11,   0,  12,   0,  14, 
  0,  16,   0,  17,   0,  19,   0,  20,   0,  22, 
  0,  23,   0,  25,   0,  26,   0,  28,   0,  29, 
  0,  30,   0,  32,   0,  33,   0,  35,   0,  36, 
  0,  38,   0,  39,   0,  40,   0,  42,   0,  43, 
  0,  44,   0,  45,   0,  47,   0,  48,   0,  49, 
  0,  50,   0,  51,   0,  52,   0,  54,   0,  55, 
  0,  56,   0,  57,   0,  58,   0,  59,   0,  60, 
  0,  60,   0,  61,   0,  62,   0,  63,   0,  64, 
  0,  65,   0,  65,   0,  66,   0,  67,   0,  67, 
  0,  68,   0,  69,   0,  69,   0,  70,   0,  70, 
  0,  71,   0,  71,   0,  71,   0,  72,   0,  72, 
  0,  72,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73, 
 };
static unsigned char gds44[178] = {
  0,   0, 178,   0,  33,   0, 255, 255,   0,  73, 
129,  95, 144, 129, 212, 192, 128,   0,   0,   0, 
128, 117,  48, 255, 255,   4, 226,  64,   0,   0, 
  0,   0,   0,   2,   0,   3,   0,   5,   0,   6, 
  0,   8,   0,   9,   0,  11,   0,  12,   0,  14, 
  0,  16,   0,  17,   0,  19,   0,  20,   0,  22, 
  0,  23,   0,  25,   0,  26,   0,  28,   0,  29, 
  0,  30,   0,  32,   0,  33,   0,  35,   0,  36, 
  0,  38,   0,  39,   0,  40,   0,  42,   0,  43, 
  0,  44,   0,  45,   0,  47,   0,  48,   0,  49, 
  0,  50,   0,  51,   0,  52,   0,  54,   0,  55, 
  0,  56,   0,  57,   0,  58,   0,  59,   0,  60, 
  0,  60,   0,  61,   0,  62,   0,  63,   0,  64, 
  0,  65,   0,  65,   0,  66,   0,  67,   0,  67, 
  0,  68,   0,  69,   0,  69,   0,  70,   0,  70, 
  0,  71,   0,  71,   0,  71,   0,  72,   0,  72, 
  0,  72,   0,  73,   0,  73,   0,  73,   0,  73, 
  0,  73,   0,  73,   0,  73,   0,  73, 
 };
static unsigned char gds45[ 32] = {
  0,   0,  32,   0, 255,   0,   1,  32,   0, 145, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   4, 226,   4, 226,   4, 226,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds53[ 42] = {
  0,   0,  42,   0, 255,   1,   0, 117,   0,  51, 
128, 238, 122,   0,   0,   0, 128,   0, 238, 122, 
  0,   0,   0,   0,  87, 228,   0,  64,   4, 221, 
110,   4, 221, 110,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds55[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  87,   0,  71, 
128,  42, 195, 130,  90, 177,   8, 129, 154,  40, 
  3, 224,  48,   3, 224,  48,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds56[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  87,   0,  71, 
  0,  29, 223, 130,   9,  67,   8, 129, 154,  40, 
  1, 240,  24,   1, 240,  24,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds61[124] = {
  0,   0, 124,   0,  33,   0, 255, 255,   0,  46, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
  2, 191,  32,   7, 208,   7, 208,  64,   0,   0, 
  0,   0,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,   1, 
 };
static unsigned char gds62[124] = {
  0,   0, 124,   0,  33,   0, 255, 255,   0,  46, 
  0,   0,   0, 130, 191,  32, 128,   1,  95, 144, 
  0,   0,   0,   7, 208,   7, 208,  64,   0,   0, 
  0,   0,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,   1, 
 };
static unsigned char gds63[124] = {
  0,   0, 124,   0,  33,   0, 255, 255,   0,  46, 
  0,   0,   0, 129,  95, 144, 128,   0,   0,   0, 
  2, 191,  32,   7, 208,   7, 208,  64,   0,   0, 
  0,   0,   0,   1,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91, 
 };
static unsigned char gds64[124] = {
  0,   0, 124,   0,  33,   0, 255, 255,   0,  46, 
129,  95, 144, 130, 191,  32, 128,   0,   0,   0, 
  0,   0,   0,   7, 208,   7, 208,  64,   0,   0, 
  0,   0,   0,   1,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91,   0,  91,   0,  91,   0,  91, 
  0,  91,   0,  91, 
 };
static unsigned char gds85[ 32] = {
  0,   0,  32,   0, 255,   0,   1, 104,   0,  90, 
  0,   1, 244,   0,   1, 244, 128,   1,  93, 156, 
  5, 124,  76,   3, 232,   3, 232,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds86[ 32] = {
  0,   0,  32,   0, 255,   0,   1, 104,   0,  90, 
129,  93, 156,   0,   1, 244, 128, 128,   1, 244, 
  5, 124,  76,   3, 232,   3, 232,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds87[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  81,   0,  62, 
  0,  89,  92, 129, 214, 171,   8, 129, 154,  40, 
  1,  10,  57,   1,  10,  57,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds90[ 32] = {
  0,   0,  32,   0, 255, 201,  50, 102,   0,   1, 
  0,   0, 182, 130,  73, 127, 136,   0,   0,  92, 
  0,   0, 141,   2,  65,   2,  26,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds91[ 32] = {
  0,   0,  32,   0, 255, 202, 100, 203,   0,   1, 
  0,   0, 182, 130,  73, 127, 136,   0,   0, 183, 
  0,   0, 141,   2,  65,   2,  26,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds92[ 32] = {
  0,   0,  32,   0, 255, 201, 105, 191,   0,   3, 
  0,   1, 151, 130,  50, 222, 136,   0,   0, 223, 
  0,   1, 109,   0, 222,   0, 205,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds93[ 32] = {
  0,   0,  32,   0, 255, 202, 126, 229,   0,   5, 
  0,   1, 151, 130,  50, 222, 136,   0,   1, 189, 
  0,   1, 109,   0, 222,   0, 205,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds94[ 32] = {
  0,   0,  32,   0, 255, 201, 191,  20,   0,   1, 
  0,  37, 206, 129, 247,  58, 136,   0,   0, 181, 
  0,   1,  15,   0, 194,   0, 185,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds95[ 32] = {
  0,   0,  32,   0, 255, 202, 126,  39,   0,   1, 
  0,  37, 206, 129, 247,  58, 136,   0,   1, 105, 
  0,   1,  15,   0, 194,   0, 185,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds96[ 32] = {
  0,   0,  32,   0, 255, 201, 162, 158,   0,   1, 
128,  13, 113, 130,  69,  63, 136,   0,   0, 160, 
  0,   1,   5,   1,  77,   1,  52,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds97[ 32] = {
  0,   0,  32,   0, 255, 202,  69,  59,   0,   1, 
128,  13, 113, 130,  69,  63, 136,   0,   1,  63, 
  0,   1,   5,   1,  77,   1,  52,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds98[ 32] = {
  0,   0,  32,   0, 255,   4,   0, 192,   0,  94, 
  1,  89, 222,   0,   0,   0, 128, 129,  89, 222, 
128,   7,  83,   7,  83,   0,  47,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds100[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  83,   0,  83, 
  0,  66, 212, 129, 249,  16,   8, 129, 154,  40, 
  1, 101,  60,   1, 101,  60,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds101[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 113,   0,  91, 
  0,  41,  32, 130,  23, 186,   8, 129, 154,  40, 
  1, 101,  60,   1, 101,  60,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds103[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  56, 
  0,  87, 133, 129, 218,   8,   8, 129, 154,  40, 
  1, 101,  60,   1, 101,  60,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds104[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 147,   0, 110, 
128,   1,  12, 130,  32, 211,   8, 129, 154,  40, 
  1,  98, 131,   1,  98, 131,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds105[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  83,   0,  83, 
  0,  68, 121, 129, 249,  16,   8, 129, 154,  40, 
  1,  98, 131,   1,  98, 131,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds106[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 165,   0, 117, 
  0,  68, 125, 129, 249,  16,   8, 129, 154,  40, 
  0, 177,  61,   0, 177,  61,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds107[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 120,   0,  92, 
  0,  91, 142, 129, 213, 104,   8, 129, 154,  40, 
  0, 177,  61,   0, 177,  61,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds126[ 32] = {
  0,   0,  32,   0, 255,   4,   1, 128,   0, 190, 
  1,  92, 189,   0,   0,   0, 128, 129,  92, 189, 
128,   3, 170,   3, 170,   0,  95,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds170[ 32] = {
  0,   0,  32,   0, 255,   4,   2,   0,   1,   0, 
  1,  93, 119,   0,   0,   0, 128, 129,  93, 119, 
128,   2, 191,   2, 191,   0, 128,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds196[ 32] = {
  0,   0,  32,   0, 255, 201, 179,  79,   0,   1, 
  0,  91, 180, 129, 121, 233, 136,   0,   0, 151, 
  0,   1,  49,   0,  67,   0,  66,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds201[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  65, 
128,  81,  90, 130,  73, 240,   8, 129, 154,  40, 
  5, 208,  72,   5, 208,  72,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds202[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  43, 
  0,  30, 158, 130,  38, 228,   8, 129, 154,  40, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds203[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  45,   0,  39, 
  0,  74, 188, 130, 213, 237,   8, 130,  73, 240, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds204[ 42] = {
  0,   0,  42,   0, 255,   1,   0,  93,   0,  68, 
128,  97, 168,   1, 173, 176, 128,   0, 236, 228, 
129, 170,  73,   0,  78,  32,   0,  64,   2, 113, 
  0,   2, 113,   0,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds205[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  45,   0,  39, 
  0,   2, 104, 129,  75, 168,   8, 128, 234,  96, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds206[ 42] = {
  0,   0,  42,   0, 255,   3,   0,  51,   0,  41, 
  0,  87,  17, 129, 204, 231,   8, 129, 115,  24, 
  1,  61, 119,   1,  61, 119,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds207[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  49,   0,  35, 
  0, 164, 101, 130, 174,  25,   8, 130,  73, 240, 
  1, 116,  18,   1, 116,  18,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds208[ 42] = {
  0,   0,  42,   0, 255,   1,   0,  29,   0,  27, 
  0,  36, 127, 130, 141, 147, 128,   0, 109, 188, 
130,  57, 214,   0,  78,  32,   0,  64,   1,  56, 
128,   1,  56, 128,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds209[ 42] = {
  0,   0,  42,   0, 255,   3,   0, 101,   0,  81, 
  0,  87,  17, 129, 204, 231,   8, 129, 115,  24, 
  0, 158, 187,   0, 158, 187,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds210[ 42] = {
  0,   0,  42,   0, 255,   1,   0,  25,   0,  25, 
  0,  35,  40, 129,  44, 200, 128,   0, 103,  54, 
128, 229,   1,   0,  78,  32,   0,  64,   1,  56, 
128,   1,  56, 128,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds211[ 42] = {
  0,   0,  42,   0, 255,   3,   0,  93,   0,  65, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  1,  61, 119,   1,  61, 119,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds212[ 42] = {
  0,   0,  42,   0, 255,   3,   0, 185,   0, 129, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  0, 158, 187,   0, 158, 187,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds213[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 129,   0,  85, 
  0,  30, 158, 130,  38, 228,   8, 129, 154,  40, 
  1, 116,  18,   1, 116,  18,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds214[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  97,   0,  69, 
  0, 164, 101, 130, 174,  25,   8, 130,  73, 240, 
  0, 186,   9,   0, 186,   9,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds215[ 42] = {
  0,   0,  42,   0, 255,   3,   1, 113,   1,   1, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  0,  79,  94,   0,  79,  94,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds216[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 139,   0, 107, 
  0, 117,  48, 130, 163, 200,   8, 130,  15,  88, 
  0, 175, 200,   0, 175, 200,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds217[ 32] = {
  0,   0,  32,   0, 255,   5,   1,  33,   0, 205, 
  0, 164, 101, 130, 174,  25,   8, 130,  73, 240, 
  0,  62,   3,   0,  62,   3,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds218[ 42] = {
  0,   0,  42,   0, 255,   3,   2, 225,   2,   1, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  0,  39, 175,   0,  39, 175,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds219[ 32] = {
  0,   0,  32,   0, 255,   5,   1, 129,   1, 209, 
  0,  97, 176, 129, 211,   7,  72, 129,  56, 128, 
  0,  99,  56,   0,  99,  56,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds220[ 32] = {
  0,   0,  32,   0, 255,   5,   1,  89,   1,  99, 
128, 144,  25, 131,  92,  34,  72, 131, 247, 160, 
  0,  99,  56,   0,  99,  56,   1,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds221[ 42] = {
  0,   0,  42,   0, 255,   3,   1,  93,   1,  21, 
  0,   3, 232, 130,  56,  92,   8, 129, 161, 248, 
  0, 126, 207,   0, 126, 207,   0,  64,   0, 195, 
 80,   0, 195,  80,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds222[ 42] = {
  0,   0,  42,   0, 255,   3,   0,  59,   0,  47, 
  0,   3, 232, 130,  56,  92,   8, 129, 161, 248, 
  2, 248, 220,   2, 248, 220,   0,  64,   0, 195, 
 80,   0, 195,  80,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds223[ 32] = {
  0,   0,  32,   0, 255,   5,   0, 129,   0, 129, 
128,  81,  90, 130,  73, 240,   8, 129, 154,  40, 
  2, 232,  36,   2, 232,  36,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds224[ 32] = {
  0,   0,  32,   0, 255,   5,   0,  65,   0,  65, 
  0,  81,  90,   1, 212, 192,   8, 129, 154,  40, 
  5, 208,  72,   5, 208,  72,   0,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds225[ 42] = {
  0,   0,  42,   0, 255,   1,   0, 185,   0, 135, 
128,  97, 168, 131, 208, 144, 128,   0, 236, 224, 
131, 211, 247,   0,  78,  32,   0,  64,   1,  56, 
128,   1,  56, 128,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds226[ 42] = {
  0,   0,  42,   0, 255,   3,   2, 225,   2,   1, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  0,  39, 175,   0,  39, 175,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds227[ 42] = {
  0,   0,  42,   0, 255,   3,   5, 193,   4,   1, 
  0,  47, 158, 130,   9,  83,   8, 129, 115,  24, 
  0,  19, 215,   0,  19, 215,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds228[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 144,   0,  73, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   9, 196,   9, 196,   9, 196,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds229[ 32] = {
  0,   0,  32,   0, 255,   0,   1, 104,   0, 181, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   3, 232,   3, 232,   3, 232,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds230[ 32] = {
  0,   0,  32,   0, 255,   0,   2, 208,   1, 105, 
  1,  95, 144,   0,   0,   0, 128, 129,  95, 144, 
128,   1, 244,   1, 244,   1, 244,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds231[ 32] = {
  0,   0,  32,   0, 255,   0,   2, 208,   0, 181, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
128,   1, 244,   1, 244,   1, 244,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds232[ 32] = {
  0,   0,  32,   0, 255,   0,   1, 104,   0,  91, 
  0,   0,   0,   0,   0,   0, 128,   1,  95, 144, 
128,   3, 232,   3, 232,   3, 232,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds233[ 32] = {
  0,   0,  32,   0, 255,   0,   1,  32,   0, 157, 
  1,  48, 176,   0,   0,   0, 128, 129,  48, 176, 
128,   4, 226,   3, 232,   4, 226,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds234[ 32] = {
  0,   0,  32,   0, 255,   0,   0, 133,   0, 121, 
  0,  58, 152, 129, 126, 208, 128, 128, 175, 200, 
128, 253, 232,   0, 250,   0, 250,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds235[ 32] = {
  0,   0,  32,   0, 255,   0,   2, 208,   1, 104, 
  1,  94, 150,   0,   0, 250,  72, 129,  94, 150, 
128,   0, 250, 255, 255, 255, 255,  64,   0,   0, 
  0,   0, 
 };
static unsigned char gds236[ 42] = {
  0,   0,  42,   0, 255,   3,   0, 151,   0, 113, 
  0,  63, 153,   3, 145, 134,   8, 129, 115,  24, 
  0, 158, 187,   0, 158, 187,   0,  64,   0,  97, 
168,   0,  97, 168,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
static unsigned char gds237[ 42] = {
  0,   0,  42,   0, 255,   3,   0,  54,   0,  47, 
  0,  63,  73,   4,  92,  24,   8, 129, 161, 248, 
  0, 126, 207,   0, 126, 207,   0,  64,   0, 195, 
 80,   0, 195,  80,   0,   0,   0,   0,   0,   0, 
  0,   0, 
 };
  
 unsigned char *std_ncep_gds[256] = {
  NULL, /*   0 */
  gds1,
  gds2,
  gds3,
  gds4,
  gds5,
  gds6,
  NULL, /*   7 */
  gds8,
  NULL, /*   9 */
  NULL, /*  10 */
  NULL, /*  11 */
  NULL, /*  12 */
  NULL, /*  13 */
  NULL, /*  14 */
  NULL, /*  15 */
  NULL, /*  16 */
  NULL, /*  17 */
  NULL, /*  18 */
  NULL, /*  19 */
  NULL, /*  20 */
  gds21,
  gds22,
  gds23,
  gds24,
  gds25,
  gds26,
  gds27,
  gds28,
  gds29,
  gds30,
  NULL, /*  31 */
  NULL, /*  32 */
  gds33,
  gds34,
  NULL, /*  35 */
  NULL, /*  36 */
  gds37,
  gds38,
  gds39,
  gds40,
  gds41,
  gds42,
  gds43,
  gds44,
  gds45,
  NULL, /*  46 */
  NULL, /*  47 */
  NULL, /*  48 */
  NULL, /*  49 */
  NULL, /*  50 */
  NULL, /*  51 */
  NULL, /*  52 */
  gds53,
  NULL, /*  54 */
  gds55,
  gds56,
  NULL, /*  57 */
  NULL, /*  58 */
  NULL, /*  59 */
  NULL, /*  60 */
  gds61,
  gds62,
  gds63,
  gds64,
  NULL, /*  65 */
  NULL, /*  66 */
  NULL, /*  67 */
  NULL, /*  68 */
  NULL, /*  69 */
  NULL, /*  70 */
  NULL, /*  71 */
  NULL, /*  72 */
  NULL, /*  73 */
  NULL, /*  74 */
  NULL, /*  75 */
  NULL, /*  76 */
  NULL, /*  77 */
  NULL, /*  78 */
  NULL, /*  79 */
  NULL, /*  80 */
  NULL, /*  81 */
  NULL, /*  82 */
  NULL, /*  83 */
  NULL, /*  84 */
  gds85,
  gds86,
  gds87,
  NULL, /*  88 */
  NULL, /*  89 */
  gds90,
  gds91,
  gds92,
  gds93,
  gds94,
  gds95,
  gds96,
  gds97,
  gds98,
  NULL, /*  99 */
  gds100,
  gds101,
  NULL, /* 102 */
  gds103,
  gds104,
  gds105,
  gds106,
  gds107,
  NULL, /* 108 */
  NULL, /* 109 */
  NULL, /* 110 */
  NULL, /* 111 */
  NULL, /* 112 */
  NULL, /* 113 */
  NULL, /* 114 */
  NULL, /* 115 */
  NULL, /* 116 */
  NULL, /* 117 */
  NULL, /* 118 */
  NULL, /* 119 */
  NULL, /* 120 */
  NULL, /* 121 */
  NULL, /* 122 */
  NULL, /* 123 */
  NULL, /* 124 */
  NULL, /* 125 */
  gds126,
  NULL, /* 127 */
  NULL, /* 128 */
  NULL, /* 129 */
  NULL, /* 130 */
  NULL, /* 131 */
  NULL, /* 132 */
  NULL, /* 133 */
  NULL, /* 134 */
  NULL, /* 135 */
  NULL, /* 136 */
  NULL, /* 137 */
  NULL, /* 138 */
  NULL, /* 139 */
  NULL, /* 140 */
  NULL, /* 141 */
  NULL, /* 142 */
  NULL, /* 143 */
  NULL, /* 144 */
  NULL, /* 145 */
  NULL, /* 146 */
  NULL, /* 147 */
  NULL, /* 148 */
  NULL, /* 149 */
  NULL, /* 150 */
  NULL, /* 151 */
  NULL, /* 152 */
  NULL, /* 153 */
  NULL, /* 154 */
  NULL, /* 155 */
  NULL, /* 156 */
  NULL, /* 157 */
  NULL, /* 158 */
  NULL, /* 159 */
  NULL, /* 160 */
  NULL, /* 161 */
  NULL, /* 162 */
  NULL, /* 163 */
  NULL, /* 164 */
  NULL, /* 165 */
  NULL, /* 166 */
  NULL, /* 167 */
  NULL, /* 168 */
  NULL, /* 169 */
  gds170,
  NULL, /* 171 */
  NULL, /* 172 */
  NULL, /* 173 */
  NULL, /* 174 */
  NULL, /* 175 */
  NULL, /* 176 */
  NULL, /* 177 */
  NULL, /* 178 */
  NULL, /* 179 */
  NULL, /* 180 */
  NULL, /* 181 */
  NULL, /* 182 */
  NULL, /* 183 */
  NULL, /* 184 */
  NULL, /* 185 */
  NULL, /* 186 */
  NULL, /* 187 */
  NULL, /* 188 */
  NULL, /* 189 */
  NULL, /* 190 */
  NULL, /* 191 */
  NULL, /* 192 */
  NULL, /* 193 */
  NULL, /* 194 */
  NULL, /* 195 */
  gds196,
  NULL, /* 197 */
  NULL, /* 198 */
  NULL, /* 199 */
  NULL, /* 200 */
  gds201,
  gds202,
  gds203,
  gds204,
  gds205,
  gds206,
  gds207,
  gds208,
  gds209,
  gds210,
  gds211,
  gds212,
  gds213,
  gds214,
  gds215,
  gds216,
  gds217,
  gds218,
  gds219,
  gds220,
  gds221,
  gds222,
  gds223,
  gds224,
  gds225,
  gds226,
  gds227,
  gds228,
  gds229,
  gds230,
  gds231,
  gds232,
  gds233,
  gds234,
  gds235,
  gds236,
  gds237,
  NULL, /* 238 */
  NULL, /* 239 */
  NULL, /* 240 */
  NULL, /* 241 */
  NULL, /* 242 */
  NULL, /* 243 */
  NULL, /* 244 */
  NULL, /* 245 */
  NULL, /* 246 */
  NULL, /* 247 */
  NULL, /* 248 */
  NULL, /* 249 */
  NULL, /* 250 */
  NULL, /* 251 */
  NULL, /* 252 */
  NULL, /* 253 */
  NULL, /* 254 */
  NULL, /* 255 */
 };
unsigned char *NCEP_GDS(unsigned char *pds, int grid_type) {
    if (std_ncep_gds[grid_type] == NULL) {
        set_PDSGridType(pds, grid_type);
        clr_HasGDS(pds);
        return NULL;
    }
    set_PDSGridType(pds, grid_type);
    set_HasGDS(pds);
    return (cpGRIBsec(std_ncep_gds[grid_type]));
}
