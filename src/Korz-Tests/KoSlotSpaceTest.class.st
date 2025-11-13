Class {
	#name : #KoSlotSpaceTest,
	#superclass : #TestCase,
	#instVars : [
		'slotSpace',
		'rcvrDimension',
		'screenParent',
		'screen'
	],
	#category : #'Korz-Tests'
}

{ #category : #running }
KoSlotSpaceTest >> setUp [
	super setUp.
	slotSpace := KoSlotSpace new.
	rcvrDimension := slotSpace addDimensionNamed: #rcvr.
	screenParent := slotSpace addCoordinateNamed: #screenParent onDimension: rcvrDimension parent: nil.
	screen := slotSpace addCoordinateNamed: #screen onDimension: rcvrDimension parent: screenParent
]

{ #category : #tests }
KoSlotSpaceTest >> testCoordinateRegistrationKeepsDimension [
	self assert: (slotSpace dimensionForCoordinate: screen) equals: rcvrDimension.
	self assert: ((slotSpace coordinatesCollectionFor: rcvrDimension) includes: screenParent)
]

{ #category : #tests }
KoSlotSpaceTest >> testMatchingSlotsFiltersBySelectorAndContext [
	| guard slot context matches |
	guard := KoSlotGuard
		selector: #drawPixel
		dimensionConstraints: (Dictionary newFrom: { rcvrDimension -> screenParent })
		parameterConstraints: nil.
	slot := KoSlot guard: guard contents: [ :ctx :args | #base ].
	slotSpace addSlot: slot.
	context := Dictionary new.
	context at: rcvrDimension put: screen.
	matches := slotSpace matchingSlotsForContext: context selector: #drawPixel arguments: #().
	self assert: matches size equals: 1.
	self assert: matches first equals: slot.
	self assert: (slotSpace matchingSlotsForContext: context selector: #other arguments: #()) isEmpty
]
