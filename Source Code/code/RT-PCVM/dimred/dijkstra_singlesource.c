/*
 * [d, p] = dijkstra(A, s)
 * 
 * Implementation of Dijkstra's method using a Matlab sparse matrix
 * as an adjacency matrix.  Zero entries represent non-existent edges.
 * Uses linear search for simplicity -- change to a heap if this ever
 * becomes the code bottleneck.
 *
 * Inputs:
 *   A - sparse adjacency matrix (transpose of the usual)
 *   s - label of source node (one-based)
 *   
 * Outputs:
 *   d - distance vector from Dijkstra
 *   p - predecessor vector from Dijkstra
 *
 * CODE WRITTEN BY DAVID BINDEL (thanks!)
 * http://www.cs.berkeley.edu/~dbindel/
 */

#include <mex.h>
#include <string.h>


/* Sift ith element up the heap
 */
static void upheap(double* d, int* h2d, int* d2h, int i)
{
    int    it = h2d[i];
    double dt = d[it];

    while (i > 1 && d[h2d[i/2]] > dt) {
        h2d[i]      = h2d[i/2];
        d2h[h2d[i]] = i;
        i           = i/2;
    }

    h2d[i]      = it;
    d2h[h2d[i]] = i;
}


/* Sift ith element down the heap
 */
static void downheap(double* d, int* h2d, int* d2h, int i, int n)
{
    int    it = h2d[i];
    double dt = d[it];

    while (2*i < n) {
        int lc = 2*i; 
	int rc = 2*i+1;
	int mc = (rc == n || d[h2d[lc]] <= d[h2d[rc]]) ? lc : rc;

	if (dt > d[h2d[mc]]) {
            h2d[i]      = h2d[mc];
            d2h[h2d[i]] = i;
	    i           = mc;
	} else {
	    break;
	}
    } 

    h2d[i]      = it;
    d2h[h2d[i]] = i;
}


/* Add item to queue or update
 */
static void enqueue(int i, double* d, int* h2d, int* d2h, int *hn)
{
    /* Use one-based indexing within heap */
    --d;
    ++i;

    if (d2h[i] == 0) {

        /* Sift new item up */
        *hn     = *hn + 1;
        d2h[i]  = *hn;
        h2d[*hn] = i;
        upheap(d, h2d, d2h, *hn);


    } else {

        /* Move old item */
        upheap  (d, h2d, d2h, d2h[i]);
        downheap(d, h2d, d2h, d2h[i], *hn);

    }
}


/* Dequeue existing item
 */
/* Add item to queue or update
 */
static int dequeue(double* d, int* h2d, int* d2h, int *hn)
{
    int top;

    /* Use one-based indexing within heap */
    --d;

    /* Dequeue top item */
    top      = h2d[1];
    d2h[top] = 0;

    /* Move tail item into hole */
    h2d[1]      = h2d[*hn];
    d2h[h2d[1]] = 1;
    --*hn;

    /* Sift down to correct place */
    downheap(d, h2d, d2h, 1, *hn);

    return top-1;
}



/* Run Dijkstra's algorithm
 */
void dijkstra(double* d, double* p, 
              int* jc, int* ir, double* cost, 
              int src, int n)
{
    int* h2d = (int*) mxMalloc((n+1) * sizeof(int));
    int* d2h = (int*) mxMalloc((n+1) * sizeof(int));
    int i, j, hn;
    
    /* Initialize */
    memset(h2d, 0, (n+1)*sizeof(int));
    memset(d2h, 0, (n+1)*sizeof(int));
    for (i = 0; i < n; ++i) {
        d[i]   = 1./0.;
        p[i]   = -1;
    }

    d[src] = 0;
    enqueue(src, d, h2d, d2h, &hn);

    while (hn > 0) {

        /* Find and dequeue closest node */
        int    u  = dequeue(d, h2d, d2h, &hn);
        double du = d[u];

        /* Update neighbor costs */
        for (i = jc[u]; i < jc[u+1]; ++i) {
            int v = ir[i];
            if (cost[i] != 0 && d[v] > du + cost[i]) {
                d[v] = d[u] + cost[i];
                p[v] = u+1;
                enqueue(v, d, h2d, d2h, &hn);
	    }
	    
        }
    }

    mxFree(h2d);
    mxFree(d2h);
}


void mexFunction(int nlhs, mxArray** plhs,
                 int nrhs, const mxArray** prhs)
{
    int n, s;

    if (nrhs != 2)
        mxErrMsgTxt("Too few arguments");
    if (!mxIsNumeric(prhs[0]) || !mxIsSparse(prhs[0]) || 
        mxGetM(prhs[0]) != mxGetN(prhs[0]))
        mxErrMsgTxt("Graph must be a square matrix");
    if (!mxIsNumeric(prhs[1]) || mxGetM(prhs[1]) * mxGetN(prhs[1]) != 1)
        mxErrMsgTxt("Source identifier must be a scalar");

    n = mxGetN(prhs[0]);
    s = (int) (*mxGetPr(prhs[1])-1);

    if (s < 0 || s > n)
        mxErrMsgTxt("Source identifier is out of range");

    plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(n, 1, mxREAL);

    dijkstra(mxGetPr(plhs[0]), mxGetPr(plhs[1]),
             mxGetJc(prhs[0]), mxGetIr(prhs[0]), mxGetPr(prhs[0]),
             s, n);
}
