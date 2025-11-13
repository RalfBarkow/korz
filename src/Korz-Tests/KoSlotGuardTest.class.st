Class {
	#name : #KoSlotGuardTest,
	#superclass : #TestCase,
	#instVars : [
		'dimension',
		'rootCoordinate',
		'childCoordinate'
	],
	#category : #'Korz-Tests'
}

{ #category : #running }
KoSlotGuardTest >> setUp [
	super setUp.
	dimension := KoDimension named: #rcvr.
	rootCoordinate := KoCoordinate named: #root.
	childCoordinate := KoCoordinate named: #child parent: rootCoordinate
]

{ #category : #tests }
KoSlotGuardTest >> testMatchesContextWhenConstraintSatisfied [
	| guard context |
	guard := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> rootCoordinate })
		parameterConstraints: nil.
	context := Dictionary new.
	context at: dimension put: childCoordinate.
	self assert: (guard matchesContext: context arguments: #()).
	context at: dimension put: KoCoordinate named: #other.
	self deny: (guard matchesContext: context arguments: #())
]

{ #category : #tests }
KoSlotGuardTest >> testMoreSpecificWhenAddsDimensionConstraint [
	| general specific |
	general := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> rootCoordinate })
		parameterConstraints: nil.
	specific := KoSlotGuard
		selector: #draw
		dimensionConstraints: (Dictionary newFrom: { dimension -> childCoordinate })
		parameterConstraints: nil.
	self assert: (specific isMoreSpecificThan: general).
	self deny: (general isMoreSpecificThan: specific)
]

{ #category : #tests }
KoSlotGuardTest >> testParameterConstraintMoreSpecific [
	| otherCoord guardA guardB |
	otherCoord := KoCoordinate named: #other parent: rootCoordinate.
	guardA := KoSlotGuard
		selector: #draw
		dimensionConstraints: Dictionary new
		parameterConstraints: { rootCoordinate }.
	guardB := KoSlotGuard
		selector: #draw
		dimensionConstraints: Dictionary new
		parameterConstraints: { otherCoord }.
	self deny: (guardA isMoreSpecificThan: guardB).
	self deny: (guardB isMoreSpecificThan: guardA).
	guardB := KoSlotGuard
		selector: #draw
		dimensionConstraints: Dictionary new
		parameterConstraints: { childCoordinate }.
	self assert: (guardB isMoreSpecificThan: guardA)
]
