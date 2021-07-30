#ifndef HYPERMAN_TEST_H
#define HYPERMAN_TEST_H

#include <stdio.h>

#define TEST_BEGIN() \
	printf("*************** %s ***************\n", __FILE__); \
	int test_result = 0;

#define TEST_END() \
	printf("*************** %s ***************\n", __FILE__); \
	return test_result;

#define PASS() return 1;
#define FAIL() return 0;

#define TEST(test_name) int test_name(void)

#define TEST_RUN(test) \
{ \
	printf("%s: ", #test); \
	if (test()) { \
		printf("OK\n"); \
	} else { \
		printf("FAILED\n"); \
		test_result = 1; \
	} \
}

/* Assertions */
#ifdef NDEBUG

#define _TEST_ASSERT_IMPL(condition, message, file, line) ((void)0)
#define _TEST_ASSERT_NE_IMPL(condition, message, file, line) ((void)0)

#else // NDEBUG

#define _TEST_ASSERT_IMPL(condition, message, file, line, func) \
{ \
	if (condition) { } else { \
		printf("(%s:%d) %s: %s - %s\n", file, line, func, #condition, message); \
		FAIL(); \
	} \
}

#define _TEST_ASSERT_NE_IMPL(condition, message, file, line, func) \
{ \
	if (condition) { \
		printf("(%s:%d) %s: %s - %s\n", file, line, func, #condition, message); \
		FAIL(); \
	} \
}

#endif // NDEBUG

#define TEST_ASSERT(condition, message) \
	_TEST_ASSERT_IMPL(condition, message, __FILE__, __LINE__, __func__)

#define TEST_ASSERT_NE(condition, message) \
	_TEST_ASSERT_NE_IMPL(condition, message, __FILE__, __LINE__, __func__)

#endif // HYPERMAN_TEST_H
