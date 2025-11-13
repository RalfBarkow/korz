Class {
	#name : #KoSlotSpaceTest,
	#superclass : #TestCase,
	#instVars : [
		'slotSpace',
		'rcvr',
		'context'
	],
	#category : #'Korz-Tests'
}

{ #category : #running }
KoSlotSpaceTest >> setUp [
	| parent child |
	super setUp.
	slotSpace := KoSlotSpace new.
	rcvr := slotSpace addDimensionNamed: #rcvr.
	parent := slotSpace addCoordinateNamed: #parent onDimension: rcvr parent: nil.
	child := slotSpace addCoordinateNamed: #child onDimension: rcvr parent: parent.
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #doSomething
			dimensionConstraints: (Dictionary newFrom: { rcvr -> parent })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'general' ]).
	slotSpace addSlot: (KoSlot
		guard: (KoSlotGuard
			selector: #doSomething
			dimensionConstraints: (Dictionary newFrom: { rcvr -> child })
			parameterConstraints: nil)
		contents: [ :ctx :args | 'specific' ]).
	context := Dictionary newFrom: { rcvr -> child }
]

{ #category : #tests }
KoSlotSpaceTest >> testBestSlotsPrefersMoreSpecific [
	| best |
	best := slotSpace bestSlotsForContext: context selector: #doSomething arguments: #().
	self assert: best size equals: 1.
	self assert: (best first evaluateInContext: context withArguments: #()) equals: 'specific'
]

{ #category : #tests }
KoSlotSpaceTest >> testBestSlotsEmptyWhenNoMatch [
	| best |
	best := slotSpace bestSlotsForContext: Dictionary new selector: #unknown arguments: #().
	self assert: best isEmpty
]

{ #category : #tests }
KoSlotSpaceTest >> testParentCoordinateMustBelongToDimension [
	| otherDimension otherCoordinate |
	otherDimension := slotSpace addDimensionNamed: #other.
	otherCoordinate := slotSpace addCoordinateNamed: #otherCoord onDimension: otherDimension parent: nil.
	self
		should: [ slotSpace addCoordinateNamed: #bad onDimension: rcvr parent: otherCoordinate ]
		raise: Error
]
