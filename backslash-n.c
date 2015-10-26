#include <stdio.h>

int main(int argc, char *argv[])
{
  if (argc < 2) {
    printf("usage: %s [file ...]\n", argv[0]);
    return 1;
  }

  for (int i = 1; i < argc; i++) {
    FILE *f = fopen(argv[i], "r+");

    if (f == NULL)
    {
      printf("%s: could not open file: %s\n", argv[0], argv[i]);
      return 1;
    }
    else
    {
      fseek(f, -1, SEEK_END);

      if (fgetc(f) != 10)
      {
        fprintf(f, "\n");
        fclose(f);
      }
    }
  }

  return 0;
}
