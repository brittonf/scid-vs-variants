
/*
 *   Alphabeta negamax search
 */


#include "phalanx.h"

#define update_PV(move, ply)				\
{							\
    register int jj;					\
    PV[ply][ply] = move;				\
    for (jj = ply + 1; PV[ply + 1][jj].from; jj++)	\
	PV[ply][jj] = PV[ply + 1][jj];		\
    PV[ply][jj].from = 0; /* end of copied line */	\
}



int sortkey( const void *a, const void *b )
{ return ( ((tmove*)b)->value - ((tmove*)a)->value ); }



int search(
	tmove *m, /* move list */
	int n,    /* number of moves */
	int Alpha, int Beta
)
{

int i;
int maxi = -1;
int result;

if( Abort && ! NoAbort ) return 0;

/*** internal iterative deepening ***/
#define IID
#ifdef IID
if( Depth > 200 && Beta-Alpha>1 )
{
	int max=0;
	for( i=1; i!=n; i++ ) if( m[i].value > m[max].value ) max=i;
	if( m[max].value != CHECKMATE )
	{
		int depth=Depth;
		Depth -= 200;
		search( m, n, Alpha, Beta );
		Depth = depth;
#undef DEBUGIID
#ifdef DEBUGIID
if(Depth>400)
{
max=0; printboard(NULL);
for(i=0;i!=n;i++) if(m[i].value>m[max].value) max=i;
printm(m[max],NULL); getchar();
}
#endif
	}
}
#endif

for( i=0; i!=n; i++ )
{
	int max;

	{
		int j;
		max = i;
		for( j=i+1; j!=n; j++ ) if( m[j].value > m[max].value ) max=j;
	}

	do_move(m+max);

	S[Ply].check = checktest(Color);

	if( i == 0 || Depth <= 0 )
	result = - evaluate( -Beta, -Alpha );
	else
	{
#define	LMRLMP /* late move reductions and pruning */
#ifdef	LMRLMP
		if(    Depth > 0
		    && !S[Ply-1].check && !S[Ply].check /* checks */
		    && i > 2
		    && m[max].in2 == 0 /* no captures reduced */
		    && m[max].in1 == m[max].in2a /* no promotions */
		    && m[max].dch >= 100 /* no extended moves */
		  )
		{
			int olddepth=Depth;
			Depth -= Depth/max(6,(33-i))+i+100;

			if( m[max].value <= 0 ) Depth -= 100;

			if( Depth>0 ) /* reduced search */
			{
				result = -evaluate( -Alpha-1, -Alpha );
				Depth = olddepth;
				if( result <= Alpha ) goto skipsearch;
			}
			else /* prune */
			{
				PV[Ply][Ply].from=0;
				Depth=olddepth;
				result=Alpha;
				goto skipsearch;
			}
			Depth = olddepth;
		}
#endif	/* LMRLMP */

		result = - evaluate( -Alpha-1, -Alpha );
		if( result>Alpha && result<Beta )
		result = - evaluate( -Beta, -Alpha-1 );

		skipsearch:;
	}

	undo_move(m+max);

	FollowPV = 0;

	if( result > Alpha )
	{
/*
{ int i; for(i=Counter-Ply;i!=Counter;i++) printm(G[i].m,NULL);
  printf("[%i,%i] %i",Alpha,Beta,result); getchar(); }
*/
		update_PV( m[max], Ply );
		Alpha = result;
		if(Alpha>=Beta)
		{
			if( i>0 ) slash_killers( m, i );
			m[max].value = (CHECKMATE-5000)+Depth;
			return Alpha;
		}
		maxi = i;
	}
	else if( i==0 && Depth>0 ) update_PV( m[max], Ply );
	/* The line above helps to maintain a nice long PV in those rare
	 * cases, where negascout is not able to confirm the fail-high
	 * and then truncates the PV. */

	{ tmove mo=m[max]; m[max] = m[i]; m[i] = mo; }
}

if( maxi != -1 ) m[maxi].value = (CHECKMATE-5000)+Depth;

return Alpha;

}



int EasyMove;
int bgs;         /* best group size */

