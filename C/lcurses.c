#include <curses.h>
//#include "ncurses_wrp.h"

int getmax_y (WINDOW * w)
{
//	return ((w)?((w)->_maxy + 1):(-1));
	return getmaxy(w);
};

int getmax_x (WINDOW * w)
{
//	return (((w)?((w)->_maxx + 1):(-1)));
	return getmaxx(w);
};

int _color_pair (short color)
{
	if (has_colors()) 
		return COLOR_PAIR(color);
	return -1;
};

WINDOW * _new_win (int lines, int cols, int y, int x)
{
	WINDOW * w;

	w = newwin(lines, cols, y, x);
//	_box(w);
	box(w,0,0);
	wrefresh(w);
	return w;
};

int _box (WINDOW *w, int verch, int horch)
{
	box(w, (chtype) verch, (chtype) horch);
//	box(w, '*','*');
	wrefresh(w);
	return 1;
//	return wborder(w, (chtype) verch, (chtype) verch, (chtype) horch, (chtype) horch, 0, 0, 0, 0);
}

int _wborder (WINDOW *w, int ls, int rs, int ts, int bs, int tl, int tr, int bl, int br) {
	wborder(w, (chtype) ls, (chtype) rs, (chtype) ts, (chtype) bs, (chtype) tl,
		(chtype) tr, (chtype) bl, (chtype) br);
	wrefresh(w);
	return 1;
};
