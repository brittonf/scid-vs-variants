/****************************
 * easy levels
 ******************/

#include "phalanx.h"



void blunder( tmove *m, int *n )
{
int i;
int initp = Flag.easy * 4 + 150;

/* quick look (small Depth) makes blunders */
initp -= Depth/5;

/* full board means more blunders */
initp += (G[Counter].mtrl+G[Counter].xmtrl) / 200;

if(Counter>2)
for( i=(*n)-1; i>=1 && (*n)>4; i-- )
{
	/* compute the probability this move is not seen */
	int p = initp;

	/* missing PV moves is unlikely */
	if( m[i].from==PV[0][Ply].from && m[i].to==PV[0][Ply].to )
	p -= 200;

	if( m[i].from==PV[Ply-1][Ply].from && m[i].to==PV[Ply-1][Ply].to )
	p -= 200;

	/* target square far from the center is more difficult to spot */
	p += 2*dist[120*E4+m[i].to].taxi + dist[120*E4+m[i].to].max +
	   + 2*dist[120*D5+m[i].to].taxi + dist[120*D5+m[i].to].max
	/* so is target square far from previous opponents move */
	   + 2*dist[120*G[Counter-1].m.to+m[i].to].taxi;

	if( m[i].in2 ) /* captures - we tend to see this */
	{
		/* the more valuable the captured piece,
		 * the more likely we see the move. */
		p -= 20 + Values[ m[i].in2 >> 4 ] / 20;

		/* capture of last moved piece is spotted
		 * + extra bonus for recapture */
		if( m[i].to == G[Counter-1].m.to )
		{
			p -= 20 + Values[ m[i].in2 >> 4 ] / 30;
			if( G[Counter-1].m.in2 ) p -= 40; /* recapture */
		}

		/* very short captures */
		switch( dist[120*m[i].from+m[i].to].max )
		{
			case 0: case 1: p -= 250; break;
	  		case 2: p -= 150; break;
	  		case 3: p -= 50; break;
		}
	}
	else /* noncaptures - prune or reduce with power table info */
	{
		int pp=0;
		unsigned short pf = P[m[i].from], pt = P[m[i].to];
		unsigned short xpm, xbnm, xrm, xqm; /* enemy power masks */
		int mpv = Values[m[i].in1 >> 4]; /* moving piece value */

		if( Color == WHITE )
		{ xpm=BPM; xbnm=(BNM|BBM); xrm=BRM; xqm=BQM; }
		else
		{ xpm=WPM; xbnm=(WNM|WBM); xrm=WRM; xqm=WQM; }

		/* leaving an attacked square - reduce probability of
		 * the move being skipped */
		if( pf&xpm ) pp -= (5 + mpv - P_VALUE)/10;
		if( pf&xbnm && mpv >= N_VALUE ) pp -= (5 + mpv - N_VALUE)/10;
		if( pf&xrm && mpv >= R_VALUE ) pp -= (5 + mpv - R_VALUE)/10;
		if( pf&(xqm|xrm|xbnm|xpm) ) pp -= mpv/100;

		/* going to an attacked square - raise probability
		 * the move is skipped */
		if( pt&xpm ) pp += (10 + mpv - P_VALUE)/10;
		if( pt&xbnm && mpv >= N_VALUE ) pp += (10 + mpv - N_VALUE)/10;
		if( pt&xrm && mpv >= R_VALUE ) pp += (10 + mpv - R_VALUE)/10;
		if( pt&(xqm|xrm|xbnm|xpm) ) pp += mpv/50;

		p += pp;

		/* careless reductions to achieve depth at these low nps */
		if( pp>=0 ) m[i].dch += 50 + min( 2*pp, 90 );
	}

	/* We focus on the piece that moved 2 plies ago and see the
	 * moves of the same piece */
	if( m[i].from == G[Counter-2].m.to ) p -= 55;

	/* underpromotions? too precise! */
	if( m[i].in1 != m[i].in2a  &&  piece(m[i].in2a) != QUEEN )
	p += 15;
	else
	p -= 5;

	/* dont see long moves, especially diagonal ones */
	p += dist[120*m[i].from+m[i].to].taxi * 3;

	/* dont see some knight moves */
	if( piece(m[i].in1) == KNIGHT )
	p += 10;

	/* going backward?  (white)Bf6xc3 is much more difficult
	 * to see than (white)Bc3xf6 ***/
	if( Color==WHITE )
		p += 4 * ( m[i].to/10 - m[i].from/10 );
	else
		p += 4 * ( m[i].from/10 - m[i].to/10 );

	if( rand()%1000 < p )
	{ m[i] = m[(*n)-1]; (*n)--; }
}
}


