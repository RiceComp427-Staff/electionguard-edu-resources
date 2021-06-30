# ElectionGuard-EDU Resources

This repository contains instructor resources for working with ElectionGuard-EDU. In particular,
you'll see:

- `voting-crypto.key` and `voting-crypto.pdf`: Apple Keynote slide deck (and PDF) that corresponds to an 80-ish minute lecture
  on the "modern cryptography" used by end-to-end cryptographic voting systems.

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
extent that two wildly different programming langauges allow you to write the same thing. As such, your choice of which codebase to
use for this assignment is mostly a function of your students' preparation. If your students know Python well, you might just stick with that. If they know Java well, then Kotlin is relatively easy to learn for a Java programmer. (The Kotlin repository includes an
introductory document to help them.)

This assignment is meant to be done in two weeks, with students working in pairs. The first week is really a warm-up, with exercises that make sure the students understand the provided cryptographic libraries. The second week requires them to understand how to synthesize everything together to achieve the desired system properties.

There are two branches in each repository. `main` provides a complete solution, where the autograder provides the maximum number of points. For contrast, `handout` removes several of the function bodies, leaving behind `TODO` markings instructing the students what to do. They're also expected to implement some property-based unit tests.

When you're preparing your handouts, likely using [GitHub Classroom](https://classroom.github.com/), you would clone the repository, check out the `handout` branch, make any necessary changes to the `README.md` file, and then the scary part. Remove the entire `.git` directory and start over (`git init . ; git add . ; git commit -m 'initial commit'`). Now you've got a repository with only the student view of the code, ready for uploading to GitHub.

Once you've got your Classroom "clone link", you paste it into `handout.tex`, and run `pdflatex handout-python` or `pdflatex handout-kotlin`, as appropriate, to generate the student handout. We're including sample PDFs with non-functional clone links so it's easier for you to read them.

## Autograding

An autograder is provided that measures 10 points for part1 (including one point for having no compiler warnings in Kotlin, or no mypy warnings/errors in Python) and 9 points for part2. The last point is based on some written questions that the student is expected to edit into the `README.md` file, and which would be graded by a human grader. (The student is asked to produce a simple benchmark and comment on the execution time for one core versus a large cluster, hopefully coming to some realization about the real-world costs of this class of algorithm.)


Since the students have the full unit test suite available to them, as well as the autograder, it's not inconceivable that a student might attempt to cheat by modifying the unit tests to always succeed. We instruct our graders to look for this in the students' repositories. Notably, [GitHub has a convenient URL syntax](https://docs.github.com/en/github/committing-changes-to-your-project/viewing-and-comparing-commits/comparing-commits) for looking at the diff between two commits. If the human grader sees changes outside of the usual, they can assess suitable penalties, e.g., treating those unit tests as having failed.

We've included a suitable GitHub Actions configuration to run the autograder on every push to the server. Also of note, the autograder prints out the time and date when it's run. This allows your graders to click through to the autograder output, skim the students' code, and transcribe the numbers into your university's learning management system (LMS).

Make sure your GitHub "organization" has enough quota for the Actions to run ([details](https://education.github.community/t/github-actions-limits-and-github-classroom/57730)).

If you *really* want the autograder's output to go directly to your LMS, the [Python autograder](https://github.com/thoward27/grade) has a function where it can write JSON output that's compatible with GradeScope. The [Java autograder](https://github.com/RiceComp215-Staff/RiceChecks), which works just fine with Kotlin, also writes output in YAML and JSON formats, but not in any format that's understood by GradeScope. Either way, you may be able to rig up some sort of connection between this output and your LMS. Obviously, a system like this would be relatively straightforward for students to defraud, but at least you'd have all the commits, so you could track it down after the fact.

Alternately, [GitHub Classroom understands how to speak the LTI protocol](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/connect-a-learning-management-system-to-github-classroom) to many popular university LMS services, but it (sadly) has a [very limited autograder](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/use-autograding), so we can't just auto-populate it with our unit tests and point weights.
