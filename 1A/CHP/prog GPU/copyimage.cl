#define PI 3.14159f
/// kernel for copying an image
/// This kernel may be modified in order to get filter coefficients. Do not forget to modify the
/// calling function and specify the parameters
///
/// imageInput:  pointer to image data
/// imageOutput: pointer to image result
/// width:       dimension of image
/// height:      dimension of image


/// COPY IMAGE
kernel void copy_image(__global const unsigned char *imageInput,
		       __global       unsigned char *imageOutput) 
{
  // Get the index of the current element to be processed
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;
  
  if (coord.x < width && coord.y < height)
    {
      imageOutput[index]     = imageInput[index];
      imageOutput[index + 1] = imageInput[index + 1];
      imageOutput[index + 2] = imageInput[index + 2];
      imageOutput[index + 3] = imageInput[index + 3];
     
    }
}



/// MEAN FILTER
kernel void moyenne_image(__global const unsigned char *imageInput,
			__global       unsigned char *imageOutput)
{
  // Get the index of the current element to be processed
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;

  float4 mean = (float4)(0,0,0,0);
  int compteur = 0;
  

  if ((coord.x - HALF_FILTER_SIZE >= 0) && (coord.x + HALF_FILTER_SIZE < width) && (coord.y - HALF_FILTER_SIZE >= 0) && (coord.y + HALF_FILTER_SIZE < height)) {
    for (int i = coord.x - HALF_FILTER_SIZE; i <= coord.x + HALF_FILTER_SIZE; i++) {
      for (int j = coord.y - HALF_FILTER_SIZE; j <= coord.y + HALF_FILTER_SIZE; j++) {
	rowOffset = j * width * 4;
	index = rowOffset + i * 4;
	mean = mean + (float4)(imageInput[index], imageInput[index + 1], imageInput[index + 2], imageInput[index + 3]);
	compteur++;
      }
    }
    mean = mean/compteur
      ;
    rowOffset = coord.y * width * 4;
    index = rowOffset + coord.x * 4;

    imageOutput[index]     = (int)(mean.x);
    imageOutput[index + 1] = (int)(mean.y);
    imageOutput[index + 2] = (int)(mean.z);
    imageOutput[index + 3] = (int)(mean.w);
     
  }
  else {
    if (coord.x < width && coord.y < height) {
      imageOutput[index]     = imageInput[index];
      imageOutput[index + 1] = imageInput[index + 1];
      imageOutput[index + 2] = imageInput[index + 2];
      imageOutput[index + 3] = imageInput[index + 3];
     
    }
  }
}

kernel void moyenne_image_naive(__global const unsigned char *imageInput,
			__global       unsigned char *imageOutput)
{
  // Get the index of the current element to be processed
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;

  float mean0 = 0.0;
  float mean1 = 0.0;
  float mean2 = 0.0;
  float mean3 = 0.0;
  int compteur = 0;
  

  if ((coord.x - HALF_FILTER_SIZE >= 0) && (coord.x + HALF_FILTER_SIZE < width) && (coord.y - HALF_FILTER_SIZE >= 0) && (coord.y + HALF_FILTER_SIZE < height)) {
    for (int i = coord.x - HALF_FILTER_SIZE; i <= coord.x + HALF_FILTER_SIZE; i++) {
      for (int j = coord.y - HALF_FILTER_SIZE; j <= coord.y + HALF_FILTER_SIZE; j++) {
	rowOffset = j * width * 4;
	index = rowOffset + i * 4;
	mean0 = mean0 + (float)(imageInput[index]);
	mean1 = mean1 + (float)(imageInput[index + 1]);
	mean2 = mean2 + (float)(imageInput[index + 2]);
	mean3 = mean3 + (float)(imageInput[index + 3]);
	compteur++;
      }
    }
    mean0 = mean0/compteur;
    mean1 = mean1/compteur;
    mean2 = mean2/compteur;
    mean3 = mean3/compteur;
    
    rowOffset = coord.y * width * 4;
    index = rowOffset + coord.x * 4;

    imageOutput[index]     = (int)(mean0);
    imageOutput[index + 1] = (int)(mean1);
    imageOutput[index + 2] = (int)(mean2);
    imageOutput[index + 3] = (int)(mean3);
     
  }
  else {
    if (coord.x < width && coord.y < height) {
      imageOutput[index]     = imageInput[index];
      imageOutput[index + 1] = imageInput[index + 1];
      imageOutput[index + 2] = imageInput[index + 2];
      imageOutput[index + 3] = imageInput[index + 3];
     
    }
  }
}

