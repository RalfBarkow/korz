
## Installation

```st
Metacello new
	repository: '';
	baseline: 'Korz';
	load
```

## Examples

Once loaded, evaluate the GT example entry point to explore the slot space used throughout the tests:

```st
KoSlotSpaceExamples exampleSlotMatching inspect
```

The example builds the `rcvr` / `location` / `isColorblind` scenario from the Korz paper and returns the slot bodies that currently match each context (`#australia`, `#colorblindAustralia`, etc.). In Glamorous Toolkit you can also browse it via the Examples browser thanks to the `<gtExample>` annotation.
