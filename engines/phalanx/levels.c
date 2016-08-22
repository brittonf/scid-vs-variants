#include "phalanx.h"

long T1, T2;

long Time = 600*100;
long Otim = 600*100;


/* return time in centiseconds */
long ptime(void)
{
	if( Flag.cpu ) return ((double)clock())*100/CLOCKS_PER_SEC;
	else
	{
#ifdef _WIN32
		return GetTickCount()/10;
#else
		struct timeval t;
		gettimeofday( &t, NULL );
		return t.tv_sec*100 + t.tv_usec/10000;
#endif
	}
}



void l_level( char * l )
{
	int moves, seconds, minutes, increment;

	while( *l == ' ' ) l++;
	moves = atoi(l);

	while( isdigit((int)*l) ) l++;
	while( *l == ' ' ) l++;

	if( *l == '\n' || *l == '\0' )
	{
		printfl("fixed time %i seconds\n", moves );
		Flag.level = fixedtime; Flag.centiseconds = moves*100;
		return;
	}

	minutes = atoi(l);

	while( isdigit((int)*l) ) l++;
	if( *l == ':' )
	{
		l++;
		seconds = atoi(l);
		while( isdigit((int)*l) ) l++;
	}
	else seconds = 0;

	while( isdigit((int)*l) ) l++;
	while( *l == ' ' ) l++;
	increment = atoi(l);

	if( moves==0 )
		printfl(
		 "level: all moves in %i:%02i, increment %i seconds\n",
		 minutes, seconds, increment );
	else
		printfl(
		 "level: %i moves in %i:%02i, increment %i seconds\n",
		 moves, minutes, seconds, increment );

	Flag.level = timecontrol;
	Flag.moves = moves;
	Flag.centiseconds = minutes*6000+seconds*100;
	Flag.increment = increment;
	Time = Flag.centiseconds;
}



void l_startsearch(void)
{
	int moves;
	T1 = ptime();

	/* Adjust the DrawScore to avoid long boring drawish endgames.
	 * The default DrawScore is -10; Phalanx tries to avoid draws.
	 * That's good, but I have observed too many games that ended
	 * with the 50 moves rule draw, where the engine played
	 * an KR vs KR endgame. The code below fixes that behaviour. */
	if(
		Counter>=80  /* Counter==80 is move #40 */
		&&
		(
			   ( DrawScore <  0 && G[Counter].mtrl <= 3*R_VALUE )
			|| ( DrawScore < 10 && G[Counter].mtrl <= R_VALUE )
		)
	  ) DrawScore++;

	switch( Flag.level )
	{
	case timecontrol:
		if( Flag.moves > 0 ) moves = 2*Flag.moves;
		else
		{
			moves = Counter +
			        (G[Counter].mtrl+G[Counter].xmtrl)/800;
			if( Counter < 120 )
				moves += 60 - Counter/4;
			else	moves += 30;
		}

		if( Flag.increment == 0 ) T2 = 0;
		else
		if( Time/Flag.increment >= 1600 )
			T2 = Flag.increment * 60;
		else
		if( Time/Flag.increment <= 400 )
			T2 = Flag.increment * 10;
		else
			T2 = Flag.increment * (Time/Flag.increment/8-20)/3;

		if( Flag.post && T2 && Flag.xboard<2 )
		printfl( "    -> increment adds %g s to soft time limit\n",
			((float)T2) / (float)100 );

		T2 += Time / ( moves - Counter%moves + 4 );

		if( Flag.ponder ) T2 += T2/8;

		if( Flag.increment==0 && Flag.level==timecontrol )
		{
		   if( Time<150/*0*/ ) T2 -= T2/2;
		   else if( Time<600/*0*/ ) T2 -= T2/4;
		}

		if( Flag.post && Flag.xboard<2 )
		printfl( "    -> soft time limit %g s\n",
		   ((float)T2) / (float)100 );

		/*** Now, set up the hard limit ***/
		     if( Time < 150/*0*/) Flag.centiseconds = Time/(moves+1)*3;
		else if( Time < 300/*0*/) Flag.centiseconds = Time/(moves+1)*6;
		else if( Time < 600/*0*/) Flag.centiseconds = Time/(moves+1)*12;
		else                  Flag.centiseconds = Time/(moves+1)*18; 

		Flag.centiseconds += 400*Flag.increment;

		if( Flag.centiseconds > Time-Flag.increment*100 )
		{
			if( Time > 200*Flag.increment )
			      Flag.centiseconds = Time-100*Flag.increment;
			else  Flag.centiseconds = Time/2;
		}

		if( Flag.centiseconds < 25 ) Flag.centiseconds = 25;

		if( Flag.post && Flag.xboard<2 )
		printfl( "    -> hard time limit %g s\n",
			((float)Flag.centiseconds) / (float)100 );

	break;
	case averagetime:
		T2 = Flag.centiseconds/3;
	break;
	default: break;
	}

	if( T2 < 1 ) T2 = 1;
}



int l_iterate(void)
{
	if( Flag.level == fixeddepth )
	{
		return ( Depth < Flag.depth );
	}
	else
	if( Flag.level == averagetime || Flag.level == timecontrol )
	{
		long t = ptime();
		switch( EasyMove )
		{
			case 1:  return ( t <= T1 + T2/2 );
			case 2:  return ( t <= T1 + T2/4 );
			default:
				 if( Depth<400 ) /* stabilize low nps levels */ 
					return ( t <= T1 + T2*2/3 );
				 if( Turns==0 )
					return ( t <= T1 + T2 );
				 else
					return ( t <= T1 + T2*(8+Turns)/8 );
		}
	}
	else
	return 1;
}