/**
*** Sorting root moves and detecting possible `Easy Move'.
**/
int sort_root_moves( tmove *m, int n )
{
	int i;
	int best = -CHECKMATE;
	int secondbest = -CHECKMATE;
	int result;

	bgs=0;

	FollowPV = 0;
	PV[0][0] = m[0];

	EasyMove = 0;
	Depth = 100;

	for( i=0; i!=n; i++ )
	{
		do_move(m+i);

		result = - evaluate( -CHECKMATE, CHECKMATE );

		m[i].value = result/4;
		if( m[i].in2 )
		{ m[i].value += Values[ m[i].in2>>4 ]; bgs++; }
		else if( m[i].special )
		{ m[i].value += 100; bgs++; }
		if( checktest(Color) )
		{ m[i].value += 150; bgs++; }

		undo_move(m+i);

		if( result > best )
		{
			tmove mm=m[0]; m[0]=m[i]; m[i]=mm;
			secondbest = best; best = result;
			update_PV( m[0], 0 );
		}
		else if( result > secondbest ) secondbest = result;
	}

	qsort( m+1, n-1, sizeof(tmove), sortkey );

	if( n == 1 ) EasyMove = 3;
	else
	if( abs(best) > CHECKMATE - 100 ) EasyMove = 2;
	else
	if( best - secondbest > 70 ) EasyMove = 1;

	if( Flag.post && EasyMove!=0 && Flag.xboard<2 )
	{
		printf( "    -> easy move      (%i)  ", EasyMove );
		printm(m[0],NULL); puts("               ");
	}

	return best;
}



