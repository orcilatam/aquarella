package com.aquarella.portal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class PortalApplicationTests {

	@Test
	@DisplayName("Test de la suma")
	void suma() {
		assertEquals(2, 1 + 1);
	}

	@Test
	@DisplayName("Test de la resta")
	void resta() {
		assertEquals(0, 1 - 1);
	}
}
