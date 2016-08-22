#include "phalanx.h"

typedef struct { unsigned f, t; } killentry;
killentry RK[H9][H9]; /* reaction killer */

unsigned HK[H9][H9]; /* history killer table */
unsigned Maxhist = 1;


void init_killers(void)
{
memset( RK, 0, H9*H9*sizeof(killentry) );
memset( HK, 0, H9*H9*sizeof(unsigned) );
Maxhist = 1;
}



void write_killer( int from, int to )
{

if( B[to] == 0 )
{
	RK[G[Counter-1].m.from][G[Counter-1].m.to].f = from;
	RK[G[Counter-1].m.from][G[Counter-1].m.to].t = to;

	HK[from][to] += Depth/10 + 1;
	if( HK[from][to] > Maxhist )
	{
		Maxhist = HK[from][to];
		if( Maxhist > 4000 )
		{
			int f,t;
			Maxhist /= 2;
			for( f=A1; f!=H9; f++ )
			for( t=A1; t!=H9; t++ )
				HK[f][t] /= 2;
		}
	}
}

}



/*
 * We are in a cut node, but the 1st killer was not successful.
 * Let's lower the history killer values of the unsuccessful ones
 * to magnify the importance of the successful one.
 */
void slash_killers( tmove *m, int n )
{
	int i;
	int findnewmax=0;

	for( i=0; i!=n; i++ )
	{
		if( HK[m[i].from][m[i].to] == Maxhist ) findnewmax = 1;
		HK[m[i].from][m[i].to] /= 2;
	}

	if( findnewmax )
	{
		int f,t;
		Maxhist /= 2;
		for( f=A1; f!=H9; f++ ) for( t=A1; t!=H9; t++ )
			if( HK[f][t] > Maxhist ) Maxhist = HK[f][t];
	}
}



void add_killer( tmove *m, int n, thashentry *ht )
{

int i, f=0, t=0;
tmove *mpv = &PV[0][Ply];
tmove *mlv = &PV[Ply][Ply];

if( Depth > 0 )
{
	f = RK[G[Counter-1].m.from][G[Counter-1].m.to].f;
	t = RK[G[Counter-1].m.from][G[Counter-1].m.to].t;
}

for( i=0; i!=n; i++ )
{
	register tmove *m1 = m+i;

	if( FollowPV )
	{
	  if(
		( mpv->special && mpv->special==m1->special )
		||
		( !mpv->special && m1->from == mpv->from
		&& m1->to == mpv->to
		&& m1->in2a == mpv->in2a )
	   )
		m1->value = CHECKMATE;
	}
	else
	{
	  if( m1->from == mlv->from
	    && m1->to == mlv->to
	    && ( mlv->in2 == 0 || m1->in2 == mlv->in2 )
	    && m1->in2a == mlv->in2a ) m1->value += 350;

	  if( ht != NULL ) if( ht->move != 0 )
	  if( ht->move == smove(m1) ) m1->value = CHECKMATE;
	}

	if( m1->value != CHECKMATE )
	{
		/* mopv - moving piece value */
		int mopv = Values[ m1->in2a >> 4 ];

		if( m1->in2 ) /* capture */
		{
			m1->value += Values[ m1->in2>>4 ];

			/* capture of last moved piece */
			if( m1->to == G[Counter-1].m.to ) m1->value += 150;

			if( Color==WHITE )
			{
			  if( P[m1->to]&0xFF00 )
			  m1->value -= ( mopv / 4 );
			  else m1->value += 150;
			}
			else
			{
			  if( P[m1->to]&0x00FF )
			  m1->value -= ( mopv / 4 );
			  else m1->value += 150;
			}

			if( m1->value < 30 ) m1->value = 30;

			if( Depth > 200 )
			{
			  m1->value += see( B, m1->from, m1->to );
			  if(m1->value<0) m1->value=20;
			}
		}
		/* non captures - look at the power tables */
		else if( mopv>P_VALUE )
		{
		  if( Color==WHITE )
		  {
			/* leaving attacked square */
			if(P[m1->from]&0xFF00) m1->value += mopv/20;
			/* going to attacked square */
			if(P[m1->to]&0xFF00) m1->value -= mopv/15;
		  }
		  else
		  {
			if(P[m1->from]&0x00FF) m1->value += mopv/20;
			if(P[m1->to]&0x00FF) m1->value -= mopv/15;
		  }
		}

		if( m1->in1 != m1->in2a ) /* pawn promotion */
			m1->value += Values[ m1->in2a>>4 ] - P_VALUE;

		if( Depth > 0 )
		{
			if( m1->from == f && m1->to == t )
				m1->value += max(Depth,50);
			if( HK[ m1->from ][ m1->to ] )
			m1->value +=
			 1 + HK[ m1->from ][ m1->to ] * 500 / Maxhist;
		}

	}
}

}

