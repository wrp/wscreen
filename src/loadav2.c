#include <stdlib.h>

void
InitLoadav( void )
{
	return;
}

static double loadav[ 3 ];

static int
GetLoadav( void )
{
	return getloadavg( loadav, 3  );
}


void
AddLoadav( char * p )
{
	int i, j;
	j = GetLoadav();
	for( i = 0; i < j; i++ ) {
		sprintf( p, " %2.2f" + !i, loadav[ i ]);
		p += strlen(p);
	}
}

