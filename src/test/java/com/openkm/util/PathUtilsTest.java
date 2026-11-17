package com.openkm.util;

import junit.framework.TestCase;

import java.text.Normalizer;

public class PathUtilsTest extends TestCase {
	private static final String NFC = "한글";
	private static final String NFD = Normalizer.normalize(NFC, Normalizer.Form.NFD);

	public void testNormalize() {
		assertFalse(NFC.equals(NFD));
		assertEquals(NFC, PathUtils.normalize(NFD));
		assertEquals(NFC, PathUtils.normalize(NFC));
		assertEquals("/okm:root/abc", PathUtils.normalize("/okm:root/abc"));
		assertNull(PathUtils.normalize(null));
	}

	public void testCleanup() {
		assertEquals(NFC + ".txt", PathUtils.cleanup(NFD + ".txt"));
	}

	public void testIsSameOrDescendant() {
		assertTrue(PathUtils.isSameOrDescendant("/okm:root/a", "/okm:root/a"));
		assertTrue(PathUtils.isSameOrDescendant("/okm:root/a/b", "/okm:root/a"));
		assertFalse(PathUtils.isSameOrDescendant("/okm:root/ab", "/okm:root/a"));
		assertFalse(PathUtils.isSameOrDescendant("/okm:root", "/okm:root/a"));
		assertTrue(PathUtils.isSameOrDescendant("/okm:root/" + NFD + "/x", "/okm:root/" + NFC));
	}
}