long LastTurn;
int Turns;
tmove root_search( void )
{

tmove m[256];
int rr[256];
int n, i;
int Alpha, Beta;
int r;

int Nod[256];

Abort = 0; NoAbort = 1;

generate_legal_moves( m, &n, checktest(Color) );

if( Flag.log != NULL )
{
	char pb[2048];

	if( Counter>0 )
	{
		fprintf(Flag.log,"\n");
		if( Flag.ponder == 2 )
			fprintf(Flag.log,"  pondering move ");
		else
			fprintf(Flag.log,"  opponent plays ");
		printm( G[Counter-1].m, pb );
		fprintf(Flag.log,"%s\n",pb);
	}

	printboard(pb);
	fprintf(Flag.log,"%s\n",pb);
}

if( Flag.book )
if( Counter < 20 || Bookout < 4 || Flag.analyze )
{
	int b;

	if( Flag.easy && Counter>4
	&& rand()%5000 < Counter*(50+Flag.easy) )
		b = -1;
	else
		b = bookmove( m, n );

	if( b != -1 )
	{
		if( Flag.easy )
			usleep( (rand()%10000) * (50+2*Flag.easy) );
		Bookout = 0;
		PV[0][1].from = 0;   /* dont start pondering */
		m[b].value = 0;
		do_move(m+b);
		return m[b];
	} else Bookout ++;
}

init_killers();

if( n == 0 ) NoAbort = 0;
else
{
	int learndepth = 0;
	int learnalpha = 0;

	Age ++;
	Nodes = 0;

	A_n = n; A_m = m; A_i = 0;

	PV[0][0].from = 0;

	l_startsearch();

	Ply = 0;

	if(!Flag.easy)
		LastIter = Alpha = sort_root_moves( m, n );
	else
	{
		/* Easy levels: Let's shuffle the moves to add randomness. */
		int i;
		for( i=1; i<n; i++ )
		{
			tmove mm;
			int ii = rand()%(i+1);
			mm=m[i]; m[i]=m[ii]; m[ii]=mm;
		}

		LastIter = Alpha = -CHECKMATE;
	}

	LastTurn = ptime();

	if( EasyMove == 3 && ! Flag.analyze ) { do_move(m); return m[0]; }

	/* randomize root moves */
	if( Flag.random )
	for( i=0; i!=n; i++ )
	{
		rr[i] = rand()%(Flag.random+1) - Flag.random/2;
/*
		printf("%4i:",rr[i]); printm(m[i],NULL);
		if(i%5==4) printf("\n");
*/
	}
	else for( i=0; i!=n; i++ ) rr[i]=0;

	FollowPV = 1;
	NoAbort = 0;
	if(Flag.nps<=1000) Depth=190; else Depth = 290;
	Ply = 0;
	A_d = Depth/100;

	memset( Nod, 0, 256*sizeof(int) );

	if( !Flag.polling ) signal(SIGINT,interrupt);

	Turns=n;

	while(   ( Flag.ponder==2 || l_iterate() || Flag.analyze )
	      && !Abort && Depth < MAXPLY*100      )
	{
		A_d++;
		Turns=0;

		Beta = CHECKMATE;
		Alpha = -CHECKMATE;

		if( Flag.analyze && Flag.xboard!=1 ) { A_i=0; verboseline(); }

		for( i=0; i!=n; i++ )
		{
			int64 lastnodes = Nodes;
			A_i = i;

			if( i == 0 )
			{
				do_move(m+i);
				r = - evaluate( -Beta+rr[i], -Alpha+rr[i] )
				    + rr[i];
				undo_move(m+i);

				if(!Abort)
				{
					m[i].value = Alpha = r;
					update_PV( m[i], 0 );
		if( Flag.post ) infoline(1,NULL);
				}
			}
			else
			{
				do_move(m+i);
				r = - evaluate( -Alpha-1+rr[i], -Alpha+rr[i] )+rr[i];
				undo_move(m+i);

				if(!Abort) m[i].value = r;
				if( m[i].value > Alpha && !Abort ) /* TURN */
				{
				      Turns++;
				      if(i>bgs) bgs++;
				      update_PV( m[i], 0 );
				      LastTurn = ptime();
				      if( EasyMove != 0 )
				      {
				        EasyMove = 0;
				        if( Flag.post && Flag.xboard<2 )
				        printf(
"    -> easy move off                                    \n" );
				      }
				      if( Flag.post ) infoline(2,NULL);
				      do_move(m+i);
				      r = - evaluate( -Beta+rr[i], -Alpha+rr[i] )+rr[i];
				      undo_move(m+i);
				      if(!Abort)
				      {
					m[i].value = Alpha = r;
				      update_PV( m[i], 0 );
				      if( Flag.post ) infoline(1,NULL);
				      }

					{
					int j, ipom = Nod[i] = Nodes-lastnodes;
					tmove pom = m[i];
					int rrr=rr[i];
					for( j=i; j>0; j-- )
					{ m[j] = m[j-1]; Nod[j] = Nod[j-1];
					  rr[j] = rr[j-1]; }
					m[j] = pom; Nod[j] = ipom; rr[j]=rrr;
					}

				}
				else /* no turn, bubble up by nodes searched */
				{
				  int j; int64 ipom; tmove pom;
				  int rrr=rr[i];
				  ipom = Nod[i] = Nodes-lastnodes;
				  /* bubble up */
				  pom = m[i];
				  for( j=i; j>bgs+1 && ipom>Nod[j-1]; j-- )
				  { m[j] = m[j-1]; Nod[j] = Nod[j-1];
				    rr[j]=rr[j-1]; }
				  m[j] = pom; Nod[j] = ipom; rr[j]=rrr;
				}
			}

			if( Abort )
			{
				if( Abort == 1 && Flag.post )
					puts("search aborted");
				break;
			}

		}

		if( !Abort && Depth>300 )
		{ learndepth = Depth; learnalpha = Alpha; }

		if( Flag.post ) infoline(3,NULL);
		Depth += 100;
		FollowPV = 1;

		/* Fix some misbehaviour of root moves randomness when
		 * close to game end. */
		if( Flag.random && G[Counter].mtrl <= Q_VALUE+R_VALUE )
			for( i=0; i!=n; i++ )
				if( abs(Alpha)>29990 ) rr[i]=0;
				else rr[i]/=2;

		if( abs(Alpha) > 29000 )
		{
			if( abs(Alpha)+Depth/100 > CHECKMATE ) break;

			if( EasyMove < 2 )
			{
				EasyMove = 2;
				if( Flag.post && Flag.xboard<2 )
				printf(
"    -> forced checkmate -> easy move (2)              \n");
			}
		}

		LastIter = Alpha;
	}

	Depth -= 100;
	AllDepth += Depth;
	{
		extern long T1;
		long t=ptime()-T1;
		if( t != 0 ) AllNPS += 100*Nodes/t;
	}

	if( Flag.post ) infoline(0,NULL);

	if( Flag.learn && learndepth ) wlearn( learndepth, learnalpha );

	do_move(PV[0]);
}

signal(SIGINT,SIG_IGN);

return PV[0][0];

}

