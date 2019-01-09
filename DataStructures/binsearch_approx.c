 /*-----------------------------------
 * binary search
 * MEX file
 * 
 * ADR 1998
 * 
 * input: Data -- n x 1, assumed to be sorted
 *        key
 * output: index into Data
 *
 * version 1.1
 *
 * v 1.1 (Apr 99) - returns NaN if key is NaN 
 %
% Status: PROMOTED (Release version) 
% See documentation for copyright (owned by original authors) and warranties (none!).
% This code released as part of MClust 3.0.
% Version control M3.0.
 -----------------------------------*/

#include "mex.h"
#include <math.h>
#include <matrix.h>
#include <stdlib.h>


double binsearch_approx(const double* data, const int n_data, const double key)
{
	int lower = 0;
	int upper = n_data - 1;
	int mid; // will floor by type conversion

	while (lower <= upper)
	{
		mid = (upper + lower) / 2;
		if (key == data[mid]) // found
			return (double) mid+1;
		else if (key == data[lower])
			return (double) lower+1;
		else if (key == data[upper])
			return (double) upper+1;
		else if (key < data[mid] && upper > mid)
			upper = mid;
		else if (data[mid] < key && lower < mid)
			lower = mid;
		else
			break; // key not found
	}
	if (key < data[0] || data[n_data-1] < key)
		return 0;
	else
		return (-1)*(mid+1); // not found
}

void mexFunction(
  int nOUT, mxArray *pOUT[],
  int nINP, const mxArray *pINP[])
{
  int n_data;
  int include_outofrange;
  int i_key;
  int n_keys;
  double *key;
  double *data;
  double *result;
  int lower, upper, mid; // will floor by type conversion
  
  /* check number of arguments: expects 2 inputs, 1 output */
  if (nINP != 2 && nINP != 3) // third input can be 0, 1 for "include out of range"
    mexErrMsgTxt("Call with Data, key as inputs. Third input can optionally be 0, 1 for 'include out of range'");
  if (nOUT != 1)
    mexErrMsgTxt("Requires one output.");

  /* check validity of inputs */
  // if (mxGetM(pINP[1]) * mxGetN(pINP[1]) != 1)
  //   mexErrMsgTxt("Can only use one key at a time.");

  /* unpack inputs */
  n_data = mxGetM(pINP[0]) * mxGetN(pINP[0]);
  n_keys = mxGetM(pINP[1]) * mxGetN(pINP[1]);
  if (nINP == 3 && pINP[2] != 0) // optional provided TRUE
	  include_outofrange = 1;
  else
	  include_outofrange = 0;
  data = (const double *)mxGetPr(pINP[0]);
  key = (const double *)mxGetPr(pINP[1]); /* sets key to point to the start of keys */
 
  /* pack outputs */
  pOUT[0] = mxCreateDoubleMatrix(mxGetM(pINP[1]), mxGetN(pINP[1]), mxREAL);
  result = (double *) mxGetPr(pOUT[0]);

  if (n_data == 0) {
	  *result = 0;
	  return;
  }

  for (i_key = 0; i_key < n_keys; i_key++) {

	  lower = 0;
	  upper = n_keys - 1;

	  if (mxIsFinite(*key)) {
		  *result = binsearch_approx(data, n_data, *key);
		  if (include_outofrange && *result == 0) {
			  if (*key < data[0]) // to the left
				  * result = 1;
			  else // to the right
				  *result = n_data;
		  };
	  }
	  else /* NaN or Inf */
		  *result = mxGetNaN();

	  result++;
	  key++;
  };
}
