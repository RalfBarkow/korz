Class {
	#name : #KoSlotSpaceExamples,
	#superclass : #Object,
	#category : #Korz
}

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addBracketSeesSlotsOn: slotSpace boundaryDimension: boundaryDimension povDimension: povDimension coordinates: coordinates [
	| square round curly angle adjacent symmetric |
	square := coordinates at: #square.
	round := coordinates at: #round.
	curly := coordinates at: #curly.
	angle := coordinates at: #angle.
	adjacent := coordinates at: #povAdjacent.
	symmetric := coordinates at: #povSymmetric.
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: square
		pov: adjacent
		result: #(round curly).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: round
		pov: adjacent
		result: #(curly square).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: curly
		pov: adjacent
		result: #(round angle square).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: angle
		pov: adjacent
		result: #(curly).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: square
		pov: symmetric
		result: #(round curly).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: round
		pov: symmetric
		result: #(curly square).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: curly
		pov: symmetric
		result: #(round angle square).
	self
		addSeesSlotOn: slotSpace
		boundaryDimension: boundaryDimension
		povDimension: povDimension
		boundary: angle
		pov: symmetric
		result: #(curly)
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addCombinerSlotsOn: slotSpace combinerDimension: combinerDimension coordinates: coordinates [
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #stabilize
			dimensionConstraints: (Dictionary newFrom: {
				combinerDimension -> (coordinates at: #meet) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'intersection of candidates' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #stabilize
			dimensionConstraints: (Dictionary newFrom: {
				combinerDimension -> (coordinates at: #quorum) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'accept proposals supported by ≥ 2 POVs' ])
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addDrawPixelSlotsOn: slotSpace dimensions: dimensions coordinates: coordinates [
	| rcvr location vision |
	rcvr := dimensions at: #rcvr.
	location := dimensions at: #location.
	vision := dimensions at: #isColorblind.
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #drawPixel
			dimensionConstraints: (Dictionary newFrom: {
				rcvr -> (coordinates at: #screenParent) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'baseline renderer' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #drawPixel
			dimensionConstraints: (Dictionary newFrom: {
				rcvr -> (coordinates at: #screenParent).
				location -> (coordinates at: #southernHemi) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'southern hemisphere override' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #drawPixel
			dimensionConstraints: (Dictionary newFrom: {
				rcvr -> (coordinates at: #screenParent).
				vision -> (coordinates at: #true) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'colorblind override' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #drawPixel
			dimensionConstraints: (Dictionary newFrom: {
				rcvr -> (coordinates at: #screenParent).
				location -> (coordinates at: #southernHemi).
				vision -> (coordinates at: #true) })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'southern colorblind override' ])
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addPileSlotsOn: slotSpace selectionDimension: selectionDimension coordinates: coordinates [
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #project
			dimensionConstraints: (Dictionary newFrom: {
				selectionDimension -> (coordinates at: #tops) })
			parameterConstraints: nil)
		contents: [ :ctx :args | #(topA topB) ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #project
			dimensionConstraints: (Dictionary newFrom: {
				selectionDimension -> (coordinates at: #all) })
			parameterConstraints: nil)
		contents: [ :ctx :args | #(topA midC baseD) ])
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addProfileSlotOn: slotSpace povDimension: povDimension objectDimension: objectDimension pov: pov object: object result: resultCollection [
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #profile
			dimensionConstraints: (Dictionary newFrom: {
				povDimension -> pov.
				objectDimension -> object })
			parameterConstraints: nil)
		contents: [ :ctx :args | resultCollection ])
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addSeesSlotOn: slotSpace boundaryDimension: boundaryDimension povDimension: povDimension boundary: boundary pov: pov result: resultCollection [
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #sees
			dimensionConstraints: (Dictionary newFrom: {
				boundaryDimension -> boundary.
				povDimension -> pov })
			parameterConstraints: nil)
		contents: [ :ctx :args | resultCollection ])
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> addYonedaSlotsOn: slotSpace povDimension: povDimension objectDimension: objectDimension coordinates: coordinates [
	| povLocal povMeta nodeA nodeB nodeC |
	povLocal := coordinates at: #povLocal.
	povMeta := coordinates at: #povMeta.
	nodeA := coordinates at: #nodeA.
	nodeB := coordinates at: #nodeB.
	nodeC := coordinates at: #nodeC.
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povLocal
		object: nodeA
		result: #(fromB).
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povLocal
		object: nodeB
		result: #(fromC).
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povLocal
		object: nodeC
		result: #(fromB).
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povMeta
		object: nodeA
		result: #(fromAll).
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povMeta
		object: nodeB
		result: #(fromAll).
	self
		addProfileSlotOn: slotSpace
		povDimension: povDimension
		objectDimension: objectDimension
		pov: povMeta
		object: nodeC
		result: #(fromAll)
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> bracketBoundaryCoordinatesFrom: coordinates [
	^ Dictionary newFrom: {
		#square -> (coordinates at: #square).
		#round -> (coordinates at: #round).
		#curly -> (coordinates at: #curly).
		#angle -> (coordinates at: #angle) }
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> bracketSeesScenario [
	| slotSpace boundaryDimension povDimension coords |
	slotSpace := KoSlotSpace new.
	boundaryDimension := slotSpace addDimensionNamed: #boundaryType.
	povDimension := slotSpace addDimensionNamed: #pov.
	coords := Dictionary new.
	coords at: #square put: (slotSpace addCoordinateNamed: #square onDimension: boundaryDimension parent: nil).
	coords at: #round put: (slotSpace addCoordinateNamed: #round onDimension: boundaryDimension parent: nil).
	coords at: #curly put: (slotSpace addCoordinateNamed: #curly onDimension: boundaryDimension parent: nil).
	coords at: #angle put: (slotSpace addCoordinateNamed: #angle onDimension: boundaryDimension parent: nil).
	coords at: #povAdjacent put: (slotSpace addCoordinateNamed: #povAdjacent onDimension: povDimension parent: nil).
	coords at: #povSymmetric put: (slotSpace addCoordinateNamed: #povSymmetric onDimension: povDimension parent: nil).
	self addBracketSeesSlotsOn: slotSpace boundaryDimension: boundaryDimension povDimension: povDimension coordinates: coords.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> (Dictionary newFrom: {
			#boundaryType -> boundaryDimension.
			#pov -> povDimension }).
		#coordinates -> coords }
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> combinerScenario [
	| slotSpace combinerDimension coords |
	slotSpace := KoSlotSpace new.
	combinerDimension := slotSpace addDimensionNamed: #combiner.
	coords := Dictionary new.
	coords at: #meet put: (slotSpace addCoordinateNamed: #meet onDimension: combinerDimension parent: nil).
	coords at: #quorum put: (slotSpace addCoordinateNamed: #quorum onDimension: combinerDimension parent: nil).
	self addCombinerSlotsOn: slotSpace combinerDimension: combinerDimension coordinates: coords.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> (Dictionary newFrom: { #combiner -> combinerDimension }).
		#coordinates -> coords }
]

{ #category : #examples }
KoSlotSpaceExamples class >> exampleBracketSees [
	<gtExample>
	| scenario dims coords slotSpace boundaryDimension povDimension boundaryCoords povs result |
	scenario := self bracketSeesScenario.
	dims := scenario at: #dimensions.
	coords := scenario at: #coordinates.
	slotSpace := scenario at: #slotSpace.
	boundaryDimension := dims at: #boundaryType.
	povDimension := dims at: #pov.
	boundaryCoords := self bracketBoundaryCoordinatesFrom: coords.
	povs := Dictionary newFrom: {
		#adjacent -> (coords at: #povAdjacent).
		#symmetric -> (coords at: #povSymmetric) }.
	result := Dictionary new.
	povs keysAndValuesDo: [ :povLabel :povCoord |
		| perBoundary |
		perBoundary := Dictionary new.
		boundaryCoords keysAndValuesDo: [ :boundaryLabel :boundaryCoord |
			| context |
			context := Dictionary newFrom: {
				boundaryDimension -> boundaryCoord.
				povDimension -> povCoord }.
			perBoundary
				at: boundaryLabel
				put: (self resultsForContext: context slotSpace: slotSpace selector: #sees)
		].
		result at: povLabel put: perBoundary
	].
	^ result
]

{ #category : #examples }
KoSlotSpaceExamples class >> exampleCombinerPolicies [
	<gtExample>
	| scenario dims coords slotSpace combinerDimension |
	scenario := self combinerScenario.
	dims := scenario at: #dimensions.
	coords := scenario at: #coordinates.
	slotSpace := scenario at: #slotSpace.
	combinerDimension := dims at: #combiner.
	^ Dictionary newFrom: {
		#meet -> (self firstResultForContext: (Dictionary newFrom: {
				combinerDimension -> (coords at: #meet) })
			slotSpace: slotSpace
			selector: #stabilize).
		#quorum -> (self firstResultForContext: (Dictionary newFrom: {
				combinerDimension -> (coords at: #quorum) })
			slotSpace: slotSpace
			selector: #stabilize)
	}
]

{ #category : #examples }
KoSlotSpaceExamples class >> examplePileSelection [
	<gtExample>
	| scenario dims coords slotSpace selectionDimension |
	scenario := self pileScenario.
	dims := scenario at: #dimensions.
	coords := scenario at: #coordinates.
	slotSpace := scenario at: #slotSpace.
	selectionDimension := dims at: #selection.
	^ Dictionary newFrom: {
		#tops -> (self resultsForContext: (Dictionary newFrom: {
				selectionDimension -> (coords at: #tops) })
			slotSpace: slotSpace
			selector: #project).
		#all -> (self resultsForContext: (Dictionary newFrom: {
				selectionDimension -> (coords at: #all) })
			slotSpace: slotSpace
			selector: #project)
	}
]

{ #category : #examples }
KoSlotSpaceExamples class >> exampleSlotMatching [
	<gtExample>
	| scenario slotSpace dimensions coordinates contexts results |
	scenario := self screenScenario.
	slotSpace := scenario at: #slotSpace.
	dimensions := scenario at: #dimensions.
	coordinates := scenario at: #coordinates.
	contexts := self screenContextsUsingDimensions: dimensions coordinates: coordinates.
	results := Dictionary new.
	contexts keysAndValuesDo: [ :label :context |
		results at: label put: (self resultsForContext: context slotSpace: slotSpace selector: #drawPixel)
	].
	^ results
]

{ #category : #examples }
KoSlotSpaceExamples class >> exampleYonedaProfiles [
	<gtExample>
	| scenario dims coords slotSpace povDimension objectDimension povs objects result |
	scenario := self yonedaScenario.
	dims := scenario at: #dimensions.
	coords := scenario at: #coordinates.
	slotSpace := scenario at: #slotSpace.
	povDimension := dims at: #pov.
	objectDimension := dims at: #object.
	povs := Dictionary newFrom: {
		#local -> (coords at: #povLocal).
		#meta -> (coords at: #povMeta) }.
	objects := Dictionary newFrom: {
		#nodeA -> (coords at: #nodeA).
		#nodeB -> (coords at: #nodeB).
		#nodeC -> (coords at: #nodeC) }.
	result := Dictionary new.
	povs keysAndValuesDo: [ :povLabel :povCoord |
		| perObject |
		perObject := Dictionary new.
		objects keysAndValuesDo: [ :objectLabel :objectCoord |
			| context profile |
			context := Dictionary newFrom: {
				povDimension -> povCoord.
				objectDimension -> objectCoord }.
			profile := self firstResultForContext: context slotSpace: slotSpace selector: #profile.
			perObject at: objectLabel put: profile
		].
		result at: povLabel put: perObject
	].
	^ result
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> firstResultForContext: context slotSpace: slotSpace selector: selector [
	| results |
	results := self resultsForContext: context slotSpace: slotSpace selector: selector.
	results isEmpty ifTrue: [ ^ nil ].
	^ results first
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> pileScenario [
	| slotSpace selectionDimension coords |
	slotSpace := KoSlotSpace new.
	selectionDimension := slotSpace addDimensionNamed: #selection.
	coords := Dictionary new.
	coords at: #tops put: (slotSpace addCoordinateNamed: #tops onDimension: selectionDimension parent: nil).
	coords at: #all put: (slotSpace addCoordinateNamed: #all onDimension: selectionDimension parent: nil).
	self addPileSlotsOn: slotSpace selectionDimension: selectionDimension coordinates: coords.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> (Dictionary newFrom: { #selection -> selectionDimension }).
		#coordinates -> coords }
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> resultsForContext: context slotSpace: slotSpace selector: selector [
	^ (slotSpace
		matchingSlotsForContext: context
		selector: selector
		arguments: #())
		collect: [ :slot | slot evaluateInContext: context withArguments: #() ]
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> screenContextsUsingDimensions: dimensions coordinates: coordinates [
	| rcvr location vision screen |
	rcvr := dimensions at: #rcvr.
	location := dimensions at: #location.
	vision := dimensions at: #isColorblind.
	screen := coordinates at: #screen.
	^ Dictionary newFrom: {
		#australia -> (Dictionary newFrom: {
			rcvr -> screen.
			location -> (coordinates at: #australia).
			vision -> (coordinates at: #false) }).
		#colorblindAustralia -> (Dictionary newFrom: {
			rcvr -> screen.
			location -> (coordinates at: #australia).
			vision -> (coordinates at: #true) }).
		#antarctica -> (Dictionary newFrom: {
			rcvr -> screen.
			location -> (coordinates at: #antarctica).
			vision -> (coordinates at: #false) }).
		#northern -> (Dictionary newFrom: {
			rcvr -> screen.
			location -> (coordinates at: #northernHemi).
			vision -> (coordinates at: #false) })
	}
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> screenScenario [
	| slotSpace dims coords world southern northern |
	slotSpace := KoSlotSpace new.
	dims := Dictionary new.
	dims at: #rcvr put: (slotSpace addDimensionNamed: #rcvr).
	dims at: #location put: (slotSpace addDimensionNamed: #location).
	dims at: #isColorblind put: (slotSpace addDimensionNamed: #isColorblind).
	world := slotSpace addCoordinateNamed: #world onDimension: (dims at: #location) parent: nil.
	southern := slotSpace addCoordinateNamed: #southernHemi onDimension: (dims at: #location) parent: world.
	northern := slotSpace addCoordinateNamed: #northernHemi onDimension: (dims at: #location) parent: world.
	coords := Dictionary new.
	coords at: #screenParent put: (slotSpace addCoordinateNamed: #screenParent onDimension: (dims at: #rcvr) parent: nil).
	coords at: #screen put: (slotSpace addCoordinateNamed: #screen onDimension: (dims at: #rcvr) parent: (coords at: #screenParent)).
	coords at: #southernHemi put: southern.
	coords at: #northernHemi put: northern.
	coords at: #australia put: (slotSpace addCoordinateNamed: #australia onDimension: (dims at: #location) parent: southern).
	coords at: #antarctica put: (slotSpace addCoordinateNamed: #antarctica onDimension: (dims at: #location) parent: southern).
	coords at: #false put: (slotSpace addCoordinateNamed: #false onDimension: (dims at: #isColorblind) parent: nil).
	coords at: #true put: (slotSpace addCoordinateNamed: #true onDimension: (dims at: #isColorblind) parent: nil).
	self addDrawPixelSlotsOn: slotSpace dimensions: dims coordinates: coords.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> dims.
		#coordinates -> coords }
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> yonedaScenario [
	| slotSpace povDimension objectDimension coords |
	slotSpace := KoSlotSpace new.
	povDimension := slotSpace addDimensionNamed: #pov.
	objectDimension := slotSpace addDimensionNamed: #object.
	coords := Dictionary new.
	coords at: #povLocal put: (slotSpace addCoordinateNamed: #povLocal onDimension: povDimension parent: nil).
	coords at: #povMeta put: (slotSpace addCoordinateNamed: #povMeta onDimension: povDimension parent: nil).
	coords at: #nodeA put: (slotSpace addCoordinateNamed: #nodeA onDimension: objectDimension parent: nil).
	coords at: #nodeB put: (slotSpace addCoordinateNamed: #nodeB onDimension: objectDimension parent: nil).
	coords at: #nodeC put: (slotSpace addCoordinateNamed: #nodeC onDimension: objectDimension parent: nil).
	self addYonedaSlotsOn: slotSpace povDimension: povDimension objectDimension: objectDimension coordinates: coords.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> (Dictionary newFrom: {
			#pov -> povDimension.
			#object -> objectDimension }).
		#coordinates -> coords }
]
