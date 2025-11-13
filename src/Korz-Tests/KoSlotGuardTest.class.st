Class {
	#name : #KoSlotGuardTest,
	#superclass : #TestCase,
	#category : #'Korz-Tests'
}

{ #category : #tests }
KoSlotGuardTest >> testMatchesContextAndArguments [
	| dimension coord guard context args |
	dimension := KoDimension named: #rcvr.
	coord := KoCoordinate named: #screenParent.
	guard := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> coord })
		parameterConstraints: { coord }.
	context := Dictionary newFrom: { dimension -> (KoCoordinate named: #screen parent: coord) }.
	args := { coord }.
	self assert: (guard matchesContext: context arguments: args)
]

{ #category : #tests }
KoSlotGuardTest >> testSpecificityOrdering [
	| dimension parent child general specific |
	dimension := KoDimension named: #rcvr.
	parent := KoCoordinate named: #parent.
	child := KoCoordinate named: #child parent: parent.
	general := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> parent })
		parameterConstraints: nil.
	specific := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> child })
		parameterConstraints: nil.
	self assert: (specific isMoreSpecificThan: general).
	self deny: (general isMoreSpecificThan: specific)
]
