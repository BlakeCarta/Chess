# Chess
Cli chess game from scratch in ruby. Final assignment from the ruby section on The Odin Project.
More details can be found at this Link: https://www.theodinproject.com/lessons/ruby-ruby-final-project

Project is functionally done, but needs significant rewrite for style and proper OOP usage.
However, I feel that i've learned a significant amount about writing programs. 

My takeways:
- This project showed me the importance of not only writing tests, but ensuring the tests were written well. At one point I had errors and because of the poorly written custom matcher that would default to passing the test, I was unaware of these issues.

- My "understanding" of OOP principles was proven to be way worse than I thought. And most of it would break down as the project grew beyond a handfull of files. Around the 1k loc mark progress slowed massively as I had to handle my own spaghetti code. The rewrite helped, but due to laziness alot of my issues came back.

- Spending significant time writing/drawing diagrams to show data/control flow and just overall mock the project has proven mandatory. I should've spent alot more time in this planning phase.

- Testing. While testing has helped alot, doing it properly is something I need to work on. I lost alot of time trying to make these massive tests. In reality I never architected these correctly and now have massive test files that are a pain to use. I need to spend alot of time reading other's code to see how to specifically improve here.