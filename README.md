# hyperman
Main repo for the manchester hyperloop pod. Node sources, tests, etc

## Setup
To initially set up the repo, it is enough to clone the repo and its submodules:
```sh
$ git clone https://github.com/HyperloopManchester/hyperman.git
$ cd hyperman/
$ git submodule init
$ git submodule update
```

## Development
### Developing Hyperman
To work on hyperman, the usual workflow will be:
1. Pull any changes in both the main repo and any submodules
2. Branch off on your own feature branch (unique branch per feature)
3. Work on a part of the code
4. Commit changes to the code. Prefer using `--amend` for small fixes
```sh
# 1) pull any changes
$ git pull
$ git submodule update --remote --merge

# 2) create a new feature branch
$ git checkout -b feature-foo

# 3) do your work
$ touch src/main_node.c

# 4) commit your work. if the change is small, then use --amend to avoid
#    creating many small commits that clutter the history. only create a
#    new commit if you start working on a logically different part of the
#    project
$ git commit --amend
# OR
$ git commit
```

When a feature is ready for review, create a pull request on the github repo.

If more work is required on the changes, then the workflow will be:
1. Pull any changes made to the `master` branch with rebase, to replay your
   commits on top of any commits to the remote branch
2. Do more work, commit said work
3. Push work to the remote branch, and request a re-review
```sh
# 1) pull and rebase changes to origin/master onto your local feature branch
#    this will make sure you are working with the latest changes
$ git pull origin master --rebase

# 2) work, commit, repeat. you know the drill

# 3) when work is done, pull with rebase and push again to the remote branch
#    then request a re-review
$ git pull origin master --rebase
$ git push origin feature-foo
```

Once your changes have been merged, checkout the `master` branch again, fetch
any changes to the origin and to the submodules, and remove your (now stale)
local branch:
```sh
$ git checkout master
$ git pull
$ git submodule update --remote --merge
$ git branch -d feature-foo
```

You may now start to work on a new feature again!

### Developing a Submodule
#### Setup
Whilst the submodules are checked out when the repository is cloned, they are
in a detached state, without any local branch. Any work committed will be lost
when the submodule is updated. Thus, it is necessary to setup a local branch
to do local development:
```sh
$ cd lib/<submodule>
$ git checkout master
```

#### Development
Development on a submodule is virtually identical to regular development. You
navigate to the submodule directory, and you run the same commands you would
in regular development.

## Testing
We are currently using our own basic testing framework, and examples of tests
can be found under `test/stdlib/test_example.c`

All tests are ran before a build, as part of the Makefile.

## Style Guide
All work on the repo should take into account the `.editorconfig` file defined
in the repository root. Make sure that your development environment is properly
configured (with the correct plugins to recognise the file).

All files should have a soft line limit of 80 columns, and a hard limit of
120 columns (longer lines should wrap to the next line).

All source files (`*.{h,hpp,c,cpp}`) should follow the following style:
```c
/* inline comments should look like this */

/* single line comments should look like this
 */

/* multiline comments should look like this, wrapping at the 80 column mark,
 * without fail. if you need to add a reference to a document, add a SEE: line
 * ---
 *  SEE: referenced_document.pdf
 */

/* all header files must contain an include guard. examples include
 * hyperman/include/main.h -> HYPERMAN_MAIN_H
 * stdlib/include/stdlib.h -> HYPERMAN_STDLIB_H
 * stdlib/include/stdlib/memory.h -> HYPERMAN_STDLIB_MEMORY_H
 * stdlib/include/imxrt.h -> HYPERMAN_IMXRT_H
 * ---
 *  NOTE: source files dont need an include guard
 */
#ifndef HEADER_FILE_NAMESPACE_H
#define HEADER_FILE_NAMESPACE_H

/* includes must be at the top of the source file, and all system headers
 * (using the <> syntax) must come before all other headers (using the "" 
 * syntax). headers should also be sorted alphabetically if possible
 */
#include <sys_header.h>
#include "my_header.h"

/* if a header requires some custom defines, then it should come after the
 * main include section, and should have 1 line of whitespace before and after
 * the relevant include (and custom defines)
 */
#define MY_TYPE int
#include "my_generic_stack.h"
#undef MY_TYPE

/* any and all types must be in snake_case, and should be namespaced as follows
 * hyperman/include/utils.h:my_func() -> hyperman_my_func
 * stdlib/include/stdlib/threading.h/thread{} -> stdlib_thread
 */

/* all variables should be marked extern and have a doc-comment */

/* this is a variable doc-comment, explaining the purpose of the variable
 * ---
 *  SEE: referenced_document.pdf
 */
extern char *my_string;

/* all functions should be marked extern and have their parameter types and
 * return type explained. any additional notes can also be included in their
 * doc-comments
 */

/* this is a function doc-comment. this is a short explanation of the function
 * ---
 *  a: this is explaining what parameter a is
 *  b: this is explaining what parameter b is
 *  @return: if the return value isnt obvious, this explains what it is
 *  SEE: any additional documentation can be mentionned here as well
 */
extern int my_func(int a, int b);

/* compound types should not be typedefined to a different type (to be used
 * without the enum, struct, or union keyword), as this limits the number of
 * type names we can use, and removes some stynactic information (enums are
 * used differently to structs are used differently to unions)
 */

/* this is an example of an enum doc-comment
 */
enum my_enum {
  /* enum members should have the namespace (i.e hyperman, stdlib) and the 
   * enum name prefixed to the value name, and must be written using
   * SCREAMING_SNAKE_CASE
   */
  NAMESPACE_MY_ENUM_FOO,
  NAMESPACE_MY_ENUM_BAR,
  NAMESPACE_MY_ENUM_BAZ,
};

/* this is an example of a struct doc-comment
 */
struct my_struct {
  u32 foo, bar, baz; /* multiple declarations can happen on one line */
};

/* this is an example of a union doc-comment
 */
union my_union {
  u32 foo;
  f32 bar;
};

/* the end of the header include guard should also mention the namespace */
#endif /* HEADER_FILE_NAMESPACE_H */
```
