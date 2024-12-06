static unsigned int altTabN = 3;  // number of alt-tab windows to show at once

static void
altTabStart(const Arg *arg) {
	if (altTabN > 0) {
		unsigned int i, nwins = 0;
		for (Monitor *m = mons; m; m = m->next)
			for (Client *c = m->clients; c; c = c->next)
				if (ISVISIBLE(c)) ++nwins;
		Window *wins = malloc(sizeof(Window) * nwins);
		nwins = 0;
		for (Monitor *m = mons; m; m = m->next)
			for (Client *c = m->clients; c; c = c->next)
				if (ISVISIBLE(c)) wins[nwins++] = c->win;
		if (!nwins) return;
		static XWindowAttributes wa;
		XGetWindowAttributes(dpy, wins[0], &wa);
		int x = wa.x, y = wa.y + wa.height + spacing;
		int mw = MIN(wa.width, altTabN * wa.width + (altTabN - 1) * spacing);
		int w = MIN(wa.width, mw / altTabN - spacing);
		int h = w * 3/4;
		Window previewwin = XCreateSimpleWindow(dpy, root,
			x, y, mw, h + spacing * 2, 0,
			scheme[SchemeNorm][ColFg].pixel,
			scheme[SchemeNorm][ColBg].pixel);
		XSelectInput(dpy, previewwin, ExposureMask);
		XMapRaised(dpy, previewwin);
		altTabWin = previewwin;
		altTabX = x;
		altTabY = y;
		altTabW = w;
		altTabH = h;
		altTabWins = wins;
		altTabNWins = nwins;
		altTabPos = arg->i ? nwins - 1 : 1;
		altTabDrawPreview();
		grabkeys();
	}
}

static void
altTabEnd(const Arg *arg) {
	if (altTabN > 0) {
		free(altTabWins);
		altTabWins = NULL;
		XDestroyWindow(dpy, altTabWin);
		altTabWin = 0;
		grabkeys();
		focus(wintoclient(altTabWins[altTabPos]));
		restack(selmon);
	}
}

static void
altTabTick(const Arg *arg) {
	if (altTabN > 0) {
		altTabPos += arg->i;
		if (altTabPos >= altTabNWins)
			altTabPos = 0;
		else if (altTabPos < 0)
			altTabPos = altTabNWins - 1;
		altTabDrawPreview();
	}
}

static void
altTabDrawPreview(void) {
	if (altTabN > 0) {
		int x = spacing;
		Client *c;
		XSetWindowAttributes wa = {
			.background_pixel = scheme[SchemeNorm][ColBg].pixel,
		};
		for (int i = 0; i < MIN(altTabN, altTabNWins); i++) {
			int idx = (altTabPos + i) % altTabNWins;
			c = wintoclient(altTabWins[idx]);
			if (!c) continue;
			Window win = XCreateSimpleWindow(dpy, altTabWin,
				x, spacing, altTabW, altTabH, 1,
				scheme[SchemeSel][ColBorder].pixel,
				scheme[SchemeNorm][ColBg].pixel);
			XChangeWindowAttributes(dpy, win, CWBackPixel, &wa);
			XReparentWindow(dpy, c->win, win, 0, 0);
			XMoveResizeWindow(dpy, c->win, 0, 0, altTabW, altTabH);
			XMapRaised(dpy, win);
			x += altTabW + spacing;
		}
	}
}