kernel void moyenne_image_vect(__global const uchar4 *imageInput,
			     __global       uchar4 *imageOutput)
{
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = 0;
  int index = 0;
  
  float4 mean = (float4) (0,0,0,0);
  int compteur = 0;

    
  if ( (coord.x>HALF_FILTER_SIZE) &&
       (width-coord.x>HALF_FILTER_SIZE) &&
       (coord.y>HALF_FILTER_SIZE) &&
       (height-coord.y>HALF_FILTER_SIZE) )
    {
      for (int i = coord.x - HALF_FILTER_SIZE; i < coord.x + HALF_FILTER_SIZE+1; i++) {
	for (int j = coord.y - HALF_FILTER_SIZE; j < coord.y + HALF_FILTER_SIZE+1; j++) {
	  rowOffset = j * width;
	  index = rowOffset + i;
                
	  mean = mean + convert_float4(imageInput[index]);
	  compteur = compteur+1;
	}
      }
      mean = mean/compteur;
        
      rowOffset = coord.y * width;
      index = rowOffset + coord.x;
        
      imageOutput[index] = convert_uchar4(mean);
    }
  else {
    rowOffset = coord.y * width;
    index = rowOffset + coord.x;
        
    imageOutput[index] = imageInput[index];
  }
}


/// GAUSSIAN FILTER
kernel void gaussienne_image(__global const unsigned char *imageInput,
			 __global       unsigned char *imageOutput)
{
  // Get the index of the current element to be processed
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;
  
  const float sigma = 10.0;
  const float beta = 1.0/(2.0*sigma*sigma);


  float4 gaussien = (float4) (0.0,0.0,0.0,0.0);
  float normalisation = 0.0;
  float coef;
  

  if ((coord.x - HALF_FILTER_SIZE >= 0) && (coord.x + HALF_FILTER_SIZE < width) && (coord.y - HALF_FILTER_SIZE >= 0) && (coord.y + HALF_FILTER_SIZE < height)) {
    for (int i = - HALF_FILTER_SIZE; i < HALF_FILTER_SIZE; i++) {
      for (int j = - HALF_FILTER_SIZE; j < HALF_FILTER_SIZE; j++) {
	rowOffset = (coord.y+j) * width * 4;
	index = rowOffset + (coord.x+i) * 4;
	
	coef = exp(-(float) (i*i+j*j)*beta);
	normalisation = normalisation + coef;
	

	gaussien = gaussien + coef * (float4)(imageInput[index], imageInput[index + 1], imageInput[index + 2], imageInput[index + 3]);;

      }
    }
    gaussien = gaussien/normalisation;
    
    rowOffset = coord.y * width * 4;
    index = rowOffset + coord.x * 4;

    imageOutput[index]     = (int)(gaussien.x);
    imageOutput[index + 1] = (int)(gaussien.y);
    imageOutput[index + 2] = (int)(gaussien.z);
    imageOutput[index + 3] = (int)(gaussien.w);
     


  }
  else {
    if (coord.x < width && coord.y < height) {
      imageOutput[index]     = imageInput[index];
      imageOutput[index + 1] = imageInput[index + 1];
      imageOutput[index + 2] = imageInput[index + 2];
      imageOutput[index + 3] = imageInput[index + 3];
     
    }
  }
}

