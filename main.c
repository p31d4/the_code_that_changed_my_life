#include <inttypes.h>
//--------------------------------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
//--------------------------------------------------------------------------------------------------

//uint16_t dim_x = 4;
//uint16_t dim_y = 4;
//                 // R   G  B   R  G  B   R  G   B   R   G   B
//uint8_t img_in[] = {255,  255, 255,  0, 0, 0,  0, 0,  0,  15, 0,  15,
//                    0,  0, 0,  0, 7, 15, 0, 0,  0,  0,  0,  0,
//                    0,  0, 0,  0, 0, 0,  0, 7,  15, 0,  0,  0,
//                    15, 0, 15, 0, 0, 0,  0, 0,  0,  0,  0,  0};

uint16_t dim_x;
uint16_t dim_y;
uint8_t *img_in;
//uint32_t hist_out[768];
uint32_t *hist_out;

typedef struct
{
  unsigned char red,green,blue;
} PPMPixel;

typedef struct
{
  int x, y;
  PPMPixel *data;
} PPMImage;

#define RGB_COMPONENT_COLOR 255

static PPMImage *readPPM(const char *filename)
{
  char buff[16];
  PPMImage *img;
  FILE *fp;
  int c, rgb_comp_color;
  //open PPM file for reading
  fp = fopen(filename, "rb");
  if (!fp)
  {
    fprintf(stderr, "Unable to open file '%s'\n", filename);
    exit(1);
  }

  //read image format
  if (!fgets(buff, sizeof(buff), fp))
  {
    perror(filename);
    exit(1);
  }

  //check the image format
  if (buff[0] != 'P' || buff[1] != '6')
  {
    fprintf(stderr, "Invalid image format (must be 'P6')\n");
    exit(1);
  }

  //alloc memory form image
  img = (PPMImage *)malloc(sizeof(PPMImage));
  if (!img) 
  {
    fprintf(stderr, "Unable to allocate memory\n");
    exit(1);
  }

  //check for comments
  c = getc(fp);
  while (c == '#')
  {
    while (getc(fp) != '\n');
      c = getc(fp);
  }

  ungetc(c, fp);
  //read image size information
  if (fscanf(fp, "%d %d", &img->x, &img->y) != 2)
  {
    fprintf(stderr, "Invalid image size (error loading '%s')\n", filename);
    exit(1);
  }

  //read rgb component
  if (fscanf(fp, "%d", &rgb_comp_color) != 1)
  {
    fprintf(stderr, "Invalid rgb component (error loading '%s')\n", filename);
    exit(1);
  }

  //check rgb component depth
  if (rgb_comp_color!= RGB_COMPONENT_COLOR)
  {
    fprintf(stderr, "'%s' does not have 8-bits components\n", filename);
    exit(1);
  }

  while (fgetc(fp) != '\n');
  //memory allocation for pixel data
  img->data = (PPMPixel*) malloc(img->x * img->y * sizeof(PPMPixel));

  if (!img)
  {
    fprintf(stderr, "Unable to allocate memory\n");
    exit(1);
  }

  //read pixel data from file
  if (fread(img->data, 3 * img->x, img->y, fp) != img->y)
  {
    fprintf(stderr, "Error loading image '%s'\n", filename);
    exit(1);
  }

  fclose(fp);
  return img;
}

//void writePPM(const char *filename, PPMImage *img)
//{
//    FILE *fp;
//    //open file for output
//    fp = fopen(filename, "wb");
//    if (!fp) {
//         fprintf(stderr, "Unable to open file '%s'\n", filename);
//         exit(1);
//    }
//
//    //write the header file
//    //image format
//    fprintf(fp, "P6\n");
//
//    //comments
//    //fprintf(fp, "# Created by %s\n",CREATOR);
//
//    //image size
//    fprintf(fp, "%d %d\n",img->x,img->y);
//
//    // rgb component depth
//    fprintf(fp, "%d\n",RGB_COMPONENT_COLOR);
//
//    // pixel data
//    fwrite(img->data, 3 * img->x, img->y, fp);
//    fclose(fp);
//}

void getImagePPM(PPMImage *img)
{
    int index;
    if(img)
    {
      for(index = 0; index < img->x * img->y; index += 1)
      {
        img_in[(3 * index)]     = img->data[index].red;
        img_in[(3 * index) + 1] = img->data[index].green;
        img_in[(3 * index) + 2] = img->data[index].blue;
      }
    }
}

extern uint32_t histrgb(uint16_t dim_x, uint16_t dim_y, uint8_t img_in[], uint32_t hist_out[]);
int main()
{
  //--------------------------------------------------------------------------------------------------
  int hist_dim = (RGB_COMPONENT_COLOR + 1) * 3; //= 3 * 256;               //256 possibilidades para R, G e B
  uint32_t *hist_out_C;//hist_out_C[3 * 256];         //histograma de saida em C
  int counter;                          //contador dos loops        
  uint8_t imgValue;                     //valor do byte da imagem (R, G ou B)
  int histError = 0;                    //flag para verificar se os histogramas C e ASM sao iguais
  
  PPMImage *image;
  image = readPPM("test.ppm");  //-----------------------------------NOME DA IMAGEM
  
  dim_x = image->x;
  dim_y = image->y;
  img_in = (uint8_t *) malloc(dim_x * dim_y * 3);
  hist_out = (uint32_t *) malloc(hist_dim * sizeof(uint32_t) /*4*/);
  hist_out_C = (uint32_t *) malloc(hist_dim * sizeof(uint32_t));
  
  printf("dim_x: %d     dim_y: %d\n", dim_x, dim_y);
  printf("hist_dim: %d\n", hist_dim);
  //printf("size hist ASM: %d     size hist C: %d\n", sizeof(hist_out), sizeof(hist_out_C));
  
  getImagePPM(image);
  
  //Zera histograma de saida
  for(counter = 0; counter < hist_dim; counter += 1)
  {
    hist_out_C[counter] = 0;
  }
  
  for(counter = 0; counter < (dim_x * dim_y * 3); counter += 1) //dim_x*dim_x*3 pixels (R G B)
  {
    imgValue = img_in[counter];
    if((counter % 3) == 0)
    {
      hist_out_C[imgValue] += 1;
    }
    else if((counter % 3) == 1)
    {
      hist_out_C[imgValue + 256] += 1;
    }
    else if((counter % 3) == 2)
    {
      hist_out_C[imgValue + 512] += 1;
    }
  }
  
  //--------------------------------------------------------------------------------------------------

  uint32_t i;  
  i = histrgb(dim_x, dim_y, img_in, hist_out);
  
  //--------------------------------------------------------------------------------------------------
  for(counter = 0; counter < hist_dim; counter += 1)
  {
    printf("\n%d ", hist_out[counter]);
    
    
    printf("%d ", hist_out_C[counter]);
    if(hist_out[counter] != hist_out_C[counter])
    {
      histError = 1;
      break;
    }
  }
  if(histError == 1)
  {
    printf("DEU RUIM\n");
  }
  else 
  {
    printf("\nDEU BOA\n");
  }
  //--------------------------------------------------------------------------------------------------
  
  return 0;
}

