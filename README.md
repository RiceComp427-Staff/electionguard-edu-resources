# ElectionGuard-EDU Resources

This repository contains instructor resources for working with ElectionGuard-EDU. In particular,
you'll see:

- `voting-crypto.key` and `voting-crypto.pdf`: Apple Keynote slide deck (and PDF) that corresponds to an 80-ish minute lecture
on the "modern cryptography" used by end-to-end cryptographic voting systems. If you want to use these slides with Keynote,
you'll need to install the [Roboto font family](https://fonts.google.com/specimen/Roboto) (used everywhere) and [Hack](https://sourcefoundry.org/hack/) (used for code). All freely available.

- `voting-crypto.pptx` is exported from `voting-crypto.key`, and is probably good enough for making small changes, but
  there are no guarantees it will work flawlessly.

- `handout-kotlin.tex` and `handout-python.tex`: front-ends that build the student PDF handout,
suitably customized to match the Kotlin or Python3 codebases in which they'll be working.

- `handout.tex`: the shared source for both of the handouts.

Otherwise, it's this README file and then the two other repositories.

## Background

This assignment was designed at Rice for use in our undergraduate senior-level computer security class (Comp427), which is also taken roughly 50/50 by masters students. The first three weeks of the class are a module concerning cryptography, and then we move into other modules considering web security, operating systems, and other topics. Many of the lectures began with material developed by J. Alex Halderman for Michigan's EECS388.

