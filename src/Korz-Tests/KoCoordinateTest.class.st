Class {
	#name : #KoCoordinateTest,
	#superclass : #TestCase,
	#category : #'Korz-Tests'
}

{ #category : #tests }
KoCoordinateTest >> testAncestorsIncludeParentChain [
	| root child grandChild |
	root := KoCoordinate named: #root.
	child := KoCoordinate named: #child parent: root.
	grandChild := KoCoordinate named: #grandChild parent: child.
	self assert: grandChild ancestors first equals: grandChild.
	self assert: (grandChild ancestors includes: root)
]

{ #category : #tests }
KoCoordinateTest >> testCoordinateOrderUsesParentRelation [
	| parent child |
	parent := KoCoordinate named: #parent.
	child := KoCoordinate named: #child parent: parent.
	self assert: (child <= parent).
	self deny: (parent <= child)
]
