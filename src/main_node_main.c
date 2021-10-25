#include "main.h"
#include "stdlib.h"

int main() {
	int a = 1, b = 1, c = 0;

	while (1) {
		c = stdlib_add(a, b);
		b = c;
		a = b;
	}

	return 0;
}
