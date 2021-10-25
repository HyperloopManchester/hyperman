# hyperman

Main repo for the manchester hyperloop pod. Platform IO, integration tests, etc

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
1. Pull any changes, rebasing your current commits onto the new commits
2. Work on a part of the code
3. Commit changes to the code. Prefer using `--amend` for small fixes
```sh
# 1) pull any changes. we rebase to avoid branches, and keep a cleaner commit
#    history. aesthetics matter :^)
$ git pull --rebase

# 2) do your work
$ touch src/main_node.c

# 3) commit your work. if the change is small, then use --amend to avoid
#    creating many small commits that clutter the history. only create a
#    new commit if you start working on a logically different part of the
#    project
$ git commit --amend
# OR
$ git commit
```

When a feature is ready for review, the usual workflow will be:
1. Pull any changes and rebase
2. Create a new branch containing all the current commits
3. Push the new branch to the origin
4. Once a remote branch has been made, request a review of your work
```sh
# 1) pull any changes, to ensure your patches dont cause conflicts
$ git pull --rebase

# 2) create a new branch. name it feature-<feature-name> or something sensible
$ git branch feature-foo

# 3) push the new local branch to our origin
$ git push origin feature-foo

# 4) request a review of your work on the remote branch. consider making a 
#    pull request from your new branch onto the master branch
```

If more work is required on the changes, then the workflow will be:
1. Checkout previously made branch
2. Pull any changes made to the `master` branch
3. Do work, commit work, goto 2
4. Push work to the remote branch, and request a re-review
```sh
# 1) checkout your local feature branch
$ git checkout feature-foo

# 2) pull and rebase changes to origin/master onto your local feature branch
#    this will make sure you are working with the latest changes
$ git pull origin master --rebase

# 3) work, commit, repeat. you know the drill

# 4) when work is done, pull with rebase and push again to the remote branch
#    then request a re-review
$ git pull origin master --rebase
$ git push origin feature-foo -f
```

Once your changes have been merged, checkout the `master` branch again, fetch
any changes to the origin, reset onto the latest commit (the merge commit), and
remove your (now stale) local branch:
```sh
$ git checkout master
$ git fetch origin
$ git reset --hard origin/master
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

All testing and compilation will be done with platform io. Testing will be done
on the host machine, with the help of hardware mocks, since debugging doesn't 
really exist on microcontrollers (without expensive hardware debuggers). Thus
to run all the tests, run the following command:
```sh
# the native environment means the host machine
$ pio test --environment native
```

We are currently using our own very basic testing framework, and examples of
a set of tests can be found under `test/example.c`.

## Remote Development

We use a hardware server to allow for remote development, which is accessible
through a vpn.

TODO
