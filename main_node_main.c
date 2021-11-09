#include "main.h"
#include "stdlib.h"
#include "stdlib/timing.h"

#include "imxrt_pins.h"

int main() {
	CORE_PIN13_CONFIG = 5;
	CORE_PIN13_PADCONFIG = IOMUXC_PAD_DSE(7);
	CORE_PIN13_DDRREG |= CORE_PIN13_BITMASK;

	while (1) {
		CORE_PIN13_PORTSET = CORE_PIN13_BITMASK;
		stdlib_delay_msec(500);

		CORE_PIN13_PORTCLEAR = CORE_PIN13_BITMASK;
		stdlib_delay_msec(500);
	}

	return 0;
}
