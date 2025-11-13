Class {
	#name : #KoCoordinateTest,
	#superclass : #TestCase,
	#category : #'Korz-Tests'
}

{ #category : #tests }
KoCoordinateTest >> testAncestorsIncludeSelfAndParentChain [
	| root child grandChild |
	root := KoCoordinate named: #root.
	child := KoCoordinate named: #child parent: root.
	grandChild := KoCoordinate named: #grandChild parent: child.
	self assert: grandChild ancestors first equals: grandChild.
	self assert: grandChild ancestors second equals: child.
	self assert: grandChild ancestors third equals: root
]

{ #category : #tests }
KoCoordinateTest >> testCoordinateOrderUsesParentChain [
	| ancestor descendant |
	ancestor := KoCoordinate named: #ancestor.
	descendant := KoCoordinate named: #descendent parent: ancestor.
	self assert: (descendant <= ancestor).
	self deny: (ancestor <= descendant)
]