kernel void gaussienne_image_naif(__global const unsigned char *imageInput,
			 __global       unsigned char *imageOutput)
{
  // Get the index of the current element to be processed
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = coord.y * width * 4;
  int index = rowOffset + coord.x * 4;
  
  const float sigma = 10.0;
  const float beta = 1.0/(2.0*sigma*sigma);


  float4 gaussien = (float4) (0.0,0.0,0.0,0.0);
  float normalisation = 0.0;
  float coef;
  

  if ((coord.x - HALF_FILTER_SIZE >= 0) && (coord.x + HALF_FILTER_SIZE < width) && (coord.y - HALF_FILTER_SIZE >= 0) && (coord.y + HALF_FILTER_SIZE < height)) {
    for (int i = 0; i < HALF_FILTER_SIZE; i++) {
      for (int j = 0; j < HALF_FILTER_SIZE; j++) {
	rowOffset = (coord.y+j) * width * 4;
	index = rowOffset + (coord.x+i) * 4;
	
	coef = exp(-(float) (i*i+j*j)*beta);
	normalisation = normalisation + coef;
	

	gaussien = gaussien + coef * (float4)(imageInput[index], imageInput[index + 1], imageInput[index + 2], imageInput[index + 3]);;

      }
    }
    gaussien = gaussien/normalisation;
    
    rowOffset = coord.y * width * 4;
    index = rowOffset + coord.x * 4;

    imageOutput[index]     = (int)(gaussien.x);
    imageOutput[index + 1] = (int)(gaussien.y);
    imageOutput[index + 2] = (int)(gaussien.z);
    imageOutput[index + 3] = (int)(gaussien.w);
     


  }
  else {
    if (coord.x < width && coord.y < height) {
      imageOutput[index]     = imageInput[index];
      imageOutput[index + 1] = imageInput[index + 1];
      imageOutput[index + 2] = imageInput[index + 2];
      imageOutput[index + 3] = imageInput[index + 3];
     
    }
  }
}


kernel void gaussienne_image_vect(__global const uchar4 *imageInput,
			      __global       uchar4 *imageOutput)
{
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = 0;
  int index = 0;

  const float sigma = 10.0;
  const float beta = 1.0/(2.0*sigma*sigma);
  
  float4 gaussien = (float4) (0.0,0.0,0.0,0.0);
  float normalisation = 0.0;
  float coef;
    
  if ( (coord.x>HALF_FILTER_SIZE) &&
       (width-coord.x>HALF_FILTER_SIZE) &&
       (coord.y>HALF_FILTER_SIZE) &&
       (height-coord.y>HALF_FILTER_SIZE) )
    {
      for (int i = - HALF_FILTER_SIZE; i < HALF_FILTER_SIZE + 1; i++) {
	for (int j = - HALF_FILTER_SIZE; j < HALF_FILTER_SIZE + 1; j++) {
	  rowOffset = (coord.y + j) * width;
	  index = rowOffset + (coord.x + i);
                
	  coef = exp(-(float) (i*i+j*j)*beta);
		
                
	  normalisation = normalisation + coef;
                
	  gaussien = gaussien + coef*convert_float4(imageInput[index]);
	}
      }
      gaussien = gaussien/normalisation;

      rowOffset = coord.y * width;
      index = rowOffset + coord.x;

      imageOutput[index] = convert_uchar4(gaussien);
    }
  else {
    rowOffset = coord.y * width;
    index = rowOffset + coord.x;
        
    imageOutput[index] = imageInput[index];
  }
}

kernel void gaussienne_image_coef(__global const uchar4 *imageInput,
			      __global       uchar4 *imageOutput,
			      __global const float *tab_coef)
{
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int rowOffset = 0;
  int index = 0;
  
  float4 gaussien = (float4) (0.0,0.0,0.0,0.0);
  float normalisation = 0.0;
  float coef;
    
  if ( (coord.x>HALF_FILTER_SIZE) &&
       (width-coord.x>HALF_FILTER_SIZE) &&
       (coord.y>HALF_FILTER_SIZE) &&
       (height-coord.y>HALF_FILTER_SIZE) )
    {
      for (int i = - HALF_FILTER_SIZE; i < HALF_FILTER_SIZE + 1; i++) {
	for (int j = - HALF_FILTER_SIZE; j < HALF_FILTER_SIZE + 1; j++) {
	  rowOffset = (coord.y + j) * width;
	  index = rowOffset + (coord.x + i);
                
	  coef = tab_coef[abs(i)] * tab_coef[abs(j)];
		
                
	  normalisation = normalisation + coef;
                
	  gaussien = gaussien + coef*convert_float4(imageInput[index]);
	}
      }
      gaussien = gaussien/normalisation;

      rowOffset = coord.y * width;
      index = rowOffset + coord.x;

      imageOutput[index] = convert_uchar4(gaussien);
    }
  else {
    rowOffset = coord.y * width;
    index = rowOffset + coord.x;
        
    imageOutput[index] = imageInput[index];
  }
}

