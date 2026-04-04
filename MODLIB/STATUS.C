#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libcob.h>


cob_global *cob_glob_ptr;

struct Status {
  char bg[11];
  char fg[11];
};

struct Status status[] = {
  { "d7827eff  ", "faf4edff  " }, // NORMAL
  { "56949fff  ", "faf4edff  " }, // INSERT
  { "907aa9ff  ", "faf4edff  " }, // VISUAL
  { "b4637aff  ", "faf4edff  " }, // COMMAND
  { "286983ff  ", "faf4edff  " }  // REPLACE
};

struct data {
  long status;
  char sa[16 + 4 + sizeof(long) + sizeof(void*)];
  char sb[16 + 4 + sizeof(long) + sizeof(void*)];
  char bg[10];
  char tmp[10];
  short len;
};

extern "C" {
COB_EXT_IMPORT int		MOD_SEPARATOR_INIT (char *);
COB_EXT_IMPORT int		OUTPUT_FMT ();
};
long global_status = 0;

char *body;
char *part;
char *fg;
char *bg;
char *bg_last;
char *fg_last;

extern "C" int
MOD_STATUS (struct data *data)
{
  void *params[1];

  data->status = global_status;

  memcpy(data->bg, bg, 10);
  memcpy(bg, status[data->status].bg, 10);
  params[0] = data->sa;
  cob_call("MOD_SEPARATOR_L", 1, params);
  memcpy(bg, status[data->status].bg, 10);
  memcpy(fg, status[data->status].fg, 10);
  memcpy(fg_last, status[data->status].fg, 10);
  memcpy(bg_last, status[data->status].bg, 10);
  *part = 5;
  OUTPUT_FMT();
  printf(" %.*s ", data->len, body);
  *part = 6;
  OUTPUT_FMT();
  *part = 3;
  memcpy(bg, data->bg, 10);
  params[0] = data->sb;
  cob_call("MOD_SEPARATOR_R", 1, params);

  return 0;
}

extern "C" void
MOD_STATUS_CHANGE (int to)
{
  global_status = to;
}

extern "C" int
MOD_STATUS_INIT (struct data *data)
{
  char a, b;
  global_status = 0;
  memset(data, 0, sizeof(struct data));
  body = (char*)cob_external_addr ("L_BODY", 42);
  part = (char *)cob_external_addr ("L_PART", 1);
  bg = (char *)cob_external_addr ("L_COLOR_BG", 10);
  fg = (char *)cob_external_addr ("L_COLOR_FG", 10);
  bg_last = (char *)cob_external_addr ("L_COLOR_BG_LAST", 10);
  fg_last = (char *)cob_external_addr ("L_COLOR_FG_LAST", 10);
  a = body[0];
  b = body[42];
  body[0] = '<';
  body[42] = b;
  MOD_SEPARATOR_INIT(data->sa);
  body[0] = '>';
  body[42] = b;
  MOD_SEPARATOR_INIT(data->sb);
  body[0] = a;
  body[42] = ' ';

  char *c;
  for (c = body; *c != ' '; ++c)
    ;
  data->len = c - body;
  return 3;
}
