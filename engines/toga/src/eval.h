
// eval.h

#ifndef EVAL_H
#define EVAL_H

// includes

#include "board.h"
#include "util.h"

// functions

extern void eval_init ();

extern int  eval      (const board_t * board, int alpha, int beta);

#endif // !defined EVAL_H

// end of eval.h