The original Michigan cryptography assignment had the students implement the Bleichenbacher signature forgery attack ([which is still a real-world vulnerability](https://medium.com/asecuritysite-when-bob-met-alice/this-attack-has-been-around-for-20-years-and-its-back-again-with-the-bleichenbacher-oracle-a585c34c9890)). This alternative aims to have the students work with concepts like zero-knowledge proofs and homomorphic encryption, while still being tractable in a course that's not dedicated to cryptography.

In particular, the unit tests use sophisticated property-based testing libraries that are surprisingly good at finding bugs. We have unit tests that specifically look for common patterns we expect students to get confused, which will hopefully help them to fix those bugs. Also, unlike "real" cryptographic libraries, this code has a feature where every "element" carries along with it the formula used to create it. These are presented in a LISP-like prefix notation, but with (perhaps unfortunate) JSON array syntax. It's much more useful to scratch your head staring at a symbolic formula than at thousands of decimal digits.

## Code

There are two code repositories: `electionguard-edu-kotlin` and `electionguard-edu-python`. They have roughly the same code, to the
extent that two wildly different programming languages allow you to write the same thing. As such, your choice of which codebase to
use for this assignment is mostly a function of your students' preparation. If your students know Python well, you might just stick with that. If they know Java well, then Kotlin is relatively easy to learn for a Java programmer. (The Kotlin repository includes an
introductory document to help them.)

This assignment is meant to be done in two weeks, with students working in pairs. The first week is really a warm-up, with exercises that make sure the students understand the provided cryptographic libraries. The second week requires them to understand how to synthesize everything together to achieve the desired system properties.

There are two branches in each repository. `main` provides a complete solution, where the autograder provides the maximum number of points. For contrast, `handout` removes several of the function bodies, leaving behind `TODO` markings instructing the students what to do. They're also expected to implement some property-based unit tests.

When you're preparing your handouts, likely using [GitHub Classroom](https://classroom.github.com/), you would clone the repository, check out the `handout` branch, make any necessary changes to the `README.md` file, and then the scary part. Remove the entire `.git` directory and start over (`git init . ; git add . ; git commit -m 'initial commit'`). Now you've got a repository with only the student view of the code, ready for uploading to GitHub.

Once you've got your Classroom "clone link", you paste it into `handout.tex`, and run `make handout-python.pdf` or `make handout-kotlin.pdf`, as appropriate, to generate the student handout. We're including sample PDFs with non-functional clone links so it's easier for you to read them.

## Autograding

An autograder is provided that measures 10 points for part1 (including one point for having no compiler warnings in Kotlin, or no mypy warnings/errors in Python) and 9 points for part2. The last point is based on some written questions that the student is expected to edit into the `README.md` file, and which would be graded by a human grader. (The student is asked to produce a simple benchmark and comment on the execution time for one core versus a large cluster, hopefully coming to some realization about the real-world costs of this class of algorithm.)


Since the students have the full unit test suite available to them, as well as the autograder, it's not inconceivable that a student might attempt to cheat by modifying the unit tests to always succeed. More on this in the "human grader" instructions, below.

We've included a suitable GitHub Actions configuration to run the autograder on every push to the server. Also of note, the autograder prints out the time and date when it's run. This allows your graders to click through to the autograder output, skim the students' code, and transcribe the numbers into your university's learning management system (LMS).

Make sure your GitHub "organization" has enough quota for the Actions to run ([details](https://education.github.community/t/github-actions-limits-and-github-classroom/57730)).

If you *really* want the autograder's output to go directly to your LMS, the [Python autograder](https://github.com/thoward27/grade) has a function where it can write JSON output that's compatible with GradeScope. The [Java autograder](https://github.com/RiceComp215-Staff/RiceChecks), which works just fine with Kotlin, also writes output in YAML and JSON formats, but not in any format that's understood by GradeScope. Either way, you may be able to rig up some sort of connection between this output and your LMS. Obviously, a system like this would be relatively straightforward for students to defraud, but at least you'd have all the commits, so you could track it down after the fact.

Alternately, [GitHub Classroom understands how to speak the LTI protocol](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/connect-a-learning-management-system-to-github-classroom) to many popular university LMS services, but it (sadly) has a [very limited autograder](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/use-autograding), so we can't just auto-populate it with our unit tests and point weights.

**If you want to change the grading weights**:
- In Python it's easy. Just change the `@weight()` annotations on the unit tests. Just keep in mind that only methods that start with `test_` are executed by Python's unittest framework. You'll see that we had to do some gymnastics to make the Hypothesis tests coexist with the autograder annotations. If you try doing both sets of annotations on the same methods, it doesn't work.
- In Kotlin it's also pretty easy. You need to edit the `@Grade` annotations, and then you need to regenerate the "grade specification", which is extracted from the annotations and written to a YAML file. All you do is run the `autograderWriteConfig` action from Gradle. This creates `config/electionguard-grader.yml`, which you should then commit. Note that we removed these Gradle actions from the `handout` branch, since they might confuse students. So generate the new YAML file on the `main` branch and copy it over to the `handout` branch.

## What do I tell my human graders

This assignment uses autograders to make life easier on your human graders, but it still expects the human graders to do some work. The advice you might give them:

- For each student project, you'll look at the list of commits. You should look at the commit times versus the submission deadlines, since students might continue to push code after the deadline. It's also technically possible to forge the commit times. More on that below.
- If a commit has a red-x, then the autograder found one or more points to take off. If it has a green-check, then the autograder gave it full marks. For "part 1", no student will have full marks yet.
- You can click on the red-x or green-check and it will take you into GitHub Actions. From there, you can open the little triangles and see the output of the autograder. It will indicate which tests failed and what points they're worth. You will eventually transcribe this into your campus grade system, but before you do, there are a few other tasks you need to do.
- Look at the "diff" from the students' initial commit to the final commit. [GitHub has a convenient URL syntax](https://docs.github.com/en/github/committing-changes-to-your-project/viewing-and-comparing-commits/comparing-commits) for doing this.
You're looking for any edits that seem weird or out of place. In particular, if a student changes one of the provided unit tests to always pass, then you should ignore the autograder output for it and give them zero points for that test.
- For each of part1 and part2, the students are asked to implement one unit test on their own. You need to look at each of them and convince yourself that they do what the students are asked to do. The professor can share the "reference implementation" with you, so you've got the right idea, but you shouldn't show it to any students.
- For part2, the students are asked to implement a simple benchmark, and answer some questions by editing `README.md`. It's only worth one point, so almost any reasonable answer will work. For the question about the benefits of testing with smaller groups, the sort of answer we're looking for is that speeding up the cryptographic primitives allows the property-based tests to consider many more test cases in the same amount of time, making them more likely to find bugs.
- Lastly, Git has the curious property that the timestamps on commits are taken from the user's computer, not the server, so a student could try to falsify the commit time by changing their computer's clock. Our autograder prints the time when it runs. For Kotlin, the `build.gradle` file has the timezone specified inside, which the professor might change; for Python, it just prints in UTC, which you would then want to understand the difference between UTC and your local timezone. You can look at those timestamps when you're looking at the autograder output on GitHub. If they're "close enough" to the deadline, that's good enough. It's entirely possible that a student could push their code on-time, and the autograder might take several minutes before it executes. However, if they're hours or days late, and especially if the commit time is wildly unrelated to the execution time, then you may have discovered a problem. Turns out, GitHub logs the time when a `push` arrives on its servers, and your instructor can use a tool like `github_event_times` from the [github-classroom-utils](https://github.com/danwallach/github-classroom-utils) to document this.

## How might I stretch this assignment to three weeks?

Part2 of this assignment is more work than part1. You could potentially split the work of part2 into a hypothetical part2 and part3. You could also extend the written questions, which ask the students to build a simple benchmarking tool, and have them do additional reading and writing in the world of cryptographic e2e voting. Alternately, you could build a simple GUI that presents a ballot to a voter and have the students wire it up with the rest of the project.

Another way you could add more work, which might be a good fit if you're using this assignment in a cryptography class, is to blank out the code to create and/or verify some of the Chaum-Pedersen proofs. Maybe you blank out the verifier for one and the generator for another. Then you can assign points to the relevant unit tests. This would let you reinforce something of the generality of these proofs, and you could leverage this as background when introducing other kinds of NIZKs / SNARKs later in the semester.
