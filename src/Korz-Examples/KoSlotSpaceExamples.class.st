Class {
	#name : #KoSlotSpaceExamples,
	#superclass : #Object,
	#category : #'Korz-Projection-Examples'
}

{ #category : #'examples' }
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
		results at: label put: (self resultsForContext: context slotSpace: slotSpace)
	].
	^ results
]

{ #category : #'private - building' }
KoSlotSpaceExamples class >> resultsForContext: context slotSpace: slotSpace [
	^ (slotSpace
		matchingSlotsForContext: context
		selector: #drawPixel
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
	| slotSpace rcvr location vision screenParent screen world southern northern australia antarctica trueCoord falseCoord |
	slotSpace := KoSlotSpace new.
	rcvr := slotSpace addDimensionNamed: #rcvr.
	location := slotSpace addDimensionNamed: #location.
	vision := slotSpace addDimensionNamed: #isColorblind.
	world := slotSpace addCoordinateNamed: #world onDimension: location parent: nil.
	southern := slotSpace addCoordinateNamed: #southernHemi onDimension: location parent: world.
	northern := slotSpace addCoordinateNamed: #northernHemi onDimension: location parent: world.
	australia := slotSpace addCoordinateNamed: #australia onDimension: location parent: southern.
	antarctica := slotSpace addCoordinateNamed: #antarctica onDimension: location parent: southern.
	screenParent := slotSpace addCoordinateNamed: #screenParent onDimension: rcvr parent: nil.
	screen := slotSpace addCoordinateNamed: #screen onDimension: rcvr parent: screenParent.
	trueCoord := slotSpace addCoordinateNamed: #true onDimension: vision parent: nil.
	falseCoord := slotSpace addCoordinateNamed: #false onDimension: vision parent: nil.
	self addDrawPixelSlotsOn: slotSpace
		dimensions: { #rcvr -> rcvr. #location -> location. #isColorblind -> vision } asDictionary
		coordinates: {
			#screenParent -> screenParent.
			#screen -> screen.
			#southernHemi -> southern.
			#australia -> australia.
			#antarctica -> antarctica.
			#northernHemi -> northern.
			#true -> trueCoord.
			#false -> falseCoord } asDictionary.
	^ Dictionary newFrom: {
		#slotSpace -> slotSpace.
		#dimensions -> (Dictionary newFrom: {
			#rcvr -> rcvr.
			#location -> location.
			#isColorblind -> vision }).
		#coordinates -> (Dictionary newFrom: {
			#screenParent -> screenParent.
			#screen -> screen.
			#southernHemi -> southern.
			#australia -> australia.
			#antarctica -> antarctica.
			#northernHemi -> northern.
			#true -> trueCoord.
			#false -> falseCoord })
	}
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
			dimensionConstraints: (Dictionary newFrom: { rcvr -> (coordinates at: #screenParent) })
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
