## I. How to set up the environment to run iosmodularkits repository
### A: Clone iosmodularkits repo to your machine

```Script
git clone git@github.com:harryngict/TracePointKit.git
```

### B: Set Up fundamental environment for iOS Developers
Ensure that your local computer has the following installed:

- 1. Xcode: Download and install Xcode from the Mac App Store.
- 2. Homebrew: Install Homebrew by following https://brew.sh/
- 3. Make: Install Make using Homebrew by running:

```sh
brew install make
```

### C: Set Up TracePointKit Tools Required

This step is required only once when you first set up the project. Use the cd command to move to the root folder of iosmodularkits that you cloned in for example:
```script
cd ../../TracePointKit
```

Then, run the following command in the terminal to automatically set up all required dependencies:

```script
make setup_local_environment
```

This syntax will execute the job defined in the `Makefile`.

### D: Running Example target

- Step 1: For users using CocoaPods (if you are using SPM, ignore this step)
``` 
bundle exec pod install
```
- Step 2: Open the project
```
open Example.xcworkspace
``` 
